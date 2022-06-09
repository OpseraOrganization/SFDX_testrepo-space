/****************************************
* Class Name : ChangeDefaultLE
* Created Date: 22 August 2017
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 22 August 2017
* Description : Default one can remain inactive, but as soon as active one becomes available in CMD this one replaces the inactive one. Daily job
* Test Class: 
*****************************************/
global class ChangeDefaultLESchedular implements Schedulable {
	global void execute(SchedulableContext SC) {
		ChangeDefaultLE changeDLE = new ChangeDefaultLE(); 
		//changeDLE.doChanges();
		changeDLE.computeSingleDLE();
		//changeDLE.checkCustomersWithoutDLE();
		changeDLE.executeBatchUpdate();
	}
}