@isTest 
private class CH_ExternalInterfaceWebServiceTest { 
	public static final string testStrng1='@test.com';
	public static final string rndInterfaceStr1='Pronto/Jira Interface';
	public static final string rndInboundStr='R&D Inbound {0}';
	public static final string inforeqstStr='Information Request from Pronto';
	public static final string inforeqstStr1='Information Request';
	public static final string correctionplanStr='Correction Plan';
	public static final string inforeqstupdate='Information Update';
	public static final string updatefromndStr='Update from R&D';
	public static final string testprontoId1='test pronto id1';
	public static final string testsubject1='test subject';
	public static final string testdescription1='test description';
	public static final string testinfodesc2='test create-informationrequest description2';
	public static final string inforesponsestr1='Information Response';
	public static final string rndInboundStr2='R&D Inbound {0} {1}';
	public static final string updateanalysisStr1='update-analysis';
	public static final string statusString1='In Progress';
	public static final string jiraStrng1='Create new JIRA';
	public static final string sampleRnDStr ='Transfer to R&D';
	public static final string jiraBridgeStr1='jira-bridge';
	public static final string testJiraId='test jira id';
	public static final string testprobNumber='test problem number';
	public static final string test1ProntoId1='pronto test id1';
	public static final string testProntoId2='pronto test id2';
	public static final string beforeUpdateStr='before update';
	public static final string prontostring1='PRONTO';
	public static final string sampleaStrng1='test';
	public static final string testsampledescr1='testDescription';
	public static final string testrlseStr1='test release';
	  
	@testSetup
	static void setup() {
		insert new CH_NAIP_Integration_Settings__c(SetupOwnerId = UserInfo.getOrganizationId(), DefaultCaseOrigin__c = 'S2S', DefaultCaseRecordTypeDeveloperName__c = 'CH_NokiaStandardCase');
		
		CH_UTIL_TEST.setupCase();
	}
	
	private static Case createTestCase() {
		CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
		CH_ExternalInterfaceUTIL.runUpdateFromExternalInterface = true;
		
		Case testProblem = CH_UTIL_TEST.getProblem();
		insert testProblem;  
		
		return testProblem;
	}
	
	private static Case createS2STestCase() {
		CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
		
		return CH_UTIL_TEST.getS2SCase();
	}
	
	private static User insertCaseSetup() {
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert CH_UTIL_TEST.createInterfaceMapping(SWS_Constants.ORANGEIRMA, '12345', '12346', '12348', '12350', '12352', '12354');
			insert new CH_Integration_Profiles__c(Name = 'Integration API Only Profile');
		}
		
		Profile integrationProfile = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		String integrationUserEmail = 'naip' + DateTime.now().getTime() + testStrng1;
		User integrationUser = getIntegrationUser(integrationUserEmail, integrationUserEmail, 'naipuser', integrationProfile);
		insert integrationUser;
		
		List<Group> testGWCGroups = [SELECT Id, Name FROM Group WHERE Name = 'GWC' and Type = 'Queue'];
		System.assertEquals(testGWCGroups.size(), 1);
		Group testGroup = new Group(Name = 'Test Group', Type ='Regular', DeveloperName = 'TestGroup');
		insert testGroup;
		
		List<GroupMember> groupMembers = new List<GroupMember>();
		groupMembers.add(new GroupMember(GroupId = testGroup.Id, UserOrGroupId = integrationUser.Id));
		groupMembers.add(new GroupMember(GroupId = testGWCGroups[0].Id, UserOrGroupId = integrationUser.Id));
		
