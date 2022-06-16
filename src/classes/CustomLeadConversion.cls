/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:		   CustomLeadConversion 
Description:	 IRApplicationCase Test class to test the class
Date	Version	  Author	 Summary of Changes
-----------   ----------	  ----------------- ---------------------------------------------------------------------------------------------------
04/15/2016	   1.0			Supriyam	  Initial Release for Convert lead custom

----------------------------------------------------------------------------------------------------------------------------------------------------------*/
/**
* Description : Method to CustomLeadConversion
* @param Strings to stamp values to Lead Object
* @return String to with leadDetails
* @throws NA
**/
public without sharing class CustomLeadConversion {
	
	/**
* Description : Method to get Lead details
* @param Strings to stamp values to Lead Object
* @return String to with lead details
* @throws NA
**/
	@AuraEnabled
	public static Lead getLeadDeatils(Id parentId)
	{
		Lead leadDetails = new Lead();
		try {
			List<Account> acc=new List<Account>();
			leadDetails = [
				SELECT Id, Lead_BG__c, Lead_BU__c, Owner.Name,Owner.Id,Deal_Name__c,Distributor_Account__r.Name,Distributor_Account__c ,recordTypeId,Company,
					End_Customer_Legal_Entity_Account__c,End_Customer_Legal_Entity_Account__r.name, PartnerAccount.Name,PartnerAccount.Id,Status,Name
				FROM Lead
				WHERE Id =: parentId
				LIMIT 1
			];
			if(
				leadDetails.recordTypeId == Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.Indirect_Deal_Registration_Approved_DEV).getRecordTypeId()
			){
	leadDetails.PartnerAccount.name = leadDetails.Distributor_Account__r.Name;
	leadDetails.PartnerAccount.Id = leadDetails.Distributor_Account__c;
	//leadDetails.End_Customer_Legal_Entity_Account__r.name = leadDetails.End_Customer_Legal_Entity_Account__r.name;
			}
		}
		catch(System.Exception e){
			String message=e.getMessage();
		}
		system.debug('@@@@@?>? '+leadDetails);
		return leadDetails;
	}
	/**
* Description : Method to check if the user is Internal or Partner
* @return Boolean
* @throws NA
**/
	@AuraEnabled
	public static Boolean isPartnerUser() 
	{
		String profileName = [
			SELECT Id,Name
			FROM Profile
			WHERE Id=:userinfo.getProfileId()
		].Name;
		return profileName.contains('Partner');
	}
