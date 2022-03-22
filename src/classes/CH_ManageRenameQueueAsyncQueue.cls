public without sharing class CH_ManageRenameQueueAsyncQueue implements Queueable {
	List<CH_Workgroup__c> oOldCH_Workgroup = new List<CH_Workgroup__c>();
	List<CH_Workgroup__c> oNewCH_Workgroup = new List<CH_Workgroup__c>();

	public CH_ManageRenameQueueAsyncQueue(List<CH_Workgroup__c> oOldCH_Workgroup, List<CH_Workgroup__c> oNewCH_Workgroup) {
		this.oOldCH_Workgroup = oOldCH_Workgroup;
		this.oNewCH_Workgroup = oNewCH_Workgroup;
	}

	public void execute(QueueableContext context) {
		final Id workgroupRT = Utils.MapRecordType('CH_Workgroup__c').get('CH_KB_Workgroup');
		final Id permissionSetId = Utils.getPermissionSetIdByPermissionSetName('CH_KB_Workgroup_Admin');

		Map<String,String> workgroupNameMap = new Map<String,String>();
		List<Group> groupQueueList = new List<Group>();
		List<Group> groupQueueListToUpdate = new List<Group>();
		List<CH_Workgroup_Admin__c> oWorkgroupAdminList = new List<CH_Workgroup_Admin__c>();

		for(CH_Workgroup__c oldWorkgroup: oOldCH_Workgroup) {
			for (CH_Workgroup__c newWorkgroup : oNewCH_Workgroup) {
				if (oldWorkgroup.Id == newWorkgroup.Id && newWorkgroup.RecordTypeId == workgroupRT) {
					if(oldWorkgroup.Name != newWorkgroup.Name){
						workgroupNameMap.put(oldWorkgroup.Name + '_OQ', newWorkgroup.Name + '_OQ');
						workgroupNameMap.put(oldWorkgroup.Name + '_AQ', newWorkgroup.Name + '_AQ');
						workgroupNameMap.put(oldWorkgroup.Name + '_PQ', newWorkgroup.Name + '_PQ');
					}
				}
			}
		}
		
		if(!workgroupNameMap.isEmpty()){
			groupQueueList = EM_Group.getQueueIdByQueueName(workgroupNameMap.keySet());
			
			if(!groupQueueList.isEmpty()){
				for(Group queueGroup : groupQueueList){
					if(workgroupNameMap.ContainsKey(queueGroup.Name)){
						queueGroup.Name = workgroupNameMap.get(queueGroup.Name);
					}
					groupQueueListToUpdate.add(queueGroup);
				}
				if(!groupQueueListToUpdate.isEmpty()) {
					EM_Group.doUpdateGroupList(groupQueueListToUpdate);
				}
			}
		}
	}
}