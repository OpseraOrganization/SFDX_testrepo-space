/****************************************
 * Class Name : CreateOpportunityApexCtlr
 * Created Date: 24.7.2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 11.10.2017 
 * Description : 
 * Test Class: CreateOpportunityApexCtlrTest
 *****************************************/
public without sharing class CreateOpportunityApexCtlr {
	
	/********************
	*Method Name: getContact
	*Parameter: Contact Id
	*Description:  Fetch the contact Details need to display on opportunity creation form
	*******************/
	@AuraEnabled
	public static Contact getContact(Id contactId) {  
		 Contact con = [SELECT Firstname, Lastname, Account.name, Account.Id,Campaign_Name__c, Purchasing_Role__c, Account.BusinessPartnerRole__c FROM contact WHERE Id = :contactId];
		 //Requirement# 3583
		if(String.isBlank(con.Purchasing_Role__c)) {
			con.Purchasing_Role__c = GlobalConstants.BUSINESS_USER;
		}
		return con;
	}
	
	/********************
	*Method Name: getDefeultAccountRole
	*Parameter: String Id businessPartnerRole
	*Description:  Fetch the matching account role from businessPartnerRole (ft-128)
	*******************/
	@AuraEnabled
	public static String getDefaultAccountRole(String businessPartnerRole) {  
		String defualtARValue = CRM_CreateOpportunityApexCtlr.getAccountRoleDefaultValue(businessPartnerRole, CRM_CreateOpportunityApexCtlr.getAccountRoleMappings());
		return defualtArValue;
	}
	/********************
	*Method Name: getCampaign
	*Parameter: Contact Id
	*Description:  Fetch the campaign Details need to display on opportunity creation form
	*******************/
	@AuraEnabled
	public static Campaign getCampaign(Id contactId) {
		try{
	if(contactId!=NULL){
				Contact con =  [SELECT Id,Marketing_Campaign__c,MKT_AttributionCampaign__c,MKT_AttributionCampaign__r.Name FROM contact WHERE Id = :contactId];
				Campaign cmpgn;
				if(con.MKT_AttributionCampaign__c!=null)
				{
					cmpgn = [select Id,Name from Campaign where Id =: con.MKT_AttributionCampaign__c order by createddate limit 1];
				}
				else if(con.Marketing_Campaign__c!=null)
				{
					cmpgn = [select Id,Name from Campaign where Id =: con.Marketing_Campaign__c order by createddate limit 1];
				}
				if(cmpgn!=NULL){
					return cmpgn;
				}	 
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_CAMPAIGN );
		}
		return NULL;
	}
	
	/********************
	*Method Name: saveOpportunityWithContact
	*Parameter: Contact Id , campaignId , accountId , Oppotunity
	*Description:   Save the direct sales opportunity 
	*******************/
	@AuraEnabled
	public static Opportunity saveOpportunityWithContact(Opportunity oppty,Id contactId,Id campaignId,Id accountId,String contactRole) {
		system.debug('Oppty.....'+oppty);
		system.debug('contactId.....'+contactId);
		system.debug('campaignId.....'+campaignId);
		system.debug('accountId.....'+accountId);
		//try{
			oppty.AccountId = accountId;
			oppty.CampaignId = campaignId;
			oppty.StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			oppty.Phase_Status__c = GlobalConstants.PLANNED;
			oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
			oppty.closeDate = oppty.G5_Planned_Date__c;
			oppty.Contact_Source__c  = contactId;
			upsert oppty;
			
			Contact con = new Contact();
			con.Id = contactId;
			con.status__c = GlobalConstants.CLOSED_CONVERTED;
			update con;
		
			//insert Contact role
			OpportunityContactRole ocr = new OpportunityContactRole();
			ocr.ContactId = con.Id;
			ocr.IsPrimary = true;
			ocr.OpportunityId = oppty.Id;
			ocr.Role = contactRole;
			insert ocr;
		//}catch(Exception exc){
		//	ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.SAVE_OPPTY_WITH_CONTACT );
		//}
		return oppty;
	}
	/********************
	*Method Name: saveIndirectOpportunityWithContact
	*Parameter: Contact Id , campaignId , accountId , Oppotunity , endCustomerId
	*Description:	Save the indirect sales opportunity
	*******************/
	@AuraEnabled
	public static Opportunity saveIndirectOpportunityWithContact(Opportunity oppty,Id contactId,Id campaignId,Id accountId,Id endCustomerLEId,String contactRole) {
		// Perform isAccessible() and isUpdateable() checks here
		system.debug('Oppty.....'+oppty);
		system.debug('contactId.....'+contactId);
		system.debug('campaignId.....'+campaignId);
		system.debug('accountId.....'+accountId);
		//try{
			oppty.AccountId = accountId;
			oppty.CampaignId = campaignId;
			oppty.StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			oppty.closeDate = oppty.G5_Planned_Date__c;
			oppty.Phase_Status__c = GlobalConstants.PLANNED;
			oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
			oppty.End_Customer_LE__c= endCustomerLEId;
			oppty.Contact_Source__c  = contactId;
			upsert oppty;
			
			Contact con = new Contact();
			con.Id = contactId;
			con.status__c = GlobalConstants.CLOSED_CONVERTED;
			update con;
			
			//insert Contact role
			OpportunityContactRole ocr = new OpportunityContactRole();
			ocr.ContactId = con.Id;
			ocr.IsPrimary = true;
			ocr.OpportunityId = oppty.Id;
			ocr.Role = contactRole;
			insert ocr;
		//}catch(Exception exc){
		//	ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.SAVE_INOPPTY_WITH_CONTACT );
		//}
		return oppty;
	}
	
	 /********************
	*Method Name: getAllCurrencyValues
	*Parameter: 
	*Description:  Fetching all Currency Values from picklist
	*******************/
	@AuraEnabled
	public static Map<string,string> getAllCurrencyValues(){
		
		Map<string,string> currencies = new  Map<string,string>();
		map<String, Schema.SObjectField> fieldMap = CreateOpportunityApexCtlr.getFieldMap(); 
		try{
			// Get the list of picklist values for this field.
			list<Schema.PicklistEntry> values =
	fieldMap.get(GlobalConstants.CURRENCY_ISO_CODE ).getDescribe().getPickListValues();
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry a : values)
			{ 
	currencies.put(a.getLabel(), a.getValue()); 
			}
			}catch(Exception exc){
	ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_ALL_CURRENCY_VAL );
			}
		return currencies;
	}
	 /********************
	*Method Name: getAllOppTypesValues
	*Parameter: 
	*Description:  Fetching all opportunity types Bussiness Type Values from picklist
	*******************/
	@AuraEnabled
	public static Map<string,string> getAllOppTypesValues(){
		Map<string,string> oppTypes= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CreateOpportunityApexCtlr.getFieldMap();
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.BUSSINESS_TYPE).getDescribe().getPickListValues();
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry a : values)
			{ 
	oppTypes.put(a.getLabel(), a.getValue()); 
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_ALL_OPP_TYPES_VAL );
		 }
		return oppTypes;
	}
	
	/********************
	*Method Name: getAllContractSigningValues
	*Parameter: 
	*Description:  Fetching all  Contract Signing Values from picklist
	*******************/
	@AuraEnabled
	public static Map<string,string> getAllContractSigningValues(){
		Map<string,string> contractSigningEntities= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CreateOpportunityApexCtlr.getFieldMap();
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.CONTRACT_SIGNING).getDescribe().getPickListValues();
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry a : values){ 
	contractSigningEntities.put(a.getLabel(), a.getValue()); 
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_ALL_CONTRACT_SIGNING_VAL );
		 }
		return contractSigningEntities;
	}
	
	 /********************
	*Method Name: getAllAccountRoleValues
	*Parameter: 
	*Description:  Fetching all Account Role Values from picklist
	*******************/
	@AuraEnabled
	public static Map<string,string> getAllAccountRoleValues(){
		Map<string,string> accountRoles= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CreateOpportunityApexCtlr.getFieldMap();
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.ACCOUNT_ROLE).getDescribe().getPickListValues();
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry a : values){ 
	accountRoles.put(a.getLabel(), a.getValue()); 
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_ALL_CONTRACT_SIGNING_VAL );
		 }
		return accountRoles;
	}
	
	/********************
	*Method Name: getFieldMap
	*Parameter: 
	*Description:  common exection in fetching picklist values
	*******************/
	private static map<String, Schema.SObjectField> getFieldMap(){
		// Get the object type of the SObject.
		Schema.sObjectType objType = Opportunity.getSObjectType(); 
		// Describe the SObject using its object type.
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();	
		// Get a map of fields for the SObject
		return objDescribe.fields.getMap(); 
	}
	
	/********************
	*Method Name: getCurrentUserISOCode
	*Parameter: 
	*Description:  get currentUserISO code
	*******************/
	@AuraEnabled
	public static String getCurrentUserISOCode(){
		return userinfo.getDefaultCurrency();
	}	
}