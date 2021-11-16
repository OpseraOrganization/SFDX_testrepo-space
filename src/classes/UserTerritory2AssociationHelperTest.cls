/****************************************
* Name : Batch_UserTerritory2AssociationTest 
* Author : Accenture
* Description : Test class for Batch_UserTerritoryRemoval,Batch_UserTerritoryAddition
*****************************************/
@isTest
private class UserTerritory2AssociationHelperTest {/*
	Private Static List<User> userList = new List<User>();
	Private Static List<Account> accList = new List<Account>();
	Private Static List<ObjectTerritory2Association> objTerritory2AssociationList = new List<ObjectTerritory2Association>();
	Private Static List<UserTerritory2Association> userAssignedToTerritoryList = new List<UserTerritory2Association>();
	Private Static List<UserTerritory2Association> UserTerritory2AssociationIdList = new List<UserTerritory2Association>();
	Private Static List<UserTerritory2Association> userAssignedToTerritoryList1 = new List<UserTerritory2Association>();
	 Private Static List<List<UserTerritory2Association>> UserTerritory2AssociationListList = new List<List<UserTerritory2Association>>();
	@testsetup
	static void setUp(){
		File_Sharing_Custom_Setting__c csCountFileSharing = new File_Sharing_Custom_Setting__c();
		csCountFileSharing.Name = GlobalConstants.ALLOWED_TOTAL_FILE_SHARE_LIMIT;
		csCountFileSharing.Value__c = '5' ;
		database.insert(csCountFileSharing); 
		 File_Sharing_Custom_Setting__c csSchedulingTime = new File_Sharing_Custom_Setting__c();
		csSchedulingTime.Name = GlobalConstants.SCHEDULINGTIME;
		csSchedulingTime.Value__c = '2' ;
		database.insert(csSchedulingTime) ;  
		File_Sharing_Custom_Setting__c csReschedulingTime = new File_Sharing_Custom_Setting__c();
		csReschedulingTime.Name = GlobalConstants.RESCHEDULINGTIME;
		csReschedulingTime.Value__c = '900' ;
		database.insert(csReschedulingTime) ;  
		File_Sharing_Custom_Setting__c csTerritoriesForSharing = new File_Sharing_Custom_Setting__c();
		csTerritoriesForSharing.Name = GlobalConstants.ALLOWED_TERRITORIES;
		csTerritoriesForSharing.Value__c = 'L7' ;
		database.insert(csTerritoriesForSharing);
	   
		File_Sharing_Custom_Setting__c csUserTerritoryAdditionBatchSize = new File_Sharing_Custom_Setting__c();
		csUserTerritoryAdditionBatchSize.Name = GlobalConstants.USERTERRITORYADDITIONBATCHSIZE;
		csUserTerritoryAdditionBatchSize.Value__c = '2' ;
		database.insert(csUserTerritoryAdditionBatchSize);
		File_Sharing_Custom_Setting__c csUserTerritoryAdditionScheduler = new File_Sharing_Custom_Setting__c();
		csUserTerritoryAdditionScheduler.Name = GlobalConstants.USERTERRITORYADDITIONSCHEDULER;
		csUserTerritoryAdditionScheduler.Value__c = 'UserTerritoryAdditionScheduler' ;
		database.insert(csUserTerritoryAdditionScheduler);
		
		
		userList = TestDataFactory.userCreation(2,'System Administrator');
		
		database.insert(userList);
		system.runAs(userList[0])
		{
			GlobalConstants.RUN_CONTENTDOCUMENTLINK_TRIGGER_ON_FILESHARING = false;			
			GlobalConstants.RUN_CONTENTDOCUMENT_TRIGGER_ON_FILESHARING = false;		
			GlobalConstants.RUN_OPPORTUNITYTEAM_TRIGGER_ON_FILESHARING = false;
			GlobalConstants.RUN_OFFERTEAM_TRIGGER_ON_FILESHARING = false;
			GlobalConstants.RUN_USERTERRITORY2ASSOCIATION_TRIGGER_ON_FILESHARING = false;

			accList = TestDataFactory.createAccount(1);
			database.insert(accList) ;
			Id accId = accList[0].id;
			Document__c docObj = new Document__c();
			docObj = TestDataFactory.createAccountDocument(accList[0].id, 'Unrestricted', 'Other Account Docs-Unrestricted');
			database.insert(docObj);
			Id territoryId = TestDataFactory.getL7TerritoryId();
			system.debug('territoryId'+ territoryId);
			objTerritory2AssociationList = TestDataFactory.assigningAccountToTerritory(1,accList[0], territoryId);
			Id territoryId1  = TestDataFactory.getAnotherL7TerritoryId();
			objTerritory2AssociationList.addAll(TestDataFactory.assigningAccountToTerritory(1,accList[0], territoryId1));
			database.insert(objTerritory2AssociationList) ;
			for(Integer i =1 ;i<userList.size() ;i++)
			{
				userAssignedToTerritoryList = TestDataFactory.assigningUserToTerritory(1, userList[i], territoryId) ; 
			}
			userAssignedToTerritoryList.addAll(TestDataFactory.assigningUserToTerritory(1, userList[1], territoryId1));   
			Batch_UserTerritoryAdditionExecuteTest();
			File_Sharing_Custom_Setting__c csUserTerritoryRemovalBatchSize = new File_Sharing_Custom_Setting__c();
			csUserTerritoryRemovalBatchSize.Name = GlobalConstants.USERTERRITORYREMOVALBATCHSIZE;
			csUserTerritoryRemovalBatchSize.Value__c = '2' ;
			database.insert(csUserTerritoryRemovalBatchSize);
			File_Sharing_Custom_Setting__c csUserTerritoryRemovalScheduler = new File_Sharing_Custom_Setting__c();
			csUserTerritoryRemovalScheduler.Name = GlobalConstants.USERTERRITORYREMOVALSCHEDULER;
			csUserTerritoryRemovalScheduler.Value__c = 'UserTerritoryRemovalScheduler' ;
			database.insert(csUserTerritoryRemovalScheduler);
			Batch_UserTerritoryRemovalExecuteTest();
		}
	   
		
	}
	   /******************************
*Method Name: UserTerritoryRemovalBatchExecuteTest
*Description: Test Method to cover UserTerritoryRemovalBatchExecute method
*********************************/
 /* static testMethod void Batch_UserTerritoryAdditionExecuteTest(){
	   
		database.insert(userAssignedToTerritoryList);
		
	}
	
	/******************************
*Method Name: UserTerritoryRemovalBatchExecuteTest
*Description: Test Method to cover UserTerritoryRemovalBatchExecute method
********************************/
  /*  static testMethod void Batch_UserTerritoryRemovalExecuteTest(){
		test.startTest();
	   // UserTerritory2AssociationHelper.userTerritoryRemovalBatch(userAssignedToTerritoryList) ;
	 //  database.delete(idList.id);
	   UserTerritory2AssociationIdList = [SELECT Id FROM UserTerritory2Association where UserId =: userList];
			List<id> idList = new List<id>();
		for(Integer i =0 ;i<UserTerritory2AssociationIdList.size();i++)
		idList.add(UserTerritory2AssociationIdList[i].Id);
			database.delete(idList);
	   test.stopTest();
	} */
	/*---------------------------------------------------------------------------------------------------------*/
	static testMethod void UserTerritoryAssociationAdditon(){
		List < File_Sharing_Custom_Setting__c > fileSharingCustomSettingList = new list < File_Sharing_Custom_Setting__c > ();
		List<User> userList = new List<User>();
		List<UserTerritory2Association> userAssignedToTerritoryList = new List<UserTerritory2Association>();
		userList = TestDataFactory.userCreation(3,'System Administrator') ;
		userList[0].NSA_Compliant__c = false ;
		database.insert(userList);
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList) ;
		system.runAs(userList[0]){
			Id territoryId = TestDataFactory.getL3TerritoryId();
			userAssignedToTerritoryList = TestDataFactory.assigningUserToTerritory(1,userList[0], territoryId) ;
			database.insert(userAssignedToTerritoryList);
		   /* Batch_UserTerritory2AssociationAdd batchObj = new Batch_UserTerritory2AssociationAdd(userAssignedToTerritoryList);
			database.executeBatch(batchObj, 10);*/
		} 
	}
		static testMethod void UserTerritoryAssociationRemoval(){
			List < File_Sharing_Custom_Setting__c > fileSharingCustomSettingList = new list < File_Sharing_Custom_Setting__c > ();
			List<User> userList = new List<User>();
			List<UserTerritory2Association> userAssignedToTerritoryList = new List<UserTerritory2Association>();
			userList = TestDataFactory.userCreation(2,'System Administrator') ;
			userList[0].NSA_Compliant__c = false ;
			database.insert(userList);
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList) ;
			system.runAs(userList[0]){
				Id territoryId = TestDataFactory.getL3TerritoryId();
				userAssignedToTerritoryList = TestDataFactory.assigningUserToTerritory(1,userList[0], territoryId) ;
				database.insert(userAssignedToTerritoryList);
				/*Batch_UserTerritory2AssociationAdd batchObj = new Batch_UserTerritory2AssociationAdd(userAssignedToTerritoryList);
				database.executeBatch(batchObj, 10); */
				List<UserTerritory2Association> userterrObjList = new List<UserTerritory2Association>();
				userterrObjList = [SELECT Id FROM UserTerritory2Association WHERE UserId =: userList[0].id];
				database.delete(userterrObjList[0].Id);
				List<id> idList = new List<id>();
				idList.add(userterrObjList[0].Id);
				/*Batch_UserTerritory2AssociationRemove batchObj1 = new Batch_UserTerritory2AssociationRemove(idList);
				database.executeBatch(batchObj1, 10);*/
		}  
	}
	}