/*******************************
Class Name: CH_UserNotificationUTIL
Created by: GCC
Last modified by: GCC
Description: This class contains methods to notify users about integration failures
*******************************/
public without sharing class CH_UserNotificationUTIL {
	/********************
	*Method Name: getCollaborationGroupsForExternalSystems
	*Parameter: Set<String> externalSystems - set of case origin systems
	*Description: Used to get Ids of chatter groups of interface key users for specific origin system
	*******************/
	public static Map<String, Id> getCollaborationGroupsForExternalSystems(Set<String> externalSystems) {
		Map<String, String> collaborationGroupNames = new Map<String, String>();
		for (CH_InterfaceKeyGroup__c interfaceKeyGroup : CH_InterfaceKeyGroup__c.getAll().values()) {
			if (externalSystems.contains(interfaceKeyGroup.ExternalSystem__c)) {
	collaborationGroupNames.put(interfaceKeyGroup.CollaborationGroupName__c, interfaceKeyGroup.ExternalSystem__c);
			}
		}

		Map<String, Id> collaborationGroups = new Map<String, Id>();
		for (CollaborationGroup cg : [SELECT Id, Name FROM CollaborationGroup WHERE Name IN :collaborationGroupNames.keySet()]) {
			collaborationGroups.put(collaborationGroupNames.get(cg.Name), cg.Id);
		}

		return collaborationGroups;
	}

	@TestVisible private static Boolean runSendS2SFailureNotification = false;
	/********************
	*Method Name: sendS2SFailureNotification
	*Parameter: Id failureCaseId - failure caseId
	*Parameter: Interface_Log__c failureCaseLog - failure log
	*Description: post feed items with outbound or inbound call errors to Case Owner, CCM, PM
	*******************/
	public static List<ConnectApi.FeedItemInput> sendS2SFailureNotification(Id failureCaseId, Interface_Log__c failureCaseLog) {
		List<ConnectApi.FeedItemInput> notifications = new List<ConnectApi.FeedItemInput>();
		if (failureCaseLog.Status__c == 'Failure') {
			Map<Id, Case> cases = new Map<Id, Case>([SELECT Id, CH_CaseOriginSystem__c, CaseNumber, Origin, OwnerId, RecordType.DeveloperName 
				FROM Case WHERE Id =: failureCaseId AND Origin = 'S2S']);
			if (!cases.isEmpty()) {
	notifications.addAll(createFailureNotifications(cases, new Map<Id, Interface_Log__c>{failureCaseId => failureCaseLog}));
	if (!notifications.isEmpty() && (!Test.isRunningTest() || runSendS2SFailureNotification)) {
		ConnectApi.ChatterFeeds.postFeedElementBatch(null, getBatchInputs(notifications));
	}
			}
		}

		return notifications;
	}

	@TestVisible private static Boolean runSendInterfaceKeyUserNotifications = false;
	/********************
	*Method Name: sendInterfaceKeyUserNotification
	*Parameter: String failureCaseOriginSystem - external case system
	*Parameter: Interface_Log__c failureCaseLog - failure log
	*Description: post feed items with outbound or inbound call errors to Case Owner, CCM, PM
	*******************/
	public static List<ConnectApi.FeedItemInput> sendInterfaceKeyUserNotification(String externalSystem, Interface_Log__c failureCaseLog) {
		List<ConnectApi.FeedItemInput> notifications = createInterfaceKeyUserNotifications(new List<String>{externalSystem}, new List<Interface_Log__c>{failureCaseLog});
		if (!notifications.isEmpty() && (!Test.isRunningTest() || runSendInterfaceKeyUserNotifications)) {
			ConnectApi.ChatterFeeds.postFeedElementBatch(null, getBatchInputs(notifications));
		}
		return notifications;
	}


	@TestVisible private static Boolean runSendOutboundFailureNotification = false;
	/********************
	*Method Name: sendOutboundFailureNotification
	*Parameter: Map<Id, Interface_Log__c> caseLogs - set of case logs
	*Description: post feed items with outbound or inbound call errors to Case Owner, CCM, PM and Interface Key Users
	*******************/
	public static List<ConnectApi.FeedItemInput> sendOutboundFailureNotification(Map<Id, Interface_Log__c> caseLogs) {
		List<ConnectApi.FeedItemInput> notifications = new List<ConnectApi.FeedItemInput>();
		Set<Id> caseIds = new Set<Id>();
		for (Id caseId : caseLogs.keySet()) {
			Interface_Log__c log = caseLogs.get(caseId);
			if (log.Status__c == 'Failure') {
	caseIds.add(caseId);
			}
		}

		if (!caseIds.isEmpty()) {		
			Map<Id, Case> cases = new Map<Id, Case>([SELECT Id, CH_CaseOriginSystem__c, CaseNumber, Origin, OwnerId, RecordType.DeveloperName 
				FROM Case WHERE Id IN : caseIds  AND Origin = 'S2S']);
			if (!cases.isEmpty()) {
	notifications.addAll(createFailureNotifications(cases, caseLogs));
	notifications.addAll(createInterfaceKeyUserNotifications(cases, caseLogs));

	if (!notifications.isEmpty() && (!Test.isRunningTest() || runSendOutboundFailureNotification)) {
		ConnectApi.ChatterFeeds.postFeedElementBatch(null, getBatchInputs(notifications));
	}
			}
		}
		return notifications;
	}

	private static List<ConnectApi.FeedItemInput> createFailureNotifications(Map<Id, Case> cases, Map<Id, Interface_Log__c> caseLogs) {
		List<ConnectApi.FeedItemInput> failureS2SNotifications = new List<ConnectApi.FeedItemInput>();
		Map<Id, Set<Id>> teamMembers = new Map<Id, Set<Id>>();
		for (Case c : cases.values()) {
			teamMembers.put(c.Id, new Set<Id> {c.OwnerId});
		}
		for (CaseTeamMember caseTeamMember : [SELECT MemberId, ParentId, TeamRole.Name FROM CaseTeamMember 
			 WHERE ParentId IN : cases.keySet() AND 
				TeamRoleId IN (SELECT Id FROM CaseTeamRole WHERE Name = 'Customer Care Manager')]) {
			Case c = cases.get(caseTeamMember.ParentId);
			if (caseTeamMember.TeamRole.Name == 'Customer Care Manager' && c.Origin == 'S2S') {
	Set<Id> caseTeamMembers = teamMembers.get(caseTeamMember.ParentId);
	caseTeamMembers.add(caseTeamMember.MemberId);
			}
		}

		for (Id caseId : teamMembers.keySet()) {
			List<ConnectApi.MessageSegmentInput> mentionSegments = new List<ConnectApi.MessageSegmentInput>();
			for (Id teamMemberId : teamMembers.get(caseId)) {
	if (teamMemberId.getSObjectType() == User.getSObjectType()) {
		ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		mentionSegmentInput.id = teamMemberId;
		mentionSegments.add(mentionSegmentInput);
	}
			}
			if (mentionSegments.isEmpty()) {
	continue;
			}

			ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
			feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
			feedItemInput.subjectId = caseId;

			ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
			messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

			ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
			textSegmentInput1.text = 'To: ';
			messageBodyInput.messageSegments.add(textSegmentInput1);

			messageBodyInput.messageSegments.addAll(mentionSegments);

			Interface_Log__c log = caseLogs.get(caseId);
			ConnectApi.TextSegmentInput textSegmentInput2 = new ConnectApi.TextSegmentInput();
			textSegmentInput2.text = String.format('\n{0} : {1}\nLog Record: {2}\n{3}/{4}', new List<Object>{log.Status__c, log.Comment__c, log.Name, URL.getSalesforceBaseUrl().toExternalForm(), log.Id});
			messageBodyInput.messageSegments.add(textSegmentInput2);

			feedItemInput.body = messageBodyInput;
			failureS2SNotifications.add(feedItemInput);
		}
		return failureS2SNotifications;
	}

	@TestVisible private static Boolean runSendS2SCaseCommentInboundSuccessNotification = false;
	/********************
	*Method Name: sendS2SCaseCommentInboundSuccessNotification
	*Parameter: Id caseCommentId - case comment is which was created in Inbound web service
	*Description: post feed items with Inbound S2S case comment success log to Case Owner
	*******************/
	public static List<ConnectApi.FeedItemInput> sendS2SCaseCommentInboundSuccessNotification(Id caseCommentId) {
		List<ConnectApi.FeedItemInput> notifications = new List<ConnectApi.FeedItemInput>();   
		List<CaseComment> comments = [SELECT Id, CommentBody, ParentId, Parent.OwnerId FROM CaseComment WHERE Id =: caseCommentId];
		if (!comments.isEmpty()) {
			CaseComment comment = comments[0];
			notifications.addAll(createS2SCaseCommentInboundNotifications(comment));
			if (!notifications.isEmpty() && (!Test.isRunningTest() || runSendS2SCaseCommentInboundSuccessNotification)) {
	ConnectApi.ChatterFeeds.postFeedElementBatch(null, getBatchInputs(notifications));
			}
		}
		return notifications;
	}

	private static List<ConnectApi.FeedItemInput> createS2SCaseCommentInboundNotifications(CaseComment comment) {
		List<ConnectApi.FeedItemInput> notifications = new List<ConnectApi.FeedItemInput>();
		if (comment.Parent.OwnerId.getSObjectType() == User.getSObjectType()) {
			ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
			feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
			feedItemInput.subjectId = comment.ParentId;

			ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
			messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

			ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
			textSegmentInput1.text = 'To: ';
			messageBodyInput.messageSegments.add(textSegmentInput1);

			List<ConnectApi.MessageSegmentInput> mentionSegments = new List<ConnectApi.MessageSegmentInput>();
			ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
			mentionSegmentInput.id = comment.Parent.OwnerId;
			mentionSegments.add(mentionSegmentInput);
			messageBodyInput.messageSegments.addAll(mentionSegments);

			ConnectApi.TextSegmentInput textSegmentInput2 = new ConnectApi.TextSegmentInput();
			textSegmentInput2.text = String.format('\nThe Case Comment({0}): {1}', new List<Object>{comment.Id, comment.CommentBody});
			messageBodyInput.messageSegments.add(textSegmentInput2);

			feedItemInput.body = messageBodyInput;
			notifications.add(feedItemInput);
		}

		return notifications;
	}

	@TestVisible private static Boolean runSendRndOutboundFailureNotification = false;
	/********************
	*Method Name: sendRndOutboundFailureNotification
	*Parameter: Map<Id, Interface_Log__c> caseLogs - set of case logs
	*Description: post feed items with outbound R&D call errors to Problem Owner, PM and Interface Key Users
	*******************/
	public static List<ConnectApi.FeedItemInput> sendRndOutboundFailureNotification(Interface_Log__c problemLog, Id rndInteractionId) {
		List<ConnectApi.FeedItemInput> notifications = new List<ConnectApi.FeedItemInput>();
		if (problemLog.Status__c == 'Failure') {	  
			List<CH_Problem_RnD_Reference__c> rndInteractions = [SELECT Id, Name, CH_RnD_Interface__c, CH_RnD_Type__c, CH_RnD_Subject__c, CH_Related_Record__c, CH_Related_Record__r.CH_CaseOriginSystem__c, CH_Related_Record__r.OwnerId FROM CH_Problem_RnD_Reference__c WHERE Id =:rndInteractionId  AND CH_Related_Record__r.RecordType.DeveloperName = 'CH_Problem'];
			if (!rndInteractions.isEmpty()) {
	CH_Problem_RnD_Reference__c rndInteraction = rndInteractions[0];
	notifications.addAll(createRndFailureNotifications(problemLog, rndInteraction));
	notifications.addAll(createInterfaceKeyUserNotifications(new List<String>{rndInteraction.CH_RnD_Interface__c}, new List<Interface_Log__c>{problemLog}));

	if (!notifications.isEmpty() && (!Test.isRunningTest() || runSendRndOutboundFailureNotification)) {
		ConnectApi.ChatterFeeds.postFeedElementBatch(null, getBatchInputs(notifications));
	}
			}
		}
		return notifications;
	}

	private static List<ConnectApi.FeedItemInput> createRndFailureNotifications(Interface_Log__c problemLog, CH_Problem_RnD_Reference__c rndInteraction) {
		List<ConnectApi.FeedItemInput> failureRndNotifications = new List<ConnectApi.FeedItemInput>();
		Set<Id> teamMembers = new Set<Id>();
		teamMembers.add(rndInteraction.CH_Related_Record__r.OwnerId);

		for (CaseTeamMember caseTeamMember : [SELECT MemberId, ParentId, TeamRole.Name FROM CaseTeamMember 
			 WHERE ParentId =: rndInteraction.CH_Related_Record__c AND 
				TeamRoleId IN (SELECT Id FROM CaseTeamRole WHERE Name = 'Problem Manager')]) {
			if (caseTeamMember.TeamRole.Name == 'Problem Manager') {
	teamMembers.add(caseTeamMember.MemberId);
			}
		}

		List<ConnectApi.MessageSegmentInput> mentionSegments = new List<ConnectApi.MessageSegmentInput>();
		for (Id teamMemberId : teamMembers) {
			if (teamMemberId.getSObjectType() == User.getSObjectType()) {
	ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
	mentionSegmentInput.id = teamMemberId;
	mentionSegments.add(mentionSegmentInput);
			}
		}
		if (!mentionSegments.isEmpty()) {
			ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
			feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
			feedItemInput.subjectId = rndInteraction.CH_Related_Record__c;

			ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
			messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

			ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
			textSegmentInput1.text = 'To: ';
			messageBodyInput.messageSegments.add(textSegmentInput1);

			messageBodyInput.messageSegments.addAll(mentionSegments);

			ConnectApi.TextSegmentInput textSegmentInput2 = new ConnectApi.TextSegmentInput();
			textSegmentInput2.text = String.format('\nThe R&D Interaction {0} of Type {1} has Failed\nFailure Message:{2}\nLog:{3}/{4}\nR&D Interaction:{3}/{5}\nRelated Record:{3}/{6}', new List<Object>{rndInteraction.Name, rndInteraction.CH_RnD_Type__c, problemLog.Comment__c, URL.getSalesforceBaseUrl().toExternalForm(), problemLog.Id, rndInteraction.Id, rndInteraction.CH_Related_Record__c});
			messageBodyInput.messageSegments.add(textSegmentInput2);

			feedItemInput.body = messageBodyInput;
			failureRndNotifications.add(feedItemInput);
		}

		return failureRndNotifications;
	}

	private static List<ConnectApi.FeedItemInput> createInterfaceKeyUserNotifications(Map<Id, Case> cases, Map<Id, Interface_Log__c> caseLogs) {
		List<String> caseOriginSystems = new List<String>();
		List<Interface_Log__c> logsForInterfaceKeyUserNotifications = new List<Interface_Log__c>();
		for (Id caseId : cases.keySet()) {
			Case c = cases.get(caseId);
			if (c.CH_CaseOriginSystem__c != NULL) {
	caseOriginSystems.add(c.CH_CaseOriginSystem__c);
	logsForInterfaceKeyUserNotifications.add(caseLogs.get(caseId));
			}
		}

		return createInterfaceKeyUserNotifications(caseOriginSystems, logsForInterfaceKeyUserNotifications);
	}

	private static List<ConnectApi.FeedItemInput> createInterfaceKeyUserNotifications(List<String> externalSystems, List<Interface_Log__c> caseLogs) {
		List<ConnectApi.FeedItemInput> interfaceKeyUserNotifications = new List<ConnectApi.FeedItemInput>();

		Map<String, Id> interfaceKeyUserGroups = getCollaborationGroupsForExternalSystems(new Set<String>(externalSystems));
		for (Integer i = 0; i < externalSystems.size(); i++) {
			Interface_Log__c log = caseLogs[i];

			Id groupId = interfaceKeyUserGroups.get(externalSystems[i]);
			if (groupId != NULL) {
	ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
	feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
	feedItemInput.subjectId = groupId;
	
	ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
	messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

	ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
	mentionSegmentInput.id = groupId;
	messageBodyInput.messageSegments.add(mentionSegmentInput);

	ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = String.format('\n{0} : {1}\nLog Record: {2}\n{3}/{4}', new List<Object>{log.Status__c, log.Comment__c, log.Name, URL.getSalesforceBaseUrl().toExternalForm(), log.Id});
	messageBodyInput.messageSegments.add(textSegmentInput);

	feedItemInput.body = messageBodyInput;
	interfaceKeyUserNotifications.add(feedItemInput);
			}
		}
		return interfaceKeyUserNotifications;
	}

	private static List<ConnectApi.BatchInput> getBatchInputs(List<ConnectApi.FeedItemInput> feedItems) {
		List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
		for (ConnectApi.FeedItemInput feedItem : feedItems) {
			batchInputs.add(new ConnectApi.BatchInput(feedItem));
		}
		return batchInputs;
	} 
}