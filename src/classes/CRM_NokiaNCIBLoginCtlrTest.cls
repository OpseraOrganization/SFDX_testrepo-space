@istest
public class CRM_NokiaNCIBLoginCtlrTest {

	testmethod static void testFetchNCIBUrl(){
		CRM_NokiaNCIBLoginCtlr.AccWrapper response = new CRM_NokiaNCIBLoginCtlr.AccWrapper();
		ISO_Country_Codes__c iso = new ISO_Country_Codes__c();
		iso.Name='US';   
		iso.Market__c='Market North America';
		iso.Country_Name__c='United States of America';
		iso.NCIBURL__c = 'www.test.com';
		insert iso;
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '1234'; 
		accountCreation.Country__c = 'Portugal';
		database.insert(accountCreation);
		
		Test.startTest();
		response = CRM_NokiaNCIBLoginCtlr.fetchNCIBUrl(null);
		System.assert(response.errorMsg != null);
		response = CRM_NokiaNCIBLoginCtlr.fetchNCIBUrl(accountCreation.Id);
		System.assert(response.errorMsg != null);
		update new Account(Id=accountCreation.Id, Country__c='United States of America');
		response = CRM_NokiaNCIBLoginCtlr.fetchNCIBUrl(accountCreation.Id);
		System.assert(response.ncibUrl != null);
		Test.stopTest();
	}
	
}