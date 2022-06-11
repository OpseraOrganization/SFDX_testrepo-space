//Create teast class for  CH_CA_Time_Recording_Controller
@isTest
public class CH_CA_Time_Recording_Controller_Test {

	public Static final String testStr1='TEST1';
	public Static final String testStr6='TEST6';	
	public Static final String SeverityStr='Minor';
	public static final String severitymajorStr='Major';
	public Static final String OutageStr='No';
	public Static final String recodtypedevname='CH_NokiaStandardCase';
	public static final String assertMessage='Expect message . Actual ';
	public static final String ownerstrn='Owner';
 
	
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
		Case newCase = CH_UTIL_TEST.createCaseNotSaved(testStr1, SeverityStr, OutageStr, recodtypedevname, false); 
		insert newCase;
		
		returnMsg=CH_CA_Time_Recording_Controller.checkAddTimeButtonApplicability(newCase.Id);
		Test.stopTest(); 
		System.assert(returnMsg == true,assertMessage + returnMsg);	  
	}
	//test getUserRole
	@isTest
	public static void getUserRole()
	{
		List< String> role = new List<String>();	  
		Test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved(testStr1, SeverityStr, OutageStr, recodtypedevname, false); 
		insert newCase;
		role=CH_CA_Time_Recording_Controller.getUserRole(newCase.Id);
		Test.stopTest(); 
		System.assert(role.size() == 0,assertMessage + role.size());	  
	}
	@isTest
	public static void getUserRoleCaseTeamMember()
	{
		List< String> role = new List<String>();	  
		Test.startTest();
		Case testCase = CH_UTIL_TEST.createCaseNotSaved(testStr1, SeverityStr, OutageStr, recodtypedevname, false);
		insert testCase;
		String UserId = UserInfo.getUserId();
		CH_CA_CaseTeamAssignment_Controller.InsertMember(UserId,testCase.Id,'Incident Engineer');
		role=CH_CA_Time_Recording_Controller.getUserRole(testCase.Id);
		Test.stopTest(); 
		System.assert(role.size() == 1,assertMessage + role.size());	  
	}
	@isTest
	public static void saveTimeRecording_test()

	{
		
		try{
	
			Test.startTest();
			Case newCase = CH_UTIL_TEST.createCaseNotSaved(testStr1, severitymajorStr, OutageStr, recodtypedevname, false); 
			insert newCase;
			CH_CA_Time_Recording_Controller.saveTimeRecording(newCase.Id,ownerstrn,2,10,string.valueOf(datetime.now()));
			
			List<CH_TimeRecording__c> listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
			Test.stopTest();
			System.assert(listTimeRecording.size() == 1,assertMessage + listTimeRecording.size());	 
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	@isTest
	public static void saveTimeRecordingValidation_test()

	{
		try{
			
			Test.startTest();
			Case newCase = CH_UTIL_TEST.createCaseNotSaved(testStr1, severitymajorStr, OutageStr, recodtypedevname, false); 
			insert newCase;
			
			CH_CA_Time_Recording_Controller.saveTimeRecording(newCase.Id,'',2,10,string.valueOf(datetime.now()));
			Test.stopTest();	
			List<CH_TimeRecording__c> listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
			System.assert(listTimeRecording.size() == 0,assertMessage + listTimeRecording.size());	
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	@isTest
	public static void saveTimeRecordingDMLExceptions_test()
	{
		try{
			
			Test.startTest();
			Case newCase = CH_UTIL_TEST.createCaseNotSaved(testStr1, severitymajorStr, OutageStr, recodtypedevname, false); 
			insert newCase;
			string year = '2019';
			string month = '10';
			string day = '5';
			string hour = '12';
			string minute = '20';
			string second = '20';
			string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' 
	+ minute +  ':' + second;
			
			Datetime myDate = Datetime.valueOf(stringDate);
			
			CH_CA_Time_Recording_Controller.saveTimeRecording(newCase.Id,ownerstrn,2,10,string.valueOf(myDate));
			Test.stopTest();	
			List<CH_TimeRecording__c> listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
			System.assert(listTimeRecording.size() == 0,assertMessage + listTimeRecording.size());	
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	@isTest
	public static void deleteTimeRecording_test()
	{
		try{
			
			Test.startTest();	
			Case newCase = CH_UTIL_TEST.createCaseNotSaved(testStr1, severitymajorStr, OutageStr, recodtypedevname, false); 
			insert newCase;
			CH_CA_Time_Recording_Controller.saveTimeRecording(newCase.Id,ownerstrn,2,10,string.valueOf(datetime.now()));		
			List<CH_TimeRecording__c> listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
			System.assert(listTimeRecording.size() == 1,assertMessage + listTimeRecording.size());	
			List<CH_TimeRecording__c> deletListTimeRecording=[SELECT Id
	 FROM CH_TimeRecording__c 
	 WHERE CH_SupportTicketNumber__c =: newCase.Id];
			delete deletListTimeRecording;
			listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyId(newCase.Id);
			System.assert(listTimeRecording.size() == 0,assertMessage + listTimeRecording.size());	
			Test.stopTest();
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	@isTest
	public static void editTimeRecording_test()
	{
		try{
		
			Test.startTest();
			Case newCase = CH_UTIL_TEST.createCaseNotSaved(testStr6, severitymajorStr, OutageStr, recodtypedevname, false); 
			insert newCase;			
			CH_CA_Time_Recording_Controller.saveTimeRecording(newCase.Id,ownerstrn,2,10,string.valueOf(datetime.now()));
			
			List<CH_TimeRecording__c> listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
			if (listTimeRecording.size()>0){
	CH_CA_Time_Recording_Controller.editTimeRecording(listTimeRecording[0].Id,ownerstrn,2,15,string.valueOf(datetime.now()));	
			}
			Test.stopTest();
			System.assert(listTimeRecording.size() == 1,assertMessage + listTimeRecording.size());	 
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	@isTest
	public static void editTimeRecordingValidation_test()
	{
		
		try{
			Test.startTest();
			Case newCase = CH_UTIL_TEST.createCaseNotSaved(testStr6, severitymajorStr, OutageStr, recodtypedevname, false); 
			insert newCase;			
			CH_CA_Time_Recording_Controller.saveTimeRecording(newCase.Id,ownerstrn,2,10,string.valueOf(datetime.now()));
			Test.stopTest();
			List<CH_TimeRecording__c> listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
			
			if (listTimeRecording.size()>0){
	CH_CA_Time_Recording_Controller.editTimeRecording(listTimeRecording[0].Id,'',2,15,string.valueOf(datetime.now()));	
			}
			listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
			
			System.assert(listTimeRecording.size() == 0,assertMessage + listTimeRecording.size());		
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	//Ref:NOKIASC-36264 Validate Hours & Minutes test method
	@isTest
	public static void editTimeRecordingHourMinValidation_test()
	{
		
		try{
			Test.startTest();
			Case newCase = CH_UTIL_TEST.createCaseNotSaved(testStr6, severitymajorStr, OutageStr, recodtypedevname, false); 
			insert newCase;			
			CH_CA_Time_Recording_Controller.saveTimeRecording(newCase.Id,ownerstrn,2,10,string.valueOf(datetime.now()));
			Test.stopTest();
			List<CH_TimeRecording__c> listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
			
			if (listTimeRecording.size()>0){
			  CH_CA_Time_Recording_Controller.editTimeRecording(listTimeRecording[0].Id,ownerstrn,0,0,string.valueOf(datetime.now()));	
			}
			listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
			
			System.assert(listTimeRecording.size() == 0,assertMessage + listTimeRecording.size());		
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	@isTest
	public static void editTimeRecordingDMLException_test()
	{
		
		try{
	string year = '2019';
			string month = '10';
			string day = '5';
			string hour = '12';
			string minute = '20';
			string second = '20';
			string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' 
	+ minute +  ':' + second;
			
			Datetime myDate = Datetime.valueOf(stringDate);
			Test.startTest();
			Case newCase = CH_UTIL_TEST.createCaseNotSaved(testStr6, severitymajorStr, OutageStr, recodtypedevname, false); 
			insert newCase;			
			CH_CA_Time_Recording_Controller.saveTimeRecording(newCase.Id,ownerstrn,2,10,string.valueOf(datetime.now()));
			
			List<CH_TimeRecording__c> listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
			
			if (listTimeRecording.size()>0){
	CH_CA_Time_Recording_Controller.editTimeRecording(listTimeRecording[0].Id,ownerstrn,2,15,string.valueOf(myDate));	
			}
			listTimeRecording=CH_CA_Time_Recording_Controller.getTimeRecordingListbyCaseId(newCase.Id);
			Test.stopTest();
			System.assert(listTimeRecording.size() == 0,assertMessage + listTimeRecording.size());		
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
}