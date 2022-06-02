/****************************************
	 * Name : BatchToDeleteDraftChildCase
	 * Author : HCL
	 * Description : BatchToDeleteDraftChildCase
	 *****************************************/
global without sharing class BatchToDeleteDraftChildCase implements Database.Batchable<sObject>,Schedulable {
	
			/********************
		*Method Name:execute 
		*Parameter:SchedulableContext SC
		*Description:Execute the batch 
		*******************/
	  
		global void execute(SchedulableContext SC)
		 
		 {
	 BatchToDeleteDraftChildCase  batch= new BatchToDeleteDraftChildCase();
	 Database.executebatch(batch,100);		
		 }
		/****************************************
		 * Name : start
		 * Author : HCL
		 * Description : this method will contain the SOQL query for the batch 
		 *****************************************/
		global Database.QueryLocator start(Database.BatchableContext BC)
		{
		 
	return Database.getQueryLocator([SELECT id,Status,CreatedBy.name,RecordType.name,ParentId,Parent.status,Parent.country__c,Parent.Is_Headquater__c,country__c,Is_Headquater__c FROM Case where RecordType.Name='IR/NIRA Sales to Country' and Status = 'Draft' and parentId!=null and Parent.status!='Draft' and parent.Is_Headquater__c=true]);
		
		}  
		/****************************************
		 * Name : execute
		 * Author : HCL
		 * Description : Execution of the batch
		 *****************************************/
		global void execute(Database.BatchableContext BC, List<case> caselist)
		{
			List<case> Deletecaselist = new List<case>();
			
			//performing additional condition check ie same child and parent country  
			for(case caseinstance:caselist)
			{
			if(caseinstance.CreatedBy.name=='Nokia Partner Portal Site Guest User' && caseinstance.Parent.country__c == caseinstance.country__c)
			{
	Deletecaselist.add(caseinstance);
			}
			}
	 
			database.delete(Deletecaselist);
		}
	
		/********************
	*Method Name:finish
	*Parameter:BC
	*Description:No Operation here 
	*******************/
   global void finish(Database.BatchableContext BC) {
	 }

}