public class CH_CA_MS_Time_Members_Controller {

	 /**
	  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
	  * Gets a list of workgroup members that are not already members of the passed timeslot
	  * ────────────────────────────────────────────────────────────────────────────────────────────────
	  * @param	timeslotId	ID of the timeslot to get eligable members from the parent workgroup
	  * @return   List<CH_Workgroup_Member__c> List   List of Workgroup Members
	  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
	  */ 
	@AuraEnabled
	public static List<CH_Workgroup_Member__c> getEligableUsers(Id timeslotId){
		List<CH_Workgroup_Member__c> result = new List<CH_Workgroup_Member__c>();
		if (timeslotId == null){
			return result;
		}
		
		CH_Workgroup_Schedule_Timeslot__c timeslot = [SELECT ID, CH_WorkgroupId__c, CH_Workgroup_Name__c 
													  FROM CH_Workgroup_Schedule_Timeslot__c 
													  WHERE ID=:timeslotId];
		
		List<String> currentMemberIds = new List<String>();
		for(CH_Workgroup_Member_Timeslot_Association__c temp: [
					SELECT CH_Workgroup_Member__c	 
				 	FROM CH_Workgroup_Member_Timeslot_Association__c
					WHERE CH_Workgroup_Schedule_Timeslot__c =:timeslotId]) {
			currentMemberIDs.add(temp.CH_Workgroup_Member__c);
			System.debug('CH_CA: Adding current timeslot member: ' + temp.CH_Workgroup_Member__c);
		}
		//get the workgroup members and return those not already assocaited with the timeslot 
		for(CH_Workgroup_Member__c m:[SELECT ID, Name , CH_Role__c, CH_Workgroup_Member_Type__c
											   FROM CH_Workgroup_Member__c 
											   Where CH_Workgroup__c =: timeslot.CH_WorkgroupId__c]) {
		   if(!currentMemberIds.contains(String.valueOf(m.Id))) {
			   System.debug('CH_CA: Not a timeslot member: ' + String.valueOf(m.Id));
			   result.add(m);
		   }
		}

		return result;
	}
	
	/**
	  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
	  * Gets a list of Workgroup Members that are not already members of the passed Tmeslot
	  * ────────────────────────────────────────────────────────────────────────────────────────────────
	  * @param	timeslotId	ID of the Tmeslot to add members to
	  * @param	members		List of Workgroup Member IDs to add to the Timeslot
	  * @param	scheduleTypes	List of the selected Schedule Types for each of the specified members.
	  *				The list index should match the position in the members list
	  * @return   string		Result of the save operations
	  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
	  */
	@AuraEnabled
	public static string addTimeSlotMembers(Id timeslotId, List<Id> members, List<String> scheduleTypes){
		string statusMessage;
		List<CH_Workgroup_Member_Timeslot_Association__c> newMembers = new List<CH_Workgroup_Member_Timeslot_Association__c>();
		for(Integer i = 0; i < members.size(); i++) { 
			//CH_Schedule_Type__c 
			newMembers.add( new CH_Workgroup_Member_Timeslot_Association__c (
				CH_Workgroup_Member__c = members[i], 
				CH_Workgroup_Schedule_Timeslot__c = timeslotId,
				CH_Schedule_Type__c = scheduleTypes[i]
			));
		}
		return CH_CA_MS_Util.saveObjects(newMembers, 'CH_Workgroup_Schedule_Timeslot__c');
	}
}