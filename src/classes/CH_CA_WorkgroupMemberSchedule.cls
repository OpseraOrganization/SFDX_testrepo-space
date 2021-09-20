public without sharing class CH_CA_WorkgroupMemberSchedule extends CH_CA_AbstractWorkgroupMember { 
	// Get all the workgroup members for the workgroups 
	public override List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersCaseTeam(List<CH_Workgroup_Rule__c> foundWorkgroupRules, Case currentCase){
		// Put all workgroupids from the rules into a set
		set<Id> workgroupIds = new set<Id>();
		for(CH_Workgroup_Rule__c rule : foundWorkgroupRules){   
			workgroupIds.add(rule.CH_Workgroup__c);
		}
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = new List<CH_Workgroup_Member__c>();
		if (workgroupIds.size() > 0){
			List<CH_Workgroup_Member__c> workgroupMembers = getAllWorkgroupMembers(workgroupIds);		   
			foundWorkgroupMembers.addAll(workgroupMembers); 
		}
		
		// Remove the queues
		List<CH_Workgroup_Member__c> validWorkgroupMembers = new List<CH_Workgroup_Member__c>();
		for (CH_Workgroup_Member__c workgroupMember : foundWorkgroupMembers){
			if (workgroupMember.CH_Workgroup_Member_Type__c != 'Queue'){
	validWorkgroupMembers.add(workgroupMember);
			}
		}
		
		return createWorkgroupMemberDTO(validWorkgroupMembers, foundWorkgroupRules);
	}
	
	// Get all the workgroup members for the case team with availability 
	public override List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersCaseTeamAvailability(List<CH_Workgroup_Rule__c> foundWorkgroupRules, CH_CA_DTO.SearchCriteriaDTO searchCriteria){
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = filterWorkgroupMembersByAvailability(foundWorkgroupRules, searchCriteria);
		return createWorkgroupMemberDTO(foundWorkgroupMembers, foundWorkgroupRules);
	}   
	
	// Get all the workgroup members for the workgroups 
	public override List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersActiveCaseInitialAssignment(List<CH_Workgroup_Rule__c> foundWorkgroupRules, CH_CA_DTO.SearchCriteriaDTO searchCriteria){
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = filterWorkgroupMembersByAvailability(foundWorkgroupRules, searchCriteria);
		return createWorkgroupMemberDTO(foundWorkgroupMembers, foundWorkgroupRules);
	}
	
	// Get all the workgroup members for the workgroups
	public override List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMembersActiveCaseReAssignment(List<CH_Workgroup_Rule__c> foundWorkgroupRules, CH_CA_DTO.SearchCriteriaDTO searchCriteria){	   
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = filterWorkgroupMembersByAvailability(foundWorkgroupRules, searchCriteria);
		return createWorkgroupMemberDTO(foundWorkgroupMembers, foundWorkgroupRules);
	}
	
	// Sort the workgroup members on schedule type
	public override Integer getSortOrder(CH_Workgroup_Member__c member){
		string nameToSort = '';
		if (member.Workgroup_Member_Timeslot_Association__r.size() > 0){
			nameToSort = member.Workgroup_Member_Timeslot_Association__r[0].CH_Schedule_Type__c;
		}
		integer sortOrder = 0;
		switch on nameToSort {
			when 'Primary' {		
	sortOrder = 0;
			}   
			when 'Secondary' {	  
	sortOrder = 1;
			}
			when 'Tertiary' {	   
	sortOrder = 2;
			}
			when else { // Workgroup Members with no timeslot association like managers   
	sortOrder = 3;
			}
		}	   
		return sortOrder;
	}
	
	// Get the workgroup workgroup members for a valid schedules/timeslots
	private List<CH_Workgroup_Member__c> filterWorkgroupMembersByAvailability(List<CH_Workgroup_Rule__c> foundWorkgroupRules, CH_CA_DTO.SearchCriteriaDTO searchCriteria){
		// Put all workgroupids from the rules into a set
	   system.debug('foundWorkgroupRules size is :'+foundWorkgroupRules);
		set<Id> workgroupIds = new set<Id>();
		for(CH_Workgroup_Rule__c rule : foundWorkgroupRules){ 
			workgroupIds.add(rule.CH_Workgroup__c);
		}
		system.debug('CH_CA: workgroupIds' + workgroupIds);
		// Get all valid schedules
		List<CH_Workgroup_Schedule__c> workgroupSchedules = getValidSchedules(workgroupIds, searchCriteria);
		system.debug('CH_CA: workgroupSchedules'+workgroupSchedules);
		set<Id> validScheduleIds = createListOfValidScheduleIds(workgroupSchedules);
		system.debug('CH_CA: validScheduleIds'+validScheduleIds);
		// Get all valid timeslots
		set<Id> validTimeslotIds = getValidTimeslotIds(validScheduleIds,workgroupIds, searchCriteria);
		// Get all workgroup members
		List<CH_Workgroup_Member__c> validWorkgroupMembers = getAllWorkgroupMembersFromTimeSlots(validTimeslotIds,workgroupIds);
		// For all workgroups with no schedule get all workgroup members - Miguel Silva changed workgroups map from  map<Id, boolean> to map<Id, Integer> because there are now 4 different scenarios
		//Scenario 0 - Has Timeslot available with a Hotline
		//Scenario 1 - Has no Timeslot available and WG has a Hotline
		//Scenario 2 - Has Timeslot available with no Hotline
		//Scenario 3 - Has no Timeslot available and WG has no Hotline
		map<Id, Integer> workgroups = analizeWorkgroups(validWorkgroupMembers, workgroupIds);
		// Get all workgroups that need to display valid Hotlines + all workgroup members - scenario 0
		set<Id> workgroupIdHotlinesAndUsers = getWorkgroupsThatNeedHotlinesAndUsers(workgroups);
				 for(CH_Workgroup_Member__c cc: validWorkgroupMembers )
				 {
					 if(cc.CH_Workgroup_Member_Type__c == 'Hotline')
						 system.debug('cc hotline ' + cc); 
				 }
		if (workgroupIdHotlinesAndUsers.size() > 0){
 
			List<CH_Workgroup_Member__c> hotlinesAndUsers = getHotlinesAndUsers(validTimeslotIds, validWorkgroupMembers,workgroupIds);		   
			validWorkgroupMembers.addall(hotlinesAndUsers); 
		}
		// Get all workgroups that need to display all workgroup members except Queues - scenario 1
		set<Id> workgroupIdAllMembers = getWorkgroupsThatNeedAllMembers(workgroups);
		if (workgroupIdAllMembers.size() > 0){
			List<CH_Workgroup_Member__c> allWorkgroupMembers = getAllWorkgroupMembersExceptQueues(workgroupIdAllMembers);		   
			validWorkgroupMembers.addAll(allWorkgroupMembers); 
		}
		// Get all WG Members on available timeslot - scenario 2
		// This might be already covered by getAllWorkgroupMembersFromTimeSlots function
		List<CH_Workgroup_Member__c> allWorkgroupManagers = getManagers(workgroupIds, validWorkgroupMembers);		   
		validWorkgroupMembers.addAll(allWorkgroupManagers); 
		//CH_Workgroup_Member__c putGWCatLast = validWorkgroupMembers[validWorkgroupMembers.size()-1];
		//system.debug('check last workgroup ' + putGWCatLast);
		//validWorkgroupMembers.add(0,putGWCatLast);
		//validWorkgroupMembers.remove(validWorkgroupMembers.size()-1);
	 for(CH_Workgroup_Member__c cc : validWorkgroupMembers)
		{
			
			system.debug('check individual workgroup ' + cc.CH_Workgroup__r.name);
		}
		
		return validWorkgroupMembers;
	}
	
	// For a list of workgroups get a list of valid schedules based on the
	// schedule dates and schedule filter
	private List<CH_Workgroup_Schedule__c> getValidSchedules(set<Id> workgroupIds, CH_CA_DTO.SearchCriteriaDTO searchCriteria){
		DateTime now = DateTime.now();
		List<CH_Workgroup_Schedule__c> workgroupSchedules = 
			[SELECT Id, CH_Workgroup__c,CH_Workgroup_Filters_Count__c
	FROM CH_Workgroup_Schedule__c 
	WHERE CH_Workgroup__c in :workgroupIds AND 
	CH_Active__c = true AND
	CH_Start_DateTime__c <= :now AND CH_End_DateTime__c >= :now];
		
		// Filter the list of schedules by Schedule Filter
		CH_CA_Workgroup_Filters filter = new CH_CA_Workgroup_Filters();
		set<Id> scheduleIdValidWithFilter = filter.getSchedulePerWorkgroupWithHighestWeight(searchCriteria, workgroupSchedules);
		system.debug('scheduleIdValidWithFilter check' + scheduleIdValidWithFilter);
		List<CH_Workgroup_Schedule__c> validSchedules = new List<CH_Workgroup_Schedule__c>();
		for (CH_Workgroup_Schedule__c workgroupSchedule : workgroupSchedules){
			if (scheduleIdValidWithFilter.contains(workgroupSchedule.id)){
	validSchedules.add(workgroupSchedule);
			}
		}
		
		system.debug('CH_CA: Valid Schedules found: ' + workgroupSchedules);
		return validSchedules;
	}
	
	// For a list of workgroups get a list of valid schedules based on the
	// schedule dates and schedule filter
	private set<Id> createListOfValidScheduleIds(List<CH_Workgroup_Schedule__c> workgroupSchedules){
		// Convert the list into a set
		set<id> foundSchedules = new set<id>();
		for (CH_Workgroup_Schedule__c schedule : workgroupSchedules){
			foundSchedules.add(schedule.id);
		}
		
		return foundSchedules;
	}
	
	// Validate each workgroup
	// Map < workgroup id, (boolean) display all workgroup members >
	// If the workgroup has no schedules then display all workgroup members
	// If the workgroup schedule contains a hotline then display all workgroup members
	// Miguel Silva - scenario 0 doesn't need all WG Members, scenario 1 needs all WG Members except Queues, scenario 2 needs only managers
	private map<Id, Integer> analizeWorkgroups(List<CH_Workgroup_Member__c> validWorkgroupMembers, set<Id> workgroupIds){
		map<Id, Integer> analizedWorkgroups = new map<Id, Integer>();
		List<CH_Workgroup_Member__c> hotlineWorkgroupMembers = [SELECT Id, 
				Name, CH_Role__c, CH_Queue_Email__c,
				CH_User__r.Email, CH_User__c, 
				CH_User__r.MobilePhone, CH_HotlinePhone__c, 
				CH_Name__c, 
				CH_Workgroup__c, CH_Workgroup__r.Name, 
				CH_Workgroup__r.CH_Level_Of_Support__c,  
				CH_User__r.CH_LastCaseAssigned__c, CH_User__r.CH_LastEngagement__c, CH_RoleOrder__c, 
				CH_Workgroup_Member_Type__c  
				FROM CH_Workgroup_Member__c WHERE CH_Workgroup__c in: workgroupIds AND
				CH_Workgroup_Member_Type__c = 'Hotline'];
		
		system.debug('validWorkgroupMembers --> ' + validWorkgroupMembers);
		for (Id workgroupId : workgroupIds){
			analizedWorkgroups.put(workgroupId, 0);
			if(validWorkgroupMembers.size() == 0){
	// If the workgroup contains a hotline but no valid WG members- scenario 1
	if(hotlineWorkgroupMembers.size() > 0){
		analizedWorkgroups.put(workgroupId, 1);
		// If the workgroup doesn't contain a hotline or valid WG members - scenario 3
	}else if(hotlineWorkgroupMembers.size() == 0){
		analizedWorkgroups.put(workgroupId, 3);
	}
			} else if(validWorkgroupMembers.size() > 0) {
	// If the workgroup contains a hotline and valid WG members- scenario 0
	if(hotlineWorkgroupMembers.size() > 0){
		analizedWorkgroups.put(workgroupId, 0);
		// If the workgroup doesn't contain a hotline but contains valid WG members - scenario 2
	}else if(hotlineWorkgroupMembers.size() == 0){
		analizedWorkgroups.put(workgroupId, 2);  
	}
			}
		}
		
		system.debug('CH_CA: Analized Workgroups: ' + analizedWorkgroups);
		return analizedWorkgroups;
	}
	
	//Get all Workgroups that need Hotlines from timeslot and all the WG Members from type User - Scenario 0
	private set<Id> getWorkgroupsThatNeedHotlinesAndUsers(map<Id, Integer> workgroups){
		set<Id> workgroupsToReturn = new set<Id>();
		for (Id workgroupId : workgroups.keySet()){
			if (workgroups.get(workgroupId) == 0){
	workgroupsToReturn.add(workgroupId);
			}
		}
		system.debug('CH_CA: Workgroups That Need All Workgroup Members: ' + workgroupsToReturn.size());		
		return workgroupsToReturn;
	}
	
	// Get all workgroups that need to display all workgroup members - Scenario 1
	private set<Id> getWorkgroupsThatNeedAllMembers(map<Id, Integer> workgroups){
		set<Id> workgroupsToReturn = new set<Id>();
		for (Id workgroupId : workgroups.keySet()){
			if (workgroups.get(workgroupId) == 1){
	workgroupsToReturn.add(workgroupId);
			}
		}
		system.debug('CH_CA: Workgroups That Need All Workgroup Members: ' + workgroupsToReturn.size());		
		return workgroupsToReturn;
	}
	
	// For a list of schedules get a list of valid timeslots based on the
	// time
	private set<Id> getValidTimeslotIds(set<Id> scheduleIds,set<Id> workgroupIds, CH_CA_DTO.SearchCriteriaDTO searchCriteria){

		
		//Adding inactive Schedules
		DateTime now = DateTime.now();
		List<CH_Workgroup_Schedule__c> workgroupSchedules = 
			[SELECT Id, CH_Workgroup__c,CH_Workgroup_Filters_Count__c
			 FROM CH_Workgroup_Schedule__c 
			 WHERE CH_Workgroup__c in :workgroupIds AND 
			 CH_Active__c = false AND
			 CH_Start_DateTime__c <= :now AND CH_End_DateTime__c >= :now];
		
		// Filter the list of schedules by Schedule Filter
		CH_CA_Workgroup_Filters filter = new CH_CA_Workgroup_Filters();
		set<Id> scheduleIdValidWithFilter = filter.getSchedulePerWorkgroupWithHighestWeight(searchCriteria, workgroupSchedules);
		List<CH_Workgroup_Schedule__c> validSchedules = new List<CH_Workgroup_Schedule__c>();
		for (CH_Workgroup_Schedule__c workgroupSchedule : workgroupSchedules){
			if (scheduleIdValidWithFilter.contains(workgroupSchedule.id)){
				validSchedules.add(workgroupSchedule);
			}
		}
		set<Id> validScheduleIds = createListOfValidScheduleIds(validSchedules);
		validScheduleIds.addall(scheduleIds);
	
		Time midnight = Time.newInstance(0, 0, 0, 0);
		system.debug('CH_CA: Get Valid Timeslots for time: ' + now.timeGMT());
		system.debug('CH_CA: scheduleIds: ' + validScheduleIds);
		set<id> foundTimeslots = new set<id>();
		for(CH_Workgroup_Schedule_Timeslot__c wgST : [SELECT Id ,CH_Time_Difference__c,CH_Start_Time__c,CH_End_Time__c,CH_Day__c 
				  FROM CH_Workgroup_Schedule_Timeslot__c 
				  WHERE CH_Workgroup_Schedule__c in :validScheduleIds]){
				//Adding time difference between GMT time and Timeslot time
				Time timeInTimeslot = now.timeGMT().addSeconds(Integer.valueof(wgST.CH_Time_Difference__c));
				DateTime timeslotDay = now.addSeconds(Integer.valueof(wgST.CH_Time_Difference__c));
				if((wgST.CH_Start_Time__c <= timeInTimeslot || wgST.CH_Start_Time__c== midnight) &&
				(wgST.CH_End_Time__c >= timeInTimeslot || wgST.CH_End_Time__c== midnight) && wgST.CH_Day__c.contains(timeslotDay.formatGMT('EEEE'))){
				 foundTimeslots.add(wgST.id);
				}
				  }
		
		system.debug('CH_CA: Valid Timeslots found: ' + foundTimeslots);
		return foundTimeslots;
	}
	
	// For the list of timeslots get all hotlines from timeslot and WG Members of the type User - Scenario 0
	private List<CH_Workgroup_Member__c> getHotlinesAndUsers(set<Id> validTimeslotIds, List<CH_Workgroup_Member__c> validWorkgroupMembers,Set<Id> workgroupIds){
		
		 for(CH_Workgroup_Member__c cc: validWorkgroupMembers )
		{
			if(cc.CH_Workgroup_Member_Type__c == 'Hotline')
			system.debug('cc hotline ' + cc); 
		}
		
		system.debug('CH_CA: validTimeslotIds --> ' + validTimeslotIds);
		List<CH_Workgroup_Member__c> HotlineMembers = 
			[SELECT Id, (SELECT CH_Schedule_Type__c 
						 FROM Workgroup_Member_Timeslot_Association__r
						 WHERE CH_Workgroup_Schedule_Timeslot__c in : validTimeslotIds), 
			 Name, CH_Role__c, CH_Queue_Email__c,
			 CH_User__r.Email, CH_User__c, 
			 CH_User__r.MobilePhone, CH_HotlinePhone__c, 
			 CH_Name__c, 
			 CH_Workgroup__c, CH_Workgroup__r.Name, 
			 CH_Workgroup__r.CH_Level_Of_Support__c,  
			 CH_User__r.CH_LastCaseAssigned__c, CH_User__r.CH_LastEngagement__c, CH_RoleOrder__c, 
			 CH_Workgroup_Member_Type__c  
			 FROM CH_Workgroup_Member__c
			 WHERE Id in (SELECT CH_Workgroup_Member__c 
						  FROM CH_Workgroup_Member_Timeslot_Association__c
						  WHERE CH_Workgroup_Schedule_Timeslot__c in : validTimeslotIds) AND 
			 CH_Off_Duty__c = false AND
			 CH_Workgroup_Member_Type__c in ('Hotline')  ];

		
		Set<Id> hotlineWorkgroupIds = new Set<Id>();
		for(CH_Workgroup_Member__c WGMember : HotlineMembers){
			if(!hotlineWorkgroupIds.contains(WGMember.CH_Workgroup__c))
			hotlineWorkgroupIds.add(WGMember.CH_Workgroup__c);
		}
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = new List<CH_Workgroup_Member__c>();
		system.debug('CH_CA: hotlineWorkgroupIds --> ' + hotlineWorkgroupIds);
		for(CH_Workgroup_Member__c WGMember : [SELECT Id, 
			  Name, CH_Role__c, CH_Queue_Email__c,
			  CH_User__r.Email, CH_User__c, 
			  CH_User__r.MobilePhone, CH_HotlinePhone__c, 
			  CH_Name__c, 
			  CH_Workgroup__c, CH_Workgroup__r.Name, 
			  CH_Workgroup__r.CH_Level_Of_Support__c,  
			  CH_User__r.CH_LastCaseAssigned__c, CH_User__r.CH_LastEngagement__c, CH_RoleOrder__c, 
			  CH_Workgroup_Member_Type__c	
			  FROM CH_Workgroup_Member__c WHERE CH_Off_Duty__c = false AND
			  CH_Workgroup_Member_Type__c = 'User' AND
			  CH_Workgroup__c IN: hotlineWorkgroupIds]){
			   if(!validWorkgroupMembers.contains(WGMember)){
				foundWorkgroupMembers.add(WGMember);
			   }
			  }
		
		for(CH_Workgroup_Member__c cc: foundWorkgroupMembers )
		{
			if(cc.CH_Workgroup_Member_Type__c == 'Hotline')
			system.debug('cc hotline ' + cc); 
		}
		
		system.debug('CH_CA: Valid Workgroup Members found: ' + foundWorkgroupMembers.size());
		return foundWorkgroupMembers; 
	}
	
	// For the list of timeslots get all workgroup members
	private List<CH_Workgroup_Member__c> getAllWorkgroupMembersFromTimeSlots(set<Id> validTimeslotIds,Set<id> workgroupIds){
		system.debug('workgroup id >>' + workgroupIds );
		Set<Id> setOfWorkGroupIdWithSchedule = new Set<Id>();
		Set<Id> setOfWorkGroupIdWithoutSchedule = new Set<Id>();
		map<Id,Boolean> mapOfWorkGroupIdAndHasScheduleWithHotline = new map<Id,Boolean>();
		map<Id,Boolean> mapOfWorkGroupIdAndHasScheduleWithoutHotline = new map<Id,Boolean>();
		map<Id,Boolean> mapOfWorkGroupIdAndHasNoScheduleWithHotline = new map<Id,Boolean>();
		map<Id,Boolean> mapOfWorkGroupIdAndHasNoScheduleWithoutHotline = new map<Id,Boolean>();
		map<Id, CH_Workgroup_Member__c> mapOfAllApplicableWorkGroupMembers = new map<Id, CH_Workgroup_Member__c>();
		List<CH_Workgroup_Member__c> allWorkGroupMembersWithSchedule = 
			[SELECT Id, (SELECT CH_Schedule_Type__c 
						 FROM Workgroup_Member_Timeslot_Association__r
						 WHERE CH_Workgroup_Schedule_Timeslot__c in : validTimeslotIds And CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Active__c = true), 
			 Name, CH_Role__c, CH_Queue_Email__c,
			 CH_User__r.Email, CH_User__c, 
			 CH_User__r.MobilePhone, CH_HotlinePhone__c, 
			 CH_Name__c, 
			 CH_Workgroup__c, CH_Workgroup__r.Name, 
			 CH_Workgroup__r.CH_Level_Of_Support__c,  
			 CH_User__r.CH_LastCaseAssigned__c, CH_User__r.CH_LastEngagement__c, CH_RoleOrder__c, 
			 CH_Workgroup_Member_Type__c  
			 FROM CH_Workgroup_Member__c
			 WHERE Id in (SELECT CH_Workgroup_Member__c 
						  FROM CH_Workgroup_Member_Timeslot_Association__c
						  WHERE CH_Workgroup_Schedule_Timeslot__c in : validTimeslotIds And CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Active__c = true) AND
			 CH_Off_Duty__c = false];
		
		for(CH_Workgroup_Member__c member : allWorkGroupMembersWithSchedule)
		{
			setOfWorkGroupIdWithSchedule.add(member.CH_Workgroup__c);
			if(member.CH_Role__c == 'Hotline') {
				system.debug('First If' + member.CH_Workgroup__r.Name + ' ' + member.Name );
				mapOfWorkGroupIdAndHasScheduleWithHotline.put(member.CH_Workgroup__c, true);
			} else {
			   system.debug('2nd If' + member.CH_Workgroup__r.Name + ' ' + member.Name );
				mapOfWorkGroupIdAndHasScheduleWithoutHotline.put(member.CH_Workgroup__c, false);
			}
			mapOfAllApplicableWorkGroupMembers.put(member.Id,member);
		}
		if(!mapOfWorkGroupIdAndHasScheduleWithHotline.isEmpty())
		{
			mapOfAllApplicableWorkGroupMembers.putall(getAllMembersAccourdingToRules(mapOfWorkGroupIdAndHasScheduleWithHotline.keySet(),true,mapOfAllApplicableWorkGroupMembers.keyset()));
		}
	   
		
		for(Id workgroupid: workgroupIds )
		{
			if(!setOfWorkGroupIdWithSchedule.contains(workgroupid))
			{
				setOfWorkGroupIdWithoutSchedule.add(workgroupid);
			}
			
		}
		system.debug('setOfWorkGroupIdWithoutSchedule check ' + setOfWorkGroupIdWithoutSchedule +' setOfWorkGroupIdWithSchedule ' + setOfWorkGroupIdWithSchedule + ' workgroupIds ' + workgroupIds);
		
		 for(CH_Workgroup_Member__c cm: [SELECT Id,Name, CH_Role__c, CH_Queue_Email__c,
											CH_User__r.Email, CH_User__c, 
											CH_User__r.MobilePhone, CH_HotlinePhone__c, 
											CH_Name__c, 
											CH_Workgroup__c, CH_Workgroup__r.Name, 
											CH_Workgroup__r.CH_Level_Of_Support__c,  
											CH_User__r.CH_LastCaseAssigned__c, CH_User__r.CH_LastEngagement__c, CH_RoleOrder__c, 
											CH_Workgroup_Member_Type__c  
											FROM CH_Workgroup_Member__c
											WHERE CH_Workgroup__c in: setOfWorkGroupIdWithoutSchedule AND
											CH_Off_Duty__c = false])
			{
				system.debug('the ch role ' +cm.CH_Role__c );
				if(cm.CH_Role__c == 'Hotline') {
					system.debug('3rd If check' + cm.CH_Workgroup__r.Name + ' ' + cm.Name );
					mapOfWorkGroupIdAndHasNoScheduleWithHotline.put(cm.CH_Workgroup__c,true);
				 }else {
					 system.debug('4th If check' + cm.CH_Workgroup__r.Name + ' ' + cm.Name );
					mapOfWorkGroupIdAndHasNoScheduleWithoutHotline.put(cm.CH_Workgroup__c,false);
				 }
			}
		
		 if(!mapOfWorkGroupIdAndHasNoScheduleWithHotline.isEmpty())
		{
			mapOfAllApplicableWorkGroupMembers.putall(getAllMembersAccourdingToRules(mapOfWorkGroupIdAndHasNoScheduleWithHotline.keySet(),true,mapOfAllApplicableWorkGroupMembers.keyset()));
		}
		
			
		return mapOfAllApplicableWorkGroupMembers.values();
	}
	
	private list<CH_Workgroup_Member__c> getAllMembersAccourdingToRules(Set<Id> workgroupIds, Boolean hasSchedule, Set<Id> allAlreadyAddedMembers)
	{
		list<CH_Workgroup_Member__c> listOfWorkGroupMembersToReturn = new list<CH_Workgroup_Member__c>();
		if(hasSchedule == true)
		{
			for(CH_Workgroup_Member__c cm: [SELECT Id,Name, CH_Role__c, CH_Queue_Email__c,
											CH_User__r.Email, CH_User__c, 
											CH_User__r.MobilePhone, CH_HotlinePhone__c, 
											CH_Name__c, 
											CH_Workgroup__c, CH_Workgroup__r.Name, 
											CH_Workgroup__r.CH_Level_Of_Support__c,  
											CH_User__r.CH_LastCaseAssigned__c, CH_User__r.CH_LastEngagement__c, CH_RoleOrder__c, 
											CH_Workgroup_Member_Type__c  
											FROM CH_Workgroup_Member__c
											WHERE CH_Workgroup__c in: workgroupIds AND
											CH_Off_Duty__c = false And CH_Role__c in ('Hotline','Engineer')])
			{
				if(!allAlreadyAddedMembers.contains(cm.Id))
				{
					listOfWorkGroupMembersToReturn.add(cm);
				}
			}
		}
		
	   
		return listOfWorkGroupMembersToReturn;
	}
	
	// Get all workgroups that need to display all workgroup members except Queues - scenario 1
	public List<CH_Workgroup_Member__c> getAllWorkgroupMembersExceptQueues(set<Id> workgroupIds){
		List<CH_Workgroup_Member__c> foundWorkgroupMembers = 
			[SELECT Id, Name, CH_Role__c, CH_User__r.Email, CH_User__c,CH_Queue_Name__c , CH_Queue_Email__c,
	CH_User__r.MobilePhone, CH_HotlinePhone__c, CH_Name__c, CH_Hotline_Name__c,
	CH_Workgroup__c, CH_Workgroup__r.Name, CH_Workgroup__r.CH_Level_Of_Support__c,  
	CH_User__r.CH_LastCaseAssigned__c, CH_User__r.CH_LastEngagement__c, CH_RoleOrder__c, CH_Queue__c, CH_Workgroup_Member_Type__c 
	FROM CH_Workgroup_Member__c 
	WHERE CH_Workgroup__c IN : workgroupIds AND 
	CH_Off_Duty__c = false AND
	CH_Workgroup_Member_Type__c != 'Queue'];
		
		system.debug('CH_CA: Workgroup Members found: ' + foundWorkgroupMembers.size());
		return foundWorkgroupMembers;
	}
	
	
	// For the found workgroup rules get all managers 1,2,3 - Scenario 3
	private List<CH_Workgroup_Member__c> getManagers(set<Id> workgroupIds, List<CH_Workgroup_Member__c> validWorkgroupMembers){
		List<string> managerRolesToRetrieve = new List<string>{'Manager 1', 'Manager 2','Manager 3', 'Case Manager'};
			
			List<CH_Workgroup_Member__c> foundWorkgroupMembers = new List<CH_Workgroup_Member__c>();
		
		for(CH_Workgroup_Member__c wgm : [SELECT Id, Name, CH_Role__c, CH_User__r.Email, CH_User__c,CH_Queue_Name__c ,
			CH_User__r.MobilePhone, CH_HotlinePhone__c, CH_Name__c, CH_Hotline_Name__c, CH_Queue_Email__c,
			CH_Workgroup__c, CH_Workgroup__r.Name, CH_Workgroup__r.CH_Level_Of_Support__c,  
			CH_User__r.CH_LastCaseAssigned__c, CH_User__r.CH_LastEngagement__c, CH_RoleOrder__c, CH_Queue__c, CH_Workgroup_Member_Type__c 
			FROM CH_Workgroup_Member__c 
			WHERE CH_Workgroup__c IN : workgroupIds AND
			CH_Role__c in :managerRolesToRetrieve AND
			CH_Off_Duty__c = false]){
			 if(!validWorkgroupMembers.contains(wgm)){
			  foundWorkgroupMembers.add(wgm);
			 }
			}
		 system.debug('CH_CA: Managers Added: ' + foundWorkgroupMembers.size());
		List<CH_Workgroup_Member__c> foundWorkgroupMembersGWC = new List<CH_Workgroup_Member__c>();
		
		
		system.debug('CH_CA: Managers Added: ' + foundWorkgroupMembers.size());	 
		return foundWorkgroupMembers;	   
	}
}