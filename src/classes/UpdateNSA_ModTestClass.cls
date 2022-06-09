@isTest
	private class UpdateNSA_ModTestClass {
		//Private static List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		@testSetup static void setup() {
			NCP_CustomerCommunitySetting__c setting = NCP_TestFactory.insertCustomSetting();
		}
		static testMethod void validateNSA_Mod() {
			
			Test.startTest();
			user usr = [select Id,NSA_Compliant__c,NSA_Modified__c from user limit 1];						   
			System.debug('The usr :::>'+usr);
			
			usr.NSA_Compliant__c = true;
			usr.Nokia_Id__c = '60000111111';
			usr.FederationIdentifier = '60000111111';
			System.debug('-----------usr :::>'+usr);
			
			//GlobalConstants.RUN_USER_TRIGGER_ON_FILESHARING = false; 
			update usr;
			//methodName();
			System.debug(' userList.get(0).NSA_Compliant__c....'+ usr.NSA_Compliant__c);
			System.debug(' userList.get(0).NSA_Modified__c....'+ usr.NSA_Modified__c);
			
			/* //System.assertEquals(System.now(), userObj.NSA_Modified__c);
	
	userList.get(0).NSA_Compliant__c = False;
	Database.update(userList);
	System.debug(' userList.get(0).NSA_Modified__c....'+ userList.get(0).NSA_Modified__c);
	*/
			
			Test.stopTest();
		} 
		static testMethod void InsertNSA_User()
		{
			Test.startTest();
			List<user> userList = new List<user>();
			userList = TestDataFactory.userCreation(1, 'System Administrator');
			userList[0].NSA_Compliant__c = true;
			userList[0].Nokia_Id__c = '60000111111';
			Database.insert(userList);	 
			
			userList[0].IsActive = false;
			Database.update(userList); 
			Test.stopTest();
		}
		
		static testMethod void AddKeyUserToPGQueueTest(){
			
			List<user> userList = new List<user>();
			userList = TestDataFactory.userCreation(1, 'System Administrator');
			userList[0].Nokia_Id__c = '60000111111';
			Database.insert(userList);
			
			userList[0].Market__c = 'Market North America';
			userList[0].Is_Key_User__c = true;
			Database.update(userList);
			
			Set<Id> userId = new Set<Id>();
			userId.add(userList[0].id);
			
			Test.startTest();
			AddKeyUserToPGQueue keyUserId1 = new AddKeyUserToPGQueue(userId);
			QueueableContext context1;
			keyUserId1.execute(context1);
			Test.stopTest(); 
			
			userList[0].Is_Key_User__c = false;
			Database.update(userList);
			
			AddKeyUserToPGQueue keyUserId2 = new AddKeyUserToPGQueue(userId);
			QueueableContext context2;
			keyUserId2.execute(context2);
			
			
			
		}
		static testMethod void updateNSA_ModTest(){
			List<user> userList = new List<user>();
			userList = TestDataFactory.userCreation(1, 'System Administrator');
			userList[0].Nokia_Id__c = '60000111111';
			Database.insert(userList);
			
			UserHelper.updateNSA_Mod(Null,Null);
			
			
		}
		static testMethod void updateDeactivationDateTest(){
			List<user> userList = new List<user>();
			userList = TestDataFactory.userCreation(1, 'System Administrator');
			userList[0].Nokia_Id__c = '60000111111';
			Database.insert(userList);
			
			UserHelper.updateDeactivationDate(Null,Null);
			
			
		}
		static testMethod void AddtoKeyUserGroupTest(){
			List<user> userList = new List<user>();
			userList = TestDataFactory.userCreation(1, 'System Administrator');
			userList[0].Nokia_Id__c = '60000111111';
			Database.insert(userList);
			
			UserHelper.AddtoKeyUserGroup(Null,Null);
			
			
		}
		static testMethod void updateFederationIdTest(){
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			List<user> userList = new List<user>();
			userList = TestDataFactory.userCreation(1, 'System Administrator');
			userList[0].Nokia_Id__c = '60000111111';
			Database.insert(userList);	   
			UserHelper.updateFederationId(Null);  
		}
	}