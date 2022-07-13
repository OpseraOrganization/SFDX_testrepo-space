/**
About
-----
Description: This Class is used as Helper for User.

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
-------------
**/
public with sharing class UserHandler_TL {

	/*
	* @description : Validate if User has been inactive, and if YES, remove it from Event__c, Event_Registration__c and Session__c Object
	* @param : newList and oldMap
	* @return : void
	*/
	public static void validateIfUserHasBeenInactive(List<User> newListUsers, Map<Id, User> oldMapUsers) {
		Set<Id> userIds = new Set<Id>();
		for(User oUser : newListUsers ){
			if(oUser.NCP_Is_Internal__c == true){
				if(oUser.IsActive != oldMapUsers.get(oUser.Id).IsActive){
					if(oUser.IsActive == false){
					   userIds.add(oUser.Id);
						if(oUser.GLT_Assistant__c != null){
							userIds.add(oUser.GLT_Assistant__c);
						}
					}
				}
			}
		}

		if(userIds != null && !userIds.isEmpty()) {
			removeSharingOfParticipants(userIds);
		}
	}

			   /*
	* @description : Validate if User changed the GLT
	* @param : newList and oldMap
	* @return : void
	*/
	public static void validateChangeOnGLT(List<User> newListUsers, Map<Id, User> oldMapUsers) {
		Set<Id> gltIdsToDelete = new Set<Id>();
							  Set<Id> gltIdsToAdd = new Set<Id>();
							  Map<Id,Id> gltIdsToUpdate = new Map<Id,Id>();

		for(User oUser : newListUsers){
			if(oUser.NCP_Is_Internal__c == true){
				if(oUser.IsActive == true && oUser.GLT_Assistant__c != oldMapUsers.get(oUser.Id).GLT_Assistant__c){
					if(oUser.GLT_Assistant__c == null){
						gltIdsToDelete.add(oldMapUsers.get(oUser.Id).GLT_Assistant__c);
					} else if(oldMapUsers.get(oUser.Id).GLT_Assistant__c == null && oUser.GLT_Assistant__c != null){
						gltIdsToAdd.add(oUser.GLT_Assistant__c);
					} else {
						gltIdsToUpdate.put(oldMapUsers.get(oUser.Id).GLT_Assistant__c,oUser.GLT_Assistant__c);
					}
				}
			}
		}

		if(gltIdsToDelete != null && !gltIdsToDelete.isEmpty()) {
			removeSharingOfParticipants(gltIdsToDelete);
		}

							  if(gltIdsToUpdate != null && !gltIdsToUpdate.isEmpty()) {
			updateSharingOfParticipants(gltIdsToUpdate);
		}

							  if(gltIdsToAdd != null && !gltIdsToAdd.isEmpty()) {
			addSharingOfParticipants(gltIdsToAdd);
		}
			   }

			   /*
			   * @description : Future Method to Avoid MIXED_DML_OPERATION issue, when we Remove Sharing of Participants from the Events, Sessions and Other Participants
			   * @param : Set<Id>
			   * @return : void
			   */
	@future
	private static void removeSharingOfParticipants(Set<Id> userIds) {
		List<Event_Registration__c> oEventRegistrations = new List<Event_Registration__c>();
		List<Event__Share> eventSharesList = new List<Event__Share>();
		List<Event_Registration__Share> eventRegistrationSharesList = new List<Event_Registration__Share>();
		List<Session__Share> sessionSharesList = new List<Session__Share>();
		if(userIds != null && !userIds.isEmpty()){
			//Get Event Share per User
			eventSharesList = EM_Event.getEventShareIdByParticipantsId(userIds);

			//Get Event Registration Share per User
			eventRegistrationSharesList = EM_EventRegistration.getEventRegistrationShareIdByParticipantsId(userIds);

			//Get Session Share per User
			sessionSharesList = EM_Session.getSessionShareIdByParticipantsId(userIds);
		}

		if(eventSharesList.size()>0){
			delete eventSharesList;
		}
		if(eventRegistrationSharesList.size()>0){
			delete eventRegistrationSharesList;
		}
		if(sessionSharesList.size()>0){
			delete sessionSharesList;
		}
		//Delete Permission Set
	}

			   /*
			   * @description : Future Method to Avoid MIXED_DML_OPERATION issue, when we Update Sharing of Participants from the Events, Sessions and Other Participants
			   * @param : Map<Id,Id>
			   * @return : void
			   */
	@future
	private static void updateSharingOfParticipants(Map<Id,Id> userIds) {
							  List<Event_Registration__c> oEventRegistrations = new List<Event_Registration__c>();
		List<Event__Share> eventSharesList = new List<Event__Share>();
		List<Event_Registration__Share> eventRegistrationSharesList = new List<Event_Registration__Share>();
		List<Session__Share> sessionSharesList = new List<Session__Share>();
							  List<Id> userIdKeys = new List<Id>(userIds.keySet());
		List<String> userIdValues = userIds.values();
							  Set<Id> userGLTIds = new Set<Id>();

		if(userIds != null && !userIds.isEmpty()){
			//Get Event Share per User
			eventSharesList = EM_Event.getEventShareIdByParticipantsId(userIds.keySet());

			//Get Event Registration Share per User
			eventRegistrationSharesList = EM_EventRegistration.getEventRegistrationShareIdByParticipantsId(userIds.keySet());

			//Get Session Share per User
			sessionSharesList = EM_Session.getSessionShareIdByParticipantsId(userIds.keySet());

											 if(eventSharesList.size()>0){
															for(Event__Share oEventShareList : eventSharesList){
																		  // oEventShareList.Id = oEventShareList.Id;
																		   oEventShareList.UserOrGroupId = userIdKeys.get(userIdValues.indexOf(oEventShareList.UserOrGroupId));
															}
															update eventSharesList;
											 }
											 if(eventRegistrationSharesList.size()>0){
															for(Event_Registration__Share oEventRegistrationShareList : eventRegistrationSharesList){
																		  //  oEventRegistrationShareList.Id = oEventRegistrationShareList.Id;
																		   oEventRegistrationShareList.UserOrGroupId = userIdKeys.get(userIdValues.indexOf(oEventRegistrationShareList.UserOrGroupId));
															}
															update eventRegistrationSharesList;
											 }
											 if(sessionSharesList.size()>0){
															for(Session__Share oSessionShareList : sessionSharesList){
																		   //oSessionShareList.Id = oSessionShareList.Id;
																		   oSessionShareList.UserOrGroupId = userIdKeys.get(userIdValues.indexOf(oSessionShareList.UserOrGroupId));
															}
															update sessionSharesList;
											 }

			for(String userGlt : userIdValues){
				userGLTIds.add(userGlt);
			}
			if(!userGLTIds.isEmpty()){
				oEventRegistrations = EM_EventRegistration.getParticipantsByGLTId(userGLTIds);
				if(!oEventRegistrations.isEmpty()){
					System.enqueueJob(new ERM_ManagePSToParticipantAsynchQueue2(oEventRegistrations,oEventRegistrations,'assign'));
				}
			}
		}
	}

			   /*
			   * @description : Future Method to Avoid MIXED_DML_OPERATION issue, when we Add Sharing of Participants from the Events, Sessions and Other Participants
			   * @param : Set<Id>
			   * @return : void
			   */
	@future
	private static void addSharingOfParticipants(Set<Id> userIds) {
							  List<Event_Registration__c> oEventRegistrations = new List<Event_Registration__c>();
							  if(userIds != null && !userIds.isEmpty()){
											 oEventRegistrations = EM_EventRegistration.getParticipantsByGLTId(userIds);
											 if(!oEventRegistrations.isEmpty()){
													   EventRegistrationHandler_TL.addParticipantEventRegistrationShare(oEventRegistrations);
															System.enqueueJob(new ERM_ManagePSToParticipantAsynchQueue2(oEventRegistrations,oEventRegistrations,'assign'));
											 }
							  }
	}
}