/****************************************
* Class Name : CH_AccountCustomerComplianceBatch_Test 
* Created Date: 29 April 2020
* Created By : TCS
* Description : Test class for CH_AccountCustomerComplianceUpdate_Batch
************/
@isTest
public class CH_AccountCustomerComplianceBatch_Test {
	public static testMethod void test() {
		Id legalAccRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		Id logisticAccRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Logistic Account').getRecordTypeId();
		List<Account> accList = new List<Account>();
		
		Account acc=new Account();
		acc.Name='test';
		acc.RecordTypeId=legalAccRecordTypeId;
		acc.BillingCountry='India';
		acc.BillingCity='Hyd';
		acc.BillingStreet='Hyd';
		acc.Customer_Compliance__c='US_Sprint';
		insert acc;
		accList.add(acc);
		
		Account acc1=new Account();
		acc1.Name='test logistic';
		acc1.RecordTypeId=logisticAccRecordTypeId;
		acc1.ParentId = acc.Id;
		acc1.BillingCountry='India';
		acc1.BillingStreet='Test Street';
		acc1.BillingCity='Test City';
		acc1.BillingPostalCode='12345';
		insert acc1;
		accList.add(acc1);
		CH_CustomerCompliance__c custComp = new CH_CustomerCompliance__c();
		custComp.Name = 'AccountLastModifiedDate';
		custComp.CH_StartDate__c = date.valueOf('2020-04-29T14:30:00.000+0000');
		custComp.CH_AccountFullShare__c = true;
		insert custComp;
		
		test.startTest();	
		acc.Customer_Compliance__c='US_Govern';
		update acc;
		//accList.add(acc);
		CH_AccountCustomerComplianceUpdate_Batch accu = new CH_AccountCustomerComplianceUpdate_Batch();
		Database.BatchableContext BC;
		SchedulableContext SC;
		accu.start(BC);
		accu.execute(BC,accList);
		accu.finish(BC);
		accu.execute(SC);
		test.stopTest();
	}
}