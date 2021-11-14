/**
About
-----
Description: This Class is used as Test Class for UserTrigger, UserTriggerHelper and  UserTriggerHandler

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
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
}