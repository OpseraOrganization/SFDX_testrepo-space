//created by Sónia Reis 07-06-2019
//class to update the permission sets to the old records, according to owner, participant and BGLead
global with sharing class ERM_ScriptUpdatePermissionSets_scheduler  /*implements Schedulable*/ {
	//public static String CRON_EXP = '0 0 0 3 9 ? 2019';
	//global void execute(SchedulableContext SC) {
	 //   runScript();
	//}
	
	public static void runScript(){		
		//delete existing permissions
		try{
			delete [SELECT PermissionSetId, PermissionSet.name, AssigneeId, Id 
					FROM PermissionSetAssignment where PermissionSet.name like 'ERM_EventOwner'];
			
			delete [SELECT PermissionSetId, PermissionSet.name, AssigneeId, Id 
					FROM PermissionSetAssignment where PermissionSet.name like 'ERM_EventParticipant'];
			
			delete [SELECT PermissionSetId, PermissionSet.name, AssigneeId, Id 
					FROM PermissionSetAssignment where PermissionSet.name like 'ERM_Session_BG_Lead'];
			
			System.debug('permissions deleted');	
			
			Map<String,Id> permissionKBMap = new Map<String,Id>{
				'Edit' => Utils.getPermissionSetIdByPermissionSetName('ERM_EventOwner'),
					'Read' => Utils.getPermissionSetIdByPermissionSetName('ERM_EventParticipant'),
					'BG' => Utils.getPermissionSetIdByPermissionSetName('ERM_Session_BG_Lead')
					};
						
						List<Event__c> eventsList = [select id, Customer_Solution_Architect__c, Event_Host__c, Marketing__c, RecordTypeId 
													 from event__C ];
			List<event_registration__C> evRegistrationList = [select id, user__c,
															  EventMarketingMember__c, EventCustomerSolutionArchitectMember__c, EventHostMember__c,  
															  event__r.RecordTypeId from event_registration__C ];
			List<session__C> sessionList = [select id, owner__C, event__r.RecordTypeId from session__C ];
			
			Set<Id> ownerList = new Set<Id>();
			Set<Id> participantList = new Set<Id>();
			Set<Id> bGList = new Set<Id>();
			
			//to know active users
			Set<Id> usersSet =  new Set<Id>();
			
			
			final Id eventERMRT = Utils.MapRecordType('Event__c').get('ERM');
			
			for(Event__c ev : eventsList){
				if(ev.RecordTypeId == eventERMRT){
					if(ev.Event_Host__c!=null && !ownerList.contains(ev.Event_Host__c)){
						ownerList.add(ev.Event_Host__c);
						usersSet.add(ev.Event_Host__c);
					}
					if(ev.Marketing__c!=null && !ownerList.contains(ev.Marketing__c)){
						ownerList.add(ev.Marketing__c);
						usersSet.add(ev.Marketing__c);
					}
					if(ev.Customer_Solution_Architect__c!=null && !ownerList.contains(ev.Customer_Solution_Architect__c)){
						ownerList.add(ev.Customer_Solution_Architect__c);
						usersSet.add(ev.Customer_Solution_Architect__c);
					}
				}
				
			}
			
			for(Session__c s : sessionList){
				if(s.event__r.RecordTypeId == eventERMRT){
					if(s.Owner__c!=null && !bGList.contains(s.Owner__c)){
						bGList.add(s.Owner__c);
						usersSet.add(s.Owner__c);
					}
				}
			}
			
			for(event_registration__C part : evRegistrationList){
				if(part.event__r.RecordTypeId == eventERMRT){
					if(part.EventHostMember__c != part.user__c &&  part.EventCustomerSolutionArchitectMember__c != part.user__c &&  part.EventMarketingMember__c != part.user__c) {
						   if(part.user__c!=null && !participantList.contains(part.user__c)){
							   participantList.add(part.user__c);
							   usersSet.add(part.user__c);
						   }
					   }
				}
				
			}
			
			//to obtain user license and filter by Salesforce only
			Map<Id, User> users = new Map<Id, User>([select id, profileId from user where id in : usersSet]);
			Set<Id> setProfile = new Set<Id>();
			for(User u : users.values()){
				setProfile.add(u.profileId);
			}
			Map<Id, Profile> profiles = new Map<Id, Profile>([select id, UserLicense.name from profile where id in : setProfile]) ;
			
			System.debug('ownerList '+ownerList);  
			System.debug('bGList '+bGList);  
			System.debug('participantList '+participantList);  
			
			
			Map<Id, User> idUserMap = new Map<Id, User>(new List<User>(EM_User.getAllUsers(usersSet)));
			
			
			List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
			
			for(ID userId : ownerList){
				if(idUserMap.get(userId).isActive && profiles.get(users.get(userId).ProfileID).UserLicense.name=='Salesforce'){
					PermissionSetList.add(new PermissionSetAssignment(
						PermissionSetId = permissionKBMap.get('Edit'),
						AssigneeId = userId));
				}
				
			}
		   
				for(ID userId : bGList){
					if(idUserMap.get(userId).isActive && profiles.get(users.get(userId).ProfileID).UserLicense.name=='Salesforce'){
						PermissionSetList.add(new PermissionSetAssignment(PermissionSetId = permissionKBMap.get('BG'), AssigneeId = userId));
					}
				}
				
				for(ID userId : participantList){
					if(idUserMap.get(userId).isActive && profiles.get(users.get(userId).ProfileID).UserLicense.name=='Salesforce'){
						PermissionSetList.add(new PermissionSetAssignment( PermissionSetId = permissionKBMap.get('Read'), AssigneeId = userId));
					}
				}
			
			
			System.debug('PermissionSetList '+PermissionSetList);  
			
			upsert PermissionSetList;
			System.debug('end ERM_ScriptUpdatePermissionSets');			
		}
		catch(Exception e)
		{
			system.debug('exception ERM_ScriptUpdatePermissionSets: '+e.getLineNumber()+' ' +e.getMessage());
		} 
	}
}