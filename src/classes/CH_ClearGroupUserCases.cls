/** 
* About 
* ----- 
* @Description	  : Clears User from Case Owner and Case Team Class.
* @TestClass	  : CH_ClearGroupUserCases_Test.
* @Project	: Case Handling.
* @Modification Log : 
*  Created  : 2020 10 27 – tiago.almeida@nokia.com
* ----- 
**/
public without sharing class CH_ClearGroupUserCases {
	
	public static void execute(Set<Id> oUserIdSet, Set<Id> oGroupIdSet){
		execute(oUserIdSet, oGroupIdSet, new Set<Id>());
	}
	
	public static void execute(Set<Id> oUserIdSet, Set<Id> oGroupIdSet, Set<Id> oCaseIdSet){
		//Get Group Names
		Map<Id, String> oGroupNameMap = new Map<Id, String>();
		for(Group oGroup : [SELECT Id, Name FROM Group WHERE Id IN :oGroupIdSet]) {
			oGroupNameMap.put(oGroup.Id, oGroup.Name);
		}
		Set<String> GroupNames = new Set<String>(oGroupNameMap.values());
		//Groups where user still belongs
		Set<String> sUserGroupName = new Set<String>();
		for(GroupMember oGroupMember : [SELECT Group.Name, UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN :oUserIdSet AND Group.Type = 'Regular']) {
			sUserGroupName.add(oGroupMember.UserOrGroupId+ '|' + oGroupMember.Group.Name);
		}
		//Get Cases where user is owner and contains group names
		List<Case> oCaseList = (oCaseIdSet.isEmpty() ? [
			SELECT Id, OwnerId, Status, CH_SecurityGroup__c, CH_GWC_SecurityGroup__c, CH_3rdPartySecurityGroup__c, RecordTypeId,
	HWS_RecordTypeCheck__c, CH_Record_Type_Check_Condition__c, CH_RecordTypeCheck__c, CH_Workgroup__c, CH_CurrentQueue__c
			FROM Case
			WHERE OwnerId IN :oUserIdSet AND Status != 'Completed' AND ((HWS_RecordTypeCheck__c = true AND Status != 'Closed') OR CH_Record_Type_Check_Condition__c = true) AND
	  ((CH_SecurityGroup__c IN :GroupNames AND Status != 'Cancelled') OR CH_GWC_SecurityGroup__c IN :GroupNames OR CH_3rdPartySecurityGroup__c IN :GroupNames)
		] : [
			SELECT Id, OwnerId, Status, CH_SecurityGroup__c, CH_GWC_SecurityGroup__c, CH_3rdPartySecurityGroup__c, RecordTypeId,
	HWS_RecordTypeCheck__c, CH_Record_Type_Check_Condition__c, CH_RecordTypeCheck__c, CH_Workgroup__c, CH_CurrentQueue__c
			FROM Case
			WHERE OwnerId IN :oUserIdSet AND Status != 'Completed' AND ((HWS_RecordTypeCheck__c = true AND Status != 'Closed') OR CH_Record_Type_Check_Condition__c = true) AND
	  ((CH_SecurityGroup__c IN :GroupNames AND Status != 'Cancelled') OR CH_GWC_SecurityGroup__c IN :GroupNames OR CH_3rdPartySecurityGroup__c IN :GroupNames) AND
				  Id IN :oCaseIdSet
		]);
		//Get Cases from CaseTeamMembers where user is present and contains group names
		List<CaseTeamMember> oCaseTeamMemberList = (oCaseIdSet.isEmpty() ? [
			SELECT Id, MemberId, Parent.Status, Parent.CH_SecurityGroup__c, Parent.CH_GWC_SecurityGroup__c, Parent.CH_3rdPartySecurityGroup__c,
	Parent.HWS_RecordTypeCheck__c, Parent.CH_Record_Type_Check_Condition__c
			FROM CaseTeamMember
			WHERE MemberId IN :oUserIdSet AND Parent.Status != 'Completed' AND ((Parent.HWS_RecordTypeCheck__c = true AND Parent.Status != 'Closed') OR Parent.CH_Record_Type_Check_Condition__c = true) AND
	  ((Parent.CH_SecurityGroup__c IN :GroupNames AND Parent.Status != 'Cancelled') OR Parent.CH_GWC_SecurityGroup__c IN :GroupNames OR Parent.CH_3rdPartySecurityGroup__c IN :GroupNames)
		] : [
			SELECT Id, MemberId, Parent.Status, Parent.CH_SecurityGroup__c, Parent.CH_GWC_SecurityGroup__c, Parent.CH_3rdPartySecurityGroup__c,
	Parent.HWS_RecordTypeCheck__c, Parent.CH_Record_Type_Check_Condition__c
			FROM CaseTeamMember
			WHERE MemberId IN :oUserIdSet AND Parent.Status != 'Completed' AND ((Parent.HWS_RecordTypeCheck__c = true AND Parent.Status != 'Closed') OR Parent.CH_Record_Type_Check_Condition__c = true) AND
	  ((Parent.CH_SecurityGroup__c IN :GroupNames AND Parent.Status != 'Cancelled') OR Parent.CH_GWC_SecurityGroup__c IN :GroupNames OR Parent.CH_3rdPartySecurityGroup__c IN :GroupNames) AND
				  ParentId IN :oCaseIdSet
		]);
		//Change Owner from Cases from the list where user is not part of another group set on the case
		User userQueue = [SELECT Id FROM User WHERE Name = 'CH Queue' LIMIT 1];
		Map<Id, Case> oCaseOldMap = new Map<Id, Case>();
		List<Case> oCaseToUpdateList = new List<Case>();
		for(Case oCase : oCaseList) {
			if(
	!sUserGroupName.contains(oCase.OwnerId + '|' + oCase.CH_SecurityGroup__c) &&
	!sUserGroupName.contains(oCase.OwnerId + '|' + oCase.CH_GWC_SecurityGroup__c) &&
	!sUserGroupName.contains(oCase.OwnerId + '|' + oCase.CH_3rdPartySecurityGroup__c)
			) {
	oCaseOldMap.put(oCase.Id, oCase.clone(true));
	oCase.OwnerId = userQueue.Id;
	oCaseToUpdateList.add(oCase);
			}
		}
		//Remove CaseTeamMembers from the list where user is part of another group set on the case
		Set<Id> oCaseTeamMemberToDeleteSet = new Set<Id>();
		for(CaseTeamMember oCaseTeamMember : oCaseTeamMemberList) {
			if(
	!sUserGroupName.contains(oCaseTeamMember.MemberId + '|' + oCaseTeamMember.Parent.CH_SecurityGroup__c) &&
	!sUserGroupName.contains(oCaseTeamMember.MemberId + '|' + oCaseTeamMember.Parent.CH_GWC_SecurityGroup__c) &&
	!sUserGroupName.contains(oCaseTeamMember.MemberId + '|' + oCaseTeamMember.Parent.CH_3rdPartySecurityGroup__c)
			) {
	oCaseTeamMemberToDeleteSet.add(oCaseTeamMember.Id);
			}
		}
		//Update Cases and delete CaseTeamMembers
		if(!oCaseToUpdateList.isEmpty()) {
			TriggerHandler.bypass('Case');
			CH_CaseTriggerHelper.updateCurrentQueue(oCaseOldMap,oCaseToUpdateList);
			CH_ClearGroupUserCases_Batch obj = new CH_ClearGroupUserCases_Batch(oCaseToUpdateList);
			DataBase.executeBatch(obj, 50);
			TriggerHandler.clearAllBypasses();
		}
		if(!oCaseTeamMemberToDeleteSet.isEmpty()) {
			deleteCaseTeamMembers(oCaseTeamMemberToDeleteSet);
		}
	}
	
	@future
	private static void deleteCaseTeamMembers(Set<Id> oCaseTeamMemberToDeleteSet) {
		List<CaseTeamMember> oCaseTeamMemberToDeleteList = [SELECT Id, MemberId, ParentId FROM CaseTeamMember WHERE Id IN :oCaseTeamMemberToDeleteSet];
		Set<String> sMemberIdSet = new Set<String>();
		Set<String> sParentIdSet = new Set<String>();
		Set<String> sMemberToParentIdSet = new Set<String>();
		for(CaseTeamMember oCaseTeamMember : oCaseTeamMemberToDeleteList) {
			sMemberIdSet.add(oCaseTeamMember.MemberId);
			sParentIdSet.add(oCaseTeamMember.ParentId);
			sMemberToParentIdSet.add(oCaseTeamMember.MemberId + ':' + oCaseTeamMember.ParentId);
		}
		List<CH_CaseTeamHistory__c> oCaseTeamHistoryList = [SELECT Id, CH_CaseTeamExit__c, OwnerId, Support_Ticket__c FROM CH_CaseTeamHistory__c WHERE OwnerId IN :sMemberIdSet AND Support_Ticket__c IN :sParentIdSet];
		if(!oCaseTeamMemberToDeleteList.isEmpty()) { database.delete(oCaseTeamMemberToDeleteList, false); }
		if(!oCaseTeamHistoryList.isEmpty()) {
			List<CH_CaseTeamHistory__c> oCaseTeamHistoryListToUpdate = new List<CH_CaseTeamHistory__c>();
			for(CH_CaseTeamHistory__c oCaseTeamHistory : oCaseTeamHistoryList) {
	if(sMemberToParentIdSet.contains(oCaseTeamHistory.OwnerId + ':' + oCaseTeamHistory.Support_Ticket__c)) {
		oCaseTeamHistory.CH_CaseTeamExit__c = System.now();
		oCaseTeamHistoryListToUpdate.add(oCaseTeamHistory);
	}
			}
			if(!oCaseTeamHistoryListToUpdate.isEmpty()) { database.update(oCaseTeamHistoryListToUpdate, false); }
		}
	}
}