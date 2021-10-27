public without sharing class CH_ManagePSAndQueueToWGMemberAsynchQueue implements Queueable {
	@testVisible
	private static Boolean doChainJob = true;
	
	List<CH_Workgroup_Member__c> oOldCH_WorkgroupMember = new List<CH_Workgroup_Member__c>();
	List<CH_Workgroup_Member__c> oNewCH_WorkgroupMember = new List<CH_Workgroup_Member__c>();
	String action = '';

	public CH_ManagePSAndQueueToWGMemberAsynchQueue(List<CH_Workgroup_Member__c> oOldCH_WorkgroupMember, List<CH_Workgroup_Member__c> oNewCH_WorkgroupMember, String action) {
		this.oOldCH_WorkgroupMember = oOldCH_WorkgroupMember;
		this.oNewCH_WorkgroupMember = oNewCH_WorkgroupMember;
		this.action = action;
	}
	
	public void execute(QueueableContext context) {
		final Id workgroupMemberRT = Utils.MapRecordType('CH_Workgroup_Member__c').get('CH_KB_Workgroup_Members');
		final Id workgroupRT = Utils.MapRecordType('CH_Workgroup__c').get('CH_KB_Workgroup');
		final Id internalApproverQueueId = Utils.getQueueIdByApiName('CH_Internal_Approver');
		final Id externalApproverQueueId = Utils.getQueueIdByApiName('CH_External_Approver');
		Map<Id,String> userRoleMapIds = new Map<Id,String>();
		Map<Id,Boolean> userOnlyPublisherIds = new Map<Id,Boolean>();
		Map<Id,String> userWorkGroupMapIds = new Map<Id,String>();
		Map<Id,String> userOwnerMapIds = new Map<Id,String>();
		Map<String,Map<Id,Id>> QueueMapList = new Map<String,Map<Id,Id>>{
				'A' => new Map<Id,Id>(),
				'P' => new Map<Id,Id>(),
				'O' => new Map<Id,Id>()
		};
		Map<Id,Id> userIdQueueMap = new Map<Id,Id>();
			  
		Map<String,Id> permissionKBMap = new Map<String,Id>{
				'Author' => Utils.getPermissionSetIdByPermissionSetName('CH_Author'),
				'Internal Approver (Approver)' => Utils.getPermissionSetIdByPermissionSetName('CH_Approver'),
				'Public Approver (Publisher)' => Utils.getPermissionSetIdByPermissionSetName('CH_Publisher'),
				'Owner' => Utils.getPermissionSetIdByPermissionSetName('CH_KB_Workgroup_Owner'),
				'Report' => Utils.getPermissionSetIdByPermissionSetName('CH_Report_User')
		};
		List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
		
		Map<String,Id> publicGroupKBMap = new Map<String,Id>{
			'Author' => Utils.getPublicGroupIdByApiName('CH_Workgroup_Authors'),
			'Internal Approver (Approver)' => Utils.getPublicGroupIdByApiName('CH_Workgroup_Approvers'),
			'Public Approver (Publisher)' => Utils.getPublicGroupIdByApiName('CH_Workgroup_Publishers')
		};
					
		List<GroupMember> groupMemberList = new List<GroupMember>();
		Map<String,Id> defaultQueueKBMap = new Map<String,Id>{
			'Internal Approver (Approver)' => Utils.getQueueIdByApiName('CH_Internal_Approver'),
			'Public Approver (Publisher)' => Utils.getQueueIdByApiName('CH_External_Approver')
		};
		List<GroupMember> groupMemberQueueList = new List<GroupMember>();
		
		if(action.equals('update') || action.equals('remove')){
			for(CH_Workgroup_Member__c oWorkgroupMember: oOldCH_WorkgroupMember){
				if(oWorkgroupMember.CH_User__c != null && oWorkgroupMember.CH_Role__c != null && oWorkgroupMember.RecordTypeId == workgroupMemberRT) {
					if(action.equals('remove')){
						userRoleMapIds.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_Role__c);
						userOnlyPublisherIds.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_Only_Publisher__c);
						userWorkGroupMapIds.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
						if(oWorkgroupMember.CH_Role__c.equals('Internal Approver (Approver)') || oWorkgroupMember.CH_Role__c.equals('Public Approver (Publisher)') && !oWorkgroupMember.CH_Only_Publisher__c){
							Map<Id,Id> userIdQueueMapToRemove = QueueMapList.get('A');
							userIdQueueMapToRemove.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
							QueueMapList.put('A', userIdQueueMapToRemove);
						}
						if(oWorkgroupMember.CH_Role__c.equals('Public Approver (Publisher)')){
							Map<Id,Id> userIdQueueMapToRemove = QueueMapList.get('P');
							userIdQueueMapToRemove.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
							QueueMapList.put('P', userIdQueueMapToRemove);
						}
						if(oWorkgroupMember.CH_Owner__c == true){
							userOwnerMapIds.put(oWorkgroupMember.CH_User__c, 'Owner');
							Map<Id,Id> userIdQueueMapToRemove = QueueMapList.get('O');
							userIdQueueMapToRemove.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
							QueueMapList.put('O', userIdQueueMapToRemove);
						}
					}
					else if(action.equals('update')){
						for(CH_Workgroup_Member__c oNewWorkgroupMember: oNewCH_WorkgroupMember){
							if(oNewWorkgroupMember.CH_User__c != null && oWorkgroupMember.CH_User__c == oNewWorkgroupMember.CH_User__c ) {
								if(oWorkgroupMember.CH_Role__c != oNewWorkgroupMember.CH_Role__c || oWorkgroupMember.CH_Owner__c != oNewWorkgroupMember.CH_Owner__c || oWorkgroupMember.CH_Only_Publisher__c != oNewWorkgroupMember.CH_Only_Publisher__c) {
									userRoleMapIds.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_Role__c);
									userOnlyPublisherIds.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_Only_Publisher__c);
									userWorkGroupMapIds.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
									if(oWorkgroupMember.CH_Role__c.equals('Internal Approver (Approver)') || oWorkgroupMember.CH_Role__c.equals('Public Approver (Publisher)') && !oWorkgroupMember.CH_Only_Publisher__c){
										Map<Id,Id> userIdQueueMapToRemove = QueueMapList.get('A');
										userIdQueueMapToRemove.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
										QueueMapList.put('A', userIdQueueMapToRemove);
									}
									if(oWorkgroupMember.CH_Role__c.equals('Public Approver (Publisher)')){
										Map<Id,Id> userIdQueueMapToRemove = QueueMapList.get('P');
										userIdQueueMapToRemove.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
										QueueMapList.put('P', userIdQueueMapToRemove);
									}
									if(oWorkgroupMember.CH_Owner__c == true){
										userOwnerMapIds.put(oWorkgroupMember.CH_User__c, 'Owner');
										Map<Id,Id> userIdQueueMapToRemove = QueueMapList.get('O');
										userIdQueueMapToRemove.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
										QueueMapList.put('O', userIdQueueMapToRemove);
									}
								}
							}
						}
					}
				}
			}
			
			//remove from queues
			if(!QueueMapList.isEmpty()){
				Map<String, Id> queueNameToId = new Map<String,Id>();
				for(Group queue : EM_Group.getAllQueues()){
					queueNameToId.put(queue.Name, queue.Id);
				}
				
				Map<String,Id> workgroupsToQueue = new Map<String,Id>();
				for(CH_Workgroup__c workgroup : CH_EM_Workgroup.getAllWorkgroups(workgroupRT)){
					for(String role : QueueMapList.keySet()){
						workgroupsToQueue.put(workgroup.Id+role, queueNameToId.get(workgroup.Name + '_' + role + 'Q'));
					}
				}
							
				if(!workgroupsToQueue.isEmpty()){
					List<GroupMember> allGroupMembers = EM_GroupMember.getAll(new Set<Id>(workgroupsToQueue.values()));
					for(String role : QueueMapList.keySet()){
						Map<Id,Id> userIdQueueMapToAdd = QueueMapList.get(role);
						if(!userIdQueueMapToAdd.isEmpty()){
							List<GroupMember> oGroupMember = new List<GroupMember>();
							for(GroupMember groupMember : allGroupMembers){
								if(groupMember.GroupId.equals(workgroupsToQueue.get(userIdQueueMapToAdd.get(groupMember.UserOrGroupId)+role))){
									oGroupMember.add(groupMember);
								}
							}
							if(!oGroupMember.isEmpty()){
								EM_GroupMember.doDeleteGroupMemberList(oGroupMember);
							}
						}
					}
				}
			}
			
			//delete permissions
			if(!userRoleMapIds.isEmpty() || !userOwnerMapIds.isEmpty()){
				Map<Id,Boolean> userHasOwnerMap = Utils.hasRoleInOthersWorkgroups(userOwnerMapIds, userWorkGroupMapIds);
				for(Id userId : userHasOwnerMap.keySet()){
					if(userHasOwnerMap.get(userId) == true){
						userOwnerMapIds.remove(userId);
					}
				}
				Map<Id,Boolean> userHasRoleMap = Utils.hasRoleInOthersWorkgroups(userRoleMapIds, userWorkGroupMapIds);
				for(Id userId : userHasRoleMap.keySet()){
					if(userHasRoleMap.get(userId) == true){
						userRoleMapIds.remove(userId);
					}
				}
				
				for(Id userId: userRoleMapIds.keySet()) {
					permissionSetList.add(new PermissionSetAssignment(PermissionSetId = permissionKBMap.get(userRoleMapIds.get(userId)), AssigneeId = userId));
				}
				for(Id userId: userOwnerMapIds.keySet()) {
					permissionSetList.add(new PermissionSetAssignment(PermissionSetId = permissionKBMap.get('Owner'), AssigneeId = userId));
				}
				if(!permissionSetList.isEmpty()){
					List<PermissionSetAssignment> permissionSetListToDelete = new List<PermissionSetAssignment>();
					for(PermissionSetAssignment curPermissionSetAssignment : EM_PermissionSetAssignment.getAllPermissionSetAssignments(new Set<Id>(permissionKBMap.values()))){
						for(PermissionSetAssignment curpermissionSetList : permissionSetList){
							if(curPermissionSetAssignment.PermissionSetId == curpermissionSetList.PermissionSetId && curPermissionSetAssignment.AssigneeId == curpermissionSetList.AssigneeId){
								permissionSetListToDelete.add(curPermissionSetAssignment);
							}
						}
					}
					if(!permissionSetListToDelete.isEmpty()){
						EM_PermissionSetAssignment.doDeletePermissionSetAssignmentList(permissionSetListToDelete);
					}
				}		   
				
				//UserRoles
				Map<Id,String> userRolesMap = Utils.userRolesInOthersWorkgroups(userRoleMapIds, userWorkGroupMapIds);
				
				//delete public groups
	
				if(!userRoleMapIds.isEmpty()){
					for(Id userId: userRoleMapIds.keySet()) {
						if(userRoleMapIds.get(userId).equals('Author')){
							if(userRolesMap.get(userId).indexOf('Internal Approver (Approver)') == -1 && userRolesMap.get(userId).indexOf('Public Approver (Publisher)') == -1){
								groupMemberList.add(new GroupMember(
										GroupId = publicGroupKBMap.get('Author'),
										UserOrGroupId = userId
								));
							}
						}
						else if(userRoleMapIds.get(userId).equals('Internal Approver (Approver)')){
							if(userRolesMap.get(userId).indexOf('Author') == -1 && userRolesMap.get(userId).indexOf('Public Approver (Publisher)') == -1){
								groupMemberList.add( new GroupMember(
										GroupId = publicGroupKBMap.get('Author'),
										UserOrGroupId = userId
								));
							}
							if(userRolesMap.get(userId).indexOf('Public Approver (Publisher)') == -1){
								groupMemberList.add(new GroupMember(
										GroupId = publicGroupKBMap.get('Internal Approver (Approver)'),
										UserOrGroupId = userId
								));
							}
						}
						else if(userRoleMapIds.get(userId).equals('Public Approver (Publisher)')){
							if(userRolesMap.get(userId).indexOf('Author') == -1 && userRolesMap.get(userId).indexOf('Internal Approver (Approver)') == -1){
								groupMemberList.add(new GroupMember(GroupId = publicGroupKBMap.get('Author'), UserOrGroupId = userId));
							}
							if(userRolesMap.get(userId).indexOf('Internal Approver (Approver)') == -1 && !userOnlyPublisherIds.get(userId)){
								groupMemberList.add(new GroupMember(GroupId = publicGroupKBMap.get('Internal Approver (Approver)'), UserOrGroupId = userId));
							}
							groupMemberList.add(new GroupMember(GroupId = publicGroupKBMap.get('Public Approver (Publisher)'), UserOrGroupId = userId));
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
			
					if(!groupMemberQueueList.isEmpty()){
						List<GroupMember> groupMemberListToDelete = new List<GroupMember>();
						for(GroupMember curGroupMember : EM_GroupMember.getAll(new Set<Id>(defaultQueueKBMap.values()))){
							for(GroupMember curGroupMemberList : groupMemberQueueList){
								if(curGroupMember.GroupId == curGroupMemberList.GroupId && curGroupMember.GroupId == curGroupMemberList.GroupId){
									groupMemberListToDelete.add(curGroupMember);
								}
							}
						}
						EM_GroupMember.doDeleteGroupMemberList(groupMemberListToDelete);
					}
				}
			}
			if(action.equals('update')){
				if(test.isRunningTest()){
					doChainJob=false;
				}
				if(doChainJob) {
					System.enqueueJob(new CH_ManagePSAndQueueToWGMemberAsynchQueue(oOldCH_WorkgroupMember,oNewCH_WorkgroupMember,'update assign'));
				}
			}
		}
		else if(action.equals('assign') || action.equals('update assign')){
			for(CH_Workgroup_Member__c oWorkgroupMember: oNewCH_WorkgroupMember){
				if(oWorkgroupMember.RecordTypeId == workgroupMemberRT) {
					if(action.equals('assign')){
						userRoleMapIds.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_Role__c);
						userOnlyPublisherIds.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_Only_Publisher__c);
						userWorkGroupMapIds.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
						if(oWorkgroupMember.CH_Role__c.equals('Internal Approver (Approver)') || oWorkgroupMember.CH_Role__c.equals('Public Approver (Publisher)') && !oWorkgroupMember.CH_Only_Publisher__c){
							Map<Id,Id> userIdQueueMapToAdd = QueueMapList.get('A');
							userIdQueueMapToAdd.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
							QueueMapList.put('A', userIdQueueMapToAdd);
						}
						if(oWorkgroupMember.CH_Role__c.equals('Public Approver (Publisher)')){
							Map<Id,Id> userIdQueueMapToAdd = QueueMapList.get('P');
							userIdQueueMapToAdd.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
							QueueMapList.put('P', userIdQueueMapToAdd);
						}
						if(oWorkgroupMember.CH_Owner__c == true){
							userOwnerMapIds.put(oWorkgroupMember.CH_User__c, 'Owner');
							Map<Id,Id> userIdQueueMapToAdd = QueueMapList.get('O');
							userIdQueueMapToAdd.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
							QueueMapList.put('O', userIdQueueMapToAdd);
						}
					}
					else if(action.equals('update assign')){
						for(CH_Workgroup_Member__c oOldWorkgroupMember: oOldCH_WorkgroupMember){
							if(oOldWorkgroupMember.CH_User__c != null && oWorkgroupMember.CH_User__c == oOldWorkgroupMember.CH_User__c ) {
								if(oWorkgroupMember.CH_Role__c != oOldWorkgroupMember.CH_Role__c || oWorkgroupMember.CH_Owner__c != oOldWorkgroupMember.CH_Owner__c || oWorkgroupMember.CH_Only_Publisher__c != oOldWorkgroupMember.CH_Only_Publisher__c) {
									userRoleMapIds.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_Role__c);
									userOnlyPublisherIds.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_Only_Publisher__c);
									userWorkGroupMapIds.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
									if(oWorkgroupMember.CH_Role__c.equals('Internal Approver (Approver)') || oWorkgroupMember.CH_Role__c.equals('Public Approver (Publisher)') && !oWorkgroupMember.CH_Only_Publisher__c){
										Map<Id,Id> userIdQueueMapToAdd = QueueMapList.get('A');
										userIdQueueMapToAdd.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
										QueueMapList.put('A', userIdQueueMapToAdd);
									}
									if(oWorkgroupMember.CH_Role__c.equals('Public Approver (Publisher)')){
										Map<Id,Id> userIdQueueMapToAdd = QueueMapList.get('P');
										userIdQueueMapToAdd.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
										QueueMapList.put('P', userIdQueueMapToAdd);
									}
									if(oWorkgroupMember.CH_Owner__c == true){
										userOwnerMapIds.put(oWorkgroupMember.CH_User__c, 'Owner');
										Map<Id,Id> userIdQueueMapToAdd = QueueMapList.get('O');
										userIdQueueMapToAdd.put(oWorkgroupMember.CH_User__c, oWorkgroupMember.CH_WorkgroupId__c);
										QueueMapList.put('O', userIdQueueMapToAdd);
									}
								}
							}
						}
					}
				}
			}
			//
			for(CH_Workgroup_Member__c oWorkgroupMember: oNewCH_WorkgroupMember){
				if(oWorkgroupMember.RecordTypeId == workgroupMemberRT) {
				}
			}
			
			//assign from queues
			if(!QueueMapList.isEmpty()){
				Map<String, Id> queueNameToId = new Map<String,Id>();
				for(Group queue : EM_Group.getAllQueues()){
					queueNameToId.put(queue.Name, queue.Id);
				}
				
				Map<String,Id> workgroupsToQueue = new Map<String,Id>();
				for(CH_Workgroup__c workgroup : CH_EM_Workgroup.getAllWorkgroups(workgroupRT)){
					for(String role : QueueMapList.keySet()){
						workgroupsToQueue.put(workgroup.Id+role, queueNameToId.get(workgroup.Name + '_' + role + 'Q'));
					}
				}
				
				List<GroupMember> oGroupMember = new List<GroupMember>();
				for(String role : QueueMapList.keySet()){
					Map<Id,Id> userIdQueueMapToAdd = QueueMapList.get(role);
					if(!userIdQueueMapToAdd.isEmpty()){
						if(!workgroupsToQueue.isEmpty()){
							for (Id key : userIdQueueMapToAdd.keySet()) {
								oGroupMember.add(new GroupMember(GroupId = workgroupsToQueue.get(userIdQueueMapToAdd.get(key)+role), UserOrGroupId = key));
								if(role.equals('A')){
									//oGroupMember.add(new GroupMember(GroupId = internalApproverQueueId, UserOrGroupId = key));
								} else if (role.equals('P')){
									if(!userOnlyPublisherIds.get(key)){
										//oGroupMember.add(new GroupMember(GroupId = internalApproverQueueId, UserOrGroupId = key));
									}
									//oGroupMember.add(new GroupMember(GroupId = externalApproverQueueId, UserOrGroupId = key));
								}
							}
						}
					}
				}
				if(!oGroupMember.isEmpty()){
					EM_GroupMember.doUpsertGroupMemberList(oGroupMember);
				}
			}
			
			//assign permissions
			if(!userRoleMapIds.isEmpty() || !userOwnerMapIds.isEmpty()){
				for(Id userId: userRoleMapIds.keySet()) {
					permissionSetList.add(new PermissionSetAssignment(PermissionSetId = permissionKBMap.get(userRoleMapIds.get(userId)), AssigneeId = userId));
				}
				for(Id userId: userOwnerMapIds.keySet()) {
					permissionSetList.add(new PermissionSetAssignment(PermissionSetId = permissionKBMap.get('Owner'), AssigneeId = userId));
				}
				if(!permissionSetList.isEmpty()){
					EM_PermissionSetAssignment.doUpsertPermissionSetAssignmentList(permissionSetList);
				}
			}
			
			//assign public groups
			if(!userRoleMapIds.isEmpty()){
				for(Id userId: userRoleMapIds.keySet()) {
					if(userRoleMapIds.get(userId).equals('Author')){
							groupMemberList.add(new GroupMember(
									GroupId = publicGroupKBMap.get('Author'),
									UserOrGroupId = userId
							));
					}
					else if(userRoleMapIds.get(userId).equals('Internal Approver (Approver)')){
							groupMemberList.add( new GroupMember(
									GroupId = publicGroupKBMap.get('Author'),
									UserOrGroupId = userId
							));
							groupMemberList.add(new GroupMember(
									GroupId = publicGroupKBMap.get('Internal Approver (Approver)'),
									UserOrGroupId = userId
							));
					}
					else if(userRoleMapIds.get(userId).equals('Public Approver (Publisher)')){
							groupMemberList.add(new GroupMember(GroupId = publicGroupKBMap.get('Author'), UserOrGroupId = userId));
						if(!userOnlyPublisherIds.get(userId)){
							groupMemberList.add(new GroupMember(GroupId = publicGroupKBMap.get('Internal Approver (Approver)'), UserOrGroupId = userId));							
						}
						groupMemberList.add(new GroupMember(GroupId = publicGroupKBMap.get('Public Approver (Publisher)'), UserOrGroupId = userId));
					}
				}
				if(!groupMemberList.isEmpty()){
					EM_GroupMember.doUpsertGroupMemberList(groupMemberList);
				}
			}
		}		
	}
}