//Test Class for Case Trigger
@IsTest
private class CaseTriggerelperPRMTEST {
  //create Test Data
	@testSetup static void createTestData() {
		Case c = new Case();
		c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION_NEW).getRecordTypeId();
		c.Country__c = 'USA';
		c.Subject = 'Sales';
		c.Description = 'Sales';
		insert c;
		System.assertNotEquals(c.Id, null);
		 
		Case child = new Case();
		child.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE_NEW).getRecordTypeId();
		child.ParentId = c.Id;
		child.Status = 'New';
		child.Subject = 'Sales1';
		child.Description = 'Sales1';
		insert child;
		System.assertNotEquals(child.Id, null);
		
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;			
	}
	
	//Test Postive Case
	static testMethod void autoApproveFirstStepPositiveTest() {
		// User user = TestDataFactory.userCreation(1, 'System Administrator')[0];
		// insert user;
		Case c = [SELECT Id, Auto_Approved_By_System__c FROM Case WHERE SUBJECT = 'Sales' limit 1];
		c.Auto_Approved_By_System__c = true;
		c.Is_Headquater__c = true;
		c.status = 'New';
		Test.startTest();
			update c;
		Test.stopTest();
		//System.assertEquals(PRMGlobalConstants.CASE_STATUS_APPROVED_PSM, c.Status);
	}
	//Test Negative Case
	static testMethod void autoApproveFirstStepNegativeTest() {
		Case c = [SELECT Id, Status, Auto_Approved_By_System__c FROM Case WHERE SUBJECT = 'Sales' limit 1];
		c.Status = PRMGlobalConstants.CASE_STATUS_APPROVED_PSM;
		update c;
		Test.startTest();
			c.Auto_Approved_By_System__c = true;
			c.Is_Headquater__c = true;
			update c;
		Test.stopTest();
		
		c = [SELECT Id, Status FROM Case limit 1];
		System.assertEquals(PRMGlobalConstants.CASE_STATUS_APPROVED_PSM, c.Status);
	}
	
	@isTest
	public static void onHoldTestCase() {
		Case childCase = [SELECT Id, Status FROM Case WHERE ParentId != null and Subject = 'Sales1' LIMIT 1];
		childCase.Status = 'On Hold';
		Test.startTest();
			update childCase;
		Test.stopTest();
	}
	
	@isTest
	public static void rejectedTestCase() {
		Case childCase = [SELECT Id, Status FROM Case WHERE ParentId != null and Subject = 'Sales1' LIMIT 1];
		childCase.Status = 'On Hold';
		update childCase;
		childCase.Status = 'Rejected';
		Test.startTest();
			update childCase;
		Test.stopTest();
	}
	
	public testMethod static void createTestCase1() {
		Case c = [SELECT Id, Status, Auto_Approved_By_System__c FROM Case WHERE SUBJECT = 'Sales' limit 1];
		System.assertNotEquals(c, null);
		
		List<Case> CaseList = new List<Case>();
		Case child1 = new Case();
		child1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE_NEW).getRecordTypeId();
		child1.ParentId = c.Id;
		child1.Status = PRMGlobalConstants.CASE_STATUS_APPROVED_PSM ;
		child1.Subject = 'Sales1';
		child1.Description = 'Sales1';
		CaseList.add(child1);
		
		Case child2 = new Case();
		child2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE_NEW).getRecordTypeId();
		child2.ParentId = c.Id;
		child2.Status = PRMGlobalConstants.CASE_STATUS_APPROVED_PSM ;
		child2.Subject = 'Sales1';
		child2.Description = 'Sales1';
		CaseList.add(child2);
		
		Case child3 = new Case();
		child3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE_NEW).getRecordTypeId();
		child3.ParentId = c.Id;
		child3.Status = PRMGlobalConstants.CASE_STATUS_APPROVED_PSM ;
		child3.Subject = 'Sales1';
		child3.Description = 'Sales1';
		CaseList.add(child3);
	
		Case child4 = new Case();
		child4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE_NEW).getRecordTypeId();
		child4.ParentId = c.Id;
		child4.Status = PRMGlobalConstants.CASE_STATUS_APPROVED_PSM ;
		child4.Subject = 'Sales1';
		child4.Description = 'Sales1';		
		CaseList.add(child4);
	  
		Database.insert(CaseList);
		CaseList[0].Status = PRMGlobalConstants.StatusRejected;
		CaseList[1].Status = PRMGlobalConstants.CASE_STATUS_APPROVED_COMP;
		CaseList[2].Status = PRMGlobalConstants.CASE_STATUS_APPROVED_PSM;
		CaseList[3].Status = 'New';
		
		Test.startTest();
			Database.Update(CaseList);
		Test.stopTest();		
	}
	
	public testMethod static void createTestCase2() {
		Case c = [SELECT Id, Status, Auto_Approved_By_System__c FROM Case WHERE SUBJECT = 'Sales' limit 1];
		System.assertNotEquals(c, null);
		
		Case child = new Case();
		child.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE_NEW).getRecordTypeId();
		child.ParentId = c.Id;
		child.Status = PRMGlobalConstants.CASE_STATUS_APPROVED_PSM ;
		child.Subject = 'Sales1';
		child.Description = 'Sales1';
		insert child;
		
		Test.startTest();
			child.Status = PRMGlobalConstants.StatusRejected;
			update child;
		Test.stopTest();
	}
	
	public testMethod static void testreleaseOnHold() {
		Case c = new Case();
		c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION_NEW).getRecordTypeId();
		c.Country__c = 'USA';
		c.Subject = 'Sales';
		c.Description = 'Sales';
		insert c;
		 List<Case> CaseList = new List<Case>();
		Case child1 = new Case();
		child1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE_NEW).getRecordTypeId();
		child1.ParentId = c.Id;
		child1.Status = PRMGlobalConstants.On_Hold;
		child1.Subject = 'Sales1';
		child1.Description = 'Sales1';
		 CaseList.add(child1);
		Case child2 = new Case();
		child2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE_NEW).getRecordTypeId();
		child2.ParentId = c.Id;
		child2.Status = PRMGlobalConstants.On_Hold ;
		child2.Subject = 'Sales1';
		child2.Description = 'Sales1';
		CaseList.add(child2);
		Case child3 = new Case();
		child3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE_NEW).getRecordTypeId();
		child3.ParentId = c.Id;
		child3.Status = PRMGlobalConstants.On_Hold;
		child3.Subject = 'Sales1';
		child3.Description = 'Sales1';
		CaseList.add(child3);
		
		
		Case child4 = new Case();
		child4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE_NEW).getRecordTypeId();
		child4.ParentId = c.Id;
		child4.Status = PRMGlobalConstants.On_Hold;
		child4.Subject = 'Sales1';
		child4.Description = 'Sales1';
		
		CaseList.add(child4);
		
	
		Database.insert(CaseList);
		CaseList[0].Status = PRMGlobalConstants.StatusRejected;
		CaseList[1].Status = PRMGlobalConstants.CASE_STATUS_APPROVED_COMP;
		CaseList[2].Status = PRMGlobalConstants.CASE_STATUS_APPROVED_PSM;
		CaseList[3].Status = 'New';
		 Test.startTest();
		Database.Update(CaseList);
		Test.stopTest();
	
	}
	
   /* public testMethod static void caseShareToOpptyMemberTest1() {
		User user = TestDataFactory.userCreation(1, 'System Administrator')[0];
		insert user;
		
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
	 
		system.runAs(user){
		
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
		
		List<Case> caseShareToInsert = new List<Case>();
		Case c = new Case();
		c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION).getRecordTypeId();
		c.Country__c = 'USA';
		c.Opportunity__c = oppty1.Id;
		insert c;
		
		caseShareToInsert.add(c);
		test.StartTest();
		 update oppty1;
	CaseTriggerHelperPRM.caseShareToOpptyMember(caseShareToInsert);
		Test.StopTest();
		}
	}*/
	public testMethod static void updateParentCaseStatusHold_Test() {
		Case c = [SELECT ID FROM CASE WHERE SUBJECT ='Sales1'];
		c.status = 'On Hold';
		update c;
	}
	public testMethod static void getApproveAndRejectedCoun_Test1() {
		Case c = [SELECT ID FROM CASE WHERE SUBJECT ='Sales1'];
		c.status = 'Approved by Compliance';
		update c;
	  //  Case c1 = [SELECT ID FROM CASE WHERE SUBJECT ='Sales'];
	  //  c1.status = 'Approved by Compliance';
	 //   update c1;
	}
	public testMethod static void getApproveAndRejectedCoun_Test2() {
		Case c = [SELECT ID FROM CASE WHERE SUBJECT ='Sales1'];
		c.status = 'Rejected';
		update c;
	/* Case c1 = [SELECT ID FROM CASE WHERE SUBJECT ='Sales'];
		c1.status = 'Approved by Compliance';
		update c1;*/
	}
		public testMethod static void getApproveAndRejectedCoun_Test3() {
		Case c = [SELECT ID FROM CASE WHERE SUBJECT ='Sales1'];
		c.status = 'New';
		update c;
	 //   Case c1 = [SELECT ID FROM CASE WHERE SUBJECT ='Sales'];
	 //   c1.status = 'New';
	  //  update c1;
	}
	public testMethod static void getApproveAndRejectedCoun_Test4() {
		Case c = [SELECT ID FROM CASE WHERE SUBJECT ='Sales1'];
		c.status = 'Approved by PSM';
		update c;
	//	Case c1 = [SELECT ID FROM CASE WHERE SUBJECT ='Sales'];
	//	c1.status = 'Approved by PSM';
//	 update c1;
	}
	public testMethod static void caseShareToOpptyMember()
	{
		User user = TestDataFactory.userCreation(1, 'System Administrator')[0];
		insert user;
		
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
	 system.runAs(user){
		
		Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Name = 'STARHUB LIMsITED';
		acc.Country__c = 'India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		insert acc;
		Opportunity oppty1 = TestDataFactory.OpportunityCreation(1, acc)[0];
		oppty1.Lead_Type__c = PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION_NEW;
		//oppty1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('').getRecordTypeId();
		 Test.StartTest();
		insert oppty1;
		oppty1.Lead_Type__c = PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION_NEW;
		List<OpportunityTeamMember> otm = TestDataFactory.optyTeamMemberCreation(1, user, oppty1);
		otm[0].OpportunityId = oppty1.Id;
		insert otm;  
		List<Case> caseShareToInsert = new List<Case>();
		Case c = new Case();
		c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION_NEW).getRecordTypeId();
		c.Country__c = 'USA';
		c.Opportunity__c = oppty1.Id;
		c.Is_Headquater__c = true;
		c.Auto_Approved_By_System__c = true;
		c.State__c = 'New';
		insert c;
		c.Is_Headquater__c = true;
		c.Auto_Approved_By_System__c = true;
		
		update c;
		caseShareToInsert.add(c);
		CaseTriggerHelperPRM.caseShareToOpptyMember(caseShareToInsert);
		 Test.StopTest();
	 
	}
}
	
	public testMethod static void caseShareToOpptyMember2()
	{
		User user = TestDataFactory.userCreation(1, 'System Administrator')[0];
		insert user;
		
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
	 system.runAs(user){
		
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
		 Test.StartTest();
		insert oppty1;
		oppty1.Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
		List<OpportunityTeamMember> otm = TestDataFactory.optyTeamMemberCreation(1, user, oppty1);
		otm[0].OpportunityId = oppty1.Id;
		insert otm;  
		List<Case> caseShareToInsert = new List<Case>();
		Case c = new Case();
		c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PRMGlobalConstants.Partner_Sales_Support_Requested).getRecordTypeId();
		c.Country__c = 'USA';
		c.Subject = 'Sales';
		c.Description = 'Sales';
		c.Opportunity__c = oppty1.Id;
		c.Is_Headquater__c = true;
		c.Auto_Approved_By_System__c = true;
		c.State__c = 'New';
		insert c;
		c.Is_Headquater__c = true;
		c.Auto_Approved_By_System__c = true;
		
		update c;
		caseShareToInsert.add(c);
		CaseTriggerHelperPRM.caseShareToOpptyMember(caseShareToInsert);
		 Test.StopTest();
	 
	}
}
}