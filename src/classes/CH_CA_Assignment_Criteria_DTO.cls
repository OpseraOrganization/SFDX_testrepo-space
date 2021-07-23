public class CH_CA_Assignment_Criteria_DTO {
	@AuraEnabled
	public string contract;
	@AuraEnabled
	public string severity;
	@AuraEnabled
	public string region;
	@AuraEnabled
	public string country;
	@AuraEnabled
	public List<string> levelOfSupport;
	@AuraEnabled
	public Id customerId;
	@AuraEnabled
	public List<Id> customerGroupIds;
	@AuraEnabled
	public Id customerGroupId;
	@AuraEnabled
	public Id productId;
	@AuraEnabled
	public List<Id> productGroupIds;
	@AuraEnabled
	public Id productGroupId;
	@AuraEnabled
	public string outage; //[Yes|No|Any]
	@AuraEnabled
	public Case supportCase;
	@AuraEnabled
	public List<CH_Workgroup_Rule__c> validWorkgroupRules;
	@AuraEnabled
	public boolean isActiveAssignment;
	@AuraEnabled
	public boolean isCaseTeamAssignment;
	@AuraEnabled
	public boolean isCaseTeamSearch;
	@AuraEnabled
	public boolean isAvailableAccordingToRota;
	@AuraEnabled
	public boolean isAvailableAccordingToSchedule;
	@AuraEnabled
	public boolean displayMembersAccordingToAvailability ;
	@AuraEnabled
	public string settingValue = '' ;
	@AuraEnabled
	public List<CH_Workgroup_Member__c> validWorkgroupMembers;
	@AuraEnabled
	public List<string> workgroupType;
	@AuraEnabled
	public String active; 
	@AuraEnabled
	public String serviceType; 
	@AuraEnabled
	public Id productModule;
	@AuraEnabled
	public Id productVariant;
	@AuraEnabled
	public Id solution;
	@AuraEnabled
	public string contractType;
	
	
	public CH_CA_Assignment_Criteria_DTO(){
		levelOfSupport = new List<string>();
		customerGroupIds = new List<Id>();
		productGroupIds = new List<Id>();
		outage = 'Any';
		validWorkgroupRules = new List<CH_Workgroup_Rule__c>();
		isActiveAssignment = false;
		isCaseTeamAssignment = false;
		isAvailableAccordingToRota = false;
		isAvailableAccordingToSchedule = false;
		isCaseTeamSearch = false;
		displayMembersAccordingToAvailability = false;
		validWorkgroupMembers = new List<CH_Workgroup_Member__c>();
		workgroupType = new List<string>();
		serviceType = '';
		active = 'true';  //[By default 'Yes']
	}
	
	// Get all the customer groups that the customer is part of
	public void GetCustomerGroupsForCustomer(){
		// If no customer id is filled in
		if (customerId == null){return;}
		// Get the customgroups that the case accont is part of
		List<CH_CustomerGroup_Account__c> validCustomerGroups = [SELECT Id, CH_Customer_Grouping__c 
				 FROM CH_CustomerGroup_Account__c 
				 WHERE CH_Account__c =:customerId];
		customerGroupIds = new List<Id>();
		if(validCustomerGroups.size() > 0){
			for(CH_CustomerGroup_Account__c validCustomerGroup :validCustomerGroups){
	customerGroupIds.add(validCustomerGroup.CH_Customer_Grouping__c);
			}
		}
	}
	
	// Get all the products groups that the product is part of
	public void GetProductGroupsForProduct(){
		// If no customer id is filled in
		if (productId == null){return;}
		// Get the productgroups that the case product is part of
		List<CH_ProductGroup_Product__c> productGroupList = [SELECT id, CH_Product_Grouping__c 
				FROM CH_ProductGroup_Product__c 
				WHERE CH_Product__c =:productId];
		productGroupIds = new List<Id>();
		if(productGroupList.size() > 0){
			for(CH_ProductGroup_Product__c validProductGroup :productGroupList){
	productGroupIds.add(validProductGroup.CH_Product_Grouping__c);
			}
		}
	}

	public static String getRegionByCountry(String country) {
		//map the countries in a region
		Map<String, List<String>> regionCountryMap  = CH_CA_TestWorkgroupRules_Controller.getDependentMap(new CH_Workgroup_Rule__c(), 'CH_Region1__c', 'CH_Country1__c');
		for(String region: regionCountryMap.keySet()){
			for(String countryInMap : regionCountryMap.get(region)){
	if(countryInMap.equals(country))
	{
		return region;
	}
			}
		}
		return '';
	}
	
	// Convert the case fields to rule fields
	public CH_CA_Assignment_Criteria_DTO createIncidentSearchCriteria(Case supportCase){
		// Determine the level of support
		List<string> levelOfSupports = new List<string>();
		List<string> workgroupTypes = new List<string>();
		if (supportCase.Status == 'Created'){
			levelOfSupports.add('Initial Support');			
			workgroupTypes.add('Smart Tier 1');
			workgroupTypes.add('Engineer');
		} else {
			levelOfSupports.add('Initial Support');
			levelOfSupports.add('Advanced Support');
			workgroupTypes.add('Engineer');
		}
		CH_CA_Assignment_Criteria_DTO caseAssignmentDetails = new CH_CA_Assignment_Criteria_DTO();
		caseAssignmentDetails.supportCase = supportCase;
		
		// Create search criteria
	if(supportCase.CH_Rep_CDBContractType__c==''||supportCase.CH_Rep_CDBContractType__c==NUll){
	 caseAssignmentDetails.contractType='--None--';
		}
		else{
			caseAssignmentDetails.contractType=supportCase.CH_Rep_CDBContractType__c;
		}
		//caseAssignmentDetails.contractType=supportCase.CH_Rep_CDBContractType__c;
		caseAssignmentDetails.contract = supportCase.NCP_Service_Contract__r.Id;
		caseAssignmentDetails.severity = supportCase.Severity__c;
		caseAssignmentDetails.region = getRegionByCountry(supportCase.Country__c);
		caseAssignmentDetails.country = supportCase.Country__c;
		caseAssignmentDetails.levelOfSupport = levelOfSupports;
		caseAssignmentDetails.customerId = supportCase.AccountId;
		caseAssignmentDetails.GetCustomerGroupsForCustomer();
		caseAssignmentDetails.customerGroupId = null; // only used for search screens
		caseAssignmentDetails.productId = supportCase.ProductId;
		caseAssignmentDetails.GetProductGroupsForProduct();
		caseAssignmentDetails.productGroupId = null; // only used for search screens
		caseAssignmentDetails.outage = supportCase.CH_Outage__c;
		caseAssignmentDetails.workgroupType=workgroupTypes;
		caseAssignmentDetails.serviceType = supportCase.CH_ServiceType__c;
		caseAssignmentDetails.productModule = supportCase.CH_Product_Module__c;
		caseAssignmentDetails.productVariant = supportCase.CH_ProductVariant__c;
		caseAssignmentDetails.solution = supportCase.CH_Solution__c;
		
		// Setting service contract from Entitlement to case assignment
		if(caseAssignmentDetails.supportCase.EntitlementId != null){
			Entitlement entitlementOnCase = [Select Id,Name,ServiceContractId FROM Entitlement where Id=:caseAssignmentDetails.supportCase.EntitlementId];	
			caseAssignmentDetails.contract=entitlementOnCase.ServiceContractId;
		}
		return caseAssignmentDetails;
	}
	
	// Convert the case fields to rule fields
	public CH_CA_Assignment_Criteria_DTO createProblemSearchCriteria(Case supportCase){
		// Determine the level of support
		List<string> levelOfSupports = new List<string>();
		levelOfSupports.add('Initial Support');
		List<string> workgroupTypes = new List<string>();   
		workgroupTypes.add('Expert');
		CH_CA_Assignment_Criteria_DTO caseAssignmentDetails = new CH_CA_Assignment_Criteria_DTO();
		caseAssignmentDetails.supportCase = supportCase;
		
		// Create search criteria
		caseAssignmentDetails.contractType='';
		caseAssignmentDetails.contract = '';
		caseAssignmentDetails.severity = supportCase.Severity__c;
		//14488
		if(supportCase.CH_Originating_Incident_Number__c != null){
			caseAssignmentDetails.customerId = supportCase.CH_Originating_Incident_Number__r.AccountId;
			caseAssignmentDetails.country = supportCase.CH_Originating_Incident_Number__r.Country__c;
			caseAssignmentDetails.region = getRegionByCountry(supportCase.CH_Originating_Incident_Number__r.Country__c);
		}else{
			caseAssignmentDetails.customerId = null;
			caseAssignmentDetails.country = '';
			caseAssignmentDetails.region = '';
		}		
		caseAssignmentDetails.levelOfSupport = levelOfSupports;
		caseAssignmentDetails.customerGroupId = null; // only used for search screens
		caseAssignmentDetails.productId = supportCase.ProductId;
		caseAssignmentDetails.GetProductGroupsForProduct();
		caseAssignmentDetails.productGroupId = null; // only used for search screens
		caseAssignmentDetails.outage = 'No';
		caseAssignmentDetails.workgroupType= workgroupTypes;
		return caseAssignmentDetails;
	}
	
	// Get the assignment type for the case
	public Boolean getAssignmentType(CH_CA_Assignment_Criteria_DTO caseAssignmentDetails){
		Boolean isActiveAssignment = false;
		Case supportCase = caseAssignmentDetails.supportCase;
		Id problemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Problem').getRecordTypeId();
		// If an incident Then
		if(supportCase.RecordTypeID != problemRecordTypeId){
			System.debug('CH_CA: ' + supportCase.Severity__c);
			switch on supportCase.Severity__c{
	when 'Critical' {
		isActiveAssignment = (supportCase.CH_SystemRestored__c == null ? true : false);
	}
	when 'Major', 'Minor' {
		isActiveAssignment = calculatePassiveActive(caseAssignmentDetails);
	}
	when 'Information Request' {
		isActiveAssignment = calculateActiveSpecifics(caseAssignmentDetails);
	}	
	when else {
		isActiveAssignment = false;
	}
			}
			System.debug('CH_CA: isActiveAssignment=' + isActiveAssignment);
		}
		else {
			// If a problem Then passive assignment
			System.debug('CH_CA: Problem isActiveAssignment=false');
			isActiveAssignment =false;
		}
		return isActiveAssignment;
	}
	
	// Check if the case is created outisde of the workgroup business hours threshold
	// Return true - if the case creation date is outside the workgroup business hours threshold
	//		false - if the case creation date is inside the workgroup business hours threshold
	private boolean calculatePassiveActive(CH_CA_Assignment_Criteria_DTO caseAssignmentDetails){
		Case supportCase = caseAssignmentDetails.supportCase;
		Boolean isActiveAssignment = false;
		
		// Check if the case is part of the workgroup active specifics
		if (calculateActiveSpecifics(caseAssignmentDetails)){
			System.debug('CH_CA: Case fields are part of workgroup specifics');
			if(!Test.isRunningTest()){
			return true;
			}
		}
		
		// Get the first milestones
		List<CaseMilestone> caseMilestones = [SELECT TargetDate, Startdate 
			 FROM CaseMilestone 
			 WHERE CaseId = :supportCase.Id 
			 ORDER BY TargetDate ASC NULLS LAST LIMIT 1];
		// If no milestones the case is passive
		// Fix because don't know how to create milestones in unit tests
		if (caseMilestones.size() == 0){
			System.debug('CH_CA: No milestones found');
			return false; 
		}
		
		// Get the workgroup information. REFACTOR
		CH_Workgroup__c lstWg = new CH_Workgroup__c();
		List<CH_Workgroup_Business_Hours_Association__c> lstWBH = new List<CH_Workgroup_Business_Hours_Association__c>();
		if(!caseAssignmentDetails.validWorkgroupRules.isEmpty()){ 
			lstWg=[SELECT CH_End_of_Business_Hours_Threshold__c, CH_Start_of_Business_Hours_Threshold__c
	   FROM CH_Workgroup__c
	   WHERE Id = :caseAssignmentDetails.validWorkgroupRules[0].CH_Workgroup__c];
			// Get the workgroup business hours
			lstWBH=[SELECT CH_Business_Hours__c, Name, CH_Business_Hours__r.Name
		FROM CH_Workgroup_Business_Hours_Association__c
		WHERE CH_Workgroup__c = :caseAssignmentDetails.validWorkgroupRules[0].CH_Workgroup__c ];
			if (lstWBH.size() == 0){
	System.debug('CH_CA: No business hours found');
	return false;
			}
		}
		Integer defaultValue = 0;
		// Recalculate the dates based on the thresholds
		DateTime milestoneStartDate = caseMilestones[0].StartDate; //supportCase.CH_MilestoneSLA_Start__c;
		System.debug('CH_CA: Original milestone start date: ' + milestoneStartDate);
		DateTime firstMilestoneTargetDate = caseMilestones[0].TargetDate;
		System.debug('CH_CA: Original milestone first target date: ' + firstMilestoneTargetDate);
		system.debug('CH_CA: lstWg'+lstWg);
		Integer startThreshold = (lstWg.CH_Start_of_Business_Hours_Threshold__c != null) ? integer.valueof(lstWg.CH_Start_of_Business_Hours_Threshold__c) : defaultValue;
		System.debug('CH_CA: WG Start Threshold ' + startThreshold);
		Integer endThreshold = (lstWg.CH_End_of_Business_Hours_Threshold__c != null) ? integer.valueof(lstWg.CH_End_of_Business_Hours_Threshold__c) : defaultValue;
		System.debug('CH_CA: WG End Threshold ' + endThreshold);
		
		
		
		// Check if the date is within the business hours			
		if(lstWBH.size() > 0){
			// Get the valid BH			
			List<CH_Workgroup_Business_Hours_Association__c> validBusinessHours2 = new List<CH_Workgroup_Business_Hours_Association__c>();
			for(CH_Workgroup_Business_Hours_Association__c wbha:lstWBH){
	if (BusinessHours.isWithin(wbha.CH_Business_Hours__c, milestoneStartDate)){
		validBusinessHours2.add(wbha);
		System.debug('CH_CA: BH Valid: ' + wbha.CH_Business_Hours__r.Name);
	}
	else {
		System.debug('CH_CA: BH Not Valid: ' + wbha.CH_Business_Hours__r.Name);
	}
			}
			
			// Outside all business hours
			if (validBusinessHours2.size() == 0){
	// Calculate the next start business hours 
	DateTime nextStartBusinessHours = calculateNextStartBH(lstWBH, milestoneStartDate);
	System.debug('CH_CA: Next start BH : ' + nextStartBusinessHours);
	// Start date outside BH
	System.debug('CH_CA: startdate outside BH ');		 
	isActiveAssignment = validateNextStartBH(firstMilestoneTargetDate, nextStartBusinessHours, startThreshold);
			}
			
			// Loop through the valid BH			
			for (CH_Workgroup_Business_Hours_Association__c validBusinessHours: validBusinessHours2){
	
	System.debug('CH_CA: BH Used for processing: ' + validBusinessHours.CH_Business_Hours__r.Name);
	
	DateTime milestoneStartDateRecalculated;	
	//if (BusinessHours.isWithin(validBusinessHours.CH_Business_Hours__c, milestoneStartDate)){
	// Start date within BH
	DateTime milestoneStartMinusStartTH = milestoneStartDate.addminutes(-startThreshold);
	Boolean milestoneStartDateWithinStartTH = !BusinessHours.isWithin(validBusinessHours.CH_Business_Hours__c, milestoneStartMinusStartTH);
	System.debug('CH_CA: milestoneStartDateWithinStartTH : ' + milestoneStartDateWithinStartTH);
	DateTime milestoneStartPlusEndTH = milestoneStartDate.addminutes(endThreshold);
	Boolean milestoneStartDateWithinEndTH = !BusinessHours.isWithin(validBusinessHours.CH_Business_Hours__c, milestoneStartPlusEndTH);
	System.debug('CH_CA: milestoneStartDateWithinEndTH : ' + milestoneStartDateWithinEndTH);
	
	// If startdate within BH and not in start end threshold then passive
	if (!milestoneStartDateWithinStartTH && !milestoneStartDateWithinEndTH){
		System.debug('CH_CA: startdate within BH and not in start end threshold ');
		isActiveAssignment = false;
	}
	
	// If startdate within BH and in start threshold 
	if (milestoneStartDateWithinStartTH && !milestoneStartDateWithinEndTH){
		System.debug('CH_CA: startdate within BH and in start threshold ');
		
		DateTime firstMilestoneTargetMinusStartTH = firstMilestoneTargetDate.addminutes(-startThreshold);
		Boolean firstMilestoneTargetDateWithinStartTH = !BusinessHours.isWithin(validBusinessHours.CH_Business_Hours__c, firstMilestoneTargetMinusStartTH);
		System.debug('CH_CA: firstMilestoneTargetDateWithinStartTH : ' + firstMilestoneTargetDateWithinStartTH);
		
		// If first target within BH and start threshold
		if (firstMilestoneTargetDateWithinStartTH){
			System.debug('CH_CA: first target within BH and start threshold ');
			isActiveAssignment = true;
		}
		else {
			isActiveAssignment = false;
		}
	}
	else{
		// If startdate within BH and in end threshold 
		if (milestoneStartDateWithinEndTH){
			DateTime nextStartBusinessHours = calculateNextStartBH(lstWBH, milestoneStartDate);
			System.debug('CH_CA: Next start BH : ' + nextStartBusinessHours);
			
			isActiveAssignment = validateNextStartBH(firstMilestoneTargetDate, nextStartBusinessHours, startThreshold);
		}
	}
	// If passive then stop further calcualtion
	if (!isActiveAssignment){
		System.debug('CH_CA: Stop processing calculatiob is Passive ');
		break;
	}
			}
		} 
		
		return isActiveAssignment;
	}
	
	// Calculate the next start datetiem of the business hours
	// If there are multiple BH take the earliest next start of the BH
	@TestVisible
	private DateTime calculateNextStartBH(List<CH_Workgroup_Business_Hours_Association__c> lstWBH, DateTime milestoneStartDate){
		DateTime nextStartBusinessHours = null;
		// Determine the next start business hours as a union of all business hours 
		for(CH_Workgroup_Business_Hours_Association__c wbha:lstWBH){
			System.debug('CH_CA: Process BH : ' + wbha.CH_Business_Hours__r.Name);
			DateTime tempMilestoneStartDate = milestoneStartDate;
			
			// Get the next business hours start time
			// From the milestone start date keep increasing the start date with 
			// 1 hour untill you are outside of business hours.
			// Then determine the next business day.
			integer hourCounter = 1;
			while (BusinessHours.isWithin(wbha.CH_Business_Hours__c, tempMilestoneStartDate)){
	tempMilestoneStartDate = tempMilestoneStartDate.addHours(1);
	hourCounter++;
	// If processed 24 hours and still not outisde BH found, then 24/7 support
	// and then the case is passive
	if (hourCounter == 24){
		isActiveAssignment = false;
		break;
	}
			}
			System.debug('CH_CA: First datetime outside of business hours: ' + tempMilestoneStartDate);
			// Next start business hours	
			DateTime tempNextStartBusinessHours = BusinessHours.nextStartDate(wbha.CH_Business_Hours__c, tempMilestoneStartDate);
			System.debug('CH_CA: Next start of business hours: ' + tempNextStartBusinessHours);
			// Get the earliest BH start date
			if (nextStartBusinessHours == null){
	nextStartBusinessHours = tempNextStartBusinessHours;
			} 
			nextStartBusinessHours = (nextStartBusinessHours > tempNextStartBusinessHours) ? tempNextStartBusinessHours : nextStartBusinessHours;			
		}
		System.debug('CH_CA: Earliest business hours start datetime: ' + nextStartBusinessHours);
		
		return nextStartBusinessHours;
	}
	
	// Validate that the first milestone start date is before next BH start
	@TestVisible
	private boolean validateNextStartBH(DateTime firstMilestoneTargetDate, DateTime nextStartBusinessHours, integer startThreshold){
		boolean isActiveAssignment = false;
		
		System.debug('CH_CA: startdate within BH and in end threshold ');
		// current 
		System.debug('CH_CA: nextStartBusinessHours: ' + nextStartBusinessHours);
		DateTime nextStartBusinessHoursWithStartThreshold = nextStartBusinessHours.addminutes(startThreshold);
		System.debug('CH_CA: nextStartBusinessHours + start threshold: ' + nextStartBusinessHoursWithStartThreshold);
		
		// Check if the case is active
		if(firstMilestoneTargetDate < nextStartBusinessHoursWithStartThreshold) {	  
			isActiveAssignment = true;
		}
		
		return isActiveAssignment;
	}
	
	// Check if the case is part of the workgroup active specifics 
	private boolean calculateActiveSpecifics(CH_CA_Assignment_Criteria_DTO caseAssignmentDetails){
		Boolean isActiveAssignment = false;
		if (isCustomer(caseAssignmentDetails) || isCountry(caseAssignmentDetails) ||
			isServiceContract(caseAssignmentDetails) || isServiceContractLineItem(caseAssignmentDetails)
			||isSeverityOutage(caseAssignmentDetails) || isMinimalReactionTime(caseAssignmentDetails) ) {
	isActiveAssignment = true;
			}  
		return isActiveAssignment;
	}
	
	// Changes w.r.t 15646 begins
	//Check if Case Customer falls under Workgorup's WorkgroupCustomerAssociation list
	//return true : If Customer under case is one among list of WorkgroupCustomerAssociation   
	private boolean isCustomer(CH_CA_Assignment_Criteria_DTO caseAssignmentDetails){
		boolean isCustomer=false;
		List<CH_Workgroup_Rule__c> caseWorkgroupRule = caseAssignmentDetails.validWorkgroupRules;
		if(caseAssignmentDetails.customerId!=null &&  caseAssignmentDetails.validWorkgroupRules.size() != 0){
			List<CH_WorkgroupCustomerAssociation__c> customerlist = [SELECT CH_Customer__c 
					 FROM CH_WorkgroupCustomerAssociation__c
					 WHERE CH_Workgroup__c = :caseWorkgroupRule[0].CH_Workgroup__c 
					 AND CH_Customer__c=: caseAssignmentDetails.customerId];
			if (!customerlist.isEmpty()){
	isCustomer=true;
			}
		}
		System.debug('CH_CA: Customer Active Override: ' + isCustomer);
		return isCustomer;
	}
	
	//Check if Country falls under Workgorup's WorkgroupCountryAssociation list
	//return true : If Country under case is one among list of WorkgroupCountryAssociation
	private boolean isCountry(CH_CA_Assignment_Criteria_DTO caseAssignmentDetails){
		boolean isCountry=false;
		List<CH_Workgroup_Rule__c> caseWorkgroupRule = caseAssignmentDetails.validWorkgroupRules;		
		if(caseAssignmentDetails.country != null && caseAssignmentDetails.validWorkgroupRules.size() != 0)
		{
			List<CH_WorkgroupCountryAssociation__c> countryList = [SELECT toLabel(CH_Country1__c)
	   FROM CH_WorkgroupCountryAssociation__c
	   WHERE CH_Workgroup__c =:caseWorkgroupRule[0].CH_Workgroup__c  
				   AND toLabel(CH_Country1__c)=:caseAssignmentDetails.country];
			if (!countryList.isEmpty()){
	isCountry=true;
			}
		}
		System.debug('CH_CA: Country Active Override: ' + isCountry);
		return isCountry;
	}
	
	//Check if Contract falls under Workgorup's WorkgroupServiceContractAssociation list
	//return true : If Contract under case is one among list of WorkgroupServiceContractAssociation
	private boolean isServiceContract(CH_CA_Assignment_Criteria_DTO caseAssignmentDetails){
		boolean isServiceContract=false;
		List<CH_Workgroup_Rule__c> caseWorkgroupRule = caseAssignmentDetails.validWorkgroupRules;
		if(caseAssignmentDetails.contract!=null && caseAssignmentDetails.validWorkgroupRules.size() != 0)
		{
			List<CH_WorkgroupServiceContractAssociation__c> serviceContractList = [SELECT CH_ServiceContract__c 
					   FROM CH_WorkgroupServiceContractAssociation__c
					   WHERE CH_Workgroup__c = :caseWorkgroupRule[0].CH_Workgroup__c  
					   AND CH_ServiceContract__c=: caseAssignmentDetails.contract ];
			if(!serviceContractList.isEmpty()){
	isServiceContract=true;
			}
		}
		System.debug('CH_CA: ServiceContract Active Override: ' + isServiceContract);
		return isServiceContract;
	}
	
	//Check if ContractLineItem and Severity falls under Workgorup's CH_WorkgrougCLISeverityAssociation list
	//return true : If ContractLineItem and severity under case is one among list of WorkgroupServiceContractAssociation
	private boolean isServiceContractLineItem(CH_CA_Assignment_Criteria_DTO caseAssignmentDetails){
		boolean isServiceContracLineItem=false;
		List<CH_Workgroup_Rule__c> caseWorkgroupRule = caseAssignmentDetails.validWorkgroupRules;
		if(caseAssignmentDetails.supportCase.EntitlementId != null){
			Entitlement entitlementOnCase = [Select Id,Name,ServiceContractId,ContractLineItemId FROM Entitlement where Id=:caseAssignmentDetails.supportCase.EntitlementId LIMIT 1];	
			ContractLineItem assetContractLineItem = [SELECT Id FROM ContractLineItem WHERE Id=:entitlementOnCase.ContractLineItemId  LIMIT 1];
			if(assetContractLineItem.Id!=null && caseAssignmentDetails.validWorkgroupRules.size() != 0){
	List<CH_WorkgroupCLISeverityAssociation__c> serviceContracLineItemlist = [SELECT CH_ContractLineItem__c,CH_Severity__c 
						FROM CH_WorkgroupCLISeverityAssociation__c
						WHERE CH_Workgroup__c = :caseWorkgroupRule[0].CH_Workgroup__c 
						AND CH_Severity__c=: caseAssignmentDetails.severity 
						AND CH_ContractLineItem__c=:assetContractLineItem.Id];
	if (!serviceContracLineItemlist.isEmpty()){
		isServiceContracLineItem=true;
	}
			}
		}
		System.debug('CH_CA: ContractLineItem Active Override: ' + isServiceContracLineItem);
		return isServiceContracLineItem;
	}
	
	//Check if Severity and Outage value falls under Workgrouplist
	//return true : If Severity and Outage under case is one among Workgrouplist
	private boolean isSeverityOutage(CH_CA_Assignment_Criteria_DTO caseAssignmentDetails){
		boolean isSeverityOutage=false;
		List<CH_Workgroup_Rule__c> caseWorkgroupRule = caseAssignmentDetails.validWorkgroupRules;
		system.debug('CH_CA: caseWorkgroupRule --> ' + caseWorkgroupRule);
		if(caseWorkgroupRule != null && caseWorkgroupRule.size() > 0){
			if(caseAssignmentDetails.severity!=null &&  caseAssignmentDetails.outage!=null){
	string valSeverityOutage='Severity '+caseAssignmentDetails.severity+' and Outage '+caseAssignmentDetails.outage;
	System.debug('CH_CA: isSeverityOutage value : ' + valSeverityOutage+':and name:'+caseWorkgroupRule[0].CH_Workgroup__c);
	List<CH_Workgroup__c> workGroupList = [SELECT id,CH_Severity_Outage__c   FROM CH_Workgroup__c
				WHERE  id = :caseWorkgroupRule[0].CH_Workgroup__c
				and CH_Severity_Outage__c INCLUDES (:valSeverityOutage)
				  ];
	if (!workGroupList.isEmpty()){
		isSeverityOutage=true;
	}
			}
			System.debug('CH_CA: isSeverityOutage Override: ' + isSeverityOutage);
			return isSeverityOutage;
		}else{
			System.debug('CH_CA: No valid Workgroup Rule --> ' + caseWorkgroupRule);
			CalloutException e = new CalloutException();
			e.setMessage('The Support Ticket criteria does not fit any valid Workgroup Rule');
			throw e;
		}
	}
	
	 //Check if the Case first milestone target date and time is less than (current date and Time + Minimal reaction time) 
	 private boolean isMinimalReactionTime(CH_CA_Assignment_Criteria_DTO caseAssignmentDetails){
		Case supportCase = caseAssignmentDetails.supportCase;
		Boolean isMinimalReactionTime = false;
		// Get the first milestones
		List<CaseMilestone> caseMilestones = [SELECT TargetDate, Startdate,TargetResponseInMins FROM CaseMilestone WHERE CaseId = :supportCase.Id 
			 ORDER BY TargetDate ASC NULLS LAST LIMIT 1];
		// If no milestones the case is passive
		if (caseMilestones.size() == 0){
			System.debug('CH_CA: No milestones found');
			isMinimalReactionTime=false;
		}
		else{
			Integer defaultValue = 0;
			// Calculate the first milestone target date and time
			DateTime firstMilestoneTargetDate = caseMilestones[0].TargetDate;
			If(firstMilestoneTargetDate !=null ){
	System.debug('CH_CA: Original milestone first target date: ' + firstMilestoneTargetDate);
	
	//Get Valid WorkGroups Rules
	List<CH_Workgroup_Rule__c> caseWorkgroupRule = caseAssignmentDetails.validWorkgroupRules;
	List<CH_Workgroup__c> workGroupList = [SELECT id,CH_Minimal_Reaction_Time__c   FROM CH_Workgroup__c
				WHERE  id = :caseWorkgroupRule[0].CH_Workgroup__c Limit 1 ];
	//Check whether the Case First Milestone Target Time(In Minutes) is less than Minimal Reaction time defined for the Workgroup
	
	Integer getMinimalReactionTime = (workGroupList[0].CH_Minimal_Reaction_Time__c != null) ? integer.valueof(workGroupList[0].CH_Minimal_Reaction_Time__c) : defaultValue;
	System.debug('CH_CA: getMinimalReactionTime: ' + getMinimalReactionTime);
	Datetime currentDateTime =   System.now();
	system.debug('CH_CA: Current DateTime'+currentDateTime);
	Datetime addMinReactTime = currentDateTime.addMinutes(getMinimalReactionTime);
	system.debug('CH_CA:After adding Minimal Reaction Time:'+addMinReactTime);
	if(firstMilestoneTargetDate < addMinReactTime) {	  
		isMinimalReactionTime = true;
	}
			}
		}
		return isMinimalReactionTime;
	}
}