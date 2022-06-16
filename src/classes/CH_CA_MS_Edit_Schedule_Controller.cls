public without sharing class CH_CA_MS_Edit_Schedule_Controller {
	
	// Get the schedule details list
	@AuraEnabled
	public static CH_Workgroup_Schedule__c getSchedule(Id scheduleId){
		if (scheduleId == null){
			return new CH_Workgroup_Schedule__c();
		}
		
		CH_Workgroup_Schedule__c workgroupSchedule;
		workgroupSchedule = [SELECT Id, Name,CH_Start_Date__c,CH_Start_Time__c,CH_End_Date__c,CH_End_Time__c,
		(SELECT Id, Name
		 FROM CH_Workgroup_Filters__r),
		(SELECT Id, Name, CH_Day__c, CH_Start_Time__c, CH_End_Time__c   
	FROM Workgroup_Schedule_Timeslots__r)
		FROM CH_Workgroup_Schedule__c 
		WHERE Id =:scheduleId];
		
		return workgroupSchedule;
	}

	// Get the locale of the logged in user
	// getLocale() returns en_US this is converted to international standard of en-US
	@AuraEnabled
	public static string getLocale(){
		String userLocale = UserInfo.getLocale();
		return userLocale.replace('_','-');
	}	


	// Get the filter details
	// The related lists will converted to RelatedFilterObjects (class defined in this class).
	// To return multiple datasets a map is used
	@AuraEnabled
	public static Map<string,List<Object>> getFilter(Id scheduleId){
		Map<string,List<Object>> filterMap = new Map<string,List<Object>>();
		
		List<CH_Workgroup_Filter__c> scheduleFilters;
		//Changes added for NOKIASC-32921
		scheduleFilters = [SELECT Id, Name,
		(SELECT Id, CH_Account__r.Name, CH_Account__r.AccountNumber  
		 FROM Workgroup_Filter_Customer_Associations__r),
		(SELECT Id, CH_Product__r.Name,CH_Product__r.ProductCode   
	FROM Workgroup_Filter_Product_Associations__r)
		FROM CH_Workgroup_Filter__c
		WHERE CH_Workgroup_Schedule__c =:scheduleId];
		
		filterMap.put('filter', scheduleFilters);
		// Create the customer related objects
		List<RelatedFilterObject> customerRelatedObjects = new List<RelatedFilterObject>();
		for(CH_Workgroup_Filter__c filter : scheduleFilters){
			for(CH_Workgroup_Filter_Customer_Association__c associationRecord : filter.Workgroup_Filter_Customer_Associations__r){
	RelatedFilterObject filterObject = new RelatedFilterObject();
	filterObject.id = associationRecord.id;
	filterObject.relatedObjectId = associationRecord.CH_Account__c;
	filterObject.filterId = filter.id;
	filterObject.label = associationRecord.CH_Account__r.Name+' ('+associationRecord.CH_Account__r.AccountNumber+')';
	filterObject.deleted = false;
	customerRelatedObjects.add(filterObject);
			}
		}
		filterMap.put('filterCustomers', customerRelatedObjects);
		// Create the product related objects
		List<RelatedFilterObject> productRelatedObjects = new List<RelatedFilterObject>();
		for(CH_Workgroup_Filter__c filter : scheduleFilters){
			for(CH_Workgroup_Filter_Product_Association__c associationRecord : filter.Workgroup_Filter_Product_Associations__r){
	RelatedFilterObject filterObject = new RelatedFilterObject();
	filterObject.id = associationRecord.id;
	filterObject.relatedObjectId = associationRecord.CH_Product__c;
	filterObject.filterId = filter.id;
	//Changes added for NOKIASC-32921
	filterObject.label = associationRecord.CH_Product__r.Name+' ('+associationRecord.CH_Product__r.ProductCode+')';
	filterObject.deleted = false;
	productRelatedObjects.add(filterObject);
			}
		}
		filterMap.put('filterProducts', productRelatedObjects); 
		
		return filterMap;
	}

	// Delete the current schedule
	@AuraEnabled
	public static Map<Id,string> saveSchedule(CH_Workgroup_Schedule__c scheduleFields){
		Savepoint savePointValidation = Database.setSavepoint();

		// Save the update
		CH_Workgroup_Schedule__c schedule =new CH_Workgroup_Schedule__c();
		if (scheduleFields.Id != null){
			schedule.Id=scheduleFields.Id;
		}
		else{
			schedule.CH_Workgroup__c=scheduleFields.CH_Workgroup__c;
		}
		schedule.Name=scheduleFields.Name;
		schedule.CH_Description__c=scheduleFields.CH_Description__c;
		schedule.CH_Start_Date__c=scheduleFields.CH_Start_Date__c;
		schedule.CH_Start_Time__c=scheduleFields.CH_Start_Time__c;
		schedule.CH_StartDateTime__c = DateTime.newInstanceGMT(scheduleFields.CH_Start_Date__c,scheduleFields.CH_Start_Time__c);
		DateTime startDateTime = DateTime.newInstanceGMT(scheduleFields.CH_Start_Date__c,scheduleFields.CH_Start_Time__c);
		Integer addDifference=ProcessTimeDifference(scheduleFields.CH_Time_Zone__c);
		schedule.CH_Start_DateTime__c=startDateTime.addSeconds(addDifference);
		schedule.CH_End_Date__c=scheduleFields.CH_End_Date__c;
		schedule.CH_End_Time__c=scheduleFields.CH_End_Time__c;
		schedule.CH_EndDateTime__c = DateTime.newInstanceGMT(scheduleFields.CH_End_Date__c,scheduleFields.CH_End_Time__c);
		DateTime endDateTime = DateTime.newInstanceGMT(scheduleFields.CH_End_Date__c,scheduleFields.CH_End_Time__c);
		schedule.CH_End_DateTime__c=endDateTime.addSeconds(addDifference);
		schedule.CH_Active__c=scheduleFields.CH_Active__c;
		schedule.CH_Time_Zone__c=scheduleFields.CH_Time_Zone__c;
		system.debug('Schedule is '+schedule);
		upsert schedule;		
		string scheduleName = [SELECT Name FROM CH_Workgroup_Schedule__c WHERE Id = :schedule.Id LIMIT 1].Name;

		// Validate the schedule
		CH_CA_Validate_Schedule scheduleValidation = new CH_CA_Validate_Schedule();
		string errorMessage = scheduleValidation.validate(new List<Id>{schedule.Id});
		// If the validation failed Then rollback
		if (scheduleValidation.stopSave){
			system.debug('CH_CA: Schedule cannot be saved because of validation errors. Save rolled back');
			Database.rollback(savePointValidation);

			// Replace the timeslot name of the new timeslot with Edited Schedule
			errorMessage = errorMessage.replace(scheduleName, 'Edited Schedule');
			return new Map<Id, string>{schedule.id => errorMessage};
		}
		else {
			system.debug('CH_CA: Schedule saved');
			return new Map<Id, string>{schedule.id => ''};			
		}
	}
	
	// Delete the current schedule
	@AuraEnabled
	public static string deleteSchedule(Id scheduleId){
		CH_Workgroup_Schedule__c schedule = new CH_Workgroup_Schedule__c(id = scheduleId);
		Database.DeleteResult deleteStatus = Database.delete(schedule, false);

		string statusMessage;
		if (deleteStatus.isSuccess()){
			statusMessage = 'Schedule Deleted';
		}
		else {
			statusMessage = deleteStatus.getErrors()[0].getMessage();
		}
		return statusMessage;
	}

	// Delete the current schedule's filter
	@AuraEnabled
	public static string deleteFilter(Id filterId){
		CH_Workgroup_Filter__c filter = new CH_Workgroup_Filter__c(id = filterId);
		Database.DeleteResult deleteStatus = Database.delete(filter, false);

		string statusMessage;
		if (deleteStatus.isSuccess()){
			statusMessage = 'Filter Deleted';
		}
		else {
			statusMessage = deleteStatus.getErrors()[0].getMessage();
		}
		return statusMessage;
	}
	
	// Delete the selected timeslots and return the status of the deletion
	@AuraEnabled
	public static string deleteSelectedTimeSlots(List<Id> selectedTimeSlotIds){
		//Delete the timeslots
		List<CH_Workgroup_Schedule_Timeslot__c> selectedTimeslots;
		selectedTimeslots = [SELECT Id FROM CH_Workgroup_Schedule_Timeslot__c WHERE Id in :selectedTimeSlotIds];

		return CH_CA_MS_Util.deleteSelectedObjects(selectedTimeslots, 'timeslot');
	}

	// Save the filter related lists
	@AuraEnabled
	public static string saveFilterRelatedLists(List<RelatedFilterObject> productsToSave, 
			List<RelatedFilterObject> customersToSave){

		string message;		
		message = updateFilterRelatedRecords(productsToSave,'CH_Workgroup_Filter_Product_Association__c');
		message += updateFilterRelatedRecords(customersToSave,'CH_Workgroup_Filter_Customer_Association__c');
	
		return message;
	}

	private static string updateFilterRelatedRecords(List<RelatedFilterObject> recordsToSave, string objectName){
		string message;
		string errorObject = (objectName == 'CH_Workgroup_Filter_Product_Association__c')? 'filter product' : 'filter customer';
		string relatedFieldName = (objectName == 'CH_Workgroup_Filter_Product_Association__c')? 'CH_Product__c' : 'CH_Account__c';
		
		Schema.SobjectType filterObjectType = Schema.getGlobalDescribe().get(objectName);
		String filterListObjectType = 'List<' + objectName + '>';
		List<SObject> insertFilterRecords = (List<SObject>)Type.forName(filterListObjectType).newInstance();
		List<SObject> deleteFilterRecords = (List<SObject>)Type.forName(filterListObjectType).newInstance();

		// Loop through all the objects to determine if they were added or deleted
		for(RelatedFilterObject filterObject : recordsToSave){
			if (filterObject.id == null && filterObject.deleted == false){
	// new record
	sObject object_instance = filterObjectType.newSObject();
	object_instance.put('CH_Workgroup_Filter__c', filterObject.filterId);
	object_instance.put(relatedFieldName, filterObject.relatedObjectId);
	insertFilterRecords.add(object_instance);
			}
			if (filterObject.id != null && filterObject.deleted == true){
	// delete record
	sObject object_instance = filterObjectType.newSObject();
	object_instance.put('id', filterObject.id);
	deleteFilterRecords.add(object_instance);
			}
		}
		message = CH_CA_MS_Util.deleteSelectedObjects(deleteFilterRecords, errorObject);
		message += CH_CA_MS_Util.saveObjects(insertFilterRecords, errorObject);
		System.debug('CH_CA: ' + message);
		return message;		
	}
	
	//Calculate the Timedifference 
	Public static Integer ProcessTimeDifference(String timeZone) {
		Integer timeDifference;
		Decimal getTimeDiff;
		switch on timeZone {
			when 'UTC' { timeDifference=0*60*60; }
			when 'UTC -1' { timeDifference=1*60*60; }
			when 'UTC -2' { timeDifference=2*60*60; }
			when 'UTC -2:30' { getTimeDiff=2.5*60*60;
							  timeDifference=Integer.valueOf(getTimeDiff); }
			when 'UTC -3' {  timeDifference=3*60*60; }
			when 'UTC -3:30' {  getTimeDiff=3.5*60*60;
							  timeDifference=Integer.valueOf(getTimeDiff);}
			when 'UTC -4' {  timeDifference=4*60*60; }
			when 'UTC -5' {  timeDifference=5*60*60; }
			when 'UTC -6' { timeDifference=6*60*60; }
			when 'UTC -7' {  timeDifference=7*60*60; }
			when 'UTC -8' { timeDifference=8*60*60; }
			when 'UTC -9' {	timeDifference=9*60*60; }
			when 'UTC -9:30' {  getTimeDiff=9.5*60*60;
							  timeDifference=Integer.valueOf(getTimeDiff); }
			when 'UTC -10' { timeDifference=10*60*60; }
			when 'UTC -11' { timeDifference=11*60*60; }
			when 'UTC -12' { timeDifference=12*60*60; }
			when 'UTC +0' { timeDifference=0*60*60; }
			when 'UTC +1' {  timeDifference=-1*60*60; } 
			when 'UTC +2' { timeDifference=-2*60*60; } 
			when 'UTC +3' {  timeDifference=-3*60*60;} 
			when 'UTC +3:30' { getTimeDiff=-3.5*60*60;
							  timeDifference=Integer.valueOf(getTimeDiff); } 
			when 'UTC +4' { timeDifference=-4*60*60;} 
			when 'UTC +4:30' { getTimeDiff=-4.5*60*60;
							  timeDifference=Integer.valueOf(getTimeDiff);} 
			when 'UTC +5' { timeDifference=-5*60*60;} 
			when 'UTC +5:30' {  getTimeDiff=-5.5*60*60;
							  timeDifference=Integer.valueOf(getTimeDiff);} 
			when 'UTC +5:45' {  getTimeDiff=-5.75*60*60;
							  timeDifference=Integer.valueOf(getTimeDiff); } 
			when 'UTC +6' { timeDifference=-6*60*60;} 
			when 'UTC +6:30' { getTimeDiff=-6.5*60*60;
							  timeDifference=Integer.valueOf(getTimeDiff);} 
			when 'UTC +7' { timeDifference=-7*60*60; }
			when 'UTC +8' { timeDifference=-8*60*60;}
			when 'UTC +8:30' { getTimeDiff=-8.5*60*60;
							  timeDifference=Integer.valueOf(getTimeDiff);}
			when 'UTC +8:45' { getTimeDiff=-8.75*60*60;
							  timeDifference=Integer.valueOf(getTimeDiff);}
			when 'UTC +9' {timeDifference=-9*60*60; }
			when 'UTC +9:30' { getTimeDiff=-9.5*60*60;
							  timeDifference=Integer.valueOf(getTimeDiff);  }
			when 'UTC +10' { timeDifference=-10*60*60;}
			when 'UTC +11' { timeDifference=-11*60*60;}
			when 'UTC +12' { timeDifference=-12*60*60;}
			when 'UTC +12:45'{ getTimeDiff=-12.75*60*60;
							   timeDifference=Integer.valueOf(getTimeDiff);}
			when 'UTC +13' {timeDifference=-13*60*60;}
			when 'UTC +13:45' {getTimeDiff=-13.75*60*60;
							   timeDifference=Integer.valueOf(getTimeDiff);}
			when 'UTC +14' { timeDifference=-14*60*60;}
			when else{ //Do Nothing
		}					
		}
		return timeDifference;
	}
	
	public class RelatedFilterObject {
		@AuraEnabled public String id {get;set;}
		@AuraEnabled public String relatedObjectId {get;set;}
		@AuraEnabled public String filterId {get;set;}
		@AuraEnabled public String label {get;set;}
		@AuraEnabled public Boolean deleted {get;set;}
	}
}