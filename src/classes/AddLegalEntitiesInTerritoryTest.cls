@isTest
public class AddLegalEntitiesInTerritoryTest {
	static testmethod void test1() {
		// startTest/stopTest block to force async processes 
		//   to run in the test.
		Test.startTest(); 
	   
		
	   
			List<Account> accountList = new  List<Account>();
			List<Account> accountListTemp = new  List<Account>();
			
	
			Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
			accountList = TestDataFactory.createAccount(3);
			accountList[0].recordtypeid = custRecordTypeId;
			accountList[1].recordtypeid = LERecordTypeId;
			accountList[1].AccountNumber='103087199999';
			accountList[2].recordtypeid = LERecordTypeId;
			accountList[1].AccountNumber='103087166666';
			
			database.insert(accountList[0]); 
			
			ObjectTerritory2Association o2t = new ObjectTerritory2Association();
			o2t.objectId = accountList[0].id;
			o2t.Territory2Id  = TestDataFactory.getL7TerritoryId();
			o2t.AssociationCause = GlobalConstants.TERRITORY2MANUAL;
			insert o2t;
			
			accountList[1].parentid = accountList[0].id;
			accountList[1].Default_Legal_Entity__c = true;
			
			database.insert(accountList[1]); 
			database.insert(accountList[2]);
			 
			System.enqueueJob(new AddLegalEntitiesInTerritory(accountList));
			Test.stopTest();
	   
	   
	}
}