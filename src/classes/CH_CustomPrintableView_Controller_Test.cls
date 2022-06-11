/*******************************************************************************************************************
* Test Class Name: CH_CustomPrintableViewWrapper_Test
* This test Class covers the code coverage for CH_CustomPrintableViewWrapper and CH_CustomPrintableView_Controller
* Developed By : TCS
* Developer Name: Akhil Ramisetty
* Last Modified (By&On):  Akhil Ramisetty on 16.08.2021 
*******************************************************************************************************************/
@isTest
public class CH_CustomPrintableView_Controller_Test {	
	
	@testSetup  
	static void setuptestdata(){  
		Test.startTest();
		CH_UTIL_TEST.setupCase(false);		  
		Test.stopTest();
	}
	@isTest
	Public static void childWrapper(){
		Test.startTest();
		CH_CustomPrintableViewWrapper.childWrapper Wrapper = new CH_CustomPrintableViewWrapper.childWrapper('CH_CaseTeamHistory__c', 'title', 'Support_Ticket__c', datetime.newInstance(2021, 9, 15, 12, 30, 0));
		Wrapper.compareTo(Wrapper);
		Test.stopTest();
	}
	@isTest
	public static void getFieldSetTest() {
		
		Test.StartTest();	   
		CH_CustomPrintableView_Controller.getFieldSet('CH_CaseTeamHistory__c','CH_CaseTeamHistory__c');
	  	CH_CustomPrintableView_Controller.getFieldSet('CaseMilestone','CaseMilestone');
		CH_CustomPrintableView_Controller.getFieldSet('CH_PendingTimeSuspension__c','CH_PendingTimeSuspension__c');
		CH_CustomPrintableView_Controller.getFieldSet('CH_Track_Field_Change__c','CH_Track_Field_Change__c');
		CH_CustomPrintableView_Controller.getFieldSet('ContentNote','ContentNote');		
		Test.StopTest();		 
	}
	
		@isTest
	   public static void getRelatedRecordsTest() {
		
		Test.StartTest();
		Case testCaseObj = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaIncidentWithRestoration', false);
		insert testCaseObj;
		CH_CustomPrintableView_Controller.getRelatedRecords('OpenActivity','Name',testCaseObj.Id,date.newInstance(2021, 9, 15));
	  	CH_CustomPrintableView_Controller.getRelatedRecords('ContentNote','Name',testCaseObj.Id,date.newInstance(2021, 9, 15));
		CH_CustomPrintableView_Controller.getRelatedRecords('FeedItem','Name',testCaseObj.Id,date.newInstance(2021, 9, 15));
		CH_CustomPrintableView_Controller.getRelatedRecords('CH_CaseTeamHistory__c','Name',testCaseObj.Id,date.newInstance(2021, 9, 15));
		CH_CustomPrintableView_Controller.getRelatedRecords('CaseMilestone','Name',testCaseObj.Id,date.newInstance(2021, 9, 15));
		CH_CustomPrintableView_Controller.getRelatedRecords('EmailMessage','Name',testCaseObj.Id,date.newInstance(2021, 9, 15));
		CH_CustomPrintableView_Controller.getRelatedRecords('CaseComment','Name',testCaseObj.Id,date.newInstance(2021, 9, 15));
		Test.StopTest();		 
	}
	
	@isTest
	public static void getMostRelatedListTest() {
		Test.StartTest();
		Case testCaseObj = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaIncidentWithRestoration', false);
		insert testCaseObj;
		CH_CustomPrintableView_Controller.getMostRelatedList(testCaseObj.Id,date.newInstance(2021, 9, 15));	  	
		Test.StopTest();	
	}
	
	 @isTest
	   public static void getRelatedObjectsTest() {
		  
	 Test.StartTest();
		Case testCaseObj = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaIncidentWithRestoration', false);
		insert testCaseObj;
		testCaseObj.subject='subject';		
		update testCaseObj;  
		List<task> t = new List<task>{ new task(
		WhatID = testCaseObj.id,
		Subject='Test',
		Status='New',
		Priority='Normal'
	   )};
		insert t;		  
		CH_CustomPrintableView_Controller.getRelatedObjects('Case'); 
		CH_CustomPrintableView_Controller.getMostRelatedList(testCaseObj.Id,date.newInstance(2021, 9, 15));
		Test.StopTest();	
	   }
	
}