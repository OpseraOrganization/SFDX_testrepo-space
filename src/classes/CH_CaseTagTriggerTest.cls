/** 
 * About 
 * ----- 
 * @Description	  : CH_CaseTag__c Object Trigger Test Class.
 * @Project	: Case Handling.
 * @Modification Log : 
 *  Created  : 2020 07 03 – tiago.almeida@nokia.com
 * ----- 
**/
@isTest
public class CH_CaseTagTriggerTest {
	private static List<CH_CaseTag__c> oCaseTagList = new List<CH_CaseTag__c>();
	
	@testSetup	
	static void setupTestData() {
		List<Product2> oProduct2List = TestDataFactory.createProduct(2);
		insert oProduct2List;
		//
		List<Product_Relation__c> oProductRelation = TestDataFactory.createProductRelation(1, oProduct2List.get(0), oProduct2List.get(1));
		insert oProductRelation;
		//
		for(Integer i = 0; i < 2; i++) {
			CH_CaseTag__c oCaseTag = new CH_CaseTag__c();
			oCaseTag.CH_Product__c = oProduct2List[0].Id;
			oCaseTag.CH_IssueType__c='3rdParty-Config';
			oCaseTag.CH_IssueDetails__c='Test'+i;
			oCaseTag.CH_AdditionalDetails__c='Test';
			oCaseTag.CH_Status__c='Active';
			oCaseTag.RecordTypeId = Schema.SObjectType.CH_CaseTag__c.getRecordTypeInfosByDeveloperName().get('CH_CaseTag').getRecordTypeId();
			oCaseTagList.add(oCaseTag);
		}
	}
	
	public static testMethod void test() {
		setupTestData();
		test.startTest();
		insert oCaseTagList;
		try {
			CH_CaseTag__c oCaseTag = oCaseTagList.get(1);
			oCaseTag.CH_IssueDetails__c='Test0';
			update oCaseTag;
		} catch(Exception e) {
	  //Added empty line to fix sonar cube issue
		}
		test.stopTest();
	}
}