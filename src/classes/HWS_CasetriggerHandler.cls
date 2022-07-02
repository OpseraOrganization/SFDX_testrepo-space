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

Public without sharing class HWS_CasetriggerHandler {
	
	public static Boolean isNewCase = false;
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
	
	Public static void beforeInsertOperation(Map <Id, Case> oldCaseMap, List <Case> newCaseList) {  
		List<Case> newEscCaseList = hwsEscaltionCasesRecordTypeCheck(newCaseList);
		if(newEscCaseList.size()>0){
			HWS_CaseTriggerHelper.sendCaPMEmailAccOwner(null,newEscCaseList);
		}
		List<Case> newHWSCaseList = hwsCasesbyRecordTypeCheck(newCaseList);
		// Added on - 30-July-2021 | NOKIASC-37537 | Start
		List<Case> parentCaseList = new List<Case>();		
		for (Case caseObj: newHWSCaseList) {			
			if (caseObj.parentId == null) {	
				parentCaseList.add(caseObj);
			}
		}   
		// Added on - 30-July-2021 | NOKIASC-37537 | End
		if(newHWSCaseList.size()>0){
			HWS_CaseTriggerHelper.duplicateSerialNumberCheck(null, newHWSCaseList);	 
			HWS_CaseTriggerHelper.RMANumberPopulate(null,newHWSCaseList);
			HWS_CaseTriggerHelper.totalNetValueCalculateOnChild(newHWSCaseList);
			if(parentCaseList.size()>0){
				CH_SecurityUtils.setCaseSecurityGroups(parentCaseList, null); // Updated on - 30-July-2021 | NOKIASC-37537 
			}
			if(!HWS_CasetriggerHandler.isNewCase){//37186 Fix for cloned cases to set proper EntitlementException and Entitlementstatus values
				HWS_Utilty.updateEntitlementDefaults(newHWSCaseList);
			}
			
		}
	} 
	
	
	/*********
*Method Name: afterInsertOperation
*Parameter: New Case List
*Description: Used to handle after Insert operation
**********/
	Public static void afterInsertOperation(Map < Id, Case > oldCaseMap, List < Case > newCaseList) {   
		
		List<Case> newHWSCaseList = hwsCasesbyRecordTypeCheck(newCaseList);
		if(newHWSCaseList.size()>0){
			CH_AuthorizedContactSharing.handleSharing(new Map<Id, Case>(newHWSCaseList), new Map<Id, Case>(), true, false);
		}
	}
	//NOKIASC-32637
	Public static void afterInsertCase(List < Case > newCaseList) {  
		List<Case> newHWSCaseList = hwsCasesbyRecordTypeCheck(newCaseList);
		if(newHWSCaseList.size()>0){
			// NOKIASC-34641,34642,34643- passive Assignment HWS Parent Case
			HWS_CaseTriggerHelper.passiveAssignmentHWSParentCase(null, newHWSCaseList);
			HWS_CaseTriggerHelper.totalNetValueCalculateOnParent(newHWSCaseList);
			Set<Id> caseIdPRISet = new Set<Id>();
			for(Case c :newHWSCaseList){
				if(c.ParentId == null && (c.CH_InternalStatus__c == 'Warranty Verification Required')){
					caseIdPRISet.add(c.Id);
				}
			}
			if(!System.isFuture() && !System.isBatch()){
				HWS_EmailNotifications.pendingReferralInstructionsEmail(caseIdPRISet,'');
			}
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
				//NOKIASC-38090:bypass trigger logic for bulk warranty check|Start 
				if(!HWS_CaseTriggerHelper.byPassTriggerForBulkWarranty){
					HWS_CaseTriggerHelper.relatedSupportTicketNumCheck(oldCaseMap, newHWSCaseList);
				}
				HWS_CaseTriggerHelper.validationsOnCase(newHWSCaseList);
				//NOKIASC-38090:bypass trigger logic for bulk warranty check|Start 
				if(!HWS_CaseTriggerHelper.byPassTriggerForBulkWarranty){
					HWS_CaseTriggerHelper.duplicateSerialNumberCheck(oldCaseMap, newHWSCaseList);  
				}
				HWS_CaseTriggerHelper.validationsOnCaseForDate(newHWSCaseList);
				//NOKIASC-38090:bypass trigger logic for bulk warranty check|Start 
				if(!HWS_CaseTriggerHelper.byPassTriggerForBulkWarranty){
					HWS_CaseTriggerHelper.entitlementNamePopulate(newHWSCaseList);
				}
				HWS_CaseTriggerHelper.reCalculatePlannedDeliveryDate(oldCaseMap,newHWSCaseList);
				HWS_CaseTriggerHelper.totalNetValueCalculateOnChild(newHWSCaseList);
				HWS_CaseTriggerHelper.calculatingTotalShippedQuantity(oldCaseMap,newHWSCaseList);
				//NOKIASC-34963
				HWS_CaseTriggerHelper.updateFaultySerialNumberReceived(oldCaseMap,newHWSCaseList);
				// Added on - 30-July-2021 | NOKIASC-37537 | Start
				List<Case> parentCaseList = new List<Case>();	   
				for (Case caseObj: newHWSCaseList) {			
					if (caseObj.parentId == null) { 
						parentCaseList.add(caseObj);
					}
				}
				if(parentCaseList.size() >0 ){
					CH_SecurityUtils.setCaseSecurityGroups(parentCaseList, oldCaseMap);
				}
				// Added on - 30-July-2021 | NOKIASC-37537 | End
				//NOKIASC-32495 :HWS cases user owners must belong to a public group that its name matches the security group field on the case level
				CH_CaseTriggerHelper.queueSecurityGroupsCheckOwnerChange(newCaseList, oldCaseMap);
				//NOKIASC-32139 :When Parent Case is Closed or Canceled then change the Support Ticket Owner to the user with the name “Archived Case No Owner” 
				HWS_CaseTriggerHelper.updateOwnerForClosedAndCancelledCases(newCaseList, oldCaseMap);
				//NOKIASC-38090:bypass trigger logic for bulk warranty check|Start 
				if(!HWS_CaseTriggerHelper.byPassTriggerForBulkWarranty){
					HWS_Utilty.updateEntitlementExceptionDefaults(oldCaseMap,newHWSCaseList);
					
					//To update EntitlementStatus,Exception Default values when Warranty Status changes
					HWS_CaseTriggerHelper.setDefaultValuesToEntitlement(oldCaseMap,newHWSCaseList);
				}
				//NOKIASC-38090:bypass trigger logic for bulk warranty check|End
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
		if(newHWSCaseList.size()>0 && HWS_CaseTriggerHelper.updateCheck){
			
			HWS_CaseTriggerHelper.updateCheck = false;  
			//NOKIASC-38090:refactoring trigger|Start
			List<Case> parentCaseList = new List<Case>();	   
			Set<Id> caseIdSet = new Set<Id>();
			Set<Id> caseSet = new Set<Id>(); 
			Set<Id> caseIdPRISet = new Set<Id>();
			List<Case> referralInstructionCaseList = new List<Case>();
			String intStatus;
			for(Case c :newHWSCaseList){
				caseIdSet.add(c.Id);
				if (c.parentId == null) { 
					parentCaseList.add(c);
				}
				if(trigger.isUpdate){					   
					if(c.Parentid != null &&  c.HWS_RequestHWRCAFMA__c && c.HWS_Address_Name__c != null 
					   && c.status != 'Draft' && (oldCaseMap.get(c.id).HWS_RequestHWRCAFMA__c==false || oldCaseMap.get(c.id).HWS_Address_Name__c!= c.HWS_Address_Name__c))//37600
					{
						caseSet.add(c.Id);
					}
					System.debug('caseSet'+caseSet);
					if(c.ParentId == null &&(c.CH_InternalStatus__c == 'Pending Referral Instruction'  && (oldCaseMap.get(c.Id).CH_InternalStatus__c != 'Pending Referral Instruction' || oldCaseMap.get(c.Id).CH_InternalStatus__c == 'Waiting for Referral Instruction'))){
						caseIdPRISet.add(c.Id);
						intStatus = oldCaseMap.get(c.Id).CH_InternalStatus__c;
					}
					//Added for NOKIASC-31233
					if(c.Origin != 'Web' && c.HWS_SOO_Reference_Number__c != null && oldCaseMap.get(c.Id).CH_InternalStatus__c != c.CH_InternalStatus__c && c.CH_InternalStatus__c != 'Warranty Verification Required'){
						referralInstructionCaseList.add(c);
					}
				}
			}
			//NOKIASC-38090:refactoring trigger|End
			if(parentCaseList.size()>0){
				// NOKIASC-34641,34642,34643- passive Assignment HWS Parent Case
				HWS_CaseTriggerHelper.passiveAssignmentHWSParentCase(oldCaseMap, parentCaseList); 
			}
			
			HWS_CaseTriggerHelper.updateRetunDeliveryOnParent(newHWSCaseList);		
			HWS_CaseTriggerHelper.completeMilestone(newHWSCaseList);			
			HWS_SPSNotificationPDF.spsChildCasesPDF(newHWSCaseList,oldCaseMap);
			
			
			List<CH_EmailAlert__c> lstEmailAlert = new List<CH_EmailAlert__c>();
			if(referralInstructionCaseList.size()>0){
				HWS_CaseTriggerHelper.referralInstructionNotification(referralInstructionCaseList);
			}
			//32465
			//HWS_CaseTriggerHelper.updateParentInternalStatusCheck(oldCaseMap, newHWSCaseList);
			if (caseSet.size() > 0 ) {//Added for NOKIASC-37600 
				HWS_EmailNotifications.RequestHWFMARCA(caseSet);	
			}
			
			if(!System.isFuture() && !System.isBatch() && !System.isQueueable()){
				HWS_CaseTriggerHelper.changeParentCaseStatus(newHWSCaseList);
				HWS_CaseTriggerHelper.totalNetValueCalculateOnParent(newHWSCaseList);
				//NOKIASC-38090:bypass trigger logic for bulk warranty check|Start
				if(!HWS_CaseTriggerHelper.byPassTriggerForBulkWarranty){
					HWS_CaseTriggerHelper.updateChildCaseEntitlementStatus(newHWSCaseList,oldCaseMap);
				}
				//NOKIASC-38090:bypass trigger logic for bulk warranty check|End
				//HWS_OrderConfirmationNotification.sendEmailNotificationForPDF(caseIdSet);
				HWS_EmailNotifications.pendingReferralInstructionsEmail(caseIdPRISet,intStatus);
				CH_AuthorizedContactSharing.handleSharing(new Map<Id, Case>(newHWSCaseList), oldCaseMap, false, true);
			}
			HWS_CaseTriggerHelper.handleCaseFieldChanges(oldCaseMap, newHWSCaseList);
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
			if (recordTypeName == 'HWS_Case_Escalation') {
				escalationCases.add(caseObj);
			}
		}  
		return escalationCases;
	}
}