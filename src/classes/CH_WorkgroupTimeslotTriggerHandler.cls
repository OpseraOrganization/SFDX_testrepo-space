/****************************************
* Trigger Name : CH_WorkgroupTimeslotTriggerHandler 
* Created Date: 17-09-2019
* Created By : Sonia Reis
*****************************************/
public class CH_WorkgroupTimeslotTriggerHandler extends TriggerHandler {
	/*
	private Map<Id, CH_Workgroup_Schedule_Timeslot__c> oldMap;
	
	public CH_WorkgroupTimeslotTriggerHandler() {
		this.oldMap = (Map<Id, CH_Workgroup_Schedule_Timeslot__c>) Trigger.oldMap;
	}
	
	//Method Name: validateAfterUpdate
	//Parameter: Map<Id, CH_Workgroup_Schedule_Timeslot__c> 
	//Description: Used to validate the update of this timeslot in the schedule, to check if the schedule remains valide
	public static void validateAfterUpdate(Map<Id, CH_Workgroup_Schedule_Timeslot__c> oldMap, Map<Id, CH_Workgroup_Schedule_Timeslot__c> newMap)
	{
		System.debug('CH_WorkgroupTimeslotTriggerHandler -- AFTER UPDATE ' +oldMap);
		if(oldMap!=null && oldMap.size()>0){
			
			Set<ID> scheduleList = new Set<ID>();
			for(CH_Workgroup_Schedule_Timeslot__c ts : oldMap.values()){
				scheduleList.add(ts.CH_Workgroup_Schedule__c);
			}
			//get status of schedules
			Map<Id, CH_Workgroup_Schedule__c> schedulesMap = new Map<Id, CH_Workgroup_Schedule__c>([select id, CH_Active__c from CH_Workgroup_Schedule__c where id IN : scheduleList]);
			
			List<CH_Workgroup_Schedule_Timeslot__c> newTimeslotList =[SELECT Id, CH_Workgroup_Schedule__c, CH_Workgroup_Schedule__r.CH_Active__c, CH_WorkgroupMemberCount__c,
																CH_Day__c, CH_Start_Time__c, CH_End_Time__c FROM CH_Workgroup_Schedule_Timeslot__c 
																WHERE CH_Workgroup_Schedule__c IN :scheduleList];


			//Map of schedules ids for list of timeslots (new values)
			Map<Id, List<CH_Workgroup_Schedule_Timeslot__c>> scheduleIdForListTSmap = new Map<Id, List<CH_Workgroup_Schedule_Timeslot__c>>();
			for(CH_Workgroup_Schedule_Timeslot__c ts : newTimeslotList){
				if(scheduleIdForListTSmap.containsKey(ts.CH_Workgroup_Schedule__c)){
					List<CH_Workgroup_Schedule_Timeslot__c> tsList = scheduleIdForListTSmap.get(ts.CH_Workgroup_Schedule__c);
					tsList.add(ts);
					scheduleIdForListTSmap.remove(ts.CH_Workgroup_Schedule__c);
					scheduleIdForListTSmap.put(ts.CH_Workgroup_Schedule__c,tsList);
				}
				else{
					scheduleIdForListTSmap.put(ts.CH_Workgroup_Schedule__c, new List<CH_Workgroup_Schedule_Timeslot__c>{ts});
				}
			}
			system.debug('new map scheduleIdForListTSmap '+scheduleIdForListTSmap);
			
			for(ID schedule : scheduleIdForListTSmap.keySet()){
				//validate only for the active schedules
				if(schedulesMap.get(schedule).CH_Active__c){
					CH_CA_Validate_Schedule validateScheduleObj = new CH_CA_Validate_Schedule();
					String result = validateScheduleObj.scheduleValidation(scheduleIdForListTSmap.get(schedule));
					system.debug('CH_WorkgroupTimeslotTriggerHandler result '+result);
					if(result!= null){
						for( CH_Workgroup_Schedule_Timeslot__c ts : scheduleIdForListTSmap.get(schedule)){
							if(newmap.containskey(ts.Id) && ts.CH_WorkgroupMemberCount__c == newmap.get(ts.Id).CH_WorkgroupMemberCount__c){ //to prevent that an update on CH_WorkgroupMemberCount__c fires this trigger  
								newmap.get(ts.Id).addError(result+ ' ');
							}
						}
					}
				}
			}
		}  
	}
	
	//Method Name: validateAfterDelete
	//Parameter: Map<Id, CH_Workgroup_Schedule_Timeslot__c>
	//Description: Used to validate the delete of this timeslot in the schedule, to check if the schedule remains valide
	public static void validateAfterDelete(Map<Id, CH_Workgroup_Schedule_Timeslot__c> oldMap)
	{
		System.debug('CH_WorkgroupTimeslotTriggerHandler -- AFTER DELETE '+oldMap);
		if(oldMap!=null && oldMap.size()>0){
			
			Set<ID> scheduleList = new Set<ID>();
			for(CH_Workgroup_Schedule_Timeslot__c ts : oldMap.values()){
				scheduleList.add(ts.CH_Workgroup_Schedule__c);
			} 
			
			List<CH_Workgroup_Schedule_Timeslot__c> newTSList = [SELECT Id, CH_Workgroup_Schedule__c, CH_Workgroup_Schedule__r.CH_Active__c, 
																 CH_Day__c, CH_Start_Time__c, CH_End_Time__c FROM CH_Workgroup_Schedule_Timeslot__c 
																 WHERE CH_Workgroup_Schedule__c IN :scheduleList];
			
			//Map of schedules ids for list of timeslots
			Map<Id, List<CH_Workgroup_Schedule_Timeslot__c>> scheduleIdForListTSmap = new Map<Id, List<CH_Workgroup_Schedule_Timeslot__c>>();
			for(CH_Workgroup_Schedule_Timeslot__c ts : newTSList){
				if(scheduleIdForListTSmap.containsKey(ts.CH_Workgroup_Schedule__c)){
					List<CH_Workgroup_Schedule_Timeslot__c> tsList = scheduleIdForListTSmap.get(ts.CH_Workgroup_Schedule__c);
					tsList.add(ts);
					scheduleIdForListTSmap.remove(ts.CH_Workgroup_Schedule__c);
					scheduleIdForListTSmap.put(ts.CH_Workgroup_Schedule__c,tsList);
				}
				else{
					scheduleIdForListTSmap.put(ts.CH_Workgroup_Schedule__c, new List<CH_Workgroup_Schedule_Timeslot__c>{ts});
				}
			}
			
			//get status of schedules
			Map<Id, CH_Workgroup_Schedule__c> schedulesMap = new Map<Id, CH_Workgroup_Schedule__c>([select id, CH_Active__c from CH_Workgroup_Schedule__c where id IN : scheduleList]);
			
			for(CH_Workgroup_Schedule_Timeslot__c ts : oldMap.values()){  
				//validate only for the active schedules
				if(schedulesMap.get(ts.CH_Workgroup_Schedule__c).CH_Active__c){
					
					CH_CA_Validate_Schedule validateScheduleObj = new CH_CA_Validate_Schedule();
					if(!scheduleIdForListTSmap.containskey(ts.CH_Workgroup_Schedule__c)){  // no more Timeslots for this schedule
						system.debug('CH_WorkgroupTimeslotTriggerHandler -- no more Timeslots for this schedule');
						ts.addError(system.label.CH_CA_TimeslotNotCoverAllDay);
					}
					else{
						String result = validateScheduleObj.scheduleValidation(scheduleIdForListTSmap.get(ts.CH_Workgroup_Schedule__c));
						system.debug('CH_WorkgroupTimeslotTriggerHandler result '+result);
						if(result!= null){
							ts.addError(result + ' ');
						}
					}
				}
			}
		}  
	}*/
}