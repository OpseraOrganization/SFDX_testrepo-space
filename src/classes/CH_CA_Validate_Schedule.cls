/****************************************
* Class Name : CH_CA_Validate_Schedule
* Created Date: 15-03-2019
* Created By : TCS
* Description : This class is used to validate workgroup schedule 
*****************************************/
public class CH_CA_Validate_Schedule {
	// The number of minutes in a day 24*60 = 1440
	static final integer MINUTES_PER_DAY = 1439;
	public boolean stopSave; 
	
	// Validate the schedule/timeslot/timeslot members
	public string validate(List<Id> scheduleIds){
		string allValidationErrors = '';
		stopSave = false;
		
		// Get all schedule information
		List<CH_Workgroup_Schedule__c> schedules = [SELECT Id, Name, CH_Active__c,
	(SELECT Id, Name, CH_WorkgroupMemberCount__c, CH_Day__c,
	  CH_Start_Time__c, CH_End_Time__c
	 FROM Workgroup_Schedule_Timeslots__r)
	FROM CH_Workgroup_Schedule__c
	WHERE Id in :scheduleIds];
		
		// Validate each schedule
		for(CH_Workgroup_Schedule__c schedule : schedules){
			string validationErrors = '<p><b>' + schedule.Name + '</b></p>';
			// Check that the schedule has a timeslot
			if (!hasTimeslot(schedule)){
	validationErrors += '<p style=\'color:red\'>' + System.label.CH_CA_NoTimeslot + '</p>';
	stopSave = true && schedule.CH_Active__c;
			}
			// Check that the timeslots are covering all days
			if (!doTimeslotCoverAllDaysOfTheWeek(schedule)){
	validationErrors += '<p>' + System.label.CH_CA_TimeslotWeekNotCovered + '</p>';
			}
			// Check that each timeslot in the schedule has at least one workgroup member
			string errorMessage = hasEachTimeSlotWorkgroupMembers(schedule);
			if (!String.isBlank(errorMessage)){
	validationErrors += '<p style=\'color:red\'>' + System.label.CH_CA_NoWorkgroupMember + '</p>';
	validationErrors += '<p>' + errorMessage + '</p>';
	stopSave = true && schedule.CH_Active__c;
			}
			// Check that timeslots are covered the whole day
			errorMessage = areTimeslotsCoveringAllDay(schedule);
			if (!String.isBlank(errorMessage)){
	validationErrors += '<p>' + System.label.CH_CA_TimeslotNotCoverAllDay + '</p>';
	validationErrors += '<p>' + errorMessage + '</p>';
			}			
			// Check that no timeslots are overlapping on a day
			//errorMessage = areTimeslotsOverlappingInADay(schedule);
			errorMessage=validateTimeslotOverlapping(schedule);
			if (!String.isBlank(errorMessage)){
	validationErrors += '<p style=\'color:red\'>' + System.label.CH_CA_TimeslotOverlapping + '</p>';
	validationErrors += '<p>' + errorMessage + '</p>';
	stopSave = true && schedule.CH_Active__c;
			}
			if (!validationErrors.contains('Error') && 
	!validationErrors.contains('Warning')){
	validationErrors += '<p>The schedule has been successfully validated. No issues found</p>';
			}
			// Add a blank line to seperate multiple schedules
			validationErrors += '<br>';
			
			allValidationErrors += validationErrors;
		}
		
		System.debug('CH_CA: validation errors: ' + allValidationErrors);
		return allValidationErrors;		
	}
	
	// Check if the schedule has at least one timeslot
	private boolean hasTimeSlot(CH_Workgroup_Schedule__c schedule){
		boolean hasTimeSlot = true;
		if (schedule.Workgroup_Schedule_Timeslots__r.size() == 0){
			hasTimeSlot = false;
		}
		
		System.debug('CH_CA: schedule has timeslots ' + hasTimeSlot);
		return hasTimeSlot;
	}
	
	// Check that each timeslot has a workgroup member
	private string hasEachTimeSlotWorkgroupMembers(CH_Workgroup_Schedule__c schedule){
		string errorMessage = '';
		
		// Loop through all the timeslots
		for (CH_Workgroup_Schedule_Timeslot__c timeslot : schedule.Workgroup_Schedule_Timeslots__r){
			if (timeslot.CH_WorkgroupMemberCount__c == 0){
	errorMessage += '- ' + timeslot.Name + '\n';	
			}
		}
		
		System.debug('CH_CA: Timeslots with no WG Members ' + errorMessage);
		return errorMessage;
	}	
	
