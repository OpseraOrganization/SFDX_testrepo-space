global class PSRORecalculateAssignmentsBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts
{
	global List<String> exception_List = new List<String>();
	global List<PSRO_Costs_Visibilities_Manager__mdt> psroAllowedRoles = [SELECT ID,Role_Name__c,BG__c FROM PSRO_Costs_Visibilities_Manager__mdt];
	global PermissionSet psroPms = [SELECT Id FROM PermissionSet WHERE Name = 'PSRO_Costs_Visibilities' LIMIT 1];
	global AggregateResult[] roleNameList = [SELECT Role_name__c FROM NF_RoleCode__c GROUP BY Role_name__c];
	global CustomNotificationType notifType = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'User_Notifications' LIMIT 1];
	global List<String> removedMetadata = new List<String>();
	
	global Database.QueryLocator start(Database.BatchableContext bc)
	{
		Id thisJobId = bc.getJobId();
		AsyncApexJob apexJob = [SELECT Id, ApexClassId FROM AsyncApexJob WHERE Id = :bc.getJobId()];
		AsyncApexJob[] jobs = [select id from AsyncApexJob where id!=:thisJobId AND status='Processing' AND ApexClassId=:apexJob.ApexClassId AND JobType='BatchApex'];
		System.debug(jobs);
		if ( (jobs==null || jobs.size()==0) && NF_EditAssignments.checkAccessToRunPSROBatch() ) 
		{
			//Collect the batches of records or objects to be passed to execute
			System.debug('no jobs running');
			removeInvalidRoleNames();
			String roleNameFilter = getAllowedRolesFilter();
			String query = 'SELECT Id, Name, IsActive, ProfileId, Restriction_Level__c, (Select Id,BG__c, Role_Code__c, Role_Name__c, User__c  FROM Sales_Roles__r WHERE ' + roleNameFilter + ') FROM User WHERE Restriction_Level__c != \'' + GlobalConstants.CONFIDENTIAL_VALUE + '\'';
			if(Test.isRunningTest())
			{
				query += ' AND LastName = \'TestUserForBatch\' LIMIT 10';
			}
			return Database.getQueryLocator(query);
		}
		else 
		{
			System.debug('same batch is already running or no permission to run batch...');
			return null;
		}
	}
	
	global void execute(Database.BatchableContext bc, List<User> userRecords)
	{
		Map<Id,Sales_role__c> salesRoleMap = new Map<Id,Sales_role__c>();
		Map<Id,User> newUserMap = new Map<Id,User>();
		Map<Id,User> oldUserMap = new Map<Id,User>();
		for(User user : userRecords)
		{
			User oldUser = user.clone(true,true,true,true);
			oldUser.Restriction_Level__c = GlobalConstants.CONFIDENTIAL_VALUE;
			oldUserMap.put(oldUser.Id, oldUser);
			
			User newUser = user.clone(true,true,true,true);
			newUserMap.put(newUser.Id, newUser);
			if(user.Sales_Roles__r.size() > 0)
			{
				for(Sales_role__c salesRole : user.Sales_Roles__r)
				{
					salesRoleMap.put(salesRole.Id, salesRole);
				}
			}
		}
		System.debug(userRecords);
		System.debug(oldUserMap);
		System.debug(newUserMap);
		System.debug(salesRoleMap);
				
		//Add missing permission set assignments: we will run this method as if we were inserting all these new sales roles
		SalesRoleTriggerHelper.managePSROCostsVisibilities(null, salesRoleMap, psroPms.Id, this.psroAllowedRoles);
		
		//remove permission sets in excess: we will run this method as if we were updating all users to current restriction level.
		UserTriggerHelper.managePSROCostsVisibilities(oldUserMap, newUserMap, psroPms.Id, this.psroAllowedRoles);
	}
	
	global void finish(Database.BatchableContext bc)
	{
		SendNotification.send(notifType.Id, createNotificationMessage(), UserInfo.getUserId());
	}
	
	private String getAllowedRolesFilter()
	{
		String allowedRoles = '';
		Integer cntr = 0;
		for(PSRO_Costs_Visibilities_Manager__mdt allowedRole: this.psroAllowedRoles)
		{
			cntr++;
			if(cntr > 1 )
			{
				allowedRoles += ' OR ';
			}
			allowedRoles += 'Role_Name__c like \'%' + allowedRole.Role_Name__c + '%\'';
		}
		if(allowedRoles.equals(''))
		{
			allowedRoles = 'Role_Name__c = \'\'';
		}
		return allowedRoles;
	} 
	
	private void removeInvalidRoleNames()
	{
		Integer j = 0;
	 	while (j < this.psroAllowedRoles.size())   
		{
			Boolean validRole = false;
			for(AggregateResult roleName : roleNameList)
			{
				if(this.psroAllowedRoles[j].Role_Name__c.equals(roleName.get('Role_name__c')))
				{
					validRole = true;
					break;
				}				
			}
			if(validRole == false)
			{
				this.removedMetadata.add(psroAllowedRoles[j].Role_Name__c);
				this.psroAllowedRoles.remove(j);
			}
			else
			{
				j++;
			}
		}
	}
	
	private String createNotificationMessage()
	{
		String finalMessage = 'PSRO cost visibilities permision set assignment recalculation has finished.';
		if(this.removedMetadata.size() > 0)
		{
			finalMessage += 'The following PSRO metadata were not considered because they do not match any existing role name: ';
			for(String mtd : this.removedMetadata)
			{
				finalMessage += mtd + ', ';
			}
		}
		return finalMessage;
	}
}