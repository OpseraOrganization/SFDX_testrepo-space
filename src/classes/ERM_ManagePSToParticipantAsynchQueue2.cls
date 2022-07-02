//Created: 08 05 2019 – sonia.reis@nokia.com

global without sharing class ERM_ManagePSToParticipantAsynchQueue2 implements Queueable {
	@testVisible
	private static Boolean doChainJob = true;
	
	List<Event_Registration__c> oOldEventRegistrations = new List<Event_Registration__c>();
	List<Event_Registration__c> oNewEventRegistrations = new List<Event_Registration__c>();
	String action = '';
	
	public ERM_ManagePSToParticipantAsynchQueue2(List<Event_Registration__c> oOldEventRegistrations, List<Event_Registration__c> oNewEventRegistrations, String action) {
		this.oOldEventRegistrations = oOldEventRegistrations;
		this.oNewEventRegistrations = oNewEventRegistrations;
		this.action = action;
	}
		
	public void execute(QueueableContext context) {
		final Id eventRegistrationInternalRT = Utils.MapRecordType('Event_Registration__c').get('Internal');
		Map<Id,String> userRoleMapIds = new Map<Id,String>();
		Map<Id,String> userEventMapIds = new Map<Id,String>();
		List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
		List<PermissionSetAssignment> permissionSetListToUpsert = new List<PermissionSetAssignment>();
		Set<PermissionSetAssignment> psSetList = new Set<PermissionSetAssignment>();
		
		Map<String,Id> permissionKBMap = new Map<String,Id>{
			'Edit' => Utils.getPermissionSetIdByPermissionSetName('ERM_EventOwner'),
			'Read' => Utils.getPermissionSetIdByPermissionSetName('ERM_EventParticipant')};
			  
		//map to get all Users
		Set<ID> idUserSet = new Set<ID> ();
		for(Event_Registration__c oEventRegistration : (oNewEventRegistrations.IsEmpty()? oOldEventRegistrations: oNewEventRegistrations)){
			idUserSet.add(oEventRegistration.User__c);
		}
		Map<Id, User> oUserMap = EM_User.getUserOwnerMap(idUserSet);
		//
		if(action.equals('remove') || action.equals('update')){
			//Check if User doesnt belong in others Events with the same Permission Set
			Map<Id, Boolean> userEventRegistrationEditPSMap = new Map<Id, Boolean>();
			Map<Id, Boolean> userEventRegistrationReadPSMap = new Map<Id, Boolean>();
			
			for(Event_Registration__c oEventRegistration : EM_EventRegistration.getEventRegistrationbyUserID(idUserSet)) {
				
				if(oEventRegistration.EventCustomerSolutionArchitectMember__c == oEventRegistration.User__c || 
				   oEventRegistration.EventHostMember__c == oEventRegistration.User__c || oEventRegistration.EventMarketingMember__c == oEventRegistration.User__c) {
					userEventRegistrationEditPSMap.put(oEventRegistration.User__c, true);
				}
				else userEventRegistrationReadPSMap.put(oEventRegistration.User__c, true);
			}
			
			//Check User Permission set to be added
			for(Event_Registration__c oOldEventRegistration: oOldEventRegistrations) {
				
				if(oOldEventRegistration.RecordTypeId == eventRegistrationInternalRT) {
					
					userEventMapIds.put(oOldEventRegistration.User__c, oOldEventRegistration.Event__c);  //map user event
					Id assistantId = oUserMap.get(oOldEventRegistration.User__c).GLT_Assistant__c;
					
					if(oOldEventRegistration.EventCustomerSolutionArchitectMember__c == oOldEventRegistration.User__c ||
					   oOldEventRegistration.EventMarketingMember__c == oOldEventRegistration.User__c || 
					   oOldEventRegistration.EventHostMember__c == oOldEventRegistration.User__c) {
						if(!userEventRegistrationEditPSMap.containsKey(oOldEventRegistration.User__c)) {
							userRoleMapIds.put(oOldEventRegistration.User__c, 'Edit');
							if(assistantId != null){
								userRoleMapIds.put(assistantId, 'Edit');
								userEventMapIds.put(assistantId, oOldEventRegistration.Event__c);
							}
						}
					} else {
						if(!userEventRegistrationReadPSMap.containsKey(oOldEventRegistration.User__c)) {
							userRoleMapIds.put(oOldEventRegistration.User__c, 'Read');
							if(assistantId != null){
								userRoleMapIds.put(assistantId, 'Read'); 
								userEventMapIds.put(assistantId, oOldEventRegistration.Event__c);
							}
						}
					}
				}
			}

			//delete permissions
			if(!userRoleMapIds.isEmpty()){		   
				for(Id userID : userRoleMapIds.keySet()){
					if((userRoleMapIds.get(userID).equals('Read')) || (userRoleMapIds.get(userID).equals('Edit'))){	 
						permissionSetList.add(new PermissionSetAssignment(
							PermissionSetId = permissionKBMap.get(userRoleMapIds.get(userId)),
							AssigneeId = userId));
					}
				}
				//to get the ids from the PS to delete
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
			}
			//If action is update assign again
			if(action.equals('update') && !oNewEventRegistrations.isEmpty()){
	System.enqueueJob(new ERM_ManagePSToParticipantAsynchQueue2(oNewEventRegistrations,oNewEventRegistrations,'assign'));
			}
		}
		else if(action.equals('assign')){
			for(Event_Registration__c oNewEventRegistration: oNewEventRegistrations){
				if(oNewEventRegistration.RecordTypeId == eventRegistrationInternalRT) {
					userEventMapIds.put(oNewEventRegistration.User__c, oNewEventRegistration.Event__c);
					Id assistantId = oUserMap.get(oNewEventRegistration.User__c).GLT_Assistant__c;
					if(oNewEventRegistration.User__c == oNewEventRegistration.EventCustomerSolutionArchitectMember__c || 
					   oNewEventRegistration.User__c == oNewEventRegistration.EventHostMember__c ||
					   oNewEventRegistration.User__c == oNewEventRegistration.EventMarketingMember__c) {
			userRoleMapIds.put(oNewEventRegistration.User__c, 'Edit');
			if(assistantId != null) {
				userRoleMapIds.put(assistantId, 'Edit');
						}
		} else {
			userRoleMapIds.put(oNewEventRegistration.User__c, 'Read');
			if(assistantId != null) {
				userRoleMapIds.put(assistantId, 'Read');
						}
					}
				}
			}
			//assign permissions
			if(!userRoleMapIds.isEmpty()){
				for(Id userId: userRoleMapIds.keySet()) {
					permissionSetList.add(new PermissionSetAssignment(
						PermissionSetId = permissionKBMap.get(userRoleMapIds.get(userId)),
						AssigneeId = userId));
				}
				if(!permissionSetList.isEmpty()){
		psSetList.addAll(permissionSetList);
		permissionSetListToUpsert.addAll(psSetList);
		Database.SaveResult[] saveResultList = Database.insert(permissionSetListToUpsert, false);
					
					for (Database.SaveResult sr : saveResultList) {
						for(Database.Error err : sr.getErrors()) {
							System.debug(LoggingLevel.ERROR, err.getMessage());
						}
					}
										
					//EM_PermissionSetAssignment.doUpsertPermissionSetAssignmentList(permissionSetList);
				}
			}
		}		
	}
}