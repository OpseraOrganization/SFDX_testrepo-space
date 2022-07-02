/****************************************************************
* Class Name : HWS_ServiceQuoteAssignmentHelper 
* Created Date: 05-11-2021
* Created By: NOKIA
* Description : This Class is used as handler for WG Assignment
				Created for HWSDDP-63 
* Modification Log:
---------------------------------------------------------
Modified By	 Modified For US#	Modified Date

******************************************************************/
public without sharing class HWS_ServiceQuoteAssignmentHelper {
	private Map<Id,HWS_Service_Quote__c> servQuoteDetailsMap;
	public HWS_ServiceQuoteAssignmentHelper(Set<Id> servQuoteIdLst){
		servQuoteDetailsMap = new Map<Id,HWS_Service_Quote__c>([SELECT Id, Name,HWS_Support_Ticket__r.HWS_RecordTypeCheck__c,									
						RecordTypeId,RecordType.DeveloperName,HWS_Support_Ticket__r.Parent.Country__c,HWS_Quote_Status__c
						FROM HWS_Service_Quote__c WHERE Id =:servQuoteIdLst]);
	}
		
	public List<CH_CA_DTO.SearchCriteriaDTO> getServQuoteDetails(){		
		List<CH_CA_DTO.SearchCriteriaDTO> searchCriteriaDTOList = new List<CH_CA_DTO.SearchCriteriaDTO>();
		List<String> workgroupTypes = new List<String>();   
		
		for(HWS_Service_Quote__c servQuote : servQuoteDetailsMap.values()){
			CH_CA_DTO.SearchCriteriaDTO searchCriteriaDTO = new CH_CA_DTO.SearchCriteriaDTO();
			searchCriteriaDTO.serviceQuoteId = servQuoteDetailsMap.get(servQuote.Id).Id;
			searchCriteriaDTO.recordTypeName = servQuoteDetailsMap.get(servQuote.Id).RecordType.DeveloperName;
			searchCriteriaDTO.serviceType = HWS_Constants.SQ_SERVICE_TYPE;
			searchCriteriaDTO.activeRules = true;
			searchCriteriaDTO.country = servQuoteDetailsMap.get(servQuote.Id).HWS_Support_Ticket__r.Parent.Country__c;
			searchCriteriaDTO.region = CH_CA_Assignment_Criteria_DTO.getRegionByCountry(searchCriteriaDTO.country);
			searchCriteriaDTO.HWSRecordTypeCheck = servQuoteDetailsMap.get(servQuote.Id).HWS_Support_Ticket__r.HWS_RecordTypeCheck__c;
			//for SME3 assignment - damaged and unreturned part quote
			if(servQuoteDetailsMap.get(servQuote.Id).HWS_Quote_Status__c == HWS_Constants.SQ_STATUS_CDM_REVIEW || servQuoteDetailsMap.get(servQuote.Id).HWS_Quote_Status__c == HWS_Constants.SQ_STATUS_ON_HOLD || servQuoteDetailsMap.get(servQuote.Id).HWS_Quote_Status__c == HWS_Constants.SQ_STATUS_IN_PROGRESS || servQuoteDetailsMap.get(servQuote.Id).HWS_Quote_Status__c == HWS_Constants.SQ_STATUS_CANCELLED){
				workgroupTypes.add('Exclusions Quotation Support-CDM');
			}
			//for SME2 assignment - damaged and unreturned part quote
			else if(servQuoteDetailsMap.get(servQuote.Id).HWS_Quote_Status__c == HWS_Constants.SQ_STATUS_ACCEPTED_CDM || servQuoteDetailsMap.get(servQuote.Id).HWS_Quote_Status__c == HWS_Constants.SQ_STATUS_REJECTED_CDM){
				workgroupTypes.add('Exclusions Quotation Support-OC');
			}
			searchCriteriaDTO.workgroupTypes = workgroupTypes;
			searchCriteriaDTOList.add(searchCriteriaDTO);
		}
		return searchCriteriaDTOList;
	}
	
	public Map<Id,List<CH_Workgroup_Rule__c>> getPassiveQuoteAssignmentWgRule() {
		Map<Id,List<CH_Workgroup_Rule__c>> foundWorkgroupRulesMap = new Map<Id,List<CH_Workgroup_Rule__c>>();
		try{
			List<CH_CA_DTO.SearchCriteriaDTO> searchCriteriaDTOList = getServQuoteDetails(); 
			// Get the first workgroup rule based on the Service Quote fields
			CH_CA_Workgroup_Rule ruleHandler = new CH_CA_Workgroup_Rule();
			for(CH_CA_DTO.SearchCriteriaDTO sc : searchCriteriaDTOList){
	CH_CA_Assignment_Criteria_DTO quoteDetails = ruleHandler.getWorkgroupRules(sc, true); 
	foundWorkgroupRulesMap.put(sc.serviceQuoteId,quoteDetails.validWorkgroupRules);
			}
		}catch(Exception e){
			return foundWorkgroupRulesMap;
		}
		return foundWorkgroupRulesMap;
	}
}