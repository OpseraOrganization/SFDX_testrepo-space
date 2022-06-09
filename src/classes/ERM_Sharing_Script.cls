global class ERM_Sharing_Script implements Database.Batchable<sObject>
{
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
		
		return Database.getQueryLocator( 'Select Id, Name, Event_Host__c, Event_Host__r.GLT_Assistant__c, Marketing__c, Marketing__r.GLT_Assistant__c, Customer_Solution_Architect__c, Customer_Solution_Architect__r.GLT_Assistant__c ,OwnerId, ' +
										'(select Id, Name, User__c, User__r.Name, User__r.GLT_Assistant__c, User__r.IsActive, RecordType.Name from Registrations__r), ' + 
										'(Select Id, Name, Owner__c, Owner__r.GLT_Assistant__c from Sessions__r) ' + 
										'from Event__c');
	}
	
	global void execute(Database.BatchableContext bc, List<Event__c> events){
	   
		//change owner queues name
		Map<Id, Group> groupsMap = new Map<Id, Group>(changeQueueName(events));		
		
		Set<Id> eventsIds = new Set<Id>();
		Set<Id> participantsIds = new Set<Id>();
		Set<Id> sessionsIds = new Set<Id>();
		
		//Event share map - in order to not have duplicates
		Map<String, Event__Share> eventShareMap = new Map<String, Event__Share>();
		
		//Participant share map - in order to not have duplicates
		Map<String, Event_Registration__Share> participantShareMap = new Map<String, Event_Registration__Share>();
		
		//Session share map - in order to not have duplicates
		Map<String, Session__Share> sessionShareMap = new Map<String, Session__Share>();
		
		Set<Id> superUsers = new Set<Id>();
		
		for(Event__c event : events)
		{   
			eventsIds.add(event.Id);
			
			//Save the super users for this event to use later
			if(event.Event_Host__c != null) {
				superUsers.add(event.Event_Host__c);
				if(event.Event_Host__r.GLT_Assistant__c != null) {
					superUsers.add(event.Event_Host__r.GLT_Assistant__c);
				}
			}
			if(event.Marketing__c != null) {
				superUsers.add(event.Marketing__c);
				if(event.Marketing__r.GLT_Assistant__c != null) {
					superUsers.add(event.Marketing__r.GLT_Assistant__c);
				}
			}
			if(event.Customer_Solution_Architect__c != null) {
				superUsers.add(event.Customer_Solution_Architect__c);
				if(event.Customer_Solution_Architect__r.GLT_Assistant__c != null) {
					superUsers.add(event.Customer_Solution_Architect__r.GLT_Assistant__c);
				}
			}
						
			//go through all participants of the event
			for(Event_Registration__c participant : event.Registrations__r)
			{
				participantsIds.add(participant.Id);
				
				//Sharing record only with active and internal participans
				if(participant.User__c != null && participant.User__r.IsActive && participant.RecordType.Name == 'Internal')
				{
					//Share event to participant
					Event__Share eventShare = new Event__Share();
					eventShare.UserOrGroupId = participant.User__c;
					eventShare.ParentId = event.Id;
					eventShare.AccessLevel = 'Read';
					eventShare.RowCause = 'Share_Event_with_Participants__c';
					eventShareMap.put( event.Id +'-'+ participant.User__c , eventShare);
					
					//Check if the participant has GLT Assistant and share event with him
					if(participant.User__r.GLT_Assistant__c != null)
					{
						Event__Share eventAShare = new Event__Share();
						eventAShare.UserOrGroupId = participant.User__r.GLT_Assistant__c;
						eventAShare.ParentId = event.Id;
						eventAShare.AccessLevel = 'Read';
						eventAShare.RowCause = 'Share_Event_with_Participants__c';
						eventShareMap.put( event.Id +'-'+ participant.User__r.GLT_Assistant__c , eventAShare);
					}
					
					//Share participants between them
					for(Event_Registration__c participantX : event.Registrations__r)
					{
						//Share the participant (iterated on the loop outside) and give him access to all the other participants (internal, external and non-identified)
						if( (participantX.RecordType.Name == 'Internal' && participantX.User__c != null && participantX.User__r.IsActive ) || participantX.RecordType.Name != 'Internal')
						{
							Event_Registration__Share participantShare = new Event_Registration__Share();
							participantShare.UserOrGroupId = participant.User__c;
							participantShare.ParentId = participantX.Id;
							participantShare.AccessLevel = 'Edit';
							participantShare.RowCause = 'Share_Participants_with_Users__c';
							participantShareMap.put( participantX.Id +'-'+  participant.User__c, participantShare);  
							
							//If applicable, share all the participants with the GLT Assistant (of the participant iterated on the loop outisde)
							if(participant.User__r.GLT_Assistant__c != null)
							{
								Event_Registration__Share assistantShare = new Event_Registration__Share();
								assistantShare.UserOrGroupId = participant.User__r.GLT_Assistant__c;
								assistantShare.ParentId = participantX.Id;
								assistantShare.AccessLevel = 'Edit';
								assistantShare.RowCause = 'Share_Participants_with_Users__c';
								participantShareMap.put( participantX.Id +'-'+  participant.User__r.GLT_Assistant__c, assistantShare); 
							}
							
						}
					}
					
				}	
			}
			
			//Go through all sessions of the event
			for(Session__c session : event.Sessions__r)
			{
				sessionsIds.add(session.Id);		 
				
				//Share session with its BG Lead and his assistant if applicable
				if(session.Owner__c != null)
				{
					Session__Share sessionShareBG = new Session__Share(); 
					sessionShareBG.UserOrGroupId = session.Owner__c;
					sessionShareBG.ParentId = session.Id;
					sessionShareBG.AccessLevel = 'Edit';
					sessionShareBG.RowCause = 'Share_Sessions_with_Participants__c';
					sessionShareMap.put(session.Id +'-'+ session.Owner__c, sessionShareBG);

					
					if(session.Owner__r.GLT_Assistant__c != null)
					{
						Session__Share sessionShareA = new Session__Share();
						sessionShareA.UserOrGroupId = session.Owner__r.GLT_Assistant__c;
						sessionShareA.ParentId = session.Id;
						sessionShareA.AccessLevel = 'Read';
						sessionShareA.RowCause = 'Share_Sessions_with_Participants__c';
						sessionShareMap.put( session.Id +'-'+ session.Owner__r.GLT_Assistant__c , sessionShareA);
						
					}
				}
				
				//Share Session with Participants and assistants
				for(Event_Registration__c participant : event.Registrations__r)
				{
					if(participant.User__c != null && participant.User__r.IsActive && participant.RecordType.Name == 'Internal' && participant.User__c != session.Owner__c)
					{
						//Share session to participant (if super user has Edit acces level)
						Session__Share sessionShareP = new Session__Share();
						sessionShareP.UserOrGroupId = participant.User__c;
						sessionShareP.ParentId = session.Id;
						sessionShareP.AccessLevel = superUsers.contains(participant.User__c) ? 'Edit' : 'Read';
						sessionShareP.RowCause = 'Share_Sessions_with_Participants__c';
						sessionShareMap.put( session.Id +'-'+ participant.User__c , sessionShareP);
						
						//Check if the participant has GLT Assistant and share session with him (if super user has Edit acces level)
						if(participant.User__r.GLT_Assistant__c != null)
						{
							Session__Share sessionShareA = new Session__Share();
							sessionShareA.UserOrGroupId = participant.User__r.GLT_Assistant__c;
							sessionShareA.ParentId = session.Id;
							sessionShareA.AccessLevel = superUsers.contains(participant.User__r.GLT_Assistant__c) ? 'Edit' : 'Read';
							sessionShareA.RowCause = 'Share_Sessions_with_Participants__c';
							sessionShareMap.put( session.Id +'-'+ participant.User__r.GLT_Assistant__c , sessionShareA);
						}
					}
				}
			}
		}
		
		//Get existing shares
		List<Event__Share> existEventShare = [Select Id, Parent.Name, UserorGroup.name from Event__Share where parentId = :eventsIds and rowcause = 'Share_Event_with_Participants__c'];
		List<Event_registration__Share> existParticipantShare = [Select Id, Parent.Name, UserorGroup.name from Event_registration__Share where parentId = :participantsIds and rowcause = 'Share_Participants_with_Users__c'];
		List<Session__Share> existSessionShare = [Select Id, Parent.Name, UserorGroup.name from Session__Share where parentId = :sessionsIds  and rowcause = 'Share_Sessions_with_Participants__c'];
		
		//Delete Exisiting shares
		
		Database.DeleteResult[] deleteSharesResult = Database.delete(existEventShare, false);
		deleteSharesResult.addAll( Database.delete(existParticipantShare, false) );
		deleteSharesResult.addAll( Database.delete(existSessionShare, false) );
		
		// Iterate through each returned result
		for(Database.DeleteResult dr : deleteSharesResult) {
			if (dr.isSuccess()) {
				// Operation was successful, so get the ID of the record that was processed
				System.debug('Successfully deleted share with ID: ' + dr.getId());
			}
			else {
				// Operation failed, so get all errors				
				for(Database.Error err : dr.getErrors()) {
					System.debug('>>> ERROR The following error has occurred.');					
					System.debug('>>> ERROR ' + err.getStatusCode() + ': ' + err.getMessage());
				}
			}
		}
		
		//Commit shares
		
		Database.SaveResult[] insertShareResult = Database.insert( eventShareMap.values() , false) ;
		insertShareResult.addAll( Database.insert( participantShareMap.values(), false ) ) ;
		insertShareResult.addAll( Database.insert( sessionShareMap.values(), false ) ) ;

		// Iterate through each returned result
		for (Database.SaveResult sr : insertShareResult) {
			if (sr.isSuccess()) {
				// Operation was successful, so get the ID of the record that was processed
				System.debug('Successfully inserted Share with ID ' + sr.getId());
			}
			else {
				// Operation failed, so get all errors				
				for(Database.Error err : sr.getErrors()) {
					System.debug('>>> ERROR The following error has occurred.');					
					System.debug('>>> ERROR ' + err.getStatusCode() + ': ' + err.getMessage());
				}
			}
		}
	}  
	
	global void finish(Database.BatchableContext bc){
		
		System.debug('FINISHED');
		
	}  
	
	
	private static List<Group> changeQueueName(List<Event__c> events){
		
		Set<String> queueDevName = new Set<String>();
		for(Event__c event : events){
			queueDevName.add(event.Id+'_OwnerQueue');
		}
		
		List<Group> groups = [Select Id, Name, DeveloperName from Group Where DeveloperName IN :queueDevName];
		Map<String, Group> groupsMap = new Map<String, Group>();
		for(Group groupObj : groups){
			groupsMap.put(groupObj.DeveloperName, groupObj);
		}
		
		for(Event__c event : events){
			String queueName = event.Id+'_OwnerQueue';
			if(groupsMap.containsKey(queueName)){
				groupsMap.get(queueName).Name = event.Id + '_OQ';
				groupsMap.get(queueName).DeveloperName = event.Id + '_OQ';
				break;
			}
			
		}
		
		update groupsMap.values();
		
		return groupsMap.values(); 
	}
	
	
}