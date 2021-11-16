/****************************************
 * Class Name : DS_CPOLineItem_Scheduler
 * Created Date: Dec 2018
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: Dec 2018
 * Description : Schedule batch at hourly intervals
 * Test Class: 
 *****************************************/
global class DS_GBOMBatch_Scheduler implements Schedulable {
	  
	/********************
   *Method Name: DS_CPOLineItem_Scheduler
   *Parameter: NA
   *Description: Constructor 
   *******************/
	global DS_GBOMBatch_Scheduler() {}
	
	/********************
   *Method Name: execute
   *Parameter: SchedulableContext
   *Description: Schedule batch at hourly intervals
   *******************/
	global void execute(SchedulableContext sc) {
		try{
			Batch_GBOMRelation batch = new Batch_GBOMRelation();
			Database.executeBatch(batch,100); 
		}
		catch(Exception ex){ ExceptionHandler.addException(ex,'DS_GBOMBatch_Scheduler' ,'DS_GBOMBatch_Scheduler'); }

	}
	
}