//Created: 10 05 2019 – sonia.reis@nokia.com

public without sharing class ERM_UpdateEventParticipantsAsyncQueue implements Queueable {
	
	List<Event__c> oOldEvents = new List<Event__c>();
	List<Event__c> oNewEvents = new List<Event__c>();
	
	public ERM_UpdateEventParticipantsAsyncQueue(List<Event__c> oOldEvents, List<Event__c> oNewEvents) {
		this.oOldEvents = oOldEvents;
		this.oNewEvents = oNewEvents;
	}
	
	public void execute(QueueableContext context) {
		
		final Id eventERMRT = Utils.MapRecordType('Event__c').get('ERM');
		final Id eventRegistrationInternalRT = Utils.MapRecordType('Event_Registration__c').get('Internal');
		
		Map<String,Id> permissionKBMap = new Map<String,Id>{
			'Edit' => Utils.getPermissionSetIdByPermissionSetName('ERM_EventOwner'),
			'Read' => Utils.getPermissionSetIdByPermissionSetName('ERM_EventParticipant')
			};
					
		Map<Id, Event__c> oldEventsMap = new Map<Id, Event__c>(oOldEvents);			
		Map<Id,List<ID>> eventIdListUsersmapEdit = new Map<Id,List<String>>(); //map id event by  Users para super que houve mudança
		Map<Id,List<ID>> eventIdListUsersmapRead = new Map<Id,List<String>>(); //map id event by Users para ps participants que houve mudança
		
		//manage OLD permissions
		for(Integer i = 0; i<oOldEvents.size(); i++){
			if(oOldEvents[i].event_host__C!= null && oNewEvents[i].event_host__C != oOldEvents[i].event_host__C){
					eventIdListUsersmapEdit.put(oOldEvents[i].id,new List<String>{oOldEvents[i].event_host__C});
			} 
			if(oOldEvents[i].marketing__C!= null && oNewEvents[i].marketing__C != oOldEvents[i].marketing__C){
				if(!eventIdListUsersmapEdit.containsKey(oOldEvents[i].id)){
					eventIdListUsersmapEdit.put(oOldEvents[i].id,new List<String>{oOldEvents[i].marketing__C});
				}
				else{
					List<String> users=  eventIdListUsersmapEdit.get(oOldEvents[i].id); 
					if(!users.contains(oOldEvents[i].marketing__C)){
						users.add(oOldEvents[i].marketing__C);
						eventIdListUsersmapEdit.remove(oOldEvents[i].id);
						eventIdListUsersmapEdit.put(oOldEvents[i].id, users);
					}
				}
			} 
			if(oOldEvents[i].Customer_Solution_Architect__c!= null && oNewEvents[i].Customer_Solution_Architect__c != oOldEvents[i].Customer_Solution_Architect__c){
				if(!eventIdListUsersmapEdit.containsKey(oOldEvents[i].id)){
					eventIdListUsersmapEdit.put(oOldEvents[i].id,new List<String>{oOldEvents[i].Customer_Solution_Architect__c});
				}
				else{
					List<String> users=  eventIdListUsersmapEdit.get(oOldEvents[i].id);
					if(!users.contains(oOldEvents[i].Customer_Solution_Architect__c)){
						users.add(oOldEvents[i].Customer_Solution_Architect__c);
						eventIdListUsersmapEdit.remove(oOldEvents[i].id);
						eventIdListUsersmapEdit.put(oOldEvents[i].id, users);
					}
				}
			} 
		}
		
		for(Integer i = 0; i<oOldEvents.size(); i++){
			if(oNewEvents[i].event_host__C != oOldEvents[i].event_host__C){   
					eventIdListUsersmapRead.put(oOldEvents[i].id,new List<String>{oNewEvents[i].event_host__C});
			} 
			if(oNewEvents[i].marketing__C != oOldEvents[i].marketing__C){
				if(!eventIdListUsersmapRead.containsKey(oOldEvents[i].id)){
					eventIdListUsersmapRead.put(oOldEvents[i].id,new List<String>{oNewEvents[i].marketing__C});
				}
				else{
					List<String> users=  eventIdListUsersmapRead.get(oOldEvents[i].id); 
					if(!users.contains(oOldEvents[i].marketing__C)){
						users.add(oNewEvents[i].marketing__C);
						eventIdListUsersmapRead.remove(oOldEvents[i].id);
						eventIdListUsersmapRead.put(oOldEvents[i].id, users);
					}
				}
			} 
			if(oNewEvents[i].Customer_Solution_Architect__c != oOldEvents[i].Customer_Solution_Architect__c){
				if(!eventIdListUsersmapRead.containsKey(oOldEvents[i].id)){
					eventIdListUsersmapRead.put(oOldEvents[i].id,new List<String>{oNewEvents[i].Customer_Solution_Architect__c});
				}
				else{
					List<String> users=  eventIdListUsersmapRead.get(oOldEvents[i].id); 
					if(!users.contains(oOldEvents[i].Customer_Solution_Architect__c)){
						users.add(oNewEvents[i].Customer_Solution_Architect__c);
						eventIdListUsersmapRead.remove(oOldEvents[i].id);
						eventIdListUsersmapRead.put(oOldEvents[i].id, users);
					}
				}
			} 
		}
	
		Set<ID> allIdUsersSetRead = new Set<ID>();
		List<Event_Registration__c> participantsFromThatUsersRead = new List<Event_Registration__c>();
		if(!eventIdListUsersmapRead.isEmpty()){
			for(List<ID>  listU :  eventIdListUsersmapRead.values()){
				allIdUsersSetRead.addAll(listU);
			} 
			
		   //get all participants with that users
		   // participantsFromThatUsersRead = EM_EventRegistration.getEventRegistrationbyUserID(allIdUsersSetRead);
		   participantsFromThatUsersRead = [SELECT
				Id,
				Event__c,
				User__c,
				RecordTypeId,
				User__r.GLT_Member__c,
				User__r.GLT_Assistant__c,
				EventCustomerSolutionArchitectMember__c,
				EventHostMember__c,
				EventMarketingMember__c
				FROM
				Event_Registration__c
				WHERE
				User__c in :allIdUsersSetRead
			   ];
		}

		//map user por list participants 
		Map<ID, List<Event_Registration__c>> userIdListParticipantsRead = new Map<ID, List<Event_Registration__c>>();
		for(Event_Registration__c part : participantsFromThatUsersRead){
			if(!userIdListParticipantsRead.containsKey(part.User__c)){
				userIdListParticipantsRead.put(part.User__c, new List<Event_Registration__c>{part});
			}
			else{
				List<Event_Registration__c> listPart = userIdListParticipantsRead.get(part.User__C);
				if(!listPart.contains(part)){
					listPart.add(part);
					userIdListParticipantsRead.remove(part.User__C);
					userIdListParticipantsRead.put(part.User__C, listPart);
				}
			}
		}
		
		Set<ID> allIdUsersSetEdit = new Set<ID>();
		List<Event_Registration__c> participantsFromThatUsersEdit = new List<Event_Registration__c>();
		if(!eventIdListUsersmapEdit.isEmpty()){
			for(List<ID>  listU :  eventIdListUsersmapEdit.values()){
				allIdUsersSetEdit.addAll(listU);
			}
			
			  //get all participants with that users
			//participantsFromThatUsersEdit= EM_EventRegistration.getEventRegistrationbyUserID(allIdUsersSetEdit);  
			participantsFromThatUsersEdit=[SELECT
				Id,
				Event__c,
				User__c,
				RecordTypeId,
				User__r.GLT_Member__c,
				User__r.GLT_Assistant__c,
				EventCustomerSolutionArchitectMember__c,
				EventHostMember__c,
				EventMarketingMember__c
				FROM
				Event_Registration__c
				WHERE
				User__c in :allIdUsersSetEdit
			   ];
		}
		

		//map user por list participants-owner --não poe o nosso
		Map<ID, List<Event_Registration__c>> userIdListParticipantsEdit = new Map<ID, List<Event_Registration__c>>();
		for(Event_Registration__c part : participantsFromThatUsersEdit){
			if(part.EventHostMember__c == part.User__c || part.EventCustomerSolutionArchitectMember__c == part.User__c  || 
			   part.EventMarketingMember__c == part.User__c){
				   if(!userIdListParticipantsEdit.containsKey(part.User__c)){
					   userIdListParticipantsEdit.put(part.User__c, new List<Event_Registration__c>{part});
				   }
				   else{
					   List<Event_Registration__c> listPart = userIdListParticipantsEdit.get(part.User__C);
					   if(!listPart.contains(part)){
						   listPart.add(part);
						   userIdListParticipantsEdit.remove(part.User__C);
						   userIdListParticipantsEdit.put(part.User__C, listPart);
					   }
				   }
			   }
		}

		//  user por participant noutro   x , read
		Map<Id,String> userRoleMapRead = new Map<Id,String>(); //lista para apagar
		if(!eventIdListUsersmapRead.isEmpty()){
			for(Id eventId: eventIdListUsersmapRead.keySet()){
				for(ID iduser :  eventIdListUsersmapRead.get(eventId)){ //list users
					if(userIdListParticipantsRead.containskey(iduser) && userIdListParticipantsRead.get(iduser).size()==1){  // ==1 only contains himself
						userRoleMapRead.put(iduser, 'Read');
					}
					if(userIdListParticipantsRead.containskey(iduser) && userIdListParticipantsRead.get(iduser).size()>1){  
						Boolean isParticipantInAnotherEvent=false;
						for(Event_Registration__c part : userIdListParticipantsRead.get(iduser)){
							if(part.EventHostMember__c!=part.User__c && part.EventMarketingMember__c !=part.User__c && part.EventCustomerSolutionArchitectMember__c !=part.User__c){
								isParticipantInAnotherEvent=true;
							}
						}
						if(!isParticipantInAnotherEvent){
							userRoleMapRead.put(iduser, 'Read');
						}
					}
				}
			}
		}
		
		//user por owner noutro x, edit
		Map<Id,String> userRoleMapEdit = new Map<Id,String>();
		if(!eventIdListUsersmapEdit.isEmpty()){
			for(Id eventId: eventIdListUsersmapEdit.keySet()){
				for(ID iduser :  eventIdListUsersmapEdit.get(eventId)){ //list users
					if(!userIdListParticipantsEdit.containskey(iduser) ){  // he is not a participant yet
						userRoleMapEdit.put(iduser, 'Edit');
					}
				}
			}
		}

		List<PermissionSetAssignment> permissionSetList1 = new List<PermissionSetAssignment>();
		//delete permissions
		if(!userRoleMapRead.isEmpty()){
			for(Id userID : userRoleMapRead.keySet()){
				permissionSetList1.add(new PermissionSetAssignment(
					PermissionSetId = permissionKBMap.get(userRoleMapRead.get(userId)),
					AssigneeId = userId));	
			}
		}
		if(!userRoleMapEdit.isEmpty()){
			for(Id userID : userRoleMapEdit.keySet()){
				
				permissionSetList1.add(new PermissionSetAssignment(
					PermissionSetId = permissionKBMap.get(userRoleMapEdit.get(userId)),
					AssigneeId = userId));	
			}
		}
		
		//to get the ids from the PS to delete
		if(!permissionSetList1.isEmpty()){
			List<PermissionSetAssignment> permissionSetListToDelete = new List<PermissionSetAssignment>();
			for(PermissionSetAssignment curPermissionSetAssignment : EM_PermissionSetAssignment.getAllPermissionSetAssignments(new Set<Id>(permissionKBMap.values()))){
				for(PermissionSetAssignment curpermissionSetList : permissionSetList1){
					if(curPermissionSetAssignment.PermissionSetId == curpermissionSetList.PermissionSetId 
					   && curPermissionSetAssignment.AssigneeId == curpermissionSetList.AssigneeId){
						   permissionSetListToDelete.add(curPermissionSetAssignment);
					   }
				}
			}
			if(!permissionSetListToDelete.isEmpty()){
				EM_PermissionSetAssignment.doDeletePermissionSetAssignmentList(permissionSetListToDelete);
			}
		}		   

		//manage NEW permissions
		Map<Id,String> userRoleMapIdsTotalEventsRead = new Map<Id,String>();
		Map<Id,String> userRoleMapIdsTotalEventsEdit = new Map<Id,String>();
		List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();

		for(Integer i = 0; i<oOldEvents.size(); i++){
			if(oNewEvents[i].RecordTypeId == eventERMRT) {
				Map<Id,String> userRoleMapIds = new Map<Id,String>();
				userRoleMapIds =  manageUpdateInsertPermissions(oNewEvents[i], oOldEvents[i]);
				if(!userRoleMapIds.isEmpty()){
					for( Id idUser: userRoleMapIds.keySet()){
						if(userRoleMapIds.get(idUser).equals('Read') && !userRoleMapIdsTotalEventsRead.containsKey(idUser)){
							userRoleMapIdsTotalEventsRead.put(idUser, 'Read');
						}
						else{
							if(userRoleMapIds.get(idUser).equals('Edit') && !userRoleMapIdsTotalEventsEdit.containsKey(idUser)){
								userRoleMapIdsTotalEventsEdit.put(idUser, 'Edit');
							}
						}   
					}
				}
			}
		}
		//assign permissions
		if(!userRoleMapIdsTotalEventsEdit.isEmpty()){
			for(Id userId: userRoleMapIdsTotalEventsEdit.keySet()) {
				permissionSetList.add(new PermissionSetAssignment(
					PermissionSetId = permissionKBMap.get(userRoleMapIdsTotalEventsEdit.get(userId)),
					AssigneeId = userId
				));
			}
		}
		if(!userRoleMapIdsTotalEventsRead.isEmpty()){
			for(Id userId: userRoleMapIdsTotalEventsRead.keySet()) {
				permissionSetList.add(new PermissionSetAssignment(
					PermissionSetId = permissionKBMap.get(userRoleMapIdsTotalEventsRead.get(userId)),
					AssigneeId = userId
				));
			}
		}
		if(!permissionSetList.isEmpty()){
			EM_PermissionSetAssignment.doUpsertPermissionSetAssignmentList(permissionSetList);
		}
	}
	
	@TestVisible 
	private Map<Id,String> manageUpdateRemovePermissions (Event_Registration__c newParticipant, Event__c oldEvent){
		Map<Id,String> userRoleMapIds = new Map<Id,String>();
		if(oldEvent.Marketing__c != null && newParticipant.User__c == oldEvent.Marketing__c){
			if(!userRoleMapIds.containskey(newParticipant.User__c)) {
				userRoleMapIds.put(newParticipant.User__c, 'Edit');
			}
		}
		if(oldEvent.Event_Host__c != null && newParticipant.User__c == oldEvent.Event_Host__c){
			if(!userRoleMapIds.containskey(newParticipant.User__c)) {
				userRoleMapIds.put(newParticipant.User__c, 'Edit');   
			}
		}
		if(oldEvent.Customer_Solution_Architect__c != null 
		   && newParticipant.User__c == oldEvent.Customer_Solution_Architect__c){
			   if(!userRoleMapIds.containskey(newParticipant.User__c)) {
				   userRoleMapIds.put(newParticipant.User__c, 'Edit'); 
			   }
		   }
		if(oldEvent.Customer_Solution_Architect__c == null 
		   && oldEvent.Event_Host__c == null && oldEvent.Marketing__c == null){
			   if(!userRoleMapIds.containskey(newParticipant.User__c)) {
				   userRoleMapIds.put(newParticipant.User__c, 'Read');  
			   }
		   }
		if(!userRoleMapIds.containskey(newParticipant.User__c)) {
			userRoleMapIds.put(newParticipant.User__c, 'Read');
		}
		return userRoleMapIds;
	}

	private Map<Id,String> manageUpdateInsertPermissions (Event__c newEvent, Event__c oldEvent){
		Map<Id,String> userRoleMapIds = new Map<Id,String>();
		
		if( oldEvent.Event_Host__c == null && newEvent.Event_Host__c!=null){
			userRoleMapIds.put(newEvent.Event_Host__c, 'Edit');
		}
		if( oldEvent.Event_Host__c != null && (newEvent.Event_Host__c==null  || newEvent.Event_Host__c!= oldEvent.Event_Host__c)){
			userRoleMapIds.put(oldEvent.Event_Host__c, 'Read');
		}
		if( oldEvent.Event_Host__c != null && newEvent.Event_Host__c!=null  && newEvent.Event_Host__c!= oldEvent.Event_Host__c){
			userRoleMapIds.put(newEvent.Event_Host__c, 'Edit');
		}
		if( oldEvent.Marketing__c == null && newEvent.Marketing__c!=null){
			userRoleMapIds.put(newEvent.Marketing__c, 'Edit');
		}
		if( oldEvent.Marketing__c != null && (newEvent.Marketing__c==null  || newEvent.Marketing__c!= oldEvent.Marketing__c)){
			userRoleMapIds.put(oldEvent.Marketing__c, 'Read');
		}
		if( oldEvent.Marketing__c != null && newEvent.Marketing__c!=null  && newEvent.Marketing__c!= oldEvent.Marketing__c){
			userRoleMapIds.put(newEvent.Marketing__c, 'Edit');
		} 
		if( oldEvent.Customer_Solution_Architect__c == null && newEvent.Customer_Solution_Architect__c!=null){
			userRoleMapIds.put(newEvent.Customer_Solution_Architect__c, 'Edit');
		}
		if( oldEvent.Customer_Solution_Architect__c != null && 
		   (newEvent.Customer_Solution_Architect__c==null  || newEvent.Customer_Solution_Architect__c!= oldEvent.Customer_Solution_Architect__c)){
			   userRoleMapIds.put(oldEvent.Customer_Solution_Architect__c, 'Read');
		   }
		if( oldEvent.Customer_Solution_Architect__c != null && newEvent.Customer_Solution_Architect__c!=null  
		   && newEvent.Customer_Solution_Architect__c!= oldEvent.Customer_Solution_Architect__c){
			   userRoleMapIds.put(newEvent.Customer_Solution_Architect__c, 'Edit');
		   } 
		return userRoleMapIds;
	}
}