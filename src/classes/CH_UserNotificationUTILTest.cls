/*******************************
Class Name: CH_UserNotificationUTILTest
Created by: GCC
Last modified by: GCC
Description: This class contains test for methods to notify users about integration failures
*******************************/
@isTest
private class CH_UserNotificationUTILTest {
	@testSetup
	static void setup() {
		CH_UTIL_TEST.setupCase();
	}

	private static Case createProblem() {
		CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
		CH_ExternalInterfaceUTIL.runUpdateFromExternalInterface = true;

		Case testProblem = CH_UTIL_TEST.getProblem();
		insert testProblem;
		return testProblem;
	}

	private static Case createS2SCase() {
		CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;

		Case testCase = CH_UTIL_TEST.getS2SCase();
		insert testCase;
		return testCase;		
	}

	@isTest
	private static void sendOutboundRndFailureNotificationTest() {
		Case testProblem = createProblem();

		testProblem = [SELECT Id, Origin, RecordType.DeveloperName FROM Case];
		System.assertNotEquals(testProblem.Origin, 'S2S');
		System.assertEquals(testProblem.RecordType.DeveloperName, 'CH_Problem');
		
		List<CH_Problem_RnD_Reference__c> rndInteractions = new List<CH_Problem_RnD_Reference__c>();
		CH_Problem_RnD_Reference__c failedRndInteraction = CH_UTIL_TEST.getRndInteraction('Failed', 'test error', 'Correction Plan', 'Correction Plan', 'outbound', 'PRONTO', 'pronto test id', testProblem.Id);
		rndInteractions.add(failedRndInteraction);
		CH_Problem_RnD_Reference__c successRndInteraction = CH_UTIL_TEST.getRndInteraction('Completed', NULL, 'Correction Plan', 'Correction Plan', 'outbound', 'PRONTO', 'pronto test id', testProblem.Id);
		rndInteractions.add(successRndInteraction);
		insert rndInteractions;

		Test.startTest();
		Profile systemAdministratorProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
		String systemAdministratorEmail = 'naip' + DateTime.now().getTime() + '@test.com';
		System.runAs(CH_UTIL_TEST.getUser(systemAdministratorEmail, systemAdministratorEmail, 'naipuser', systemAdministratorProfile)) {
			CaseTeamRole teamRole = [SELECT Id FROM CaseTeamRole WHERE Name = 'Customer Care Manager'];
			CaseTeamMember caseTeamMember = new CaseTeamMember(ParentId = testProblem.Id, TeamRoleId = teamRole.Id, MemberId = UserInfo.getUserId());
			insert caseTeamMember;

			Interface_Log__c failureLog = CH_ExternalInterfaceUTIL.createOutboundRndInterfaceLog(String.format('R&D Outbound {0} {1}', new List<Object> {failedRndInteraction.CH_RnD_Type__c, failedRndInteraction.CH_Related_Record__c}), 'R&D', failedRndInteraction.CH_RnD_Error_Message__c);
			CH_UserNotificationUTIL.runSendRndOutboundFailureNotification = false;
			List<ConnectApi.FeedItemInput>  feedItemInputs = CH_UserNotificationUTIL.sendRndOutboundFailureNotification(failureLog, failedRndInteraction.Id);
			System.assertEquals(feedItemInputs.size(), 1);
			System.assertEquals(feedItemInputs[0].body.messageSegments.size(), 3);

			teamRole = [SELECT Id FROM CaseTeamRole WHERE Name = 'Problem Manager'];
			caseTeamMember.TeamRoleId = teamRole.Id;
			update caseTeamMember;
			feedItemInputs = CH_UserNotificationUTIL.sendRndOutboundFailureNotification(failureLog, failedRndInteraction.Id);
			System.assertEquals(feedItemInputs.size(), 1);
			System.assertEquals(feedItemInputs[0].body.messageSegments.size(), 4);

			CH_UTIL_TEST.createInterfaceKeyGroup('test pronto interface group', 'PRONTO');
			feedItemInputs = CH_UserNotificationUTIL.sendRndOutboundFailureNotification(failureLog, failedRndInteraction.Id);
			System.assertEquals(feedItemInputs.size(), 2);
			System.assertEquals(feedItemInputs[0].body.messageSegments.size(), 4);
			System.assertEquals(feedItemInputs[1].body.messageSegments.size(), 2);

			CH_UserNotificationUTIL.runSendRndOutboundFailureNotification = true;
			Boolean hasError = false;
			try {
	CH_UserNotificationUTIL.sendRndOutboundFailureNotification(failureLog, failedRndInteraction.Id);
			} catch(Exception e) {
	hasError = true;
			}
			System.assert(hasError);

			Interface_Log__c successLog = CH_ExternalInterfaceUTIL.createOutboundRndInterfaceLog(String.format('R&D Outbound {0} {1}', new List<Object> {successRndInteraction.CH_RnD_Type__c, successRndInteraction.CH_Related_Record__c}), 'R&D', NULL);
			feedItemInputs = CH_UserNotificationUTIL.sendRndOutboundFailureNotification(successLog, successRndInteraction.Id);
			System.assert(feedItemInputs.isEmpty());
		}
		Test.stopTest();
	}

