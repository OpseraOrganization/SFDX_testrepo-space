@isTest
public without sharing class BatchToDeleteDraftChildCaseTest {
	
	static testMethod void testBatchToDeleteDraftChildCase(){
	// User guestuser = [SELECT Id FROM user WHERE Name='Nokia Partner Portal Site Guest User'];
	// System.runAs(guestuser) {
	id idRecType=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION).getRecordTypeId();
		Case c = new Case();
		c.RecordTypeId = idRecType;
		c.Country__c = 'USA';
		c.Subject = 'Sales';
		c.Description = 'Sales';
		c.Status = 'New';
		c.Is_Headquater__c=true;

		insert c;
		
		Case child = new Case();
		child.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE).getRecordTypeId();
		child.ParentId = c.Id;
		child.Status = 'Draft';
		child.Subject = 'Sales1';
		child.Description = 'Sales1';
		child.Country__c = 'USA';
		insert child;
		
			Test.startTest();
			BatchToDeleteDraftChildCase obj= new BatchToDeleteDraftChildCase();
			obj.execute(null);
			Test.stopTest();
   // }
	}

}