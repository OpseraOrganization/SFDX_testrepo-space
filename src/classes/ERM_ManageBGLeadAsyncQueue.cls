//Created: 23 05 2019 – sonia.reis@nokia.com

global without sharing class ERM_ManageBGLeadAsyncQueue implements Queueable {
	
	List<Session__c> oldSessions = new List<Session__c>();
	List<Session__c> newSessions = new List<Session__c>();
	String action = '';
	
	public ERM_ManageBGLeadAsyncQueue(List<Session__c> oldSessions, List<Session__c> newSessions, String action) {
		this.oldSessions = oldSessions;
		this.newSessions = newSessions;
		this.action = action;
	}

	public void execute(QueueableContext context) {
		Map<Id,String> userRoleMapIds = new Map<Id,String>();
		//Map<Id,String> userEventMapIds = new Map<Id,String>();
		List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
		Map<String,Id> permissionKBMap = new Map<String,Id>{'BG' => Utils.getPermissionSetIdByPermissionSetName('ERM_Session_BG_Lead')};

		if(action.equals('remove')){
			Set<Id> usersIds = new Set<Id>();
			Set<ID> sessionsSet = new Set<Id>();
	for(Session__c session: oldSessions){
	sessionsSet.add(session.id);
	if(session.Owner__c != null){ usersIds.add(session.Owner__c);
	}
			}
			Map<Id,User> usersMap = new Map<Id,User>([SELECT Id, GLT_Assistant__c FROM User WHERE Id IN :usersIds]);
			for(Session__c session: oldSessions){ if(session.Owner__c != null){   //has a BGLead for the session
		userRoleMapIds.put(session.Owner__c, 'BG'); 
		if(usersMap.containsKey(session.Owner__c) && usersMap.get(session.Owner__c).GLT_Assistant__c != null){ userRoleMapIds.put(usersMap.get(session.Owner__c).GLT_Assistant__c, 'BG'); 
		}
	}
			}
			
			//if BGlead in other session remove from the list 
			List<Session__c> sessionsFromThatUser = EM_Session.getSessionWithBGLeadUsers(usersIds);
			Map<ID, List<Session__c>> userIDListSessionMap = new Map<ID, List<Session__c>>();
			for(Session__c session : sessionsFromThatUser){
	if(!sessionsSet.contains(session.id)){
		if(!userIDListSessionMap.containsKey(session.owner__c)){ userIDListSessionMap.put(session.owner__c, new List<Session__C>{session});
		}
		else{ userIDListSessionMap.get(session.owner__c).add(session);
		}
		if(!userIDListSessionMap.containsKey(session.owner__r.GLT_Assistant__c)){ userIDListSessionMap.put(session.owner__r.GLT_Assistant__c, new List<Session__C>{session});
		}
		else{ userIDListSessionMap.get(session.owner__r.GLT_Assistant__c).add(session);
		}
	}
			}

			//remove permission set assigned to BGLead if not in another session as BGLead
			if(!userRoleMapIds.isEmpty()){
	for(Id userId: userRoleMapIds.keySet()) {
		if(!userIDListSessionMap.containskey(userId)){ permissionSetList.add(new PermissionSetAssignment( AssigneeId = userId )); 
		}
	}
	if(!permissionSetList.isEmpty()){
		List<PermissionSetAssignment> permissionSetListToDelete = new List<PermissionSetAssignment>();
		for(PermissionSetAssignment curPermissionSetAssignment : EM_PermissionSetAssignment.getAllPermissionSetAssignments(new Set<Id>(permissionKBMap.values()))){
			for(PermissionSetAssignment curpermissionSetList : permissionSetList){
				if(curPermissionSetAssignment.PermissionSetId == curpermissionSetList.PermissionSetId && curPermissionSetAssignment.AssigneeId == curpermissionSetList.AssigneeId){ permissionSetListToDelete.add(curPermissionSetAssignment);
				}
			}
		}
		if(!permissionSetListToDelete.isEmpty()){ EM_PermissionSetAssignment.doDeletePermissionSetAssignmentList(permissionSetListToDelete);
		}	
	}
			}			
		}
		else if(action.equals('assign')){
			Set<Id> usersIds = new Set<Id>();
	for(Session__c session: newSessions){
	if(session.Owner__c != null){ usersIds.add(session.Owner__c);
	}
			}
			Map<Id,User> usersMap = new Map<Id,User>([SELECT Id, GLT_Assistant__c FROM User WHERE Id IN :usersIds]);
			for(Session__c session: newSessions){
	if(session.Owner__c != null){ userRoleMapIds.put(session.Owner__c, 'BG'); 
		if(usersMap.containsKey(session.Owner__c) && usersMap.get(session.Owner__c).GLT_Assistant__c != null){ userRoleMapIds.put(usersMap.get(session.Owner__c).GLT_Assistant__c, 'BG'); 
		}
	}
			}


			//assign permission set BGLead
			if(!userRoleMapIds.isEmpty()){
	for(Id userId: userRoleMapIds.keySet()) { permissionSetList.add(new PermissionSetAssignment( PermissionSetId = permissionKBMap.get(userRoleMapIds.get(userId)), AssigneeId = userId
		));
	}
	if(!permissionSetList.isEmpty()){ EM_PermissionSetAssignment.doUpsertPermissionSetAssignmentList(permissionSetList);
	}
			}
		}
	}		
}