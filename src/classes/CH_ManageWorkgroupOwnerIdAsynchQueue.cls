public without sharing class CH_ManageWorkgroupOwnerIdAsynchQueue implements Queueable {
	List<CH_Workgroup_Member__c> oCH_WorkgroupMember = new List<CH_Workgroup_Member__c>();

	public CH_ManageWorkgroupOwnerIdAsynchQueue(List<CH_Workgroup_Member__c> oCH_WorkgroupMember) {
		this.oCH_WorkgroupMember = oCH_WorkgroupMember;
	}

	public void execute(QueueableContext context) {
		final Id workgroupMemberRT = Utils.MapRecordType('CH_Workgroup_Member__c').get('CH_KB_Workgroup_Members');
		Set<Id> workgroupIds = new Set<Id>();
		Map<String, Id> queueNameToId = new Map<String,Id>();
		List<CH_Workgroup__c> oCH_Workgroup = new List<CH_Workgroup__c>();
		
		for(CH_Workgroup_Member__c newWorkgroupMember: oCH_WorkgroupMember){
			if(newWorkgroupMember.RecordTypeId == workgroupMemberRT) {
				workgroupIds.add(newWorkgroupMember.CH_WorkgroupId__c);
			}
		}
		
		if(!workgroupIds.isEmpty()){
			oCH_Workgroup = CH_EM_Workgroup.getWorkgroupById(workgroupIds);
			if(!oCH_Workgroup.isEmpty()){
				for(Group queue : EM_Group.getAllQueues()){
					queueNameToId.put(queue.Name, queue.Id);
				}
				for(CH_Workgroup__c oWorkgroup: oCH_Workgroup){
					oWorkgroup.OwnerId = queueNameToId.get(oWorkgroup.Name+ '_OQ');
				}
				if(!oCH_Workgroup.isEmpty()){
					CH_EM_Workgroup.doUpdateCHWorkgroupList(oCH_Workgroup);
				}
			}
		}  
	}
}