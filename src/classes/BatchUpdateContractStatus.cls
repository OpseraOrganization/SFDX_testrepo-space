/****************************************
	 * Name : BatchUpdateContractStatus
	 * Author : HCL
	 * Description : BatchToUpdateContractRecords
	 *****************************************/
	 global class BatchUpdateContractStatus implements Database.Batchable<sObject>,Schedulable 
	{
		/********************
		*Method Name:execute 
		*Parameter:SchedulableContext SC
		*Description:Execute the batch 
		*******************/
	  
		global void execute(SchedulableContext SC)
		 
		 {
	 BatchUpdateContractStatus  batch= new BatchUpdateContractStatus();
	 Database.executebatch(batch,100);		
		 }
		/****************************************
		 * Name : start
		 * Author : HCL
		 * Description : this method will contain the SOQL query for the batch 
		 *****************************************/
		global Database.QueryLocator start(Database.BatchableContext BC)
		{
		 
	return Database.getQueryLocator([SELECT Id,Contract_Status_New__c,Expired_Contract_Status__c,	EndDate,CreatedDate FROM Contract where CreatedDate < 2018-10-19T00:00:00Z AND Expired_Contract_Status__c!='Archived']);
		
		}  
		/****************************************
		 * Name : execute
		 * Author : HCL
		 * Description : Execution of the batch
		 *****************************************/
		global void execute(Database.BatchableContext BC, List<Contract> Contract_list)
		{	  
			List<Contract> UpdateContractList = new List<Contract>();

			for(Contract ContractInstance:Contract_list)
			{
	if(ContractInstance.EndDate < system.today())
				{
					ContractInstance.Contract_Status_New__c= 'Passed End Date';
					ContractInstance.Expired_Contract_Status__c ='Action Needed';
					ContractInstance.Contract_Status__c = 'Expired';
				}
	
	UpdateContractList.add(ContractInstance);
			}
			
			database.update(UpdateContractList);
		}
	  // ExceptionHandler.addException(exp,GlobalConstants.BATCH_RECALLOPPORTUNITY, GlobalConstants.BATCH_EXECUTE);
		
		/********************
	*Method Name:finish
	*Parameter:BC
	*Description:No Operation here 
	*******************/
   global void finish(Database.BatchableContext BC) {
	 }
}