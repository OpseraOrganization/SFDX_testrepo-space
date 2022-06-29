/****************************************************************
* Class Name : CH_CA_Workgroup_Rule 
* Created Date: 
* Created By: TCS
* Description : This Class is used as helper for WG assignment
* Modification Log:
---------------------------------------------------------
Modified By	 Modified For US#	Modified Date

******************************************************************/
public without sharing class CH_CA_Workgroup_Rule {
	// Get the workgroup rules for the rule based on the search criteria - Used by lightning component CH_Test_Workgroup_Rules
	public static List<CH_Workgroup_Rule__c> GetWorkgroupRules(CH_CA_Assignment_Criteria_DTO caseAssignmentDetails){
		return getAllWorkgroupRules(caseAssignmentDetails);
	} 
	
	// Get the workgroup rules that apply to the search criteria
	// Points to the old GetWorkgroupRules2 that still uses the old
	// CH_CA_Assignment_Criteria_DTO. This needs to be refactored.
	public CH_CA_Assignment_Criteria_DTO getWorkgroupRules(CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO, boolean onlyFirstRule){
		// Temp reformat from new DTO to old DTO. Needs refactoring
		CH_CA_Assignment_Criteria_DTO caseAssignmentDetails = TempSearchCriteriaToCaseAssignmentDTO(searchCriteriaDTO);
		return GetWorkgroupRules2(caseAssignmentDetails,onlyFirstRule);
	}
	
	// Get the workgroup members for the add members to case team component
	public CH_CA_Assignment_Criteria_DTO GetWorkgroupRules2(CH_CA_Assignment_Criteria_DTO caseAssignmentDetails, boolean onlyFirstRule){
		// Get the worgroup rules that apply
		List<CH_Workgroup_Rule__c> allWorkgroupRules = getAllWorkgroupRules(caseAssignmentDetails);
		// If only the first rule needs to be used for getting the workgroup members
		If (onlyFirstRule){
			List<CH_Workgroup_Rule__c> tempValidWorkgroupRules = new List<CH_Workgroup_Rule__c>();
			tempValidWorkgroupRules.add(allWorkgroupRules[0]);
			caseAssignmentDetails.validWorkgroupRules = tempValidWorkgroupRules;
		} else { caseAssignmentDetails.validWorkgroupRules = allWorkgroupRules;
		}
		return caseAssignmentDetails;
	}
	
	// Get all workgroup rules that are according to the rule criteria
	@TestVisible
	private static List<CH_Workgroup_Rule__c> getAllWorkgroupRules(CH_CA_Assignment_Criteria_DTO caseAssignmentDetails) {
		// Dynamic SOQL doesn't allow complex binding so this is a workaround
		string contractType=caseAssignmentDetails.contractType;
		string contract = caseAssignmentDetails.contract;
		string severity = caseAssignmentDetails.severity;
		string region = caseAssignmentDetails.region;
		string serviceType = caseAssignmentDetails.serviceType;
		string country = caseAssignmentDetails.country;
		List<string> levelOfSupport = caseAssignmentDetails.levelOfSupport;
		string customerId = caseAssignmentDetails.customerId;
		List<Id> customerGroupIds = caseAssignmentDetails.customerGroupIds;
		Id customerGroupId = caseAssignmentDetails.customerGroupId;
		string productId = caseAssignmentDetails.productId;
		string productModule = caseAssignmentDetails.productModule;
		string productVariant = caseAssignmentDetails.productVariant;
		string productRelease = caseAssignmentDetails.productRelease;
		string solution = caseAssignmentDetails.solution;
		List<Id> productGroupIds = caseAssignmentDetails.productGroupIds;
		Id productGroupId = caseAssignmentDetails.productGroupId;
		string outage = caseAssignmentDetails.outage;
		boolean activeValue; 
		String active = caseAssignmentDetails.active; 
		Boolean workgroupTypeSize = false;
				//NOKIASC-34641-variable added to check HWS or SWS case
		Boolean  HWSRecordTypeCheck=caseAssignmentDetails.HWSRecordTypeCheck;
		// Changes added as a part of 28331
		Boolean isLevelOfSuppport = false;
		String servQuoteId = caseAssignmentDetails.serviceQuoteId;
		if (!String.isBlank(active) && active!= 'Any'){
			if(active=='Yes'||active=='true'){
	activeValue=true;
			} else{ activeValue=false;
			}
		}
		List<string> workgroupType =caseAssignmentDetails.workgroupType; 
		//Changes added from 20.1.2
		if(workgroupType.size() == 1 && workgroupType[0] == ''){
			workgroupTypeSize = true;
		}
		//Changes added as a part of 28331
		if(levelOfSupport.size() == 1 && (levelOfSupport[0] == '' || levelOfSupport[0] == null)){
			isLevelOfSuppport = true;
		}
		string kbWorkgroupRecordTypeId = Schema.SObjectType.CH_Workgroup_Rule__c.getRecordTypeInfosByDeveloperName().get('CH_KB_WorkgroupRule').getRecordTypeId();
		String sQuery = 'SELECT Id, Name, CH_Workgroup__r.Name, CH_OrderNumber__c, CH_ServiceType__c,CH_Contract_Type__c,CH_Workgroup__r.recordtypeid, ' + 
			'  CH_ServiceContract__r.Name, CH_Severity__c, CH_Region1__c, CH_Workgroup__c, CH_Solution__r.Name, ' +
			'  CH_Country1__c, CH_LevelOfSupport__c, CH_Account__r.Name, CH_ProductVariant__r.Name, CH_ProductRelease__r.Name, ' +
			'  CH_Customer_Group__r.Name, CH_Product__r.Name, CH_Product_Module__r.Name, ' +
			'  CH_Product_Group__r.Name, CH_Outage__c, CH_BusinessHours__c, CH_Workgroup__r.CH_BusinessHours__c,CH_Workgroup_Type__c,CH_Active__c' +
			'  FROM CH_Workgroup_Rule__c WHERE recordtypeid != :kbWorkgroupRecordTypeId AND ';
		if(String.isBlank(servQuoteId)){
			if(activeValue!=null){
	String whereClause = ' (CH_Active__c= :activeValue)AND'; sQuery += whereClause;
			}
			if (workgroupType.size() > 0 && !workgroupTypeSize){
	String whereClause = ' (CH_Workgroup_Type__c IN :workgroupType OR CH_Workgroup_Type__c= NULL) AND'; sQuery += whereClause;
			}
			if(!String.isBlank(contractType) ){
	String whereClause = ' (CH_Contract_Type__c= :contractType OR CH_Contract_Type__c= NULL) AND'; sQuery += whereClause;
			}
			if(!String.isBlank(contract)){
	String whereClause = ' (CH_ServiceContract__c= :contract OR CH_ServiceContract__c= NULL) AND'; sQuery += whereClause;
			}
			else{
	String whereClause = ' (CH_ServiceContract__c= NULL) AND'; sQuery += whereClause;
			}
			
			if (!String.isBlank(serviceType)){
	//34648
	if(serviceType == 'Hardware Support'){
		String whereClause = ' CH_ServiceType__c = :serviceType AND'; sQuery += whereClause;
	}
	else{
		String whereClause = ' (CH_ServiceType__c = :serviceType OR CH_ServiceType__c = NULL) AND'; sQuery += whereClause;
	}
			}
			if (!String.isBlank(severity)){
	String whereClause = ' (CH_Severity__c= :severity OR CH_Severity__c= NULL) AND'; sQuery += whereClause;
			}
			if (!String.isBlank(country) && !country.equals('--None--')){   //country case is always not blank
	String whereClause = ' ( (CH_Country1__c= :country AND CH_Region1__c= :region) OR '+
		'(CH_Country1__c= :country AND CH_Region1__c= NULL) OR '+
		'(CH_Country1__c= NULL AND CH_Region1__c= NULL) OR '+
		'(CH_Country1__c= NULL AND CH_Region1__c= :region) ) AND';
	sQuery += whereClause;
			}
			if (!String.isBlank(region) && !region.equals('--None--')){   
	String whereClause = ' (CH_Region1__c= :region OR CH_Region1__c= NULL) AND'; sQuery += whereClause;
			}
			//Changes added as a part of 28331
			if (levelOfSupport.size()>0 && !isLevelOfSuppport){
	String whereClause = ' (CH_LevelOfSupport__c IN :levelOfSupport OR CH_LevelOfSupport__c= NULL) AND'; sQuery += whereClause;
			}
			if (!String.isBlank(customerId) && customerGroupIds.size() == 0){
	String whereClause = ' ((CH_Account__c= :customerId OR CH_Account__c= NULL) AND CH_Customer_Group__c= NULL) AND'; sQuery += whereClause;
			}
			if (!String.isBlank(customerId) && customerGroupIds.size() > 0){
	String whereClause = ' ((CH_Account__c= :customerId OR CH_Account__c= NULL) AND (CH_Customer_Group__c IN :customerGroupids OR CH_Customer_Group__c = null)) AND'; sQuery += whereClause;
			}
			if (String.isBlank(customerId) && !String.isBlank(customerGroupId)){
	String whereClause = ' (CH_Customer_Group__c = :customerGroupId OR CH_Customer_Group__c= NULL) AND'; sQuery += whereClause;
			}
			if (!String.isBlank(productId) && productGroupIds.size() == 0){
	String whereClause = ' ((CH_Product__c= :productId OR CH_Product__c= NULL) AND CH_Product_Group__c= Null) AND'; sQuery += whereClause;
			}
			if (!String.isBlank(productId) && productGroupIds.size() > 0){
	String whereClause = ' ((CH_Product__c= :productId OR CH_Product__c= NULL) AND (CH_Product_Group__c IN :productGroupids OR CH_Product_Group__c = null)) AND';
	sQuery += whereClause;
			}
			if (String.isBlank(productId) && !String.isBlank(productGroupId)){
	String whereClause = ' (CH_Product_Group__c = :productGroupid OR CH_Product_Group__c= Null) AND'; sQuery += whereClause;
			}
			if (!String.isBlank(productModule)){
	String whereClause = ' (CH_Product_Module__c = :productModule OR CH_Product_Module__c= Null) AND'; sQuery += whereClause;
			}
			else {
	String whereClause = ' (CH_Product_Module__c = :productModule) AND'; sQuery += whereClause;			
			}		
			if (!String.isBlank(productVariant)){
	String whereClause = ' (CH_ProductVariant__c = :productVariant OR CH_ProductVariant__c= Null) AND'; sQuery += whereClause;
			}
			else {
	String whereClause = ' (CH_ProductVariant__c = :productVariant) AND';
	sQuery += whereClause;			
			}
			if (!String.isBlank(productRelease)){
	String whereClause = ' (CH_ProductRelease__c = :productRelease OR CH_ProductRelease__c = Null) AND';
	sQuery += whereClause;
			}
			if (!String.isBlank(solution)){
	String whereClause = ' (CH_Solution__c = :solution OR CH_Solution__c= Null) AND';
	sQuery += whereClause;
			} 
			else {
	String whereClause = ' (CH_Solution__c = :solution) AND';
	sQuery += whereClause;			
			}		system.debug('Value of outage:'+outage);
			if (outage != 'Any'){
	String whereClause = ' (CH_Outage__c = :outage OR CH_Outage__c = \'Any\') AND'; sQuery += whereClause;
			}
			else {
	String whereClause = ' (CH_Outage__c = \'Any\' OR CH_Outage__c = \'Yes\' OR CH_Outage__c = \'No\') AND';
	sQuery += whereClause;
			}
		}	
		else{ //added for HWSDDP-160
			if(activeValue!=null){
	String whereClause = ' (CH_Active__c= :activeValue) AND';
	sQuery += whereClause;
			}
			if (workgroupType.size() > 0 && !workgroupTypeSize){
	String whereClause = ' (CH_Workgroup_Type__c IN :workgroupType) AND'; sQuery += whereClause;
			}
			if (!String.isBlank(serviceType) && serviceType == 'Hardware Support'){
	String whereClause = ' CH_ServiceType__c = :serviceType AND'; sQuery += whereClause;
			}
			if (!String.isBlank(country) && !country.equals('--None--')){   //country case is always not blank
	String whereClause = '(CH_Country1__c= :country OR CH_Country1__c = NULL) AND'; sQuery += whereClause;
			}
			if (!String.isBlank(region)){   
	String whereClause = ' (CH_Region1__c= :region OR CH_Region1__c = NULL) AND'; sQuery += whereClause;
			}
		}
		integer len1 = sQuery.length();
		if(sQuery.endsWithIgnoreCase('AND')){
			sQuery = sQuery.substring(0, len1 - 3);
		}
		if(sQuery.endsWithIgnoreCase('WHERE')){
			sQuery = sQuery.substring(0, len1 - 5);
		}
		//NOKIASC-34641-variable added to check HWS or SWS case
		if(serviceType == 'Hardware Support'){
	  sQuery = ''+sQuery+' ORDER BY CH_Workgroup_Type__c DESC,CH_OrderNumber__c ASC NULLS LAST';  
		}
		else { sQuery = ''+sQuery+' ORDER BY CH_OrderNumber__c ASC NULLS LAST'; 
		}
		List<CH_Workgroup_Rule__c> lstOfWorkgroupRules = new List<CH_Workgroup_Rule__c>();
		lstOfWorkgroupRules = Database.query(sQuery);
		if(lstOfWorkgroupRules.size() == 0 && lstOfWorkgroupRules.isEmpty() && !String.isBlank(servQuoteId)){
			ErrorLog__c errlog = CH_ErrorLogUtils.createErrorLog('No matching Workgroup Rule found','CH_CA_Workgroup_Rule-getAllWorkgroupRules','OTHERS-OTHERS','HWS-Service Quotation',servQuoteId);
			insert errlog;
		}
		return lstOfWorkgroupRules;
	}
	
	// Temp class that needs to be refactored.
	// The code for CH_CA_Assignment_Criteria_DTO in this class needs to be replaced by 
	private CH_CA_Assignment_Criteria_DTO TempSearchCriteriaToCaseAssignmentDTO(CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO){
		CH_CA_Assignment_Criteria_DTO caseAssignmentDTO = new CH_CA_Assignment_Criteria_DTO();
		caseAssignmentDTO.contract = searchCriteriaDTO.contract;
		caseAssignmentDTO.severity = searchCriteriaDTO.severity;
		caseAssignmentDTO.region = searchCriteriaDTO.region;
		caseAssignmentDTO.country = searchCriteriaDTO.country;
		caseAssignmentDTO.levelOfSupport = searchCriteriaDTO.levelOfSupports;
		if (!String.isBlank(searchCriteriaDTO.customerId)){
			caseAssignmentDTO.customerId = searchCriteriaDTO.customerId;
		}
		caseAssignmentDTO.GetCustomerGroupsForCustomer();
		if (!String.isBlank(searchCriteriaDTO.customerGroupId)){
			caseAssignmentDTO.customerGroupId = searchCriteriaDTO.customerGroupId;
		}
		if (!String.isBlank(searchCriteriaDTO.productId)){
			caseAssignmentDTO.productId = searchCriteriaDTO.productId;
		}
		caseAssignmentDTO.GetProductGroupsForProduct();
		if (!String.isBlank(searchCriteriaDTO.productGroupId)){
			caseAssignmentDTO.productGroupId = searchCriteriaDTO.productGroupId;
		}
		caseAssignmentDTO.workgroupType = searchCriteriaDTO.workgroupTypes;
		caseAssignmentDTO.outage = searchCriteriaDTO.outage;
		caseAssignmentDTO.active = String.valueOf(searchCriteriaDTO.activeRules);
		caseAssignmentDTO.serviceType = searchCriteriaDTO.serviceType;
		if (!String.isBlank(searchCriteriaDTO.solution)){ caseAssignmentDTO.solution = searchCriteriaDTO.solution;
		}
		if (!String.isBlank(searchCriteriaDTO.productModule)){ caseAssignmentDTO.productModule = searchCriteriaDTO.productModule;
		}
		if (!String.isBlank(searchCriteriaDTO.productVariant)){ caseAssignmentDTO.productVariant = searchCriteriaDTO.productVariant;
		}
		if (!String.isBlank(searchCriteriaDTO.productRelease)){ caseAssignmentDTO.productRelease = searchCriteriaDTO.productRelease;
		}
		if (!String.isBlank(searchCriteriaDTO.serviceQuoteId)){ caseAssignmentDTO.serviceQuoteId = searchCriteriaDTO.serviceQuoteId;
		}
		caseAssignmentDTO.contractType =searchCriteriaDTO.contractType;
		return caseAssignmentDTO;
	}
}