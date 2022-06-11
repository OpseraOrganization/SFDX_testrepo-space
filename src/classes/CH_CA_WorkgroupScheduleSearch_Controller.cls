/* Type:  Apex Class
* Name - CH_CA_WorkgroupScheduleSearch_Controller
* Test Class - CH_CA_WorkgroupScheduleSearch_Test
* Description - This is an Apex controller class, created to do following actions,
	1. Getting picklist values on UI i.e. Lightning component
	2. Searching for the schedules based on the given crieteria's
	3. Deleting the selected schedule.
* Developer: TCS
* */
public without sharing class CH_CA_WorkgroupScheduleSearch_Controller {	
	//Method : getselectOptions
	//Description : This method is used to get picklist values on UI.
	//parameter1 : sObject objObject : it would be valid sObject
	//parameter2 : string fld : it would be valid FIELD on given sObject
	@AuraEnabled
	public static List < String > getselectOptions(sObject objObject, string fld) {
		List < String > allOpts = new list < String > ();
		// Get the object type of the SObject.
		Schema.sObjectType objType = objObject.getSObjectType();
		
		// Describe the SObject using its object type.
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
		
		// Get a map of fields for the SObject
		map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
		
		// Get the list of picklist values for this field.
		list<Schema.PicklistEntry> values =
			fieldMap.get(fld).getDescribe().getPickListValues();
		
		// Add these values to the selectoption list.
		for (Schema.PicklistEntry a: values) {
			allOpts.add(a.getValue());
		}
		allOpts.sort();
		return allOpts;
	}	  
	
	//Method : searchSchedules
	//Description : This method is used to get return workgroup schedules based on given criterias.
	//parameters : String startDate, String endDate, String Active, String WorkgroupType, String Customer, String Region, String Country, String Severity, string Product,String Outage
	//To match criterias on the records.
	@AuraEnabled
	public static List<Object> searchSchedules(String startDate, String endDate,
			  String startTime ,String endTime,	
			  String active, String workgroupType, 
			  String customer, String region, String country, 
			  String severity, string product,String outage, 
			  String levelOfSupport, String workgroupId, String solution,
			  String productModule, String productVariant) 
	{	
		Date strtDate = Date.valueOf(startDate);
		Date edDate = Date.valueOf(endDate);
		Time strtTime = CH_CA_MS_List_Schedules_Controller.updateTime(startTime);
		Time edTime = CH_CA_MS_List_Schedules_Controller.updateTime(endTime);
		DateTime startDateTime = DateTime.newInstanceGMT(strtDate,strtTime);
		DateTime endDateTime = DateTime.newInstanceGMT(edDate,edTime);
		// DTO to send the search criteria through the layers
		CH_CA_DTO.SearchCriteriaDTO searchCriteria = new CH_CA_DTO.SearchCriteriaDTO();
		searchCriteria.country = country;
		searchCriteria.region = region;
		searchCriteria.outage = outage;
		searchCriteria.severity = severity;
		searchCriteria.customerId = String.isBlank(customer) ? null : customer;
		searchCriteria.productId = String.isBlank(product) ? null : product;
		//Added as a part of US - 26399
		searchCriteria.productModule = String.isBlank(productModule) ? null: productModule; 
		searchCriteria.productVariant = String.isBlank(productVariant) ? null: productVariant; 
		searchCriteria.solution = String.isBlank(solution) ? null: solution; 
		if (!String.isBlank(workgroupType)){
			searchCriteria.workgroupTypes.add(workgroupType);
		}
		if (!String.isBlank(levelOfSupport)){
			searchCriteria.levelOfSupports.add(levelOfSupport);			
		}
		
		//converting active check to boolean if it has value of yes then boolean will be true otherwise false only
		List<CH_Workgroup_Schedule__c> workgroupSchedules  = new List<CH_Workgroup_Schedule__c>();
		
		String sQuery  = ' SELECT Id,Name,CH_Start_Date__c,CH_Start_Time__c,CH_End_Date__c,CH_End_Time__c,CH_Start_DateTime__c,CH_End_DateTime__c,CH_Active__c, CH_Workgroup_Filters_Count__c,CH_StartDateTime__c,CH_EndDateTime__c,  '+
			' (SELECT CH_Workgroup_Type__c,CH_Region__c,CH_Country__c,CH_Severity__c,CH_Outage__c, CH_LevelOfSupport__c, CH_Solution__r.Name,CH_ProductModule__r.Name,CH_ProductVariant__r.Name  FROM CH_Workgroup_Filters__r) '+
			' FROM CH_Workgroup_Schedule__c '+
			' WHERE CH_Workgroup__c	 = : workgroupId AND CH_EndDateTime__c >= : startDateTime '+
			' AND CH_StartDateTime__c <= : endDateTime ';
			
		if(Active == 'Yes'){
			sQuery += ' AND CH_Active__c = true '; 
		}
		else if (Active == 'No') {
			sQuery += ' AND CH_Active__c = false '; 
		}
		workgroupSchedules = Database.query(sQuery);
		system.debug('CH_CA: WorkgroupSchedules ' + workgroupSchedules);
		List<CH_CA_Workgroup_Weight> sortedSchedules = getSortedSchedules(workgroupSchedules, searchCriteria);
		return sortedSchedules;
	}
	
	//Method : getSortedSchedules
	//Description : This method is used to get sorted list of workgroup schedules 
	//parameter1 : List<CH_Workgroup_Schedule__c> WorkgroupSchedules : List of schedules which are yet to sort
	//parameter2 : Case currentCase : class instance which are needed to passed to get weights
	public static List<CH_CA_Workgroup_Weight> getSortedSchedules(List<CH_Workgroup_Schedule__c> workgroupSchedules , CH_CA_DTO.SearchCriteriaDTO searchCriteria){
		
		//Create a set of schedules Ids to use in methods
		Set<Id> workgroupSchedulesIds = new Set<Id>();
		for(CH_Workgroup_Schedule__c ws : workgroupSchedules){
			workgroupSchedulesIds.add(ws.id);
		}
		
		//For a list of schedules get the filters		
		List<CH_Workgroup_Filter__c> filters = new CH_CA_Workgroup_Filters().getWorkgroupFilters(searchCriteria, workgroupSchedulesIds);
		system.debug('CH_CA: filters '+filters);		
		//map of id per CH_Workgroup_Schedule__c
		Map<Id, CH_Workgroup_Schedule__c> scheduleMap = new Map<ID,CH_Workgroup_Schedule__c>(workgroupSchedules);

		List<CH_Workgroup_Schedule__c> workgroupSchedulesWithFiltersMatching = new List<CH_Workgroup_Schedule__c>();
		//create list of schedules with filters
		for(CH_Workgroup_Filter__c wgFilter : filters){
			workgroupSchedulesWithFiltersMatching.add(scheduleMap.get(wgFilter.CH_Workgroup_Schedule__c));
		}
		
		//get the correspondent weight for the schedules, according to the filters
		Map<Id, integer> workgroupWeightMap = new CH_CA_Workgroup_Filters().getPerWorkgroup_AllScheduleWithWeight(searchCriteria, workgroupSchedulesWithFiltersMatching, filters);
		system.debug('CH_CA: workgroupWeightMap '+workgroupWeightMap);

		//Creating sorted list of CH_CA_Workgroup_Weight by weight
		List<CH_CA_Workgroup_Weight> sortedSchedules  = new List<CH_CA_Workgroup_Weight>();
		
		//add all the schedules with a matching filter
		for(CH_Workgroup_Schedule__c scheduleWithFilter : workgroupSchedulesWithFiltersMatching){
			sortedSchedules.add(new CH_CA_Workgroup_Weight(scheduleMap.get(scheduleWithFilter.Id), workgroupWeightMap.get(scheduleWithFilter.Id)));
		}
		//add all the schedules with no filter (null values)
		for(CH_Workgroup_Schedule__c schedule : workgroupSchedules){
			if(schedule.CH_Workgroup_Filters_Count__c == 0 ){
	sortedSchedules.add(new CH_CA_Workgroup_Weight(schedule, 0));
			}
		}

		system.debug('CH_CA: sortedSchedules '+sortedSchedules );
		return sortedSchedules;
	}
  
	//Method : deleteSchedule
	//Description : This method is used to delete required workgroup schedule.
	//parameter1 : String idstr : string id of the schedule to be deleted
	@AuraEnabled
	public static void deleteSchedule(String idstr){
		CH_Workgroup_Schedule__c deletedRecord = new CH_Workgroup_Schedule__c();
		deletedRecord.Id = idstr;
		delete deletedRecord;
	}
	
	@AuraEnabled
	public static Id getUserDetail(){
		
		Id userId = UserInfo.getUserId();
		return userId;
	}
	// NOKIASC-15336:Get the Search Schedule per User
	@AuraEnabled
	public static List<CH_Workgroup_Member_Timeslot_Association__c>  getSchedulePerUser(String startDate, String endDate, String startTime , String endTime, String userId){
		List<CH_Workgroup_Member_Timeslot_Association__c> workgroup_Member_Timeslot_Association = new List<CH_Workgroup_Member_Timeslot_Association__c>();
		Set<Id> scheduleIdList = new Set<Id>();
		List<CH_Workgroup_Schedule__c> workgroupSchedules;
		//Converting string to DateTime
		Date strtDate = Date.valueOf(startDate);
		Date edDate = Date.valueOf(endDate);
		Time strtTime = CH_CA_MS_List_Schedules_Controller.updateTime(startTime);
		Time edTime = CH_CA_MS_List_Schedules_Controller.updateTime(endTime);
		DateTime startDateTime = DateTime.newInstanceGMT(strtDate,strtTime);
		DateTime endDateTime = DateTime.newInstanceGMT(edDate,edTime);
		
		//Get schedule within the time entry
		String soqlQuery ='SELECT Id FROM CH_Workgroup_Schedule__c ' + 
			' WHERE CH_EndDateTime__c >= : startDateTime '+
			' AND CH_StartDateTime__c <= : endDateTime AND CH_Active__c = true  ';
		
		workgroupSchedules = Database.query(soqlQuery);
	
		//create scheduleIdList in set
		for (CH_Workgroup_Schedule__c tempSchedule:workgroupSchedules){
			scheduleIdList.add(tempSchedule.Id);
		}
		if (scheduleIdList.size()>0){
			//get data for Search Schedule per User
			workgroup_Member_Timeslot_Association=[SELECT CH_Workgroup_Schedule_Timeslot__r.CH_Schedule_Name__c, 
			   CH_Schedule_Type__c,CH_Workgroup_Member__r.CH_Role__c,
			   CH_Workgroup_Member__r.Name, CH_Workgroup_Schedule_Timeslot__r.CH_Start_Time__c,
			   CH_Workgroup_Schedule_Timeslot__r.CH_End_Time__c,CH_Workgroup_Schedule_Timeslot__r.CH_Day__c, 
			   CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Time_Zone__c ,
			   CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Workgroup__r.Name 
			   FROM CH_Workgroup_Member_Timeslot_Association__c 
			   WHERE CH_Workgroup_Member__r.CH_User__c=:userId AND CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__c=:scheduleIdList ];
		}
		return workgroup_Member_Timeslot_Association;
	}
	
	@AuraEnabled
	public static GetDateTimeValues getDateTimeDetails(){
		GetDateTimeValues gtDateTimedetails = new GetDateTimeValues();
		gtDateTimedetails.getStartDate = Datetime.now().Date();
		gtDateTimedetails.getEndDate = Datetime.now().date().addMonths(1);
		gtDateTimedetails.getStartTime = Datetime.now().Time();
		return gtDateTimedetails;
	}
	
	public class GetDateTimeValues {
		@AuraEnabled public Date getStartDate {get;set;}
		@AuraEnabled public Date getEndDate {get;set;}
		@AuraEnabled public Time getStartTime {get;set;}
	}
}