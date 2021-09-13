/****************************************
	 * Name : Batch_Recall_opportunity
	 * Author : Accenture
	 * Description : Sales Process Req# 3108: Recall Batch Job
	 *****************************************/
	global class Batch_Recall_opportunity implements Database.Batchable<sObject>,Database.Stateful,Schedulable 
	{

		Public List<NF_Recall_Ongoing_oppty__c> query_oppty = new List<NF_Recall_Ongoing_oppty__c>();
		Public List<NF_Recall_Ongoing_oppty__c> update_status = new List<NF_Recall_Ongoing_oppty__c>();
		Public String Recalled_Oppty;
		  Public string msg;
		/********************
		*Method Name:execute 
		*Parameter:SchedulableContext SC
		*Description:Execute the bacth 
		*******************/
	  
		 global void execute(SchedulableContext SC)
		 
		 {
		   Batch_Recall_opportunity  batch= new Batch_Recall_opportunity();
			 Database.executebatch(batch,1);		
		 }
		/****************************************
		 * Name : start
		 * Author : Accenture
		 * Description : this method will contain the SOQL query for the batch 
		 *****************************************/
		global Database.QueryLocator start(Database.BatchableContext BC)
		{
		// Map<String,NF_Recall_Ongoing_oppty__c> oppty_map = NF_Recall_Ongoing_oppty__c.getall();
		query_oppty = [select Name from NF_Recall_Ongoing_oppty__c where NF_is_recalled__c = false];
		set<String> oppty_set = new set<string>();
		for(NF_Recall_Ongoing_oppty__c get_oppty : query_oppty){
				oppty_set.add(get_oppty.Name);
			}
		return Database.getQueryLocator([SELECT Id,StageName, phase_status__c FROM Opportunity where Id in :oppty_set]);
		}  
		/****************************************
		 * Name : execute
		 * Author : Accenture
		 * Description : Execution of the batch
		 *****************************************/
		global void execute(Database.BatchableContext BC, List<Opportunity> oppty_list)
		{	  
		try
		{
		for(Opportunity recall_oppty : oppty_list)
		{System.debug('recall_oppty::> '+recall_oppty);
		If((recall_oppty.phase_status__c<>null && recall_oppty.phase_status__c.startsWith('Submitted')) || recall_oppty.StageName.equalsIgnoreCase('Submitted For Approval'))
		{
		recalled_oppty = recall_Oppty.Id;
		Apttus_Approval.ApprovalsWebService.cancelApprovals(GlobalConstants.OBJECT_OPPORTUNITY, recall_oppty.Id);				 
		}
		} 
		}
		catch(Exception exp){
		 msg = exp.getmessage();	 
		system.debug('Exception Message:'+msg);
			
		if(Test.isRunningTest() || msg.contains('Future method cannot be called from a future or batch method'))
		{
		for(NF_Recall_Ongoing_oppty__c recall_obj:query_oppty)
		{
		if( recall_obj.Name == recalled_oppty)
		{
		recall_obj.nf_is_recalled__c = true;
		update_status.add(recall_obj);
		}
		}
		if(!update_status.isEmpty())
		update update_status;		
		}
	  // ExceptionHandler.addException(exp,GlobalConstants.BATCH_RECALLOPPORTUNITY, GlobalConstants.BATCH_EXECUTE);
		}
	   }
		/********************
	*Method Name:finish
	*Parameter:BC
	*Description:No Operation here 
	*******************/
   global void finish(Database.BatchableContext BC) {
		   }
}