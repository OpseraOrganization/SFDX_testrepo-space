public with sharing class QTC_DataExtract {
	
   public static List<Product_Extension__c> getrelatedproductextensions (set<Id> Productset, String Currencycode,String masterCurrencycode,String Portfolio,String AccountNumber){
		 String PDE_stream = '';
		List<Product_Extension__c> Prodext_List = new List<Product_Extension__c>();
		If(portfolio == Nokia_CPQ_Constants.QTC)
		{
			PDE_stream = Nokia_CPQ_Constants.CQ_STRING;
		}
		else if(portfolio == Nokia_CPQ_Constants.IP_ROUTING_STRING || portfolio == Nokia_CPQ_Constants.NOKIA_FN)
		{
		List<CPQ_Enterprise_Customer_Floor_Price__mdt> Accountwithtype = [select Account_Number__c,Type__c from CPQ_Enterprise_Customer_Floor_Price__mdt where Account_Number__c = :AccountNumber Limit 1];
		If(!Accountwithtype.isEmpty())
		{
			PDE_stream = Accountwithtype[0].type__c;
		}
		}
		// Below query is modified by Nandeesh 
		if(portfolio == Nokia_CPQ_Constants.IP_ROUTING_STRING || portfolio == Nokia_CPQ_Constants.NOKIA_FN){
		Prodext_List = [select Id,Product__c,Market_Price__c,Floor_Price__c,Custom_Bid__c from Product_Extension__c where Product__c in :Productset  and CurrencyIsoCode = :masterCurrencycode and Stream__c = :PDE_stream];
		}
		else{
	Prodext_List = [select Id,Product__c,Market_Price__c,Floor_Price__c,Custom_Bid__c from Product_Extension__c where Product__c in :Productset and CurrencyIsoCode = :Currencycode and Stream__c = :PDE_stream];
		}
		system.debug('PDE_LIST:'+Prodext_List);
		return Prodext_List;
	}
	//added by jithin - isNCQ - start
	public static List<Product_Extension__c> getrelatedNCQproductextensions (set<Id> Productset, String Currencycode){
		List<Product_Extension__c> Prodext_List = [select Id,Product__c,Market_Price__c,Floor_Price__c,Custom_Bid__c,Stream__c from Product_Extension__c where (Stream__c = 'QTC' and Product__c in :Productset and CurrencyIsoCode = :Currencycode) ORDER BY Floor_Price__c DESC NULLS LAST];
		
		return Prodext_List;
	}
	//added by jithin - isNCQ - end
	//added by jithin - isNCQ - start
	public static List<Product2> getrelatedproductList (set<Id> productSet){
		List<Product2> productList = [select Id,CPQ_Activity_Type__c,CPQ_Budget_Hrs__c,CPQ_Description__c,CPQ_Network_Activity__c,CPQ_T_L__c,CPQ_Work_Center__c,Business_Group__c,NokiaCPQ_State__c from Product2 where Id in :Productset];//modified by jithin to add fields Business_Group__c, NokiaCPQ_State__c
		
		return productList;
	}
	//added by jithin - isNCQ - end

	//Surround CQ Req: May Release - start
	public static Map<Id, CPQ_FRUCustItemCdMap__c> getCustomerItemCodeMap (set<Id> productSet, Id accounntId){
		Map<Id, CPQ_FRUCustItemCdMap__c> customerItemCodeByProductMap = new Map<Id, CPQ_FRUCustItemCdMap__c>();
		Id CICRecordTypeId = Schema.SObjectType.CPQ_FRUCustItemCdMap__c.getRecordTypeInfosByDeveloperName().get('CIC').getRecordTypeId();
		List<CPQ_FRUCustItemCdMap__c> cicList = [
			SELECT 
	Id,CPQ_Account__c,CPQ_Product__c,CPQ_Customer_Item_Code__c,CPQ_Active__c 
			FROM CPQ_FRUCustItemCdMap__c 
			WHERE CPQ_Account__c = :accounntId AND CPQ_Product__c in :Productset AND CPQ_Active__c = true AND RecordTypeId = :CICRecordTypeId
		];
		
		for(CPQ_FRUCustItemCdMap__c cic : cicList) {
			customerItemCodeByProductMap.put(cic.CPQ_Product__c, cic);
		}
		return customerItemCodeByProductMap;
	}

	public static List<Apttus_Config2__PriceListItem__c> getContractedPriceListItems (set<Id> productSet, List<String> agreementList, String currencyCode){
		List<Apttus_Config2__PriceListItem__c> contractedPriceListItems = new List<Apttus_Config2__PriceListItem__c>();
		if(productSet != null && !productSet.isEmpty() && agreementList != null && !agreementList.isEmpty()) {
			DateTime currentTime = System.now();
			List<Apttus_Config2__PriceListItem__c> activePlIs = [
	SELECT
		Id,CPQ_Agreement_Number__c,Apttus_Config2__ListPrice__c,Apttus_Config2__ContractPrice__c,Apttus_Config2__ProductId__c,CPQ_Conditional_Price_Code__c,Apttus_Config2__EffectiveDate__c,Apttus_Config2__ExpirationDate__c
	FROM Apttus_Config2__PriceListItem__c 
	WHERE CPQ_Agreement_Number__c IN :agreementList AND Apttus_Config2__ProductId__c IN :productSet AND Apttus_Config2__Active__c = true AND CurrencyIsoCode = :currencyCode
	//ORDER BY CPQ_Conditional_Price_Code__c ASC NULLS LAST
	ORDER BY CPQ_Conditional_Price_Code__c ASC NULLS LAST, LastModifiedDate  DESC
			];
			for(Apttus_Config2__PriceListItem__c pli : activePlIs) {
	Boolean validPLI = true;
	if(pli.Apttus_Config2__EffectiveDate__c != null && pli.Apttus_Config2__EffectiveDate__c > currentTime) {
		validPLI = false;
	}
	if(pli.Apttus_Config2__ExpirationDate__c != null && pli.Apttus_Config2__ExpirationDate__c < currentTime) {
		validPLI = false;
	}
	if(validPLI) {
		contractedPriceListItems.add(pli);
	}
			}
		}
		return contractedPriceListItems;
	}
	
	public static Map<Id, Apttus_Config2__PriceListItem__c> getGlobalPriceListItems (set<Id> productSet, Id globalPriceListId){
		Map<Id, Apttus_Config2__PriceListItem__c> globalPLIByProductId = new Map<Id, Apttus_Config2__PriceListItem__c>();
		List<Apttus_Config2__PriceListItem__c> globalPLIList = [
			SELECT
		Id,CPQ_Agreement_Number__c,Apttus_Config2__ListPrice__c,Apttus_Config2__ProductId__c
	FROM Apttus_Config2__PriceListItem__c 
	WHERE Apttus_Config2__PriceListId__c = :globalPriceListId AND Apttus_Config2__ProductId__c IN :productSet AND Apttus_Config2__Active__c = true
		];
		for(Apttus_Config2__PriceListItem__c pli : globalPLIList) {
			globalPLIByProductId.put(pli.Apttus_Config2__ProductId__c, pli);
		}
		return globalPLIByProductId;
	}
	public static Map<String, CPQ_ContractConditionDisc__c> getApplicableILDs(set<String> ppCodes, List<String> agreementList) {
		Map<String, CPQ_ContractConditionDisc__c> ildEntryByPPCode = new  Map<String, CPQ_ContractConditionDisc__c>();
		Id CICRecordTypeId = Schema.SObjectType.CPQ_ContractConditionDisc__c.getRecordTypeInfosByDeveloperName().get('ILD').getRecordTypeId();
		if(ppCodes != null && !ppCodes.isEmpty() && agreementList != null && !agreementList.isEmpty()) {
			DateTime currentTime = System.now();
			List<CPQ_ContractConditionDisc__c> ildList = [
	SELECT
		Id,CPQ_Code__c,CPQ_Description__c,CPQ_Discount_Type__c,CPQ_Discount_Value__c,CPQ_Start_Date__c,CPQ_End_Date__c
	FROM CPQ_ContractConditionDisc__c 
	WHERE CPQ_Agreement_Number__c IN :agreementList AND CPQ_Code__c IN :ppCodes AND CPQ_Active__c = true
			];
			for(CPQ_ContractConditionDisc__c ildEntry : ildList) {
	Boolean validILD = true;
	if(ildEntry.CPQ_Start_Date__c != null && ildEntry.CPQ_Start_Date__c > currentTime) {
		validILD = false;
	}
	if(ildEntry.CPQ_End_Date__c != null && ildEntry.CPQ_End_Date__c < currentTime) {
		validILD = false;
	}
	if(validILD) {
		ildEntryByPPCode.put(ildEntry.CPQ_Code__c, ildEntry);
	}
			}
		}
		return ildEntryByPPCode;
	}
	
	public static List<CPQ_QuoteContractualDiscount__c> getQuoteContractualDiscounts(Id quoteId) {
		return [
			SELECT
	Id, CPQ_Contractual_Disc_Method__c, CPQ_Code__c, CPQ_Description__c, CPQ_Discount_Type__c, CPQ_Discount_Value__c
			FROM CPQ_QuoteContractualDiscount__c
			WHERE CPQ_Proposal__c = :quoteId
			ORDER BY CPQ_Sequence__c ASC NULLS LAST
		];
	}

	public static Map<String, CPQ_TransportMap__c> getApplicableTansportRates(Id accountId, Set<Id> hardwareProductIds) {
		Map<String, CPQ_TransportMap__c> transportPecentByProduct = new Map<String, CPQ_TransportMap__c>();
		List<CPQ_TransportMap__c> tranportList = [
			SELECT id, CPQ_Product__c, CPQ_Transport_Percent__c
			FROM CPQ_TransportMap__c
			WHERE CPQ_Account__c = :accountId AND (CPQ_Product__c IN :hardwareProductIds OR CPQ_Product__c = null) AND CPQ_Active__c = true
		];
		for(CPQ_TransportMap__c transport : tranportList) {
			if(String.isBlank(transport.CPQ_Product__c)) {
	transportPecentByProduct.put(Nokia_CPQ_Constants.DEFAULT_TRANSPORT_RATE, transport);
			} else {
	transportPecentByProduct.put(transport.CPQ_Product__c, transport);
			}
		}
		return transportPecentByProduct;
	}
	//Surround CQ Req: May Release - end
	
}