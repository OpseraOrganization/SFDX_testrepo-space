public without sharing class CH_RndInteractionTriggerHandler {
	public static Boolean enablePreventInboundRndInteractionModifyValidation = true;
	 
	/********************
	*Method Name: setCaseReferenceNumber
	*Description: copy Reference Number from Transfer to R&D interaction to Case
	*******************/
	public static void setCaseReferenceNumber(List<CH_Problem_RnD_Reference__c> rndInteractions, Map<Id, CH_Problem_RnD_Reference__c> oldRndItneractions) {
		Map<Id, CH_Problem_RnD_Reference__c> transferToRndInteractions = new Map<Id, CH_Problem_RnD_Reference__c>();
		for (CH_Problem_RnD_Reference__c rndInteraction : rndInteractions) {
			if ((oldRndItneractions.get(rndInteraction.Id).CH_RnD_Reference__c != rndInteraction.CH_RnD_Reference__c && !String.isEmpty(rndInteraction.CH_RnD_Reference__c) && 
	oldRndItneractions.get(rndInteraction.Id).CH_RnD_Status__c != rndInteraction.CH_RnD_Status__c && rndInteraction.CH_RnD_Status__c == 'Completed' && 
	rndInteraction.CH_RnD_Direction__c == 'outbound' && 
	rndInteraction.CH_RnD_Type__c == 'Transfer to R&D' &&
	rndInteraction.CH_Related_Record__c != NULL) && (!transferToRndInteractions.containsKey(rndInteraction.CH_Related_Record__c))) {
	transferToRndInteractions.put(rndInteraction.CH_Related_Record__c, rndInteraction);
			}
		}

		if (!transferToRndInteractions.isEmpty()) {
			List<Case> cases = [SELECT Id, CH_CRNumber__c FROM Case WHERE Id IN :transferToRndInteractions.keySet() AND CH_CRNumber__c = NULL AND CH_R_D_Interface_Flag__c = false];
			if (!cases.isEmpty()) {
	for(Case c : cases) {
		c.CH_CRNumber__c = transferToRndInteractions.get(c.Id).CH_RnD_Reference__c;
		c.CH_R_D_Interface_Flag__c = true;
	}
	update cases;
			}
		}
	}

	public static void preventInboundRndInteractionDelete(List<CH_Problem_RnD_Reference__c> rndInteractions) {
		for (CH_Problem_RnD_Reference__c rndInteraction : rndInteractions) {
			if (rndInteraction.CH_RnD_Direction__c == 'inbound') {
	rndInteraction.addError(String.format(Label.CH_InboundRndInteraction_PreventDeletionValidation, new List<Object>{rndInteraction.Name}));
			}
		}
	}

	public static void preventInboundRndInteractionModify(List<CH_Problem_RnD_Reference__c> rndInteractions, Map<Id, CH_Problem_RnD_Reference__c> oldRndItneractions) {
		if (enablePreventInboundRndInteractionModifyValidation) {
			for (CH_Problem_RnD_Reference__c rndInteraction : rndInteractions) {
	if (oldRndItneractions.get(rndInteraction.Id).CH_RnD_Direction__c == 'inbound') {
		rndInteraction.addError(String.format(Label.CH_InboundRndInteraction_PreventUpdateValidation, new List<Object>{rndInteraction.Name}));
	}
			}
		}
	
	}

	public static void setRecordType(List<CH_Problem_RnD_Reference__c> rndInteractions) {
		Map<String, Id> rndInteractionRecordTypes = new Map<String, Id>();
		for (RecordType rndInteractionRecordType : [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'CH_Problem_RnD_Reference__c']) {
			rndInteractionRecordTypes.put(rndInteractionRecordType.DeveloperName, rndInteractionRecordType.Id);
		}

		for (CH_Problem_RnD_Reference__c rndInteraction : rndInteractions) {
			if (rndInteraction.CH_RnD_Direction__c == 'inbound') {
	if (rndInteraction.CH_RnD_Type__c == 'Workaround') {
		rndInteraction.RecordTypeId = rndInteractionRecordTypes.get('Workaround');
		continue;
	}
	if (rndInteraction.CH_RnD_Type__c == 'Correction Response') {
		rndInteraction.RecordTypeId = rndInteractionRecordTypes.get('Correction');
		continue;
	}
	if (rndInteraction.CH_RnD_Type__c == 'Information Request') {
		rndInteraction.RecordTypeId = rndInteractionRecordTypes.get('Information_Request');
		continue;
	}
	rndInteraction.RecordTypeId = rndInteractionRecordTypes.get('Inbound');
			} else {
	if (rndInteraction.CH_RnD_Status__c == 'Open') {
		rndInteraction.RecordTypeId = rndInteractionRecordTypes.get('Open');
		continue;
	}
	if (rndInteraction.CH_RnD_Status__c == 'Failed') {
		rndInteraction.RecordTypeId = rndInteractionRecordTypes.get('Failed');
		continue;
	}
	if (rndInteraction.CH_RnD_Type__c == 'Transfer to R&D') {
		rndInteraction.RecordTypeId = rndInteractionRecordTypes.get('Transfer_To_RnD');
		continue;
	}
	rndInteraction.RecordTypeId = rndInteractionRecordTypes.get('Outbound');
			}
		}
	}

	public static void setCompletionDate(List<CH_Problem_RnD_Reference__c> rndItneractions) {
		for (CH_Problem_RnD_Reference__c rndInteraction : rndItneractions) {
			if (rndInteraction.CH_RnD_Status__c == 'Completed') {
	rndInteraction.CH_Completion_Date__c = Datetime.Now();
			}
		}
	}

	public static void setCompletionDate(Map<Id, CH_Problem_RnD_Reference__c> newRndItneractions, Map<Id, CH_Problem_RnD_Reference__c> oldRndItneractions) {
		for (CH_Problem_RnD_Reference__c newRndInteraction : newRndItneractions.values()) {
			CH_Problem_RnD_Reference__c oldRndInteraction = oldRndItneractions.get(newRndInteraction.Id);
			if (newRndInteraction.CH_RnD_Status__c != oldRndInteraction.CH_RnD_Status__c && newRndInteraction.CH_RnD_Status__c == 'Completed') {
	newRndInteraction.CH_Completion_Date__c = Datetime.Now();
			}
		}
	}

	public static CH_Problem_RnD_Reference__c updateNotOwnRndInteraction(CH_Problem_RnD_Reference__c rndInteraction) {
		update rndInteraction;
		return rndInteraction;
	}

	public static List<CH_Problem_RnD_Reference__c> updateNotOwnRndInteractions(List<CH_Problem_RnD_Reference__c> rndInteractions) {
		update rndInteractions;
		return rndInteractions;
	}	

	public static List<ConnectApi.FeedItemInput> postFeedItemsForNewInboundRndInteractions(List<CH_Problem_RnD_Reference__c> rndItneractions) {
		List<ConnectApi.BatchInput> batchFeedItemInputs = new List<ConnectApi.BatchInput>();
		List<ConnectApi.FeedItemInput> feedItemInputs = new List<ConnectApi.FeedItemInput>();

		List<CH_Problem_RnD_Reference__c> processedRndInteractions = new List<CH_Problem_RnD_Reference__c>();
		for (CH_Problem_RnD_Reference__c rndInteraction : rndItneractions) {
			if (rndInteraction.CH_Related_Record__c != NULL && rndInteraction.CH_RnD_Direction__c == 'inbound') {
	ConnectApi.FeedItemInput feedItemInput = createFeedItemForNewInboundRndInteraction(rndInteraction);
	feedItemInputs.add(feedItemInput);
	batchFeedItemInputs.add(new ConnectApi.BatchInput(feedItemInput));
	processedRndInteractions.add(rndInteraction);
			}
		}
		if (!batchFeedItemInputs.isEmpty() && !Test.isRunningTest()) {
			ConnectApi.BatchResult[] batchResults = ConnectApi.ChatterFeeds.postFeedElementBatch(null, batchFeedItemInputs);
			for (Integer br = 0; br < batchResults.size(); br++) {
	ConnectApi.BatchResult batchResult = batchResults[br];
	if (!batchResult.isSuccess()) {
		processedRndInteractions[br].addError(batchResult.getErrorMessage());
	}
			}
		}
		
		return feedItemInputs;
	}

	private static ConnectApi.FeedItemInput createFeedItemForNewInboundRndInteraction(CH_Problem_RnD_Reference__c rndInteraction) {
		ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
		feedItemInput.subjectId = rndInteraction.CH_Related_Record__c;
		feedItemInput.body = new ConnectApi.MessageBodyInput();
		feedItemInput.body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

		ConnectApi.TextSegmentInput inboundRndInteractionTypeSegment = new ConnectApi.TextSegmentInput();
		inboundRndInteractionTypeSegment.text = 'R&D Interaction Type: ' + rndInteraction.CH_RnD_Type__c;
		feedItemInput.body.messageSegments.add(inboundRndInteractionTypeSegment);

		ConnectApi.TextSegmentInput inboundRndInteractionSubjectSegment = new ConnectApi.TextSegmentInput();
		inboundRndInteractionSubjectSegment.text = '\nR&D Interaction Subject: ' + rndInteraction.CH_RnD_Subject__c;
		feedItemInput.body.messageSegments.add(inboundRndInteractionSubjectSegment);

		ConnectApi.TextSegmentInput inboundRndInteractionSegment = new ConnectApi.TextSegmentInput();
		inboundRndInteractionSegment.text = '\nInbound R&D Interaction: ';
		feedItemInput.body.messageSegments.add(inboundRndInteractionSegment);

		ConnectApi.EntityLinkSegmentInput inboundRndInteractionLinkSegment = new ConnectApi.EntityLinkSegmentInput();
		inboundRndInteractionLinkSegment.entityId = rndInteraction.Id;
		feedItemInput.body.messageSegments.add(inboundRndInteractionLinkSegment);

		ConnectApi.TextSegmentInput reletedProblemSegment = new ConnectApi.TextSegmentInput();
		reletedProblemSegment.text = '\nRelated Problem: ';
		feedItemInput.body.messageSegments.add(reletedProblemSegment);

		ConnectApi.EntityLinkSegmentInput reletedProblemLinkSegment = new ConnectApi.EntityLinkSegmentInput();
		reletedProblemLinkSegment.entityId = rndInteraction.CH_Related_Record__c;
		feedItemInput.body.messageSegments.add(reletedProblemLinkSegment);

		ConnectApi.TextSegmentInput inboundRndInteractionReferenceSegment = new ConnectApi.TextSegmentInput();
		inboundRndInteractionReferenceSegment.text = '\nR&D Reference: ' + rndInteraction.CH_RnD_Reference__c;
		feedItemInput.body.messageSegments.add(inboundRndInteractionReferenceSegment);

		return feedItemInput;
	}
}