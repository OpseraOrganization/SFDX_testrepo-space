@isTest
public class CAPS_AttachmentUpdateCaleaQueueable_Test {
public static final string ENDUSER_CLASSIFICATION = 'Service Provider End User Information';
  //Stup Data
	@testSetup
	public static void setup()
	{
		
		CH_Settings__c chsetObj =CAPS_TestDataUtil.createChsetting();
		insert chsetObj;
		
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		List<Case> caseList = new List<Case>();
		caseList = CAPS_TestDataUtil.createCaseRecord(1);
		insert caseList;

		List<CH_Attachment__c> chAttchListNew = new List<CH_Attachment__c>();//Service Provider End User Information
		chAttchListNew.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,ENDUSER_CLASSIFICATION,caseList[0].Id)[0]);
		chAttchListNew.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Other Information',caseList[0].Id)[0]);
		chAttchListNew.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,ENDUSER_CLASSIFICATION,caseList[0].Id)[0]);
		chAttchListNew.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,ENDUSER_CLASSIFICATION,caseList[0].Id)[0]);		 
		insert chAttchListNew;
	}
	@isTest
	public static void updateRetentionDaysforLightningTest() {
		CAPS_TestDataUtil.createCustomSettingsData();
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		Map<String, Boolean> attachmentVsCaleaFlag = new Map<String,Boolean>();
		Case cs = [SELECT Id, Status FROM Case LIMIT 1];
		List<CH_Attachment__c> chAttchList = [SELECT Id, AttachmentID__c FROM CH_Attachment__c WHERE Case__c =: cs.Id LIMIT 2];
		attachmentVsCaleaFlag.put(chAttchList[0].AttachmentID__c, true);
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new CAPS_DeleteMockHttpResponse());
		CAPS_AttachmentUpdateCaleaQueueable job = new CAPS_AttachmentUpdateCaleaQueueable(attachmentVsCaleaFlag);
		job.maximum = 1;
		System.enqueueJob(job);
		Test.stopTest();
	}
}