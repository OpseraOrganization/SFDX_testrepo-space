/* Type:  Apex Class
* Name - CH_CA_WorkgroupScheduleSearch_Controller
* Test Class - CH_CA_WorkgroupScheduleSearch_Test
* Description - This is an Apex controller class, created to do following actions,
	1. Getting picklist values on UI i.e. Lightning component
	2. Searching for the schedules based on the given crieteria's
	3. Deleting the selected schedule.
* Developer: TCS
* */
public class CH_CA_WorkgroupScheduleSearch_Controller {	
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
	public static List<Object> searchSchedules(String startDate, String endDate, String Active, String WorkgroupType, 
											   String Customer, String Region, String Country, 
											   String Severity, string Product,String Outage, 
											   String LevelOfSupport, String workgroupId, String Solution,
											   String ProductModule, String ProductVariant) 
	{		
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
		if (!String.isBlank(WorkgroupType)){
			searchCriteria.workgroupTypes.add(WorkgroupType);
		}
		if (!String.isBlank(LevelOfSupport)){
			searchCriteria.levelOfSupports.add(LevelOfSupport);			
		}
		
		//Converting string to date
		DateTime dateStart = convertStringToDateTime(startDate);
		DateTime dateEnd = convertStringToDateTime(endDate);
		
		//converting active check to boolean if it has value of yes then boolean will be true otherwise false only
		List<CH_Workgroup_Schedule__c> WorkgroupSchedules  = new List<CH_Workgroup_Schedule__c>();
		
		String sQuery  = ' SELECT Id,Name,CH_Start_DateTime__c,CH_End_DateTime__c,CH_Active__c, CH_Workgroup_Filters_Count__c, '+
			' (SELECT CH_Workgroup_Type__c,CH_Region__c,CH_Country__c,CH_Severity__c,CH_Outage__c, CH_LevelOfSupport__c, CH_Solution__r.Name,CH_ProductModule__r.Name,CH_ProductVariant__r.Name  FROM CH_Workgroup_Filters__r) '+
			' FROM CH_Workgroup_Schedule__c '+
			' WHERE CH_Workgroup__c	 = : workgroupId AND CH_End_DateTime__c >= : dateStart '+
			' AND CH_Start_DateTime__c <= : dateEnd ';
			
		if(Active == 'Yes'){
			sQuery += ' AND CH_Active__c = true '; 
		}
		else if (Active == 'No') {
			sQuery += ' AND CH_Active__c = false '; 
		}
		WorkgroupSchedules = Database.query(sQuery);
		system.debug('CH_CA: WorkgroupSchedules ' + WorkgroupSchedules);
		List<CH_CA_Workgroup_Weight> sortedSchedules = getSortedSchedules(WorkgroupSchedules, searchCriteria);
		return sortedSchedules;
	}
	
	//Method : convertStringToDateTime
	//Description : This method is used to convert string Date to DateTime format.
	//parameter1 : string strDate : it is a string Date
	private static DateTime convertStringToDateTime (string strDate){
		DateTime datetoDateTime ;
		if(strDate != null){
			// need convert to '2019-04-18 11:57:10' format where given format would be 
			string onlyDate = strDate.substringBefore('T');
			string onlyTime = strDate.substringBetween('T','Z');
			string generatedStardDate = onlyDate+ ' '+onlyTime;
			datetoDateTime = DateTime.valueOf(generatedStardDate);
		}
		return datetoDateTime;
	}
	
	//Method : getSortedSchedules
	//Description : This method is used to get sorted list of workgroup schedules 
	//parameter1 : List<CH_Workgroup_Schedule__c> WorkgroupSchedules : List of schedules which are yet to sort
	//parameter2 : Case currentCase : class instance which are needed to passed to get weights
	public static List<CH_CA_Workgroup_Weight> getSortedSchedules(List<CH_Workgroup_Schedule__c> WorkgroupSchedules , CH_CA_DTO.SearchCriteriaDTO searchCriteria){
		
		//Create a set of schedules Ids to use in methods
		Set<Id> WorkgroupSchedulesIds = new Set<Id>();
		for(CH_Workgroup_Schedule__c ws : WorkgroupSchedules){
			WorkgroupSchedulesIds.add(ws.id);
		}
		
		//For a list of schedules get the filters		
		List<CH_Workgroup_Filter__c> filters = new CH_CA_Workgroup_Filters().getWorkgroupFilters(searchCriteria, WorkgroupSchedulesIds);
		system.debug('CH_CA: filters '+filters);		
		//map of id per CH_Workgroup_Schedule__c
		Map<Id, CH_Workgroup_Schedule__c> scheduleMap = new Map<ID,CH_Workgroup_Schedule__c>(WorkgroupSchedules);

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
		for(CH_Workgroup_Schedule__c schedule : WorkgroupSchedules){
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
	
	//Method : getStartDate
	//Description : This method is used to return current date time
	@AuraEnabled
	public static DateTime getStartDate(){
		return system.now();
	}
	
	//Method : getEndDate
	//Description : This method is used to return date time +1 Months
	@AuraEnabled
	public static DateTime getEndDate(){
		return system.now().addMonths(1);
	}
	
	@AuraEnabled
	public static Id getUserDetail(){
		
		Id userId = UserInfo.getUserId();
		//String userName = UserInfo.getName();
		return userId;
	}
	// NOKIASC-15336:Get the Search Schedule per User
	@AuraEnabled
	public static List<CH_Workgroup_Member_Timeslot_Association__c>  getSchedulePerUser(String startDate, String endDate,String userId){
		List<CH_Workgroup_Member_Timeslot_Association__c> Workgroup_Member_Timeslot_Association;
		Set<Id> scheduleIdList = new Set<Id>();
		List<CH_Workgroup_Schedule__c> workgroupSchedules;
		//Converting string to date
		DateTime dateStart = convertStringToDateTime(startDate);
		DateTime dateEnd = convertStringToDateTime(endDate);
		
		//Get schedule within the time entry
		String soqlQuery ='SELECT Id FROM CH_Workgroup_Schedule__c ' + 
			' WHERE CH_End_DateTime__c >= : dateStart '+
			' AND CH_Start_DateTime__c <= : dateEnd AND CH_Active__c = true  ';
		
		workgroupSchedules = Database.query(soqlQuery);
				
		//create scheduleIdList in set
		for (CH_Workgroup_Schedule__c tempSchedule:workgroupSchedules){
			scheduleIdList.add(tempSchedule.Id);
		}
		if (scheduleIdList.size()>0){
			//get data for Search Schedule per User
			Workgroup_Member_Timeslot_Association=[SELECT CH_Workgroup_Schedule_Timeslot__r.CH_Schedule_Name__c, 
												   CH_Schedule_Type__c,CH_Workgroup_Member__r.CH_Role__c,
												   CH_Workgroup_Member__r.Name, CH_Workgroup_Schedule_Timeslot__r.CH_Start_Time__c,
												   CH_Workgroup_Schedule_Timeslot__r.CH_End_Time__c,CH_Workgroup_Schedule_Timeslot__r.CH_Day__c, 
												   CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Time_Zone__c ,
												   CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Workgroup__r.Name 
												   FROM CH_Workgroup_Member_Timeslot_Association__c 
												   WHERE CH_Workgroup_Member__r.CH_User__c=:userId AND CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__c=:scheduleIdList ];
		}
		return Workgroup_Member_Timeslot_Association;
	}
}