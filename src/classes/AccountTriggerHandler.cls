/****************************************
 * Class Name : AccountTriggerHandler
 * Created Date: 27 December 2016
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 27 December 2016
 * Description : Handle the sequence of the AccountTriggerHelper
 * Test Class: 
 *****************************************/
public with sharing class AccountTriggerHandler{
	/********************
	*Method Name: beforeInsertOperation
	*Parameter: Account List
	*Description: Used to handle before Insert activities
	  1. Choose default legal entity
	*******************/
	public static void beforeInsertOperation(List<Account> accountList){ 
		 //Get List of LegalEntity
		 List<Account> legalEntityList = AccountTriggerHelper.computeLegalEntityList(accountList);
		 //Get List of CustomerAccounts
		 //List<Account> customerList = AccountModifier.computeCustomerList(accountList);
		 
		 System.debug('Inside AccountTriggerHandler.beforeInsertOperation .....'+ legalEntityList);
		 if(legalEntityList.size()>0){
	if(GlobalConstants.isDefaultUpdated){
	 GlobalConstants.isDefaultUpdated = false;
	 AccountTriggerHelper.chooseDefaultLegalEntity(legalEntityList);
	}
		 }
		 System.debug('GlobalConstants.NEW_ACCOUNT ........'+GlobalConstants.NEW_ACCOUNT);	  
		 GlobalConstants.NEW_ACCOUNT=true;
		 System.debug('GlobalConstants.NEW_ACCOUNT ........'+GlobalConstants.NEW_ACCOUNT);
	 } 
	 
	/********************
	*Method Name: beforeUpdateOperation
	*Parameter: Account List
	*Description: Used to handle before Update activities
	 1. Choose default legal entity
	*******************/
	 public static void beforeUpdateOperation(List<Account> accountList){ 
		 //Get List of LegalEntity
		 List<Account> legalEntityList = AccountTriggerHelper.computeLegalEntityList(accountList);	   
		 System.debug('Inside AccountTriggerHandler.beforeUpdateOperation .....'+ legalEntityList);
		 if(legalEntityList.size()>0){
	if(GlobalConstants.isDefaultUpdated){
	 GlobalConstants.isDefaultUpdated = false;
	 list<Account> validLElist = AccountTriggerHelper.validateDefaultLegalEntity(legalEntityList);
	 AccountTriggerHelper.chooseDefaultLegalEntity(validLElist);
	}
		 }
	 }

	 
	/********************
	*Method Name: afterInsertOperation
	*Parameter: Account List
	*Description: Used to handle after Insert activities
	  1. Add legal entity in to territory same as parent customer
	  2. Check if existing Default is inactive then make new active legal Entity as default
	*******************/
	public static void afterInsertOperation(List<Account> accountList){ 
		 //Get List of LegalEntity
		 List<Account> legalEntityList = AccountTriggerHelper.computeLegalEntityList(accountList);
		 
		 System.debug('Inside AccountTriggerHandler.afterInsertOperation .....'+ legalEntityList);
		 if(legalEntityList.size()>0){
	if (!System.isBatch()){
	System.enqueueJob(new AddLegalEntitiesInTerritory(legalEntityList));
	}
	else {
	 AddingLegalEntitiesInTerritory addEntities = new AddingLegalEntitiesInTerritory();
	 addEntities.AddLegalEntitiesInTerritory(legalEntityList);
	}
	 
	//Requirement: 870
			// Add account legalentity and end customer legal entity in opportunities which does not have any.
			AccountTriggerHelper.updateOpportunityLegaEnitities(legalEntityList);
			
			if (!System.isBatch()){
			System.enqueueJob(new CheckAndChangeDefaultLegalEntity(legalEntityList));
	}
	
	else {
	 CheckChangeDefaultLegalEntity checkLE = new CheckChangeDefaultLegalEntity();
	 checkLE.CheckAndChangeDefaultLegalEntity(legalEntityList);
	}
		 }
		 
		 List<String> prospectIdList = AccountTriggerHelper.computeProspectList(accountList);
		 if(prospectIdList.size()>0){
	ProspectCreationCallout.createbulkProspect(prospectIdList);
		 }
	GlobalConstants.NEW_ACCOUNT=true;
	 }
	 
	/********************
	*Method Name: afterUpdateOperation
	*Parameter: Account List
	*Description: Used to handle after Insert activities
	  1. Add legal entity in to territory same as parent customer
	*******************/
	public static void afterUpdateOperation(List<Account> accountList, Map<ID, Account> accNewMap, Map<ID, Account> accOldMap){ 
		 //Get List of LegalEntity
		 List<Account> legalEntityList = AccountTriggerHelper.computeLegalEntityList(accountList);
		 List<Account> validLegalEntityList = AccountTriggerHelper.checkParentIdChanges(legalEntityList);
		 
		 System.debug('Inside AccountTriggerHandler.afterUpdateOperation .....'+ legalEntityList);
		 if(validLegalEntityList.size()>0){
	if (!System.isBatch()){
	System.enqueueJob(new AddLegalEntitiesInTerritory(validLegalEntityList));
	}
	else {
	 AddingLegalEntitiesInTerritory addEntities = new AddingLegalEntitiesInTerritory();
	 addEntities.AddLegalEntitiesInTerritory(validLegalEntityList);
	}
	
			//Requirement: 870
			// Add account legalentity and end customer legal entity in opportunities which does not have any.
			AccountTriggerHelper.updateOpportunityLegaEnitities(validLegalEntityList);
		}
		 if(legalEntityList.size()>0){
			System.debug('Inside validateLEDeactivation Handler.....' );
			AccountTriggerHelper.validateLEDeactivation(legalEntityList,accOldMap);
		}
		//Sales Process: 741
		//Need to bypass for data loader profile only
		/*if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			AccountTriggerHelper.updateOpptyOnAccUpdate(accNewMap, accOldMap);
		}*/
		if (!System.isBatch() ) {
			System.enqueueJob(new CH_UpdateServiceContractSharingAsync(accOldMap, accNewMap));
		} else {
			CH_UpdateServiceContractSharing.execute(accOldMap, accNewMap);
		}
	}
	
	 /********************
	*Method Name: restrictEnablingPartner
	*Parameter: Account List
	*Description: Used to handle after Insert activities
	  2. Added below block of code for sending email notification to PSM user as per PRM project.
	  1. Block users from enabling a partner if Account Record Type is Legal Entity
	*******************/
	//Commented by Karthika for Code optimization as this method is not in use.
   /* public static void restrictEnablingPartner(List<Account> acclist) {
		Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosById();
		for(Account a : acclist) {
			if (rtMap.get(a.RecordTypeId).getName().equals(PRMGlobalConstants.LEGAL_ENTITY) && a.IsPartner) {
			a.addError(System.Label.Restrict_Enabling_Partner_Error_Message);
	 }  
		}
	}*/
	
	/********************
	*Method Name: beforeOperation
	*Parameter: Account List
	*Description: Used to populate values in Market and country code
	*******************/
	public static void beforeOperation(List<Account> accList){ 
	Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosById();
	
	try{
	for(Account acc : accList){
	
	
	 System.debug('The record type.....' + acc.RecordType.Name);
	 if((rtMap.get(acc.RecordTypeId).getName().equals(GlobalConstants.ACC_PROSPECT) || rtMap.get(acc.RecordTypeId).getName().equals(GlobalConstants.ACC_Logistic)) && acc.Billingcountrycode!=NULL){
	system.debug('countrycode....'+acc.Billingcountrycode);
	system.debug('country....'+acc.BillingCountry);
	if(acc.Market__c == null){
		acc.Market__c = ISO_Country_Codes__c.getvalues(acc.BillingCountryCode).Market__c;
	}
	else if(acc.Market__c  != ISO_Country_Codes__c.getvalues(acc.BillingCountryCode).Market__c){
		
		//SF Ticket 00276074- Added 'NE Americas' in below condition
		if(acc.Market__c != 'NE Americas' && acc.Market__c != 'NE EMEA & APAC' && acc.Market__c != 'NE Web' && acc.Market__c != 'NNO Others'){
			acc.addError(System.Label.Incorrect_Market_Value + ' ' +ISO_Country_Codes__c.getvalues(acc.BillingCountryCode).Country_Name__c+ ' ' + System.Label.Is + ' ' + ISO_Country_Codes__c.getvalues(acc.BillingCountryCode).Market__c);
		}
	}
	acc.Country__c= ISO_Country_Codes__c.getvalues(acc.BillingCountryCode).country_name__c;
	acc.CountryCode__c = acc.BillingCountryCode;
	acc.State__c = acc.BillingState;
	}
	 }
	 }   
	catch(Exception exc){
	 ExceptionHandler.addException(exc, GlobalConstants.ACCOUNT_TRIGGER_HANDLER, GlobalConstants.ACCOUNT_TRIGGER_HANDLER_BEFORE_OP );
	}
		 
	
	  }
	  
	/*
	* @description	Check BusinessPartnerRole field update on account.
	* @param			newAct new account updated data, oldAct old account data befor update
	* @return	
	*/
	public static void afterUpdateSupplierOperation(Map<Id,Account> newAct, Map<Id,Account> oldAct){
		AccountTriggerHelper.SupplierEmailAlert(newAct, oldAct);
	}
}