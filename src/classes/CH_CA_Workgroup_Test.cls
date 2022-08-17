@isTest
public class CH_CA_Workgroup_Test { 
	@testSetup
	static void setuptestdata()
	{
		//run as dataload user
		Profile profile = [Select Id from Profile where name = 'Data Loader Profile' LIMIT 1];
			
			User dataLoaderUser = new User(
	Lastname='DataLoad',
	Firstname='USER',
	Alias = 'DL-OWNER',
	ProfileId = profile.Id,
	Username = System.now().millisecond() + 'DL-OWNER@test.com',
	Email= System.now().millisecond() + 'test2@test.com',
	EmailEncodingKey='UTF-8',
	LanguageLocaleKey='en_US',
	LocaleSidKey='en_US',
	TimeZoneSidKey='America/Chicago',
	Nokia_ID__c = 'CHTEST100'
			);
		system.runAs(dataLoaderUser){
		
		insert new Global_Control__c(ObjectTriggerByPass__c='ACCT,CNTCT,ACC_CNTCT_REL,USER,SVCNTRT,ASSET,PRODUCT,CLI,ENT');
		
		CH_UTIL_TEST.setupCase(false);
		}
	}

	@isTest
	static void testCreateCaseAssignmentObjectProblem(){
		test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1Workgroup', 'Minor', 'No', 'CH_Problem', false);
		insert newCase;
		CH_CA_Assignment_Criteria_DTO caseAssignmentDetails = new CH_CA_Assignment_Criteria_DTO();
		CH_CA_Workgroup wg = new CH_CA_Workgroup();
		caseAssignmentDetails = wg.CreateCaseAssignmentObject(newCase.Id);
		test.stopTest();
		
		System.assert(caseAssignmentDetails.customerId == null, 'Expected null. Actual ' + caseAssignmentDetails.customerId);		
	}

}