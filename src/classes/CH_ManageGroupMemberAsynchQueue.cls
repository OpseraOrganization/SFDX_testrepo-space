public with sharing class CH_ManageGroupMemberAsynchQueue implements Queueable {

	List<CH_Workgroup__c> oCH_Workgroup = new List<CH_Workgroup__c>();

	public CH_ManageGroupMemberAsynchQueue(List<CH_Workgroup__c> oCH_Workgroup) {
		this.oCH_Workgroup = oCH_Workgroup;
	}

	public void execute(QueueableContext context) {
		final Id workgroupRT = Utils.MapRecordType('CH_Workgroup__c').get('CH_KB_Workgroup');
		Map<Id,Id> userIdQueueMap = new Map<Id,Id>();
		
		for(CH_Workgroup__c oWorkgroup: oCH_Workgroup){
			if(oWorkgroup.RecordTypeId == workgroupRT) {
				userIdQueueMap.put(oWorkgroup.OwnerId, oWorkgroup.Id);
			}
		}
		
		if(!userIdQueueMap.isEmpty()){
			Map<String, Id> queueNameToId = new Map<String,Id>();
			Map<Id,Id> workgroupsToQueue = new Map<Id,Id>();
			
			for(Group queue : EM_Group.getAllQueues()){
				queueNameToId.put(queue.Name, queue.Id);
			}
			for(CH_Workgroup__c workgroup : CH_EM_Workgroup.getAllWorkgroups(workgroupRT)){
				workgroupsToQueue.put(workgroup.Id, queueNameToId.get(workgroup.Name+ '_OQ'));
			}
			if(!workgroupsToQueue.isEmpty()){
				List<GroupMember> oGroupMember = new List<GroupMember>();
				for (Id key : userIdQueueMap.keySet()) {
					oGroupMember.add(new GroupMember(GroupId = workgroupsToQueue.get(userIdQueueMap.get(key)), UserOrGroupId = key));
				}
				if(!oGroupMember.isEmpty()){
					EM_GroupMember.doInsertGroupMemberList(oGroupMember);
				}
			}
		}
	}
}