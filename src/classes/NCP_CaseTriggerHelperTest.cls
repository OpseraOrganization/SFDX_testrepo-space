//Test Class for Case Trigger
@IsTest(SeeAllData=FALSE)
private class NCP_CaseTriggerHelperTest {
	/*
	//create Test Data
	@testSetup static void createTestData() {
		//createTestCase();
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;	   
	}	
	*/
	@isTest static void TestInternal() {
		User internalUser;
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')){
			Account acc = NCP_TestFactory.createAccount();
			Account acc2 = NCP_TestFactory.createLegalAccount(acc.Id);
	   /*	 Contact cont = NCP_TestFactory.createContact(acc);
			cont.Email = 'support.portal@nokia.com';
			update cont; */
			
	Contact cont = new Contact();
	cont.AccountId = acc.Id;
	cont.FirstName = 'First Name';
	cont.LastName = 'Last Name';
	cont.Email = 'support.portal@nokia.com';
	cont.City__c = 'City';
	cont.Street__c = 'Street';
	cont.State__c = 'State';
	cont.Country__c = 'Country';
	cont.Phone = '0550222333';
	cont.CH_ContactTimeZone__c = '(GMT+14:00) Line Islands Time (Pacific/Kiritimati)';
	cont.CH_PreferredMtdOfServiceCommunication__c = 'Email ';

	insert cont;
				
			internalUser = NCP_TestFactory.createInternalUser('internal', 'internal@nokian.com.dev');
			internalUser.NCP_Relationship__c = 'Internal' ;
			insert internalUser;  
			NCP_TestFactory.createInternalService(internalUser.Id,'EEPT');
			List<NCP_Service_Tile__mdt> allServiceTiles = NCP_TestFactory.loadAllServiceTiles();				 
		}			
		System.runAs(internalUser){
			Test.startTest();
		 //   NCP_CustomerCommunitySetting__c mdt = NCP_TestFactory.insertCustomSetting();
			Case myCase = NCP_TestFactory.createEntitlementCase(null,null,'CARES','ALED');
			myCase.Issue_Reported_By__c = internalUser.Id ;
			update myCase ;
			List<Case> lstCase = new List<Case>();
			lstCase.add(myCase);
			
			Map<id, Case> caseOldMap = new Map<id, Case>();
			Map<id, Case> caseNewMap = new Map<id, Case>();
			caseOldMap.put(myCase.Id,myCase);
			caseNewMap.put(myCase.Id,myCase);
			
			CaseTriggerHandler.afterInsertOperation(lstCase);
			CaseTriggerHandler.afterUpdateOperation(lstCase, caseNewMap, caseOldMap);
			
			NCP_CaseTriggerHelper.approveSupportTicket(lstCase);
			NCP_CaseTriggerHelper.sendEmailToKeyUser(lstCase);
		   // myCase.NCP_NAM_Entitlement_Requested__c = 'SUCCESS';
		   // update myCase ;			
			NCP_CaseTriggerHelper.updateCaseStatus(lstCase);
			Test.stopTest();
		}
	}

	@isTest static void TestExternal() {
		User externalUser;
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')){
			Account acc = NCP_TestFactory.createAccount();
			Account acc2 = NCP_TestFactory.createLegalAccount(acc.Id);
			
	Contact cont = new Contact();
	cont.AccountId = acc.Id;
	cont.FirstName = 'First Name';
	cont.LastName = 'Last Name';
	cont.Email = 'support.portal@nokia.com';
	cont.City__c = 'City';
	cont.Street__c = 'Street';
	cont.State__c = 'State';
	cont.Country__c = 'Country';
	cont.Phone = '0550222333';
	cont.CH_ContactTimeZone__c = '(GMT+14:00) Line Islands Time (Pacific/Kiritimati)';
	cont.CH_PreferredMtdOfServiceCommunication__c = 'Email ';

	insert cont;
	
			externalUser = NCP_TestFactory.createInternalUser('external', 'externalUser@external.com.dev');
			externalUser.NCP_Relationship__c = 'Customer' ;
			insert externalUser;  

			List<NCP_Service_Tile__mdt> allServiceTiles = NCP_TestFactory.loadAllServiceTiles();				 
		}			
		System.runAs(externalUser){
			Test.startTest();
		 //   NCP_CustomerCommunitySetting__c mdt = NCP_TestFactory.insertCustomSetting();
			Case myCase = NCP_TestFactory.createEntitlementCase(null,null,'CDB','EEPT');
			myCase.Issue_Reported_By__c = externalUser.Id ;
			update myCase ;
			List<Case> lstCase = new List<Case>();
			lstCase.add(myCase);
			
			Map<id, Case> caseOldMap = new Map<id, Case>();
			Map<id, Case> caseNewMap = new Map<id, Case>();
			caseOldMap.put(myCase.Id,myCase);
			caseNewMap.put(myCase.Id,myCase);
			
			CaseTriggerHandler.afterInsertOperation(lstCase);
			CaseTriggerHandler.afterUpdateOperation(lstCase, caseNewMap, caseOldMap);
			
			NCP_CaseTriggerHelper.approveSupportTicket(lstCase);
			NCP_CaseTriggerHelper.sendEmailToKeyUser(lstCase);
		   // myCase.NCP_NAM_Entitlement_Requested__c = 'SUCCESS';
		   // update myCase ;			
			NCP_CaseTriggerHelper.updateCaseStatus(lstCase);
			Test.stopTest();
		}
	}

}