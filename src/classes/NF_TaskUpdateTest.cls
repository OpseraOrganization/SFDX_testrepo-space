/***************************************
* Name : NF_TaskUpdate
* Author : Accenture
* Description : Test class for NF_TaskUpdate
*****************************************/
@istest
private class NF_TaskUpdateTest {
	  private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_DIRECT_SALES_OPPORTUNITY).getRecordTypeId();
		public static Integer numOfDays = Integer.valueOf(System.Label.Number_of_Days);

	 static testMethod void myUnitTest() {
	 User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
	 insert userCreation;
	 System.runAs(userCreation){
	  
	   
	  Account accountCreation = TestDataFactory.createAccount(1)[0];
	  insert accountCreation;
	  //Creating Opportunity
	   Set<Id> oppIdSet = new Set<Id>();
	  List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation);
	  optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
	  optyCreation[0].Amount = 1000;
	  optyCreation[1].RecordTypeId = oppDirectRecordTypeId;
	  optyCreation[1].Amount = 1000;
			
	  optyCreation[1].StageName = GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE;
	  optyCreation[1].Phase_Status__c = 'Offer Submitted to Customer (Manual)';
	  insert optyCreation[1];
	  optyCreation[1].stageName = GlobalConstants.COMPLETED_OPPTY;
	  optyCreation[1].Phase_Status__c = 'Closed';
	  optyCreation[1].Oppty_Completion_Date__c = System.today() + numOfDays; 
	  update optyCreation[1];
		   oppIdSet.add(optyCreation[1].id);
	  List<Task> taskCreationList = TestDataFactory.TaskCreation(1);
	  taskCreationList[0].WhatId = optyCreation[1].Id;
	  taskCreationList[0].status = 'Open';
	  taskCreationList[0].Task_Creation_By_Pass_Check__c = GlobalConstants.VALUE_TRUE;
	  insert taskCreationList;
	  
		   Test.startTest();
	  NF_TaskUpdate taskUpdation = new NF_TaskUpdate();
		  taskUpdation.oppIdSet.add(optyCreation[1].id);
	  SchedulableContext SC;
	  Database.BatchableContext BC;
	  taskUpdation.start(BC);
	  taskUpdation.execute(BC,optyCreation);
	  taskUpdation.finish(BC);
	  taskUpdation.execute(SC);
	  Test.StopTest();		 
	 }	
	}
}