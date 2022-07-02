/****************************************
 * Name : Scheduler_AccMvmtNonNSAToNSATest 
 * Author : Accenture
 * Description : Test class for Scheduler_AccMvmtNonNSAToNSA
 *****************************************/
@isTest
public class Scheduler_AccMvmtNonNSAToNSATest {/*
	Private static List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>(); 
	Private static List<User> userList = new List<User>();
	Private static List<Account> accountList = new List<Account>();   
	Private static List<Account> updateAccountList = new List<Account>();   
	Private static Map<id,Account> oldAccountMap = new Map<id,Account>();
	Private static Map<id,Account> newAccountMap = new Map<id,Account>();
	Private static Scheduler_AccountMovementNonNSAToNSA schedulerObj;
	Private static Scheduler_AccountRemovalBatch schedulerRemoveObj;
	Private static Scheduler_AccountMovementBatch schedulerAccMvmtObj;
	Private static Batch_AccountMovementFromTerrNonNSAToNSA batchObj;
	Private static Batch_AccountMovementFromTerritory batchAccountMvmt;
	Private static AccountMovementHelper accMvntObj;
	Private static Id territoryId; 
	Private static Id territory2Id;
	Private static Account accountObj;
	Private static Account tempAccountObj;
	Private static Document__c accountDocumentObj1;
	Private static Document__c accountDocumentObj2;
	Private static List<Document__c> accountDocumentList = new List<Document__c>();
	Private static List<ContentVersion> contentVersionList = new List<ContentVersion>();
	Private static List<ContentDocumentLink> contentDocLinkList;
	Private static ContentVersion contentVersionObj = new ContentVersion();
	Private static Id contentDocumentId;
	Private static Map<Id,List<Document__c>> territoryDocMap = new Map<Id,List<Document__c>>();
	/******************************
	*Method Name: schedulerTestMethod
	*Description: Test Method to cover Addition and Removal of user to territory functionality
	********************************/
   // @isTest
   /* static void schedulerTestMethod (){		
		//Insert user
		userList = TestDataFactory.userCreation(2, 'System Administrator');
		database.insert(userList);  
		System.assertNotEquals(userList, Null);
		system.runAs(userList[1]){ 
			//Insert an File_Sharing_Custom_Setting
			Test.startTest();
			GlobalConstants.RUN_CONTENTDOCUMENTLINK_TRIGGER_ON_FILESHARING = false;			
			GlobalConstants.RUN_CONTENTDOCUMENT_TRIGGER_ON_FILESHARING = false;		
			GlobalConstants.RUN_OPPORTUNITYTEAM_TRIGGER_ON_FILESHARING = false;
			GlobalConstants.RUN_OFFERTEAM_TRIGGER_ON_FILESHARING = false;
			GlobalConstants.RUN_USERTERRITORY2ASSOCIATION_TRIGGER_ON_FILESHARING = false;
			
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			System.debug('fileSharingCustomSettingList:::>'+fileSharingCustomSettingList);
			System.assertNotEquals(fileSharingCustomSettingList, Null);
			
			//Create a List of TerritoryID									
			territoryId = TestDataFactory.getL7TerritoryId();
			System.debug('L7 Territory:::>'+territoryId);
			
			//Account Creation
			accountList = TestDataFactory.createAccount(4);						
			//tempAccountObj = accountList[1];
			accountList[1].L7ID__c = territoryId;
			accountList[2].L7ID__c = territoryId;
			accountList[3].L7ID__c = territoryId;
			Database.insert(accountList);
			
			for(Account accObj : accountList){
				oldAccountMap.put(accObj.Id, accObj);	
			}			
			System.debug('accountList:::>'+accountList);
			System.debug('oldAccountMap::>'+oldAccountMap);						
			
			//Assign USer to territory
			List<UserTerritory2Association> userTerritoryAssociationList = new List<UserTerritory2Association>();
			userTerritoryAssociationList = TestDataFactory.assigningUserToTerritory(1, userList[0], territoryId);
			Database.insert(userTerritoryAssociationList);
			
			//Assign the created account,opportunity,offer to a L7 active territory
			List<ObjectTerritory2Association> objTerritory2AssociationList = new List<ObjectTerritory2Association>();
			objTerritory2AssociationList = TestDataFactory.assigningAccountToTerritory(1, accountList[0], territoryId);
			Database.insert(objTerritory2AssociationList);			
			System.debug('objTerritory2AssociationList:::>'+objTerritory2AssociationList);
			
			//Create Document Record in the Account created above
			accountDocumentObj1= new Document__c();
			accountDocumentObj1 = TestDataFactory.createAccountDocument(accountList[0].Id,GlobalConstants.UNRESTRICTED_VALUE, 'Other Account Docs-Unrestricted');
			accountDocumentList.add(accountDocumentObj1);
			//Database.insert(accountDocumentObj);
			accountDocumentObj2= new Document__c();
			accountDocumentObj2 = TestDataFactory.createAccountDocument(accountList[0].Id,GlobalConstants.UNRESTRICTED_VALUE, 'Other Account Docs-Unrestricted');
			accountDocumentList.add(accountDocumentObj2);
			Database.insert(accountDocumentList);						
			
			//Create ContentVersion Record
			contentVersionList = new list < ContentVersion >();
			contentVersionList = TestDataFactory.createContentVersion(1);
			Database.insert(contentVersionList);
			System.debug('contentVersionList:::>'+contentVersionList);								
			
			//Retrive ContentDocumentId from the Contentversion
			contentVersionObj =[select ContentDocumentId from ContentVersion where Id IN: contentVersionList];			
			contentDocumentId = contentVersionObj.ContentDocumentId;			
			System.debug('contentDocumentId:::>'+contentDocumentId);			
						
			//Create ContentDocumentLink for the Document and the ContentDocument Id created by inserting ContentVersion
			contentDocLinkList = new List<ContentDocumentLink>();
			contentDocLinkList = TestDataFactory.createContentDocumentLinkWithShareTypeV(1, accountDocumentObj1.Id, contentDocumentId);
			Database.insert(contentDocLinkList);
			
			//Create ContentDocumentLink for the Document and the ContentDocument Id created by inserting ContentVersion
			contentDocLinkList = new List<ContentDocumentLink>();
			contentDocLinkList = TestDataFactory.createContentDocumentLinkWithShareTypeV(1, accountDocumentObj2.Id, contentDocumentId);
			Database.insert(contentDocLinkList);
			   
			territoryDocMap.put(territoryId, accountDocumentList);
			GlobalUtility.retrieveTerritoryIdRestrictionContentDocList(territoryDocMap);
			System.debug('accountDocumentObj:::>'+accountDocumentList); 
						
			
			//Update the acc   
			territory2Id = TestDataFactory.getAnotherL7TerritoryId();
			updateAccountList = [SELECT Id,Name,L7ID__c FROM Account WHERE Id IN:accountList];
			updateAccountList[0].L7ID__c = territoryId;
			updateAccountList[1].L7ID__c = Null;
			updateAccountList[2].L7ID__c =territory2Id;
			updateAccountList[3].L7ID__c =territory2Id;
			updateAccountList[3].Customer_Compliance__c = 'US_Company';
			database.update(updateAccountList);
			System.debug('AccountObj to be updated:::>'+accountObj);
			for(Account accObj : updateAccountList){
			 	newAccountMap.put(accObj.Id, accObj);   
			}			
			System.debug('newAccountMap::>'+newAccountMap); 
			
			//Calling Scheduler Movement Class
			Datetime dt = Datetime.now().addMinutes(2);
			String sch = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
			schedulerAccMvmtObj = new Scheduler_AccountMovementBatch(oldAccountMap,newAccountMap);
			system.schedule('Test check 0', sch, schedulerAccMvmtObj); 
			batchAccountMvmt = new Batch_AccountMovementFromTerritory(oldAccountMap,newAccountMap);
			Database.executeBatch(batchAccountMvmt);
			
			//Calling the Scheduler Class			
			schedulerObj = new Scheduler_AccountMovementNonNSAToNSA(oldAccountMap,newAccountMap);			
			system.schedule('Test check 1', sch, schedulerObj);						 
			
			//Calling batch object
			batchObj = new Batch_AccountMovementFromTerrNonNSAToNSA(oldAccountMap,newAccountMap);
			Database.executeBatch(batchObj);
			
			//Calling Scheduler Removal class
		   // accMvntObj = new AccountMovement
			schedulerRemoveObj = new Scheduler_AccountRemovalBatch(accountList);
			system.schedule('Test check 2', sch, schedulerRemoveObj); 
		   // Database.delete(accountList);
		}
	}*/
}