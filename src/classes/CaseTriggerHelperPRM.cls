/****************************************
* Class Name : CaseTriggerHelperPRM
* Created Date: 17 April 2017
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 19 April 2017
* Description : 
* Test Class: 
 *****************************************/
public  without sharing class CaseTriggerHelperPRM {
  /********************
	*Method Name: autoApproveFirstStep
	*Parameter: new case list, old case map, new case map
	*Description: Used to handle After Update activities
	  1. If nobody picks IR Form then, Auto Approve Step 1(Approval By PSM) of approval process
	*******************/
	public static void autoApproveFirstStep(List< Case > CaseList, Map<ID, Case> caseNewMap, Map<ID, Case> caseOldMap) {
		Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Case.getRecordTypeInfosById();
		Set<Id> caseIds = new Set<Id>();
		for(Case c : caseList) {
			if(rtMap.get(C.RecordTypeId).getDeveloperName().equals(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE) 
	  || (rtMap.get(C.RecordTypeId).getDeveloperName().equals(PRMGlobalConstants.VAR_FORM)
	  && c.Is_Headquater__c)
	  || (rtMap.get(C.RecordTypeId).getDeveloperName().equals(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION)
	  && c.Is_Headquater__c)){
		if(c.Auto_Approved_By_System__c 
		&& caseOldMap.get(c.Id).Auto_Approved_By_System__c != c.Auto_Approved_By_System__c
		&& c.Status == PRMGlobalConstants.CASE_STATUS_NEW) {
		 caseIds.add(c.Id);
		}
			}
		}
		
		//system.debug('caseIdsLL'+caseIds);
		if(caseIds.size() > 0) {
	Set<Id> caseapprovalIds = new Set<Id>();
			try{
	//   for(id c:caseIds){
	List<Approval.ProcessWorkitemRequest> appReqList = new List<Approval.ProcessWorkitemRequest>(); 
	for(ProcessInstanceWorkitem pw : [SELECT Id, ProcessInstanceId, ActorId
	 FROM ProcessInstanceWorkitem
	 WHERE ProcessInstance.TargetObjectId IN :caseIds
	AND ProcessInstance.Status =: PRMGlobalConstants.PI_STATUS_PENDING 
	 LIMIT : PRMGlobalConstants.PROCESS_INSTANCE_FETCH_LIMIT]) {
	//Id targetobjectId = (Id)ProcessInstance.TargetObjectId;
		// if(!(caseapprovalIds.contains(ProcessInstance.TargetObjectId))) {
			// system.debug('pw'+pw.ActorId);
	if(pw.ActorId != System.Label.Compliance_Queue) {
		Approval.ProcessWorkitemRequest appReq = new Approval.ProcessWorkitemRequest();
		//Set Auto Approve Action and Comment
		appReq.setComments(System.Label.Auto_approved_by_system_Message);
		appReq.setAction(PRMGlobalConstants.APPROVAL_ACTION_APPROVE);
		// Use the ID from the newly created item to specify the item to be worked
		appReq.setWorkitemId(pw.Id);
		appReqList.add(appReq);		 
	}		 
	 //}   
	
	}
	
	// Submit the request for approval
	if(appReqList.size() > 0) {
		List<Approval.ProcessResult> result =  Approval.process(appReqList);
		for(Approval.ProcessResult res : result) {
		}
	}
	}catch(Exception e) {
		ExceptionHandler.addException(e,PRMGlobalConstants.CASE_TRIGGER_HELPER ,PRMGlobalConstants.AUTO_APPROVE_FIRST_STEP);
			}
		}
	}
	
   /********************
	*Method Name: caseShareToOpptyMember
	*Parameter: List<Case> caseList
	*Description: share case with opp members
	*******************/
	public static void caseShareToOpptyMember(List<Case> caseList){
		List<CaseShare> caseShareToInsert = new List<CaseShare> ();
	// List<OpportunityTeamMember> opptyTeam = new List<OpportunityTeamMember>();
		Map<id,Set<Id>> opptyMemberMap = new Map<id,Set<Id>>();
		Map<id,id> caseOpptyMap = new Map<id,id> ();
		List<Opportunity> caseOppty = new list<Opportunity>();
		try{
			for(Case caseInstance : caseList){
	caseOpptyMap.put(caseInstance.Opportunity__c,caseInstance.Id);
			}
			caseOppty = [SELECT Id, OwnerId, Lead_Type__c FROM Opportunity 
	WHERE id IN :  caseOpptyMap.keySet() Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];	
	 // opptyTeam  = [SELECT OpportunityId,Opportunity.ownerId,UserId FROM OpportunityTeamMember 
			//	 WHERE OpportunityId IN :  caseOpptyMap.keySet()  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];  
			for(OpportunityTeamMember otm : [SELECT OpportunityId,Opportunity.ownerId,UserId FROM OpportunityTeamMember 
			WHERE OpportunityId IN :  caseOpptyMap.keySet()  
			Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
	Set<id> opptymemberId = new Set<id>();
	if(!opptyMemberMap.containskey(otm.OpportunityId)){
		opptymemberId.add(otm.UserId);
	}else{
		opptymemberId = opptyMemberMap.get(otm.OpportunityId);
		opptymemberId.add(otm.UserId);
	}
	opptyMemberMap.put( otm.OpportunityId , opptymemberId);
			}
			for(Opportunity caseOpportunity : caseOppty){
	if(caseOpportunity.Lead_Type__c == PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION){ 
		CaseShare sharePSM  = new CaseShare();
		sharePSM .UserOrGroupId = caseOpportunity.ownerid;
		sharePSM .CaseId = caseOpptyMap.get(caseOpportunity.id);
		sharePSM .CaseAccessLevel = PRMGlobalConstants.READ;
		sharePSM .RowCause = PRMGlobalConstants.MANUAL;
		caseShareToInsert.add(sharePSM );
	}
	for(id users : opptyMemberMap.get(caseOpportunity.id)){
		CaseShare share = new CaseShare();
		share.UserOrGroupId = users;
		share.CaseId = caseOpptyMap.get(caseOpportunity.id);
		share.CaseAccessLevel = PRMGlobalConstants.READ;
		share.RowCause = PRMGlobalConstants.MANUAL;
		caseShareToInsert.add(share);	
	}
			}
			//insert caseShareToInsert;
			Database.SaveResult[] srList = Database.insert(caseShareToInsert, false);
			// Iterate through each returned result
			for (Database.SaveResult sr : srList) {
	if (sr.isSuccess()) {
		// Operation was successful, so get the ID of the record that was processed
		
	}
	else {
		// Operation failed, so get all errors	
		for(Database.Error err : sr.getErrors()) {
			
		}
	}
			}
		}
		catch(Exception e) { 
			ExceptionHandler.addException(e,PRMGlobalConstants.CASE_TRIGGER_HELPER ,PRMGlobalConstants.CASE_SHARE_TO_OPPTY_MEMBER);
		}
	}
   /********************
	*Method Name: updateParentCaseStatusHold
	*Parameter: new case list, old case map, new case map
	*Description: Used to handle After Update activities
	  1. If nobody picks IR Form then, Auto Approve Step 1(Approval By PSM) of approval process
	*******************/	 
	public static void updateParentCaseStatusHold(List<Case> newCaseList, List<Case> oldCaseList, Map<Id, Case> oldCaseMap) {
		try{
			Integer count = 0;
			Set<Id> parentIdSet = new Set<Id>();
			Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
			for(Case c : newCaseList) {
	if(rt_map.get(c.RecordTypeId).getDeveloperName().containsIgnoreCase(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE)
		&& c.Status != oldCaseMap.get(c.Id).Status &&  c.Status == PRMGlobalConstants.CASE_STATUS_HOLD) {
			count++;
			parentIdSet.add(c.ParentId);
	}
			}
			List<Case> caseToupdate = new List<Case>();
			for(Case c : [SELECT Id FROM Case WHERE Id IN : parentIdSet Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]) {
	if(count != 0 && count == newCaseList.size()){
		//system.debug('Count'+count);
		c.Status = PRMGlobalConstants.CASE_STATUS_HOLD;
		caseToupdate.add(c);
	}
			}
			if(caseToupdate.size() > 0) {
	database.update(caseToupdate);
			}
		}catch(Exception e) { 
			ExceptionHandler.addException(e,PRMGlobalConstants.CASE_TRIGGER_HELPER ,PRMGlobalConstants.UPDATE_PARENT_CASE_STATUS_HOLD);
		}
	}
   /********************
	*Method Name: updateParentCaseStatus
	*Parameter: new case list, old case map, new case map
	*Description: Used to handle After Update activities
	  1. If nobody picks IR Form then, Auto Approve Step 1(Approval By PSM) of approval process
	*******************/	  
	public static void updateParentCaseStatus(List<Case> newCaseList, List<Case> oldCaseList, Map<Id, Case> oldCaseMap) {
		try{
			Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
			Set<Id> parentIdSet = new Set<Id>();
			for(Case c : newCaseList) {
	if(rt_map.get(c.RecordTypeId).getDeveloperName().containsIgnoreCase(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE)
		&& c.Status != oldCaseMap.get(c.Id).Status && oldCaseMap.get(c.Id).Status != PRMGlobalConstants.CASE_STATUS_HOLD && (c.Status == PRMGlobalConstants.CASE_STATUS_APPROVED_PSM
			|| c.Status == PRMGlobalConstants.StatusRejected)   && c.Status != PRMGlobalConstants.Requested_CMD_Account && c.Status != PRMGlobalConstants.Onboarding_In_Progress) {
			parentIdSet.add(c.ParentId);
	}
			}
			
	 // Set<Id> invalidParent = new Set<Id>();
			Map<Id, List<Case>> parentTochildMap = new Map<Id, List<Case>>();
			if(parentIdSet.size() > 0) {
	for(Case c : [SELECT Id, Status, ParentId FROM Case WHERE ParentId IN: parentIdSet Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]) {
		if(!parentTochildMap.containsKey(c.ParentId)) {
			parentTochildMap.put(c.ParentId, new List<Case>());
		}
		parentTochildMap.get(c.ParentId).add(c);
	}
			}
	  
			Map<Id, String> parentCaseStatusMap =  new Map<Id, String>();
			for(id pId : parentTochildMap.keySet()) {
	if(parentTochildMap.get(pId).size() > 0) {
	// Integer value = 4;
		Integer value = 5;
	//find lowest child's case status
		for(Case c : parentTochildMap.get(pId)) {
	if(c.Status.equals(PRMGlobalConstants.CASE_STATUS_NEW)&& value > 1) {
	value = 1;
			} 
			else if(c.status.equals(PRMGlobalConstants.CASE_STATUS_APPROVED_PSM)&& value > 2) {
	value = 2;
			}  else if(c.status.equals(PRMGlobalConstants.CASE_STATUS_APPROVED_COMP) && value > 3) {
	value = 3;
			} else if(c.status.equals(PRMGlobalConstants.StatusRejected) && value >4) {
	value = 4;
		} 
	else{}
		}
		//system.debug('value value '+value);
		if(value == 1) {
	parentCaseStatusMap.put(pId, PRMGlobalConstants.CASE_STATUS_NEW);
		}else if(value == 2) {
	parentCaseStatusMap.put(pId, PRMGlobalConstants.CASE_STATUS_APPROVED_PSM);
			}/*else if(value == 3) {
	parentCaseStatusMap.put(pId, PRMGlobalConstants.CASE_STATUS_APPROVED_COMP);
			}*/else if(value == 4) {
	parentCaseStatusMap.put(pId, PRMGlobalConstants.StatusRejected);
			}else{}
			
		
		}  
			}
			
	 // system.debug('parentCaseStatusMap::'+parentCaseStatusMap);
			List<Case> caseToupdate = new List<Case>();
			for(Case c : [SELECT Id FROM Case WHERE Id IN : parentCaseStatusMap.KeySet() Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]) {
	c.Status = parentCaseStatusMap.get(c.Id);
	caseToupdate.add(c);
			}
			if(caseToupdate.size() > 0) {
	  database.update(caseToupdate) ;
			}
		}catch(Exception e) {  
			ExceptionHandler.addException(e,PRMGlobalConstants.CASE_TRIGGER_HELPER ,PRMGlobalConstants.UPDATE_PARENT_CASE_STATUS);
		}
  }
   /********************
	*Method Name: updateChildCaseStatus
	*Parameter: new case list, old case map, new case map
	*Description: Used to handle After Update activities
	  1. If nobody picks IR Form then, Auto Approve Step 1(Approval By PSM) of approval process
	*******************/   
	public static void updateChildCaseStatus(List<Case> newCaseList, List<Case> oldCaseList, Map<Id, Case> oldCaseMap) {
		try{
			Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
			Map<Id, String> caseToStatus = new Map<Id, String>();
			for(Case c : newCaseList) {
	if(c.Status != oldCaseMap.get(c.Id).Status 
	&& (/*c.Status == PRMGlobalConstants.CASE_STATUS_APPROVED_COMP 
		|| */c.Status == PRMGlobalConstants.StatusRejected) 
	&& !c.Is_Headquater__c 
	&& (rt_map.get(c.RecordTypeId).getDeveloperName().containsIgnoreCase(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION)
		|| rt_map.get(c.RecordTypeId).getDeveloperName().containsIgnoreCase(PRMGlobalConstants.VAR_FORM))) {
			caseToStatus.put(c.Id, c.Status);
	}
			}
	
			//System.debug('caseToStatus::'+caseToStatus);
			Map<Id, List<Case>> parentToChildMap = new Map<Id, List<Case>>();
			if(!caseToStatus.isEmpty()) {
	List<Case> childCaseList = [SELECT ID, ParentId, Status FROM CASE WHERE ParentId IN : caseToStatus.keySet() Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
	if(!childCaseList.isEmpty()) {
		for(Case c : childCaseList) {
			if(caseToStatus.get(c.ParentId) == PRMGlobalConstants.StatusRejected) {
	c.Status = caseToStatus.get(c.ParentId);
			}/*else if(caseToStatus.get(c.ParentId) == PRMGlobalConstants.CASE_STATUS_APPROVED_COMP 
		 && c.Status.contains('Approved')) {
	c.Status = caseToStatus.get(c.ParentId);
			}*/
			else{}
	}
	// system.debug('childCaseList::'+childCaseList);
		database.update(childCaseList);
	}
			}
		}catch(Exception e) {
	 ExceptionHandler.addException(e,PRMGlobalConstants.CASE_TRIGGER_HELPER ,PRMGlobalConstants.UPDATE_CHILD_CASE_STATUS);			
		}
	}
  /********************
	*Method Name: getApproveAndRejectedCoun
	*Parameter: new case list, old case map, new case map
	*Description: Used to handle After Update activities
	  1. If nobody picks IR Form then, Auto Approve Step 1(Approval By PSM) of approval process
	*******************/	 
	public static void getApproveAndRejectedCoun(List<Case> newCaseList, Map<Id, Case> oldCaseMap) {
		try{
			Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
			Set<Id> parentIds = new Set<Id>();
			for(Case c : newCaseList) {
	if((rt_map.get(c.RecordTypeId).getDeveloperName().containsIgnoreCase(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION)
		|| rt_map.get(c.RecordTypeId).getDeveloperName().containsIgnoreCase(PRMGlobalConstants.VAR_FORM))
		&& c.Status != oldCaseMap.get(c.Id).Status && c.Status == PRMGlobalConstants.CASE_STATUS_APPROVED_COMP) {
			if(c.Is_Headquater__c) {
	c.Approved_Countries__c = c.Country__c;
		c.Auto_Approved_By_System__c = false;
			}else {
	c.Auto_Approved_By_System__c = false;
	parentIds.add(c.Id);
			}
			
	}
			}
		
			Map<Id, List<String>> parToApprovedCountries = new Map<Id, List<String>>();
			Map<Id, List<String>> parToRejectedCountries = new Map<Id, List<String>>();
			if(!parentIds.isEmpty()) {
	for(Case c : [SELECT ID, Status, parentId, Country__c FROM Case 
		 WHERE parentId IN: parentIds AND (Status <> : PRMGlobalConstants.CASE_STATUS_NEW OR Status <> : PRMGlobalConstants.On_Hold) 
		 Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]) {
		if(c.Status.contains(PRMGlobalConstants.Approved)) {
			if(!parToApprovedCountries.containsKey(c.ParentId)) {
	parToApprovedCountries.put(c.ParentId, new List<String>());
			}
			parToApprovedCountries.get(c.ParentId).add(c.Country__c);
		}
		if(c.Status.contains(PRMGlobalConstants.StatusRejected)) {
			if(!parToRejectedCountries.containsKey(c.ParentId)) {
	parToRejectedCountries.put(c.ParentId, new List<String>());
			}
			parToRejectedCountries.get(c.ParentId).add(c.Country__c);
		}
		
	}
		for(Case c : newCaseList) {
		if(!parToApprovedCountries.get(c.Id).isEmpty()) {
			c.Approved_Countries__c = string.join(parToApprovedCountries.get(c.Id),PRMGlobalConstants.comma);
		}
		if(!parToApprovedCountries.get(c.Id).isEmpty()) {
			c.Rejected_Countries__c = string.join(parToRejectedCountries.get(c.Id),PRMGlobalConstants.comma);
		}
	}
			}
		}catch(Exception e) { 
			ExceptionHandler.addException(e,PRMGlobalConstants.CASE_TRIGGER_HELPER ,PRMGlobalConstants.GET_APPROVE_REJECTED_COUNTRY);
		}
	  
	}

/********************
	*Method Name: autoSubmitParentCaseForApproval
	*Parameter: new case list, old case map, new case map
	*Description: Used to handle After Update activities
	  1. If nobody picks IR Form then, Auto Approve Step 1(Approval By PSM) of approval process
	*******************/	 
	/*public static void autoSubmitParentCaseForApproval(List<Case> newCaseList, Map<Id, Case> oldCaseMap) {
		try{
			Boolean complianceApproved = true;
			case newCase = newCaseList[0];
			system.debug('newCaseList[0].parentId::'+newCaseList[0].parentId);
			Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
			if(rt_map.get(newCase.RecordTypeId).getName().containsIgnoreCase(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE) 
	  && (newCase.status == PRMGlobalConstants.CASE_STATUS_APPROVED_COMP || newCase.Status.equals(PRMGlobalConstants.REJECTED_STATUS)) && oldCaseMap.get(newCase.Id).status != newCase.status) {
	for(Case c : [SELECT ID, status FROM Case WHERE parentId =: newCaseList[0].parentId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]) {
		if(c.Status.equals(PRMGlobalConstants.CASE_STATUS_APPROVED_COMP) || c.Status.equals(PRMGlobalConstants.REJECTED_STATUS)) {
			//
		}else {
			complianceApproved = false;
			break;
		}
	}
	system.debug('complianceApproved::'+complianceApproved);
	if(complianceApproved) {
		Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
		req1.setObjectId(newCaseList[0].parentId);
		req1.setProcessDefinitionNameOrId(PRMGlobalConstants.IR_Parent_Case_ApprovalNew);
		Approval.ProcessResult result = Approval.process(req1);
	 }
			}
		 }catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.CASE_TRIGGER_HELPER ,PRMGlobalConstants.autoSubmitParentCaseForApproval);
		}
	}*/
/********************
	*Method Name: autoSubmitParentCaseForApproval
	*Parameter: new case list, old case map, new case map
	*Description: Used to handle After Update activities
	  1. If nobody picks IR Form then, Auto Approve Step 1(Approval By PSM) of approval process
	*******************/	  
	 public static void autoSubmitParentCaseForApproval(List<Case> newCaseList, Map<Id, Case> oldCaseMap) {
		try{
			Boolean complianceApproved = true;
	  Integer count = 0;
			case newCase = newCaseList[0];
			//system.debug('newCaseList[0].parentId::'+newCaseList[0].parentId);
			Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
	  
			if(rt_map.get(newCase.RecordTypeId).getDeveloperName().containsIgnoreCase(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE) 
	  && (newCase.status == PRMGlobalConstants.CASE_STATUS_APPROVED_COMP || newCase.Status.equals(PRMGlobalConstants.REJECTED_STATUS)) 
		&& oldCaseMap.get(newCase.Id).status != newCase.status) {
	
	List<Case> caseList = [select Id , status from Case where parentId =: newCaseList[0].parentId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
	/* if(caseList.size()  == 1 && caseList[0].Status.equals(PRMGlobalConstants.REJECTED_STATUS)){
			complianceApproved = false;
	} else */
	//system.debug('caseList.size'+ caseList.size());
	if(caseList.size() > 0){
			for(Case c : caseList){
	 if(c.Status.equals(PRMGlobalConstants.CASE_STATUS_APPROVED_COMP) ){
	 }else if( c.Status.equals(PRMGlobalConstants.REJECTED_STATUS)) {
	count++; 
	 }else {
	complianceApproved = false;
	break;
	 }
			}
			if(count != 0 && count == caseList.size()  )
			{
		//system.debug('caseList.size-inside'+ caseList.size());
	 complianceApproved = false;
			}
	}
		//system.debug('complianceApproved'+complianceApproved);
	/* for(Case c : [SELECT ID, status FROM Case WHERE parentId =: newCaseList[0].parentId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]) {
		if(c.Status.equals(PRMGlobalConstants.CASE_STATUS_APPROVED_COMP) || c.Status.equals(PRMGlobalConstants.REJECTED_STATUS)) {
			//
		}else {
			complianceApproved = false;
			break;
		}
	} */
	//system.debug('complianceApproved::'+complianceApproved);
	if(complianceApproved) {
		Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
		req1.setObjectId(newCaseList[0].parentId);
		req1.setProcessDefinitionNameOrId(PRMGlobalConstants.IR_Parent_Case_ApprovalNew);
		Approval.ProcessResult result = Approval.process(req1);
	 }
			}
	
		 }catch(Exception e) {
	 ExceptionHandler.addException(e,PRMGlobalConstants.CASE_TRIGGER_HELPER ,PRMGlobalConstants.autoSubmitParentCaseForApproval);
		}
	}
	
	
	/********************
	*Method Name: releaseOnHold
	*Parameter: new case list, old case map, new case map
	*Description: Used to handle After Update activities
	  1. If nobody picks IR Form then, Auto Approve Step 1(Approval By PSM) of approval process
	*******************/	
	public static void releaseOnHold(List<Case> newCaseList, Map<Id, Case> oldCaseMap) {
		try{
	Case newCase = newCaseList[0];
			Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
			if(rt_map.get(newCase.RecordTypeId).getDeveloperName().containsIgnoreCase(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE) 
	  && oldCaseMap.get(newCase.Id).status == PRMGlobalConstants.On_Hold && newCase.status != oldCaseMap.get(newCase.Id).status) {
	 List<Case> childList = [SELECT Id, Status FROM Case WHERE parentId =: newCase.parentId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
	Boolean releaseHold = true;
	for(Case c : childList) {
		if(c.status.equals(PRMGlobalConstants.On_Hold)) {
		// system.debug('in if ::');
			releaseHold = false;
			break;
		}
	}
	  // system.debug('releaseHold::'+releaseHold);
	if(releaseHold) {
		Integer value = 5;
		for(Case c : childList) { 
			if(c.status == PRMGlobalConstants.CASE_STATUS_NEW && value > 1) {
	value = 1;
			} else if(c.status == PRMGlobalConstants.CASE_STATUS_APPROVED_PSM && value > 2) {
	value = 2;
			} else if(c.status == PRMGlobalConstants.StatusRejected && value > 4) {
	value = 4;
			} else if(c.status == PRMGlobalConstants.CASE_STATUS_APPROVED_COMP && value > 3) {
	value = 3;
			}
			else{}
		}
		
		Case parentCase = new Case(Id = newCase.parentId);
		if(value == 1) {
			parentCase.Status = PRMGlobalConstants.CASE_STATUS_NEW;
	}else if(value == 2 || value == 3) {
			parentCase.Status = PRMGlobalConstants.CASE_STATUS_APPROVED_PSM;
		}else if(value == 4) {
			parentCase.Status = PRMGlobalConstants.StatusRejected;
		}
		else{}
	database.update(parentCase);
	} 
			}
		}catch(Exception e) { 
			ExceptionHandler.addException(e,PRMGlobalConstants.CASE_TRIGGER_HELPER ,PRMGlobalConstants.releaseOnHold);
		}
	}

 
}