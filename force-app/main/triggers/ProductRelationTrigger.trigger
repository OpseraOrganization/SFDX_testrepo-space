/** 
 * About 
 * ----- 
 * @Description	  : Product_Relation__c Object Trigger.
 * @TestClass		: ProductRelationTriggerTest.
 * @Project		  : Case Handling.
 * @Modification Log : 
 *  Created  : 2020 01 23 – tiago.almeida@nokia.com
 * ----- 
**/
trigger ProductRelationTrigger on Product_Relation__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {
	new ProductRelationTriggerHandler().run();
}