	@isTest
	private static void sendOutboundS2SFailureNotificationTest() {
		Case testCase = createS2SCase();

		testCase = [SELECT Id, Origin, RecordType.DeveloperName FROM Case];
		System.assertEquals(testCase.Origin, 'S2S');
		System.assertNotEquals(testCase.RecordType.DeveloperName, 'CH_Problem');
		
		List<Interface_Log__c> logs = new List<Interface_Log__c>();
		Interface_Log__c failureLog = CH_ExternalInterfaceUTIL.createOutboundCustomerS2SInterfaceLog(String.format('S2S Case {0} {1}', new List<Object> {'orange-irma', testCase.Id}), 'test request', 'test error');
		Interface_Log__c successLog = CH_ExternalInterfaceUTIL.createOutboundCustomerS2SInterfaceLog(String.format('S2S Case {0} {1}', new List<Object> {'orange-irma', testCase.Id}), 'test request', NULL);
		insert logs;

		Test.startTest();
		Profile systemAdministratorProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
		String systemAdministratorEmail = 'naip' + DateTime.now().getTime() + '@test.com';
		System.runAs(CH_UTIL_TEST.getUser(systemAdministratorEmail, systemAdministratorEmail, 'naipuser', systemAdministratorProfile)) {
			CaseTeamRole teamRole = [SELECT Id FROM CaseTeamRole WHERE Name = 'Problem Manager'];
			CaseTeamMember caseTeamMember = new CaseTeamMember(ParentId = testCase.Id, TeamRoleId = teamRole.Id, MemberId = UserInfo.getUserId());
			insert caseTeamMember;

			CH_UserNotificationUTIL.runSendOutboundFailureNotification = false;
			List<ConnectApi.FeedItemInput>  feedItemInputs = CH_UserNotificationUTIL.sendOutboundFailureNotification(new Map<Id, Interface_Log__c>{testCase.Id => failureLog});
			System.assertEquals(feedItemInputs.size(), 1);
			System.assertEquals(feedItemInputs[0].body.messageSegments.size(), 3);

			teamRole = [SELECT Id FROM CaseTeamRole WHERE Name = 'Customer Care Manager'];
			caseTeamMember.TeamRoleId = teamRole.Id;
			update caseTeamMember;
			feedItemInputs = CH_UserNotificationUTIL.sendOutboundFailureNotification(new Map<Id, Interface_Log__c>{testCase.Id => failureLog});
			System.assertEquals(feedItemInputs.size(), 1);
			System.assertEquals(feedItemInputs[0].body.messageSegments.size(), 4);

			CH_UserNotificationUTIL.runSendOutboundFailureNotification = true;
			Boolean hasError = false;
			try {
	CH_UserNotificationUTIL.sendOutboundFailureNotification(new Map<Id, Interface_Log__c>{testCase.Id => failureLog});
			} catch(Exception e) {
	hasError = true;
			}
			System.assert(hasError);

			feedItemInputs = CH_UserNotificationUTIL.sendOutboundFailureNotification(new Map<Id, Interface_Log__c>{testCase.Id => successLog});
			System.assert(feedItemInputs.isEmpty());
		}
		Test.stopTest();
	}

