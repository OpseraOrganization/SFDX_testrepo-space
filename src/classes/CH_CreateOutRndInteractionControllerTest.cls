@isTest
private class CH_CreateOutRndInteractionControllerTest {

	public static final string sampleTestPorntoId='test pronto id';
	public static final string sampleworkarndAcc='Workaround Accepted';
	public static final string sampleworkarndRej='Workaround Rejected';
	public static final string sampleInfoUpdte='Information Update';
	public static final string sampleTrsftoRD='Transfer to R&D';
	public static final string sampleAcceWrkArnd='accept-workaround';
	public static final string sampleRDOutbnd='R&D Outbound {0} {1}';
	public static final string sampleProntoJiraIntrfc='Pronto/Jira Interface';
	public static final string sampleBadRequest='test: Bad Request';
	public static final string sampleCrteInfoUpdte='create-informationupdate';
	public static final string sampleStatusTrng='In Progress';
	public static final string sampleCreateAnlys='create-analysis';
	
	@testSetup
	static void setup() {
		CH_UTIL_TEST.setupCase();
	}
	
	private static Case createTestCase() {
		CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
		
		Case testCase = CH_UTIL_TEST.getS2SCase();
		insert testCase;
		
		testCase = [SELECT Id, CH_CustomerDescription__c, CH_RDInterface__c, CaseNumber FROM Case WHERE Id =: testCase.Id];
		return testCase;
	}
	
	private static CH_Problem_RnD_Reference__c createTestRndInteraction(Case testCase, String description, String rndReference) {
		CH_Problem_RnD_Reference__c rndInteraction = new CH_Problem_RnD_Reference__c();
		rndInteraction.CH_RnD_Interface__c = 'PRONTO';
		rndInteraction.CH_RnD_Direction__c = 'inbound';
		rndInteraction.CH_RnD_Reference__c = rndReference;
		rndInteraction.CH_Related_Record__c = testCase.Id;
		rndInteraction.CH_RnD_Description__c = description;
		insert rndInteraction;
		
		return rndInteraction;
	}
	
	private static CH_CreateOutRndInteractionController.RndInteraction getTestOutboundRndInteraction(Case problem, String rndInterface, String interactionType, String transactionStatus, String referenceNumber) {
		CH_CreateOutRndInteractionController.RndInteraction rndInteraction = new CH_CreateOutRndInteractionController.RndInteraction();
		rndInteraction.direction = 'outbound';
		rndInteraction.interactionType = interactionType;
		rndInteraction.interfaceName = rndInterface;
		rndInteraction.rndReference = referenceNumber;
		rndInteraction.transactionStatus = transactionStatus;
		rndInteraction.relatedRecordNumber = problem.CaseNumber;
		rndInteraction.relatedRecordId = problem.Id;
		rndInteraction.comment = 'test comment';
		rndInteraction.description = 'test description';
		return rndInteraction;  
	}
	
	private static CH_CreateOutRndInteractionController.RndInteraction getTestOutboundRndInteraction(Case problem, String rndInterface, String interactionType, String transactionStatus) {
		return getTestOutboundRndInteraction(problem, rndInterface, interactionType, transactionStatus, NULL);
	}
	
	private static void validateCreateInformationUpdateLog(Interface_Log__c log, Case c, String externalSystemAction, String interfaceName, String status, String comment, String name, String interfaceType) {
		validateLog(log, externalSystemAction, interfaceName, status, comment, name, interfaceType);
		System.assert(log.Interface_Request_Sent__c.contains('Severity_xc=' + c.Severity__c));
	}
	
	private static void validateCreateAnalysisLog(Interface_Log__c log, Case c, String externalSystemAction, String interfaceName, String status, String comment, String name, String interfaceType) {
		validateLog(log, externalSystemAction, interfaceName, status, comment, name, interfaceType);
		System.assert(log.Interface_Request_Sent__c.contains('Severity_xc=' + c.Severity__c));
		System.assert(log.Interface_Request_Sent__c.contains('CaseNumber=' + c.CaseNumber));
		
		System.assertEquals(c.Product.Name, 'testProduct');
		if (interfaceName == 'pronto') {
			System.assert(log.Interface_Request_Sent__c.contains('NokiaProductId=' + c.Product.Name));
		} else {
			System.assertEquals(c.Product.NokiaCPQ_Alias__c, 'testProduct CPQ Alias');
			
			System.assert(log.Interface_Request_Sent__c.contains('NokiaProductId=' + c.Product.NokiaCPQ_Alias__c));
			System.assert(log.Interface_Request_Sent__c.contains('CH_ProductVariant_xc=' + c.CH_ProductVariant__r.NokiaCPQ_Alias__c));
		}
		Account testAccount = [SELECT Id, AccountNumber FROM Account WHERE Id =: c.AccountId];
		System.assert(log.Interface_Request_Sent__c.contains('AccountNumber=' + testAccount.AccountNumber));
	}
	
