/****************************************
* Class Name : CH_CaseTriggerHandler
* Created Date: 08 August 2018
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 09 August 2018
* Description : Handle the sequence of the CaseTriggerHelper
* Test Class: CH_CaseTriggerHelperTest
*****************************************/
public class CH_CaseTriggerHandler {
	Public Static Boolean isAuditTrailEnabled= False;//Changes added for NOKIASC-39624
	/********************
	*Method Name: beforeInsertOperation
	*Parameter: New Case List
	*Description: Used to handle before insert operation
	*******************/
	public static void beforeInsertOperation(List<Case> newCaseList) { 
		
		// Added recursive check
		if(CH_AvoidRecursion.runBeforeInsertOnce()) {
			//Added CH Recordtype check as part of Code Optimization -- 27608 --> By Satya Pagadala
			// Filter CH Case Record Type
			newCaseList = isolateCHCasesbyRecordType(newCaseList);
			if(newCaseList.size()>0){
	isAuditTrailEnabled=True;
				// Get non S2S Cases
				List<Case> newCaseNonS2SList = isolateCHCasesNonS2S(newCaseList);
				List<Case> newCaseS2SList = isolateNewS2SCasesToMap(newCaseList);
				CH_Settings__c entExpAsyncCheck = CH_Settings__c.getValues('checkEntitlementExceptionCases');
				CH_Settings__c blackListAsyncCheck = CH_Settings__c.getValues('CH_BlacklistCaseReportTrigger');
				//Moving CH Case Process Builder Logic
				CH_CaseTriggerHelper.populateCaseFields(new Map <Id,Case>(),newCaseList);
				// Validate the new CH type cases to ensure:
				// Authorised user is correct if Asset and entitlements are selected, etc.
				if(newCaseNonS2SList.size()>0)
					CH_CaseTriggerHelper.populateCaseEntitlement(newCaseNonS2SList);
				if(newCaseS2SList.size()>0){
					CH_CaseTriggerHelper.populateS2SCases(newCaseS2SList);  
					CH_CaseTriggerHelper.validateServiceCaseCreation(newCaseS2SList, new Map <Id,Case>());//added newCaseS2SList PArameter as part of NOKIASC-27614
				}
				//Merged below method in populateCaseFields method as part of code optimization --> 27620 -- By Satya
				
				CH_CaseTriggerHelper.setFlagForCaseMilestone(newCaseList, true);
				if(newCaseNonS2SList.size()>0){
					//Merged below method in populateCaseFields method as part of code optimization --> 27620 -- By Satya
					
					CH_CaseTriggerHelper.updateProductDetails(newCaseNonS2SList);
				}
				CH_CaseTriggerHelper.fetchCaseFields(newCaseList, null);
				if(blackListAsyncCheck != null && blackListAsyncCheck.SettingValue__c == 'true')
					CH_CaseTriggerHelper.CH_BlacklistCaseReportTrigger(newCaseList);
				//Merged below method in populateCaseFields method as part of code optimization --> 27620 -- By Satya
				
				CH_CaseTriggerHelper.setEmailTypes(newCaseList);			   
				
				// Set Entitlement Exception field
				if(entExpAsyncCheck != null && entExpAsyncCheck.SettingValue__c == 'true')
					CH_CaseTriggerHelper.checkEntitlementExceptionCases(newCaseList);
				
				CH_CaseTriggerHelper.populateCaleaFlag(newCaseList);//NOKIASC-36342
				CH_SecurityUtils.setCaseSecurityGroups(newCaseList, null);  //Nokiasc-38727
			}
		}
		
	}
	
