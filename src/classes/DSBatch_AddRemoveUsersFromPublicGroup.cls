/****************************************
	 * Name : DSBatch_AddRemoveUsersFromPublicGroup
	 * Author : Accenture
	 * Description : This class is for creating product entries from Product sales item staging object
	 * ReqNo : 
	****************************************/
global class DSBatch_AddRemoveUsersFromPublicGroup implements Database.Batchable<sObject>,Database.Stateful,Schedulable {

	List<string> permissionSetNames = new List<String>();
	public String groupId;
	/****************************************
		 * Name : execute
		 * Description : executes the batch class using schedulable instance
		 * Parameters: SchedulableContext
	 *****************************************/
	global void execute(SchedulableContext SC)	  
	{
		DSBatch_AddRemoveUsersFromPublicGroup  batch = new DSBatch_AddRemoveUsersFromPublicGroup();
		Database.executebatch(batch);			
	} 
	
	 /****************************************
		 * Name : start
		 * Description : Retrieves the data from sales item staging object
		 * Parameters: Database.BatchableContext
		 * Returns : Database.QueryLocator
	 *****************************************/
	global Iterable<sObject> start(Database.BatchableContext BC)
	{
	 	//collect all users from public group, check if they have permission set assigned else remove them
	 	//
	 	String permissionSetLabel = Label.DS_PermissionSetsForPublicGroup;
		 Group groupName = [Select Id,DeveloperName 
						   from Group 
						   where DeveloperName = :CSWXGlobalConstant.Order_Management_Group Limit 1];
		if(groupName <> null)
			groupId = groupName.Id;
		System.debug(groupId);
		
		for(String psLabel : permissionSetLabel.split('\n'))
		{
			permissionSetNames.add(psLabel.trim());
		}
		List<GroupMember> memberList = [SELECT GroupId,Id,UserOrGroupId,Group.DeveloperName 
										 FROM GroupMember 
										 where Group.DeveloperName = :CSWXGlobalConstant.Order_Management_Group];
		List<PermissionSetAssignment> pmList = [SELECT AssigneeId,Id,PermissionSetId,PermissionSet.Name 
													 FROM PermissionSetAssignment 
													 where PermissionSet.Name in :permissionSetNames];
		List<sObject> sObjectList = new List<sObject>();
		sObjectList.addAll(pmList);
		sObjectList.addAll(memberList);
		
		return sObjectList;
	}
	
	/****************************************
		 * Name : execute
		 * Description : Retrieves the data from sales item staging object
		 * Parameters: Database.BatchableContext, List of Product sales item
		 * Returns : 
	 *****************************************/	
	global void execute(Database.BatchableContext BC, List<sObject> usersList)
	{ 
		List<Id> groupMemberList = new List<Id>();
		Set<Id> permissionSetUsers = new Set<Id>();
		Map<String,String> publicGroupMembers = new Map<String,String>();
		system.debug(groupID);
		
		List<GroupMember> groupMemberUpdate = new List<GroupMember>();
		Set<Id> groupMembersSet = new Set<Id>();
		Set<String> permissionAssignedUsers = new Set<String>();
		Schema.SObjectType psmType = Schema.PermissionSetAssignment.getSObjectType();
		Schema.SObjectType gmType = Schema.GroupMember.getSObjectType();

		
		try{
			
			for(sObject users : usersList){
				if(users.getSObjectType() == psmType && users.get('AssigneeId') <> null)
					permissionAssignedUsers.add(String.valueOf(users.get('AssigneeId')));
				else if(users.getSObjectType() == gmType && users.get('UserOrGroupId') <> null){
					publicGroupMembers.put(String.valueOf(users.get('UserOrGroupId')),String.valueOf(users.get('Id')));
				}
					
		}
			 system.debug('publicGroupMembers'+publicGroupMembers);
			if(!publicGroupMembers.keySet().isEmpty()){
				for(PermissionSetAssignment psaUser : [SELECT AssigneeId,Id,PermissionSetId,PermissionSet.Name 
													   FROM PermissionSetAssignment 
													   where PermissionSet.Name in :permissionSetNames
													   And AssigneeId in :publicGroupMembers.keySet()])
				{
					permissionSetUsers.add(psaUser.AssigneeId);
				}
				system.debug('permissionSetUsers'+permissionSetUsers);
				for(String member : publicGroupMembers.keySet()){
					if(!permissionSetUsers.contains(member)){
						groupMemberList.add(publicGroupMembers.get(member));
					}
				}
				if(!groupMemberList.isEmpty())
				{
					Database.delete(groupMemberList,false);
				}
			}
			
			if(!permissionAssignedUsers.isEmpty()){
				for(GroupMember groupMembers : [SELECT GroupId,Id,UserOrGroupId,Group.DeveloperName 
												FROM GroupMember 
												Where Group.DeveloperName = :CSWXGlobalConstant.Order_Management_Group
												And UserOrGroupId in :permissionAssignedUsers])
				{
					groupMembersSet.add(groupMembers.UserOrGroupId);
				}
				for(String userId : permissionAssignedUsers){
					if(!groupMembersSet.contains(userId)){
						GroupMember gm = new GroupMember();
						gm.UserOrGroupId = userId;
						gm.GroupId = groupId;
						groupMemberUpdate.add(gm);
					}
				}
				if(!groupMemberUpdate.isEmpty())
				{
					Database.insert(groupMemberUpdate,false);
					//insert groupMemberUpdate;
				}
			}
		
		
		
		}catch(Exception ex){
			ExceptionHandler.addException(ex,'Batch_AdduserstoGroup','Execute');
	}
	}
	
	/****************************************
		 * Name : finish
		 * Description : finish method of batch class which calls price list item batch class to update 
		 *		or create price list items from product sales items
		 * Parameters: Database.BatchableContext
		 * Returns : 
	 *****************************************/ 
	global void finish(Database.BatchableContext BC)
	{

	}
}