/****************************************
* Trigger Name : AssetTrigger 
* Created Date: 25 September 2018
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 11 November 2019
* Description : All Asset Related Actions will be tracked here
	 : Added functionality to create Covered NEA record automatically upon creation of NEA from CLI record page. 
*****************************************/
trigger AssetTrigger on Asset (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

		new CH_AssetTriggerHandler().run();
}