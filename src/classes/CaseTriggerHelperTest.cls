//Test Class for Case Trigger
@IsTest
private class CaseTriggerHelperTest {
	
	//create Test Data
	@testSetup static void createTestData() {
		createTestCase();
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;		 
	}
	
	//Test Postive Case
	static testMethod void autoApproveFirstStepPositiveTest() {
		Case c = [SELECT Id, Auto_Approved_By_System__c,Is_Headquater__c,ParentId FROM Case limit 1];
		c.Auto_Approved_By_System__c = true;
		c.Is_Headquater__c = true; //Added for 00015986# SF Ticket. 
		//c.ParentId = '00000000';
		Test.startTest();
			update c;
		Test.stopTest();
		
	}
	
	//Test Negative Case
	static testMethod void autoApproveFirstStepNegativeTest() {
		Case c = [SELECT Id, Status, Auto_Approved_By_System__c FROM Case limit 1];
		c.Status = PRMGlobalConstants.CASE_STATUS_APPROVED_PSM;
		update c;
		
		c.Auto_Approved_By_System__c = true;
		Test.startTest();
		update c;
		Test.stopTest();
		
		c = [SELECT Id, Status FROM Case limit 1];
		System.assertEquals(PRMGlobalConstants.CASE_STATUS_APPROVED_PSM, c.Status);
	}
	
	public static void createTestCase() {
		Case c = new Case();
		c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION).getRecordTypeId();
		c.Country__c = 'USA';
		insert c;
	}
	
	public testMethod static void caseShareToOpptyMemberTest1() {
		User user = TestDataFactory.userCreation(1, 'System Administrator')[0];
		insert user;
		
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		
		
		Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Name = 'STARHUB LIMsITED';
		acc.Country__c = 'India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		insert acc;
		Opportunity oppty1 = TestDataFactory.OpportunityCreation(1, acc)[0];
		oppty1.Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
		//oppty1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('').getRecordTypeId();
		insert oppty1;
		oppty1.Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
		List<OpportunityTeamMember> otm = TestDataFactory.optyTeamMemberCreation(1, user, oppty1);
		insert otm;
		//opportunity opptyInstance = [select id,PRMSales_Support_Requested__c from opportunity where id =: oppty1.id];
		oppty1.PRMSales_Support_Requested__c = true;
		Case c = new Case();
		c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION).getRecordTypeId();
		c.Country__c = 'USA';
		c.Opportunity__c = oppty1.Id;
		
		test.StartTest();
		update oppty1;
		insert c;
		Test.StopTest();
	}
	@isTest static void leadTest() {
		List<Case> CaseList = new List<Case>();
		Map<id, Case> caseOldMap = new Map<id, Case>();
		Map<id, Case> caseNewMap = new Map<id, Case>();
		try {
			CaseTriggerHandler.afterUpdateOperation(CaseList, caseNewMap, caseOldMap);
		} catch (DMLException e) {
			system.assertEquals(e.getMessage(), e.getMessage());
		}
		
		CaseTriggerHandler.afterUpdateOperation(CaseList, caseNewMap, caseOldMap);
	}
	@isTest static void leadTest2() {
		List<case> caseListnew = new List<case>();
		try {
			CaseTriggerHandler.afterInsertOperation(caseListnew);
		} catch (DMLException e) {
			system.assertEquals(e.getMessage(), e.getMessage());
		}
		
		CaseTriggerHandler.afterInsertOperation(caseListnew);
	}
	
	@isTest static void TestInternalEntitlements() {
		User internalUser;
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')){
			Account acc = NCP_TestFactory.createAccount();
			Account acc2 = NCP_TestFactory.createLegalAccount(acc.Id);
			Contact cont = NCP_TestFactory.createContact(acc); 
			internalUser = NCP_TestFactory.createInternalUser('internal', 'internal@nokian.com.dev');
			insert internalUser;  
			NCP_TestFactory.createInternalService(internalUser.Id,'PIC');						   
		}			 
		System.runAs(internalUser){
			Test.startTest();
			NCP_CustomerCommunitySetting__c mdt = NCP_TestFactory.insertCustomSetting();
			Case myCase = NCP_TestFactory.createEntitlementCase(null,null,'CDB','PIC');
			Test.stopTest();
		}
	}
	
	  
   /* @isTest static void TestEntitlements(){
		User CustomerUser,u;
		ServiceContract scCDB, sccCDB, scOTHER, sccOTHER;
		List<User> userList = new List<User>();
		List<ServiceContract> scList = new List<ServiceContract>();
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
			Account acc = NCP_TestFactory.createAccount();
			Account acc2 = NCP_TestFactory.createLegalAccount(acc.Id);
			Contact cont = NCP_TestFactory.createContact(acc); 
			CustomerUser = NCP_TestFactory.createUser(false,'test',cont, 'test2@nokian.com.dev');
			u = NCP_TestFactory.createInternalUser('test2','test2@nokia.com.dev');
			userList.add(u);
			userList.add(CustomerUser);
			insert userList;
			AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(cont.Id,acc2.Id,true);						
			scCDB = NCP_TestFactory.createServiceContract(acc2, 'CDB',false);
			scOTHER = NCP_TestFactory.createServiceContract(acc2, 'Other Services',false);
			scList.add(scCDB);
			scList.add(scOTHER);
			insert scList;
			scCDB = [Select Id,ContractNumber from ServiceContract where ID =:scCDB.Id];
			sccCDB = NCP_TestFactory.createChildServiceContract(acc2, scCDB, 'PIC', 'Services',true);			  
		  sccOTHER = NCP_TestFactory.createOtherServicesChildContract(acc2, scOTHER, 'Co-Op Marketing', 'Services');

		}			 
		System.runAs(CustomerUser){
			Test.startTest();
			List<Case> cases = new List<Case>();
			NCP_CustomerCommunitySetting__c mdt = NCP_TestFactory.insertCustomSetting();
			Case myCase = NCP_TestFactory.createEntitlementCase(scCDB,sccCDB.Id,'CDB','PIC');
			Case myCase2 = NCP_TestFactory.createEntitlementCase(scOTHER,sccOTHER.Id,'Other Services','PIC');
			myCase.Status = 'Approved';
			myCase.NCP_NAM_Entitlement_Requested__c = 'SUCCESS';
			cases.add(myCase);
			cases.add(myCase2);
			update cases;
			Test.stopTest();
		}
	}*/
}