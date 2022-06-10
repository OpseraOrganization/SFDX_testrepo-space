@isTest
public class CH_CA_Workgroup_Filters_Test {
		
	@testSetup   
	static void setuptestdata(){   
		CH_UTIL_TEST.setupCase(false); 
		CH_UTIL_TEST.createWorkgroupSchedules(); 
	}

	@istest
	static void getValidSchedulebyFilter(){
		test.starttest();
		Case currentCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		Insert currentCase;

		List<CH_Workgroup_Schedule__c> schedules = [SELECT Id, CH_Workgroup__c,CH_Workgroup_Filters_Count__c FROM CH_Workgroup_Schedule__c];

		CH_CA_DTO.SearchCriteriaDTO searchCriteria = createSearchCriteria(currentCase);	
		CH_CA_Workgroup_Filters filters = new CH_CA_Workgroup_Filters();
		set<Id> lstOfScheduleIds = filters.getSchedulePerWorkgroupWithHighestWeight(searchCriteria, schedules);
		// DTO to send the search criteria through the layers
		Map<Id, integer> lstOfSchduleIds = filters.getAllSchedulePerWorkgroupWithWeight(searchCriteria, schedules);
		test.stoptest();
		
		System.assert(lstOfScheduleIds.size() == 1, 'Expected 1 valid schedule should be found. Actual ' + lstOfScheduleIds.size());
	}

	@istest
	static void getValidSchedulebyFilterNoFilter(){
		test.starttest();
		Case currentCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		Insert currentCase;
		
		List<CH_Workgroup_Schedule__c> schedules = [SELECT Id, CH_Workgroup__c, CH_Workgroup_Filters_Count__c FROM CH_Workgroup_Schedule__c];
		// Delete the filter
		CH_Workgroup_Filter__c filter = [SELECT Id FROM CH_Workgroup_Filter__c LIMIT 1];
		delete filter;
		
		CH_CA_DTO.SearchCriteriaDTO searchCriteria = createSearchCriteria(currentCase);		
		CH_CA_Workgroup_Filters filters = new CH_CA_Workgroup_Filters();
		set<Id> lstOfScheduleIds = filters.getSchedulePerWorkgroupWithHighestWeight(searchCriteria, schedules);
		test.stoptest();
		
		System.assert(lstOfScheduleIds.size() == 0, 'Expected 0 valid schedule should be found. Actual ' + lstOfScheduleIds.size());
	}	
	
