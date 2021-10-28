/**
About
-----
Description: This Class is used as Helper for CH_WorkgroupMemberTrigger.

Created for: Nokia Portugal COE
Created: 19 02 2019

Update History
--------------
Created: 19 02 2019 – flavio.toscano@nokia.com
-------------
**/
public with sharing class CH_WorkgroupMemberHandler_TL {

	/*
	* @description : CH_UserId__c based on User__c in order to run the Duplicate Rules
	* @param : List<CH_Workgroup_Member__c>
	* @return : void
	*/
	public static void updateUserId(List<CH_Workgroup_Member__c> oCH_WorkgroupMember) {
		//final Id workgroupMemberRT = Utils.MapRecordType('CH_Workgroup_Member__c').get('CH_KB_Workgroup_Members');
		String workgroupMemberRT = Utils.getRecordTypeIdByDeveloperName('CH_Workgroup_Member__c','CH_KB_Workgroup_Members');
		
		for(CH_Workgroup_Member__c oWorkgroupMember: oCH_WorkgroupMember){
			if(oWorkgroupMember.RecordTypeId == workgroupMemberRT) {
				oWorkgroupMember.CH_UserId__c = oWorkgroupMember.CH_User__c;
				oWorkgroupMember.CH_WorkgroupId__c = oWorkgroupMember.CH_Workgroup__c;
			}
		}
	}
	
	/*
	* @description : Share Workgroup Member on CH_Workgroup__c
	* @param : List<CH_Workgroup_Member__c>
	* @return : void
	*/
	public static void addWorkgroupMemberToWorkgroupShare(List<CH_Workgroup_Member__c> oCH_WorkgroupMember) {
		//final Id workgroupMemberRT = Utils.MapRecordType('CH_Workgroup_Member__c').get('CH_KB_Workgroup_Members');
		String workgroupMemberRT = Utils.getRecordTypeIdByDeveloperName('CH_Workgroup_Member__c','CH_KB_Workgroup_Members');
		List<CH_Workgroup__Share> workgroupShareList = new List<CH_Workgroup__Share>();

		for(CH_Workgroup_Member__c oWorkgroupMember: oCH_WorkgroupMember){
			if(oWorkgroupMember.RecordTypeId == workgroupMemberRT && oWorkgroupMember.CH_Owner__c == false) {
				CH_Workgroup__Share workgroupShare = new CH_Workgroup__Share();
				if (Schema.sObjectType.CH_Workgroup__Share.fields.ParentId.isCreateable()) {
					workgroupShare.ParentId = oWorkgroupMember.CH_WorkgroupId__c;
				}
				if (Schema.sObjectType.CH_Workgroup__Share.fields.UserOrGroupId.isCreateable()) {
					workgroupShare.UserOrGroupId = oWorkgroupMember.CH_UserId__c;
				}
				if (Schema.sObjectType.CH_Workgroup__Share.fields.AccessLevel.isCreateable()) {
					workgroupShare.AccessLevel = 'Read';
				}
				if (Schema.sObjectType.CH_Workgroup__Share.fields.RowCause.isCreateable()) {
					workgroupShare.RowCause = 'Manual';
				}
				workgroupShareList.add(workgroupShare);
			}
		}
		
		if(workgroupShareList.size()>0){
			system.debug(workgroupShareList);
			if(CH_Workgroup__Share.sObjectType.getDescribe().isCreateable()){
				CH_EM_Workgroup.doUpsertCHWorkgroupShareList(workgroupShareList);
			}
		}
	}
	
	/*
	* @description : Delete Shared Workgroup Member on CH_Workgroup__c
	* @param : List<CH_Workgroup_Member__c>
	* @return : void
	*/
	public static void deleteWorkgroupMemberToWorkgroupShare(List<CH_Workgroup_Member__c> oCH_WorkgroupMember) {
		//final Id workgroupMemberRT = Utils.MapRecordType('CH_Workgroup_Member__c').get('CH_KB_Workgroup_Members');
		String workgroupMemberRT = Utils.getRecordTypeIdByDeveloperName('CH_Workgroup_Member__c','CH_KB_Workgroup_Members');
		List<CH_Workgroup__Share> workgroupShareListToDelete = new List<CH_Workgroup__Share>();
		Set<Id> workgroupShareIdSetToDelete = new Set<Id>();
		Map<Id,Id> workgroupIdAndUserId = new Map<Id,Id>();
		Set<Id> workgroupIdSet = new Set<Id>();
		Set<Id> workgroupShareToDeleteSet = new Set<Id>();

		for(CH_Workgroup_Member__c oWorkgroupMember: oCH_WorkgroupMember){
			if(oWorkgroupMember.RecordTypeId == workgroupMemberRT && oWorkgroupMember.CH_Owner__c == false) {
	workgroupIdSet.add(oWorkgroupMember.CH_WorkgroupId__c);
			}
		}
		
		if(!workgroupIdSet.isEmpty()){
			for(CH_Workgroup__Share workgroupShare : CH_EM_Workgroup.getAllWorkgroupShares(workgroupIdSet)){
				workgroupIdAndUserId.put(workgroupShare.Id, workgroupShare.UserOrGroupId);
				
			}
			
			if(!workgroupIdAndUserId.isEmpty()){
				List<Id> workgroupIdAndUserIdValues = workgroupIdAndUserId.values();
				List<Id> workgroupIdAndUserIdKeys = new List<Id>(workgroupIdAndUserId.keySet());
				
				for(CH_Workgroup_Member__c oWorkgroupMember: oCH_WorkgroupMember){
					if(oWorkgroupMember.RecordTypeId == workgroupMemberRT && oWorkgroupMember.CH_Owner__c == false) {
						if(workgroupIdAndUserIdValues.contains(oWorkgroupMember.CH_UserId__c)){
							workgroupShareIdSetToDelete.add(workgroupIdAndUserIdKeys.get(workgroupIdAndUserIdValues.indexOf((oWorkgroupMember.CH_UserId__c))));
						}
					}
				}
				
				if(!workgroupShareIdSetToDelete.isEmpty()){
					workgroupShareListToDelete = CH_EM_Workgroup.getAllWorkgroupSharesById(workgroupShareIdSetToDelete);
					if(!workgroupShareListToDelete.isEmpty()){
						CH_EM_Workgroup.doDeleteCHWorkgroupShareList(workgroupShareListToDelete);
					}
				}   
			}
		}
	}
	
	/*
	TO DELETE - START
	*/
	
	/*
	* @description : 
	* @param : List<CH_Workgroup_Member__c> New list
	* @param : List<CH_Workgroup_Member__c> Old list
	* @return : void
	*/
	public static void workgroupMemberToWorkgroupAdmin(List<CH_Workgroup_Member__c> oNewWorkgroupMember, List<CH_Workgroup_Member__c> oOldWorkgroupMember, String action) {
		final Id workgroupMemberRT = Utils.MapRecordType('CH_Workgroup_Member__c').get('CH_KB_Workgroup_Members');
		List<CH_Workgroup_Admin__c> oWorkgroupAdmin = new List<CH_Workgroup_Admin__c>();
		switch on action {
			when 'updateowner' {
				for(CH_Workgroup_Member__c newWorkgroupMember: oNewWorkgroupMember){
					if(newWorkgroupMember.RecordTypeId == workgroupMemberRT) {
						for(CH_Workgroup_Member__c oldWorkgroupMember: oOldWorkgroupMember){
							if(newWorkgroupMember.Id == oldWorkgroupMember.Id){
								oWorkgroupAdmin.add(new CH_Workgroup_Admin__c(
									CH_Action__c = 'updateWorkgroupOwner',
									CH_OldWorkgroupMemberUserOwner__c = oldWorkgroupMember.CH_Owner__c,
									CH_OldWorkgroupId__c = oldWorkgroupMember.CH_WorkgroupId__c,
									CH_OldWorkgroupMemberUserRecordType__c = oldWorkgroupMember.RecordTypeId,
									CH_NewWorkgroupMemberUserOwner__c = newWorkgroupMember.CH_Owner__c,
									CH_NewWorkgroupId__c = newWorkgroupMember.CH_WorkgroupId__c,
									CH_NewWorkgroupMemberUserRecordType__c = newWorkgroupMember.RecordTypeId
								));							
							}
						} 
					}
				}   
			}
			when 'assign' {
				for(CH_Workgroup_Member__c newWorkgroupMember: oNewWorkgroupMember){
					if(newWorkgroupMember.RecordTypeId == workgroupMemberRT) {
						oWorkgroupAdmin.add(new CH_Workgroup_Admin__c(
							CH_Action__c = 'assignWorkgroupMember',
							CH_NewWorkgroupMemberUserId__c = newWorkgroupMember.CH_User__c,
							CH_NewWorkgroupMemberUserRole__c = newWorkgroupMember.CH_Role__c,
							CH_NewWorkgroupMemberUserOwner__c = newWorkgroupMember.CH_Owner__c,
							CH_NewWorkgroupId__c = newWorkgroupMember.CH_WorkgroupId__c,
							CH_NewWorkgroupMemberUserRecordType__c = newWorkgroupMember.RecordTypeId
						));
					}
				}
			}
			when 'remove' {
				for(CH_Workgroup_Member__c oldWorkgroupMember: oOldWorkgroupMember){
					if(oldWorkgroupMember.RecordTypeId == workgroupMemberRT) {
						oWorkgroupAdmin.add(new CH_Workgroup_Admin__c(
							CH_Action__c = 'removeWorkgroupMember',
							CH_OldWorkgroupMemberUserId__c = oldWorkgroupMember.CH_User__c,
							CH_OldWorkgroupMemberUserRole__c = oldWorkgroupMember.CH_Role__c,
							CH_OldWorkgroupMemberUserOwner__c = oldWorkgroupMember.CH_Owner__c,
							CH_OldWorkgroupId__c = oldWorkgroupMember.CH_WorkgroupId__c,
							CH_OldWorkgroupMemberUserRecordType__c = oldWorkgroupMember.RecordTypeId
						));
					}
				}				
			}
			when 'update' {
				for(CH_Workgroup_Member__c newWorkgroupMember: oNewWorkgroupMember){
					if(newWorkgroupMember.RecordTypeId == workgroupMemberRT) {
						for(CH_Workgroup_Member__c oldWorkgroupMember: oOldWorkgroupMember){
							if(newWorkgroupMember.Id == oldWorkgroupMember.Id){
								oWorkgroupAdmin.add(new CH_Workgroup_Admin__c(
									CH_Action__c = 'updateWorkgroupMember',
									CH_OldWorkgroupMemberUserId__c = oldWorkgroupMember.CH_User__c,
									CH_OldWorkgroupMemberUserRole__c = oldWorkgroupMember.CH_Role__c,
									CH_OldWorkgroupMemberUserOwner__c = oldWorkgroupMember.CH_Owner__c,
									CH_OldWorkgroupId__c = oldWorkgroupMember.CH_WorkgroupId__c,
									CH_OldWorkgroupMemberUserRecordType__c = oldWorkgroupMember.RecordTypeId,
									CH_NewWorkgroupMemberUserId__c = newWorkgroupMember.CH_User__c,
									CH_NewWorkgroupMemberUserRole__c = newWorkgroupMember.CH_Role__c,
									CH_NewWorkgroupMemberUserOwner__c = newWorkgroupMember.CH_Owner__c,
									CH_NewWorkgroupId__c = newWorkgroupMember.CH_WorkgroupId__c,
									CH_NewWorkgroupMemberUserRecordType__c = newWorkgroupMember.RecordTypeId
								));							
							}
						} 
					}
				}				
			}
			when else {
				//Do Nothing
			}
		} 
		if(!oWorkgroupAdmin.isEmpty()){
			insert oWorkgroupAdmin;
		}
	}
	
	/*
	* @description : CH_UserId__c based on User__c in order to run the Duplicate Rules
	* @param : List<CH_Workgroup_Member__c>
	* @return : void
	*/
	public static void updateWorkgroupOwnerOnChildUpdate(List<CH_Workgroup_Member__c> oNewCH_WorkgroupMember, List<CH_Workgroup_Member__c> oOldCH_WorkgroupMember) {
		final Id workgroupMemberRT = Utils.MapRecordType('CH_Workgroup_Member__c').get('CH_KB_Workgroup_Members');
	Set<Id> workgroupIds = new Set<Id>();
		Map<String, Id> queueNameToId = new Map<String,Id>();
		List<CH_Workgroup__c> oCH_Workgroup = new List<CH_Workgroup__c>();
		
		for(CH_Workgroup_Member__c oldWorkgroupMember: oOldCH_WorkgroupMember){
			for(CH_Workgroup_Member__c newWorkgroupMember: oNewCH_WorkgroupMember){
				if(oldWorkgroupMember.Id == newWorkgroupMember.Id && newWorkgroupMember.CH_Owner__c != oldWorkgroupMember.CH_Owner__c && newWorkgroupMember.CH_Owner__c == true){
		  workgroupIds.add(newWorkgroupMember.CH_WorkgroupId__c);
		}
			}
		}

		if(!workgroupIds.isEmpty()){
			oCH_Workgroup = CH_EM_Workgroup.getWorkgroupById(workgroupIds);
			if(!oCH_Workgroup.isEmpty()){
				for(Group queue : EM_Group.getAllQueues()){
					queueNameToId.put(queue.Name, queue.Id);
				}
				for(CH_Workgroup__c oWorkgroup: oCH_Workgroup){
					oWorkgroup.OwnerId = queueNameToId.get('CH_' + oWorkgroup.Name+ '_' + 'OwnerQueue');
				}
				if(!oCH_Workgroup.isEmpty()){
					update oCH_Workgroup;
				}
			}
		}
	}

	/*
	* @description : Assign To Queue and Permissions
	* @param : List<CH_Workgroup_Member__c> new list
	* @return : void
	*/
	public static void assignPermissionSetAndQueueBasedOnRole(List<CH_Workgroup_Member__c> oCH_WorkgroupMember) {
		final Id workgroupMemberRT = Utils.MapRecordType('CH_Workgroup_Member__c').get('CH_KB_Workgroup_Members');
		Map<Id,String> userRoleMapIds = new Map<Id,String>();
		Map<Id,String> userOwnerMapIds = new Map<Id,String>();
		Map<String,Map<Id,Id>> QueueMapList = new Map<String,Map<Id,Id>>{
				//'Approver' => new Map<Id,Id>(),
				//'Publisher' => new Map<Id,Id>(),
				'Member' => new Map<Id,Id>(),
				'CH_Internal_Approver' => new Map<Id,Id>(),
				'CH_External_Approver' => new Map<Id,Id>()
		};

		for(CH_Workgroup_Member__c oWorkgroupMember: oCH_WorkgroupMember){
			if(oWorkgroupMember.RecordTypeId == workgroupMemberRT) {
				userRoleMapIds.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_Role__c);
				Map<Id,Id> userIdMemberQueueMapToAdd = QueueMapList.get('Member');
				userIdMemberQueueMapToAdd.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
				QueueMapList.put('Member', userIdMemberQueueMapToAdd);
				/*if(oWorkgroupMember.CH_Role__c == 'Internal Approver (Approver)'){
					Map<Id,Id> userIdQueueMapToAdd = QueueMapList.get('Approver');
					userIdQueueMapToAdd.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
					QueueMapList.put('Approver', userIdQueueMapToAdd);
				}
				else if(oWorkgroupMember.CH_Role__c == 'Public Approver (Publisher)'){
					Map<Id,Id> userIdQueueMapToAdd = QueueMapList.get('Publisher');
					userIdQueueMapToAdd.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
					QueueMapList.put('Publisher', userIdQueueMapToAdd);
				}*/
				if(oWorkgroupMember.CH_Owner__c == true){
					userOwnerMapIds.put(oWorkgroupMember.CH_User__c, 'Owner');
				}
			}
		}
		//assign from queues
		for(String role : QueueMapList.keySet()){
			Map<Id,Id> userIdQueueMapToRemove = QueueMapList.get(role);
			if(!userIdQueueMapToRemove.isEmpty()){
				assignUserToQueue(userIdQueueMapToRemove, role);
			}
		}
		//assign permissions
		if(!userRoleMapIds.isEmpty() || !userOwnerMapIds.isEmpty()){
			managePermissionSetToUserId(userRoleMapIds, userOwnerMapIds, 'add');
		}
		//assign public groups
		if(!userRoleMapIds.isEmpty()){
			managePublicGroupsToUserId(userRoleMapIds, new Map<Id,String>(), 'add');
		}
	}

	/*
	* @description : Remove/Update From Queue and Permissions
	* @param : List<CH_Workgroup_Member__c> old list
	* @return : void
	*/
	public static void removePermissionSetAndQueueBasedOnRole(List<CH_Workgroup_Member__c> oCH_WorkgroupMember) {
		final Id workgroupMemberRT = Utils.MapRecordType('CH_Workgroup_Member__c').get('CH_KB_Workgroup_Members');
		Map<Id,String> userRoleMapIds = new Map<Id,String>();
		Map<Id,String> userWorkGroupMapIds = new Map<Id,String>();
		Map<Id,String> userOwnerMapIds = new Map<Id,String>();
		Map<String,Map<Id,Id>> QueueMapList = new Map<String,Map<Id,Id>>{
				//'Approver' => new Map<Id,Id>(),
				//'Publisher' => new Map<Id,Id>(),
				'Member' => new Map<Id,Id>()//,
		};

		for(CH_Workgroup_Member__c oWorkgroupMember: oCH_WorkgroupMember){
			if(oWorkgroupMember.CH_User__c != null && oWorkgroupMember.CH_Role__c != null && oWorkgroupMember.RecordTypeId == workgroupMemberRT) {
				userRoleMapIds.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_Role__c);
				userWorkGroupMapIds.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
				Map<Id,Id> userIdMemberQueueMapToRemove = QueueMapList.get('Member');
				userIdMemberQueueMapToRemove.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
				QueueMapList.put('Member', userIdMemberQueueMapToRemove);
				/*if(oWorkgroupMember.CH_Role__c == 'Internal Approver (Approver)'){
					Map<Id,Id> userIdQueueMapToRemove = QueueMapList.get('Approver');
					userIdQueueMapToRemove.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
					QueueMapList.put('Approver', userIdQueueMapToRemove);
				}
				else if(oWorkgroupMember.CH_Role__c == 'Public Approver (Publisher)'){
					Map<Id,Id> userIdQueueMapToRemove = QueueMapList.get('Publisher');
					userIdQueueMapToRemove.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
					QueueMapList.put('Publisher', userIdQueueMapToRemove);
				}*/
				if(oWorkgroupMember.CH_Owner__c == true){
					userOwnerMapIds.put(oWorkgroupMember.CH_User__c, 'Owner');
				}
			}
		}
		//remove from queues
		if(!QueueMapList.isEmpty()){
			for(String role : QueueMapList.keySet()){
				Map<Id,Id> userIdQueueMapToRemove = QueueMapList.get(role);
				if(!userIdQueueMapToRemove.isEmpty()){
					removeUserFromQueue(userIdQueueMapToRemove, role);
				}
			}
		}
		//delete permissions
		if(!userRoleMapIds.isEmpty() || !userOwnerMapIds.isEmpty()){
			Map<Id,Boolean> userHasOwnerMap = hasRoleInOthersWorkgroups(userOwnerMapIds, userWorkGroupMapIds);
			for(Id userId : userHasOwnerMap.keySet()){
				if(userHasOwnerMap.get(userId) == true){
					userOwnerMapIds.remove(userId);
				}
			}
			Map<Id,Boolean> userHasRoleMap = hasRoleInOthersWorkgroups(userRoleMapIds, userWorkGroupMapIds);
			for(Id userId : userHasRoleMap.keySet()){
				if(userHasRoleMap.get(userId) == true){
					userRoleMapIds.remove(userId);
				}
			}
			managePermissionSetToUserId(userRoleMapIds, userOwnerMapIds, 'delete');
			//UserRoles
			Map<Id,String> userRolesMap = userRolesInOthersWorkgroups(userRoleMapIds, userWorkGroupMapIds);
			//delete public groups
			managePublicGroupsToUserId(userRoleMapIds, userRolesMap, 'delete');
			//remove from default queues ('CH_Internal_Approver AND CH_External_Approver')
			deleteDefaultQueuesToUserId(userRoleMapIds, userRolesMap);
		}
	}

	/*
	* @description : Update Queue and Permissions
	* @param : List<CH_Workgroup_Member__c> new list
	* @param : List<CH_Workgroup_Member__c> old list
	* @return : void
	*/
	public static void updatePermissionSetAndQueueBasedOnRole(List<CH_Workgroup_Member__c> oNewCH_WorkgroupMember, List<CH_Workgroup_Member__c> oOldCH_WorkgroupMember) {
		final Id workgroupMemberRT = Utils.MapRecordType('CH_Workgroup_Member__c').get('CH_KB_Workgroup_Members');
		List<CH_Workgroup_Member__c> oNewCH_WorkgroupMemberToAdd = new List<CH_Workgroup_Member__c>();
		List<CH_Workgroup_Member__c> oOldCH_WorkgroupMemberToRemove = new List<CH_Workgroup_Member__c>();
		List<CH_Workgroup_Member__c> oCH_WorkgroupMemberForWorkgroupUpdate = new List<CH_Workgroup_Member__c>();

		for(CH_Workgroup_Member__c oldWorkgroupMember: oOldCH_WorkgroupMember){
			for(CH_Workgroup_Member__c newWorkgroupMember: oNewCH_WorkgroupMember){
				if(oldWorkgroupMember.Id == newWorkgroupMember.Id && newWorkgroupMember.CH_Role__c != oldWorkgroupMember.CH_Role__c ||
				   oldWorkgroupMember.Id == newWorkgroupMember.Id && newWorkgroupMember.CH_Owner__c != oldWorkgroupMember.CH_Owner__c){
					   oOldCH_WorkgroupMemberToRemove.add(oldWorkgroupMember);
					   oNewCH_WorkgroupMemberToAdd.add(newWorkgroupMember);
		}
			}
		}
		if(!oOldCH_WorkgroupMemberToRemove.isEmpty()){
			removePermissionSetAndQueueBasedOnRole(oOldCH_WorkgroupMemberToRemove);
		}
		if(!oNewCH_WorkgroupMemberToAdd.isEmpty()){
			assignPermissionSetAndQueueBasedOnRole(oNewCH_WorkgroupMemberToAdd);
		}
	}

	@future
	private static void managePermissionSetToUserId(Map<Id,String> userRoleMapIds, Map<Id,String> userOwnerMapIds, String action){
		Map<String,Id> permissionKBMap = new Map<String,Id>{
				'Author' => Utils.getPermissionSetIdByPermissionSetName('CH_Author'),
				'Internal Approver (Approver)' => Utils.getPermissionSetIdByPermissionSetName('CH_Approver'),
				'Public Approver (Publisher)' => Utils.getPermissionSetIdByPermissionSetName('CH_Publisher'),
				'Owner' => Utils.getPermissionSetIdByPermissionSetName('CH_KB_Workgroup_Owner'),
				'Report' => Utils.getPermissionSetIdByPermissionSetName('CH_Report_User')
		};
		List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();

		for(Id userId: userRoleMapIds.keySet()) {
			PermissionSetAssignment psa1 = new PermissionSetAssignment(
					PermissionSetId = permissionKBMap.get(userRoleMapIds.get(userId)),
					AssigneeId = userId
			);
			permissionSetList.add(psa1);

			PermissionSetAssignment psa2 = new PermissionSetAssignment(
					PermissionSetId = permissionKBMap.get('Report'),
					AssigneeId = userId
			);
			permissionSetList.add(psa2);
		}
		for(Id userId: userOwnerMapIds.keySet()) {
			PermissionSetAssignment psa3 = new PermissionSetAssignment(
					PermissionSetId = permissionKBMap.get('Owner'),
					AssigneeId = userId
			);
			permissionSetList.add(psa3);

			PermissionSetAssignment psa4 = new PermissionSetAssignment(
					PermissionSetId = permissionKBMap.get('Report'),
					AssigneeId = userId
			);
			permissionSetList.add(psa4);
		}
		if(!permissionSetList.isEmpty()){
			if(action == 'add'){
				EM_PermissionSetAssignment.doUpsertPermissionSetAssignmentList(permissionSetList);
			}
			else if(action == 'delete'){
				List<PermissionSetAssignment> permissionSetListToDelete = new List<PermissionSetAssignment>();
				for(PermissionSetAssignment curPermissionSetAssignment : EM_PermissionSetAssignment.getAllPermissionSetAssignments(new Set<Id>(permissionKBMap.values()))){
					for(PermissionSetAssignment curpermissionSetList : permissionSetList){
						if(curPermissionSetAssignment.PermissionSetId == curpermissionSetList.PermissionSetId && curPermissionSetAssignment.PermissionSetId == curpermissionSetList.PermissionSetId){
							permissionSetListToDelete.add(curPermissionSetAssignment);
						}
					}
				}
				EM_PermissionSetAssignment.doDeletePermissionSetAssignmentList(permissionSetListToDelete);
			}
			else system.debug('Invalid Action.');
		}
	}

	@future
	private static void deleteDefaultQueuesToUserId(Map<Id,String> userRoleMapIds, Map<Id,String> userRolesMap){
		Map<String,Id> publicGroupKBMap = new Map<String,Id>{
				'Internal Approver (Approver)' => Utils.getQueueIdByApiName('CH_Internal_Approver'),
				'Public Approver (Publisher)' => Utils.getQueueIdByApiName('CH_External_Approver')
		};
		List<GroupMember> groupMemberList = new List<GroupMember>();
		for(Id userId: userRoleMapIds.keySet()) {
			if(userRoleMapIds.get(userId) == 'Public Approver (Publisher)' || userRoleMapIds.get(userId) == 'Internal Approver (Approver)' && userRolesMap.get(userId).indexOf('Public Approver (Publisher)') == -1){
				groupMemberList.add(new GroupMember(
					GroupId = publicGroupKBMap.get(userRoleMapIds.get(userId)),
					UserOrGroupId = userId
				));   
			}	 
			if(userRoleMapIds.get(userId) == 'Public Approver (Publisher)' && userRolesMap.get(userId).indexOf('Internal Approver (Approver)') == -1){
				groupMemberList.add(new GroupMember(
					GroupId = publicGroupKBMap.get('Internal Approver (Approver)'),
					UserOrGroupId = userId
				));
			}
		}

		if(!groupMemberList.isEmpty()){
			List<GroupMember> groupMemberListToDelete = new List<GroupMember>();
			for(GroupMember curGroupMember : EM_GroupMember.getAll(new Set<Id>(publicGroupKBMap.values()))){
				for(GroupMember curGroupMemberList : groupMemberList){
					if(curGroupMember.GroupId == curGroupMemberList.GroupId && curGroupMember.GroupId == curGroupMemberList.GroupId){
						groupMemberListToDelete.add(curGroupMember);
					}
				}
			}
			EM_GroupMember.doDeleteGroupMemberList(groupMemberListToDelete);
		}
	}

	@future
	private static void managePublicGroupsToUserId(Map<Id,String> userRoleMapIds, Map<Id,String> userRolesMap, String action){
		Map<String,Id> publicGroupKBMap = new Map<String,Id>{
				'Author' => Utils.getPublicGroupIdByApiName('CH_Workgroup_Authors'),
				'Internal Approver (Approver)' => Utils.getPublicGroupIdByApiName('CH_Workgroup_Approvers'),
				'Public Approver (Publisher)' => Utils.getPublicGroupIdByApiName('CH_Workgroup_Publishers')
		};
		List<GroupMember> groupMemberList = new List<GroupMember>();

		for(Id userId: userRoleMapIds.keySet()) {
			if(userRoleMapIds.get(userId) == 'Author'){
				if(action == 'add' || action == 'delete' && userRolesMap.get(userId).indexOf('Internal Approver (Approver)') == -1 || action == 'delete' && userRolesMap.get(userId).indexOf('Public Approver (Publisher)') == -1){
					groupMemberList.add(new GroupMember(
							GroupId = publicGroupKBMap.get('Author'),
							UserOrGroupId = userId
					));
				}
			}
			else if(userRoleMapIds.get(userId) == 'Internal Approver (Approver)'){
				if(action == 'add' || action == 'delete' && userRolesMap.get(userId).indexOf('Author') == -1 || action == 'delete' && userRolesMap.get(userId).indexOf('Public Approver (Publisher)') == -1){
					groupMemberList.add( new GroupMember(
							GroupId = publicGroupKBMap.get('Author'),
							UserOrGroupId = userId
					));
				}
				if(action == 'add' || action == 'delete' && userRolesMap.get(userId).indexOf('Public Approver (Publisher)') == -1){
					groupMemberList.add(new GroupMember(
							GroupId = publicGroupKBMap.get('Internal Approver (Approver)'),
							UserOrGroupId = userId
					));
				}
			}
			else if(userRoleMapIds.get(userId) == 'Public Approver (Publisher)'){
				if(action == 'add' || action == 'delete' && userRolesMap.get(userId).indexOf('Author') == -1 || action == 'delete' && userRolesMap.get(userId).indexOf('Internal Approver (Approver)') == -1){
					groupMemberList.add(new GroupMember(
							GroupId = publicGroupKBMap.get('Author'),
							UserOrGroupId = userId
					));
				}
				if(action == 'add' || action == 'delete' && userRolesMap.get(userId).indexOf('Internal Approver (Approver)') == -1){
					groupMemberList.add(new GroupMember(
							GroupId = publicGroupKBMap.get('Internal Approver (Approver)'),
							UserOrGroupId = userId
					));
				}
				groupMemberList.add(new GroupMember(
						GroupId = publicGroupKBMap.get('Public Approver (Publisher)'),
						UserOrGroupId = userId
				));
			}
		}

		if(!groupMemberList.isEmpty()){
			if(action == 'add'){
				EM_GroupMember.doUpsertGroupMemberList(groupMemberList);
			}
			else if(action == 'delete'){
				List<GroupMember> groupMemberListToDelete = new List<GroupMember>();
				for(GroupMember curGroupMember : EM_GroupMember.getAll(new Set<Id>(publicGroupKBMap.values()))){
					for(GroupMember curGroupMemberList : groupMemberList){
						if(curGroupMember.GroupId == curGroupMemberList.GroupId && curGroupMember.GroupId == curGroupMemberList.GroupId){
							groupMemberListToDelete.add(curGroupMember);
						}
					}
				}
				system.debug('Tiago: '+groupMemberListToDelete);
				EM_GroupMember.doDeleteGroupMemberList(groupMemberListToDelete);
			}
			else system.debug('Invalid Action.');
		}
	}

	@future
	private static void assignUserToQueue(Map<Id,Id> userIdQueueMap, String queueName){
		final Id workgroupRT = Utils.MapRecordType('CH_Workgroup__c').get('CH_KB_Workgroup');
		final Id internalApproverQueueId = Utils.getQueueIdByApiName('CH_Internal_Approver');
		final Id externalApproverQueueId = Utils.getQueueIdByApiName('CH_External_Approver');
		Map<String, Id> queueNameToId = new Map<String,Id>();
		Map<Id,Id> workgroupsToQueue = new Map<Id,Id>();

		for(Group queue : EM_Group.getAllQueues()){
			queueNameToId.put(queue.Name, queue.Id);
		}
		for(CH_Workgroup__c workgroup : CH_EM_Workgroup.getAllWorkgroups(workgroupRT)){
			workgroupsToQueue.put(workgroup.Id, queueNameToId.get('CH_' + workgroup.Name + '_' + queueName + 'Queue'));
		}

		if(!workgroupsToQueue.isEmpty()){
			List<GroupMember> oGroupMember = new List<GroupMember>();
			for (Id key : userIdQueueMap.keySet()) {
				oGroupMember.add(new GroupMember(GroupId = workgroupsToQueue.get(userIdQueueMap.get(key)), UserOrGroupId = key));
				if(queueName == 'Approver'){
					oGroupMember.add(new GroupMember(GroupId = internalApproverQueueId, UserOrGroupId = key));
				} else if (queueName == 'Publisher'){
					oGroupMember.add(new GroupMember(GroupId = internalApproverQueueId, UserOrGroupId = key));
					oGroupMember.add(new GroupMember(GroupId = externalApproverQueueId, UserOrGroupId = key));
				}
			}

			if(!oGroupMember.isEmpty()){
				EM_GroupMember.doUpsertGroupMemberList(oGroupMember);
			}
		}
	}

	@future
	private static void removeUserFromQueue(Map<Id,Id> userIdQueueMap, String queueName){
		final Id workgroupRT = Utils.MapRecordType('CH_Workgroup__c').get('CH_KB_Workgroup');
		Map<String, Id> queueNameToId = new Map<String,Id>();
		Map<Id,Id> workgroupsToQueue = new Map<Id,Id>();
		for(Group queue : EM_Group.getAllQueues()){
			queueNameToId.put(queue.Name, queue.Id);
		}
		for(CH_Workgroup__c workgroup : CH_EM_Workgroup.getAllWorkgroups(workgroupRT)){
			workgroupsToQueue.put(workgroup.Id, queueNameToId.get('CH_' + workgroup.Name+ '_'+queueName+'Queue'));
		}
		if(!workgroupsToQueue.isEmpty()){
			List<GroupMember> oGroupMember = new List<GroupMember>();
			for(GroupMember groupMember : EM_GroupMember.getAll(new Set<Id>(workgroupsToQueue.values()))){
				if(groupMember.GroupId == workgroupsToQueue.get(userIdQueueMap.get(groupMember.UserOrGroupId))){
					oGroupMember.add(groupMember);
				}
			}
			EM_GroupMember.doDeleteGroupMemberList(oGroupMember);
		}
	}

	private static Map<Id,boolean> hasRoleInOthersWorkgroups(Map<Id,String> userRoleMap, Map<Id,String> userWorkGroupMapIds){
		Map<Id,boolean> result = new Map<Id,boolean>();
		List<CH_Workgroup_Member__c> workgroupMembers = CH_EM_WorkgroupMember.getAllWorkgroupMembersPerUser(userRoleMap.keySet());
		if(!workgroupMembers.isEmpty()){
			for(Id userId : userRoleMap.keySet()){
				Boolean hasRole = false;
				for(CH_Workgroup_Member__c workgroupMember : workgroupMembers){
					if(workgroupMember.CH_User__c == userId && workgroupMember.CH_WorkgroupId__c != userWorkGroupMapIds.get(userId)){
						if(workgroupMember.CH_Role__c == userRoleMap.get(userId) && userRoleMap.get(userId) != 'Owner' ||
								workgroupMember.CH_Owner__c == true && userRoleMap.get(userId) == 'Owner'){
							hasRole= true;
							break;
						}						
					}
				}
				result.put(userId, hasRole);
			}
		}
		return result;
	}

	private static Map<Id,String> userRolesInOthersWorkgroups(Map<Id,String> userRoleMap, Map<Id,String> userWorkGroupMapIds){
		Map<Id,String> result = new Map<Id,String>();
		List<CH_Workgroup_Member__c> workgroupMembers = CH_EM_WorkgroupMember.getAllWorkgroupMembersPerUser(userRoleMap.keySet());
		if(!workgroupMembers.isEmpty()){
			for(Id userId : userRoleMap.keySet()){
				String roles = '';
				for(CH_Workgroup_Member__c workgroupMember : workgroupMembers){
					if(workgroupMember.CH_User__c == userId && workgroupMember.CH_WorkgroupId__c != userWorkGroupMapIds.get(userId)){
						if(roles.indexOf(workgroupMember.CH_Role__c) == -1){
							roles= roles+workgroupMember.CH_Role__c+',';
						}
					}
				}
				result.put(userId, roles.removeEnd(','));
			}
		}
		return result;
	}
	
	/*
	TO DELETE - END
	*/
}