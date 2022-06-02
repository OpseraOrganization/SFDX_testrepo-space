/*********************************************************************
* Class Name : QTC_ShowSalesOrder
* Test Class : QTC_ShowSalesOrderTest
* Created Date: 6th May 2021
* Created By : Jithin Sreedharan, Standav
* Description : Rest service for SAP to request prices for Sales Order products.
Called by CPI which is middleware for SAP, SAP does not directly interact with Salesforce
* Modified By : Neeharika Upadrasta, Nokia
* Description : Updated pricing logic to return all possible prices for the products sent.
* Modified By : Neeharika Upadrasta, Nokia. 29/Mar/2022
* Description : Ticket # 02397351 - Added null check for Prod bug where $0 Contract Prices are not being displayed.
	They are being overridden by Floor/Rec Price. Contract Prices will always be displayed
	except when they are null.
Added SAP standard parameters in request and response.
*******************************************************************/
@RestResource(urlMapping='/v1/ShowSalesOrder/*')
global without sharing class QTC_ShowSalesOrder {

	//Salesforce line parameters
	public static String productCode;
	public static String conditionType;
	public static Decimal unitprice;
	
	//Salesforce header parameters
	public static String defaultCurrency;
	public static String pricingpool;
	public static String soldTo;
	public static String defPricingPool;
	public static String documentDate;
	public static String errormessage;	
	
	@HttpPost
	global static void doPost() {
		RestRequest request = RestContext.request;
		RestResponse res = RestContext.response;
		
		try {
			String reqBody = request.requestbody.toString();
			QTC_ShowSalesOrder_Wrapper.N0_Z_EFI_SENDORDER requestFromSAP;
			try {
				requestFromSAP = (QTC_ShowSalesOrder_Wrapper.N0_Z_EFI_SENDORDER)JSON.deserialize(reqBody, QTC_ShowSalesOrder_Wrapper.N0_Z_EFI_SENDORDER.class);
			} 
			catch(Exception e) {								
				N0_Z_EFI_SENDORDER requestFromSAPSingle = (N0_Z_EFI_SENDORDER)JSON.deserialize(reqBody, N0_Z_EFI_SENDORDER.class);
				
				//Initialize wrappers
				requestFromSAP = new QTC_ShowSalesOrder_Wrapper.N0_Z_EFI_SENDORDER();
				requestFromSAP.IZEFI005 = new QTC_ShowSalesOrder_Wrapper.IZEFI005();
				
				//Cast input from SAP into Header and line items
				requestFromSAP.ZEFI006 = (QTC_ShowSalesOrder_Wrapper.ZEFI006)requestFromSAPSingle.ZEFI006; 
				QTC_ShowSalesOrder_Wrapper.Item singleItem = (QTC_ShowSalesOrder_Wrapper.Item)requestFromSAPSingle.IZEFI005.item;				
				requestFromSAP.IZEFI005.item = new List<QTC_ShowSalesOrder_Wrapper.Item>{singleItem};							   
			}
			system.debug('requestFromSAP '+requestFromSAP);
			soldTo = requestFromSAP.ZEFI006.KUNNR;
			soldTo = soldTo.replaceFirst('^0+',''); //To remove leading zeroes sent when sent from SAP. Ex: 00082084 -> 82084
			String productCodesString = getProducts(requestFromSAP.IZEFI005.item);
			
			if(String.isBlank(soldTo) || String.isBlank(productCodesString)) {
	requestFromSAP.ZEFI006.ZMESSAGE = 'Sold Account or Products not provided, please check the parameters';
	res.responseBody = Blob.valueOf('Bad request parameters, check Message field on input for details');
	res.statusCode = 400;
			} else {
	QTC_ShowSalesOrder_Wrapper.N0_Z_EFI_SENDORDER pricingResponse = getDynamicPricingResponse(productCodesString, requestFromSAP);
	res.responseBody = Blob.valueOf(JSON.serialize(pricingResponse));
	res.statusCode = 200;
			}
			
		} catch (Exception e) {
			res.responseBody = Blob.valueOf(e.getMessage());
			res.statusCode = 500;
		}
	}
	
	
	//helper methods - start
	private static final String STATUS_SUCCESS = 'success';
	private static final String STATUS_FAILED = 'failed';
	@TestVisible
	private static QTC_ShowSalesOrder_Wrapper.N0_Z_EFI_SENDORDER getDynamicPricingResponse(String productCodesString, QTC_ShowSalesOrder_Wrapper.N0_Z_EFI_SENDORDER requestFromSAP) {
		
		//Custom Settings for returning WES Number of Account selected
		Map<String, QTC_WES_Warranty_Mapping__c> wesMap = QTC_WES_Warranty_Mapping__c.getAll();
		
		//Set WES Number for selected Account
		if(wesMap.containsKey(soldTo)){
			requestFromSAP.ZEFI006.ZZWESNR = wesMap.get(soldTo).WES_Warranty__c;
		}
		else
			requestFromSAP.ZEFI006.ZZWESNR = wesMap.get('Default').WES_Warranty__c;	
		
		//find parent customer Id
		Account parentAccount = findCustomerAccountFromLegalEntity(soldTo);
		if(parentAccount == null) {
			requestFromSAP.ZEFI006.ZMESSAGE = 'Sold To Account not found';
			return requestFromSAP;
		}
		
		//Start finding Pricing Pool and related Agreements
		String sapPricingPoolName = requestFromSAP.ZEFI006.ZZPPNAME;
		CPQ_PricingPool__c selectedPricingPool;
		List<CPQ_Pricing_Pool_Agreement_Map__c> poolAgreementList;
		
		//find pricing pool - if a pricing pool is mentioned by the SAP user
		if(String.isNotBlank(sapPricingPoolName)){
			selectedPricingPool = findPricingPool(sapPricingPoolName);
		}
		else{ // If not pricing pool is mentioned, get default Pricing Pool on the Account
			selectedPricingPool = findDefaultPricingPool(parentAccount.Id);
		}		
		
		//get mapped agreements in seqeunce from selected pricing pool		
		if(selectedPricingPool != null){			
			poolAgreementList = selectedPricingPool.Pricing_Pool_Agreement_Maps__r;
			requestFromSAP.ZEFI006.ZZPPNAME = selectedPricingPool.CPQ_Pricing_Pool_Name__c;
		}
		else{
			requestFromSAP.ZEFI006.ZMESSAGE = 'Selected Pricing Pool does not exist, please check Pricing Pool name';
			return requestFromSAP;
		}			
		
		//create map of productcode vs productId
		List<String> productCodesList = productCodesString.split(',');
		Set<String> productCodes = new Set<String>(productCodesList);
		Map<String, Product2> productByCode = getProductByProductCode(productCodes);
		
		//Get Global Price List for specific Products
		Map<String, Apttus_Config2__PriceListItem__c> globalPriceListMap = getGlobalPriceList(productCodes);
		
		//get agreement numbers in sequence
		List<String> agreementNumbers = getSequencedAgreementNumbers(poolAgreementList);
		Map<String, Apttus_Config2__PriceListItem__c> priceListItemByProductCodeSpecific;
		
		//check if a specific valid agreement is given in request.
		CPQ_Pricing_Pool_Agreement_Map__c validPoolAgreementRecord = findIfValidAgreementSpecifiedInTheRequest(poolAgreementList, requestFromSAP.ZEFI006.ZZWESNR);
		
		//create map of agreement specific product code vs price list item, if the agreement exist in the default price pool - remove price list items that dosent fall between the dates
		if(validPoolAgreementRecord != null) {
			priceListItemByProductCodeSpecific = getSpecificAgreementPricingMap(validPoolAgreementRecord, productCodes);
		}
		
		//create default pricing pool product code vs price list items map respecting the sequence - remove price list items that dosent fall between the dates
		Map<String, Apttus_Config2__PriceListItem__c> priceListItemByProductCodeDefaultPool = getDefaultPoolPricingMap(agreementNumbers, productCodes);
		Map<String,Product_Extension__c>  peMap = new Map<String,Product_Extension__c>();
		peMap = getProdExtensionMap(productCodes);
		
		//create response wrapper - initialize data
		String prdCode = '';
		Decimal contractPrice;
		Decimal basePrice;
		Decimal listPrice;
		Decimal floorPrice;
		QTC_ShowSalesOrder_Wrapper.Item contractLine;
		QTC_ShowSalesOrder_Wrapper.Item baseLine;
		QTC_ShowSalesOrder_Wrapper.Item recommendLine;
		List<Decimal> basePriceList = new List<Decimal>();
		List<QTC_ShowSalesOrder_Wrapper.Item> additionalLines = new List<QTC_ShowSalesOrder_Wrapper.Item>();
		
		for(QTC_ShowSalesOrder_Wrapper.Item lineItem : requestFromSAP.IZEFI005.item) {
			
			prdCode = lineItem.MATNR;
			contractPrice = null;
			basePrice = 0;
			listPrice = 0;
			floorPrice = 0;
			
			contractLine = new QTC_ShowSalesOrder_Wrapper.Item();
			baseLine = new QTC_ShowSalesOrder_Wrapper.Item();
			recommendLine = new QTC_ShowSalesOrder_Wrapper.Item();
			Apttus_Config2__PriceListItem__c pli;
			Product_Extension__c peLi;
			basePriceList.clear();
			
			if(productByCode != null && productByCode.containsKey(prdCode)) {
	
	if(priceListItemByProductCodeSpecific != null && !priceListItemByProductCodeSpecific.isEmpty()) {
		pli = priceListItemByProductCodeSpecific.containsKey(prdCode) ? priceListItemByProductCodeSpecific.get(prdCode) : null;
	}
	else if(priceListItemByProductCodeDefaultPool != null && !priceListItemByProductCodeDefaultPool.isEmpty()) {
		pli = priceListItemByProductCodeDefaultPool.containsKey(prdCode) ? priceListItemByProductCodeDefaultPool.get(prdCode) : null;
	}	  
	
	//Contract Price from default Pricing Pool or from Pricing Pool mentioned in the request
	if(pli != null && pli.Apttus_Config2__ContractPrice__c != null) {
		contractPrice = pli.Apttus_Config2__ContractPrice__c;
		requestFromSAP.ZEFI006.ZZCONTNR = pli.Apttus_Config2__PriceListId__r.Name;
		//Add new line for each condition type
		contractLine = cloneLineItem(contractLine,lineItem,prdCode,'ZPR0',String.valueof(contractPrice));
		basePriceList.add(contractPrice);
		additionalLines.add(contractLine);
	}
	
	//Floor Price from Product Extension
	//Added null check for Prod bug 02397351 where $0 are not being sent, overridden by Floor/Rec Price
	if(contractPrice == null && peMap!=null && peMap.containsKey(prdCode)){
		peLi = peMap.get(prdCode);
		
		if(peLi.Floor_Price__c != null){ //No additonal line needed for Floor Price
			floorPrice = peLi.Floor_Price__c;
			basePriceList.add(floorPrice);
		}		
		if(peLi.Market_Price__c != null){
			basePrice = floorPrice!=0 ? floorPrice : peLi.Market_Price__c; //If Floor Price is available, it is assigned to this line as well
			recommendLine = cloneLineItem(recommendLine,lineItem,prdCode,'ZREC',String.valueof(basePrice));
			basePriceList.add(basePrice);
			additionalLines.add(recommendLine);
		}		
	}
	
	//Global List Price is assigned with blank condition Type
	if(globalPriceListMap.containsKey(prdCode)){
		listPrice = globalPriceListMap.get(prdCode).Apttus_Config2__ListPrice__c;
		lineItem.KBETR_SPM = String.valueof(listPrice);
		lineItem.KSCHL = '';
		basePriceList.add(listPrice);
	}
	
	//Creating mandatory line item for base price - Contract/Floor/List Price is assigned as Base Price, whichever is found first in that order
	baseLine = cloneLineItem(baseLine,lineItem,prdCode,'ZPRF',String.valueof(basePriceList[0])); //Taking the first added price in the list
	additionalLines.add(baseLine);
	
	//New logic added based on SAP's behaviour when Contract Price is not available
	if(contractPrice == null){
		contractLine = cloneLineItem(contractLine,lineItem,prdCode,'ZPR0',String.valueof(basePriceList[0]));
		additionalLines.add(contractLine);
	}		
			}
		}
		
		//Add new lines to the request body and send back as response
		requestFromSAP.IZEFI005.item.addall(additionalLines);
		
		return requestFromSAP;
	}
	
	private static String getProducts(List<QTC_ShowSalesOrder_Wrapper.Item> wrapperLines){
		List<String> productCodesString = new List<String>();
		
		for(QTC_ShowSalesOrder_Wrapper.Item wrapper : wrapperLines){
			if(wrapper.MATNR != null)
	productCodesString.add(wrapper.MATNR);
		}
		return String.join(productCodesString,',');
	}
	
	private static Account findCustomerAccountFromLegalEntity(String soldTo) {
		
		if(String.isBlank(soldTo)) return null;
		
		Account ultimateParent;
		
		Account level0Account = [SELECT Id, ParentId, AccountNumber FROM Account WHERE QTC_Sold_To__c =: soldTo LIMIT 1];
		if(level0Account == null) return null;
		if(level0Account.ParentId == null) {
			ultimateParent = level0Account;
		}
		
		Account level1Account;
		if(ultimateParent == null && level0Account.parentId != null) {
			level1Account = [SELECT Id, ParentId, AccountNumber FROM Account WHERE Id =:level0Account.ParentId][0];
			if(level1Account.ParentId == null) {
	ultimateParent = level1Account;
			}
		}
		
		Account level2Account;
		if(ultimateParent == null && level1Account.parentId != null) {
			level2Account = [SELECT Id, ParentId, AccountNumber FROM Account WHERE Id =:level1Account.ParentId][0];
			if(level2Account.ParentId == null) {
	ultimateParent = level2Account;
			}
		}
		
		Account level3Account;
		if(ultimateParent == null && level2Account.parentId != null) {
			level3Account = [SELECT Id, ParentId, AccountNumber FROM Account WHERE Id =:level2Account.ParentId][0];
			if(level3Account.ParentId == null) {
	ultimateParent = level3Account;
			}
		}
		
		Account level4Account;
		if(ultimateParent == null && level3Account.parentId != null) {
			level4Account = [SELECT Id, ParentId, AccountNumber FROM Account WHERE Id =:level3Account.ParentId][0];
			if(level4Account.ParentId == null) {
	ultimateParent = level4Account;
			}
		}
		return ultimateParent;
	}
	
	
	private static CPQ_PricingPool__c findDefaultPricingPool(Id accountId) {
		
		if(accountId == null) return null;
		
		List<CPQ_PricingPoolAccountMap__c> poolAccountMapList = [SELECT Id, CPQ_Pricing_Pool_ID__c FROM CPQ_PricingPoolAccountMap__c
				 WHERE CPQ_Account__c = :accountId AND CPQ_Default__c = true ORDER BY LastModifiedDate DESC LIMIT 1];
		if(poolAccountMapList == null || poolAccountMapList.isEmpty()) return null;
		
		List<CPQ_PricingPool__c> poolList = [SELECT Id,CPQ_Pricing_Pool_Name__c, (SELECT Id,CPQ_Agreement_Name__c,CPQ_Agreement_Name__r.Name,CPQ_Agreement_Number__c
					  FROM Pricing_Pool_Agreement_Maps__r
					  WHERE CPQ_Active__c = true ORDER BY CPQ_Rank__c ASC NULLS LAST)
			FROM CPQ_PricingPool__c
			WHERE Id = :poolAccountMapList[0].CPQ_Pricing_Pool_ID__c AND CPQ_Active__c = true];
		
		return poolList[0];
	}
	
	private static Map<String, Product2> getProductByProductCode(Set<String> productCodes) {
		
		if(productCodes == null || productCodes.isEmpty()) return null;
		
		Map<String, Product2> productByCode = new Map<String, Product2>();
		List<Product2> productList = [SELECT Id, ProductCode from Product2 WHERE ProductCode IN :productCodes];
		if(productList != null) {
			for(Product2 prd : productList) {
	productByCode.put(prd.ProductCode, prd);
			}
		}
		
		return productByCode;
	}
	
	private static List<String> getSequencedAgreementNumbers(List<CPQ_Pricing_Pool_Agreement_Map__c> poolAgreementList) {
		
		if(poolAgreementList == null || poolAgreementList.isEmpty()) return null;
		
		List<String> agreementNumbers = new List<String>();
		for(CPQ_Pricing_Pool_Agreement_Map__c poolAgrMap : poolAgreementList) {
			agreementNumbers.add(poolAgrMap.CPQ_Agreement_Number__c);
		}
		
		return agreementNumbers;
	}
	
	private static CPQ_Pricing_Pool_Agreement_Map__c findIfValidAgreementSpecifiedInTheRequest(List<CPQ_Pricing_Pool_Agreement_Map__c> poolAgreementList, String agreementName) {
		
		if(poolAgreementList == null || poolAgreementList.isEmpty() || String.isBlank(agreementName)) return null;
		
		CPQ_Pricing_Pool_Agreement_Map__c validAgreement;
		for(CPQ_Pricing_Pool_Agreement_Map__c poolAgrMap : poolAgreementList) {
			if(poolAgrMap.CPQ_Agreement_Name__r.Name.equalsIgnoreCase(agreementName)) {
	validAgreement = poolAgrMap;
	break;
			}
		}
		return validAgreement;
	}
	
	private static Map<String, Apttus_Config2__PriceListItem__c>  getSpecificAgreementPricingMap(CPQ_Pricing_Pool_Agreement_Map__c poolAgrMap, Set<String> productCodes) {
		
		if(poolAgrMap == null || productCodes == null || productCodes.isEmpty()) return null;
		
		Map<String, Apttus_Config2__PriceListItem__c> priceListItemByProductCode = new Map<String, Apttus_Config2__PriceListItem__c>();
		List<Apttus_Config2__PriceListItem__c> priceListItems = [
			SELECT
			Id, CPQ_Agreement_Name__c, CPQ_Agreement_Number__c, Apttus_Config2__ListPrice__c,
			Apttus_Config2__ContractPrice__c, Apttus_Config2__ProductId__r.ProductCode, 
			Apttus_Config2__EffectiveDate__c, Apttus_Config2__ExpirationDate__c, Apttus_Config2__PriceListId__r.Name
			FROM Apttus_Config2__PriceListItem__c
			WHERE Apttus_Config2__PriceListId__c = :poolAgrMap.CPQ_Agreement_Name__c AND Apttus_Config2__ProductId__r.ProductCode IN :productCodes AND Apttus_Config2__Active__c = true
		];
		DateTime currentTime = DateTime.now();
		for(Apttus_Config2__PriceListItem__c pli : priceListItems) {
			if(!priceListItemByProductCode.containsKey(pli.Apttus_Config2__ProductId__r.ProductCode)) {
	Boolean isValidPLI = true;
	if(pli.Apttus_Config2__EffectiveDate__c != null && currentTime < pli.Apttus_Config2__EffectiveDate__c) {
		isValidPLI = false;
	}
	if(pli.Apttus_Config2__ExpirationDate__c != null && currentTime > pli.Apttus_Config2__ExpirationDate__c) {
		isValidPLI = false;
	}
	if(isValidPLI) {
		priceListItemByProductCode.put(pli.Apttus_Config2__ProductId__r.ProductCode, pli);
	}
			}
		}
		
		return priceListItemByProductCode;
	}
	
	private static Map<String, Apttus_Config2__PriceListItem__c> getDefaultPoolPricingMap(List<String> agreementNumbers, Set<String> productCodes) {
		if(agreementNumbers == null || agreementNumbers.isEmpty() || productCodes == null || productCodes.isEmpty()) return null;
		
		Map<String, Apttus_Config2__PriceListItem__c> priceListItemByProductCode = new Map<String, Apttus_Config2__PriceListItem__c>();
		Nokia_CPQ_Constants.AGREEMENT_NUMBERS = agreementNumbers;
		List<Apttus_Config2__PriceListItem__c> priceListItems = [
			SELECT
			Id, CPQ_Agreement_Name__c, CPQ_Agreement_Number__c, Apttus_Config2__ListPrice__c, Apttus_Config2__ContractPrice__c,
			Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__EffectiveDate__c, Apttus_Config2__ExpirationDate__c,
			Apttus_Config2__PriceListId__r.Name
			FROM Apttus_Config2__PriceListItem__c
			WHERE CPQ_Agreement_Number__c IN :agreementNumbers AND Apttus_Config2__ProductId__r.ProductCode IN :productCodes AND Apttus_Config2__Active__c = true
		];
		List<CPQ_PriceListItemWrapper> pliWrapperList = makePLIWrapperList(priceListItems);
		pliWrapperList.sort();
		
		DateTime currentTime = DateTime.now();
		for(CPQ_PriceListItemWrapper pliWrapper : pliWrapperList) {
			Apttus_Config2__PriceListItem__c pli = pliWrapper.priceListItem;
			if(!priceListItemByProductCode.containsKey(pli.Apttus_Config2__ProductId__r.ProductCode)) {
	Boolean isValidPLI = true;
	if(pli.Apttus_Config2__EffectiveDate__c != null && currentTime < pli.Apttus_Config2__EffectiveDate__c) {
		isValidPLI = false;
	}
	if(pli.Apttus_Config2__ExpirationDate__c != null && currentTime > pli.Apttus_Config2__ExpirationDate__c) {
		isValidPLI = false;
	}
	if(isValidPLI) {
		priceListItemByProductCode.put(pli.Apttus_Config2__ProductId__r.ProductCode, pli);
	}
			}
		}
		
		return priceListItemByProductCode;
	}
	
	private static Map<String,Product_Extension__c> getProdExtensionMap(Set<String> productCodes) {
		if(productCodes == null || productCodes.isEmpty()) return null;
		
		Map<String,Product_Extension__c> prodExtensionByProductCode = new Map<String,Product_Extension__c>();
		List<Product_Extension__c> prodExtensionItems = new List<Product_Extension__c>();
		prodExtensionItems = [SELECT Id, Product__r.ProductCode,Stream__c,Floor_Price__c,Market_Price__c
		 FROM Product_Extension__c
		 WHERE Product__r.ProductCode IN :productCodes AND Stream__c = 'QTC'
		];
		
		if(!prodExtensionItems.isEmpty()){
			for(Product_Extension__c pe:prodExtensionItems){
	prodExtensionByProductCode.put(pe.Product__r.ProductCode,pe);
			}
			
			return prodExtensionByProductCode;
		}
		
		return null;
	}
	
	private static List<CPQ_PriceListItemWrapper> makePLIWrapperList(List<Apttus_Config2__PriceListItem__c> pliList) {
		List<CPQ_PriceListItemWrapper> pliWrapperList = new List<CPQ_PriceListItemWrapper>();
		for(Apttus_Config2__PriceListItem__c pli : pliList) {
			pliWrapperList.add(new CPQ_PriceListItemWrapper(pli));
		}
		return pliWrapperList;
	}
	
	private static Map<String, Apttus_Config2__PriceListItem__c> getGlobalPriceList(Set<String> prodCodes) {
		Map<String, Apttus_Config2__PriceListItem__c> globalPriceListMap = new Map<String, Apttus_Config2__PriceListItem__c>();
		for(Apttus_Config2__PriceListItem__c pli : [Select Id, Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__ListPrice__c,
				Apttus_Config2__PriceListId__r.Name
				from Apttus_Config2__PriceListItem__c
				where Apttus_Config2__PriceListId__r.Name = 'Global Price List (USD)'
				AND Apttus_Config2__ProductId__r.ProductCode IN :prodCodes
				AND Apttus_Config2__Active__c = true]){
					if(pli != null)
						globalPriceListMap.put(pli.Apttus_Config2__ProductId__r.ProductCode, pli);
				}
		
		return globalPriceListMap;
	}
	
	private static CPQ_PricingPool__c findPricingPool(String pricingPoolName){
		List<CPQ_PricingPool__c> poolList = new List<CPQ_PricingPool__c>();
		poolList = [SELECT Id,CPQ_Pricing_Pool_Name__c, (SELECT Id,CPQ_Agreement_Name__c,CPQ_Agreement_Name__r.Name,CPQ_Agreement_Number__c
					 FROM Pricing_Pool_Agreement_Maps__r
					 WHERE CPQ_Active__c = true ORDER BY CPQ_Rank__c ASC NULLS LAST)
		FROM CPQ_PricingPool__c 
		WHERE CPQ_Pricing_Pool_Name__c =:pricingPoolName AND CPQ_Active__c = true];
		if(poolList.isEmpty()) return null;
		else return poolList[0];
	}
	//helper methods - end
	
	//wrapper classes for single line item - start
	public class N0_Z_EFI_SENDORDER {
		public IZEFI005 IZEFI005;
		public QTC_ShowSalesOrder_Wrapper.ZEFI006 ZEFI006;
		
		public N0_Z_EFI_SENDORDER(){}
	}
	
	public class IZEFI005 {
		public QTC_ShowSalesOrder_Wrapper.Item item;
		
		public IZEFI005(){}
	}
	//wrapper classes for single line item - end
	
	private static QTC_ShowSalesOrder_Wrapper.Item cloneLineItem(QTC_ShowSalesOrder_Wrapper.Item newLine, QTC_ShowSalesOrder_Wrapper.Item oldLine, String prdCode, String conditionType, String price){ 
		newLine.MANDT= oldLine.MANDT;
		newLine.VBELN= oldLine.VBELN;
		newLine.POSNR= oldLine.POSNR;
		newLine.MATNR= prdCode;
		newLine.KWMENG= oldLine.KWMENG;
		newLine.ARKTX= oldLine.ARKTX;
		newLine.BSTNK= oldLine.BSTNK;
		newLine.POSAR= oldLine.POSAR;
		newLine.UEPOS= oldLine.UEPOS;
		newLine.KSCHL= conditionType;
		newLine.KBETR_SPM= price;
		newLine.ECODE= oldLine.ECODE;
		newLine.KBETR= oldLine.KBETR;
		newLine.MEINS= oldLine.MEINS;
		newLine.ERDAT= oldLine.ERDAT;
		newLine.SMENG= oldLine.SMENG;
		newLine.POSEX= oldLine.POSEX;
		newLine.KDMAT= oldLine.KDMAT;
		newLine.SPART= oldLine.SPART;
		newLine.GSBER= oldLine.GSBER;
		newLine.NETWR= oldLine.NETWR;
		newLine.WAERK= oldLine.WAERK;
		newLine.WERKS= oldLine.WERKS;
		newLine.STLNR= oldLine.STLNR;
		newLine.NETPR= oldLine.NETPR;
		newLine.KPEIN= oldLine.KPEIN;
		newLine.KMEIN= oldLine.KMEIN;
		newLine.PRCTR= oldLine.PRCTR;
		newLine.PS_PSP_PNR= oldLine.PS_PSP_PNR;
		newLine.AUFNR= oldLine.AUFNR;
		newLine.PARVW= oldLine.PARVW;
		newLine.KUNNR= oldLine.KUNNR;
		newLine.LAND1= oldLine.LAND1;
		newLine.LZONE= oldLine.LZONE;
		newLine.ZMESSAGE= oldLine.ZMESSAGE;
		newLine.FIELD1= oldLine.FIELD1;
		newLine.FIELD2= oldLine.FIELD2;
		return newLine;
	}
}