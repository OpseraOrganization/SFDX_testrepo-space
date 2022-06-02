@isTest
public class CQ_customLookUpControllerTest {
	private static  Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
	static testMethod void test(){
		user SysAdmin1= TestDataFactory.userCreation(1,'System Administrator')[0];
		Database.insert(SysAdmin1);
		System.runAs(SysAdmin1){
			Test.startTest();
			Account accountNoNvzw = NF_TestDataFactory.createAccount('1TestNONVZW0000');
			accountNoNvzw.RecordTypeId=custRecordTypeId;
			Database.insert(accountNoNvzw);
			List<Contact> conList = TestDataFactory.createContact2(1,accountNoNvzw);
			conList[0].CH_ContactType__c = 'Customer';
			conList[0].Contact_Status__c = 'Active';
			Database.insert(conList);
			System.debug('conList::> '+conList[0]);
			CQ_customLookUpController.fetchLookUpValues('test','User',null);
			CQ_customLookUpController.fetchLookUpValues('Roger','Contact',accountNoNvzw.Id);
			Test.stopTest();
		}
	}
}