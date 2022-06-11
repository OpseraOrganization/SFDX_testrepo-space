public class CH_CA_MS_Edit_Timeslot_Controller {

	// Get the schedule list
	@AuraEnabled
	public static CH_Workgroup_Schedule__c getSchedule(Id scheduleId){
		if (scheduleId == null){
			return new CH_Workgroup_Schedule__c();
		}
		
		CH_Workgroup_Schedule__c schedule;
		schedule = [SELECT Id, CH_Active__c, Name
					FROM CH_Workgroup_Schedule__c 
					WHERE Id =:scheduleId];

		return schedule;
	}
	
	// Get the timeslot
	@AuraEnabled
	public static CH_Workgroup_Schedule_Timeslot__c getTimeSlot(Id timeslotId){
		if (timeslotId == null){
			return new CH_Workgroup_Schedule_Timeslot__c();
		}
		
		CH_Workgroup_Schedule_Timeslot__c timeSlot;
		timeSlot = [SELECT Id, CH_Start_Time__c, CH_End_Time__c, Name, 
					(SELECT Id, CH_Workgroup_Member_Name__c , CH_Schedule_Type__c, CH_Workgroup_Member_Role__c	 
				 	 FROM Workgroup_Member_Timeslot_Association__r)
					FROM CH_Workgroup_Schedule_Timeslot__c 
					WHERE Id =:timeslotId];

		return timeSlot;
	}

	// Delete the current timeslot
	@AuraEnabled
	public static string deleteTimeslot(Id timeslotId, Id scheduleId){
		Savepoint savePointValidation = Database.setSavepoint();

		CH_Workgroup_Schedule_Timeslot__c timeslot = new CH_Workgroup_Schedule_Timeslot__c(id = timeslotId);
		Database.DeleteResult deleteStatus = Database.delete(timeslot, false);

		string statusMessage;
		if (deleteStatus.isSuccess()){
			statusMessage = 'Timeslot Deleted';
			// Validate the schedule
			CH_CA_Validate_Schedule scheduleValidation = new CH_CA_Validate_Schedule();
			string errorMessage = scheduleValidation.validate(new List<Id>{scheduleId});
			// If the validation failed Then rollback
			if (scheduleValidation.stopSave){
				system.debug('CH_CA: Timeslot cannot be deleted because of Schedule validation errors. Deletion rolled back');
				Database.rollback(savePointValidation);
				
				return errorMessage;
			}
		}
		else {
			statusMessage = 'An error occured: ' + deleteStatus.getErrors()[0].getMessage();
		}
				
		return statusMessage;
	}

	// Delete the selected timeslot associations and return the status of the deletion
	@AuraEnabled
	public static string deleteSelectedTimeSlotAssociations(List<Id> selectedTimeSlotAssocationIds, Id scheduleId){
		Savepoint savePointValidation = Database.setSavepoint();

		//Delete the timeslot members
		List<CH_Workgroup_Member_Timeslot_Association__c> selectedTimeslotAssociations;
		selectedTimeslotAssociations = [SELECT Id FROM CH_Workgroup_Member_Timeslot_Association__c WHERE Id in :selectedTimeSlotAssocationIds];

		string statusMessage = CH_CA_MS_Util.deleteSelectedObjects(selectedTimeslotAssociations, 'timeslot association');

		// If something was saved
		if (!statusMessage.startsWith('Deleted 0')){
			// Validate the schedule
			CH_CA_Validate_Schedule scheduleValidation = new CH_CA_Validate_Schedule();
			string errorMessage = scheduleValidation.validate(new List<Id>{scheduleId});
			// If the validation failed Then rollback
			if (scheduleValidation.stopSave){
				system.debug('CH_CA: Timeslot Members cannot be deleted because of Schedule validation errors. Deletion rolled back');
				Database.rollback(savePointValidation);
				
				return errorMessage;
			}			
		}
		
		return statusMessage;
	}	 

	// Delete the current timeslot
	@AuraEnabled
	public static string saveTimeslot(CH_Workgroup_Schedule_Timeslot__c gettimeslot){
		Savepoint savePointValidation = Database.setSavepoint();

		// Save the update
		//Start Changes for Bug-27444
		//CH_Workgroup_Schedule_Timeslot__c timeslot =(CH_Workgroup_Schedule_Timeslot__c)System.JSON.deserialize(timeslotFields, CH_Workgroup_Schedule_Timeslot__c.Class);
		 CH_Workgroup_Schedule_Timeslot__c timeslot =new CH_Workgroup_Schedule_Timeslot__c();
	 	timeSlot.CH_Workgroup_Schedule__c=gettimeslot.CH_Workgroup_Schedule__c;
		timeSlot.Id=gettimeslot.Id;
		timeSlot.CH_Start_Time__c=gettimeslot.CH_Start_Time__c;
		timeSlot.CH_End_Time__c=gettimeslot.CH_End_Time__c;
		timeSlot.CH_Day__c=gettimeslot.CH_Day__c;
		//End Changes for the Bug-27444
		upsert timeslot;
		string timeslotName = [SELECT Name FROM CH_Workgroup_Schedule_Timeslot__c WHERE Id = :timeslot.Id LIMIT 1].Name;
	   
		// Validate the schedule
		CH_CA_Validate_Schedule scheduleValidation = new CH_CA_Validate_Schedule();
		string errorMessage = scheduleValidation.validate(new List<Id>{timeslot.CH_Workgroup_Schedule__c});
		// If the validation failed Then rollback
		if (scheduleValidation.stopSave){
			system.debug('CH_CA: Timeslto cannot be saved because of Schedule validation errors. Save rolled back');
			Database.rollback(savePointValidation);
			
			// Replace the timeslot name of the new timeslot with Edited TimeSlot
			errorMessage = errorMessage.replace(timeslotName, 'Edited TimeSlot');
			return errorMessage;
		}
		return '';
	}
}