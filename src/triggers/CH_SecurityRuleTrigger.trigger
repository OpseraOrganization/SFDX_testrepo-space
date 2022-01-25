/** 
 * About 
 * ----- 
 * @Description	  : Case Handling SecurityRule Trigger.
 * @TestClass		: CH_SecurityRuleTriggerTest.
 * @Project		  : Case Handling.
 * @Modification Log : 
 *  Created  : 2019 11 18 – tiago.almeida@nokia.com
 * ----- 
**/
trigger CH_SecurityRuleTrigger on CH_SecurityRule__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

		new CH_SecurityRuleTriggerHandler().run();
}