@isTest
public class DetectCustomerTerritorySchedularTest{
	static testmethod void test1() {
		test.starttest();
		
			
			List<Account> accountList = new  List<Account>();
			List<Account> accountListTemp = new  List<Account>();
			
			Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
			accountList = TestDataFactory.createAccount(3);
			accountList[0].recordtypeid = custRecordTypeId;
			accountList[1].recordtypeid = LERecordTypeId;
			accountList[1].AccountNumber='103087122222';
			accountList[2].recordtypeid = LERecordTypeId;
			accountList[1].AccountNumber='103087133333';
			
			database.insert(accountList[0]); 
			
			ObjectTerritory2Association o2t = new ObjectTerritory2Association();
			o2t.objectId = accountList[0].id;
			o2t.Territory2Id  = TestDataFactory.getAnotherL7TerritoryId();
			o2t.AssociationCause = GlobalConstants.TERRITORY2MANUAL;
			insert o2t;
			
			accountList[1].parentid = accountList[0].id;
			accountList[1].Default_Legal_Entity__c = true;
			
			database.insert(accountList[1]); 
			database.insert(accountList[2]);
			 
			ObjectTerritory2Association o2t1 = new ObjectTerritory2Association();
			o2t1.objectId = accountList[0].id;
			o2t1.Territory2Id  = TestDataFactory.getL7TerritoryId();
			o2t1.AssociationCause = GlobalConstants.TERRITORY2MANUAL;
			insert o2t1;
			
			DetectCustomerTerritoryChangesSchedular sh1 = new DetectCustomerTerritoryChangesSchedular();
			String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1); 
			
		
	}
}