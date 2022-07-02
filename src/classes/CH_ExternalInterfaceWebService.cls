/*******************************
Class Name: CH_ExternalInterfaceWebService
Created by: GCC
Last modified by: GCC
Description: Web service for receiving the requests from NAIP
*******************************/
global without sharing class CH_ExternalInterfaceWebService {
	public static final String PROVIDED_WORKAROUND='provide-workaround';
	public static final String CREATE_INFORMATION_REQUEST='create-informationrequest';
	public static final String CANCEL_INFORMATION_REQUEST ='cancel-informationrequest';
	public static final String CREATE_CORRECTIONPLAN ='create-correctionplan';
	public static final String CREATE_CORRECTIONPLAN_READY='create-correctionready';
	public static final String CANCEL_CORRECTION='cancel-correction';
	public static final String CREATE_INFORMATION_UPDATE='create-informationupdate';
	public static final String UPDATE_ANALYSIS='update-analysis';
	public static final String INFORMATION_UPDATE='Information Update';
	public static final String ACKNOWLEDGE_SUCCESS='acknowledge-success';
	private class S2sException extends Exception {}
	private class RndException extends Exception {}
	
	private static CH_NAIP_Integration_Settings__c naipIntegrationSettings {
		get {
			if (naipIntegrationSettings == NULL) {
	naipIntegrationSettings = CH_NAIP_Integration_Settings__c.getOrgDefaults(); 
			}
			return naipIntegrationSettings;
		}
		set;
	}	
	/********************
* Description: Used to handle create or update Case request from external system
* Method Name: upsertCases
* Parameter: List of CaseObject
* Return: List of CaseObjectResponse
*******************/
	webservice static List<CaseObjectResponse> upsertCases(List<CaseObject> caseObjectList) {
		List<CaseObjectResponse> responses = new List<CaseObjectResponse>();
		if (caseObjectList != NULL) {
			if (caseObjectList.size() == 1) {
	responses.add(handleS2SRequest(caseObjectList[0]));
			} else {
	for (CaseObject request : caseObjectList) {
		CaseObjectResponse response = new CaseObjectResponse(request);
		response.errorMessage = Label.CH_InboundS2SRequest_MultipleRequestValidation;
		responses.add(response);
	}
			}
		}
		system.debug('-41--final----'+responses);
		return responses;
	}
	
	private static CaseObjectResponse handleS2SRequest(CaseObject request) {
		system.debug('---request----'+request);
		CaseObjectResponse response = new CaseObjectResponse(request);
		system.debug('------response---'+response);
		
		Savepoint sp = Database.setSavepoint();
		Case s2sCase = NULL;
		try {
			if (String.isEmpty(request.chActionExternalSystem)) {
	throw new S2sException(Label.CH_InboundUpsertCase_ErrorNoAction);
			} else if (String.isEmpty(request.chCaseOriginSystem)) {
	throw new S2sException(Label.CH_InboundUpsertCase_ErrorNoCaseOriginSystem);
			}
			
			if (request.isCreateCase) {
	return handleCreateCaseS2SRequest(request);
			}
			
			s2sCase = validateS2SCase(request);
			if (request.isRetrieveCase) {
	return handleRetrieveCaseS2SRequest(request, s2sCase);
			}
			if (request.isCreateInformationResponse ||
	request.isCancelCase ||
	request.isAcceptWorkaround ||
	request.isRejectWorkaround ||
	request.isAcceptSolution ||
	request.isRejectSolution ||
	request.isCreateInformationUpdate ||
	request.isAcknowledgeSuccess ||
	request.isAcknowledgeError) {
		return handleCaseCommentS2SRequest(request, s2sCase);
	}
			throw new S2sException(String.format(Label.CH_InboundS2SRequest_UnsupportedActionValidation, new List<Object>{request.chActionExternalSystem}));
		} catch(Exception e) {
			response.errorMessage = e.getMessage();
			Database.rollback(sp);
			
			Interface_Log__c log = createS2SInterfaceLog(request, response);
			CH_UserNotificationUTIL.sendInterfaceKeyUserNotification(request.chCaseOriginSystem, log);
			if (s2sCase != NULL) {
	CH_UserNotificationUTIL.sendS2SFailureNotification(s2sCase.Id, log);
			}
		}
		system.debug('---response----'+response);
		return response;
	}
	
	private static CaseObjectResponse handleCaseCommentS2SRequest(CaseObject request, Case c) {
		validateCaseStatus(c);
		//NOKIASC-26445 start
		updateCapsAttachment(request,c);
		//NOKIASC-26445 end
		
		CaseComment comment = new CaseComment(ParentId = c.Id, IsPublished = true);
		//NOKIASC-27321
		comment.CommentBody = String.format('{0} \n{1} \n{2}', new List<Object>{request.actionType, request.caseCommentTitle, request.caseCommentBody});
		insert comment;
		
		CH_UserNotificationUTIL.sendS2SCaseCommentInboundSuccessNotification(comment.Id);
		
		CaseObjectResponse response = new CaseObjectResponse(NULL, c.CaseNumber, c.CH_CaseOriginSystem__c, c.CH_Action_ExternalSystem__c, c.Reference_Number__c);
		
		if(!Test.isRunningTest()){
			createS2SInterfaceLog(request, response);	
		}
		
		return response;
	}
	
	private static CaseObjectResponse handleCreateCaseS2SRequest(CaseObject request) {
		Case c = convertToCase(new Case(), request);
		insert c;
		//DML_SObject.doInsert(c, true, true);
		//Changes added for NOKIASC-32422
		CH_Portal_Case_TriggerHandler.assignOwner(new Set<Id>{c.Id});
		c = [SELECT Id, CaseNumber, CH_Action_ExternalSystem__c, CH_CaseOriginSystem__c, Reference_Number__c FROM Case WHERE Id =: c.Id];
		CaseObjectResponse response = new CaseObjectResponse(NULL, c.CaseNumber, c.CH_CaseOriginSystem__c, c.CH_Action_ExternalSystem__c, c.Reference_Number__c);
		system.debug('----115---response----'+response);
		
		if(!Test.isRunningTest()){
			createS2SInterfaceLog(request, response);	
		}
		
		return response;
	}
	@TestVisible
	private static void updateCapsAttachment(CaseObject request, Case c) {
		system.debug('--handleCaseCommentS2SRequest ME--existing case-'+c+'---request---'+request);
		system.debug('----request.chCapsAttachmentMetadataFromNaip---'+request.chCapsAttachmentMetadataFromNaip);
		try{
			if(request.chCapsAttachmentMetadataFromNaip != null) {
	c.CH_CAPS_AttachmentMetadatafromNAIP__c = request.chCapsAttachmentMetadataFromNaip;
	update c;
			}
		}
		catch(Exception e){
			throw new S2sException(e.getMessage());
		}
	}
	
	private static CaseObjectResponse handleRetrieveCaseS2SRequest(CaseObject request, Case c) {
		CaseObjectResponse response = new CaseObjectResponse(NULL, c.CaseNumber, c.CH_CaseOriginSystem__c, c.CH_Action_ExternalSystem__c, c.Reference_Number__c);
		response.caseStatus = c.Status;
		
		if(!Test.isRunningTest()){
			createS2SInterfaceLog(request, response);	
		}
		
		return response;
	}
	
	@TestVisible
	private static void validateCaseStatus(Case c) {
		Set<String> inactiveCaseStatuses = new Set<String> {'Completed', 'Cancelled'};
			if (inactiveCaseStatuses.contains(c.Status)) {
	throw new S2sException(String.format(Label.CH_InboundS2SRequest_CaseStatusValidation, new List<Object>{c.Status}));
			}
	}
	
	private static Case validateS2SCase(CaseObject request) {
		String caseNumber;
		if(request.caseNumber != null){
			caseNumber = request.caseNumber;
		} else if(request.referenceNumber != null){
			caseNumber = request.referenceNumber;
		}
		
		List<Case> cases = new List<Case>();
		
		//Start NOKIASC-26602
		if (!String.isEmpty(caseNumber)) {
			cases = [SELECT Id, CaseNumber, Origin,Status, CH_CaseOriginSystem__c, CH_Action_ExternalSystem__c, Reference_Number__c FROM Case WHERE CaseNumber =: caseNumber];
			
			if(cases.isEmpty()){
	cases = [SELECT Id, CaseNumber, Origin, CH_CaseOriginSystem__c, CH_Action_ExternalSystem__c, Reference_Number__c, Status FROM Case WHERE Reference_Number__c =: caseNumber];
			}
			if (cases.isEmpty()) {
	throw new S2sException(String.format(Label.CH_InboundS2SRequest_InvalidCaseNumberValidation, new List<Object>{caseNumber}));
			}
			//End NOKIASC-26602
			else {
	Case c = cases[0];
	if (c.Origin != 'S2S') {
		throw new S2sException(String.format(Label.CH_InboundS2SRequest_InvalidCaseOriginValidation, new List<Object>{c.Origin}));
	} else {
		if (c.CH_CaseOriginSystem__c != request.chCaseOriginSystem) {
			throw new S2sException(String.format(Label.CH_InboundS2SRequest_InvalidCaseOriginSystemValidation, new List<Object>{c.CH_CaseOriginSystem__c}));
		} else {
			return c;
		}
	}
			}
		}
		
		throw new S2sException(Label.CH_InboundS2SRequest_NoCaseNumberValidation);
	}
	
	/********************
* Description: Used to convert record of CaseObject type to Salesforce standard Case object
* Method Name: convertToCase 
* Parameter: Case - terget Case object, CaseObject - source CaseObject record
* Return: Case
*******************/
	private static Case convertToCase(Case c, CaseObject caseObject) {
		// references
		if (caseObject.accountId			!= null && caseObject.accountId != '') {c.AccountId	 = caseObject.accountId;}
		if (caseObject.assetId	!= null && caseObject.assetId != '') {c.AssetId	  = caseObject.assetId;}
		if (caseObject.chProductModule  != null && caseObject.chProductModule !='') {c.CH_Product_Module__c  = caseObject.chProductModule;}
		if (caseObject.contactId			!= null && caseObject.contactId != '') {c.ContactId	 = caseObject.contactId;}
		if (caseObject.entitlementId		!= null && caseObject.entitlementId != '') {c.EntitlementId	= caseObject.entitlementId;}
		if (caseObject.chProblemId	  != null && caseObject.chProblemId != '') {c.CH_Problem__c		 = caseObject.chProblemId;}
		if (caseObject.productId			!= null && caseObject.productId != '') {c.ProductId	 = caseObject.productId;}
		if (caseObject.chProductRelease  != null && caseObject.chProductRelease != '') {c.CH_ProductRelease__c  = caseObject.chProductRelease;}
		if (caseObject.chProductVariant  != null && caseObject.chProductVariant != '') {c.CH_ProductVariant__c  = caseObject.chProductVariant;}
		if (caseObject.chSolution  != null && caseObject.chSolution != '') {c.CH_Solution__c  = caseObject.chSolution;}
		if (caseObject.chSwRelease	  != null && caseObject.chSwRelease != '') {c.CH_SW_Release__c		= caseObject.chSwRelease;}
		if (caseObject.chSwComponent		!= null && caseObject.chSwComponent != '') {c.CH_SW_Component__c		= caseObject.chSwComponent;}
		if (caseObject.chSwBuild			!= null && caseObject.chSwBuild != '') {c.CH_SW_Build__c			= caseObject.chSwBuild;}
		if (caseObject.chSwModule		 != null && caseObject.chSwModule != '') {c.CH_SW_Module__c	= caseObject.chSwModule;}
		if (caseObject.chProblemRndReferenceId	  != null && caseObject.chProblemRndReferenceId != '') {c.CH_Problem_RnD_ReferenceId__c	 = caseObject.chProblemRndReferenceId;}
		
		// picklists
		if (caseObject.chCaseOriginSystem	!= null) {c.CH_CaseOriginSystem__c   = caseObject.chCaseOriginSystem;}
		if (caseObject.chServiceType		!= null) {c.CH_ServiceType__c	= caseObject.chServiceType;}
		if (caseObject.severity	!= null) {c.Severity__c	 = caseObject.severity;}
		if (caseObject.chOutage	!= null) {c.CH_Outage__c	 = caseObject.chOutage;}
		if (caseObject.chStage	!= null) {c.CH_Stage__c	 = caseObject.chStage;}
		if (caseObject.chClassification  != null) {c.CH_Classification__c	= caseObject.chClassification;}
		
		// strings
		if (caseObject.chCustomerDescription			!= null) {
			//NOKIASC-25153 replace \n with <br>
			
			c.CH_CustomerDescription__c = caseObject.chCustomerDescription.replace('\n', '<br>');
		}
		if (caseObject.phoneNo	!= null) {c.Phone_No__c	 = caseObject.phoneNo;}
		if (caseObject.email2	!= null) {c.CH_Email2__c		= caseObject.email2;}
		if (caseObject.status	!= null) {c.Status		= caseObject.status;}
		if (caseObject.subject	!= null) {c.Subject	  = caseObject.subject;}
		//typeVal = 1. Incident 2. Information Request
		if (caseObject.typeVal	!= null && caseObject.typeVal == 'Information Request') {
			c.Type		= caseObject.typeVal;
			c.Severity__c	 = 'Information Request';
		} else if(caseObject.typeVal	!= null) {
			c.Type		= caseObject.typeVal;
		}
		if (caseObject.fax	 != null) {c.FAX__c	  = caseObject.fax;}
		if (caseObject.mobilePhone	  != null) {c.Mobile_Phone__c	= caseObject.mobilePhone;}
		if (caseObject.networkElementID  != null) {c.CH_NetworkElementID__c = caseObject.networkElementID;}
		if (caseObject.referenceNumber  != null) {c.Reference_Number__c   = caseObject.referenceNumber;}
		if (caseObject.chTechnicalAnalysis	!= null) {c.CH_TechnicalAnalysis__c  = caseObject.chTechnicalAnalysis;}
		if (caseObject.chTechnicalSolution	!= null) {c.CH_TemporarySolution__c  = caseObject.chTechnicalSolution;}
		if (caseObject.secLastName	  != null) {c.SEC_Last_Name__c		= caseObject.secLastName;}
		if (caseObject.secFirstName   != null) {c.SEC_First_Name__c	= caseObject.secFirstName;}
		if (caseObject.chActionExternalSystem   != null) {c.CH_Action_ExternalSystem__c	  = caseObject.chActionExternalSystem;}
		if (caseObject.chExternalSystemAccount	  != null) {c.CH_ExternalSystemAccount__c = caseObject.chExternalSystemAccount;}
		if (caseObject.chExternalSystemProductRelease   != null) {c.CH_ExternalSystemProductRelease__c  = caseObject.chExternalSystemProductRelease;}
		if (caseObject.chExternalSystemProductVariant   != null) {c.CH_ExternalSystemProductVariant__c  = caseObject.chExternalSystemProductVariant;}
		if (caseObject.chExternalSystemProduct	  != null) {c.CH_ExternalSystemProduct__c = caseObject.chExternalSystemProduct;}
		if (caseObject.chExternalSystemSolution   != null) {c.CH_ExternalSystemSolution__c	= caseObject.chExternalSystemSolution;}
		if (caseObject.chCapsAttachmentMetadataFromNaip != null) {c.CH_CAPS_AttachmentMetadatafromNAIP__c = caseObject.chCapsAttachmentMetadataFromNaip;}

		// boolean
		if (caseObject.isEscalated	  != null) {c.IsEscalated	 = Boolean.valueOf(caseObject.isEscalated);}
		if (caseObject.chInternalCase	 != null) {c.CH_InternalCase__c	= Boolean.valueOf(caseObject.chInternalCase);}
		
		c.Origin = naipIntegrationSettings.DefaultCaseOrigin__c;
		Id nokiaStandardCaseRecordTypeId= Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByDeveloperName().get(naipIntegrationSettings.DefaultCaseRecordTypeDeveloperName__c).getRecordTypeId();
		c.RecordTypeId = nokiaStandardCaseRecordTypeId;
		
		return c;
	}
	
	/********************
* Description: Used to handle inbound R&D Interaction
* Method Name: handleRndRequest
* Parameter: RndRequest request
* Return: RndResponse response
*******************/
	webservice static RndResponse handleRndRequest(RndRequest request) {
		RndResponse response = new RndResponse(request.rndInteractionInterface);
		Case problem = NULL;
		
		Savepoint sp = Database.setSavepoint();
		try {
			if (request == NULL || String.isEmpty(request.rndInteractionType)) {
	throw new RndException(Label.CH_InboundRndRequest_NoActionValidation);
			} else {
	if (String.isEmpty(request.rndInteractionInterface)) {
		throw new RndException(Label.CH_InboundRndRequest_NoInterfaceNameValidation);
	} else {
		if (!request.isProntoInterface && !request.isJiraInterface) {
			throw new RndException(String.Format(Label.CH_InboundRndRequest_InvalidInterfaceNameValidation, new List<String> {request.rndInteractionInterface}));
		}
	}
			}
			if (request.isProntoInterface && (request.isCreatePcpGroup || request.isUpdatePcpGroup || request.isDeletePcpGroup)) {
		return handleProntoGroupRequest(request, response);
	}
			
			String problemNumber = request.isProntoInterface && request.isUpdateAnalysis ? request.rndInteractionReference : request.rndInteractionOriginatingIncident;
			problem = validateProblem(problemNumber);
			if (request.isProntoInterface) {
	if (request.isProvideWorkaround || request.isCreateInformationRequest || request.isCancelInformationRequest || request.isCreateCorrectionPlan || request.isCreateCorrectionReady || request.isCancelCorrection || request.isUpdateAnalysis) {
		return handleProntoRndRequest(problem, request, response);
	} 
	if (request.isCreateInformationUpdate) {
		return handleProntoCreateInformationUpdateRndRequest(problem, request, response);
	}
	throw new RndException(String.Format(Label.CH_InboundRndRequest_UnsupportedActionValidation, new List<String> {request.rndInteractionType, request.rndInteractionInterface}));
			} else {
	if (request.isUpdateAnalysis || request.isCreateCorrectionPlan || request.isCancelCorrection || request.isProvideWorkaround || request.isCreateInformationRequest || request.isCancelInformationRequest || request.isCreateCorrectionReady) {
		return handleJiraRndRequest(problem, request, response);
	} else if (request.isAcknowledgeSuccess) {
		return handleJiraAcknowledge(problem, request, response);
	} else if (request.isCreateInformationUpdate) {
		return handleJIRACreateInformationUpdateRndRequest(problem, request, response);
	} else {
		throw new RndException(String.Format(Label.CH_InboundRndRequest_UnsupportedActionValidation, new List<String> {request.rndInteractionType, request.rndInteractionInterface}));
	}
			}
		} catch (Exception e) {
			response.rndInteractionErrorMessage = e.getMessage();
			Database.rollback(sp);
			
			Interface_Log__c failureLog = createRndInterfaceLog(problem, request, response);
			if (!String.isEmpty(request.intefaceName)) {
	CH_UserNotificationUTIL.sendInterfaceKeyUserNotification(request.intefaceName, failureLog);
			}
		}
		
		return response;
	}

	private static RndResponse handleJIRACreateInformationUpdateRndRequest(Case problem, RndRequest request, RndResponse response) {
		CH_Problem_RnD_Reference__c rndInteraction = initializeInboundRndInteraction('JIRA', request);
		rndInteraction.CH_Related_Record__c = problem.Id;
		insert rndInteraction;
		
		String inboundCreateInformationRequestType = 'Information Request';
		String outboundCreateInformationResponseType = 'Information Response';
		Map<String, List<CH_Problem_RnD_Reference__c>> rndInteractionTypes = new Map<String, List<CH_Problem_RnD_Reference__c>> {inboundCreateInformationRequestType => new List<CH_Problem_RnD_Reference__c>(),
			outboundCreateInformationResponseType => new List<CH_Problem_RnD_Reference__c>()};
	for (CH_Problem_RnD_Reference__c r : [SELECT Id, CH_RnD_Description__c, CH_RnD_Type__c, CH_RnD_Direction__c FROM CH_Problem_RnD_Reference__c 
	  WHERE CH_Related_Record__c =: problem.Id AND CH_RnD_Type__c IN :rndInteractionTypes.keySet() AND CH_RnD_Interface__c = 'JIRA' AND CH_RnD_Reference__c =: rndInteraction.CH_RnD_Reference__c]) {
	if (r.CH_RnD_Type__c == inboundCreateInformationRequestType && r.CH_RnD_Direction__c == 'inbound') {
	 rndInteractionTypes.get(inboundCreateInformationRequestType).add(r);
	} else {
	 if (r.CH_RnD_Type__c == outboundCreateInformationResponseType && r.CH_RnD_Direction__c == 'outbound') {
	  rndInteractionTypes.get(outboundCreateInformationResponseType).add(r);
	 }
	}
	  }
		if (!rndInteractionTypes.get(inboundCreateInformationRequestType).isEmpty() && rndInteractionTypes.get(outboundCreateInformationResponseType).isEmpty()) {
			List<CH_Problem_RnD_Reference__c> inboundCreateInformationRequestsForUpdate = new List<CH_Problem_RnD_Reference__c>();
			for (CH_Problem_RnD_Reference__c r : rndInteractionTypes.get(inboundCreateInformationRequestType)) {
	if (rndInteraction.CH_RnD_Description__c != r.CH_RnD_Description__c) {
		r.CH_RnD_Description__c = rndInteraction.CH_RnD_Description__c;
		inboundCreateInformationRequestsForUpdate.add(r);
	}
			}
			
			if (!inboundCreateInformationRequestsForUpdate.isEmpty()) {
	CH_RndInteractionTriggerHandler.enablePreventInboundRndInteractionModifyValidation = false;
	CH_RndInteractionTriggerHandler.updateNotOwnRndInteractions(inboundCreateInformationRequestsForUpdate);
			}
		}
		
		createRndInteractionInterfaceLog(problem, rndInteraction, request);
		
		response.rndInteractionStatus = rndInteraction.CH_RnD_Status__c;
		return response;
	}
	
	private static RndResponse handleProntoCreateInformationUpdateRndRequest(Case problem, RndRequest request, RndResponse response) {
		CH_Problem_RnD_Reference__c rndInteraction = initializeInboundRndInteraction('PRONTO', request);
		rndInteraction.CH_Related_Record__c = problem.Id;
		insert rndInteraction;
		
		String inboundCreateInformationRequestType = 'Information Request';
		String outboundCreateInformationResponseType = 'Information Response';
		Map<String, List<CH_Problem_RnD_Reference__c>> rndInteractionTypes = new Map<String, List<CH_Problem_RnD_Reference__c>> {inboundCreateInformationRequestType => new List<CH_Problem_RnD_Reference__c>(),
			outboundCreateInformationResponseType => new List<CH_Problem_RnD_Reference__c>()};
	for (CH_Problem_RnD_Reference__c r : [SELECT Id, CH_RnD_Description__c, CH_RnD_Type__c, CH_RnD_Direction__c FROM CH_Problem_RnD_Reference__c 
	  WHERE CH_Related_Record__c =: problem.Id AND CH_RnD_Type__c IN :rndInteractionTypes.keySet() AND CH_RnD_Interface__c = 'PRONTO' AND CH_RnD_Reference__c =: rndInteraction.CH_RnD_Reference__c]) {
	if (r.CH_RnD_Type__c == inboundCreateInformationRequestType && r.CH_RnD_Direction__c == 'inbound') {
	 rndInteractionTypes.get(inboundCreateInformationRequestType).add(r);
	} else {
	 if (r.CH_RnD_Type__c == outboundCreateInformationResponseType && r.CH_RnD_Direction__c == 'outbound') {
	  rndInteractionTypes.get(outboundCreateInformationResponseType).add(r);
	 }
	}
	  }
		if (!rndInteractionTypes.get(inboundCreateInformationRequestType).isEmpty() && rndInteractionTypes.get(outboundCreateInformationResponseType).isEmpty()) {
			List<CH_Problem_RnD_Reference__c> inboundCreateInformationRequestsForUpdate = new List<CH_Problem_RnD_Reference__c>();
			for (CH_Problem_RnD_Reference__c r : rndInteractionTypes.get(inboundCreateInformationRequestType)) {
	if (rndInteraction.CH_RnD_Description__c != r.CH_RnD_Description__c) {
		r.CH_RnD_Description__c = rndInteraction.CH_RnD_Description__c;
		inboundCreateInformationRequestsForUpdate.add(r);
	}
			}
			
			if (!inboundCreateInformationRequestsForUpdate.isEmpty()) {
	CH_RndInteractionTriggerHandler.enablePreventInboundRndInteractionModifyValidation = false;
	CH_RndInteractionTriggerHandler.updateNotOwnRndInteractions(inboundCreateInformationRequestsForUpdate);
			}
		}
		
		createRndInteractionInterfaceLog(problem, rndInteraction, request);
		
		response.rndInteractionStatus = rndInteraction.CH_RnD_Status__c;
		return response;
	}
	/*
Lastmodified Details - Pronto-RD Enhancement: Receive Attachments from R&D
Name - Vinod 
Date - 06-07-2020
User Story - NOKIASC-24431
*/
	private static RndResponse handleProntoRndRequest(Case problem, RndRequest request, RndResponse response) {
		CH_Problem_RnD_Reference__c rnDInteraction = initializeInboundRndInteraction('PRONTO', request);
		rndInteraction.CH_Related_Record__c = problem.Id;
		insert rnDInteraction;
		
		//NOKIASC-24431 start
		if(request.isCreateInformationRequest || request.isProvideWorkaround){
			if(request.caseAttachmentMetadata !=null && request.caseAttachmentMetadata !=''){
	problem.CH_CAPS_AttachmentMetadatafromNAIP__c = request.caseAttachmentMetadata;
			}
			update problem;
		}
		// NOKIASC-24431 end
		
		if (request.isCreateCorrectionPlan || request.isCreateCorrectionReady|| request.isCancelCorrection) {
			//NOKIASC-24431 start
	if((request.isCreateCorrectionPlan || request.isCreateCorrectionReady) && (request.caseAttachmentMetadata !=null &&	request.caseAttachmentMetadata !='')){
		problem.CH_CAPS_AttachmentMetadatafromNAIP__c = request.caseAttachmentMetadata;
	}
			//NOKIASC-24431 End
			//problem.CH_Target_Release__c = request.caseTargetRelease;
			//problem.CH_Target_Release_Date__c = request.caseTargetReleaseDate;
			CH_CaseField_SideHighlightApex.createorUpdatePrivateFeedRecord(problem.Id,request.caseTargetRelease,request.caseTargetReleaseDate);//NOKIASC-35878
			problem.CH_JIRA_ExternalStatus__c = request.caseJiraExternalStatus;
			problem.CH_JIRA_ResolutionCode__c = request.caseJiraResolutionCode;
			
			update problem;
		} else {
			if (request.isUpdateAnalysis) {
	if (String.isEmpty(request.caseContactEmail)) {
		problem.CH_RnD_Contact__c = NULL;
		problem.CH_RnD_Contact_Email__c = NULL;
		//problem.CH_Target_Release__c = request.caseTargetRelease;
		//problem.CH_Target_Release_Date__c = request.caseTargetReleaseDate;
		CH_CaseField_SideHighlightApex.createorUpdatePrivateFeedRecord(problem.Id,request.caseTargetRelease,request.caseTargetReleaseDate);//NOKIASC-35878
		problem.CH_JIRA_ExternalStatus__c = request.caseJiraExternalStatus;
		problem.CH_JIRA_ResolutionCode__c = request.caseJiraResolutionCode;
	} else {
		List<User> rndUsers = [SELECT Id FROM User WHERE Email =: request.caseContactEmail];
		if (rndUsers.size() == 1) {
			problem.CH_RnD_Contact__c = rndUsers[0].Id;
		} else {
			problem.CH_RnD_Contact__c = NULL;
		}
		problem.CH_RnD_Contact_Email__c = request.caseContactEmail;
	// problem.CH_Target_Release__c = request.caseTargetRelease;
	// problem.CH_Target_Release_Date__c = request.caseTargetReleaseDate;
	CH_CaseField_SideHighlightApex.createorUpdatePrivateFeedRecord(problem.Id,request.caseTargetRelease,request.caseTargetReleaseDate);//NOKIASC-35878
		problem.CH_JIRA_ExternalStatus__c = request.caseJiraExternalStatus;
		problem.CH_JIRA_ResolutionCode__c = request.caseJiraResolutionCode;
	}
	update problem;
			}
		}
		
		createRndInteractionInterfaceLog(problem, rndInteraction, request);
		
		response.rndInteractionStatus = rndInteraction.CH_RnD_Status__c;
		return response;
	}
	
	private static RndResponse handleProntoGroupRequest(RndRequest request, RndResponse response) {
		List<CH_Pronto_Group__c> existingGroup = [SELECT Name, CH_Pronto_Group_Title__c, CH_Pronto_Group_Description__c, CH_Pronto_Group_Status__c 
	 FROM CH_Pronto_Group__c WHERE Name = :request.pcpGroupName LIMIT 1];
		
		if (request.isCreatePcpGroup) {
			// If there is duplicate values in the table - No action is taken
			if (existingGroup.size() > 0) {
	throw new RndException(Label.CH_InboundRndRequest_ProntoGroupDuplicateError);
			} else {
	// If there is no duplicate values in the table - A new record is created with the values from create-pcpgroup message
	CH_Pronto_Group__c pcpgroup = new CH_Pronto_Group__c();
	pcpgroup.Name = request.pcpGroupName;
	pcpgroup.CH_Pronto_Group_Title__c = request.pcpGroupTitle;
	pcpgroup.CH_Pronto_Group_Description__c = request.pcpGroupDescription;
	pcpgroup.CH_Pronto_Group_Status__c = 'Active';
	pcpgroup.CH_Pronto_Group_Origin__c = 'Interface';
	insert pcpgroup;
	
	createRndPcpGroupInterfaceLog(pcpgroup, 'Insert', request);
	
	response.rndInteractionStatus = 'Active';
			}
		} else if (request.isUpdatePcpGroup) {
			//  If the groupname entry is NOT found in the table - No action is taken
			if (existingGroup.size() == 0) {
	throw new RndException(Label.CH_InboundRndRequest_ProntoGroupNotFoundError);
			} else {
	//  If the groupname entry is found in the table - The Existing record is updated with the values from update-pcpgroup message
	existingGroup.get(0).CH_Pronto_Group_Title__c = request.pcpGroupTitle;
	existingGroup.get(0).CH_Pronto_Group_Description__c = request.pcpGroupDescription;
	update existingGroup;
	
	createRndPcpGroupInterfaceLog(existingGroup.get(0), 'Update', request);
	
	response.rndInteractionStatus = existingGroup.get(0).CH_Pronto_Group_Status__c;
			}
		} else if (request.isDeletePcpGroup) {
			// If the groupname entry is NOT found in the table - No action is taken
			if (existingGroup.size() == 0) {
	throw new RndException(Label.CH_InboundRndRequest_ProntoGroupNotFoundError);
			} else {
	// If the groupname entry is found in the table - The Existing record is marked inactive and then deleted
	existingGroup.get(0).CH_Pronto_Group_Status__c = 'Inactive';
	update existingGroup;
	response.rndInteractionStatus = existingGroup.get(0).CH_Pronto_Group_Status__c;
	
	createRndPcpGroupInterfaceLog(existingGroup.get(0), 'Delete', request);
	
	delete existingGroup;
			}
		}
		return response;
	}
	
	private static RndResponse handleJiraRndRequest(Case problem, RndRequest request, RndResponse response) {
		CH_Problem_RnD_Reference__c rndInteraction = initializeInboundRndInteraction('JIRA', request);
		rndInteraction.CH_Related_Record__c = problem.Id;
		insert rndInteraction;
		
		if(request.isCreateInformationRequest || request.isProvideWorkaround){
			if(request.caseAttachmentMetadata !=null && request.caseAttachmentMetadata !=''){
	problem.CH_CAPS_AttachmentMetadatafromNAIP__c = request.caseAttachmentMetadata;
			}
			update problem;
		}
		if (request.isCreateCorrectionPlan || request.isCreateCorrectionReady|| request.isCancelCorrection) {
			//NOKIASC-24431 start
			if((request.isCreateCorrectionPlan || request.isCreateCorrectionReady) && (request.caseAttachmentMetadata !=null && request.caseAttachmentMetadata !='')){
	problem.CH_CAPS_AttachmentMetadatafromNAIP__c = request.caseAttachmentMetadata;
			}
			//NOKIASC-24431 End
			//problem.CH_Target_Release__c = request.caseTargetRelease;
			//problem.CH_Target_Release_Date__c = request.caseTargetReleaseDate;
			CH_CaseField_SideHighlightApex.createorUpdatePrivateFeedRecord(problem.Id,request.caseTargetRelease,request.caseTargetReleaseDate);//NOKIASC-35878
			problem.CH_JIRA_ExternalStatus__c = request.caseJiraExternalStatus;
			problem.CH_JIRA_ResolutionCode__c = request.caseJiraResolutionCode;
			
			update problem;
		} else {
			if (request.isUpdateAnalysis) {
	if (String.isEmpty(request.caseContactEmail)) {
		problem.CH_RnD_Contact__c = NULL;
		problem.CH_RnD_Contact_Email__c = NULL;
		//problem.CH_Target_Release__c = request.caseTargetRelease;
		//problem.CH_Target_Release_Date__c = request.caseTargetReleaseDate;
		CH_CaseField_SideHighlightApex.createorUpdatePrivateFeedRecord(problem.Id,request.caseTargetRelease,request.caseTargetReleaseDate);//NOKIASC-35878
		problem.CH_JIRA_ExternalStatus__c = request.caseJiraExternalStatus;
		problem.CH_JIRA_ResolutionCode__c = request.caseJiraResolutionCode;
	} else {
		List<User> rndUsers = [SELECT Id FROM User WHERE Email =: request.caseContactEmail];
		if (rndUsers.size() == 1) {
			problem.CH_RnD_Contact__c = rndUsers[0].Id;
		} else {
			problem.CH_RnD_Contact__c = NULL;
		}
		problem.CH_RnD_Contact_Email__c = request.caseContactEmail;
	// problem.CH_Target_Release__c = request.caseTargetRelease;
	// problem.CH_Target_Release_Date__c = request.caseTargetReleaseDate;
	CH_CaseField_SideHighlightApex.createorUpdatePrivateFeedRecord(problem.Id,request.caseTargetRelease,request.caseTargetReleaseDate);//NOKIASC-35878
		problem.CH_JIRA_ExternalStatus__c = request.caseJiraExternalStatus;
		problem.CH_JIRA_ResolutionCode__c = request.caseJiraResolutionCode;
	}
	update problem;
			}
		}
		
		createRndInteractionInterfaceLog(problem, rndInteraction, request);
		
		response.rndInteractionStatus = rndInteraction.CH_RnD_Status__c;
		return response;
	}
	
	private static RndResponse handleJiraAcknowledge(Case problem, RndRequest request, RndResponse response) {
		CH_Problem_RnD_Reference__c createAnalysisRndInteraction = validateCreateAnalysisRndInteraction(problem);
		createAnalysisRndInteraction.CH_RnD_Status__c = 'Completed';
		createAnalysisRndInteraction.CH_RnD_Reference__c = request.rndInteractionReference;
		CH_RndInteractionTriggerHandler.updateNotOwnRndInteraction(createAnalysisRndInteraction);
		
		CH_Problem_RnD_Reference__c rndInteraction = initializeInboundRndInteraction('JIRA', request);
		rndInteraction.CH_Related_Record__c = problem.Id;
		insert rndInteraction;
		
		problem.CH_JIRA_ExternalStatus__c = request.caseJiraExternalStatus;
		//problem.CH_Target_Release__c = request.caseTargetRelease;
		//problem.CH_Target_Release_Date__c = request.caseTargetReleaseDate;
		CH_CaseField_SideHighlightApex.createorUpdatePrivateFeedRecord(problem.Id,request.caseTargetRelease,request.caseTargetReleaseDate);//NOKIASC-35878
		problem.CH_JIRA_ResolutionCode__c = request.caseJiraResolutionCode;
		
		update problem;
		
		createRndInteractionInterfaceLog(problem, rndInteraction, request);
		
		response.rndInteractionStatus = rndInteraction.CH_RnD_Status__c;   
		return response;
	}
	
	private static Case validateProblem(String caseNumber) {
		if (!String.isEmpty(caseNumber)) {
			List<Case> cases = [SELECT Id FROM Case WHERE CaseNumber =: caseNumber];
			if (cases.isEmpty()) {
	throw new RndException(String.Format(Label.CH_InboundRndRequest_InvalidProblemNumberValidation, new List<Object> {caseNumber}));
			} else {
	return cases[0];
			}
		}
		throw new RndException(Label.CH_InboundRndRequest_NoProblemNumberValidation);
	}
	
	private static CH_Problem_RnD_Reference__c validateCreateAnalysisRndInteraction(Case problem) {
		List<CH_Problem_RnD_Reference__c> createAnalysisRndInteractions = [SELECT Id FROM CH_Problem_RnD_Reference__c
		 WHERE CH_Related_Record__c =: problem.Id 
		 AND CH_RnD_Interface__c = 'JIRA' 
		 AND CH_RnD_Status__c = 'In Progress' 
		 AND CH_RnD_Type__c = 'Transfer to R&D' 
		 AND CH_RnD_Direction__c = 'Outbound'];
		if (createAnalysisRndInteractions.isEmpty()) {
			throw new RndException(Label.CH_InboundRndRequest_NoInitialCreateAnalysisValidation);
		}
		return createAnalysisRndInteractions[0];
	}
	
	private static CH_Problem_RnD_Reference__c initializeInboundRndInteraction(String interfaceName, RndRequest request) {
		CH_Problem_RnD_Reference__c rnDInteraction = new CH_Problem_RnD_Reference__c(CH_RnD_Status__c = 'Completed',
			 CH_RnD_Interface__c = interfaceName,
			 CH_RnD_Direction__c = 'inbound',
			 CH_RnD_Type__c = request.interactionType,
			 CH_RnD_Subject__c = request.interactionSubject,
			 CH_RnD_Description__c = request.rndInteractionDescription,
			 CH_RnD_Reference__c = request.rndInteractionReference);
		return rndInteraction;
	}
	
	private static void createRndPcpGroupInterfaceLog(CH_Pronto_Group__c prontoGroup, String operationType, RndRequest request) {
		String logName = String.format('R&D Inbound {0}', new List<Object> {request.rndInteractionType});
		String requestLog = String.format('R&D {0} {1}. Pronto Group: {3}. Pronto group name: {4}\n{5}', new List<Object> {request.rndInteractionInterface, request.rndInteractionType, prontoGroup.Id, request.pcpGroupName, request});
		Interface_Log__c log = CH_ExternalInterfaceUTIL.createInboundRndInterfaceLog(logName, operationType, requestLog, NULL);
		insert log;
	}
	
	private static void createRndInteractionInterfaceLog(Case problem, CH_Problem_RnD_Reference__c rndInteraction, RndRequest request) {
		String logName = String.format('R&D Inbound {0} {1}', new List<Object> {rndInteraction.CH_RnD_Type__c, problem.Id});
		String requestLog = String.format('R&D {0} {1}. R&D Interaction: {3}\n{4}', new List<Object> {rndInteraction.CH_RnD_Interface__c, rndInteraction.CH_RnD_Type__c, rndInteraction.Id, request});
		Interface_Log__c log = CH_ExternalInterfaceUTIL.createInboundRndInterfaceLog(logName, 'Insert', requestLog, NULL);
		insert log;
	}
	
	private static Interface_Log__c createRndInterfaceLog(Case problem, RndRequest request, RndResponse response) {
		Interface_Log__c log = NULL;
		if (request == NULL) {
			log = CH_ExternalInterfaceUTIL.createInboundRndInterfaceLog('R&D Inbound', NULL, String.format('R&D {0}', new List<Object> {request}), response.rndInteractionErrorMessage);
		} else {
			String logName = problem == NULL 
	? String.format('R&D Inbound {0}', new List<Object> {request.rndInteractionType}) 
	: String.format('R&D Inbound {0} {1}', new List<Object> {request.rndInteractionType, problem.Id});
			
			String requestLog = String.format('R&D {0} {1}\n{2}', new List<Object> {request.rndInteractionInterface, request.rndInteractionType, request});
			log = CH_ExternalInterfaceUTIL.createInboundRndInterfaceLog(logName, NULL, requestLog, response.rndInteractionErrorMessage);
		}
		insert log;
		
		return log;
	}
	
	private static Interface_Log__c createS2SInterfaceLog(CaseObject request, CaseObjectResponse response) {
		String logName = NULL;
		String requestLog = NULL;
		String operationType = NULL;
		
		if (request.isRetrieveCase) {
			logName = String.format('Inbound {0} Case({1})', new List<Object> {request.chCaseOriginSystem, request.caseNumber});
			requestLog = String.format('Inbound {0} {1}: {2}', new List<Object> {request.chCaseOriginSystem, request.caseNumber, request});
		} else {
			logName = String.format('Inbound {0} Case', new List<Object> {request.chCaseOriginSystem});
			requestLog = String.format('Inbound Case {0}', new List<Object> {request});
			if (request.isCreateCase) {
	operationType = 'Insert';
			}
		}
		Interface_Log__c log = CH_ExternalInterfaceUTIL.createInboundCustomerS2SInterfaceLog(logName, requestLog, response.errorMessage, operationType);
		insert log;
		
		return log;
	}
	
	global class RndRequest {
		webservice String rndInteractionType;
		webservice String rndInteractionInterface;
		webservice String rndInteractionReference;
		webservice String rndInteractionOriginatingIncident;
		webservice String rndInteractionSubject;
		webservice String rndInteractionDescription;
		webservice String caseAttachmentMetadata;
		webservice String caseTargetRelease;
		webservice Date caseTargetReleaseDate;
		webservice String caseContactEmail;
		webservice String caseContactInfo;
		webservice String caseJiraExternalStatus;
		webservice String caseJiraResolutionCode;
		webservice String pcpGroupTitle;
		webservice String pcpGroupName;
		webservice String pcpGroupDescription;
		webservice String pcpGroupSystemUserEmail;
		
		private Map<String, String> interactionTypes {
			get {
	if (interactionTypes == NULL) {
		interactionTypes = new Map<String, String>{CH_ExternalInterfaceWebService.PROVIDED_WORKAROUND => 'Workaround',
			CH_ExternalInterfaceWebService.CREATE_INFORMATION_REQUEST => 'Information Request',
			CH_ExternalInterfaceWebService.CANCEL_INFORMATION_REQUEST => 'Cancel Information Request',
			CH_ExternalInterfaceWebService.CREATE_CORRECTIONPLAN => 'Correction Plan',
			CH_ExternalInterfaceWebService.CREATE_CORRECTIONPLAN_READY => 'Correction Response',
			CH_ExternalInterfaceWebService.CANCEL_CORRECTION => 'Correction Not Needed',
			CH_ExternalInterfaceWebService.CREATE_INFORMATION_UPDATE => 'Update from R&D',
			CH_ExternalInterfaceWebService.UPDATE_ANALYSIS => CH_ExternalInterfaceWebService.INFORMATION_UPDATE,
			CH_ExternalInterfaceWebService.ACKNOWLEDGE_SUCCESS => 'Acknowledgement'};
	}
	return interactionTypes;
			}
			set;
		}
		public String interactionType {
			get {
	if (interactionType == NULL) {
		interactionType = interactionTypes.get(rndInteractionType);
	}
	return interactionType;
			}
			set;
		}
		private Map<String, String> interactionSubjects {
			get {
	if (interactionSubjects == NULL) {
		interactionSubjects = new Map<String, String>{CH_ExternalInterfaceWebService.PROVIDED_WORKAROUND => 'Workaround',
			CH_ExternalInterfaceWebService.CREATE_INFORMATION_REQUEST => 'Information Request from Pronto',
			CH_ExternalInterfaceWebService.CANCEL_INFORMATION_REQUEST => 'Cancel Information Request',
			CH_ExternalInterfaceWebService.CREATE_CORRECTIONPLAN => 'Correction Plan',
			CH_ExternalInterfaceWebService.CREATE_CORRECTIONPLAN_READY => 'Correction Ready',
			CH_ExternalInterfaceWebService.CANCEL_CORRECTION => 'Correction Not Needed',
			CH_ExternalInterfaceWebService.CREATE_INFORMATION_UPDATE => CH_ExternalInterfaceWebService.INFORMATION_UPDATE,
			CH_ExternalInterfaceWebService.UPDATE_ANALYSIS => 'Information Update from R&D',
			CH_ExternalInterfaceWebService.ACKNOWLEDGE_SUCCESS => 'Transfer Success'};
	}
	return interactionSubjects;
			}
			set;
		}
		public String interactionSubject {
			get {
	if (interactionSubject == NULL) {
		interactionSubject = rndInteractionSubject;
		if (String.isEmpty(interactionSubject)) {
			interactionSubject = interactionSubjects.get(rndInteractionType);
		}
	}
	return interactionSubject;
			}
			set;
		}
		public Boolean isProntoInterface {
			get {
	if (isProntoInterface == NULL) {
		isProntoInterface = rndInteractionInterface == 'pronto';
	}
	return isProntoInterface;
			}
			set;
		}
		public Boolean isJiraInterface {
			get {
	if (isJiraInterface == NULL) {
		isJiraInterface = rndInteractionInterface == 'jira-bridge';
	}
	return isJiraInterface;
			}
			set;
		}
		public String intefaceName {
			get {
	if (isProntoInterface) {
		intefaceName = 'PRONTO';
	} else {
		if (isJiraInterface) {
			intefaceName = 'JIRA';
		}
	}
	return intefaceName;
			}
			set;
		}
		public Boolean isProvideWorkaround {
			get {
	if (isProvideWorkaround == NULL) {
		isProvideWorkaround = rndInteractionType == CH_ExternalInterfaceWebService.PROVIDED_WORKAROUND;
	}
	return isProvideWorkaround;
			}
			set;
		}
		public Boolean isCreateInformationRequest {
			get {
	if (isCreateInformationRequest == NULL) {
		isCreateInformationRequest = rndInteractionType == CH_ExternalInterfaceWebService.CREATE_INFORMATION_REQUEST;
	}
	return isCreateInformationRequest;
			}
			set;
		}
		public Boolean isCancelInformationRequest {
			get {
	if (isCancelInformationRequest == NULL) {
		isCancelInformationRequest = rndInteractionType == CH_ExternalInterfaceWebService.CANCEL_INFORMATION_REQUEST;
	}
	return isCancelInformationRequest;
			}
			set;
		}
		public Boolean isCreateCorrectionPlan {
			get {
	if (isCreateCorrectionPlan == NULL) {
		isCreateCorrectionPlan = rndInteractionType == CH_ExternalInterfaceWebService.CREATE_CORRECTIONPLAN;
	}
	return isCreateCorrectionPlan;
			}
			set;
		}
		public Boolean isCreateCorrectionReady {
			get {
	if (isCreateCorrectionReady == NULL) {
		isCreateCorrectionReady = rndInteractionType == CH_ExternalInterfaceWebService.CREATE_CORRECTIONPLAN_READY;
	}
	return isCreateCorrectionReady;
			}
			set;
		}
		public Boolean isCancelCorrection {
			get {
	if (isCancelCorrection == NULL) {
		isCancelCorrection = rndInteractionType == CH_ExternalInterfaceWebService.CANCEL_CORRECTION;
	}
	return isCancelCorrection;
			}
			set;
		}
		public Boolean isCreateInformationUpdate {
			get {
	if (isCreateInformationUpdate == NULL) {
		isCreateInformationUpdate = rndInteractionType == CH_ExternalInterfaceWebService.CREATE_INFORMATION_UPDATE;
	}
	return isCreateInformationUpdate;
			}
			set;
		}
		public Boolean isUpdateAnalysis {
			get {
	if (isUpdateAnalysis == NULL) {
		isUpdateAnalysis = rndInteractionType == CH_ExternalInterfaceWebService.UPDATE_ANALYSIS;
	}
	return isUpdateAnalysis;
			}
			set;
		}
		public Boolean isCreatePcpGroup {
			get {
	if (isCreatePcpGroup == NULL) {
		isCreatePcpGroup = rndInteractionType == 'create-pcpgroup';
	}
	return isCreatePcpGroup;
			}
			set;
		}
		public Boolean isUpdatePcpGroup {
			get {
	if (isUpdatePcpGroup == NULL) {
		isUpdatePcpGroup = rndInteractionType == 'update-pcpgroup';
	}
	return isUpdatePcpGroup;
			}
			set;
		}
		public Boolean isDeletePcpGroup {
			get {
	if (isDeletePcpGroup == NULL) {
		isDeletePcpGroup = rndInteractionType == 'delete-pcpgroup';
	}
	return isDeletePcpGroup;
			}
			set;
		}
		public Boolean isAcknowledgeSuccess {
			get {
	if (isAcknowledgeSuccess == NULL) {
		isAcknowledgeSuccess = rndInteractionType == CH_ExternalInterfaceWebService.ACKNOWLEDGE_SUCCESS;
	}
	return isAcknowledgeSuccess;
			}
			set;
		}
	}
	
	global class RndResponse {
		webservice String rndInteractionErrorMessage;
		webservice String rndInteractionStatus;
		webservice String rndInteractionInterface;
		
		public RndResponse(String rndInteractionInterface) {
			this.rndInteractionInterface = rndInteractionInterface; 
		}
	}
	
	global class CaseObject {
		webservice String accountId;
		webservice String assetId;
		webservice String chProductModule;
		webservice String caseNumber;
		webservice String origin;
		webservice String chCaseOriginSystem;
		webservice String recordTypeId;
		webservice String email2;
		webservice String contactId;
		webservice String phoneNo;
		webservice String chCustomerDescription;
		webservice String entitlementId;
		webservice String isEscalated;
		webservice String status;
		webservice String subject;
		webservice String typeVal;
		webservice String fax;
		webservice String mobilePhone;
		webservice String networkElementID;
		webservice String chProblemId;
		webservice String productId;
		webservice String chProductRelease;
		webservice String chProductVariant;
		webservice String chSolution;
		webservice String referenceNumber;
		webservice String chServiceType;
		webservice String severity;
		webservice String chSwRelease;
		webservice String chSwComponent;
		webservice String chSwBuild;
		webservice String chSwModule;
		webservice String chTechnicalAnalysis;
		webservice String chTechnicalSolution;
		webservice String secLastName;
		webservice String secFirstName;
		webservice String chActionExternalSystem;
		webservice String chInternalCase;
		webservice String chProblemRndReferenceId;
		webservice String chExternalSystemAccount;
		webservice String chExternalSystemProductRelease;
		webservice String chExternalSystemProductVariant;
		webservice String chExternalSystemProduct;
		webservice String chExternalSystemSolution;
		webservice String chOutage;
		webservice String chStage;
		webservice String chClassification;
		webservice String chCapsAttachmentMetadataFromNaip;
		webservice String chTargetRelease;
		webservice Date chTargetReleaseDate;
		webservice String chJiraExternalStatus;
		webservice String chJiraResolutionCode;
		webservice String caseCommentTitle;
		webservice String caseCommentBody;
		
		private Map<String, String> actionTypes {
			get {
	if (actionTypes == NULL) {
		actionTypes = new Map<String, String>{'create-informationresponse' => 'Information Response',
			'cancel-case' => 'Cancel Case',
			'accept-workaround' => 'Accept Workaround',
			'reject-workaround' => 'Reject Workaround',
			'accept-solution' => 'Solution Accepted',
			'reject-solution' => 'Solution Rejected',
			CH_ExternalInterfaceWebService.CREATE_INFORMATION_UPDATE => CH_ExternalInterfaceWebService.INFORMATION_UPDATE,
			CH_ExternalInterfaceWebService.ACKNOWLEDGE_SUCCESS => 'Acknowledge Success',
			'acknowledge-error' => 'Acknowledge Error'};
	}
	return actionTypes;
			}
			set;
		}
		public String actionType {
			get {
	if (actionType == NULL) {
		actionType = actionTypes.get(chActionExternalSystem);
	}
	return actionType;
			}
			set;
		}
		
		public Boolean isRetrieveCase {
			get {
	if (isRetrieveCase == NULL) {
		isRetrieveCase = chActionExternalSystem == 'retrieve-case';
	}
	return isRetrieveCase;
			}
			set;
		}
		public Boolean isCreateCase {
			get {
	if (isCreateCase == NULL) {
		isCreateCase = chActionExternalSystem == 'create-case';
	}
	return isCreateCase;
			}
			set;
		}
		public Boolean isCreateInformationUpdate {
			get {
	if (isCreateInformationUpdate == NULL) {
		isCreateInformationUpdate = chActionExternalSystem == CH_ExternalInterfaceWebService.CREATE_INFORMATION_UPDATE;
	}
	return isCreateInformationUpdate;
			}
			set;
		}
		public Boolean isCancelCase {
			get {
	if (isCancelCase == NULL) {
		isCancelCase = chActionExternalSystem == 'cancel-case';
	}
	return isCancelCase;
			}
			set;
		}
		public Boolean isAcceptWorkaround {
			get {
	if (isAcceptWorkaround == NULL) {
		isAcceptWorkaround = chActionExternalSystem == 'accept-workaround';
	}
	return isAcceptWorkaround;
			}
			set;
		}
		public Boolean isRejectWorkaround {
			get {
	if (isRejectWorkaround == NULL) {
		isRejectWorkaround = chActionExternalSystem == 'reject-workaround';
	}
	return isRejectWorkaround;
			}
			set;
		}
		public Boolean isAcceptSolution {
			get {
	if (isAcceptSolution == NULL) {
		isAcceptSolution = chActionExternalSystem == 'accept-solution';
	}
	return isAcceptSolution;
			}
			set;
		}
		public Boolean isRejectSolution {
			get {
	if (isRejectSolution == NULL) {
		isRejectSolution = chActionExternalSystem == 'reject-solution';
	}
	return isRejectSolution;
			}
			set;
		}
		public Boolean isCreateInformationResponse {
			get {
	if (isCreateInformationResponse == NULL) {
		isCreateInformationResponse = chActionExternalSystem == 'create-informationresponse';
	}
	return isCreateInformationResponse;
			}
			set;
		}
		public Boolean isAcknowledgeSuccess {
			get {
	if (isAcknowledgeSuccess == NULL) {
		isAcknowledgeSuccess = chActionExternalSystem == CH_ExternalInterfaceWebService.ACKNOWLEDGE_SUCCESS;
	}
	return isAcknowledgeSuccess;
			}
			set;
		}
		public Boolean isAcknowledgeError {
			get {
	if (isAcknowledgeError == NULL) {
		isAcknowledgeError = chActionExternalSystem == 'acknowledge-error';
	}
	return isAcknowledgeError;
			}
			set;
		}
	}
	global class CaseObjectResponse {
		webservice String errorMessage;
		webservice String caseNumber;
		webservice String chCaseOriginSystem;
		webservice String chActionExternalSystem;
		webservice String referenceNumber;
		webservice String caseStatus;
		
		public CaseObjectResponse(CaseObject request) {
			this.caseNumber = request.caseNumber;
			this.chCaseOriginSystem = request.chCaseOriginSystem;
			this.chActionExternalSystem = request.chActionExternalSystem;
			this.referenceNumber = request.referenceNumber;
		}
		
		public CaseObjectResponse(String errorMessage, String caseNumber, string caseOriginSystem, String externalSystemAction, String referenceNumber) {
			this.errorMessage = errorMessage;
			this.caseNumber = caseNumber;
			this.chCaseOriginSystem = caseOriginSystem;
			this.chActionExternalSystem = chActionExternalSystem;
			this.referenceNumber = referenceNumber;
		}
	}
}