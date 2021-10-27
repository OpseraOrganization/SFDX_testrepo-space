/**
About
-----
Description: Test class for CH_KnowledgeHandler_TL.

Created: 23 05 2019

Update History
--------------
Created:  23 05 2019 – Nokia IN Bangalore
-------------
**/
@isTest(seealldata =False)
private class CH_WorkgroupMemberHandler_TL_Test {
	private static List<CH_Workgroup__c> workgroupList;
	private static List<CH_Workgroup_Member__c> author;
	private static List<CH_Workgroup_Member__c> approver;
	private static List<CH_Workgroup_Member__c> publisher;
	private static Integer i = 1;
	/*
* @description : Test Data Record creation for CH_Workgroup__c & CH_Workgroup_Member__c
*/
	static testMethod void InsertWorkgroups() {
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		workgroupList = CH_TestDataFactory.create_CH_Workgroups(1, 'CH_KB_Workgroup');
		insert workgroupList;
		System.assertEquals(i, [SELECT Id FROM CH_Workgroup__c WHERE RecordType.DeveloperName='CH_KB_Workgroup'].size(), 'list of workgroup was not correct inserted');
		i++;
	}
	/*
* @description : Test Method to cover CH_WorkgroupMemberHandler_TL 
*/
	static testMethod void testUpdateOwnerFlagAndRole_Authors() {
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		//Create user
		User adminUser = CH_TestDataFactory.createUser('System Administrator', 'TestCH_WorkgroupMemberHandler_TL' + 1);
		insert adminUser;
		//Assign Permission set CH_KB_Workgroup_Admin to created user
		PermissionSet  oPermissionSet = [SELECT Id FROM PermissionSet WHERE Name = 'CH_KB_Workgroup_Admin'];
		system.assert(oPermissionSet !=null);
		insert new PermissionSetAssignment(AssigneeId = adminUser.id, PermissionSetId = oPermissionSet.Id);
		system.runAs(adminUser){
			Test.startTest();
			InsertWorkgroups();
			InsertWorkgroups();
			author = CH_TestDataFactory.create_CH_WorkgroupMembers(1, workgroupList, 'Author');
			approver = CH_TestDataFactory.create_CH_WorkgroupMembers(1, workgroupList, 'Approver');
			publisher = CH_TestDataFactory.create_CH_WorkgroupMembers(1, workgroupList, 'Publisher');
			
			insert author;
			insert approver;
			insert publisher; 
			System.assertEquals(1, [Select id from CH_Workgroup_Member__c where CH_Role__c='Author'].size(), 'list of workgroup members was not insert');
			System.assertEquals(1, [Select id from CH_Workgroup_Member__c where CH_Role__c='Approver'].size(), 'list of workgroup members was not insert');
			System.assertEquals(1, [Select id from CH_Workgroup_Member__c where CH_Role__c='Publisher'].size(), 'list of workgroup members was not insert');
			
			// change roles and owner flag
			author[0].CH_Role__c = 'Internal Approver (Approver)';
			update author[0];
			
			approver[0].CH_Owner__c = true;
			approver[0].CH_Role__c = 'Public Approver (Publisher)';
			update approver[0];
			
			// deletes
			delete author[0];
			
			// update roles
			System.enqueueJob(new CH_ManagePSAndQueueToWGMemberAsynchQueue(author,author,'assign'));
			System.enqueueJob(new CH_ManagePSAndQueueToWGMemberAsynchQueue(author,approver,'update assign'));
			System.enqueueJob(new CH_ManagePSAndQueueToWGMemberAsynchQueue(author,approver,'update'));
			System.enqueueJob(new CH_ManagePSAndQueueToWGMemberAsynchQueue(approver,approver,'remove'));
			
			//Tests for CH_EM_WorkgroupMember
			CH_EM_WorkgroupMember.doInsertCHWorkgroupMemberList([Select id from CH_Workgroup_Member__c where CH_Role__c='Author']);
			CH_EM_WorkgroupMember.doUpdateCHWorkgroupMemberList([Select id from CH_Workgroup_Member__c where CH_Role__c='Author']);
			CH_EM_WorkgroupMember.doDeleteCHWorkgroupMemberList([Select id from CH_Workgroup_Member__c where CH_Role__c='Author']);
			
			//Tests for CH_EM_Workgroup
			CH_EM_Workgroup.doInsertCHWorkgroupList(workgroupList);
			CH_EM_Workgroup.doUpdateCHWorkgroupList(workgroupList);
			CH_EM_Workgroup.doDeleteCHWorkgroupList(workgroupList);
			
			Test.stopTest();
		}
	}
	
}