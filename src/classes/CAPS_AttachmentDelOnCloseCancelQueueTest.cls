/***************************************************************
* Class Name : CAPS_AttachmentDelOnCloseCancelQueueTest	test
* Created Date: 24 July 2019
* Description : Test class for CAPS_AttachmentDelOnCloseCancelQueue
***************************************************************/
@IsTest

private class CAPS_AttachmentDelOnCloseCancelQueueTest {
	public static final string ENDUSER_CLASSIFICATION = 'Service Provider End User Information';
  //Stup Data
	@testSetup
	public static void setup()
	{
		
		
		CH_Settings__c chsetObj =CAPS_TestDataUtil.createChsetting();
		insert chsetObj;
		
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		Case ca = new Case();
		ca.Subject = 'Creating Non Ch test data CAPS123';
		ca.Category__c = 'General Issues';
		ca.Type = 'Services_Project_Team';
		ca.Issue_Reported_By__c = userinfo.getuserid();
		ca.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SF_Support').getRecordTypeId();
		ca.Status = 'New';
		ca.Description = 'test';
		insert ca;

		List<CH_Attachment__c> chAttchListNew = new List<CH_Attachment__c>();//Service Provider End User Information
		chAttchListNew.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,ENDUSER_CLASSIFICATION,ca.Id)[0]);
		chAttchListNew.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Other Information',ca.Id)[0]);
		chAttchListNew.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,ENDUSER_CLASSIFICATION,ca.Id)[0]);
		chAttchListNew.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,ENDUSER_CLASSIFICATION,ca.Id)[0]);		 
		insert chAttchListNew;
		
	}
	@isTest
	public static void updateRetentionDaysforLightningTest() {
		CAPS_TestDataUtil.createCustomSettingsData();
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		Map<String,Boolean> attahmentIdVsToBeDeletedMap = new Map<String,Boolean>();
		Map<String, Map<String,String>> attachIDVsMapOfUpdateFieldsMap = new Map<String, Map<String,String>>();
		Map<String,String> valueVsFieldMap = new Map<String,String>();
		Map<String,String> attachmentIdVsDateMap = new Map<String,String>();
		Case cs = [SELECT Id, Status FROM Case WHERE subject = 'Creating Non Ch test data CAPS123' LIMIT 1];
		List<CH_Attachment__c> chAttchList = [SELECT Id, AttachmentID__c FROM CH_Attachment__c WHERE Case__c =: cs.Id LIMIT 2];
		attachmentIdVsDateMap.put(chAttchList[0].AttachmentID__c,CAPS_ConstantHandler.RETENTION_DAYS1_STR);
		attahmentIdVsToBeDeletedMap.put(chAttchList[0].AttachmentID__c, true);
		
		valueVsFieldMap.put(CAPS_ConstantHandler.CASESTATUS, 'Cancelled');
		attachIDVsMapOfUpdateFieldsMap.put(chAttchList[0].AttachmentID__c, valueVsFieldMap);
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new CAPS_DeleteMockHttpResponse());
		CAPS_AttachmentDelOnCloseCancelQueue job = new CAPS_AttachmentDelOnCloseCancelQueue(attahmentIdVsToBeDeletedMap, attachIDVsMapOfUpdateFieldsMap, attachmentIdVsDateMap);
		job.maximum = 1;
		System.enqueueJob(job);
		Test.stopTest();
	}
}