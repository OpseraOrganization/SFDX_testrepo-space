@isTest   
private class CH_ExternalInterfaceUTILTest {  
	public static final String emalsubstr='test subject';
	public static final String s2sCaseStr='S2S Case {0} {1}';
	public static final String custDescrptn='new test customer description';  
	public static final String custdescrp2='Customer Description';
	public static final String caseStatusstr='In Progress';
	public static final String testBadRqst='test: Bad Request';
	public static final String casedescrptnstr1='test description';
	public static final String updateanlysStrng='update-analysis';
	public static final String rnDOtbndStr='R&D Outbound {0} {1}';
	public static final String rndinrfcStrn1='Pronto/Jira Interface';
	public static final String otherinfoStr='Other Information';
	public static final String updateToRnDStr='Update to R&D';
	public static final String testJiraIdStr='test jira id';
	public static final String testJiraBridge='jira-bridge';
	public static final String testProntoId='test pronto id';
	
	@testSetup static void setup() {
		insert new CH_Integration__c(EnableIntegration__c = true);  
		Product2 tempProduct = new Product2(
			Name = 'Test Product 1',
			NokiaCPQ_State__c = 'Implement',
			NCP_CAREACTIVATE__c = 'test',
			PMD_Portfolio_Classification__c = 'Product'
		);
		Insert tempProduct;
		
		CH_UTIL_TEST.setupCase();
	}
	
	private static Case createTestCase() {
		CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
		
		return CH_UTIL_TEST.getS2SCase();
	}
	
	private static EmailMessage createTestEmailMessage(Id testCaseId, String emailType) {
		EmailMessage email = new EmailMessage();
		email.FromAddress = 'testfrom@test.org';
		email.Incoming = false;
		email.ToAddress= 'testto@test.org';
		email.Subject = emalsubstr;
		email.TextBody = 'test body';
		email.ParentId = testCaseId; 
		email.CH_Email_Type__c = emailType;
		email.CH_TypeControl__c = 'All';
		return email;
	}
	
	private static CH_OutboundMessageSettings__c createOutboundMessageSettings(String settings) {
		return new CH_OutboundMessageSettings__c(Name = settings,
												 CaseFeedEmailCauseAnalysisReport__c = true,
												 CaseFeedEmailCustomerInformationRequest__c = true,
												 CaseFeedEmailInitialResponse__c = true,
												 CaseFeedEmailRestoration__c = true,
												 CaseFeedEmailServiceDisruptionReport__c = true,
												 CaseFeedEmailSolution__c = true,
												 CaseFeedEmailTemporary__c = true,
												 CaseFeedEmailUpdate__c = true,
												 CaseStageInvestigateRestore__c = true,
												 CaseStageDiagnosisTechnicalAnalysis__c = true,
												 CaseStageRegister__c = true,
												 CaseStageAssetRespond__c = true,
												 CaseStageResolve__c = true,
												 CaseStageRoute__c = true,
												 CaseStageClose__c = true);
	}
	
	private static void validateRndUpdateAnalysisLog(Interface_Log__c log, Case c, List<CH_Attachment__c> attachments, String externalSystemAction, String interfaceName,String comment, String name, String interfaceType) {
		validateRndLog(log, externalSystemAction, interfaceName, comment, name, interfaceType);
		System.assert(log.Interface_Request_Sent__c.contains('Severity_xc=' + c.Severity__c));
		System.assert(log.Interface_Request_Sent__c.contains('CaseNumber=' + c.CaseNumber));
		if (attachments != NULL) {
			if (interfaceName == 'pronto') {
				for (CH_Attachment__c a : attachments) {
					System.assert(log.Interface_Request_Sent__c.contains('AttachmentID_xc=' + a.AttachmentID__c));
					System.assert(log.Interface_Request_Sent__c.contains('File_Name_xc=' + a.File_Name__c));
				}
			} else {
				for (CH_Attachment__c a : attachments) {
					System.assert(!log.Interface_Request_Sent__c.contains('AttachmentID_xc=' + a.AttachmentID__c));
					System.assert(!log.Interface_Request_Sent__c.contains('File_Name_xc=' + a.File_Name__c));
				}
			}
		}
	}
	
	private static void validateRndCreateInformationUpdateLog(Interface_Log__c log, Case c, String externalSystemAction, String interfaceName, String comment, String name, String interfaceType) {
		validateRndLog(log, externalSystemAction, interfaceName, comment, name, interfaceType);
		System.assert(log.Interface_Request_Sent__c.contains('Severity_xc=' + c.Severity__c));
	}
	
	private static void validateRndLog(Interface_Log__c log, String externalSystemAction, String interfaceName,String comment, String name, String interfaceType) {
		System.assertEquals(log.Comment__c, comment);
		System.assertEquals(log.Name, name);
		System.assertEquals(log.Message_Type__c, 'Outbound');
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
		System.assert(log.Interface_Request_Sent__c.contains('Type_x=' + externalSystemAction));
		System.assert(log.Interface_Request_Sent__c.contains('Interface_x=' + interfaceName));
	}
	
	private static void validateInsertCaseCommentNotificationLog(Interface_Log__c log, Case c, CaseComment comment) {
		validateCaseCommentNotificationLog(log, c, comment, 'NOKIA comment added');
		System.assertEquals(log.Operation_Type__c, 'Insert');
	}
	
	private static void validateDeleteCaseCommentNotificationLog(Interface_Log__c log, Case c, CaseComment comment) {
		validateCaseCommentNotificationLog(log, c, comment, 'NOKIA comment deleted');
		System.assertEquals(log.Operation_Type__c, 'Delete');
	}
	
	private static void validateCaseCommentNotificationLog(Interface_Log__c log, Case c, CaseComment comment, String title) {
		validateLog(log, c, SWS_Constants.CREATEINFOUPDATE, title, 'Success', NULL, SWS_Constants.CUSTOMERS2S);
		System.assert(log.Interface_Request_Sent__c.contains('Case Comment Id: ' + comment.Id));
	}
	
	private static void validateLog(Interface_Log__c log, Case c, String externalSystemAction, String activityTitle, String status, String comment, String interfaceType) {
		System.assert(log.Interface_Request_Sent__c.contains('Title=' + activityTitle));
		validateLog(log, c, externalSystemAction, status, comment, interfaceType);
	}
	
	private static void validateLog(Interface_Log__c log, Case c, String externalSystemAction, String status, String comment, String interfaceType) {
		System.assertEquals(log.Status__c, status);
		System.assertEquals(log.Comment__c, comment);
		System.assert(String.isNotEmpty(log.Interface_Request_Sent__c));
		System.assertEquals(log.Interface_Type__c, interfaceType);
		System.assert(log.Interface_Request_Sent__c.contains('CH_Action_ExternalSystem_xc=' + externalSystemAction));
		System.assert(log.Interface_Request_Sent__c.contains('CaseNumber=' + c.CaseNumber));
		System.assert(log.Interface_Request_Sent__c.contains('CH_CaseOriginSystem_xc=' + c.CH_CaseOriginSystem__c));
		System.assert(log.Interface_Request_Sent__c.contains('ReferenceNumber_xc=' + c.Reference_Number__c));
	}
	
	private static CH_Problem_RnD_Reference__c validateRndInteraction(Id outboundRndInteractionId, String subject, String description, String comment, String rndInterface, String relatedRecordId, String rndReference, String direction, String rndType) {
		CH_Problem_RnD_Reference__c rndInteraction = [SELECT Id, CreatedDate, CH_Related_Record__r.CaseNumber, CH_Related_Record__r.CH_Originating_Incident_Number__c, CH_Request__c, CH_Related_Record__r.CH_Originating_Incident_Number__r.CaseNumber, CH_RnD_Status__c, CH_RnD_Error_Message__c, CH_RnD_Subject__c, CH_RnD_Description__c, CH_RnD_Comment__c, CH_RnD_Interface__c, CH_Related_Record__c, CH_RnD_Reference__c, CH_RnD_Direction__c, CH_RnD_Type__c FROM CH_Problem_RnD_Reference__c WHERE Id =: outboundRndInteractionId];
		System.assertEquals(rndInteraction.CH_RnD_Subject__c, subject);
		System.assertEquals(rndInteraction.CH_RnD_Description__c, description);
		System.assertEquals(rndInteraction.CH_RnD_Comment__c, comment);
		System.assertEquals(rndInteraction.CH_RnD_Interface__c, rndInterface);
		System.assertEquals(rndInteraction.CH_Related_Record__c, relatedRecordId);
		System.assertEquals(rndInteraction.CH_RnD_Reference__c, rndReference);
		System.assertEquals(rndInteraction.CH_RnD_Direction__c, direction);
		System.assertEquals(rndInteraction.CH_RnD_Type__c, rndType);
		
		return rndInteraction;  
	}
	