	/********************
	*Method Name: beforeUpdateOperation
	*Parameter: Old Case Map, New Case List
	*Description: Used to handle before update operation
	*******************/
	public static void beforeUpdateOperation(Map < Id, Case > oldCaseMap, List < Case > newCaseList) {
		
		// Added recursive check
		if(CH_AvoidRecursion.runBeforeUpdateOnce()) {
			//Added CH Recordtype check as part of Code Optimization -- 27608 --> By Satya Pagadala
			// Filter CH Case Record Type
			newCaseList = isolateCHCasesbyRecordType(newCaseList);
			if(newCaseList.size()>0){
				//31311 validate Case LegalEntity in mapping table s2s legal entity
				CH_CaseTriggerHelper.chS2SLegalEntityCheck(oldCaseMap,newCaseList);
				//end 3111
				CH_CaseTriggerHelper.probCreatedCheck(oldCaseMap,newCaseList);
				CH_Settings__c entExpAsyncCheck = CH_Settings__c.getValues('checkEntitlementExceptionCases');
				CH_Settings__c blackListAsyncCheck = CH_Settings__c.getValues('CH_BlacklistCaseReportTrigger');
				//Moving CH Case Process Builder Logic
				CH_CaseTriggerHelper.populateCaseFields(oldCaseMap,newCaseList);
				// US 22292 : Non-Care - Validation rule that Contact must be Nokia Employee
				//Merged below method in populateCaseFields method as part of code optimization --> 27620 -- By Satya
				// Get non S2S Cases
				List<Case> newCaseNonS2SList = isolateCHCasesNonS2S(newCaseList);
				List<Case> newCaseS2SList = isolateNewS2SCasesToMap(newCaseList);
				CH_CaseTriggerHelper.fetchCaseFields(newCaseList, oldCaseMap);
				if(blackListAsyncCheck != null && blackListAsyncCheck.SettingValue__c == 'true')
					CH_CaseTriggerHelper.CH_BlacklistCaseReportTrigger(newCaseList);
				//Merged below method in populateCaseFields method as part of code optimization --> 27620 -- By Satya
				
				if(newCaseNonS2SList.size()>0){
					CH_CaseTriggerHelper.updateProductDetails(newCaseNonS2SList);
					//added by Abdallah
					CH_CaseTriggerHelper.updateCurrentQueue(oldCaseMap,newCaseNonS2SList);
				} else if(newCaseS2SList.size() >0){ //NOKIASC-34554 defect logic to assign Product deials
					CH_CaseTriggerHelper.updateProductDetails(newCaseS2SList);
				}
				// Validate the new CH type cases to ensure: 
				// Authorised user is correct if Asset and entitlements are selected, etc.
				
				//Merged below method in populateCaseFields method as part of code optimization --> 27620 -- By Satya
				
				CH_CaseTriggerHelper.setStatusAfterQueueAssignment(oldCaseMap, newCaseList);
				CH_CaseTriggerHelper.updateProblemParentIncident(oldCaseMap,newCaseList);
				
				CH_CaseTriggerHelper.queueSecurityGroupsCheckOwnerChange(newCaseList, oldCaseMap);
				//Added as PArt of Code-Opt
				if(CH_AvoidRecursion.runBeforeInsertOnce()){
					// Validate the new CH type cases to ensure: 
					// Authorised user is correct if Asset and entitlements are selected, etc.
					CH_CaseTriggerHelper.validateServiceCaseCreation(newCaseList, oldCaseMap);// added as part of NOKIASC-27614 Code-Opt
					CH_CaseTriggerHelper.createS2SCAPSAttachmentsOnCase(oldCaseMap, newCaseList);// added as part of NOKIASC-27612 Code-Opt.
					
				}
				// Update Entitlement Exception Field
				if(entExpAsyncCheck != null && entExpAsyncCheck.SettingValue__c == 'true')
					CH_CaseTriggerHelper.checkEntitlementExceptionCases(oldCaseMap, newCaseList);
				CH_CaseTriggerHelper.completeMilestoneOnCancellation(newCaseList);
				CH_CaseTriggerHelper.setEmailTypes(newCaseList);
				//Merged below method in populateCaseFields method as part of code optimization --> 27620 -- By Satya
				CH_CaseTriggerHelper.handleP20orderDetails(oldCaseMap, newCaseList);
				CH_CaseTriggerHelper.updateMilestoneCompletionDate(oldCaseMap, newCaseList);
				CH_SecurityUtils.setCaseSecurityGroups(newCaseList, oldCaseMap);
				//NOKIASC-34615
				CH_CaseTriggerHelper.checkCancelledCases(newCaseList, oldCaseMap); 
			}
		}
		CH_CaseTriggerHelper.updateFlagForCaseMilestone(oldCaseMap, newCaseList);
	}
	
