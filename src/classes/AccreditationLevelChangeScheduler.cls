/****************************************
 * Class Name : AccreditationLevelChangeScheduler
 * Created Date: June 2018
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: June 2018
 * Description : Schedule AccreditationLevelChangeScheduler for Accreditation level change sceduler
 * Test Class: 
 *****************************************/
global class AccreditationLevelChangeScheduler implements Schedulable {
	  
	/********************
   *Method Name: execute
   *Parameter: SchedulableContext
   *Description: execute Method of NSA check class
   *******************/
	global void execute(SchedulableContext sc) {
	   Database.executeBatch(new batchAccreditationLevelEvalution());
	   }
	
}