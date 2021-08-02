//Create teast class for  CH_CA_Time_Recording_Controller
@isTest
public class CH_CA_Time_Recording_Controller_Test {
	
	@testSetup
	public static void setup(){
		CH_UTIL_TEST.setupCase(false);	 
	} 
	//test checkAddTimeButtonApplicability
	@isTest
	public static void checkAddTimeButtonApplicability()
	{
		Boolean returnMsg;		
		Test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false); 
		insert newCase;
		
		returnMsg=CH_CA_Time_Recording_Controller.checkAddTimeButtonApplicability(newCase.Id);
		Test.stopTest(); 
		System.assert(returnMsg == true,'Expect message . Actual ' + returnMsg);	  
	}
	//test getUserRole
	@isTest
	public static void getUserRole()
	{
		List< String> role = new List<String>();	  
		Test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false); 
		insert newCase;
		role=CH_CA_Time_Recording_Controller.getUserRole(newCase.Id);
		Test.stopTest(); 
		System.assert(role.size() == 0,'Expect message . Actual ' + role.size());	  
	}
	@isTest
	public static void getUserRoleCaseTeamMember()
	{
		List< String> role = new List<String>();	  
		Test.startTest();
		Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
		insert testCase;
		String UserId = UserInfo.getUserId();
		CH_CA_CaseTeamAssignment_Controller.InsertMember(UserId,testCase.Id,'Incident Engineer');
		role=CH_CA_Time_Recording_Controller.getUserRole(testCase.Id);
		Test.stopTest(); 
		System.assert(role.size() == 1,'Expect message . Actual ' + role.size());	  
	}
	@isTest
	public static void saveTimeRecording_test()
	{
		Boolean returnMsg;	
		Test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Major', 'No', 'Nokia Standard Case', false); 
		insert newCase;
		CH_CA_Time_Recording_Controller.saveTimeRecording(newCase.Id,'Owner',2,10);
		Test.stopTest();
		List<CH_TimeRecording__c> listTimeRecording1=CH_CA_Time_Recording_Controller.getTimeRecordingListbyId(newCase.Id);
		List<CH_TimeRecording__c> listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
		System.assert(listTimeRecording.size() == 1,'Expect message . Actual ' + listTimeRecording.size());	  
	}
	@isTest
	public static void saveTimeRecordingValidation_test()
	{
		try{
			Boolean returnMsg;	
			Test.startTest();
			Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Major', 'No', 'Nokia Standard Case', false); 
			insert newCase;
			CH_CA_Time_Recording_Controller.saveTimeRecording(newCase.Id,'',2,10);
			Test.stopTest();	   
			List<CH_TimeRecording__c> listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
			System.assert(listTimeRecording.size() == 0,'Expect message . Actual ' + listTimeRecording.size());	
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	@isTest
	public static void deleteTimeRecording_test()
	{
		Boolean returnMsg;	
		Test.startTest();	
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Major', 'No', 'Nokia Standard Case', false); 
		insert newCase;
		CH_CA_Time_Recording_Controller.saveTimeRecording(newCase.Id,'Owner',2,10);		
		List<CH_TimeRecording__c> listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
		System.assert(listTimeRecording.size() == 1,'Expect message . Actual ' + listTimeRecording.size());	
		List<CH_TimeRecording__c> deletListTimeRecording=[SELECT Id
														  FROM CH_TimeRecording__c 
														  WHERE CH_SupportTicketNumber__c =: newCase.Id];
		delete deletListTimeRecording;
		listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyId(newCase.Id);
		System.assert(listTimeRecording.size() == 0,'Expect message . Actual ' + listTimeRecording.size());	
		Test.stopTest();	 
	}
	@isTest
	public static void editTimeRecording_test()
	{
		Boolean returnMsg;	
		Test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST6', 'Major', 'No', 'Nokia Standard Case', false); 
		insert newCase;			
		CH_CA_Time_Recording_Controller.saveTimeRecording(newCase.Id,'Owner',2,10);
		Test.stopTest();
		List<CH_TimeRecording__c> listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
		if (listTimeRecording.size()>0){
			CH_CA_Time_Recording_Controller.editTimeRecording(listTimeRecording[0].Id,'Owner',2,15);	
		}
		System.assert(listTimeRecording.size() == 1,'Expect message . Actual ' + listTimeRecording.size());	  
	}
	@isTest
	public static void editTimeRecordingValidation_test()
	{
		Boolean returnMsg;	
		try{
			Test.startTest();
			Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST6', 'Major', 'No', 'Nokia Standard Case', false); 
			insert newCase;			
			CH_CA_Time_Recording_Controller.saveTimeRecording(newCase.Id,'Owner',2,10);
			Test.stopTest();
			List<CH_TimeRecording__c> listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
			
			if (listTimeRecording.size()>0){
				CH_CA_Time_Recording_Controller.editTimeRecording(listTimeRecording[0].Id,'',2,15);	
			}
			listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
			
			System.assert(listTimeRecording.size() == 0,'Expect message . Actual ' + listTimeRecording.size());		
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
}