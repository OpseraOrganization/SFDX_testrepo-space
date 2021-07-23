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
	/********************
	*Method Name: beforeInsertOperation
	*Parameter: New Case List
	*Description: Used to handle before insert operation
	*******************/
	public static void beforeInsertOperation(List<Case> newCaseList) { 
		System.debug('### Before Insert ###  CaseTrigger ### START ### ' + Limits.getQueries()); 
		// Added recursive check
		if(CH_AvoidRecursion.runBeforeInsertOnce()) {
			//Added CH Recordtype check as part of Code Optimization -- 27608 --> By Satya Pagadala
			// Filter CH Case Record Type
			newCaseList = isolateCHCasesbyRecordType(newCaseList);
			if(newCaseList.size()>0){	
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
	//CH_CaseTriggerHelper.validateCaseCreation(newCaseList);
	CH_CaseTriggerHelper.setFlagForCaseMilestone(newCaseList, true);
	if(newCaseNonS2SList.size()>0){
		//Merged below method in populateCaseFields method as part of code optimization --> 27620 -- By Satya
		//CH_CaseTriggerHelper.validAsset(newCaseNonS2SList);
		CH_CaseTriggerHelper.updateProductDetails(newCaseNonS2SList);
	}
	CH_CaseTriggerHelper.fetchCaseFields(newCaseList, null);
	if(blackListAsyncCheck != null && blackListAsyncCheck.SettingValue__c == 'true')
		CH_CaseTriggerHelper.CH_BlacklistCaseReportTrigger(newCaseList);
	//Merged below method in populateCaseFields method as part of code optimization --> 27620 -- By Satya
	//CH_CaseTriggerHelper.populateBusinessHourIds(newCaseList);
	//CH_CaseTriggerHelper.updateProblemParentIncident(newCaseList);
	CH_CaseTriggerHelper.setEmailTypes(newCaseList);
	
	// Set Entitlement Exception field
	if(entExpAsyncCheck != null && entExpAsyncCheck.SettingValue__c == 'true')
		CH_CaseTriggerHelper.checkEntitlementExceptionCases(newCaseList);
	CH_SecurityUtils.setCaseSecurityGroups(newCaseList, null);	
			}
		}
		System.debug('### Before Insert ###  CaseTrigger ### END ### ' + Limits.getQueries()); 
	}
	
	/********************
	*Method Name: beforeUpdateOperation
	*Parameter: Old Case Map, New Case List
	*Description: Used to handle before update operation
	*******************/
	public static void beforeUpdateOperation(Map < Id, Case > oldCaseMap, List < Case > newCaseList) {
		System.debug('### Before Update ###  CaseTrigger ### START ### ' + Limits.getQueries());
		// Added recursive check
		if(CH_AvoidRecursion.runBeforeUpdateOnce()) {
			//Added CH Recordtype check as part of Code Optimization -- 27608 --> By Satya Pagadala
			// Filter CH Case Record Type
			newCaseList = isolateCHCasesbyRecordType(newCaseList);
			if(newCaseList.size()>0){
	CH_Settings__c entExpAsyncCheck = CH_Settings__c.getValues('checkEntitlementExceptionCases');
	CH_Settings__c blackListAsyncCheck = CH_Settings__c.getValues('CH_BlacklistCaseReportTrigger');
			//Moving CH Case Process Builder Logic
				CH_CaseTriggerHelper.populateCaseFields(oldCaseMap,newCaseList);
	// US 22292 : Non-Care - Validation rule that Contact must be Nokia Employee
	//Merged below method in populateCaseFields method as part of code optimization --> 27620 -- By Satya
	//CH_CaseTriggerHelper.validateContactMustBeNokiaEmployee(newCaseList, oldCaseMap);
	//
	// Get non S2S Cases
	List<Case> newCaseNonS2SList = isolateCHCasesNonS2S(newCaseList);
	CH_CaseTriggerHelper.fetchCaseFields(newCaseList, oldCaseMap);
	if(blackListAsyncCheck != null && blackListAsyncCheck.SettingValue__c == 'true')
		CH_CaseTriggerHelper.CH_BlacklistCaseReportTrigger(newCaseList);
	//Merged below method in populateCaseFields method as part of code optimization --> 27620 -- By Satya
	//CH_CaseTriggerHelper.productAssetValidation(oldCaseMap, newCaseList);
	if(newCaseNonS2SList.size()>0){
		CH_CaseTriggerHelper.updateProductDetails(newCaseNonS2SList);
		//added by Abdallah
		CH_CaseTriggerHelper.updateCurrentQueue(oldCaseMap,newCaseNonS2SList);
	}
	// Validate the new CH type cases to ensure: 
	// Authorised user is correct if Asset and entitlements are selected, etc.
	//CH_CaseTriggerHelper.validateServiceCaseCreation(newCaseList, oldCaseMap); Commented as Part of NOKIASC-27614
	//Merged below method in populateCaseFields method as part of code optimization --> 27620 -- By Satya
	//CH_CaseTriggerHelper.updateBusinessHourIds(oldCaseMap, newCaseList);
	CH_CaseTriggerHelper.setStatusAfterQueueAssignment(oldCaseMap, newCaseList);
	CH_CaseTriggerHelper.updateProblemParentIncident(oldCaseMap,newCaseList);
	//CH_CaseTriggerHelper.replaceImgWithMessage(newCaseList);
	//CH_CaseTriggerHelper.queueSecurityGroupsCheck(newCaseList, oldCaseMap); This line is commented as part of the CPU time imp. replaced by the one on the following line
	CH_CaseTriggerHelper.queueSecurityGroupsCheckOwnerChange(newCaseList, oldCaseMap);
	//CH_CaseTriggerHelper.checkViolatedMilestone(newCaseList);
	//CH_CaseTriggerHelper.sendUpdatesToExternalInterface(oldCaseMap, newCaseS2SList);
	//CH_CaseTriggerHelper.createS2SCAPSAttachmentsOnUpdate(oldCaseMap, newCaseList);//filtering S2S in helper - Added on 22nd March, 2019. Commented as part of NOKIASC-27612
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
	//CH_CaseTriggerHelper.verifyCountryChangeOnCase(oldCaseMap, newCaseList);
	CH_CaseTriggerHelper.handleP20orderDetails(oldCaseMap, newCaseList);
	
	CH_CaseTriggerHelper.updateFlagForCaseMilestone(oldCaseMap, newCaseList);
	CH_CaseTriggerHelper.updateMilestoneCompletionDate(oldCaseMap, newCaseList);
	
	//CH_CaseTriggerHelper2.setSecurityGroups(oldCaseMap, newCaseList);
	CH_SecurityUtils.setCaseSecurityGroups(newCaseList, oldCaseMap);
			}
		}
		
		System.debug('### Before Update ###  CaseTrigger ### END ### ' + Limits.getQueries());	
	}
	
	/********************
	*Method Name: afterInsertOperation
	*Parameter: New Case List
	*Description: Used to handle after insert operation
	*******************/
	public static void afterInsertOperation(List<Case> newCaseList) {
		System.debug('### After Insert ###  CaseTrigger ### START ### ' + Limits.getQueries());
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
	//CH_CaseTriggerUtilityHelper.createProductChatterGroup(newCaseList);			
	CH_CaseTriggerHelper.AddoRemoveProblemOwnerForCases(null,newCaseList);
	CH_CaseTriggerHelper.addCCMToCaseTeam(newCaseList);
	CH_CaseEmailHandler.notifyAdditionalContacts(newCaseList);
	CH_CompleteMilestoneOnInsert.completeMilestonesOnInsert(caseIds);
	  // CH_CaseTriggerHelper.notifyAdditionalContacts(newCaseList);
	//CH_CaseTriggerHelper.createS2SCAPSAttachmentsOnInsert(newCaseList);//filtering S2S in helper - Added on 22nd March, 2019.Commented as part of NOKIASC-27612. 
	CH_CaseTriggerHelper.createS2SCAPSAttachmentsOnCase(new Map<Id,Case>(), newCaseList);// added as part of NOKIASC-27612 Code-Opt.
			
			
	// Manage sharing of authorization contacts 
	CH_AuthorizedContactSharing.handleSharing(new Map<Id, Case>(newCaseList), new Map<Id, Case>(), true, false);
	
	CH_CaseTriggerHelper.handleP20orderDetails(null, newCaseList);
	if(!System.isQueueable() && !System.isfuture()) //Sri
					Id jobId = System.enqueueJob(new CH_CaseProcessQueueable(caseIds,new Map<Id,Case>(),true,false));
			}
		}
		System.debug('### After Insert ###  CaseTrigger ### END ### ' + Limits.getQueries());  
	}
	
	/********************
	*Method Name: afterUpdateOperation
	*Parameter: Old Case Map, New Case List
	*Description: Used to handle after update operation
	*******************/
	public static void afterUpdateOperation(Map < Id, Case > oldCaseMap, List < Case > newCaseList) {
		System.debug('### After Update ###  CaseTrigger ### START ### ' + Limits.getQueries());
		// Added recursive check
		//Added CH Recordtype check as part of Code Optimization -- 27608 --> By Satya Pagadala
		//Moved this New List out of the isolation check	
		newCaseList = isolateCHCasesbyRecordType(newCaseList);
		if(newCaseList.size()>0){
			if(CH_AvoidRecursion.runAfterUpdateOnce()) {		
				Set<Id> caseIds = new Set<Id>();
				List<Case> caseTeamCaseList = new List<Case>();	
	for (Case caseObj : newCaseList){
					caseIds.add(caseObj.Id);
					// Building filtered Id set to pass to addMembersToCaseTeam function as per NOKIASC-27856 fix
					
					if((caseObj.CH_Workgroup__c != oldCaseMap.get(caseObj.Id).CH_Workgroup__c && caseObj.CH_Workgroup__c != null) || caseObj.RecordTypeId != oldCaseMap.get(caseObj.Id).RecordTypeId){
						caseTeamCaseList.add(caseObj);
					}
				} 
	//CH_CaseTriggerUtilityHelper.createProductChatterGroupOnUpdate( newCaseList,oldCaseMap);
	CH_CaseTriggerHelper.AddoRemoveProblemOwnerForCases(oldCaseMap, newCaseList);
	// start Update Known Error
	//CH_CaseTriggerHelper.setKnownErrorArticleUpdates(newCaseList, oldCaseMap);
	// end Update Known Error			
				if(!caseTeamCaseList.isEmpty()){
					CH_CaseTriggerHelper.addMembersToCaseTeamWrapper(caseTeamCaseList);
				}
	// CH_CaseTriggerHelper.updateBusinessHourIds(oldCaseMap,newCaseList); // Not Required
	// Get S2S Cases
	
	// NOKIASC-15275 start
	// Added !System.isQueueable() check as part of NOKIASC-28441
	if(!System.isFuture() && !System.isQueueable()){
					CH_CompleteIROnInsert.completeIROnInsert(caseIds);
				}
	 //NOKIASC-15275 end 
		
	//  CH_CaseTriggerHelper.notifyAdditionalContacts(newCaseList);
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
	//CH_CustomFieldTracking.handleCaseFieldChanges(oldCaseMap, new Map<Id, Case>(newCaseList));
	
	 // Raji }
			
			
			// Update defect values on incidents (When related problem is updated) NOKIASC-14381
			CH_CaseTriggerHelper.updateIncidentsDefect(oldCaseMap, newCaseList);
			// Post to chatter on problem when it's related/dissociated from an incident
			CH_CaseTriggerHelper.addProblemChatterPost(oldCaseMap, newCaseList);	
			if(CH_AvoidRecursion.runAfterInsertOnce()) {
	if(!System.isQueueable() && !System.isfuture())
					Id jobId = System.enqueueJob(new CH_CaseProcessQueueable(caseIds,oldCaseMap,false,true));
			}
			// Manage sharing of authorization contacts 
			CH_AuthorizedContactSharing.handleSharing(new Map<Id, Case>(newCaseList), oldCaseMap, false, true);
			
			//CH_CustomFieldTracking.handleCaseFieldChanges(oldCaseMap, new Map<Id, Case>(newCaseList));			
			}//Raji 
			//START*********Recursion handled differently in main execution class, so DO NOT change
			CH_CaseTriggerHelper.updateAttchmentinCAPS(oldCaseMap, newCaseList);
			//END***********Recursion handled differently in main execution class, so DO NOT change
	 System.debug('username***'+userinfo.getName());
	 if(userinfo.getName()!='NAIP User'){
			CH_CustomFieldTracking_beta.trackFieldChanges(oldCaseMap,newCaseList);	
		 }			
		}
		System.debug('### After Update ###  CaseTrigger ### END ### ' + Limits.getQueries()); 
	}	
	
	/********************
	*Method Name: isolateCHCasesbyRecordType
	*Parameter: New Case List 
	*Last updated by: TSALEM (2018.08.09)
	*Description: isolate only the Case Handling cases (by record type)
	*	  This is to reduce the size of the list if a bulk amount of Cases are being loaded (that are not CH specific)
	*	  (Performance improvement step)
	*	  User Story: NOKIASC-494
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
		//String userPrifileName = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name;
		//Boolean isIntegrationProfile = CH_Integration_Profiles__c.getValues(userPrifileName) != null;
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
		List<Case> chCases = new List<Case> ();
		for (Case caseObj: caseList) {
			//Added CH Recordtype check as part of Code Optimization -- 27608 --> By Satya Pagadala
			if (caseObj.Origin != 'S2S' && caseObj.CH_RecordTypeCheck__c) {
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