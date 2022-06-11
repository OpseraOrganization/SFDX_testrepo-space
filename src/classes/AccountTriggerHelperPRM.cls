/****************************************
	* Class Name : AccountTriggerHelperPRM
	* Created Date: 17 April 2017
	* Created By : Accenture
	
	* Last Modified by: Accenture
	* Last Modified Date: 19 April 2017
	* Description :
	*****************************************/
public with sharing class AccountTriggerHelperPRM {
	
	/*******************************
		*Method name: createPartnerCompany
		*Description: This Method will create a new partner company and combines two previous existing methods
		*Parameter: Account Values
		*author: joao rodrigues CO
	*******************************/ 
	public static void createPartnerCompany( Map<id,Account> accountOldMap , Map<id,Account> accountNewMap  )
	{
		List<Partner_Company__c> partnerCompanyList = new List<Partner_Company__c>();
		
		//List<Contact> contactUpdateInactive = new List<Contact>();
		try{
			for(Account acc : accountNewMap.values())
			{
	if((acc.recordtypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.CUSTOMER).getRecordTypeId())
	&& (accountNewMap.get(acc.Id).Partner_Type__c!=null) &&
	   ((!accountOldMap.get(acc.Id).IsPartner && accountNewMap.get(acc.Id).IsPartner && !String.isEmpty(accountNewMap.get(acc.Id).Partner_Type__c))
		|| (String.isEmpty(accountOldMap.get(acc.Id).Partner_Type__c) && !String.isEmpty(accountNewMap.get(acc.Id).Partner_Type__c) && accountNewMap.get(acc.Id).IsPartner )))
	{
			Partner_Company__c partnerCompany = getPartnerCompany();
			partnerCompany.Country_Headquarters__c = acc.Country__c;
			partnerCompany.Market__c = acc.Market__c;
			partnerCompany.Partner_Name__c = acc.id;
			partnerCompany.Partner_Type__c = acc.Partner_Type__c;
			partnerCompanyList.add(partnerCompany);
	}
			}
			database.insert(partnerCompanyList);
		}catch(Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.ACCOUNT_TRIGGER_HELPER_PRM,PRMGlobalConstants.UPDATE_PARTNER_COMPANY);
		}
	}

	/*******************************
		*Method name: updatePartnerCompanyOnChange
		*Description: This Method will Update Partner Company
		*Requirement: 2812 (Updates to Partner Company Records)
	*******************************/ 
	public static void updatePartnerCompanyOnChange( Map<id,Account> accountOldMap , Map<id,Account> accountNewMap  ){
		Set<Id> accountIds = new Set<Id>();
		try{
			for(Account acc : accountNewMap.values())
			{
	if((accountNewMap.get(acc.Id).Partner_Type__c != accountOldMap.get(acc.Id).Partner_Type__c) )
	{
		accountIds.add(acc.Id); 
	}

			}
			if(!accountIds.IsEmpty())
			{
	List<Partner_Company__c> partnerCompanyListUpdate = [SELECT id,Partner_Type__c,Partner_Name__c  FROM Partner_Company__c 
	WHERE Partner_Name__c  in : accountIds LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	for(Partner_Company__c partnerCompany : partnerCompanyListUpdate)
	{	 
		partnerCompany.Partner_Type__c = accountNewMap.get(partnerCompany.Partner_Name__c).Partner_Type__c;
	}
	database.update(partnerCompanyListUpdate);
			}
		}
		catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.ACCOUNT_TRIGGER_HELPER_PRM,PRMGlobalConstants.UPDATE_PARTNER_COMPANY_ON_CHANGE);
		}
	}
	
	/*******************************
		*Method name: deletePartnerCompany
		*Description: This Method will Remove Account From Partner Company
		*Requirement: 2812 (Updates to Partner Company Records)
	*******************************/		 
	public static void deletePartnerCompany( Map<id,Account> accountOldMap , Map<id,Account> accountNewMap)
	{
		Set<id> accIdSet = new Set<id>();
		List<Partner_Company__c> partnerCompanyList = new List<Partner_Company__c>();		
		try{
			for(Account acc : accountNewMap.values())
			{
	if(((accountOldMap.get(acc.Id).IsPartner && !accountNewMap.get(acc.Id).IsPartner)
	|| (!String.isEmpty(accountOldMap.get(acc.Id).Partner_Type__c) && String.isEmpty(accountNewMap.get(acc.Id).Partner_Type__c)))
	&& acc.recordtypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.CUSTOMER).getRecordTypeId())
	{
		accIdSet.add(acc.Id);
	}
			}
			if(!accIdSet.IsEmpty())
			{
	partnerCompanyList=[SELECT Country_Headquarters__c,Id,Market__c,Name,Partner_Name__c,Partner_Type__c FROM Partner_Company__c 
			WHERE Partner_Name__c IN :accIdSet LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	if(!partnerCompanyList.IsEmpty()){
		database.delete(partnerCompanyList);
	}
			}
		}catch(Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.ACCOUNT_TRIGGER_HELPER_PRM,PRMGlobalConstants.DELETE_PARTNER_COMPANY);
		}
	}
	
	public static Partner_Company__c getPartnerCompany(){
		return  new Partner_Company__c();
	}
	/********************
		*Method Name: updateCertValueONPaertnerProgram
		*Parameter: Account List
		*Description: Used to handle after Insert activities
		2. Added bloack of code to update certification data based on partner program field
		// Author - supriyam 
	*******************/
	public static void updateCertValueONPaertnerProgram( Map<id,Account> accountOldMap , Map<id,Account> accountNewMap  ){
		Set<ID> accountId = new Set<ID>();
		try{
			for(Account acc : accountNewMap.values()){
	if(accountOldMap.get(acc.Id).Partner_Program__c != accountNewMap.get(acc.Id).Partner_Program__c){
		accountId.add(acc.Id);
	}
			}
			
			// added code to check change of partner program 
			
			LIST<Certification__c> certdetailsUpdate = new LIST<Certification__c>();
			If(!accountId.IsEmpty()){
	for (Certification__c certDetails : [select Partner__c,Partner__r.Partner_Program__c,GPP_Certification_Name__c,Certification_Matrix_Number__r.GPP_0_0__c,Certification_Matrix_Number__r.GPP_1_0__c,Certification_Matrix_Number__r.GPP_2_0__c,Certification_Matrix_Number__r.GPP_3_0__c 
	 from Certification__c where Partner__c in:accountId 
	 Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		 
		 if(certDetails.Partner__r.Partner_Program__c == PRMGlobalConstants.Partner_Program0){
	certDetails.GPP_Certification_Name__c = certDetails.Certification_Matrix_Number__r.GPP_0_0__c;
		 }else if(certDetails.Partner__r.Partner_Program__c == PRMGlobalConstants.Partner_Program1){
	certDetails.GPP_Certification_Name__c = certDetails.Certification_Matrix_Number__r.GPP_1_0__c;
		 }else if(certDetails.Partner__r.Partner_Program__c == PRMGlobalConstants.Partner_Program2){
	certDetails.GPP_Certification_Name__c = certDetails.Certification_Matrix_Number__r.GPP_2_0__c;
		 }else if(certDetails.Partner__r.Partner_Program__c == PRMGlobalConstants.Partner_Program3){
	certDetails.GPP_Certification_Name__c = certDetails.Certification_Matrix_Number__r.GPP_3_0__c;
		 }
		 certdetailsUpdate.add(certDetails); 
		 
	 }
	database.update(certdetailsUpdate,false);
			}
			
			//update certdetailsUpdate;
			// end code for partner program
			
			
		}catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.ACCOUNT_TRIGGER_HELPER_PRM ,PRMGlobalConstants.updateCertValueONPaertnerProgram); 
			
		}
	}
	// end code
	
	/********************
		*Method Name: restrictEnablingPartner
		*Parameter: Account List
		*Description: Used to handle after Insert activities
		2. Added below block of code for sending email notification to PSM user as per PRM project.
		1. Block users from enabling a partner if Account Record Type is Legal Entity
	*******************/
	public static void restrictEnablingPartner(List<Account> acclist) {
		Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosById();
		
		for(Account a : acclist) {
			try{
	
	if (rtMap.get(a.RecordTypeId).getName().equals(PRMGlobalConstants.LEGAL_ENTITY) && a.IsPartner) {
		a.addError(System.Label.Restrict_Enabling_Partner_Error_Message);
	}  
			}catch(Exception exc){
	ExceptionHandler.addException(exc, PRMGlobalConstants.ACCOUNT_TRIGGER_HELPER_PRM, PRMGlobalConstants.ACCOUNT_TRIGGER_HANDLER_RESTRICTENABLINGPARTNER );   
			}
		}
	}
	
	/********************
		*Method Name: createPartnerLibrary
		*Parameter: Account List
		*Description: Used to create Patrtner Library and folder structure when partner type is populated on partne raccount on After update event
	
	*******************/
	public static void createPartnerLibrary( Map<id,Account> accountOldMap , Map<id,Account> accountNewMap ){
		try{
			set<ID> createLibraryAcc = new set<ID>();
			
			for(Account acc : accountNewMap.values()){
	if((accountOldMap.get(acc.Id).Partner_Type__c != accountNewMap.get(acc.Id).Partner_Type__c) && 
	(accountNewMap.get(acc.Id).Partner_Type__c != null) && (accountOldMap.get(acc.Id).Partner_Type__c == null)){
		createLibraryAcc.add(acc.id);
	}
			}
			if(!(createLibraryAcc.isempty())){	  
		  System.enqueueJob(new createPartnerLibrary(createLibraryAcc));	
			}
		}catch(Exception Ex){
			ExceptionHandler.addException(Ex, PRMGlobalConstants.ACCOUNT_TRIGGER_HELPER_PRM, PRMGlobalConstants.createPartnerLibrary);
			
		}
		
	}
	
	/********************
		*Method Name: createPartnerLibraryAfterInsert
		*Parameter: Account List
		*Description: Used to create Patrtner Library and folder structure when partner account created and partner type is populated
	*******************/
	public static void createPartnerLibraryAfterInsert(List<Account> acclist){
		try{
			set<ID> createLibraryAcc = new set<ID>();
			
			for(Account acc : acclist){
	if(acc.Partner_Type__c != null){
		createLibraryAcc.add(acc.id);
	}
			}
			if(!(createLibraryAcc.isempty())){	  
		System.enqueueJob(new createPartnerLibrary(createLibraryAcc));	
			}
		}catch(Exception Ex){
			ExceptionHandler.addException(Ex, PRMGlobalConstants.ACCOUNT_TRIGGER_HELPER_PRM, PRMGlobalConstants.createPartnerLibrary);
			
		}
		
	}
	
	
	//Commented -- As a part of PRM Partner Account Disable Req.
	//Start -- PRM Partner Account Disable Req.
		
		/********************
			*Method Name: deactivateUser
			*Parameter: Map
			*Description: Used to Deactivate user if Partner Account gets deactivated
	
		*******************/
		/*
		public static void deactivateUser( Map<id,Account> accountOldMap , Map<id,Account> accountNewMap){
		try{
		
		Set<Id> accountIdSet = new Set<Id>();
		Set<Id> conIdSet = new Set<Id>();
		List<id> userToUpdateList = new List<id>();
		for(account acc : accountNewMap.values()){
		if((!acc.IsPartner ) && (acc.IsPartner != accountOldMap.get(acc.Id).IsPartner)){
		accountIdSet.add(acc.Id);
		}
		}
		if(!accountIdSet.IsEmpty()){
		
		for(contact con : [Select Id from Contact where AccountId IN : accountIdSet 
		Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		conIdSet.add(con.Id);
		}
		if(!conIdSet.IsEmpty()){
		
		for(user userInst : [SELECT Id,IsActive FROM User WHERE ContactId IN : conIdSet 
		Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		userToUpdateList.add(userInst.ID);
		}
		}
		
		if(!userToUpdateList.IsEmpty()){
	
		AccountTriggerHelperPRM.deactivateUserfuture(userToUpdateList);
		
		}
		}
		}catch(Exception Ex){
		ExceptionHandler.addException(Ex, PRMGlobalConstants.ACCOUNT_TRIGGER_HELPER_PRM, PRMGlobalConstants.deactivateUser);
		
		}
		}
		/********************
			*Method Name: deactivateUserfuture
			*Parameter: Map
			*Description: future methode
		
		*******************/
	 /*
		@future
		public static void deactivateUserfuture( List<id> userToUpdateList){
		try{
		List<User> userList = [SELECT Id,IsActive FROM User WHERE id  IN : userToUpdateList 
		Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())] ; 
		for(user userInst : userList ){
		userInst.IsActive = false;
		}
		database.update(userList);
		}catch(Exception Ex){
		ExceptionHandler.addException(Ex, PRMGlobalConstants.ACCOUNT_TRIGGER_HELPER_PRM, PRMGlobalConstants.DeactivateUserfuture);	  
		}
		}
	*/
	//END -- PRM Partner Account Disable Req.


	
	/********************
		*Method Name: updateARRtools
		*Parameter: Map
		*Description: 
	
	*******************/
	public static void updateARRtools( Map<id,Account> accountOldMap , Map<id,Account> accountNewMap){
		try{
			Map<string,Set<String>> arrToolMap = new Map<string,Set<String>> ();
			Map<Id,List<Additional_Resource_Request__c>>  mapContactadditionResource = new Map<Id,List<Additional_Resource_Request__c>>();
			List<Additional_Resource_Request__c> listToUpdate = new List<Additional_Resource_Request__c> ();
			Set<ID> accountId = new Set<ID>();
			List<Account> accountIdForPartnerDisable = new List<Account>();
			for(ARR_Tools__c arrTool : [select id,Partner_Type__c , Tool_Name__c from ARR_Tools__c 
	Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		Set<String> toolName = new Set<String>();
		toolName.addAll(arrTool.Tool_Name__c.split(PRMGlobalConstants.SemiColon));
		arrToolMap.put(arrTool.Partner_Type__c ,toolName);
	}
			for(Account acc : accountOldMap.values()){
	if(acc.Partner_Type__c != accountNewMap.get(acc.Id).Partner_Type__c){
		accountId.add(acc.Id);
	}
	if(accountOldMap.get(acc.Id).IsPartner  && (!accountNewMap.get(acc.Id).IsPartner ) ){
		accountIdForPartnerDisable.add(acc);
	}
			}
			
			
			//Commented -- As a part of PRM Partner Account Disable Req.
			//Start -- PRM Partner Account Disable Req.
			
			/*
	List<Contact> conUpdateInactive=new List<Contact>();
	if(!accountIdForPartnerDisable.IsEmpty()){
	for (Contact conUpdate : [select id,User_Create_Status__c,User_Inactive_Reason__c from Contact 
	where Accountid in:accountIdForPartnerDisable Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
	conUpdate.User_Create_Status__c=PRMGlobalConstants.Inactive;
	conUpdate.User_Inactive_Reason__c=PRMGlobalConstants.PartnerAccountInactive;
	conUpdateInactive.add(conUpdate);
	}
	database.update(conUpdateInactive); 
	}
			*/
	
			//End -- PRM Partner Account Disable Req.
			
			
			List<Additional_Resource_Request__c> aRRupdateInactive=new List<Additional_Resource_Request__c>();
			if(!accountIdForPartnerDisable.IsEmpty()){
	for (Additional_Resource_Request__c arrUpdate : [select id,Request_Status__c, Additional_Resource__c, Partner_Account__c, Partner_Account__r.Market__c from Additional_Resource_Request__c 
	 where Partner_Account__c in:accountIdForPartnerDisable 
	 Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		 //ConPD.AccountId=accountIdForPartnerDisable;
		 if(!(arrUpdate.Additional_Resource__c == PRMGlobalConstants.USAPricing 
		&& (arrUpdate.Partner_Account__r.Market__c != PRMGlobalConstants.Distibutor))){
		 arrUpdate.Request_Status__c=PRMGlobalConstants.Remove;
		 arrUpdate.Partner_Type_Update__c=PRMGlobalConstants.NO;
		 aRRupdateInactive.add(arrUpdate);
		}
	 }
	database.update(aRRupdateInactive);
			}
			
			List<Contact> conUpdatePartnerType=new List<Contact>();
			if(!accountId.IsEmpty()){
	for (Contact conUpdate1 : [select id,User_Partner_Type__c,Account.id from Contact 
	where Account.id in:accountId AND PRM_Active_Partner_User__c = true
	Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
	 conUpdate1.User_Partner_Type__c=accountNewMap.get(conUpdate1.accountId).Partner_Type__c;
	 conUpdatePartnerType.add(conUpdate1);
	 //system.debug('.........'+conUpdate1);
	}
			}
			database.update(conUpdatePartnerType); 
			Map<Id,contact> contactMap = new Map<Id,contact>();
			if(!accountId.IsEmpty()){
	contactMap = new Map<Id,contact>( [Select id,account.partner_type__c,account.Market__c from contact 
	  where AccountId IN : accountId 
	  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]);  
	
	
	for (Additional_Resource_Request__c ARRDetails : [select id,Partner_Type_Update__c,Request_Status__c,Partner_Contact__c,Additional_Resource__c,Partner_Account__c,Partner_Account__r.Market__c from Additional_Resource_Request__c 
	  where Partner_Account__r.id in:accountId 
	  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
	List<Additional_Resource_Request__c> adrList = new List<Additional_Resource_Request__c> ();
	if(mapContactadditionResource.containsKey(ARRDetails.Partner_Contact__c)){
		adrList = mapContactadditionResource.get(ARRDetails.Partner_Contact__c);
	}
	adrList.add(ARRDetails);
	mapContactadditionResource.put(ARRDetails.Partner_Contact__c,adrList);
	
	  }
			}
			for(id conId : mapContactadditionResource.keyset() ){
	//Map<id,Additional_Resource_Request__c> existingArrMap = new Map<id,Additional_Resource_Request__c>;
	Set<string> arrSet = new Set<string>();
	if(contactMap.containskey(conId)){
		if(arrToolMap.containskey((contactMap.get(conId).account.partner_type__c))){
			arrSet.addAll(arrToolMap.get(contactMap.get(conId).account.partner_type__c));
			//system.debug('arrSet'+arrSet);
			for(Additional_Resource_Request__c arr : mapContactadditionResource.get(conId)){
	boolean removeArr = true;
	for(string arrt : arrToolMap.get(contactMap.get(conId).account.partner_type__c) ){
		if(arr.Additional_Resource__c == arrt){
			removeArr = false;
			arrSet.remove(arrt);
			break;
		}
		
	}
				if(removeArr == true && !(arr.Additional_Resource__c == PRMGlobalConstants.USAPricing && (arr.Partner_Account__r.Market__c != PRMGlobalConstants.Distibutor))){
					arr.Request_Status__c = PRMGlobalConstants.Remove;
					arr.Partner_Type_Update__c  = PRMGlobalConstants.NO;
					listToUpdate.add(arr);
				}
	
			}
		}
		
	}
			}
			for(id con : contactMap.keyset()){
	boolean gotContact = false;
	for(id conId : mapContactadditionResource.keyset() ){
		if(con == conId ){
			gotContact = true;
		}
	}
	
			}
			Set<Id> arrIds = new  Set<Id> ();
			for(Additional_Resource_Request__c arr1 : listToUpdate){
	arrIds.add(arr1.Id);
			}
			if(!listToUpdate.isEmpty()){
	//database.update(listToUpdate);
	
	
	Database.update(listToUpdate);
	// List<Additional_Resource_Request__c>  arrList = [select id,Partner_Type_Update__c,Request_Status__c,Partner_Contact__c,Additional_Resource__c from Additional_Resource_Request__c where ID In : arrIds];
	//system.debug('RecordKaHaal>>>>' +arrList);
			}
			/*if(!listToInsert.isEmpty()){
			database.insert(listToInsert);
			}*/
		}catch(Exception Ex){
			ExceptionHandler.addException(Ex, PRMGlobalConstants.ACCOUNT_TRIGGER_HELPER_PRM, PRMGlobalConstants.updateARRtools);
			
		}  
	}
	
	
	/********************
		*Method Name: accountOnwerChange
		*Parameter: Map
		*Description: 

	*******************/	  
	public static void accountOnwerChange(Map<id,Account> accountOldMap , Map<id,Account> accountNewMap){
		List<Account> accountListOld = new List<Account>();
		List<Account> accountListNew = new List<Account>();
		try{
			for(Account a : accountNewMap.values()) {
	if(a.ownerId != accountOldMap.get(a.Id).ownerId) {
		accountListOld.add(accountOldMap.get(a.Id));
		accountListNew.add(a);
	}
			}
			if(accountListNew.size() > 0) {
	System.enqueuejob(new  AccountOwnerChangeAsync(accountListOld, accountListNew));
			}
		}catch(Exception e) {
			ExceptionHandler.addException(e, PRMGlobalConstants.ACCOUNT_TRIGGER_HELPER_PRM, PRMGlobalConstants.AccountOwnerChange);
		}
	}
	/********************
		*Method Name: getAccountIdsToDisablePartnerUser
		*Parameter:
		*Description: This method is used to get Account ids for the accounts whose Partner_Disable__c Flag got changed 

	*******************/		 
	public static void getAccountIdsToDisablePartnerUser(Map<id,Account> accountOldMap , Map<id,Account> accountNewMap){
		try{
			Set<ID> accountId = new Set<ID>();
			for(Account acc : accountOldMap.values()){
	if((!accountOldMap.get(acc.Id).Partner_Disable__c) && accountNewMap.get(acc.Id).Partner_Disable__c){
		accountId.add(acc.Id);
	} 
			}
			
			
			if(accountId != null && accountId.size() > 0 ){
	
	//START -- PRM Partner Disable Account Changes
	List<String> ContactFieldInfoLst = System.Label.Info_Contact_OnPartnerDeactivating.split(';');
	Set<Id> partnerConIds = new Set<id>();
	List<Contact> partnerConLst = new List<Contact>();
	Map<String,String> UsrInact_ReasonMap = new Map<String,String>();
	//Label storing Ownerid, Inactive status field information
	UsrInact_ReasonMap.put(ContactFieldInfoLst[2],ContactFieldInfoLst[5]);
	UsrInact_ReasonMap.put(ContactFieldInfoLst[3],ContactFieldInfoLst[4]);
	
	
	//PRM Disabling Partner Users--Query All Contacts related to Account
	for(Contact con : [SELECT Id, User_Create_Status__c, User_Inactive_Reason__c, Accountid, OwnerId FROM Contact WHERE AccountId IN :accountId and Id IN (SELECT ContactId FROM User WHERE AccountId IN: accountId and Profile.UserLicense.Name IN  ('Partner Community', 'Partner Community Login'))]) {
		//PRM Disabling Partner Users--Selecting contacts belonging to partner community | Leaving out Customer Contacts
			con.OwnerId = ContactFieldInfoLst[0];
		
			if(accountNewMap.get(con.accountid) != NULL && UsrInact_ReasonMap.containsKey(accountNewMap.get(con.accountid).Partner_Status__c))
			{
	con.User_Create_Status__c = ContactFieldInfoLst[1];
	con.User_Inactive_Reason__c = UsrInact_ReasonMap.get(accountNewMap.get(con.accountid).Partner_Status__c);
			}
			
			partnerConLst.add(con);
			partnerConIds.add(con.id);
			
	}
	
	
	//PRM Disabling Partner Users--Update Contact Record (Owner, Inactive Status) and Queueable to Update related users
	if(!partnerConLst.isEmpty()) {
		System.enqueueJob(new PRMInactivatePartnerContact_Queueable(partnerConLst));
	}
	  
	//END -- PRM Partner Disable Account Changes
			}
			
		}catch(Exception Ex){ExceptionHandler.addException(Ex,PRMGlobalConstants.ACCOUNT_TRIGGER_HELPER_PRM, PRMGlobalConstants.getAccountIdsToDisablePartnerUser);}
	} 
	/********************
		*Method Name: coopEligibleAccountAccrualandFundCreation
		*Parameter:
		*Description: This method will create Fund for COOP eligible accounts Automattically		
	*******************/
	public static void coopEligibleAccountAccrualandFundCreation(List<Account> accountNewList){
		List<Fund__c> fundList = new List<Fund__c>();
		List<Co_Op_Approvals_Master_Data__c> approvalsList = new List<Co_Op_Approvals_Master_Data__c>();
		Set<Id> accountIds = new Set<Id>();
		Set<Id> accountsWithMainFund = new Set<Id>();
		try{
			User approver = new User();
			for(Account acc : accountNewList){
	accountIds.add(acc.id);
			}
			for(Fund__c fund : [Select Id, Name, Partner_Name__c from Fund__c where Partner_Name__c in : accountIds and PRM_Main_Fund__c = true]){
	accountsWithMainFund.add(fund.Partner_Name__c);
			}
			try{
	approver = [Select Id, Name from User where Email = :Label.PRM_Coop_global_admin limit 1];
			}catch(Exception Ex){
	approver = null;
			}
			for(Account acc : accountNewList){
	if(!accountsWithMainFund.contains(acc.Id)){
		Fund__c fund  = new Fund__c();
		fund.Partner_Name__c = acc.id;
		fund.name =  PRMGlobalConstants.Main_Fund;
		fund.PRM_Main_Fund__c = true;
		fundList.add(fund);
	}
	
	//SFPRM-302 - Automate the creation of the Co-op Approvals Master Data record when an Account is Co-op Eligible
	if(approver != null){
		Co_Op_Approvals_Master_Data__c approval = new Co_Op_Approvals_Master_Data__c();
		approval.Name = acc.Name;
		approval.Partner_Account__c = acc.Id;
		approval.Activity_Approver_Level_1__c = approver.Id;
		approvalsList.add(approval);
	}else{
		acc.addError('The PRM Co-op Global Admin email does not belong to any active user. Please raise a Support Ticket or contact a System Administrator');
	}
			}
			if(fundList != null){
	database.insert(fundList);
			}
			if(approvalsList != null){
	database.insert(approvalsList);
			}
		}catch(Exception Ex){
			ExceptionHandler.addException(Ex,PRMGlobalConstants.ACCOUNT_TRIGGER_HELPER_PRM, PRMGlobalConstants.coopEligibleAccountAccrualandFundCreation);
		}
	}  
	
	/********************
		*Method Name: accountAcreditationUpdate
		*Parameter: 
		*Description: This method will update account on accrdittaion batch update

	*******************/	  
	public static void accountAcreditationUpdate(Map<id,Account> accountOldMap , Map<id,Account> accountNewMap){
		list<Accreditation__c> accredToUpdate = new list<Accreditation__c>();
		set<ID> updatedAccID = new set<ID>();
		set<ID> partLocatorYesAccID = new set<ID>();
		set<ID> partLocatorNoAccID = new set<ID>();
		try{
			for(Account acc : accountNewMap.values()) {
	if((acc.Third_Party_Screening__c != accountOldMap.get(acc.Id).Third_Party_Screening__c) || 
	(acc.Shift_Model__c != accountOldMap.get(acc.Id).Shift_Model__c)){
		updatedAccID.add(acc.id);
	}
	//SFPRM-294 - Rolling 'Display on Partner Locator' field to Accreditations on change
	if(acc.Co_op_Account_Created__c != accountOldMap.get(acc.Id).Co_op_Account_Created__c && acc.Co_op_Account_Created__c == 'Yes'){
		partLocatorYesAccID.add(acc.Id);
	}else if(acc.Co_op_Account_Created__c != accountOldMap.get(acc.Id).Co_op_Account_Created__c && acc.Co_op_Account_Created__c == 'No'){
		partLocatorNoAccID.add(acc.Id);
	}
			}
			if(!updatedAccID.IsEmpty()){
	for(Accreditation__c accred :[select id, name, Partner__c, Partner__r.Shift_Model__c, Partner__r.Third_Party_Screening__c, Evaluated_Accreditation__c 
	from Accreditation__c 
	where Partner__c in : updatedAccID 
	Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
	 accred.Evaluated_Accreditation__c = true;
	 accred.Shift_Model__c = accred.Partner__r.Shift_Model__c;
	 accred.Third_Party_Screening__c = accred.Partner__r.Third_Party_Screening__c;
	 accredToUpdate.add(accred);
	}
	
			}
			//SFPRM-294 - Rolling 'Display on Partner Locator' field to Accreditations on change
			if(!partLocatorYesAccID.IsEmpty()){
	for(Accreditation__c accred :[select id, name, PRM_Display_on_Partner_Locator__c, Partner__r.Co_op_Account_Created__c
	from Accreditation__c 
	where Partner__c in : partLocatorYesAccID 
	and (Accreditation_Level__c = :PRMGlobalConstants.AccredAdvanced or Accreditation_Level__c = :PRMGlobalConstants.AccredExpert or Accreditation_Level__c = :PRMGlobalConstants.AccredPremier)
	Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
	 accred.PRM_Display_on_Partner_Locator__c = accred.Partner__r.Co_op_Account_Created__c;
	 accredToUpdate.add(accred);
	}
			}
			if(!partLocatorNoAccID.IsEmpty()){
	for(Accreditation__c accred :[select id, name, PRM_Display_on_Partner_Locator__c, Partner__r.Co_op_Account_Created__c
	from Accreditation__c 
	where Partner__c in : partLocatorNoAccID
	Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
	 accred.PRM_Display_on_Partner_Locator__c = accred.Partner__r.Co_op_Account_Created__c;
	 accredToUpdate.add(accred);
	}
			}
			if(!accredToUpdate.IsEmpty()){
	database.update(accredToUpdate,false);
			}
		}catch(Exception e) {
			ExceptionHandler.addException(e, PRMGlobalConstants.ACCOUNT_TRIGGER_HELPER_PRM, PRMGlobalConstants.accountAcreditationUpdate);
		}
	}
	
}