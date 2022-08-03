/****************************************
* Trigger Name : CH_WorkgroupRotaTrigger 
* Created Date: 12-09-2018
* Created By : TCS
* Description : This trigger is used to create entries for workgroup member for their rotation on reoccurance
*****************************************/
trigger CH_WorkgroupRotaTrigger on CH_Workgroup_Event__c (after insert) {
	public static final string stringVal = 'Yes';
	public static final string WorkgroupRotaTrigger = 'WorkgroupRotaTrigger';
	public static final string EMPTYSTRING= ' ';
 
   
	String isActive = CH_Settings__c.getValues(WorkgroupRotaTrigger) != null ? CH_Settings__c.getValues(WorkgroupRotaTrigger).SettingValue__c :EMPTYSTRING;
   
	if(isActive == stringVal){
		if(Trigger.isAfter) {
			if(Trigger.isInsert) {
				CH_WorkgroupRotaTriggerHandler.afterInsertOperation(Trigger.new);
			}
		}
	}
}