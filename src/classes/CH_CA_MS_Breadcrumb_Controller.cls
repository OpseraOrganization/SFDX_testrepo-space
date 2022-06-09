public class CH_CA_MS_Breadcrumb_Controller {
		
	/**
	* ───────────────────────────────────────────────────────────────────────────────────────────────┐
	* Gets the Workgroup and schedule names from the passed IDs
	* ────────────────────────────────────────────────────────────────────────────────────────────────
	* @param	workgroupId   ID of the workgroup
	* @param	scheduleId	ID of the schedule
	* @return   List<String>  First entry is the workgroup name; second will be the schedule name
	* ───────────────────────────────────────────────────────────────────────────────────────────────┘
	*/
	@AuraEnabled
	public static List<String> getWorkGroupAndScheduleNames(Id workgroupId, Id scheduleId){
		List<String> result = new List<String>();
		if(String.isNotEmpty(workgroupId)) {
			CH_Workgroup__c workgroup = [select Name from CH_Workgroup__c where id =: workgroupId];
			result.add(workgroup.Name);
			if(String.isNotEmpty(scheduleId)) {
				CH_Workgroup_Schedule__c  schedule = [select Name from CH_Workgroup_Schedule__c where id =: scheduleId];
				result.add(schedule.Name);
			}
		}	
		return result;
	}
}