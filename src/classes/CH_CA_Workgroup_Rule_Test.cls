@isTest 
public class CH_CA_Workgroup_Rule_Test {
	@testSetup
	static void setuptestdata(){
		CH_UTIL_TEST.setupCase(false);
	}

	@isTest
	static void testGetWorkgroupRules(){
		test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Critical', 'Yes', 'CH_NokiaIncidentWithRestoration', false);
		CH_CA_Assignment_Criteria_DTO rule = new CH_CA_Assignment_Criteria_DTO().createIncidentSearchCriteria(newCase);
		rule.serviceType='Customer Support';
		List<CH_Workgroup_Rule__c> foundRules = CH_CA_Workgroup_Rule.GetWorkgroupRules(rule);
		test.stopTest();
	
		System.assert(foundRules.size() == 1,'Expected 1. Found ' + foundRules.size()); 
		System.assert(foundRules[0].Name == 'CATCH ALL', 'Rule 1 found CATCH ALL');
	}

	@isTest
	static void testGetWorkgroupRules22(){
		test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Critical', 'Yes', 'CH_NokiaIncidentWithRestoration', false);
		
		CH_CA_Assignment_Criteria_DTO ruleDTO = new CH_CA_Assignment_Criteria_DTO().createIncidentSearchCriteria(newCase);
		System.assert(ruleDTO != null,'DTO is created'); 
		
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = new CH_CA_DTO.SearchCriteriaDTO();
		searchCriteriaDTO.severity = 'Critical';
		searchCriteriaDTO.outage = 'Yes';
		searchCriteriaDTO.serviceType='Customer Support';		
		

		CH_CA_Workgroup_Rule rule = new CH_CA_Workgroup_Rule();
		CH_CA_Assignment_Criteria_DTO foundDTO = rule.getWorkgroupRules(searchCriteriaDTO, true);
		test.stopTest();
		System.assert(foundDTO != null,'DTO is created'); 
	}
	
	@isTest
	static void testGetWorkgroupRules2(){
		test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		CH_CA_Assignment_Criteria_DTO rule = new CH_CA_Assignment_Criteria_DTO().createIncidentSearchCriteria(newCase);
		CH_CA_Assignment_Criteria_DTO foundRules = new CH_CA_Workgroup_Rule().GetWorkgroupRules2(rule,true);
		CH_CA_Assignment_Criteria_DTO foundRules1 = new CH_CA_Workgroup_Rule().GetWorkgroupRules2(rule,false);
		System.assert(foundRules != null,'Rules is created'); 
		System.assert(foundRules1 != null,'Rules1 is created'); 
		test.stopTest();
	}
}