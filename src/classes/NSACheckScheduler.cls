/****************************************
 * Class Name : NSACheckScheduler
 * Created Date: March 2018
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: March 2018
 * Description : Send email if NSA security at risk
 * Test Class: 
 *****************************************/
global class NSACheckScheduler implements Schedulable {
	  
	/********************
   *Method Name: NSACheckScheduler
   *Parameter: String
   *Description: Constructor 
   *******************/
	global NSACheckScheduler() {
	}
	
	/********************
   *Method Name: execute
   *Parameter: SchedulableContext
   *Description: execute Method of NSA check class
   *******************/
	global void execute(SchedulableContext sc) {
		CheckNSASecurity.CheckNSASecurityOnProfile();
	}
	
}