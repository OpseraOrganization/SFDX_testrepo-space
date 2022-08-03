/****************************************
 * Trigger Name : AccountTrigger 
 * Created Date: 26 December 2016
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 21 January 2016
 * Description : All Account Related Actions will be tracked here
 *****************************************/
Trigger AccountTrigger on Account (Before insert, Before update, After insert, After update)
{
	//NOKIASC-31789 The Bypass variable was added to bypass Triggers from Test class
   Boolean byPass = String.IsEmpty((Global_Control__c.getInstance().ObjectTriggerByPass__c))  ? true : !(Global_Control__c.getInstance().ObjectTriggerByPass__c).containsIgnoreCase('ACCT');
   boolean updateAc;
   if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && byPass )
   {
   //ITCCPQ-332  start
	   if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
	   {
		   if(Trigger.isUpdate){
			   updateAc = true;
		   }
		   AccountTriggerHandlerCOE.beforeUpdateOperation(Trigger.new,Trigger.oldmap,updateAc);		
	   }
//	 ITCCPQ-332 End
		if(Trigger.isBefore)
		{
			AccountTriggerHandler.beforeOperation(Trigger.new);
			if(Trigger.isInsert)
			{
	AccountTriggerHandler.beforeInsertOperation(Trigger.new);
			}
			else if(Trigger.isUpdate)
			{
	AccountTriggerHandler.beforeUpdateOperation(Trigger.new);
	AccountTriggerHandlerPRM.beforeUpdateOperation(Trigger.new);
	//AccountTriggerHandler.beforeUpdateAccountModifier(Trigger.new,Trigger.oldMap);
			}
		}
		else if(Trigger.isAfter)
		{
			if(Trigger.isInsert)
			{
	DS_AccountTriggerHandler.afterInsertOperation(Trigger.new);
	AccountTriggerHandler.afterInsertOperation(Trigger.new);
	AccountTriggerHandlerPRM.afterInsertOperation(Trigger.new);
	AccountTriggerHandlerPRM.afterInsertForCOOP(Trigger.new);
			}
			else if(Trigger.isUpdate)
			{
	AccountTriggerHandler.afterUpdateOperation(Trigger.new, Trigger.newMap, Trigger.oldMap);
	// AccountMovementHandler.afterUpdate(Trigger.oldMap,Trigger.newMap);
	AccountTriggerHandlerPRM.afterUpdate(Trigger.oldMap,Trigger.newMap);
	AccountTriggerHandlerPRM.afterUpdateForCOOP(Trigger.oldMap, Trigger.new);
	AccountTriggerHandler.afterUpdateSupplierOperation(Trigger.newMap, Trigger.oldMap); 
	//DS_CustomerUserShareWithAccountManager.changeAccountOwnerSharing(Trigger.oldMap, Trigger.newMap);
	DS_AccountTriggerHandler.ProcessOnlyDMPAccount(Trigger.oldMap,Trigger.newMap);
	DS_AccountTriggerHandler.afterUpdateOperation(Trigger.oldMap,Trigger.newMap);
			}
		}
   }
}