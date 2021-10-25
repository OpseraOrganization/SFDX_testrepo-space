/****************************************
* Trigger Name : OrderIntakeTrigger
* Created Date: 11 November 2016
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 21 November 2016
* Description : All Order Intake Actions will be tracked here
*****************************************/

trigger OrderIntakeTrigger on Order_Intake_Forecast__c (Before insert, Before update,Before Delete,After Update, After Insert,after Delete) {  
	if(Trigger.isBefore)
	{
		if(Trigger.isInsert ){
			OrderIntakeHandler.BeforeInsert(Trigger.new);
			
		}
		if(Trigger.isUpdate){
			System.debug('>>>>>>BeforeUpdate Start>>>>>>>');
			OrderIntakeHandler.BeforeUpdate(Trigger.new,Trigger.old);
			OrderIntakeHandler.BeforeUpdate(Trigger.new,Trigger.oldMap);
			System.debug('>>>>>>BeforeUpdate End>>>>>>>');		
			
		}  
		
		if(Trigger.isDelete)	
		{
			OrderIntakeHandler.BeforeDelete(Trigger.old);
		}
		
	}
	if(Trigger.isAfter){
		if(Trigger.isInsert ){
			OrderIntakeHandler.AfterInsert(Trigger.new);
		}
		
		
		if(Trigger.IsUpdate){
			OrderIntakeHandler.AfterUpdate(Trigger.new);
			
			OrderIntakeHandler.AfterUpdate(Trigger.newMap, Trigger.oldMap);//add on 2018-08-13 for ticket 12942
		}
		
		
		
	}
}