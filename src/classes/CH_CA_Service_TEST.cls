@isTest 
public class CH_CA_Service_TEST {
	public static final string NSC='CH_NokiaStandardCase';
	public static final string sampleexpt = 'Expected 3. Actual ';
	public static final string sampleexpt1 = 'Expected 6. Actual ';
	public static final string sampleexpt2 = 'Expected Minor. Actual ';
	public static final string sampleexpt3 = 'Expected No. Actual ';
	@testSetup  
	static void setuptestdata(){  
		Test.startTest();
		CH_UTIL_TEST.setupCase(false);   
		Test.stopTest();
	}
	 
	//Get the all workgroup members for active assignment with hotline
	@isTest
	static void testGetActiveCaseAssignmentWorkgroupMembersHotline(){ 
		Test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Major', 'Yes', CH_CA_Service_TEST.NSC, false);
		Insert newCase;
		Test.stopTest();
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembers = service.getCaseAssignmentWorkgroupMembers();
		System.assert(workgroupMembers.size() == 3,sampleexpt + workgroupMembers.size());
		
	}
	
	@isTest
	static void testGetActiveCaseAssignmentWorkgroupMembersHotlinePassive(){ 
		Test.Starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Major', 'Yes', CH_CA_Service_TEST.NSC, false);
		newCase.CH_Initial_Assignment__c = false;
		Insert newCase;
		Test.Stoptest();
		CH_CA_Service getActiveService = new CH_CA_Service(newCase.id);
		List<CH_CA_DTO.WorkgroupMemberDTO> getActiveWorkgroupMembers = getActiveService.getCaseAssignmentWorkgroupMembers();
		System.assert(getActiveWorkgroupMembers.size() == 3,sampleexpt + getActiveWorkgroupMembers.size());
		
	}
	
	// Get the all workgroup members for active assignment with hotline
	@isTest
	static void testGetActiveCaseAssignmentWorkgroupMembersHotlineForActiveAssignment(){ 
		Test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Critical', 'Yes', CH_CA_Service_TEST.NSC, false);
		Insert newCase;
		Test.stoptest();
		CH_CA_Service getHotlineService = new CH_CA_Service(newCase.id);
		List<CH_CA_DTO.WorkgroupMemberDTO> getHotlineWorkgroupMembers = getHotlineService.getCaseAssignmentWorkgroupMembers();
		System.assert(getHotlineWorkgroupMembers.size() == 5,'Expected 5. Actual ' + getHotlineWorkgroupMembers.size());
		
	}
	
	@isTest
	static void testGetActiveCaseAssignmentWorkgroupMembersHotlineForActiveReAssignment(){ 
		Test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Critical', 'Yes', CH_CA_Service_TEST.NSC, false);
		newCase.CH_Initial_Assignment__c = false;
		Insert newCase;
		Test.Stoptest();
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembers = service.getCaseAssignmentWorkgroupMembers();
		System.assert(workgroupMembers.size() == 5,'Expected 5. Actual ' + workgroupMembers.size());
		
	}
	
	// Get the all workgroup members with availability for active assignment without hotline
	@isTest
	static void testGetActiveCaseAssignmentWorkgroupMembersNoHotline(){ 
		Test.starttest();
		// Delete the hotline 
		Id hotlineId = [SELECT Id FROM CH_Workgroup_Member__c WHERE CH_Role__c = 'Hotline' LIMIT 1].Id;
		Database.delete(hotlineId);
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Major', 'Yes', CH_CA_Service_TEST.NSC, false);
		Insert newCase;
		Test.stoptest();
		CH_CA_Service getNoHotlineService = new CH_CA_Service(newCase.id);
		List<CH_CA_DTO.WorkgroupMemberDTO> getNoHotlineWorkgroupMembers = getNoHotlineService.getCaseAssignmentWorkgroupMembers();
		System.assert(getNoHotlineWorkgroupMembers.size() == 3,sampleexpt + getNoHotlineWorkgroupMembers.size());
		
	}
	
