/****************************************
* Trigger Name : EntitlementTrigger 
* Created Date: 25 September 2018
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 25 September 2018
* Description : All Entitlement Related Actions will be tracked here
*****************************************/
trigger EntitlementTrigger on Entitlement (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

		new CH_EntitlementTriggerHandler().run();
}