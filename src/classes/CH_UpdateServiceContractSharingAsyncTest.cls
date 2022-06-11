@isTest
public class CH_UpdateServiceContractSharingAsyncTest {
	
	public static testMethod void test1(){
		Map<Id,Account> oOldAccounts = new Map<Id, Account>();
		Map<Id,Account> oNewAccounts = new Map<Id, Account>();
		
		Id accRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
		Id servRecordTypeId=Schema.SObjectType.ServiceContract.getRecordTypeInfosByName().get('CARE Service Contract').getRecordTypeId();
		
		Account acc=new Account();
		acc.Name='test';
		acc.RecordTypeId=accRecordTypeId;
		acc.BillingCountry='India';
		acc.BillingCity='Hyd';
		acc.BillingStreet='Hyd';
		acc.Customer_Compliance__c='US_Cox';
		insert acc;
		
		Account acc1=new Account();
		acc1.Name='test11';
		acc1.RecordTypeId=accRecordTypeId;
		acc1.BillingCountry='India';
		acc1.BillingCity='Hyd';
		acc1.BillingStreet='Hyd';
		acc1.Customer_Compliance__c='US_Cox';
		acc1.ParentId=acc.id;
		insert acc1;
	   
		ServiceContract serContract1 =new ServiceContract();
		serContract1.RecordTypeId = servRecordTypeId;
		serContract1.AccountId = acc.id;
		serContract1.Name = 'TCS Service Contract TestData1';
		serContract1.CurrencyIsoCode='EUR';
		serContract1.CH_CDB_ContractId__c = '123456tes1t';
		serContract1.CH_CDB_PreviousContractId__c = '123456test';
		serContract1.StartDate = system.today();
		serContract1.EndDate = system.today()+10;
		serContract1.CH_CAPM_EmailAddress__c = 'cmmkp7777@nokia.com';
		serContract1.CH_PriceBook__c = 'Nokia CARE Price Book';
		//serContract1.Pricebook2Id = customPB1.Id;
		insert serContract1;
		
		ServiceContract serContract2 =new ServiceContract();
		serContract2.RecordTypeId = servRecordTypeId;
		serContract2.AccountId = acc.id;
		serContract2.Name = 'TCS Service Contract TestData2';
		serContract2.CurrencyIsoCode='EUR';
		serContract2.CH_CDB_ContractId__c = '123456tes2t';
		serContract2.CH_CDB_PreviousContractId__c = '1234567test';
		serContract2.StartDate = system.today();
		serContract2.EndDate = system.today()+10;
		serContract2.CH_CAPM_EmailAddress__c = 'cmmkp7777@nokia.com';
		serContract2.CH_PriceBook__c = 'Nokia CARE Price Book';
		//serContract2.Pricebook2Id = customPB1.Id;
		insert serContract2;
		
		CH_SecurityGroups__c SecurityGroup = new CH_SecurityGroups__c();
		SecurityGroup.GroupName__c='SEC_Sprint';
		SecurityGroup.CH_CustomerCompliance__c='US_Sprint';
		SecurityGroup.Name = '123';
		SecurityGroup.GroupId__c='00G410000034hrQEAQ';
		insert SecurityGroup;
		
		Group GroupName = new Group();
		GroupName.DeveloperName='SEC_Sprint1';
		GroupName.Name='SEC|Sprint|||';
		insert GroupName;
		
		 Group GroupName1 = new Group();
		GroupName1.DeveloperName='US_Cox';
		GroupName1.Name='US_Cox';
		insert GroupName1;
		
		CH_SecurityGroups__c SecurityGroup1 = new CH_SecurityGroups__c();
		SecurityGroup1.GroupName__c='US_Cox';
		SecurityGroup1.CH_CustomerCompliance__c='US_Cox';
		SecurityGroup1.Name = '1233';
		SecurityGroup1.GroupId__c=GroupName1.ID;
		insert SecurityGroup1;
		
		 Group GroupName2 = new Group();
		GroupName2.DeveloperName='All';
		GroupName2.Name='All';
		insert GroupName2;
		
		CH_SecurityGroups__c SecurityGroup2 = new CH_SecurityGroups__c();
		SecurityGroup2.GroupName__c='All';
		SecurityGroup2.CH_CustomerCompliance__c='All';
		SecurityGroup2.Name = '1233All';
		SecurityGroup2.GroupId__c=GroupName2.ID;
		insert SecurityGroup2;
		
		ServiceContractShare oContractShare = new ServiceContractShare();				   
		oContractShare.AccessLevel = 'Read';				   
		oContractShare.ParentId = serContract1.Id;
		oContractShare.UserOrGroupId = '00G410000034hr5EAA';
			 
		insert oContractShare;
		
		Test.startTest();  
		
		//serContract2.AccountId = acc1.id;
		//update serContract2;
		acc.Customer_Compliance__c='US_Sprint';
		update acc;
		acc1.Customer_Compliance__c='US_Sprint';
		update acc1;
		
		ServiceContractShare deletedShare = [SELECT Id, IsDeleted FROM ServiceContractShare WHERE Id = :oContractShare.Id LIMIT 1];
			System.assertEquals(deletedShare.IsDeleted, false);

		ServiceContractShare oContractShare2 = new ServiceContractShare();
		oContractShare2.AccessLevel = 'Read';
		oContractShare2.ParentId = serContract2.Id;
		oContractShare2.UserOrGroupId = '00G410000034hr5EAA';
		insert oContractShare2;
		 
		Test.stopTest();

}
}