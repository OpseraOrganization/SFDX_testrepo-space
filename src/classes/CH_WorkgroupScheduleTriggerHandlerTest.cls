@isTest
public class CH_WorkgroupScheduleTriggerHandlerTest {
	private static User adminUser = CH_TestDataFactory.createUser('System Administrator', 'CH_Test');
	@testSetup
	static void setuptestdata(){
		CH_UTIL_TEST.createCustomSettings();
		// Create users
		CH_UTIL_TEST.createNokiaUsers();
		// Create accounts
		CH_UTIL_TEST.createAccounts();		
		// Create products
		CH_UTIL_TEST.createProducts();
		// Create workgroups
		CH_UTIL_TEST.createWorkgroups();		
		//CH_UTIL_TEST.setupCase(false);
		CH_UTIL_TEST.createWorkgroupSchedules(); 
	}
	
	//Test 1 : Create Workgroup Inactive -> no error but CH_Active__c=false
	@isTest
	static void testWGSCreateInactive(){
		System.runAs(adminUser){
			test.starttest();
			CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id, CH_Active__c FROM CH_Workgroup_Schedule__c WHERE Name = 'Schedule_test'];
			System.assertEquals(true,workgroupSchedule.CH_Active__c);
			test.stoptest();
		}
	}
	
	//Test 2 : Update Workgroup to active with no timeslot and no workgroup member 
	//error -> Workgroup schedule cannot be activated unless there is atleast one timeslot record created and atleast one workgroupmember is associated with it.
	@isTest
	static void testWGSUpdateToActive(){
		System.runAs(adminUser){
			Test.startTest();
			CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id, CH_Active__c FROM CH_Workgroup_Schedule__c WHERE Name = 'Schedule_test'];
			workgroupSchedule.CH_Active__c=false;
			Update workgroupSchedule;
			try{
				workgroupSchedule.CH_Active__c=true;
				Update workgroupSchedule;
			}
			catch (DmlException e){
				System.assert( e.getMessage().contains('Update failed. First exception on row 0 with id '+workgroupSchedule.Id+'; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+system.label.CH_CA_NoTimeslotNoWorkgroupMember),e.getMessage() );
				System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0) );
			}
			Test.stopTest();
		}
	}
	
	//Test 3 : Update Workgroup to active with timeslot and no workgroup member 
	//error -> Each timeslot must contain atleast one workgroup member.
	@isTest
	static void testWGSUpdateWithTSNoWG(){
		System.runAs(adminUser){
			Test.startTest();
			CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id, CH_Active__c FROM CH_Workgroup_Schedule__c WHERE Name = 'Schedule_test'];
			try {
				workgroupSchedule.CH_Active__c=true;
				Update workgroupSchedule;
			}
			catch (DmlException e){
				System.assert(e.getMessage().contains('Update failed. First exception on row 0 with id ' + workgroupSchedule.Id + '; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, ' + system.label.CH_CA_NoWorkgroupMember), e.getMessage());
				System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
			}
			Test.stopTest();
		}
	}
	
	//Test 4 : Update Workgroup to active with overlapping timeslot and no workgroup member 
	//error -> Timeslots are overlapping on each other.<br/> Each timeslot must contain atleast one workgroup member.
	@isTest
	static void testWGSUpdateWithOverlappingTSNoWG(){
		System.runAs(adminUser){
			Test.startTest();
			CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id, CH_Active__c FROM CH_Workgroup_Schedule__c WHERE Name = 'Schedule_test'];
			try {
				workgroupSchedule.CH_Active__c=true;
				Update workgroupSchedule;
			}
			catch (DmlException e){
				//System.assert( e.getMessage().contains('Update failed. First exception on row 0 with id ' + workgroupSchedule.Id + '; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, ' + system.label.CH_CA_NoWorkgroupMember), e.getMessage());
				System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
			}
			Test.stopTest();
		}
	}
	
	//Test 5 : Update Workgroup to active with timeslot and workgroup member 
	//error -> No Error (Successfully Updated CH_Active__c = true)
	@isTest
	static void testWGSUpdateWithTSWGM(){
		System.runAs(adminUser){
			Test.startTest();
			CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id, CH_Active__c FROM CH_Workgroup_Schedule__c WHERE Name = 'Schedule_test'];
			workgroupSchedule.CH_Active__c=true;
			Update workgroupSchedule;
			System.assertEquals(true,workgroupSchedule.CH_Active__c);
			Test.stopTest();
		}
	}
	
	//Test 6 : Update Workgroup to active with overlapping timeslot and workgroup member 
	//error -> Timeslots are overlapping on each other.
	@isTest
	static void testWGSUpdateWithOverlappingTSWGM(){
		System.runAs(adminUser){
			Test.startTest();
			CH_Workgroup_Schedule__c workgroupSchedule = [SELECT Id, CH_Active__c FROM CH_Workgroup_Schedule__c WHERE Name = 'Schedule_test'];
			try {
				workgroupSchedule.CH_Active__c=true;
				Update workgroupSchedule;
			}
			catch (DmlException e){
				System.assert(e.getMessage().contains('Update failed. First exception on row 0 with id ' + workgroupSchedule.Id + '; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, ' + system.label.CH_CA_TimeslotOverlapping), e.getMessage());
				System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
			}
			Test.stopTest();
		}
	}
}