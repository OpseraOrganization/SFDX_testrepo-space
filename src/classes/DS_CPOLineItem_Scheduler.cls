/****************************************
 * Class Name : DS_CPOLineItem_Scheduler
 * Created Date: Dec 2018
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: Dec 2018
 * Description : Schedule batch at hourly intervals
 * Test Class: 
 *****************************************/
global class DS_CPOLineItem_Scheduler implements Schedulable {
	  
	/********************
   *Method Name: DS_CPOLineItem_Scheduler
   *Parameter: NA
   *Description: Constructor 
   *******************/
	global DS_CPOLineItem_Scheduler() {}
	
	/********************
   *Method Name: execute
   *Parameter: SchedulableContext
   *Description: Schedule batch at hourly intervals
   *******************/
	global void execute(SchedulableContext sc) {
		try{
			Batch_CPOItems batch = new Batch_CPOItems();
			Database.executeBatch(batch,100); 
		}
		catch(Exception ex){ ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_CPOLineItem_Scheduler ,CSWXGlobalConstant.DS_CPO_Scheduler_execute ); }

	}
	
}