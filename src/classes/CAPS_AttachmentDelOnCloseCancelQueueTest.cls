/***************************************************************
* Class Name : CAPS_AttachmentDelOnCloseCancelQueueTest	test
* Created Date: 24 July 2019
* Description : Test class for CAPS_AttachmentDelOnCloseCancelQueue
***************************************************************/
@IsTest

private class CAPS_AttachmentDelOnCloseCancelQueueTest {
  
  //Stup Data
	@testSetup
	public static void setup()
	{
		
		CH_Settings__c cstObj = new CH_Settings__c();
		cstObj.Description__c = 'test custom settings';
		cstObj.SettingValue__c = '3';
		cstObj.Name = 'SpecificTimeForOnhold';
		insert cstObj;

		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		Case cs = new Case();
		cs.Subject = 'Creating Non Ch test data CAPS123';
		cs.Category__c = 'General Issues';
		cs.Type = 'Services_Project_Team';
		cs.Issue_Reported_By__c = userinfo.getuserid();
		cs.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('SF Support').getRecordTypeId();
		cs.Status = 'New';
		cs.Description = 'test';
		insert cs;

		List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();//Service Provider End User Information
		chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Service Provider End User Information',cs.Id)[0]);
		chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Other Information',cs.Id)[0]);
		chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Service Provider End User Information',cs.Id)[0]);
		chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Service Provider End User Information',cs.Id)[0]);		 
		insert chAttchList;
		
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