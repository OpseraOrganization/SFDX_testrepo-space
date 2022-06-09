trigger CampaignMemberTrigger on CampaignMember (After insert,after Update, After Delete, After Undelete)
{
	 if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
	{
		if(Trigger.isAfter)
		{
			if(Trigger.isInsert)
			{
				CampaignMemberTriggerHandler.afterInsertOperation(Trigger.New);
			}
			if(Trigger.isUpdate)
			{
				CampaignMemberTriggerHandler.afterUpdateOperation(Trigger.New,trigger.old);
			}
			if(Trigger.isDelete)
			{
				CampaignMemberTriggerHandler.afterDeleteOperation(trigger.old);
			}
			if(Trigger.isUnDelete)
			{
				CampaignMemberTriggerHandler.afterUnDeleteOperation(Trigger.New);
			}
		}
	}
		
}