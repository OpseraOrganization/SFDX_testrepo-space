/***************************************
* Trigger Name : KnowledgeTrigger 
* Created Date: 09 Jamuary 2019
* Created By : salesforce.com
* Last Modified by: salesforce.com
* Last Modified Date: 09 January 2018
* Description : All Knowledge Related Actions will be tracked here
*****************************************/
trigger KnowledgeTrigger on Knowledge__kav (	
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

	new CH_KnowledgeHandler_TH().run();
}