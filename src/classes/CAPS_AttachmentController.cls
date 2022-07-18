/*************************************************************************************************
 * Class Name : CAPS_AttachmentController
 * Created Date: 27 June 2018
 * Created By : TCS
 * Descsription: Server Side Controller for CAPS Attachment Download/Delete lightning component
 * Last Modified by: 
 * Last Modified Date: 
 * Description : 
*************************************************************************************************/
public without sharing class CAPS_AttachmentController { 

	/*****************************************************
	* Method Name : isCommunity
	* Created Date: 27 June 2018
	* Created By : Jeroen de Vries
	* Descsription: Check if the component is running in SF or in the community
	* Parameter: NA
	* Return: True if running in the communit. False running in SF
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/	
	@AuraEnabled
	public static boolean isCommunity(){
		Id siteId = Site.getSiteId(); 
		if (siteId != null) {
			return true;
		}
		return false;
	}

	//Get all the workgroup members 
	@AuraEnabled
	public static boolean getCaseTeamMembers(String caseId){
		String userId = UserInfo.getUserId();
		List<CaseTeamMember> oCaseTeamMembers = [SELECT Id, Member.Name, Member.Id, TeamRole.Name, CreatedDate FROM CaseTeamMember WHERE ParentId =: caseId];
		List<CaseTeamMember> currentUserInCaseTeamMember = new List<CaseTeamMember>();
		Id siteId = Site.getSiteId();
		
		if(!oCaseTeamMembers.isEmpty()){
			for(CaseTeamMember oCaseTeamMember : oCaseTeamMembers){
	if(oCaseTeamMember.Member.Id == userId){
		currentUserInCaseTeamMember.add(oCaseTeamMember);
	}
			}
		} else if(siteId != null){
			return true;
		}
		if(!currentUserInCaseTeamMember.isEmpty() && siteId != null){
			return true;
		} else if(!currentUserInCaseTeamMember.isEmpty() && siteId == null){
			return true;
		} else if(currentUserInCaseTeamMember.isEmpty() && siteId != null){
			return true;
		} else {
			List<Case> oCaseOwner = [SELECT Id, OwnerId FROM Case WHERE Id =: caseId AND OwnerId =: userId];
			if(!oCaseOwner.isEmpty() && siteId != null){
	return true;	 
			} else if (!oCaseOwner.isEmpty() && siteId == null){
	return true;
			} else if (oCaseOwner.isEmpty() && siteId != null){
	return true;
			} else { 
	return false;
			}
		}
	}
	
	/*****************************************************
	* Method Name : userProfileCheck
	* Created Date: 2 May 2019
	* Created By : TCS
	* Descsription: Check if logged in user profile is CH_Agent or not
	* Parameter: N/A
	* Return: CH_Agent true or flase
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/  
	@AuraEnabled
	public static boolean getUserProfileDetails(){
		Profile profiledet = [Select Name from Profile where Id =: userinfo.getProfileid()];
		String pname = profiledet.name;
		if(pname != 'CH_Agent')
			return true;
		else 
			return false;
	}
	/*****************************************************
	* Method Name : removeDeleteButton
	* Created Date: 27 June 2019
	* Created By : TCS
	* Descsription: Check if CH_SuspectedDataBreach__c is checked
	* Parameter: Case Id
	* Return: True or False
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/  
	@AuraEnabled
	public static boolean getDeleteButton(Id caseid){
		List<Case> caseList = [SELECT Id, CH_SuspectedDataBreach__c FROM Case where Id =: caseid LIMIT 1];
		if(!caseList.isEmpty() && caseList[0].CH_SuspectedDataBreach__c){
			return false;}
		else{return true;}
	}
	/*****************************************************
	* Method Name : getAttachment
	* Created Date: 27 June 2018
	* Created By : TCS
	* Descsription: Fetch all Attachment added to a case. Method is called from lightning component
	* Parameter: case Id
	* Return: attachment list
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/
	@AuraEnabled
	public static List<CH_Attachment__c> getAttachment(Id caseId) {
		
		List <CH_Attachment__c> chAttachmentList = new List <CH_Attachment__c>();
	

		if(caseId !=null){
			if (isCommunity()) {
	chAttachmentList = [SELECT Id, Name,CH_Size__c, CH_Uploaded__c,CH_Description__c,AttachmentID__c,CH_Status__c, 
			File_Name__c,CH_Portal_or_Email_to_Case__c, Customer_Visible__c, Sensitive_Data__c,CH_FileType__c,CH_MarkForDelete__c 
			FROM CH_Attachment__c 
			WHERE Case__c = :caseId AND Customer_Visible__c = true AND CH_FileType__c != 'Scrambled'  AND ((CH_Status__c NOT IN ('On Hold', 'Failed') AND CH_Portal_or_Email_to_Case__c = 'Salesforce')
			OR CH_Portal_or_Email_to_Case__c != 'Salesforce')
			ORDER BY CH_Uploaded__c DESC];
			}
			else {
	chAttachmentList = [SELECT Id, Name,CH_Size__c, CH_Uploaded__c,CH_Description__c,AttachmentID__c,CH_Status__c, 
			File_Name__c,CH_Portal_or_Email_to_Case__c, Customer_Visible__c, Sensitive_Data__c,CH_FileType__c,CH_MarkForDelete__c 
			FROM CH_Attachment__c 
			WHERE Case__c = :caseId  AND ((CH_Status__c NOT IN ('On Hold', 'Failed') AND CH_Portal_or_Email_to_Case__c = 'Portal')
	OR CH_Portal_or_Email_to_Case__c != 'Portal')
			ORDER BY CH_Uploaded__c DESC];
			}
		}
		return chAttachmentList;
	}

	/*****************************************************
	* Method Name : getPortalAttachment
	* Created Date: 27 June 2018
	* Created By : Jeroen de Vries
	* Descsription: Fetch all Attachment that need to be visible in the portal
	* Parameter: case Id
	* Return: attachment list
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/	
	@AuraEnabled
	public static List<CH_Attachment__c> getPortalAttachment(Id caseId) {
		
		List <CH_Attachment__c> chAttachmentList = new List <CH_Attachment__c>();

		if(caseId !=null){
			chAttachmentList = [SELECT Id, Name,CH_Size__c, CH_Uploaded__c,CH_Description__c,AttachmentID__c,CH_Status__c,
		File_Name__c, Customer_Visible__c, Sensitive_Data__c,CH_FileType__c,CH_MarkForDelete__c 
		FROM CH_Attachment__c 
		WHERE Case__c = :caseId AND Customer_Visible__c = true AND CH_FileType__c != 'Scrambled'
		ORDER BY CH_Uploaded__c DESC];
		}
		return chAttachmentList;
	}
	
	/*****************************************************
	* Method Name : downloadAttachments
	* Created Date: 27 June 2018
	* Created By : TCS
	* Descsription: download attachments from CAPS. Method is called from lightning component
	* Parameter: attachmentIds
	* Return: response from CAPS
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/
	@AuraEnabled
	public static List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper> downloadAttachments(List<String> attachmentIds, List<CH_Attachment__c> attachmentList){
		List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper> downloadWarp = new List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper>() ;
		if(!attachmentIds.isEmpty() && !attachmentList.isEmpty()){
			Map<String,List<String>> cAPSattachIdVsFileListMap = new Map<String, List<String>>();
			List<String> fileNameList;
			Set<String> attachmentIdSet = new Set<String>();
			attachmentIdSet.addAll(attachmentIds);//convert to set 
			for(CH_Attachment__c attchObj: attachmentList){
	fileNameList = new List<String>();
	if(attachmentIdSet.contains(attchObj.Id) && !String.isBlank(attchObj.AttachmentID__c) && !String.isBlank(attchObj.File_Name__c)){
		if(!cAPSattachIdVsFileListMap.isEmpty() && cAPSattachIdVsFileListMap.containsKey(attchObj.AttachmentID__c)){//if map already have same caps attachmentid
			fileNameList = cAPSattachIdVsFileListMap.get(attchObj.AttachmentID__c);
			fileNameList.add(attchObj.File_Name__c);
		}
		else{
			fileNameList.add(attchObj.File_Name__c);
		}
		cAPSattachIdVsFileListMap.put(attchObj.AttachmentID__c,fileNameList);
	}
			}
			CAPS_Attachments_Download chDownload = new CAPS_Attachments_Download();
			if(!cAPSattachIdVsFileListMap.isEmpty()){
	downloadWarp  = chDownload.getAttachment(attachmentIds, cAPSattachIdVsFileListMap);// call outs are happening here
			}
		}
	return downloadWarp;
	}
	/*****************************************************
	* Method Name : updateRetentionDays
	* Created Date:  10 July 2018
	* Created By : TCS
	* Descsription: Update retention days for selected Attachments. Method is called from lightning component
	* Parameter: attachmentIds
	* Return: None
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/
	@AuraEnabled
	public static void updateRetentionDays(List<String> listRecords, List<CH_Attachment__c> attachmentList, Id caseRecordId){
		List<Case> caseList = [SELECT Id, CH_SuspectedDataBreach__c FROM Case where Id =: caseRecordId LIMIT 1];
		if(!caseList.isEmpty() && !caseList[0].CH_SuspectedDataBreach__c && !listRecords.isEmpty() && attachmentList != null && !attachmentList.isEmpty()){

	Set<String> attachmentIdSet = new Set<String>();
	Set<String> cAPSattachmentIdSet = new Set<String>();
	attachmentIdSet.addAll(listRecords);
	for(CH_Attachment__c attchObj: attachmentList){
		if(attachmentIdSet.contains(attchObj.Id) && !String.isBlank(attchObj.AttachmentID__c)){
			cAPSattachmentIdSet.add(attchObj.AttachmentID__c);//set of caps attachment ids
		}
	}
	 if(!cAPSattachmentIdSet.isEmpty() && !Test.isRunningTest()){
		//update retention days to minimum
		CAPS_Attachment_Delete.updateRetentionDaysforLightning(cAPSattachmentIdSet, true);
			}
		}
	}
	/*****************************************************
	* Method Name : getRequiredCaseInformation
	* Created Date: 30 July 2019
	* Created By : TCS
	* Descsription: Get Neccessary case information in doInit
	* Parameter: Case Id
	* Return: Case
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/ 
	@AuraEnabled
	public static CAPS_AttachmentWrapper getRequiredCaseInformation(Id caseid)
	{
		CAPS_AttachmentWrapper wrappervalue = new CAPS_AttachmentWrapper();
		
		List<Case> caseList = [SELECT Id, CH_SuspectedDataBreach__c, CH_RDInterface__c, RecordType.DeveloperName FROM Case where Id =: caseid LIMIT 1];
		wrappervalue.suspectedDataBreach = caseList[0].CH_SuspectedDataBreach__c;
		wrappervalue.rNdInterfaceName = caseList[0].CH_RDInterface__c;
		wrappervalue.caseRecordTypeName = caseList[0].RecordType.DeveloperName;
		wrappervalue.capsInstance = CH_Settings__c.getValues('CAPSInstance') != null ? CH_Settings__c.getValues('CAPSInstance').SettingValue__c :'';
		wrappervalue.baseUrl = CH_Settings__c.getValues('BaseUrl') != null ? CH_Settings__c.getValues('BaseUrl').SettingValue__c :'';
		return wrappervalue;
	}
	
	/*****************************************************
	* Method Name : shareAttachmentsWithRnd
	* Descsription: send CAPS Attachments to NAIP
	* Parameters:
	* interfaceName: alue will be JIRA or PRONOTO
	* combinedDescription: it's combined of attachment download links+notes-send to Description in interface
	* attachmentIdList: it's CH_attachment's  SF Id List query
	*******************************************/ 
	@AuraEnabled
	public static String shareAttachmentsWithRnd(Id caseid, String interfaceName, String subject, String combinedDescription, String comments, List<Id> attachmentIdList) {
		Case c = [SELECT Id, CaseNumber, CH_ReportedDate__c, Severity__c, Priority, CH_CRNumber__c, CH_Originating_Incident_Number__c, CH_Originating_Incident_Number__r.CaseNumber  FROM Case WHERE  Id =: caseid];
		CH_Problem_RnD_Reference__c rndInteraction = new CH_Problem_RnD_Reference__c(CH_RnD_Subject__c = subject,
	CH_RnD_Description__c = combinedDescription,
	CH_RnD_Comment__c = comments,
	CH_RnD_Interface__c = interfaceName,
	CH_Related_Record__c = caseid,
	CH_RnD_Reference__c = c.CH_CRNumber__c,
	CH_RnD_Direction__c = 'outbound',
	CH_RnD_Type__c = 'Update to R&D');

		rndInteraction = CH_ExternalInterfaceUTIL.sendCaseAttachments(rndInteraction, c, new Set<Id>(attachmentIdList));
		return rndInteraction.Id;
	}
/*****************************************************
  * Method Name : getRDInteractions
  * Created Date: 31 March 2020
  * Created By : TCS
  * Descsription: Check ifshare R&D button disable or not defect 27302
  * Parameter: caseId
  * Return:  true or flase
  * Last Modified by: 
  * Last Modified Date: 
  * Description: 
  *******************************************/  
   @AuraEnabled
   public static boolean getRDInteractions(String caseId){
	
	  List<CH_Problem_RnD_Reference__c> rndInteractionSize=[select id from CH_Problem_RnD_Reference__c where CH_Related_Record__c =:caseId];
	  
	  if(rndInteractionSize.size()>0){
	return false;
	  }else{
	return true;
	  }
	
   }
   
	public class CAPS_AttachmentWrapper{
		@AuraEnabled public  Boolean suspectedDataBreach{get;set;}
		@AuraEnabled public  String rNdInterfaceName{get;set;}
		@AuraEnabled public  String caseRecordTypeName{get;set;}
		@AuraEnabled public  String capsInstance{get;set;}
		@AuraEnabled public  String baseUrl{get;set;}
	}
}