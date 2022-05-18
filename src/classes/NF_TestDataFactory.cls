/**
 * @name	NF_TestDataFactory 
 * @author   
 * @since   Dec 28, 2016
 * @desc	This class helps create customized test data, used in test classes
 * @history 
 */
public without sharing class NF_TestDataFactory {
	
	  /*
	 * @desc	this method creates accounts
	 * @param   nb : an integer representing the number of records to createreate
	 * @return  list of Accounts : the created Account' list
	 */
	public static list<Account> getAccounts(Integer nb) {
		list<Account> results = new list<Account>();
		for (integer i = 0; i < nb; i++) {
			results.add(
	new Account(   
		Acc_No__c = 'Test'+i,
		Active__c = true,
		Name = 'Test Account -' + i + Utils.generateRandomInteger(2)+Utils.generateRandomString(2),
		BillingStreet = '1660 International Dr',
		BillingCity = 'McLean',
		BillingState = 'Nunavut',
		BillingPostalCode = '22102',
		BillingCountry = 'Canada',
		AccountStatusInCRMOM__c = 'Active',
		Industry='Applications Partner',
		Market__c='Market North America',
		Country__c='Canada',
		CBT_CT_Code__c='NAM US Regionals',
		RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
			));
		}
		return results;
	}
	
	 /*
	 * @desc	this method creates opportunities
	 * @param   nb : an integer representing the number of records to create
	 * @param   accounts : list of account
	 * @return  list of Opportunities : the created Opportunity' list
	 */
	public static list<Opportunity> getOpportunities(Integer nb, list<Account> accounts) {
		list<Opportunity> results = new list<Opportunity>();

		for (integer i = 0; i < nb; i++) {
			results.add(
	new Opportunity(   
		Name = 'Test'+i,
		AccountId = accounts[Math.mod(i, accounts.size())].id,
		StageName = 'Develop Opportunity',
		Phase_Status__c = 'Opportunity in Progress',
		CloseDate = Date.Today() ,
		G2_Planned_Date__c = Date.today(),
		G3_Planned_Date__c = Date.today(),
		G4_Planned_Date__c = Date.today(),
		G5_Planned_Date__c = Date.today(),
		//G6_Planned_Date__c = Date.today(), 
		Amount = 100+i, 
		Lead_BG__c='MN',
		Lead_BU__c='MN',
		Unweighted_Amount_EUR__c =200+i,
		Account_Role__c = 'GPP Distributor Partner'
	)
			);
		}
		return results;
	}
	
	 /*
	 * @desc	this method creates Opportunity team members
	 * @param   nb : an integer representing the number of records to create
	 * @param   opportunities : list of opportunity
	 * @param   users : list of user
	 * @return  list of  Opportunity team members : the created  Opportunity team members' list
	 */
	public static list<OpportunityTeamMember> getOpportunityTeamMember(Integer nb, list<Opportunity> opportunities,list<User> users) {
		list<OpportunityTeamMember> results = new list<OpportunityTeamMember>();

		for (integer i = 0; i < nb; i++) {
			results.add(
	new OpportunityTeamMember(   
		UserId = users[Math.mod(i, users.size())].id,
		OpportunityId = opportunities[Math.mod(i, opportunities.size())].id
		
	)
			);
		}
		return results;
	}

	/*
	 * @desc	this method creates Approval Request
	 * @param   nb : an integer representing the number of records to create
	 * @param   opportunities : list of opportunity
	 * @param   users : list of user (approvers, contributors, validators)
	 * @return  list of approvalRequest : the created approval request' list
	 */
	public static list<Apttus_Approval__Approval_Request__c> getApprovalRequests(Integer nb, list<Opportunity> opportunities,list<User> users) {
		list<Apttus_Approval__Approval_Request__c> results = new list<Apttus_Approval__Approval_Request__c>();

		for (integer i = 0; i < nb; i++) {
			results.add(
	new Apttus_Approval__Approval_Request__c(   
		Apttus_Approval__Assigned_To_Name__c =  users[Math.mod(i, users.size())].Name,
		Apttus_Approval__Assigned_To_Id__c  =   users[Math.mod(i, users.size())].id,
		Apttus_Approval__DelegateApproverIds__c = users[Math.mod(i, users.size())].id,
		Apttus_Approval__Assigned_To_Type__c =   'User',
		//Apttus_Approval__Approval_Status__c =	 status,
		Apttus_Approval__Object_Type__c = 'Opportunity',
		Apttus_Approval__Object_Id__c  = opportunities[Math.mod(i, opportunities.size())].id,
		Apttus_Approval__Related_Opportunity__c = opportunities[Math.mod(i, opportunities.size())].id,
		//Apttus_Approval__Initial_Submitter__c = userId,
		
		Apttus_Approval__Notify_Only__c = true,
		Apttus_Approval__Send_Email__c = false,
		Apttus_Approval__Active__c = true
	)
			);
		}
		return results;
	}
	
	/*
	 * @desc	this method creates users
	 * @param   nb : an integer representing the number of records to create
	 * @param   profileName : the profile to associate to users
	 * @return  list of users : the created user' list
	 */
	public static list<User> getUsers(Integer nb, string profileName) {
		list<User> results = new list<User>();
		ID profileID = [SELECT Id 
			FROM Profile 
			WHERE Name = :profileName
		].Id;
		 Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		for (integer i = 0; i < nb; i++) {
			results.add(
	new User(	
			LastName = 'LastName'+i,
			FirstName = 'FirstName'+i,
			Username = newGUID()+i + '@nokia.com',
			Email = 'test'+i+'@nokia.com',
			alias = 'alias'+i,
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'ISO-8859-1',
			ProfileId = profileID,
			LanguageLocaleKey = 'en_US',
			Nokia_ID__c = randomInt + '0'
	)
			);
		}
		return results;
	}
	
	/*
	 * @desc	
	 * @return  string
	 */
	public static String newGUID(){
		Blob b = Crypto.GenerateAESKey(128);
		String h = EncodingUtil.ConvertTohex(b);
		String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
		return guid;
	}

	 /*
	 * @desc  this method used to create user to be used in test classes
	 * @param  profile name
	 * @return  the created user
	 */
	public static User createAdminUser(String profileName) {

		Profile p;
		User u;
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		p = [SELECT Id FROM Profile WHERE Name = :profileName];

		u = new User();
		u.LastName = 'alias1';
		u.FirstName = 'Joe';
		u.Username = newGUID() + '@nokia.com';
		u.Email = 'test@nokia.com';
		u.alias = 'alias1';
		u.TimeZoneSidKey = 'America/Los_Angeles';
		u.LocaleSidKey = 'en_US';
		u.EmailEncodingKey = 'ISO-8859-1';
		u.ProfileId = p.Id;
		u.LanguageLocaleKey = 'en_US';
		u.Nokia_ID__c = randomInt + '0';
		return u;
	}
	 /*
	 * @desc  
	 * @param  
	 * @return  the created account
	 */
	public static Account createAccount(String accountNumber){
		return new Account(Acc_No__c = accountNumber,
	Active__c = true,
	Name = 'Test Account -',
	BillingStreet = '1660 International Dr',
	BillingCity = 'McLean',
	BillingState = 'Nunavut',
	BillingPostalCode = '22102',
	BillingCountry = 'Canada',
	AccountStatusInCRMOM__c = 'Active',
	Industry='Applications Partner',
	Market__c='Market North America',
	Country__c='Canada',
	CBT_CT_Code__c='NAM US Regionals',
	Partner_Program__c='GPP 3.0',
	RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
	);
	}
	
	
	  /*
	 * @desc	this method creates Compitator accounts
	 * @param   nb : an integer representing the number of records to create
	 * @return  list of Accounts : the created Account' list
	 */
	public  static Account getComAccounts(String accountNumber) {
		return new Account(Acc_No__c = accountNumber,
	Active__c = true,
	Name = 'Test Account -',
	BillingStreet = '1660 International Dr',
	BillingCity = 'McLean',
	BillingState = 'Virginia',
	BillingPostalCode = '22102',
	BillingCountry = 'Canada',
	AccountStatusInCRMOM__c = 'Active',
	Industry='Applications Partner',
	Market__c='',
	Country__c='Canada',
	CBT_CT_Code__c='NAM US Regionals',
	Type='Customer',
	CountryCode__c='CA',
		
	RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId()
	);
	}

	 /*
	 * @desc 
	 * @param  
	 * @return  
	 */
	public static Opportunity createOpportunity(String accountId, String stageName, String phaseStatus, Date closeDate, Decimal amount){
		Opportunity myOpp = new Opportunity(Name='NF Opportunity', AccountID = accountID, StageName = stageName, Phase_Status__c=  phaseStatus, CloseDate = closeDate, 
		G2_Planned_Date__c = Date.today(), G3_Planned_Date__c = Date.today() + 1, G4_Planned_Date__c = Date.today() + 2, G5_Planned_Date__c = Date.today() + 3,
		Amount = amount, Unweighted_Amount_EUR__c = amount);
		myOpp.Lead_BG__c='MN';
		myOpp.Lead_BU__c = 'MN';
		return myOpp;
	}
	 /*
	 * @desc  
	 * @param  
	 * @return  the created Apttus_Approval__ApprovalRequest__c
	 */
	public static Apttus_Approval__Approval_Request__c createApprovalRequest(String status, String userType, String objectType, 
		String oppId, Boolean notifyOnly, Boolean sendEmail, String userName, String userId, String raName){
		Apttus_Approval__Approval_Request__c myAR = new Apttus_Approval__Approval_Request__c(
			Apttus_Approval__Assigned_To_Name__c=   userName,
			Apttus_Approval__Assigned_To_Id__c  =   userId,
			Apttus_Approval__Assigned_To_Type__c=   userType,
			Apttus_Approval__Approval_Status__c =   status,
			Apttus_Approval__Object_Type__c = objectType,
			Apttus_Approval__Object_Id__c  = oppId,
			Apttus_Approval__Related_Opportunity__c = oppId,
			Apttus_Approval__Initial_Submitter__c = userId,

			Apttus_Approval__Notify_Only__c = notifyOnly,
			Apttus_Approval__Send_Email__c = sendEmail,
			Apttus_Approval__Active__c = true,
			Apttus_Approval__SubstepName__c = raName
		);
		return myAR;
	}
	

	
	 /*
	 * @desc  
	 * @param  
	 * @return 
	 * @Accenture-May 04-changed role owner date type from decimal to string
	 */
	public static Sales_Role__c createSalesRole(User userVar, String roleCode, String org, String roleName) {
	return new Sales_Role__c(Role_Code__c = roleCode, User__c = userVar.Id,
		Organisation__c = org,
		Role_Name__c = roleName,Process_SRT_Audit__c=false);
	}
	 

	public static Apttus_Approval__ApprovalRuleAssignee__c createArAssignee(String ruleEntryId, Integer sequence, 
	Boolean notifyOnly, Boolean sendEmail, String assigneeValue){
		return new Apttus_Approval__ApprovalRuleAssignee__c(Apttus_Approval__RuleEntryId__c = ruleEntryId, Apttus_Approval__Sequence__c = sequence, 
			Apttus_Approval__NotifyOnly__c = notifyOnly, Apttus_Approval__SendEmail__c = sendEmail, Apttus_Approval__AssigneeValue__c = assigneeValue);
	}

	public static Apttus_Approval__ApprovalRuleEntry__c createRuleEntry(String ruleId, Integer sequence){
		return new Apttus_Approval__ApprovalRuleEntry__c(Apttus_Approval__ApprovalRuleId__c = ruleId, Apttus_Approval__Sequence__c = sequence);
	}

	public static Apttus_Approval__ApprovalRule__c createApprovalRule(String ruleName, Boolean isActive, String busObject, String ruleType, Integer sequence){
		return new Apttus_Approval__ApprovalRule__c(Name = ruleName, Apttus_Approval__Active__c = isActive, Apttus_Approval__BusinessObject__c = busObject, 
	Apttus_Approval__RuleType__c = ruleType, Apttus_Approval__Sequence__c = sequence);
	}

	public static Apttus_Approval__Approval_Request_History__c createApprovalHistoryRequest(String status, String userType, String objectType, 
		String oppId, Boolean notifyOnly, Boolean sendEmail, String userName, String userId, String raName){
		Apttus_Approval__Approval_Request_History__c myAR = new Apttus_Approval__Approval_Request_History__c(
			Apttus_Approval__Assigned_To_Name__c=   userName,
			Apttus_Approval__Assigned_To_Id__c  =   userId,
			Apttus_Approval__Assigned_To_Type__c=   userType,
			Apttus_Approval__Approval_Status__c =   status,
			Apttus_Approval__Object_Type__c = objectType,
			Apttus_Approval__Object_Id__c  = oppId,
			Apttus_Approval__Related_Opportunity__c = oppId,
			Apttus_Approval__Initial_Submitter__c = userId,

			Apttus_Approval__Notify_Only__c = notifyOnly,
			Apttus_Approval__Send_Email__c = sendEmail,
			Apttus_Approval__Active__c = true,
			Apttus_Approval__SubstepName__c = raName
		);
		return myAR;
	}

 /*
	 * @desc	this method creates Territory
	 * @param   Name : Organisation Name
	 * @param   H_Level : Hierarchy_Level
	 * @param   T2Model : Territory2ModelId
	 * @param   T2Type : Territory2TypeId
	 * @return  the created Territory
	 */
	 
	public static Territory2 CreateTerritory2(String Name,String H_level,Id T2Model, Id T2Type ) {
		String DevName = Name.replaceAll(' ','_');
		Territory2 results = new Territory2(   
		AccountAccessLevel = 'Edit',
		CaseAccessLevel = 'Read',
		ContactAccessLevel = 'Edit',
		Description = DevName,
		DeveloperName = DevName,
		Name = Name,
		Hierarchy_Level__c = H_level,
		OpportunityAccessLevel = 'Edit',
		Territory2ModelId = T2Model,
		Territory2TypeId = T2Type
		);
		return results;
	}
}