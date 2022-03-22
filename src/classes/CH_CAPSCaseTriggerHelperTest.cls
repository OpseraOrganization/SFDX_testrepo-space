//Test Class for Case Trigger
@IsTest
public class CH_CAPSCaseTriggerHelperTest {
	
	//Stup Data
	@testSetup
	public static void setup()
	{
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		CH_UTIL_TEST.setupCase(false);
	}
	
	
	/*public testMethod static void testWithsetup(){
		
		Test.startTest();
		case testCaseObj2 =CH_UTIL_TEST.createCaseNotSaved('Test', 'Minor', 'No', 'Problem', false);
		insert testCaseObj2;
		
		List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();//Service Provider End User Information
		chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Service Provider End User Information',testCaseObj2.Id)[0]);
		insert chAttchList;
		System.assertNotEquals(chAttchList.Size(), 0);
		
		
		testCaseObj2.Status = 'Root Cause Shared';
		testCaseObj2.Priority = 'Low';
		testCaseObj2.CH_CauseoftheIncident__c = 'Test';
		testCaseObj2.CH_SummaryofAnalysis__c = 'Test';
		testCaseObj2.CH_ListofContributingCauses__c = 'Test';
		testCaseObj2.CH_ValidationofRootCause__c = 'Test';
		testCaseObj2.CH_ProblemStatement__c = 'Test';
		testCaseObj2.CH_AssessedOutage__c = 'No';
		testCaseObj2.CH_SuspectedProblem__c = 'HW';
		testCaseObj2.CH_SolutionDetails__c = 'true';
		//testCaseObj2.CH_Article_Attached__c = true;
		Update testCaseObj2;
		
		testCaseObj2.Status = 'Solution Shared';
		Update testCaseObj2;
		

		
		Test.stopTest();
	}	
	
	public testMethod static void testWithsetup1(){
		
		Test.startTest();
		case testCaseObj2 =CH_UTIL_TEST.createCaseNotSaved('Test', 'Minor', 'No', 'Problem', false);
		insert testCaseObj2;
		
		List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();//Service Provider End User Information
		chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Other Information',testCaseObj2.Id)[0]);
		insert chAttchList;
		System.assertNotEquals(chAttchList.Size(), 0);
		
		testCaseObj2.Status = 'Root Cause Shared';
		testCaseObj2.Priority = 'Low';
		testCaseObj2.CH_CauseoftheIncident__c = 'Test';
		testCaseObj2.CH_SummaryofAnalysis__c = 'Test';
		testCaseObj2.CH_ListofContributingCauses__c = 'Test';
		testCaseObj2.CH_ValidationofRootCause__c = 'Test';
		testCaseObj2.CH_ProblemStatement__c = 'Test';
		testCaseObj2.CH_AssessedOutage__c = 'No';
		testCaseObj2.CH_SuspectedProblem__c = 'HW';
		testCaseObj2.CH_SolutionDetails__c = 'true';
		//testCaseObj2.CH_Article_Attached__c = true;
		Update testCaseObj2;
		
		testCaseObj2.Status = 'Solution Shared';
		Update testCaseObj2;
		

		
		Test.stopTest();
	}
		
	public testMethod static void test1(){
		
		Test.startTest();
		case testCaseObj2 =CH_UTIL_TEST.createCaseNotSaved('Test', 'Minor', 'No', 'Problem', false);
		insert testCaseObj2;
		
		List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();//Other Information
		chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Other Information',testCaseObj2.Id)[0]);
		insert chAttchList;
		System.assertEquals(chAttchList.Size(), 1);
		
		Test.setMock(HttpCalloutMock.class, new CAPS_DeleteMockHttpResponse());
		
		
		testCaseObj2.Status = 'Root Cause Shared';
		testCaseObj2.Priority = 'Low';
		testCaseObj2.CH_CauseoftheIncident__c = 'Test';
		testCaseObj2.CH_SummaryofAnalysis__c = 'Test';
		testCaseObj2.CH_ListofContributingCauses__c = 'Test';
		testCaseObj2.CH_ValidationofRootCause__c = 'Test';
		testCaseObj2.CH_ProblemStatement__c = 'Test';
		testCaseObj2.CH_AssessedOutage__c = 'No';
		testCaseObj2.CH_SuspectedProblem__c = 'HW';
		testCaseObj2.CH_SolutionDetails__c = 'true';
		//testCaseObj2.CH_Article_Attached__c = true;
		Update testCaseObj2;
		
		testCaseObj2.Status = 'Solution Shared';
		Update testCaseObj2;
		
	
		
		Test.StopTest();
		
	}
	public testMethod static void test11(){
		
		Test.startTest();
		case testCaseObj2 =CH_UTIL_TEST.createCaseNotSaved('Test', 'Minor', 'No', 'Problem', false);
		insert testCaseObj2;
		
		List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();//Other Information
		chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Service Provider End User Information',testCaseObj2.Id)[0]);
		insert chAttchList;
		System.assertEquals(chAttchList.Size(), 1);			 
		
		
		testCaseObj2.Status = 'Root Cause Shared';
		testCaseObj2.Priority = 'Low';
		testCaseObj2.CH_CauseoftheIncident__c = 'Test';
		testCaseObj2.CH_SummaryofAnalysis__c = 'Test';
		testCaseObj2.CH_ListofContributingCauses__c = 'Test';
		testCaseObj2.CH_ValidationofRootCause__c = 'Test';
		testCaseObj2.CH_ProblemStatement__c = 'Test';
		testCaseObj2.CH_AssessedOutage__c = 'No';
		testCaseObj2.CH_SuspectedProblem__c = 'HW';
		testCaseObj2.CH_SolutionDetails__c = 'true';
		//testCaseObj2.CH_Article_Attached__c = true;
		Update testCaseObj2;
		
		testCaseObj2.Status = 'Solution Shared';
		Update testCaseObj2;
		
		
		Test.setMock(HttpCalloutMock.class, new CAPS_DeleteMockHttpResponse());
		update testCaseObj2;
		Test.StopTest();
	}
		
	public testMethod static void test3(){
		system.runAs(new User(Id = UserInfo.getUserId())){
			
			test.startTest();
			
			List<String> chAttchIdList = new List<String>();
			case testCaseObj2 =CH_UTIL_TEST.createCaseNotSaved('Test', 'Minor', 'No', 'Problem', false);
			insert testCaseObj2;
			
			List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();//Other Information
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Service Provider End User Information',testCaseObj2.Id)[0]);
			insert chAttchList;
			System.assertEquals(chAttchList.Size(), 1);  
			
			for(CH_Attachment__c chattach : chAttchList){
				chAttchIdList.add(chattach.AttachmentID__c);
			}		
			Set<String> chAttchIdSet = new Set<String>();
			chAttchIdSet.addAll(chAttchIdList);
			
			
			Test.setMock(HttpCalloutMock.class, new CAPS_DeleteMockHttpResponse());
			CAPS_Attachment_Delete.updateRetentionDaysforLightning(chAttchIdSet, true);
			test.stopTest();
		}
	}*/
		
		
	public testMethod static void updatesRetentionDaysTest1(){
		CAPS_TestDataUtil.createCustomSettingsData();
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		system.runAs(new User(Id = UserInfo.getUserId())){
			test.StartTest();
			case testCaseObj2 =CH_UTIL_TEST.createCaseNotSaved('Test', 'Minor', 'No', 'Problem', false);
			insert testCaseObj2;
			List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();//Service Provider End User Information
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Service Provider End User Information',testCaseObj2.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Service Provider End User Information',testCaseObj2.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Service Provider End User Information',testCaseObj2.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Service Provider End User Information',testCaseObj2.Id)[0]);		 
			insert chAttchList;
			testCaseObj2.CH_ReasonForCancellation__c = 'Test';
			testCaseObj2.Status = 'Cancelled';
			Update testCaseObj2;
			Test.setMock(HttpCalloutMock.class, new CAPS_DeleteMockHttpResponse());
			Test.StopTest();
			system.debug('testtt>>'+testCaseObj2.status);
		}
	}
	
		
		/*public testMethod static void updatefieldsinCAPS(){
	system.runAs(new User(Id = UserInfo.getUserId())){
	case caseObj= [SELECT Id,CH_OutageEndDate__c FROM case Where Severity__c = 'Minor'  Limit 1];

	List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();//Service Provider End User Information
	chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Service Provider End User Information',caseObj.Id)[0]);
	chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Service Provider End User Information',caseObj.Id)[0]);
	chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Service Provider End User Information',caseObj.Id)[0]);
	chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Service Provider End User Information',caseObj.Id)[0]);

	insert chAttchList;
	System.assertEquals(chAttchList.Size(), 4);				  
	test.StartTest();
	//Test.setMock(HttpCalloutMock.class, new CAPS_DeleteMockHttpResponse());		  
	//  caseObj.CH_SystemRestored__c =  caseObj.CH_OutageEndDate__c  ;
	//  caseObj.CH_IsSystemRestoredSLA__c=  true; 
	caseObj.CH_InitialDiagnosis__c ='Test Intial';
	caseObj.CH_CaseCause__c ='Caused by Customer';
	caseObj.CH_Stage__c='close';
	caseObj.CH_SolutionType__c= 'HW';
	caseObj.Status = 'Closed';
	caseobj.CH_AssignedDate__c= system.today().addDays(-1);  
	caseObj.CH_AssessedOutage__c = 'Yes';				

	update caseObj;
	Test.StopTest();	 
	}
	}*/
}