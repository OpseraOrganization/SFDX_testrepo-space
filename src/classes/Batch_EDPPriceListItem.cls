/****************************************
	 * Name : Batch_EDPPriceListItem
	 * Author : Accenture
	 * Description : This class is for creating price list items from Product sales item object
	 * ReqNo : 4566, 4571, 4572, 4870
	****************************************/
global class Batch_EDPPriceListItem implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful,Schedulable {
		 
	public Map<String, String> paramterMap = new Map<String, String>();
	public Set<String> currencyRepriceSet = new Set<String>();
	public List<String> portfolioList = new List<String>();
	private static boolean debug = false;
	
	/****************************************
		 * Name : execute
		 * Description : executes the batch class
		 * Parameters: SchedulableContext
		 * Returns : 
	 *****************************************/
	global void execute(SchedulableContext SC)	  
		 {
			   Batch_EDPPriceListItem  batch = new Batch_EDPPriceListItem();
			   Database.executebatch(batch, 2000);			
		 } 
	
	/****************************************
		 * Name : start
		 * Description : Retreives all sales items which has IRP price
		 * Parameters: Database.BatchableContext
		 * Returns : List<Product_Sales_Items__c>
	 *****************************************/	
	global Database.QueryLocator start(Database.BatchableContext BC)
		{
			for(PMDI_PriceList_Filter__c pmdifilter : [SELECT Filter__c,Id,Name 
													   FROM PMDI_PriceList_Filter__c])
			{
				if(pmdifilter.Name.containsIgnoreCase('Portfolio'))
				{
					String port = pmdifilter.Filter__c;
					if(port != null && !String.isBlank(port) && !String.isEmpty(port))
					portfolioList.add(port);					
				}		
				if(debug)
					System.debug('portfolio: '+portfolioList);
			}
			
			for(NokiaCPQ_PMDI_Parameter__c paramter : [SELECT NokiaCPQ_ParaFrom__c,
											NokiaCPQ_ParaTo__c, NokiaCPQ_ParaType__c,
										  CurrencyIsoCode 
															FROM NokiaCPQ_PMDI_Parameter__c
															WHERE NokiaCPQ_Active__c = True
															AND NokiaCPQ_ObjNameTrg__c = 'Apttus_Config2__PriceListItem__c' 
														AND Name = 'Currency Conversion'])
			{
				if(paramter.NokiaCPQ_ParaType__c.equalsIgnoreCase('FX_RATE_USD'))
					paramterMap.put(paramter.NokiaCPQ_ParaFrom__c+'USD',paramter.NokiaCPQ_ParaTo__c);
				if(paramter.NokiaCPQ_ParaType__c.equalsIgnoreCase('FX_RATE_EUR'))
					paramterMap.put(paramter.NokiaCPQ_ParaFrom__c+'EUR',paramter.NokiaCPQ_ParaTo__c);
			}
			
			//Collect all product sales item that were modified today for processing			
			return database.getQueryLocator([SELECT Id,
											 	NSNCode__c,Name,
											 	Is_Processed__c,CurrencyIsoCode,
											 	IRP_Price__c,IRP_Valid_From__c
											 FROM Product_Sales_Item__c
											 WHERE Is_Processed__c = true AND
			Is_PLI_Processed__c = false AND
											 	IRP_Price__c != null AND											 	
											 	IRP_Valid_From__c <= :system.now()
											]);
		}
	
	/****************************************
		 * Name : execute
		 * Description : Creates or updates price list items based on salesitems
		 * Parameters: Database.BatchableContext, List<Product_Sales_Item__c>
		 * Returns : 
	 *****************************************/
	global void execute(Database.BatchableContext BC, List<Product_Sales_Item__c> salesItems)
		{
			Map<String, List<Apttus_Config2__PriceListItem__c>> priceListItemMap = new Map<String, List<Apttus_Config2__PriceListItem__c>>();
			Map<String, List<String>> productMap = new Map<String, List<String>>();
			Map<String, Id> priceListMap = new Map<String, Id>();
			Map<String, CurrencyType> currency_map = new Map<String, CurrencyType>();
			Map<Id, String> productIdCode_map = new Map<Id, String>();
			
			List<Id> productActiveList = new List<Id>();
			List<String> codeList = new List<String>();			
			List<Apttus_Config2__PriceListItem__c> priceItemList = new List<Apttus_Config2__PriceListItem__c>();
			List<Apttus_Config2__PriceListItem__c> Upd_priceItemList = new List<Apttus_Config2__PriceListItem__c>();					 
			List<Product_Sales_Item__c> processedPSIlist = new List<Product_Sales_Item__c>();
			
			Boolean currency_check = false;			
			
			//prepare a list for storing all the salesitems code for this batch			
			for(Product_Sales_Item__c salesItem : salesItems)
			{
				codeList.add(salesItem.NSNCode__c);
			}
			
								 
			//Getting Product Data for the sales items code needed for this batch and store it in a map
			String product_query = 'SELECT Id,Productcode,Portfolio__c,IsActive '+
					   'FROM Product2 '+
					   'where ProductCode in :codeList ';
			if(portfolioList != null && !portfolioList.isEmpty())
				product_query = product_query + 'AND Portfolio__c not in :portfolioList';
				
			for(List<Product2> ProdList : Database.query(product_query))
			{ 	 
				for(Product2 product : ProdList)
	{
		if(productMap.containsKey(product.ProductCode))
			productMap.get(product.ProductCode).add(product.Id+','+product.Portfolio__c);
		else
						productMap.put(product.ProductCode, new List<String>{product.Id+','+product.Portfolio__c});
					
		productIdCode_map.put(product.Id,product.ProductCode);
					if(product.IsActive)
						productActiveList.add(product.Id);
				}	
			}
											
			System.debug(productActiveList);
			//Get price list Id for each currency in a map
			for(Apttus_Config2__PriceList__c price : [Select Id, CurrencyIsoCode
													  From Apttus_Config2__PriceList__c
													 Where Name like 'Global%']){	  
					priceListMap.put(price.CurrencyIsoCode, price.Id);
			}
			//System.debug(priceListMap);
			
			
			//Get all pricelistitem details in a map for upserting data
			for(Apttus_Config2__PriceListItem__c priceListItem : [Select Id, 
																  	Apttus_Config2__ProductCode__c,
					Apttus_Config2__ProductId__r.Portfolio__c,
																 	Apttus_Config2__ListPrice__c,
																 	Apttus_Config2__PriceListItem__c.Apttus_Config2__EffectiveDate__c,
																 	Apttus_Config2__Active__c,
																  	CurrencyIsoCode,
					Master_Currency__c,
																  	Apttus_Config2__PriceListId__r.Name
				From Apttus_Config2__PriceListItem__c 
																where Apttus_Config2__ProductCode__c in :codeList 
																AND Apttus_Config2__PriceListId__r.Name like 'Global%'])
			{  
				if(priceListItemMap.containsKey(priceListItem.Apttus_Config2__ProductCode__c+priceListItem.Apttus_Config2__ProductId__r.Portfolio__c))
		priceListItemMap.get(priceListItem.Apttus_Config2__ProductCode__c+priceListItem.Apttus_Config2__ProductId__r.Portfolio__c).add(priceListItem);
	else
		priceListItemMap.put(priceListItem.Apttus_Config2__ProductCode__c+priceListItem.Apttus_Config2__ProductId__r.Portfolio__c, new List<Apttus_Config2__PriceListItem__c>{priceListItem});
			}
			//System.debug('priceListItemMap:'+priceListItemMap);
			
			codeList.clear();
			
			//Get all currency conversion details in a map
			for(CurrencyType c_type : [SELECT ConversionRate,DecimalPlaces,
									   Id,IsActive,IsoCode FROM CurrencyType])
			{
				currency_map.put(c_type.IsoCode, c_type);
			}
															
			//Loop through all salesitems
			for(Product_Sales_Item__c psi : salesItems)
			{
	//Get the pricelist Id for the currencycode of sales item
	Id priceList_ID;
	if(priceListMap.containsKey(psi.CurrencyIsoCode))
				{
					priceList_ID = priceListMap.get(psi.CurrencyIsoCode); 
				}
	
	//Get all the products that exists for the nsn code of sales item
	List<String> productList = productMap.get(psi.NSNCode__c);
	if(productList != null)
	{
	for(String product : productList)
	{
					currency_check = false;
		String portfolio = product.substringAfter(','); 
					
			Apttus_Config2__PriceListItem__c pli = new Apttus_Config2__PriceListItem__c();
		
					pli.Apttus_Config2__ProductId__c = product.substringBefore(',');  
			
		pli.Apttus_Config2__PriceListId__c = priceList_ID;
					  
					pli.Apttus_Config2__ListPrice__c = psi.IRP_Price__c.setScale(2);
					
					if(productActiveList.contains(pli.Apttus_Config2__ProductId__c))
					   pli.Apttus_Config2__Active__c = true;
					
		//Check if pricelist item already exists for a  sales item
			if(priceListItemMap.containsKey(psi.NSNCode__c+portfolio))
					{	
				 		
						List<Apttus_Config2__PriceListItem__c> plitems = priceListItemMap.get(psi.NSNCode__c+portfolio);
						if(plitems != null){
						for(Apttus_Config2__PriceListItem__c pl : plitems)
						{														 	
							if(pl.CurrencyIsoCode == psi.CurrencyIsoCode)
							{
								pli.Id = pl.Id;									
		//if price value changes create a new record in Quote reprice object
		if(psi.IRP_Price__c != pl.Apttus_Config2__ListPrice__c)
		{
									currencyRepriceSet.add(pli.Apttus_Config2__PriceListId__c);
		}
		currency_check = true;
								pli.Master_Currency__c = true;
								System.debug('pl: '+pl);
				}
				else
				{								
		//convert the currency value for older price list items//		   
								Decimal currRate;
								String currCode;
								if(portfolio == null || portfolio == '' || portfolio == 'null')
								{
									//use default exchange rate
			pl.Apttus_Config2__ListPrice__c = defaultExchangeRate(psi.CurrencyIsoCode, pl.CurrencyIsoCode, psi.IRP_Price__c,currency_map);	
									pl.Apttus_Config2__EffectiveDate__c = psi.IRP_Valid_From__c;
								}
		else if(portfolio != 'null' || portfolio != null || portfolio != '')
								{
									//get the exchange rate from dynamic mapping for portfolio and currency combination
									String param ='';
			if(pl.CurrencyIsoCode.equalsIgnoreCase('USD') && psi.CurrencyIsoCode.equalsIgnoreCase('EUR'))
											param = paramterMap.get(portfolio+'USD');
									if(pl.CurrencyIsoCode.equalsIgnoreCase('EUR') && psi.CurrencyIsoCode.equalsIgnoreCase('USD'))
											param = paramterMap.get(portfolio+'EUR');
									
									//change the existing currency value to appropriate new currency value
									if(param!= null && String.isNotBlank(param) && String.isNotEmpty(param))
									{
										currRate = Decimal.valueOf(param);
										pl.Apttus_Config2__ListPrice__c = (psi.IRP_Price__c * currRate).setScale(2);
									}
			else
			{
				pl.Apttus_Config2__ListPrice__c = defaultExchangeRate(psi.CurrencyIsoCode, pl.CurrencyIsoCode, psi.IRP_Price__c,currency_map);
			}
									pl.Apttus_Config2__EffectiveDate__c = psi.IRP_Valid_From__c;
								}
																							  
								pl.Master_Currency__c = false;
								//confirm and then add
								if(productActiveList.contains(pli.Apttus_Config2__ProductId__c))
									pl.Apttus_Config2__Active__c = true;
								if(!Upd_priceItemList.contains(pl))
			Upd_priceItemList.add(pl);
				}
						}
						}			
					}
		if(currency_check == false)
		{
						pli.CurrencyIsoCode = psi.CurrencyIsoCode;
			pli.Master_Currency__c = true;
					}		
					pli.Apttus_Config2__EffectiveDate__c = psi.IRP_Valid_From__c;				
				
				  //Add this current pli item to price list item map
				  priceItemList.add(pli);  
					if(debug)
				  System.debug('Price List Item: '+pli); 
	}
	 }
			}
			
			priceListMap.clear();
			productMap.clear();
			salesItems.clear();
			
			//Upsert pricelist item in to object
			if(Upd_priceItemList != null && Upd_priceItemList.size() > 0)
				Database.update(Upd_priceItemList,false);

			try
			{
				Database.UpsertResult[] results = Database.Upsert(priceItemList,false);
				for(integer index = 0; results != null && index< results.size() ; index++)
				{
					if(results[index].isSuccess())
					{
				Product_Sales_Item__c psi = new Product_Sales_Item__c();
				String productId = priceItemList[index].Apttus_Config2__ProductId__c;
				if(productId != null)
		psi.NsnCode__c = productIdCode_map.get(productId);
				psi.Is_PLI_Processed__c = true;	
							if(!(processedPSIlist.contains(psi)))
							{
								processedPSIlist.add(psi);
							}
					}
				}
				Database.upsert(processedPSIlist,Product_Sales_Item__c.NsnCode__c,false);
							 
			}catch(Exception ex)
			{
				System.debug('Exception while upserting pricelist items or quotereprice items'+ex.getMessage());
			}
			
			priceItemList.clear(); 
			processedPSIlist.clear();
			
			if(debug)
			System.debug('Apex cpu time: '+Limits.getCpuTime());
			
		}
	
	/****************************************
		 * Name : defaultExchangeRate
		 * Description : Retreives token from EDP by making a callout
		 * Parameters: Salesitem currency, Pricelistitem currency, IRP price, currencymap
		 * Returns : Decimal listprice
	 *****************************************/
	public Decimal defaultExchangeRate(String psiCurrency, String plCurrency, Decimal IRP_Price,Map<String, CurrencyType> currency_map)
	{
		Decimal currRate;
		Decimal price;
		if(psiCurrency.equalsIgnoreCase('EUR') && plCurrency.equalsIgnoreCase('USD'))
		{
	if(currency_map.containsKey(plCurrency))
	currRate = currency_map.get(plCurrency).ConversionRate;
			price = IRP_Price * currRate;
		}
		if(psiCurrency.equalsIgnoreCase('USD') && plCurrency.equalsIgnoreCase('EUR'))
		{
			if(currency_map.containsKey(psiCurrency))
	currRate = currency_map.get(psiCurrency).ConversionRate;
			price = IRP_Price / currRate;	
		}
		return price.setScale(2);
	}
	
	/****************************************
		 * Name : finish
		 * Description : creates quote reprice entries 
		 * Parameters: Database.BatchableContext
		 * Returns : 
	 *****************************************/
	global void finish(Database.BatchableContext BC)
		{
			try
			{				
				Id recordTypeId = [SELECT Id 
							   FROM RecordType 
							   WHERE DeveloperName = 'Price_List' 
							   limit 1].Id;
				List<Quote_Reprice__c> quoteRepriceList = new List<Quote_Reprice__c>();   
			
				for(String listPrice : currencyRepriceSet)
				{
					Quote_Reprice__c quoteReprice = new Quote_Reprice__c();
					quoteReprice.Price_List__c = listPrice;
					quoteReprice.RecordTypeId = recordTypeId;
					if(!(quoteRepriceList.contains(quoteReprice)))
						quoteRepriceList.add(quoteReprice);
				}
			 	Database.insert(quoteRepriceList,false); 
			}
			catch(Exception ex)
			{
				System.debug('Exception occurred while loading quote reprice: '+ex);
			}
		}
}