	/********************
	*Method Name: afterInsertOperation
	*Parameter: New Case List
	*Description: Used to handle after insert operation
	*******************/
	public static void afterInsertOperation(List<Case> newCaseList) {
		// Added recursive check
		if(CH_AvoidRecursion.runAfterInsertOnce()) {
			//Added CH Recordtype check as part of Code Optimization -- 27608 --> By Satya Pagadala
			// Filter CH Case Record Type
			newCaseList = isolateCHCasesbyRecordType(newCaseList);
			if(newCaseList.size()>0){
			
				Set <Id> caseIds = new Set <Id> ();
				for (Case caseObj : newCaseList){
					caseIds.add(caseObj.Id);
				}
	CH_CaseTriggerHelper.AddoRemoveProblemOwnerForCases(null,newCaseList);
	CH_CaseTriggerHelper.addCCMToCaseTeam(newCaseList);
	CH_CaseEmailHandler.notifyAdditionalContacts(newCaseList);
	CH_CompleteMilestoneOnInsert.completeMilestonesOnInsert(caseIds);
	CH_CaseTriggerHelper.createS2SCAPSAttachmentsOnCase(new Map<Id,Case>(), newCaseList);// added as part of NOKIASC-27612 Code-Opt.
	   CH_ExternalInterfaceUTIL.sendCreationToExternalSystem(newCaseList);
			
	// Manage sharing of authorization contacts 
	CH_AuthorizedContactSharing.handleSharing(new Map<Id, Case>(newCaseList), new Map<Id, Case>(), true, false);
	
	CH_CaseTriggerHelper.handleP20orderDetails(null, newCaseList);
	if(!System.isQueueable() && !System.isfuture()){
					System.enqueueJob(new CH_CaseProcessQueueable(caseIds,new Map<Id,Case>(),true,false));
		//29710
					CH_CaseTriggerHelper.getCasesForSubscribers(null, newCaseList);
	}
				//Changes for NOKIASC-31109
			   CH_CaseTriggerHelper.checkCriteriaForNGNAIPMessage(null, newCaseList);
	  CH_CaseTriggerHelper.insertIncidentsDefect(newCaseList);//NOKIASC-38501
			}
		}
		}
	