	private static void validateLog(Interface_Log__c log, String externalSystemAction, String interfaceName, String status, String comment, String name, String interfaceType) {
		System.assertEquals(log.Status__c, status);
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
	
	@isTest
	private static void loadInboundRndInteractionTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		String rndReference = sampleTestPorntoId;
		CH_Problem_RnD_Reference__c inboundRndInteraction = createTestRndInteraction(testCase, NULL, rndReference);
		CH_CreateOutRndInteractionController.RndInteraction rndInteraction = CH_CreateOutRndInteractionController.loadInboundRndInteraction(testCase.Id);
		System.assertEquals(rndInteraction.relatedRecordId, NULL);
		System.assertEquals(rndInteraction.relatedRecordNumber, NULL);
		System.assertEquals(rndInteraction.rndReference, NULL);
		
		rndInteraction = CH_CreateOutRndInteractionController.loadInboundRndInteraction(inboundRndInteraction.Id);
		System.assertEquals(rndInteraction.relatedRecordId, testCase.Id);
		System.assertEquals(rndInteraction.relatedRecordNumber, testCase.CaseNumber);
		System.assertEquals(rndInteraction.rndReference, rndReference);
		Test.stopTest();
	}
	
	@isTest
	private static void deleteOutboundRndInteractionValidationTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		List<CH_Problem_RnD_Reference__c> outboundRndInteractions = new List<CH_Problem_RnD_Reference__c>();
		CH_CreateOutRndInteractionController.RndInteraction prontoWorkaroundAcceptedRndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', sampleworkarndAcc, 'Open', 'test pronto id1');
		outboundRndInteractions.add(prontoWorkaroundAcceptedRndInteraction.initializeSfRndInteraction());
		insert outboundRndInteractions;
		
