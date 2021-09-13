/****************************************
* Class Name : CH_AssetComplianceUpdate_Batch_Test 
* Created Date: 23 December 2019
* Created By : Bharathi Nutakki - TCS
* Description : Test class for CH_AssetCustomerComplianceUpdate_Batch
************/
@isTest
public class CH_AssetComplianceUpdate_Batch_Test {
	public static testMethod void test() {
		Id accRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		Id assetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Covered Part').getRecordTypeId();
		List<Asset> astList = new List<Asset>();
		
		Account acc=new Account();
		acc.Name='test';
		acc.RecordTypeId=accRecordTypeId;
		acc.BillingCountry='India';
		acc.BillingCity='Hyd';
		acc.BillingStreet='Hyd';
		acc.Customer_Compliance__c='US_Sprint';
		insert acc;
		
		Asset ast = new Asset();
		ast.RecordTypeId = assetRecordTypeId;
		ast.Name = 'Test Asset';
		ast.AccountId = acc.Id;
		insert ast;
		astList.add(ast);
		
		CH_CustomerCompliance__c custComp = new CH_CustomerCompliance__c();
		custComp.Name = 'Date';
		custComp.CH_StartDate__c = date.valueOf('2019-03-11T14:30:00.000+0000');
		insert custComp;
						
		test.startTest();				
		acc.Customer_Compliance__c='US_Govern';
		update acc;
		
		CH_AssetCustomerComplianceUpdate_Batch accu = new CH_AssetCustomerComplianceUpdate_Batch();
		Database.BatchableContext BC;
		SchedulableContext SC;
		accu.start(BC);
		accu.execute(BC,astList);
		accu.finish(BC);
		accu.execute(SC);
		test.stopTest();
	}
}