/**
About
-----
Description: This Class is used as Test Class for UserTrigger, UserTriggerHelper and  UserTriggerHandler

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
----------------
Created: 26/05/2020 – joao.5.rodrigues@nokia.com
-------------
**/
@isTest
public with sharing class UserTriggerTest 
{
	@testSetup 
	static void datasetup() 
	{
		//Set project manager as PSRO in metadata
		PSRO_Costs_Visibilities_Manager__mdt psroMD = new PSRO_Costs_Visibilities_Manager__mdt();
		psroMD.BG__c = 'NSW';
		psroMD.Role_Name__c = 'Project Manager';
		
		//NF_RoleCode__c
		List<NF_RoleCode__c> roleCodeList = new List<NF_RoleCode__c>();
			NF_RoleCode__c roleCode = new NF_RoleCode__c();
			roleCode.Name = 'NSNE_BGPM';
			roleCode.Role_Name__c = 'BG Project Manager';
			roleCode.BG_Attribute__c = 'NSW;FN;ION;MN;GS;NEN';
			roleCode.Hierarchy_Level__c = 'L4';
			roleCode.A_S__c = false;
			roleCodeList.add(roleCode);
			
			NF_RoleCode__c roleCode2 = new NF_RoleCode__c();
			roleCode2.Name = 'NSNA_APA';
			roleCode2.Role_Name__c = 'BG Level A Approver';
			roleCode2.BG_Attribute__c = 'NSW;FN;ION;MN;GS;NEN';
			roleCode2.Hierarchy_Level__c = 'L4';
			roleCode2.A_S__c = false;
			roleCodeList.add(roleCode2);
			
			insert roleCodeList; 
		
		List<User> oUser = TestDataFactory.userCreation(1,'Nokia Sales Profile');
			insert oUser;
		
		List<User> oUserAdmin = TestDataFactory.userCreation(1,'System Administrator');
			insert oUserAdmin;

		List<Account> oAccounts = TestDataFactory.createAccount(1);
			//Added By Chaitanya
			insert oAccounts;
			
		User oAdminUser = TestDataFactory.createUser('Admin', 'AdminTest');
		insert oAdminUser;
	}
	
	static testMethod void testInactivateUser(){   
		List<User> oUser = [select id,Profile.Name from User where lastname =:'AdminTest' limit 1];  
		List<User> oUsers = [select id,Profile.Name from User where Profile.Name=:'System Administrator' limit 1];  
		Test.startTest();
		System.runAs(oUser[0]){
			
			system.assertEquals(false,oUsers.isEmpty());
			User userUpdate = new User();
			userUpdate.id = oUsers[0].id;
			userUpdate.IsActive = false;
			update userUpdate;  
		}
		Test.stopTest();
	}
	
	static testMethod void testCurrentUserAccount(){
		List<User> oUsers = [select id,Profile.Name from User where lastname =:'AdminTest' limit 1]; 
		Test.startTest();
			System.runAs(oUsers[0]){
	List<Account> oAccounts=[select id from Account limit 1];
	System.assertEquals(false,oAccounts.isEmpty());
	if(!oAccounts.isEmpty()){
		EM_User.getCurrentUserAccount(oAccounts[0].Id);
	}
			}
		Test.stopTest();  
	}
	
	static testMethod void getCurrentUserTest(){
		User getCurrentUser;
		User getCurrentUserOwner;
		Test.startTest(); 
			List<User> userList = [select id from User where id=:UserInfo.getUserId()];
			getCurrentUser = EM_User.getCurrentUser(userList[0].id);
			getCurrentUserOwner = EM_User.getCurrentUserOwner(userList[0].id);
		Test.stopTest();
	  }
	
	static testMethod void updateUserRestrictionLevel()
	{
		List<User> oUser = [select id,Profile.Name from User where lastname =:'AdminTest' limit 1]; 
		System.runAs(oUser[0])
		{
			Test.startTest();
			
			List<User> oUsers = TestDataFactory.userCreation(2,'Nokia Sales Profile');
			GlobalConstants.RUN_USER_TRIGGER_ON_FILESHARING = true;
			GlobalConstants.STOP_TRIGGER_USER_ON_BEFOREINSERT = false;
			oUsers[0].Restriction_Level__c = 'Confidential';
			oUsers[0].NSA_Compliant__c = true;
			oUsers[0].IsActive = true;
			oUsers[1].Restriction_Level__c = 'Unrestricted';
			oUsers[1].NSA_Compliant__c = true;
			oUsers[1].IsActive = true;
			insert oUsers;
			//User0 should have the permission set, User1 should not
			
			oUsers[0].NSA_Compliant__c = false;
			oUsers[1].Restriction_Level__c = 'Confidential';
			update oUsers;
			
			//Add user to sales role as project manager
			List<Sales_Role__c> salesRoleList = new List<Sales_Role__c>();
			Sales_Role__c managerRole1 = new Sales_Role__c();
			managerRole1.Organisation__c = 'Market Europe';
			managerRole1.Role_Code__c = 'NSNE_BGPM';
			managerRole1.Role_Name__c = '4 - BG Project Manager';
			managerRole1.User__c = oUsers[0].Id;
			salesRoleList.add(managerRole1);
			Sales_Role__c managerRole2 = new Sales_Role__c();
			managerRole2.Organisation__c = 'Market Europe';
			managerRole2.Role_Code__c = 'NSNA_APA';
			managerRole2.Role_Name__c = '4 - BG Level A Approver';
			managerRole2.User__c = oUsers[0].Id;
			salesRoleList.add(managerRole2);
			insert salesRoleList; 
			
			oUsers[0].Restriction_Level__c = 'Unrestricted';
			oUsers[0].NSA_Compliant__c = true;
			oUsers[1].IsActive = false;
			//User0 should have the permission set, User1 should not have the permission set
			update oUsers;
			
			//Increasing coverage
			Set<Id> userIds = new Set<Id>();
			for(User u : oUsers)
			{
	userIds.add(u.Id);
			}
			UserTriggerHelper.removePermissionSetOnUpdate(userIds);
			
			Test.stopTest();
		}
	}
	
	static testMethod void addSalesRoleTest(){
		List<User> oUser = [select id,Profile.Name,lastname  from User where lastname =:'AdminTest' limit 1]; 
		Test.startTest();
			System.runAs(oUser[0]){
	 List<User> userList = [select id,Profile.Name from User where Profile.Name=:'Nokia Sales Profile' limit 1];  
	 //Add user to sales role as project manager in test setup
	 //Increasing coverage
	 Set<Id> userIds = new Set<Id>();
	 for(User u : userList){
		userIds.add(u.Id);
	 }
	 UserTriggerHelper.removePermissionSetOnUpdate(userIds);
			} 
	Test.stopTest(); 
	}
		static testMethod void updateUserRestrictionLevel1()
	{
		List<User> oUser = [select id,Profile.Name from User where lastname =:'AdminTest' limit 1]; 
		System.runAs(oUser[0])
		{
			Test.startTest();
			
			List<User> oUsers = TestDataFactory.userCreation(2,'Nokia Sales Profile');
			GlobalConstants.RUN_USER_TRIGGER_ON_FILESHARING = true;
			GlobalConstants.STOP_TRIGGER_USER_ON_BEFOREINSERT = false;
			oUsers[0].Restriction_Level__c = 'Confidential';
			oUsers[0].NSA_Compliant__c = true;
			oUsers[0].NCP_Is_Internal__c = true;
			oUsers[0].IsActive = true;
			oUsers[1].Restriction_Level__c = 'Unrestricted';
			oUsers[1].NSA_Compliant__c = true;
			oUsers[1].NCP_Is_Internal__c = true;
			oUsers[1].IsActive = true;
			insert oUsers;
			//User0 should have the permission set, User1 should not
			
			oUsers[0].NSA_Compliant__c = false;
			oUsers[1].Restriction_Level__c = 'Confidential';
			update oUsers;
			
			//Add user to sales role as project manager
			List<Sales_Role__c> salesRoleList = new List<Sales_Role__c>();
			Sales_Role__c managerRole1 = new Sales_Role__c();
			managerRole1.Organisation__c = 'Market Europe';
			managerRole1.Role_Code__c = 'NSNE_BGPM';
			managerRole1.Role_Name__c = '4 - BG Project Manager';
			managerRole1.User__c = oUsers[0].Id;
			salesRoleList.add(managerRole1);
			Sales_Role__c managerRole2 = new Sales_Role__c();
			managerRole2.Organisation__c = 'Market Europe';
			managerRole2.Role_Code__c = 'NSNA_APA';
			managerRole2.Role_Name__c = '4 - BG Level A Approver';
			managerRole2.User__c = oUsers[0].Id;
			salesRoleList.add(managerRole2);
			insert salesRoleList; 
			
			oUsers[0].Restriction_Level__c = 'Unrestricted';
			oUsers[0].NSA_Compliant__c = true;
			oUsers[1].IsActive = false;
			//User0 should have the permission set, User1 should not have the permission set
			update oUsers;
			
			//Increasing coverage
			Set<Id> userIds = new Set<Id>();
			for(User u : oUsers)
			{
	userIds.add(u.Id);
			}
			UserTriggerHelper.removePermissionSetOnUpdate(userIds);
			
			Test.stopTest();
		}
	}
	static testMethod void updateUserRestrictionLevel2()
	{
		List<User> oUser = [select id,Profile.Name from User where lastname =:'AdminTest' limit 1]; 
		System.runAs(oUser[0])
		{
			Test.startTest();
			User userAssistant1 = TestDataFactory.createUser('Admin', 'Assistant 1');
			insert userAssistant1;
			List<User> oUsers = TestDataFactory.userCreation(2,'Nokia Sales Profile');
			GlobalConstants.RUN_USER_TRIGGER_ON_FILESHARING = true;
			GlobalConstants.STOP_TRIGGER_USER_ON_BEFOREINSERT = false;
			oUsers[0].Restriction_Level__c = 'Confidential';
			oUsers[0].NSA_Compliant__c = true;
			oUsers[0].NCP_Is_Internal__c = true;
			oUsers[0].IsActive = true;
			oUsers[0].GLT_Assistant__c = userAssistant1.Id ;
			oUsers[1].Restriction_Level__c = 'Unrestricted';
			oUsers[1].NSA_Compliant__c = true;
			oUsers[1].NCP_Is_Internal__c = true;
			oUsers[1].IsActive = true;
			oUsers[1].GLT_Assistant__c = userAssistant1.Id ;
			insert oUsers;
			//User0 should have the permission set, User1 should not
			
			oUsers[0].NSA_Compliant__c = false;
			oUsers[1].Restriction_Level__c = 'Confidential';
			update oUsers;
			
			//Add user to sales role as project manager
			List<Sales_Role__c> salesRoleList = new List<Sales_Role__c>();
			Sales_Role__c managerRole1 = new Sales_Role__c();
			managerRole1.Organisation__c = 'Market Europe';
			managerRole1.Role_Code__c = 'NSNE_BGPM';
			managerRole1.Role_Name__c = '4 - BG Project Manager';
			managerRole1.User__c = oUsers[0].Id;
			salesRoleList.add(managerRole1);
			Sales_Role__c managerRole2 = new Sales_Role__c();
			managerRole2.Organisation__c = 'Market Europe';
			managerRole2.Role_Code__c = 'NSNA_APA';
			managerRole2.Role_Name__c = '4 - BG Level A Approver';
			managerRole2.User__c = oUsers[0].Id;
			salesRoleList.add(managerRole2);
			insert salesRoleList; 
			
			oUsers[0].Restriction_Level__c = 'Unrestricted';
			oUsers[0].NSA_Compliant__c = true;
			oUsers[1].IsActive = false;
			oUsers[0].GLT_Assistant__c = userAssistant1.Id ;
			oUsers[1].GLT_Assistant__c = userAssistant1.Id ;
			//User0 should have the permission set, User1 should not have the permission set
			update oUsers;
			
			//Increasing coverage
			Set<Id> userIds = new Set<Id>();
			for(User u : oUsers)
			{
	userIds.add(u.Id);
			}
			UserTriggerHelper.removePermissionSetOnUpdate(userIds);
			
			Test.stopTest();
		}
	}
		static testMethod void updateUserRestrictionLevel3()
	{
		List<User> oUser = [select id,Profile.Name from User where lastname =:'AdminTest' limit 1]; 
		System.runAs(oUser[0])
		{
			Test.startTest();
			User userAssistant1 = TestDataFactory.createUser('Admin', 'Assistant 1');
			insert userAssistant1;
			List<User> oUsers = TestDataFactory.userCreation(2,'Nokia Sales Profile');
			GlobalConstants.RUN_USER_TRIGGER_ON_FILESHARING = true;
			GlobalConstants.STOP_TRIGGER_USER_ON_BEFOREINSERT = false;
			oUsers[0].Restriction_Level__c = 'Confidential';
			oUsers[0].NSA_Compliant__c = true;
			oUsers[0].NCP_Is_Internal__c = true;
			oUsers[0].IsActive = true;
			oUsers[0].GLT_Assistant__c = userAssistant1.Id ;
			oUsers[1].Restriction_Level__c = 'Unrestricted';
			oUsers[1].NSA_Compliant__c = true;
			oUsers[1].NCP_Is_Internal__c = true;
			oUsers[1].IsActive = true;
			oUsers[1].GLT_Assistant__c = userAssistant1.Id ;
			insert oUsers;
			//User0 should have the permission set, User1 should not
			
			oUsers[0].NSA_Compliant__c = false;
			oUsers[1].Restriction_Level__c = 'Confidential';
			oUsers[0].GLT_Assistant__c = Null ;
			oUsers[1].GLT_Assistant__c = null ;
			update oUsers;
			
			//Add user to sales role as project manager
			List<Sales_Role__c> salesRoleList = new List<Sales_Role__c>();
			Sales_Role__c managerRole1 = new Sales_Role__c();
			managerRole1.Organisation__c = 'Market Europe';
			managerRole1.Role_Code__c = 'NSNE_BGPM';
			managerRole1.Role_Name__c = '4 - BG Project Manager';
			managerRole1.User__c = oUsers[0].Id;
			salesRoleList.add(managerRole1);
			Sales_Role__c managerRole2 = new Sales_Role__c();
			managerRole2.Organisation__c = 'Market Europe';
			managerRole2.Role_Code__c = 'NSNA_APA';
			managerRole2.Role_Name__c = '4 - BG Level A Approver';
			managerRole2.User__c = oUsers[0].Id;
			salesRoleList.add(managerRole2);
			insert salesRoleList; 
			
			oUsers[0].Restriction_Level__c = 'Unrestricted';
			oUsers[0].NSA_Compliant__c = true;
			oUsers[1].IsActive = false;
			oUsers[0].GLT_Assistant__c = Null ;
			oUsers[1].GLT_Assistant__c = null ;
			//User0 should have the permission set, User1 should not have the permission set
			update oUsers;
			
			//Increasing coverage
			Set<Id> userIds = new Set<Id>();
			for(User u : oUsers)
			{
	userIds.add(u.Id);
			}
			UserTriggerHelper.removePermissionSetOnUpdate(userIds);
			
			Test.stopTest();
		}
	}
	static testMethod void updateUserRestrictionLevel4()
	{
		List<User> oUser = [select id,Profile.Name from User where lastname =:'AdminTest' limit 1]; 
		System.runAs(oUser[0])
		{
			Test.startTest();
			User userAssistant1 = TestDataFactory.createUser('Admin', 'Assistant 1');
			insert userAssistant1;
			List<User> oUsers = TestDataFactory.userCreation(2,'Nokia Sales Profile');
			GlobalConstants.RUN_USER_TRIGGER_ON_FILESHARING = true;
			GlobalConstants.STOP_TRIGGER_USER_ON_BEFOREINSERT = false;
			oUsers[0].Restriction_Level__c = 'Confidential';
			oUsers[0].NSA_Compliant__c = true;
			oUsers[0].NCP_Is_Internal__c = true;
			oUsers[0].IsActive = true;
			oUsers[0].GLT_Assistant__c = null ;
			oUsers[1].Restriction_Level__c = 'Unrestricted';
			oUsers[1].NSA_Compliant__c = true;
			oUsers[1].NCP_Is_Internal__c = true;
			oUsers[1].IsActive = true;
			oUsers[1].GLT_Assistant__c = null ;
			insert oUsers;
			//User0 should have the permission set, User1 should not
			
			oUsers[0].NSA_Compliant__c = false;
			oUsers[1].Restriction_Level__c = 'Confidential';
			oUsers[0].GLT_Assistant__c = Null ;
			oUsers[1].GLT_Assistant__c = null ;
			update oUsers;
			
			//Add user to sales role as project manager
			List<Sales_Role__c> salesRoleList = new List<Sales_Role__c>();
			Sales_Role__c managerRole1 = new Sales_Role__c();
			managerRole1.Organisation__c = 'Market Europe';
			managerRole1.Role_Code__c = 'NSNE_BGPM';
			managerRole1.Role_Name__c = '4 - BG Project Manager';
			managerRole1.User__c = oUsers[0].Id;
			salesRoleList.add(managerRole1);
			Sales_Role__c managerRole2 = new Sales_Role__c();
			managerRole2.Organisation__c = 'Market Europe';
			managerRole2.Role_Code__c = 'NSNA_APA';
			managerRole2.Role_Name__c = '4 - BG Level A Approver';
			managerRole2.User__c = oUsers[0].Id;
			salesRoleList.add(managerRole2);
			insert salesRoleList; 
			
			oUsers[0].Restriction_Level__c = 'Unrestricted';
			oUsers[0].NSA_Compliant__c = true;
			oUsers[1].IsActive = false;
			oUsers[0].GLT_Assistant__c = userAssistant1.Id ;
			oUsers[1].GLT_Assistant__c = userAssistant1.Id ;
			//User0 should have the permission set, User1 should not have the permission set
			update oUsers;
			
			//Increasing coverage
			Set<Id> userIds = new Set<Id>();
			for(User u : oUsers)
			{
	userIds.add(u.Id);
			}
			UserTriggerHelper.removePermissionSetOnUpdate(userIds);
			
			Test.stopTest();
		}
	}
	static testMethod void updateUserRestrictionLevel5()
	{
		List<User> oUser = [select id,Profile.Name from User where lastname =:'AdminTest' limit 1]; 
		System.runAs(oUser[0])
		{
			Test.startTest();
			User userAssistant1 = TestDataFactory.createUser('Admin', 'Assistant 1');
			insert userAssistant1;
			User userAssistant2 = TestDataFactory.createUser('Admin', 'Assistant 2');
			insert userAssistant2;
			List<User> oUsers = TestDataFactory.userCreation(2,'Nokia Sales Profile');
			GlobalConstants.RUN_USER_TRIGGER_ON_FILESHARING = true;
			GlobalConstants.STOP_TRIGGER_USER_ON_BEFOREINSERT = false;
			oUsers[0].Restriction_Level__c = 'Confidential';
			oUsers[0].NSA_Compliant__c = true;
			oUsers[0].NCP_Is_Internal__c = true;
			oUsers[0].IsActive = true;
			oUsers[0].GLT_Assistant__c = userAssistant1.Id  ;
			oUsers[1].GLT_Assistant__c = userAssistant1.Id  ;
			oUsers[1].Restriction_Level__c = 'Unrestricted';
			oUsers[1].NSA_Compliant__c = true;
			oUsers[1].NCP_Is_Internal__c = true;
			oUsers[1].IsActive = true;
			
			insert oUsers;
			//User0 should have the permission set, User1 should not
			
			oUsers[0].NSA_Compliant__c = false;
			oUsers[1].Restriction_Level__c = 'Confidential';
			oUsers[0].GLT_Assistant__c = userAssistant2.Id;
			oUsers[1].GLT_Assistant__c = userAssistant2.Id;
			update oUsers;
			
			//Add user to sales role as project manager
			List<Sales_Role__c> salesRoleList = new List<Sales_Role__c>();
			Sales_Role__c managerRole1 = new Sales_Role__c();
			managerRole1.Organisation__c = 'Market Europe';
			managerRole1.Role_Code__c = 'NSNE_BGPM';
			managerRole1.Role_Name__c = '4 - BG Project Manager';
			managerRole1.User__c = oUsers[0].Id;
			salesRoleList.add(managerRole1);
			Sales_Role__c managerRole2 = new Sales_Role__c();
			managerRole2.Organisation__c = 'Market Europe';
			managerRole2.Role_Code__c = 'NSNA_APA';
			managerRole2.Role_Name__c = '4 - BG Level A Approver';
			managerRole2.User__c = oUsers[0].Id;
			salesRoleList.add(managerRole2);
			insert salesRoleList; 
			
			oUsers[0].Restriction_Level__c = 'Unrestricted';
			oUsers[0].NSA_Compliant__c = true;
			oUsers[1].IsActive = false;
			oUsers[0].GLT_Assistant__c = userAssistant2.Id;
			oUsers[1].GLT_Assistant__c = userAssistant2.Id;
			//User0 should have the permission set, User1 should not have the permission set
			update oUsers;
			
			//Increasing coverage
			Set<Id> userIds = new Set<Id>();
			for(User u : oUsers)
			{
	userIds.add(u.Id);
			}
			UserTriggerHelper.removePermissionSetOnUpdate(userIds);
			
			Test.stopTest();
		}
	}
	
	static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
  
  static testMethod void testBatchEventShare1() {
	
   
	Account customerAcc = new Account(
	  name='Batch test' + Utils.generateRandomInteger(4), 
	  RecordTypeId=accRecordTypeId,
	  Active__c = true,
	  AccountStatusInCRMOM__c = 'Active'
	);
	
	insert customerAcc;
	
	Venue__c venue = new Venue__c(Name = 'Test Venue');
	insert venue;
	
	User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
	insert oAdminUser;
	
	User participant1 = TestDataFactory.createUser('Admin', 'Test Part 1');
	insert participant1;

	User userAssistant1 = TestDataFactory.createUser('Admin', 'Assistant 1');
	insert userAssistant1;
	
	User participant2 = TestDataFactory.createUser('Admin', 'Test Part 2');
	participant2.GLT_Assistant__c = userAssistant1.Id;
	insert participant2;
	
	User userAssistant2 = TestDataFactory.createUser('Admin', 'Assistant 2');
	insert userAssistant2;
	
	User participant3 = TestDataFactory.createUser('Admin', 'Test Part 3');
	participant3.GLT_Assistant__c = userAssistant2.ID;
	insert participant3;
	
	User participant4 = TestDataFactory.createUser('Admin', 'Test Part 4');
	insert participant4;
	
	List<User> participants = new List<User>();
	participants.add(participant1);
	participants.add(participant2);
	participants.add(participant3);
		
	System.runAs(oAdminUser) {
	  
	  //1.Create Event
	  
	  Event__c event = new Event__c(
		Account__c = customerAcc.Id,
		Event_host__c = participant4.Id,
		Marketing__c = oAdminUser.Id,
		Event_level__c = 'Executive',
		Event_Type__c = 'ERM - Executive Review Meeting',
		Event_Start_Date__c = System.today().addDays(50),
		Event_End_Date__c = System.today().addDays(54),
		RecordTypeId = Schema.SObjectType.Event__c.getRecordTypeInfosByDeveloperName().get('ERM').getRecordTypeId(),
		Venue__c = venue.Id
	  );
	  
	  ERM_CreateEventAsynchQueue.doChainJob = false;
	  insert event;
	  
	  //2.Create Participants
	  Id recordTypePart = Schema.SObjectType.Event_Registration__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
	  List<Event_Registration__c> participantsLst = new List<Event_Registration__c>();
	  Event_Registration__c part = new Event_Registration__c();
	  for(User participant : participants)
	  {
		part = new Event_Registration__c(
		  Event__c = event.Id,
		  RecordTypeId = recordTypePart,
		  Role__c = 'CT Member',
		  User__c = participant.Id
		);
		
		participantsLst.add(part);
	  }

	  insert participantsLst;
	  
	  
	  //3.Create Sessions
	  Event__c eventRefresh = [Select id, name from Event__c where id = :event.Id limit 1];
	  List<Session__c> sessions = new List<Session__c>();
	  for(Integer i = 0 ; i < 2 ; i++)
	  {
		Session__c session = new Session__c(
		  Name = eventRefresh.Name + ' - Session ' + i,
		  Start_time__c = System.today().addDays(50+i),
		  Start_hour__c = Time.newInstance(10,0,0,0),
		  End_time__c = System.today().addDays(50+i),
		  End_hour__c = Time.newInstance(18,0,0,0), 
		  Session_Status__c = 'Pending',
		  Session_Type__c = 'Presentation',
		  Owner__c = i == 0 ? participants[2].Id : null,
		  Event__c = eventRefresh.Id
		);
		sessions.add(session);
	  }

	  insert sessions;
	  
	}

	Test.startTest();
	
	ERM_Sharing_Script obj = new ERM_Sharing_Script();
	DataBase.executeBatch(obj); 
	
	Test.stopTest();
	  
	
  }
}