/****************************************
* Trigger Name : CH_WorkgroupTimeslotAssociationHandler 
* Created Date: 18-09-2019
* Created By : Sonia Reis
*****************************************/
public class CH_WorkgroupTimeslotAssociationHandler extends TriggerHandler {
	/*
	private Map<Id, CH_Workgroup_Member_Timeslot_Association__c> oldMap;
	
	public CH_WorkgroupTimeslotAssociationHandler() {
		this.oldMap = (Map<Id, CH_Workgroup_Member_Timeslot_Association__c>) Trigger.oldMap;
	}

	//Method Name: validateBeforeDelete
	//Parameter: Map<Id, CH_Workgroup_Member_Timeslot_Association__c>
	//Description: Used to check whether atleast one workgroup member is associated with this timeslot
	public static void validateBeforeDelete(Map<Id, CH_Workgroup_Member_Timeslot_Association__c> oldMap)
	{
		System.debug('CH_WorkgroupTimeslotAssociationHandler -- BEFORE DELETE '+ oldMap);
		
		if(oldMap!=null && oldMap.size()>0){

			Set<ID> scheduleIDSet = new  Set<ID>();
			Set<ID> timeslotIDSet = new  Set<ID>();
			for(CH_Workgroup_Member_Timeslot_Association__c member : oldMap.values()){
				scheduleIDSet.add(member.CH_Schedule_Id__c);
				timeslotIDSet.add(member.CH_Workgroup_Schedule_Timeslot__c);
			}
			Map<Id, CH_Workgroup_Schedule__c> schedulesMap = new Map<Id, CH_Workgroup_Schedule__c>([select id, CH_Active__c from CH_Workgroup_Schedule__c where id IN : scheduleIDSet]);
			
			
			CH_CA_Validate_Schedule validate = new CH_CA_Validate_Schedule();
			Map<Id, String> resultMap = validate.atLeastOneWorkgroupMember(timeslotIDSet);
			
			for(CH_Workgroup_Member_Timeslot_Association__c member : oldMap.values()){
				if(schedulesMap.get(member.CH_Schedule_Id__c).CH_Active__c){
					if(resultMap.containsKey(member.CH_Workgroup_Schedule_Timeslot__c)){
						system.debug('CH_WorkgroupTimeslotAssociationHandler result '+ resultMap.get(member.CH_Workgroup_Schedule_Timeslot__c));
						member.addError(resultMap.get(member.CH_Workgroup_Schedule_Timeslot__c));
					}
				}
			}
		}  
		 System.debug('CH_WorkgroupTimeslotAssociationHandler -- END BEFORE DELETE ');
	}*/
}