/**
* Description : Method to check if Partner is eligible to convert
* @return Boolean
* @throws NA
**/
	@AuraEnabled
	public static Boolean isValidPartnerUser(Id leadId) 
	{
		Id userId = userinfo.getUserId();
		Id accountId = [
			SELECT Id,Contact.AccountId
			FROM User
			WHERE Id = :userId limit 1
		].Contact.AccountId;
		Id partnerAccountId = [
			Select Id, PartnerAccountId
			FROM Lead
			WHERE Id = :leadId limit 1
		].PartnerAccountId;
		List<PermissionSetAssignment> psaList = [
			SELECT Id
			FROM PermissionSetAssignment
			WHERE AssigneeId = :userId and PermissionSet.Name = 'Nokia_CPQ_Partner_User'
		];
		return accountId == partnerAccountId && !psaList.isEmpty();
	}
	/**
* Description : Method to getContactDeatils
* @param Strings to stamp values to Lead Object
* @return String to with contactDetails
* @throws NA
**/
	@AuraEnabled 
	public static User getContactDeatils(Id ownerID) 
	{
		User contactDetails = new User();
		try{
			contactDetails=[
				SELECT Contact.Name,Contact.Id
				FROM User
				WHERE id=:ownerID LIMIT 1
			];		  
		}
		Catch(System.Exception e)
		{
			String message=e.getMessage();
		}
		return contactDetails;
	}
	/**
* Description : Method to ConvertLead
* @param Strings to stamp values to Lead Object
* @return String to with covertedIdString
* @throws NA
**/
	@AuraEnabled
	public static String ConvertLead(Id LeadId,Id PartnerId , String OpptyName, String leadBG, String leadBU, Boolean quickConvert) 
	{
		List <contact> contactList = new List <contact>();
		id conIds;
		string emailId;
		boolean checkDeletion = false ;
		List<String> successMessage= new List<String>();
		List<String> convertedId= new List<String>();
		List<account> accLEList = new List<account>();
		List<account> accList = new List<account>();
		Boolean flag = false;
		lead ld =[
			SELECT PartnerAccountID,recordType.name,email,Indirect_Reseller_Account__c,Distributor_Account__c,Company, End_Customer_Legal_Entity_Account__c
			FROM lead
			WHERE id =: LeadId LIMIT 1
		];
		accLEList = [
			SELECT Id, Name, ParentId
			FROM Account
			WHERE id =: ld.End_Customer_Legal_Entity_Account__c
			/*(recordType.name =: PRMGlobalConstants.LEGAL_ENTITY OR (recordType.name =: PRMGlobalConstants.PROSPECT AND BusinessPartnerRole__c =: PRMGlobalConstants.EndCustomer) )and Name =: ld.Company */
			Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())
		];		  
		accList = [
			SELECT Id, Name, Active__c
			FROM Account
			WHERE  (Id =: accLEList[0].ParentId and recordType.name =: PRMGlobalConstants.CUSTOMER) OR
	   ( Id =: accLEList[0].id and recordType.name =: PRMGlobalConstants.PROSPECT)
			LIMIT 1
		];
		if(ld.email  != null){
			contactList = [
				SELECT id ,AccountId,Account.name
				FROM contact
				WHERE email =: ld.email
			];
		}
		
		if(!contactList.IsEmpty()){ checkDeletion =true; }
		Database.LeadConvert lc = new Database.LeadConvert();
		lc.setLeadId(LeadId);
		// if(conIds !=null){
		//   lc.setContactId(conIds);
		// }
		lc.setAccountId(PartnerId);
		lc.setOpportunityName(OpptyName);
		
		LeadStatus convertStatus = [
			SELECT Id, MasterLabel
			FROM LeadStatus
			WHERE IsConverted=true
			LIMIT 1
		];
		
		lc.setConvertedStatus(convertStatus.MasterLabel);
		try{
			Database.LeadConvertResult lcr = Database.convertLead(lc, false);
			
			if(!lcr.isSuccess())
			{
	for(Database.Error error : lcr.getErrors())
	{
		successMessage.add(error.getMessage());
	}
			}
			else
			{
	lead leadInstance = [select Id, RecordType.Name , PartnerAccountId , End_Customer_Legal_Entity_Account__c, End_Customer_Legal_Entity_Account__r.ParentId, ConvertedContactId ,Indirect_Reseller_Account__c,PRM_Marketing_Tactic_Supported__c from lead where id =: LeadId LIMIT 1];
	contact con = [Select email,accountId from contact where id =: leadInstance.ConvertedContactId ];
	Account endCustAcc = [SELECT Id, Name, Active__c, RecordType.DeveloperName FROM Account WHERE 
			  (Id =: leadInstance.End_Customer_Legal_Entity_Account__r.ParentId and recordType.name =: PRMGlobalConstants.CUSTOMER) 
			  OR ( Id =: leadInstance.End_Customer_Legal_Entity_Account__c and recordType.name =: PRMGlobalConstants.PROSPECT) limit 1];
	Opportunity opp =[Select Id, Name, OwnerId, Account.OwnerId, Account.Owner.Name, Account.CurrencyIsoCode, Account.BusinessPartnerRole__c, Account.GEOLevel1ID__c,
		  Account_Role__c, End_Customer_Information__c, Multiple_or_Unknown_EC_Activity_Sector__c, Multiple_or_Unknown_EC_Country__c, G3_Planned_Date__c,
		  End_Customer_LE__c, Indirect_Reseller_Account__c, Indirect_Reseller_Account__r.OwnerId,PRM_Marketing_Tactic_Supported__c from Opportunity where Id =: lcr.getOpportunityId()];
	if(checkDeletion ==true){
		delete con;
		//MSilva - SFPRM-452 creating Contact Role for the original contact
		OpportunityContactRole ocr = new OpportunityContactRole(
						ContactId = contactList[0].Id, IsPrimary = true, OpportunityId = opp.Id, Role = 'Business User'
					);
		insert ocr;
	}
	
				convertedId.addAll(new List<String> {opp.Id, 'Success'});
	
	//MSilva - SFPRM-501 - Setting Lead BG + Lead BU
	opp.Lead_BG__c = leadBG; opp.Lead_BU__c = leadBU;
				opp.Account_Role__c = PRMGlobalConstants.GPPDistributorPartner;
				
	opp.PRM_Marketing_Tactic_Supported__c = leadInstance.PRM_Marketing_Tactic_Supported__c;
				
	if(quickConvert){
		opp.G3_Planned_Date__c = System.today(); opp.G4_Planned_Date__c = System.today().addMonths(2);
		opp.G5_Planned_Date__c = System.today().addMonths(3); opp.G6_Planned_Date__c = System.today().addMonths(4);
		opp.StageName = GlobalConstants.IDENTIFY_OPPORTUNITY; opp.Phase_Status__c = GlobalConstants.PLANNED;
		opp.isPartnerOpportunity__c = true; opp.Gate_3_Bypass_no_offer_support__c= true;
	}
	update opp;
	
	if(contactList.IsEmpty() && endCustAcc.RecordType.DeveloperName != PRMGlobalConstants.CUSTOMER){ con.accountId = endCustAcc.id; update con; }
			}
		}
		catch(System.Exception e){ String message=e.getMessage(); }
		
		if(successMessage.size() ==0 ) { return String.join(convertedId, ','); }
		return String.join(successMessage, '--');	   
	}
	/**
* Description : Method to GetName
* @param Strings to stamp values to Lead Object
* @return String to with OpptyName
* @throws NA
**/
	@AuraEnabled
	public static Opportunity getName(String OpptyId) 
	{
		Opportunity opptyName = new Opportunity();
		try{
			opptyName= [
				SELECT Name
				FROM opportunity
				WHERE ID =:OpptyId LIMIT 1
			];		  
		}	
		Catch(System.Exception e)
		{
			String message=e.getMessage(); 
		}
		return opptyName;
	}
	
	/**
* Description : Method to Inactive acc names 3.1 Release
* @param Strings to stamp values to Lead Object
* @return String to with acc name
* @throws NA
**/
	@AuraEnabled
	public static String getInactiveAccName(Id leadID) 
	{
		String errorMSG = PRMGlobalConstants.No_Error ;
		List<Account> partnerAccName = new List<Account>();
		List<Account> endCustomer = new List<Account>();
		Lead leadDetails = getLeadDeatils(leadID);
		try{
			partnerAccName = [SELECT Name, Active__c, AccountStatusInCRMOM__c From Account  WHERE (Id =: leadDetails.PartnerAccount.Id and recordType.name =: PRMGlobalConstants.CUSTOMER) OR ( Id =: leadDetails.PartnerAccount.Id and recordType.name =: PRMGlobalConstants.PROSPECT) Limit 1];
			endCustomer = [SELECT Name, Active__c From Account  WHERE ( id =: leadDetails.End_Customer_Legal_Entity_Account__c /* Name =: leadDetails.Company and (recordType.name =: PRMGlobalConstants.LEGAL_ENTITY OR (recordType.name =: PRMGlobalConstants.PROSPECT AND BusinessPartnerRole__c =: PRMGlobalConstants.EndCustomer) )*/) Limit 1];
		}	
		catch(System.Exception e){ String message=e.getMessage(); }
		if(endCustomer.IsEmpty()){
			errorMSG = PRMGlobalConstants.EndCustomerNotPresent ;
		}else if(!partnerAccName.IsEmpty() && partnerAccName[0].Active__c == false && !endCustomer.IsEmpty() && endCustomer[0].Active__c == false ){
			errorMSG = PRMGlobalConstants.BOTHInactive ;
		}else if(!partnerAccName.IsEmpty() && partnerAccName[0].Active__c == false && !endCustomer.IsEmpty() && endCustomer[0].Active__c == true){
			errorMSG = PRMGlobalConstants.PartnerAccountInactive;
		}else if(!partnerAccName.IsEmpty() && partnerAccName[0].Active__c == true && !endCustomer.IsEmpty() && endCustomer[0].Active__c == false ){
			if(partnerAccName[0].AccountStatusInCRMOM__c == PRMGlobalConstants.Inactive){
	errorMSG = PRMGlobalConstants.BOTHInactive;
			}else{
	errorMSG = PRMGlobalConstants.EndCustomerAccountInactive;
			}
		}else if(!partnerAccName.IsEmpty() && partnerAccName[0].Active__c == true && !endCustomer.IsEmpty() && endCustomer[0].Active__c == true
	 && partnerAccName[0].AccountStatusInCRMOM__c == PRMGlobalConstants.Inactive){
		 errorMSG = PRMGlobalConstants.PartnerAccountInactive;
	 }
		return errorMSG;
	}
	/**
* Description : Method to Inactive acc names 3.1 Release
* @param Strings to stamp values to Lead Object
* @return String to with acc name
* @throws NA
**/
	@AuraEnabled
	public static String getEndCustomerName(Id leadID) 
	{
		String message;
		String endCustomerName = PRMGlobalConstants.RFUrl ;
		List<Account> endCustomer = new List<Account>();
		List<Account> endCustomerLE = new List<Account>();
		Lead leadDetails = getLeadDeatils(leadID);
		try{	
			endCustomerLE = [SELECT Name, Active__c, ParentId From Account WHERE (ID =: leadDetails.End_Customer_Legal_Entity_Account__c) Limit 1];
			endCustomer = [SELECT Name, Active__c, AccountStatusInCRMOM__c From Account  WHERE(((Id =: endCustomerLE[0].ParentId AND recordType.name =: PRMGlobalConstants.CUSTOMER) AND (Active__c !=: PRMGlobalConstants.RUN_LEAD_TRIGGER_ON_LEAD_UPDATE OR AccountStatusInCRMOM__c !=: PRMGlobalConstants.ActiveSt)) OR (Id =: endCustomerLE[0].id AND Active__c !=: PRMGlobalConstants.RUN_LEAD_TRIGGER_ON_LEAD_UPDATE AND recordType.name =: PRMGlobalConstants.PROSPECT AND Id =: endCustomerLE[0].id)) Limit 1];
		}	
		catch(System.Exception e)
		{
			message=e.getMessage();
		}
		endCustomerName = !endCustomer.IsEmpty() ? endCustomer[0].Name : PRMGlobalConstants.ActiveSt;
		return endCustomerName;
		
	}
	
	/**
* Description : Method to get endcustomer name for cinversion page
* @param Strings to stamp values to Lead Object
* @return String to with end customer acc name
* @throws NA
**/
	@AuraEnabled
	public static String getEndCustomer(Id EndCustID) 
	{
		String message;
		System.debug('EndCustID '+ EndCustID);
		String endCustomerN = PRMGlobalConstants.RFUrl ;
		List<Account> endCustomer = new List<Account>();
		try{	
			endCustomer = [
				SELECT Name, Active__c
				FROM Account
				WHERE Id =: EndCustID Limit 1
			];
		}	
		catch(System.Exception e) { message=e.getMessage(); }
		
		System.debug('endCustomer '+ endCustomer );
		if(!endCustomer.IsEmpty()){ endCustomerN = endCustomer[0].Name; }
		
		System.debug('endCustomerN : '+ endCustomerN);
		return endCustomerN;
	}
	/**
* Description : Method to update Lead details
* @param Strings to stamp values to Lead Object
* @return String to with lead details
* @throws NA
**/
	@AuraEnabled
	public static void updateLead(Id LeadId,String G3_Planned_Date,String G4_Approval_Date,String G5_Planned_Date,String G6_Planned_Date){
		try{
			Lead leadUpdate=new Lead();
			// leadUpdate.G2_Planned_Date__c= Date.valueOf(G2_Planned_Date);
			leadUpdate.G3_Planned_Date__c= Date.valueOf(G3_Planned_Date);
			leadUpdate.G4_Approval_Date__c= Date.valueOf(G4_Approval_Date);
			leadUpdate.G5_Planned_Date__c= Date.valueOf(G5_Planned_Date);
			leadUpdate.G6_Planned_Date__c= Date.valueOf(G6_Planned_Date);
			leadUpdate.Id=LeadId;
			update leadUpdate;
		} Catch(System.Exception e)
		{
			String message=e.getMessage();
		}   
		
	}
	
	@AuraEnabled
	public static Map<String, List<String>> getDependentPicklistValues() {
		Schema.sObjectField dependentField=Opportunity.Lead_BU__c;
		Schema.DescribeFieldResult depend = dependentField.getDescribe();
		Schema.sObjectField controlToken = depend.getController();
		if (controlToken == null) { return new Map<String, List<String>>(); }
		
		Schema.DescribeFieldResult control = controlToken.getDescribe();
		List<Schema.PicklistEntry> controlEntries;
		if(control.getType() != Schema.DisplayType.Boolean) {
			controlEntries = control.getPicklistValues();
		}
		
		String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
		Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
		for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
			if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))) {
	List<String> base64chars =
		String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
	for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
		Object controlValue =
			(controlEntries == null
			 ?   (Object) (index == 1)
			 :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
			);
		Integer bitIndex = index / 6;
		if (bitIndex > base64chars.size() - 1) {
			break;
		}
		Integer bitShift = 5 - Math.mod(index, 6);
		if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0)
			continue;
		if (!dependentPicklistValues.containsKey((String) controlValue)) {
			dependentPicklistValues.put((String) controlValue, new List<String>());
		}
		dependentPicklistValues.get((String) controlValue).add(entry.getLabel());
	}
			}
		}
		return dependentPicklistValues;
	}
	
	@AuraEnabled
	public static ListView getListView() {
		ListView listviews = [
			SELECT Id, Name
			FROM ListView
			WHERE SobjectType = 'Lead' and Name='Recently Viewed Leads'
		];
		return listviews;
	}
	
	/**
	* Description : Method to get Lead BG
	* @return String
	* @throws NA
	**/
	@AuraEnabled
	public static String getLeadBG(Id parentId) 
	{
		String leadBG = [
			SELECT Id,Lead_BG__c
			FROM Lead
			WHERE Id = :parentId
		].Lead_BG__c;
		return leadBG;
	}
	
	 /**
	* Description : Method to get Lead BU
	* @return String
	* @throws NA
	**/
	@AuraEnabled
	public static String getLeadBU(Id parentId) 
	{
		String leadBU = [
			SELECT Id,Lead_BU__c
			FROM Lead
			WHERE Id=:parentId
		].Lead_BU__c;
		return leadBU;
	}

	@AuraEnabled
	public static User getTechOptinChoice(){
		try {
			
			if(UserInfo.getUserType()=='PowerPartner') {
				List<User> partnerUser = [SELECT Id, Contact.PRM_Tech_Squad_Eligible__c, contact.PRM_Tech_Squad_Opt_In__c, ContactId FROM User WHERE Id=:UserInfo.getUserId()];
				if(partnerUser!=null && !partnerUser.isEmpty())
					return partnerUser[0];
			}

			return null;

		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static string setTechOptinChoice(Contact con){
		try {

			update con;

			return 'success';
			
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
}