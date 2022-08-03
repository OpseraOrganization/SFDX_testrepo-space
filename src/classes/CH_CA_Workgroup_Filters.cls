public class CH_CA_Workgroup_Filters { 
	
	
	// for the schedules, get per workgroup the schedule with the higest weight
	public set<Id> getSchedulePerWorkgroupWithHighestWeight(CH_CA_DTO.SearchCriteriaDTO searchCriteria, List<CH_Workgroup_Schedule__c> schedules){
		// Build query to get the filters that belong to the schedule
		set<Id> scheduleIds = createListIdsFromObjects(schedules);
		List<CH_Workgroup_Filter__c> foundFilters = getWorkgroupFilters(searchCriteria, scheduleIds);
		// Calculate weight
		set<Id> mostImportantScheduleIds = getPerWorkgroup_ScheduleWithHighestWeight(searchCriteria, schedules, foundFilters);
		
		return mostImportantScheduleIds; 
	}
	
	// for the schedules, get per workgroup all valid schedule with their weight
	public Map<Id, integer> getAllSchedulePerWorkgroupWithWeight(CH_CA_DTO.SearchCriteriaDTO searchCriteria, List<CH_Workgroup_Schedule__c> schedules){
		// Build query to get the filters that belong to the schedule
		set<Id> scheduleIds = createListIdsFromObjects(schedules);
		List<CH_Workgroup_Filter__c> foundFilters = getWorkgroupFilters(searchCriteria, scheduleIds);
		// Calculate weight
		Map<Id, integer> allSchdulesWithWeight = getPerWorkgroup_AllScheduleWithWeight(searchCriteria, schedules, foundFilters);
		
		return allSchdulesWithWeight;
	}
	
	// Get the valid workgroup filters according to the search criteria
	public List<CH_Workgroup_Filter__c> getWorkgroupFilters(CH_CA_DTO.SearchCriteriaDTO searchCriteria, set<Id> scheduleIds){
		string country = searchCriteria.country;
		string region = searchCriteria.region; 
		string outage = searchCriteria.outage;
		string severity = searchCriteria.severity;
		string accountId = searchCriteria.customerId;
		List<String> levelOfSupports = searchCriteria.levelOfSupports;
		List<string> productIds = searchCriteria.getProductIds();
		List<string> workgroupTypes = searchCriteria.workgroupTypes;
		string productId = searchCriteria.productId;
		//Added as part of US 26399			
		string productModuleId= searchCriteria.productModule;
		string productVariantId= searchCriteria.productVariant;
		string productSolutionId= searchCriteria.solution;
		
		
		System.debug('CH_CA:productIds ' + productIds);
		System.debug('CH_CA: scheduleIds ' + scheduleIds);
		
		String sQuery = ' SELECT CH_Country__c, CH_Outage__c, CH_Region__c, CH_Severity__c, ' +   
			' CH_Workgroup_Type__c, CH_Workgroup_Schedule__c, CH_Workgroup_Schedule__r.CH_Workgroup__c, ' +
			' CH_LevelOfSupport__c, CH_Solution__c,CH_ProductModule__c,CH_ProductVariant__c';
		
		if(!String.isBlank(accountId)){
			String clause = ', (SELECT Id, CH_Workgroup_Filter__c,CH_Account__c ' + 
				'   FROM Workgroup_Filter_Customer_Associations__r )';
			System.debug('CH_CA: SOQL CLAUSE: ' + clause + ' value: ' + accountId);
			sQuery += clause;
		}
		if(productIds.size() > 0){
			String clause = ', (SELECT Id, CH_Workgroup_Filter__c ,CH_Product__c' + 
				'   FROM Workgroup_Filter_Product_Associations__r )' ;
			System.debug('CH_CA: SOQL CLAUSE: ' + clause + ' value: ' + productIds);
			sQuery += clause;
		}
		
		sQuery +=  ' FROM CH_Workgroup_Filter__c WHERE CH_Workgroup_Schedule__c in :scheduleIds AND';
		System.debug('CH_CA: SOQL SELECT: ' + sQuery);
		
		if(!String.isBlank(country)){
			String whereClause = ' (CH_Country__c includes (:country) OR CH_Country__c = NULL) AND';
			System.debug('CH_CA: SOQL WHERE: ' + whereClause + ' value: ' + country);
			sQuery += whereClause;
		}
		if(!String.isBlank(region)){
			String whereClause = ' (CH_Region__c includes (:region) OR CH_Region__c = NULL) AND';
			System.debug('CH_CA: SOQL WHERE: ' + whereClause + ' value: ' + region);
			sQuery += whereClause;
		}
		if (outage != 'Any'){
			String whereClause = ' (CH_Outage__c = :outage OR CH_Outage__c = \'Any\' OR CH_Outage__c = null) AND';
			System.debug('CH_CA: SOQL WHERE: ' + whereClause + ' value: ' + outage);
			sQuery += whereClause;
		}	   
		if(!String.isBlank(severity)){
			String whereClause = ' (CH_Severity__c includes (:severity) OR CH_Severity__c = NULL) AND';
			System.debug('CH_CA: SOQL WHERE: ' + whereClause + ' value: ' + severity);
			sQuery += whereClause;
		}
		
		//Added as part of US 26399
		if(!String.isBlank(productSolutionId)){
			String whereClause = ' (CH_Solution__c = :productSolutionId OR CH_Solution__c = NULL) AND';
			System.debug('CH_CA: SOQL WHERE: ' + whereClause + ' value: ' + productSolutionId);
			sQuery += whereClause;
		}
		else{
			String whereClause = ' (CH_Solution__c = NULL) AND';
			System.debug('CH_CA: SOQL WHERE: ' + whereClause + ' value: ' + productSolutionId);
			sQuery += whereClause;
		}

		if(!String.isBlank(productModuleId)){
			String whereClause = ' (CH_ProductModule__c = :productModuleId OR CH_ProductModule__c = NULL) AND';
			System.debug('CH_CA: SOQL WHERE: ' + whereClause + ' value: ' + productModuleId);
			sQuery += whereClause;
		}
		else{
			String whereClause = ' (CH_ProductModule__c = NULL) AND';
			System.debug('CH_CA: SOQL WHERE: ' + whereClause + ' value: ' + productModuleId);
			sQuery += whereClause;
		}
		
		if(!String.isBlank(productVariantId)){
			String whereClause = ' (CH_ProductVariant__c = :productVariantId OR CH_ProductVariant__c = NULL) AND';
			System.debug('CH_CA: SOQL WHERE: ' + whereClause + ' value: ' + productVariantId);
			sQuery += whereClause;
		}
		else{
			String whereClause = ' (CH_ProductVariant__c = NULL) AND';
			System.debug('CH_CA: SOQL WHERE: ' + whereClause + ' value: ' + productVariantId);
			sQuery += whereClause;
		}
		
		if (workgroupTypes.size() > 0){
			String whereClause = '(';
			sQuery += whereClause;  
			for (string workgroupType : workgroupTypes){
				whereClause = ' CH_Workgroup_Type__c includes (\'' + workgroupType + '\') OR';
				System.debug('CH_CA: SOQL WHERE: ' + whereClause + ' value: ' + workgroupType);
				sQuery += whereClause;		  
			}
			whereClause = ' CH_Workgroup_Type__c = NULL) AND';
			System.debug('CH_CA: SOQL WHERE: ' + whereClause + ' value: ');
			sQuery += whereClause;					  
		}
		
		 //Chaitan Changes
		if (levelOfSupports != null && levelOfSupports.size() > 0 && String.isNotEmpty(levelOfSupports[0])){	   
			String whereClause;
			  
				whereClause = ' (CH_LevelOfSupport__c in :levelOfSupports OR CH_LevelOfSupport__c = NULL) AND';
			  
			System.debug('CH_CA: SOQL WHERE: ' + whereClause + ' value: ' + levelOfSupports);
			sQuery += whereClause;					
		} 
		integer len1 = sQuery.length();
		if(sQuery.endsWithIgnoreCase('AND')){
			sQuery = sQuery.substring(0, len1 - 3);
		}
		system.debug('CH_CA: country:'+country);
		system.debug('CH_CA: severity:'+severity);
		system.debug('CH_CA: outage: ' + outage);
		system.debug('CH_CA: region: ' + region);
		system.debug('CH_CA: scheduleIds'+scheduleIds);
		system.debug('CH_CA: Levelof support'+levelOfSupports);
		system.debug('CH_CA: FINAL SOQL: ' + sQuery);
		List<CH_Workgroup_Filter__c> lstOfScheduleFilters = Database.query(sQuery);
		system.debug('CH_CA: found filters: ' + lstOfScheduleFilters.size());
		System.debug('lstOfScheduleFilters Test:' + lstOfScheduleFilters);
		for(CH_Workgroup_Filter__c wf :lstOfScheduleFilters){
			system.debug('lstOfScheduleFilters' + wf);		  
		}
		for(CH_Workgroup_Filter__c wf :lstOfScheduleFilters){
			system.debug('lstOfScheduleFilters' + wf);
		}	
		// Check if the case product and account are part of accounts and products 
		// that are associated to the found filters
		List<CH_Workgroup_Filter__c> lstOfScheduleFiltersFinal = new List<CH_Workgroup_Filter__c>();
		for (CH_Workgroup_Filter__c foundFilter: lstOfScheduleFilters) {
			boolean validCustomerFilter = false;
			boolean validProductFilter = false;
			// If the associated customers is blank, this filter is ok for this customer
			if(foundFilter.Workgroup_Filter_Customer_Associations__r.size() == 0){
				system.debug('CH_CA: customer associated to filter 0. Valid');
				validCustomerFilter = true;
			}
			else {
				// check if account is in the list of associated customers
				for (CH_Workgroup_Filter_Customer_Association__c customerFilter: foundFilter.Workgroup_Filter_Customer_Associations__r){
					if (customerFilter.CH_Account__c == accountId){
						system.debug('CH_CA: customer found in associated filter list. Valid');
						validCustomerFilter = true;
						break;
					}				   
				}
			}
			// If the associated customers is blank, this filter is ok for this customer
			if(foundFilter.Workgroup_Filter_Product_Associations__r.size() == 0){
	system.debug('CH_CA: product associated to filter 0. Valid');
				validProductFilter = true;
			}
			else {
				// check if product is in the list of associated products
				for (CH_Workgroup_Filter_Product_Association__c productFilter: foundFilter.Workgroup_Filter_Product_Associations__r){
					if (productIds.contains(productFilter.CH_Product__c)){
						system.debug('CH_CA: product found in associated filter list. Valid');
						validProductFilter = true;
						break;
					}
				}
			}
			if (validCustomerFilter && validProductFilter){
				lstOfScheduleFiltersFinal.add(foundFilter);
			}
		}

		system.debug('CH_CA: found filters (with account/product check): ' + lstOfScheduleFiltersFinal.size());
		return lstOfScheduleFiltersFinal;
	}
	
	// ScheduleId is list with all scheduleIds
	// Filters is a list with the filters from scheduleIds
	// It's possible that a schedule does not have a filter.
	private set<Id> getPerWorkgroup_ScheduleWithHighestWeight(CH_CA_DTO.SearchCriteriaDTO searchCriteria, List<CH_Workgroup_Schedule__c> schedules, List<CH_Workgroup_Filter__c> filters){
		
		// For each schedule calculate the weight to determine the schedule per workgroup with 
		// the highest weight
		// Map : workgroupid, <string[0]=schedule id, string[1]=filter weight>
		Map<id, List<string>> workgroupWithMostImportantSchedules = new Map<id, List<string>>();		
		for (CH_Workgroup_Schedule__c schedule : schedules){
			// Lookup the filter for schedule
			CH_Workgroup_Filter__c filterForSchedule = getFilterForSchedule(filters, schedule.Id);
			// If no valid filter is found, the schedule must not be added
			if (filterForSchedule != null){
				List<string> scheduleInfo;
				// If the schedule has no filter
				if (schedule.CH_Workgroup_Filters_Count__c==0){
					scheduleInfo = new List<string>();
					scheduleInfo.add(schedule.Id);
					scheduleInfo.add('0');
				}
				else { // If the schedule has a filter, add the filter with the highest weight
					// Calculate the weight
					integer weight = calculateWeight(searchCriteria, filterForSchedule);
					// Get the schedule with the highest weight for the workgroup
					scheduleInfo = workgroupWithMostImportantSchedules.get(schedule.CH_Workgroup__c);
					if (scheduleInfo == null){
						scheduleInfo = new List<string>();
						scheduleInfo.add(schedule.Id);
						scheduleInfo.add(String.valueOf(weight));					
					}
					else {
						// If the new weight is larger then update 
						if (weight > Integer.valueOf(scheduleInfo[1])){
							scheduleInfo[0] = schedule.Id;
							scheduleInfo[1] = String.valueOf(weight);
						}
					}
				}
				workgroupWithMostImportantSchedules.put(schedule.CH_Workgroup__c, scheduleInfo); 
			}
		}
		
		// Convert the list of schedules to a list of Ids
		set<id> mostImportantSchedules = new set<id>();
		for (List<string> scheduleInfo : workgroupWithMostImportantSchedules.values()){
			mostImportantSchedules.add(scheduleInfo[0]);
		}
		
		system.debug('CH_CA: Schedules per Workgroup with highest weight ' + mostImportantSchedules);
		return mostImportantSchedules;
	}
	
	// ScheduleId is list with all scheduleIds
	// Filters is a list with the filters from scheduleIds
	// It's possible that a schedule does not have a filter.
	public Map<Id, integer> getPerWorkgroup_AllScheduleWithWeight(CH_CA_DTO.SearchCriteriaDTO searchCriteria, List<CH_Workgroup_Schedule__c> schedules, List<CH_Workgroup_Filter__c> filters){
		
		// For each schedule calculate the weight to determine the schedule per workgroup with 
		// the highest weight
		// Map : workgroupid, <string[0]=schedule id, string[1]=filter weight>
		Map<id, integer> workgroupWithAllSchedules = new Map<id, integer>(); 
		for (CH_Workgroup_Schedule__c schedule : schedules){
			// Lookup the filter for schedule
			CH_Workgroup_Filter__c filterForSchedule = getFilterForSchedule(filters, schedule.Id);
			// Calculate the weight
			integer weight = calculateWeight(searchCriteria, filterForSchedule);
			
			workgroupWithAllSchedules.put(schedule.Id, weight);
		}
		
		system.debug('CH_CA: All Schedules per Workgroup ' + workgroupWithAllSchedules);
		return workgroupWithAllSchedules;
	}
		
	// For a list of workgroups get a list of valid schedules based on the
	// schedule dates and schedule filter
	private set<Id> createListIdsFromObjects(List<sObject> listOfObjects){
		// Convert the list into a set
		set<id> listOfIds = new set<id>();
		for (sObject objectItem : listOfObjects){
			listOfIds.add(objectItem.id);
		}
		
		return listOfIds;
	}
	
	// Calculate the weight for a filter
	private integer calculateWeight(CH_CA_DTO.SearchCriteriaDTO searchCriteria, CH_Workgroup_Filter__c filter){
		integer weight = 0;
		if (filter == null){
			return weight;
		}
		// Modified as a part of defect 28977
		/*
		if (filter.CH_Country__c == searchCriteria.country){
			weight++;
		}
		*/
		if( !String.isBlank(searchCriteria.country) && filter.CH_Country__c != null && filter.CH_Country__c.contains(searchCriteria.country)){
			weight++;
			system.debug('CH_CA: CH_Country__c--'+weight);  
		}
		if (filter.CH_Region__c == searchCriteria.region){
			weight++;
		}   
		if (filter.CH_Outage__c!='Any' && filter.CH_Outage__c == searchCriteria.outage){
			weight++;
		}
		// Modified as a part of defect 28977
		/*
		
		if (filter.CH_Severity__c == searchCriteria.severity){
			weight++;
		}
		*/
		if( !String.isBlank(searchCriteria.severity) && filter.CH_Severity__c != null && filter.CH_Severity__c.contains(searchCriteria.severity)){
			weight++;
			system.debug('CH_CA: CH_Severity__c--'+weight); 
		}
		if (filter.Workgroup_Filter_Customer_Associations__r.size() > 0){
			weight++;
		}
		if (filter.Workgroup_Filter_Product_Associations__r.size() > 0){
			weight++;
		}
		
		//Added as a part of US 26399
		system.debug('CH_CA: searchCriteria ' + searchCriteria);
		system.debug('CH_CA: searchCriteria.productModule ' + searchCriteria.productModule);
		system.debug('CH_CA: filter.CH_ProductModule__c ' + filter.CH_ProductModule__c);
		if ( !String.isBlank(searchCriteria.solution) && filter.CH_Solution__c == searchCriteria.solution){		
			weight++;		   
		}
		if ( !String.isBlank(searchCriteria.productModule) && filter.CH_ProductModule__c== searchCriteria.productModule){
			weight++;		 
		}
		if ( !String.isBlank(searchCriteria.productVariant) && filter.CH_ProductVariant__c== searchCriteria.productVariant){
			weight++;		  
		}
		
		for (string workgroupType : searchCriteria.workgroupTypes){
			if (filter.CH_Workgroup_Type__c != null && 
				filter.CH_Workgroup_Type__c.contains(workgroupType)){
				weight++;
				break;
			}  
		}
		for (string levelOfSupport : searchCriteria.levelOfSupports){
			if (filter.CH_LevelOfSupport__c != null && String.isNotBlank(levelOfSupport) &&
				filter.CH_LevelOfSupport__c.contains(levelOfSupport)){
				weight++;
				break;
			}  
		}
		system.debug('CH_CA: weight '+weight);
		return weight;	  
	}
	
	// Find the filter for the scheduleId
	private CH_Workgroup_Filter__c getFilterForSchedule(List<CH_Workgroup_Filter__c> filters, Id scheduleId){
		CH_Workgroup_Filter__c foundFilter = null;
		for(CH_Workgroup_Filter__c filter : filters){
			if (filter.CH_Workgroup_Schedule__c == scheduleId){
				foundFilter = filter;
				break;
			}
		}
		return foundFilter;
	}
}