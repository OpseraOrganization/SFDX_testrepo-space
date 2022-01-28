/* Type:  Apex Class
* Name - CH_CA_Workgroup_Member_DTO
* Description - This class is used to retrive Data for various object and store in various Maps.
* Developer: TCS
* */
public class CH_CA_Workgroup_Member_DTO {
	//getting all workgrou
	public Map<Id,CH_Workgroup__c> mapAllWorkgroups;
	//getting all workgroupSchedules
	public Map<Id,CH_Workgroup_Schedule__c> mapAllWorkgroupSchedules;
	//getting all filters
	public Map<Id,CH_Workgroup_Filter__c> mapAllfilters;
	//getting all filtersassociation with customer
	public Map<Id,CH_Workgroup_Filter_Customer_Association__c> mapCustomerAssociation;
	//getting all filtersassociation with product
	public Map<Id,CH_Workgroup_Filter_Product_Association__c> mapProductAssociation;
	//getting all Workgroup Schedule Timeslot
	public Map<Id,CH_Workgroup_Schedule_Timeslot__c> mapWorkgroupScheduleTimeslot;
	//getting all Workgroup Schedule Timeslot Association
	public Map<Id,CH_Workgroup_Member_Timeslot_Association__c> mapWgScheduleTimslotAssociation;
	//getting all workgroup members
	public Map<Id,CH_Workgroup_Member__c> mapAllWorkgroupMembers;
	//getting case
	public Case supportCase;
	//gettin map of ROTA
	public Map<Id,CH_Workgroup_Event__c> mapROTA;
	//constructor needs to define for schedule search.because i am reusing its Maps.
	public CH_CA_Workgroup_Member_DTO(){}
	
	public CH_CA_Workgroup_Member_DTO(set<Id> setWorkgroupIds){
		if(setWorkgroupIds != null && setWorkgroupIds.size() > 0){
			mapAllWorkgroupSchedules = new Map<Id,CH_Workgroup_Schedule__c>([SELECT Id,CH_Description__c,CH_End_DateTime__c,CH_Start_DateTime__c,CH_Workgroup_Filters_Count__c,CH_Workgroup__c,Name,CH_Time_Zone__c
																			 FROM CH_Workgroup_Schedule__c 
																			 WHERE CH_Workgroup__c IN : setWorkgroupIds
																			 AND CH_Start_DateTime__c <= :system.now() AND CH_End_DateTime__c >= :system.now()
																			 AND CH_Active__c = true]);
			system.debug('size of mapAllWorkgroupSchedules'+mapAllWorkgroupSchedules.size());
		}
		if(mapAllWorkgroupSchedules != null && mapAllWorkgroupSchedules.size() > 0){
			//getting all filters related to schedules
			mapAllfilters = new Map<Id,CH_Workgroup_Filter__c>([SELECT Id, Name, CH_Country__c, CH_Outage__c,
																CH_Region__c, CH_Severity__c, CH_Workgroup_Schedule__c,
																CH_Workgroup_Type__c
																FROM CH_Workgroup_Filter__c 
																WHERE CH_Workgroup_Schedule__c IN : mapAllWorkgroupSchedules.keySet()]);
			system.debug('size of mapAllfilters'+mapAllfilters.size());   
			mapWorkgroupScheduleTimeslot = new Map<Id,CH_Workgroup_Schedule_Timeslot__c>([SELECT Id, CH_Day__c,CH_End_Time__c,CH_SortOrder__c,CH_Start_Time__c,CH_Workgroup_Id__c,CH_Workgroup_Schedule__c,Name 
																						  FROM CH_Workgroup_Schedule_Timeslot__c
																						  WHERE CH_Workgroup_Schedule__c IN :mapAllWorkgroupSchedules.keySet()]);
			system.debug('size of mapWorkgroupScheduleTimeslot'+mapWorkgroupScheduleTimeslot.size());   
		}
		if(mapAllfilters != null && mapAllfilters.size() > 0){
			//getting all customer association with filters
			mapCustomerAssociation = new Map<Id,CH_Workgroup_Filter_Customer_Association__c>([SELECT Id,CH_Account__c , CH_Workgroup_Filter__c
																							  FROM CH_Workgroup_Filter_Customer_Association__c
																							  WHERE CH_Workgroup_Filter__c in : mapAllfilters.keySet()]);
			system.debug('size of mapCustomerAssociation'+mapCustomerAssociation.size());
			mapProductAssociation = new Map<Id,CH_Workgroup_Filter_Product_Association__c>([SELECT Id,CH_Product__c, CH_Workgroup_Filter__c
																							FROM CH_Workgroup_Filter_Product_Association__c
																							WHERE CH_Workgroup_Filter__c in : mapAllfilters.keySet()]);
			system.debug('size of mapProductAssociation'+mapProductAssociation.size());
		}
	}
	
}