/***************************************************************
* Class Name : CH_CA_Workgroup_WeightTest	test
* Created Date: 28 March 2020
* Description : Test class for CH_CA_Workgroup_Weight
***************************************************************/

@isTest
public class CH_CA_Workgroup_WeightTest {
	@isTest
	public static void wGScheduleTest(){ 	
		integer weight=20;
		CH_Workgroup_Schedule__c wgSchedule = new CH_Workgroup_Schedule__c();
		Test.startTest();
			CH_CA_Workgroup_Weight wrkWeight = new CH_CA_Workgroup_Weight(wgSchedule, weight);			
		Test.stopTest();	
	}
	
}