	/********************
	*Method Name: afterUpdateOperation
	*Parameter: Old Case Map, New Case List
	*Description: Used to handle after update operation
	*******************/
	public static void afterUpdateOperation(Map < Id, Case > oldCaseMap, List < Case > newCaseList) {
		// Added recursive check
		//Added CH Recordtype check as part of Code Optimization -- 27608 --> By Satya Pagadala
		//Moved this New List out of the isolation check	
		newCaseList = isolateCHCasesbyRecordType(newCaseList);
		if(newCaseList.size()>0){
			if(CH_AvoidRecursion.runAfterUpdateOnce()) {
	CH_SecurityUtils.deletMembersOnCasesBasedonSecurityGroups(newCaseList, oldCaseMap);
				Set<Id> caseIds = new Set<Id>();
				List<Case> caseTeamCaseList = new List<Case>(); 
	for (Case caseObj : newCaseList){
					caseIds.add(caseObj.Id);
					// Building filtered Id set to pass to addMembersToCaseTeam function as per NOKIASC-27856 fix
					
					if((caseObj.CH_Workgroup__c != oldCaseMap.get(caseObj.Id).CH_Workgroup__c && caseObj.CH_Workgroup__c != null) || caseObj.RecordTypeId != oldCaseMap.get(caseObj.Id).RecordTypeId){
						caseTeamCaseList.add(caseObj);
					}
				} 
	//Changes added as a Part of NOKIASC-35322
				CH_CaseTriggerHelper.checkDefectSolutionTargetAndPausedDate(oldCaseMap,newCaseList);
	CH_CaseTriggerHelper.AddoRemoveProblemOwnerForCases(oldCaseMap, newCaseList);
	// start Update Known Error
	// end Update Known Error		   
				if(!caseTeamCaseList.isEmpty()){
					CH_CaseTriggerHelper.addMembersToCaseTeamWrapper(caseTeamCaseList);
				}
	// Get S2S Cases
	
	// NOKIASC-15275 start
	// Added !System.isQueueable() check as part of NOKIASC-28441
	if(!System.isFuture() && !System.isQueueable()){
					CH_CompleteIROnInsert.completeIROnInsert(caseIds);
		//29710
					CH_CaseTriggerHelper.getCasesForSubscribers(oldCaseMap, newCaseList);
				}
	 //NOKIASC-15275 end
				//  NOKIASC-28529 Start - Vinod C
				List<Case> newCaseRnDList = isolateCHCasesRnD(newCaseList);
				if(!newCaseRnDList.isEmpty() && newCaseRnDList.size() > 0){
					CH_ExternalInterfaceUTIL.sendSeverityUpdatesToExternalSystem(oldCaseMap, newCaseRnDList);
				}
				//NOKIASC-28529 end
	List<Case> newCaseS2SList = isolateCHCasesS2S(newCaseList);
	if(newCaseS2SList.size()>0){
		CH_ExternalInterfaceUTIL.rejectInvalidS2SCases(newCaseS2SList);
		if(CH_Integration__c.getInstance().EnableIntegration__c) {
			CH_CaseTriggerHelper.handleUpdatesS2SCases(oldCaseMap, newCaseS2SList);
		}	
	}
	
	 // Raji }
			
			
			// Update defect values on incidents (When related problem is updated) NOKIASC-14381
			CH_CaseTriggerHelper.updateIncidentsDefect(oldCaseMap, newCaseList);
			// Post to chatter on problem when it's related/dissociated from an incident
			CH_CaseTriggerHelper.addProblemChatterPost(oldCaseMap, newCaseList);	
			if(CH_AvoidRecursion.runAfterInsertOnce() && !System.isQueueable() && !System.isfuture()) {
	System.enqueueJob(new CH_CaseProcessQueueable(caseIds,oldCaseMap,false,true));
			}
			// Manage sharing of authorization contacts 
			CH_AuthorizedContactSharing.handleSharing(new Map<Id, Case>(newCaseList), oldCaseMap, false, true);
				
			//31109
				CH_CaseTriggerHelper.checkCriteriaForNGNAIPMessage(oldCaseMap, newCaseList);
			CH_CaseTriggerHelper.updateCALEAInCAPS(oldCaseMap, newCaseList);//NOKIASC-37029
			}//Raji 
			//START*********Recursion handled differently in main execution class, so DO NOT change
			CH_CaseTriggerHelper.updateAttchmentinCAPS(oldCaseMap, newCaseList);
			//END***********Recursion handled differently in main execution class, so DO NOT change
			if(userinfo.getName()!='NAIP User' && !Test.isRunningTest()  && !isAuditTrailEnabled){
			 CH_CustomFieldTracking_beta.trackFieldChanges(oldCaseMap,newCaseList); 
			}
			//NOKIASC-31957
			CH_CaseTriggerHelper.checkCompletedCases(newCaseList, oldCaseMap);
		}
		
	}	 
	
	/********************
	*Method Name: isolateCHCasesbyRecordType
	*Parameter: New Case List 
	*Last updated by: TSALEM (2018.08.09)
	*Description: isolate only the Case Handling cases (by record type)
	*	 This is to reduce the size of the list if a bulk amount of Cases are being loaded (that are not CH specific)
	*	 (Performance improvement step)
	*	 User Story: NOKIASC-494
	*******************/
	private static List < Case > isolateCHCasesbyRecordType(List < Case > caseList) {
		List < Case > chCases = new List < Case > ();
		for (Case caseObj: caseList) {
			//Checks hidden field on Case that is a formula field - boolean that returns true for the CH Case Record Types
			if (caseObj.CH_RecordTypeCheck__c) {
	chCases.add(caseObj);
			}
		}
		return chCases;
	}

