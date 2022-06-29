/* Type:  Test Class
* Name - CH_WorkgroupMember_Trigger_Handler_Test
* Description - This class is used to test CH_WorkgroupMember_Trigger_Handler apex class
* Developer: TCS
* */
@isTest 
private class CH_WorkgroupMember_Trigger_Handler_Test {
	private static User adminUser = CH_TestDataFactory.createUser('System Administrator', 'CH_Test');
	@testSetup
	static void setuptestdata(){
		CH_UTIL_TEST.setupCase(false);
	}
	//Test Method For CH_WorkgroupMember_Trigger_Handler Ref: NOKIASC-34961
	static testMethod void testValidateQueueBeforeDeletion(){
		test.startTest();
		try
		{
			CH_Workgroup__c workgroup = [SELECT Id FROM CH_Workgroup__c LIMIT 1];
			id CH_CA_Workgroup = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByDeveloperName().get('CH_CA_WorkgroupMember').getRecordTypeId();
			CH_Workgroup_Member__c oWorkgroupMember = new CH_Workgroup_Member__c();
			oWorkgroupMember.Name = 'TEST_QUEUE';
			oWorkgroupMember.CH_Role__c = 'Queue';
			oWorkgroupMember.CH_Workgroup_Member_Type__c = 'Queue';
			oWorkgroupMember.CH_Workgroup__c = workgroup.Id;
			oWorkgroupMember.RecordTypeId = CH_CA_Workgroup;
			insert oWorkgroupMember;
			Map<Id,CH_Workgroup_Member__c> oldWorkgroupMembersMap = new Map<Id,CH_Workgroup_Member__c>();
			oldWorkgroupMembersMap.put(oWorkgroupMember.Id, oWorkgroupMember);   
			CH_WorkgroupMember_Trigger_Handler.validateQueueBeforeDeletion(new List<CH_Workgroup_Member__c>{oWorkgroupMember},null,oldWorkgroupMembersMap,'delete');
			new CH_WorkgroupMember_Trigger_Handler().validateBeforeDeletion(new List<CH_Workgroup_Member__c>{oWorkgroupMember});
		}
		catch(Exception e)
		{   
			System.assert(e.getMessage()!=null);
		}
		test.stopTest();
	}
	static testMethod void testValidateQueueBeforeUpdation(){
		test.startTest();
		try
		{
			CH_Workgroup__c workgroup = [SELECT Id FROM CH_Workgroup__c LIMIT 1];
			id CH_CA_Workgroup = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByDeveloperName().get('CH_CA_WorkgroupMember').getRecordTypeId();
			CH_Workgroup_Member__c oWorkgroupMember = new CH_Workgroup_Member__c();
			oWorkgroupMember.Name = 'TEST_QUEUE';
			oWorkgroupMember.CH_Role__c = 'Queue';
			oWorkgroupMember.CH_Workgroup_Member_Type__c = 'Queue';
			oWorkgroupMember.CH_Workgroup__c = workgroup.Id;
			oWorkgroupMember.RecordTypeId = CH_CA_Workgroup;
			insert oWorkgroupMember;
			Map<Id,CH_Workgroup_Member__c> oldWorkgroupMembersMap = new Map<Id,CH_Workgroup_Member__c>();
			oldWorkgroupMembersMap.put(oWorkgroupMember.Id, oWorkgroupMember); 
			oWorkgroupMember.CH_Workgroup_Member_Type__c = 'User';
			CH_WorkgroupMember_Trigger_Handler.validateQueueBeforeDeletion(new List<CH_Workgroup_Member__c>{oWorkgroupMember},new List<CH_Workgroup_Member__c>{oWorkgroupMember},oldWorkgroupMembersMap,'update');
			
		}
		catch(Exception e)
		{
			System.assert(e.getMessage()!=null);
		}
		test.stopTest();
	}
	
	static testMethod void testValidateWorkgroupRuleDeletion(){
		Test.StartTest();
		List<CH_Workgroup_Rule__c> workgroupRule = [SELECT Id FROM CH_Workgroup_Rule__c LIMIT 1];
		System.assert(workgroupRule.size() == 1,'Expected 1 , Actual:'+workgroupRule.size());
		Delete workgroupRule;
		Test.StopTest();
		
	}
	
