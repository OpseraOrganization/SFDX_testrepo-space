/****************************************
* Class Name : CH_CA_Validate_Schedule_Controller
* Created Date: 15-03-2019
* Created By : TCS
* Description : This class is used by lightning component which will validate workgroup schedule
* Test Class: CH_CA_Validate_Schedule_Controller_Test
*****************************************/
public class CH_CA_Validate_Schedule_Controller{

	//Method Name: validateWorkgroupSchedule
	//Parameter: List<string> workgroupScheduleId
	//Description: This function validate workgroup schedule and Workgroup Schedule Timeslot
	@AuraEnabled
	public static string validateWorkgroupSchedule(List<string> workgroupScheduleId){
		List<string> scheduleIds = workgroupScheduleId;
		system.debug('CH_CA: Validate schedules for: ' + scheduleIds);
		
		CH_CA_Validate_Schedule validateSchedule = new CH_CA_Validate_Schedule();
		string validationError = validateSchedule.validate(scheduleIds);
				
		system.debug('CH_CA: Validation Errors:' + validationError);
		return validationError;
	}
}