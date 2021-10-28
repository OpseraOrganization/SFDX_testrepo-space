/****************************************
* Trigger Name : CH_TrackFieldChangeTrigger 
* Created Date: 19 November 2018
* Created By : aelhitary
* Last Modified by: aelhitary
* Last Modified Date: 19 November 2018
* Description : Trigger CH_Track_Field_Change__c
*****************************************/
trigger CH_TrackFieldChangeTrigger on CH_Track_Field_Change__c (before insert, before update, after insert, after update, after delete) {
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
		if(Trigger.isBefore) {
			if(Trigger.isInsert) {
				CH_TrackFieldChangeTriggerHandler.beforeInsertOperation(Trigger.new);
			}
		}
	}
}