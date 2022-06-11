public without sharing class CH_ManageRenameQueueAsyncQueue implements Queueable {
	List<CH_Workgroup__c> oOldCH_Workgroup = new List<CH_Workgroup__c>();
	List<CH_Workgroup__c> oNewCH_Workgroup = new List<CH_Workgroup__c>();

	public CH_ManageRenameQueueAsyncQueue(List<CH_Workgroup__c> oOldCH_Workgroup, List<CH_Workgroup__c> oNewCH_Workgroup) {
		this.oOldCH_Workgroup = oOldCH_Workgroup;
		this.oNewCH_Workgroup = oNewCH_Workgroup;
	}

	public void execute(QueueableContext context) {
		final Id workgroupRT = Utils.MapRecordType('CH_Workgroup__c').get('CH_KB_Workgroup');
		final Id workgroupCART = Utils.MapRecordType('CH_Workgroup__c').get('CH_CA_Workgroup');

		Map<String,String> workgroupNameMap = new Map<String,String>();
		List<Group> groupQueueList = new List<Group>();
		List<Group> groupQueueListToUpdate = new List<Group>();

		String DVTWorkgroups = System.Label.HWS_DP_Workgroups;
		Set<String> DVTWorkgroupsSet = New Set<String>();
		
		if(DVTWorkgroups != NULL){
			if(DVTWorkgroups.contains(';')){
				DVTWorkgroupsSet.addAll(DVTWorkgroups.split(';'));	
			} else {
				DVTWorkgroupsSet.add(DVTWorkgroups);
			}			
		}
		for(CH_Workgroup__c oldWorkgroup: oOldCH_Workgroup) {
			for (CH_Workgroup__c newWorkgroup : oNewCH_Workgroup) {
				if (oldWorkgroup.Id == newWorkgroup.Id && newWorkgroup.RecordTypeId == workgroupRT) {
					if(oldWorkgroup.Name != newWorkgroup.Name){
						workgroupNameMap.put(oldWorkgroup.Name + '_OQ', newWorkgroup.Name + '_OQ');
						workgroupNameMap.put(oldWorkgroup.Name + '_AQ', newWorkgroup.Name + '_AQ');
						workgroupNameMap.put(oldWorkgroup.Name + '_PQ', newWorkgroup.Name + '_PQ');
					}
				//Update Public Group Name HWSDDP-125
				} else if(oldWorkgroup.Id == newWorkgroup.Id && newWorkgroup.RecordTypeId == workgroupCART && DVTWorkgroupsSet.contains(newWorkgroup.Name) 
						  && (newWorkgroup.CH_Type__c.contains('Exclusions Quotation Support-CDM') || newWorkgroup.CH_Type__c.contains('Exclusions Quotation Support-QC')) && oldWorkgroup.Name != newWorkgroup.Name){
						  workgroupNameMap.put(oldWorkgroup.Name, newWorkgroup.Name);
				}
			}
		}
		if(!workgroupNameMap.isEmpty()){
			groupQueueList = EM_Group.getQueueIdByQueueName(workgroupNameMap.keySet());
			if(!groupQueueList.isEmpty()){
				for(Group queueGroup : groupQueueList){
					if(workgroupNameMap.ContainsKey(queueGroup.Name)){
						queueGroup.Name = workgroupNameMap.get(queueGroup.Name);
						queueGroup.DeveloperName = workgroupNameMap.get(queueGroup.Name);
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