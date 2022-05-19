/************************************************************************************************************ 
Class Name : QTO_QuoteProposalController
Test Class : QTO_QuoteProposalControllerTest
Created Date: 10/10/2021
Created by: Shaik, Johny
Description :Quote Proposal rest api  
*********************************************************************************************************/
@RestResource(urlMapping='/qto/quotes/*')
global without sharing class QTO_QuoteProposalController {
	//static Id quoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.QuoteRecordType).getRecordTypeId();
	static Id quoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CCRE_Proposal').getRecordTypeId();
	 
	static Map<String, Apttus__APTS_Agreement__c> agrMap = new Map<String,Apttus__APTS_Agreement__c>();
	static Map<String,Account> parentAccountMap=new map<String,Account> ();
	static Map<string,Opportunity> opportunityMap=new Map<string,Opportunity>();
	static Set<string> productCodeSet=new Set<string>();
	static Set<Id> parentIds = new Set<Id>();
	static Map<String, Product2> productCodeMap  = new Map<String, Product2>();
	static Map<String, String> agrPLMap = new Map<String, String>();
	static Map<String,Id> mapPaymentTermInfos = new Map<String,Id>();
	static Map<String, Apttus_Config2__PriceListItem__c> prodcutPriceListMap = new Map<String, Apttus_Config2__PriceListItem__c> ();
	 
	public static void populateQuoteInfo( List<Object> body) {
		System.debug('QUOTE CREATION : populateQuoteInfo ');

		List<String> accounts = new List<String>();
		List<String> opportunities = new List<String>();
		List<String> agreements = new List<String>();
	 
		for( Object record : body) {
			
			Map<String, Object> quotePayload = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(record));
			
			String account = quotePayload.containsKey('Apttus_Proposal__Account__c') ? String.valueOf(quotePayload.get('Apttus_Proposal__Account__c')) : NULL;
			if(!String.isBlank(account)) accounts.add(account);
			
			String opportunity = quotePayload.containsKey('Apttus_Proposal__Opportunity__c') ? String.valueOf(quotePayload.get('Apttus_Proposal__Opportunity__c')) : NULL;
			if(!String.isBlank(opportunity)) opportunities.add(opportunity);
			
			String agreementStr = quotePayload.containsKey('Agreement_Lookup__c') ? String.valueOf(quotePayload.get('Agreement_Lookup__c')) : NULL;
			if(!String.isBlank(agreementStr)) agreements.add(agreementStr);
			
			System.debug('QUOTE CREATION : accounts : '+ accounts);
			System.debug('QUOTE CREATION : opportunities : '+ opportunities);
			System.debug('QUOTE CREATION : agreements : '+ agreements);
			
			//Products
			Map<String, Object> lineItemsMap = (Map<String, Object>)quotePayload.get('Apttus_Proposal__R00N70000001yUfBEAU__r');
			System.debug('lineItemsMap >>>> '+ lineItemsMap);
			if(lineItemsMap <> null) {
	List<Object> lines = (List<Object>)lineItemsMap.get('records');
	for (Object rec : lines) {
		Map<String, Object> recMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(rec));
		if(recMap.containsKey('Product_Code__c') && !String.isBlank((String)recMap.get('Product_Code__c')))
			productCodeSet.add((String)recMap.get('Product_Code__c'));
	}
			}
		}
		//Accounts
		for(Account Acco: [SELECT Id,name,Parentid, Parent.ownerid, AccountNumber FROM Account WHERE AccountNumber IN: accounts]) {
			parentAccountMap.put(Acco.AccountNumber,Acco);
			parentIds.add(Acco.parentId);
		} 
		
		//Opportunities
		for(Opportunity Opp:[Select Id,name, Opportunity_ID__c,Reference_Opportunity__c, CurrencyIsoCode from Opportunity where Opportunity_ID__c IN: opportunities]) {
			opportunityMap.put(Opp.Opportunity_ID__c,Opp);
		}
		
		//Products
		if(!productCodeSet.isEmpty()) {
			for(Product2 productObj : [
	select id,ProductCode, Name  from Product2 where ProductCode in :productCodeSet Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()
			] ) {
	productCodeMap.put(productObj.ProductCode,productObj);
			}
		}
		
		
		
		//Agreements
		for(Apttus__APTS_Agreement__c agreement :[
			Select Id,Apttus_CMConfig__PaymentTermId__c,Apttus__Contract_Start_Date__c, Apttus__Contract_End_Date__c,Apttus__FF_Agreement_Number__c,
			Inco_Term_Description__c, Apttus__Related_Opportunity__r.Name, Apttus__Related_Opportunity__c,Apttus_CMConfig__PriceListId__c,Apttus_CMConfig__PriceListId__r.currencyIsoCode 
			from Apttus__APTS_Agreement__c where Apttus__FF_Agreement_Number__c IN : agreements
		]) {
			agrMap.put(Agreement.Apttus__FF_Agreement_Number__c, agreement);
			agrPLMap.put(Agreement.Apttus__FF_Agreement_Number__c, agreement.Apttus_CMConfig__PriceListId__c);
		}
		
		//Price List Items
		for(Apttus_Config2__PriceListItem__c plItem :[ 
			Select Id,Apttus_Config2__PriceListId__c,Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.ProductCode,
			Apttus_Config2__ProductId__r.Description,Apttus_Config2__PriceUom__c,
			Apttus_Config2__ListPrice__c, Apttus_Config2__ContractPrice__c, CurrencyIsoCode from Apttus_Config2__PriceListItem__c 
			WHERE  Apttus_Config2__PriceListId__c IN :agrPLMap.values()
		]) {
			prodcutPriceListMap.put(plItem.Apttus_Config2__ProductId__r.ProductCode, plItem);
		}
		
		//Payment Terms Map
		for(Apttus_Config2__PaymentTerm__c paymentTermSO : [SELECT Id, Name FROM Apttus_Config2__PaymentTerm__c]){
			mapPaymentTermInfos.put(paymentTermSO.Name,paymentTermSO.Id);			
		}
		
	}
	
	
	@HttpPost 
	global static ResponseWrapper quoteProposalCreation() {
		System.debug('QUOTE CREATION :  POST API CALL');
		RestRequest req = RestContext.request; //the RestRequest for the Apex REST method
		ResponseWrapper responseJSON = new ResponseWrapper(); //responseWrapper object for API response
		List<Object> body = new List<Object>(); //placeholder for the JSON Body of the request
		Boolean thirdBR = true;
		List<Object> updatedQuotes = new List<Object>();
		String jsonBody = req.requestBody.toString(); //the body of the request
		//responseJSON = serializeQuotePayload(jsonBody) ;
		
		if (!String.isBlank(jsonBody)) { //if the request body is NOT white space, empty ('') or null
			body = (List<Object>)JSON.deserializeUntyped(jsonBody); //deserializes the JSON string 
			populateQuoteInfo(body);
			for(Object record : body) {
	Map<String, Object> quotePayload = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(record));
	
	//System.debug('QUOTE CREATION parentAccountMap: '+ parentAccountMap);
	//System.debug('QUOTE CREATION agrMap: '+ agrMap);
	//System.debug('QUOTE CREATION parentIds: '+ parentIds);
	//System.debug('QUOTE CREATION opportunityMap: '+ opportunityMap);
	//System.debug('QUOTE CREATION products: '+ productCodeSet);
	//System.debug('QUOTE CREATION quotePayload: '+ quotePayload);
	//System.debug('QUOTE CREATION prodcutPriceListMap: '+ prodcutPriceListMap);
	//System.debug('QUOTE CREATION productCodeMap: '+ productCodeMap);  
	
	String opportunity = String.valueOf(quotePayload.get('Apttus_Proposal__Opportunity__c'));
	String agreement = String.valueOf(quotePayload.get('Agreement_Lookup__c'));
	String account = String.valueOf(quotePayload.get('Apttus_Proposal__Account__c'));
	
	if((opportunityMap.Containskey(opportunity) && !String.isBlank(opportunity)) || (agrMap.containskey(agreement) && !String.isBlank(agreement))) {
		
		String parentAccountId = parentAccountMap.get(account).ParentId;
		String accountId = parentAccountMap.get(account).Id;
		
		if(!String.isBlank(parentAccountId)) {
			quotePayload.put('Apttus_Proposal__Account__c', parentAccountId);
			quotePayload.put('Sold_To_Party__c', accountId);
		}
		else {
			quotePayload.put('Apttus_Proposal__Account__c', accountId);
		}
		
		quotePayload.put('Apttus_Proposal__Approval_Stage__c', thirdBR ? CSWXGlobalConstant.Approved : CSWXGlobalConstant.draft);
		if(CSWXGlobalConstant.Approved == quotePayload.get('Apttus_Proposal__Approval_Stage__c')) 
			quotePayload.put('LOA_Status__c', CSWXGlobalConstant.Approved);
		
		String proposalName = opportunityMap.Containskey(opportunity) ? opportunityMap.get(opportunity).Name : agrMap.containskey(agreement)
			? agrMap.get(agreement).Apttus__Related_Opportunity__r.Name : Null;
		
		String opportunityId = opportunityMap.Containskey(opportunity) ? opportunityMap.get(opportunity).Id : agrMap.containskey(agreement)
			? agrMap.get(agreement).Apttus__Related_Opportunity__c: Null; 
		
		String currencyCode = opportunityMap.Containskey(opportunity) ? opportunityMap.get(opportunity).CurrencyIsoCode : agrMap.containskey(agreement)
			? agrMap.get(agreement).CurrencyIsoCode: Null; 
		
		if(!agrMap.isEmpty()) {
			
			System.debug('QUOTE CREATION  >> Agreement_Lookup__c ' + agrMap.containskey(agreement));   
			Date startDate = agrMap.get(agreement).Apttus__Contract_Start_Date__c;  
			Date endDate = agrMap.get(agreement).Apttus__Contract_End_Date__c;   
			String agrPaymentTerm = agrMap.get(agreement).Apttus_CMConfig__PaymentTermId__c; 
			String agrIncoTerm = agrMap.get(agreement).Inco_Term_Description__c; 
			
			String paymentTerm = quotePayload.Containskey('Apttus_QPConfig__PaymentTermId__c') ? String.valueOf(quotePayload.get('Apttus_QPConfig__PaymentTermId__c'))  : Null;
			String incoTerm = quotePayload.Containskey('Incoterms__c') ? String.valueOf(quotePayload.get('Incoterms__c'))  : Null;
			
			quotePayload.put('Contract_Start_Date__c', startDate);
			quotePayload.put('Contract_End_Date__c', endDate);
			
			if(String.isBlank(paymentTerm))
				quotePayload.put('Apttus_QPConfig__PaymentTermId__c', agrPaymentTerm);
			else
				quotePayload.put('Apttus_QPConfig__PaymentTermId__c', mapPaymentTermInfos.get(paymentTerm));
			
			if(String.isBlank(incoTerm))
				quotePayload.put('Incoterms__c', agrIncoTerm);
			else
				quotePayload.put('Incoterms__c', incoTerm);
			
			if(agrMap.containskey(agreement) && agrMap.get(agreement).Apttus_CMConfig__PriceListId__c <> null) {
				quotePayload.put('Apttus_QPConfig__PriceListId__c', agrMap.get(agreement).Apttus_CMConfig__PriceListId__c);
				quotePayload.put('CurrencyIsoCode', currencyCode);
			}
			quotePayload.put('Agreement_Lookup__c', agrMap.get(agreement).Id);
		}
		
		quotePayload.put('RecordTypeId', quoteRecordTypeId);
		quotePayload.put('Apttus_Proposal__Proposal_Name__c', proposalName);
		quotePayload.put('Apttus_Proposal__Opportunity__c', opportunityId);
		quotePayload.put('Apttus_Proposal__Valid_Until_Date__c', System.today().AddDays(28));
		
		//Products
		Map<String, Object> quoteLineItemsMap = (Map<String, Object>)quotePayload.get('Apttus_Proposal__R00N70000001yUfBEAU__r');
		if(quoteLineItemsMap <> null) {
			List<Object> quoteLines = (List<Object>)quoteLineItemsMap.get('records');
			List<Object> updatedQuoteLines = new List<Object>();
			
			for (Object rec : quoteLines) {
				Map<String, Object> quoteLineMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(rec));
				String productKey = quoteLineMap.containsKey('Product_Code__c') ? String.valueOf(quoteLineMap.get('Product_Code__c')) : NULL;
				System.debug('QUOTE CREATION productKey: '+ productKey);  
				String netUnitPrice = quoteLineMap.containsKey('Apttus_QPConfig__NetUnitPrice__c') ? String.valueOf(quoteLineMap.get('Apttus_QPConfig__NetUnitPrice__c')) : NULL;
				String netPrice = quoteLineMap.containsKey('Apttus_QPConfig__NetPrice__c') ? String.valueOf(quoteLineMap.get('Apttus_QPConfig__NetPrice__c')) : NULL;
				String unitOfMeasure = quoteLineMap.containsKey('Apttus_QPConfig__Uom__c') ? String.valueOf(quoteLineMap.get('Apttus_QPConfig__Uom__c')) : NULL;
				
				if(!String.isBlank(productKey) && (prodcutPriceListMap.containskey(productKey) && !prodcutPriceListMap.isEmpty())) {
		quoteLineMap.put('CurrencyIsoCode', currencyCode);
		quoteLineMap.put('Apttus_Proposal__Product__c', prodcutPriceListMap.get(productKey).Apttus_Config2__ProductId__c);
		quoteLineMap.put('Apttus_Proposal__Description__c', prodcutPriceListMap.get(productKey).Apttus_Config2__ProductId__r.Description);
		quoteLineMap.put('Apttus_QPConfig__PriceListItemId__c', prodcutPriceListMap.get(productKey).Id);
		
		if(String.isBlank(netUnitPrice))
			quoteLineMap.put('Apttus_QPConfig__NetUnitPrice__c', prodcutPriceListMap.get(productKey).Apttus_Config2__ListPrice__c);
		if(String.isBlank(netPrice))
			quoteLineMap.put('Apttus_QPConfig__NetPrice__c', prodcutPriceListMap.get(productKey).Apttus_Config2__ListPrice__c);
		 	if(String.isBlank(unitOfMeasure))
			quoteLineMap.put('Apttus_QPConfig__Uom__c', prodcutPriceListMap.get(productKey).Apttus_Config2__PriceUom__c);
		
		if(quoteLineMap.containskey('NokiaCPQ_Configuration_Type__c') && quoteLineMap.get('NokiaCPQ_Configuration_Type__c') == 'Standalone'){
			quoteLineMap.put('Apttus_QPConfig__OptionId__c', prodcutPriceListMap.get(productKey).Apttus_Config2__ProductId__c);
		}
		
		//Price related fields
		//quoteLineMap.put('Apttus_QPConfig__BasePrice__c', prodcutPriceListMap.get(productKey).Apttus_Config2__ListPrice__c);
		//quoteLineMap.put('NokiaCPQ_Extended_Cost__c', prodcutPriceListMap.get(productKey).Apttus_Config2__ListPrice__c);
		//quoteLineMap.put('Reference_Price__c', prodcutPriceListMap.get(productKey).Apttus_Config2__ListPrice__c);
		//quoteLineMap.put('Equivalent_Price__c', prodcutPriceListMap.get(productKey).Apttus_Config2__ListPrice__c);
		//quoteLineMap.put('Apttus_QPConfig__BaseExtendedPrice__c', prodcutPriceListMap.get(productKey).Apttus_Config2__ListPrice__c);
		//quoteLineMap.put('Nokia_Base_Price__c', prodcutPriceListMap.get(productKey).Apttus_Config2__ListPrice__c);
				}
				else {
		quoteLineMap.put('CurrencyIsoCode', currencyCode);
		quoteLineMap.put('Apttus_Proposal__Product__c', productCodeMap.containsKey(productKey) ? productCodeMap.get(productKey).Id : NULL);
		
		
				}
				updatedQuoteLines.add(quoteLineMap);
			}
			quoteLineItemsMap.put('records',updatedQuoteLines);
			quotePayload.put('Apttus_Proposal__R00N70000001yUfBEAU__r', quoteLineItemsMap);
		}
		updatedQuotes.add(quotePayload); 
		
	}
			}
			List<Apttus_Proposal__Proposal__c> deserializeObj = (List<Apttus_Proposal__Proposal__c>)JSON.deserialize(JSON.serialize(updatedQuotes), List<Apttus_Proposal__Proposal__c>.Class);
			system.debug('QUOTE CREATION : FINAL OBJ' + deserializeObj);
			responseJSON = saveQuotes(deserializeObj);
		}
		else {
			responseJSON.status = 'Failure';
			responseJSON.response = 'JSON body was empty or null ';
			return responseJSON;
		}
		return responseJSON; //return the JSON response
	}
	
	/*
	 *  Save Quote and Quote lines
	 */
	private static ResponseWrapper saveQuotes(List<Apttus_Proposal__Proposal__c> deserializeObj) {
		ResponseWrapper responseJSON = new ResponseWrapper(); //responseWrapper object for API response
		List<Apttus_Proposal__Proposal__c> quoteList = new List<Apttus_Proposal__Proposal__c>();
		for(Apttus_Proposal__Proposal__c quote: deserializeObj) {
			quoteList.add(quote);
		}
		insert quoteList;
		
		List<Customer_facing_Attribute__c> quoteCFAList = new List<Customer_facing_Attribute__c>();
		System.debug('QUOTE CREATION ===== CFA Creation ============');
		for(Customer_facing_Attribute__c cfa: deserializeObj[0].DS_customer_facing_Attributes__r) {
			cfa.Quote__c = quoteList[0].Id;
			quoteCFAList.add(cfa);
		}
		
		List<Apttus_Proposal__Proposal_Line_Item__c> quoteLineList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		for(Apttus_Proposal__Proposal_Line_Item__c line : deserializeObj[0].Apttus_Proposal__R00N70000001yUfBEAU__r) {
			line.Apttus_Proposal__Proposal__c = quoteList[0].Id;
			quoteLineList.add(line);
		}
		insert quoteLineList;
		Integer i = 0;
		for(Apttus_Proposal__Proposal_Line_Item__c quoteLine : deserializeObj[0].Apttus_Proposal__R00N70000001yUfBEAU__r) {
			for(Customer_facing_Attribute__c qlcfa : quoteLine.DS_customer_facing_Attributes__r){
	qlcfa.Quote_Line_Item__c = quoteLineList[i].Id;
	qlcfa.Quote__c = quoteList[0].Id;
	quoteCFAList.add(qlcfa);
			}
			i++;
		}
		insert quoteCFAList;
		responseJSON.response = Url.getOrgDomainUrl().toExternalForm() +'/'+quoteList[0].Id;
		return responseJSON;
	}
	   
	
	
	//wrapper class for the response to an API request
	global class ResponseWrapper {
		global String status {get;set;} //status string
		global String response {get;set;} //message string
		//global Object response {get;set;}
		
		//constructor
		global ResponseWrapper() {
			this.status = 'Quote/Proposal has been created Successfully..';
			this.response = '';
			////this.response = null;
		}
	}
}