		return integrationUser;
	}
	
	private static User getIntegrationUser(String integrationUserEmail, String integrationUserName, String integrationUserAlias, Profile integrationProfile) {
		User integrationUser = new User(Alias = integrationUserAlias, 
	Email = integrationUserEmail, 
	ProfileId = integrationProfile.Id, 
	UserName = integrationUserName, 
	EmailEncodingKey = 'UTF-8', 
	LastName = 'NaipUser', 
	LanguageLocaleKey = 'en_US', 
	LocaleSidKey = 'en_US', 
	TimeZoneSidKey = 'America/Los_Angeles');
		return integrationUser;
	}
	
	private static CH_Problem_RnD_Reference__c getRndInteraction(String status, String rndType, String subject, String direction, String rndInterface, String referenceId, Id relatedRecordId) {
		CH_Problem_RnD_Reference__c rndInteraction = new CH_Problem_RnD_Reference__c(CH_RnD_Status__c = status, 
	CH_RnD_Type__c = rndType,
	CH_RnD_Direction__c = direction,
	CH_RnD_Subject__c = subject,
	CH_RnD_Interface__c = rndInterface,
	CH_RnD_Reference__c = referenceId,
	CH_Related_Record__c = relatedRecordId);
		return rndInteraction;
	}
	
	private static CH_ExternalInterfaceWebService.CaseObject getUpsertCasesRequest() {
		CH_ExternalInterfaceWebService.CaseObject requestObject = new CH_ExternalInterfaceWebService.CaseObject();
		requestObject.chActionExternalSystem = 'create-case';
		requestObject.chCaseOriginSystem = SWS_Constants.ORANGEIRMA;
		requestObject.chCustomerDescription = 'WBC';
		requestObject.email2 = 'test44@email.com';
		requestObject.chExternalSystemAccount = '12345';
		requestObject.networkElementID = 'Net Element:DE-98134737';
		requestObject.chOutage = 'No';
		requestObject.referenceNumber = 'WBC3';
		requestObject.secFirstName = sampleaStrng1;
		requestObject.secLastName = sampleaStrng1;
		requestObject.chServiceType = 'Internal Support';
		requestObject.severity = 'Minor';
		requestObject.chStage = 'Register';
		requestObject.subject = 'WBC';
		requestObject.typeVal = 'Incident';
		return requestObject;
	}
	
	private static void validateS2SLog(Interface_Log__c log, String logName, String logOperation) {
		System.assertEquals(log.Status__c, 'Failure');
		System.assertEquals(log.Interface_Type__c, 'Customer S2S');
		System.assertEquals(log.Message_Type__c, 'Inbound');
		System.assertEquals(log.Operation_Type__c, logOperation);
		System.assert(!String.isEmpty(log.Comment__c));
		System.assert(!String.isEmpty(log.Interface_Request_Sent__c));
		System.assertEquals(log.Name, logName);
	}
	
	private static void validateRndValidationLogs(Integer logCount, String logName, CH_ExternalInterfaceWebService.RndRequest request, Map<Id, Interface_Log__c> processedLogs) {
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c WHERE Id NOT IN :processedLogs.keySet()];
		System.assertEquals(logs.size(), logCount);
		for (Interface_Log__c log : logs) {
			processedLogs.put(log.Id, log);
			validateRndLog(log, request.rndInteractionType, request.rndInteractionInterface, 'Failure', log.Comment__c, logName, rndInterfaceStr1);
		}   
	}
	
	private static void validateRndPcpGroupLog(String status, CH_ExternalInterfaceWebService.RndRequest request) {
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		Interface_Log__c log = logs[0];
		System.assertEquals(log.Status__c, status);
		if (log.Status__c == 'Failure') {
			validateRndLog(logs[0], request.rndInteractionType, request.rndInteractionInterface, 'Failure', logs[0].Comment__c, String.format(rndInboundStr, new List<Object> {request.rndInteractionType}), rndInterfaceStr1);
		} else {
			validateRndLog(logs[0], request.rndInteractionType, request.rndInteractionInterface, 'Success', NULL, String.format(rndInboundStr, new List<Object> {request.rndInteractionType}), rndInterfaceStr1);
		}
	}
	
	private static void validateRndLog(Interface_Log__c log, String interactionType, String interfaceName, String status, String comment, String name, String interfaceType) {
		System.assertEquals(log.Status__c, status);
		System.assertEquals(log.Comment__c, comment);
		System.assertEquals(log.Name, name);
		System.assertEquals(log.Message_Type__c, 'Inbound');
		if (log.Status__c == 'Failure') {
			System.assertEquals(log.Number_of_Records_Errored__c, 1);
			System.assertEquals(log.Number_of_Records_Success__c, 0);
			System.assert(!String.isEmpty(log.Comment__c));
		} else {
			System.assertEquals(log.Number_of_Records_Errored__c, 0);
			System.assertEquals(log.Number_of_Records_Success__c, 1);
			System.assert(String.isEmpty(log.Comment__c));
		}
		System.assertEquals(log.Number_of_Record_Processed__c, 1);
		System.assert(String.isNotEmpty(log.Interface_Request_Sent__c));
		System.assertEquals(log.Interface_Type__c, interfaceType);   
		System.assert(log.Interface_Request_Sent__c.contains('rndInteractionType=' + interactionType));
		System.assert(log.Interface_Request_Sent__c.contains('rndInteractionInterface=' + interfaceName));
	}
	
	@isTest
	private static void prontoProvideWorkaroundTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = 'provide-workaround';
		handleProntoRndRequestTest(testCase.Id, request, 'Workaround','Workaround');
		System.assert(request.isProvideWorkaround);
		Test.stopTest();
	}
	
	@isTest
	private static void prontoCreateInformationRequestTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = 'create-informationrequest';
		handleProntoRndRequestTest(testCase.Id, request, inforeqstStr1,'Information_Request');
		System.assert(request.isCreateInformationRequest);
		Test.stopTest();
	}
	
	@isTest
	private static void prontoCancelInformationRequestTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = 'cancel-informationrequest';
		handleProntoRndRequestTest(testCase.Id, request, 'Cancel Information Request','Inbound');
		System.assert(request.isCancelInformationRequest);
		Test.stopTest();
	}
	
	@isTest
	private static void prontoCreateCorrectionPlanTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = 'create-correctionplan';
		handleProntoRndRequestTest(testCase.Id, request, correctionplanStr,'Inbound');
		System.assert(request.isCreateCorrectionPlan);
		Test.stopTest();
	}
	
	@isTest
	private static void prontoCreateCorrectionReadyTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = 'create-correctionready';
		handleProntoRndRequestTest(testCase.Id, request, 'Correction Response','Correction');
		System.assert(request.isCreateCorrectionReady);
		Test.stopTest();
	}
	
	@isTest
	private static void prontoCancelCorrectionTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = 'cancel-correction';
		handleProntoRndRequestTest(testCase.Id, request, 'Correction Not Needed','Inbound');
		System.assert(request.isCancelCorrection);
		Test.stopTest();
	}
	
	@isTest
	private static void prontoCreateInformationUpdateTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = SWS_Constants.CREATEINFOUPDATE;
		request.rndInteractionDescription = 'test create-informationrequest description1';
		handleProntoRndRequestTest(testCase.Id, request, updatefromndStr,'Inbound');
		System.assert(request.isCreateInformationUpdate);
		CH_Problem_RnD_Reference__c createInformationUpdateRndInteraction = [SELECT Id, CH_RnD_Type__c FROM CH_Problem_RnD_Reference__c];
		System.assertEquals(createInformationUpdateRndInteraction.CH_RnD_Type__c, updatefromndStr);
		Map<Id, Interface_Log__c> logs = new Map<Id, Interface_Log__c>([SELECT Id FROM Interface_Log__c]);
		System.assertEquals(logs.size(), 3);
		
		CH_Problem_RnD_Reference__c createInformationRequestRndInteraction = getRndInteraction('Completed', inforeqstStr1, inforeqstStr1, 'inbound', prontostring1, testprontoId1, testCase.Id);
		createInformationRequestRndInteraction.CH_RnD_Description__c = 'test create-informationrequest description1';
		insert createInformationRequestRndInteraction;
		
		Profile integrationProfile = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		String integrationUserEmail = 'naip' + DateTime.now().getTime() + testStrng1;
		User integrationUser = getIntegrationUser(integrationUserEmail, integrationUserEmail, 'naipuser', integrationProfile);
		System.runAs(integrationUser) {
			request.rndInteractionInterface = prontostring1;
			request.rndInteractionReference = testprontoId1;
			request.rndInteractionSubject = testsubject1;
			request.rndInteractionDescription = testdescription1;
			request.rndInteractionType = SWS_Constants.CREATEINFOUPDATE;
			request.rndInteractionDescription = testinfodesc2;
			System.assert(request.isProntoInterface);
			System.assert(!request.isJiraInterface);
			System.assert(request.isCreateInformationUpdate);
			
			CH_ExternalInterfaceWebService.handleRndRequest(request);
			createInformationRequestRndInteraction = [SELECT Id, CH_RnD_Description__c FROM CH_Problem_RnD_Reference__c WHERE Id =: createInformationRequestRndInteraction.Id];
			System.assertEquals(createInformationRequestRndInteraction.CH_RnD_Description__c, testinfodesc2);
			
			CH_Problem_RnD_Reference__c createCreateInformationResponseRndInteraction = getRndInteraction('Completed', inforesponsestr1, inforesponsestr1, 'outbound', prontostring1, testprontoId1, testCase.Id);
			insert createCreateInformationResponseRndInteraction;
			
			request.rndInteractionDescription = 'test create-informationrequest description3';
			CH_ExternalInterfaceWebService.handleRndRequest(request);
			createInformationRequestRndInteraction = [SELECT Id, CH_RnD_Type__c, CH_RnD_Description__c FROM CH_Problem_RnD_Reference__c WHERE Id =: createInformationRequestRndInteraction.Id];
			System.assertEquals(createInformationRequestRndInteraction.CH_RnD_Description__c, testinfodesc2);
		}
		
		logs = new Map<Id, Interface_Log__c>([SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c WHERE Id NOT IN :logs.keySet()]);
		System.assertEquals(logs.size(), 2);
		for (Interface_Log__c successLog : logs.values()) {
			validateRndLog(successLog, request.rndInteractionType, request.rndInteractionInterface, 'Success', NULL, String.format(rndInboundStr2, new List<Object> {updatefromndStr, testCase.Id}), rndInterfaceStr1);
		}
		Test.stopTest();
	}
	
	@isTest
	private static void prontoUpdateAnalysisTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = updateanalysisStr1;
		handleProntoRndRequestTest(testCase.Id, request, inforeqstupdate, 'Inbound');
		System.assert(request.isUpdateAnalysis);
		Test.stopTest();
	}
	
	@isTest
	private static void prontoUpdateAnalysisEmptyContactEmailTest() {
		String integrationUserEmail = 'naip' + DateTime.now().getTime() + testStrng1;
		Case testCase = prontoUpdateAnalysisContactEmailTest(integrationUserEmail, NULL);
		
		System.assertEquals(testCase.CH_RnD_Contact_Email__c, NULL);
		System.assertEquals(testCase.CH_RnD_Contact__c, NULL);
	}
	
	@isTest
	private static void prontoUpdateAnalysisInvalidContactEmailTest() {
		String integrationUserEmail = 'naip' + DateTime.now().getTime() + testStrng1;
		String integrationUserInvalidEmail = 'naipinvalid' + DateTime.now().getTime() + testStrng1;
		Case testCase = prontoUpdateAnalysisContactEmailTest(integrationUserEmail, integrationUserInvalidEmail);
		
		System.assertEquals(testCase.CH_RnD_Contact_Email__c, integrationUserInvalidEmail);
		System.assertEquals(testCase.CH_RnD_Contact__c, NULL);
	}
	
	@isTest
	private static void prontoUpdateAnalysisSuccessContactEmailTest() {
		String integrationUserEmail = 'naip' + DateTime.now().getTime() + testStrng1;
		Case testCase = prontoUpdateAnalysisContactEmailTest(integrationUserEmail, integrationUserEmail);
		
		System.assertEquals(testCase.CH_RnD_Contact_Email__c, integrationUserEmail);
		User integrationUser = [SELECT Id FROM User WHERE Email =: integrationUserEmail];
		System.assertEquals(testCase.CH_RnD_Contact__c, integrationUser.Id);
	}
	
	@isTest
	private static void prontoUpdateAnalysisContactEmailDuplicateTest() {
		String integrationUserEmail = 'naip' + DateTime.now().getTime() + testStrng1;
		Case testCase = prontoUpdateAnalysisContactEmailTest(integrationUserEmail, integrationUserEmail, integrationUserEmail);
		
		System.assertEquals(testCase.CH_RnD_Contact_Email__c, integrationUserEmail);
		System.assertEquals(testCase.CH_RnD_Contact__c, NULL);
	}
	
	private static Case prontoUpdateAnalysisContactEmailTest(String integrationUserEmail, String contactEmail) {
		return prontoUpdateAnalysisContactEmailTest(integrationUserEmail, NULL, contactEmail);
	}
	
	private static Case prontoUpdateAnalysisContactEmailTest(String integrationUserEmail, String integrationUser2Email, String contactEmail) {
		Case testCase = createTestCase();
		
		Test.startTest();
		Profile integrationProfile = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = updateanalysisStr1;
		request.rndInteractionInterface = prontostring1;
		request.rndInteractionSubject = testsubject1;
		request.rndInteractionDescription = testdescription1;
		request.caseTargetRelease = testrlseStr1;
		request.caseTargetReleaseDate = Date.today();
		
		testCase = [SELECT Id, CaseNumber FROM Case WHERE Id =: testCase.Id];
		System.assert(String.isNotEmpty(testCase.CaseNumber));
		request.rndInteractionReference = testCase.CaseNumber;
		
		if (!String.isEmpty(integrationUser2Email)) {
			User integrationUser2 = getIntegrationUser(integrationUser2Email, sampleaStrng1 + integrationUser2Email, 'naip2', integrationProfile);
			insert integrationUser2;
		}
		
		User integrationUser1 = getIntegrationUser(integrationUserEmail, integrationUserEmail, 'naip1', integrationProfile);
		System.runAs(integrationUser1) {
			request.caseContactEmail = contactEmail;
			CH_ExternalInterfaceWebService.RndResponse response = CH_ExternalInterfaceWebService.handleRndRequest(request);
			System.assertEquals(response.rndInteractionErrorMessage, NULL);
			testCase = [SELECT Id, CH_RnD_Contact_Email__c, CH_RnD_Contact__c FROM Case WHERE Id =: testCase.Id];
		}
		
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		Interface_Log__c log = logs[0];
		validateRndLog(log, request.rndInteractionType, request.rndInteractionInterface, 'Success', NULL, String.format(rndInboundStr2, new List<Object> {inforeqstupdate, testCase.Id}), rndInterfaceStr1);
		Test.stopTest();
		
		return testCase;
	}
	
	@isTest
	private static void jiraUpdateAnalysisTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = updateanalysisStr1;
		handleJiraRndRequestTest(testCase.Id, request, inforeqstupdate,'Inbound');
		System.assert(request.isUpdateAnalysis);
		Test.stopTest();
	}
	
	@isTest
	private static void jiraAcknowledgeSuccessTest() {
		Case testCase = createTestCase();
		testCase = [SELECT Id, CaseNumber, CH_JIRA_ExternalStatus__c, CH_CRNumber__c, CH_R_D_Interface_Flag__c FROM Case WHERE Id =: testCase.Id];
		System.assertEquals(testCase.CH_R_D_Interface_Flag__c, false);
		System.assert(String.isEmpty(testCase.CH_CRNumber__c));
		
		CH_Problem_RnD_Reference__c createAnalysisRndInteraction = getRndInteraction(statusString1, sampleRnDStr, jiraStrng1, 'outbound', 'JIRA', NULL, testCase.Id);
		insert createAnalysisRndInteraction;
		
		Test.startTest();
		Profile integrationProfile = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		String integrationUserEmail = 'naip' + DateTime.now().getTime() + testStrng1;
		User integrationUser = getIntegrationUser(integrationUserEmail, integrationUserEmail, 'naipuser', integrationProfile);
		System.runAs(integrationUser) {
			CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
			request.rndInteractionInterface = jiraBridgeStr1;
			request.rndInteractionReference = testJiraId;
			request.rndInteractionSubject = testsubject1;
			request.rndInteractionDescription = testdescription1;
			request.rndInteractionType = 'acknowledge-success';
			request.caseJiraExternalStatus = 'test external status';
			System.assert(!request.isProntoInterface);
			System.assert(request.isJiraInterface);
			System.assert(request.isAcknowledgeSuccess);
			CH_ExternalInterfaceWebService.RndResponse response = CH_ExternalInterfaceWebService.handleRndRequest(request);
			System.assertEquals(response.rndInteractionErrorMessage, Label.CH_InboundRndRequest_NoProblemNumberValidation);
			System.assertEquals(response.rndInteractionStatus, NULL);
			System.assertEquals(response.rndInteractionInterface, request.rndInteractionInterface);
			testCase = [SELECT Id, CaseNumber, CH_JIRA_ExternalStatus__c, CH_CRNumber__c, CH_R_D_Interface_Flag__c FROM Case WHERE Id =: testCase.Id];
			System.assertEquals(testCase.CH_R_D_Interface_Flag__c, false);
			System.assert(String.isEmpty(testCase.CH_JIRA_ExternalStatus__c));
			System.assert(String.isEmpty(testCase.CH_CRNumber__c));
			
			request.rndInteractionOriginatingIncident = testprobNumber;
			response = CH_ExternalInterfaceWebService.handleRndRequest(request);
			System.assertEquals(response.rndInteractionErrorMessage, String.Format(Label.CH_InboundRndRequest_InvalidProblemNumberValidation, new List<Object> {request.rndInteractionOriginatingIncident}));
			System.assertEquals(response.rndInteractionStatus, NULL);
			System.assertEquals(response.rndInteractionInterface, request.rndInteractionInterface);
			testCase = [SELECT Id, CaseNumber, CH_JIRA_ExternalStatus__c, CH_CRNumber__c, CH_R_D_Interface_Flag__c FROM Case WHERE Id =: testCase.Id];
			System.assertEquals(testCase.CH_R_D_Interface_Flag__c, false);
			System.assert(String.isEmpty(testCase.CH_JIRA_ExternalStatus__c));
			System.assert(String.isEmpty(testCase.CH_CRNumber__c));
			List<CH_Problem_RnD_Reference__c> rndInteractions = [SELECT Id FROM CH_Problem_RnD_Reference__c];
			System.assertEquals(rndInteractions.size(), 1);
			System.assertEquals(rndInteractions[0].Id, createAnalysisRndInteraction.Id);
			
			Map<Id, Interface_Log__c> logs = new Map<Id, Interface_Log__c>([SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c]);
			System.assertEquals(logs.size(), 2);
			for (Interface_Log__c failureLog : logs.values()) {
	validateRndLog(failureLog, request.rndInteractionType, request.rndInteractionInterface, 'Failure', failureLog.Comment__c, String.format(rndInboundStr, new List<Object> {request.rndInteractionType}), rndInterfaceStr1);
			}
			
			request.rndInteractionOriginatingIncident = testCase.CaseNumber;
			response = CH_ExternalInterfaceWebService.handleRndRequest(request);
			System.assert(String.isEmpty(response.rndInteractionErrorMessage));
			System.assertEquals(response.rndInteractionStatus, 'Completed');
			System.assertEquals(response.rndInteractionInterface, request.rndInteractionInterface);
			testCase = [SELECT Id, CaseNumber, CH_JIRA_ExternalStatus__c, CH_CRNumber__c, CH_R_D_Interface_Flag__c FROM Case WHERE Id =: testCase.Id];
			System.assertEquals(testCase.CH_R_D_Interface_Flag__c, true);
			System.assertEquals(testCase.CH_JIRA_ExternalStatus__c, request.caseJiraExternalStatus);
			System.assertEquals(testCase.CH_CRNumber__c, request.rndInteractionReference);
			rndInteractions = [SELECT Id, CH_Completion_Date__c, RecordTypeId, CH_RnD_Status__c, CH_RnD_Interface__c, CH_RnD_Direction__c, CH_RnD_Type__c, CH_RnD_Subject__c, CH_RnD_Description__c, CH_RnD_Reference__c, CH_Related_Record__c FROM CH_Problem_RnD_Reference__c];
			System.assertEquals(rndInteractions.size(), 2);
			
			CH_Problem_RnD_Reference__c rndInteraction = NULL;
			for (CH_Problem_RnD_Reference__c newRdnInteraction : rndInteractions) {
	if (newRdnInteraction.Id != createAnalysisRndInteraction.Id) {
		rndInteraction = newRdnInteraction;
		break;
	}
			}
			System.assertEquals(rndInteraction.CH_RnD_Status__c, 'Completed');
			System.assertEquals(rndInteraction.CH_RnD_Interface__c, 'JIRA');
			System.assertEquals(rndInteraction.CH_RnD_Direction__c, 'inbound');
			System.assertEquals(rndInteraction.CH_RnD_Type__c, 'Acknowledgement');
			System.assertEquals(rndInteraction.CH_RnD_Subject__c, testsubject1);
			System.assertEquals(rndInteraction.CH_RnD_Description__c, request.rndInteractionDescription);
			System.assertEquals(rndInteraction.CH_RnD_Reference__c, request.rndInteractionReference);
			System.assertEquals(rndInteraction.CH_Related_Record__c, testCase.Id);
			System.assert(rndInteraction.CH_Completion_Date__c != NULL);
			RecordType rndInteractionRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Inbound' AND SobjectType = 'CH_Problem_RnD_Reference__c'];
			System.assertEquals(rndInteraction.RecordTypeId, rndInteractionRecordType.Id);
			
			response = CH_ExternalInterfaceWebService.handleRndRequest(request);
			System.assertEquals(response.rndInteractionErrorMessage, Label.CH_InboundRndRequest_NoInitialCreateAnalysisValidation);
			
			logs = new Map<Id, Interface_Log__c>([SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c WHERE Id NOT IN :logs.keySet()]);
			System.assertEquals(logs.size(), 2);
			List<Interface_Log__c> failureLogs = new List<Interface_Log__c>();
			List<Interface_Log__c> successLogs = new List<Interface_Log__c>();
			for (Interface_Log__c log : logs.values()) {
	if (log.Status__c == 'Success') {
		successLogs.add(log);
	} else {
		failureLogs.add(log);
	}
			}
			System.assertEquals(failureLogs.size(), 1);
			System.assertEquals(successLogs.size(), 1);
			validateRndLog(successLogs[0], request.rndInteractionType, request.rndInteractionInterface, 'Success', NULL, String.format(rndInboundStr2, new List<Object> {rndInteraction.CH_RnD_Type__c, testCase.Id}), rndInterfaceStr1);
			validateRndLog(failureLogs[0], request.rndInteractionType, request.rndInteractionInterface, 'Failure', failureLogs[0].Comment__c, String.format(rndInboundStr2, new List<Object> {request.rndInteractionType, testCase.Id}), rndInterfaceStr1);
		}
		Test.stopTest();
	}
	
	@isTest
	private static void handleRndRequestErrorHandlingTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = updateanalysisStr1;
		request.rndInteractionReference = 'External test Reference Id which has length more than 100 characters and cannot be saved in Salesforce.';
		request.rndInteractionInterface = jiraBridgeStr1;
		request.rndInteractionSubject = testsubject1;
		request.rndInteractionDescription = testdescription1;
		
		testCase = [SELECT Id, CaseNumber FROM Case WHERE Id =: testCase.Id];
		System.assert(String.isNotEmpty(testCase.CaseNumber));
		request.rndInteractionOriginatingIncident = testCase.CaseNumber;
		
		CH_ExternalInterfaceWebService.RndResponse response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		System.assert(!String.isEmpty(response.rndInteractionErrorMessage));
		System.assert(response.rndInteractionErrorMessage.contains(request.rndInteractionReference));
		System.assertEquals(response.rndInteractionStatus, NULL);
		System.assertEquals(response.rndInteractionInterface, request.rndInteractionInterface);
		
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		validateRndLog(logs[0], request.rndInteractionType, request.rndInteractionInterface, 'Failure', logs[0].Comment__c, String.format(rndInboundStr2, new List<Object> {request.rndInteractionType, testCase.Id}), rndInterfaceStr1);
		Test.stopTest();
	}
	
	@isTest
	private static void handleRndRequestErrorHandlingNotificationTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = updateanalysisStr1;
		request.rndInteractionReference = 'External test Reference Id which has length more than 100 characters and cannot be saved in Salesforce.';
		request.rndInteractionInterface = jiraBridgeStr1;
		request.rndInteractionSubject = testsubject1;
		request.rndInteractionDescription = testdescription1;
		
		testCase = [SELECT Id, CaseNumber FROM Case WHERE Id =: testCase.Id];
		System.assert(String.isNotEmpty(testCase.CaseNumber));
		request.rndInteractionOriginatingIncident = testCase.CaseNumber;
		
		CH_UserNotificationUTIL.runSendInterfaceKeyUserNotifications = true;
		CH_ExternalInterfaceWebService.RndResponse response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		
		CH_UTIL_TEST.createInterfaceKeyGroup('test jira interface key group', 'JIRA');
		Boolean hasError = false;
		try {
			response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		} catch(Exception e) {
			hasError = true;
		}
		System.assert(hasError);
		
		request.rndInteractionReference = testJiraId;
		response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		Test.stopTest();
	}
	
	@isTest
	private static void rndRequestValidationTest() {
		Case testCase = createTestCase();
		testCase = [SELECT Id, CaseNumber FROM Case WHERE Id =: testCase.Id];
		
		Test.startTest();
		Map<Id, Interface_Log__c> processedLogs = new Map<Id, Interface_Log__c>();
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		CH_ExternalInterfaceWebService.RndResponse response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		System.assertEquals(response.rndInteractionErrorMessage, Label.CH_InboundRndRequest_NoActionValidation);
		validateRndValidationLogs(1, String.format(rndInboundStr, new List<Object> {request.rndInteractionType}), request, processedLogs);
		
		request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = updateanalysisStr1;
		response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		System.assertEquals(response.rndInteractionErrorMessage, Label.CH_InboundRndRequest_NoInterfaceNameValidation);
		validateRndValidationLogs(1, String.format(rndInboundStr, new List<Object> {request.rndInteractionType}), request, processedLogs);
		
		request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = updateanalysisStr1;
		request.rndInteractionInterface = 'test interface name';
		response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		System.assertEquals(response.rndInteractionErrorMessage, String.Format(Label.CH_InboundRndRequest_InvalidInterfaceNameValidation, new List<String> {request.rndInteractionInterface}));
		validateRndValidationLogs(1, String.format(rndInboundStr, new List<Object> {request.rndInteractionType}), request, processedLogs);
		
		request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionInterface = prontostring1;
		request.rndInteractionType = updateanalysisStr1;
		response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		System.assertEquals(response.rndInteractionErrorMessage, Label.CH_InboundRndRequest_NoProblemNumberValidation);
		
		request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionInterface = prontostring1;
		request.rndInteractionType = updateanalysisStr1;
		request.rndInteractionReference = sampleaStrng1;
		response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		System.assertEquals(response.rndInteractionErrorMessage, String.Format(Label.CH_InboundRndRequest_InvalidProblemNumberValidation, new List<Object> {request.rndInteractionReference}));
		validateRndValidationLogs(2, String.format(rndInboundStr, new List<Object> {request.rndInteractionType}), request, processedLogs);
		
		request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionInterface = jiraBridgeStr1;
		request.rndInteractionType = 'test jira action';
		request.rndInteractionOriginatingIncident = testCase.CaseNumber;
		response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		System.assertEquals(response.rndInteractionErrorMessage, String.Format(Label.CH_InboundRndRequest_UnsupportedActionValidation, new List<String> {request.rndInteractionType, request.rndInteractionInterface}));
		validateRndValidationLogs(1, String.format(rndInboundStr2, new List<Object> {request.rndInteractionType, testCase.Id}), request, processedLogs);
		
		request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionInterface = prontostring1;
		request.rndInteractionType = 'test pronto action';
		request.rndInteractionOriginatingIncident = testCase.CaseNumber;
		response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		System.assertEquals(response.rndInteractionErrorMessage, String.Format(Label.CH_InboundRndRequest_UnsupportedActionValidation, new List<String> {request.rndInteractionType, request.rndInteractionInterface}));
		validateRndValidationLogs(1, String.format(rndInboundStr2, new List<Object> {request.rndInteractionType, testCase.Id}), request, processedLogs);
		
		System.assertEquals(processedLogs.size(), 7);
		Test.stopTest();
	}
	
	private static void handleProntoRndRequestTest(Id caseId, CH_ExternalInterfaceWebService.RndRequest request, String interactionType, String recordTypeName) {
		Profile integrationProfile = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		String integrationUserEmail = 'naip' + DateTime.now().getTime() + testStrng1;
		User integrationUser = getIntegrationUser(integrationUserEmail, integrationUserEmail, 'naipuser', integrationProfile);
		System.runAs(integrationUser) {
			request.rndInteractionInterface = prontostring1;
			if (!request.isUpdateAnalysis) {
	request.rndInteractionReference = 'test pronto id';
			}
			request.rndInteractionSubject = testsubject1;
			request.rndInteractionDescription = testdescription1;
			request.caseTargetRelease = testrlseStr1;
			request.caseTargetReleaseDate = Date.today();
			request.caseContactEmail = UserInfo.getUserEmail();
			System.assert(request.isProntoInterface);
			System.assert(!request.isJiraInterface);
			CH_ExternalInterfaceWebService.RndResponse response = CH_ExternalInterfaceWebService.handleRndRequest(request);
			System.assertEquals(response.rndInteractionErrorMessage, Label.CH_InboundRndRequest_NoProblemNumberValidation);
			System.assertEquals(response.rndInteractionStatus, NULL);
			System.assertEquals(response.rndInteractionInterface, request.rndInteractionInterface);
			
			if (request.isUpdateAnalysis) {
	request.rndInteractionReference = testprobNumber;
			} else {
	request.rndInteractionOriginatingIncident = testprobNumber;  
			}
			response = CH_ExternalInterfaceWebService.handleRndRequest(request);
			if (request.isUpdateAnalysis) {
	System.assertEquals(response.rndInteractionErrorMessage, String.Format(Label.CH_InboundRndRequest_InvalidProblemNumberValidation, new List<Object> {request.rndInteractionReference}));
			} else {
	System.assertEquals(response.rndInteractionErrorMessage, String.Format(Label.CH_InboundRndRequest_InvalidProblemNumberValidation, new List<Object> {request.rndInteractionOriginatingIncident}));
			}
			System.assertEquals(response.rndInteractionStatus, NULL);
			System.assertEquals(response.rndInteractionInterface, request.rndInteractionInterface);
			
			Case testCase = [SELECT Id, CaseNumber FROM Case WHERE Id =: caseId];
			System.assert(String.isNotEmpty(testCase.CaseNumber));
			if (request.isUpdateAnalysis) {
	request.rndInteractionReference = testCase.CaseNumber;
			} else {
	request.rndInteractionOriginatingIncident = testCase.CaseNumber;	
			}
			response = CH_ExternalInterfaceWebService.handleRndRequest(request);
			System.assert(String.isEmpty(response.rndInteractionErrorMessage));
			System.assertEquals(response.rndInteractionStatus, 'Completed');
			System.assertEquals(response.rndInteractionInterface, request.rndInteractionInterface);
			
			List<CH_Problem_RnD_Reference__c> rndInteractionsrec = [SELECT Id, CH_RnD_Error_Message__c, CH_Completion_Date__c, RecordTypeId, CH_RnD_Status__c, CH_RnD_Interface__c, CH_RnD_Direction__c, CH_RnD_Type__c, CH_RnD_Subject__c, CH_RnD_Description__c, CH_RnD_Reference__c, CH_Related_Record__c FROM CH_Problem_RnD_Reference__c];
			System.assertEquals(rndInteractionsrec.size(), 1);
			CH_Problem_RnD_Reference__c rndInteractionsingl = rndInteractionsrec[0];
			System.assertEquals(rndInteractionsingl.CH_RnD_Status__c, 'Completed');
			System.assertEquals(rndInteractionsingl.CH_RnD_Interface__c, prontostring1);
			System.assertEquals(rndInteractionsingl.CH_RnD_Direction__c, 'inbound');
			System.assertEquals(rndInteractionsingl.CH_RnD_Type__c, interactionType);
			System.assertEquals(rndInteractionsingl.CH_RnD_Subject__c, request.rndInteractionSubject);
			System.assertEquals(rndInteractionsingl.CH_RnD_Description__c, request.rndInteractionDescription);
			System.assertEquals(rndInteractionsingl.CH_RnD_Reference__c, request.rndInteractionReference);
			System.assertEquals(rndInteractionsingl.CH_Related_Record__c, testCase.Id);
			System.assert(rndInteractionsingl.CH_Completion_Date__c != NULL);
			RecordType rndInteractionRecordTypeq = [SELECT Id FROM RecordType WHERE DeveloperName =: recordTypeName AND SobjectType = 'CH_Problem_RnD_Reference__c'];
			System.assertEquals(rndInteractionsingl.RecordTypeId, rndInteractionRecordTypeq.Id);
			
			testCase = [SELECT Id, CaseNumber, CH_RnD_Contact__c, CH_RnD_Contact_Email__c, CH_Target_Release__c, CH_Target_Release_Date__c FROM Case WHERE Id =: caseId];
			
			if (request.isUpdateAnalysis) {
	System.assertEquals(testCase.CH_RnD_Contact_Email__c, request.caseContactEmail);
	System.assertEquals(testCase.CH_RnD_Contact_Email__c, integrationUserEmail);
	System.assertEquals(testCase.CH_RnD_Contact__c, UserInfo.getUserId());
			} else {
	System.assertEquals(testCase.CH_RnD_Contact_Email__c, NULL);
	System.assertEquals(testCase.CH_RnD_Contact__c, NULL);   
			}
			
			List<Interface_Log__c> logslst = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
			System.assertEquals(logslst.size(), 3);
			List<Interface_Log__c> failureLogslst = new List<Interface_Log__c>();
			List<Interface_Log__c> successLogslst = new List<Interface_Log__c>();
			for (Interface_Log__c log : logslst) {
	if (log.Status__c == 'Success') {
		successLogslst.add(log);
	} else {
		failureLogslst.add(log);
	}
			}
			System.assertEquals(failureLogslst.size(), 2);
			System.assertEquals(successLogslst.size(), 1);
			validateRndLog(successLogslst[0], request.rndInteractionType, request.rndInteractionInterface, 'Success', rndInteractionsingl.CH_RnD_Error_Message__c, String.format(rndInboundStr2, new List<Object> {rndInteractionsingl.CH_RnD_Type__c, testCase.Id}), rndInterfaceStr1);
			for (Interface_Log__c failureLog : failureLogslst) {
	validateRndLog(failureLog, request.rndInteractionType, request.rndInteractionInterface, 'Failure', failureLog.Comment__c, String.format(rndInboundStr, new List<Object> {request.rndInteractionType}), rndInterfaceStr1);
			}
		}
	}
	
	private static void handleJiraRndRequestTest(Id caseId, CH_ExternalInterfaceWebService.RndRequest request, String interactionType,String recordTypeName) {
		Profile integrationProfile = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		String integrationUserEmail = 'naip' + DateTime.now().getTime() + testStrng1;
		User integrationUser = getIntegrationUser(integrationUserEmail, integrationUserEmail, 'naipuser', integrationProfile);
		System.runAs(integrationUser) {
			request.rndInteractionInterface = jiraBridgeStr1;
			request.rndInteractionReference = testJiraId;
			request.rndInteractionSubject = testsubject1;
			request.rndInteractionDescription = testdescription1;
			System.assert(!request.isProntoInterface);
			System.assert(request.isJiraInterface);
			CH_ExternalInterfaceWebService.RndResponse response = CH_ExternalInterfaceWebService.handleRndRequest(request);
			System.assertEquals(response.rndInteractionErrorMessage, Label.CH_InboundRndRequest_NoProblemNumberValidation);
			System.assertEquals(response.rndInteractionStatus, NULL);
			System.assertEquals(response.rndInteractionInterface, request.rndInteractionInterface);
			
			request.rndInteractionOriginatingIncident = testprobNumber;
			response = CH_ExternalInterfaceWebService.handleRndRequest(request);
			System.assertEquals(response.rndInteractionErrorMessage, String.Format(Label.CH_InboundRndRequest_InvalidProblemNumberValidation, new List<Object> {request.rndInteractionOriginatingIncident}));
			System.assertEquals(response.rndInteractionStatus, NULL);
			System.assertEquals(response.rndInteractionInterface, request.rndInteractionInterface);
			
			Case testCase = [SELECT Id, CaseNumber FROM Case WHERE Id =: caseId];
			System.assert(String.isNotEmpty(testCase.CaseNumber));
			request.rndInteractionOriginatingIncident = testCase.CaseNumber;
			response = CH_ExternalInterfaceWebService.handleRndRequest(request);
			System.assert(String.isEmpty(response.rndInteractionErrorMessage));
			System.assertEquals(response.rndInteractionStatus, 'Completed');
			System.assertEquals(response.rndInteractionInterface, request.rndInteractionInterface);
			
			List<CH_Problem_RnD_Reference__c> rndInteractions = [SELECT Id, CH_Completion_Date__c, RecordTypeId, CH_RnD_Status__c, CH_RnD_Interface__c, CH_RnD_Direction__c, CH_RnD_Type__c, CH_RnD_Subject__c, CH_RnD_Description__c, CH_RnD_Reference__c, CH_Related_Record__c FROM CH_Problem_RnD_Reference__c];
			System.assertEquals(rndInteractions.size(), 1);
			CH_Problem_RnD_Reference__c rndInteraction = rndInteractions[0];
			System.assertEquals(rndInteraction.CH_RnD_Status__c, 'Completed');
			System.assertEquals(rndInteraction.CH_RnD_Interface__c, 'JIRA');
			System.assertEquals(rndInteraction.CH_RnD_Direction__c, 'inbound');
			System.assertEquals(rndInteraction.CH_RnD_Type__c, interactionType);
			System.assertEquals(rndInteraction.CH_RnD_Subject__c, request.rndInteractionSubject);
			System.assertEquals(rndInteraction.CH_RnD_Description__c, request.rndInteractionDescription);
			System.assertEquals(rndInteraction.CH_RnD_Reference__c, request.rndInteractionReference);
			System.assertEquals(rndInteraction.CH_Related_Record__c, testCase.Id);
			System.assert(rndInteraction.CH_Completion_Date__c != NULL);
			RecordType rndInteractionRecordType = [SELECT Id FROM RecordType WHERE DeveloperName =: recordTypeName AND SobjectType = 'CH_Problem_RnD_Reference__c'];
			System.assertEquals(rndInteraction.RecordTypeId, rndInteractionRecordType.Id);
			
			testCase = [SELECT Id, CH_JIRA_ExternalStatus__c, CaseNumber, CH_RnD_Contact__c, CH_RnD_Contact_Email__c, CH_Target_Release__c, CH_Target_Release_Date__c FROM Case WHERE Id =: caseId];
			System.assertEquals(testCase.CH_Target_Release__c, NULL);
			System.assertEquals(testCase.CH_Target_Release_Date__c, NULL);
			System.assertEquals(testCase.CH_RnD_Contact_Email__c, NULL);
			System.assertEquals(testCase.CH_RnD_Contact__c, NULL);
			System.assertEquals(testCase.CH_JIRA_ExternalStatus__c, request.caseJiraExternalStatus);
			
			List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
			System.assertEquals(logs.size(), 3);
			List<Interface_Log__c> failureLogs = new List<Interface_Log__c>();
			List<Interface_Log__c> successLogs = new List<Interface_Log__c>();
			for (Interface_Log__c log : logs) {
	if (log.Status__c == 'Success') {
		successLogs.add(log);
	} else {
		failureLogs.add(log);
	}
			}
			System.assertEquals(failureLogs.size(), 2);
			System.assertEquals(successLogs.size(), 1);
			validateRndLog(successLogs[0], request.rndInteractionType, request.rndInteractionInterface, 'Success', NULL, String.format(rndInboundStr2, new List<Object> {rndInteraction.CH_RnD_Type__c, testCase.Id}), rndInterfaceStr1);
			for (Interface_Log__c failureLog : failureLogs) {
	validateRndLog(failureLog, request.rndInteractionType, request.rndInteractionInterface, 'Failure', failureLog.Comment__c, String.format(rndInboundStr, new List<Object> {request.rndInteractionType}), rndInterfaceStr1);
			}
		}
	}
	
	@isTest
	private static void completionDateTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		
		CH_Problem_RnD_Reference__c openRndInteraction = getRndInteraction('Open', correctionplanStr, correctionplanStr, 'outbound', prontostring1, test1ProntoId1, testCase.Id);
		insert openRndInteraction;
		openRndInteraction = [SELECT Id, CH_Completion_Date__c, CH_RnD_Status__c FROM CH_Problem_RnD_Reference__c WHERE Id =: openRndInteraction.Id];
		System.assertEquals(openRndInteraction.CH_Completion_Date__c, NULL);
		System.assertEquals(openRndInteraction.CH_RnD_Status__c, 'Open');
		
		openRndInteraction.CH_RnD_Description__c = testdescription1;
		update openRndInteraction;
		openRndInteraction = [SELECT Id, CH_Completion_Date__c, CH_RnD_Status__c FROM CH_Problem_RnD_Reference__c WHERE Id =: openRndInteraction.Id];
		System.assertEquals(openRndInteraction.CH_Completion_Date__c, NULL);
		System.assertEquals(openRndInteraction.CH_RnD_Status__c, 'Open');
		
		openRndInteraction.CH_RnD_Status__c = 'Completed';
		update openRndInteraction;
		openRndInteraction = [SELECT Id, CH_Completion_Date__c, CH_RnD_Status__c FROM CH_Problem_RnD_Reference__c WHERE Id =: openRndInteraction.Id];
		System.assertNotEquals(openRndInteraction.CH_Completion_Date__c, NULL);
		System.assertEquals(openRndInteraction.CH_RnD_Status__c, 'Completed');
		
		CH_Problem_RnD_Reference__c completedRndInteraction = getRndInteraction('Completed', correctionplanStr, correctionplanStr, 'inbound', prontostring1, test1ProntoId1, testCase.Id);
		insert completedRndInteraction;
		completedRndInteraction = [SELECT Id, CH_Completion_Date__c, CH_RnD_Status__c FROM CH_Problem_RnD_Reference__c WHERE Id =: completedRndInteraction.Id];
		System.assertNotEquals(completedRndInteraction.CH_Completion_Date__c, NULL);
		System.assertEquals(completedRndInteraction.CH_RnD_Status__c, 'Completed');
		Test.stopTest();
	}
	
	@isTest
	private static void postFeedItemsForNewInboundRndInteractionsTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		Profile integrationProfile = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		String integrationUserEmail = 'naip' + DateTime.now().getTime() + testStrng1;
		User integrationUser = getIntegrationUser(integrationUserEmail, integrationUserEmail, 'naipuser', integrationProfile);
		System.runAs(integrationUser) {  
			List<CH_Problem_RnD_Reference__c> rndInteractions = new List<CH_Problem_RnD_Reference__c>();
			CH_Problem_RnD_Reference__c informationRequestRndInteraction = getRndInteraction('Completed', inforeqstStr1, inforeqstStr, 'inbound', prontostring1, test1ProntoId1, testCase.Id);
			rndInteractions.add(informationRequestRndInteraction);
			CH_Problem_RnD_Reference__c correctionPlanRndInteraction = getRndInteraction('Completed', correctionplanStr, correctionplanStr, 'inbound', prontostring1, testProntoId2, testCase.Id);
			rndInteractions.add(correctionPlanRndInteraction);
			CH_Problem_RnD_Reference__c informationUpdateRndInteraction = getRndInteraction('Completed', updatefromndStr, inforeqstupdate, 'inbound', prontostring1, testProntoId2, testCase.Id);
			rndInteractions.add(informationUpdateRndInteraction);
			CH_Problem_RnD_Reference__c informationUpdateOutboundRndInteraction = getRndInteraction('Completed', inforeqstupdate, inforeqstupdate, 'outbound', prontostring1, testProntoId2, testCase.Id);
			rndInteractions.add(informationUpdateOutboundRndInteraction);
			insert rndInteractions;
			
			List<ConnectApi.FeedItemInput> feedItems = CH_RndInteractionTriggerHandler.postFeedItemsForNewInboundRndInteractions(rndInteractions);
			System.assertEquals(feedItems.size(), 3);
			for (ConnectApi.FeedItemInput feedItem : feedItems) {
	System.assertEquals(feedItem.body.messageSegments.size(), 7);
			}
			
			postFeedItemForNewInboundRndInteractionTest(feedItems[0], informationRequestRndInteraction);
			postFeedItemForNewInboundRndInteractionTest(feedItems[1], correctionPlanRndInteraction);
			postFeedItemForNewInboundRndInteractionTest(feedItems[2], informationUpdateRndInteraction);
		}
		Test.stopTest();
	}
	
	private static void postFeedItemForNewInboundRndInteractionTest(ConnectApi.FeedItemInput feedItem, CH_Problem_RnD_Reference__c rndInteraction) {
		ConnectApi.TextSegmentInput inboundRndInteractionTypeSegment  = (ConnectApi.TextSegmentInput) feedItem.body.messageSegments[0];
		System.assertEquals(inboundRndInteractionTypeSegment.text, 'R&D Interaction Type: ' + rndInteraction.CH_RnD_Type__c);
		
		ConnectApi.TextSegmentInput inboundRndInteractionSubjectSegment = (ConnectApi.TextSegmentInput) feedItem.body.messageSegments[1];
		System.assertEquals(inboundRndInteractionSubjectSegment.text, '\nR&D Interaction Subject: ' + rndInteraction.CH_RnD_Subject__c);
		
		ConnectApi.TextSegmentInput inboundRndInteractionSegment = (ConnectApi.TextSegmentInput) feedItem.body.messageSegments[2];
		System.assertEquals(inboundRndInteractionSegment.text, '\nInbound R&D Interaction: ');
		
		ConnectApi.EntityLinkSegmentInput inboundRndInteractionLinkSegment = (ConnectApi.EntityLinkSegmentInput) feedItem.body.messageSegments[3];
		System.assertEquals(inboundRndInteractionLinkSegment.entityId, rndInteraction.Id);
		
		ConnectApi.TextSegmentInput reletedProblemSegment = (ConnectApi.TextSegmentInput) feedItem.body.messageSegments[4];
		System.assertEquals(reletedProblemSegment.text, '\nRelated Problem: ');
		
		ConnectApi.EntityLinkSegmentInput reletedProblemLinkSegment = (ConnectApi.EntityLinkSegmentInput) feedItem.body.messageSegments[5];
		System.assertEquals(reletedProblemLinkSegment.entityId, rndInteraction.CH_Related_Record__c);
		
		ConnectApi.TextSegmentInput inboundRndInteractionReferenceSegment = (ConnectApi.TextSegmentInput) feedItem.body.messageSegments[6];
		System.assertEquals(inboundRndInteractionReferenceSegment.text, '\nR&D Reference: ' + rndInteraction.CH_RnD_Reference__c);
	}
	
	@isTest
	private static void preventInboundRndInteractionDeleteEditTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		CH_Problem_RnD_Reference__c informationRequestRndInteraction = getRndInteraction('Completed', inforeqstStr1, inforeqstStr, 'inbound', prontostring1, test1ProntoId1, testCase.Id);
		insert informationRequestRndInteraction;
		informationRequestRndInteraction = [SELECT Id, Name FROM CH_Problem_RnD_Reference__c WHERE Id =: informationRequestRndInteraction.Id];
		
		Boolean hasError = false;
		try {
			informationRequestRndInteraction.CH_RnD_Subject__c = sampleaStrng1;
			update informationRequestRndInteraction;
		} catch(Exception e) {
			System.assert(e.getMessage().contains(String.format(Label.CH_InboundRndInteraction_PreventUpdateValidation, new List<Object>{informationRequestRndInteraction.Name})));
			hasError = true;
		}
		System.assert(hasError);
		
		hasError = false;
		try {
			delete informationRequestRndInteraction;
		} catch(Exception e) {
			System.assert(e.getMessage().contains(String.format(Label.CH_InboundRndInteraction_PreventDeletionValidation, new List<Object>{informationRequestRndInteraction.Name})));
			hasError = true;
		}
		System.assert(hasError);
		
		Test.stopTest();
	}
	@isTest
	private static void insertCaseFailureTest() {
		CH_ExternalInterfaceUTIL.runUpdateFromExternalInterface = true;
		User integrationUser = insertCaseSetup();
		
		Test.startTest();
		System.runAs(integrationUser) {
			CH_ExternalInterfaceWebService.CaseObject requestObject = getUpsertCasesRequest();
			CollaborationGroup interfaceKeyUserGroup = new CollaborationGroup(Name = 'test interface key user group', CollaborationType = 'Public');
			insert interfaceKeyUserGroup;
			CH_InterfaceKeyGroup__c interfaceKeyUserGroupSettings = new CH_InterfaceKeyGroup__c(Name = sampleaStrng1, ExternalSystem__c = sampleaStrng1, CollaborationGroupName__c = interfaceKeyUserGroup.Name);
			insert interfaceKeyUserGroupSettings;
			requestObject.chCaseOriginSystem = interfaceKeyUserGroupSettings.ExternalSystem__c;
			List<CH_ExternalInterfaceWebService.CaseObjectResponse> failedResponse = CH_ExternalInterfaceWebService.upsertCases(new List<CH_ExternalInterfaceWebService.CaseObject>{requestObject});
			System.assert(!String.isEmpty(failedResponse[0].errorMessage));
			System.assert(String.isEmpty(failedResponse[0].caseNumber));
			List<Case> cases = [SELECT Id FROM Case];
			System.assert(cases.isEmpty());
			List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Interface_Request_Sent__c, Status__c, Message_Type__c, Operation_Type__c, Interface_Type__c FROM Interface_Log__c];
			System.assertEquals(logs.size(), 1);
			Interface_Log__c log = logs[0];
			validateS2SLog(log, String.format('Inbound {0} Case', new List<Object> {requestObject.chCaseOriginSystem}), 'Insert');
			
			Boolean hasError = false;
			CH_UserNotificationUTIL.runSendS2SFailureNotification = true;
			CH_UserNotificationUTIL.runSendInterfaceKeyUserNotifications = true;
			try {
	CH_ExternalInterfaceWebService.upsertCases(new List<CH_ExternalInterfaceWebService.CaseObject>{requestObject});
			} catch(Exception e) {
	hasError = true;
			}
			System.assert(hasError);
			
			CH_UserNotificationUTIL.runSendS2SFailureNotification = true;
			CH_UserNotificationUTIL.runSendInterfaceKeyUserNotifications = false;
			CH_ExternalInterfaceWebService.upsertCases(new List<CH_ExternalInterfaceWebService.CaseObject>{requestObject});
		}
		Test.stopTest();
	}
	
	@isTest
	private static void s2sRetrieveCaseTest() {
		Case testS2SCase = createS2STestCase();
		insert testS2SCase;
		
		Test.startTest();
		Profile integrationProfile = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		String integrationUserEmail = 'naip' + DateTime.now().getTime() + testStrng1;
		User integrationUser = getIntegrationUser(integrationUserEmail, integrationUserEmail, 'naipuser', integrationProfile);
		System.runAs(integrationUser) {
			testS2SCase = [SELECT Id, CaseNumber, Origin, CH_CaseOriginSystem__c FROM Case WHERE Id =: testS2SCase.Id];
			CH_ExternalInterfaceWebService.CaseObject request = new CH_ExternalInterfaceWebService.CaseObject();
			request.chActionExternalSystem = 'retrieve-case';
			request.chCaseOriginSystem = SWS_Constants.ORANGEIRMA;
			request.referenceNumber = testS2SCase.CaseNumber;
			
			List<CH_ExternalInterfaceWebService.CaseObjectResponse> responses = CH_ExternalInterfaceWebService.upsertCases(new List<CH_ExternalInterfaceWebService.CaseObject>{request});
			System.assertEquals(responses.size(), 1);
			System.assert(String.isEmpty(responses[0].errorMessage));
			System.assertEquals(responses[0].caseStatus, 'Created');
			List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
			
			request.referenceNumber = sampleaStrng1;
			responses = CH_ExternalInterfaceWebService.upsertCases(new List<CH_ExternalInterfaceWebService.CaseObject>{request});
			System.assertEquals(responses.size(), 1);
			System.assertEquals(responses[0].errorMessage,  String.format(Label.CH_InboundS2SRequest_InvalidCaseNumberValidation, new List<Object>{request.referenceNumber}));
			logs = [SELECT Id, Name, Comment__c, Interface_Request_Sent__c, Status__c, Message_Type__c, Operation_Type__c, Interface_Type__c FROM Interface_Log__c];
			
			Interface_Log__c log = logs[0];
			validateS2SLog(log, String.format('Inbound {0} Case({1})', new List<Object> {request.chCaseOriginSystem, NULL}), NULL);
		}
		Test.stopTest();
	}
	
	@isTest
	private static void s2sCreateInformationUpdateTest() {
		s2sCaseCommentRequestTest(SWS_Constants.CREATEINFOUPDATE, inforeqstupdate);
	}
	
	@isTest
	private static void s2sCancelCaseTest() {
		s2sCaseCommentRequestTest('cancel-case', 'Cancel Case');
	}
	
	@isTest
	private static void s2sAcceptWorkaroundTest() {
		s2sCaseCommentRequestTest('accept-workaround', 'Accept Workaround');
	}
	
	@isTest
	private static void s2sRejectWorkaroundTest() {
		s2sCaseCommentRequestTest('reject-workaround', 'Reject Workaround');
	}
	
	@isTest
	private static void s2sAcceptSolutionTest() {
		s2sCaseCommentRequestTest('accept-solution', 'Solution Accepted');
	}
	
	@isTest
	private static void s2sRejectSolutionTest() {
		s2sCaseCommentRequestTest('reject-solution', 'Solution Rejected');
	}
	
	@isTest
	private static void s2sCreateInformationResponseTest() {
		s2sCaseCommentRequestTest('create-informationresponse', inforesponsestr1);
	}
	
	private static void s2sCaseCommentRequestTest(String externalAction, String actionType) {
		Case testS2SCase = createS2STestCase();
		insert testS2SCase;
		
		CH_UTIL_TEST.createInterfaceKeyGroup('test orange-irma interface key group', SWS_Constants.ORANGEIRMA);
		
		Test.startTest();
		Profile integrationProfile = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		String integrationUserEmail = 'naip' + DateTime.now().getTime() + testStrng1;
		User integrationUser = getIntegrationUser(integrationUserEmail, integrationUserEmail, 'naipuser', integrationProfile);
		System.runAs(integrationUser) {
			testS2SCase = [SELECT Id, CaseNumber, Origin, CH_CaseOriginSystem__c FROM Case WHERE Id =: testS2SCase.Id];
			CH_ExternalInterfaceWebService.CaseObject request = new CH_ExternalInterfaceWebService.CaseObject();
			request.chActionExternalSystem = externalAction;
			request.chCaseOriginSystem = SWS_Constants.ORANGEIRMA;
			request.caseCommentTitle = 'test title';
			request.caseCommentBody = 'test body';
			request.referenceNumber = testS2SCase.CaseNumber;
			
			CH_UserNotificationUTIL.runSendS2SFailureNotification = true;
			CH_UserNotificationUTIL.runSendInterfaceKeyUserNotifications = true;
			List<CH_ExternalInterfaceWebService.CaseObjectResponse> responses = CH_ExternalInterfaceWebService.upsertCases(new List<CH_ExternalInterfaceWebService.CaseObject>{request});
			System.assertEquals(responses.size(), 1);
			System.assert(String.isEmpty(responses[0].errorMessage));
			List<CaseComment> comments = [SELECT Id, IsPublished, ParentId, CommentBody FROM CaseComment];
			System.assertEquals(comments.size(), 1);
			CaseComment comment = comments[0];
			System.assert(comment.IsPublished);
			System.assertEquals(comment.ParentId, testS2SCase.Id);
			System.assertEquals(comment.CommentBody, String.format('{0} \n{1} \n{2}', new List<Object>{actionType, request.caseCommentTitle, request.caseCommentBody}));
			List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
			
			Boolean hasSuccessNotification = false;
			CH_UserNotificationUTIL.runSendS2SCaseCommentInboundSuccessNotification = true;
			try {
	CH_ExternalInterfaceWebService.upsertCases(new List<CH_ExternalInterfaceWebService.CaseObject>{request});
			} catch(Exception e) {
	hasSuccessNotification = true;
			}
			System.assert(hasSuccessNotification);
			logs = [SELECT Id FROM Interface_Log__c];
			
			CH_UserNotificationUTIL.runSendS2SCaseCommentInboundSuccessNotification = false;
			request = new CH_ExternalInterfaceWebService.CaseObject();
			request.chCaseOriginSystem = SWS_Constants.ORANGEIRMA;
			request.referenceNumber = testS2SCase.CaseNumber;
			request.chActionExternalSystem = 'test external action';
			
			Boolean hasFailureNotification = false;
			CH_UserNotificationUTIL.runSendS2SFailureNotification = true;
			CH_UserNotificationUTIL.runSendInterfaceKeyUserNotifications = false;
			try {
	CH_ExternalInterfaceWebService.upsertCases(new List<CH_ExternalInterfaceWebService.CaseObject>{request});
			} catch(Exception e) {
	hasFailureNotification = true;
			}
			System.assert(hasFailureNotification);
			
			hasFailureNotification = false;
			CH_UserNotificationUTIL.runSendS2SFailureNotification = false;
			CH_UserNotificationUTIL.runSendInterfaceKeyUserNotifications = true;
			try {
	CH_ExternalInterfaceWebService.upsertCases(new List<CH_ExternalInterfaceWebService.CaseObject>{request});
			} catch(Exception e) {
	hasFailureNotification = true;
			}
			System.assert(hasFailureNotification);
			
			CH_UserNotificationUTIL.runSendS2SFailureNotification = false;
			CH_UserNotificationUTIL.runSendInterfaceKeyUserNotifications = false;
			responses = CH_ExternalInterfaceWebService.upsertCases(new List<CH_ExternalInterfaceWebService.CaseObject>{request});
			System.assertEquals(responses.size(), 1);
			System.assertEquals(responses[0].errorMessage,  String.format(Label.CH_InboundS2SRequest_UnsupportedActionValidation, new List<Object>{request.chActionExternalSystem}));
			logs = [SELECT Id, Name, Comment__c, Interface_Request_Sent__c, Status__c, Message_Type__c, Operation_Type__c, Interface_Type__c FROM Interface_Log__c WHERE Id NOT IN :logs];
			for (Interface_Log__c log : logs) {
	validateS2SLog(log, String.format('Inbound {0} Case', new List<Object> {request.chCaseOriginSystem}), NULL);
			}
		}
		Test.stopTest();
	}
	
	@isTest
	private static void s2sCaseCommentValidationTest() {
		Case testS2SCase = createS2STestCase();
		insert testS2SCase;
		
		Test.startTest();
		testS2SCase = [SELECT Id, CaseNumber, Status FROM Case];
		CH_ExternalInterfaceWebService.CaseObject request = new CH_ExternalInterfaceWebService.CaseObject();
		request.chActionExternalSystem = 'retrieve-casetest';
		request.chCaseOriginSystem = SWS_Constants.ORANGEIRMA;
		request.referenceNumber = testS2SCase.CaseNumber;
		
		List<CH_ExternalInterfaceWebService.CaseObjectResponse> responses = CH_ExternalInterfaceWebService.upsertCases(new List<CH_ExternalInterfaceWebService.CaseObject>{request});
		System.assertEquals(responses.size(), 1);
		System.assertEquals(responses[0].errorMessage, String.format(Label.CH_InboundS2SRequest_UnsupportedActionValidation, new List<Object>{request.chActionExternalSystem}));
		
		CH_ExternalInterfaceWebService.validateCaseStatus(testS2SCase);
		Set<String> inactiveCaseStatuses = new Set<String> {'Completed', 'Cancelled'};
			for(String caseStatus : inactiveCaseStatuses) {
	testS2SCase.Status = caseStatus;
	Boolean hasError = false;
	try {
		CH_ExternalInterfaceWebService.validateCaseStatus(testS2SCase);
	} catch(Exception e) {
		System.assertEquals(e.getMessage(), String.format(Label.CH_InboundS2SRequest_CaseStatusValidation, new List<Object>{caseStatus}));
		hasError = true;
	}
	System.assert(hasError);
			}
		
		testS2SCase.Status = 'Closed';
		CH_ExternalInterfaceWebService.validateCaseStatus(testS2SCase);
		Test.stopTest();
	}
	
	@isTest
	private static void s2sRequestValidationTest() {
		Case testProblem = createTestCase();
		testProblem = [SELECT Id, CaseNumber, Origin, CH_CaseOriginSystem__c FROM Case WHERE Id =: testProblem.Id];
		
		Test.startTest();
		CH_ExternalInterfaceWebService.CaseObject request = new CH_ExternalInterfaceWebService.CaseObject();
		request.chActionExternalSystem = 'retrieve-case';
		request.chCaseOriginSystem = SWS_Constants.ORANGEIRMA;
		List<CH_ExternalInterfaceWebService.CaseObjectResponse> responses = CH_ExternalInterfaceWebService.upsertCases(new List<CH_ExternalInterfaceWebService.CaseObject>{request});
		System.assertEquals(responses.size(), 1);
		System.assertEquals(responses[0].errorMessage, Label.CH_InboundS2SRequest_NoCaseNumberValidation);
		
		request.referenceNumber = 'test case';
		responses = CH_ExternalInterfaceWebService.upsertCases(new List<CH_ExternalInterfaceWebService.CaseObject>{request});
		System.assertEquals(responses.size(), 1);
		System.assertEquals(responses[0].errorMessage, String.format(Label.CH_InboundS2SRequest_InvalidCaseNumberValidation, new List<Object>{request.referenceNumber}));
		
		request.referenceNumber = testProblem.CaseNumber;
		responses = CH_ExternalInterfaceWebService.upsertCases(new List<CH_ExternalInterfaceWebService.CaseObject>{request});
		System.assertEquals(responses.size(), 1);
		System.assertEquals(responses[0].errorMessage, String.format(Label.CH_InboundS2SRequest_InvalidCaseOriginValidation, new List<Object>{testProblem.Origin}));
		
		Case testS2SCase = createS2STestCase();
		insert testS2SCase;
		testS2SCase = [SELECT Id, CaseNumber, Origin, CH_CaseOriginSystem__c FROM Case WHERE Id =: testS2SCase.Id];
		request.chCaseOriginSystem = 'orange-irmatest';
		request.referenceNumber = testS2SCase.CaseNumber;
		responses = CH_ExternalInterfaceWebService.upsertCases(new List<CH_ExternalInterfaceWebService.CaseObject>{request});
		System.assertEquals(responses.size(), 1);
		System.assertEquals(responses[0].errorMessage, String.format(Label.CH_InboundS2SRequest_InvalidCaseOriginSystemValidation, new List<Object>{testS2SCase.CH_CaseOriginSystem__c}));
		
		responses = CH_ExternalInterfaceWebService.upsertCases(new List<CH_ExternalInterfaceWebService.CaseObject>{request, request});
		System.assertEquals(responses.size(), 2);
		for (CH_ExternalInterfaceWebService.CaseObjectResponse response : responses) {
			System.assertEquals(response.errorMessage, Label.CH_InboundS2SRequest_MultipleRequestValidation);
		}
		Test.stopTest();
	}
	
	@isTest
	private static void caseReferenceNumberTest() {
		Case testCase = createTestCase();
		testCase = [SELECT Id, CaseNumber, CH_JIRA_ExternalStatus__c, CH_CRNumber__c, CH_R_D_Interface_Flag__c FROM Case WHERE Id =: testCase.Id];
		System.assert(String.isEmpty(testCase.CH_CRNumber__c));
		System.assertEquals(testCase.CH_R_D_Interface_Flag__c, false);
		
		CH_Problem_RnD_Reference__c createAnalysisRndInteraction1 = getRndInteraction(statusString1, sampleRnDStr, jiraStrng1, 'outbound', 'JIRA', NULL, testCase.Id);
		CH_Problem_RnD_Reference__c createAnalysisRndInteraction2 = getRndInteraction(statusString1, sampleRnDStr, jiraStrng1, 'outbound', 'JIRA', NULL, testCase.Id);
		List<CH_ExternalInterfaceWebService.RndRequest> requests = new List<CH_ExternalInterfaceWebService.RndRequest>();
		for (Integer i=0; i<2; i++) {
			CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
			request.rndInteractionInterface = jiraBridgeStr1;
			request.rndInteractionSubject = testsubject1;
			request.rndInteractionDescription = testdescription1;
			request.rndInteractionType = 'acknowledge-success';
			request.caseJiraExternalStatus = 'test external status';
			request.rndInteractionOriginatingIncident = testCase.CaseNumber;
			requests.add(request);
		}
		CH_ExternalInterfaceWebService.RndRequest request1 = requests[0];
		request1.rndInteractionReference = 'test jira id1';
		CH_ExternalInterfaceWebService.RndRequest request2 = requests[1];
		request2.rndInteractionReference = 'test jira id2';
		
		Test.startTest();
		insert createAnalysisRndInteraction1;
		CH_ExternalInterfaceWebService.RndResponse response = CH_ExternalInterfaceWebService.handleRndRequest(request1);
		System.assert(String.isEmpty(response.rndInteractionErrorMessage));
		System.assertEquals(response.rndInteractionStatus, 'Completed');
		testCase = [SELECT Id, CaseNumber, CH_CRNumber__c, CH_R_D_Interface_Flag__c FROM Case WHERE Id =: testCase.Id];
		System.assertEquals(testCase.CH_CRNumber__c, request1.rndInteractionReference);
		System.assertEquals(testCase.CH_R_D_Interface_Flag__c, true);
		createAnalysisRndInteraction1 = [SELECT Id, CH_RnD_Reference__c FROM CH_Problem_RnD_Reference__c WHERE Id =: createAnalysisRndInteraction1.Id];
		System.assertEquals(createAnalysisRndInteraction1.CH_RnD_Reference__c, request1.rndInteractionReference);
		
		insert createAnalysisRndInteraction2;
		response = CH_ExternalInterfaceWebService.handleRndRequest(request2);
		System.assert(String.isEmpty(response.rndInteractionErrorMessage));
		System.assertEquals(response.rndInteractionStatus, 'Completed');
		testCase = [SELECT Id, CaseNumber, CH_CRNumber__c, CH_R_D_Interface_Flag__c FROM Case WHERE Id =: testCase.Id];
		System.assertNotEquals(testCase.CH_CRNumber__c, request2.rndInteractionReference);
		System.assertEquals(testCase.CH_CRNumber__c, request1.rndInteractionReference);
		System.assertEquals(testCase.CH_R_D_Interface_Flag__c, true);
		createAnalysisRndInteraction2 = [SELECT Id, CH_RnD_Reference__c FROM CH_Problem_RnD_Reference__c WHERE Id =: createAnalysisRndInteraction2.Id];
		System.assertEquals(createAnalysisRndInteraction2.CH_RnD_Reference__c, request2.rndInteractionReference);
		Test.stopTest();
	}
	
	@isTest
	private static void handleProntoGroupRequestCreatepcpgroupTest() {
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = 'create-pcpgroup';
		request.rndInteractionInterface = prontostring1;
		request.pcpGroupName = prontostring1;
		request.pcpGroupTitle = 'testTitle';
		request.pcpGroupDescription = testsampledescr1;
		
		System.assert([SELECT Count() FROM CH_Pronto_Group__c WHERE Name = :request.pcpGroupName] == 0);
		
		CH_ExternalInterfaceWebService.RndResponse response = new CH_ExternalInterfaceWebService.RndResponse(request.rndInteractionInterface);
		response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		
		System.assert(response.rndInteractionErrorMessage == null, 'Error message should be empty');
		System.assert(response.rndInteractionInterface == prontostring1, 'Wrong rndInteractionInterface in response');
		System.assert(response.rndInteractionStatus == 'Active', 'Wrong rndInteractionStatus in response');
		
		List<CH_Pronto_Group__c> pcpGroup = [SELECT Name, CH_Pronto_Group_Title__c, CH_Pronto_Group_Description__c, CH_Pronto_Group_Origin__c 
			FROM CH_Pronto_Group__c WHERE Name = :request.pcpGroupName LIMIT 1];
		System.assert(pcpGroup.size() == 1, 'Pronto group was not created');
		System.assert(pcpGroup.get(0).Name == request.pcpGroupName, 'wrong pcpGroupName');
		System.assert(pcpGroup.get(0).CH_Pronto_Group_Title__c == request.pcpGroupTitle, 'wrong pcpGroupTitle');
		System.assert(pcpGroup.get(0).CH_Pronto_Group_Description__c == request.pcpGroupDescription, 'wrong pcpGroupDescription');
		System.assert(pcpGroup.get(0).CH_Pronto_Group_Origin__c == 'Interface', 'wrong CH_Pronto_Group_Origin__c');
		validateRndPcpGroupLog('Success', request);
	}
	
	@isTest
	private static void handleProntoGroupRequestCreatepcpgroupDuplicateTest() {
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = 'create-pcpgroup';
		request.rndInteractionInterface = prontostring1;
		request.pcpGroupName = prontostring1;
		request.pcpGroupTitle = 'testTitle';
		request.pcpGroupDescription = testsampledescr1;
		
		CH_Pronto_Group__c pcpGroup = new CH_Pronto_Group__c();
		pcpGroup.Name = request.pcpGroupName;
		insert pcpGroup;
		
		System.assert([SELECT Count() FROM CH_Pronto_Group__c WHERE Name = :request.pcpGroupName] == 1);
		
		CH_ExternalInterfaceWebService.RndResponse response = new CH_ExternalInterfaceWebService.RndResponse(request.rndInteractionInterface);
		response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		
		System.assert(response.rndInteractionErrorMessage == Label.CH_InboundRndRequest_ProntoGroupDuplicateError, 'Error message should not be empty. Recieved :' + response.rndInteractionErrorMessage );
		validateRndPcpGroupLog('Failure', request);
	}
	
	@isTest
	private static void handleProntoGroupRequestUpdatepcpgroupTest() {
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = 'update-pcpgroup';
		request.rndInteractionInterface = prontostring1;
		request.pcpGroupName = prontostring1;
		request.pcpGroupTitle = 'testTitle';
		request.pcpGroupDescription = testsampledescr1;
		
		CH_Pronto_Group__c pcpGroup = new CH_Pronto_Group__c();
		pcpGroup.Name = request.pcpGroupName;
		pcpGroup.CH_Pronto_Group_Title__c = beforeUpdateStr;
		pcpGroup.CH_Pronto_Group_Description__c = beforeUpdateStr;
		insert pcpGroup;
		
		System.assert([SELECT CH_Pronto_Group_Title__c FROM CH_Pronto_Group__c WHERE Name = :request.pcpGroupName].get(0).CH_Pronto_Group_Title__c == beforeUpdateStr);
		System.assert([SELECT CH_Pronto_Group_Description__c FROM CH_Pronto_Group__c WHERE Name = :request.pcpGroupName].get(0).CH_Pronto_Group_Description__c == beforeUpdateStr);
		
		CH_ExternalInterfaceWebService.RndResponse response = new CH_ExternalInterfaceWebService.RndResponse(request.rndInteractionInterface);
		response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		
		System.assert(String.isEmpty(response.rndInteractionErrorMessage), 'Error message should be empty. Recieved :' + response.rndInteractionErrorMessage );
		System.assert([SELECT CH_Pronto_Group_Title__c FROM CH_Pronto_Group__c WHERE Name = :request.pcpGroupName].get(0).CH_Pronto_Group_Title__c == request.pcpGroupTitle);
		System.assert([SELECT CH_Pronto_Group_Description__c FROM CH_Pronto_Group__c WHERE Name = :request.pcpGroupName].get(0).CH_Pronto_Group_Description__c == request.pcpGroupDescription);
		validateRndPcpGroupLog('Success', request);
	}
	
	@isTest
	private static void handleProntoGroupRequestUpdatepcpgroupNotFoundTest() {
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = 'update-pcpgroup';
		request.rndInteractionInterface = prontostring1;
		request.pcpGroupName = prontostring1;
		request.pcpGroupTitle = 'testTitle';
		request.pcpGroupDescription = testsampledescr1;
		
		System.assert([SELECT Count() FROM CH_Pronto_Group__c WHERE Name = :request.pcpGroupName] == 0);
		
		CH_ExternalInterfaceWebService.RndResponse response = new CH_ExternalInterfaceWebService.RndResponse(request.rndInteractionInterface);
		response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		
		System.assert(response.rndInteractionErrorMessage == Label.CH_InboundRndRequest_ProntoGroupNotFoundError, 'Error message should be about "No Group found". Recieved :' + response.rndInteractionErrorMessage );
		System.assert([SELECT Count() FROM CH_Pronto_Group__c WHERE Name = :request.pcpGroupName] == 0);
		validateRndPcpGroupLog('Failure', request);
	}
	
	@isTest
	private static void handleProntoGroupRequestDeletepcpgroupTest() {
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = 'delete-pcpgroup';
		request.rndInteractionInterface = prontostring1;
		request.pcpGroupName = prontostring1;
		
		CH_Pronto_Group__c pcpGroup = new CH_Pronto_Group__c();
		pcpGroup.Name = request.pcpGroupName;
		insert pcpGroup;
		
		System.assert([SELECT Count() FROM CH_Pronto_Group__c WHERE Name = :request.pcpGroupName] == 1);
		
		CH_ExternalInterfaceWebService.RndResponse response = new CH_ExternalInterfaceWebService.RndResponse(request.rndInteractionInterface);
		response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		
		System.assert(String.isEmpty(response.rndInteractionErrorMessage), 'Error message should be empty. Recieved :' + response.rndInteractionErrorMessage );
		System.assert([SELECT Count() FROM CH_Pronto_Group__c WHERE Name = :request.pcpGroupName] == 0, 'Pronto Group was not deleted');
		validateRndPcpGroupLog('Success', request);
	}
	
	@isTest
	private static void handleProntoGroupRequestDeletepcpgroupNotFoundTest() {
		CH_ExternalInterfaceWebService.RndRequest request = new CH_ExternalInterfaceWebService.RndRequest();
		request.rndInteractionType = 'delete-pcpgroup';
		request.rndInteractionInterface = prontostring1;
		request.pcpGroupName = prontostring1;
		
		System.assert([SELECT Count() FROM CH_Pronto_Group__c WHERE Name = :request.pcpGroupName] == 0);
		
		CH_ExternalInterfaceWebService.RndResponse response = new CH_ExternalInterfaceWebService.RndResponse(request.rndInteractionInterface);
		response = CH_ExternalInterfaceWebService.handleRndRequest(request);
		
		System.assert(response.rndInteractionErrorMessage == Label.CH_InboundRndRequest_ProntoGroupNotFoundError, 'Error message should be about "No Group found". Recieved :' + response.rndInteractionErrorMessage );
		validateRndPcpGroupLog('Failure', request);
	}
}