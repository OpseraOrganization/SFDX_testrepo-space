@isTest
public class CH_CaseTagUtils_Test {
	
	private static List<Product2> oProduct2List;

	@testSetup	
	static void setupTestData() {
		oProduct2List = TestDataFactory.createProduct(2);
		insert oProduct2List;
		//
		List<Product_Relation__c> oProductRelationList = TestDataFactory.createProductRelation(1, oProduct2List.get(0), oProduct2List.get(1));
		insert oProductRelationList;
		//
		CH_CaseTag__c oCaseTag = new CH_CaseTag__c();
		oCaseTag.CH_Product__c = oProduct2List[0].Id;
		oCaseTag.CH_IssueType__c='3rdParty-Config';
		oCaseTag.CH_IssueDetails__c='Test' + Utils.generateRandomInteger(2) + Utils.generateRandomString(2);
		oCaseTag.CH_AdditionalDetails__c='Test' + Utils.generateRandomInteger(2) + Utils.generateRandomString(2);
		oCaseTag.CH_Status__c='Active';
		oCaseTag.RecordTypeId = Schema.SObjectType.CH_CaseTag__c.getRecordTypeInfosByDeveloperName().get('CH_CaseTag').getRecordTypeId();
		//insert oCaseTag;
	}
	
	public static testMethod void test() {
		setupTestData();
		test.startTest();
		try { CH_CaseTagUtils.getTagDetails('CH_AdditionalDetails__c', oProduct2List[0].Id, '3rdParty-Config', 'Test'); } catch(Exception e) {}
		try { CH_CaseTagUtils.getTag(oProduct2List[0].Id, '3rdParty-Config', 'Test', 'Test'); } catch(Exception e) {}
		test.stopTest();
	}

}