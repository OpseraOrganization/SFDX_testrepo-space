/****************************************
	 * Name : Batch_Remove_NSA_FLAG
	 * Author : Accenture
	 * Description : This class is for removing NSA flag on user based on NSA Epiration Date Field
	 * ReqNo : #5957
	****************************************/
global class Batch_Remove_NSA_FLAG implements Database.Batchable<sObject>,Schedulable
{
	/****************************************
		 * Name : execute
		 * Description : executes the batch class using schedulable instance
		 * Parameters: SchedulableContext
	 *****************************************/
	global void execute(SchedulableContext SC)	  
	{
		Batch_Remove_NSA_FLAG  batch= new Batch_Remove_NSA_FLAG();
		Database.executebatch(batch,200);			
	} 
	
	/****************************************
		 * Name : start
		 * Description : Retrieves the data from sales item staging object
		 * Parameters: Database.BatchableContext
		 * Returns : Database.QueryLocator
	 *****************************************/
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		try{
			return database.getQueryLocator([
				Select Id, NSA_Expiration_Date__c, NSA_Compliant__c
				From User
				Where NSA_Expiration_Date__c = today
				And NSA_Compliant__c = true
			]);
		}
		catch(Exception ex)
			{
				ExceptionHandler.addException(ex,GlobalConstants.BatchRemoveNSAFLAG , GlobalConstants.START);
				return null;
			}
	}
	
	/****************************************
		 * Name : execute
		 * Description : Retrieves the user data from user object
		 * 	If any user has expiration <= today, then update NSA compliant flag to false
		 * Parameters: Database.BatchableContext, List of User
		 * Returns : 
	 *****************************************/	
	global void execute(Database.BatchableContext BC, List<User> UserList)
	{
		try{
			
			for(User userObj : UserList)
			{
				userObj.NSA_Compliant__c = false;
			}
			
			
			List<Database.SaveResult> userResults = Database.update(UserList, false);
			ExceptionHandler.generateExceptionRecordFromSaveResult(userResults,GlobalConstants.BATCH_EXECUTE,GlobalConstants.BatchRemoveNSAFLAG);  
		   
		}
		catch(Exception ex)
			{
				ExceptionHandler.addException(ex,GlobalConstants.BatchRemoveNSAFLAG , GlobalConstants.BATCH_EXECUTE);
		   }
	}
	
	/****************************************
		 * Name : finish
		 * Description : finish method of batch class
		 * Parameters: 
		 * Returns : 
	 *****************************************/ 
	global void finish(Database.BatchableContext BC)
	{
	}
}