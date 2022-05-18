/*******************************
Class Name: CH_ExternalInterfaceUTIL
Created by: GCC
Last modified by: GCC
Description: This class contains methods to control sending of Outbound Messages
*******************************/
public without sharing class CH_ExternalInterfaceUTIL {
	
	@testVisible
	public static Set<Case> casesWithErrors = new Set<Case>();
	/********************
*Method Name: sendUpdatesToExternalFromEmailMessage
*Parameter: emailMessageIds
*Description: for CH_Outbound Email Updates Status or Timestamp (Process Builder) - NOKIASC-15205
*******************/
	@InvocableMethod
	public static void sendUpdatesToExternalFromEmailMessage(List<Id> emailMessageIds) {
		CH_OutboundMessageSettings__c outboundMessageSettingsperOrigin = new CH_OutboundMessageSettings__c();
		Map<Id, EmailMessage> emailMessagesToSend = new Map<Id, EmailMessage>([SELECT Id, Subject, TextBody, RelatedToId, CH_Email_Type__c, CH_TypeControl__c, CreatedDate, EmailTemplateId, ReplyToEmailMessageId FROM EmailMessage WHERE Id IN :emailMessageIds]);
		if (!emailMessagesToSend.isEmpty()) {
			Map<Id, Set<Id>> caseIds = new Map<Id, Set<Id>>();
			for (EmailMessage emailMessageToSend : emailMessagesToSend.values()) {
				if (emailMessageToSend.RelatedToId != NULL) {
					if (!caseIds.containsKey(emailMessageToSend.RelatedToId)) {
						caseIds.put(emailMessageToSend.RelatedToId, new Set<Id>());
					}
					Set<Id> emailMessageIdsToSend = caseIds.get(emailMessageToSend.RelatedToId);
					emailMessageIdsToSend.add(emailMessageToSend.Id);
				}
			}
			if (!caseIds.isEmpty()) {
				List<Case> cases = [SELECT Id, CaseNumber, CH_CaseOriginSystem__c, Reference_Number__c FROM Case WHERE Id IN :caseIds.keySet() AND Origin = 'S2S'];
				if (!cases.isEmpty()) {
					Map<String, CH_OutboundMessageSettings__c> outboundMessageSettings = CH_OutboundMessageSettings__c.getAll();   
					for (Case c : cases) {
						outboundMessageSettingsperOrigin = outboundMessageSettings.get(c.CH_CaseOriginSystem__c);
						Set<Id> emailMessageIdsToSend = caseIds.get(c.Id);
						for (Id emailMessageIdToSend : emailMessageIdsToSend) {
							EmailMessage emailMessageToSend = emailMessagesToSend.get(emailMessageIdToSend);
							String externalSystemAction = isolateS2SbyEmailType(outboundMessageSettings, emailMessageToSend.CH_Email_Type__c, c.CH_CaseOriginSystem__c);
							system.debug('externalSystemAction: ' + externalSystemAction);
							if (String.isNotEmpty(externalSystemAction) && (!emailMessageToSend.Subject.startsWith('Automatic reply:'))) {
								sendUpdatesToExternalFromEmailMessage(externalSystemAction, c.Id, c.CaseNumber, c.CH_CaseOriginSystem__c, c.Reference_Number__c, emailMessageToSend.Subject, emailMessageToSend.TextBody, emailMessageToSend.CreatedDate);
							} /*else if(emailMessageToSend.EmailTemplateId == NULL && emailMessageToSend.ReplyToEmailMessageId == NULL && emailMessageToSend.CH_Email_Type__c == NULL && emailMessageToSend.CH_TypeControl__c == 'All' && outboundMessageSettingsperOrigin != NULL && outboundMessageSettingsperOrigin.CaseCreation__c == TRUE) {
sendUpdatesToExternalFromEmailMessage('create-InitialResponse', c.Id, c.CaseNumber, c.CH_CaseOriginSystem__c, c.Reference_Number__c, emailMessageToSend.Subject, emailMessageToSend.TextBody, emailMessageToSend.CreatedDate);
}*/
						}
					}
				}
			}
		}
	}
	
	@TestVisible
	private static String isolateS2SbyEmailType(Map<String, CH_OutboundMessageSettings__c> outboundMessageSettings, String emailType, String caseOrigin) {
		CH_OutboundMessageSettings__c outboundMessageSetting = outboundMessageSettings.get(caseOrigin);
		
		if (outboundMessageSetting != NULL) {
			//NOKIASC-26530
			if(emailType == 'Initial Response' && outboundMessageSetting.CaseFeedEmailInitialResponse__c) { return 'create-InitialResponse';
																										  } 
			if(emailType == 'Customer Information Request' && outboundMessageSetting.CaseFeedEmailCustomerInformationRequest__c) {
				return 'create-customerinformationrequest';
			} 
			if (emailType == 'Temporary Solution Provided' && outboundMessageSetting.CaseFeedEmailTemporary__c) {
				return 'provide-workaround';
			}
			if (emailType == 'Solution Provided' && outboundMessageSetting.CaseFeedEmailSolution__c) {
				return 'provide-solution';
			}
			if (emailType == 'Update' && outboundMessageSetting.CaseFeedEmailUpdate__c) {
				return SWS_Constants.CREATEINFOUPDATE;
			}
			if (emailType == 'Restoration' && outboundMessageSetting.CaseFeedEmailRestoration__c) {
				return SWS_Constants.CREATEINFOUPDATE;
			}
			if (emailType == 'Service Disruption Report' && outboundMessageSetting.CaseFeedEmailServiceDisruptionReport__c) {
				return SWS_Constants.CREATEINFOUPDATE;
			}
			if (emailType == 'Cause Analysis Report' && outboundMessageSetting.CaseFeedEmailCauseAnalysisReport__c) {
				return SWS_Constants.CREATEINFOUPDATE;
			}
		}
		return NULL;
	}
	
	@future(callout=true)
	private static void sendUpdatesToExternalFromEmailMessage(String externalSystemAction, Id caseId, String caseNumber, String caseOriginSystem, String referenceNumber, String emailSubject, String emailBody, DateTime emailCreatedDate) {
		//NOKIASC-27526 start 
		Set<String> caseFields = new Set<String> {'Id', 'Type', 'CreatedDate', 'LastModifiedDate'};
			
			List<Case> cases = Database.query(String.format('SELECT {0} FROM Case WHERE Id =:caseId', new List<Object>{String.join(new List<String>(caseFields), ',')}));
		
		Case c = cases[0];
		
		//NOKIASC-27526 end 
		CH_partnerNAIPWSDLForSF.Case_x s2sCase = new CH_partnerNAIPWSDLForSF.Case_x();
		s2sCase.sObjects = new CH_partnerNAIPWSDLForSF.sObjects();
		s2sCase.sObjects.CH_Action_ExternalSystem_xc = externalSystemAction;
		s2sCase.sObjects.CaseNumber = caseNumber;
		s2sCase.sObjects.CH_CaseOriginSystem_xc = caseOriginSystem;
		s2sCase.sObjects.ReferenceNumber_xc = referenceNumber;
		//NOKIASC-27526
		s2sCase.sObjects.Type_x = c.Type;
		s2sCase.sObjects.CreatedDate = c.CreatedDate;
		s2sCase.sObjects.LastModifiedDate = c.LastModifiedDate; 
		
		CH_partnerNAIPWSDLForSF.FeedItem feedItem = new CH_partnerNAIPWSDLForSF.FeedItem();
		feedItem.sObjects = new CH_partnerNAIPWSDLForSF.sObjects2();
		feedItem.sObjects.Title = emailSubject;
		feedItem.sObjects.Body = emailBody;
		feedItem.sObjects.CreatedDate = emailCreatedDate;
		
		sendS2SRequestToExternalSystem(caseId, s2sCase, feedItem, String.format('Email Feed\n\n\n{0}\n\n\n{1}', new List<Object> {s2sCase, feedItem}));
	}
	
	private static void sendS2SRequestToExternalSystem(Id caseId, CH_partnerNAIPWSDLForSF.Case_x s2sCase, CH_partnerNAIPWSDLForSF.FeedItem feedItem, String comment) {
		sendS2SRequestToExternalSystem(caseId, s2sCase, feedItem, comment, 'Update');
	}
	
	private static void sendS2SRequestToExternalSystem(Id caseId, CH_partnerNAIPWSDLForSF.Case_x s2sCase, CH_partnerNAIPWSDLForSF.FeedItem feedItem, String comment, String operationType) {
		String errorMessage = NULL;
		try {
			CH_partnerNAIPWSDLForSF.NOKIA_EAI_CASEHANDLING_COMMON_webservices_inboundFromSalesForce_Port naipConnection = new CH_partnerNAIPWSDLForSF.NOKIA_EAI_CASEHANDLING_COMMON_webservices_inboundFromSalesForce_Port();
			CH_partnerNAIPWSDLForSF.responseToSalesForce response = naipConnection.receiveFromSalesForce(s2sCase, feedItem, NULL, NULL, NULL, NULL, NULL, NULL);
			if (!String.isEmpty(response.message)) {
				errorMessage = response.message;
			}
		} catch(Exception e) {
			errorMessage = e.getMessage();
		}
		
		Interface_Log__c log = createOutboundCustomerS2SInterfaceLog(String.format('S2S Case {0} {1}', new List<Object> {s2sCase.sObjects.CH_CaseOriginSystem_xc, caseId}), comment, errorMessage, operationType);
		insert log;
		CH_UserNotificationUTIL.sendOutboundFailureNotification(new Map<Id, Interface_Log__c>{caseId => log});
	}
	
	/********************
*Method Name: sendCreationToExternalSystem
*Parameter: New Case List
*Description: if Case change to from Phone or Email to S2S then SF makes creation-case callout to external system
*******************/
	public static void sendCreationToExternalSystem(List<Case> cases) {
		Boolean isIntegrationProfile = false;   
		List<CH_Integration_Profiles__c> intProfLst = CH_Integration_Profiles__c.getall().values();
		if(intProfLst.size()>0){
			for(CH_Integration_Profiles__c intProf : intProfLst){
				if(UserInfo.getProfileId() == intProf.CH_ProfileId__c){
					isIntegrationProfile = true;
				}
			}
		}
		if(!isIntegrationProfile){
			for (Case c : cases) {
				if(c.origin == 'S2S' && c.Reference_Number__c != null){
					sendCreationToExternalSystem(c.Id);  
				}
			}
		}
	}
	
	@future(callout=true)
	private static void sendCreationToExternalSystem(Id caseId) {
		//NOKIASC-27526 start 
		Set<String> caseFields = new Set<String> {'Id', 'CH_SW_Build__r.Name', 'CH_SW_Module__r.Name', 'CH_SW_Release__r.Name', 'CH_SW_Component__r.Name', 'CH_Solution__r.Name', 'CH_Product_Module__r.Name', 'CH_ProductVariant__r.Name', 'CH_Product_Release__r.Name', 'Asset.CH_NetworkElementID__c', 'Product.Name', 'LastModifiedDate', 'CH_NetworkElementID__c', 'Contact.FirstName', 'Contact.LastName', 'Contact.MobilePhone', 'Contact.Email', 'CaseNumber', 'Subject', 'CH_CustomerDescription__c', 'CreatedDate', 'Reference_Number__c', 'CH_CaseOriginSystem__c', 'CreatedBy.Email', 'Product.PMD_Portfolio_Classification__c', 'Product.NCP_Nokia_Product_Id__c', 'Account.Country__c', 'Account.CountryCode__c', 'Account.Name', 'Account.NCP_P20_ID__c', 'Type', 'Severity__c', 'CH_Problem_Type__c', 'CH_Repeatability__c', 'CH_Discovered_in__c', 'CH_HW_Firmware__c', 'CH_HW_Name__c', 'CH_HW_Revision__c', 'CH_SW_Release__c', 'CH_SW_Build__c', 'AssetId', 'CH_ProductRelease__c', 'CH_SW_Build_Name__c', 'CH_SW_Component__c', 'CH_SW_Module__c', 'CH_Product_Module__c', 'SEC_Last_Name__c', 'SEC_First_Name__c', 'ContactEmail', 'ContactPhone', 'CH_Outage__c', 'CH_Stage__c', 'CH_InternalCase__c', 'CH_Classification__c', 'CH_ProductVariant__c', 'CH_Solution__c', 'CH_ReportedDate__c', 'CH_SolutionTargetDate__c', 'CH_PausedSinceDate__c', 'CH_Workaround_Type__c', 'CH_Product_Name__c', 'CH_Product_Release_Name__c', 'CH_Product_Module_Name__c', 'CH_Solution_Name__c', 'CH_Product_Variant_Name__c', 'CH_Account_Name__c', 'Account.AccountNumber'};
			
			List<Case> cases = Database.query(String.format('SELECT {0} FROM Case WHERE Id =:caseId', new List<Object>{String.join(new List<String>(caseFields), ',')}));
		Case c = cases[0];

		 List<CH_Case_PA_InterfaceMapping__c> interfaceMappings = [SELECT Id, AccountIn__c, AccountOut__c, ProductOut__c FROM CH_Case_PA_InterfaceMapping__c WHERE CaseOriginSystem__c = :c.CH_CaseOriginSystem__c AND AccountOut__c = :c.Account.AccountNumber AND ProductOut__c = :c.Product.NCP_Nokia_Product_Id__c LIMIT 1];
		CH_Case_PA_InterfaceMapping__c iM = interfaceMappings[0];

		//Case
		CH_partnerNAIPWSDLForSF.Case_x s2sCase = new CH_partnerNAIPWSDLForSF.Case_x();
		s2sCase.sObjects = new CH_partnerNAIPWSDLForSF.sObjects();
		s2sCase.sObjects.CH_Action_ExternalSystem_xc = 'create-case';
		s2sCase.sObjects.CaseNumber = c.CaseNumber;
		if(c.CH_CaseOriginSystem__c == 'Telefonica'){
			s2sCase.sObjects.CH_CaseOriginSystem_xc = 'telefonica'; 
		} else {
			s2sCase.sObjects.CH_CaseOriginSystem_xc = c.CH_CaseOriginSystem__c;
		}
		s2sCase.sObjects.ReferenceNumber_xc = c.Reference_Number__c;
		s2sCase.sObjects.Type_x = c.Type;
		s2sCase.sObjects.CreatedDate = c.CreatedDate;
		s2sCase.sObjects.LastModifiedDate = c.LastModifiedDate; 
		
		//CaseObjectList
		CH_partnerNAIPWSDLForSF.CaseObjectList caseObjList = new CH_partnerNAIPWSDLForSF.CaseObjectList();
		caseObjList.networkElementID = c.Asset.CH_NetworkElementID__c;
		caseObjList.severity = c.Severity__c;
		caseObjList.chOutage = c.CH_Outage__c;
		caseObjList.secLastName = c.Contact.LastName;
		caseObjList.secFirstName = c.Contact.FirstName;  
		caseObjList.subject = c.Subject;
		caseObjList.caseNumber = c.CaseNumber;
		caseObjList.chInternalCase = String.valueOf(c.CH_InternalCase__c);
		caseObjList.typeVal = c.Type;
		caseObjList.referenceNumber = c.Reference_Number__c;
		caseObjList.chActionExternalSystem = 'create-case';
		if(c.CH_CaseOriginSystem__c == 'Telefonica'){
			caseObjList.chCaseOriginSystem = 'telefonica'; 
		} else {
			caseObjList.chCaseOriginSystem = c.CH_CaseOriginSystem__c;
		}
		caseObjList.chCustomerDescription = c.CH_CustomerDescription__c;
		caseObjList.chStage = c.CH_Stage__c;
		caseObjList.chClassification = c.CH_Classification__c;
		caseObjList.assetId = c.AssetId;
		caseObjList.chSwRelease = c.CH_SW_Release__r.Name;
		caseObjList.chSwBuild = c.CH_SW_Build__r.Name;
		caseObjList.chSwComponent = c.CH_SW_Component__r.Name;
		caseObjList.chSwModule = c.CH_SW_Module__r.Name;
		caseObjList.accountId = iM.AccountIn__c;
		caseObjList.chAccountName = c.Account.Name;
		caseObjList.chProductRelease = c.CH_Product_Release__r.Name;
		caseObjList.chProductVariant = c.CH_ProductVariant__r.Name;
		caseObjList.chSolution = c.CH_Solution__r.Name;
		caseObjList.chProduct = c.Product.Name;
		caseObjList.chProductModule = c.CH_Product_Module__r.Name;
		caseObjList.email2 = c.Contact.Email;
		caseObjList.mobilePhone = c.Contact.MobilePhone;

		//CreatedBy
		CH_partnerNAIPWSDLForSF.CreatedBy createdBy = new CH_partnerNAIPWSDLForSF.CreatedBy();
		createdBy.Email = c.CreatedBy.Email;
		
		//FeedItem
		CH_partnerNAIPWSDLForSF.FeedItem feedItem = new CH_partnerNAIPWSDLForSF.FeedItem();
		feedItem.sObjects = new CH_partnerNAIPWSDLForSF.sObjects2();
		//feedItem.sObjects.Id = '';
		feedItem.sObjects.CreatedDate = system.now();
		//feedItem.sObjects.Title = notificationTitle;
		//feedItem.sObjects.ParentId = '';
		//feedItem.sObjects.Body = notificationBody;
		
		//Account
		CH_partnerNAIPWSDLForSF.Account account = new CH_partnerNAIPWSDLForSF.Account();
		account.AccountNumber = c.Account.AccountNumber;
		account.Country = c.Account.Country__c;
		account.Name = c.Account.Name;
		account.P20ID = c.Account.NCP_P20_ID__c;
		account.CountryCode = c.Account.CountryCode__c;
		
		//Product
		CH_partnerNAIPWSDLForSF.Product product = new CH_partnerNAIPWSDLForSF.Product();
		product.NokiaProductId = c.Product.NCP_Nokia_Product_Id__c;
		product.PortfolioClassification = c.Product.PMD_Portfolio_Classification__c;
		
		sendS2SCreationRequestToExternalSystem(caseId, s2sCase, createdBy, account, product, feedItem, caseObjList, String.format('Case Creation\n\n\n{0}\n\n\n{1}\n\n\n{2}\n\n\n{3}\n\n\n{4}\n\n\n{5}', new List<Object> {s2sCase, createdBy, account, product, feedItem, caseObjList}));
	}
	
	private static void sendS2SCreationRequestToExternalSystem(Id caseId, CH_partnerNAIPWSDLForSF.Case_x s2sCase, CH_partnerNAIPWSDLForSF.CreatedBy createdBy, CH_partnerNAIPWSDLForSF.Account account, CH_partnerNAIPWSDLForSF.Product product, CH_partnerNAIPWSDLForSF.FeedItem feedItem, CH_partnerNAIPWSDLForSF.CaseObjectList caseObjList, String comment) {
		String errorMessage = NULL;
		try {
			CH_partnerNAIPWSDLForSF.NOKIA_EAI_CASEHANDLING_COMMON_webservices_inboundFromSalesForce_Port naipConnection = new CH_partnerNAIPWSDLForSF.NOKIA_EAI_CASEHANDLING_COMMON_webservices_inboundFromSalesForce_Port();
			CH_partnerNAIPWSDLForSF.responseToSalesForce response = naipConnection.receiveFromSalesForce(s2sCase, feedItem, NULL, NULL, account, product, caseObjList, NULL);
			if (!String.isEmpty(response.message)) {
				errorMessage = response.message;
			}
		} catch(Exception e) {
			errorMessage = e.getMessage();
		}
		
		Interface_Log__c log = createOutboundCustomerS2SInterfaceLog(String.format('S2S Case {0} {1}', new List<Object> {s2sCase.sObjects.CH_CaseOriginSystem_xc, caseId}), comment, errorMessage, 'Insert');
		insert log;
		CH_UserNotificationUTIL.sendOutboundFailureNotification(new Map<Id, Interface_Log__c>{caseId => log});
	}
	
	/********************
*Method Name: sendCancelationToExternalSystem
*Parameter: Old Case List, New Case List
*Description: if Case.Status is changed to Cancelled then SF makes cancel-case callout to external system
*******************/
	public static void sendCancelationToExternalSystem(Map<Id, Case> oldCases, List<Case> cases) {
		for (Case c : cases) {
			if (oldCases.get(c.Id).Status != c.Status && c.Status == 'Cancelled' && c.Origin == 'S2S') {
				sendCancelationToExternalSystem(c.Id, c.CaseNumber, c.CreatedDate, c.CH_CaseOriginSystem__c, c.Reference_Number__c, c.Subject, c.CH_CustomerDescription__c);
			}
		}
	}
	
	@future(callout=true)
	private static void sendCancelationToExternalSystem(Id caseId, String caseNumber, DateTime caseCreatedDate, String caseOriginSystem, String referenceNumber, String caseSubject, String caseDescription) {
		//NOKIASC-27526 start 
		Set<String> caseFields = new Set<String> {'Id', 'LastModifiedDate'};
			
			List<Case> cases = Database.query(String.format('SELECT {0} FROM Case WHERE Id =:caseId', new List<Object>{String.join(new List<String>(caseFields), ',')}));
		Case c = cases[0];
		
		CH_partnerNAIPWSDLForSF.Case_x s2sCase = new CH_partnerNAIPWSDLForSF.Case_x();
		s2sCase.sObjects = new CH_partnerNAIPWSDLForSF.sObjects();
		s2sCase.sObjects.CH_Action_ExternalSystem_xc = 'cancel-case';
		s2sCase.sObjects.CaseNumber = caseNumber;
		s2sCase.sObjects.CreatedDate = caseCreatedDate;
		//NOKIASC-27526
		s2sCase.sObjects.LastModifiedDate = c.LastModifiedDate;
		if(caseOriginSystem == 'Telefonica'){
			s2sCase.sObjects.CH_CaseOriginSystem_xc = 'telefonica'; 
		} else {
			s2sCase.sObjects.CH_CaseOriginSystem_xc = caseOriginSystem;
		}
		s2sCase.sObjects.ReferenceNumber_xc = referenceNumber;
		s2sCase.sObjects.Subject = caseSubject;
		s2sCase.sObjects.Description = caseDescription;
		
		//NOKIASC-27526
		CH_partnerNAIPWSDLForSF.FeedItem feedItem = new CH_partnerNAIPWSDLForSF.FeedItem();
		feedItem.sObjects = new CH_partnerNAIPWSDLForSF.sObjects2();
		feedItem.sObjects.CreatedDate = system.now();
		
		sendS2SRequestToExternalSystem(caseId, s2sCase, feedItem, String.format('Case Cancellation\n\n\n{0}', new List<Object> {s2sCase}));
	}
	
	/********************
*Method Name: sendStatusUpdatesToExternalSystem
*Parameter: Old Case List, New Case List
*Description: if Case.Status is changed then SF makes cancel-case callout to external system
*******************/
	public static void sendStatusUpdatesToExternalSystem(Map<Id, Case> oldCases, List<Case> cases) {
		Set<String> availableStatuses = new Set<String> {'Assigned', 'Responded in Progress', 'Restoration Provided', 'Temp Sol. Provided', 'Solution Provided', 'Closed'};
			for (Case c : cases) {
				if (oldCases.get(c.Id).Status != c.Status && availableStatuses.contains(c.Status)) {
					sendFieldUpdatesToExternalSystem(c.Id, 'Status', 'Status update', 'Status has been updated to {0}');
				}
			}
	}
	
	/********************
*Method Name: updateFromExternalInterface
*Parameter: New Case List
*Description: Used to send a notification to the owner on update
*******************/
	public static void updatedFromExternalInterface(Map<Id, Case> oldCases, List<Case> cases) {
		List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
		for(Case c : cases) {
			ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
			ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
			ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
			ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
			ConnectApi.TextSegmentInput textSegmentInput2 = new ConnectApi.TextSegmentInput();
			messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
			textSegmentInput1.text = 'Hi ';
			messageBodyInput.messageSegments.add(textSegmentInput1);
			mentionSegmentInput.id = c.OwnerId;
			messageBodyInput.messageSegments.add(mentionSegmentInput);
			textSegmentInput2.text = '. The case was updated by the external system';
			messageBodyInput.messageSegments.add(textSegmentInput2);
			feedItemInput.body = messageBodyInput;
			feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
			feedItemInput.subjectId = c.Id;
			ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
			batchInputs.add(batchInput);
		}
		if(!Test.isRunningTest() || runUpdateFromExternalInterface) { ConnectApi.ChatterFeeds.postFeedElementBatch(null, batchInputs);
																	}
	}
	
	public static Interface_Log__c createInboundCustomerS2SInterfaceLog(String logName, String request, String comment, String operationType) {
		return createInterfaceLog(logName, request, comment, operationType, 'Inbound', 'Customer S2S');
	}
	
	@TestVisible
	private static Interface_Log__c createOutboundCustomerS2SInterfaceLog(String logName, String request, String comment) {
		return createOutboundCustomerS2SInterfaceLog(logName, request, comment, 'Update');
	}
	
	private static Interface_Log__c createOutboundCustomerS2SInterfaceLog(String logName, String request, String comment, String operationType) {
		return createInterfaceLog(logName, request, comment, operationType, 'Outbound', 'Customer S2S');
	}
	
	@TestVisible
	private static Interface_Log__c createOutboundRndInterfaceLog(String logName, String request, String comment) {
		return createInterfaceLog(logName, request, comment, 'Insert', 'Outbound', 'Pronto/Jira Interface');
	}
	
	public static Interface_Log__c createInboundRndInterfaceLog(String logName, String operationType, String request, String comment) {
		return createInterfaceLog(logName, request, comment, operationType, 'Inbound', 'Pronto/Jira Interface');
	}
	
	private static Interface_Log__c createInterfaceLog(String logName, String request, String comment, String operationType, String messageType, String interfaceType) {
		Interface_Log__c log = new Interface_Log__c(Name = logName,
													Operation_Type__c = operationType,
													Number_of_Record_Processed__c = 1,
													Message_Type__c = messageType,
													Interface_Request_Sent__c = request,
													Comment__c = comment,
													Interface_Type__c = interfaceType);
		if (String.isEmpty(comment)) {
			log.Status__c = 'Success';
			log.Number_of_Records_Errored__c = 0;
			log.Number_of_Records_Success__c = 1;
		} else {
			log.Status__c = 'Failure';
			log.Number_of_Records_Errored__c = 1;
			log.Number_of_Records_Success__c = 0;
		}
		return log;
	}
	
	public static List<Case> isolateS2SbyStage(List<Case> cases) {
		Map<String, CH_OutboundMessageSettings__c> outboundMessageSettings = CH_OutboundMessageSettings__c.getAll();
		List<Case> isolatedCases = new List<Case>();
		for(Case c : cases) {
			if(outboundMessageSettings.get(c.CH_CaseOriginSystem__c) != null &&
			   ((c.CH_Stage__c == 'Register' && outboundMessageSettings.get(c.CH_CaseOriginSystem__c).CaseStageRegister__c) ||
				(c.CH_Stage__c == 'Assess & Respond' && outboundMessageSettings.get(c.CH_CaseOriginSystem__c).CaseStageAssetRespond__c) || 
				(c.CH_Stage__c == 'Investigate & Restore' && outboundMessageSettings.get(c.CH_CaseOriginSystem__c).CaseStageInvestigateRestore__c) || 
				(c.CH_Stage__c == 'Diagnosis & Technical Analysis' && outboundMessageSettings.get(c.CH_CaseOriginSystem__c).CaseStageDiagnosisTechnicalAnalysis__c) || 
				(c.CH_Stage__c == 'Resolve' && outboundMessageSettings.get(c.CH_CaseOriginSystem__c).CaseStageResolve__c) ||
				(c.CH_Stage__c == 'Route' && outboundMessageSettings.get(c.CH_CaseOriginSystem__c).CaseStageRoute__c) || 
				(c.CH_Stage__c == 'Close' && outboundMessageSettings.get(c.CH_CaseOriginSystem__c).CaseStageClose__c))) {
					isolatedCases.add(c);
				}
		}
		return isolatedCases;
	}
	
	public static Boolean isExternalSoapRequest() {
		return URL.getCurrentRequestUrl().toExternalForm().startsWith(URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap');
	}
	
	@TestVisible private static Boolean runUpdateFromExternalInterface = false;
	
	
	/********************
*Method Name: populateCaseHandlingCases
*Parameter: New Case List
*Description: Used to query and link Account, Prodct, Solution, Variant and Release records via InterfaceMapping record
*******************/
	public static void populateCaseHandlingCases(List<Case> cases, Map<Id, Account> accounts, Map<Id, Product2> products, Map<Id, CH_ProductRelease__c> releases, Map<Id, Asset> assets, Map<Id, Entitlement> entitlements) {
		
		Map<String, CH_Case_PA_InterfaceMapping__c> mappings = getInterfaceMappings(cases);
		String externalSystemAccount;
		CH_Case_PA_InterfaceMapping__c mapping = new CH_Case_PA_InterfaceMapping__c();
		
		List<Case> casesWithMappings = new List<Case>();
		for (Case c : cases) {
			if(c.CH_CaseOriginSystem__c == 'tcom-dtag'){ mapping = mappings.get(c.CH_CaseOriginSystem__c + c.CH_ExternalSystemAccount__c);
														if(mapping == NULL){ externalSystemAccount = c.CH_ExternalSystemAccount__c.substringBeforeLast(';') + ';';
																			mapping = mappings.get(c.CH_CaseOriginSystem__c + externalSystemAccount);
																		   }
													   } else {
														   mapping = mappings.get(c.CH_CaseOriginSystem__c + c.CH_ExternalSystemAccount__c); 
													   }
			
			if (mapping != NULL) {
				casesWithMappings.add(c);
			} else {
				//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
				c.addError(System.Label.CH_Mapping_Not_Found + c.CH_ExternalSystemAccount__c);
				casesWithErrors.add(c);
			}
		}
		
		setS2SCaseInterfaceMappingDefaulLookups(casesWithMappings, mappings, accounts, products, releases, entitlements);
		setS2SCaseAssets(casesWithMappings, mappings, accounts, products, releases, entitlements, assets);
	}
	
	private static Map<String, CH_Case_PA_InterfaceMapping__c> getInterfaceMappings(List<Case> cases) {
		Set<String> externalSystemAccountIds = new Set<String>();
		Set<String> origins = new Set<String>();
		Set<String> productIn = new Set<String>();
		Set<String> productReleaseIn = new Set<String>();
		Set<String> solutionIn = new Set<String>();
		Set<String> variantIn = new Set<String>();
		List<Case> tMobileCases = new List<Case>();
		for(Case c : cases) {
			if (c.CH_CaseOriginSystem__c != TMOBILE_ORIGIN_CODE) {
				externalSystemAccountIds.add(c.CH_ExternalSystemAccount__c);
				origins.add(c.CH_CaseOriginSystem__c);
				productIn.add(c.CH_ExternalSystemProduct__c);
				productReleaseIn.add(c.CH_ExternalSystemProductRelease__c);
				solutionIn.add(c.CH_ExternalSystemSolution__c);
				variantIn.add(c.CH_ExternalSystemProductVariant__c);
			} else { tMobileCases.add(c);
				   }
		}
		List<CH_Case_PA_InterfaceMapping__c> mappings = new List<CH_Case_PA_InterfaceMapping__c>();
		if (!externalSystemAccountIds.isEmpty() && !origins.isEmpty()) {
			if(origins.contains('tcom-dtag')){
				mappings = [SELECT Id, CaseOriginSystem__c, AccountIn__c, AccountOut__c, SolutionOut__c, EntitlementOut__c,ProductOut__c, VariantOut__c, ProductReleaseOut__c FROM CH_Case_PA_InterfaceMapping__c WHERE AccountIn__c IN : externalSystemAccountIds AND CaseOriginSystem__c IN : origins AND ProductIn__c IN : productIn AND ProductReleaseIn__c IN : productReleaseIn AND SolutionIn__c IN : solutionIn AND VariantIn__c IN : variantIn];
				if(mappings.isEmpty()){ String stringExternalSystemAccountIds;
									   for(String strings : externalSystemAccountIds){
										   stringExternalSystemAccountIds = strings;
									   }
									   List<String> externalSystemAccountIdsList = stringExternalSystemAccountIds.split(';');
									   Set<String> newExternalSystemAccountIds = new Set<String>(); 
									   if(externalSystemAccountIdsList.size()>1){
										   newExternalSystemAccountIds.add(externalSystemAccountIdsList[0] + ';' + externalSystemAccountIdsList[1] + ';');
									   } else {
										   newExternalSystemAccountIds.add(externalSystemAccountIdsList[0] + ';;');
									   }	 
									   mappings = [SELECT Id, CaseOriginSystem__c, AccountIn__c, AccountOut__c, SolutionOut__c, EntitlementOut__c,ProductOut__c, VariantOut__c, ProductReleaseOut__c FROM CH_Case_PA_InterfaceMapping__c WHERE AccountIn__c IN : newExternalSystemAccountIds AND CaseOriginSystem__c IN : origins AND ProductIn__c IN : productIn AND ProductReleaseIn__c IN : productReleaseIn AND SolutionIn__c IN : solutionIn AND VariantIn__c IN : variantIn];
									  }
			} else {
				mappings = [SELECT Id, CaseOriginSystem__c, AccountIn__c, AccountOut__c, SolutionOut__c, EntitlementOut__c,ProductOut__c, VariantOut__c, ProductReleaseOut__c FROM CH_Case_PA_InterfaceMapping__c WHERE AccountIn__c IN : externalSystemAccountIds AND CaseOriginSystem__c IN : origins AND ProductIn__c IN : productIn AND ProductReleaseIn__c IN : productReleaseIn AND SolutionIn__c IN : solutionIn AND VariantIn__c IN : variantIn];
			}
		}
		if (!tMobileCases.isEmpty()) { mappings.addAll(getTMobileMappings(tMobileCases));
									 }
		
		//group interface mappings by origins and combinations of Account/Products/Releases
		Map<String, CH_Case_PA_InterfaceMapping__c> mappingMap = new Map<String, CH_Case_PA_InterfaceMapping__c>();
		for(CH_Case_PA_InterfaceMapping__c mapping : mappings) {
			mappingMap.put(mapping.CaseOriginSystem__c + mapping.AccountIn__c, mapping);
		}
		return mappingMap;
	}
	
	private static void setS2SCaseAssets(List<Case> cases, Map<String, CH_Case_PA_InterfaceMapping__c> mappings, Map<Id, Account> accounts, Map<Id, Product2> products, Map<Id, CH_ProductRelease__c> releases, Map<Id, Entitlement> entitlements, Map<Id, Asset> assets) {
		Map<String, List<Case>> assetCases = new Map<String, List<Case>>();
		Set<String> assetExternalIds = new Set<String>();
		Set<String> accountNos = new Set<String>();
		List<String> entitlementCodes = new List<String>();
		for (Case c : cases) {
			String externalSystemAccount;
			CH_Case_PA_InterfaceMapping__c mapping = new CH_Case_PA_InterfaceMapping__c();
			if(c.CH_CaseOriginSystem__c == 'tcom-dtag'){ mapping = mappings.get(c.CH_CaseOriginSystem__c + c.CH_ExternalSystemAccount__c);
														if(mapping == NULL){ externalSystemAccount = c.CH_ExternalSystemAccount__c.substringBeforeLast(';') + ';';
																			mapping = mappings.get(c.CH_CaseOriginSystem__c + externalSystemAccount);
																		   }
													   } else {
														   mapping = mappings.get(c.CH_CaseOriginSystem__c + c.CH_ExternalSystemAccount__c);	
													   }
			Account a = accounts.get(c.AccountId);
			Product2 solution = products.get(c.CH_Solution__c);
			Product2 product = products.get(c.ProductId);
			Product2 variant = products.get(c.CH_ProductVariant__c);
			CH_ProductRelease__c release = releases.get(c.CH_Product_Release__c);
			if(mapping.EntitlementOut__c != NULL) { entitlementCodes.add(mapping.EntitlementOut__c);
												  }
			system.debug('---entitlementCodes-sf records--'+entitlementCodes);
			
			if (a != NULL && product != NULL && release != NULL) {
				if (String.isEmpty(a.AccountNumber) || String.isEmpty(a.CountryCode__c) || String.isEmpty(product.NCP_Nokia_Product_Id__c) || String.isEmpty(release.CH_NSNLegacyCode__c)) {
					//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
					c.addError(System.Label.CH_External_ID_Format_Incorrect);
					casesWithErrors.add(c);
				}
				
				String solutionNCPId = solution == NULL ? '' : solution.NCP_Nokia_Product_Id__c;
				String variantNCPId = variant == NULL ? '' : variant.NCP_Nokia_Product_Id__c;
				String assetExternalId;
				assetExternalId = a.AccountNumber + '|' + a.CountryCode__c + '|' + solutionNCPId + '|' + product.NCP_Nokia_Product_Id__c + '|' + variantNCPId + '|' + release.CH_NSNLegacyCode__c;
				
				if(assetCases.get(assetExternalId + a.Acc_No__c) == NULL) {
					assetCases.put(assetExternalId + a.Acc_No__c, new List<Case>());
				}
				
				assetCases.get(assetExternalId + a.Acc_No__c).add(c);
				assetExternalIds.add(assetExternalId);
				accountNos.add(a.Acc_No__c);
			}
		}
		if(entitlementCodes.isEmpty()){
			entitlements.clear();
			for (Entitlement e : [SELECT Id, CH_CDB_EntitlementId__c, Asset.CH_CountryISOName__c, Asset.CH_CountryISO2__c, Asset.CH_CDB_ExternalAssetId__c, Asset.Account.Acc_No__c, (SELECT Id, ServiceContractId, ServiceContract.CH_Entitlement__c FROM Contract_Line_Items__r) FROM Entitlement WHERE Status = 'Active' AND Asset.CH_CDB_ExternalAssetId__c IN : assetExternalIds AND Asset.Account.Acc_No__c IN : accountNos AND ServiceContract.Status = 'Active' AND ServiceContract.NCP_External_Status__c = 'Active' AND ContractLineItem.Status = 'Active' AND ContractLineItem.NCP_External_Status__c = 'Active']) {
				entitlements.put(e.Id, e);
			}
		}
		if(!entitlements.isEmpty()){
			
			Map<Id, List<Entitlement>> assetEntitlements = new Map<Id, List<Entitlement>>();
			for (Entitlement e : entitlements.values()) {
				if(!entitlementCodes.isEmpty()){
					for(String entitlementC : entitlementCodes){
						system.debug('---entitlementC-sf records--'+entitlementC);
						if(e.CH_CDB_EntitlementId__c == entitlementC){ assets.put(e.AssetId, e.Asset);
																	  if (!assetEntitlements.containsKey(e.AssetId)) { assetEntitlements.put(e.AssetId, new List<Entitlement>());
																													 }
																	  assetEntitlements.get(e.AssetId).add(e);
																	 }
					}
				} else {
					assets.put(e.AssetId, e.Asset);
					if (!assetEntitlements.containsKey(e.AssetId)) { assetEntitlements.put(e.AssetId, new List<Entitlement>());
																   }
					assetEntitlements.get(e.AssetId).add(e);
				}
			}
			
			Map<String, Asset> assetMap = new Map<String, Asset>();
			for (Asset a : assets.values()) { assetMap.put(a.CH_CDB_ExternalAssetId__c + a.Account.Acc_No__c, a);
											}
			for (String assetExternalId : assetCases.keySet()) {
				for (Case c : assetCases.get(assetExternalId)) {
					Asset a = assetMap.get(assetExternalId);
					if (a != NULL && assetEntitlements.containsKey(a.Id) && assetEntitlements.get(a.Id).size() == 1) {
						c.AssetId = a.Id; c.Country__c = a.CH_CountryISOName__c; Entitlement e = assetEntitlements.get(a.Id)[0]; c.EntitlementId = e.Id;
						
					}
				}
			}
		}
	}
	
	private static void setS2SCaseInterfaceMappingDefaulLookups(List<Case> cases, Map<String, CH_Case_PA_InterfaceMapping__c> mappings, Map<Id, Account> accounts, Map<Id, Product2> products, Map<Id, CH_ProductRelease__c> releases, Map<Id, Entitlement> entitlements) {
		List<String> accountCodes = new List<String>();
		List<String> productCodes = new List<String>();
		List<String> releaseCodes = new List<String>();
		List<String> entitlementCodes = new List<String>();
		
		for(Case c : cases) {
			String externalSystemAccount;
			CH_Case_PA_InterfaceMapping__c mapping = new CH_Case_PA_InterfaceMapping__c();
			if(c.CH_CaseOriginSystem__c == 'tcom-dtag'){ mapping = mappings.get(c.CH_CaseOriginSystem__c + c.CH_ExternalSystemAccount__c);
														if(mapping == NULL){ externalSystemAccount = c.CH_ExternalSystemAccount__c.substringBeforeLast(';') + ';';
																			mapping = mappings.get(c.CH_CaseOriginSystem__c + externalSystemAccount);
																		   }
													   } else {
														   mapping = mappings.get(c.CH_CaseOriginSystem__c + c.CH_ExternalSystemAccount__c);	
													   }
			
			if(mapping.AccountOut__c != NULL) {
				accountCodes.add(mapping.AccountOut__c);
			}
			if(mapping.SolutionOut__c != NULL) {
				productCodes.add(mapping.SolutionOut__c);
			}
			if(mapping.ProductOut__c != NULL) {
				productCodes.add(mapping.ProductOut__c);
			}
			if(mapping.VariantOut__c != NULL) {
				productCodes.add(mapping.VariantOut__c);
			}
			if(mapping.ProductReleaseOut__c != NULL) {
				releaseCodes.add(mapping.ProductReleaseOut__c);
			}
			if(mapping.EntitlementOut__c != NULL) { entitlementCodes.add(mapping.EntitlementOut__c);
												  }
		}
		for (Account a : [SELECT Id, ParentId, Acc_No__c, AccountNumber, CountryCode__c, (SELECT Id, CH_ServiceContract__c, CH_ServiceContract__r.CH_Entitlement__c FROM Authorized_Account__r) FROM Account WHERE Acc_No__c IN : accountCodes]) {
			accounts.put(a.Id, a);
		}
		Map<String, Account> accountMap = new Map<String, Account>();
		for (Account a : accounts.values()) {
			accountMap.put(a.Acc_No__c, a);
		}
		
		for (Product2 p : [SELECT Id, Name, NCP_Nokia_Product_Id__c FROM Product2 WHERE NCP_Nokia_Product_Id__c IN : productCodes]) {
			products.put(p.Id, p);
		}
		Map<String, Product2> productMap = new Map<String, Product2>();
		for (Product2 p : products.values()) {
			productMap.put(p.NCP_Nokia_Product_Id__c, p);
		}
		for (CH_ProductRelease__c r : [SELECT Id, Name, CH_NSNLegacyCode__c FROM CH_ProductRelease__c WHERE CH_NSNLegacyCode__c IN : releaseCodes]) {
			releases.put(r.Id, r);
		}
		
		Map<String, CH_ProductRelease__c> releaseMap = new Map<String, CH_ProductRelease__c>();
		for(CH_ProductRelease__c r : releases.values()) {
			releaseMap.put(r.CH_NSNLegacyCode__c, r);
		}
		for (Entitlement e : [SELECT Id, Name, AccountId, AssetId, CH_CDB_EntitlementId__c, Asset.CH_CountryISOName__c, (SELECT Id, ServiceContractId, ServiceContract.CH_Entitlement__c FROM Contract_Line_Items__r), ContractLineItemId, ServiceContractId, Asset.CH_CDB_ExternalAssetId__c, Asset.Account.Acc_No__c, Asset.CH_CountryISO2__c, ServiceContract.Status FROM Entitlement WHERE Status = 'Active' AND CH_CDB_EntitlementId__c IN : entitlementCodes AND ServiceContract.Status = 'Active' AND ServiceContract.NCP_External_Status__c = 'Active' AND ContractLineItem.Status = 'Active' AND ContractLineItem.NCP_External_Status__c = 'Active']) { 
			entitlements.put(e.Id, e);
		}
		
		Map<String, Entitlement> entitlementMap = new Map<String, Entitlement>();
		for(Entitlement e : entitlements.values()) { entitlementMap.put(e.CH_CDB_EntitlementId__c, e);
												   }
		for (Case c : cases) {
			String externalSystemAccount;
			CH_Case_PA_InterfaceMapping__c mapping = new CH_Case_PA_InterfaceMapping__c();
			if(c.CH_CaseOriginSystem__c == 'tcom-dtag'){ mapping = mappings.get(c.CH_CaseOriginSystem__c + c.CH_ExternalSystemAccount__c);
														if(mapping == NULL){ externalSystemAccount = c.CH_ExternalSystemAccount__c.substringBeforeLast(';') + ';';
																			mapping = mappings.get(c.CH_CaseOriginSystem__c + externalSystemAccount);
																		   }
													   } else {
														   mapping = mappings.get(c.CH_CaseOriginSystem__c + c.CH_ExternalSystemAccount__c);	
													   }
			
			Account a = accountMap.get(mapping.AccountOut__c);
			Product2 solution = productMap.get(mapping.SolutionOut__c);
			Product2 product = productMap.get(mapping.ProductOut__c);
			Product2 variant = productMap.get(mapping.VariantOut__c);
			CH_ProductRelease__c release = releaseMap.get(mapping.ProductReleaseOut__c);
			Entitlement entitlement = entitlementMap.get(mapping.EntitlementOut__c);
			
			c.AccountId = a == NULL ? NULL : a.Id;
			c.CH_Solution__c = solution == NULL ? NULL : solution.Id;
			c.ProductId = product == NULL ? NULL : product.Id;
			c.CH_ProductVariant__c = variant == NULL ? NULL : variant.Id;
			c.CH_Product_Release__c = release == NULL ? NULL : release.Id;
			c.AssetId = entitlement == NULL ? NULL : entitlement.AssetId;
			c.EntitlementId = entitlement == NULL ? NULL : entitlement.Id;
			if(!Test.isRunningTest()){
				c.Country__c = entitlement == NULL ? NULL : entitlement.Asset.CH_CountryISOName__c;
			}
		}
	}
	
	/********************
*Method Name: createCaseContactIfNotExisting
*cases: new cases
*accounts: case accounts
*Description: creates new Contact and EntitlmentContact records if SF doesn't find Contact by email
*******************/
	public static void createCaseContactIfNotExisting(List<Case> cases, Map<Id, Account> accounts) {
		Map<String, List<Case>> s2sCases = new Map<String, List<Case>>();
		for(Case c : cases) {
			if(c.Origin.toUpperCase() == 'S2S' && !casesWithErrors.contains(c)) {
				if (String.isEmpty(c.CH_Email2__c)) { //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
					c.addError(System.Label.CH_Empty_Contact_Email);
					casesWithErrors.add(c);
				} else if (String.isEmpty(c.SEC_Last_Name__c)) { //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
					c.addError(System.Label.CH_Empty_Contact_Last_Name);
					
					casesWithErrors.add(c);
				} else {
					String caseEmail = c.CH_Email2__c.trim().toLowerCase();
					if (!s2sCases.containsKey(caseEmail)) {
						s2sCases.put(caseEmail, new List<Case>());
					}
					s2sCases.get(caseEmail).add(c);
				}
			}
		}
		
		// search contacts by case emails
		Map<String, Contact> contactEmails = new Map<String, Contact>();
		for (Contact contactItem : [SELECT Id, Email FROM Contact WHERE Email IN :s2sCases.keySet()]) {
			contactEmails.put(contactItem.Email.trim().toLowerCase(), contactItem);
		}
		// search cases which don't have contacts
		Map<String, List<Case>> noContactCases = new Map<String, List<Case>>();
		for (String caseEmail: s2sCases.keySet()) {
			if (!contactEmails.containsKey(caseEmail) && !noContactCases.containsKey(caseEmail)) { noContactCases.put(caseEmail, s2sCases.get(caseEmail));
																								  
																								 }
		}
		
		// create new case contacts and account/contact relationships
		if (!noContactCases.isEmpty()) {
			List<Contact> newContacts = new List<Contact>();
			List<AccountContactRelation> newAccountContactRelationships = new List<AccountContactRelation>();
			for (String caseEmail : noContactCases.keySet()) {
				for (Case c : noContactCases.get(caseEmail)) {
					Account a = accounts.get(c.AccountId);
					if (a == NULL) {
						//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
						c.addError(System.Label.CH_No_Customer_Account_Found);
						casesWithErrors.add(c);
					} else {
						if (!contactEmails.containsKey(caseEmail)) { Contact newContact = new Contact(LastName = c.SEC_Last_Name__c, FirstName = c.SEC_First_Name__c, Email = caseEmail, AccountId = a.ParentId, CH_ContactType__c = 'Customer');
																	//27525
																	if(!String.isEmpty(c.Phone_No__c)){ newContact.Phone = c.Phone_No__c;
																									  }
																	if(!String.isEmpty(c.Mobile_Phone__c)){ newContact.MobilePhone = c.Mobile_Phone__c;
																										  }
																	contactEmails.put(caseEmail, newContact);
																	newContacts.add(newContact);
																	newAccountContactRelationships.add(new AccountContactRelation(AccountId = c.AccountId, NCP_Entitlement_Relationship__c = true));
																   }
					}
				}
			}
			
			if (!newContacts.isEmpty()) {
				
				insert newContacts;
				for (Integer c = 0; c < newContacts.size(); c++) {
					newAccountContactRelationships[c].ContactId = newContacts[c].Id;
				}
				
				insert newAccountContactRelationships;
			}
		}
		
		// set case contact ids
		for (String caseEmail : s2sCases.keySet()) {
			for (Case c: s2sCases.get(caseEmail)) {
				if (contactEmails.containsKey(caseEmail)) {
					c.ContactId = contactEmails.get(caseEmail).Id;
					system.debug('----assigning --- contact to new case---');
				}
			}
		}
	}
	
	/********************
*Method Name: createEntitlementContactsIfNotExisting
*Parameter: New Case List
*Description: Used to create new EntitlmentContact records if no EntitlmentContact for Case Contact and Entitlement
* exists. If account is not authorized, EntitlmentContact will not be crated. Account is considered authorized if
* all of account contacts are authorized (according to JIRA NOKIASC-16822).
*******************/
	public static void createEntitlementContactsIfNotExisting(List<Case> cases, Map<Id, Account> accounts, Map<Id, Entitlement> entitlements) {
		List<Case> s2sCases = new List<Case>();
		for (Case c : cases) {
			if (c.Origin.toUpperCase() == 'S2S' && !casesWithErrors.contains(c)) {
				if (c.ContactId == null) { 
					//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
					c.addError(System.Label.CH_S2S_Case_Has_No_Contact);
					casesWithErrors.add(c);
				} else if (c.AccountId == null) { 
					//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
					c.addError(System.Label.CH_S2S_Case_Has_No_Account);	 
					casesWithErrors.add(c);
				} else if (c.EntitlementId == null) {
					//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
					c.addError(System.Label.CH_Case_Has_No_Entitlement);
					casesWithErrors.add(c);
				} else { s2sCases.add(c);
					   }
			}
		}
		
		Map<Id, Set<Id>> accountContactIds = new Map<Id, Set<Id>>();
		Map<Id, Set<Id>> accountServiceContractIds = new Map<Id, Set<Id>>();
		Map<Id, ServiceContract> serviceContracts = new Map<Id, ServiceContract>();
		List<Case> casesToAuthorizeContacts = getCasesToAuthorizeContacts(s2sCases, accounts, entitlements, accountContactIds, accountServiceContractIds, serviceContracts);
		
		if (!casesToAuthorizeContacts.isEmpty()) { createEntitlementContactsToAuthorizeContacts(casesToAuthorizeContacts, accounts, accountContactIds, accountServiceContractIds, serviceContracts);
												 }
	}
	
	private static void createEntitlementContactsToAuthorizeContacts(List<Case> casesToAuthorizeContacts, Map<Id, Account> accounts, Map<Id, Set<Id>> accountContactIds, Map<Id, Set<Id>> accountServiceContractIds, Map<Id, ServiceContract> serviceContracts) {
		List<EntitlementContact> entitlementContacts = new List<EntitlementContact>();
		
		Set<Id> parentAccountIds = new Set<Id>();
		for (Case c : casesToAuthorizeContacts) {
			parentAccountIds.add(accounts.get(c.AccountId).ParentId);
		}
		Map<Id, Account> parentAccounts = new Map<Id, Account>([SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :parentAccountIds]);
		
		for (Case c: casesToAuthorizeContacts) {
			// check if all Account Contacts are Authorized
			Set<Id> parentAccountContactIds = new Set<Id>();
			for (Contact parentAccountContact : parentAccounts.get(accounts.get(c.AccountId).ParentId).Contacts) {
				if (c.ContactId != parentAccountContact.Id) { parentAccountContactIds.add(parentAccountContact.Id);
															}
			}
			
			if (accountContactIds.get(c.AccountId).containsAll(parentAccountContactIds)) {
				// get Authorized Entitlement Id
				Id authorizedEntitlementId = NULL;
				for (Id serviceContractId : accountServiceContractIds.get(c.AccountId)) {
					if (serviceContracts.get(serviceContractId) != NULL && serviceContracts.get(serviceContractId).CH_Entitlement__c != NULL) {
						authorizedEntitlementId = serviceContracts.get(serviceContractId).CH_Entitlement__c;
						break;
					}
				}
				if (authorizedEntitlementId == NULL) { 
					//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
					c.addError(System.Label.CH_Case_Contact_Can_Not_Be_Authoried);
					casesWithErrors.add(c);
				} else { entitlementContacts.add(new EntitlementContact(ContactId = c.ContactId, EntitlementId = authorizedEntitlementId));
					   }
			} else { 
				//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
				c.addError(System.Label.CH_Case_Contact_Can_Not_Be_Authorized_For_Account_Contacts_Unauthorized);
				casesWithErrors.add(c);
			}
		}
		
		if (!entitlementContacts.isEmpty()) { insert entitlementContacts;
											}
	}
	
	private static List<Case> getCasesToAuthorizeContacts(List<Case> s2sCases, Map<Id, Account> accounts, Map<Id, Entitlement> entitlements, Map<Id, Set<Id>> accountContactIds, Map<Id, Set<Id>> accountServiceContractIds, Map<Id, ServiceContract> serviceContracts) {
		List<Case> casesToAuthorizeContacts = new List<Case>();
		
		if (!s2sCases.isEmpty()) { loadServiceContractsToAuthorizeCaseContacts(s2sCases, accounts, entitlements, accountServiceContractIds, serviceContracts);
								  
								  Map<Id, List<EntitlementContact>> authorizedCaseContacts = new Map<Id, List<EntitlementContact>>();
								  Map<Id, List<EntitlementContact>> authorizedCaseEntitlements = new Map<Id, List<EntitlementContact>>();
								  loadEntitlementContactsToAuthorizeCaseContacts(s2sCases, serviceContracts, authorizedCaseContacts, authorizedCaseEntitlements);
								  
								  for (Case c: s2sCases) {
									  if (!authorizedCaseContacts.containsKey(c.ContactId)) {
										  Account caseAccount = accounts.get(c.AccountId);
										  if (caseAccount != null && caseAccount.Authorized_Account__r.isEmpty()) { 
											  //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
											  c.addError(System.Label.CH_Case_Account_Not_Authorized);	  
											  casesWithErrors.add(c);
										  } else { Entitlement caseEntitlement = entitlements.get(c.EntitlementId);
												  if (caseEntitlement != null && caseEntitlement.Contract_Line_Items__r.isEmpty()) {
													  //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
													  c.addError(System.Label.CH_Case_Entitlement_No_Contract_Line_Items);
													  casesWithErrors.add(c);
												  } else {
													  if(accountServiceContractIds != null && accountServiceContractIds.containsKey(c.AccountId)){
														  for (Id serviceContractId : accountServiceContractIds.get(c.AccountId)) {
															  Id authorizedEntitlementId = serviceContracts.get(serviceContractId).CH_Entitlement__c;
															  if (authorizedEntitlementId == NULL) { 
																  //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
																  c.addError(System.Label.CH_Case_ServiceContract_No_Entitlement);
																  casesWithErrors.add(c);
															  } else {
																  Set<Id> contactIds = new Set<Id>();
																  if (authorizedCaseEntitlements.containsKey(authorizedEntitlementId)) {
																	  for (EntitlementContact entitlementContactItem: authorizedCaseEntitlements.get(authorizedEntitlementId)) {
																		  contactIds.add(entitlementContactItem.ContactId);
																	  }
																  }
																  accountContactIds.put(c.AccountId, contactIds);
																  casesToAuthorizeContacts.add(c);
															  }
														  }
													  }
												  }
												 }
									  }   
								  }
								 }
		
		return casesToAuthorizeContacts;
	}
	
	private static Map<Id, ServiceContract> loadServiceContractsToAuthorizeCaseContacts(List<Case> s2sCases, Map<Id, Account> accounts, Map<Id, Entitlement> entitlements, Map<Id, Set<Id>> accountServiceContractIds, Map<Id, ServiceContract> serviceContracts) {
		for (Case c: s2sCases) {
			// get ServiceContract from Accounts and Entitlements
			Account caseAccount = accounts.get(c.AccountId);
			if (caseAccount != NULL) {
				if (!accountServiceContractIds.containsKey(c.AccountId)) { accountServiceContractIds.put(c.AccountId, new Set<Id>());
																		 }
				Set<Id> authorizedAccountServiceContractIds = accountServiceContractIds.get(c.AccountId);
				for (CH_AuthorizedAccount__c authorizedAccount: caseAccount.Authorized_Account__r) {
					authorizedAccountServiceContractIds.add(authorizedAccount.CH_ServiceContract__c);
					serviceContracts.put(authorizedAccount.CH_ServiceContract__c, authorizedAccount.CH_ServiceContract__r);
				}
			}
			
			Entitlement caseEntitlement = entitlements.get(c.EntitlementId);
			if (caseEntitlement != NULL) {
				if (!accountServiceContractIds.containsKey(c.AccountId)) { accountServiceContractIds.put(c.AccountId, new Set<Id>());
																		 }
				Set<Id> contactLineServiceContractIds = accountServiceContractIds.get(c.AccountId);
				for (ContractLineItem entitlementContactLine: caseEntitlement.Contract_Line_Items__r) {
					contactLineServiceContractIds.add(entitlementContactLine.ServiceContractId);
					serviceContracts.put(entitlementContactLine.ServiceContractId, entitlementContactLine.ServiceContract);
				}
			}
		}
		return serviceContracts;
	}
	
	private static void loadEntitlementContactsToAuthorizeCaseContacts(List<Case> s2sCases, Map<Id, ServiceContract> serviceContracts, Map<Id, List<EntitlementContact>> authorizedCaseContacts, Map<Id, List<EntitlementContact>> authorizedCaseEntitlements) {
		Set<Id> caseContactIds = new Set<Id>();
		for (Case c: s2sCases) {
			if (c.ContactId != NULL) { caseContactIds.add(c.ContactId);
									 }
		}
		
		Set<Id> authorizedEntitlementIds = new Set<Id>();
		for (ServiceContract sc: serviceContracts.values()) {
			if (sc.CH_Entitlement__c != NULL) { authorizedEntitlementIds.add(sc.CH_Entitlement__c);
											  }
		}
		
		List<EntitlementContact> entitlementContacts = [SELECT Id, ContactId, EntitlementId FROM EntitlementContact WHERE ContactId IN :caseContactIds AND EntitlementId IN :authorizedEntitlementIds LIMIT 10000];
		for (EntitlementContact ec : entitlementContacts) {
			if (ec.ContactId != NULL) {
				if (!authorizedCaseContacts.containsKey(ec.ContactId)) { authorizedCaseContacts.put(ec.ContactId, new List<EntitlementContact>());
																	   }
				authorizedCaseContacts.get(ec.ContactId).add(ec);
			}
			if (ec.EntitlementId != NULL) {
				if (!authorizedCaseEntitlements.containsKey(ec.EntitlementId)) { authorizedCaseEntitlements.put(ec.EntitlementId, new List<EntitlementContact>());
																			   }
				authorizedCaseEntitlements.get(ec.EntitlementId).add(ec);
			}
		}
	}
	
	/********************
*Method Name: rejectInvalidS2SCases
*Parameter: Case List
*Description: method to reject S2S cases with origin system but without ref. number and other validations
*******************/
	public static void rejectInvalidS2SCases(List<Case> cases) {
		// reject S2S cases with origin != null but no ref number
		for (Case aCase : cases) {
			if (aCase.CH_CaseOriginSystem__c != null && String.isEmpty(aCase.Reference_Number__c)) {
				//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
				aCase.addError(System.Label.CH_S2S_Case_Cannot_Have_Empty_Reference_For_Origin_System_Set);
				casesWithErrors.add(aCase);
			}
		}
	}
	
	/********************
*Method Name: isolateUniqueRefNumCases
*Parameter: New Case List
*Description: Used to prevent case creation if reference number is not unique for one origin across not closed cases
*******************/
	public static List<Case> isolateUniqueRefNumCases(List<Case> cases) {
		Set<String> refNumbers = new Set<String>();
		Set<String> origins = new Set<String>();
		List<Case> casesWithoutErrors = new List<Case>();
		for(Case c : cases) {
			refNumbers.add(c.Reference_Number__c);
			origins.add(c.CH_CaseOriginSystem__c);
		}
		List<Case> refNumExistingCases = [
			SELECT Id, Reference_Number__c, CH_CaseOriginSystem__c
			FROM Case
			WHERE Reference_Number__c
			IN : refNumbers
			AND CH_CaseOriginSystem__c
			IN : origins
			AND Status != 'Completed' 
			AND status != 'Cancelled'
		];
		Map<String, Set<String>> refNumExistingCaseMap = new Map<String, Set<String>>();
		for(Case c : refNumExistingCases) {
			if(refNumExistingCaseMap.get(c.CH_CaseOriginSystem__c) == null) {
				refNumExistingCaseMap.put(c.CH_CaseOriginSystem__c, new Set<String>());
			}
			refNumExistingCaseMap.get(c.CH_CaseOriginSystem__c).add(c.Reference_Number__c);
		}
		for(Case c : cases) {
			if(refNumExistingCaseMap.get(c.CH_CaseOriginSystem__c) != null && refNumExistingCaseMap.get(c.CH_CaseOriginSystem__c).contains(c.Reference_Number__c)) {
				//Changes made for the bug-26589 & NOKIASC-26928- US
				//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
				c.addError(System.Label.CH_Cannot_Create_Case_Reference_Number+' '+c.Reference_Number__c);
				casesWithErrors.add(c);
			} else { casesWithoutErrors.add(c);
				   }
		}
		return casesWithoutErrors;
	}
	
	/****************************************
* Value Name : TMOBILE_ORIGIN_CODE
* Description : Constant to store text code (system name) for TMobile external system
****************************************/
	@testVisible
	private static final String TMOBILE_ORIGIN_CODE = 'tmobile-tim';
	
	/****************************************
* Class Name : ComplexMappingKey
* Description : Inner class to represent mapping range to use in getTMobileMappings helper method.
****************************************/
	private class ComplexMappingKey {
		public String prefix = null;
		public Integer numericValue = null;
		public String mappingCode = null;
		public String rawExternalSystemAccount = null;
		
		public ComplexMappingKey(String rawExternalSystemAccount){
			this.rawExternalSystemAccount = rawExternalSystemAccount;
			
			if (rawExternalSystemAccount.contains('|')) {
				String interfaceString = rawExternalSystemAccount.replace(' ', '').substringBefore('|');
				
				this.prefix = interfaceString.replaceAll('[0-9]', '');
				this.mappingCode = rawExternalSystemAccount.substringAfter('|').trim();
				if (interfaceString.containsAny('0123456789')) { this.numericValue = integer.valueof(interfaceString.replaceAll('[a-zA-Z]', ''));
															   }
			}
		}
	}
	
	/********************
*Method Name: getTMobileMappings
*Parameter: Case List
*Description: Used to query InterfaceMapping record for TMobile.
* TMobile is using ranges fields (RangePrefix__c, RangeStart__c, RangeEnd__c) to define range of values for
* mapiing entrys so should be queried in a different way.
*******************/
	@testVisible
	private static List<CH_Case_PA_InterfaceMapping__c> getTMobileMappings(List<Case> specialCases) {
		List<ComplexMappingKey> complexMappingKeys = new List<ComplexMappingKey>();
		
		for(Case c : specialCases) {
			if (c.CH_CaseOriginSystem__c == TMOBILE_ORIGIN_CODE) {
				ComplexMappingKey aComplexMappingKey = new ComplexMappingKey(c.CH_ExternalSystemAccount__c);
				if (aComplexMappingKey.numericValue != null) { complexMappingKeys.add(aComplexMappingKey);
															 } else {
																 //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
																 c.addError(System.Label.CH_Cannot_Extract_Mapping_Range_From_External_System_Account_Field);
																 casesWithErrors.add(c);
															 }
			}
		}
		
		if (complexMappingKeys.size() == 0) { return new List<CH_Case_PA_InterfaceMapping__c>();
											}
		
		// select mappings for TMobile
		String queryTemplateStringForTMobile =
			'SELECT Id, CaseOriginSystem__c, AccountIn__c, AccountOut__c, SolutionOut__c, ProductOut__c, VariantOut__c, ' +
			'ProductReleaseOut__c, EntitlementOut__c, RangePrefix__c, RangeStart__c, RangeEnd__c ' +
			'FROM CH_Case_PA_InterfaceMapping__c ' +
			'WHERE CaseOriginSystem__c = :TMOBILE_ORIGIN_CODE AND ({0})';
		
		String mappingRanges = '';
		
		for (Integer i = 0; i < complexMappingKeys.size(); i++) {
			mappingRanges += '(RangePrefix__c = \'' + complexMappingKeys[i].prefix + '\' ';
			mappingRanges += 'AND RangeStart__c <= ' + complexMappingKeys[i].numericValue + ' ';
			mappingRanges += 'AND RangeEnd__c >= ' + complexMappingKeys[i].numericValue + ' ';
			mappingRanges += 'AND AccountIn__c = \'' + complexMappingKeys[i].mappingCode + '\' )';
			if (i != complexMappingKeys.size() - 1) {
				mappingRanges += ' OR ';
			}
		}
		
		String queryStringForTMobile = String.format(queryTemplateStringForTMobile, new List<Object>{mappingRanges});
		List<CH_Case_PA_InterfaceMapping__c> iMappingListForTMobile = Database.query(queryStringForTMobile);
		List<CH_Case_PA_InterfaceMapping__c> iMappingRecordsToAdd = new List<CH_Case_PA_InterfaceMapping__c>();
		
		// add TMobile mappings to iMapping list
		for (CH_Case_PA_InterfaceMapping__c interfaceMappingRecord: iMappingListForTMobile) {
			for (ComplexMappingKey complexMappingKeyItem: complexMappingKeys) {
				if (complexMappingKeyItem.prefix == interfaceMappingRecord.RangePrefix__c
					&& complexMappingKeyItem.numericValue >= interfaceMappingRecord.RangeStart__c
					&& complexMappingKeyItem.numericValue <= interfaceMappingRecord.RangeEnd__c
					&& complexMappingKeyItem.mappingCode == interfaceMappingRecord.AccountIn__c) {
						// change AccountIn__c from mapping to ExternalSystemAccount from Case
						interfaceMappingRecord.AccountIn__c = complexMappingKeyItem.rawExternalSystemAccount;
						iMappingRecordsToAdd.add(interfaceMappingRecord);
						break;
					}
			}
		}
		return iMappingRecordsToAdd;
	}
	
	/********************
*Method Name: sendUpdatesToExternalSyetem
*Parameter: Old Case List, New Case List
*Description: method to determine if field from list of "fields visible by customer" is changed and if so - send field update callout to external system
*******************/
	public static void sendFieldUpdatesToExternalSystem(Map<Id, Case> oldCases, List<Case> cases) {
		Map<String, String> notificationTitles = new Map<String, String>{
			'CH_Summary__c' => 'Summary to Customer',
				'CH_CustomerDescription__c' => 'Customer Description'
				};
					for (Case c : cases) {
						for (String notificationField : notificationTitles.keySet()) {
							if (oldCases.get(c.Id).get(notificationField) != c.get(notificationField)) {
								sendFieldUpdatesToExternalSystem(c.Id, notificationField, notificationTitles.get(notificationField), '{0}');
							}
						}
					}
	}
	
	/********************
*Method Name: sendFieldUpdatesToExternalSystem
*Parameter: String caseNumber, String fieldUpdatesMapJSON
*Description: method to send field update message to external system
*******************/
	@future(callout=true)
	private static void sendFieldUpdatesToExternalSystem(Id caseId, String notificationField, String notificationTitle, String notificationBody) {
		Set<String> caseFields = new Set<String> {'Id', 'CaseNumber', 'CH_Stage__c', 'Origin', 'CreatedDate', 'LastModifiedDate', 'CH_CaseOriginSystem__c', 'Reference_Number__c', notificationField};
			
			List<Case> cases = Database.query(String.format('SELECT {0} FROM Case WHERE Id =:caseId', new List<Object>{String.join(new List<String>(caseFields), ',')}));
		List<Case> casesWithOriginSystem = filterS2SCasesWOriginSystem(cases);
		List<Case> availableForS2SOutboundMessageCases = isolateS2SbyStage(casesWithOriginSystem);  
		
		if (!availableForS2SOutboundMessageCases.isEmpty()) {
			Case c = availableForS2SOutboundMessageCases[0];
			CH_partnerNAIPWSDLForSF.Case_x s2sCase = new CH_partnerNAIPWSDLForSF.Case_x();
			s2sCase.sObjects = new CH_partnerNAIPWSDLForSF.sObjects();
			s2sCase.sObjects.CH_Action_ExternalSystem_xc = SWS_Constants.CREATEINFOUPDATE;
			s2sCase.sObjects.CaseNumber = c.CaseNumber;
			if(c.CH_CaseOriginSystem__c == 'Telefonica'){
				s2sCase.sObjects.CH_CaseOriginSystem_xc = 'telefonica'; 
			} else {
				s2sCase.sObjects.CH_CaseOriginSystem_xc = c.CH_CaseOriginSystem__c;
			}
			s2sCase.sObjects.ReferenceNumber_xc = c.Reference_Number__c;  
			//NOKIASC-27526
			s2sCase.sObjects.CreatedDate = c.CreatedDate;
			s2sCase.sObjects.LastModifiedDate = c.LastModifiedDate;
			
			CH_partnerNAIPWSDLForSF.FeedItem feedItem = new CH_partnerNAIPWSDLForSF.FeedItem();
			feedItem.sObjects = new CH_partnerNAIPWSDLForSF.sObjects2();
			feedItem.sObjects.Title = notificationTitle;
			//NOKIASC-27526
			feedItem.sObjects.CreatedDate = system.now();
			feedItem.sObjects.Body = String.format(notificationBody, new List<Object>{c.get(notificationField)});
			if(notificationField == 'CH_CustomerDescription__c'){
				String bodyHTMLReplacement = feedItem.sObjects.Body;
				bodyHTMLReplacement = bodyHTMLReplacement.replace('<p><br>', '\n');
				bodyHTMLReplacement = bodyHTMLReplacement.replace('</p>', '');
				bodyHTMLReplacement = bodyHTMLReplacement.replace('<p>', '\n');
				feedItem.sObjects.Body = bodyHTMLReplacement;	 
			}
			sendS2SRequestToExternalSystem(caseId, s2sCase, feedItem, String.format('Field Update Feed\n\n\n{0}\n\n\n{1}', new List<Object> {s2sCase, feedItem}));
		}
	}
	
	/********************
*Method Name: sendNotificationToExternalSystem
*Parameter: String caseNumber, String fieldUpdatesMapJSON
*Description: method to send notification to external system
*******************/
	@future(callout=true)
	public static void sendNotificationToExternalSystem(Id caseId, Id caseCommentId, String notificationTitle, String notificationBody, String operationType) {
		List<Case> cases = [SELECT Id, CaseNumber, CH_Stage__c, Origin, CH_CaseOriginSystem__c,CreatedDate,LastModifiedDate,Reference_Number__c FROM Case WHERE Id =:caseId];
		List<Case> casesWithOriginSystem = filterS2SCasesWOriginSystem(cases);
		List<Case> availableForS2SOutboundMessageCases = isolateS2SbyStage(casesWithOriginSystem);  
		
		if (!availableForS2SOutboundMessageCases.isEmpty()) {
			Case c = availableForS2SOutboundMessageCases[0];
			CH_partnerNAIPWSDLForSF.Case_x s2sCase = new CH_partnerNAIPWSDLForSF.Case_x();
			s2sCase.sObjects = new CH_partnerNAIPWSDLForSF.sObjects();
			s2sCase.sObjects.CH_Action_ExternalSystem_xc = SWS_Constants.CREATEINFOUPDATE;
			s2sCase.sObjects.CaseNumber = c.CaseNumber;
			if(c.CH_CaseOriginSystem__c == 'Telefonica'){
				s2sCase.sObjects.CH_CaseOriginSystem_xc = 'telefonica'; 
			} else {
				s2sCase.sObjects.CH_CaseOriginSystem_xc = c.CH_CaseOriginSystem__c;
			}
			s2sCase.sObjects.ReferenceNumber_xc = c.Reference_Number__c;  
			//NOKIASC-27526
			s2sCase.sObjects.CreatedDate = c.CreatedDate;
			s2sCase.sObjects.LastModifiedDate = c.LastModifiedDate;
			
			CH_partnerNAIPWSDLForSF.FeedItem feedItem = new CH_partnerNAIPWSDLForSF.FeedItem();
			feedItem.sObjects = new CH_partnerNAIPWSDLForSF.sObjects2();
			feedItem.sObjects.Title = notificationTitle;
			feedItem.sObjects.Body = notificationBody;
			//NOKIASC-27526
			feedItem.sObjects.CreatedDate = system.now();
			
			sendS2SRequestToExternalSystem(caseId, s2sCase, feedItem, String.format('Notification. Case Comment Id: {0}\n\n\n{1}\n\n\n{2}', new List<Object> {caseCommentId, s2sCase, feedItem}), operationType);
		}
	}
	
	/********************
*Method Name: sendAttachmentId
*Parameter: Case and Attachment
*Description: Callout to NAIP for sending attachment Id on creation of attachments
*User Story: NOKIASC-15209/NOKIASC-15658
*******************/   
	@future(callout=true)   
	public static void sendAttachmentId (Id caseId, String caseNumber, String caseOriginSystem, String caseReferenceNumber,  String fileName, String attachmentId, String description, Decimal fileSize, String fileType) {
		
		//NOKIASC-27526
		List<Case> cases = [SELECT Id, CaseNumber, CH_Stage__c, Origin, CH_CaseOriginSystem__c,Reference_Number__c,CreatedDate,LastModifiedDate FROM Case WHERE Id =:caseId];
		Case c = cases[0];
		
		CH_partnerNAIPWSDLForSF.Case_x caseRequest = new CH_partnerNAIPWSDLForSF.Case_x();
		CH_partnerNAIPWSDLForSF.sObjects caseSObjects = new CH_partnerNAIPWSDLForSF.sObjects();
		//NOKIASC-27526
		CH_partnerNAIPWSDLForSF.FeedItem feedItem = new CH_partnerNAIPWSDLForSF.FeedItem();
		feedItem.sObjects = new CH_partnerNAIPWSDLForSF.sObjects2();
		feedItem.sObjects.CreatedDate = system.now();
		
		caseSObjects.CH_Action_ExternalSystem_xc = SWS_Constants.CREATEINFOUPDATE;
		caseSObjects.CaseNumber = caseNumber;
		if(caseOriginSystem == 'Telefonica'){
			caseSObjects.CH_CaseOriginSystem_xc = 'telefonica'; 
		} else {
			caseSObjects.CH_CaseOriginSystem_xc = caseOriginSystem;
		}
		caseSObjects.ReferenceNumber_xc = caseReferenceNumber;  
		//NOKIASC-27526
		caseSObjects.CreatedDate = c.CreatedDate;
		caseSObjects.LastModifiedDate = c.LastModifiedDate;
		caseRequest.sObjects = caseSObjects;
		
		CH_partnerNAIPWSDLForSF.Attachment objAttachment = new CH_partnerNAIPWSDLForSF.Attachment();  
		List<CH_partnerNAIPWSDLForSF.sObjects3> listObject3 = new List<CH_partnerNAIPWSDLForSF.sObjects3>();
		CH_partnerNAIPWSDLForSF.sObjects3 objsObject3 = new CH_partnerNAIPWSDLForSF.sObjects3();
		objsObject3.File_Name_xc = fileName;
		objsObject3.CH_Description_xc = description;
		objsObject3.CH_FileType_xc = fileType;
		objsObject3.AttachmentID_xc = attachmentId;
		objsObject3.CH_Size_xc = String.ValueOf(fileSize);
		listObject3.add(objsObject3);  
		objAttachment.sObjects = listObject3;  
		
		String errorMessage = NULL;
		try {
			CH_partnerNAIPWSDLForSF.NOKIA_EAI_CASEHANDLING_COMMON_webservices_inboundFromSalesForce_Port naipConnection = new CH_partnerNAIPWSDLForSF.NOKIA_EAI_CASEHANDLING_COMMON_webservices_inboundFromSalesForce_Port();
			//NOKIASC-27526
			CH_partnerNAIPWSDLForSF.responseToSalesForce response = naipConnection.receiveFromSalesForce(caseRequest, feedItem, objAttachment, NULL, NULL, NULL, NULL, NULL);
			if (!String.isEmpty(response.message)) { errorMessage = response.message;
												   }
		} catch(Exception e) {
			errorMessage = e.getMessage();
		}
		
		Interface_Log__c log = createOutboundCustomerS2SInterfaceLog(String.format('S2S Case {0} {1}', new List<Object> {caseRequest.sObjects.CH_CaseOriginSystem_xc, caseId}), 'Sent AttachmentId Details', errorMessage);
		insert log;
		
		CH_UserNotificationUTIL.sendOutboundFailureNotification(new Map<Id, Interface_Log__c>{caseId => log});
	}
	
	/********************
*Method Name: sendSeverityUpdatesToExternalSystem
*Parameter: Old Case List, New Case List
*Description: method to determine if status field is changed and if so - send field update callout to external system
*******************/ 
	public static void sendSeverityUpdatesToExternalSystem(Map<Id, Case> oldCases, List<Case> cases) {  
		List<Case> caseList = [SELECT Id, CaseNumber, CH_ReportedDate__c, CH_SolutionTargetDate__c, CH_PausedSinceDate__c, CH_CRNumber__c, Severity__c, CH_Originating_Incident_Number__c, CH_Originating_Incident_Number__r.CaseNumber, 
							   (SELECT Id, CH_RnD_Interface__c FROM CH_R_D_Interactions__r WHERE (CH_RnD_Interface__c = 'PRONTO' OR  CH_RnD_Interface__c = 'JIRA')
								AND CH_RnD_Status__c =  'Completed' AND CH_RnD_Type__c =  'Transfer to R&D') 
							   FROM Case WHERE RecordType.DeveloperName = 'CH_Problem' AND Id IN :oldCases.keySet()];  
		
		for (Case c : caseList) {
			if ((oldCases.get(c.Id).Severity__c != c.Severity__c) && !c.CH_R_D_Interactions__r.isEmpty()) {
				sendSeverityUpdatesToPronto(c.Id ,c.CH_R_D_Interactions__r[0].CH_RnD_Interface__c,c.Severity__c, c.CaseNumber, c.CH_Originating_Incident_Number__r.CaseNumber, c.CH_CRNumber__c, c.CH_ReportedDate__c, c.CH_SolutionTargetDate__c, c.CH_PausedSinceDate__c);   
			}
		}
	}
	
	/********************
*Method Name: sendSeverityUpdatesToPronto
*Parameter: Old Case List, New Case List
*Description: method to determine if status field is changed and if so - send field update callout to external system
*******************/
	@future(callout=true)
	public static void sendSeverityUpdatesToPronto(Id caseId,String interfaceType ,String severity, String caseNumber, String incidentNumber, String rndReference, DateTime reportedDate, DateTime solutionTargetDate, DateTime pausedSinceDate) {   
		CH_Problem_RnD_Reference__c outboundRndInteraction;
		if(interfaceType=='PRONTO')
		{
			outboundRndInteraction = new CH_Problem_RnD_Reference__c(CH_RnD_Direction__c = 'outbound',
																	 CH_RnD_Subject__c = String.format('Problem {0}: Severity/Priority Change to {1}', new List<Object>{caseNumber, severity}),
																	 CH_RnD_Type__c = 'Severity Change',
																	 CH_RnD_Interface__c = 'PRONTO',
																	 CH_RnD_Reference__c = rndReference,  
																	 CH_Related_Record__c = caseId,
																	 CH_RnD_Description__c = 'Update Severity'); 
		}
		else if(interfaceType=='JIRA')
		{
			outboundRndInteraction = new CH_Problem_RnD_Reference__c(CH_RnD_Direction__c = 'outbound',
																	 CH_RnD_Subject__c = String.format('Problem {0}: Severity/Priority Change to {1}', new List<Object>{caseNumber, severity}),
																	 CH_RnD_Type__c = 'Severity Change',
																	 CH_RnD_Interface__c = 'JIRA',
																	 CH_RnD_Reference__c = rndReference,  
																	 CH_Related_Record__c = caseId,
																	 CH_RnD_Description__c = 'Update Severity'); 
		}
		
		CH_partnerNAIPWSDLForSF.receiveFromSalesForce request = new CH_partnerNAIPWSDLForSF.receiveFromSalesForce();
		
		request.RndInteraction = new CH_partnerNAIPWSDLForSF.RndInteraction();
		request.RndInteraction.ReferenceNumber = outboundRndInteraction.CH_RnD_Reference__c;
		request.RndInteraction.CreatedDate = Date.Today();
		request.RndInteraction.Subject = outboundRndInteraction.CH_RnD_Subject__c;
		request.RndInteraction.Description = outboundRndInteraction.CH_RnD_Description__c;
		//NOKIASC-32332 start
		if(incidentNumber !=null){ request.RndInteraction.RelatedRecord = incidentNumber;
								 }
		else{
			request.RndInteraction.RelatedRecord = caseNumber;
		}
		//NOKIASC-32332 start
		
		Map<String, String> supportedInterfaces = new Map<String, String> {'PRONTO' => 'pronto','JIRA' => 'jira-bridge'};
			Map<String, String> supportedTypes = new Map<String, String> {'Severity Change' => 'update-analysis'};
				request.RndInteraction.Interface_x = supportedInterfaces.get(outboundRndInteraction.CH_RnD_Interface__c);
		request.RndInteraction.Type_x = supportedTypes.get(outboundRndInteraction.CH_RnD_Type__c);
		
		request.Case_x = new CH_partnerNAIPWSDLForSF.Case_x();
		request.Case_x.sObjects = new CH_partnerNAIPWSDLForSF.sObjects();
		request.Case_x.sObjects.CH_ReportedDate_xc = reportedDate;//NOKIASC-35335
		request.Case_x.sObjects.CH_SolutionTargetDate_xc = solutionTargetDate;//NOKIASC-35311
		request.Case_x.sObjects.CH_PausedSinceDate_xc = pausedSinceDate;//NOKIASC-35311
		request.Case_x.sObjects.Severity_xc = Severity;
		request.Case_x.sObjects.Severity_oi_xc = Severity;
		request.Case_x.sObjects.CaseNumber = caseNumber;
		
		sendOutboundRndInteraction(request, outboundRndInteraction);
	}
	
	
	/********************
*Method Name: filterS2SCasesWOriginSystem
*Parameter: Case List - casesToFilter
*Description: Used to filter S2S Cases with CaseOriginSystem being set to seme value
*******************/
	public static List<Case> filterS2SCasesWOriginSystem(List<Case> casesToFilter) {
		List<Case> result = new List<Case>();
		
		for (Case caseItem : casesToFilter) {
			if (caseItem.Origin == 'S2S' && caseItem.CH_CaseOriginSystem__c != null) {
				result.add(caseItem);
			}
		}
		
		return result;
	}
	
	private static void sendOutboundRndInteraction(CH_partnerNAIPWSDLForSF.receiveFromSalesForce request, CH_Problem_RnD_Reference__c outboundRndInteraction) {
		String requestLog = String.format('R&D {0} {1}\n{2}', new List<Object> {outboundRndInteraction.CH_RnD_Interface__c, outboundRndInteraction.CH_RnD_Type__c, request});
		
		try {
			CH_partnerNAIPWSDLForSF.NOKIA_EAI_CASEHANDLING_COMMON_webservices_inboundFromSalesForce_Port naipConnection = new CH_partnerNAIPWSDLForSF.NOKIA_EAI_CASEHANDLING_COMMON_webservices_inboundFromSalesForce_Port();
			CH_partnerNAIPWSDLForSF.responseToSalesForce response = naipConnection.receiveFromSalesForce(request.Case_x, request.FeedItem, request.Attachment, request.RndInteraction, request.Account, request.Product, NULL, NULL);
			
			if (String.isEmpty(response.message)) {
				if(outboundRndInteraction.CH_RnD_Interface__c == 'JIRA' && outboundRndInteraction.CH_Rnd_Type__c != 'Transfer to R&D') {
					if(!String.isEmpty(response.rndInteractionInterface) && response.rndInteractionInterface == 'jira-bridge'){
						if(!String.isEmpty(response.rndInteractionType) && response.rndInteractionType == 'response-success'){
							outboundRndInteraction.CH_RnD_Status__c = 'Completed';	
						} else {
							outboundRndInteraction.CH_RnD_Status__c = 'In Progress';
						}	
					} else {
						outboundRndInteraction.CH_RnD_Status__c = 'In Progress';
					}
				} else {
					outboundRndInteraction.CH_RnD_Status__c = 'In Progress';
				}
				if(outboundRndInteraction.CH_RnD_Interface__c == 'PRONTO') {
					outboundRndInteraction.CH_RnD_Status__c = 'Completed';
					if (outboundRndInteraction.CH_Rnd_Type__c == 'Transfer to R&D') { outboundRndInteraction.CH_RnD_Reference__c = response.externalID;
																					}
				}
				outboundRndInteraction.CH_RnD_Error_Message__c = NULL;
			} else {
				outboundRndInteraction.CH_RnD_Status__c = 'Failed';
				outboundRndInteraction.CH_RnD_Error_Message__c = response.message;
			}
		} catch(Exception e) {
			outboundRndInteraction.CH_RnD_Status__c = 'Failed';
			outboundRndInteraction.CH_RnD_Error_Message__c = e.getMessage();
		}
		
		outboundRndInteraction.CH_Request__c = JSON.serialize(request);
		upsert outboundRndInteraction;
		
		Interface_Log__c log = createOutboundRndInterfaceLog(String.format('R&D Outbound {0} {1}', new List<Object> {outboundRndInteraction.CH_RnD_Type__c, outboundRndInteraction.CH_Related_Record__c}), requestLog, outboundRndInteraction.CH_RnD_Error_Message__c);
		insert log;
		
		CH_UserNotificationUTIL.sendRndOutboundFailureNotification(log, outboundRndInteraction.Id);
	}
	
	/********************
*Method Name: resendOutboundRndInteraction
*Parameter: outboundRndInteractionId
*Description: resend failed outbound R&D Interactions
*******************/
	public static void resendOutboundRndInteraction(CH_Problem_RnD_Reference__c outboundRndInteraction) {
		CH_partnerNAIPWSDLForSF.receiveFromSalesForce request = (CH_partnerNAIPWSDLForSF.receiveFromSalesForce)JSON.deserialize(outboundRndInteraction.CH_Request__c, CH_partnerNAIPWSDLForSF.receiveFromSalesForce.class); 
		sendOutboundRndInteraction(request, outboundRndInteraction);
	}
	
	/********************
*Method Name: resendOutboundS2SInteraction
*Parameter: outboundS2SInteractionId
*Description: resend failed outbound Customer S2S Interactions US15221
*******************/
	public static void resendOutboundS2SInteraction(Interface_Log__c outboundS2SInteraction) {
		CH_partnerNAIPWSDLForSF.FeedItem feedItem = new CH_partnerNAIPWSDLForSF.FeedItem();
		String caseNumber, caseOriginSystem, referenceNumber, emailSubject, emailBody, externalSystemAction, interfaceRequestSent; 
		Datetime caseCreatedDate, feedCreatedDate;
		Id caseId;
		
		interfaceRequestSent = outboundS2SInteraction.Interface_Request_Sent__c;
		
		if(interfaceRequestSent != null){
			caseNumber = interfaceRequestSent.substringBetween('CaseNumber=',',');   
			caseOriginSystem = interfaceRequestSent.substringBetween('CH_CaseOriginSystem_xc=',',');
			referenceNumber = interfaceRequestSent.substringBetween('ReferenceNumber_xc=',',');
			emailSubject = interfaceRequestSent.substringBetween('Title=',',');
			emailBody = interfaceRequestSent.substringBetween('Body=',',');
			externalSystemAction = interfaceRequestSent.substringBetween('CH_Action_ExternalSystem_xc=',',');
			caseCreatedDate = Datetime.valueOf(interfaceRequestSent.substringBetween('CreatedDate=',','));
			feedCreatedDate = Datetime.valueOf(interfaceRequestSent.substringBetween('createdDate=',','));
			
			if(caseNumber != null && outboundS2SInteraction.Operation_Type__c == 'Insert' && outboundS2SInteraction.Interface_Type__c == 'Customer S2S'){
				Set<String> caseFields = new Set<String> {'Id', 'LastModifiedDate', 'CH_NetworkElementID__c', 'CaseNumber', 'Subject', 'CH_CustomerDescription__c', 'CreatedDate', 'Reference_Number__c', 'CH_CaseOriginSystem__c', 'CreatedBy.Email', 'Product.PMD_Portfolio_Classification__c', 'Product.NCP_Nokia_Product_Id__c', 'Account.Country__c', 'Account.CountryCode__c', 'Account.Name', 'Account.NCP_P20_ID__c', 'Type', 'Severity__c', 'CH_Problem_Type__c', 'CH_Repeatability__c', 'CH_Discovered_in__c', 'CH_HW_Firmware__c', 'CH_HW_Name__c', 'CH_HW_Revision__c', 'CH_SW_Release__c', 'CH_SW_Build__c', 'AssetId', 'CH_ProductRelease__c', 'CH_SW_Build_Name__c', 'CH_SW_Component__c', 'CH_SW_Module__c', 'CH_Product_Module__c', 'SEC_Last_Name__c', 'SEC_First_Name__c', 'ContactEmail', 'ContactPhone', 'CH_Outage__c', 'CH_Stage__c', 'CH_InternalCase__c', 'CH_Classification__c', 'CH_ProductVariant__c', 'CH_Solution__c', 'CH_ReportedDate__c', 'CH_SolutionTargetDate__c', 'CH_PausedSinceDate__c', 'CH_Workaround_Type__c', 'CH_Product_Name__c', 'CH_Product_Release_Name__c', 'CH_Product_Module_Name__c', 'CH_Solution_Name__c', 'CH_Product_Variant_Name__c', 'CH_Account_Name__c', 'Account.AccountNumber'};
			
			List<Case> cases = Database.query(String.format('SELECT {0} FROM Case WHERE CaseNumber =:caseNumber', new List<Object>{String.join(new List<String>(caseFields), ',')}));
			Case c = cases[0];
			
			//Case
			CH_partnerNAIPWSDLForSF.Case_x s2sCase = new CH_partnerNAIPWSDLForSF.Case_x();
			s2sCase.sObjects = new CH_partnerNAIPWSDLForSF.sObjects();
			s2sCase.sObjects.CH_Action_ExternalSystem_xc = externalSystemAction; s2sCase.sObjects.CaseNumber = caseNumber; s2sCase.sObjects.CH_CaseOriginSystem_xc = caseOriginSystem; s2sCase.sObjects.ReferenceNumber_xc = referenceNumber; s2sCase.sObjects.Type_x = c.Type; s2sCase.sObjects.CreatedDate = caseCreatedDate; s2sCase.sObjects.LastModifiedDate = c.LastModifiedDate; 
			
			//CaseObjectList
			CH_partnerNAIPWSDLForSF.CaseObjectList caseObjList = new CH_partnerNAIPWSDLForSF.CaseObjectList();
			caseObjList.networkElementID = c.CH_NetworkElementID__c; caseObjList.severity = c.Severity__c; caseObjList.chOutage = c.CH_Outage__c; caseObjList.secLastName = c.SEC_Last_Name__c; caseObjList.secFirstName = c.SEC_First_Name__c; caseObjList.subject = c.Subject; caseObjList.caseNumber = c.CaseNumber; caseObjList.chInternalCase = String.valueOf(c.CH_InternalCase__c); caseObjList.typeVal = c.Type; caseObjList.referenceNumber = referenceNumber; caseObjList.chActionExternalSystem = externalSystemAction; caseObjList.chCaseOriginSystem = caseOriginSystem; caseObjList.chCustomerDescription = c.CH_CustomerDescription__c; caseObjList.chStage = c.CH_Stage__c; caseObjList.chClassification = c.CH_Classification__c; caseObjList.assetId = c.AssetId; caseObjList.chSwRelease = c.CH_SW_Release__c; caseObjList.chSwBuild = c.CH_SW_Build__c; caseObjList.chSwComponent = c.CH_SW_Component__c; caseObjList.chSwModule = c.CH_SW_Module__c; caseObjList.accountId = c.Account.AccountNumber; caseObjList.chAccountName = c.Account.Name; caseObjList.chProductRelease = c.CH_ProductRelease__c; caseObjList.chProductVariant = c.CH_ProductVariant__c; caseObjList.chSolution = c.CH_Solution_Name__c; caseObjList.chProductModule = c.CH_Product_Module__c; caseObjList.email2 = c.ContactEmail; caseObjList.mobilePhone = c.ContactPhone;

			//CreatedBy
			CH_partnerNAIPWSDLForSF.CreatedBy createdBy = new CH_partnerNAIPWSDLForSF.CreatedBy();
			createdBy.Email = c.CreatedBy.Email;
			
			//FeedItem
			feedItem.sObjects = new CH_partnerNAIPWSDLForSF.sObjects2();
			feedItem.sObjects.CreatedDate = feedCreatedDate; feedItem.sObjects.Title = emailSubject;
			feedItem.sObjects.Body = emailBody;
			
			//Account
			CH_partnerNAIPWSDLForSF.Account account = new CH_partnerNAIPWSDLForSF.Account();
			account.AccountNumber = c.Account.AccountNumber; account.Country = c.Account.Country__c; account.Name = c.Account.Name; account.P20ID = c.Account.NCP_P20_ID__c; account.CountryCode = c.Account.CountryCode__c;
			
			//Product
			CH_partnerNAIPWSDLForSF.Product product = new CH_partnerNAIPWSDLForSF.Product();
			product.NokiaProductId = c.Product.NCP_Nokia_Product_Id__c; product.PortfolioClassification = c.Product.PMD_Portfolio_Classification__c;
			
			sendS2SCreationRequestToExternalSystem(c.Id, s2sCase, createdBy, account, product, feedItem, caseObjList, String.format('S2S Case Creation Resend\n\n\n{0}\n\n\n{1}\n\n\n{2}\n\n\n{3}\n\n\n{4}\n\n\n{5}', new List<Object> {s2sCase, createdBy, account, product, feedItem, caseObjList}));
				
			} else if (caseNumber != null){
				caseId = [SELECT Id FROM Case WHERE CaseNumber=:caseNumber].Id;
				CH_partnerNAIPWSDLForSF.Case_x s2sCase = new CH_partnerNAIPWSDLForSF.Case_x();
				s2sCase.sObjects = new CH_partnerNAIPWSDLForSF.sObjects();
				s2sCase.sObjects.CH_Action_ExternalSystem_xc = externalSystemAction;
				s2sCase.sObjects.CaseNumber = caseNumber;
				if(caseOriginSystem == 'Telefonica'){
					s2sCase.sObjects.CH_CaseOriginSystem_xc = 'telefonica'; 
				} else {
					s2sCase.sObjects.CH_CaseOriginSystem_xc = caseOriginSystem;
				}
				s2sCase.sObjects.ReferenceNumber_xc = referenceNumber;
				s2sCase.sObjects.CreatedDate = caseCreatedDate;
				feedItem.sObjects = new CH_partnerNAIPWSDLForSF.sObjects2();
				feedItem.sObjects.Title = emailSubject;
				feedItem.sObjects.Body = emailBody;
				feedItem.sObjects.CreatedDate = feedCreatedDate;	  
				sendS2SRequestToExternalSystem(caseId, s2sCase, feedItem, String.format('S2S Resend\n\n\n{0}\n\n\n{1}', new List<Object> {s2sCase, feedItem}));
			}
		}
	}
	
	/********************
*Method Name: sendProntoOutboundRndInteraction
*Parameter: outboundRndInteractionId
*Description: method makes callouts to NAIP for: pronto accept-workaround, pronto reject-workaround, pronto reject-correction, pronto create-informationresponse, pronto update-analysis
*******************/
	public static void sendProntoOutboundRndInteraction(CH_Problem_RnD_Reference__c outboundRndInteraction) {
		CH_partnerNAIPWSDLForSF.receiveFromSalesForce request = new CH_partnerNAIPWSDLForSF.receiveFromSalesForce();
		request.RndInteraction = new CH_partnerNAIPWSDLForSF.RndInteraction();
		
		Map<String, String> supportedTypes = new Map<String, String> {'Workaround Accepted' => 'accept-workaround', 
			'Workaround Rejected' => 'reject-workaround', 
			'Correction Rejected' => 'reject-correction',
			'Information Response' => 'create-informationresponse',
			'Information Update' => 'create-informationupdate'};
				Map<String, String> supportedInterfaces = new Map<String, String> {'PRONTO' => 'pronto','JIRA' => 'jira-bridge'};//NOKIASC-24683 added jira
					request.RndInteraction.Interface_x = supportedInterfaces.get(outboundRndInteraction.CH_RnD_Interface__c);
		request.RndInteraction.Type_x = supportedTypes.get(outboundRndInteraction.CH_RnD_Type__c);
		if (String.isEmpty(request.RndInteraction.Interface_x) || String.isEmpty(request.RndInteraction.Type_x) && !Test.isRunningTest()) {
			String validationErrorMessage = String.format(Label.CH_OutboundRndInteraction_UnsupportedInteractionTypeValidation, new List<Object>{outboundRndInteraction.CH_RnD_Interface__c, outboundRndInteraction.CH_RnD_Type__c});
			AuraHandledException validationError = new AuraHandledException(validationErrorMessage);
			validationError.setMessage(validationErrorMessage);
			throw validationError;
		}
		request.RndInteraction.ReferenceNumber = outboundRndInteraction.CH_RnD_Reference__c;
		request.RndInteraction.CreatedDate = outboundRndInteraction.CreatedDate;
		request.RndInteraction.Subject = outboundRndInteraction.CH_RnD_Subject__c;
		request.RndInteraction.Description = outboundRndInteraction.CH_RnD_Description__c;
		//NOKIASC-32332 start
		if(outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__c !=null){ request.RndInteraction.RelatedRecord = outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.CaseNumber;
																								}
		else{
			request.RndInteraction.RelatedRecord = outboundRndInteraction.CH_Related_Record__r.CaseNumber;
		}
		//NOKIASC-32332 start
		
		if (outboundRndInteraction.CH_RnD_Type__c == 'Information Update') {
			request.Case_x = new CH_partnerNAIPWSDLForSF.Case_x();
			request.Case_x.sObjects = new CH_partnerNAIPWSDLForSF.sObjects();
			request.Case_x.sObjects.CH_ReportedDate_xc = outboundRndInteraction.CH_Related_Record__r.CH_ReportedDate__c;
			request.Case_x.sObjects.Severity_xc = outboundRndInteraction.CH_Related_Record__r.Severity__c;
			request.Case_x.sObjects.Severity_oi_xc = outboundRndInteraction.CH_Related_Record__r.Severity__c;
			request.Case_x.sObjects.CH_SolutionTargetDate_xc = outboundRndInteraction.CH_Related_Record__r.CH_SolutionTargetDate__c;//NOKIASC-35311
			request.Case_x.sObjects.CH_PausedSinceDate_xc = outboundRndInteraction.CH_Related_Record__r.CH_PausedSinceDate__c;//NOKIASC-35311
		}
		
		setRndInteractionContent(outboundRndInteraction);
		
		sendOutboundRndInteraction(request, outboundRndInteraction);
	}
	
	/********************
*Method Name: sendCaseAttachments
*Parameter: outboundRndInteraction
*Description: method makes callouts to NAIP for: pronto update-analysis, jira update-analysis
*******************/  
	public static CH_Problem_RnD_Reference__c sendCaseAttachments(CH_Problem_RnD_Reference__c outboundRndInteraction, Case c, Set<Id> attachmentIds) {
		CH_partnerNAIPWSDLForSF.receiveFromSalesForce request = new CH_partnerNAIPWSDLForSF.receiveFromSalesForce();
		request.RndInteraction = new CH_partnerNAIPWSDLForSF.RndInteraction();
		
		Map<String, String> supportedTypes = new Map<String, String> {'Update to R&D' => 'update-analysis'};
			Map<String, String> supportedInterfaces = new Map<String, String> {'PRONTO' => 'pronto','JIRA' => 'jira-bridge'};
				request.RndInteraction.Interface_x = supportedInterfaces.get(outboundRndInteraction.CH_RnD_Interface__c);
		request.RndInteraction.Type_x = supportedTypes.get(outboundRndInteraction.CH_RnD_Type__c);
		if (String.isEmpty(request.RndInteraction.Interface_x) || String.isEmpty(request.RndInteraction.Type_x)) {
			String validationErrorMessage = String.format(Label.CH_OutboundRndInteraction_UnsupportedInteractionTypeValidation, new List<Object>{outboundRndInteraction.CH_RnD_Interface__c, outboundRndInteraction.CH_RnD_Type__c});
			AuraHandledException validationError = new AuraHandledException(validationErrorMessage);
			validationError.setMessage(validationErrorMessage);
			throw validationError;
		}
		request.RndInteraction.ReferenceNumber = outboundRndInteraction.CH_RnD_Reference__c;
		request.RndInteraction.CreatedDate = Datetime.now();
		request.RndInteraction.Subject = outboundRndInteraction.CH_RnD_Subject__c;
		request.RndInteraction.Description = outboundRndInteraction.CH_RnD_Description__c;
		//NOKIASC-32332 start
		if(c.CH_Originating_Incident_Number__c !=null){ request.RndInteraction.RelatedRecord = c.CH_Originating_Incident_Number__r.CaseNumber;
													  }
		else{
			request.RndInteraction.RelatedRecord = c.CaseNumber;
		}
		//NOKIASC-32332 start
		
		request.Case_x = new CH_partnerNAIPWSDLForSF.Case_x();
		request.Case_x.sObjects = new CH_partnerNAIPWSDLForSF.sObjects();
		if (request.RndInteraction.Interface_x == 'pronto') {
			request.Case_x.sObjects.Severity_xc = c.Severity__c;
			request.Case_x.sObjects.Severity_oi_xc = c.Severity__c;
		} else {
			request.Case_x.sObjects.Severity_xc = c.Severity__c + ' | ' + c.Priority;
			request.Case_x.sObjects.Severity_oi_xc = c.Severity__c + ' | ' + c.Priority;
		}
		request.Case_x.sObjects.CH_ReportedDate_xc = c.CH_ReportedDate__c;
		request.Case_x.sObjects.CH_SolutionTargetDate_xc = c.CH_SolutionTargetDate__c; //NOKIASC-39679
		request.Case_x.sObjects.CH_PausedSinceDate_xc = c.CH_PausedSinceDate__c; //NOKIASC-39679
		request.Case_x.sObjects.CaseNumber = c.CaseNumber;
		
		if (request.RndInteraction.Interface_x == 'pronto') {
			request.Attachment = new CH_partnerNAIPWSDLForSF.Attachment();
			request.Attachment.sObjects = new List<CH_partnerNAIPWSDLForSF.sObjects3>();
			for (CH_Attachment__c relatedAttachment : [SELECT Id, AttachmentID__c, CH_Description__c, CH_Size__c, File_Name__c, Sensitive_Data__c, CH_FileType__c FROM CH_Attachment__c WHERE Id IN: attachmentIds]) {
				CH_partnerNAIPWSDLForSF.sObjects3 a = new CH_partnerNAIPWSDLForSF.sObjects3();
				a.CH_Description_xc = relatedAttachment.CH_Description__c;
				if (relatedAttachment.CH_Size__c != NULL) {
					a.CH_Size_xc = String.ValueOf(relatedAttachment.CH_Size__c);
				}
				a.Sensitive_Data_xc = relatedAttachment.Sensitive_Data__c;
				a.AttachmentID_xc = relatedAttachment.AttachmentID__c;
				a.File_Name_xc = relatedAttachment.File_Name__c;
				a.CH_FileType_xc = relatedAttachment.CH_FileType__c;
				request.Attachment.sObjects.add(a);
			}
		}
		
		sendOutboundRndInteraction(request, outboundRndInteraction);
		
		return outboundRndInteraction;
	}
	
	public static void sendOutboundCreateAnalysisRndInteraction(Id outboundRndInteractionId) {
		CH_Problem_RnD_Reference__c outboundRndInteraction = [
			SELECT Id, CreatedDate, CH_RnD_Description__c, CH_RnD_Interface__c, CH_RnD_Subject__c, CH_RnD_Type__c,CH_Related_Record__r.CH_Originating_Incident_Number__c, 
			CH_Related_Record__r.CH_Originating_Incident_Number__r.CaseNumber,CH_Related_Record__r.CaseNumber,CH_Related_Record__r.CH_Product_Module_Name__c, CH_Related_Record__r.CH_Discovered_in__c, CH_Related_Record__r.CH_Repeatability__c, CH_Related_Record__r.CH_Problem_Type__c, 
			CH_Related_Record__r.CH_Product_Module__c,CH_Related_Record__r.CH_ProductVariant__c, CH_Related_Record__r.CH_ProductVariant__r.NokiaCPQ_Alias__c, CH_Related_Record__r.CH_SW_Build__c, 
			CH_Related_Record__r.CH_SW_Build__r.Name, CH_Related_Record__r.CH_SW_Component__c, CH_Related_Record__r.CH_SW_Module__c,CH_Related_Record__r.CH_SW_Release__c, CH_Related_Record__r.CH_SW_Release__r.Name, CH_Related_Record__r.ContactEmail, CH_Related_Record__r.ContactPhone, 
			CH_Related_Record__r.Owner.Email, CH_Related_Record__r.Owner.Phone, CH_Related_Record__r.CreatedDate,CH_Related_Record__r.SEC_First_Name__c, CH_Related_Record__r.CH_SW_Release_Name__c, CH_Related_Record__r.SEC_Last_Name__c, CH_Related_Record__r.Severity__c,
			CH_Related_Record__r.Priority, CH_Related_Record__r.CH_CustomerDescription__c,CH_Related_Record__r.CH_IssueDescription__c,CH_Related_Record__r.Subject, CH_Related_Record__r.AssetId, CH_Related_Record__r.Account.AccountNumber, CH_Related_Record__r.Account.Country__c, 
			CH_Related_Record__r.CH_ReportedDate__c,CH_Related_Record__r.CH_PausedSinceDate__c, CH_Related_Record__r.CH_SolutionTargetDate__c,CH_Related_Record__r.Account.CountryCode__c, CH_Related_Record__r.Account.Name, CH_Related_Record__r.Account.NCP_P20_ID__c, 
			CH_Related_Record__r.CreatedBy.Email,  CH_Related_Record__r.CH_HW_Name__c, CH_Related_Record__r.CH_Product_Name__c,CH_Related_Record__r.CH_HW_Revision__c, CH_Related_Record__r.CH_SW_Build_Name__c, CH_Related_Record__r.CH_SW_Build__r.CH_NSNAliasName__c, 
			CH_Related_Record__r.Product.NokiaCPQ_Alias__c, CH_Related_Record__r.Product.Name, CH_Related_Record__r.Product.PMD_Portfolio_Classification__c, CH_Related_Record__r.CH_Pronto_Group__r.Name,CH_Related_Record__r.CH_Product_Release_Name__c, CH_Related_Record__r.CH_SW_Module__r.Name, 
			CH_Related_Record__r.CH_SW_Component__r.Name , CH_Related_Record__r.CH_Originating_Incident_Number__r.Account.LE_L4_Name__c , CH_Related_Record__r.CH_Originating_Incident_Number__r.Severity__c ,CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_ServiceContractNumber__c,
			CH_Related_Record__r.CH_Originating_Incident_Number__r.Priority ,CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_Product_Name__c, CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_Product_Module_Name__c,  CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_Product_Release_Name__c , 
			CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_SW_Release_Name__c,  CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_ServiceType__c, 
			CH_Related_Record__r.CH_ActionTaken__c, CH_Related_Record__r.CH_PreventiveActions__c, CH_Related_Record__r.CH_CorrectiveActions__c, CH_Related_Record__r.CH_ProblemStatement__c, CH_Related_Record__r.Steps_to_Reproduce_Issue__c,
			CH_Related_Record__r.CH_CauseoftheIncident__c, CH_Related_Record__r.CH_ListofContributingCauses__c, CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_Rep_CDBContractType__c, CH_Related_Record__r.CH_SummaryofAnalysis__c, CH_Related_Record__r.CH_Root_Cause_Description__c, CH_Related_Record__r.CH_ValidationofRootCause__c,
			CH_Related_Record__r.CH_TemporarySolution__c, CH_Related_Record__r.CH_Workaround_Type__c  FROM CH_Problem_RnD_Reference__c  WHERE Id =: outboundRndInteractionId
		];
		
		CH_partnerNAIPWSDLForSF.receiveFromSalesForce request = new CH_partnerNAIPWSDLForSF.receiveFromSalesForce();
		request.RndInteraction = new CH_partnerNAIPWSDLForSF.RndInteraction();
		request.RndInteraction.CreatedDate = outboundRndInteraction.CreatedDate;
		request.RndInteraction.Description = outboundRndInteraction.CH_RnD_Description__c;
		request.RndInteraction.Subject = outboundRndInteraction.CH_RnD_Subject__c;
		//NOKIASC-31495 start
		if(outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__c !=null){ request.RndInteraction.RelatedRecord = outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.CaseNumber;
																								}
		else{
			request.RndInteraction.RelatedRecord = outboundRndInteraction.CH_Related_Record__r.CaseNumber;
		}
		//NOKIASC-31495 end 
		request.RndInteraction.Type_x = 'create-analysis';
		
		request.Product = new CH_partnerNAIPWSDLForSF.Product();
		
		request.Account = new CH_partnerNAIPWSDLForSF.Account();
		request.Account.AccountNumber = outboundRndInteraction.CH_Related_Record__r.Account.AccountNumber;
		request.Account.Country = outboundRndInteraction.CH_Related_Record__r.Account.Country__c;
		request.Account.Name = outboundRndInteraction.CH_Related_Record__r.Account.Name;
		if(outboundRndInteraction.CH_RnD_Interface__c == 'JIRA') {
			request.Product.NokiaProductId = outboundRndInteraction.CH_Related_Record__r.Product.NokiaCPQ_Alias__c;
			request.Product.PortfolioClassification = outboundRndInteraction.CH_Related_Record__r.Product.PMD_Portfolio_Classification__c;
			request.Case_x = createJiraCreateAnalysisCaseRequest(outboundRndInteraction);
			request.RndInteraction.Interface_x = 'jira-bridge';
		}
		if(outboundRndInteraction.CH_RnD_Interface__c == 'PRONTO') {
			request.Product.NokiaProductId = outboundRndInteraction.CH_Related_Record__r.Product.NokiaCPQ_Alias__c;
			request.Account.P20ID = outboundRndInteraction.CH_Related_Record__r.Account.NCP_P20_ID__c;
			request.Case_x = createProntoCreateAnalysisCaseRequest(outboundRndInteraction);
			request.RndInteraction.Interface_x = 'pronto';
		}
		setCreateAnalysisRndInteractionContent(request, outboundRndInteraction);
		sendOutboundRndInteraction(request, outboundRndInteraction);
	}
	
	private static CH_partnerNAIPWSDLForSF.Case_x createJiraCreateAnalysisCaseRequest(CH_Problem_RnD_Reference__c outboundRndInteraction) {
		// Case
		CH_partnerNAIPWSDLForSF.Case_x caseRequest = new CH_partnerNAIPWSDLForSF.Case_x();
		CH_partnerNAIPWSDLForSF.sObjects rndCaseSObjects = new CH_partnerNAIPWSDLForSF.sObjects();
		rndCaseSObjects.CaseNumber = outboundRndInteraction.CH_Related_Record__r.CaseNumber;
		rndCaseSObjects.CH_DiscoveredIn_xc = outboundRndInteraction.CH_Related_Record__r.CH_Discovered_in__c;
		rndCaseSObjects.CH_Problem_Repeatability_xc = outboundRndInteraction.CH_Related_Record__r.CH_Repeatability__c;
		rndCaseSObjects.CH_Problem_Type_xc = outboundRndInteraction.CH_Related_Record__r.CH_Problem_Type__c;
		if (outboundRndInteraction.CH_Related_Record__r.CH_ProductVariant__c != NULL) {
			rndCaseSObjects.CH_ProductVariant_xc = outboundRndInteraction.CH_Related_Record__r.CH_ProductVariant__r.NokiaCPQ_Alias__c;
		}
		rndCaseSObjects.CH_SW_Build_xc = outboundRndInteraction.CH_Related_Record__r.CH_SW_Build_Name__c + ' | ' + outboundRndInteraction.CH_Related_Record__r.CH_SW_Build__r.CH_NSNAliasName__c;
		rndCaseSObjects.CH_SW_Component_xc = outboundRndInteraction.CH_Related_Record__r.CH_SW_Component__r.Name;
		rndCaseSObjects.CH_SW_Module_xc = outboundRndInteraction.CH_Related_Record__r.CH_SW_Module__r.Name;
		
		//29704
		rndCaseSObjects.CH_SW_Release_xc = outboundRndInteraction.CH_Related_Record__r.CH_SW_Release_Name__c;
		rndCaseSObjects.ContactEmail = outboundRndInteraction.CH_Related_Record__r.Owner.Email;
		rndCaseSObjects.ContactPhone = outboundRndInteraction.CH_Related_Record__r.Owner.Phone;
		rndCaseSObjects.CreatedDate = outboundRndInteraction.CH_Related_Record__r.CreatedDate;
		rndCaseSObjects.CH_ReportedDate_xc = outboundRndInteraction.CH_Related_Record__r.CH_ReportedDate__c;//NOKIASC-35335
		rndCaseSObjects.CH_SolutionTargetDate_xc = outboundRndInteraction.CH_Related_Record__r.CH_SolutionTargetDate__c;//NOKIASC-35311
		rndCaseSObjects.CH_PausedSinceDate_xc = outboundRndInteraction.CH_Related_Record__r.CH_PausedSinceDate__c;//NOKIASC-35311
		rndCaseSObjects.SEC_First_Name_xc = outboundRndInteraction.CH_Related_Record__r.SEC_First_Name__c;
		rndCaseSObjects.SEC_Last_Name_xc = outboundRndInteraction.CH_Related_Record__r.SEC_Last_Name__c;
		//New Fields For Jira NOKIASC-36137 Added By Eashwar 22/06/2021
		//Origin Incident fields
		rndCaseSObjects.LE_L4_Name_xc= outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.Account.LE_L4_Name__c;
		rndCaseSObjects.Priority=outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.Priority;
		rndCaseSObjects.ProductId=outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_Product_Name__c;
		rndCaseSObjects.CH_Product_Release_xc=outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_Product_Release_Name__c;
		rndCaseSObjects.CH_SW_Release_oi_xc = outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_SW_Release_Name__c;
		rndCaseSObjects.CH_Product_Module_xc = outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_Product_Module_Name__c;
		rndCaseSObjects.CH_Service_Type_xc=outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_ServiceType__c;
		rndCaseSObjects.CH_ServiceContractType_xc=outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_Rep_CDBContractType__c; 
		// rndCaseSObjects
		// Incident fields
		rndCaseSObjects.CH_Problem_Type_xc=outboundRndInteraction.CH_Related_Record__r.CH_Problem_Type__c;
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.CH_ActionTaken__c)) { 
			rndCaseSObjects.CH_ActionTaken_xc=outboundRndInteraction.CH_Related_Record__r.CH_ActionTaken__c.stripHtmlTags();
		}
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.CH_PreventiveActions__c)) { 
			rndCaseSObjects.CH_Corrective_Preventive_Action_xc=outboundRndInteraction.CH_Related_Record__r.CH_PreventiveActions__c.stripHtmlTags();
		}
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.CH_CorrectiveActions__c)) { 
			rndCaseSObjects.CH_CorrectiveActions_xc=outboundRndInteraction.CH_Related_Record__r.CH_CorrectiveActions__c.stripHtmlTags();
		}
		rndCaseSObjects.CH_ProblemStatement_xc=outboundRndInteraction.CH_Related_Record__r.CH_ProblemStatement__c;
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.Steps_to_Reproduce_Issue__c)) { 
			rndCaseSObjects.Steps_to_Reproduce_Issue_xc=outboundRndInteraction.CH_Related_Record__r.Steps_to_Reproduce_Issue__c.stripHtmlTags();
		}
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.CH_CauseoftheIncident__c)) { 
			rndCaseSObjects.CH_CauseoftheIncident_xc =outboundRndInteraction.CH_Related_Record__r.CH_CauseoftheIncident__c.stripHtmlTags();
		}
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.CH_ListofContributingCauses__c)) { 
			rndCaseSObjects.CH_ListofContributingCauses_xc=outboundRndInteraction.CH_Related_Record__r.CH_ListofContributingCauses__c.stripHtmlTags();
		}
		rndCaseSObjects.CH_SummaryofAnalysis_xc=outboundRndInteraction.CH_Related_Record__r.CH_SummaryofAnalysis__c;
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.CH_Root_Cause_Description__c)) { 
			rndCaseSObjects.CH_Root_Cause_Description_xc=outboundRndInteraction.CH_Related_Record__r.CH_Root_Cause_Description__c.stripHtmlTags();
		}
		rndCaseSObjects.CH_ValidationofRootCause_xc=outboundRndInteraction.CH_Related_Record__r.CH_ValidationofRootCause__c;
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.CH_TemporarySolution__c)) { 
			rndCaseSObjects.CH_TemporarySolution_xc=outboundRndInteraction.CH_Related_Record__r.CH_TemporarySolution__c.stripHtmlTags();
		}
		rndCaseSObjects.CH_Workaround_Type_xc =   outboundRndInteraction.CH_Related_Record__r.CH_Workaround_Type__c;
		rndCaseSObjects.Severity_oi_xc = outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.Severity__c;
		rndCaseSObjects.Severity_xc = outboundRndInteraction.CH_Related_Record__r.Severity__c;
		//Ends Here NOKIASC-36137 
		
		//Nokiasc-26230
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.CH_IssueDescription__c)) { 
			rndCaseSObjects.Description = outboundRndInteraction.CH_Related_Record__r.CH_IssueDescription__c.stripHtmlTags();
		}
		
		rndCaseSObjects.Subject = outboundRndInteraction.CH_Related_Record__r.Subject;
		// Created By
		CH_partnerNAIPWSDLForSF.CreatedBy rndCreatedBy = new CH_partnerNAIPWSDLForSF.CreatedBy();
		rndCreatedBy.Email = outboundRndInteraction.CH_Related_Record__r.CreatedBy.Email;
		rndCaseSObjects.CreatedBy = rndCreatedBy;
		caseRequest.sObjects = rndCaseSObjects;
		return caseRequest;
	}
	
	private static CH_partnerNAIPWSDLForSF.Case_x createProntoCreateAnalysisCaseRequest(CH_Problem_RnD_Reference__c outboundRndInteraction) {
		// Case
		CH_partnerNAIPWSDLForSF.Case_x caseRequest = new CH_partnerNAIPWSDLForSF.Case_x();
		CH_partnerNAIPWSDLForSF.sObjects rndCaseSObjects = new CH_partnerNAIPWSDLForSF.sObjects();
		rndCaseSObjects.CaseNumber = outboundRndInteraction.CH_Related_Record__r.CaseNumber;
		rndCaseSObjects.CH_DiscoveredIn_xc = outboundRndInteraction.CH_Related_Record__r.CH_Discovered_in__c;
		rndCaseSObjects.CH_HW_Name_xc = outboundRndInteraction.CH_Related_Record__r.CH_HW_Name__c;
		rndCaseSObjects.CH_HW_Revision_xc = outboundRndInteraction.CH_Related_Record__r.CH_HW_Revision__c;
		rndCaseSObjects.CH_Problem_Repeatability_xc = outboundRndInteraction.CH_Related_Record__r.CH_Repeatability__c;
		rndCaseSObjects.CH_Problem_Type_xc = outboundRndInteraction.CH_Related_Record__r.CH_Problem_Type__c;
		rndCaseSObjects.CH_SW_Build_xc = outboundRndInteraction.CH_Related_Record__r.CH_SW_Build__r.Name;
		rndCaseSObjects.CH_SW_Build_Name_xc = outboundRndInteraction.CH_Related_Record__r.CH_SW_Build_Name__c;
		rndCaseSObjects.CH_SW_Release_xc = outboundRndInteraction.CH_Related_Record__r.CH_SW_Release_Name__c;
		
		//New Fields For PRONTO NOKIASC-36137 Added By Eashwar 22/06/2021
		//Origin Incident fields
		rndCaseSObjects.LE_L4_Name_xc= outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.Account.LE_L4_Name__c;
		rndCaseSObjects.Priority=outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.Priority;
		rndCaseSObjects.ProductId=outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_Product_Name__c;
		rndCaseSObjects.CH_Product_Release_xc=outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_Product_Release_Name__c;
		rndCaseSObjects.CH_Product_Module_xc = outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_Product_Module_Name__c;
		rndCaseSObjects.CH_SW_Release_oi_xc=outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_SW_Release_Name__c;
		rndCaseSObjects.CH_SW_Release_xc = outboundRndInteraction.CH_Related_Record__r.CH_SW_Release_Name__c;
		rndCaseSObjects.CH_Service_Type_xc=outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_ServiceType__c;
		rndCaseSObjects.CH_ServiceContractType_xc=outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.CH_Rep_CDBContractType__c; 
		// rndCaseSObjects
		// Incident fields
		rndCaseSObjects.CH_Problem_Type_xc=outboundRndInteraction.CH_Related_Record__r.CH_Problem_Type__c;
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.CH_ActionTaken__c)) { 
			rndCaseSObjects.CH_ActionTaken_xc=outboundRndInteraction.CH_Related_Record__r.CH_ActionTaken__c.stripHtmlTags();
		}
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.CH_PreventiveActions__c)) { 
			rndCaseSObjects.CH_Corrective_Preventive_Action_xc=outboundRndInteraction.CH_Related_Record__r.CH_PreventiveActions__c.stripHtmlTags();
		}
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.CH_CorrectiveActions__c)) { 
			rndCaseSObjects.CH_CorrectiveActions_xc=outboundRndInteraction.CH_Related_Record__r.CH_CorrectiveActions__c.stripHtmlTags();
		}
		rndCaseSObjects.CH_ProblemStatement_xc=outboundRndInteraction.CH_Related_Record__r.CH_ProblemStatement__c;
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.Steps_to_Reproduce_Issue__c)) { 
			rndCaseSObjects.Steps_to_Reproduce_Issue_xc=outboundRndInteraction.CH_Related_Record__r.Steps_to_Reproduce_Issue__c.stripHtmlTags();
		}
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.CH_CauseoftheIncident__c)) {   
			rndCaseSObjects.CH_CauseoftheIncident_xc =outboundRndInteraction.CH_Related_Record__r.CH_CauseoftheIncident__c.stripHtmlTags();
		}
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.CH_ListofContributingCauses__c)) { 
			rndCaseSObjects.CH_ListofContributingCauses_xc=outboundRndInteraction.CH_Related_Record__r.CH_ListofContributingCauses__c.stripHtmlTags();
		}
		rndCaseSObjects.CH_SummaryofAnalysis_xc=outboundRndInteraction.CH_Related_Record__r.CH_SummaryofAnalysis__c;
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.CH_Root_Cause_Description__c)) { 
			rndCaseSObjects.CH_Root_Cause_Description_xc=outboundRndInteraction.CH_Related_Record__r.CH_Root_Cause_Description__c.stripHtmlTags();
		}
		rndCaseSObjects.CH_ValidationofRootCause_xc=outboundRndInteraction.CH_Related_Record__r.CH_ValidationofRootCause__c;
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.CH_TemporarySolution__c)) { 
			rndCaseSObjects.CH_TemporarySolution_xc=outboundRndInteraction.CH_Related_Record__r.CH_TemporarySolution__c.stripHtmlTags();
		}
		rndCaseSObjects.CH_Workaround_Type_xc =   outboundRndInteraction.CH_Related_Record__r.CH_Workaround_Type__c;
		rndCaseSObjects.Severity_oi_xc = outboundRndInteraction.CH_Related_Record__r.CH_Originating_Incident_Number__r.Severity__c;
		rndCaseSObjects.Severity_xc = outboundRndInteraction.CH_Related_Record__r.Severity__c;
		//Ends Here NOKIASC-36137 
		
		//Nokiasc-26230
		if (!String.isEmpty(outboundRndInteraction.CH_Related_Record__r.CH_IssueDescription__c)) { 
			rndCaseSObjects.Description = outboundRndInteraction.CH_Related_Record__r.CH_IssueDescription__c.stripHtmlTags();
		}
		
		rndCaseSObjects.Subject = outboundRndInteraction.CH_Related_Record__r.Subject;
		rndCaseSObjects.CreatedDate = outboundRndInteraction.CH_Related_Record__r.CreatedDate;
		rndCaseSObjects.CH_ReportedDate_xc = outboundRndInteraction.CH_Related_Record__r.CH_ReportedDate__c;//NOKIASC-35335
		rndCaseSObjects.CH_SolutionTargetDate_xc = outboundRndInteraction.CH_Related_Record__r.CH_SolutionTargetDate__c;//NOKIASC-35311
		rndCaseSObjects.CH_PausedSinceDate_xc = outboundRndInteraction.CH_Related_Record__r.CH_PausedSinceDate__c;//NOKIASC-35311
		rndCaseSObjects.UserEmail = UserInfo.getUserEmail();
		rndCaseSObjects.ProntoGroupName =  outboundRndInteraction.CH_Related_Record__r.CH_Pronto_Group__r.Name;
		caseRequest.sObjects = rndCaseSObjects;
		return caseRequest;
	}
	
	private static void setRndInteractionContent(CH_Problem_RnD_Reference__c outboundRndInteraction) {
		if (outboundRndInteraction.CH_RnD_Interface__c == 'PRONTO' ||outboundRndInteraction.CH_RnD_Interface__c == 'JIRA') { //NOKIASC-24683 added jira
			Map<String, String> contents = new Map<String, String> {'Workaround Rejected' => 'Workaround Rejection to {0} {1}\n=====Request=======\n{2}\n=====Response=======\n{3}', 
				'Correction Rejected' => 'Correction Rejection to {0} {1}\n=====Request=======\n{2}\n=====Response=======\n{3}',
				'Information Response' => 'Information Response to {0} {1}\n=====Request=======\n{2}\n=====Response=======\n{3}'};
					if (contents.containsKey(outboundRndInteraction.CH_RnD_Type__c)) {
						String content = contents.get(outboundRndInteraction.CH_RnD_Type__c);
						String relatedDescription = '';
						if (outboundRndInteraction.CH_Related_RnD_Interaction__c != NULL) { relatedDescription = outboundRndInteraction.CH_Related_RnD_Interaction__r.CH_RnD_Description__c;
																						  }
						outboundRndInteraction.CH_RnD_Content__c = String.format(content, new List<Object>{outboundRndInteraction.CH_RnD_Interface__c, Datetime.now(), relatedDescription, outboundRndInteraction.CH_RnD_Description__c});
					}
		}
	}
	//Ref: 22895 Removed If condition in order to populate content in both jira & pronto
	private static void setCreateAnalysisRndInteractionContent(CH_partnerNAIPWSDLForSF.receiveFromSalesForce request, CH_Problem_RnD_Reference__c outboundRndInteraction) {
		
		String content = 'Problem Transfer to {0} {1}\n=====Problem Details======={2}\n=====Originating Incident Details======={3}';
		
		String problemContent = '';
		Map<String, Object> problemFields = new Map<String, Object> {'Problem Number' => request.Case_x.sObjects.CaseNumber,
			'Reported Date' => request.Case_x.sObjects.CH_ReportedDate_xc, //NOKIASC-38909
			'Discovered In' => request.Case_x.sObjects.CH_DiscoveredIn_xc,
			'HW Name' => request.Case_x.sObjects.CH_HW_Name_xc,
			'HW Revision' => request.Case_x.sObjects.CH_HW_Revision_xc,
			'Problem Repetability' => request.Case_x.sObjects.CH_Problem_Repeatability_xc,
			'Problem Type' => request.Case_x.sObjects.CH_Problem_Type_xc,
			'SW Build' => request.Case_x.sObjects.CH_SW_Build_xc,
			'SW Build Name' => request.Case_x.sObjects.CH_SW_Build_Name_xc,
			'SW Release' => request.Case_x.sObjects.CH_SW_Release_xc,
			'Description' => request.Case_x.sObjects.Description,
			'Severity' => request.Case_x.sObjects.Severity_xc,
			'Subject' => request.Case_x.sObjects.Subject,
			'User Email' => request.Case_x.sObjects.UserEmail,
			'Pronto Group Name' => request.Case_x.sObjects.ProntoGroupName,
			'R&D Subject' => request.RndInteraction.Subject,
			'R&D Description' => request.RndInteraction.Description,
			'R&D Created Date' => request.RndInteraction.CreatedDate,   
			'Account Number' => request.Account.AccountNumber,
			'Account Country' => request.Account.Country,
			'Account Name' => request.Account.Name,
			'Account P20ID' => request.Account.P20ID,
			'Product Name' => request.Product.NokiaProductId
			};
				
				for (String fieldLabel : problemFields.keySet()) {
					Object fieldValue = problemFields.get(fieldLabel);
					if (fieldValue != NULL) {
						problemContent += String.format('\n{0}:"{1}"', new List<Object>{fieldLabel, fieldValue});
					} else {
						problemContent += String.format('\n{0}:""', new List<Object>{fieldLabel});
					}
				}
		
		String originatingIncidentContent = '';
		outboundRndInteraction.CH_RnD_Content__c = String.format(content, new List<Object>{outboundRndInteraction.CH_RnD_Interface__c, Datetime.now(), problemContent, originatingIncidentContent});
	}
	
	//Changes added as a part of NOKIASC-35311
	public static void sendSolutionTargetDateToProntoOrJira(Id caseId, DateTime reportedDate, DateTime pausedSinceDate,DateTime solutionTargetDate, String caseNumber, String incidentNumber, String rndReference,string rndInterface,string severity,string rndSubject) {   
		CH_Problem_RnD_Reference__c outboundRndInteraction = new CH_Problem_RnD_Reference__c(CH_RnD_Direction__c = 'outbound',
																							 CH_RnD_Subject__c = rndSubject,
																							 CH_RnD_Type__c = 'Update to R&D',
																							 CH_RnD_Interface__c = rndInterface,
																							 CH_RnD_Reference__c = rndReference,  
																							 CH_Related_Record__c = caseId,
																							 CH_RnD_Description__c = 'Update on '+rndSubject); 
		
		CH_partnerNAIPWSDLForSF.receiveFromSalesForce request = new CH_partnerNAIPWSDLForSF.receiveFromSalesForce();
		
		request.RndInteraction = new CH_partnerNAIPWSDLForSF.RndInteraction();
		request.RndInteraction.ReferenceNumber = outboundRndInteraction.CH_RnD_Reference__c;
		request.RndInteraction.CreatedDate = Date.Today();
		request.RndInteraction.Subject = outboundRndInteraction.CH_RnD_Subject__c;
		request.RndInteraction.Description = outboundRndInteraction.CH_RnD_Description__c;
		if(incidentNumber !=null){ request.RndInteraction.RelatedRecord = incidentNumber; }
		else{ request.RndInteraction.RelatedRecord = caseNumber; }
		Map<String, String> supportedInterfaces = new Map<String, String> {'PRONTO' => 'pronto','JIRA' => 'jira-bridge'};
			//what should be the value of CH_RnD_Interface__c for Solution Target Date and Paused Since Date 
			Map<String, String> supportedTypes = new Map<String, String> {'Update to R&D' => 'update-analysis'};
				request.RndInteraction.Interface_x = supportedInterfaces.get(outboundRndInteraction.CH_RnD_Interface__c);
		request.RndInteraction.Type_x = supportedTypes.get(outboundRndInteraction.CH_RnD_Type__c);
		
		request.Case_x = new CH_partnerNAIPWSDLForSF.Case_x();
		request.Case_x.sObjects = new CH_partnerNAIPWSDLForSF.sObjects();
		request.Case_x.sObjects.CH_ReportedDate_xc = reportedDate;
		request.Case_x.sObjects.CH_PausedSinceDate_xc = pausedSinceDate;
		request.Case_x.sObjects.CH_SolutionTargetDate_xc = solutionTargetDate;
		request.Case_x.sObjects.CaseNumber = caseNumber;
		request.Case_x.sObjects.Severity_xc = severity;
		request.Case_x.sObjects.Severity_oi_xc = severity;
		sendOutboundRndInteraction(request, outboundRndInteraction);
	}
}