	/********************
	*Method Name: isolateNewS2SCasesToMap
	*Parameter: New Case List
	*Description: isolates new S2S Cases to then perform mapping and other processing, if profile is not listed in
	* CH_Integration_Profiles__c custom setting - skip mapping
	*******************/
	@testVisible
	private static List<Case> isolateNewS2SCasesToMap(List<Case> caseList) {
	//To fix 101 soql issue, created new field CH_ProfileId__c in custom settings instead of querying Profile Names
		//As of in custom setting we have only two profiles
		//By Satya on 20th Feb 2020
		Boolean isIntegrationProfile = false;   
		List<CH_Integration_Profiles__c> intProfLst = CH_Integration_Profiles__c.getall().values();
		if(intProfLst.size()>0){
			for(CH_Integration_Profiles__c intProf : intProfLst){
	if(UserInfo.getProfileId() == intProf.CH_ProfileId__c){
		isIntegrationProfile = true;
	}
			}
		}
		List<Case> s2sCasesFromExternalInterface = new List<Case> ();

		if (isIntegrationProfile) {
			for (Case caseObj: caseList) {
	//Added CH Recordtype check as part of Code Optimization -- 27608 --> By Satya Pagadala
	if (caseObj.Origin == 'S2S' && caseObj.CH_RecordTypeCheck__c) {
		s2sCasesFromExternalInterface.add(caseObj);
	}
			}
		}
		return s2sCasesFromExternalInterface;
	}

	/********************
	*Method Name: isolateCHCasesS2S
	*Parameter: New Case List 
	*Description: isolates S2S Cases
	*******************/
	private static List<Case> isolateCHCasesS2S(List<Case> caseList) {
		List<Case> chCases = new List<Case> ();
		for (Case caseObj: caseList) {
			//Added CH Recordtype check as part of Code Optimization -- 27608 --> By Satya Pagadala
			if (caseObj.Origin == 'S2S' && caseObj.CH_RecordTypeCheck__c) {
	chCases.add(caseObj);
			}
		}
		return chCases;
	}
	/********************
	*Method Name: isolateCHCasesNonS2S
	*Parameter: New Case List 
	*Description: isolates non-S2S Cases
	*******************/
	private static List<Case> isolateCHCasesNonS2S(List<Case> caseList) {
		Boolean isIntegrationProfile = false;   
		List<CH_Integration_Profiles__c> intProfLst = CH_Integration_Profiles__c.getall().values();
		if(intProfLst.size()>0){
			for(CH_Integration_Profiles__c intProf : intProfLst){
				if(UserInfo.getProfileId() == intProf.CH_ProfileId__c){
					isIntegrationProfile = true;
				}
			}
		}
		List<Case> chCases = new List<Case> ();
		for (Case caseObj: caseList) {
			//Added CH Recordtype check as part of Code Optimization -- 27608 --> By Satya Pagadala
			//if (caseObj.Origin != 'S2S' && caseObj.CH_RecordTypeCheck__c) {
			if (!isIntegrationProfile && caseObj.CH_RecordTypeCheck__c) {
	chCases.add(caseObj);
			}
		}
		return chCases;
	}
	/********************
	*Method Name: isolateCHCasesRnD
	*Parameter: New Case List 
	*Description: isolates R&D Cases. Added this method as part of NOKIASC-28529.
	*******************/
	private static List<Case> isolateCHCasesRnD(List<Case> caseList) {
		List<Case> chCases = new List<Case> ();
		for (Case caseObj: caseList) {
			if (caseObj.CH_RDInterface__c!=Null && (caseObj.CH_RDInterface__c.equalsIgnoreCase('JIRA') || caseObj.CH_RDInterface__c.equalsIgnoreCase('PRONTO')) && caseObj.CH_RecordTypeCheck__c) {
				chCases.add(caseObj);
			}
		}
		return chCases;
	}
}