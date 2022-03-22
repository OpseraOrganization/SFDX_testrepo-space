public class CH_WorkgroupMember_Trigger_Handler {
	
	// A Case Assignment workgroup member cannot be deleted when it has timeslots assigned
	public void validateBeforeDeletion(List<CH_Workgroup_Member__c> newWorkgroupMembers){
		Id kbRecordTypeId = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByName().get('CH_KB_WorkgroupMember').getRecordTypeId();

		// Loop through all the workgroup members but process only the case assignment ones
		for(CH_Workgroup_Member__c newWorkgroupMember: newWorkgroupMembers) {
			// if not a KB workgroup member, thus a case assignment workgroup member
			if (newWorkgroupMember.recordTypeId != kbRecordTypeId){
				// if the workgroup member has timeslot then you cannot delete
				if (newWorkgroupMember.CH_Assigned_To_Timeslots__c > 0){
					newWorkgroupMember.AddError('Workgroup member cannot be removed from the workgroup as long as the member is configured in a timeslot in this workgroup');					
				}				
			}
		}
	}
}