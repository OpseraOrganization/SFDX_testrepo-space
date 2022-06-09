/* --------------------------------------------------------------------------------------------------------------------------------------------------------
	Name:	NokiaCPQ_CreateQuote_Controller
	Description:	 Controller Class for Create Quote Quick Action in Opportunity .
	Date	Version  Author			  Summary of Changes
	-----------   ----------   -----------------	 ---------------------------------------------------------------------------------------
	18 Aug 2021   1.0   Christie JJ				  Pre-Aplha version.
	15 Jan 2022   1.1   Christie JJ		 FN Restructing Changes
	---------------------------------------------------------------------------------------------------------------------------------------------------------- */

public without sharing class NokiaCPQ_CreateQuote_Controller {

//Container Class Added by Christie JJ for ITCCPQ-2555 for getting the serialized quote object.
public class ProposalDataContainer{
	 
	@AuraEnabled  public String Name{get;set;}
	@AuraEnabled  public String OppId{get;set;}
	@AuraEnabled  public String warrantyCredit{get;set;}
	@AuraEnabled  public String contractDate{get;set;}
	@AuraEnabled  public Boolean sysContract{get;set;}
	@AuraEnabled  public String AccId{get;set;}
	@AuraEnabled  public String Description{get;set;}
	@AuraEnabled  public Boolean isMaintenance{get;set;}
	@AuraEnabled  public Boolean leo{get;set;}
	@AuraEnabled  public String Portfolio{get;set;}
	@AuraEnabled  public String subportfolios{get;set;}
	@AuraEnabled  public String quoteEMT{get;set;}
	@AuraEnabled  public String currencyCode{get;set;}
 
}

@AuraEnabled
public static Opportunity getOpportunityFields (String opportunityId) {

	List<Opportunity> opportunityRecord;
	if(opportunityId!=null) {
		opportunityRecord = [SELECT AccountId,End_Customer_LE__c,CurrencyIsoCode FROM Opportunity where Id =: opportunityId LIMIT 1];
	}

	if(!opportunityRecord.isEmpty())
		return opportunityRecord[0];
	return null;

}

@AuraEnabled
public static Boolean checkExistingContracts(String legalEntityAccountId, List<String> portfolio){
	// Set<string> buSet = new Set<string>();
	// Map<String, NokiaCPQ_Portfolio_Business_Mapping__mdt> portfolioMap = NokiaCPQ_Portfolio_Business_Mapping__mdt.getAll();
	// for(String key : portfolioMap.keySet()) {
	// 	if(portfolioMap.get(key).NokiaCPQ_Portfolios__c.contains(portfolio)) {
	// 		//businessUnit = portfolioMap.get(nameEmailDomain).NokiaCPQ_CH_Business_Unit__c;
	// 		buSet.add(portfolioMap.get(key).NokiaCPQ_CH_Business_Unit__c);
	// 	}
	// }
	// if(!buSet.isEmpty()) {
	// 	return ([SELECT Id, ServiceContract.Id, ServiceContract.AccountId, ServiceContract.Account.Name, Product2.CH_Business_Unit__c FROM ContractLineItem WHERE ServiceContract.AccountId = : legalEntityAccountId and ServiceContract.NCP_External_Status__c = 'Active' and ServiceContract.Status = 'Active' and ServiceContract.RecordType.Name in ('CARE Service Contract') and Product2.CH_Business_Unit__c IN :buSet LIMIT 1].size()>0);
	// }
	// return false;

	// Modified for ITCCPQ-2555, by Christie JJ
	return Nokia_CPQ_Utility.hasExistingMaintenanceContractList(legalEntityAccountId, portfolio);
}
@AuraEnabled
public static String getOrgUrl(){
	return URL.getSalesforceBaseUrl().toExternalForm();
}

//Modified for ITCCPQ-2555, by Chrisitie JJ , for including the sub-portfolio values.
@AuraEnabled
//public static Apttus_Proposal__Proposal__c createQuoteRecord(String Name,String OppId,String warrantyCredit,String contractDate,Boolean sysContract,String AccId,String Description,Boolean isMaintenance,Boolean leo,String Portfolio,List<String> subportfolios,String quoteEMT,/*string quoteNYM,*/ string currencyCode /*,Boolean needsRepricing*/){
public static Apttus_Proposal__Proposal__c createQuoteRecord(String serializedData){

	ProposalDataContainer deserializedData =(ProposalDataContainer)System.JSON.deserialize(serializedData,ProposalDataContainer.class);

	
	Apttus_Proposal__Proposal__c qp = new Apttus_Proposal__Proposal__c();
	Apttus_Proposal__Proposal__c returnQp = new Apttus_Proposal__Proposal__c();

	/*
	//Customer Quote record create
	try{
		Id recid = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
		system.debug('[+] recid');
		System.debug(recid);
		system.debug('[+] date = '+contractDate);
		system.debug(contractDate);
		//Opportunity oppObj = oppList.get(0);
		qp.RecordTypeId =recid;
		qp.Apttus_Proposal__Proposal_Name__c = Name;
		qp.Apttus_Proposal__Account__c = AccId;
		qp.CurrencyIsoCode = currencyCode;
		qp.Apttus_Proposal__Opportunity__c = OppId;
		qp.Apttus_Proposal__Description__c = Description;
		qp.NokiaCPQ_Portfolio__c = Portfolio;
		qp.Warranty_credit__c = warrantyCredit;
		//qp.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = quoteQWM;
		//qp.NokiaCPQ_Maintenance_Type__c = quoteMT;
		qp.NokiaCPQ_Existing_IONMaint_Contract__c = quoteEMT;
		//qp.NokiaCPQ_No_of_Years__c =quoteNYM;
		qp.NokiaCPQ_LEO_Discount__c = leo;
		qp.NokiaCPQ_Is_Maintenance_Quote__c=isMaintenance;
		if(contractDate!=null && !String.isBlank(contractDate)) {
			qp.NokiaCPQ_Contract_Start_Date__c=Date.ValueOf(contractDate);
		}

		qp.NokiaCPQ_systemVerifiedContract__c=sysContract;

		//Added for ITCCPQ-2555 by Chrisitie JJ 
		if(!subportfolios.isEmpty() && subportfolios!=null && (subportfolios.size()!=1)){
			qp.CPQ_SubPortfolio__c = String.join(subportfolios,';');
		}
		else if((subportfolios.size()==1) && subportfolios[0]!=Portfolio){
			qp.CPQ_SubPortfolio__c = String.join(subportfolios,';');
		}
		/*if(needsRepricing){
	  qp.NokiaCPQ_Needs_Reprice__c=true;
	 }
		system.debug('Inserted Field values:'+qp);
		system.debug('[+] Record Type = '+qp.RecordType.Name);
		system.debug('[+] Quote type = '+qp.Quote_Type__c);
		insert qp;
		system.debug('Quote Id = : '+qp.Id);

		returnQp = [Select Id, Name,Quote_Type__c,RecordType.Name from Apttus_Proposal__Proposal__c where Id =: qp.Id ];
		system.debug('[+] Quote type = '+returnQp.Quote_Type__c);
		system.debug('[+] Record Type = '+returnQp.RecordType.Name);
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
	*/


	//Customer Quote record create
	try{
		Id recid = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
		system.debug('[+] recid');
		System.debug(recid);
		//Opportunity oppObj = oppList.get(0);
		qp.RecordTypeId =recid;
		qp.Apttus_Proposal__Proposal_Name__c = deserializedData.Name;
		qp.Apttus_Proposal__Account__c = deserializedData.AccId;
		qp.CurrencyIsoCode = deserializedData.currencyCode;
		qp.Apttus_Proposal__Opportunity__c = deserializedData.OppId;
		qp.Apttus_Proposal__Description__c = deserializedData.Description;
		qp.NokiaCPQ_Portfolio__c = deserializedData.Portfolio;
		qp.Warranty_credit__c = deserializedData.warrantyCredit;
		//qp.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = quoteQWM;
		//qp.NokiaCPQ_Maintenance_Type__c = quoteMT;
		qp.NokiaCPQ_Existing_IONMaint_Contract__c = deserializedData.quoteEMT;
		//qp.NokiaCPQ_No_of_Years__c =quoteNYM;
		qp.NokiaCPQ_LEO_Discount__c = deserializedData.leo;
		qp.NokiaCPQ_Is_Maintenance_Quote__c=deserializedData.isMaintenance;
		if(deserializedData.contractDate!=null && !String.isBlank(deserializedData.contractDate)) {
			qp.NokiaCPQ_Contract_Start_Date__c=Date.ValueOf(deserializedData.contractDate);
		}

		//Added for ITCCPQ-2555 by Chrisitie JJ 
		//qp.CPQ_SubPortfolio__c = String.join(deserializedData.subportfolios,';');
		/*if(deserializedData.subportfolios!=null && !deserializedData.subportfolios.isEmpty()  && (deserializedData.subportfolios.size()!=1)){
			qp.CPQ_SubPortfolio__c = String.join(deserializedData.subportfolios,';');
		}
		else if((deserializedData.subportfolios.size()==1) && deserializedData.subportfolios[0]!=deserializedData.Portfolio){
			qp.CPQ_SubPortfolio__c = String.join(deserializedData.subportfolios,';');
		}*/
		if(deserializedData.subportfolios!=null && !String.isBlank(deserializedData.subportfolios)){
			//qp.CPQ_SubPortfolio__c = String.join(deserializedData.subportfolios,';');
			qp.CPQ_SubPortfolio__c = deserializedData.subportfolios;
		}
		

		qp.NokiaCPQ_systemVerifiedContract__c=deserializedData.sysContract;
		system.debug('Inserted Field values:'+qp);
		system.debug('[+] Record Type = '+qp.RecordType.Name);
		system.debug('[+] Quote type = '+qp.Quote_Type__c);
		insert qp;
		system.debug('Quote Id = : '+qp.Id);

		returnQp = [Select Id, Name,Quote_Type__c,RecordType.Name from Apttus_Proposal__Proposal__c where Id =: qp.Id ];
		system.debug('[+] Quote type = '+returnQp.Quote_Type__c);
		system.debug('[+] Record Type = '+returnQp.RecordType.Name);
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
 * @author Christie JJ | 11-04-2021
 * @return String
 **/
@AuraEnabled
public static String getRecordType() {
	Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing utilObj = new Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing();
	return utilObj.fetchProposalRecordType();
}

/**
 * @description Fetches the related valid subportfolios from the portfolio mapping custom metadata & the related account accreditations' portfolios
 * @author Christie JJ | 01-06-2022
 * @return String
 **/
@AuraEnabled
public static List<String> getSubPortfolios(String portfolio,Id accountId) {
	Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing utilObj = new Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing();
	return utilObj.fetchSubPortfolios(portfolio,accountId);
	//return null;
}

}