@isTest
public class CH_UpdateServiceContractSharing_Test {
	static testMethod void testSchedule(){
		List<Account> accountList = new  List<Account>();
		List<Account> accountListTemp = new  List<Account>();
		Map<Id,Account> oldvalues = new Map<Id,Account>();
		Map<Id,Account> newValues = new Map<Id,Account>();	
		Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
		
		accountList = TestDataFactory.createAccount(2);
		//accountList[0].recordtypeid = custRecordTypeId;
		accountList[1].recordtypeid = LERecordTypeId;
		//database.insert(accountList[0]); 
		
	   // accountList[1].parentid = accountList[0].id;
		accountList[1].AccountNumber = '1000087011';
		accountList[1].Customer_Compliance__c  = 'US_SCEC';
		database.insert(accountList[1]); 
		
		oldvalues.put(accountList[1].Id, accountList[1]); 
		
		accountList[1].Customer_Compliance__c='US_Sprint';
		database.update(accountList[1]);  
		
		newvalues.put(accountList[1].Id, accountList[1]);
		
		ServiceContract oServiceContract = new ServiceContract();
		oServiceContract.AccountId = accountList[1].id;
		oServiceContract.Name = 'Test Service Contract';
		oServiceContract.CH_CDB_ContractId__c = 'Test';
		oServiceContract.CH_EntitlementScript__c = 'Header Script';
		oServiceContract.Pricebook2Id = Test.getStandardPricebookId();
		insert oServiceContract;
		
		Group GroupName = new Group();
		GroupName.DeveloperName='SEC_Sprint1';
		GroupName.Name='SEC|Sprint|||';
		insert GroupName;
		
		CH_SecurityGroups__c SecurityGroup = new CH_SecurityGroups__c();
		SecurityGroup.GroupName__c='SEC_Sprint';
		SecurityGroup.CH_CustomerCompliance__c='US_Sprint';
		SecurityGroup.Name = '123';
		SecurityGroup.GroupId__c=GroupName.Id;
		insert SecurityGroup;
		
		CH_SecurityGroups__c SecurityGrop = new CH_SecurityGroups__c();
		SecurityGrop.GroupName__c='SEC_Cox';
		SecurityGrop.CH_CustomerCompliance__c='OTHER';
		SecurityGrop.Name = '1234';
		SecurityGrop.GroupId__c=GroupName.Id;
		insert SecurityGrop;
		
		CH_SecurityGroups__c SecurityGrop1 = new CH_SecurityGroups__c();
		SecurityGrop1.GroupName__c='SEC_Cox';
		SecurityGrop1.CH_CustomerCompliance__c='ALL';
		SecurityGrop1.Name = '12345';
		SecurityGrop1.GroupId__c=GroupName.Id;
		insert SecurityGrop1;
		
		test.startTest();
		CH_UpdateServiceContractSharing.execute(oldvalues,newvalues); 
		test.stopTest();
	}  
}