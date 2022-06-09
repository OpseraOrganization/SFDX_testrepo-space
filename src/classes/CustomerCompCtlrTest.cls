@IsTest
public class CustomerCompCtlrTest {

		 private static testMethod void CheckNSATestPositive() {  
	 		List<Account> accountList = new  List<Account>();
		 	Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
		 	
		 	accountList = TestDataFactory.createAccount(1);
			accountList[0].recordtypeid = custRecordTypeId;
		 	accountList[0].Customer_Compliance__c = 'US_Sprint';
		 	database.insert(accountList[0]);
		
		 	ApexPages.StandardController sc = new ApexPages.StandardController(accountList[0]);

			CustomerCompCtlr CustComp = new CustomerCompCtlr(sc);
		 	CustComp.checkNSA();
	 }
	
	 private static testMethod void CheckNSATestNegative() {  
	 		List<Account> accountList = new  List<Account>();
		 	Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
		 	
		 	accountList = TestDataFactory.createAccount(1);
			accountList[0].recordtypeid = custRecordTypeId;
		 	accountList[0].Customer_Compliance__c = 'US_Govern';
		 	database.insert(accountList[0]);
		 
			ApexPages.StandardController sc = new ApexPages.StandardController(accountList[0]);

			CustomerCompCtlr CustComp = new CustomerCompCtlr(sc);
		 	CustComp.checkNSA();
			  
	 }					 
	
}