/* 
CREATED BY BRUNO PALMA
UPDATED BY JOAO RODRIGUES
*/
global without sharing class UserTriggerHandler extends TriggerHandler
{
	private Map<Id,User> oldMap = (Map<Id,User>)Trigger.oldMap;
	private Map<Id,User> newMap = (Map<Id,User>)Trigger.newMap;
	
	public UserTriggerHandler()
	{
	}

	protected override void beforeInsert()
	{
		if(GlobalConstants.RUN_USER_TRIGGER_ON_FILESHARING)
		{
			try
			{
				if(!GlobalConstants.STOP_TRIGGER_USER_ON_BEFOREINSERT)
				{
					GlobalConstants.STOP_TRIGGER_USER_ON_BEFOREINSERT = true;
					UserTriggerHelper.updateNSA_Mod(oldMap,newMap);
					UserTriggerHelper.updateDeactivationDate(oldMap,newMap);
					UserTriggerHelper.updateFederationId(oldMap,newMap);
				}
			}
			catch(Exception ex)
			{
				ExceptionHandler.addException(ex, GlobalConstants.USER_HANDLER , GlobalConstants.ON_BEFORE_INSERT_ACC);
			}
		}
	}

	protected override void beforeUpdate()
	{
		if(GlobalConstants.RUN_USER_TRIGGER_ON_FILESHARING)
		{
			try
			{
				if(!GlobalConstants.STOP_TRIGGER_USER_ON_BEFOERUPDATE)
				{
					GlobalConstants.STOP_TRIGGER_USER_ON_BEFOERUPDATE = true;
					UserTriggerHelper.updateNSA_Mod(oldMap,newMap);
					UserTriggerHelper.updateDeactivationDate(oldMap,newMap);
					UserTriggerHelper.updateFederationId(oldMap,newMap);
				}
			}
			catch(Exception ex)
			{
				ExceptionHandler.addException(ex, GlobalConstants.USER_HANDLER , GlobalConstants.ON_BEFORE_UPDATE_ACC);
			}
		}
	}

	protected override void beforeDelete()
	{
		UserTriggerHelper.managePSROCostsVisibilities(oldMap,newMap,null,null);
	}

	protected override void afterInsert()
	{
		try
		{
			if(GlobalConstants.RUN_USER_TRIGGER_ON_FILESHARING)
			{
				UserTriggerHelper.createAccountContactRelationShare(oldMap,newMap);
				UserTriggerHelper.createAuthorizedEntitlements(oldMap,newMap);
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.USER_HANDLER , GlobalConstants.ON_AFTER_UPDATE_ACC );
		}
		UserHandlerPRM.onAfterInsert(Trigger.New);
		DS_UserTrigger_Handler.processOnlyDMPUser(newMap);
		UserConCreationHandler.CallFutureConCreation(Trigger.new);
		UserTriggerHelper.managePSROCostsVisibilities(oldMap,newMap,null,null);
	}

	protected override void afterUpdate()
	{
		try
		{
			if(GlobalConstants.RUN_USER_TRIGGER_ON_FILESHARING)
			{
				if(!GlobalConstants.STOP_TRIGGER_USER_ON_AFTERUPDATE)
				{
					GlobalConstants.STOP_TRIGGER_USER_ON_AFTERUPDATE = true;
					// To add key user in Key Market group
					UserTriggerHelper.AddtoKeyUserGroup(oldMap,newMap);
					//Permission Set assignment code
					set<id> userIdAdd = new Set<Id> ();
					set<id> userIdRemove = new Set<Id> ();
					for(User userNew : newMap.values())
					{
						if((oldMap.get(userNew.id).Restriction_Level__c  != GlobalConstants.CONFIDENTIAL_VALUE) && userNew.Restriction_Level__c  == GlobalConstants.CONFIDENTIAL_VALUE)
						{
							userIdAdd.add(userNew.id);
						}
						else
							if((oldMap.get(userNew.id).Restriction_Level__c  == GlobalConstants.CONFIDENTIAL_VALUE) && userNew.Restriction_Level__c  != GlobalConstants.CONFIDENTIAL_VALUE)
							{
								userIdRemove.add(userNew.id);
							}
					}
					if(!userIdAdd.IsEmpty())
					{
						UserTriggerHelper.assignPermissionSetOnInsertUpdate(userIdAdd);
					}
					if(!userIdRemove.IsEmpty())
					{
						UserTriggerHelper.removePermissionSetOnUpdate(userIdRemove);
					}
					///Req 5991 - Remove NSA territories when a user's NSA flag is deactivated
					UserTriggerHelper.removeUserFromNSATerritory(newMap.values(), oldMap);
				}
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.USER_HANDLER , GlobalConstants.ON_AFTER_UPDATE_ACC );
		}
		System.enqueueJob(new NF_User_Helper(newMap));
		UserConCreationHandler.CallFutureUpdateConStatus(oldMap,newMap);
		UserTriggerHelper.managePSROCostsVisibilities(oldMap,newMap,null,null);
	}

	protected override void afterDelete()
	{
	}
}