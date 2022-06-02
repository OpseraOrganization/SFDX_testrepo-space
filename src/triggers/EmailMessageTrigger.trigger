/***************************************
* Trigger Name : EmailMessageTrigger 
* Created Date: 22 Nov 2018
* Created By : TCS
* Last Modified by: 
* Last Modified Date: 
* Description : 
* Last Modified by: TCS
* Last Modified Date: 
* Description : 
*****************************************/
trigger EmailMessageTrigger on EmailMessage (before insert, before update, after insert) {
	
	  if(Trigger.IsInsert){
		 if(Trigger.isBefore){
			 CH_EmailMessageTriggerHandler.beforeInsertOperation(Trigger.New);
		 }
		 if(Trigger.isAfter){
			 CH_EmailMessageTriggerHandler.afterInsertOperation(Trigger.New);
		 }
	 }
	
   
	
  

}