	@isTest
	public static void isolateS2SbyStageSuccessTest() {
		Case testCase = createTestCase();
		insert testCase;
		
		Test.startTest();
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		CH_OutboundMessageSettings__c settings = createOutboundMessageSettings(SWS_Constants.ORANGEIRMA);
		insert settings;
		
		Case newTestCase = [SELECT Id, Origin, CH_CaseOriginSystem__c, CH_Summary__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		newTestCase.CH_Stage__c = 'Prevent';
		System.assert(CH_ExternalInterfaceUTIL.isolateS2SbyStage(new List<Case>{newTestCase}).isEmpty());
		newTestCase.CH_Stage__c = 'Register';
		System.assertEquals(CH_ExternalInterfaceUTIL.isolateS2SbyStage(new List<Case>{newTestCase}).size(), 1);
		newTestCase.CH_Stage__c = 'Assess & Respond';
		System.assertEquals(CH_ExternalInterfaceUTIL.isolateS2SbyStage(new List<Case>{newTestCase}).size(), 1);
		newTestCase.CH_Stage__c = 'Investigate & Restore';
		System.assertEquals(CH_ExternalInterfaceUTIL.isolateS2SbyStage(new List<Case>{newTestCase}).size(), 1);
		newTestCase.CH_Stage__c = 'Diagnosis & Technical Analysis';
		System.assertEquals(CH_ExternalInterfaceUTIL.isolateS2SbyStage(new List<Case>{newTestCase}).size(), 1);
		newTestCase.CH_Stage__c = 'Resolve';
		System.assertEquals(CH_ExternalInterfaceUTIL.isolateS2SbyStage(new List<Case>{newTestCase}).size(), 1);
		newTestCase.CH_Stage__c = 'Route';
		System.assertEquals(CH_ExternalInterfaceUTIL.isolateS2SbyStage(new List<Case>{newTestCase}).size(), 1);
		newTestCase.CH_Stage__c = 'Close';
		System.assertEquals(CH_ExternalInterfaceUTIL.isolateS2SbyStage(new List<Case>{newTestCase}).size(), 1);
		
		newTestCase = [SELECT Id, Origin, CH_Stage__c, CH_CaseOriginSystem__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		System.assertEquals(newTestCase.Origin, 'S2S');
		System.assertEquals(newTestCase.CH_CaseOriginSystem__c, SWS_Constants.ORANGEIRMA);
		newTestCase.CH_CustomerDescription__c = custDescrptn;
		CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = true;
		newTestCase.CH_ReportedDate__c = newTestCase.CreatedDate.adddays(-2);
		newTestCase.CH_IssueOccurenceDate__c = newTestCase.CH_ReportedDate__c.adddays(-1);
		update newTestCase;
		
		Test.stopTest();
		
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		testCase = [SELECT Id, CaseNumber, CH_CaseOriginSystem__c, Reference_Number__c, Origin FROM Case];
		validateLog(logs[0], testCase, SWS_Constants.CREATEINFOUPDATE, custdescrp2, 'Success', NULL, SWS_Constants.CUSTOMERS2S);
	}
	
	@IsTest
	public static void isolateUniqueRefNumCasesTest(){
		Case testCase = createTestCase();
		insert testCase;
		
		Test.startTest();
		
		List<Case> newCaseList = [SELECT Id, Origin, CH_CaseOriginSystem__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		CH_ExternalInterfaceUTIL.isolateUniqueRefNumCases(newCaseList);
		
		Test.stopTest();
	}
	
	@isTest
	private static void sendCreationToExternalSystemTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
		Case testCase = createTestCase();
		insert testCase;
		List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
		System.assert(logs.isEmpty());
		
		Test.startTest();
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		Case newTestCase = [SELECT Id, Origin, CH_CaseOriginSystem__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		System.assertEquals(newTestCase.Origin, 'S2S');
		System.assertEquals(newTestCase.CH_CaseOriginSystem__c, SWS_Constants.ORANGEIRMA);
		CH_ExternalInterfaceUTIL.sendCreationToExternalSystem(new List<Case>{newTestCase});
		Test.stopTest();
		
		logs = [SELECT Id, Name, Comment__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		testCase = [SELECT Id, CaseNumber, CH_CaseOriginSystem__c, Reference_Number__c, Origin FROM Case];
		validateLog(logs[0], testCase, 'create-case', 'Success', NULL, SWS_Constants.CUSTOMERS2S);
	}
	
	@isTest
	public static void isolateS2SbyStageValidationTest() {
		Case testCase = createTestCase();
		insert testCase;
		
		Test.startTest();
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		Case newTestCase = [SELECT Id, Origin, CH_CaseOriginSystem__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		newTestCase.CH_Stage__c = 'Register';
		System.assert(CH_ExternalInterfaceUTIL.isolateS2SbyStage(new List<Case>{newTestCase}).isEmpty());
		newTestCase.CH_Stage__c = 'Assess & Respond';
		System.assert(CH_ExternalInterfaceUTIL.isolateS2SbyStage(new List<Case>{newTestCase}).isEmpty());
		newTestCase.CH_Stage__c = 'Investigate & Restore';
		System.assert(CH_ExternalInterfaceUTIL.isolateS2SbyStage(new List<Case>{newTestCase}).isEmpty());
		newTestCase.CH_Stage__c = 'Diagnosis & Technical Analysis';
		System.assert(CH_ExternalInterfaceUTIL.isolateS2SbyStage(new List<Case>{newTestCase}).isEmpty());
		newTestCase.CH_Stage__c = 'Resolve';
		System.assert(CH_ExternalInterfaceUTIL.isolateS2SbyStage(new List<Case>{newTestCase}).isEmpty());
		newTestCase.CH_Stage__c = 'Route';
		System.assert(CH_ExternalInterfaceUTIL.isolateS2SbyStage(new List<Case>{newTestCase}).isEmpty());
		newTestCase.CH_Stage__c = 'Close';
		System.assert(CH_ExternalInterfaceUTIL.isolateS2SbyStage(new List<Case>{newTestCase}).isEmpty());
		newTestCase.CH_Stage__c = 'Prevent';
		System.assert(CH_ExternalInterfaceUTIL.isolateS2SbyStage(new List<Case>{newTestCase}).isEmpty());
		
		newTestCase = [SELECT Id, Origin, CH_Stage__c, CH_CaseOriginSystem__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		System.assertEquals(newTestCase.Origin, 'S2S');
		System.assertEquals(newTestCase.CH_CaseOriginSystem__c, SWS_Constants.ORANGEIRMA);
		newTestCase.CH_CustomerDescription__c = custDescrptn;
		update newTestCase;
		Test.stopTest();
		
		List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
		System.assert(logs.isEmpty());
	}
	
	@isTest
	private static void sendUpdatesFromEmailMessageToExternalTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
		CH_OutboundMessageSettings__c settings = createOutboundMessageSettings(SWS_Constants.ORANGEIRMA);
		insert settings;
		
		Case testCase = createTestCase();
		testCase.CH_AssignedDate__c = Datetime.now();
		testCase.Status = SWS_Constants.INPROGRESS;
		insert testCase;
		System.assertEquals(testCase.CH_CaseOriginSystem__c, SWS_Constants.ORANGEIRMA);
		
		List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
		
		Test.startTest();
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		Map<String, CH_OutboundMessageSettings__c> outboundMessageSettings = CH_OutboundMessageSettings__c.getAll();
		System.assert(String.isNotEmpty(CH_ExternalInterfaceUTIL.isolateS2SbyEmailType(outboundMessageSettings, 'Customer Information Request', testCase.CH_CaseOriginSystem__c)));
		System.assert(String.isNotEmpty(CH_ExternalInterfaceUTIL.isolateS2SbyEmailType(outboundMessageSettings, 'Temporary Solution Provided', testCase.CH_CaseOriginSystem__c)));
		System.assert(String.isNotEmpty(CH_ExternalInterfaceUTIL.isolateS2SbyEmailType(outboundMessageSettings, 'Solution Provided', testCase.CH_CaseOriginSystem__c)));
		System.assert(String.isNotEmpty(CH_ExternalInterfaceUTIL.isolateS2SbyEmailType(outboundMessageSettings, 'Update', testCase.CH_CaseOriginSystem__c)));
		System.assert(String.isNotEmpty(CH_ExternalInterfaceUTIL.isolateS2SbyEmailType(outboundMessageSettings, 'Restoration', testCase.CH_CaseOriginSystem__c)));
		System.assert(String.isNotEmpty(CH_ExternalInterfaceUTIL.isolateS2SbyEmailType(outboundMessageSettings, 'Service Disruption Report', testCase.CH_CaseOriginSystem__c)));
		System.assert(String.isNotEmpty(CH_ExternalInterfaceUTIL.isolateS2SbyEmailType(outboundMessageSettings, 'Cause Analysis Report', testCase.CH_CaseOriginSystem__c)));
		
		EmailMessage testEmail = createTestEmailMessage(testCase.Id, 'Update');
		insert testEmail;
		Test.stopTest();
		
		logs = [SELECT Id, Name, Comment__c, Interface_Request_Sent__c, Status__c, Interface_Type__c, Operation_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		testCase = [SELECT Id, CaseNumber, CH_CaseOriginSystem__c, Reference_Number__c, Origin FROM Case];
		Interface_Log__c log = logs[0];
		validateLog(log, testCase, SWS_Constants.CREATEINFOUPDATE, testEmail.Subject, 'Success', NULL, SWS_Constants.CUSTOMERS2S);
		testEmail = [SELECT Id, CreatedDate FROM EmailMessage WHERE Id =: testEmail.Id];
		System.assert(log.Interface_Request_Sent__c.contains('createdDate=' + testEmail.CreatedDate));
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = false;
		CH_ExternalInterfaceUTIL.resendOutboundS2SInteraction(log);
	}
	
	@isTest
	public static void outboundMessageSettingsTest() {
		CH_OutboundMessageSettings__c settings = createOutboundMessageSettings(SWS_Constants.ORANGEIRMA);
		settings.CaseFeedEmailCauseAnalysisReport__c = false;
		settings.CaseFeedEmailCustomerInformationRequest__c = false;
		settings.CaseFeedEmailRestoration__c = false;
		settings.CaseFeedEmailServiceDisruptionReport__c = false;
		settings.CaseFeedEmailSolution__c = false;
		settings.CaseFeedEmailTemporary__c = false;
		settings.CaseFeedEmailUpdate__c = false;
		settings.CaseFeedEmailInitialResponse__c = false;
		insert settings;
		
		Case testCase = createTestCase();
		testCase.CH_AssignedDate__c = Datetime.now();
		testCase.Status = SWS_Constants.INPROGRESS;
		insert testCase;
		System.assertEquals(testCase.CH_CaseOriginSystem__c, SWS_Constants.ORANGEIRMA);
		
		List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
		System.assert(logs.isEmpty());
		
		Test.startTest();
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		Map<String, CH_OutboundMessageSettings__c> outboundMessageSettings = CH_OutboundMessageSettings__c.getAll();
		System.assert(String.isEmpty(CH_ExternalInterfaceUTIL.isolateS2SbyEmailType(outboundMessageSettings, 'Customer Information Request', testCase.CH_CaseOriginSystem__c)));
		System.assert(String.isEmpty(CH_ExternalInterfaceUTIL.isolateS2SbyEmailType(outboundMessageSettings, 'Temporary Solution Provided', testCase.CH_CaseOriginSystem__c)));
		System.assert(String.isEmpty(CH_ExternalInterfaceUTIL.isolateS2SbyEmailType(outboundMessageSettings, 'Solution Provided', testCase.CH_CaseOriginSystem__c)));
		System.assert(String.isEmpty(CH_ExternalInterfaceUTIL.isolateS2SbyEmailType(outboundMessageSettings, 'Update', testCase.CH_CaseOriginSystem__c)));
		System.assert(String.isEmpty(CH_ExternalInterfaceUTIL.isolateS2SbyEmailType(outboundMessageSettings, 'Restoration', testCase.CH_CaseOriginSystem__c)));
		System.assert(String.isEmpty(CH_ExternalInterfaceUTIL.isolateS2SbyEmailType(outboundMessageSettings, 'Service Disruption Report', testCase.CH_CaseOriginSystem__c)));
		System.assert(String.isEmpty(CH_ExternalInterfaceUTIL.isolateS2SbyEmailType(outboundMessageSettings, 'Cause Analysis Report', testCase.CH_CaseOriginSystem__c)));
		System.assert(String.isEmpty(CH_ExternalInterfaceUTIL.isolateS2SbyEmailType(outboundMessageSettings, 'Initial Response', testCase.CH_CaseOriginSystem__c)));
		
		EmailMessage testEmail = createTestEmailMessage(testCase.Id, 'Update');
		insert testEmail;
		Test.stopTest();
		
		logs = [SELECT Id FROM Interface_Log__c];
		System.assert(logs.isEmpty());
	}
	
	@isTest
	private static void sendCreatedStatusToExternalSystemTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
		Case newTestCase = createTestCase();
		newTestCase.Status = 'Created';
		insert newTestCase;
		
		Case testCase = [SELECT Id, Origin, CH_CaseOriginSystem__c, CH_Stage__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		testCase.Status = 'New';
		
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
		insert createOutboundMessageSettings(SWS_Constants.ORANGEIRMA);
		
		List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
		System.assert(logs.isEmpty());
		
		Test.startTest();
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		System.assertEquals(newTestCase.Origin, 'S2S');
		System.assertEquals(testCase.CH_CaseOriginSystem__c, SWS_Constants.ORANGEIRMA);
		CH_ExternalInterfaceUTIL.sendStatusUpdatesToExternalSystem(new Map<Id, Case>{testCase.Id => testCase}, new List<Case>{newTestCase});
		Test.stopTest();
		
		logs = [SELECT Id FROM Interface_Log__c];
		System.assert(logs.isEmpty());
	}
	
	@isTest
	private static void sendAssignedStatusToExternalSystemTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
		Case newTestCase = createTestCase();
		newTestCase.Status = 'Assigned';
		insert newTestCase;
		
		Case testCase = [SELECT Id, Origin, CH_CaseOriginSystem__c, CH_Stage__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		testCase.Status = 'Created';
		
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
		insert createOutboundMessageSettings(SWS_Constants.ORANGEIRMA);
		
		List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
		System.assert(logs.isEmpty());
		
		Test.startTest();
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		System.assertEquals(newTestCase.Origin, 'S2S');
		System.assertEquals(testCase.CH_CaseOriginSystem__c, SWS_Constants.ORANGEIRMA);
		CH_ExternalInterfaceUTIL.sendStatusUpdatesToExternalSystem(new Map<Id, Case>{testCase.Id => testCase}, new List<Case>{newTestCase});
		Test.stopTest();
		
		logs = [SELECT Id, Name, Comment__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		testCase = [SELECT Id, CaseNumber, CH_CaseOriginSystem__c, Reference_Number__c, Origin FROM Case];
		validateLog(logs[0], testCase, SWS_Constants.CREATEINFOUPDATE, 'Status update', 'Success', NULL, SWS_Constants.CUSTOMERS2S);
	}
	
	@isTest
	private static void sendCancelationToExternalSystemTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
		Case testCase = createTestCase();
		insert testCase;
		List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
		System.assert(logs.isEmpty());
		
		Test.startTest();
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		Case newTestCase = [SELECT Id, Origin, CH_CaseOriginSystem__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		System.assertEquals(newTestCase.Origin, 'S2S');
		System.assertEquals(newTestCase.CH_CaseOriginSystem__c, SWS_Constants.ORANGEIRMA);
		newTestCase.Status = 'Cancelled';
		CH_ExternalInterfaceUTIL.sendCancelationToExternalSystem(new Map<Id, Case>{testCase.Id => testCase}, new List<Case>{newTestCase});
		Test.stopTest();
		
		logs = [SELECT Id, Name, Comment__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		testCase = [SELECT Id, CaseNumber, CH_CaseOriginSystem__c, Reference_Number__c, Origin FROM Case];
		validateLog(logs[0], testCase, 'cancel-case', 'Success', NULL, SWS_Constants.CUSTOMERS2S);
	}
	
	@isTest
	private static void sendCancelationToExternalSystemValidationTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
		Case testCase = createTestCase();
		insert testCase;
		List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
		System.assert(logs.isEmpty());
		
		Test.startTest();
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		Case newTestCase = [SELECT Id, Origin, CH_CaseOriginSystem__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		System.assertEquals(newTestCase.Origin, 'S2S');
		System.assertEquals(newTestCase.CH_CaseOriginSystem__c, SWS_Constants.ORANGEIRMA);
		
		newTestCase.Origin = NULL;
		newTestCase.Status = 'Cancelled';
		CH_ExternalInterfaceUTIL.sendCancelationToExternalSystem(new Map<Id, Case>{testCase.Id => testCase}, new List<Case>{newTestCase});
		
		newTestCase.Origin = 'S2S';
		newTestCase.Status = 'Created';
		CH_ExternalInterfaceUTIL.sendCancelationToExternalSystem(new Map<Id, Case>{testCase.Id => testCase}, new List<Case>{newTestCase});
		Test.stopTest();
		
		logs = [SELECT Id, Name, Comment__c, Interface_Request_Sent__c, Status__c FROM Interface_Log__c];
		System.assert(logs.isEmpty());
	}
	
	@isTest
	private static void sendCancelationToExternalSystemFailureNotificationTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
		Boolean hasError = false;
		try {
			sendCancelationToExternalSystemErrorTest(new NaipS2SErrorWebServiceMock());
		} catch(Exception e) {
			hasError = true;
		}
		System.assert(hasError);
	}
	
	@isTest
	private static void sendCancelationToExternalSystemExternalErrorTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = false;
		Interface_Log__c log = sendCancelationToExternalSystemErrorTest(new NaipS2SErrorWebServiceMock());
		System.assertEquals(log.Comment__c, testBadRqst);
	}
	
	@isTest
	private static void sendCancelationToExternalSystemWebServiceErrorTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = false;
		Interface_Log__c log = sendCancelationToExternalSystemErrorTest(NULL);
		System.assertNotEquals(log.Comment__c, testBadRqst);
	}
	
	private static Interface_Log__c sendCancelationToExternalSystemErrorTest(WebServiceMock naipWebServiceMock) {
		Case testCase = createTestCase();
		insert testCase;
		List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
		System.assert(logs.isEmpty());
		
		Test.startTest();
		if (naipWebServiceMock != NULL) {
			Test.setMock(WebServiceMock.class, naipWebServiceMock);
		}
		
		Case newTestCase = [SELECT Id, Origin, CH_CaseOriginSystem__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		System.assertEquals(newTestCase.Origin, 'S2S');
		System.assertEquals(newTestCase.CH_CaseOriginSystem__c, SWS_Constants.ORANGEIRMA);
		newTestCase.Status = 'Cancelled';
		CH_ExternalInterfaceUTIL.sendCancelationToExternalSystem(new Map<Id, Case>{testCase.Id => testCase}, new List<Case>{newTestCase});
		Test.stopTest();
		
		logs = [SELECT Id, Name, Comment__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		Interface_Log__c log = logs[0];
		System.assert(String.isNotEmpty(log.Comment__c));
		testCase = [SELECT Id, CaseNumber, CH_CaseOriginSystem__c, Reference_Number__c, Origin FROM Case];
		validateLog(log, testCase, 'cancel-case', 'Failure', log.Comment__c, SWS_Constants.CUSTOMERS2S);
		return log;
	}
	
	@isTest
	private static void sendFieldUpdatesToExternalSystemTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
		Case newTestCase = createTestCase();
		newTestCase.CH_Summary__c = 'new test summary to customer';
		newTestCase.CH_CustomerDescription__c = custDescrptn;
		newTestCase.Description = 'new test description';
		insert newTestCase;
		List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
		System.assert(logs.isEmpty());
		
		CH_OutboundMessageSettings__c settings = createOutboundMessageSettings(SWS_Constants.ORANGEIRMA);
		insert settings;
		
		Test.startTest();
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		Case testCase = [SELECT Id, Origin, Severity__c, CH_CaseOriginSystem__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		testCase.CH_Summary__c = 'test summary to customer';
		testCase.CH_CustomerDescription__c = 'test customer description';
		testCase.Description = casedescrptnstr1;  
		System.assertEquals(newTestCase.Origin, 'S2S');
		System.assertEquals(newTestCase.CH_CaseOriginSystem__c, SWS_Constants.ORANGEIRMA);
		CH_ExternalInterfaceUTIL.sendFieldUpdatesToExternalSystem(new Map<Id, Case>{testCase.Id => testCase}, new List<Case>{newTestCase});
		Test.stopTest();
		
		logs = [SELECT Id, Name, Comment__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 2);
		Interface_Log__c summaryToCustomerlog = NULL;
		Interface_Log__c customerDescriptionlog = NULL;
		for (Interface_Log__c log : logs) {
			if (log.Interface_Request_Sent__c.contains(newTestCase.CH_Summary__c)) {
				summaryToCustomerlog = log;
			} else {
				customerDescriptionlog = log;
			}
		}
		
		testCase = [SELECT Id, CaseNumber, CH_CaseOriginSystem__c, Reference_Number__c, Origin FROM Case];
		validateLog(summaryToCustomerlog, testCase, SWS_Constants.CREATEINFOUPDATE, 'Summary to Customer', 'Success', NULL, SWS_Constants.CUSTOMERS2S);
		validateLog(customerDescriptionlog, testCase, SWS_Constants.CREATEINFOUPDATE, custdescrp2, 'Success', NULL, SWS_Constants.CUSTOMERS2S);
	}
	
	@isTest
	private static void sendFieldUpdatesToExternalSystemValidationTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
		Case testCase = createTestCase();
		insert testCase;
		List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
		System.assert(logs.isEmpty());
		
		CH_OutboundMessageSettings__c settings = createOutboundMessageSettings(SWS_Constants.ORANGEIRMA);
		insert settings;
		
		Test.startTest();
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		testCase = [SELECT Id, Origin, CH_CaseOriginSystem__c, CH_CRNumber__c, Description, Severity__c, CH_Summary__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		Case newTestCase = [SELECT Id, Origin, CH_CaseOriginSystem__c, CH_CRNumber__c, Description, Severity__c, CH_Summary__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		System.assertEquals(newTestCase.Origin, 'S2S');
		System.assertEquals(newTestCase.CH_CaseOriginSystem__c, SWS_Constants.ORANGEIRMA);
		
		System.assertEquals(testCase.Subject, newTestCase.Subject);
		System.assertEquals(testCase.Description, newTestCase.Description);
		System.assertEquals(testCase.Severity__c, newTestCase.Severity__c);
		CH_ExternalInterfaceUTIL.sendFieldUpdatesToExternalSystem(new Map<Id, Case>{testCase.Id => testCase}, new List<Case>{newTestCase});
		
		testCase.CH_CRNumber__c = 'test id';
		CH_ExternalInterfaceUTIL.sendFieldUpdatesToExternalSystem(new Map<Id, Case>{testCase.Id => testCase}, new List<Case>{newTestCase});
		
		testCase.Origin = NULL;
		CH_ExternalInterfaceUTIL.sendFieldUpdatesToExternalSystem(new Map<Id, Case>{testCase.Id => testCase}, new List<Case>{newTestCase});
		Test.stopTest();
		
		logs = [SELECT Id, Name, Comment__c, Interface_Request_Sent__c, Status__c FROM Interface_Log__c];
		System.assert(logs.isEmpty());
	}
	
	@isTest
	private static void sendFieldUpdatesToExternalSystemExternalFailureNotificationTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
		Boolean hasError = false;
		try {
			sendFieldUpdatesToExternalSystemErrorTest(new NaipS2SErrorWebServiceMock());
		} catch(Exception e) {
			hasError = true;
		}
		System.assert(hasError);
	}
	
	@isTest
	private static void sendFieldUpdatesToExternalSystemExternalErrorTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = false;
		Interface_Log__c log = sendFieldUpdatesToExternalSystemErrorTest(new NaipS2SErrorWebServiceMock());
		System.assertEquals(log.Comment__c, testBadRqst);
	}
	
	@isTest
	private static void sendFieldUpdatesToExternalSystemWebServiceErrorTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = false;
		Interface_Log__c log = sendFieldUpdatesToExternalSystemErrorTest(NULL);
		System.assertNotEquals(log.Comment__c, testBadRqst);
	}
	
	private static Interface_Log__c sendFieldUpdatesToExternalSystemErrorTest(WebServiceMock naipWebServiceMock) {
		Case newTestCase = createTestCase();
		newTestCase.CH_CustomerDescription__c = custDescrptn;
		insert newTestCase;
		List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
		System.assert(logs.isEmpty());
		
		CH_OutboundMessageSettings__c settings = createOutboundMessageSettings(SWS_Constants.ORANGEIRMA);
		insert settings;
		
		Test.startTest();
		if (naipWebServiceMock != NULL) {
			Test.setMock(WebServiceMock.class, naipWebServiceMock);
		}
		
		Case testCase = [SELECT Id, Origin, Severity__c, CH_CaseOriginSystem__c, CH_Summary__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		System.assertEquals(newTestCase.Origin, 'S2S');
		System.assertEquals(newTestCase.CH_CaseOriginSystem__c, SWS_Constants.ORANGEIRMA);
		testCase.CH_CustomerDescription__c = 'test customer description';
		CH_ExternalInterfaceUTIL.sendFieldUpdatesToExternalSystem(new Map<Id, Case>{testCase.Id => testCase}, new List<Case>{newTestCase});
		Test.stopTest();
		
		logs = [SELECT Id, Name, Comment__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		Interface_Log__c log = logs[0];
		System.assert(String.isNotEmpty(log.Comment__c));
		testCase = [SELECT Id, CaseNumber, CH_CaseOriginSystem__c, CH_Summary__c, CH_CustomerDescription__c, Reference_Number__c, Origin FROM Case];
		validateLog(log, testCase, SWS_Constants.CREATEINFOUPDATE, custdescrp2, 'Failure', log.Comment__c, SWS_Constants.CUSTOMERS2S);
		return log;
	}
	
	@isTest
	private static void sendSeverityUpdatesToExternalSystemTest() {
		Id ProblemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		Case testCase = createTestCase();
		testCase.Subject = 'new test subject';
		testCase.Severity__c = 'Critical';
		testcase.CH_Stage__c = 'Report';
		testCase.Status = 'Created';
		testCase.RecordTypeId = ProblemRecordTypeId;
		testCase.Description = 'new test description';
		insert testCase;
		CH_Problem_RnD_Reference__c rndInteraction = new CH_Problem_RnD_Reference__c(CH_RnD_Direction__c = 'outbound',
																					 CH_RnD_Subject__c = 'Test',
																					 CH_RnD_Interface__c = 'PRONTO',
																					 CH_RnD_Reference__c = 'pronto task id',
																					 CH_RnD_Status__c = 'Completed',
																					 CH_RnD_Type__c = 'Transfer to R&D',
																					 CH_Related_Record__c = testCase.Id,
																					 CH_RnD_Description__c = 'Test Severity Update');
		insert rndInteraction;  
		
		Test.startTest();
		
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);   
		Case newTestCase = [SELECT Id, CaseNumber, Severity__c FROM Case];
		newTestCase.Severity__c = 'Major';
		update newTestCase;   
		CH_ExternalInterfaceUTIL.sendSeverityUpdatesToExternalSystem(new Map<Id, Case>{testCase.Id => testCase}, new List<Case>{newTestCase});   
		Test.stopTest();
		
		List<CH_Problem_RnD_Reference__c> rndInteractionResult = [SELECT Id, CH_RnD_Subject__c, CH_RnD_Error_Message__c, CH_RnD_Type__c from CH_Problem_RnD_Reference__c WHERE CH_RnD_Type__c = 'Severity Change']; 
		System.assertEquals(rndInteractionResult.size(), 1);
		CH_Problem_RnD_Reference__c outboundRndInteraction = rndInteractionResult[0];
		System.assertEquals(outboundRndInteraction.CH_RnD_Subject__c, String.format('Problem {0}: Severity/Priority Change to Major', new List<Object>{newTestCase.CaseNumber}));
		
		testCase = [SELECT Id, CaseNumber, Severity__c, Origin FROM Case];
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		validateRndCreateInformationUpdateLog(logs[0], testCase, SWS_Constants.UPDATEANALYSIS, 'pronto',outboundRndInteraction.CH_RnD_Error_Message__c, String.format(rnDOtbndStr, new List<Object> {outboundRndInteraction.CH_RnD_Type__c, testCase.Id}), rndinrfcStrn1);
	}
	
	//Changes added as a part of NOKIASC-35311
	@isTest
	private static void sendSolutionTargetDateToProntoOrJiraTest() {
		Id ProblemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		Case testCase = createTestCase();
		testCase.Subject = 'new test subject';
		testCase.Severity__c = 'Critical';
		testcase.CH_Stage__c = 'Report';
		testCase.Status = 'Created';
		testCase.RecordTypeId = ProblemRecordTypeId;
		testCase.Description = 'new test description';
		insert testCase;
		CH_Problem_RnD_Reference__c rndInteraction = new CH_Problem_RnD_Reference__c(CH_RnD_Direction__c = 'outbound',
																					 CH_RnD_Subject__c = String.format('Problem {0}: SolutionTargetDate Change to {1} and PausedSinceDate Change to {2}', new List<Object>{testCase.caseNumber, testCase.CH_SolutionTargetDate__c,testCase.CH_PausedSinceDate__c}),
																					 CH_RnD_Interface__c = 'PRONTO',
																					 CH_RnD_Reference__c = 'pronto task id',
																					 CH_RnD_Status__c = 'Completed',
																					 CH_RnD_Type__c = 'Update to R&D',
																					 CH_Related_Record__c = testCase.Id,
																					 CH_RnD_Description__c = 'Update SolutionTargetDate and PausedSinceDate');
		insert rndInteraction;  
		
		Test.startTest();
		
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);   
		Case newTestCase = [SELECT Id, CaseNumber, Severity__c FROM Case];
		newTestCase.Severity__c = 'Major';
		update newTestCase;   
		CH_ExternalInterfaceUTIL.sendSolutionTargetDateToProntoOrJira(testCase.Id,null,null,null,testCase.caseNumber, testCase.CH_Originating_Incident_Number__r.CaseNumber, testCase.CH_CRNumber__c,testCase.CH_RDInterface__c,testCase.Severity__c,'testSubject');   
		Test.stopTest();
		
		List<CH_Problem_RnD_Reference__c> rndInteractionResult = [SELECT Id, CH_RnD_Subject__c, CH_RnD_Error_Message__c, CH_RnD_Type__c from CH_Problem_RnD_Reference__c WHERE CH_RnD_Type__c = 'Update to R&D']; 
		System.assertEquals(rndInteractionResult.size(), 2);
		CH_Problem_RnD_Reference__c outboundRndInteraction = rndInteractionResult[0];
		System.assertEquals(outboundRndInteraction.CH_RnD_Subject__c, String.format('Problem {0}: SolutionTargetDate Change to {1} and PausedSinceDate Change to {2}', new List<Object>{testCase.caseNumber, testCase.CH_SolutionTargetDate__c,testCase.CH_PausedSinceDate__c}));
	}
	
	private static void sendCAPSAttachmentsTest(String rndReference, String rndInterface, String externalInterface) {
		
		CAPS_TestDataUtil.createCustomSettingsData();
		
		Case testCase = createTestCase();
		testCase.CH_CRNumber__c = rndReference;
		insert testCase;
		
		List<CH_Attachment__c> attachments = new List<CH_Attachment__c>();
		attachments.addAll(CAPS_TestDataUtil.createCHAttachmentRecord(1, otherinfoStr, testCase.Id));
		attachments.addAll(CAPS_TestDataUtil.createCHAttachmentRecord(2, 'Service Provider End User Information', testCase.Id));
		insert attachments;
		
		Test.startTest();
		NaipUpdateAnalysisWebServiceMock naipWebServiceMock = new NaipUpdateAnalysisWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		Id outboundRndInteractionId = CH_AttachmentUtils.shareWithRND(testCase.Id, rndInterface, emalsubstr, casedescrptnstr1, 'test comment', new List<CH_Attachment__c>{attachments[0], attachments[1]});
		System.assertNotEquals(outboundRndInteractionId, NULL);
		CH_Problem_RnD_Reference__c outboundRndInteraction = validateRndInteraction(outboundRndInteractionId, emalsubstr, casedescrptnstr1, 'test comment', rndInterface, testCase.Id, rndReference, 'outbound', updateToRnDStr);
		
		testCase = [SELECT Id, CaseNumber, Severity__c, Origin FROM Case];
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		validateRndUpdateAnalysisLog(logs[0], testCase, new List<CH_Attachment__c> {attachments[0], attachments[1]}, SWS_Constants.UPDATEANALYSIS, externalInterface, outboundRndInteraction.CH_RnD_Error_Message__c, String.format(rnDOtbndStr, new List<Object> {outboundRndInteraction.CH_RnD_Type__c, testCase.Id}), rndinrfcStrn1);
		Test.stopTest();
	}
	
	@isTest
	private static void sendOutboundCreateAnalysisRndInteractionTestTest() {
		sendOutboundCreateAnalysisRndInteractionTest(testJiraIdStr, 'JIRA');   
	}
	@isTest
	private static void sendOutboundCreateAnalysisRndInteractionProntoTest() {  
		sendOutboundCreateAnalysisRndInteractionTest(testProntoId, 'PRONTO');
	}
	private static void sendOutboundCreateAnalysisRndInteractionTest(String rndReference, String rndInterface) {
		
		CAPS_TestDataUtil.createCustomSettingsData();
		
		Case testCase = createTestCase();
		testCase.CH_CRNumber__c = rndReference;
		insert testCase;
		
		List<CH_Attachment__c> attachments = new List<CH_Attachment__c>();
		attachments.addAll(CAPS_TestDataUtil.createCHAttachmentRecord(1, otherinfoStr, testCase.Id));
		attachments.addAll(CAPS_TestDataUtil.createCHAttachmentRecord(2, 'Service Provider End User Information', testCase.Id));
		insert attachments;
		
		Test.startTest();
		NaipUpdateAnalysisWebServiceMock naipWebServiceMock = new NaipUpdateAnalysisWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		Id outboundRndInteractionId = CH_AttachmentUtils.shareWithRND(testCase.Id, rndInterface, emalsubstr, casedescrptnstr1, 'test comment', new List<CH_Attachment__c>{attachments[0], attachments[1]});
		System.assertNotEquals(outboundRndInteractionId, NULL);
		
		CH_ExternalInterfaceUTIL.sendOutboundCreateAnalysisRndInteraction(outboundRndInteractionId);
		
		Test.stopTest();
	}
	
	@isTest
	private static void sendProntoOutboundRndInteractionTest() {
		Case testCase = createTestCase();
		testCase.CH_CRNumber__c = testProntoId;
		insert testCase;
		
		Test.startTest();
		
		Id outboundRndInteractionId = CH_AttachmentUtils.shareWithRND(testCase.Id, 'PRONTO', emalsubstr, casedescrptnstr1, 'test comment', new List<CH_Attachment__c>());
		System.assertNotEquals(outboundRndInteractionId, NULL);
		CH_Problem_RnD_Reference__c outboundRndInteraction = validateRndInteraction(outboundRndInteractionId, emalsubstr, casedescrptnstr1, 'test comment', 'PRONTO', testCase.Id, testProntoId, 'outbound', updateToRnDStr);
		
		CH_ExternalInterfaceUTIL.sendProntoOutboundRndInteraction(outboundRndInteraction);
		
		Test.stopTest();
	}
	
	@isTest
	private static void resendOutboundRndInteractionTest(){
		Case testCase = createTestCase();
		testCase.CH_CRNumber__c = testProntoId;
		insert testCase;
		
		Test.startTest();
		
	Id outboundRndInteractionId = CH_AttachmentUtils.shareWithRND(testCase.Id, 'PRONTO', emalsubstr, casedescrptnstr1, 'test comment', new List<CH_Attachment__c>());
		System.assertNotEquals(outboundRndInteractionId, NULL);
		CH_Problem_RnD_Reference__c outboundRndInteraction = validateRndInteraction(outboundRndInteractionId, emalsubstr, casedescrptnstr1, 'test comment', 'PRONTO', testCase.Id, testProntoId, 'outbound', updateToRnDStr);
		
		CH_ExternalInterfaceUTIL.resendOutboundRndInteraction(outboundRndInteraction);
		
		Test.stopTest();  
	}
	
	@IsTest
	private static void sendAttachmentIdTest() {
		CAPS_TestDataUtil.createCustomSettingsData();
		
		String attachmentId;
		Case testCase = createTestCase();
		insert testCase;
		
		List<CH_Attachment__c> attachments = new List<CH_Attachment__c>();
		attachments.addAll(CAPS_TestDataUtil.createCHAttachmentRecord(1, otherinfoStr, testCase.Id));
		insert attachments;
		
		for(CH_Attachment__c attachment : attachments){
			attachmentId = attachment.Id;
		}
		
		Test.startTest();
		
		CH_ExternalInterfaceUTIL.sendAttachmentId(testCase.Id, testCase.CaseNumber, 'ogange-irma', testCase.Reference_Number__c, 'TEST Attachment', attachmentId, 'Test Attacment', 100, 'txt');
		
		Test.stopTest();
	}
	
	@IsTest
	private static void createEntitlementContactsIfNotExistingTest(){
		Id legalEntityAccountId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		CH_UTIL_TEST.createS2SAccounts('test1','test2','test3');
		Account testAccount = [SELECT Id FROM Account WHERE RecordTypeId =:legalEntityAccountId];
		Product2 testProduct = [SELECT Id FROM Product2 WHERE Name = 'Test Product 1'];
		Asset testAsset = CH_UTIL_TEST.createS2SAsset('12346|234|12348|12350|12352|12354', testAccount.Id);
		Test.startTest();
		insert testAsset;
		CH_EntitlementTestData.createS2SEntitlement('testEntitlement', testAsset.Id, testAccount.Id, testProduct.Id, '56478', 'Legacy Customer Support Service - Critical Major Minor 24x7', false);
		Case testCase = CH_UTIL_TEST.getS2SCase();
		
		Map<Id, Account> accMap = new Map<Id, Account>();
		List<Case> newCaseS2SList = new List<Case>();
		newCaseS2SList.add(testCase);
		CH_ExternalInterfaceUTIL.createEntitlementContactsIfNotExisting(newCaseS2SList,accMap, new Map<Id, Entitlement>());
		
		Test.stopTest();
	}
	
	@IsTest
	private static void createCaseContactIfNotExistingTest(){
		CAPS_TestDataUtil.createCustomSettingsData();
		Map<Id, Account> accountsMap = new Map<Id, Account>();
		Set<Id> accountId = new Set<Id>();
		
		Case testCaseNew = createTestCase();
		insert testCaseNew; 
		
		Test.startTest();
		
		List<Case> newCaseList = [SELECT Id, Origin, CH_CaseOriginSystem__c, CH_Email2__c, AccountId, CH_CustomerDescription__c, SEC_Last_Name__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		
		for(Case c : newCaseList){
			accountId.add(c.AccountId); 
		}  
		
		List<Account> newAccountList = [SELECT Id FROM Account WHERE Id =: accountId];
		
		for(Account a : newAccountList){
			accountsMap.put(a.Id, a); 
		}
		
		CH_ExternalInterfaceUTIL.createCaseContactIfNotExisting(newCaseList, accountsMap);
		
		Test.stopTest();
	}
	
	@IsTest
	private static void createInboundCustomerS2SInterfaceLogTest(){
		Test.startTest();
		
		CH_ExternalInterfaceUTIL.createInboundCustomerS2SInterfaceLog('LogName Test', 'Request Test', 'Comment Test', 'Update');
		
		Test.stopTest();
	}
	
	@IsTest
	private static void createInboundRndInterfaceLogTest(){
		Test.startTest();
		
		CH_ExternalInterfaceUTIL.createInboundRndInterfaceLog('LogName Test', 'Request Test', 'Comment Test', 'Update');
		
		Test.stopTest();
	}
	
	@IsTest
	private static void updatedFromExternalInterfaceTest(){
		CAPS_TestDataUtil.createCustomSettingsData();
		Map<Id, Case> oldCases = new Map<Id, Case>();
		Case testCaseOld = createTestCase();
		insert testCaseOld; 
		
		Test.startTest();
		
		List<Case> oldCaseList = [SELECT Id, Origin, OwnerId, CH_CaseOriginSystem__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		
		for(Case c : oldCaseList){
			oldCases.put(c.Id, c);
		}  
		
		Case testCaseNew = createTestCase();
		insert testCaseNew;   
		
		List<Case> newCaseList = [SELECT Id, Origin, OwnerId, CH_CaseOriginSystem__c, CH_CustomerDescription__c, Subject, Status, CaseNumber, CreatedDate, Reference_Number__c FROM Case];
		
		CH_ExternalInterfaceUTIL.updatedFromExternalInterface(oldCases, newCaseList);
		
		Test.stopTest();
	}
	
	@isTest
	private static void sendProntoCAPSAttachmentsTest() {
		sendCAPSAttachmentsTest(testProntoId, 'PRONTO', 'pronto');
	}
	
	@isTest
	private static void sendJiraCAPSAttachmentsTest() {
		sendCAPSAttachmentsTest(testJiraIdStr, 'JIRA', testJiraBridge);
	}
	
	private static void sendCAPSAttachmentsErrorTest(String rndReference, String rndInterface, String externalInterface, String subject) {
		Case testCase = createTestCase();
		testCase.CH_CRNumber__c = rndReference;
		insert testCase;
		
		Test.startTest();
		NaipUpdateAnalysisWebServiceMock naipWebServiceMock = new NaipUpdateAnalysisWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		Id outboundRndInteractionId = CH_AttachmentUtils.shareWithRND(testCase.Id, rndInterface, subject, casedescrptnstr1, 'test comment', new List<CH_Attachment__c>());
		System.assertNotEquals(outboundRndInteractionId, NULL);
		CH_Problem_RnD_Reference__c outboundRndInteraction = validateRndInteraction(outboundRndInteractionId, subject, casedescrptnstr1, 'test comment', rndInterface, testCase.Id, rndReference, 'outbound', updateToRnDStr);
		System.assert(String.IsNotEmpty(outboundRndInteraction.CH_RnD_Error_Message__c));
		System.assertEquals(outboundRndInteraction.CH_RnD_Error_Message__c, testBadRqst);
		
		testCase = [SELECT Id, CaseNumber, Severity__c, Origin FROM Case];
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		validateRndUpdateAnalysisLog(logs[0], testCase, NULL, SWS_Constants.UPDATEANALYSIS, externalInterface,outboundRndInteraction.CH_RnD_Error_Message__c, String.format(rnDOtbndStr, new List<Object> {outboundRndInteraction.CH_RnD_Type__c, testCase.Id}), rndinrfcStrn1);  
		Test.stopTest();
	}
	
	@isTest
	private static void sendProntoCAPSAttachmentsErrorTest() {
		sendCAPSAttachmentsErrorTest(testProntoId, 'PRONTO', 'pronto', emalsubstr);
	}
	
	@isTest
	public static void sendJiraCAPSAttachmentsErrorTest() {
		sendCAPSAttachmentsErrorTest(testJiraIdStr, 'JIRA', testJiraBridge, NULL);
	}
	
	@isTest
	public static void sendCAPSAttachmentsWebServiceErrorTest() {
		Case testCase = createTestCase();
		testCase.CH_CRNumber__c = testProntoId;
		insert testCase;
		
		Test.startTest();
		
		Id outboundRndInteractionId = CH_AttachmentUtils.shareWithRND(testCase.Id, 'PRONTO', emalsubstr, casedescrptnstr1, 'test comment', new List<CH_Attachment__c>());
		System.assertNotEquals(outboundRndInteractionId, NULL);
		CH_Problem_RnD_Reference__c outboundRndInteraction = validateRndInteraction(outboundRndInteractionId, emalsubstr, casedescrptnstr1, 'test comment', 'PRONTO', testCase.Id, testProntoId, 'outbound', updateToRnDStr);
		System.assert(String.IsNotEmpty(outboundRndInteraction.CH_RnD_Error_Message__c));   
		System.assertNotEquals(outboundRndInteraction.CH_RnD_Error_Message__c, testBadRqst);
		
		testCase = [SELECT Id, CaseNumber, Severity__c, Origin FROM Case];
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		validateRndUpdateAnalysisLog(logs[0], testCase, NULL, SWS_Constants.UPDATEANALYSIS, 'pronto',logs[0].Comment__c, String.format(rnDOtbndStr, new List<Object> {outboundRndInteraction.CH_RnD_Type__c, testCase.Id}), rndinrfcStrn1);
		Test.stopTest();
	}
	
	@isTest
	public static void testRejectInvalidS2SCasesSuccess() {
		Case testCase = createTestCase();
		testCase.Reference_Number__c = 'test-123';
		insert testCase;
		
		Test.startTest();
		CH_ExternalInterfaceUTIL.rejectInvalidS2SCases(new List<Case>{testCase});
		System.assert(CH_ExternalInterfaceUTIL.casesWithErrors.size() == 0, 'errors set is not empty');
		Test.stopTest();
	}
	
	@isTest
	public static void testRejectInvalidS2SCasesFailure() {
		Case testCase = createTestCase();
		testCase.Reference_Number__c = null;
		insert testCase;
		
		Test.startTest();
		CH_ExternalInterfaceUTIL.rejectInvalidS2SCases(new List<Case>{testCase});
		System.assert(CH_ExternalInterfaceUTIL.casesWithErrors.size() == 1, 'errors set is empty');
		Test.stopTest();
	}
	
	@isTest
	public static void testIsolateNewS2SCasesToMap() {
		System.assert(CH_Integration_Profiles__c.getAll().size() == 0, 'resultForNonIntegrationProfile should be 0');
		
		Case testCase = new Case(Origin = 'S2S');
		
		List<Case> resultForNonIntegrationProfile = CH_CaseTriggerHandler.isolateNewS2SCasesToMap(new List<Case>{testCase});
		System.assert(resultForNonIntegrationProfile.size() == 0, 'resultForNonIntegrationProfile should be 0');
		
		String uniqueUserName = 'admin' + DateTime.now().getTime() + '@testorg.com';
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
		User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
						  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
						  LocaleSidKey='en_US', ProfileId = p.Id,
						  TimeZoneSidKey='America/Los_Angeles',
						  UserName=uniqueUserName);
		
		CH_Integration_Profiles__c integrationProfileSetting = new CH_Integration_Profiles__c(name = 'System Administrator');
		insert integrationProfileSetting;
		
		List<Case> resultForIntegrationProfile = new List<Case>();
		
		Test.startTest();
		System.runAs(u) {
			resultForIntegrationProfile = CH_CaseTriggerHandler.isolateNewS2SCasesToMap(new List<Case>{testCase});
		}
		Test.stopTest();
	}
	
	@isTest
	public static void testFilterS2SCasesWOriginSystem() {
		Case testCase = new Case(Origin = 'S2S');
		System.assert(CH_ExternalInterfaceUTIL.filterS2SCasesWOriginSystem(new List<Case>{testCase}).size() == 0);
		
		testCase = new Case(Origin = 'S2S', CH_CaseOriginSystem__c = 'ogange-irma');
		System.assert(CH_ExternalInterfaceUTIL.filterS2SCasesWOriginSystem(new List<Case>{testCase}).size() == 1);
	}
	
	@isTest
	private static void insertCaseCommentNotificationTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
		Case testCase = createTestCase();
		insert testCase;
		
		List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
		System.assert(logs.isEmpty());
		
		CH_OutboundMessageSettings__c settings = createOutboundMessageSettings(SWS_Constants.ORANGEIRMA);
		insert settings;
		
		Test.startTest();
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		List<CaseComment> comments = new List<CaseComment>();
		CaseComment comment1 = new CaseComment(ParentId = testCase.Id, IsPublished = true, CommentBody = 'test comment1');
		comments.add(comment1);
		CaseComment comment2 = new CaseComment(ParentId = testCase.Id, IsPublished = true, CommentBody = 'test comment2');
		comments.add(comment2);
		comments.add(new CaseComment(ParentId = testCase.Id, IsPublished = false, CommentBody = 'test comment3'));
		insert comments;
		Test.stopTest();
		
		logs = [SELECT Id, Name, Comment__c, Operation_Type__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 2);
		Interface_Log__c comment1Log = NULL;
		Interface_Log__c comment2Log = NULL;
		for (Interface_Log__c log : logs) {
			if (log.Interface_Request_Sent__c.contains(comment1.CommentBody)) {
				comment1Log = log;
			}
			if (log.Interface_Request_Sent__c.contains(comment2.CommentBody)) {
				comment2Log = log;
			} 
		}
		
		testCase = [SELECT Id, CaseNumber, CH_CaseOriginSystem__c, Reference_Number__c, Origin FROM Case];
		validateInsertCaseCommentNotificationLog(comment1Log, testCase, comment1);
		validateInsertCaseCommentNotificationLog(comment2Log, testCase, comment2);
	}
	
	@isTest
	private static void deleteCaseCommentNotificationTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
		Case testCase = createTestCase();
		insert testCase;
		
		List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
		System.assert(logs.isEmpty());
		
		List<CaseComment> comments = new List<CaseComment>();
		CaseComment comment1 = new CaseComment(ParentId = testCase.Id, IsPublished = true, CommentBody = 'test comment1');
		comments.add(comment1);
		CaseComment comment2 = new CaseComment(ParentId = testCase.Id, IsPublished = true, CommentBody = 'test comment2');
		comments.add(comment2);
		comments.add(new CaseComment(ParentId = testCase.Id, IsPublished = false, CommentBody = 'test comment3'));
		insert comments;
		
		CH_OutboundMessageSettings__c settings = createOutboundMessageSettings(SWS_Constants.ORANGEIRMA);
		insert settings;
		
		Test.startTest();
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		delete comments;
		Test.stopTest();
		
		logs = [SELECT Id, Name, Comment__c, Operation_Type__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 2);
		Interface_Log__c comment1Log = NULL;
		Interface_Log__c comment2Log = NULL;
		for (Interface_Log__c log : logs) {
			if (log.Interface_Request_Sent__c.contains(comment1.CommentBody)) {
				comment1Log = log;
			}
			if (log.Interface_Request_Sent__c.contains(comment2.CommentBody)) {
				comment2Log = log;
			} 
		}
		
		testCase = [SELECT Id, CaseNumber, CH_CaseOriginSystem__c, Reference_Number__c, Origin FROM Case];
		validateDeleteCaseCommentNotificationLog(comment1Log, testCase, comment1);
		validateDeleteCaseCommentNotificationLog(comment2Log, testCase, comment2);
	}
	
	@isTest
	private static void noCaseOriginCaseCommentNotificationValidationTest() {
		
		
		Boolean hasError = false;
		try {
			CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
			Case testCase = createTestCase();
			testCase.CH_CaseOriginSystem__c = NULL;
			insert testCase;
			
			CH_OutboundMessageSettings__c settings = createOutboundMessageSettings(SWS_Constants.ORANGEIRMA);
			insert settings;
			
			caseCommentNotificationValidationTest(testCase);
		} catch(Exception e) {
			hasError = true;
		}
		System.assert(hasError);
	}
	
	@isTest
	private static void noOutboundMessageSettingsCaseCommentNotificationValidationTest() {
		CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
		Case testCase = createTestCase();
		insert testCase;
		
		caseCommentNotificationValidationTest(testCase);
	}
	
	private static void caseCommentNotificationValidationTest(Case testCase) {
		Test.startTest();
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		List<CaseComment> comments = new List<CaseComment>();
		CaseComment comment1 = new CaseComment(ParentId = testCase.Id, IsPublished = true, CommentBody = 'test comment1');
		comments.add(comment1);
		CaseComment comment2 = new CaseComment(ParentId = testCase.Id, IsPublished = true, CommentBody = 'test comment2');
		comments.add(comment2);
		comments.add(new CaseComment(ParentId = testCase.Id, IsPublished = false, CommentBody = 'test comment3'));
		insert comments;
		Test.stopTest();
		
		List<Interface_Log__c> logs = [SELECT Id FROM Interface_Log__c];
		System.assert(logs.isEmpty());
	}
	
	public class NaipS2SSuccessWebServiceMock implements WebServiceMock {
		public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType) {
				CH_partnerNAIPWSDLForSF.receiveFromSalesForceResponse receivFromSfResponse = new CH_partnerNAIPWSDLForSF.receiveFromSalesForceResponse();
				CH_partnerNAIPWSDLForSF.responseToSalesForce responseToSf = new CH_partnerNAIPWSDLForSF.responseToSalesForce();
				receivFromSfResponse.responseToSalesForce = responseToSf;
				response.put('response_x', receivFromSfResponse);
			}
	}
	
	public class NaipS2SErrorWebServiceMock implements WebServiceMock {
		public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType) {
				CH_partnerNAIPWSDLForSF.receiveFromSalesForceResponse receivFromSfResponse = new CH_partnerNAIPWSDLForSF.receiveFromSalesForceResponse();
				CH_partnerNAIPWSDLForSF.responseToSalesForce responseToSf = new CH_partnerNAIPWSDLForSF.responseToSalesForce();
				responseToSf.message = testBadRqst;
				receivFromSfResponse.responseToSalesForce = responseToSf;
				response.put('response_x', receivFromSfResponse);
			}
	}
	
	public class NaipUpdateAnalysisWebServiceMock implements WebServiceMock {
		public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType) {
				CH_partnerNAIPWSDLForSF.receiveFromSalesForceResponse receivFromSfResponse = new CH_partnerNAIPWSDLForSF.receiveFromSalesForceResponse();
				CH_partnerNAIPWSDLForSF.responseToSalesForce responseToSf = new CH_partnerNAIPWSDLForSF.responseToSalesForce();
				
				CH_partnerNAIPWSDLForSF.receiveFromSalesForce naipRequest = (CH_partnerNAIPWSDLForSF.receiveFromSalesForce) request;
				if (naipRequest.Case_x != NULL && naipRequest.RndInteraction != NULL && 
					naipRequest.Case_x.sObjects.Severity_xc == 'Minor' && 
					naipRequest.RndInteraction.Type_x == SWS_Constants.UPDATEANALYSIS && 
					((naipRequest.RndInteraction.Interface_x == 'pronto' && naipRequest.Attachment != NULL && naipRequest.Attachment.sObjects.size() == 2) ||
					 (naipRequest.RndInteraction.Interface_x == testJiraBridge && naipRequest.Attachment == NULL && !String.isEmpty(naipRequest.RndInteraction.Subject)))) {
						 responseToSf.message = NULL;
					 } else {
						 responseToSf.message = testBadRqst;
					 }
				receivFromSfResponse.responseToSalesForce = responseToSf;
				response.put('response_x', receivFromSfResponse);
			}
	}
}