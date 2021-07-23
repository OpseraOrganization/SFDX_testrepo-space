@isTest
public class CH_CA_Workgroup_Instructions_Cntrl_TEST {
	
	public static Profile profile;
	public static User dataLoaderUser;
	
	// Test that for a case the workgroup instructions are retrieved from the assigned workgroup
	@isTest(SeeAllData=true)
	static void TestGetWorkgroupInstructionsAssingedCase(){
		profile = [Select Id from Profile where name = 'Data Loader Profile' LIMIT 1];
		
		dataLoaderUser = new User(
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
			CH_UTIL_TEST.setupCase(false);
		}
		test.starttest();
		// Setup a new case that has not been assigned so no workgroup
		Case newCaseCreation = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
		Id getCHCAWorkgroupRecordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByName().get('CH_CA_Workgroup').getRecordTypeId();
		CH_Workgroup__c getCaseWorkgroup = [select id, Name, RecordTypeId from CH_Workgroup__c where name=:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];
		getCaseWorkgroup.RecordTypeId = getCHCAWorkgroupRecordTypeId; //replacing the exisitng workgroup's record type by CH_CA_Workgroup record type
		update getCaseWorkgroup;
		newCaseCreation.CH_Workgroup__c = getCaseWorkgroup.Id;
		insert newCaseCreation;
		CH_WorkgroupInstructions__c workGroupInstructions = new CH_WorkgroupInstructions__c(CH_Workgroup__c = getCaseWorkgroup.Id , CH_Active__c = TRUE, CH_AssignmentType__c = 'Passive', CH_Severity__c = 'Minor');
		insert workGroupInstructions;
		newCaseCreation = [SELECT Id, CH_Workgroup__c FROM Case WHERE Id =:newCaseCreation.Id];
		// Get the workgroup instructions of the workgroup from the first found rule
		CH_WorkgroupInstructions__c foundWorkgroup = CH_CA_Workgroup_Instructions_Controller.getWorkgroupInstructions(newCaseCreation.Id,newCaseCreation.CH_Workgroup__c,'');
		CH_CA_Workgroup_Instructions_Controller.requestAssistanceToWG(newCaseCreation.Id, getCaseWorkgroup.Name);
		Case worgroupDetailsCase = CH_CA_Workgroup_Instructions_Controller.getWorkgroupDetails(newCaseCreation.Id);
		test.stopTest();
		
	}
	
	@isTest
	static void testAccessCheckWGInstructionsblank(){
		test.starttest();		
		Boolean retrunValue=CH_CA_Workgroup_Instructions_Controller.accessCheckWGInstructions(null);
		test.stopTest();
		
	}
	@isTest
	public static void testAccessCheckWGInstructionException()
	{
		Boolean returnMsg;	
		try{
			test.starttest();		
			Boolean retrunValue=CH_CA_Workgroup_Instructions_Controller.accessCheckWGInstructions('abc');
			test.stopTest();
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
}