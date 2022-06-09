/****************************************************************
* Class Name : HWS_ServiceQuoteSharingTriggerHelper 
* Created Date: 05-11-2021
* Created By: TCS
* Description : This Class is used as helper for ServiceQuoteSharingTrigger Trigger
* Modification Log:
---------------------------------------------------------
Modified By	 Modified For US#	Modified Date
 
******************************************************************/
public with sharing class HWS_ServiceQuoteSharingTriggerHelper {
	/*******************************************************
	* Method Name : SearchUserByEmailId 
	* Description : returns quote id and contacts who are portal users
	*********************************************************/ 
	public static Map<Id,Id> SearchUserByEmailId(List<Id> contactIdlst){
		Map<Id,Id> contactIdUserMap = new Map<Id,Id>();  // To get a mapping of {email : userId}
		for(User usr:[SELECT Id, Email,contactId FROM User WHERE  ContactId !=Null and contactId IN :contactIdlst AND isActive=true]){
			contactIdUserMap.put(usr.contactId, usr.Id); 
		}
		return contactIdUserMap;		
	}
	
	/*******************************************************
	* Method Name : enableSharing 
	* Description : add service quote sharing for portal users
	*********************************************************/ 
	public static void enableSharing(Map<Id,List<Id>> quoteIdContactIdLstMap, Map<Id,Id>  contactIdUserMap){  
		// Provides sharing to both the customer1 email and customer2 email
		List<HWS_Service_Quote__Share> shareList = new List<HWS_Service_Quote__Share>();
		for(Id quoteId : quoteIdContactIdLstMap.keySet()){
			for(Id contactId : quoteIdContactIdLstMap.get(quoteId)){
				if(contactIdUserMap.containsKey(contactId)){
					HWS_Service_Quote__Share shareQuote = new HWS_Service_Quote__Share();
					shareQuote.ParentId = quoteId;
					shareQuote.UserOrGroupId = contactIdUserMap.get(contactId);
					shareQuote.AccessLevel = 'Edit';
					shareQuote.RowCause = Schema.HWS_Service_Quote__Share.RowCause.SVQ_Portal_User__C;
					shareList.add(shareQuote);
				}
			}
		}
		if(!shareList.isEmpty()){
			DML_SObject.doInsert(shareList,true,true);
		}
	}
	
	/*******************************************************
	* Method Name : removeSharing 
	* Description : remove service quote sharing for portal users
	*********************************************************/ 
	public static void removeSharing(Map<Id,List<Id>> delQuoteIdContactIdLstMap, Map<Id,Id>  contactIdUserMap){
		List<HWS_Service_Quote__Share> delShareList = new List<HWS_Service_Quote__Share>();
		Map<Id,HWS_Service_Quote__Share> sQSharemap = new Map<Id,HWS_Service_Quote__Share>();
		for(HWS_Service_Quote__Share sQShare:[SELECT Id,userorgroupid,ParentId FROM HWS_Service_Quote__Share WHERE ParentId IN :delQuoteIdContactIdLstMap.keyset() and userorgroupid IN :contactIdUserMap.values()]){
			sQSharemap.put(sQShare.ParentId,sQShare);
		}
		for(Id quoteId : delQuoteIdContactIdLstMap.keySet()){
			HWS_Service_Quote__Share sQSharetemp = new HWS_Service_Quote__Share();
			if(sQSharemap.containsKey(quoteId)){
				sQSharetemp = sQSharemap.get(quoteId);
				for(Id contactId : delQuoteIdContactIdLstMap.get(quoteId)){
					if(contactIdUserMap.get(contactId) == sQSharetemp.userorgroupid){
						HWS_Service_Quote__Share shareQuote = new HWS_Service_Quote__Share();
						shareQuote.Id = sQSharetemp.Id;
						delShareList.add(shareQuote);
					}
				}
			}
		}
		if(!delShareList.isEmpty()){
			DML_SObject.doDelete(delShareList,true,false);
		}
	}
	
	/*******************************************************
	* Method Name : updateSharing 
	* Description : add/remove sharing if Quote Sent date or Contact1/COntact2 is updated
	*********************************************************/ 
	public static void updateSharing(Map<Id,HWS_Service_Quote__c> oldMap,Map<Id,HWS_Service_Quote__c> newMap){
		Map<Id,List<Id>> quoteIdContactIdLstMap = new Map<Id,List<Id>>();
		Map<Id,List<Id>> delQuoteIdContactIdLstMap = new Map<Id,List<Id>>();
		List<Id> cnctIdlst = new List<Id>();
		for(HWS_Service_Quote__c sq : newMap.values()){
			List<Id> contactIdlst = new List<Id>();
			List<Id> delContactIdlst = new List<Id>();
			if((oldMap.get(sq.Id).HWS_Quote_Sent_Date__c != sq.HWS_Quote_Sent_Date__c)|| 
	(oldMap.get(sq.Id).HWS_Quote_Sent_Date__c != null  && 
	((oldMap.get(sq.Id).HWS_Customer_ContactId_1__c != sq.HWS_Customer_ContactId_1__c) || 
	(oldMap.get(sq.Id).HWS_Customer_ContactId2__c != sq.HWS_Customer_ContactId2__c)))){
	if(!String.isBlank(sq.HWS_Customer_ContactId_1__c))
	 contactIdlst.add(sq.HWS_Customer_ContactId_1__c);
	if(oldMap.get(sq.Id).HWS_Customer_ContactId_1__c != sq.HWS_Customer_ContactId_1__c && !string.isblank(oldMap.get(sq.Id).HWS_Customer_ContactId_1__c))
		delContactIdlst.add(oldMap.get(sq.Id).HWS_Customer_ContactId_1__c);

	if(!String.isBlank(sq.HWS_Customer_ContactId2__c))
		contactIdlst.add(sq.HWS_Customer_ContactId2__c);
	if(oldMap.get(sq.Id).HWS_Customer_ContactId2__c != sq.HWS_Customer_ContactId2__c && !string.isblank(oldMap.get(sq.Id).HWS_Customer_ContactId2__c))
		delContactIdlst.add(oldMap.get(sq.Id).HWS_Customer_ContactId2__c);
			}
			if(contactIdlst!=null && contactIdlst.size()>0){
				quoteIdContactIdLstMap.put(sq.Id,contactIdlst);
				cnctIdlst.addAll(contactIdlst);
			}
			if(delContactIdlst!=null && delContactIdlst.size()>0){
				delQuoteIdContactIdLstMap.put(sq.Id,delContactIdlst);
				cnctIdlst.addAll(delContactIdlst);
			}
		}
		if(cnctIdlst != null && cnctIdlst.size()>0){
			Map<Id,Id> contactIdUserMap = SearchUserByEmailId(cnctIdlst);
			if(contactIdUserMap!=null && !contactIdUserMap.isempty()){
				if(quoteIdContactIdLstMap!=null && quoteIdContactIdLstMap.keyset().size()>0){
					enableSharing(quoteIdContactIdLstMap,contactIdUserMap);
				}
				if(delQuoteIdContactIdLstMap!=null && delQuoteIdContactIdLstMap.keyset().size()>0){
					removeSharing(delQuoteIdContactIdLstMap,contactIdUserMap);
				}
			}
		}
	} 
	
	/*******************************************************
	* Method Name : autoAssignToWorkgroups 
	* Description : assign service quote to SME3/SME2 WG and update 
	owner and quote status
	created for HWSDDP-60
	*********************************************************/ 
	public static void autoAssignToWorkgroups(Map<Id,HWS_Service_Quote__c> oldMap,Map<Id,HWS_Service_Quote__c> newMap){
		Id damaged_quote_RecTypeId = Schema.getGlobalDescribe().get('HWS_Service_Quote__c').getDescribe().getRecordTypeInfosByDeveloperName().get('HWS_Damaged_Part_Quote').getRecordTypeId();
		Id unreturned_quote_RecTypeId = Schema.getGlobalDescribe().get('HWS_Service_Quote__c').getDescribe().getRecordTypeInfosByDeveloperName().get('HWS_UnReturned_Part_Quote').getRecordTypeId();
		List<HWS_Service_Quote__c> servQuoteWgAssignmentLst = new List<HWS_Service_Quote__c>();
		Map<String,String> servQuoteToWGNameMap = new Map<String,String>();
		String userQuery = 'SELECT Id FROM User WHERE Name = "CH Queue" LIMIT 1';
		List<User> chQueueUser = DML_SObject.doQuery(userQuery,true); // query in without sharing mode
		Map<Id,List<CH_Workgroup_Rule__c>> getPassiveWorkGroupRuleMap = passiveAssignmentToWorkgroups(newMap.keySet());
		for(HWS_Service_Quote__c sq : newMap.values()){
			//do passive assignment for SME3 workgroup - added for HWSDDP-63
			if(sq.HWS_Workgroup__c == null && oldMap.get(sq.Id).HWS_Quote_Status__c != sq.HWS_Quote_Status__c && sq.HWS_Quote_Status__c != HWS_Constants.SQ_STATUS_DRAFT){
				HWS_Service_Quote__c servQuoteDetails = updateWorkgroupDetails(getPassiveWorkGroupRuleMap,sq,chQueueUser[0].Id);
				servQuoteWgAssignmentLst.add(servQuoteDetails);
				servQuoteToWGNameMap.put(sq.Id, servQuoteDetails.HWS_WorkgroupName__c);
			}
			//do passive assignment for SME2 workgroup for damaged - added for HWSDDP-63
			else if(sq.RecordTypeId == damaged_quote_RecTypeId && sq.HWS_Workgroup__c != null  && oldMap.get(sq.Id).HWS_Quote_Status__c != sq.HWS_Quote_Status__c && (sq.HWS_Quote_Status__c == HWS_Constants.SQ_STATUS_ACCEPTED_CDM || sq.HWS_Quote_Status__c == HWS_Constants.SQ_STATUS_REJECTED_CDM)){
				HWS_Service_Quote__c servQuoteDetails = updateWorkgroupDetails(getPassiveWorkGroupRuleMap,sq,chQueueUser[0].Id);
				servQuoteWgAssignmentLst.add(servQuoteDetails);
				servQuoteToWGNameMap.put(sq.Id, servQuoteDetails.HWS_WorkgroupName__c);
			}
			//do manual passive assignment for SME2 workgroup for Unreturned - added for HWSDDP-160
			else if(sq.RecordTypeId == unreturned_quote_RecTypeId && sq.HWS_Workgroup__c != null && oldMap.get(sq.Id).HWS_TriggerOCWorkgroupAssignment__c != sq.HWS_TriggerOCWorkgroupAssignment__c  && sq.HWS_TriggerOCWorkgroupAssignment__c && (sq.HWS_Quote_Status__c == HWS_Constants.SQ_STATUS_ACCEPTED_CDM || sq.HWS_Quote_Status__c == HWS_Constants.SQ_STATUS_REJECTED_CDM)){
				HWS_Service_Quote__c servQuoteDetails = updateWorkgroupDetails(getPassiveWorkGroupRuleMap,sq,chQueueUser[0].Id);
				servQuoteWgAssignmentLst.add(servQuoteDetails);
				servQuoteToWGNameMap.put(sq.Id, servQuoteDetails.HWS_WorkgroupName__c);
			}
			//validation-  Manual assignment for OC is allowed for unretunred only when Status is Accepted by CDM or Rejected by CDM and WG is not blank - added for HWSDDP-160
			else if(sq.RecordTypeId == unreturned_quote_RecTypeId && sq.HWS_Workgroup__c != null && oldMap.get(sq.Id).HWS_TriggerOCWorkgroupAssignment__c != sq.HWS_TriggerOCWorkgroupAssignment__c && sq.HWS_TriggerOCWorkgroupAssignment__c && (sq.HWS_Quote_Status__c != HWS_Constants.SQ_STATUS_ACCEPTED_CDM || sq.HWS_Quote_Status__c != HWS_Constants.SQ_STATUS_REJECTED_CDM)){
				newMap.get(sq.Id).addError(System.Label.HWS_Prevent_Manual_OC_WG_Assignemnt_Warning);
			}
			if(!servQuoteWgAssignmentLst.isEmpty()){
				DML_SObject.doUpdate(servQuoteWgAssignmentLst,true,false,true); // update in with sharing with retry attempts if fails
				HWS_EmailNotifications.serviceQuoteWGAssignmentEmail(servQuoteWgAssignmentLst); 
			}
			// Insert Service Quote WG Share records
			if(servQuoteToWGNameMap.size() > 0) {
				insertSQuoteUserShareRecords(servQuoteToWGNameMap);
			}
		}
	}
	/*******************************************************
	* Method Name : updateWorkgroupDetails 
	* Description : assigns WG details to Service Quote record
	created for HWSDDP-60
	*********************************************************/ 
	public static HWS_Service_Quote__c updateWorkgroupDetails(Map<Id,List<CH_Workgroup_Rule__c>> workGroupRuleMapDetails, HWS_Service_Quote__c servQuoteObj,Id queueUserId){
		HWS_Service_Quote__c cloneServQuote = new HWS_Service_Quote__c();
		if(workGroupRuleMapDetails.values().size() > 0 && workGroupRuleMapDetails.get(servQuoteObj.Id) != null ){
			cloneServQuote.HWS_Workgroup__c = !workGroupRuleMapDetails.get(servQuoteObj.Id).isEmpty() ? workGroupRuleMapDetails.get(servQuoteObj.Id)[0].CH_Workgroup__c : null; 
			cloneServQuote.HWS_WorkGroupType__c = !workGroupRuleMapDetails.get(servQuoteObj.Id).isEmpty() ? workGroupRuleMapDetails.get(servQuoteObj.Id)[0].CH_Workgroup_Type__c : '';
			cloneServQuote.HWS_WorkgroupName__c = !workGroupRuleMapDetails.get(servQuoteObj.Id).isEmpty() ? workGroupRuleMapDetails.get(servQuoteObj.Id)[0].CH_Workgroup__r.Name : '';
			cloneServQuote.OwnerId = queueUserId; //assign the owner as CH Queue User
			if(servQuoteObj.HWS_Quote_Status__c != HWS_Constants.SQ_STATUS_ON_HOLD && servQuoteObj.HWS_Quote_Status__c != HWS_Constants.SQ_STATUS_CANCELLED && cloneServQuote.HWS_WorkGroupType__c == HWS_Constants.WORKGROUP_TYPE_CDM){
				cloneServQuote.HWS_Quote_Status__c = HWS_Constants.SQ_STATUS_CDM_REVIEW; // update Status to CDM Review only when current status is not On Hold or Cancelled
			}else if(cloneServQuote.HWS_WorkGroupType__c == HWS_Constants.WORKGROUP_TYPE_OC){
				cloneServQuote.HWS_Quote_Status__c = HWS_Constants.SQ_STATUS_OC_REVIEW;
			}
			cloneServQuote.Id = servQuoteObj.Id;
		}
		return cloneServQuote;
	}
	/*******************************************************
	* Method Name : sendOwnerAssignmentEmail 
	* Description : sends email to all Service Quote Owner
	created for HWSDDP-99
	*********************************************************/ 
	public static void sendOwnerAssignmentEmail(Map<Id,HWS_Service_Quote__c> oldMap,Map<Id,HWS_Service_Quote__c> newMap){
		String userQuery = 'SELECT Id FROM User WHERE Name = "CH Queue" LIMIT 1';
		List<User> chQueueUser = DML_SObject.doQuery(userQuery,true); // query in without sharing mode
		Boolean isOwnerReAssignmenEmail = false;
		List<Id> servQuoteIdLst = new List<Id>();
		if(oldMap != null){ 
			for(HWS_Service_Quote__c sq : newMap.values()){
				if((oldMap.get(sq.Id).OwnerId == chQueueUser[0].Id && sq.OwnerId != oldMap.get(sq.Id).OwnerId) || (sq.OwnerId != oldMap.get(sq.Id).OwnerId)){//check if owner is changed
					servQuoteIdLst.add(sq.Id);
					isOwnerReAssignmenEmail = true;
				}
			}
		}
		if(!servQuoteIdLst.isEmpty() && isOwnerReAssignmenEmail){
			HWS_EmailNotifications.ownerReAssignmentEmail(servQuoteIdLst); 
		}
	}
	

	/*******************************************************
	* Method Name : passiveAssignmentToWorkgroups 
	* Description : assign service quote to workgroup
	created for HWSDDP-63
	*********************************************************/ 
	public static Map<Id,List<CH_Workgroup_Rule__c>> passiveAssignmentToWorkgroups(Set<Id> serviceQuoteIdList) {
		Map<Id,List<CH_Workgroup_Rule__c>> getPassiveWorkGroupRuleMap = new Map<Id,List<CH_Workgroup_Rule__c>>();
		HWS_ServiceQuoteAssignmentHelper assignmentHelper = new HWS_ServiceQuoteAssignmentHelper(serviceQuoteIdList);
		getPassiveWorkGroupRuleMap = assignmentHelper.getPassiveQuoteAssignmentWgRule();
		return getPassiveWorkGroupRuleMap;
	}
	
	/***************************************
	* Method Name : insertSQuoteUserShareRecords 
	* Description : created ServiceQuoteShare records HWSDDP-125
	*****************************************/
	public static void insertSQuoteUserShareRecords(Map<String,String> servQuoteToWGNameMap){
		Map<String,Id> wgNameToGroupMap = new Map<String,Id>();
		for(Group g : [SELECT Id, Name FROM Group WHERE Type ='Regular' and Name IN : servQuoteToWGNameMap.values()]){
			wgNameToGroupMap.put(g.Name, g.Id);
		}
		List<HWS_Service_Quote__Share> sQuoteShareList = new List<HWS_Service_Quote__Share>();
		for(String sQuoteId : servQuoteToWGNameMap.keySet()){
			HWS_Service_Quote__Share sQuoteShare = new HWS_Service_Quote__Share();
			sQuoteShare.ParentId = sQuoteId;
			sQuoteShare.UserOrGroupId = wgNameToGroupMap.get(servQuoteToWGNameMap.get(sQuoteId));
			sQuoteShare.AccessLevel = 'Read';
			sQuoteShare.RowCause = Schema.HWS_Service_Quote__Share.RowCause.SVQ_Workgroup_Team__C;
			sQuoteShareList.add(sQuoteShare);
		}
		if(sQuoteShareList.size() > 0) {
			DML_SObject.doInsert(sQuoteShareList, true, true, false);
		   
		}
	}
	
}