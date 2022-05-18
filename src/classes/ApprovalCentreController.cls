/**
* @description: ApprovalCentreController contorller's apex class. This is used to extend the functionality of lightning component.
*	  The class includes methods to retrieve all accessable Approval's Details for the User.
* @author:	Accenture IDC.
* ============================================================================
* History:
* -------
* VERSION AUTHOR	DATE		DETAIL			FEATURES/CSR/TTP
* 1.0	23/11/2016   Sprint 7 LoA requirements.
* ============================================================================
*/
public without sharing class ApprovalCentreController{
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Nov-2016
* Param: String searchKeyWord
* Return: List<WrapperWildCardSearch>
* Description: Retrieve all records from Account,Opportunity,offer and Document objects depending on the input passed to the menthod
* High Level Process :
********************************************************************************************************************* */
	@AuraEnabled
	public static ApprovalCentreWrapper basicApprovalDetails(String oppRecordId) {
		List<ApprovalCentreWrapper> wrapperList = new List<ApprovalCentreWrapper>();
		Set<String> phaseStatusValues = getOpportunityPhaseStatusValues();
		ApprovalCentreWrapper wrapperObj = getNewApprovalCentreWrapperObj();
		
		try{
			Opportunity oppObj = new Opportunity();
			oppObj = [select Id,StageName,Name,Account.Market__c,Account.Country__c,FORMAT(G2_Approval_Date__c),FORMAT(G3_Approval_Date__c),
					  FORMAT(G4_Approval_Date__c),FORMAT(G5_Approval_Date__c),FORMAT(G6_Approval_Date__c),Account.Name, Supporting_BGs_BUs__c,Lead_BG__c,Lead_BU__c,Phase_Status__c,
					  (select Approval_Scope__c,
					   LoA_Currency__c, Offer_Description__c,Offer_Number__c,Lead_BG__c,Lead_BU__c,LoA_Approval_Level__c,
					   LoA_Level_Before_Trigger_Approval__c, WTD_Case__c /*BP-FT-1961*/
					   from Offers__r where ActiveOffer__c =: true limit 1) from Opportunity where id =: oppRecordId limit 1];
			List<Apttus_Approval__Approval_Request__c> approvalCreaterDetailsObj = [SELECT Id,Tech_Status__c,Aproval_Completion_days__c,Apttus_Approval__ActualApproverName__c,Validator_Status__c,Apttus_Approval__Date__c,Apttus_Approval__Assigned_To_Id__c,CreatedBy.Name,CreatedBy.SmallPhotoUrl,NF_Role_Name__c,Apttus_Approval__Assigned_To_Name__c,Apttus_Approval__Approver_Comments__c,Apttus_Approval__Approval_Status__c,NF_Assignee_Type__c,APTSCU_Approval_Action__c,Apttus_Approval__DelegateApproverIds__c,Delegate_Approvers__c FROM Apttus_Approval__Approval_Request__c WHERE Apttus_Approval__Object_Id__c =: oppObj.Id and NF_Assignee_Type__c IN (:GlobalConstants.VALIDATOR,:GlobalConstants.APPROVER, :GlobalConstants.STAKEHOLDER_INFORMATION) Order by createdDate desc Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			approvalCreaterDetailsObj = removeCommentsSystemInfo(approvalCreaterDetailsObj);
			System.debug('approvalCreaterDetailsObj:::>'+approvalCreaterDetailsObj);
			for(String gateValue : phaseStatusValues){
				if(oppObj.StageName.equalsIgnoreCase(GlobalConstants.WITH_DRAW_BY_NOKIA)||oppObj.StageName.equalsIgnoreCase(GlobalConstants.LOST_TO_COMPETITOR)||oppObj.StageName.equalsIgnoreCase(GlobalConstants.OBSOLETE)||oppObj.StageName.equalsIgnoreCase(GlobalConstants.COMPLETED_OPPTY)||oppObj.StageName.equalsIgnoreCase(GlobalConstants.CANCELLED_BY_CUSTOMER)){
					wrapperObj.notAllowToCreateTask = true;
					break;
				}
				
				if(oppObj.Phase_Status__c.contains(gateValue))
				{
					wrapperObj.gateStep = gateValue;
					break;
				}else{
					wrapperObj.gateStep = GlobalConstants.CURRENTLY_NO_GATE;
					wrapperObj.approvalReqDate = null;
				}
			}
			
			wrapperObj.opportunityName = oppObj.Name;
			wrapperObj.opportunityId = oppObj.Id;
			wrapperObj.customer = oppObj.Account.Name;
			
			if(approvalCreaterDetailsObj.size()>0)
			{
				if(approvalCreaterDetailsObj[0].Apttus_Approval__Date__c != null && !wrapperObj.gateStep.equalsIgnoreCase(GlobalConstants.CURRENTLY_NO_GATE))
				{
					wrapperObj.approvalReqDate =  Date.valueof(approvalCreaterDetailsObj[0].Apttus_Approval__Date__c );
				}
				if(approvalCreaterDetailsObj[0].CreatedBy.SmallPhotoUrl != null)
				{
					wrapperObj.approverPhotoURL =  approvalCreaterDetailsObj[0].CreatedBy.SmallPhotoUrl;
					System.debug('approverPhotoURL:::>'+approvalCreaterDetailsObj[0].CreatedBy.SmallPhotoUrl);
				}
			}
			if(oppObj.Account.Market__c != Null && oppObj.Account.Country__c == Null)
			{
				wrapperObj.marketOrCountry = oppObj.Account.Market__c;
			}
			else if(oppObj.Account.Market__c == Null && oppObj.Account.Country__c != Null)
			{
				wrapperObj.marketOrCountry = oppObj.Account.Country__c;
			}
			else if (oppObj.Account.Market__c != Null && oppObj.Account.Country__c != Null)
			{
				wrapperObj.marketOrCountry = oppObj.Account.Market__c+GlobalConstants.FORWARD_SLASH+oppObj.Account.Country__c;
			}
			else if(oppObj.Account.Market__c == Null && oppObj.Account.Country__c == Null)
			{
				wrapperObj.marketOrCountry = GlobalConstants.BLANK_VALUE;
			}
			else
			{
				System.debug('Nothing');
			}
			if(oppObj.Lead_BG__c != null)
			{
				wrapperObj.leadBG = oppObj.Lead_BG__c;
			}
			if(oppObj.Lead_BU__c != null)
			{
				wrapperObj.leadBU = oppObj.Lead_BU__c;
			}
			if(oppObj.Supporting_BGs_BUs__c != null)
			{
				wrapperObj.supportingBGsBUs = oppObj.Supporting_BGs_BUs__c;
			}
			if(!oppObj.Offers__r.isEmpty())
			{
				//BP-FT-1961
				if(!String.isBlank(oppObj.Offers__r[0].WTD_Case__c))
					wrapperObj.WinTheDealLink = oppObj.Offers__r[0].WTD_Case__c;
				if(oppObj.Offers__r[0].Offer_Number__c != null)
				{
					wrapperObj.offerNumber = oppObj.Offers__r[0].Offer_Number__c;
				}
				
				if(oppObj.Offers__r[0].LoA_Approval_Level__c != null)
				{
					wrapperObj.loaApprovalLevel = oppObj.Offers__r[0].LoA_Approval_Level__c;
				}
				if(oppObj.Offers__r[0].LoA_Level_Before_Trigger_Approval__c != null)
				{
					wrapperObj.loaApprovalLevelBeforeSTA = oppObj.Offers__r[0].LoA_Level_Before_Trigger_Approval__c;
				}
				String loACurrency;
				If(oppObj.Offers__r[0].LoA_Currency__c == Null){
					loACurrency=GlobalConstants.BLANK_VALUE;
				}
				else{
					loACurrency=oppObj.Offers__r[0].LoA_Currency__c;
				}
				if(oppObj.Offers__r[0].Approval_Scope__c!= null)
				{
					wrapperObj.approvalScope = oppObj.Offers__r[0].Approval_Scope__c;
				}
				if(oppObj.Offers__r[0].Offer_Description__c != null)
				{
					wrapperObj.offerDescription = String.valueOf(oppObj.Offers__r[0].Offer_Description__c).replaceAll(GlobalConstants.REMOVE_PARA_TAG ,GlobalConstants.BLANK_VALUE);
				}
				else
				{
					System.debug('Nothing');
				}
			}else{
				wrapperObj.offerNumber = GlobalConstants.BLANK_VALUE;
			}
			if(approvalCreaterDetailsObj.size()>0)
			{
				List<Apttus_Approval__Approval_Request__c> appoverRecoList = new List<Apttus_Approval__Approval_Request__c>();
				List<Apttus_Approval__Approval_Request__c> validatorRecoList = new List<Apttus_Approval__Approval_Request__c>();
				System.debug('approvalCreaterDetailsObj:::>'+approvalCreaterDetailsObj);
				
				wrapperObj.approvalRequester = approvalCreaterDetailsObj[0].CreatedBy.Name;
				for(Apttus_Approval__Approval_Request__c approvalObj : approvalCreaterDetailsObj)
				{
					if(approvalObj.NF_Assignee_Type__c.equalSIgnoreCase(GlobalConstants.VALIDATOR))
					{
						validatorRecoList.add(approvalObj);
					}
					else if(approvalObj.NF_Assignee_Type__c.equalSIgnoreCase(GlobalConstants.APPROVER))
					{
						appoverRecoList.add(approvalObj);
					}
				}
				wrapperObj.validatorRecList =validatorRecoList;
				wrapperObj.approverRecList = appoverRecoList;
				System.debug('validatorRecoList::>'+validatorRecoList);
				System.debug('appoverRecoList::>'+appoverRecoList);
			}
			else
			{
				wrapperObj.approvalRequester = GlobalConstants.NO_APPROVAL_REQ;
			}
			wrapperObj = returnApprovalStatusInfo(approvalCreaterDetailsObj,wrapperObj);
			System.debug('wrapperObj::>'+wrapperObj);
			wrapperList.add(wrapperObj);
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, ApprovalCentreController.class.getName(), GlobalConstants.BasicApprovalDetailsMethod);
			System.debug('Exception message:::>'+ex.getMessage());
		}
		return wrapperObj;
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Nov-2016
* Param: Id recordId
* Return: Map<String, List<Document__c>>
* Description: Retrieve all related list records of a object for current user
- New Req. Change : 4703 : Updates in LoA based on new DocStrategy ReDesign
* High Level Process :
********************************************************************************************************************* */
	@AuraEnabled
	public static  List<DocumentWrapper> getConfidentialDocs(Id currentRecordId)
	{
		List<Confidential_File__c> lstConfiDocs = new List<Confidential_File__c>();
		List<DocumentWrapper> lstConfiDocsWrapper = new List<DocumentWrapper>();
		DocumentWrapper objDocumentWrapper ;
		try
		{
			if(File_Sharing_Custom_Setting__c.getInstance(GlobalConstants.LOA_G4_G5_DOCUMENTTYPES) != null)
			{
				for(Confidential_File__c doc : [SELECT
												Content_Version_Name__c,ContentDocumentId__c,lastmodifieddate,lastmodifiedby.name,Description__c,Document_Type__c,Id,IsDeleted,Offer__c,Opportunity__c
												FROM
												Confidential_File__c
												where
												Offer__r.Opportunity__c = : currentRecordId and Offer__r.ActiveOffer__c = true and IsDeleted = false ORDER BY LastModifiedDate asc Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())])
				{
					
					objDocumentWrapper = new DocumentWrapper();
					objDocumentWrapper.strDocumentName = doc.Content_Version_Name__c;
					objDocumentWrapper.strDocumentType = doc.Document_Type__c;
					objDocumentWrapper.strLastModifiedBy = doc.lastmodifiedby.name;
					objDocumentWrapper.strLastModifiedDate = string.valueof(doc.lastmodifieddate);
					objDocumentWrapper.strContentDocumentID = doc.ContentDocumentId__c;
					
					lstConfiDocsWrapper.add(objDocumentWrapper);
					lstConfiDocs.add(doc);
					
				}
			}
			else
			{
				System.debug('LOA_G4_G5_DOCUMENTTYPES custom setting not created in File Sharing Custom Setting. Pls create one');
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, ApprovalCentreController.class.getName(), GlobalConstants.METHOD_RETRIEVEDOCUMENTS);
		}
		
		return lstConfiDocsWrapper;
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Nov-2016
* Param: Id recordId
* Return: Map<String, List<Document__c>>
* Description: Retrieve all related list records of a object for current user
- New Req. Change : 4703 : Updates in LoA based on new DocStrategy ReDesign
* High Level Process :
********************************************************************************************************************* */
	@AuraEnabled
	public static  List<DocumentWrapper> getG4_G5_Docs(Id currentRecordId)
	{
		Set<String> gateDocumentTypes = new Set<String>();
		List<ContentVersion> lstContentVersion = new List<ContentVersion>();
		List<DocumentWrapper> lstG4G5DocsWrapper = new List<DocumentWrapper>();
		DocumentWrapper objDocumentWrapper ;
		
		try
		{
			Id OfferId = [select id,opportunity__c from offer__c where opportunity__c=:currentRecordId AND ActiveOffer__c = true].id;
			
			if(File_Sharing_Custom_Setting__c.getInstance(GlobalConstants.LOA_G4_G5_DOCUMENTTYPES) != null)
			{
				for(String docType : File_Sharing_Custom_Setting__c.getInstance(GlobalConstants.LOA_G4_G5_DOCUMENTTYPES).Value__c.split(GlobalConstants.COMMA))
				{
					gateDocumentTypes.add(docType.trim());
				}
				System.debug('gateDocumentTypes'+gateDocumentTypes);
				set<id> idContentDocumentLink = new set<id>();
				map<id,string> mapContentDocIDVerNumber = new map<id,string>();
				
				for(ContentDocumentLink OContentDocumentLink : [SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility
																FROM
																ContentDocumentLink
																WHERE LinkedEntityId = :OfferId])
				{
					idContentDocumentLink.add(OContentDocumentLink.ContentDocumentId);
				}
				System.debug('ContentDocumentLink'+idContentDocumentLink);
				for(ContentVersion doc : [SELECT ContentDocumentId, Document_Type_POC__c,description,isdeleted,title,VersionNumber  FROM ContentVersion WHERE ContentDocumentId in :idContentDocumentLink AND isLatest= true AND isdeleted= false])
					
				{
					System.debug('lstContentVersion'+gateDocumentTypes.contains(doc.Document_Type_POC__c));
					if(gateDocumentTypes.contains(doc.Document_Type_POC__c))
					{
						mapContentDocIDVerNumber.put(doc.ContentDocumentId,doc.VersionNumber);
					}
				}
				for(File_Report__c objFileReport : [select ContentDocumentId__c,Document_Type__c,File_Name__c,File_Version__c,LastModifiedBy.Name,LastModifiedDate from File_Report__c where ContentDocumentId__c in : mapContentDocIDVerNumber.keyset()])
				{
					if( mapContentDocIDVerNumber.get(objFileReport.ContentDocumentId__c) == objFileReport.File_Version__c)
					{
						objDocumentWrapper = new DocumentWrapper();
						objDocumentWrapper.strDocumentName = objFileReport.File_Name__c;
						objDocumentWrapper.strDocumentType = objFileReport.Document_Type__c;
						objDocumentWrapper.strLastModifiedBy = objFileReport.LastModifiedBy.name;
						objDocumentWrapper.strLastModifiedDate = string.valueof(objFileReport.lastmodifieddate);
						objDocumentWrapper.strContentDocumentID = objFileReport.ContentDocumentId__c;
						
						lstG4G5DocsWrapper.add(objDocumentWrapper);
					}
				}
				System.debug('lstContentVersion'+lstContentVersion);
			}
			else
			{
				System.debug('LOA_G4_G5_DOCUMENTTYPES custom setting not created in File Sharing Custom Setting. Pls create one');
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, ApprovalCentreController.class.getName(), GlobalConstants.METHOD_RETRIEVEDOCUMENTS);
		}
		System.debug('lstG4G5DocsWrapper'+lstG4G5DocsWrapper);
		return lstG4G5DocsWrapper;
	}
	
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Feb-2017
* Param: None
* Return: WrapperWildCardSearch
* Description: Returns new instance of WrapperWildCardSearch
* High Level Process :
**********************************************************************************************************************/
	@AuraEnabled
	public static String approvalRequest(String approvalRequestId, String comment)
	{
		try
		{
			System.debug('Approval Request Id::'+approvalRequestId+'Approval Comment::'+comment);
			String response = APTSCU_ApprovalActionsController.approveRequest(approvalRequestId, comment);
			System.debug(' approvalRequest response::>'+response);
			return response;
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, ApprovalCentreController.class.getName(), GlobalConstants.basicApprovalDetailsMethod);
			return ex.getMessage();
		}
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Feb-2017
* Param: None
* Return: WrapperWildCardSearch
* Description: Returns new instance of WrapperWildCardSearch
* High Level Process :
**********************************************************************************************************************/
	@AuraEnabled
	public static String rejectionRequest(String approvalRequestId, String comment)
	{
		try
		{
			String response = APTSCU_ApprovalActionsController.rejectRequest(approvalRequestId, comment);
			return response;
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, ApprovalCentreController.class.getName(), GlobalConstants.basicApprovalDetailsMethod);
			return ex.getMessage();
		}
	}
	
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Dec-2016
* Param:
* Return: ContentDocumentLink
* Description: Returns new instance of ContentDocumentLink
* High Level Process :
**********************************************************************************************************************/
	public static Set<String> getOpportunityPhaseStatusValues(){
		Set<String> phaseStatusValues = new Set<String>();
		try{
			String customString = File_Sharing_Custom_Setting__c.getInstance(GlobalConstants.OPPORTUNITY_GATE_VALUES).Value__c;
			if(customString != null)
			{
				for(String level : customString.split(GlobalConstants.COMMA))
				{
					phaseStatusValues.add(level.trim());
				}
			}
		}catch(Exception ex) {
			ExceptionHandler.addException(ex, ApprovalCentreController.class.getName(), GlobalConstants.METHOD_OPPORTUNITYSALESOUTCOMEVALUE);
		}
		return phaseStatusValues;
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Feb-2017
* Param: None
* Return: WrapperWildCardSearch
* Description: Returns new instance of WrapperWildCardSearch
* High Level Process :
**********************************************************************************************************************/
	private static ApprovalCentreWrapper getNewApprovalCentreWrapperObj(){
		return new ApprovalCentreWrapper();
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Feb-2017
* Param: Apttus_Approval__Approval_Request__c Object Id.
* Return: Apttus_Approval__Approval_Request__c Object fields value.
* Description: Populates the field values of Apttus_Approval__Approval_Request__c Object
* High Level Process :
**********************************************************************************************************************/
	@AuraEnabled
	public static List<Apttus_Approval__Approval_Request__c> getApprovalsDetailsRec(Id oppRecordId)
	{
		List<Apttus_Approval__Approval_Request__c> approvalRecList;
		List<Apttus_Approval__Approval_Request__c> modifiedApprovalRecList;
		try
		{
			Id currentLoggedInUserId;
			currentLoggedInUserId = UserInfo.getUserId();
			approvalRecList = [SELECT Id,NF_BG_Attribute__c,Validator_Status__c,Apttus_Approval__Approver_Comments__c,Apttus_Approval__Step_Name__c,Apttus_Approval__Approval_Status__c,Apttus_Approval__Date__c,
							   Apttus_Approval__Assigned_To_Name__c,NF_Assignee_Type__c,Delegate_Approvers__c,FORMAT(LastModifiedDate),Apttus_Approval__SubmissionComment1__c,Apttus_Approval__SubmissionComment2__c,Apttus_Approval__SubmissionComment3__c,
							   NF_Role_Name__c,NF_Organization_Level__c,Apttus_Approval__ActualApproverName__c,Apttus_Approval__Request_Comments__c
							   FROM Apttus_Approval__Approval_Request__c where Apttus_Approval__Object_Id__c =: oppRecordId and NF_Assignee_Type__c != NULL  and (NF_Assignee_Type__c =: GlobalConstants.APPROVER or NF_Assignee_Type__c =: GlobalConstants.VALIDATOR) Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			modifiedApprovalRecList = removeCommentsSystemInfo(approvalRecList);
			
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, ApprovalCentreController.class.getName(), GlobalConstants.basicApprovalDetailsMethod);
		}
		return modifiedApprovalRecList;
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Aug-2017
* Param: Apttus_Approval__Approval_Request__c Id , Validator Comment, Validate or Reject action .
* Return: Apttus_Approval__Approval_Request__c Object fields value.
* Description: Populates the field values of Apttus_Approval__Approval_Request__c Object
* High Level Process :
**********************************************************************************************************************/
	@AuraEnabled
	public static String validateOrReject (String approvalReqId, String comment, String validateOrRej)
	{
		String response;
		try
		{
			if(validateOrRej.equalsIgnoreCase(GlobalConstants.STAKEHOLDER_ADD_CMT_BTN))
			{
				response =  APTSCU_ApprovalActionsController.addCommentsToRequest( approvalReqId, comment);
			}
			else
			{
				response = APTSCU_ApprovalActionsController.addCommentsToRequest( approvalReqId, comment);
				Apttus_Approval__Approval_Request__c aptusRec = [SELECT APTSCU_Approval_Action__c,Apttus_Approval__Approval_Status__c,Id,NF_Assignee_Type__c,Apttus_Approval__Actual_Approver__c FROM Apttus_Approval__Approval_Request__c WHERE Id =: approvalReqId limit 1];
				if(validateOrRej.equalsIgnoreCase(GlobalConstants.VALIDATE))
				{
					aptusRec.Validator_Status__c = GlobalConstants.VALIDATED_PICKLIST_VALUE;
					aptusRec.Apttus_Approval__Actual_Approver__c = UserInfo.getUserId();
				}
				else
				{
					aptusRec.Validator_Status__c = GlobalConstants.REJECTED_PICKLIST_VALUE;
					aptusRec.Apttus_Approval__Actual_Approver__c = UserInfo.getUserId();
				}
				database.update(aptusRec);
			}
			return response;
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, ApprovalCentreController.class.getName(), GlobalConstants.basicApprovalDetailsMethod);
			return ex.getMessage();
		}
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Aug-2017
* Param: Apttus_Approval__Approval_Request__c list .
* Return: Apttus_Approval__Approval_Request__c list.
* Description: Removes unwanted system information from comment field
* High Level Process :
**********************************************************************************************************************/
	public static List<Apttus_Approval__Approval_Request__c> removeCommentsSystemInfo(List<Apttus_Approval__Approval_Request__c> approvalRecList)
	{
		List<Apttus_Approval__Approval_Request__c> modifiedApprovalList = new List<Apttus_Approval__Approval_Request__c>();
		try{
			for(Apttus_Approval__Approval_Request__c apprRec : approvalRecList)
			{
				string resultString;
				if(apprRec.Apttus_Approval__Approver_Comments__c != null)
				{
					String fullString = apprRec.Apttus_Approval__Approver_Comments__c;
					if(fullString.contains(GlobalConstants.SYSTEM_INFO_COMMENT))
					{
						do{
							if(fullString.contains(GlobalConstants.YEAT_FIRSTTWO_DIGITS))
							{
								fullString  = fullString.substringAfter(GlobalConstants.SYSTEM_INFO_COMMENT);
								if(fullString.contains(GlobalConstants.USER_COMMENT))
								{
									fullString = fullString.substringAfter(GlobalConstants.USER_COMMENT);
								}
								else if(fullString.contains(GlobalConstants.APPROVAL_COMMENT))
								{
									fullString = fullString.substringAfter(GlobalConstants.APPROVAL_COMMENT);
								}
								if(fullString.contains(GlobalConstants.YEAT_FIRSTTWO_DIGITS))
								{
									if(String.isBlank(resultString))
									{
										resultString = fullString.substringBefore(GlobalConstants.YEAT_FIRSTTWO_DIGITS);
									}
									else
									{
										resultString = resultString +GlobalConstants.COMMA+fullString.substringBefore(GlobalConstants.YEAT_FIRSTTWO_DIGITS);
									}
									String toBeRemoved = fullString.subString(fullString.indexOf(GlobalConstants.YEAT_FIRSTTWO_DIGITS),fullString.indexOf(GlobalConstants.YEAT_FIRSTTWO_DIGITS)+24);
									fullString = fullString.remove(toBeRemoved);
								}
							}
							else
							{
								break;
							}
						}while(true);
					}
					else
					{
						if(fullString.contains(GlobalConstants.YEAT_FIRSTTWO_DIGITS) && fullString.contains(GlobalConstants.HYPHEN) && fullString.contains(GlobalConstants.COLEN))
						{
							resultString = GlobalConstants.BLANK_VALUE;
						}
						else
						{
							resultString = fullString;
						}
					}
				}
				apprRec.Apttus_Approval__Approver_Comments__c = resultString;
				modifiedApprovalList.add(apprRec);
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, ApprovalCentreController.class.getName(), GlobalConstants.METHOD_REMOVE_COMMENTS_SYS_INFO);
		}
		return modifiedApprovalList;
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Aug-2017
* Param: Apttus_Approval__Approval_Request__c list .
* Return: Apttus_Approval__Approval_Request__c list.
* Description: Removes unwanted system information from comment field
* High Level Process :
**********************************************************************************************************************/
	public static ApprovalCentreWrapper returnApprovalStatusInfo(List<Apttus_Approval__Approval_Request__c> approvalRecList, ApprovalCentreWrapper approvalWrapperObj)
	{
		ApprovalCentreWrapper wrapperObj = approvalWrapperObj;
		Set<String> delegateApproversId = new Set<String>();
		try
		{
			Decimal approvalCompletionDays = Decimal.valueOf(File_Sharing_Custom_Setting__c.getInstance(Globalconstants.APPROVAL_COMPLETION_DAYS).Value__c);
			for(Apttus_Approval__Approval_Request__c apReq : approvalRecList){
				System.debug('apReq:::>'+apReq);
				if(apReq.Apttus_Approval__DelegateApproverIds__c != null)
				{
					delegateApproversId.addAll(String.valueOf(apReq.Apttus_Approval__DelegateApproverIds__c).split(GlobalConstants.COMMA));
				}
				System.debug('delegateApproversId:::'+delegateApproversId);
				System.debug('Id::'+apReq.Id+',Apttus_Approval__Assigned_To_Id__c::'+apReq.Apttus_Approval__Assigned_To_Id__c+',UserId::'+UserInfo.getUserId()+',NF_Assignee_Type__c::'+apReq.NF_Assignee_Type__c+',Apttus_Approval__Approval_Status__c::'+apReq.Apttus_Approval__Approval_Status__c+',Tech_Status__c::'+apReq.Tech_Status__c);
				//Approver button visibility
				if((apReq.Apttus_Approval__Assigned_To_Id__c == UserInfo.getUserId()||delegateApproversId.contains(UserInfo.getUserId()) )  &&
				   apReq.APTSCU_Approval_Action__c != NULL &&
				   (apReq.Apttus_Approval__Approval_Status__c == GlobalConstants.ASSIGNED
					|| apReq.Apttus_Approval__Approval_Status__c ==GlobalConstants.REASSIGNED)){
						System.debug('Approver:::>');
						wrapperObj.approvalRequestId = apReq.id;
						wrapperObj.isApprovalRequested = true;
						if(apReq.Apttus_Approval__Assigned_To_Id__c == UserInfo.getUserId())
						{
							wrapperObj.type = GlobalConstants.APPROVING_AS_APPROVER;
							break;
						}
						else if(delegateApproversId.contains(UserInfo.getUserId()))
						{
							wrapperObj.type = GlobalConstants.APPROVING_AS_DELEGATE;
							break;
						}
						else
						{
							System.debug('Nothing');
						}
					}
				//Validator button visibility
				else if((apReq.Apttus_Approval__Assigned_To_Id__c == UserInfo.getUserId()||delegateApproversId.contains(UserInfo.getUserId())) && (apReq.NF_Assignee_Type__c.equalsIgnoreCase(GlobalConstants.VALIDATOR )) && apReq.Apttus_Approval__Approval_Status__c.equalsIgnoreCase(GlobalConstants.STATUS_NOTIFIED) && (apReq.Tech_Status__c == null || (!apReq.Tech_Status__c.equalsIgnoreCase(GlobalConstants.REJECTED) && !apReq.Tech_Status__c.equalsIgnoreCase(GlobalConstants.CANCELLED))))
				{
					System.debug('apReq.Tech_Status__c::>'+apReq.Tech_Status__c);
					System.debug('Validator:::>'+apReq.Apttus_Approval__Assigned_To_Id__c+'NF::>'+apReq.NF_Assignee_Type__c);
					System.debug('apReq.Validator_Status__c::>'+apReq.Validator_Status__c + 'apReq.Aproval_Completion_days__c:::>'+apReq.Aproval_Completion_days__c);
					wrapperObj.validatorOrApprover = true;
					wrapperObj.approvalRequestId = apReq.id;
					if(apReq.Validator_Status__c == null && (apReq.Aproval_Completion_days__c <= approvalCompletionDays ||apReq.Aproval_Completion_days__c == null))
					{
						System.debug('1::>');
						if(delegateApproversId.contains(UserInfo.getUserId()))
						{
							System.debug('2::>');
							wrapperObj.ValidatonCompletion = false;
							wrapperObj.type = GlobalConstants.VALIDATING_AS_DELEGATE;
							wrapperObj.isApprovalRequested = true;
						}
						else
						{
							System.debug('3::>');
							wrapperObj.ValidatonCompletion = false;
							wrapperObj.type = GlobalConstants.VALIDATING_AS_VALIDATOR;
							wrapperObj.isApprovalRequested = true;
						}
						break;
					}
					else
					{
						System.debug('4::>');
						if(apReq.Aproval_Completion_days__c > approvalCompletionDays && apReq.Validator_Status__c==NUll )
						{
							wrapperObj.validatorEligibilityExpired = true;
						}
						else if(apReq.Validator_Status__c<>NUll)
						{
							wrapperObj.ValidatonCompletion = true;
						}
						wrapperObj.isApprovalRequested = false;
						wrapperObj.type = GlobalConstants.REQUEST_CLOSED;
					}
					
				}
				else
				{
					System.debug('No one:::<'+apReq.Apttus_Approval__Assigned_To_Id__c+'NF::>'+apReq.NF_Assignee_Type__c);
					wrapperObj.approvalRequestId = null;
					wrapperObj.isApprovalRequested = false;
					wrapperObj.type = GlobalConstants.REQUEST_CLOSED;
					wrapperObj.validatorOrApprover = false;
				}
				delegateApproversId.clear();
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, ApprovalCentreController.class.getName(), GlobalConstants.METHOD_RETURN_APPROVAL_STATUS_INFO);
		}
		return wrapperObj;
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: Aug-2017
* Param: Id oppRecordId .
* Return: Task Record list.
* Description: Get all the related task of the opportunity
* High Level Process :
**********************************************************************************************************************/
	@AuraEnabled
	public static List<Task> getTaskDetails(Id oppRecordId)
	{
		Id approval_RecordType_ID = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Approval_Center_Task').getRecordTypeId();
		List<Task> taskRecList;
		try
		{	
			taskRecList = [SELECT Id,Subject,Description,ActivityDate,Status,Owner.Name,WhoId,WhatId FROM Task WHERE Created_At__c != NULL AND WhatId =: oppRecordId AND Recordtypeid =: approval_RecordType_ID Order By CreatedDate desc Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			System.debug('taskRecList::::'+taskRecList);
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, ApprovalCentreController.class.getName(), GlobalConstants.METHOD_RETURN_APPROVAL_STATUS_INFO);
		}
		
		return taskRecList;
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Feb-2018
* Param: Apttus_Approval__Approval_Request__c Object Id.
* Return: Apttus_Approval__Approval_Request__c Object fields value.
* Description: Populates the field value of Apttus_Approval__Approval_Request__c Object
* High Level Process :
**********************************************************************************************************************/
	@AuraEnabled
	public static string getRequestorComment(Id oppRecordId)
	{
		string strComment ;
		List<String> lstPhaseStatus = new List<String>{GlobalConstants.SUBMITTED_FOR_G2_APPROVAL,GlobalConstants.SUBMITTED_FOR_G3_APPROVAL,GlobalConstants.SUBMITTED_FOR_G4_APPROVAL,GlobalConstants.SUBMITTED_FOR_G5_APPROVAL,GlobalConstants.SUBMITTED_FOR_G6_APPROVAL};
			try
		{
			opportunity oppComment = [SELECT Id,Submission_Comments__c
									  FROM
									  opportunity
									  where
									  Phase_Status__c in : lstPhaseStatus AND id =:oppRecordId];
			
			if(oppComment.Submission_Comments__c != GlobalConstants.SALES_EMPTY  || oppComment.Submission_Comments__c != GlobalConstants.BLANK_VALUE )
				strComment = oppComment.Submission_Comments__c;
			else
				return GlobalConstants.SALES_EMPTY ;
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, ApprovalCentreController.class.getName(), GlobalConstants.basicApprovalDetailsMethod);
		}
		return strComment;
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Aug-2017
* Param: Id oppRecordId .
* Return: Task Record list.
* Description: Get all the related task of the opportunity
* High Level Process :
**********************************************************************************************************************/
	@AuraEnabled
	public static Boolean getUserRestriction()
	{
		string strRestriction ;
		try
		{
			strRestriction = [select Restriction_Level__c from user where id=:UserInfo.getUserId()].Restriction_Level__c;
			if(strRestriction == GlobalConstants.CONFIDENTIAL_VALUE)
				return true;
			else
				return false;
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, ApprovalCentreController.class.getName(), GlobalConstants.METHOD_RETURN_APPROVAL_STATUS_INFO);
		}
		
		return null;
	}
}