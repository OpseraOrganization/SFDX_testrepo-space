/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Get, Upsert and Delete relevent sObject declared in the Lightning and Community Builder
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author		 Randy Grewal   <rgrewal@salesfore.com>
* @modifiedBy	 Randy Grewal   <rgrewal@salesfore.com>
* @maintainedBy   Randy Grewal   <rgrewal@salesfore.com>
* @version		1.1
* @created		2017-05-01
* @modified	   2017-06-12
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.1			rgrewal@salesfore.com
* 2017-06-08	 	Added option to filter query by logged in user and removed System.debug logs
* 2017-06-12		Security Review Fixes:
*		Added isAccessible(), isCreateable(), isDeletable() for CRUD/FLS Enforcement fix
*		Added Typecasting to all injected field API names for SOQL Injection fix
*		Added "with sharing" keyword to Class for Sharing Violation Fix
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public with sharing class CH_AnyEventCalCtrl {
	@AuraEnabled
	public static List<EventObj> getEvents(String sObjectName, String titleField, String startDateTimeField, String endDateTimeField, String descriptionField, String userField, Boolean filterByUserField, string workgroup, string workgroupMember){
		String q = 'SELECT Id,' + 
			String.valueOf(titleField) + ',' + 
			String.valueOf(startDateTimeField) + ',' +
			String.valueOf(endDateTimeField) + ',' +
			String.valueOf(descriptionField) + ',' +
			String.valueOf(userField) + ' FROM ' + 
			String.valueOf(sObjectName) + ' WHERE ' + 
			String.valueOf(userField) + ' = \'' + UserInfo.getUserId() + '\'';
		if (!filterByUserField) {
			q = 'SELECT Id,' + 
				String.valueOf(titleField) + ',' + 
				String.valueOf(startDateTimeField) + ',' +
				String.valueOf(endDateTimeField) + ',' +
				String.valueOf(descriptionField) + ',' +
				String.valueOf(userField) + ' FROM ' + 
				String.valueOf(sObjectName);
		} 
		List<EventObj> eventRecords = new List<EventObj>();
		if((workgroup!=Null && workgroup!='') ||(workgroupMember!=Null && workgroupMember!='')){
			q='SELECT ID, CH_Subject__c, CH_Startdate__c, CH_Enddate__c, Name, OwnerId from ch_workgroup_event__c ';
			if(workgroup!=Null && workgroup!='' && workgroupMember!=Null && workgroupMember!=''){
				q=q+'where CH_Workgroup__c=\''+workgroup +'\'and CH_WorkgroupMember__c=\''+workgroupMember+'\'';
			}
			else if(workgroup!=Null && workgroup!=''){
				q=q+'where CH_Workgroup__c=\''+workgroup +'\'';
			}
			else if(workgroupMember!=Null && workgroupMember!=''){
				q=q+'where CH_WorkgroupMember__c=\''+workgroupMember+'\'';
			}
			List<sObject> sObjectList = Database.query(q);
			if(isAccessible(sObjectName)) {
				for (sObject obj : sObjectList) {
					EventObj newEv = new EventObj(obj.Id,
												  String.valueOf(obj.get(titleField)),
												  DateTime.valueOf(obj.get(startDateTimeField)),
												  DateTime.valueOf(obj.get(endDateTimeField)),
												  String.valueOf(obj.get(descriptionField)),
												  String.valueOf(obj.get(userField))
												 );
					eventRecords.add(newEv);
				}
			}
		}
		return eventRecords;
	}
	
/*	@AuraEnabled	
	public static List <CH_Workgroup_Event__c> getWorkgroupRota(string workgroup, string workgroupMember)
	{
		List <CH_Workgroup_Event__c> WorkgroupRota = new List <CH_Workgroup_Event__c>();
		if(workgroup!=Null && workgroup!='' && workgroupMember!=Null && workgroupMember!=''){
			//			WorkgroupRota = [select Id, Name, CH_Workgroup__r.Name, CH_WorkgroupMember__r.Name, CH_SupportType__c, CH_StartDate__c, CH_EndDate__c, CH_EndOccurence__c from ch_workgroup_event__c where CH_Workgroup__c=:workgroup and CH_WorkgroupMember__c=:workgroupMember];
			WorkgroupRota = [SELECT ID, CH_Subject__c, CH_Startdate__c, CH_Enddate__c, Name, OwnerId from ch_workgroup_event__c where CH_Workgroup__c=:workgroup and CH_WorkgroupMember__c=:workgroupMember];
			system.debug('Both '+ workgroup+' '+workgroupMember);
		}
		else if(workgroup!=Null && workgroup!=''){
			WorkgroupRota = [select  ID, CH_Subject__c, CH_Startdate__c, CH_Enddate__c, Name, OwnerId from ch_workgroup_event__c where CH_Workgroup__c=:workgroup];
			system.debug('workgroup '+ workgroup);
		}
		else if(workgroupMember!=Null && workgroupMember!=''){
			WorkgroupRota = [select ID, CH_Subject__c, CH_Startdate__c, CH_Enddate__c, Name, OwnerId from ch_workgroup_event__c where CH_WorkgroupMember__c=:workgroupMember];
			system.debug('workgroupMember '+workgroupMember);
		}
		system.debug('********list of WorkgroupRota: '+ WorkgroupRota);
		return WorkgroupRota;
	}*/
	
	@AuraEnabled
	public static EventObj upsertEvents(String sEventObj, String sObjectName, String titleField, String startDateTimeField, String endDateTimeField, String descriptionField, String userField){
		EventObj upsertingEvent = (EventObj)JSON.deserialize(sEventObj, EventObj.class);
		sObject newRecord = Schema.getGlobalDescribe().get(sObjectName).newSObject(); 
		if (upsertingEvent.Id != null && isAccessible(sObjectName,'Id')){
			newRecord.put('Id',upsertingEvent.Id);
		} 
		if (isAccessible(sObjectName,titleField)) {
			newRecord.put(titleField, upsertingEvent.title);
		}
		if (isAccessible(sObjectName,startDateTimeField)) {
			newRecord.put(startDateTimeField, upsertingEvent.startDateTime);
		}
		if (isAccessible(sObjectName,endDateTimeField)) {
			newRecord.put(endDateTimeField, upsertingEvent.endDateTime);
		}
		if (isAccessible(sObjectName,descriptionField)) {
			newRecord.put(descriptionField, upsertingEvent.description);
		}
		try {
			upsert newRecord;
			EventObj newEv = new EventObj(newRecord.Id,
										  String.valueOf(newRecord.get(titleField)),
										  DateTime.valueOf(newRecord.get(startDateTimeField)),
										  DateTime.valueOf(newRecord.get(endDateTimeField)),
										  String.valueOf(newRecord.get(descriptionField)),
										  String.valueOf(newRecord.get(userField))
										 );
			return newEv;
		} catch (Exception e) {
			System.debug(e.getMessage());
			return null;
		}
		
	}
	@AuraEnabled
	public static String deleteEvent(String eventId, String sObjectName, String titleField, String startDateTimeField, String endDateTimeField, String descriptionField, String userField){
		String q = 'SELECT Id,' + 
			titleField + ',' + 
			startDateTimeField + ',' +
			endDateTimeField + ',' +
			descriptionField + ',' +
			userField + ' FROM ' + 
			sObjectName + ' WHERE Id = \'' + eventId  + '\'';
		List<sObject> sObjectList = Database.query(q);
		try {
			if(isDeletable(sObjectName)) {
				delete sObjectList;
			}
			return eventId;
		} catch (Exception e) {
			System.debug(e.getMessage());
			return null;
		}
		
	}
	public class EventObj {
		@AuraEnabled
		public String Id {get;set;}
		@AuraEnabled
		public String title {get;set;}
		@AuraEnabled
		public DateTime startDateTime {get;set;}
		@AuraEnabled
		public DateTime endDateTime {get;set;}
		@AuraEnabled
		public String description {get;set;}
		@AuraEnabled
		public String owner {get;set;}
		
		public EventObj(String i,String t, DateTime s, DateTime e, String d, String o){
			this.Id = i;
			this.title = t;
			this.startDateTime = s;
			this.endDateTime = e;
			this.description = d;
			this.owner = o;
		}		
	}
	public static Boolean isAccessible(String sObjectType, String fieldName){
		SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);
		Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();
		DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();
		return fieldDescribe.isAccessible();
	}
	public static Boolean isAccessible(String sObjectType){
		SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);
		return schemaType.getDescribe().isAccessible();
	}
	public static Boolean isCreateable(String sObjectType){
		SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);
		return schemaType.getDescribe().isCreateable();
	}
	public static Boolean isDeletable(String sObjectType){
		SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);
		return schemaType.getDescribe().isDeletable();
	}
}