/****************************************
 * Class Name : CRM_CreateOpportunityApexCtlr
 * Created Date: 01.10.2020
 * Created By : CO Team - Joao Rodrigues 
 * Description : 
 * Test Class: CRM_CreateOpportunityApexCtlrTest
 *****************************************/
public without sharing class CRM_CreateOpportunityApexCtlr {
	
	/********************
	*Method Name: getFormData
	*Parameter: recordId (AccountId or Contact Id)
	*Description:  Fetch the contact / account Details needed to display on opportunity creation form.
	*******************/
	@AuraEnabled
	public static WrapperFull getFormData(Id recordId) 
	{
		WrapperFull wrp = new WrapperFull();
		wrp.contactRec = null;
		wrp.campaignRec = null;
		wrp.accountRec = null;
		wrp.canCreate = canCreate();
		if(wrp.canCreate)
		{
			String sObjectName = getObjectFromId(recordId);
			if(sObjectName.equals('Contact'))
			{
	System.debug('From Contact');
	wrp.contactRec = getContact(recordId);
	wrp.accountRec = getAccount(wrp.contactRec.account.Id);
	wrp.campaignRec = getCampaign(recordId);
	wrp.businessPartnerRole = wrp.contactRec.Account.BusinessPartnerRole__c;
			}
			else if(sObjectName.equals('Account'))
			{   
	System.debug('From account');
	wrp.accountRec= getAccount(recordId);
	wrp.businessPartnerRole = wrp.accountRec.BusinessPartnerRole__c;
			}
			
			wrp.accountRoleValues = getAllAccountRoleValues();
			wrp.contractSigningValues = getAllContractSigningValues();
			wrp.currencyValues = getAllCurrencyValues();
			wrp.oppTypeValues = getAllOppTypesValues();
			wrp.oppEndCustomerInfoValues = getAllOppECInformationValues();
			wrp.oppECMarketSegValues = getAllOppECMktSegValues();
			wrp.oppECCountryValues = getAllOppECCountryValues();
			wrp.oppECActSecValues = getAllOppActSecValues();
			
			wrp.defaultAccountRole = getAccountRoleDefaultValue(wrp.businessPartnerRole, getAccountRoleMappings());
			wrp.defaultCurrency = getCurrentUserISOCode();
			
		}
		return wrp;
	}
	
	 /********************
	*Method Name: saveIndirectOppFromAcc
	*Parameter: Opportunity, AccountId and  endCustomerLEId)
	*Description:  creates indirect opportunity
	*******************/
	@AuraEnabled
	public static Opportunity saveIndirectOpportunityWithAccount(Opportunity oppty, Id accountId, Id endCustomerLEId)
	{
		oppty.StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
		oppty.Business_Type__c = 'Standard Opportunity';
		oppty.Phase_Status__c = GlobalConstants.PLANNED;
		oppty.closeDate = oppty.G5_Planned_Date__c;//Da Account temos 2199-09-09
		oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
		oppty.End_Customer_LE__c = endCustomerLEId;
		oppty.AccountId = accountId;
		insert oppty;
		return oppty;
	}
	
	/********************
	*Method Name: saveIndirectOpportunityWithContact
	*Parameter: Contact Id , campaignId , accountId , Oppotunity , endCustomerId
	*Description:   Save the indirect sales opportunity
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
		//  ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.SAVE_INOPPTY_WITH_CONTACT );
		//}
		return oppty;
	}
	
	/********************
	*Method Name: getContact
	*Parameter: Contact Id
	*Description:  Fetch the contact Details need to display on opportunity creation form.
	*******************/
	private static Boolean canCreate() 
	{	 
		Boolean canCreate = false;
		Schema.DescribeSObjectResult oppObj = Schema.SObjectType.Opportunity; 
		Map<String,Schema.RecordTypeInfo> rtMapByName = oppObj.getRecordTypeInfosByDeveloperName();
		Schema.RecordTypeInfo indOppRecType =  rtMapByName.get(GlobalConstants.Indirect_Record_Type);
		if(oppObj.isCreateable() && indOppRecType.isAvailable())
		{
			canCreate = true;
		}
		return canCreate;
	}   
	/********************
	*Method Name: getContact
	*Parameter: Contact Id
	*Description:  Fetch the contact Details need to display on opportunity creation form.
	*******************/
	private static Contact getContact(Id contactId) {  
		 Contact con = [SELECT Firstname, Lastname, account.name, account.Id, account.BusinessPartnerRole__c, Campaign_Name__c, Purchasing_Role__c FROM contact WHERE Id = :contactId];
		 //Requirement# 3583
		 if(String.isBlank(con.Purchasing_Role__c))  
	con.Purchasing_Role__c = GlobalConstants.BUSINESS_USER;
		 return con;
	}
	
	/********************
	*Method Name: getAccount
	*Parameter: Account Id
	*Description:  Fetch the Account Details need to display on opportunity creation form
	*******************/
	private static Account getAccount(Id accountId) {  
		//Requirement# 3583
		Account acc = [SELECT Id, Name, BusinessPartnerRole__c FROM Account WHERE Id = :accountId];
		return acc;
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
	*Method Name: getAllCurrencyValues
	*Parameter: 
	*Description:  Fetching all Currency Values from picklist
	*******************/
	public static Map<string,string> getAllCurrencyValues()
	{   
		Map<string,string> currencies = new  Map<string,string>();
		map<String, Schema.SObjectField> fieldMap = CRM_CreateOpportunityApexCtlr.getFieldMap(); 
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
	* AuraEnabled notation only needed for DIRECT OPPS
	*******************/
	public static Map<string,string> getAllOppTypesValues(){
		Map<string,string> oppTypes= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CRM_CreateOpportunityApexCtlr.getFieldMap();
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
	*Method Name: getAllOppECInformationValues
	*Parameter: 
	*Description:  Fetching all opportunity types End Customer Information Values from picklist
	*******************/
	public static Map<string,string> getAllOppECInformationValues(){
		Map<string,string> oppECInformations= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CRM_CreateOpportunityApexCtlr.getFieldMap();
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.END_CUSTOMER_INFORMATION).getDescribe().getPickListValues();
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry a : values)
			{ 
	oppECInformations.put(a.getLabel(), a.getValue()); 
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_ALL_EC_INFORMATION_VAL);
		 }
		return oppECInformations;
	}
	
	/********************
	*Method Name: getAllOppECMktSegValues
	*Parameter: 
	*Description:  Fetching all opportunity types End Customer Market Segments Values from picklist
	*******************/
	public static Map<string,string> getAllOppECMktSegValues(){
		Map<string,string> oppECMKTSegInformations= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CRM_CreateOpportunityApexCtlr.getFieldMap();
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.M_O_U_EC_MARKET_SEGMENT).getDescribe().getPickListValues();
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry a : values)
			{ 
	oppECMKTSegInformations.put(a.getLabel(), a.getValue()); 
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_ALL_MTK_SEG_VAL );
		 }
		return oppECMKTSegInformations;
	}
	
	/********************
	*Method Name: getAllOppECCountryValues
	*Parameter: 
	*Description:  Fetching all opportunity types End Customer Country Values from picklist
	*******************/
	public static Map<string,string> getAllOppECCountryValues(){
		Map<string,string> oppECCountryInformations= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CRM_CreateOpportunityApexCtlr.getFieldMap();
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.M_O_U_EC_Country).getDescribe().getPickListValues();
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry a : values)
			{ 
	oppECCountryInformations.put(a.getLabel(), a.getValue()); 
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_ALL_COUNTRY_VAL );
		 }
		return oppECCountryInformations;
	}
	
	/********************
	*Method Name: getAllOppActSecValues
	*Parameter: 
	*Description:  Fetching all opportunity types End Customer Activity Segment Values from picklist
	*******************/
	public static Map<string,List<string>> getAllOppActSecValues(){
		Map<string,List<string>> oppActSecValues= new Map<string,List<string>>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CRM_CreateOpportunityApexCtlr.getFieldMap();
		try{
			//Get picklist values
			List<Schema.PicklistEntry> ctrlEntries = fieldMap.get(GlobalConstants.M_O_U_EC_MARKET_SEGMENT).getDescribe().getPickListValues();
			List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(fieldMap.get(GlobalConstants.M_O_U_EC_ACT_SEC).getDescribe().getPicklistValues());
			List<String> controllingValues = new List<String>();
		
			for (Schema.PicklistEntry ple : ctrlEntries) {
				String label = ple.getLabel();
				oppActSecValues.put(label, new List<String>());
				controllingValues.add(label);
			}
			
			for (PicklistEntryWrapper plew : depEntries) {
				String label = plew.label;
				String validForBits = base64ToBits(plew.validFor);
				for (Integer i = 0; i < validForBits.length(); i++) {
					String bit = validForBits.mid(i, 1);
					if (bit == '1') {
						oppActSecValues.get(controllingValues.get(i)).add(label);
					}
				}
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.CREATE_OPPTY_APEX_CTLR ,GlobalConstants.GET_ALL_ACT_SEC_VAL );
		}
		return oppActSecValues;
	}
	
	public static String decimalToBinary(Integer val) {
		String bits = '';
		while (val > 0) {
			Integer remainder = Math.mod(val, 2);
			val = Integer.valueOf(Math.floor(val / 2));
			bits = String.valueOf(remainder) + bits;
		}
		return bits;
	}
	
	public static String base64ToBits(String validFor) {
		if (String.isEmpty(validFor)) return '';
		
		String validForBits = '';
		
		for (Integer i = 0; i < validFor.length(); i++) {
			String thisChar = validFor.mid(i, 1);
			Integer val = base64Chars.indexOf(thisChar);
			String bits = decimalToBinary(val).leftPad(6, '0');
			validForBits += bits;
		}
		
		return validForBits;
	}
	
	private static final String base64Chars = '' +
		'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
		'abcdefghijklmnopqrstuvwxyz' +
		'0123456789+/';
	
	private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
		return (List<PicklistEntryWrapper>)
			JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
	}
	
	public class PicklistEntryWrapper{
		public String active {get;set;}
		public String defaultValue {get;set;}
		@AuraEnabled
		public String label {get;set;}
		@AuraEnabled
		public String value {get;set;}
		public String validFor {get;set;}
		public PicklistEntryWrapper(){		  
		}
	}
	
	/********************
	*Method Name: getAllContractSigningValues
	*Parameter: 
	*Description:  Fetching all  Contract Signing Values from picklist
	* AuraEnabled notation only needed for DIRECT OPPS
	*******************/
	public static Map<string,string> getAllContractSigningValues(){
		Map<string,string> contractSigningEntities= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CRM_CreateOpportunityApexCtlr.getFieldMap();
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
	* AuraEnabled notation only needed for DIRECT OPPS
	*******************/
	public static Map<string,string> getAllAccountRoleValues(){
		Map<string,string> accountRoles= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CRM_CreateOpportunityApexCtlr.getFieldMap();
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
	public static String getCurrentUserISOCode()
	{
		return userinfo.getDefaultCurrency();
	}
	
	 /********************
	*Method Name: getBPR2AccountRoleMap
	*Parameter: 
	*Description:  finds the account role default value on opp based on business partner type on account.
	*******************/
	public static List<CRM_AccountRole_Opp_Map__c> getAccountRoleMappings()
	{
		return CRM_AccountRole_Opp_Map__c.getall().values();
	}
	
	
	/********************
	*Method Name: getBPR2AccountRoleMap
	*Parameter: 
	*Description:  finds the account role default value on opp based on business partner type on account.
	*******************/
	public static String getAccountRoleDefaultValue(String accBusinessPartnerRole, List<CRM_AccountRole_Opp_Map__c> bprToArMaps)
	{
		String defaultAccountRoleValue = '';
		if(accBusinessPartnerRole != null && !accBusinessPartnerRole.equals(''))
		{
			for(CRM_AccountRole_Opp_Map__c arMap : bprToArMaps)
			{
	System.debug(arMap.BPR_at_Account__c + ' vs ' + accBusinessPartnerRole);
	if(arMap.BPR_at_Account__c.equals(accBusinessPartnerRole))
	{
		defaultAccountRoleValue = arMap.AR_on_opportunity__c;
		break;
	}
			}
		}
		System.Debug('>>> defaultAccountRoleValue>>> '+defaultAccountRoleValue);
		return defaultAccountRoleValue;
	}
	
	private static String getObjectFromId(Id recordId)
	{
		Schema.SObjectType sobjectType = recordId.getSObjectType();
		String sobjectName = sobjectType.getDescribe().getName();
		return sobjectName;
	}

	public class WrapperFull
	{
		@AuraEnabled
		public Boolean canCreate {get;set;}
		@AuraEnabled
		public Map<string,string> accountRoleValues {get;set;} 
		@AuraEnabled
		public Map<string,string> contractSigningValues {get;set;} 
		@AuraEnabled
		public Map<string,string> currencyValues {get;set;} 
		@AuraEnabled
		public Map<string,string> oppTypeValues {get;set;}
		@AuraEnabled
		public Map<string,string> oppEndCustomerInfoValues {get;set;}
		@AuraEnabled
		public Map<string,string> oppECMarketSegValues {get;set;}
		@AuraEnabled
		public Map<string,string> oppECCountryValues {get;set;}
		@AuraEnabled
		public Map<string,List<string>> oppECActSecValues {get;set;}
		@AuraEnabled
		public String defaultAccountRole {get;set;}
		@AuraEnabled
		public String defaultCurrency {get;set;}
		@AuraEnabled
		public Account accountRec {get;set;} 
		@AuraEnabled
		public Contact contactRec {get;set;}
		@AuraEnabled
		public Campaign campaignRec {get;set;}
		
		private String businessPartnerRole {get;set;}
	}
}