/****************************************	
	* Name : HWS_MakeSOOCalloutBulkRMABatch
	* Description : Update List<Case> based on status to be updated from SOO response
	* Parameters: Parent CaseNumber list 
	* Being called from HWS_CreateSupportTicketportal
	* Purpose: To avoid Apex CPU time Limit exceed which is causing due t Milstone calculation
	* Created on : 22 Oct 2019
	*****************************************/ 
global class HWS_MakeSOOCalloutBulkRMABatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful{
	   
	List<String> parentCaseNumberList;
	List<String> parentCaseIdList = new List<String>();
	global HWS_MakeSOOCalloutBulkRMABatch(List<String> parentList){		
		this.parentCaseNumberList = parentList;
	}
	global List<SObject> start(Database.BatchableContext context) {
		 List<Case> caselist = [select id, CaseNumber from Case where CaseNumber in :parentCaseNumberList];	   
		return caselist;
	}
	global void execute(Database.BatchableContext context, List<SObject> caseLst) {		
		if(caseLst.size()>0){
			List<Case> caseListToUpdate = new List<Case>();
			for(SObject c :caseLst){				  
				List<Case> caseLstReturn = HWS_CreateSupportTicketportal.makeSOOCalloutBulkRMA(c.Id);
				caseListToUpdate.addAll(caseLstReturn);
	this.parentCaseIdList.add(c.Id);
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
		//Id batchJobId = Database.executeBatch(new HWS_StartMilestoneCalculationBatch (parentCaseIdList), 100);
	}
}