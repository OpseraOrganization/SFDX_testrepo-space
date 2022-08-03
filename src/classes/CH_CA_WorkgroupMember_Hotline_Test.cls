/* Type:  Test Class
 * Name - CH_CA_WorkgroupMember_Hotline_Test
 * Description - This class is used to test CH_CA_WorkgroupMember_Hotline_controller apex controller
 * Date: 28-02-2019
 * */
@isTest
public class CH_CA_WorkgroupMember_Hotline_Test {
	@testSetup
	static void setuptestdata(){
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		//Created workgroup
		CH_Workgroup__c wg = new CH_Workgroup__c();
		wg.Name='testforHotlineMember';
		wg.CH_Level_Of_Support__c= 'Initial Support';
		wg.CH_Type__c = 'Engineer';
		wg.CH_Start_of_Business_Hours_Threshold__c=60;
		wg.CH_End_of_Business_Hours_Threshold__c=60;
		insert wg;
	}
	static testMethod void testInsertMemberwithValidWorkgroup(){  
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		CH_Workgroup__c wg = [SELECT Id FROM CH_Workgroup__c WHERE Name='testforHotlineMember' LIMIT 1];
		CH_Workgroup_Member__c newMem= new CH_Workgroup_Member__c();
		newMem.CH_Hotline_Name__c = 'test';
		newMem.CH_Description__c= 'test';
		newMem.CH_HotlinePhone__c='111222221212';
		newMem.CH_Workgroup__c = wg.Id;
		test.startTest();
		CH_CA_WorkgroupMember_Hotline_controller.saveHotlineMember(newMem);		
		test.stopTest();
	}
	
	static testMethod void testInsertMemberwithInValidWorkgroup(){  
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		//to cover catch statement this method has been written
		CH_Workgroup__c wg = [SELECT Id FROM CH_Workgroup__c WHERE Name='testforHotlineMember' LIMIT 1];
		CH_Workgroup_Member__c newMem= new CH_Workgroup_Member__c();
		newMem.CH_Hotline_Name__c = 'test';
		newMem.CH_Description__c= 'test';
		newMem.CH_HotlinePhone__c='111222221212';
		newMem.CH_Workgroup__c = null;
		test.startTest();
		try {
			CH_CA_WorkgroupMember_Hotline_controller.saveHotlineMember(newMem);
		} catch (AuraHandledException e) {
			system.debug('msg'+e.getMessage());
			system.assertEquals('Script-thrown exception', e.getMessage());
		}	
		test.stopTest();
	}
}