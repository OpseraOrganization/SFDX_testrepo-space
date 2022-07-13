public without sharing class CH_ManageCreateQueueAsynchQueue implements Queueable {
	@testVisible
	private static Boolean doChainJob = true;
	
	List<CH_Workgroup__c> oCH_Workgroup = new List<CH_Workgroup__c>();

	public CH_ManageCreateQueueAsynchQueue(List<CH_Workgroup__c> oCH_Workgroup) {
		this.oCH_Workgroup = oCH_Workgroup;
	}

	public void execute(QueueableContext context) {
		final Id workgroupRT = Utils.MapRecordType('CH_Workgroup__c').get('CH_KB_Workgroup');
		final Id workgroupCART = Utils.MapRecordType('CH_Workgroup__c').get('CH_CA_Workgroup');
		List<Group> queueList = new List<Group>();
		Set<String> oQueueNames = new Set<String>();
		Set<String> oQueueNamesKB = new Set<String>();
		
		String DVTWorkgroups = System.Label.HWS_DP_Workgroups;
		Set<String> DVTWorkgroupsSet = New Set<String>();
		
		if(DVTWorkgroups != NULL){
			if(DVTWorkgroups.contains(';')){
				DVTWorkgroupsSet.addAll(DVTWorkgroups.split(';'));	
			} else {
				DVTWorkgroupsSet.add(DVTWorkgroups);
			}			
		}
		
		for(CH_Workgroup__c oWorkgroup: oCH_Workgroup){
			if(oWorkgroup.RecordTypeId == workgroupRT) {
				//Create Member Workgroup Queue
				Group wgQueue1 = new Group(
					Name = oWorkgroup.Name + '_OQ',
					Type = 'Queue',
					DoesSendEmailToMembers = true
				);
				queueList.add(wgQueue1);
				oQueueNames.add(oWorkgroup.Name + '_OQ');
				
				//Create Approver Workgroup Queue
				Group wgQueue2 = new Group(
					Name = oWorkgroup.Name + '_AQ',
					Type = 'Queue',
					DoesSendEmailToMembers = true
				);
				queueList.add(wgQueue2);
				oQueueNamesKB.add(oWorkgroup.Name + '_AQ');
				
				//Create Publisher Workgroup Queue
				Group wgQueue3 = new Group(
					Name = oWorkgroup.Name + '_PQ',
					Type = 'Queue',
					DoesSendEmailToMembers = true
				);
				queueList.add(wgQueue3);
				oQueueNamesKB.add(oWorkgroup.Name + '_PQ');
			} 
			//HWSDDP-125
			else if(oWorkgroup.RecordTypeId == workgroupCART && DVTWorkgroupsSet.contains(oWorkgroup.Name) && (oWorkgroup.CH_Type__c.contains('Exclusions Quotation Support-CDM') || oWorkgroup.CH_Type__c.contains('Exclusions Quotation Support-OC'))){
				//Create Public Group
				Group wgPublicGroup = new Group(
					Name = oWorkgroup.Name,
					Type = 'Regular',
					DoesSendEmailToMembers = true,
					DoesIncludeBosses = true
				);
				queueList.add(wgPublicGroup);
			}
		}
		
		if(!queueList.isEmpty()) {
			system.debug(queueList);
			EM_Group.doInsertGroupList(queueList);
			if(!oQueueNames.isEmpty() || !oQueueNamesKB.isEmpty()){
				List<Group> queuesIdList = new List<Group>();
				List<Group> queuesIdKBList = new List<Group>();
				List<QueuesObject> queueObjectList = new List<QueuesObject>();
				queuesIdList = EM_Group.getQueueIdByQueueName(oQueueNames);
				queuesIdKBList = EM_Group.getQueueIdByQueueName(oQueueNamesKB);
				
				if(!queuesIdList.isEmpty() || !queuesIdKBList.isEmpty()){
					for (Group queue : queuesIdList) {
						QueuesObject qso = new QueueSObject(
							QueueID = queue.id,
							SobjectType = 'CH_Workgroup__c'
						);
						queueObjectList.add(qso);
					}
					
					for (Group queue : queuesIdKBList) {
						QueuesObject qso = new QueueSObject(
							QueueID = queue.id,
							SobjectType = 'KnowledgeArticleVersion'
						);
						queueObjectList.add(qso);
					}
					
					if(!queueObjectList.isEmpty()){
						EM_Group.doInsertQueuesObjectList(queueObjectList);
						//insert queueObjectList;
					}
				}	
			}
		}
		
		if(!Test.isRunningTest() && doChainJob){
				System.enqueueJob(new CH_ManageGroupMemberAsynchQueue(oCH_Workgroup));
		}
	}
}