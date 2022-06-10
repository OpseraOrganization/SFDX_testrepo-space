/****************************************
* Trigger Name : ServiceContractTrigger 
* Created Date: 31 August 2018
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 15 October 2020
* Description : All ServiceContract Related Actions will be tracked here
*****************************************/
trigger ServiceContractTrigger on ServiceContract (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

		new ServiceContractTriggerHandler().run();
		new CH_ServiceContractTriggerHandler().run();
}