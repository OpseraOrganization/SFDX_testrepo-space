@istest	
public class CH_CA_WorkGroup_Rule_Controller_Test {
	@testSetup
	public static void setup(){
		Test.startTest();
		CH_UTIL_TEST.setupCase(false);
		Test.stopTest();
	}
	
	@istest
	static void testCDBRecords(){
		Test.startTest();
		CH_CA_WorkGroup_Rule_Controller.getCdbRecords();
		Test.stopTest();
	}
	
	@istest
	static void testWGRuleDetails(){
		Test.startTest();
		CH_Workgroup_Rule__c workgroupRules = [SELECT id,Name,CH_Workgroup__c,CH_OrderNumber__c,CH_Active__c,CH_ServiceType__c,CH_Contract_Type__c,CH_Workgroup_Type__c,
			  CH_Severity__c,CH_Outage__c,CH_LevelOfSupport__c,CH_Customer_Group__c,CH_Account__c,CH_ServiceContract__c,
			  CH_Region1__c,CH_Country1__c,CH_Product_Group__c,CH_Product__c,CH_Solution__c,CH_ProductRelease__c,
			  CH_ProductVariant__c,CH_Product_Module__c,CH_Workgroup__r.Name  FROM CH_Workgroup_Rule__c 
			  WHERE CH_Workgroup__r.Name = :CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];	
		CH_CA_WorkGroup_Rule_Controller.getWGRuleDetails(workgroupRules.Id);
		CH_CA_WorkGroup_Rule_Controller.getKBRuleDetails(workgroupRules.Id);
		 System.assert(workgroupRules.CH_Workgroup__r.Name == 'TEST', 'Expected TEST. Actual ' + workgroupRules.CH_Workgroup__r.Name);
		Test.stopTest();
	}
	
}