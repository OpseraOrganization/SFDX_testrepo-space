/****************************************
	 * Name : BatchUpdateExpAmontInCoAllocation
	 * Author : HCL
	 * Description : BatchToUpdateExpirationAmountinCoAllocationRecords
	 *****************************************/
	global class BatchUpdateExpAmontInCoAllocation implements Database.Batchable<sObject>,Schedulable 
	{

		
		/********************
		*Method Name:execute 
		*Parameter:SchedulableContext SC
		*Description:Execute the batch 
		*******************/
	  
		 global void execute(SchedulableContext SC)
		 
		 {
		   BatchUpdateExpAmontInCoAllocation  batch= new BatchUpdateExpAmontInCoAllocation();
		   Database.executebatch(batch,100);		
		 }
		/****************************************
		 * Name : start
		 * Author : HCL
		 * Description : this method will contain the SOQL query for the batch 
		 *****************************************/
		global Database.QueryLocator start(Database.BatchableContext BC)
		{
		 
		  return Database.getQueryLocator([SELECT Id,Days_to_expire__c,Expiration_Date__c,Expiration_Amount__c,Allocation_Period_Balance__c,Status__c FROM Co_Op_Allocation__c where Status__c='Active' AND Expiration_Date__c < today]);
		
		}  
		/****************************************
		 * Name : execute
		 * Author : HCL
		 * Description : Execution of the batch
		 *****************************************/
		global void execute(Database.BatchableContext BC, List<Co_Op_Allocation__c> Coallocation_list)
		{	  
			List<Co_Op_Allocation__c> UpdateCoAllocationList = new List<Co_Op_Allocation__c>();

			for(Co_Op_Allocation__c CoAllocationInstance:Coallocation_list)
			{
				CoAllocationInstance.Status__c='Expired';
				if(CoAllocationInstance.Expiration_Amount__c!=null)
				{
				CoAllocationInstance.Expiration_Amount__c= CoAllocationInstance.Expiration_Amount__c+CoAllocationInstance.Allocation_Period_Balance__c;
				}
				if(CoAllocationInstance.Expiration_Amount__c ==null)
				{
				CoAllocationInstance.Expiration_Amount__c= CoAllocationInstance.Allocation_Period_Balance__c;
				}
				UpdateCoAllocationList.add(CoAllocationInstance);
			}
			
			database.update(UpdateCoAllocationList, false);
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