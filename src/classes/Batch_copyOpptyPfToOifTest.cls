@isTest 
public class Batch_copyOpptyPfToOifTest
{
	static testMethod void testMethod1() 
	{
		Id dealFramedRecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Framed Deal').getRecordTypeId();
		Deal__c dealCreation = TestDataFactory.createDeal(1)[0];
		dealCreation.RecordTypeId = dealFramedRecordTypeId;
		DataBase.insert(dealCreation);
		Test.startTest();
			Batch_copyOpptyPfToOif obj = new Batch_copyOpptyPfToOif();
			DataBase.executeBatch(obj);			 
		Test.stopTest();
	}
}