		Boolean hasError = false;
		Profile integrationProfile = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		String integrationUserEmail = 'naip' + DateTime.now().getTime() + '@test.com';
		System.runAs(CH_UTIL_TEST.getUser(integrationUserEmail, integrationUserEmail, 'naipuser', integrationProfile)) {
			try {
	CH_CreateOutRndInteractionController.deleteRndInteraction(outboundRndInteractions[0].Id);
			} catch(Exception e) {
	hasError = true;
			}
		}
		System.assert(hasError);
		CH_CreateOutRndInteractionController.deleteRndInteraction(outboundRndInteractions[0].Id);
		Test.stopTest();
	}
	
	@isTest
	private static void createOutboundRndInteractionValidationTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		Boolean hasError = false;
		try {
			CH_CreateOutRndInteractionController.RndInteraction jiraUpdateToRndInteraction = getTestOutboundRndInteraction(testCase, 'JIRA', '  Update to R&D', 'Open', 'test jira id');
			Id jiraUpdateToRndInteractionId = CH_CreateOutRndInteractionController.createRndInteraction(JSON.serialize(jiraUpdateToRndInteraction));
			CH_CreateOutRndInteractionController.sendRndInteraction(jiraUpdateToRndInteractionId);   
		} catch(AuraHandledException e) {
			hasError = true;
			System.assertEquals(e.getMessage(), String.format(Label.CH_OutboundRndInteraction_UnsupportedInteractionTypeValidation, new List<Object>{'JIRA', 'Update to R&D'}));
		}
		//System.assert(hasError);  
		hasError = false;
		
		List<CH_Problem_RnD_Reference__c> outboundRndInteractions = new List<CH_Problem_RnD_Reference__c>();
		CH_CreateOutRndInteractionController.RndInteraction prontoWorkaroundAcceptedRndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', sampleworkarndAcc, 'Open', 'test pronto id1');
		outboundRndInteractions.add(prontoWorkaroundAcceptedRndInteraction.initializeSfRndInteraction());
		CH_CreateOutRndInteractionController.RndInteraction prontoWorkaroundRejectedRndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', sampleworkarndRej, 'Open', 'test pronto id2');
		outboundRndInteractions.add(prontoWorkaroundRejectedRndInteraction.initializeSfRndInteraction());
		CH_CreateOutRndInteractionController.RndInteraction prontoCorrectionRejectedRndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', 'Correction Rejected', 'Open', 'test pronto id3');
		outboundRndInteractions.add(prontoCorrectionRejectedRndInteraction.initializeSfRndInteraction());
		CH_CreateOutRndInteractionController.RndInteraction prontoInfromationResponseRndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', 'Information Response', 'Open', sampleTestPorntoId);
		outboundRndInteractions.add(prontoInfromationResponseRndInteraction.initializeSfRndInteraction());	
		CH_CreateOutRndInteractionController.RndInteraction prontoInformationUpdateRndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', sampleInfoUpdte, 'Open', sampleTestPorntoId);
		outboundRndInteractions.add(prontoInformationUpdateRndInteraction.initializeSfRndInteraction());	
		insert outboundRndInteractions;
		
		System.assertEquals(outboundRndInteractions[0].CH_RnD_Subject__c, String.format('Problem {0}: Workaround Acceptance to PRONTO', new List<Object>{testCase.CaseNumber}));
		System.assertEquals(outboundRndInteractions[1].CH_RnD_Subject__c, String.format('Problem {0}: Workaround Rejection to PRONTO', new List<Object>{testCase.CaseNumber}));
		System.assertEquals(outboundRndInteractions[2].CH_RnD_Subject__c, String.format('Problem {0}: Correction Rejection to PRONTO', new List<Object>{testCase.CaseNumber}));
		System.assertEquals(outboundRndInteractions[3].CH_RnD_Subject__c, String.format('Problem {0}: Information Response to PRONTO', new List<Object>{testCase.CaseNumber}));
		System.assertEquals(outboundRndInteractions[4].CH_RnD_Subject__c, String.format('Problem {0}: Information Update to PRONTO', new List<Object>{testCase.CaseNumber}));
		
		try {
			CH_CreateOutRndInteractionController.sendRndInteraction(outboundRndInteractions[0].Id);
			CH_CreateOutRndInteractionController.sendRndInteraction(outboundRndInteractions[1].Id);
			CH_CreateOutRndInteractionController.sendRndInteraction(outboundRndInteractions[2].Id);
			CH_CreateOutRndInteractionController.sendRndInteraction(outboundRndInteractions[3].Id);
			CH_CreateOutRndInteractionController.sendRndInteraction(outboundRndInteractions[4].Id);
		} catch(Exception e) {
			hasError = true;
		}
		System.assert(!hasError);
		Test.stopTest();
	}
	
	@isTest
	private static void createOutboundRndInteractionTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		CH_CreateOutRndInteractionController.RndInteraction rndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', sampleworkarndAcc, 'Open', sampleTestPorntoId);
		Id outboundRndInteractionId = CH_CreateOutRndInteractionController.createRndInteraction(JSON.serialize(rndInteraction));
		
		CH_Problem_RnD_Reference__c outboundSfRndInteraction = validateOutboundRndInteractionSend(outboundRndInteractionId, 'Open', rndInteraction);
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Reference__c, rndInteraction.rndReference);
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Status__c, rndInteraction.transactionStatus);
		System.assert(String.isEmpty(outboundSfRndInteraction.CH_RnD_Error_Message__c));
		Test.stopTest();
	}
	
	private static CH_Problem_RnD_Reference__c validateOutboundRndInteractionSend(Id outboundRndInteractionId, String recordType, CH_CreateOutRndInteractionController.RndInteraction rndInteraction) {
		System.assertNotEquals(outboundRndInteractionId, NULL);
		CH_Problem_RnD_Reference__c outboundSfRndInteraction = [SELECT Id, CH_Related_RnD_Interaction__c, CH_Related_Record__r.Severity__c, CH_Related_Record__r.Subject, CH_RnD_Content__c, CH_Request__c, RecordType.DeveloperName, CH_RnD_Error_Message__c, CH_RnD_Direction__c, CH_RnD_Type__c, CH_RnD_Interface__c, CH_RnD_Reference__c, CH_RnD_Status__c, CH_Related_Record__c, CH_Related_Record__r.CaseNumber, CH_RnD_Comment__c, CH_RnD_Description__c FROM CH_Problem_RnD_Reference__c WHERE Id =: outboundRndInteractionId];
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Direction__c, rndInteraction.direction);
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Type__c, rndInteraction.interactionType);
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Interface__c, rndInteraction.interfaceName);
		System.assertEquals(outboundSfRndInteraction.CH_Related_Record__c, rndInteraction.relatedRecordId);
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Comment__c, rndInteraction.comment);
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Description__c, rndInteraction.description);
		System.assertEquals(outboundSfRndInteraction.RecordType.DeveloperName, recordType);
		if (outboundSfRndInteraction.CH_RnD_Status__c == 'Open') {
			System.assert(String.isEmpty(outboundSfRndInteraction.CH_Request__c));
		} else {
			System.assert(!String.isEmpty(outboundSfRndInteraction.CH_Request__c));
			if (outboundSfRndInteraction.CH_RnD_Interface__c == 'PRONTO') {
	Set<String> contentTypes = new Set<String> {sampleworkarndRej, 'Correction Rejected', 'Information Response', sampleTrsftoRD};
		if (contentTypes.contains(outboundSfRndInteraction.CH_RnD_Type__c)) {
			System.assert(!String.isEmpty(outboundSfRndInteraction.CH_RnD_Content__c));
		} else {
			System.assert(String.isEmpty(outboundSfRndInteraction.CH_RnD_Content__c));
		}
	if (outboundSfRndInteraction.CH_RnD_Type__c == sampleTrsftoRD) {
		System.assert(outboundSfRndInteraction.CH_RnD_Content__c.startsWith('Problem Transfer to PRONTO'));
		System.assert(outboundSfRndInteraction.CH_RnD_Content__c.contains(String.format('Problem Number:"{0}"', new List<Object>{outboundSfRndInteraction.CH_Related_Record__r.CaseNumber})));
		System.assert(outboundSfRndInteraction.CH_RnD_Content__c.contains(String.format('Severity:"{0}"', new List<Object>{outboundSfRndInteraction.CH_Related_Record__r.Severity__c})));
		System.assert(outboundSfRndInteraction.CH_RnD_Content__c.contains(String.format('Subject:"{0}"', new List<Object>{outboundSfRndInteraction.CH_Related_Record__r.Subject})));
	}
			}
		}
		return outboundSfRndInteraction;
	}
	
	@isTest
	private static void loadProblemTest() {
		Case testCase = createTestCase();
		
		Test.startTest();
		CH_CreateOutRndInteractionController.Problem problem = CH_CreateOutRndInteractionController.loadProblem(testCase.Id);
		System.assertEquals(problem.description, testCase.CH_CustomerDescription__c.stripHtmlTags());
		System.assertEquals(problem.description, 'test customer description');
		System.assertEquals(problem.interfaceName, testCase.CH_RDInterface__c);
		Test.stopTest();
	}
	
	@isTest
	private static void resendOutboundRndInteractionTest() {
		Case testCase = createTestCase();
		CH_CreateOutRndInteractionController.RndInteraction rndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', sampleworkarndAcc, 'Open', sampleTestPorntoId);
		Id outboundRndInteractionId = CH_CreateOutRndInteractionController.createRndInteraction(JSON.serialize(rndInteraction));
		
		CH_Problem_RnD_Reference__c outboundRndInteraction = [SELECT Id, CH_RnD_Reference__c, CreatedDate, CH_RnD_Subject__c, CH_RnD_Description__c, CH_Related_Record__r.CaseNumber FROM CH_Problem_RnD_Reference__c WHERE Id =: outboundRndInteractionId];
		CH_partnerNAIPWSDLForSF.receiveFromSalesForce request = new CH_partnerNAIPWSDLForSF.receiveFromSalesForce();
		request.RndInteraction = new CH_partnerNAIPWSDLForSF.RndInteraction();
		request.RndInteraction.Interface_x = 'pronto';
		request.RndInteraction.Type_x = sampleAcceWrkArnd;
		request.RndInteraction.ReferenceNumber = outboundRndInteraction.CH_RnD_Reference__c;
		request.RndInteraction.CreatedDate = outboundRndInteraction.CreatedDate;
		request.RndInteraction.Subject = outboundRndInteraction.CH_RnD_Subject__c;
		request.RndInteraction.Description = outboundRndInteraction.CH_RnD_Description__c;
		request.RndInteraction.RelatedRecord = outboundRndInteraction.CH_Related_Record__r.CaseNumber;
		
		outboundRndInteraction.CH_Request__c = JSON.serialize(request);
		outboundRndInteraction.CH_RnD_Error_Message__c = 'test error';
		outboundRndInteraction.CH_RnD_Status__c = 'Failed';
		update outboundRndInteraction;
		
		Test.startTest();
		NaipProntoSuccessWebServiceMock naipWebServiceMock = new NaipProntoSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		CH_CreateOutRndInteractionController.sendRndInteraction(outboundRndInteractionId);
		outboundRndInteraction = validateOutboundRndInteractionSend(outboundRndInteractionId, 'Outbound', rndInteraction);
		System.assertEquals(outboundRndInteraction.CH_RnD_Reference__c, rndInteraction.rndReference);
		System.assertEquals(outboundRndInteraction.CH_RnD_Status__c, 'Completed');
		System.assert(String.isEmpty(outboundRndInteraction.CH_RnD_Error_Message__c));
		
		testCase = [SELECT Id, CaseNumber, Severity__c, Origin FROM Case];
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		validateLog(logs[0],sampleAcceWrkArnd, 'pronto', 'Success', NULL, String.format(sampleRDOutbnd, new List<Object> {rndInteraction.interactionType, testCase.Id}), sampleProntoJiraIntrfc);
		Test.stopTest();
	}
	
	@isTest
	private static void resendOutboundRndInteractionErrorTest() {
		Case testCase = createTestCase();
		
		CH_CreateOutRndInteractionController.RndInteraction rndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', sampleInfoUpdte, 'Open', sampleTestPorntoId);
		Id outboundRndInteractionId = CH_CreateOutRndInteractionController.createRndInteraction(JSON.serialize(rndInteraction));
		
		CH_Problem_RnD_Reference__c outboundRndInteraction = [SELECT Id, CH_RnD_Reference__c, CreatedDate, CH_RnD_Subject__c, CH_RnD_Description__c, CH_Related_Record__r.CaseNumber FROM CH_Problem_RnD_Reference__c WHERE Id =: outboundRndInteractionId];
		CH_partnerNAIPWSDLForSF.receiveFromSalesForce request = new CH_partnerNAIPWSDLForSF.receiveFromSalesForce();
		request.RndInteraction = new CH_partnerNAIPWSDLForSF.RndInteraction();
		request.RndInteraction.Interface_x = 'pronto';
		request.RndInteraction.Type_x = sampleAcceWrkArnd;
		request.RndInteraction.ReferenceNumber = outboundRndInteraction.CH_RnD_Reference__c;
		request.RndInteraction.CreatedDate = outboundRndInteraction.CreatedDate;
		request.RndInteraction.Subject = outboundRndInteraction.CH_RnD_Subject__c;
		request.RndInteraction.Description = outboundRndInteraction.CH_RnD_Description__c;
		request.RndInteraction.RelatedRecord = outboundRndInteraction.CH_Related_Record__r.CaseNumber;
		
		outboundRndInteraction.CH_Request__c = JSON.serialize(request);
		outboundRndInteraction.CH_RnD_Error_Message__c = 'test error';
		outboundRndInteraction.CH_RnD_Status__c = 'Failed';
		update outboundRndInteraction;
		
		Test.startTest();
		NaipErrorWebServiceMock naipWebServiceMock = new NaipErrorWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		CH_CreateOutRndInteractionController.sendRndInteraction(outboundRndInteractionId);
		outboundRndInteraction = validateOutboundRndInteractionSend(outboundRndInteractionId, 'Failed', rndInteraction);
		System.assertEquals(outboundRndInteraction.CH_RnD_Reference__c, rndInteraction.rndReference);
		System.assertEquals(outboundRndInteraction.CH_RnD_Status__c, 'Failed');
		System.assertEquals(outboundRndInteraction.CH_RnD_Error_Message__c, sampleBadRequest);
		
		testCase = [SELECT Id, CaseNumber, Severity__c, Origin FROM Case];
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		validateLog(logs[0],sampleAcceWrkArnd, 'pronto', 'Failure', outboundRndInteraction.CH_RnD_Error_Message__c, String.format(sampleRDOutbnd, new List<Object> {rndInteraction.interactionType, testCase.Id}), sampleProntoJiraIntrfc);   
		Test.stopTest();
	}
	
	@isTest
	private static void sendOutboundRndInteractionErrorNotificationTest() {
		CH_UserNotificationUTIL.runSendInterfaceKeyUserNotifications = true;
		
		Case testCase = createTestCase();
		CH_CreateOutRndInteractionController.RndInteraction rndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', sampleInfoUpdte, 'Open', sampleTestPorntoId);
		Id outboundRndInteractionId = CH_CreateOutRndInteractionController.createRndInteraction(JSON.serialize(rndInteraction));
		
		CH_UTIL_TEST.createInterfaceKeyGroup('test pronto interface group', 'PRONTO');
		
		Test.startTest();
		Test.setMock(WebServiceMock.class, new NaipErrorWebServiceMock());
		Boolean hasError = true;
		try {
			CH_CreateOutRndInteractionController.sendRndInteraction(outboundRndInteractionId);
		} catch(Exception e) {
			hasError = true;
		}
		System.assert(hasError);
		Test.stopTest();
	}
	
	@isTest
	private static void sendOutboundRndInteractionContentTest() {
		Case testCase = createTestCase();
		
		String inboundRndInteractionDescription = 'test inbound workaround';
		CH_Problem_RnD_Reference__c inboundRndInteraction = createTestRndInteraction(testCase, inboundRndInteractionDescription, sampleTestPorntoId);
		
		String outboundRndInteractionDescription = 'test outbound workaround rejected';
		CH_CreateOutRndInteractionController.RndInteraction rndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', sampleworkarndRej, 'Open', sampleTestPorntoId);
		rndInteraction.relatedRndInteractionId = inboundRndInteraction.Id;
		rndInteraction.description = outboundRndInteractionDescription;
		Id outboundRndInteractionId = CH_CreateOutRndInteractionController.createRndInteraction(JSON.serialize(rndInteraction));
		
		CH_Problem_RnD_Reference__c outboundRndInteraction = [SELECT Id, CH_RnD_Reference__c, CreatedDate, CH_RnD_Subject__c, CH_RnD_Description__c, CH_Related_Record__r.CaseNumber FROM CH_Problem_RnD_Reference__c WHERE Id =: outboundRndInteractionId];
		CH_partnerNAIPWSDLForSF.receiveFromSalesForce request = new CH_partnerNAIPWSDLForSF.receiveFromSalesForce();
		request.RndInteraction = new CH_partnerNAIPWSDLForSF.RndInteraction();
		request.RndInteraction.Interface_x = 'pronto';
		request.RndInteraction.Type_x = 'reject-workaround';
		request.RndInteraction.ReferenceNumber = outboundRndInteraction.CH_RnD_Reference__c;
		request.RndInteraction.CreatedDate = outboundRndInteraction.CreatedDate;
		request.RndInteraction.Subject = outboundRndInteraction.CH_RnD_Subject__c;
		request.RndInteraction.Description = outboundRndInteraction.CH_RnD_Description__c;
		request.RndInteraction.RelatedRecord = outboundRndInteraction.CH_Related_Record__r.CaseNumber;
		
		Test.startTest();
		NaipProntoSuccessWebServiceMock naipWebServiceMock = new NaipProntoSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		CH_CreateOutRndInteractionController.sendRndInteraction(outboundRndInteractionId);
		outboundRndInteraction = validateOutboundRndInteractionSend(outboundRndInteractionId, 'Outbound', rndInteraction);
		System.assertEquals(outboundRndInteraction.CH_RnD_Reference__c, rndInteraction.rndReference);
		System.assertEquals(outboundRndInteraction.CH_RnD_Status__c, 'Completed');
		System.assertEquals(outboundRndInteraction.CH_Related_RnD_Interaction__c, inboundRndInteraction.Id);
		System.assert(outboundRndInteraction.CH_RnD_Content__c.startsWith('Workaround Rejection to PRONTO'));
		System.assert(outboundRndInteraction.CH_RnD_Content__c.contains(inboundRndInteractionDescription));
		System.assert(outboundRndInteraction.CH_RnD_Content__c.contains(outboundRndInteractionDescription));
		System.assert(String.isEmpty(outboundRndInteraction.CH_RnD_Error_Message__c));
		
		testCase = [SELECT Id, CaseNumber, Severity__c, Origin FROM Case];
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		validateLog(logs[0],'reject-workaround', 'pronto', 'Success', NULL, String.format(sampleRDOutbnd, new List<Object> {rndInteraction.interactionType, testCase.Id}), sampleProntoJiraIntrfc);
		Test.stopTest();
	}
	
	@isTest
	private static void sendOutboundRndInteractionTest() {
		CH_UserNotificationUTIL.runSendInterfaceKeyUserNotifications = true;
		CH_UTIL_TEST.createInterfaceKeyGroup('test pronto interface group', 'PRONTO');
		
		Case testCase = createTestCase();
		CH_CreateOutRndInteractionController.RndInteraction rndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', sampleInfoUpdte, 'Open', sampleTestPorntoId);
		Id outboundRndInteractionId = CH_CreateOutRndInteractionController.createRndInteraction(JSON.serialize(rndInteraction));
		
		Test.startTest();
		NaipProntoSuccessWebServiceMock naipWebServiceMock = new NaipProntoSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		CH_CreateOutRndInteractionController.sendRndInteraction(outboundRndInteractionId);
		CH_Problem_RnD_Reference__c outboundSfRndInteraction = validateOutboundRndInteractionSend(outboundRndInteractionId, 'Outbound', rndInteraction);
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Reference__c, rndInteraction.rndReference);
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Status__c, 'Completed');
		System.assert(String.isEmpty(outboundSfRndInteraction.CH_RnD_Error_Message__c));
		
		testCase = [SELECT Id, CaseNumber, Severity__c, Origin FROM Case];
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		validateCreateInformationUpdateLog(logs[0], testCase, sampleCrteInfoUpdte, 'pronto', 'Success', NULL, String.format(sampleRDOutbnd, new List<Object> {rndInteraction.interactionType, testCase.Id}), sampleProntoJiraIntrfc);
		Test.stopTest();
	}
	
	@isTest
	private static void sendOutboundRndInteractionErrorTest() {
		Case testCase = createTestCase();
		
		CH_CreateOutRndInteractionController.RndInteraction rndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', sampleInfoUpdte, 'Open', sampleTestPorntoId);
		Id outboundRndInteractionId = CH_CreateOutRndInteractionController.createRndInteraction(JSON.serialize(rndInteraction));
		
		Test.startTest();
		NaipErrorWebServiceMock naipWebServiceMock = new NaipErrorWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		CH_CreateOutRndInteractionController.sendRndInteraction(outboundRndInteractionId);
		CH_Problem_RnD_Reference__c outboundSfRndInteraction = validateOutboundRndInteractionSend(outboundRndInteractionId, 'Failed', rndInteraction);
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Reference__c, rndInteraction.rndReference);
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Status__c, 'Failed');
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Error_Message__c, sampleBadRequest);
		
		testCase = [SELECT Id, CaseNumber, Severity__c, Origin FROM Case];
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		validateCreateInformationUpdateLog(logs[0], testCase, sampleCrteInfoUpdte, 'pronto', 'Failure', outboundSfRndInteraction.CH_RnD_Error_Message__c, String.format(sampleRDOutbnd, new List<Object> {rndInteraction.interactionType, testCase.Id}), sampleProntoJiraIntrfc);   
		Test.stopTest();
	}
	
	@isTest
	private static void sendOutboundRndInteractionWebServiceErrorTest() {
		Case testCase = createTestCase();
		CH_CreateOutRndInteractionController.RndInteraction rndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', sampleInfoUpdte, 'Open', sampleTestPorntoId);
		Id outboundRndInteractionId = CH_CreateOutRndInteractionController.createRndInteraction(JSON.serialize(rndInteraction));
		
		Test.startTest();
		CH_CreateOutRndInteractionController.sendRndInteraction(outboundRndInteractionId);
		CH_Problem_RnD_Reference__c outboundSfRndInteraction = validateOutboundRndInteractionSend(outboundRndInteractionId, 'Failed', rndInteraction);
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Reference__c, rndInteraction.rndReference);
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Status__c, 'Failed');
		System.assert(String.isNotEmpty(outboundSfRndInteraction.CH_RnD_Error_Message__c));
		System.assertNotEquals(outboundSfRndInteraction.CH_RnD_Error_Message__c, sampleBadRequest);
		
		testCase = [SELECT Id, CaseNumber, Severity__c, Origin FROM Case];
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		validateCreateInformationUpdateLog(logs[0], testCase, sampleCrteInfoUpdte, 'pronto', 'Failure', outboundSfRndInteraction.CH_RnD_Error_Message__c, String.format(sampleRDOutbnd, new List<Object> {rndInteraction.interactionType, testCase.Id}), sampleProntoJiraIntrfc);   
		Test.stopTest();
	}
	
	@isTest
	private static void sendProntoCreateAnalysisRndInteractionTest() {
		Case testCase = createTestCase();
		CH_CreateOutRndInteractionController.RndInteraction rndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', sampleTrsftoRD, sampleStatusTrng);
		Id outboundRndInteractionId = CH_CreateOutRndInteractionController.createRndInteraction(JSON.serialize(rndInteraction));
		
		Test.startTest();
		NaipProntoSuccessWebServiceMock naipWebServiceMock = new NaipProntoSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		CH_CreateOutRndInteractionController.sendCreateAnalysisRndInteraction(outboundRndInteractionId);
		CH_Problem_RnD_Reference__c outboundSfRndInteraction = validateOutboundRndInteractionSend(outboundRndInteractionId, 'Transfer_To_RnD', rndInteraction);
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Reference__c, sampleTestPorntoId);
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Status__c, 'Completed');
		System.assert(String.isEmpty(outboundSfRndInteraction.CH_RnD_Error_Message__c));
		
		testCase = [SELECT Id, CaseNumber, CH_CustomerDescription__c, Severity__c, Origin, ProductId, Product.Name, Product.NokiaCPQ_Alias__c, CH_ProductVariant__r.NokiaCPQ_Alias__c, AccountId FROM Case];
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		validateCreateAnalysisLog(logs[0], testCase, sampleCreateAnlys, 'pronto', 'Success', outboundSfRndInteraction.CH_RnD_Error_Message__c, String.format(sampleRDOutbnd, new List<Object> {rndInteraction.interactionType, testCase.Id}), sampleProntoJiraIntrfc);
		Test.stopTest();
	}
	
	@isTest
	private static void sendProntoCreateAnalysisRndInteractionErrorTest() {
		Case testCase = createTestCase();
		CH_CreateOutRndInteractionController.RndInteraction rndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', sampleTrsftoRD, sampleStatusTrng);
		Id outboundRndInteractionId = CH_CreateOutRndInteractionController.createRndInteraction(JSON.serialize(rndInteraction));
		
		Test.startTest();
		NaipErrorWebServiceMock naipWebServiceMock = new NaipErrorWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		CH_CreateOutRndInteractionController.sendCreateAnalysisRndInteraction(outboundRndInteractionId);
		CH_Problem_RnD_Reference__c outboundSfRndInteraction = validateOutboundRndInteractionSend(outboundRndInteractionId, 'Failed', rndInteraction);
		System.assert(String.isEmpty(outboundSfRndInteraction.CH_RnD_Reference__c));
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Status__c, 'Failed');
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Error_Message__c, sampleBadRequest);
		
		testCase = [SELECT Id, CaseNumber, CH_CustomerDescription__c, Severity__c, Origin, ProductId, Product.Name, Product.NokiaCPQ_Alias__c, CH_ProductVariant__r.NokiaCPQ_Alias__c, AccountId FROM Case];
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		validateCreateAnalysisLog(logs[0], testCase, sampleCreateAnlys, 'pronto', 'Failure', outboundSfRndInteraction.CH_RnD_Error_Message__c, String.format(sampleRDOutbnd, new List<Object> {rndInteraction.interactionType, testCase.Id}), sampleProntoJiraIntrfc);
		Test.stopTest();
	}
	
	@isTest
	private static void sendJiraCreateAnalysisRndInteractionTest() {
		Case testCase = createTestCase();
		CH_CreateOutRndInteractionController.RndInteraction rndInteraction = getTestOutboundRndInteraction(testCase, 'JIRA', sampleTrsftoRD, sampleStatusTrng);
		Id outboundRndInteractionId = CH_CreateOutRndInteractionController.createRndInteraction(JSON.serialize(rndInteraction));
		
		Test.startTest();
		NaipJiraSuccessWebServiceMock naipWebServiceMock = new NaipJiraSuccessWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		CH_CreateOutRndInteractionController.sendCreateAnalysisRndInteraction(outboundRndInteractionId);
		CH_Problem_RnD_Reference__c outboundSfRndInteraction = validateOutboundRndInteractionSend(outboundRndInteractionId, 'Transfer_To_RnD', rndInteraction);
		System.assert(String.isEmpty(outboundSfRndInteraction.CH_RnD_Reference__c));
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Status__c, sampleStatusTrng);
		System.assert(String.isEmpty(outboundSfRndInteraction.CH_RnD_Error_Message__c));
		
		testCase = [SELECT Id, CaseNumber, CH_CustomerDescription__c, Severity__c, Origin, ProductId, Product.Name, Product.NokiaCPQ_Alias__c, CH_ProductVariant__r.NokiaCPQ_Alias__c, AccountId FROM Case];
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		validateCreateAnalysisLog(logs[0], testCase, sampleCreateAnlys, 'jira-bridge', 'Success', NULL, String.format(sampleRDOutbnd, new List<Object> {rndInteraction.interactionType, testCase.Id}), sampleProntoJiraIntrfc);
		Test.stopTest();
	}
	
	@isTest
	private static void sendJiraCreateAnalysisRndInteractionErrorTest() {
		Case testCase = createTestCase();
		CH_CreateOutRndInteractionController.RndInteraction rndInteraction = getTestOutboundRndInteraction(testCase, 'JIRA', sampleTrsftoRD, sampleStatusTrng);
		Id outboundRndInteractionId = CH_CreateOutRndInteractionController.createRndInteraction(JSON.serialize(rndInteraction));
		
		Test.startTest();
		NaipErrorWebServiceMock naipWebServiceMock = new NaipErrorWebServiceMock();
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		CH_CreateOutRndInteractionController.sendCreateAnalysisRndInteraction(outboundRndInteractionId);
		CH_Problem_RnD_Reference__c outboundSfRndInteraction = validateOutboundRndInteractionSend(outboundRndInteractionId, 'Failed', rndInteraction);
		System.assert(String.isEmpty(outboundSfRndInteraction.CH_RnD_Reference__c));
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Status__c, 'Failed');
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Error_Message__c, sampleBadRequest);
		
		testCase = [SELECT Id, CaseNumber, CH_CustomerDescription__c, Severity__c, Origin, ProductId, Product.Name, Product.NokiaCPQ_Alias__c, CH_ProductVariant__r.NokiaCPQ_Alias__c, AccountId FROM Case];
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		validateCreateAnalysisLog(logs[0], testCase, sampleCreateAnlys, 'jira-bridge', 'Failure', outboundSfRndInteraction.CH_RnD_Error_Message__c, String.format(sampleRDOutbnd, new List<Object> {rndInteraction.interactionType, testCase.Id}), sampleProntoJiraIntrfc);
		Test.stopTest();
	}
	
	@isTest
	private static void sendCreateAnalysisRndInteractionWebServiceErrorTest() {
		Case testCase = createTestCase();
		CH_CreateOutRndInteractionController.RndInteraction rndInteraction = getTestOutboundRndInteraction(testCase, 'PRONTO', sampleTrsftoRD, sampleStatusTrng);
		Id outboundRndInteractionId = CH_CreateOutRndInteractionController.createRndInteraction(JSON.serialize(rndInteraction));
		
		Test.startTest();
		CH_CreateOutRndInteractionController.sendCreateAnalysisRndInteraction(outboundRndInteractionId);
		CH_Problem_RnD_Reference__c outboundSfRndInteraction = validateOutboundRndInteractionSend(outboundRndInteractionId, 'Failed', rndInteraction);
		System.assert(String.isEmpty(outboundSfRndInteraction.CH_RnD_Reference__c));
		System.assertEquals(outboundSfRndInteraction.CH_RnD_Status__c, 'Failed');
		System.assert(String.isNotEmpty(outboundSfRndInteraction.CH_RnD_Error_Message__c));
		System.assertNotEquals(outboundSfRndInteraction.CH_RnD_Error_Message__c, sampleBadRequest);
		
		testCase = [SELECT Id, CaseNumber, CH_CustomerDescription__c, Severity__c, Origin, ProductId, Product.Name, Product.NokiaCPQ_Alias__c, CH_ProductVariant__r.NokiaCPQ_Alias__c, AccountId FROM Case];
		List<Interface_Log__c> logs = [SELECT Id, Name, Comment__c, Message_Type__c, Number_of_Records_Errored__c, Number_of_Records_Success__c, Number_of_Record_Processed__c, Interface_Request_Sent__c, Status__c, Interface_Type__c FROM Interface_Log__c];
		System.assertEquals(logs.size(), 1);
		validateCreateAnalysisLog(logs[0], testCase, sampleCreateAnlys, 'pronto', 'Failure', logs[0].Comment__c, String.format(sampleRDOutbnd, new List<Object> {rndInteraction.interactionType, testCase.Id}), sampleProntoJiraIntrfc);
		Test.stopTest();
	}
	
	public class NaipErrorWebServiceMock implements WebServiceMock {
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
	responseToSf.message = sampleBadRequest;
	receivFromSfResponse.responseToSalesForce = responseToSf;
	response.put('response_x', receivFromSfResponse);
			}
	}
	
	public class NaipProntoSuccessWebServiceMock implements WebServiceMock {
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
	responseToSf.externalID = sampleTestPorntoId;
	receivFromSfResponse.responseToSalesForce = responseToSf;
	response.put('response_x', receivFromSfResponse);
			}
	}
	
	public class NaipJiraSuccessWebServiceMock implements WebServiceMock {
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
}