	static testMethod void testKbWorkgroupMemberBeforeUpdation(){
		test.startTest();
		try
		{
			// Create Workgroup
			CH_ManageCreateQueueAsynchQueue.doChainJob = false;
			CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
			Id workgroupRecordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByDeveloperName().get('CH_KB_Workgroup').getRecordTypeId();
			CH_Workgroup__c workgroup = new CH_Workgroup__c();
			workgroup.name = 'TEST';
			workgroup.RecordTypeId = workgroupRecordTypeId;
			workgroup.CH_Workgroup_Instructions__c = 'This is a workgroup instruction';
			workgroup.CH_Type__c = 'Engineer;Smart Tier 1';
			insert workgroup;
			// Create User		
			User testUser = TestDataFactory.createUser('Nokia Sales Profile','TestUser');
			insert testUser;
			// Create Workgroup Member
			Id workgroupMemberRT = Utils.MapRecordType('CH_Workgroup_Member__c').get('CH_KB_Workgroup_Members');
			CH_Workgroup_Member__c oWorkgroupMember = new CH_Workgroup_Member__c();
			oWorkgroupMember.Name = 'TEST_QUEUE';
			oWorkgroupMember.CH_Role__c = 'Author';
			oWorkgroupMember.CH_Workgroup_Member_Type__c = 'User';
			oWorkgroupMember.CH_Workgroup__c = workgroup.Id;
			oWorkgroupMember.RecordTypeId = workgroupMemberRT;
			oWorkgroupMember.CH_User__c = testUser.Id;
			oWorkgroupMember.CH_Owner__c = true;
			insert oWorkgroupMember;
			// Update Workgroup Member Role to 'Internal Approver (Approver)'
			oWorkgroupMember.CH_Role__c = 'Internal Approver (Approver)';		
			update oWorkgroupMember;
			// Update Workgroup Member Role to 'Public Approver (Publisher)'
			oWorkgroupMember.CH_Role__c = 'Public Approver (Publisher)';
			update oWorkgroupMember;
			// Update Workgroup Member Role to 'Author'
			oWorkgroupMember.CH_Role__c = 'Author';
			update oWorkgroupMember;
		}
		catch(Exception e)
		{
			System.assert(e.getMessage()!=null);
		}
		test.stopTest();
	}
	
	static testMethod void testKbWorkgroupMemberBeforeDeletion(){
		test.startTest();
		try
		{
			// Create Workgroup
			CH_ManageCreateQueueAsynchQueue.doChainJob = false;
			CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
			Id workgroupRecordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByDeveloperName().get('CH_KB_Workgroup').getRecordTypeId();
			CH_Workgroup__c workgroup = new CH_Workgroup__c();
			workgroup.name = 'TEST';
			workgroup.RecordTypeId = workgroupRecordTypeId;
			workgroup.CH_Workgroup_Instructions__c = 'This is a workgroup instruction';
			workgroup.CH_Type__c = 'Engineer;Smart Tier 1';
			insert workgroup;
			// Create User
			User testUser = TestDataFactory.createUser('Nokia Sales Profile','TestUser');
			insert testUser;
			// Create Workgroup Members
			Id workgroupMemberRT = Utils.MapRecordType('CH_Workgroup_Member__c').get('CH_KB_Workgroup_Members');
			List<CH_Workgroup_Member__c> listWorkgroupMembers = new List<CH_Workgroup_Member__c>();
			CH_Workgroup_Member__c oWorkgroupMember1 = new CH_Workgroup_Member__c();
			oWorkgroupMember1.Name = 'TEST_QUEUE';
			oWorkgroupMember1.CH_Role__c = 'Author';
			oWorkgroupMember1.CH_Workgroup_Member_Type__c = 'User';
			oWorkgroupMember1.CH_Workgroup__c = workgroup.Id;
			oWorkgroupMember1.RecordTypeId = workgroupMemberRT;
			oWorkgroupMember1.CH_User__c = testUser.Id;
			oWorkgroupMember1.CH_Owner__c = true;
			listWorkgroupMembers.add(oWorkgroupMember1);
			CH_Workgroup_Member__c oWorkgroupMember2 = new CH_Workgroup_Member__c();
			oWorkgroupMember2.Name = 'TEST_QUEUE';
			oWorkgroupMember2.CH_Role__c = 'Internal Approver (Approver)';
			oWorkgroupMember2.CH_Workgroup_Member_Type__c = 'User';
			oWorkgroupMember2.CH_Workgroup__c = workgroup.Id;
			oWorkgroupMember2.RecordTypeId = workgroupMemberRT;
			oWorkgroupMember2.CH_User__c = testUser.Id;
			oWorkgroupMember2.CH_Owner__c = true;
			listWorkgroupMembers.add(oWorkgroupMember2);
			CH_Workgroup_Member__c oWorkgroupMember3 = new CH_Workgroup_Member__c();
			oWorkgroupMember3.Name = 'TEST_QUEUE';
			oWorkgroupMember3.CH_Role__c = 'Public Approver (Publisher)';
			oWorkgroupMember3.CH_Workgroup_Member_Type__c = 'User';
			oWorkgroupMember3.CH_Workgroup__c = workgroup.Id;
			oWorkgroupMember3.RecordTypeId = workgroupMemberRT;
			oWorkgroupMember3.CH_User__c = testUser.Id;
			oWorkgroupMember3.CH_Owner__c = true;
			listWorkgroupMembers.add(oWorkgroupMember3);
			insert listWorkgroupMembers;
			// Update Assign Workgroup Members
			System.enqueueJob(new CH_ManagePSAndQueueToWGMemberAsynchQueue(listWorkgroupMembers,listWorkgroupMembers,'update assign'));
			// Delete Workgroup Members
			delete listWorkgroupMembers;		
		}
		catch(Exception e)
		{
			System.assert(e.getMessage()!=null);
		}
		test.stopTest();
	}
}