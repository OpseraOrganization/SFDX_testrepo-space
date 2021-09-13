/**
About
-----
Description: This Class is used as Helper for CH_WorkgroupTrigger.

Created for: Nokia Portugal COE
Created: 19 02 2019

Update History
--------------
Created: 19 02 2019 – flavio.toscano@nokia.com
-------------
**/
public with sharing class CH_WorkgroupHandler_TL {
		
	/*
	* @description : Delete Workgroup Queues
	* @param : List<CH_Workgroup__c>
	* @return : void
	*/
	public static void deleteWorkgroupQueues(List<CH_Workgroup__c> oCH_Workgroup) {
		final Id workgroupRT = Utils.MapRecordType('CH_Workgroup__c').get('CH_KB_Workgroup');
		Set<String> workgroupQueueNameSet = new Set<String>();
		List<Group> groupQueueList = new List<Group>();

		for(CH_Workgroup__c oWorkgroup: oCH_Workgroup){
			if(oWorkgroup.RecordTypeId == workgroupRT) {
				workgroupQueueNameSet.add(oWorkgroup.Name + '_OQ');
			}
		}

		if(!workgroupQueueNameSet.isEmpty()){
			groupQueueList = EM_Group.getQueueIdByQueueName(workgroupQueueNameSet);

			if(!groupQueueList.isEmpty()){
				EM_Group.doDeleteGroupList(groupQueueList);
			}
		}
	}
	
	 /*
	* @description : Whenever OWner of Work Group is changed
	*		 Add manual sharing rule for respective Workgroup Members
	* @param : List<CH_Workgroup__c> and old Map<Id, CH_Workgroup__c>
	* @return : void
	*/
	public static void addWorkgroupMemberToWorkgroupShare(List<CH_Workgroup__c> oCH_Workgroup, Map<Id, CH_Workgroup__c> oldMapWorkgroup) {
		set<ID> workGroupRecordID = new set<ID>();
		for(CH_Workgroup__c oWorkGroup : oCH_Workgroup){
			if(oWorkGroup.OwnerId != oldMapWorkgroup.get(oWorkGroup.Id).OwnerId){
				workGroupRecordID.add(oWorkGroup.Id);
			}
		}
		if(!workGroupRecordID.isempty()){
			List<CH_Workgroup_Member__c> oCH_WorkgroupMember = [select id, RecordTypeId, CH_Owner__c, CH_WorkgroupId__c,
																CH_UserId__c from CH_Workgroup_Member__c where CH_WorkgroupId__c in :workGroupRecordID ];
			if(!oCH_WorkgroupMember.isempty()){
				CH_WorkgroupMemberHandler_TL.addWorkgroupMemberToWorkgroupShare(oCH_WorkgroupMember);
			}
		}
	}
	
	/*
	* @description : Delete Workgroup ListViews regarding created Queues
	* @param : List<CH_Workgroup__c>
	* @return : void
	*/
	/*
	public static void deleteWorkgroupListViews(List<CH_Workgroup__c> oCH_Workgroup) {
		final Id workgroupRT = Utils.MapRecordType('CH_Workgroup__c').get('CH_KB_Workgroup');
		Set<String> oQueueNames = new Set<String>();
		List<ListView> listViewList = new List<ListView>();

		for(CH_Workgroup__c oWorkgroup: oCH_Workgroup){
			if(oWorkgroup.RecordTypeId == workgroupRT) {
				oQueueNames.add(oWorkgroup.Name + '_OQ');
				oQueueNames.add(oWorkgroup.Name + '_AQ');
				oQueueNames.add(oWorkgroup.Name + '_PQ');
			}
		}

		if(!oQueueNames.isEmpty()) {
			listViewList = EM_Group.getListViewsByQueueName(oQueueNames);
			if(!listViewList.isEmpty()){
				EM_Group.doDeleteListViewList(listViewList);
			}
		}
	}
	*/
}