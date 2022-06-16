/****************************************
* Class Name : CH_WorkgroupScheduleTriggerHandler
* Created Date: 13-03-2019
* Created By : TCS
* Description : This trigger is used to verify workgroup schedule has following things-
* 1. Atleast one timeslot record is present in each workgroup schedule
* 2. Atleast one workgroup member is present in each timeslot record
* 3. Timeslot records are not overlapping on each other on same day
* Test Class: CH_WorkgroupScheduleTriggerHandlerTest
*****************************************/
public with sharing class CH_WorkgroupScheduleTriggerHandler extends TriggerHandler {
/*
	private Map<Id, CH_Workgroup_Schedule__c> newMap;
	
	public CH_WorkgroupScheduleTriggerHandler() {
		this.newMap = (Map<Id, CH_Workgroup_Schedule__c>) Trigger.NewMap;
	}
	
	//Method Name: validateBeforeUpdate
	//Parameter: Map<Id, CH_Workgroup_Schedule__c>
	//Description: Used to check whether atleast one timeslot is created and atleast one workgroup member record is associated
	//and timeslots are not overlapping
	//and atleast one workgroup member is associated with timeslot
	public static void validateBeforeUpdate(Map<Id, CH_Workgroup_Schedule__c> newMap)
	{
		if(newMap!=null && newMap.size()>0){
			List<CH_Workgroup_Schedule_Timeslot__c> wGSTSList =[SELECT Id, CH_Workgroup_Schedule__c, CH_Day__c, CH_Start_Time__c, CH_End_Time__c FROM CH_Workgroup_Schedule_Timeslot__c 
																WHERE CH_Workgroup_Schedule__c IN :newMap.keySet()];
			CH_CA_Validate_Schedule validateScheduleObj = new CH_CA_Validate_Schedule();
			validateScheduleObj.workgroupScheduleTriggerValidation(newMap, wGSTSList);
		}
	}
	
	//Method Name: validateAfterInsert
	//Parameter: Map<Id, CH_Workgroup_Schedule__c>
	//Description: Used to check whether atleast one timeslot is created and atleast one workgroup member record is associated
	public static void validateAfterInsert(Map<Id, CH_Workgroup_Schedule__c> newMap)
	{
		if(newMap.size()>0){
			//get list of all CH_Workgroup_Schedule__c records
			List<CH_Workgroup_Schedule_Timeslot__c> wGSTSList =[SELECT Id, Name, CH_Workgroup_Schedule__c, CH_Day__c, CH_Start_Time__c, CH_End_Time__c FROM CH_Workgroup_Schedule_Timeslot__c 
																WHERE CH_Workgroup_Schedule__c IN :newMap.keySet()];
			CH_CA_Validate_Schedule validateScheduleObj = new CH_CA_Validate_Schedule();
			validateScheduleObj.workgroupScheduleTriggerValidation(newMap, wGSTSList);
		}
	}*/
}