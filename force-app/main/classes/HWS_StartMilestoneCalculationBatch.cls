/****************************************	
	* Name : HWS_MakeSOOCalloutConsoleBatch
	* Description : Update List<Case> based on status to be updated from SOO response
	* Parameters: Parent CaseNumber list 
	* Being called from HWS_CreateSupportTicketportal
  * Purpose: To avoid Apex CPU time Limit exceed which is causing due t Milstone calculation
  * Created on : 22 Oct 2019
	*****************************************/ 
global class HWS_StartMilestoneCalculationBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful{
	   
	/*List<sObject> childList;	
	global HWS_MakeSOOCalloutConsoleBatch(List<sObject> caseList){		
		this.childList = caseList;
	}
	global List<SObject> start(Database.BatchableContext context) {			  
		return childList;
	}
	global void execute(Database.BatchableContext context, List<SObject> childList) {		
		if(childList.size()>0){
			update childList;
		}
	}
	
	global void finish(Database.BatchableContext context) {
	}*/
	List<String> parentCaseNumberList;
	global HWS_StartMilestoneCalculationBatch(List<String> parentList){  
		this.parentCaseNumberList = parentList;
	}
	global List<SObject> start(Database.BatchableContext context) {
		 List<Case> caselist = [select id, CaseNumber, HWS_StartMilestone__c from Case where ParentId in :parentCaseNumberList];	   
		return caselist;
	}
	global void execute(Database.BatchableContext context, List<Case> caseLst) {		
		if(caseLst.size()>0){
			List<Case> caseListToUpdate = new List<Case>();
			for(Case c :caseLst){				  
			   c.HWS_StartMilestone__c = true;
				caseListToUpdate.add(c);
			}
			
			if(caseListToUpdate.size()>0){
				try{
					update caseListToUpdate;
				}
				catch(DMLException de){
					System.debug('Error while submitting/updating Case: '+de);
				}
			}
		}
	}	
	global void finish(Database.BatchableContext context) {
	}
}