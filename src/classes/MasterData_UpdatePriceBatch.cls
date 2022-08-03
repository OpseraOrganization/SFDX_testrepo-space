/***********************************************************************
*@Class Name: MasterData_UpdatePriceBatch
*@Desription: to update Master Data on a daily basis by processing MasterData Staging records
*@Test Class: MasterData_UpdatePriceBatch_Test
*@Modifiction Log:
 --------------------------------------------------------------------------
  @Author		 Change Description	Date	
------------------------------------------------------------------------------
  Siva Kumar		Created			14/Apr/2021
**************************************************************************/
global without sharing class MasterData_UpdatePriceBatch implements Database.Batchable<sObject>, Database.Stateful{
	//Variables Declaration
	final static String  DIRECT_PRICELIST_FNUSD = Label.Direct_Price_List; //Direct Pricelist FN (USD)

	final static String  FLOOR_PRICING = Label.MasterData_FloorPrice; //Floor Pricing
	final static String  FN_DIRECT_PRICELIST_TYPE = 'FN Direct';
	final static String  FINALIZED= 'Finalized';
	final static String  INDIRECT_MARKET_PRICELISTTYPE = 'Indirect Market';
	final static String  MARKET_DATA= 'Market Price List';
	final static String  USD_CURRENCY= 'USD';
	List<String> marketPricelistlst= Label.MasterData_MarketPriceLists.split(',');	
	List<String> repriceQuoteStages= label.MasterData_RepriceQuoteStages.split(',');
	static Map<Id,product2> mapProductIdToPortfolio ;   
	string batchID = ''; 
	Set<Id> setProcessedPLIs = new Set<Id>();
	Set<String> setProcessedProdExt = new Set<String>();
	
	//start
	global Database.QueryLocator start(Database.BatchableContext BC){
		
		string query = 'SELECT Id, Name, Price__c, Product_Code__c, CreatedDate,createdby.name,Type__c,Stream__c,CurrencyIsoCode FROM CNP_High_Staging__c 	'; 
		return Database.getQueryLocator(query);
	}
	
	//execute method
	global void execute(Database.BatchableContext BC, List<CNP_High_Staging__c> scope){
		batchID = BC.getJobId(); 
		
		// Map to put the Product code vs Price to update on Price List Item
		Map<String,Decimal> mapOfProductCodeAndPrice = new Map<String,Decimal>();
		Map<String, List<String>> mapTypetoProductCode = new Map<String, List<String>>();
		Map<String, List<String>> mapMarketTypetoProductCode = new Map<String, List<String>>();
		Set<String> priceListNameset = new Set<String>();
		Map<String,CNP_High_Staging__c> mapOfProductCodeAndStreamToPrice = new Map<String,CNP_High_Staging__c>();
		Map<String,CNP_High_Staging__c> mapProdCodePriceListToStage = new Map<String,CNP_High_Staging__c>();
		
		for(CNP_High_Staging__c highStaging: scope){
			//map of product code vs price for CNP High
			if(highStaging.Product_Code__c != null && highStaging.Price__c != null){
	mapOfProductCodeAndPrice.put(highStaging.Product_Code__c ,highStaging.Price__c);
			}
			
			
			if(highStaging.Type__c != null && highStaging.Product_Code__c != null){
	if(!mapTypetoProductCode.containsKey(highStaging.Type__c)){
		mapTypetoProductCode.put(highStaging.Type__c, new List<String>());
	}
	mapTypetoProductCode.get(highStaging.Type__c).add(highStaging.Product_Code__c);
			}
			//Floor Pricing
			if(highStaging.Product_Code__c != null  && highStaging.Type__c == FLOOR_PRICING){ 
	
	mapOfProductCodeAndStreamToPrice.put(highStaging.Product_Code__c+'_'+highStaging.Stream__c, highStaging);   
			}
			//MarketData
			if(highStaging.Type__c != null && highStaging.Product_Code__c != null && marketPricelistlst.contains(highStaging.Type__c)){
	string pl_truncatedName = highStaging.Type__c.substringBefore(' (')+'%';
	
	priceListNameset.add(pl_truncatedName);
	if(!mapMarketTypetoProductCode.containsKey(MARKET_DATA)){
		mapMarketTypetoProductCode.put(MARKET_DATA,new List<String>());
	}	
		mapMarketTypetoProductCode.get(MARKET_DATA).add(highStaging.Product_Code__c);
	String pricelist_truncatedName = highStaging.Type__c.substringbefore('(');
	string prodCodePLName = highStaging.Product_Code__c+'_'+pricelist_truncatedName.deleteWhitespace();
	mapProdCodePriceListToStage.put(prodCodePLName, highStaging);   
			}	
		}
	
		
		//processing CNP High
		if(mapTypetoProductCode.containsKey(DIRECT_PRICELIST_FNUSD) && !mapTypetoProductCode.get(DIRECT_PRICELIST_FNUSD).isEmpty()){
			Set<String> setProductCodes = new Set<String>(mapTypetoProductCode.get(DIRECT_PRICELIST_FNUSD));
			processDirectPriceListFN(scope, setProductCodes,mapOfProductCodeAndPrice);
		}
		//processing Floor Pricing
		if(mapTypetoProductCode.containsKey(FLOOR_PRICING) && !mapTypetoProductCode.get(FLOOR_PRICING).isEmpty() ){
			Set<String> setProductCodes = new Set<String>(mapTypetoProductCode.get(FLOOR_PRICING));
			
			processFloorPriceType(scope, setProductCodes, mapOfProductCodeAndStreamToPrice); 
		}
		 //marketData
		if(mapMarketTypetoProductCode.containsKey(MARKET_DATA) && !mapMarketTypetoProductCode.get(MARKET_DATA).isEmpty() ){
			Set<String> setProductCodes = new Set<String>(mapMarketTypetoProductCode.get(MARKET_DATA));
			
			processMarketData(scope, setProductCodes, mapProdCodePriceListToStage,priceListNameset); 
		}		
	 
	
		
		/**Delete Staging data*/
		if(!scope.isEmpty()){
			delete scope;
		}
		
	}
	//finish method
	global void finish(Database.BatchableContext BC){
		 
	
		//update quotes with NeedsReprice = true for floor pricing
		if(!setProcessedProdExt.isEmpty())
		rePriceQuotesFloorPricing(setProcessedProdExt);
		
		//insert QuoteReprice for repricing Direct Pricelist FN USD and Market PriceList Quotes
		if(!setProcessedPLIs.isEmpty())
	insertQuoteReprice(setProcessedPLIs);
	}
	
	/******************************************
	 *@Method:	 processDirectPriceListFN
	 *@Desription: Method to handle 'Direct PriceList FN(USD)' Type Staging records
	 *@Param:	  Scope (Staging records), setProductCodes, mapOfProductCodeAndPrice
	 *****************************************/
	private void processDirectPriceListFN(List<CNP_High_Staging__c> scope, Set<String> setProductCodes, Map<String,Decimal> mapOfProductCodeAndPrice){
		Set<string> prodCodesWihtPLI = new Set<String>();
		List<Apttus_Config2__PriceListItem__c> priceListItemToUpsert = new List<Apttus_Config2__PriceListItem__c>();
		Map<String, List<Apttus_Config2__PriceListItem__c>> mapOldProductToPLI = new Map<String, List<Apttus_Config2__PriceListItem__c>>();
		Map<String, List<Apttus_Config2__PriceListItem__c>> mapNewProductToPLI = new Map<String, List<Apttus_Config2__PriceListItem__c>>();

			/*****************Handling PLI Updation****************/

		updateExistingPLI(setProductCodes,mapOfProductCodeAndPrice,prodCodesWihtPLI,mapOldProductToPLI,priceListItemToUpsert);
   
			/*****************Handling New PLI Insertion****************/
		
		//get productCodesToProducts without PLI
		Map<String, List<Product2>> productWithoutPriceListItemMap = getProductsMap(setProductCodes, prodCodesWihtPLI);
	 
		//get all old and new PLIs to Insert/Upsert
		getPLIsToUpsert(productWithoutPriceListItemMap,mapOfProductCodeAndPrice,priceListItemToUpsert,mapNewProductToPLI);
	 
		//upsert PriceListItem
		if(!priceListItemToUpsert.isEmpty()){
			upsertPLIs(priceListItemToUpsert);
			
		}
		
		/********Processing Table record Insertion - CNP HIGH***********************/

		insertProcessingTableRecords(scope, mapNewProductToPLI, mapOldProductToPLI,null,null,DIRECT_PRICELIST_FNUSD);

	}
	/******************************************
	 *@Method:	 processFloorPriceType
	 *@Desription: Method to handle 'Floor Pricing' Type Staging records
	 *@Param:	  Scope (Staging records), setProductCodes, mapProdCodeStreamToStage
	 *****************************************/

	private void processFloorPriceType(List<CNP_High_Staging__c> scope, Set<String> setProductCodes, Map<String,CNP_High_Staging__c> mapProdCodeStreamToStage){//AND Stream__c IN:setStream
		//collections initialization
		Set<string> prodCodesWithProductExtension = new Set<String>();
		List<Product_Extension__c> productExtensionToUpsert = new List<Product_Extension__c>();
		Map<String, List<Product_Extension__c>> mapOldProductToProductExtension = new Map<String, List<Product_Extension__c>>();
		Map<String, List<Product_Extension__c>> mapNewProductToProductExtension = new Map<String, List<Product_Extension__c>>();
  
	/*****************Handling Product Extension Updation****************/ 
		
		updateExistingProdExt(setProductCodes,mapProdCodeStreamToStage,prodCodesWithProductExtension,mapOldProductToProductExtension,productExtensionToUpsert);
		
	/*****************Handling Product Extension Insertion****************/ 
		
		//get productCodesToProducts without ProdExtension
		Map<String,List<Product2>> productWithoutProductExtMap = getProdWithoutProdExt(setProductCodes,prodCodesWithProductExtension,mapProdCodeStreamToStage);
		
		//get all old and new Product Extension records to Insert/Update
		getProdExtToUpsert(mapProdCodeStreamToStage,productWithoutProductExtMap,productExtensionToUpsert,mapNewProductToProductExtension);
		
		//upsert product extension
		if(!productExtensionToUpsert.isEmpty())
			upsertProdExt(productExtensionToUpsert);
	
				/********Processing Table Insertion - Floor Pricing***********************/	 
		//insert Processing records for Floor Price
		insertProcessingTableRecords(scope, null ,null , mapNewProductToProductExtension, mapOldProductToProductExtension,FLOOR_PRICING);

	}
	/******************************************
	 *@Method:	 processMarketData
	 *@Desription: Method to handle 'Market Data'(Partners) Type Staging records
	 *@Param:	  Scope (Staging records), setProductCodes, mapProdCodePriceListToStage
	 *****************************************/	
	private void processMarketData(List<CNP_High_Staging__c> scope, Set<String> setProductCodes, Map<String,CNP_High_Staging__c> mapProdCodePriceListToStage,Set<String> priceListNameset){
		//collections initialization
		Set<string> prodCodesWihtPLI = new Set<String>();
		List<Apttus_Config2__PriceListItem__c> priceListItemToUpsert = new List<Apttus_Config2__PriceListItem__c>();
		Map<String, List<Apttus_Config2__PriceListItem__c>> mapOldProductToPLI = new Map<String, List<Apttus_Config2__PriceListItem__c>>();
		Map<String, List<Apttus_Config2__PriceListItem__c>> mapNewProductToPLI = new Map<String, List<Apttus_Config2__PriceListItem__c>>();
		mapProductIdToPortfolio = new Map<Id,product2>([select Id,Portfolio__c from product2 where ProductCode IN:setProductCodes ]); 
		
	/*****************Handling Market Data PLI Updation****************/
		updateExistingPLIMarketData(setProductCodes,mapProdCodePriceListToStage,prodCodesWihtPLI,mapOldProductToPLI,priceListItemToUpsert,priceListNameset);
		
		//upsert PriceListItem
		if(!priceListItemToUpsert.isEmpty())
			upsertPLIs(priceListItemToUpsert);
		
				/********Processing Table Insertion - Market Data***********************/  
		insertProcessingTableRecords(scope, mapNewProductToPLI, mapOldProductToPLI,null,null,MARKET_DATA);
		
	}
	
	/******************************************
	 *@Method:	 insertProcessingTableRecords
	 *@Desription: Common Method for Processing Table record insertion
	 *@Param:	  Scope (Staging records), mapNewProductToPLI, mapOldProductToPLI,mapNewProductToProductExtension,mapOldProductToProductExtension
	 *****************************************/	
	private void insertProcessingTableRecords(List<CNP_High_Staging__c> scope, Map<String, List<Apttus_Config2__PriceListItem__c>> mapNewProductToPLI,
			 Map<String, List<Apttus_Config2__PriceListItem__c>> mapOldProductToPLI, 
				Map<String,List<Product_Extension__c>> mapNewProductToProductExtension, 
					Map<String, List<Product_Extension__c>> mapOldProductToProductExtension, String type){
		
			
		List<CNP_High_ProcessingTable__c> lstProcessing = new List<CNP_High_ProcessingTable__c>();
   
		// Iterate the Staging records
		for(CNP_High_Staging__c highStaging: scope){
			//Insert Processing Table records for CNP High
			if(type == DIRECT_PRICELIST_FNUSD && highStaging.Type__c == DIRECT_PRICELIST_FNUSD){
	List<CNP_High_ProcessingTable__c> lstProcessing1 = processingTableRecsCNP( highStaging, mapNewProductToPLI, mapOldProductToPLI);
	if(lstProcessing1 != null && !lstProcessing1.isEmpty()){
		lstProcessing.addAll(lstProcessing1);
	}   
			}
			//Insert Processing Table records for Floor Pricing
			if(type == FLOOR_PRICING && highStaging.Type__c == FLOOR_PRICING){
	List<CNP_High_ProcessingTable__c> lstProcessing2 = processingTableRecsForFloor( highStaging,mapNewProductToProductExtension, mapOldProductToProductExtension);
	if(lstProcessing2 != null && !lstProcessing2.isEmpty()){
		lstProcessing.addAll(lstProcessing2);
	}
			}
			//Insert Processing Table records for Market Data
			if(type == MARKET_DATA  && marketPricelistlst.contains(highStaging.Type__c)){
		
	List<CNP_High_ProcessingTable__c> lstProcessing3 = processingTableRecsForMarketData( highStaging, mapNewProductToPLI, mapOldProductToPLI);
	if(lstProcessing3 != null && !lstProcessing3.isEmpty()){
		lstProcessing.addAll(lstProcessing3);
	}
			}			
		}
		
		if(!lstProcessing.isEmpty())
			insert lstProcessing;
		
	}
	  /***************************Utility Methods *******************************/
	private  List<CNP_High_ProcessingTable__c> processingTableRecsCNP( CNP_High_Staging__c highStaging,Map<String, List<Apttus_Config2__PriceListItem__c>> mapNewProductToPLI,Map<String, List<Apttus_Config2__PriceListItem__c>> mapOldProductToPLI){
		
		List<CNP_High_ProcessingTable__c> lstProcessing = new List<CNP_High_ProcessingTable__c>();
		
		if( mapNewProductToPLI.containskey(highStaging.Product_Code__c)){
			for(Apttus_Config2__PriceListItem__c priceLI : mapNewProductToPLI.get(highStaging.Product_Code__c)){
				
				CNP_High_ProcessingTable__c processingTable = getProcessingForPLI(highStaging,priceLI,'INSERT');
				
				lstProcessing.add(processingTable);
			}
		}	
		if(mapOldProductToPLI.containskey(highStaging.Product_Code__c)){
			for(Apttus_Config2__PriceListItem__c priceLI : mapOldProductToPLI.get(highStaging.Product_Code__c)){
				
				CNP_High_ProcessingTable__c processingTable = getProcessingForPLI(highStaging,priceLI,'UPDATE');
				lstProcessing.add(processingTable);
			}
		}
		if(!mapNewProductToPLI.containskey(highStaging.Product_Code__c) && !mapOldProductToPLI.containskey(highStaging.Product_Code__c)){
			
			CNP_High_ProcessingTable__c processingTable = getProcessingForPLI(highStaging,NULL,NULL);
			
			lstProcessing.add(processingTable);
		}
		return lstProcessing;
	}
	
	//Get processing records to insert for Floor Pricing
	private List<CNP_High_ProcessingTable__c> processingTableRecsForFloor( CNP_High_Staging__c highStaging,Map<String, List<Product_Extension__c>> mapNewProductToProductExtension,
																		  Map<String, List<Product_Extension__c>> mapOldProductToProductExtension){
		List<CNP_High_ProcessingTable__c> lstProcessing = new List<CNP_High_ProcessingTable__c>();
		
		 String code_stream = highStaging.Product_Code__c+'_'+highStaging.Stream__c;
		if(mapNewProductToProductExtension.containskey(code_stream)){
			for(Product_Extension__c prodExt : mapNewProductToProductExtension.get(code_stream)){
				CNP_High_ProcessingTable__c processingTable = getProcessingForProdExt(highStaging, prodExt,'INSERT');
				
				lstProcessing.add(processingTable);
			}
		}
		if(mapOldProductToProductExtension.containskey(code_stream)){
			for(Product_Extension__c prodExt : mapOldProductToProductExtension.get(code_stream)){
				CNP_High_ProcessingTable__c processingTable = getProcessingForProdExt(highStaging, prodExt,'UPDATE');
				lstProcessing.add(processingTable);
			}
		}
		if (!mapNewProductToProductExtension.containskey(code_stream) && !mapOldProductToProductExtension.containskey(code_stream)){
			CNP_High_ProcessingTable__c processingTable = getProcessingForProdExt(highStaging, NULL,NULL);
			lstProcessing.add(processingTable);
		}
		return lstProcessing;
	}

	/*******************************
	 * Method Name: processingTableRecsForMarketData
	 * Description: For MarketData, to update existing PriceListItems List price with new Price.
	 * *********************************/ 
	private List<CNP_High_ProcessingTable__c> processingTableRecsForMarketData( CNP_High_Staging__c highStaging,Map<String, List<Apttus_Config2__PriceListItem__c>> mapNewProductToPLI,
							Map<String, List<Apttus_Config2__PriceListItem__c>> mapOldProductToPLI){
		List<CNP_High_ProcessingTable__c> lstProcessing = new List<CNP_High_ProcessingTable__c>();
						
		string pricelist_truncatedName = highStaging.Type__c.substringbefore('(');
		string prodCodePLName = highStaging.Product_Code__c+'_'+pricelist_truncatedName.deleteWhitespace();						
		if(mapNewProductToPLI.containskey(prodCodePLName)){
			for(Apttus_Config2__PriceListItem__c priceLI : mapNewProductToPLI.get(prodCodePLName)){
	CNP_High_ProcessingTable__c processingTable = getProcessingForPLI(highStaging,priceLI,'INSERT');
	
	lstProcessing.add(processingTable);
			}
		}else if(mapOldProductToPLI.containskey(prodCodePLName)){
			for(Apttus_Config2__PriceListItem__c priceLI : mapOldProductToPLI.get(prodCodePLName)){
	CNP_High_ProcessingTable__c processingTable = getProcessingForPLI(highStaging,priceLI,'UPDATE');
	lstProcessing.add(processingTable);
			}
		}else{
			CNP_High_ProcessingTable__c processingTable = getProcessingForPLI(highStaging,NULL,NULL);
			lstProcessing.add(processingTable);
		}
		return lstProcessing;
	}	
	//Get processing records to insert for CNP High, Market Data
	private CNP_High_ProcessingTable__c getProcessingForPLI(CNP_High_Staging__c highStaging,Apttus_Config2__PriceListItem__c priceLI,String dml){
			CNP_High_ProcessingTable__c processingTable = new CNP_High_ProcessingTable__c();
			processingTable.Batch_Id__c = string.valueof(batchID);
			processingTable.Type__c = highStaging.Type__c;
			//if target PLI's currency =  USD
			if(priceLI != null && priceLI.currencyISOCode == 'USD'){
	processingTable.New_List_Price__c = string.valueof(highStaging.Price__c);
			}
			//if target PLI's currency =  EUR, convert and populate list price
			else if(priceLI != null && marketPricelistlst.contains(highStaging.Type__c) && priceLI.currencyISOCode == 'EUR' && mapProductIdToPortfolio.containskey(priceLI.Apttus_Config2__ProductId__c) ){
	
	Map<string,Decimal> portfolioToConversionRateMap =  getconversionRateMap();  
	
	string portfolio = mapProductIdToPortfolio.get(priceLI.Apttus_Config2__ProductId__c).Portfolio__c;
	if(portfolio  != null && portfolioToConversionRateMap.containsKey(portfolio))
	{
		Decimal stagePrice = highStaging.Price__c;
		Decimal newListprice = (portfolioToConversionRateMap.get(portfolio)*stagePrice).setscale(2);		
		processingTable.New_List_Price__c  = String.valueof(newListprice);		
	}	
			}
			//if productCode doesn't exists		
			else{
	processingTable.New_List_Price__c  = string.valueof(highStaging.Price__c);
			}
			
			processingTable.Product_Code__c = highStaging.Product_Code__c;
			processingTable.Source_Price__c = string.valueof(highStaging.Price__c);
			processingTable.Source_Currency__c = highStaging.CurrencyIsoCode;
			//processing record for newly inserted PLIs
			if(dml == 'INSERT'){
	processingTable.Error_Message__c = 'New PriceListItem created '; 
	if(highStaging.Type__c==DIRECT_PRICELIST_FNUSD)
		processingTable.Object_Currency__c = 'USD';
	else
	processingTable.Object_Currency__c =priceLI.CurrencyIsoCode;	
			}
			//processing record for updated PLIs
			if(dml == 'UPDATE'){
	Decimal oldListPrice = (priceLI.Apttus_Config2__ListPrice__c).setscale(2);
	processingTable.Old_List_Price__c = string.valueof(oldListPrice); 
	processingTable.Error_Message__c = 'PriceListItem Updated Successfully ';  
	processingTable.Object_Currency__c =priceLI.CurrencyIsoCode;
	
			}   
			
			processingTable.Processed_Date_Time__c = system.now();
			
			processingTable.Staging_Created_By__c = highStaging.createdby.name;
			processingTable.Staging_Created_Date__c = Date.valueof(highStaging.createdDate);
			if(dml != null){
	processingTable.Status__c = 'Processed';
	processingTable.Price_List_Item__c = priceLI.Id;
			}
			
			//if Product doesn't exist for given productcode in staging
			else{
	processingTable.Status__c = 'Failed';
	processingTable.Error_Message__c = 'Product Not Found ';
	
			}	
			
			processingTable.CurrencyIsoCode = highStaging.CurrencyIsoCode;
			return processingTable;
	}
	
	//Get Product Extension records to insert for Floor Pricing
	private CNP_High_ProcessingTable__c getProcessingForProdExt(CNP_High_Staging__c highStaging,Product_Extension__c prodExt,String dml){
		CNP_High_ProcessingTable__c processingTable = new CNP_High_ProcessingTable__c();
			processingTable.Batch_Id__c = batchID;
			processingTable.Type__c = highStaging.Type__c;		
			processingTable.Product_Code__c = highStaging.Product_Code__c;
			processingTable.New_List_Price__c = string.valueof(highStaging.Price__c);
			processingTable.Source_Price__c = string.valueof(highStaging.Price__c);
			processingTable.Source_Stream__c = String.valueof(highStaging.Stream__c);
			processingTable.Source_Currency__c = highStaging.CurrencyIsoCode;
			
			if(dml == 'INSERT'){
	processingTable.Error_Message__c = 'New ProductExtension created '; //insert/update/null
	processingTable.Object_Currency__c =prodExt.CurrencyIsoCode;
			}
			if(dml == 'UPDATE'){
	processingTable.Old_List_Price__c = string.valueof(prodExt.Floor_Price__c); //update
	processingTable.Error_Message__c = 'ProductExtension Updated Successfully ';	
	processingTable.Object_Currency__c =prodExt.CurrencyIsoCode;
	
			}   

			processingTable.Processed_Date_Time__c = system.now();
			processingTable.CurrencyIsoCode = 'USD';
			processingTable.Staging_Created_By__c = highStaging.createdby.name;
			processingTable.Staging_Created_Date__c = Date.valueof(highStaging.createdDate);
			if(dml != null){
	processingTable.Status__c = 'Processed';
	processingTable.Product_Extension__c = prodExt.Id;
			}
			else{
	processingTable.Status__c = 'Failed';
	processingTable.Error_Message__c = 'Product Not Found ';
	
			}	
	
			return processingTable;
	}
	
	
	private Apttus_Config2__PriceListItem__c getPLI(Id productId, Id priceListId, Decimal listPrice){
		Apttus_Config2__PriceListItem__c pli = new Apttus_Config2__PriceListItem__c();
		pli.Apttus_Config2__ProductId__c = productId;
		pli.Apttus_Config2__PriceListId__c = priceListId;//type1
		pli.Apttus_Config2__ChargeType__c = 'Standard Price';
		pli.Apttus_Config2__PriceType__c = 'One Time';
		pli.Apttus_Config2__ListPrice__c = listPrice;
		return pli;
	}
	private Product_Extension__c getProductExtension(Id productId,Decimal listPrice, String stream){
		Product_Extension__c proExt = new Product_Extension__c();
		proExt.Product__c = productId;
		proExt.Floor_Price__c = listPrice;
		proExt.Stream__c = stream;
		proExt.CurrencyISOCode = 'USD';
		return proExt;
	}
	//Get map of Product Codes with no  correponsding existing PLI records
	private Map<String, List<Product2>> getProductsMap(Set<String> setProductCodesAll, Set<String> prodCodesWihtPLI){
		Map<String, List<Product2>> productCodeToProdMap = new Map<String, List<Product2>>();
		Map<String, List<Product2>> mapProductCodesWithoutPLIs = new Map<String, List<Product2>>();
		Map<String,Product2> productMap = new Map<String,Product2>();
		set<string> setMissingProdCodeID = new set<string>();

		//get map of productCode to Products
		for(product2 prod : [SELECT Id,ProductCode from product2 where ProductCode IN: setProductCodesAll]){
			productMap.put(prod.Id,prod);
			if(!productCodeToProdMap.containsKey(prod.ProductCode)){
				productCodeToProdMap.put(prod.ProductCode,new List<Product2>{});
			}
			productCodeToProdMap.get(prod.ProductCode).add(Prod);
		}

		//get missing productsWithoutPLI using productCode&productId combination 
		for(string prdcode: setProductCodesAll){	 
			if(productCodeToProdMap.containsKey(prdcode)) {
				for(Product2 prd:productCodeToProdMap.get(prdcode))
					setMissingProdCodeID.add(prdcode+'_'+prd.Id);
			}
		}
		//get map of prodCode To productswithoutPLIs
		for(String codePrdID : setMissingProdCodeID){
			string code = codePrdID.substringBefore('_');
			string prodID = codePrdID.substringAfter('_');
			
			if(!prodCodesWihtPLI.contains(codePrdID) && productMap.containskey(prodID)){
				
				if(!mapProductCodesWithoutPLIs.containskey(code)){
				mapProductCodesWithoutPLIs.put(code,new List<Product2>());
				}
				mapProductCodesWithoutPLIs.get(code).add(productMap.get(prodID));
			}

		}

		return mapProductCodesWithoutPLIs;
	}
	
	/*********************Insert/Update Price List item records*********************************/
	private void upsertPLIs(List<Apttus_Config2__PriceListItem__c> priceListItemToUpsert){
		Database.UpsertResult[] uResults = Database.upsert(priceListItemToUpsert, false);
		for(Database.UpsertResult result : uResults){
			if(result.isSuccess()){
	setProcessedPLIs.add(result.getId());
			}
		}
	}	

	/*********************Insert/Update Product Extension records*********************************/
	
	private void upsertProdExt(List<Product_Extension__c> prodExtToUpsert){
		Database.UpsertResult[] uResults = Database.upsert(prodExtToUpsert, false);
		for(Database.UpsertResult result : uResults){
			if(result.isSuccess()){
	setProcessedProdExt.add(result.getId());
			}
		}
	}	
	
	/******************
	 * Method Name: getPLIsToUpsert
	 * Description: to create new Price List Item records if they don't exist for a given product code for CNP High.
	 * *****************/
	private void getPLIsToUpsert(Map<String, List<Product2>> productWithoutPLIMap,
		 Map<String,Decimal> mapOfProductCodeAndPrice,
		 List<Apttus_Config2__PriceListItem__c> priceListItemToUpsert,
		 Map<String, List<Apttus_Config2__PriceListItem__c>> mapNewProductToPLI){
 
		Apttus_Config2__PriceList__c pl = [select Id,Name FROM Apttus_Config2__PriceList__c where Name =:DIRECT_PRICELIST_FNUSD];
		for(String str : productWithoutPLIMap.keyset()){
			for(Product2 prod:productWithoutPLIMap.get(str)){
	if(mapOfProductCodeAndPrice.containskey(str) && pl != null){
		Apttus_Config2__PriceListItem__c pli = getPLI(prod.Id, pl.Id, mapOfProductCodeAndPrice.get(str));
		priceListItemToUpsert.add(pli);
		//populate map of product code vs new PLI price
		if(!mapNewProductToPLI.containsKey(str)){
			mapNewProductToPLI.put(str, new List<Apttus_Config2__PriceListItem__c>());
		}
		mapNewProductToPLI.get(str).add(pli);
	}
			}	
		}
	}
	/******************
	 * Method Name: getProdExtToUpsert
	 * Description: to create new Product Extension records if they don't exist for a given product code for Floor Pricing Type.
	 * *****************/	
   private void getProdExtToUpsert(Map<String, CNP_High_Staging__c> mapProdCodeStreamToStage,
		 Map<String, List<Product2>> productWithoutProductExtMap,
		 List<Product_Extension__c> productExtensionToUpsert,
		 Map<String, List<Product_Extension__c>> mapNewProductCodeStreamToProdExt){
		
		if(!productWithoutProductExtMap.isEmpty()){
			for(String str : mapProdCodeStreamToStage.keySet()){
	if(productWithoutProductExtMap.containsKey(str)){
		for(product2 prd:productWithoutProductExtMap.get(str)){

			Product_Extension__c proExt = getProductExtension(prd.Id, mapProdCodeStreamToStage.get(str).Price__c,mapProdCodeStreamToStage.get(str).Stream__c);
			
			productExtensionToUpsert.add(proExt);
			
			//populate map of product code vs new Product extension price
			if(!mapNewProductCodeStreamToProdExt.containsKey(str)){
				mapNewProductCodeStreamToProdExt.put(str, new List<Product_Extension__c>());
			}
			mapNewProductCodeStreamToProdExt.get(str).add(proExt);
		}
	}	
	
			}
		}
	 }
	//To get Map of Product codes with no Product Extension records in the system - for Floor Pricing
	private Map<String, List<Product2>> getProdWithoutProdExt(Set<String> setProductCodes, Set<string> prodCodesWithProductExtension, Map<String,CNP_High_Staging__c> mapProdCodeStreamToStage){
		set<String> setProdCodeStreamId = new set<String>();
		Map<string,Product2> productMap = new Map<string,Product2>();
		Map<String, List<Product2>> mapCodeToProducts = new Map<String, List<Product2>>();
		Map<String, List<Product2>> productWithoutProductExtMap = new Map<String, List<Product2>>();
		
		//map of prodcode to Products
		for(Product2 prod : [Select Id,productCode from Product2 WHERE productcode IN: setProductCodes]){ //need a check AB_qtc@p2
				productMap.put(prod.Id,prod);
				if(!mapCodeToProducts.containskey(prod.ProductCode)){
					mapCodeToProducts.put(prod.ProductCode, new List<Product2>());
				}
				mapCodeToProducts.get(prod.ProductCode).add(prod);
		}
		//get set of Productcode-stream-ProdId combinations with out ProductExtensions but with Products in system
		for(string codeStream: mapProdCodeStreamToStage.keyset()){
			string code = codeStream.substringBefore('_');
			if(mapCodeToProducts.containskey(code)){
				for(Product2 prod: mapCodeToProducts.get(code)){
					setProdCodeStreamId.add(codeStream+'@'+prod.Id);					
				}
			}
		}
		//get map of product Code to Products without Product Extensions
		for(string codeStreamProdID: setProdCodeStreamId){
			string prodId = codeStreamProdID.substringAfter('@');
			string code_Stream = codeStreamProdID.substringBefore('@');

			if(!prodCodesWithProductExtension.contains(codeStreamProdID) && productMap.containsKey(prodId) ){

				if(!productWithoutProductExtMap.containsKey(code_Stream)){
					productWithoutProductExtMap.put(code_Stream,new List<Product2>() );
				}
				productWithoutProductExtMap.get(code_Stream).add(productMap.get(prodId));

			}
		}

		return productWithoutProductExtMap;
	}	
	/******************
	 * Method Name: rePriceQuotesFloorPricing
	 * Description: For floor pricing, to reprice those quotes that have line items with Floor pricing updated.
	 * *****************/		
	private  void rePriceQuotesFloorPricing(set<String> prodExtIDs){
		List<Apttus_Proposal__Proposal__c> lstQuotesToUpdate = new List<Apttus_Proposal__Proposal__c>();
		Set<Id> setQuoteIds = new Set<Id>();
		Set<String> prodIdset = new Set<String>();
		
		for (Product_Extension__c pEObj:[select id,product__r.productCode from Product_Extension__c where ID IN:prodExtIDs ]){
			prodIdset.add(pEObj.product__c);  
		}
		
		for(Apttus_Config2__LineItem__c lineItem : [Select Id,Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c, Apttus_Config2__ConfigurationId__r.Apttus_Config2__FinalizedDate__c, 
				Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,
				Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c 
													from Apttus_Config2__LineItem__c  
				WHERE Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c =: FINALIZED
				AND Apttus_Config2__ConfigurationId__r.Apttus_Config2__FinalizedDate__c != null 
				AND Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c
				IN: repriceQuoteStages AND Apttus_Config2__ProductId__c IN:prodIdset AND Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.NokiaCPQ_Needs_Reprice__c	= FALSE]){
	if(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c != null){
	 setQuoteIds.add(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c);
	  }
		 }	  
		system.debug('setQuoteIds>>>'+setQuoteIds);
		if(!setQuoteIds.isEmpty()){
			for(Id quoteId : setQuoteIds){
	Apttus_Proposal__Proposal__c quote = new Apttus_Proposal__Proposal__c(Id = quoteId);
	quote.NokiaCPQ_Needs_Reprice__c = true;
	lstQuotesToUpdate.add(quote);
			}
		}
		
		if(!lstQuotesToUpdate.isEmpty())
			update lstQuotesToUpdate;
	}
	
	/******************
	 * Method Name: insertQuoteReprice
	 * Description: For CNP High & Market Data, insert quote Reprice record to reprice those quotes that have PLIs List Price updated.
	 * *****************/	
	private void insertQuoteReprice(Set<Id> setProcessedPLIs){
		List<Quote_Reprice__c> repriceList = new List<Quote_Reprice__c>();
		Set<Id> setPriceListIds = new Set<Id>();
		
		if(!setProcessedPLIs.isEmpty()){
			for(Apttus_Config2__PriceListItem__c pli : [Select Id,Apttus_Config2__PriceListId__c from Apttus_Config2__PriceListItem__c where id in:setProcessedPLIs]){
	setPriceListIds.add(pli.Apttus_Config2__PriceListId__c);
			}
		}		 
		system.debug('setPriceListIds>>'+setPriceListIds);
		if(!setPriceListIds.isEmpty()){
			for(Id plId : setPriceListIds){
	Quote_Reprice__c quoteRepriceObj = new Quote_Reprice__c();
	quoteRepriceObj.Price_List__c = plId;
	quoteRepriceObj.recordTypeId =  Schema.SObjectType.Quote_Reprice__c.getRecordTypeInfosByDeveloperName().get('Price_List').getRecordTypeId();
	repriceList.add(quoteRepriceObj);
			} 
		}

		if(!repriceList.isEmpty())
			insert repriceList;		
	}
	/******************
	 * Method Name: updateExistingPLI
	 * Description: For CNP High, to update existing PLIs List Price.
	 * *****************/	 
	private void updateExistingPLI(Set<String> setProductCodes,
									Map<String,Decimal> mapOfProductCodeAndPrice,
									 Set<string> prodCodesWihtPLI,
									  Map<String, List<Apttus_Config2__PriceListItem__c>> mapOldProductToPLI,
									   List<Apttus_Config2__PriceListItem__c> priceListItemToUpsert){
		for(Apttus_Config2__PriceListItem__c priclistitem : [SELECT Id,Apttus_Config2__ListPrice__c,Apttus_Config2__ProductCode__c,CurrencyIsoCode,Apttus_Config2__ProductId__c 
															 	FROM Apttus_Config2__PriceListItem__c 
																WHERE Apttus_Config2__ProductCode__c IN : setProductCodes 
															 	AND Apttus_Config2__PriceListId__r.Name =: DIRECT_PRICELIST_FNUSD
																AND Apttus_Config2__PriceListId__r.PriceList_Type__c=: FN_DIRECT_PRICELIST_TYPE 
																AND Apttus_Config2__Active__c = TRUE]){
			//if PLI exists
			if(mapOfProductCodeAndPrice.containsKey(priclistitem.Apttus_Config2__ProductCode__c)){
				prodCodesWihtPLI.add(priclistitem.Apttus_Config2__ProductCode__c+'_'+priclistitem.Apttus_Config2__ProductId__c);
				//populate the map of product code vs old PLI price
				if(!mapOldProductToPLI.containsKey(priclistitem.Apttus_Config2__ProductCode__c)){
					mapOldProductToPLI.put(priclistitem.Apttus_Config2__ProductCode__c, new List<Apttus_Config2__PriceListItem__c>());
				}
				Apttus_Config2__PriceListItem__c priclistitemClone = new Apttus_Config2__PriceListItem__c(Id = priclistitem.Id, Apttus_Config2__ListPrice__c = priclistitem.Apttus_Config2__ListPrice__c,CurrencyIsoCode =priclistitem.CurrencyIsoCode );
				mapOldProductToPLI.get(priclistitem.Apttus_Config2__ProductCode__c).add(priclistitemClone);

				//update new value
				priclistitem.Apttus_Config2__ListPrice__c = mapOfProductCodeAndPrice.get(priclistitem.Apttus_Config2__ProductCode__c);
				priceListItemToUpsert.add(priclistitem);
			}
		}
	}
	/******************
	 * Method Name: updateExistingProdExt
	 * Description: For Floor Pricing, to update existing Product Extension records with new Floor Price.
	 * *****************/	  
	private void updateExistingProdExt(Set<String> setProductCodes, Map<String,CNP_High_Staging__c> mapProdCodeStreamToStage,Set<string> prodCodesWithProductExtension,
				Map<String, List<Product_Extension__c>> mapOldProductToProductExtension,List<Product_Extension__c> productExtensionToUpsert){
		for(Product_Extension__c productExt : [SELECT Id,Product__c,Product__r.ProductCode,Floor_Price__c,CurrencyISOCode,Stream__c FROM Product_Extension__c 
			  where Product__r.ProductCode IN:setProductCodes
			 AND CurrencyIsoCode =: USD_CURRENCY]){
			
			
			
			//check if Product extension exists for a given staging record's ProductCode-Stream combination
			if(mapProdCodeStreamToStage.containsKey(productExt.Product__r.ProductCode+'_'+productExt.Stream__c)){
	prodCodesWithProductExtension.add(productExt.Product__r.ProductCode+'_'+productExt.Stream__c+'@'+productExt.Product__c);
	//populate map of product code vs old product extension price to access old values during Processing table creation
	if(!mapOldProductToProductExtension.containsKey(productExt.Product__r.ProductCode+'_'+productExt.Stream__c)){
		mapOldProductToProductExtension.put(productExt.Product__r.ProductCode+'_'+productExt.Stream__c, new List<Product_Extension__c>());
	}
	Product_Extension__c productExtClone = new Product_Extension__c(Id = productExt.Id, Floor_Price__c = productExt.Floor_Price__c, currencyISOCode =productExt.CurrencyISOCode );
	mapOldProductToProductExtension.get(productExt.Product__r.ProductCode+'_'+productExt.Stream__c).add(productExtClone);

	//update new Floor Price
	productExt.Floor_Price__c = mapProdCodeStreamToStage.get(productExt.Product__r.ProductCode+'_'+productExt.Stream__c).Price__c;
	productExtensionToUpsert.add(productExt);
			}
		}		
	}
	/******************
	 * Method Name: updateExistingPLIMarketData
	 * Description: For Market Data, to update existing PLIs List Price.
	 * *****************/			
	private void updateExistingPLIMarketData(Set<String> setProductCodes,
			Map<String,CNP_High_Staging__c> mapProdCodePriceListToStage,
			 set<String> prodCodesWihtPLI,
			  Map<String, List<Apttus_Config2__PriceListItem__c>> mapOldProductToPLI,
			List<Apttus_Config2__PriceListItem__c> priceListItemToUpsert, Set<String> priceListNameset)
	{
		 
	 Map<string,Decimal> portfolioToConversionRateMap =  getconversionRateMap();			
		for(Apttus_Config2__PriceListItem__c priclistitem : [SELECT Id,Apttus_Config2__ListPrice__c,Apttus_Config2__ProductCode__c,CurrencyIsoCode,
				Apttus_Config2__ProductId__r.Portfolio__c,Apttus_Config2__PriceListId__r.Name,Apttus_Config2__ProductId__c
				FROM Apttus_Config2__PriceListItem__c 
				WHERE Apttus_Config2__ProductCode__c IN :setProductCodes AND Apttus_Config2__PriceListId__r.Name LIKE: priceListNameset
				AND Apttus_Config2__PriceListId__r.PriceList_Type__c=: INDIRECT_MARKET_PRICELISTTYPE 
				AND Apttus_Config2__Active__c = TRUE]){
			
			//truncate pricelistname to fetch EUR PLIs				
			
			String pricelist_truncatedName = priclistitem.Apttus_Config2__PriceListId__r.Name.substringbefore('(');
	 string mapKey = priclistitem.Apttus_Config2__ProductCode__c+'_'+pricelist_truncatedName.deleteWhitespace(); 
					
			//check if corresponding PLI exists for a given staging record's ProductCode-Pricelistname combination				
			if(mapProdCodePriceListToStage.containsKey(mapKey)){
	
	  
	prodCodesWihtPLI.add(mapKey);
	//populate the map of product code vs old PLI values
	if(!mapOldProductToPLI.containsKey(mapKey)){
		mapOldProductToPLI.put(mapKey, new List<Apttus_Config2__PriceListItem__c>());
	}
	Apttus_Config2__PriceListItem__c priclistitemClone = getOldPLIClone(priclistitem);
	
	

	mapOldProductToPLI.get(mapKey).add(priclistitemClone);

	//populate list price if target PLI currency =  USD
	if(priclistitem.currencyISOCode == 'USD'){
		
		priclistitem.Apttus_Config2__ListPrice__c = mapProdCodePriceListToStage.get(mapKey).Price__c;
	}
	//populate list price with converted rate if target PLI currency =  EUR
	else if(priclistitem.currencyISOCode == 'EUR' && priclistitem.Apttus_Config2__ProductId__r.Portfolio__c != null && portfolioToConversionRateMap.containsKey(priclistitem.Apttus_Config2__ProductId__r.Portfolio__c)){
		
		Decimal stagePrice = mapProdCodePriceListToStage.get(mapKey).Price__c;
		
		Decimal listprice =  portfolioToConversionRateMap.get(priclistitem.Apttus_Config2__ProductId__r.Portfolio__c)*stagePrice;
		priclistitem.Apttus_Config2__ListPrice__c  = listprice.setScale(2);
		
	}
	priceListItemToUpsert.add(priclistitem);
			}
		}
			 
	}
	//Get conversion rate for Euro Price List Items - for Indirect Market
	private Map<string,Decimal> getconversionRateMap(){
		Map<string,Decimal> portfolioToConversionRateMap = new Map<string,Decimal>();
		for(NokiaCPQ_PMDI_Parameter__c pmdiPar: [select Id,name, NokiaCPQ_Active__c, NokiaCPQ_ObjNameSrc__c, 
			 NokiaCPQ_ObjNameTrg__c, NokiaCPQ_ParaFrom__c,NokiaCPQ_ParaTo__c, 
			 NokiaCPQ_ParaType__c, NokiaCPQ_ReqMap__c from NokiaCPQ_PMDI_Parameter__c 
			 where name = 'Currency Conversion' and NokiaCPQ_ParaType__c = 'FX_RATE_EUR']){
			portfolioToConversionRateMap.put(pmdiPar.NokiaCPQ_ParaFrom__c,Decimal.valueof(pmdiPar.NokiaCPQ_ParaTo__c));
		}
		
		return portfolioToConversionRateMap;
	}
	//Old PLI instance to copy old values onto Processing Table
	private Apttus_Config2__PriceListItem__c getOldPLIClone(Apttus_Config2__PriceListItem__c existingPLI){
		Apttus_Config2__PriceListItem__c priclistitemClone = new Apttus_Config2__PriceListItem__c();
		priclistitemClone.Id = existingPLI.Id;
		priclistitemClone.Apttus_Config2__ListPrice__c = existingPLI.Apttus_Config2__ListPrice__c;
		priclistitemClone.CurrencyIsoCode =existingPLI.CurrencyIsoCode;
		priclistitemClone.Apttus_Config2__ProductId__c =existingPLI.Apttus_Config2__ProductId__c;
		return priclistitemClone;
	}
	
}