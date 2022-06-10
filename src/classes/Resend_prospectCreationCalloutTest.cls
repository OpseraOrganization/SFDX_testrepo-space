@isTest
public class Resend_prospectCreationCalloutTest {
	private static testMethod void Resend_createbulkProspect500Test() {
		test.startTest();
		List<Account> accountList = new List<Account>{};
		Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
		Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();	 
		accountList = TestDataFactory.createAccount(1);
		accountList[0].recordtypeid = ProspectRecordTypeId;	  
		accountList[0].AccountNumber = '30191217';
		accountList[0].Website = 'testaudfhieuqrqgrrwkgvfrufgwejgfwekfgwufehwdfjkgwekjfgiuwefgweiugfuweigfwjekfgwkeufgwekfgwkejfgekwfjegfwkefgweuifgwefdewewfsdfdfdfgd.com';
		accountList[0].BillingPostalCode='12345678959';
		Insert accountList[0];
		List<String> strList= new List<String>();
		strList.add(accountList[0].Id);
		Test.setMock(HttpCalloutMock.class, new ProspectCreationMockResponse500Test());
		Resend_prospectCreationCallout.Resend_createbulkProspect(strList);
		Test.stopTest();
		
	}
	 private static testMethod void Resend_createbulkProspectSuccessTest() {
		test.startTest();
		List<Account> accountList = new List<Account>{};
		Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
		Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();	 
		accountList = TestDataFactory.createAccount(1);
		accountList[0].recordtypeid = ProspectRecordTypeId;	  
		accountList[0].AccountNumber = '30191217';
		accountList[0].Website = 'testaudfhieuqrqgrrwkgvfrufgwejgfwekfgwufehwdfjkgwekjfgiuwefgweiugfuweigfwjekfgwkeufgwekfgwkejfgekwfjegfwkefgweuifgwefdewewfsdfdfdfgd.com';
		accountList[0].BillingPostalCode='12345678959';
		Insert accountList[0];
		UseProspectCreationCertificate__c certificateUse= new UseProspectCreationCertificate__c();
		certificateUse.CertificateAllow__c = true;
		insert certificateUse;
		List<String> strList= new List<String>();
		strList.add(accountList[0].Id);
		Test.setMock(HttpCalloutMock.class, new ProspectCreationMockResponseTest());
		Resend_prospectCreationCallout.Resend_createbulkProspect(strList);
		Test.stopTest();
		
	}
		private static testMethod void Resend_createbulkProspectFailureTest() {
		test.startTest();
		List<Account> accountList = new List<Account>{};
		Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
		Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();	 
		accountList = TestDataFactory.createAccount(1);
		accountList[0].recordtypeid = ProspectRecordTypeId;	  
		accountList[0].AccountNumber = '30191217';
		accountList[0].Website = 'testaudfhieuqrqgrrwkgvfrufgwejgfwekfgwufehwdfjkgwekjfgiuwefgweiugfuweigfwjekfgwkeufgwekfgwkejfgekwfjegfwkefgweuifgwefdewewfsdfdfdfgd.com';
		accountList[0].BillingPostalCode='12345678959';
		Insert accountList[0];
		List<String> strList= new List<String>();
		strList.add(accountList[0].Id);
		Test.setMock(HttpCalloutMock.class, new ProspectCreationMockResponseFailureTest());
		Resend_prospectCreationCallout.Resend_createbulkProspect(strList);
		Test.stopTest();
		
	}
}