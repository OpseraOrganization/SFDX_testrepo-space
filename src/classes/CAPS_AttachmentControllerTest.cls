/***************************************************************
 * Class Name : CAPS_AttachmentControllerTest
 * Created Date: 12 July 2018
 * Description : Test class for CAPS_AttachmentController
***************************************************************/
@IsTest
private class CAPS_AttachmentControllerTest {
	/*
	  cover methods in CAPS_AttachmentController, method getAttachment
	*/
	public static User runAsUser = new User(Id = UserInfo.getUserId());
	public static final string OTHER_CLASSIFICATION = 'Other Information';
	public static final string ENDUSER_CLASSIFICATION = 'Service Provider End User Information';
	@testSetup
	public static void setup()
	{
		CH_UTIL_TEST.setupCase(false);
	}

	public testMethod static void attachmentTest(){
		system.runAs(new User(Id = UserInfo.getUserId())){
			test.startTest();
			CAPS_TestDataUtil.createCustomSettingsData();
			Case casList = new Case();
			casList = CH_UTIL_TEST.createCaseNotSaved('Test', 'Minor', 'No', 'CH_Problem', false);
			insert casList;
	 
			CH_Problem_RnD_Reference__c rd=new CH_Problem_RnD_Reference__c ();
			rd.CH_RnD_Interface__c ='JIRA';
			rd.CH_Related_Record__c=casList.Id;
			rd.CH_Request__c='test';
			rd.CH_RnD_Subject__c='testsub';
			rd.CH_RnD_Status__c='Open'; 
			rd.CH_RnD_Direction__c='outbound';
			rd.CH_RnD_Type__c='Transfer to R&D';
			rd.CH_RnD_Description__c='Test description';
			rd.CH_RnD_Comment__c='Test comments';
			insert rd;		
			List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,OTHER_CLASSIFICATION,casList.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,OTHER_CLASSIFICATION,casList.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,ENDUSER_CLASSIFICATION,casList.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,ENDUSER_CLASSIFICATION,casList.Id)[0]);
			insert chAttchList;
			List<CH_Attachment__c> listAttachment = new List<CH_Attachment__c>();
			listAttachment = CAPS_AttachmentController.getAttachment(casList.Id);	 
			List<Id> attachmentIdList =new List<Id>();
			attachmentIdList.add(chAttchList[0].id);
	 
			listAttachment = new List<CH_Attachment__c>();
			listAttachment = CAPS_AttachmentController.getPortalAttachment(casList.Id);
			CAPS_AttachmentController.getUserProfileDetails();
			CAPS_AttachmentController.getDeleteButton(casList.Id);
			CAPS_AttachmentController.getRequiredCaseInformation(casList.Id);
			CAPS_AttachmentController.getRDInteractions(casList.Id);			
			CAPS_AttachmentController.shareAttachmentsWithRnd(casList.Id,rd.CH_RnD_Interface__c,rd.CH_RnD_Subject__c,rd.CH_RnD_Description__c,rd.CH_RnD_Comment__c,attachmentIdList);			
			CAPS_AttachmentController.getCaseTeamMembers(casList.Id);
			test.stopTest();
		}
	}
	/*
	  cover methods in CAPS_AttachmentController, method updateRetentionDays
	*/
	public testMethod static void updateRetentionDaysTest(){
		system.runAs(new User(Id = UserInfo.getUserId())){
			test.startTest();
			CAPS_TestDataUtil.createCustomSettingsData();
			Case caseList = new Case();
			caseList = CH_UTIL_TEST.createCaseNotSaved('Test', 'Minor', 'No', 'CH_Problem', false);
			insert caseList;
			List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,OTHER_CLASSIFICATION,caseList.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,OTHER_CLASSIFICATION,caseList.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,ENDUSER_CLASSIFICATION,caseList.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,ENDUSER_CLASSIFICATION,caseList.Id)[0]);
			insert chAttchList;
			List<String> chAttchIdList = new List<String>();
			for(CH_Attachment__c chattach : chAttchList){
	chAttchIdList.add(chattach.Id);
			}
			
			Test.setMock(HttpCalloutMock.class, new CAPS_DeleteMockHttpResponse());
			CAPS_AttachmentController.updateRetentionDays(chAttchIdList, chAttchList, caseList.Id);
			test.stopTest();
		}
	}
	/*
	  cover methods in CAPS_AttachmentController - method downloadAttachments and class CAPS_Attachments_Download
	*/
	public testMethod static void downloadAttachmentsTest(){
		system.runAs(new User(Id = UserInfo.getUserId())){
			test.startTest();
			CAPS_TestDataUtil.createCustomSettingsData();
			Case caList = new Case();
			caList = CH_UTIL_TEST.createCaseNotSaved('Test', 'Minor', 'No', 'CH_Problem', false);
			insert caList;
			List<CH_Attachment__c> chAttchmentList = new List<CH_Attachment__c>();
			chAttchmentList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,OTHER_CLASSIFICATION,caList.Id)[0]);
			chAttchmentList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,OTHER_CLASSIFICATION,caList.Id)[0]);
			chAttchmentList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,ENDUSER_CLASSIFICATION,caList.Id)[0]);
			chAttchmentList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,ENDUSER_CLASSIFICATION,caList.Id)[0]);
			insert chAttchmentList;
			List<String> chAttchIdListNew = new List<String>();
			for(CH_Attachment__c chattach : chAttchmentList){
	chAttchIdListNew.add(chattach.Id);
			}
			
			Test.setMock(HttpCalloutMock.class, new CAPS_DownloadMockHttpResponse());			
			List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper> capdownAttch = new List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper>();
	 
			capdownAttch =CAPS_AttachmentController.downloadAttachments(chAttchIdListNew, chAttchmentList);
	 

			test.stopTest();
		}
	}

}