	// Check that the timeslots cover all days of the week
	private boolean doTimeslotCoverAllDaysOfTheWeek(CH_Workgroup_Schedule__c schedule){
		boolean doTimeslotCoverAllDaysOfTheWeek = true;
		
		Set<string> daysCovered = new Set<string>();
		// Loop through all the timeslots
		for (CH_Workgroup_Schedule_Timeslot__c timeslot : schedule.Workgroup_Schedule_Timeslots__r){
			// Add the days of the timeslot to a set to get a unique list of covered days
			daysCovered.addAll(timeslot.CH_Day__c.split(';'));
		}
		
		// If all 7 days are in the set
		if (daysCovered.size() != 7){
			doTimeslotCoverAllDaysOfTheWeek = false;
		}	 
		
		System.debug('CH_CA: daysCovered ' + daysCovered);
		System.debug('CH_CA: covers all days of the week ' + doTimeslotCoverAllDaysOfTheWeek);
		return doTimeslotCoverAllDaysOfTheWeek;
	}

	// Check that a whole day is covered by timeslots
	private string areTimeslotsCoveringAllDay(CH_Workgroup_Schedule__c schedule){
		map<String, TimeSlot> timeslotCoverage = aggregateTimeslotsPerDay(schedule);

		string errorMessage = '';
		for (String day :timeslotCoverage.keySet()){
			TimeSlot timeslot = timeslotCoverage.get(day);
	if (timeslot.scheduledMinutes < MINUTES_PER_DAY) { 
	errorMessage += '- ' + timeslot.name + ' ' + timeslot.day + '\n';
			}
		}		
		
		System.debug('CH_CA: Days that are not completly covered by Timeslots ' + errorMessage);
		return errorMessage;
	}
		
		
	// Flatten the timeslots per day (as the timeslot has a multipicklist for days)
	// Then aggregate the minutes scheduled per day
	private map<String, TimeSlot> aggregateTimeslotsPerDay(CH_Workgroup_Schedule__c schedule){
		List<TimeSlot> timeSlots = new List<TimeSlot>();
		// Loop through all the timeslots
		for (CH_Workgroup_Schedule_Timeslot__c timeslot : schedule.Workgroup_Schedule_Timeslots__r){
			// Flatten the days into seperate entries
			for(String day : timeslot.CH_Day__c.split(';')){
	TimeSlot dayTimeslot = new TimeSlot();
	dayTimeslot.name = timeslot.Name;
	dayTimeslot.day = day;
	dayTimeslot.startTime = timeslot.CH_Start_Time__c;
	dayTimeslot.endTime = timeslot.CH_End_Time__c;
	dayTimeslot.scheduledMinutes = 0;
	timeSlots.add(dayTimeslot);
			}
		}

		// Mao with the day name and the total number of minutes covered by timeslots in that day
		map<String, TimeSlot> timeslotCoverage = new map<String, TimeSlot>();
		for (TimeSlot timeslot : timeSlots){
			//Changes added for 28523
			//Long timeslotMinutes = calculateTimeDifference(timeslot.startTime, timeslot.endTime);
			Long timeslotMinutes = calculateTimeDifference(timeslot.startTime,timeslot.endTime == Time.newInstance(0, 0, 0, 0)?Time.newInstance(23, 59, 0, 0):timeslot.endTime);
			// if the day does not exists
			if (timeslotCoverage.get(timeslot.day) == null){
	timeslot.scheduledMinutes = timeslotMinutes;
	timeslotCoverage.put(timeslot.day, timeslot);
			}
			else{
	TimeSlot timeslotInternal = timeslotCoverage.get(timeslot.day);
	if (!timeslotInternal.name.contains(timeslot.name)){
		timeslotInternal.name += ', ' + timeslot.name;
	}
	Long savedMinutes = timeslotInternal.scheduledMinutes;
	timeslotInternal.scheduledMinutes = savedMinutes + timeslotMinutes;
	timeslotCoverage.put(timeslotInternal.day, timeslotInternal);
			}
		}

		return timeslotCoverage;	
	}

