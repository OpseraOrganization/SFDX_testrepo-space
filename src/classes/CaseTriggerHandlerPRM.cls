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
	  Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
	  List<case> caseListnew = new List<case>();
	  List<case> caseListNIRA = new List<case>();
	  Map<ID, Case> caseNewMapNIRA = new Map<ID, Case>();
	  Map<ID, Case> caseOldMapNIRA = new Map<ID, Case>();
	  //Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
	  //Auto Approve 
	  system.debug('CaseList --> ' + CaseList);
	  for(Case c : CaseList) {
		system.debug('c.RecordType.DeveloperName --> ' + c.RecordType.DeveloperName);
		if( (rt_map.get(c.RecordTypeId).getDeveloperName().containsIgnoreCase(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION)) || (rt_map.get(c.RecordTypeId).getDeveloperName().containsIgnoreCase(PRMGlobalConstants.VAR_FORM)) || (rt_map.get(c.RecordTypeId).getDeveloperName().containsIgnoreCase(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE))){
		  caseListNIRA.add(c);
			system.debug('c.RecordType.DeveloperName --> ' + rt_map.get(c.RecordTypeId).getDeveloperName());
		  caseNewMapNIRA.put(c.Id,caseNewMap.get(c.Id));
		  caseOldMapNIRA.put(c.Id,caseOldMap.get(c.Id));
		}
	 if((((rt_map.get(c.RecordTypeId).getDeveloperName().containsIgnoreCase(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE)) 
	&& (!c.Is_Headquater__c)) 
	||((rt_map.get(c.RecordTypeId).getDeveloperName().containsIgnoreCase(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION))
	&& c.Is_Headquater__c))
	&& (c.Status.equals(PRMGlobalConstants.CASE_STATUS_APPROVED_PSM) ||c.Status.equals(PRMGlobalConstants.CASE_STATUS_APPROVED_COMP))){
	  caseListnew.add(c);
	}
	  }
		
		if(!caseListNIRA.IsEmpty()){
		  CaseTriggerHelperPRM.updateParentCaseStatusHold(caseListNIRA, caseOldMapNIRA.values(), caseOldMapNIRA);
		  CaseTriggerHelperPRM.updateParentCaseStatus(caseListNIRA, caseOldMapNIRA.values(), caseOldMapNIRA);
		  CaseTriggerHelperPRM.updateChildCaseStatus(caseListNIRA, caseOldMapNIRA.values(), caseOldMapNIRA);
		  CaseTriggerHelperPRM.autoApproveFirstStep(caseListNIRA, caseNewMapNIRA, caseOldMapNIRA);
		  CaseTriggerHelperPRM.autoSubmitParentCaseForApproval(caseListNIRA, caseOldMapNIRA);
		  CaseTriggerHelperPRM.releaseOnHold(caseListNIRA, caseOldMapNIRA);
		}
		
  if(!caseListnew.IsEmpty()){
	//system.debug('Inside handler'+caseListnew);
	ID jobID = System.enqueueJob(new UnlockCaseRecordPRM(caseListnew));
	
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
	  List<case> caseListnew = new List<case>();
	  for(case c : caseList) {
  if(c.RecordType.DeveloperName == 'Partner Sales Support Requested'
	 && c.Opportunity__c != NULL){
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
	  List<Case> getApproveCaseListNew = new List<Case>();
	  String recTypeName = '';
	  for(Case c : caseListNew) {
		system.debug('c.RecordType.DeveloperName --> ' + c.RecordType.DeveloperName);
		recTypeName = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(c.RecordTypeId).getName();
		if(recTypeName == 'Indirect Reseller Application'
		   || recTypeName == 'VAR Fast-Track Form'
		   || recTypeName == 'IR/NIRA Sales to Country') {
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