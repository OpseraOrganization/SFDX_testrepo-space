/****************************************
* Class Name : CH_TimeRecordingTriggerHandler 
* Created Date: 17-02-2020
* Created By : TCS
* User Story :NOKIASC-26236 
* Description : Handle the excecution of the CH_WorkgroupScheduleTrigger
*****************************************/

public class CH_TimeRecordingTriggerHandler {
	public void validateBeforeDeletion(List<CH_TimeRecording__c> timeRecordings){
		for(CH_TimeRecording__c timeRecording: timeRecordings) {
			//NOKIASC-26236 : bypass validation for data loader profile
			if(timeRecording.OwnerId != UserInfo.getUserId() && (!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))){
				timeRecording.AddError('You are not allowed to modify this record. Only the Record Owner can modify or delete the record.');					
			}
			
		}
	}
}