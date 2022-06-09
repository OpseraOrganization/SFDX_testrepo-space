@isTest (seealldata =false) 
private class CH_WorkgroupHandler_TL_Test {
	private static List<CH_Workgroup__c> workgroupList;
	 
	static testMethod void createWorkgroups() {
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		// create WorkGroups
		workgroupList = CH_TestDataFactory.create_CH_Workgroups(4, 'CH_KB_Workgroup');
		System.debug('workgroupList before insert: ' + workgroupList);

		insert workgroupList;
		
		if(!workgroupList.isEmpty()){
			System.enqueueJob(new CH_ManageGroupMemberAsynchQueue(workgroupList));	
		}
		System.assertEquals(4, [SELECT Id FROM CH_Workgroup__c WHERE RecordType.DeveloperName='CH_KB_Workgroup'].size(), 'list of workgroup was not correct inserted');
	}

	static testMethod void renameWorkgroups() {
		
		// rename the workgroup
		Test.startTest();
		createWorkgroups();
		workgroupList[0].name = 'Test Done';
		update workgroupList[0];
		System.assertEquals('Test Done', [SELECT name from CH_Workgroup__c where name='Test Done'].name, 'a workgroup was not correct updated');
		Test.stopTest();
	}	 
	static testMethod void deleteWorkgroups() {
		// delete the workgroup
		Test.startTest();
		createWorkgroups();
		delete workgroupList[0];
		System.assertEquals(3, [SELECT Id FROM CH_Workgroup__c WHERE RecordType.DeveloperName='CH_KB_Workgroup'].size(), 'list of workgroups not correct');
		Test.stopTest();
	}
	 static testMethod void updateWorkgroupsOwner() {
		
		// rename the workgroup
		Test.startTest();
		createWorkgroups();
		workgroupList[0].name = 'Test Done';
		update workgroupList[0];
		System.assertEquals('Test Done', [SELECT name from CH_Workgroup__c where name='Test Done'].name, 'a workgroup was not correct updated');
		User adminUser = CH_TestDataFactory.createUser('System Administrator', 'CH_KnowledgeHandler_TL' + 1);
		insert adminUser;
		//Assign Permission set CH_KB_Workgroup_Admin to created user
		PermissionSet  oPermissionSet = [SELECT Id FROM PermissionSet WHERE Name = 'CH_KB_Workgroup_Admin'];
		system.assert(oPermissionSet !=null);
		system.runAs(adminUser){
			workgroupList[0].OwnerID = adminUser.Id;
			update workgroupList[0];
		}
		Test.stopTest();
	} 
}