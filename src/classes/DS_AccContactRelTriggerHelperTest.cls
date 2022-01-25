@isTest
public class DS_AccContactRelTriggerHelperTest {

	public static testmethod void checkRecordExistTest(){
		
		test.startTest();
		
		Account accCustomer = TestDataFactory.createAccount(1)[0];
		accCustomer.AccountNumber='100006843';
		accCustomer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		database.insert(accCustomer);
		
		Contact contactRecordCustomer = TestDataFactory.createContact(1,accCustomer)[0];
		contactRecordCustomer.FirstName = 'Customer User';
		contactRecordCustomer.LastName = 'SWx Test';
		database.insert(contactRecordCustomer); 
		
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='1000068431';
		accLegalEntity.ParentId=accCustomer.ID;
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		database.insert(accLegalEntity);
		
		AccountContactRelation accContactRelRecordLegalEntity = new AccountContactRelation();
		accContactRelRecordLegalEntity.AccountId=accLegalEntity.Id;
		accContactRelRecordLegalEntity.ContactId=contactRecordCustomer.Id;
		database.insert(accContactRelRecordLegalEntity);
		
		Account accRecord = TestDataFactory.createAccount(1)[0];
		accRecord.AccountNumber='';
		accRecord.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Logistic_Account').getRecordTypeId();
		accRecord.ParentId=accLegalEntity.ID;
		accRecord.P20_Logistic_ID__c= '12345';
		database.insert(accRecord);
		
		List<AccountContactRelation> accContactRelList = new List<AccountContactRelation>();
		Map<Id,AccountContactRelation> accContactRelMap = new Map<Id,AccountContactRelation>();
		
		AccountContactRelation accContactRelRecord = new AccountContactRelation();
		accContactRelRecord.AccountId=accRecord.Id;
		accContactRelRecord.ContactId= contactRecordCustomer.ID;
		database.insert(accContactRelRecord);
		
		accContactRelList.add(accContactRelRecord);
		accContactRelMap.put(accContactRelRecord.Id, accContactRelRecord);
		
		test.stopTest();
		
	}
}