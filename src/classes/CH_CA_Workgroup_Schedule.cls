//TO DELETE
public class CH_CA_Workgroup_Schedule {
	/*
	private List<String> rolesWithNoAvailability = new List<String>{'Manager 1','Manager 2','Manager 3','Case Manager',''};
		
	// Filter the list of workgroup members based on the availability
	// Certain roles of workgroup members will be checked against availability.
	// If the workgroup member is not available, the workgroup member is removed
	// from the list.
	// Certain roles of workgroup members will NOT be checked against availability
	// and will remain in the list.	 
	public List<CH_CA_DTO.WorkgroupMemberDTO> filterWorkgroupMembersByAvailability(List<CH_CA_DTO.WorkgroupMemberDTO> allWorkgroupMembers , CH_CA_Assignment_Criteria_DTO caseDetails){	 
		// Get all workgroup members Ids
		Set<Id> workMemberIds = new Set<Id>();
		for(CH_CA_DTO.WorkgroupMemberDTO workgroupMember : allWorkgroupMembers){
			workMemberIds.add(workgroupMember.Id);
		}
			
		//getting Active time slot from correct schedule
		List<Id> activeTimeSlotFromSchedle = getActiveTimeSlotIds(allWorkgroupMembers , caseDetails);		
		system.debug('CH_CA: activeTimeSlotFromSchedle'+activeTimeSlotFromSchedle);
			
		// Get the availability for all workgroup members
		List<CH_Workgroup_Member_Timeslot_Association__c> workgroupMembersWithSchedule = 
			[SELECT CH_Schedule_Type__c, CH_Workgroup_Member__c,CH_Workgroup_Schedule_Timeslot__c
			 FROM CH_Workgroup_Member_Timeslot_Association__c
			 WHERE 
			 CH_Workgroup_Member__c in :workMemberIds AND 
			 CH_Workgroup_Schedule_Timeslot__c  in : activeTimeSlotFromSchedle AND
			 CH_Workgroup_Member__r.CH_Off_Duty__c = false];
		System.debug('CH_CA: members time Slot Association found ' + workgroupMembersWithSchedule.size());
			
		// Get all workgroup member Ids from people that are available
		Map<Id, string> availableWorkMemberIds = new Map<Id, string>();
		for(CH_Workgroup_Member_Timeslot_Association__c schedule : workgroupMembersWithSchedule){
			availableWorkMemberIds.put(schedule.CH_Workgroup_Member__c, schedule.CH_Schedule_Type__c);
		}
		System.debug('CH_CA: availableWorkMemberIds found ' + availableWorkMemberIds.size());
		
		List<CH_CA_DTO.WorkgroupMemberDTO> filteredWorkgroupMembers = new List<CH_CA_DTO.WorkgroupMemberDTO>();
		// Remove not valid workgroup members
		for (CH_CA_DTO.WorkgroupMemberDTO workgroupMember : allWorkgroupMembers){
			System.debug('CH_CA: Iterating in All members  ' + workgroupMember);
			// if the workgroup members contains a hotline then display all workgroup members
			// else display workgroup members based on Schedule
			if(workgroupMembersContainsHotline(allWorkgroupMembers, workgroupMember,availableWorkMemberIds)){
				System.debug('CH_CA: Workgroup Have a Hotline  ' + workgroupMember);
				filteredWorkgroupMembers.add(workgroupMember);
			}
			else{   
				System.debug('CH_CA: Workgroup Have NO Hotline  ' + workgroupMember);
				// If the workgroup member has a role that does not require availability 
				if (rolesWithNoAvailability.contains(workgroupMember.role)){
					system.debug('CH_CA: Added role: ' + workgroupMember.role);
					filteredWorkgroupMembers.add(workgroupMember);
				}
				// If the workgroup member has a Schedule
				else if (availableWorkMemberIds.containsKey(workgroupMember.id)){
					system.debug('CH_CA: Active Members in Current Schedule : ' + workgroupMember.role);
					workgroupMember.scheduleType = availableWorkMemberIds.get(workgroupMember.id);
					if(workgroupMember.scheduleType.contains('Primary')){
						system.debug('CH_CA: Primary Scheduled Members : ' + workgroupMember);
						workgroupMember.scheduleTypeOrderNumber = 0;
					}else if(workgroupMember.scheduleType.contains('Secondary')){
						system.debug('CH_CA: Secondary Scheduled Members : ' + workgroupMember);
						workgroupMember.scheduleTypeOrderNumber = 1;
					}else if(workgroupMember.scheduleType.contains('Tertiary')){
						system.debug('CH_CA: Tertiary Scheduled Members : ' + workgroupMember);
						workgroupMember.scheduleTypeOrderNumber = 2;
					}
					filteredWorkgroupMembers.add(workgroupMember);
				}
			}
		}
		System.debug('CH_CA: filteredWorkgroupMembers found ' + filteredWorkgroupMembers);									   
		return filteredWorkgroupMembers;
	}
	
	// If the list of workgoup members contains a hotline then return true
	private boolean workgroupMembersContainsHotline(List<CH_CA_DTO.WorkgroupMemberDTO> allWorkgroupMembers, CH_CA_DTO.WorkgroupMemberDTO currentWorkgroupMember,Map<Id, string> availableWorkMemberIds){
		Set<Id> associatedMembers = new Set<Id>(availableWorkMemberIds.keySet()); 
		for(CH_CA_DTO.WorkgroupMemberDTO workgroupMember: allWorkgroupMembers){
			if (currentWorkgroupMember.workgroupName == workgroupMember.workgroupName &&
				workgroupMember.role == 'Hotline' &&
				associatedMembers.contains(workgroupMember.Id)){
					system.debug('CH_CA: Hotlin is True');
					return true;
				}
		}
		return false;
	}	
	
	public List<Id> getActiveTimeSlotIds(List<CH_CA_DTO.WorkgroupMemberDTO> allWorkgroupMembers, CH_CA_Assignment_Criteria_DTO caseDetails){
		List<Id> activeTimeSlots = new List<Id>();
		//Saperating workgroupIDs
		Set<Id> workgroupIDs = new Set<Id>();
		for(CH_CA_DTO.WorkgroupMemberDTO workgroupMember : allWorkgroupMembers){
			//workgroupIDs.add(workgroupMember.workgroupId);
		}
		system.debug('CH_CA: Workgroup Ids'+ workgroupIDs);
		CH_CA_Workgroup_Member_DTO memberDetails = new CH_CA_Workgroup_Member_DTO (workgroupIDs);
		memberDetails.supportCase =  caseDetails.supportCase;
		system.debug('CH_CA: Assignment DTO'+ caseDetails.supportCase);
		for(Id currentWorkgroup : workgroupIDs){
			activeTimeSlots.add(getTimeSlotForWorkgroupSchedule(currentWorkgroup, memberDetails, caseDetails));
		}
		return activeTimeSlots;
	}
	
	public Id getTimeSlotForWorkgroupSchedule(Id workgroupId,CH_CA_Workgroup_Member_DTO memberDetails,CH_CA_Assignment_Criteria_DTO caseAssignmentDetails){
		List<string> listRoles = new List<string>();
		listRoles.add('Engineer');
		listRoles.add('Hotline');
		if(!caseAssignmentDetails.supportCase.CH_Initial_Assignment__c){
			listRoles.add('Expert');
		}
		Id workgroupScheduleId = null;
		Id activeTimeSlotIdForCurrentSchedule = null;
		List<Id>  wgMemberfromTimslotAssociationIds = new List<Id> ();
		List<CH_Workgroup_Member__c> WorkgroupMembers = new List<CH_Workgroup_Member__c>();
		
		if(workgroupId!= Null){
			//15584 - Displaying Members from Scheduler
			workgroupScheduleId = getWorkgroupSchedule(workgroupId,memberDetails,caseAssignmentDetails);
			//getting timeslot
			if(workgroupScheduleId!=null ){
				activeTimeSlotIdForCurrentSchedule = getTimeSlot(workgroupScheduleId,memberDetails);	
			}
		}
		return activeTimeSlotIdForCurrentSchedule;
	}
	
	//16510 - getting WorkgroupSchedule for particular workgroup
	private Id getWorkgroupSchedule (Id workgroupId, CH_CA_Workgroup_Member_DTO memberDetails,CH_CA_Assignment_Criteria_DTO caseAssignmentDetails){
		//getting workgroup schedules based on current time which stays between start and end time
		List<CH_Workgroup_Schedule__c> WorkgroupSchedule  = new List<CH_Workgroup_Schedule__c>();
		for(CH_Workgroup_Schedule__c wgSchedule : memberDetails.mapAllWorkgroupSchedules.values()){
			if(wgSchedule.CH_Workgroup__c == workgroupId){
				WorkgroupSchedule.add(wgSchedule);
			}  
		}		
		Id workgroupScheduleId = null ;
		Map<Integer ,Id> schedulewithWeight = new Map<Integer ,Id>();
		
		for(CH_Workgroup_Schedule__c wgs : WorkgroupSchedule){
			//iterated worgroup schedule to match with filter
			Integer weight = new CH_CA_Workgroup_Filters().getValidSchedulebyFilter(caseAssignmentDetails,wgs.Id,memberDetails);
			//If returned weight is 0 : There is no Filter associated with this schedule.
			//If returned weight is 1 : There is no Matches found on Filter + Product Association + Customer Association.
			//If returned weight is !1 : We are taking this schedule for further process even if it is 0.
			//If multiple schedule with same weight found then the first schedule would be picked up.
			if(weight != 1){
				schedulewithWeight.put(weight,wgs.Id);
				system.debug('CH:CA Proper schedule is Found is '+wgs+weight);
			}
			//if weight is more than 0 added to schedule with weight
			else{
				system.debug('CH:CA No Proper schedule is Found'+wgs+weight);
			}
		}
		if(schedulewithWeight != null){
			workgroupScheduleId = sortedWeightSchedule(schedulewithWeight);
		}
		return workgroupScheduleId;
	}
	
	//sorting schedule by its maximum weight
	private Id sortedWeightSchedule(Map<Integer ,Id> schedulewithWeight){
		//getting keySet from the schedule map & converting to list since we cant sort the set
		Id workgroupScheduleId = null;
		List<Integer> validscheduleKeySet = new List<Integer>(schedulewithWeight.keySet());
		validscheduleKeySet.sort();
		Integer MaxWeightIndex = 0;
		if(validscheduleKeySet.size() != 0 ){
			//picking the maximum index from the list since after sorting highest weight value goes to last index
			MaxWeightIndex = validscheduleKeySet.size()-1;
			//getting value for weight
			Integer weight = validscheduleKeySet[MaxWeightIndex];
			//getting value at max key when weight is 1 or more than 1
			if(weight > 0 ){
				workgroupScheduleId = schedulewithWeight.get(validscheduleKeySet[MaxWeightIndex]);
			}
			// if weight is 0 then we need to pick the schedule as it is.
			else if(weight == 0){
				workgroupScheduleId = schedulewithWeight.get(0);
			}
		}
		return workgroupScheduleId;
	}
	
	//getting timelost 
	private Id getTimeSlot(Id workgroupScheduleId,CH_CA_Workgroup_Member_DTO memberDetails){
		Id WorkgroupScheduleTimeslotId = null;
		List<CH_Workgroup_Schedule_Timeslot__c> WorkgroupScheduleTimeslot = new List<CH_Workgroup_Schedule_Timeslot__c>();
		for(CH_Workgroup_Schedule_Timeslot__c wgsTimeslot : memberDetails.mapWorkgroupScheduleTimeslot.values()){
			if(wgsTimeslot.CH_Workgroup_Schedule__c == workgroupScheduleId){
				WorkgroupScheduleTimeslot.add(wgsTimeslot);		   
			}
		}
		Time startTime = Time.newInstance(0, 0, 0, 0); //12:00 AM
		for(CH_Workgroup_Schedule_Timeslot__c ts : WorkgroupScheduleTimeslot){
			//if planning a schedule timeslot for entire day. i.e. from 12:00 AM to 12.00 AM
			if(ts.CH_Start_Time__c == startTime && ts.CH_End_Time__c ==startTime){
				system.debug('CA: 12-12 TimeSlot'+  ' Start Time '+ts.CH_Start_Time__c +'End Time '+ ts.CH_End_Time__c+'Now time '+system.now().time());
				WorkgroupScheduleTimeslotId =  ts.Id;
				break;
			}else if(ts.CH_Start_Time__c <= system.now().time() && ts.CH_End_Time__c >= system.now().time()){
				system.debug('CA: 12-9 TimeSlot'+  ' Start Time '+ts.CH_Start_Time__c +'End Time '+ ts.CH_End_Time__c +'Now time '+system.now().time() );
				WorkgroupScheduleTimeslotId = ts.Id;
			}
		}
		system.debug('returned timeslots>>'+WorkgroupScheduleTimeslotId);
		return WorkgroupScheduleTimeslotId;
	}
*/
}