	@istest
	static void getValidSchedulebyFilterWithCustomer_Association(){
		test.starttest();
		Case currentCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		Insert currentCase;
		
		List<CH_Workgroup_Schedule__c> schedules = [SELECT Id, CH_Workgroup__c,CH_Workgroup_Filters_Count__c FROM CH_Workgroup_Schedule__c];
		Account legalAccount = [SELECT Id FROM Account WHERE Name = 'LEGAL-ACCOUNT' LIMIT 1];
		//Creating filter 
		CH_Workgroup_Filter__c schedulefilter7 = [SELECT Id,CH_Workgroup_Schedule__c from CH_Workgroup_Filter__c where 
	 CH_Workgroup_Schedule__c=:schedules[0].Id LIMIT 1];
		//Associating filter with customer
		CH_Workgroup_Filter_Customer_Association__c custAsso7 = new CH_Workgroup_Filter_Customer_Association__c();
		custAsso7.CH_Account__c = legalAccount.Id;
		custAsso7.CH_Workgroup_Filter__c = schedulefilter7.Id;
		insert custAsso7;
		CH_CA_DTO.SearchCriteriaDTO searchCriteria = createSearchCriteria(currentCase);		
		CH_CA_Workgroup_Filters filters = new CH_CA_Workgroup_Filters();		
		set<Id> lstOfScheduleIds = filters.getSchedulePerWorkgroupWithHighestWeight(searchCriteria, schedules);
		// DTO to send the search criteria through the layers
		Map<Id, integer> lstOfSchduleIds = filters.getAllSchedulePerWorkgroupWithWeight(searchCriteria, schedules);
		test.stoptest();
		
		System.assert(lstOfScheduleIds.size() == 1, 'Expected 1 valid schedule should be found. Actual ' + lstOfScheduleIds.size());
	}
	@istest
	static void getValidSchedulebyFilterWithProduct_Association(){
		test.starttest();
		Case currentCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		Insert currentCase;
		
		List<CH_Workgroup_Schedule__c> schedules = [SELECT Id, CH_Workgroup__c,CH_Workgroup_Filters_Count__c FROM CH_Workgroup_Schedule__c];
		Product2 product = [SELECT Id FROM Product2 WHERE Name = 'TestProduct' LIMIT 1];
		//Creating filter 
		CH_Workgroup_Filter__c schedulefilter7 = [SELECT Id,CH_Workgroup_Schedule__c from CH_Workgroup_Filter__c where 
	 CH_Workgroup_Schedule__c=:schedules[0].Id LIMIT 1];
		//Associating filter with product
		CH_Workgroup_Filter_Product_Association__c prodAsso7 = new CH_Workgroup_Filter_Product_Association__c();
		prodAsso7.CH_Product__c = product.Id;
		prodAsso7.CH_Workgroup_Filter__c = schedulefilter7.Id;
		insert prodAsso7;
		CH_CA_DTO.SearchCriteriaDTO searchCriteria = createSearchCriteria(currentCase);		
		CH_CA_Workgroup_Filters filters = new CH_CA_Workgroup_Filters();		
		set<Id> lstOfScheduleIds = filters.getSchedulePerWorkgroupWithHighestWeight(searchCriteria, schedules);
		// DTO to send the search criteria through the layers
		Map<Id, integer> lstOfSchduleIds = filters.getAllSchedulePerWorkgroupWithWeight(searchCriteria, schedules);
		test.stoptest();
		
		System.assert(lstOfScheduleIds.size() == 1, 'Expected 1 valid schedule should be found. Actual ' + lstOfScheduleIds.size());
	}
	// Create DTO to send the search criteria through the layers	
	private static CH_CA_DTO.SearchCriteriaDTO createSearchCriteria(Case currentCase){
		CH_CA_DTO.SearchCriteriaDTO searchCriteria = new CH_CA_DTO.SearchCriteriaDTO();
		searchCriteria.country = currentCase.Country__c;
		searchCriteria.region = currentCase.id == null ? currentCase.HWS_Region__c : CH_CA_Assignment_Criteria_DTO.getRegionByCountry(currentCase.Country__c);
		searchCriteria.outage = currentCase.CH_Outage__c;
		searchCriteria.severity = currentCase.Severity__c;
		searchCriteria.customerId = currentCase.AccountId;
		searchCriteria.productId = currentCase.ProductId;
		searchCriteria.productVariant = currentCase.CH_ProductVariant__c;
		searchCriteria.solution = currentCase.CH_Solution__c;
		List<string> workgroupTypes = new List<string>();
		
		
		Id problemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		// If not a problem then
		if (currentCase.RecordTypeID != problemRecordTypeId){
			if (currentCase.Status!= ''){
	workgroupTypes.add('Engineer'); 
	workgroupTypes.add('Smart Tier 1'); 
			} else {
	workgroupTypes.add('Expert');
	workgroupTypes.add('Engineer'); 
			}
		} else {
			workgroupTypes.add('Expert');
		}
		searchCriteria.workgroupTypes = workgroupTypes; 
		if (!String.isBlank(currentCase.Status)){
			if (currentCase.Status == 'Created'){
	searchCriteria.levelOfSupports.add('Initial Support');	 
			}
			else {
	searchCriteria.levelOfSupports.add('Initial Support');
	searchCriteria.levelOfSupports.add('Advanced Support');			
			}
		}

		return searchCriteria;	  
	}	
}