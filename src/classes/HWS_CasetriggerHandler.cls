/****************************************
* Class Name : HWS_CasetriggerHandler
* Created Date: 21 Nov 2018
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 11 Sep 2019
* Description : Parent Case Status should always be 'Open' until all the child Cases  under it are either closed/cancelled.
Once all child cases are either in Closed or Cancelled status, the parent Case status should be 'Closed'
* Test Class: 
*****************************************/

Public class HWS_CasetriggerHandler {
	
	/*********
	*Method Name: beforeInsertOperation
	*Parameter: New Case List
	*Description: Used to handle before Insert operation
	**********/
	public static Id esclationCase {
		get { 
			if(esclationCase == null){
	esclationCase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ESCALATION_CASE);
	
			}
			return esclationCase;
		}
		set; }
	//public static Id esclationCase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ESCALATION_CASE);
	
	Public static void beforeInsertOperation(Map <Id, Case> oldCaseMap, List <Case> newCaseList) {	
		List<Case> newEscCaseList = hwsEscaltionCasesRecordTypeCheck(newCaseList);
		if(newEscCaseList.size()>0){
			HWS_CaseTriggerHelper.sendCaPMEmailAccOwner(null,newEscCaseList);
		}
		List<Case> newHWSCaseList = hwsCasesbyRecordTypeCheck(newCaseList);
		if(newHWSCaseList.size()>0){
			HWS_CaseTriggerHelper helper = new HWS_CaseTriggerHelper();	
			HWS_CaseTriggerHelper.duplicateSerialNumberCheck(null, newHWSCaseList);		
			HWS_CaseTriggerHelper.RMANumberPopulate(null,newHWSCaseList);
			CH_SecurityUtils.setCaseSecurityGroups(newHWSCaseList, null);
		}
	} 
	
	/*********
	*Method Name: afterInsertOperation
	*Parameter: New Case List
	*Description: Used to handle after Insert operation
	**********/
	Public static void afterInsertOperation(Map < Id, Case > oldCaseMap, List < Case > newCaseList) {	
		/*  //Barcode Method Calling
		Set<Id> caseIdSet = new Set<Id>();
		for(Case c :newCaseList){
		caseIdSet.add(c.Id);
		}
		// Astrea_Barcode.GenerateBarcodes generateBarcodesInstance = new Astrea_Barcode.GenerateBarcodes();
		// generateBarcodesInstance.saveBarcodeToFields(caseIdSet, false);
		//Ends Here  
		*/	
		List<Case> newHWSCaseList = hwsCasesbyRecordTypeCheck(newCaseList);
		if(newHWSCaseList.size()>0){
			CH_AuthorizedContactSharing.handleSharing(new Map<Id, Case>(newHWSCaseList), new Map<Id, Case>(), true, false);
		}
	}   
	
	/*********
	*Method Name: beforeUpdateOperation
	*Parameter: New Case List
	*Description: Used to handle before Update operation
	**********/
	Public static void beforeUpdateOperation(Map < Id, Case > oldCaseMap, List < Case > newCaseList) {		
		List<Case> newEscCaseList = hwsEscaltionCasesRecordTypeCheck(newCaseList);
		List<Case> newHWSCaseList = hwsCasesbyRecordTypeCheck(newCaseList);	
		if(HWS_CaseTriggerHelper.updateStatCheck){
			if(newEscCaseList.size()>0){
	HWS_CaseTriggerHelper.sendCaPMEmailAccOwner(oldCaseMap,newEscCaseList);
			}
			if(newHWSCaseList.size()>0){
	HWS_CaseTriggerHelper.updateStatCheck = false;
	HWS_CaseTriggerHelper.validationsOnCase(newHWSCaseList);
	HWS_CaseTriggerHelper.duplicateSerialNumberCheck(oldCaseMap, newHWSCaseList);	
	HWS_CaseTriggerHelper.validationsOnCaseForDate(newHWSCaseList);
	HWS_CaseTriggerHelper.entitlementNamePopulate(newHWSCaseList);
	HWS_CaseTriggerHelper.reCalculatePlannedDeliveryDate(oldCaseMap,newHWSCaseList);
	// HWS_CaseTriggerHelper.updateRetunDeliveryOnParent(newHWSCaseList);
	HWS_CaseTriggerHelper.calculatingTotalShippedQuantity(oldCaseMap,newHWSCaseList);
	CH_SecurityUtils.setCaseSecurityGroups(newHWSCaseList, oldCaseMap);
			}
		}	  
	}
	
	/*********
	*Method Name: afterUpdateOperation
	*Parameter: Old Case Map, New Case List
	*Description: Used to handle after update operation
	*********/
	Public static void afterUpdateOperation(Map <Id, Case> oldCaseMap, Map <Id, Case> newCaseMap, List <Case> newCaseList) {	
		List<Case> newHWSCaseList = hwsCasesbyRecordTypeCheck(newCaseList);	
		if(newHWSCaseList.size()>0){
			if(HWS_CaseTriggerHelper.updateCheck){
	HWS_CaseTriggerHelper.updateCheck = false;	 
	HWS_CaseTriggerHelper.handleCaseFieldChanges(oldCaseMap, newHWSCaseList);
	HWS_CaseTriggerHelper.updateRetunDeliveryOnParent(newHWSCaseList);			
	HWS_CaseTriggerHelper.completeMilestone(newHWSCaseList);
	//HWS_OrderConfirmationNotification.sendEmailNotification(newHWSCaseList);
	HWS_SPSNotificationPDF.spsChildCasesPDF(newHWSCaseList,oldCaseMap);
	//HWS_ShippedCaseEmailNotification.sendEmailNotification(oldCaseMap, newHWSCaseList);
	CH_AuthorizedContactSharing.handleSharing(new Map<Id, Case>(newHWSCaseList), oldCaseMap, false, true);
	//Order Confirmation mail - Failure Report
	Set<Id> caseIdSet = new Set<Id>();
	for(Case c :newHWSCaseList){
		caseIdSet.add(c.Id);
	}	
	
	if(!System.isFuture() && !System.isBatch()){
		HWS_OrderConfirmationNotification.sendEmailNotificationForPDF(caseIdSet);
	}
			}
		}   
	}
	
	/********************
	*Method Name: hwsCasesbyRecordTypeCheck
	*Parameter: New Case List 
	*Last updated by: Satya (2019.08.29)
	*Description: isolate only the HWS cases (by record type)
	*This is to reduce the size of the list if a bulk amount of Cases are being loaded (that are not HWS specific)   
	*******************/
	private static List <Case> hwsCasesbyRecordTypeCheck(List <Case> caseList) {	
		List <Case> hwsCases = new List <Case> ();
		for (Case caseObj: caseList) {
			//Checks hidden field on Case that is a formula field - boolean that returns true for the HWS Case Record Types
			if (caseObj.HWS_RecordTypeCheck__c) {
	hwsCases.add(caseObj);
			}
		}   
		return hwsCases;
	}
	/********************
	*Method Name: hwsEscaltionCasesRecordTypeCheck
	*Parameter: Case List 
	*Last updated by: TCS (09/11/2019)
	*Description: 
	This is to check for only HWS escalation cases, return the list of cases of type escaltion.	
	*******************/
	public static List <Case> hwsEscaltionCasesRecordTypeCheck(List<Case> caseList) {	
		List <Case> escalationCases = new List <Case> ();
		for (Case caseObj: caseList) {
			String recordTypeName = caseObj.RecordType.DeveloperName;
			//if (caseObj.RecordTypeId == esclationCase) {
			if (recordTypeName == 'HWS_Case_Escalation') {
	escalationCases.add(caseObj);
			}
		}  
		return escalationCases;
	}
}