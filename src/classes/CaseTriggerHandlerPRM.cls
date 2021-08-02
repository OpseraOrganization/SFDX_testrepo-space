/****************************************
* Class Name : CaseTriggerHandlerPRM
* Created Date: 17 April 2017
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 19 April 2017
* Description : Handle the sequence of the CaseTriggerHelperPRM
* Test Class: 
*****************************************/
public without sharing class CaseTriggerHandlerPRM {
	 /********************
	*Method Name: afterUpdateOperation
	*Parameter: New Case List, New Case Map, Old Case Map
	*Description: Used to handle after Update activities
	*******************/
	public static void afterUpdateOperation(List<Case> CaseList, Map<ID, Case> caseNewMap, Map<ID, Case> caseOldMap) { 
		try{ 
			List<case> caseListnew = new List<case>();
			Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
			//Auto Approve 
			
			//my code start
			//for(Case c : newCaseList) {
			//	if(rt_map.get(c.RecordTypeId).getName().containsIgnoreCase(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION) || rt_map.get(c.RecordTypeId).getName().containsIgnoreCase(PRMGlobalConstants.VAR_FORM) || rt_map.get(c.RecordTypeId).getName().containsIgnoreCase(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE)
			   //  if(c.RecordType.DeveloperName == 'Indirect Reseller Application' || c.RecordType.DeveloperName == 'VAR Fast-Track Form' || c.RecordType.DeveloperName == 'IR/NIRA Sales to Country') {
			//my code end
			
			for(Case c : CaseList) {
				system.debug('dot id' +c.RecordType.Id);
				system.debug('name' +c.RecordType.Name);
				system.debug('developer name'+c.RecordType.DeveloperName);
					system.debug('recordtypeid'+c.RecordTypeID);
					
			//	if(c.RecordType.DeveloperName == 'Indirect Reseller Application' || c.RecordType.DeveloperName == 'VAR Fast-Track Form' || c.RecordType.DeveloperName == 'IR/NIRA Sales to Country') {
				if( (rt_map.get(c.RecordTypeId).getName().containsIgnoreCase(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION)) || (rt_map.get(c.RecordTypeId).getName().containsIgnoreCase(PRMGlobalConstants.VAR_FORM)) || (rt_map.get(c.RecordTypeId).getName().containsIgnoreCase(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE)))
				   {
					system.debug('CaseTriggerHandlerPRM Test-1');
		CaseTriggerHelperPRM.updateParentCaseStatusHold(CaseList, caseOldMap.values(), caseOldMap);
		CaseTriggerHelperPRM.updateParentCaseStatus(CaseList, caseOldMap.values(), caseOldMap);
		CaseTriggerHelperPRM.updateChildCaseStatus(CaseList, caseOldMap.values(), caseOldMap);
		CaseTriggerHelperPRM.autoApproveFirstStep(CaseList, caseNewMap, caseOldMap);
		CaseTriggerHelperPRM.autoSubmitParentCaseForApproval(CaseList, caseOldMap);
		CaseTriggerHelperPRM.releaseOnHold(CaseList, caseOldMap);
	   }
	  if((((rt_map.get(c.RecordTypeId).getName().containsIgnoreCase(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE)) 
		&& (!c.Is_Headquater__c)) 
		||((rt_map.get(c.RecordTypeId).getName().containsIgnoreCase(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION))
		&& c.Is_Headquater__c))
		&& (c.Status.equals(PRMGlobalConstants.CASE_STATUS_APPROVED_PSM) ||c.Status.equals(PRMGlobalConstants.CASE_STATUS_APPROVED_COMP))){
		caseListnew.add(c);
	}
	if(!caseListnew.IsEmpty()){
		//system.debug('Inside handler'+caseListnew);
		ID jobID = System.enqueueJob(new UnlockCaseRecordPRM(caseListnew));
		
	}
			}
			
		}catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.CaseTriggerHandler,PRMGlobalConstants.afterUpdateOperation);}
	}
	
	/********************
	*Method Name: afterInsertOperation
	*Parameter: case caseInstance
	*Description: Handle After Insert Operations	
	*******************/
	public static void afterInsertOperation(List<case> caseList) { 
		try{
			//Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
			Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
			List<case> caseListnew = new List<case>();
			for(case c : caseList) {
			   if((rt_map.get(c.RecordTypeId).getName().containsIgnoreCase(PRMGlobalConstants.Partner_Sales_Support_Requested)) && (c.Opportunity__c != NULL))
	//if(c.RecordType.DeveloperName == 'Partner Sales Support Requested' && c.Opportunity__c != NULL)
			   {
		caseListnew.add(c);
	}
			}	 
			if(!caseListnew.IsEmpty()){
	CaseTriggerHelperPRM.caseShareToOpptyMember(caseListnew);
			}
		}catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.CaseTriggerHandler,PRMGlobalConstants.afterInsertOperation);}
	}
	
	/********************
	*Method Name: beforeUpdateOperation
	*Parameter: case caseInstance
	*******************/
	public static void beforeUpdateOperation(List<case> caseListNew, Map<Id, Case> oldCaseMap) { 
		try{
			//Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
			Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
			List<Case> getApproveCaseListNew = new List<Case>();
			for(Case c : caseListNew) {
				
				if((rt_map.get(c.RecordTypeId).getName().containsIgnoreCase(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION)) || (rt_map.get(c.RecordTypeId).getName().containsIgnoreCase(PRMGlobalConstants.VAR_FORM)) || (rt_map.get(c.RecordTypeId).getName().containsIgnoreCase(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE)))
				
	//if(c.RecordType.DeveloperName == 'Indirect Reseller Application' || c.RecordType.DeveloperName == 'VAR Fast-Track Form' || c.RecordType.DeveloperName == 'IR/NIRA Sales to Country') 
				
				{
		  getApproveCaseListNew.add(c);
	 }
			}
			if(!getApproveCaseListNew.isEmpty()){
	CaseTriggerHelperPRM.getApproveAndRejectedCoun(getApproveCaseListNew, oldCaseMap);
			}
	}catch(System.Exception e){
		ExceptionHandler.addException(e,PRMGlobalConstants.CaseTriggerHandler,PRMGlobalConstants.BEFORE_UPDATE_OPERATION);}
	}
}