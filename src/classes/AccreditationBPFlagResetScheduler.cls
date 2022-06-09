/****************************************
 * Class Name : AccreditationBPFlagResetScheduler
 * Created Date: June 2018
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: June 2018
 * Description : Schedule BPFlagResetOnAccreditation for BP statu reset ona ccreditation
 * Test Class: 
 *****************************************/
global class AccreditationBPFlagResetScheduler implements Schedulable {	  
	/********************
   *Method Name: execute
   *Parameter: SchedulableContext
   *Description: execute Method of NSA check class
   *******************/
	global void execute(SchedulableContext sc) {
	   Database.executeBatch(new BPFlagResetOnAccreditation());
	   }   
}