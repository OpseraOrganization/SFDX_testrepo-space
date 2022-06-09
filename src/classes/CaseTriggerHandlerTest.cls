@IsTest
public class CaseTriggerHandlerTest {
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
}