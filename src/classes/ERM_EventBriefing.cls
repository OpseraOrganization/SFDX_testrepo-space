public without sharing class ERM_EventBriefing {
	@AuraEnabled public String docName{get;set;}
	@AuraEnabled public Event__c event{get;set;}
	@AuraEnabled public String venue{get;set;}
	@AuraEnabled public String accountName{get;set;}
	@AuraEnabled public List<Event_Registration__c> internalParticipants{get;set;}
	@AuraEnabled public List<Event_Registration__c> externalParticipants{get;set;}
	@AuraEnabled public List<Session__c> sessions{get;set;}
	@AuraEnabled public List<ERM_Stakeholder__c> Stakeholders {get;set;}
	   
	@AuraEnabled
	public static ERM_EventBriefing initClass(ID recordID){
		ERM_EventBriefing obj = new ERM_EventBriefing();
		List<Event__c> event = [
			select id, Name, Account__c, Venue__c, Event_Start_Date__c, Event_End_Date__c, Event_Vision__c, RecordType.DeveloperName, Default_Room__r.Name
			from Event__c where id = :recordID Limit 1
		];
		if(event.isEmpty())
			return obj;
		obj.event = event[0];
		//
		List<Venue__c> venue = [ select id, Name from Venue__c where id = :obj.event.Venue__c Limit 1 ];
		obj.venue= '';
		if(!venue.isEmpty())
			obj.venue= venue[0].Name;
		//
		List<Account> accountName = [ select id, Name from Account where id = :obj.event.Account__c Limit 1 ];
		obj.accountName= '';
		if(!accountName.isEmpty())
			obj.accountName= accountName[0].Name;
		//
		obj.externalParticipants = [
			select id, Name, Contact__r.Title from Event_Registration__c
			where Event__c = :obj.event.id and RecordType.DeveloperName = 'External' and Status__c != 'Rejected'
		];
		obj.internalParticipants = [
			select id, Name, User__r.Title, Role__c from Event_Registration__c
			where Event__c = :obj.event.id and RecordType.DeveloperName = 'Internal' and Role__c != 'Content' and Status__c != 'Rejected'
		];
		obj.sessions = [
			select id, Name, Start_time__c, Start_hour__c, Speaker_s_name__c, Content_Owner__c, Session_Notes__c, Room__r.Name
			from Session__c  where Event__c = :obj.event.id
			order by Start_time__c asc, Start_hour__c asc nulls last
		];
		obj.Stakeholders = [select id, Name, Session__c, Participant__r.Name, Role__c from ERM_Stakeholder__c where Event__c = :obj.event.id and Status__c != 'Rejected'];
		obj.docName= obj.event.Name+' - Briefing';
		return obj;
	}
}