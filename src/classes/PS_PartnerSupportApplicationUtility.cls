public without sharing class PS_PartnerSupportApplicationUtility {
	
	@InvocableMethod(label='Partner Support Ticket Share' description='Method to handle sharing of Partner Support Tickets')
		public static void partnerSupportTicketShare(List<CaseFlowParams> caseFlowParamsLst){
			List<Case> caseNewList = new List<Case>();
			List<Case> caseOldList = new List<Case>();
			for(CaseFlowParams casePar : caseFlowParamsLst){
				caseNewList.add(casePar.caseNew);
				if(casePar.caseOld != NULL)
					caseOldList.add(casePar.caseOld);
			}
			String caseOldListStr = caseOldList.size() > 0?JSON.serialize(caseOldList):NULL;
			createCaseShareRecords(JSON.serialize(caseNewList), caseOldListStr);
			
	}
	
	@future
	public static void createCaseShareRecords(String CaseNewLstJSON, String caseOldLstJSON){
			List<CaseShare> caseShareLst = new List<CaseShare>();
		List<Group> psPartnerSuppGrp = [SELECT Id FROM Group WHERE DeveloperName = 'PS_Partner_Support' AND Type = 'Regular'];
			List<Case> caseNewList = (List<Case>)JSON.deserialize(caseNewLstJson, List<Case>.class);
			Map<Id, Id> nonPartnerUsers = new Map<Id, Id>();
		if(caseOldLstJSON == NULL){
			for(Case partnerCase : caseNewList){
	if(psPartnerSuppGrp != NULL && !psPartnerSuppGrp.isEmpty()){
		Caseshare grpShare = new Caseshare();
		grpShare.CaseId = partnerCase.Id;
		grpShare.UserorGroupId = psPartnerSuppGrp[0].Id;
		grpShare.CaseAccessLevel = 'Edit';
		caseShareLst.add(grpShare);
	}
	if(String.isNotBlank(partnerCase.Issue_Reported_By__c) && System.Label.PS_StopIssueReportedBySharing != 'true'){
		Caseshare caseShareVar = new Caseshare();
		caseShareVar.CaseId = partnerCase.Id;
		caseShareVar.UserorGroupId = partnerCase.Issue_Reported_By__c;
		caseShareVar.CaseAccessLevel = 'Edit';
		caseShareLst.add(caseShareVar);
	}
	if(partnerCase.CreatedById != partnerCase.Issue_Reported_By__c &&  System.Label.PS_StopCreatedBySharing != 'true'){
		nonPartnerUsers.put(partnerCase.Id, partnerCase.CreatedById);
	}
			}
			
		}
		if(caseOldLstJSON != NULL && System.Label.PS_StopIssueReportedBySharing != 'true'){
			List<Case> caseOldLst = (List<Case>)JSON.deserialize(caseOldLstJSON, List<Case>.class);
			Map<Id, Case> caseOldMap = new Map<Id, Case>();
			Map<Id, Id> deleteCaseShare = new Map<Id, Id>();
			for(Case oldC : caseOldLst){
				if(String.isNotBlank(oldC.Issue_Reported_By__c)){
					deleteCaseShare.put(oldC.Issue_Reported_By__c, oldC.Id);
				}
				caseOldMap.put(oldC.Id, oldC);
			}
			if(deleteCaseShare.size() > 0){
				List<CaseShare> shareRecs = [SELECT Id,UserOrGroupId,CaseId FROM CaseShare WHERE CaseId IN: caseOldMap.keySet()];
				List<CaseShare> deleteShares = new List<CaseShare>();
				for(CaseShare cShare : shareRecs){
					if(deleteCaseShare.containsKey(cShare.UserOrGroupId) && deleteCaseShare.get(cShare.UserOrGroupId) == cShare.caseId)
						deleteShares.add(cShare);
				}
				if(deleteShares.size() > 0){
					Delete deleteShares;
				}
			}
			
			for(Case partnerCase : caseNewList){
				if(String.isNotBlank(partnerCase.Issue_Reported_By__c)){
					nonPartnerUsers.put(partnerCase.Id, partnerCase.Issue_Reported_By__c);
				}
			}
		}
			
			if(!nonPartnerUsers.isEmpty()){
	Map<Id, Group> partnerGroups = new Map<Id, Group>([SELECT Id, Name FROM Group WHERE DeveloperName IN ('PS_Partner_Enablement', 'PS_Partner_Query_Management')]);
	if( partnerGroups!=null && !partnerGroups.isEmpty() ){
		List<GroupMember> partnerSupportGrpMem = [SELECT UserOrGroupId, GroupId From GroupMember where UserOrGroupId IN: nonPartnerUsers.values() and groupId IN: partnerGroups.keySet()];
		Set<Id> groupMemberSet = new Set<Id>();
		
		for(GroupMember grpMem : partnerSupportGrpMem)
			groupMemberSet.add(grpMem.UserOrGroupId);
		
		for(Id caseId : nonPartnerUsers.keySet()){
			if(groupMemberSet.size() == 0 || !groupMemberSet.contains(nonPartnerUsers.get(caseId))){
				Caseshare caseShareVar = new Caseshare();
				caseShareVar.CaseId = caseId;
				caseShareVar.UserorGroupId = nonPartnerUsers.get(caseId);
				caseShareVar.CaseAccessLevel = 'Edit';
				caseShareLst.add(caseShareVar);
			}
		}
		
	}
	
			}
		
		
		if(!caseShareLst.isEmpty()){
			Database.insert(caseShareLst, false);
		}
	}
	
	public class CaseFlowParams{
		@InvocableVariable
		Public Case caseNew;
		@InvocableVariable
		Public Case caseOld;
	}
}