	@isTest
	private static void sendS2SFailureNotificationTest() {
		Case testCase = createS2SCase();

		testCase = [SELECT Id, Origin, RecordType.DeveloperName FROM Case];
		System.assertEquals(testCase.Origin, 'S2S');
		System.assertNotEquals(testCase.RecordType.DeveloperName, 'CH_Problem');
		 
		Interface_Log__c failureLog = CH_ExternalInterfaceUTIL.createOutboundCustomerS2SInterfaceLog(String.format('S2S Case {0} {1}', new List<Object> {'orange-irma', testCase.Id}), 'test request', 'test error');
		insert failureLog;

		Test.startTest();
		Profile systemAdministratorProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
		String systemAdministratorEmail = 'naip' + DateTime.now().getTime() + '@test.com';
		System.runAs(CH_UTIL_TEST.getUser(systemAdministratorEmail, systemAdministratorEmail, 'naipuser', systemAdministratorProfile)) {
			CaseTeamRole teamRole = [SELECT Id FROM CaseTeamRole WHERE Name = 'Problem Manager'];
			CaseTeamMember caseTeamMember = new CaseTeamMember(ParentId = testCase.Id, TeamRoleId = teamRole.Id, MemberId = UserInfo.getUserId());
			insert caseTeamMember;

			CH_UserNotificationUTIL.runSendOutboundFailureNotification = false;
			List<ConnectApi.FeedItemInput> feedItemInputs = CH_UserNotificationUTIL.sendS2SFailureNotification(testCase.Id, failureLog);
			System.assertEquals(feedItemInputs.size(), 1);
			System.assertEquals(feedItemInputs[0].body.messageSegments.size(), 3);

			teamRole = [SELECT Id FROM CaseTeamRole WHERE Name = 'Customer Care Manager'];
			caseTeamMember.TeamRoleId = teamRole.Id;
			update caseTeamMember;
			feedItemInputs = CH_UserNotificationUTIL.sendS2SFailureNotification(testCase.Id, failureLog);
			System.assertEquals(feedItemInputs.size(), 1);
			System.assertEquals(feedItemInputs[0].body.messageSegments.size(), 4);

			CH_UserNotificationUTIL.runSendS2SFailureNotification = true;
			Boolean hasError = false;
			try {
	CH_UserNotificationUTIL.sendS2SFailureNotification(testCase.Id, failureLog);
			} catch(Exception e) {
	hasError = true;
			}
			System.assert(hasError);
		}
		Test.stopTest();
	}

	@isTest
	private static void sendInterfaceKeyUserNotificationsTest() {
		Case testCase = createS2SCase();

		Interface_Log__c failureLog = CH_ExternalInterfaceUTIL.createInboundCustomerS2SInterfaceLog('test log', 'test request', 'test error', 'Update');
		insert failureLog;

		Test.startTest();
		CH_UserNotificationUTIL.runSendInterfaceKeyUserNotifications = true;
		List<ConnectApi.FeedItemInput> feedItemInputs = CH_UserNotificationUTIL.sendInterfaceKeyUserNotification(testCase.CH_CaseOriginSystem__c, failureLog);
		System.assert(feedItemInputs.isEmpty());

		CollaborationGroup interfaceKeyUserGroup = new CollaborationGroup(Name = 'test interface key user group', CollaborationType = 'Public');
		insert interfaceKeyUserGroup;
		CH_InterfaceKeyGroup__c interfaceKeyUserGroupSettings = new CH_InterfaceKeyGroup__c(Name = 'test', ExternalSystem__c = 'orange-irma', CollaborationGroupName__c = interfaceKeyUserGroup.Name);
		insert interfaceKeyUserGroupSettings;

		Boolean hasError = false;
		try {
			CH_UserNotificationUTIL.runSendInterfaceKeyUserNotifications = true;
			CH_UserNotificationUTIL.sendInterfaceKeyUserNotification(testCase.CH_CaseOriginSystem__c, failureLog);
		} catch(Exception e) {
			hasError = true;
		}
		System.assert(hasError);

		CH_UserNotificationUTIL.runSendInterfaceKeyUserNotifications = false;
		feedItemInputs = CH_UserNotificationUTIL.sendInterfaceKeyUserNotification(testCase.CH_CaseOriginSystem__c, failureLog);
		System.assertEquals(feedItemInputs.size(), 1);
		Test.stopTest();
	}

	@isTest
	private static void sendInboundS2SCaseCommentSuccessNotificationTest() {
		Case testCase = createS2SCase();

		Test.startTest();
		Profile integrationProfile = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		String integrationUserEmail = 'naip' + DateTime.now().getTime() + '@test.com';
		System.runAs(CH_UTIL_TEST.getUser(integrationUserEmail, integrationUserEmail, 'naipuser', integrationProfile)) {
			CaseComment comment = new CaseComment(ParentId = testCase.Id, IsPublished = true, CommentBody = 'test comment');
			insert comment;

			CH_UserNotificationUTIL.runSendS2SCaseCommentInboundSuccessNotification = false;
			List<ConnectApi.FeedItemInput> feedItemInputs = CH_UserNotificationUTIL.sendS2SCaseCommentInboundSuccessNotification(testCase.Id);
			System.assert(feedItemInputs.isEmpty());

			feedItemInputs = CH_UserNotificationUTIL.sendS2SCaseCommentInboundSuccessNotification(comment.Id);
			System.assertEquals(feedItemInputs.size(), 1);
			System.assertEquals(feedItemInputs[0].body.messageSegments.size(), 3);

			CH_UserNotificationUTIL.runSendS2SCaseCommentInboundSuccessNotification = true;
			Boolean hasNotification = false;
			try {
	feedItemInputs = CH_UserNotificationUTIL.sendS2SCaseCommentInboundSuccessNotification(comment.Id);
			} catch(Exception e) {
	hasNotification = true;
			}
			System.assert(hasNotification);
		}
		Test.stopTest();		
	}
}