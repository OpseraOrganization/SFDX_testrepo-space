/**
About
-----
Description: This Class is used as Helper for CH_KnowledgeTrigger.

Created for: Nokia Portugal COE
Created: 17 04 2019

Update History
--------------
Created: 17 04 2019 – flavio.toscano@nokia.com
-------------
**/
public with sharing class CH_KnowledgeHandler_TL {
	
	/*
* @description : Validate If User can Edit Article (only if belong to the selected Workgroup)
* @param : List<Knowledge__kav>
* @return : void
*/
	public static void validateIfUserCanEditArticle(List<Knowledge__kav> oCH_Knowledge) {
		final Id KnowledgeHowToRT = Utils.MapRecordType('Knowledge__kav').get('CH_HowTo');
		final Id KnowledgeStandardRT = Utils.MapRecordType('Knowledge__kav').get('CH_Standard');
		final Id KnowledgeResolutionRT = Utils.MapRecordType('Knowledge__kav').get('CH_Resolution');
		final Id KnowledgeTechnicalProcedureRT = Utils.MapRecordType('Knowledge__kav').get('CH_TechnicalProcedure');
		final Id KnowledgeAlarmRT = Utils.MapRecordType('Knowledge__kav').get('CH_Alarm');
		final Id KnowledgeKnowErrorRT = Utils.MapRecordType('Knowledge__kav').get('CH_KnownError');
		final Id workgroupMemberRT = Utils.MapRecordType('CH_Workgroup_Member__c').get('CH_KB_Workgroup_Members');
		
		Boolean canEdit = true;
		Id strCurrentUserId = UserInfo.getUserId();
		
		List<CH_Workgroup_Member__c> workgroupMemberList = new List<CH_Workgroup_Member__c>();
		Map <Id,Id> workgroupIdUserId = new Map<Id,Id>();
		List<Id> workgroupIdUserIdKeys = new List<Id>();
		List<Id> workgroupIdUserIdValues = new List<Id>();
		
		AggregateResult results = [SELECT count(Id) userHasPermission FROM PermissionSetAssignment WHERE AssigneeId = :strCurrentUserId AND (PermissionSet.Name = 'CH_Author' OR PermissionSet.Name = 'CH_Approver' OR PermissionSet.Name = 'CH_Publisher')];
		Integer userHasPermission = (Integer)results.get('userHasPermission');
		system.debug(results);
		
		workgroupMemberList = CH_EM_WorkgroupMember.validateIfUserIsAWorkgroupMember(Userinfo.getUserId(), workgroupMemberRT);
		if(!workgroupMemberList.isEmpty()){
			canEdit = true;
			for(CH_Workgroup_Member__c workgroupMember :workgroupMemberList){
				workgroupIdUserId.put(workgroupMember.CH_Workgroup__c, workgroupMember.CH_User__c);
			}
			workgroupIdUserIdKeys = new List<Id>(workgroupIdUserId.keySet());
			workgroupIdUserIdValues = workgroupIdUserId.values();
		} else {
			canEdit = true;
		}
		for(Knowledge__kav oKnowledge: oCH_Knowledge) {
			if(oKnowledge.CH_Workgroup__c != null && userHasPermission > 0 && !workgroupIdUserIdKeys.contains(oKnowledge.CH_Workgroup__c) && oKnowledge.CH_InApproval__c == false && (oKnowledge.RecordTypeId == KnowledgeHowToRT || oKnowledge.RecordTypeId == KnowledgeStandardRT || oKnowledge.RecordTypeId == KnowledgeResolutionRT || oKnowledge.RecordTypeId == KnowledgeTechnicalProcedureRT || oKnowledge.RecordTypeId == KnowledgeAlarmRT || oKnowledge.RecordTypeId == KnowledgeKnowErrorRT)){
				//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
				oKnowledge.addError(System.Label.CH_Non_Workgroup_Member_Cannot_Update_Article);
			} else {
				canEdit = true;
			}
		}
	}
	/*
* @description : Update Knowledge Article Persistant Link
* @param : List<Knowledge__kav>
* @return : void
* US: NOKIASC-35225

Commented below code Nokiasc-35225 US no longer required
public static void updateKnowledgeArticleId (List<Knowledge__kav> oCH_Knowledge){
for(Knowledge__kav oKnowledge: oCH_Knowledge){
oKnowledge.CH_ArticleID__c = oKnowledge.KnowledgeArticleId;
}
}*/
	
	/*
* @description : Update Knowledge Article KB Product Fields
* @param : List<Knowledge__kav>
* @return : void
*/
	public static void updateKBProducts(List<Knowledge__kav> oCH_Knowledge) {
		Set<Id> knowledgeArticleId = new Set<Id> ();
		
		for(Knowledge__kav oKnowledge: oCH_Knowledge) {
			if(oKnowledge.CH_InApproval__c == false && oKnowledge.PublishStatus == 'Draft' && oKnowledge.ValidationStatus != 'Needs Approver Review' && oKnowledge.CH_Workgroup__c != null){		
				knowledgeArticleId.add(oKnowledge.KnowledgeArticleId);
			}
		}
		if(!knowledgeArticleId.isEmpty()){
			List<CH_ProductRelation__c> oProductRelationList = [SELECT Id, CH_Knowledge__r.Id, CH_Knowledge__r.KnowledgeArticleId, CreatedDate, CH_Parent_Product__r.Name, CH_Parent_Product__c FROM CH_ProductRelation__c WHERE CH_Knowledge__r.KnowledgeArticleId IN :knowledgeArticleId AND CH_Parent_Release__c = NULL ORDER BY CreatedDate DESC];
			Map<Id,String> knowledgeProductMap = new Map<Id,String>();
			
			for(Id kbIds: knowledgeArticleId){
				String result = '';
				for(CH_ProductRelation__c oProductRelation : oProductRelationList){
					if(oProductRelation.CH_Parent_Product__c != NULL && oProductRelation.CH_Knowledge__r.KnowledgeArticleId == kbIds && (result + oProductRelation.CH_Parent_Product__r.Name+'; ').length() < 1500){
						result += oProductRelation.CH_Parent_Product__r.Name+'; ';
					}
				}
				knowledgeProductMap.put(kbIds, result);
			}
			for(Knowledge__kav oKnowledge: oCH_Knowledge) {
				if(oKnowledge.CH_InApproval__c == false && oKnowledge.PublishStatus == 'Draft' && oKnowledge.ValidationStatus != 'Needs Approver Review' && knowledgeProductMap.keySet().contains(oKnowledge.Id)){
					oKnowledge.CH_KB_Products__c = knowledgeProductMap.get(oKnowledge.Id);
				}
			}
		}
	}
	
	/*
* @description : Validate If User can Delete Article (only if belong to the selected Workgroup)
* @param : List<Knowledge__kav>
* @return : void
*/
	public static void validateIfUserCanDeleteArticle(List<Knowledge__kav> oCH_Knowledge) {
		final Id KnowledgeHowToRT = Utils.MapRecordType('Knowledge__kav').get('CH_HowTo');
		final Id KnowledgeStandardRT = Utils.MapRecordType('Knowledge__kav').get('CH_Standard');
		final Id KnowledgeResolutionRT = Utils.MapRecordType('Knowledge__kav').get('CH_Resolution');
		final Id KnowledgeTechnicalProcedureRT = Utils.MapRecordType('Knowledge__kav').get('CH_TechnicalProcedure');
		final Id KnowledgeAlarmRT = Utils.MapRecordType('Knowledge__kav').get('CH_Alarm');
		final Id KnowledgeKnowErrorRT = Utils.MapRecordType('Knowledge__kav').get('CH_KnownError');
		final Id kbWorkgroupMemberRT = Utils.MapRecordType('CH_Workgroup_Member__c').get('CH_KB_Workgroup_Members');
		
		Boolean allow = false;
		Id strCurrentUserId = UserInfo.getUserId();
		Set<Id> workgroupIds = new Set<Id>();
		Set<String> workgroupIdWorkgroupMemberId = new Set<String>();
		
		for(Knowledge__kav oKnowledge: oCH_Knowledge) {
			if(oKnowledge.CH_Workgroup__c != null && (oKnowledge.RecordTypeId == KnowledgeHowToRT || oKnowledge.RecordTypeId == KnowledgeStandardRT || oKnowledge.RecordTypeId == KnowledgeResolutionRT || oKnowledge.RecordTypeId == KnowledgeTechnicalProcedureRT || oKnowledge.RecordTypeId == KnowledgeAlarmRT || oKnowledge.RecordTypeId == KnowledgeKnowErrorRT)){
				workgroupIds.add(oKnowledge.CH_Workgroup__c);
			}
		}
		if(!workgroupIds.isEmpty()){
			AggregateResult results = [SELECT count(Id) userHasPermission FROM PermissionSetAssignment WHERE AssigneeId = :strCurrentUserId AND (PermissionSet.Name = 'CH_Author' OR PermissionSet.Name = 'CH_Approver' OR PermissionSet.Name = 'CH_Publisher')];   
			Integer userHasPermission = (Integer)results.get('userHasPermission');
			
			for(CH_Workgroup_Member__c wgm : [SELECT Id, CH_Workgroup__c, CH_User__c FROM CH_Workgroup_Member__c WHERE RecordTypeId = :kbWorkgroupMemberRT AND CH_Workgroup__c IN :workgroupIds]){
				workgroupIdWorkgroupMemberId.add(wgm.CH_Workgroup__c + '|' + wgm.CH_User__c);
			}
			if(!workgroupIdWorkgroupMemberId.isEmpty()){
				for(Knowledge__kav oKnowledge: oCH_Knowledge) {
					if(userHasPermission > 0 && oKnowledge.CH_InApproval__c == false && oKnowledge.PublishStatus == 'Draft' && oKnowledge.ValidationStatus != 'Needs Approver Review'){
						for(String wkIdwkmId : workgroupIdWorkgroupMemberId){
							system.debug(oKnowledge.CH_Workgroup__c);
							system.debug(strCurrentUserId);
							system.debug(wkIdwkmId.substringBefore('|'));
							system.debug(wkIdwkmId.substringAfter('|'));
							if(oKnowledge.CH_Workgroup__c == wkIdwkmId.substringBefore('|') && strCurrentUserId == wkIdwkmId.substringAfter('|')){
								allow = true;
							}			 
						}
					}
					if(!allow){
						//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
						oKnowledge.addError(System.Label.CH_Non_Issuer_Cannot_Delete_Article);			
					}
				}	 
			}	 
		}  
	}
	
	/*
* @description : Assign Owner to Article, if record is on Approval Status and Update Approver
* @param : List<Knowledge__kav>
* @return : void
*/
	public static void assignOwnerIfInApprovalStatus(List<Knowledge__kav> oOldCH_Knowledge, List<Knowledge__kav> oNewCH_Knowledge) {
		final Id KnowledgeHowToRT = Utils.MapRecordType('Knowledge__kav').get('CH_HowTo');
		final Id KnowledgeStandardRT = Utils.MapRecordType('Knowledge__kav').get('CH_Standard');
		final Id KnowledgeResolutionRT = Utils.MapRecordType('Knowledge__kav').get('CH_Resolution');
		final Id KnowledgeTechnicalProcedureRT = Utils.MapRecordType('Knowledge__kav').get('CH_TechnicalProcedure');
		final Id KnowledgeAlarmRT = Utils.MapRecordType('Knowledge__kav').get('CH_Alarm');
		final Id KnowledgeKnownErrorRT = Utils.MapRecordType('Knowledge__kav').get('CH_KnownError');
		
		Map <Id,String> queueIdQueueAPIName = new Map<Id,String>();
		List<Group> queueList = new List<Group>();
		List<Id> queueIdQueueAPINameKeys = new List<Id>();
		List<String> queueIdQueueAPINameValues = new List<String>();
		Map<Id,Id> knowledgeIdToQueueId = new Map<Id,Id>();
		
		queueList = EM_Group.getAllKBQueues();
		
		if(!queueList.isEmpty()){
			for(Group queue :queueList){
				queueIdQueueAPIName.put(queue.Id, queue.Name);
			}
			queueIdQueueAPINameKeys = new List<Id>(queueIdQueueAPIName.keySet());
			queueIdQueueAPINameValues = queueIdQueueAPIName.values();
		}	
		for(Knowledge__kav oOldKnowledge: oOldCH_Knowledge) {
			for(Knowledge__kav oNewKnowledge: oNewCH_Knowledge) {
				if(oOldKnowledge.Id == oNewKnowledge.Id && oNewKnowledge.CH_Workgroup__c != null && oOldKnowledge.CH_InApproval__c == false && oNewKnowledge.CH_InApproval__c == true && (oNewKnowledge.RecordTypeId == KnowledgeHowToRT || oNewKnowledge.RecordTypeId == KnowledgeStandardRT || oNewKnowledge.RecordTypeId == KnowledgeResolutionRT || oNewKnowledge.RecordTypeId == KnowledgeTechnicalProcedureRT || oNewKnowledge.RecordTypeId == KnowledgeAlarmRT || oNewKnowledge.RecordTypeId == KnowledgeKnownErrorRT)) {
					//Approval Step 1 || Approver
					if(oNewKnowledge.CH_Minor_changes__c == true && oNewKnowledge.CH_ComingFromApprovalProcess__c == false && oNewKnowledge.CH_Candidate_for_External__c == false){
						knowledgeIdToQueueId.put(oNewKnowledge.Id, queueIdQueueAPINameKeys.get(queueIdQueueAPINameValues.indexOf((oNewKnowledge.CH_WorkgroupName__c + '_AQ'))));
						//Approval Step 2 || Approver  
					} else if(oNewKnowledge.CH_Minor_changes__c == false && oNewKnowledge.CH_ComingFromApprovalProcess__c == false && oNewKnowledge.CH_Candidate_for_External__c == false){
						knowledgeIdToQueueId.put(oNewKnowledge.Id, queueIdQueueAPINameKeys.get(queueIdQueueAPINameValues.indexOf((oNewKnowledge.CH_WorkgroupName__c + '_AQ'))));
						//Approval Step 3 || Approver
					} else if(oNewKnowledge.CH_Minor_changes__c == true && oNewKnowledge.CH_ComingFromApprovalProcess__c == false && oNewKnowledge.CH_Candidate_for_External__c == true){
						knowledgeIdToQueueId.put(oNewKnowledge.Id, queueIdQueueAPINameKeys.get(queueIdQueueAPINameValues.indexOf((oNewKnowledge.CH_WorkgroupName__c + '_AQ'))));
						//Approval Step 4 || Approver
					} else if(oNewKnowledge.CH_Minor_changes__c == false && oNewKnowledge.CH_ComingFromApprovalProcess__c == false && oNewKnowledge.CH_Candidate_for_External__c == true){
						knowledgeIdToQueueId.put(oNewKnowledge.Id, queueIdQueueAPINameKeys.get(queueIdQueueAPINameValues.indexOf((oNewKnowledge.CH_WorkgroupName__c + '_AQ'))));
					}			
				} else if(oOldKnowledge.Id == oNewKnowledge.Id && oNewKnowledge.CH_Workgroup__c != null && (oNewKnowledge.ValidationStatus == 'Needs Publisher Review' || (oNewKnowledge.ValidationStatus == 'Internal Approved' && oNewKnowledge.CH_ComingFromApprovalProcess__c == true)) && oNewKnowledge.CH_InApproval__c == true && (oNewKnowledge.RecordTypeId == KnowledgeHowToRT || oNewKnowledge.RecordTypeId == KnowledgeStandardRT || oNewKnowledge.RecordTypeId == KnowledgeResolutionRT || oNewKnowledge.RecordTypeId == KnowledgeTechnicalProcedureRT || oNewKnowledge.RecordTypeId == KnowledgeAlarmRT || oNewKnowledge.RecordTypeId == KnowledgeKnownErrorRT)) {
					
					//Approval Step 5 || Publisher
					if(oNewKnowledge.CH_Minor_changes__c == true && oNewKnowledge.CH_ComingFromApprovalProcess__c == true && oNewKnowledge.CH_Candidate_for_External__c == true){
						knowledgeIdToQueueId.put(oNewKnowledge.Id, queueIdQueueAPINameKeys.get(queueIdQueueAPINameValues.indexOf((oNewKnowledge.CH_WorkgroupName__c + '_PQ'))));
						//Approval Step 6 || Publisher
					} else if(oNewKnowledge.CH_Minor_changes__c == false && oNewKnowledge.CH_ComingFromApprovalProcess__c == true && oNewKnowledge.CH_Candidate_for_External__c == true){
						knowledgeIdToQueueId.put(oNewKnowledge.Id, queueIdQueueAPINameKeys.get(queueIdQueueAPINameValues.indexOf((oNewKnowledge.CH_WorkgroupName__c + '_PQ'))));
					}
				}
			}
		}
		
		if(!knowledgeIdToQueueId.isEmpty()){ 
			updateProcessInstanceWorkitem(knowledgeIdToQueueId);
		}
	}
	
	/*
* @description : Future Method to Update Knowledge Approver
* @param : Map<Id,Id>
* @return : void
*/
	@future
	private static void updateProcessInstanceWorkitem(Map<Id,Id> knowledgeIdToQueueId) {
		List<ProcessInstanceWorkitem> processInstanceWorkitemListToUpdate = new List<ProcessInstanceWorkitem>();
		system.debug(knowledgeIdToQueueId);
		if(!knowledgeIdToQueueId.isEmpty()){
			processInstanceWorkitemListToUpdate = EM_ProcessInstance.getProcessInstanceWorkitemByTargetObjectId(knowledgeIdToQueueId.keySet());	
			system.debug(processInstanceWorkitemListToUpdate);
			for(ProcessInstanceWorkitem processInstanceWorkItem : processInstanceWorkitemListToUpdate){
				processInstanceWorkItem.OriginalActorId = (knowledgeIdToQueueId.get(processInstanceWorkItem.ProcessInstance.TargetObjectId));
				processInstanceWorkItem.ActorId = (knowledgeIdToQueueId.get(processInstanceWorkItem.ProcessInstance.TargetObjectId));
			}
			if(!processInstanceWorkitemListToUpdate.isEmpty()){
				system.debug(processInstanceWorkitemListToUpdate);
				EM_ProcessInstance.doUpdateProcessInstanceWorkitemList(processInstanceWorkitemListToUpdate);
			}
		}
	}
	
	/********************
*Method Name: setDefaultDataCategories
*Parameter: New Article List (Only Case Handling Record Type Records)
*Description: Used to assign default Data Category Groups and Data Categories
*******************/
	public static void setDefaultDataCategories(List<Knowledge__kav> articleList){
		List<Knowledge__DataCategorySelection> KnowDataSel = new List<Knowledge__DataCategorySelection>();
		for(Knowledge__kav k : articleList){	
			Knowledge__DataCategorySelection dataCategorySelection = new Knowledge__DataCategorySelection();
			dataCategorySelection.DataCategoryGroupName = 'Case_Handling';
			dataCategorySelection.DataCategoryName = 'Case_Handling';
			dataCategorySelection.ParentId = k.Id;
			KnowDataSel.add(dataCategorySelection);
			//insert dataCategorySelection;
			//}
		}
		if(KnowDataSel.size()>0){
			insert KnowDataSel;
		}
	}
	
	/********************
*Method Name: getProductFromLatestVersion
*Parameter: New Article List (Only Case Handling Record Type Records)
*Description: Used to replicate related CH_ProductRelation__c from latest article version to new one
*******************/
	public static void getProductFromLatestVersion(List<Knowledge__kav> articleList){
		Map<Id,Id> knowledgeArticleIds = new Map<Id,Id>();
		for(Knowledge__kav kav : articleList){
			knowledgeArticleIds.put(kav.Id, kav.KnowledgeArticleId);
		}
		if(!knowledgeArticleIds.isEmpty()){
			getProductFromLatestVersion(knowledgeArticleIds);
		}
	}
	
	@future
	private static void getProductFromLatestVersion(Map<Id,Id> knowledgeArticleIds){
		Set<Id> kavhSet = new Set<Id>();
		Map<Id,Knowledge__kav> articlesMap = new Map<Id,Knowledge__kav>();
		for(KnowledgeArticleVersionHistory kavh : [SELECT Id, ParentId, VersionNumber, VersionId, EventType FROM KnowledgeArticleVersionHistory WHERE ParentId IN :knowledgeArticleIds.values() ORDER BY VersionNumber DESC LIMIT 1]){
			kavhSet.add(kavh.VersionId);
		}
		if(!kavhSet.isEmpty()){
			for(Knowledge__kav kav : [SELECT Id, KnowledgeArticleId, (SELECT Id, CH_Knowledge__c, CH_Parent_Release__c, CH_Parent_Product__c, CH_Relation_Type__c FROM CH_Product_Relations__r) FROM Knowledge__kav WHERE Id IN :kavhSet]){
				articlesMap.put(kav.KnowledgeArticleId, kav);
			}
			if(!articlesMap.isEmpty()){
				List<CH_ProductRelation__c> productRelationListToInsert = new List<CH_ProductRelation__c>();
				for(Knowledge__kav kav : [SELECT Id, KnowledgeArticleId, PublishStatus FROM Knowledge__kav WHERE Id IN :knowledgeArticleIds.keySet()]){
					if(articlesMap.keySet().contains(kav.KnowledgeArticleId) && !articlesMap.get(kav.KnowledgeArticleId).CH_Product_Relations__r.isEmpty()){
						for(CH_ProductRelation__c relation : articlesMap.get(kav.KnowledgeArticleId).CH_Product_Relations__r){
							CH_ProductRelation__c newRelation = new CH_ProductRelation__c();
							newRelation.CH_Knowledge__c = kav.id;
							newRelation.CH_Parent_Release__c = relation.CH_Parent_Release__c;
							newRelation.CH_Parent_Product__c = relation.CH_Parent_Product__c;
							newRelation.CH_Relation_Type__c = relation.CH_Relation_Type__c;
							productRelationListToInsert.add(newRelation);
						}
					}
				}
				if(!productRelationListToInsert.isEmpty()){
					insert productRelationListToInsert;
				}
			}	   
		}
	}
}