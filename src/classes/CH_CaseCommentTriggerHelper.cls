/****************************************
* Class Name : CH_CaseCommentTriggerHelper
* Created Date: 12 Dec 2018
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 
* Description : 
* Test Class:
*****************************************/
public with sharing class CH_CaseCommentTriggerHelper {
	
	/***************************************************************** 
	Description:  Logic to fetch the Case Comments fields and to scramble
	Returns: void 
	History	
	DATE	 AUTHOR	 Change 
	12/20/2018   Ganga Prasuna	Created 
	*****************************************************************/ 
	public static void scramblingLogic(List < CaseComment > newcommentList){
		for(CaseComment cref: newcommentList) {		 
			if( cref.CommentBody != '' &&  cref.CommentBody != null) {	
		cref.CommentBody = CH_SecurityUtils.scrambleText(cref.CommentBody);
			}
		}
	}
	
	/********************
	*Method Name: sendNotificationToExternalSystem
	*Description: method to make create-informationupdate callouts to external systems
	*******************/
	public static void sendNotificationToExternalSystem(List<CaseComment> comments, String notificationTitle, String operationType) {
		Map<Id, List<CaseComment>> publicCaseComments = new Map<Id, List<CaseComment>>();
		system.debug('--sendNotificationToExternalSystem---'+comments);
		for (CaseComment comment : comments) {
			system.debug('--sendNotificationToExternalSystem comment---'+comment);
			if (comment.IsPublished) {
	if (!publicCaseComments.containsKey(comment.ParentId)) {
		publicCaseComments.put(comment.ParentId, new List<CaseComment>());
	}
	publicCaseComments.get(comment.ParentId).add(comment);
			}
		}

		if (!publicCaseComments.isEmpty()) {
			List<Case> cases = [SELECT Id, CaseNumber, CH_Stage__c, Origin, CH_CaseOriginSystem__c, Reference_Number__c FROM Case WHERE Id IN :publicCaseComments.keySet()];
			system.debug('----cases -----'+cases);
			List<Case> casesWithOriginSystem = CH_ExternalInterfaceUTIL.filterS2SCasesWOriginSystem(cases);
			system.debug('------casesWithOriginSystem----'+casesWithOriginSystem);
			List<Case> availableForS2SOutboundMessageCases = CH_ExternalInterfaceUTIL.isolateS2SbyStage(casesWithOriginSystem);
			system.debug('----availableForS2SOutboundMessageCases---'+availableForS2SOutboundMessageCases);
			for (Case c : availableForS2SOutboundMessageCases) {
	List<CaseComment> caseComments = publicCaseComments.get(c.Id);
	for (CaseComment comment : caseComments) {
		system.debug('-------calling --sendNotificationToExternalSystem comment.CommentBody.substring(0,4)---'+comment.CommentBody.substring(0,4));
		if(comment.CommentBody.substring(0,4) != 'CAPS' && Userinfo.getName() !='NAIP User'){
			system.debug('-------calling --sendNotificationToExternalSystem comment---'+comment);
			CH_ExternalInterfaceUTIL.sendNotificationToExternalSystem(comment.ParentId, comment.Id, notificationTitle, comment.CommentBody, operationType);
		}
	}
			}
		}
	}
	
	//Changes added for NOKIASC-36637
	Public Static void calculatePlannedAutomaticDateTimer(List < CaseComment > newcommentList){
		String naipUsrId = System.Label.CH_NaipUserId;
		Set<Id> userRec= new Set<Id>();
		Set<Id> userIds=new Set<Id>();
		Set<Id> caseIds=new Set<Id>();
		for(CaseComment cref: newcommentList) {		 
			if(cref.ParentId != null && cref.CreatedById != naipUsrId ) {	
				String getCommentBody=cref.CommentBody;
				if(!(getCommentBody.startsWithIgnoreCase('CAPS') && getCommentBody.startsWithIgnoreCase('OUR ISSUE IS RESOLVED'))){
					userRec.add(cref.CreatedById);
					caseIds.add(cref.ParentId);
				}
			}
		}
		if(!userRec.isEmpty()){
			for(User  getUserRec : [Select ID,IsPortalEnabled from User where ID IN : userRec AND IsPortalEnabled = True]){ userIds.add(getUserRec.Id); }
			if(!userIds.ISEMPTY() && userIds.Size()>0 && !caseIds.ISEMPTY() && caseIds.Size()>0){ CH_EmailAttachmentHelper.caseCommentCalculation(userIds,caseIds); }
		}
	}
}