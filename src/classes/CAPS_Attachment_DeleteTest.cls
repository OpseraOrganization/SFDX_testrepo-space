/***************************************************************
* Class Name : CAPS_Attachment_DeleteTest	test
* Created Date: 12 July 2018
* Description : Test class for CAPS_Attachment_Delete
***************************************************************/
@IsTest

private class CAPS_Attachment_DeleteTest {
	public static final string ENDUSER_CLASSIFICATION = 'Service Provider End User Information';
  //Stup Data
	@testSetup
	public static void setup()
	{
		
		
		CH_Settings__c cstObj =CAPS_TestDataUtil.createChsetting();
		insert cstObj;
		
		
		
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		Case cs = new Case();
		cs.Subject = 'Creating Non Ch test data';
		cs.Category__c = 'General Issues';
		cs.Type = 'Services_Project_Team';
		cs.Issue_Reported_By__c = userinfo.getuserid();
		cs.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SF_Support').getRecordTypeId();
		cs.Status = 'New';
		cs.Description = 'test';
		insert cs;

		List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();//Service Provider End User Information
		chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,ENDUSER_CLASSIFICATION,cs.Id)[0]);
		chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,ENDUSER_CLASSIFICATION,cs.Id)[0]);
		chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,ENDUSER_CLASSIFICATION,cs.Id)[0]);
		chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,ENDUSER_CLASSIFICATION,cs.Id)[0]);		 
		insert chAttchList;
		
	}
	@isTest
	public static void updateRetentionDaysforLightningTest() {
		
	   
		
		CAPS_TestDataUtil.createCustomSettingsData();
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		Set<String> chAttchIdSet = new Set<String>();
		chAttchIdSet.add([SELECT AttachmentID__c FROM CH_Attachment__c LIMIT 1][0].AttachmentID__c);
			   
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new CAPS_DeleteMockHttpResponse());
		CAPS_Attachment_Delete.updateRetentionDaysforLightning(chAttchIdSet,true);
		String attahmentIdVsToBeDeletedMapStr;
		string attachIDVsMapOfUpdateFieldsMapStr;
		String attachmentidvsDate;
		
		
		Map<String, Map<String,String>> attachIDVsMapOfUpdateFieldsMap = new Map<String, Map<String,String>>();
		CAPS_Attachment_Delete.updateAllFieldsforTrigger(attahmentIdVsToBeDeletedMapStr,attachIDVsMapOfUpdateFieldsMapStr,attachmentidvsDate);
		
		Test.stopTest();
	}
	
	
	public testMethod static void cAPSVclassificationTest(){
		
	   
		

		test.startTest();
		String nctclassificationId = CAPS_Attachment_Delete.cAPSVclassification('Other Information');
		System.assertEquals('4',nctclassificationId);
		test.stopTest();
		
		
	}
	
	
	public testMethod static void cAPSVclassificationTest2(){
		
		CH_Settings__c cstObj = new CH_Settings__c();
		cstObj.Description__c = 'test custom settings';
		cstObj.SettingValue__c = '3';
		cstObj.Name = 'SpecificTimeForOnhold';
		insert cstObj;
		
		test.startTest();
		String nctclassificationId = CAPS_Attachment_Delete.cAPSVclassification('Other Sensitive Information');
		System.assertEquals('3',nctclassificationId);
		test.stopTest();
		
	}
	
	public testMethod static void cAPSVclassificationTest3(){
		CH_Settings__c cstObj = new CH_Settings__c();
		cstObj.Description__c = 'test custom settings';
		cstObj.SettingValue__c = '3';
		cstObj.Name = 'SpecificTimeForOnhold';
		insert cstObj;
		
		test.startTest();
		String nctclassificationId = CAPS_Attachment_Delete.cAPSVclassification(ENDUSER_CLASSIFICATION);
		System.assertEquals('1',nctclassificationId);
		test.stopTest();
		
	}
}