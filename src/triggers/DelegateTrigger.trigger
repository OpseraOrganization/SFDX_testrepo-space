/****************************************
 * Trigger Name : DelegateTrigger 
 * Created Date: 9 Sep 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date:  
 * Description : Used this trigger to check the NSA usersinfo
 *****************************************/

trigger DelegateTrigger on Apttus_Approval__Backup_Approver__c (Before insert, Before update) {

 if(Trigger.isBefore)
	{
		if(Trigger.isInsert ){
			
			DelegateHandler.BeforeInsert(Trigger.new);
		   
		   
		  
		}
		
		 if(Trigger.isUpdate ){
		 DelegateHandler.BeforeUpdate(Trigger.new,Trigger.oldmap);
		 
		 }

	}


  }