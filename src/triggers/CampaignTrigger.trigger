/****************************************
 * Trigger Name : CampaignTrigger
 * Created Date: 06 March 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : All Campaign related Actions will be tracked here
 *****************************************/
trigger CampaignTrigger on Campaign(Before update,before delete,Before insert) {
   if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
		if(Trigger.isBefore && Trigger.isInsert){
			CampaignTriggerHandler.beforeInsertOperation(Trigger.new);
		}
		else if(Trigger.isBefore && Trigger.isUpdate){
			CampaignTriggerHandler.beforeUpdateOperation(Trigger.new);
		}
		else if(Trigger.isBefore && Trigger.isDelete){
			CampaignTriggerHandler.beforeDeleteOperation(Trigger.old);
		}
   }	 
}