	// Get the all workgroup members for passive assignment 
	@isTest
	static void testGetPassiveCaseAssignmentWorkgroupMembers(){ 
		Test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_Service_TEST.NSC, false);
		Insert newCase;   
		Test.Stoptest();
		CH_CA_Service getPassiveService = new CH_CA_Service(newCase.id);
		List<CH_CA_DTO.WorkgroupMemberDTO> getPassiveWorkgroupMembers = getPassiveService.getCaseAssignmentWorkgroupMembers();
		System.assert(getPassiveWorkgroupMembers.size() == 3,sampleexpt + getPassiveWorkgroupMembers.size());
		
	}
	
	// Get the all workgroup members for the case 
	@isTest
	static void testGetCaseTeamInitialLoadWorkgroupMembers(){ 
		Test.Starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_Service_TEST.NSC, false);
		Insert newCase;  
		Test.stoptest();
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = new CH_CA_DTO.SearchCriteriaDTO();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembers = service.getCaseTeamInitialLoadWorkgroupMembers(searchCriteriaDTO);
		System.assert(workgroupMembers.size() == 6,sampleexpt1 + workgroupMembers.size());
	}
	
	// Get the all workgroup members based on search criteria
	@isTest
	static void testGetCaseTeamSearchWorkgroupMembers(){ 
		Test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_Service_TEST.NSC, false);
		Insert newCase;  
		Test.stoptest();
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = new CH_CA_DTO.SearchCriteriaDTO();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembers = service.getCaseTeamSearchWorkgroupMembers(searchCriteriaDTO);
		System.assert(workgroupMembers.size() == 6,sampleexpt1 + workgroupMembers.size());
		
	}
	
	// Get the all workgroup members based on search criteria
	@isTest
	static void testGetCaseTeamSearchWorkgroupMembersForScheduleTrue(){ 
		
		CH_Settings__c settingForROTASchedule = new CH_Settings__c ();
		settingForROTASchedule.Name = 'Switch Between ROTA and Schedule';
		settingForROTASchedule.Description__c = 'This setting determines whether we need to get workgroup members from ROTA or Schedule.';
		settingForROTASchedule.SettingValue__c = 'CH_CA_WorkgroupMemberSchedule';
		if ([SELECT Id FROM CH_Settings__c WHERE Name = 'Switch Between ROTA and Schedule'].size() == 0){
			insert settingForROTASchedule;
		}
		test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_Service_TEST.NSC, false);
		Insert newCase; 
		Test.stoptest();
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = new CH_CA_DTO.SearchCriteriaDTO();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembers = service.getCaseTeamSearchWorkgroupMembers(searchCriteriaDTO);
		System.assert(workgroupMembers.size() == 6,sampleexpt1 + workgroupMembers.size());
	}
	
	// Get the case details
	@isTest
	static void testGetCaseDetails(){ 
		Test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_Service_TEST.NSC, false);
		Insert newCase; 
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = service.getCaseDetails();
		System.assert(searchCriteriaDTO.severity == 'Minor', sampleexpt2 + searchCriteriaDTO.severity);
		System.assert(searchCriteriaDTO.outage == 'No', sampleexpt3 + searchCriteriaDTO.outage);
		test.stoptest();
		
	}
	
	// Get the case details
	@isTest
	static void testGetCaseDetailsForAssignedStatus(){ 
		Test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_Service_TEST.NSC, false);
		newCase.Status = 'Assigned';
		Insert newCase;  
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = service.getCaseDetails();
		System.assert(searchCriteriaDTO.severity == 'Minor', sampleexpt2 + searchCriteriaDTO.severity);
		System.assert(searchCriteriaDTO.outage == 'No', sampleexpt3 + searchCriteriaDTO.outage);
		Test.stoptest();
	}
	
	@isTest
	static void testGetCaseDetailsForAssignedStatusProblemRecType(){ 
		Test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_Problem', false);
		newCase.Status = 'Assigned';
		Insert newCase;   
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = service.getCaseDetails();
		System.assert(searchCriteriaDTO.severity == 'Minor', sampleexpt2 + searchCriteriaDTO.severity);
		System.assert(searchCriteriaDTO.outage == 'No', sampleexpt3 + searchCriteriaDTO.outage);
		Test.stoptest();
	}
	
	@isTest
	static void testGetCaseDetailsForProblemRecType(){ 
		Test.Starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_Problem', false);
		Insert newCase;  
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = service.getCaseDetails();
		System.assert(searchCriteriaDTO.severity == 'Minor', sampleexpt2 + searchCriteriaDTO.severity);
		System.assert(searchCriteriaDTO.outage == 'No', sampleexpt3 + searchCriteriaDTO.outage);
		Test.stoptest();
	}
	
	
	// Get the all workgroup members  
	@isTest
	static void testGetAllCaseAssignmentWorkgroupMembers(){ 
		Test.Starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_Service_TEST.NSC, false);
		Insert newCase; 
		Test.stoptest();
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = new CH_CA_DTO.SearchCriteriaDTO();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembers = service.getAllCaseAssignmentWorkgroupMembers();
		System.assert(workgroupMembers.size() == 7,'Expected 7. Actual ' + workgroupMembers.size());
		
	}
	
	// Get the all workgroup members  
	@isTest
	static void testGetPassiveCaseAssignmentWorkgroupMembers2(){ 
		Test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_Service_TEST.NSC, false);
		Insert newCase;   
		Test.stoptest();
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembers = service.getPassiveCaseAssignmentWorkgroupMembers();
		System.assert(workgroupMembers.size() == 3,sampleexpt + workgroupMembers.size());
		
	}
	@istest
	static void validateCaseTeamMemberForLoginUser (){
		try{
			Test.startTest();	   
			Id loginUserID =Userinfo.getUserId();  
			Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_Service_TEST.NSC, false);
			insert testCase;
			Test.stopTest();
			CH_CA_Service service = new CH_CA_Service(testCase.Id);
			boolean returnMsg =service.validateInsertMember(loginUserID);
			System.assert(returnMsg != null,'  , Exception message - ' + returnMsg);
			
		}catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	
	@istest
	static void validateCaseTeamMemberOtherUser (){
		try{
			Test.startTest();
			boolean returnMsg=false;
			Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_Service_TEST.NSC, false);
			insert testCase;   
			Test.stopTest();
			CH_CA_Service service = new CH_CA_Service(testCase.Id);
			Profile systemAdministratorProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
			String systemAdministratorEmail = 'naip' + DateTime.now().getTime() + '@test.com';
			User userDtls=  CH_UTIL_TEST.getUser(systemAdministratorEmail, systemAdministratorEmail, 'naipuser', systemAdministratorProfile);
			returnMsg =service.validateInsertMember(userDtls.Id); 
			System.assert(returnMsg != null,'  , Exception message - ' + returnMsg);
			
		}catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	@istest
	static void getWorkgroupMembersOnInitialLoadTest (){
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Major', 'Yes', CH_CA_Service_TEST.NSC, false);
		test.startTest();	   
		CH_Workgroup__c testWorkGroup = new CH_Workgroup__c(CH_End_of_Business_Hours_Threshold__c = 60,
															CH_Level_Of_Support__c = SWS_Constants.LOSINITIALSUPPORT,
															CH_Start_of_Business_Hours_Threshold__c = 60,
															CH_Type__c = 'Engineer',
															Name = 'TestWorkgroup');
		insert testWorkGroup;
		CH_Workgroup_Rule__c testWorkGroupRule = new CH_Workgroup_Rule__c(Name = 'TestRule',
																		  CH_Workgroup__c = testWorkGroup.Id,
																		  CH_Severity__c = 'Minor',
																		  CH_Outage__c = 'No',
																		  CH_OrderNumber__c = 1);
		insert testWorkGroupRule;
		List<CH_Workgroup_Rule__c> wgList = new List<CH_Workgroup_Rule__c>();
		wgList.add(testWorkGroupRule);	  
		Insert newCase;
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		List<CH_CA_DTO.WorkgroupMemberDTO> wgDTO = service.getWorkgroupMembersOnInitialLoad(wgList);
		service.checkWGMembersSecurityDesktop(wgDTO);
		test.stopTest();
	}
	@istest
	static void getWorkgroupInstructionsTest(){
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Critical', 'Yes', CH_CA_Service_TEST.NSC, false);
		test.startTest();	   
		insert newCase;
		Id recordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByDeveloperName().get('CH_CA_Workgroup').getRecordTypeId();
		CH_Workgroup__c testWorkGroup = new CH_Workgroup__c(CH_End_of_Business_Hours_Threshold__c = 60,
															CH_Level_Of_Support__c = SWS_Constants.LOSINITIALSUPPORT,
															CH_Start_of_Business_Hours_Threshold__c = 60,
															CH_Type__c = 'Engineer',
															Name = 'TestWorkgroup',RecordTypeId= recordTypeId );
		
		testWorkGroup.RecordTypeId=recordTypeId;
		insert testWorkGroup;
		CH_WorkgroupInstructions__c cwi = new CH_WorkgroupInstructions__c(CH_Workgroup__c = testWorkGroup.Id,
																		  CH_AssignmentType__c='Case Team',
																		  CH_Active__c=TRUE);
		
		insert cwi;
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = new CH_CA_DTO.SearchCriteriaDTO();
		searchCriteriaDTO.severity = 'Critical';
		searchCriteriaDTO.outage = 'Yes';
		searchCriteriaDTO.levelOfSupports.add(SWS_Constants.LOSINITIALSUPPORT);
		searchCriteriaDTO.workgroupTypes.add('Engineer');
		CH_WorkgroupInstructions__c wgDTO = service.getWorkgroupInstructions(searchCriteriaDTO,testWorkGroup.Id,newCase.Id,'Case Team');
		System.assert(wgDTO.CH_Active__c == True,'Actual True Expected ' + wgDTO.CH_Active__c);
		CH_WorkgroupInstructions__c wgPassiveDTO = service.getWorkgroupInstructions(searchCriteriaDTO,testWorkGroup.Id,newCase.Id,'reAssignment');
		System.assert(wgPassiveDTO.CH_Active__c == False,'Actual False Expected ' + wgPassiveDTO.CH_Active__c);
		CH_Workgroup__c cwg = service.getWorkgroupName(searchCriteriaDTO);
		System.assert(cwg.Name == 'TEST','Actual TEST Expected ' + cwg.Name);
		Test.stopTest();
	}  
	@istest
	static void assignUserTest(){
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Critical', 'Yes', CH_CA_Service_TEST.NSC, false);
		User chUser;
		List<User> users = [SELECT Id, Alias FROM User WHERE Alias in ('TSTNP1','TSTNP2')];
		for (User tempUser : users){
			if (tempUser.Alias == 'TSTNP1'){
				chUser = tempUser;
			}
		} 
		CH_Workgroup__c workgroup = new CH_Workgroup__c();
		workgroup.name = 'TEST';
		workgroup.CH_Type__c = 'Engineer;Smart Tier 1';
		test.startTest();
		insert workgroup;
		CH_Workgroup_Member__c member1 = new CH_Workgroup_Member__c ();
		member1.CH_User__c = chUser.id;
		member1.CH_Role__c = 'Engineer'; 
		member1.CH_Workgroup__c = workgroup.Id;
		member1.CH_Workgroup_Member_Type__c = 'User';
		insert member1;
		Map<id,CH_Workgroup_Member__c> caseIdWGMap = new Map<id,CH_Workgroup_Member__c>();	  
		insert newCase;
		caseIdWGMap.put(newCase.Id, member1);
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		service.assignUser(caseIdWGMap);
		test.stopTest();
	}
	
	// Get the all workgroup members  
	@isTest
	static void testgetPortalOrS2SCaseAssignmentWorkgroupMembers(){ 
		Test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_Service_TEST.NSC, false);
		Insert newCase;   
		Test.stoptest();
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		CH_Workgroup_Member__c workgroupMembers = service.getPortalOrS2SCaseAssignmentWorkgroupMembers();
		System.assert(workgroupMembers.Name == 'MN_GWC_R_All-Products','Actual TEST Expected ' + workgroupMembers.Name);
		
	}
	
}