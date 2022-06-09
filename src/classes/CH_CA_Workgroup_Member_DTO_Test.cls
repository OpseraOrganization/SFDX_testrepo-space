/* Type:  Apex Class
* Name - CH_CA_Workgroup_Member_DTO_Test
* Description - This class is used to test CH_CA_Workgroup_Member_DTO Apex Class.
* Developer: TCS
* */
@isTest
public class CH_CA_Workgroup_Member_DTO_Test {
	@testSetup   
	static void setuptestdata(){  
		CH_UTIL_TEST.setupCase(false);
	}
		
	//testCH_CA_Workgroup_Member_DTO for Schedule for single parameter constructor
	@istest
	static void testCH_CA_Workgroup_Member_DTOWithSetWgIds(){
		Test.startTest();
		CH_UTIL_TEST.createWorkgroupSchedules();
		Test.stopTest();

		CH_Workgroup__c wg = [SELECT Id,Name FROM CH_Workgroup__c WHERE Name= : CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];
		set<Id> setWorkgroupIDs = new set<Id>();
		setWorkgroupIDs.add(wg.Id);
		
		//When custom setting is schedule
		CH_CA_Workgroup_Member_DTO memberDetails = new CH_CA_Workgroup_Member_DTO (setWorkgroupIDs);
		System.assert(memberDetails.mapAllWorkgroupSchedules.size() == 1, 'Expected 1. Actual ' + memberDetails.mapAllWorkgroupSchedules.size());		
	}
}