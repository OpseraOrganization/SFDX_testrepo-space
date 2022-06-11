/**
 * @description	   : 
 * @author			: Yashdeep Prajapati
 * @group			 : 
 * @last modified on  : 12-03-2021
 * @last modified by  : Yashdeep Prajapati
**/
public without sharing class NokiaCPQ_newQuoteControllerclass {
@AuraEnabled
public static Apttus_Proposal__Proposal__c createQuoteRecordWM(String recordType,String Name,String OppId,String Description,String Portfolio,Boolean quoteQWM){
	Id recid = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId();
	List<Opportunity> oppList = [Select Id,accountId,CurrencyIsoCode,Legal_Entity__c,End_Customer__c from Opportunity where Id =: OppId];

	Apttus_Proposal__Proposal__c qp = new Apttus_Proposal__Proposal__c();
	Apttus_Proposal__Proposal__c returnQp = new Apttus_Proposal__Proposal__c();

	//Direct Customer Quote record create
	try{

		if(oppList != null && oppList.size() > 0) {
			Opportunity oppObj = oppList.get(0);
			qp.RecordTypeId =recid;
			qp.CurrencyIsoCode = oppObj.CurrencyIsoCode;
			qp.Apttus_Proposal__Proposal_Name__c = Name;
			qp.Apttus_Proposal__Opportunity__c = OppId;
			qp.Apttus_Proposal__Description__c = Description;
			qp.NokiaCPQ_Portfolio__c = Portfolio;
			//qp.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = quoteQWM;
			system.debug('Inserted Field values:'+qp);
			insert qp;
			system.debug('Quote Id = : '+qp.Id);
			returnQp = [Select Id, Name, Apttus_Proposal__Proposal_Name__c from Apttus_Proposal__Proposal__c where Id =: qp.Id ];
		}
		return returnQp;
	}
	catch(Exception e) {
		String message = e.getMessage();
		String errMsg = message.substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION:');
		String errMessage = errMsg.substringBefore(':');
		AuraHandledException auraError = new AuraHandledException(errMessage);
		throw auraError;
	}


}

@AuraEnabled
public static Apttus_Proposal__Proposal__c createQuoteRecord(String recordType,String Name,String OppId,String Description,String Portfolio,Boolean quoteQWM,String quoteMT,String quoteEMT,string quoteNYM){
	Id recid = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();
	List<Opportunity> oppList = [Select Id,accountId,CurrencyIsoCode,Legal_Entity__c,End_Customer__c from Opportunity where Id =: OppId];

	Apttus_Proposal__Proposal__c qp = new Apttus_Proposal__Proposal__c();
	Apttus_Proposal__Proposal__c returnQp = new Apttus_Proposal__Proposal__c();

	//Direct Customer Quote record create
	try{
		if(oppList != null && oppList.size() > 0) {
			Opportunity oppObj = oppList.get(0);
			qp.RecordTypeId =recid;
			qp.Apttus_Proposal__Proposal_Name__c = Name;
			qp.CurrencyIsoCode = oppObj.CurrencyIsoCode;
			qp.Apttus_Proposal__Opportunity__c = OppId;
			qp.Apttus_Proposal__Description__c = Description;
			qp.NokiaCPQ_Portfolio__c = Portfolio;
			qp.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = quoteQWM;
			qp.NokiaCPQ_Maintenance_Type__c = quoteMT;
			qp.NokiaCPQ_Existing_IONMaint_Contract__c = quoteEMT;
			qp.NokiaCPQ_No_of_Years__c =quoteNYM;
			system.debug('Inserted Field values:'+qp);
			insert qp;
			system.debug('Quote Id = : '+qp.Id);
			returnQp = [Select Id, Name, Apttus_Proposal__Proposal_Name__c from Apttus_Proposal__Proposal__c where Id =: qp.Id ];
		}
		return returnQp;
	}
	catch(Exception e) {
		String message = e.getMessage();
		System.debug('message' + message);
		String errMsg = message.substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION,');
		String errMessage = errMsg.substringBefore(':');
		AuraHandledException auraError = new AuraHandledException(errMessage);
		throw auraError;
	}
}

@AuraEnabled
public static Apttus_Proposal__Proposal__c createQTCQuoteCPQRecord(String recordType,String Name,String OppId,String Description,Date DueDate,String Notes,Boolean MasterQuote,
																   Integer MQuoteQuantity,String CustProcode,String CustOrgSeg,String CustReqNum,String SalesLead,String CustProSiteCity,
																   String CustProSiteState,String AccLegalEntity,String QuoteLead, String pricingPoolVal, String priceConVal, String priceConCodeVal){
	Id recid = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId();
	List<Opportunity> oppList = [Select Id,CreatedById,accountId,CurrencyIsoCode,Legal_Entity__c,End_Customer__c,OwnerId from Opportunity where Id =: OppId];

	//New QTC Quote- CPQ record creation
	Apttus_Proposal__Proposal__c qp = new Apttus_Proposal__Proposal__c();
	Apttus_Proposal__Proposal__c returnQp = new Apttus_Proposal__Proposal__c();

	try{
		if(oppList != null && oppList.size() > 0) {
			Opportunity oppObj = oppList.get(0);

			qp.RecordTypeId =recid;
			qp.Apttus_Proposal__Proposal_Name__c = Name;
			qp.CurrencyIsoCode = oppObj.CurrencyIsoCode;
			qp.Apttus_Proposal__Opportunity__c = OppId;
			qp.Apttus_Proposal__Description__c = Description;
			qp.CQ_Due_Date__c =  DueDate;
			qp.CQ_Notes__c= Notes;
			qp.CQ_Master_Quote__c = MasterQuote;
			qp.CQ_Master_Quote_Quantity__c=MQuoteQuantity;
			qp.Apttus_Proposal__Account__c =oppObj.AccountId;
			qp.Account_Legal_Entity__c = AccLegalEntity;
			qp.CQ_Customer_Project_Code__c=CustProcode;
			qp.CQ_Customer_Organization_Segment__c=CustOrgSeg;
			qp.CQ_Customer_Request_Number__c=CustReqNum;
			qp.CQ_Sales_Lead__c=SalesLead;
			qp.CQ_Customer_Project_Site_City__c= CustProSiteCity;
			qp.CQ_Lead__c= QuoteLead;
			qp.CQ_Customer_Project_Site_State__c=CustProSiteState;
			qp.CPQ_Pricing_Pool__c = pricingPoolVal;
			qp.CPQ_Contractual_Price_Condition__c = priceConVal;
			qp.CPQ_Contractual_Price_Condition_Code__c = priceConCodeVal;
			system.debug('Inserted Field values:'+qp);
			insert qp;
			system.debug('Quote Id = : '+qp.Id);
			returnQp = [Select Id, Name, Apttus_Proposal__Proposal_Name__c from Apttus_Proposal__Proposal__c where Id =: qp.Id ];
		}
		return returnQp;
	}
	catch(Exception e) {
		String finalMessage = '';
		String message = e.getMessage();
		if(message.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
			String errMsg = message.substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION');
			finalMessage = errMsg.substringBefore('.');
		}
		if(String.isBlank(finalMessage)) {
			finalMessage = message;
		}
		AuraHandledException auraError = new AuraHandledException(finalMessage);
		throw auraError;
	}

}


@AuraEnabled
public static Apttus_Proposal__Proposal__c createQTCQuoteSPTRecord(String recordType,String Name,String OppId,String sptOpp,Decimal sptQuotVal,String sptDescription,Date sptDueDate,String sptNotes,Boolean sptMasterQuote,Decimal sptMQquantity,String sptAccLegEntity,string sptCustProCode,String sptCustOrgSeg,String sptCustReqNum,String sptSalesLead,String sptCustProSC,String sptQuoteLead,String sptCustProSS,String sptServComp){
	Id recid = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId();
	List<Opportunity> oppList = [Select Id,accountId,CurrencyIsoCode,Legal_Entity__c,End_Customer__c from Opportunity where Id =: OppId];

	Apttus_Proposal__Proposal__c qp = new Apttus_Proposal__Proposal__c();
	Apttus_Proposal__Proposal__c returnQp = new Apttus_Proposal__Proposal__c();

	//Direct Customer Quote record create for Surround PT
	try{
		if(oppList !=Null ||oppList.size()>0) {
			Opportunity oppObj = oppList.get(0);

			qp.RecordTypeId =recid;
			qp.CurrencyIsoCode = oppObj.CurrencyIsoCode;
			qp.Apttus_Proposal__Proposal_Name__c = Name;
			qp.Apttus_Proposal__Opportunity__c = sptOpp;
			qp.CQ_Due_Date__c =  sptDueDate;
			qp.Apttus_Proposal__Account__c=oppObj.accountId;
			qp.CQ_Value__c = sptQuotVal;
			qp.Apttus_Proposal__Description__c = sptDescription;
			qp.CQ_Notes__c = sptNotes;
			qp.CQ_Master_Quote__c=sptMasterQuote;
			qp.CQ_Master_Quote_Quantity__c = sptMQquantity;
			qp.Account_Legal_Entity__c=sptAccLegEntity;
			qp.CQ_Customer_Project_Code__c  =	   sptCustProCode;
			qp.CQ_Customer_Organization_Segment__c= sptCustOrgSeg;
			qp.CQ_Customer_Request_Number__c = sptCustReqNum;
			qp.CQ_Sales_Lead__c=sptSalesLead;
			qp.CQ_Customer_Project_Site_City__c =sptCustProSC;
			qp.CQ_Lead__c=sptQuoteLead;
			qp.CQ_Customer_Project_Site_State__c=sptCustProSS;
			qp.CQ_Servies_components__c  = sptServComp;
			system.debug('Inserted Field values:'+qp);
			insert qp;
			system.debug('Quote Id = : '+qp.Id);
			returnQp = [Select Id, Name, Apttus_Proposal__Proposal_Name__c from Apttus_Proposal__Proposal__c where Id =: qp.Id ];
		}
		return returnQp;

	}
	catch(Exception e) {
		String finalMessage = '';
		String message = e.getMessage();
		if(message.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
			String errMsg = message.substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION');
			finalMessage = errMsg.substringBefore('.');
		}
		if(String.isBlank(finalMessage)) {
			finalMessage = message;
		}
		AuraHandledException auraError = new AuraHandledException(finalMessage);
		throw auraError;
	}


}

@AuraEnabled
public static List<Opportunity> getOpportunityRecord(String recordId){
	List<Opportunity> oppList = [Select Id,OwnerId,accountId,LastModifiedById,CurrencyIsoCode,Legal_Entity__c,End_Customer__c from Opportunity where Id =: recordId];
	return oppList;

}
@AuraEnabled
public static Id getRecTypeId(String recordTypeLabel){
	Id recid = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(recordTypeLabel).getRecordTypeId();
	return recid;
}

@AuraEnabled
public static String getBaseUrl()
{
	return URL.getSalesforceBaseUrl().toExternalForm();
}

//Target methodes

@AuraEnabled
public static List<CPQ_PricingPool__c> getPricingPool(String recordId){
	Opportunity opp = [Select Id, accountId, End_Customer__c from Opportunity where Id =: recordId LIMIT 1];

	List<CPQ_PricingPoolAccountMap__c> poolList = [SELECT Id, CPQ_Account__c, CPQ_Pricing_Pool_ID__c FROm CPQ_PricingPoolAccountMap__c WHERE CPQ_Account__c = :opp.AccountId AND CPQ_Active__c = true];
	List<Id> ppIds = new List<Id>();
	for(CPQ_PricingPoolAccountMap__c ppa : poolList) {
		ppIds.add(ppa.CPQ_Pricing_Pool_ID__c);
	}

	List<CPQ_PricingPool__c> ppList = [SELECT Id, Name, CPQ_Pricing_Pool_Name__c FROm CPQ_PricingPool__c WHERE Id IN :ppIds AND CPQ_Active__c = true];

	return ppList;
}

@AuraEnabled
public static List<CPQ_ContractConditionDisc__c> getPricingConditions(String recordId, String ppId){
	Opportunity opp = [Select Id, accountId, End_Customer__c from Opportunity where Id =: recordId LIMIT 1];

	List<CPQ_Pricing_Pool_Agreement_Map__c> ppAgrList = [SELECT Id, CPQ_Agreement_Name__c FROm CPQ_Pricing_Pool_Agreement_Map__c WHERE CPQ_Pricing_Pool_Id__c = :ppId AND CPQ_Active__c = true];
	List<Id> ppAgrIds = new List<Id>();
	for(CPQ_Pricing_Pool_Agreement_Map__c ppa : ppAgrList) {
		ppAgrIds.add(ppa.CPQ_Agreement_Name__c);
	}
	system.debug('--->1.1 '+ppAgrIds);


	List<CPQ_ContractConditionDisc__c> discList = new List<CPQ_ContractConditionDisc__c>();
	for(CPQ_ContractConditionDisc__c ccd:[SELECT Id, CPQ_Code__c,RecordType.name,CPQ_Start_Date__c,CPQ_End_Date__c,CPQ_Description__c FROM CPQ_ContractConditionDisc__c WHERE RecordType.name IN ('Conditional') AND CPQ_Agreement_Name__c IN :ppAgrIds AND CPQ_Active__c = true]) {

		if(ccd.CPQ_Start_Date__c != null && ccd.CPQ_End_Date__c != null && (date.today() >= ccd.CPQ_Start_Date__c && date.today() <= ccd.CPQ_End_Date__c)) {
			discList.add(ccd);
		}else if(ccd.CPQ_Start_Date__c != null && ccd.CPQ_End_Date__c == null && date.today() >= ccd.CPQ_Start_Date__c) {
			discList.add(ccd);
		}else if(ccd.CPQ_Start_Date__c == null && ccd.CPQ_End_Date__c != null && date.today() <= ccd.CPQ_End_Date__c) {
			discList.add(ccd);
		}else if(ccd.CPQ_Start_Date__c == null && ccd.CPQ_End_Date__c == null) {
			discList.add(ccd);
		}

	}

	system.debug('--->1.3 '+discList);
	return discList;


}

@AuraEnabled
public static WrapperData getPricingPoolOnQuote(String recordId){
	Apttus_Proposal__Proposal__c quote = [SELECT Id, Apttus_Proposal__Opportunity__c, CPQ_Pricing_Pool__c, CPQ_Contractual_Price_Condition__c FROm Apttus_Proposal__Proposal__c WHERE Id = :recordId];
	List<CPQ_PricingPool__c> ppList = getPricingPool(quote.Apttus_Proposal__Opportunity__c);

	WrapperData wrapper = new WrapperData();
	wrapper.quoteData = quote;
	wrapper.poolData = ppList;

	return wrapper;
}

@AuraEnabled
public static List<CPQ_ContractConditionDisc__c> getContractualDiscount(String recordId){


	Apttus_Proposal__Proposal__c quote = [SELECT Id, Apttus_Proposal__Opportunity__c, CPQ_Pricing_Pool__c, CPQ_Contractual_Price_Condition__c FROm Apttus_Proposal__Proposal__c WHERE Id = :recordId];
	List<CPQ_Pricing_Pool_Agreement_Map__c> ppAgrList = [SELECT Id, CPQ_Agreement_Name__c FROm CPQ_Pricing_Pool_Agreement_Map__c WHERE CPQ_Pricing_Pool_Name__c = :quote.CPQ_Pricing_Pool__c AND CPQ_Active__c = true];
	List<String> agreeNo = new List<String>();
	for(CPQ_Pricing_Pool_Agreement_Map__c ppa : ppAgrList) {
		agreeNo.add(ppa.CPQ_Agreement_Name__c);
	}

	List<CPQ_ContractConditionDisc__c> discList = new List<CPQ_ContractConditionDisc__c>();
	for(CPQ_ContractConditionDisc__c ccd:[SELECT Id, CPQ_Code__c,RecordType.name,CPQ_Start_Date__c,CPQ_End_Date__c,CPQ_Description__c FROM CPQ_ContractConditionDisc__c WHERE RecordType.name IN ('ICD','QLD') AND CPQ_Agreement_Name__c IN :agreeNo AND CPQ_Active__c = true order by CPQ_Description__c ASC NULLS LAST]) {
		if(ccd.CPQ_Start_Date__c != null && ccd.CPQ_End_Date__c != null && (date.today() >= ccd.CPQ_Start_Date__c && date.today() <= ccd.CPQ_End_Date__c)) {
			discList.add(ccd);
		}else if(ccd.CPQ_Start_Date__c != null && ccd.CPQ_End_Date__c == null && date.today() >= ccd.CPQ_Start_Date__c) {
			discList.add(ccd);
		}else if(ccd.CPQ_Start_Date__c == null && ccd.CPQ_End_Date__c != null && date.today() <= ccd.CPQ_End_Date__c) {
			discList.add(ccd);
		}else if(ccd.CPQ_Start_Date__c == null && ccd.CPQ_End_Date__c == null) {
			discList.add(ccd);
		}

	}
	system.debug('--->2 '+discList);
	return discList;

}

@AuraEnabled
public static void createQuoteContractualDiscount(String quoteId, String discId, Integer seqNo){
	if(discId != null && seqNo != null) {
		CPQ_QuoteContractualDiscount__c disc = new CPQ_QuoteContractualDiscount__c();
		disc.CPQ_Proposal__c = quoteId;
		disc.CPQ_QLD_ICD_ID__c = discId;
		disc.CPQ_Sequence__c = seqNo;
		insert disc;
	}
}

//Get saved QuoteContractualDiscount
@AuraEnabled
public static List<CPQ_QuoteContractualDiscount__c> getSavedQuoteContractualDiscount(Id recordId){

	List<CPQ_QuoteContractualDiscount__c> qcdList = new List<CPQ_QuoteContractualDiscount__c>();
	qcdList = [SELECT Id, CPQ_Code__c, CPQ_Sequence__c,CPQ_Contractual_Disc_Method__c,CPQ_Discount_Type__c,CPQ_Discount_Value__c,CPQ_Description__c FROM CPQ_QuoteContractualDiscount__c where CPQ_Proposal__c =: recordId];

	return qcdList;
}

//Delete QuoteContractualDiscount
@AuraEnabled
public static void deleteQuoteContractualDiscount(Id qcd){
	Delete [select id from CPQ_QuoteContractualDiscount__c where id =: qcd];
}

//Update QuoteContractualDiscount
@AuraEnabled
public static void updateQuoteContractualDiscount(List<CPQ_QuoteContractualDiscount__c> qcdList){
	update qcdList;
}
/**
 * @description Check if user is Licensed for Apttus_Proposal namespace
 * @author Yashdeep Prajapati | 10-19-2021
 * @param userId
 * @return boolean
 **/
@AuraEnabled
public static boolean isUserLicensedForCPQPackage(String userId) {
	Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing utilObj = new Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing();
	return utilObj.isUserLicensedForPackage(userId, 'Apttus_Proposal');
}

/**
 * @description Fetch Proposal RecordType Id
 * @author Christie JJ | 11-26-2021
 * @return String
 **/
@AuraEnabled
public static String getRecordType(String developerName) {
	Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing utilObj = new Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing();
	return utilObj.fetchProposalRecordType(developerName);
}


public class WrapperData {
@AuraEnabled
public Apttus_Proposal__Proposal__c quoteData;

@AuraEnabled
public List<CPQ_PricingPool__c> poolData;
}
}