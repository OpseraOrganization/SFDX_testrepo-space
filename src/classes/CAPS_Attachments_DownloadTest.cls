/***************************************************************
 * Class Name : CAPS_Attachments_DownloadTest
 * Created Date: 24 October 2019
 * Description : Test class for CAPS_Attachments_Download
***************************************************************/
@IsTest
private class CAPS_Attachments_DownloadTest {
	/*
	  cover methods in CAPS_Attachments_Download
	*/
	@testSetup static void setup() {
	insert new CH_Integration__c(EnableIntegration__c = true);  

		CH_UTIL_TEST.setupCase();
	}

	private static Case createTestCase() {
		CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;

		return CH_UTIL_TEST.getS2SCase();
	}
	public testMethod static void downloadAttachmentsTest1(){
		system.runAs(new User(Id = UserInfo.getUserId())){
			
			CAPS_TestDataUtil.createCustomSettingsData();
			
			Case testCase = createTestCase();
			insert testCase;

			List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,CAPS_ConstantHandler.OTHER_DATA,testCase.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,CAPS_ConstantHandler.OTHER_DATA,testCase.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,CAPS_ConstantHandler.ENDUSER_DATA,testCase.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,CAPS_ConstantHandler.ENDUSER_DATA,testCase.Id)[0]);
			insert chAttchList;
			test.startTest();
			List<String> chAttchIdList = new List<String>();
			for(CH_Attachment__c chattach : chAttchList){
	chAttchIdList.add(chattach.Id);
			}
			
			Test.setMock(HttpCalloutMock.class, new CAPS_DownloadMockHttpResponse());			
			List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper> capdownAttch = new List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper>();
	 
			capdownAttch =CAPS_AttachmentController.downloadAttachments(chAttchIdList, chAttchList);
	 
			test.stopTest();
		}
	}
	public testMethod static void downloadAttachmentsTest1AWS4(){
		system.runAs(new User(Id = UserInfo.getUserId())){
			
			CAPS_TestDataUtil.createCustomSettingsData();
			
			Case testCase = createTestCase();
			insert testCase;

			List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,CAPS_ConstantHandler.OTHER_DATA,testCase.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,CAPS_ConstantHandler.OTHER_DATA,testCase.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,CAPS_ConstantHandler.ENDUSER_DATA,testCase.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,CAPS_ConstantHandler.ENDUSER_DATA,testCase.Id)[0]);
			insert chAttchList;
			test.startTest();
			List<String> chAttchIdList = new List<String>();
			for(CH_Attachment__c chattach : chAttchList){
	chAttchIdList.add(chattach.Id);
			}
			
			Test.setMock(HttpCalloutMock.class, new CAPS_DownloadMockHttpResponseS3Sign4());			
			List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper> capdownAttch = new List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper>();
	 
			capdownAttch =CAPS_AttachmentController.downloadAttachments(chAttchIdList, chAttchList);
	 

			test.stopTest();
		}
	}
	public testMethod static void downloadAttachmentsTest2(){
		system.runAs(new User(Id = UserInfo.getUserId())){
			
			CAPS_TestDataUtil.createCustomSettingsData();
			
			Case testCase = createTestCase();
			insert testCase;

			List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,CAPS_ConstantHandler.OTHER_DATA,testCase.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,CAPS_ConstantHandler.OTHER_DATA,testCase.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,CAPS_ConstantHandler.ENDUSER_DATA,testCase.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,CAPS_ConstantHandler.ENDUSER_DATA,testCase.Id)[0]);
			insert chAttchList;
			test.startTest();
			List<String> chAttchIdList = new List<String>();
			for(CH_Attachment__c chattach : chAttchList){
	chAttchIdList.add(chattach.Id);
			}
			
			Test.setMock(HttpCalloutMock.class, new CAPS_DownloadMockHttpResponseS3Fail());			
			List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper> capdownAttch = new List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper>();
	 
			capdownAttch =CAPS_AttachmentController.downloadAttachments(chAttchIdList, chAttchList);
	 

			test.stopTest();
		}
	}
	public testMethod static void downloadAttachmentsTest3(){
		system.runAs(new User(Id = UserInfo.getUserId())){
			
			CAPS_TestDataUtil.createCustomSettingsData();
			
			Case testCase = createTestCase();
			insert testCase;

			List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,CAPS_ConstantHandler.OTHER_DATA,testCase.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,CAPS_ConstantHandler.OTHER_DATA,testCase.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,CAPS_ConstantHandler.ENDUSER_DATA,testCase.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,CAPS_ConstantHandler.ENDUSER_DATA,testCase.Id)[0]);
			insert chAttchList;
			test.startTest();
			List<String> chAttchIdList = new List<String>();
			for(CH_Attachment__c chattach : chAttchList){
	chAttchIdList.add(chattach.Id);
			}
			
			Test.setMock(HttpCalloutMock.class, new CAPS_DownloadMockHttpResponseCAPSFail());			
			List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper> capdownAttch = new List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper>();
	 
			capdownAttch =CAPS_AttachmentController.downloadAttachments(chAttchIdList, chAttchList);
	 
			test.stopTest();
		}
	}
}