	//Calculates time difference between start time and end time of timeslot
	private Long calculateTimeDifference(Time startTime, Time endTime){
		Time midnight = Time.newInstance(0, 0, 0, 0);
		Long timeDifference = MINUTES_PER_DAY; 
		//Changes added for 28523
		//if (startTime != midnight || endTime != midnight){
			timeDifference = (endTime.hour() * 60 + endTime.minute()) - (startTime.hour() * 60 + startTime.minute());			
		//}
		return timeDifference;
	}
	
	
	private String validateTimeslotOverlapping(CH_Workgroup_Schedule__c wGSTSList){
		string errorMessage = '';
		Map<String,List<string>> getlstMap=new Map<String,List<string>>();
		Map<String, List<CH_Workgroup_Schedule_Timeslot__c>> wGSTSMap= splitDays(wGSTSList);
		//Loop through all days in a week of CH_Workgroup_Schedule_Timeslot__c
		for(String day:wGSTSMap.keySet()){
			for(CH_Workgroup_Schedule_Timeslot__c wGSTSOuterObj:wGSTSMap.get(day)){
				for(CH_Workgroup_Schedule_Timeslot__c wGSTSInnerObj:wGSTSMap.get(day)){
					wGSTSOuterObj.CH_End_Time__c=(wGSTSOuterObj.CH_End_Time__c == Time.newInstance(0, 0, 0, 0)?Time.newInstance(23, 59, 0, 0):wGSTSOuterObj.CH_End_Time__c);
					wGSTSInnerObj.CH_End_Time__c=(wGSTSInnerObj.CH_End_Time__c == Time.newInstance(0, 0, 0, 0)?Time.newInstance(23, 59, 0, 0):wGSTSInnerObj.CH_End_Time__c);
					if(wGSTSOuterObj.Id != wGSTSInnerObj.Id &&
					   ((wGSTSOuterObj.CH_Start_Time__c < wGSTSInnerObj.CH_Start_Time__c &&
						 wGSTSInnerObj.CH_Start_Time__c < wGSTSOuterObj.CH_End_Time__c) ||
						(wGSTSOuterObj.CH_Start_Time__c < wGSTSInnerObj.CH_End_Time__c &&
						 wGSTSInnerObj.CH_End_Time__c < wGSTSOuterObj.CH_End_Time__c) ||
						(wGSTSOuterObj.CH_Start_Time__c == wGSTSInnerObj.CH_Start_Time__c &&
						 wGSTSInnerObj.CH_End_Time__c == wGSTSOuterObj.CH_End_Time__c) ||
						(wGSTSOuterObj.CH_Start_Time__c == wGSTSInnerObj.CH_Start_Time__c) ||
						(wGSTSInnerObj.CH_End_Time__c == wGSTSOuterObj.CH_End_Time__c))){
							if(getlstMap.containsKey(day)){
								getlstMap.get(day).add(wGSTSInnerObj.name);
								getlstMap.get(day).add(wGSTSOuterObj.name);
							}
							else{
								getlstMap.put(day,new List<String>{wGSTSInnerObj.name}); 
								getlstMap.put(day,new List<String>{wGSTSOuterObj.name}); 
							}
						}
				}
			}
		}
		for(String getValuesSet:getlstMap.keySet()){
			string getValidDays;
			for(String getValidSet:getlstMap.get(getValuesSet)){
				if(getValidDays != null &&  getValidDays != ''){
					if(!getValidDays.contains(getValidSet)){
						getValidDays+=', '+getValidSet; 
					}
				}
				else{
					getValidDays=getValidSet;
				}
				
			}
			if(errorMessage != null &&  errorMessage != ''){
				errorMessage+=' - '+getValidDays+' '+getValuesSet;
			}
			else{
				errorMessage='-'+getValidDays+' '+getValuesSet;
			}
		}
		return errorMessage;
	}
	
	private Map<String, List<CH_Workgroup_Schedule_Timeslot__c>> splitDays(CH_Workgroup_Schedule__c wGSTSList){
		//Create Map of CH_Workgroup_Schedule_Timeslot__c with Id as day and Values as list of timeslots on that day
		Map<String, List<CH_Workgroup_Schedule_Timeslot__c>> wGSTSMap= new Map<String, List<CH_Workgroup_Schedule_Timeslot__c>>();
		for (CH_Workgroup_Schedule_Timeslot__c timeslot : wGSTSList.Workgroup_Schedule_Timeslots__r){
			//Check if multiple days are selected
			for(String day:timeslot.CH_Day__c.split(';')){
				if(wGSTSMap.containsKey(day)){
					wGSTSMap.get(day).add(timeslot);
				}
				else{
					List<CH_Workgroup_Schedule_Timeslot__c> tempLst =new List<CH_Workgroup_Schedule_Timeslot__c>();
					tempLst.add(timeslot);
					wGSTSMap.put(day,tempLst);   
				}
			}
		}
		return wGSTSMap;
	}
	
	private class TimeSlot {
		string name;
		string day;
		Time startTime;
		Time endTime;
		Long scheduledMinutes;
	}
}