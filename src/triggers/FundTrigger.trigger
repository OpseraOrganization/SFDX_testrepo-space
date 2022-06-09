/****************************************
 * Trigger Name : FundTrigger 
 * Created Date: 08 May 2018
 * Created By : Accenture
 * Description : All CooPFund Related Actions will be tracked here
 *****************************************/
trigger FundTrigger on Fund__c (Before insert, Before update, After insert, After update) {
   if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
   {
		if(Trigger.isBefore)
		{
			if(Trigger.isInsert)
			{
				CoopFundHandlerPRM.beforeInsertOperation(Trigger.new);
			}
			else if(Trigger.isUpdate)
			{
	   CoopFundHandlerPRM.beforeUpdateOperation(Trigger.new);
			}
		}
		else if(Trigger.isAfter)
		{
			if(Trigger.isInsert)
			{
	system.debug('Trigger>>>>>>>>');
			//	CoopFundHelperPRM.createAccuarls(Trigger.new);
	CoopFundHandlerPRM.afterInsertOperation(Trigger.new);
			}
			else if(Trigger.isUpdate)
			{
			}
		}/*
	else if(Trigger.isDelete){
		 if(Trigger.isBefore)
			{
	  
			}
			else if(Trigger.isAfter){
	  // CoopFundHandlerPRM.afterDelete(Trigger.old);
		 }
	}*/
   }
}