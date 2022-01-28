/****************************************
* Class Name : CaseTriggerHandler
* Created Date: 17 April 2017
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 19 April 2017
* Description : Handle the sequence of the CaseTriggerHelper
* Last Modified by: TCS
* Last Modified Date: 27 June 2018
* Description : Calling CAPS API
* Last Modified by: TCS
* Last Modified Date: 23 July 2018
* Description : Delete Attachments in CAPS when case in cancelled
* Last Modified: 19-Aug-2018 - TCS - Commenting "updateAttchmentinCAPS" here and moving the method to separate class, 
   keeping the method   commented for sometime
* Test Class:  
*****************************************/
public without sharing class CaseTriggerHandler {
	
	public static Id ncpCaseRTId = null;
	
	// added by SF for NCP project
	public static void beforeUpdateOperation(List<Case> CaseList, Map<ID, Case> caseNewMap, Map<ID, Case> caseOldMap) { 
	try{ 
			//Auto Approve 
			if (NCP_RecursiveCheck.runBeforeUpdateOnce()) {
	List<case> caseListnew = new List<case>();
	List<case> caseEntitlemntList = new List<case>();
	if (ncpCaseRTId == null) {
		system.debug('beforeUpdateOperation - ncpCaseRTId == null?');	   
		ncpCaseRTId = NCP_Utils.getObjectRecordTypeId('Case',NCP_Constants.CASE_RT_DEVNAME_ENTITLEMENT);
	}
	system.debug('beforeUpdateOperation - ncpCaseRTId: ' + ncpCaseRTId);
	for(case caseInstance : CaseList){
	 if(ncpCaseRTId != null && caseInstance.recordTypeId ==  ncpCaseRTId){		  
		 if(caseNewMap.get(caseInstance.Id).Status == NCP_Constants.STATUS_APPROVED){ 
			caseEntitlemntList.add(caseInstance);
		 }
	 }else{
		 caseListnew.add(caseInstance);
	 }
	}
	if(!caseEntitlemntList.IsEmpty()){ 
		CaseTriggerHelper.manageEntitlements(caseEntitlemntList);
	}
			}
	}
	catch(System.Exception e){
		ExceptionHandler.addException(e,PRMGlobalConstants.CaseTriggerHandler,PRMGlobalConstants.afterUpdateOperation);
		}
	}
	
	/********************
	*Method Name: afterInsertOperation
	*Parameter: case caseInstance
	*Description: case share to oppty member
	  
	*******************/
	// updated by SF for NCP project
	public static void afterInsertOperation(List<case> caseList) {
	
		//added debug log on 26-06-2019
		//system.debug('CH_CA: In afterInsertOperation securityGroup'+caseList[0].CH_SecurityGroup__c + ' GWC '+caseList[0].CH_GWC_SecurityGroup__c); ERROR WITH EMPTY LIST
		
		List<case> caseListnew = new List<case>();
		List<case> caseEntitlemntList = new List<case>();
		List<Case> caseApproveTicket = new List<Case>();
		//List<case> caseNOLSList = new List<case>();				
		
		try{
			if (NCP_RecursiveCheck.runAfterInsertOnce()) {
				//Req 2552 Partner Access to only their Sales Support Request Cases

				if (ncpCaseRTId == null) {
					system.debug('afterInsertOperation - ncpCaseRTId == null?');
					ncpCaseRTId = NCP_Utils.getObjectRecordTypeId('Case', NCP_Constants.CASE_RT_DEVNAME_ENTITLEMENT);
				}
				system.debug('afterInsertOperation - ncpCaseRTId: ' + ncpCaseRTId);
				for(case caseInstance : caseList){
					if(caseInstance.Opportunity__c != NULL){ 
						caseListnew.add(caseInstance);
					}
					if(ncpCaseRTId != null && caseInstance.recordTypeId ==  ncpCaseRTId){ 
						caseEntitlemntList.add(caseInstance);
						caseApproveTicket.add(caseInstance);
					}					
				}
				if(!caseApproveTicket.IsEmpty()){
					system.debug('casetriggerhandler value1');
					NCP_CaseTriggerHelper.approveSupportTicket(caseApproveTicket);
					
				}				   
				if(!caseEntitlemntList.IsEmpty()){ 
					CaseTriggerHelper.addCaseTeamMembers(caseEntitlemntList);	
				}

			}
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CaseTriggerHandler,PRMGlobalConstants.afterInsertOperation);}
	}
	
	/********************
	*Method Name: afterUpdateOperation
	*Parameter: New Case List, New Case Map, Old Case Map
	*Description: Used to handle after Update activities
	1. If nobody picks IR Form then, Auto Approve Step 1(Approval By PSM) of approval process
	*******************/
	public static void afterUpdateOperation(List<Case> CaseList, Map<ID, Case> caseNewMap, Map<ID, Case> caseOldMap) { 
		try{ //Auto Approve 
			if (NCP_RecursiveCheck.runAfterUpdateOnce()) {
				// added by SF for NCP project
				List<case> caseEntitlemntList = new List<case>();
				if(ncpCaseRTId == null) {
					ncpCaseRTId = NCP_Utils.getObjectRecordTypeId('Case', NCP_Constants.CASE_RT_DEVNAME_ENTITLEMENT);
				}
				for(case caseInstance : CaseList){
					if(ncpCaseRTId != null && caseInstance.recordTypeId ==  ncpCaseRTId){
						if(caseNewMap.get(caseInstance.Id).NCP_NAM_Entitlement_Requested__c != caseOldMap.get(caseInstance.Id).NCP_NAM_Entitlement_Requested__c && caseNewMap.get(caseInstance.Id).NCP_NAM_Entitlement_Requested__c == NCP_Constants.SUCCESS_VALUE){ 
							caseEntitlemntList.add(caseInstance);
						}
					}
				}
				if(!caseEntitlemntList.IsEmpty()){ 
					NCP_CaseTriggerHelper.sendEmailToKeyUser(caseEntitlemntList);	
				}
				//Added by Rajeshwari as of US - NOKIASC-21735
				CH_CaseTriggerUtilityHelper.getOwnerBasedCase(CaseList, caseOldMap);
				CH_CaseTriggerUtilityHelper.updateCaseHistory(CaseList, caseOldMap);			
			}   
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CaseTriggerHandler,PRMGlobalConstants.afterUpdateOperation);}
	}   
}