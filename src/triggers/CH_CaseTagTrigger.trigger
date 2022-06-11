/** 
 * About 
 * ----- 
 * @Description	  : CH_CaseTag__c Object Trigger.
 * @TestClass		: CH_CaseTagTriggerTest.
 * @Project	: Case Handling.
 * @Modification Log : 
 *  Created  : 2020 06 25 – tiago.almeida@nokia.com
 * ----- 
**/
trigger CH_CaseTagTrigger on CH_CaseTag__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {
	new CH_CaseTagTriggerHandler().run();
}