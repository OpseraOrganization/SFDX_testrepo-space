public without sharing class CH_CustomPrintableView_Controller {
	//34781
	@AuraEnabled
	public static List<String> getFieldSet(String fieldSetName, String sObjectName) {
		
		// Get a map of field name and field token
		Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(sObjectName.toLowerCase()).getDescribe().Fields.getMap();
		list<string> selectFields = new list<string>();
		if(sObjectName =='CH_CaseTeamHistory__c'){
			selectFields =  new list<string>{'CH_CaseTeamElapsedTime__c', 'CH_CaseTeamEntry__c', 'CH_CaseTeamExit__c', 'CH_CaseTeamOwner__c', 'CH_CaseTeamRole__c', 'CH_CaseTeamWorkgroup__c'};
				}
		else if(sObjectName =='CaseMilestone'){
			selectFields =  new list<string>{'StartDate', 'TargetDate', 'CompletionDate', 'TimeRemainingInMins', 'IsViolated', 'BusinessHoursId'};
				}
		else if(sObjectName =='CH_PendingTimeSuspension__c'){
			selectFields =  new list<string>{'CH_StartTime__c', 'CH_StopTime__c', 'CH_CumulativeTime__c', 'CH_Stage__c', 'CH_InternalStatus__c', 'CreatedById', 'CreatedDate','LastModifiedDate'};
				}
		else if(sObjectName =='CH_Track_Field_Change__c'){
			selectFields =  new list<string>{'Date_old__c', 'Date_new__c', 'text_old__c', 'Text_new__c', 'LastModifiedById', 'LastModifiedDate','CH_Old_value__c', 'CH_New_value__c'};
				}
		else if(sObjectName =='ContentNote'){
			selectFields =  new list<string>{'Title', 'OwnerId', 'TextPreview','LastModifiedDate'};
				}
		else{
			if (fMap != null){
				for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
					Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
					selectFields.add(fd.getName());
				}
			}
		}
		if(selectFields != null && selectFields.size() > 0)
			return selectFields;
		else
			return null;
	}
	
	@auraEnabled
	public static List<sObject> getRelatedRecords(String childObjectName, String referenceFieldName, String referenceFieldValue, Date selectedDate) {
		List<sObject> objList = new List<sObject>();
		
		try {
			String chatterCondition = '';
			String fieldName='';
			if(childObjectName == 'OpenActivity' && childObjectName !=null){
				Case c =[Select Id, CaseNumber, CreatedDate, (Select Subject, Owner.Name, Priority, ActivityDate, IsTask, ActivityType, IsReminderSet, Status, Description, LastModifiedDate,CreatedDate from OpenActivities ORDER BY LastModifiedDate) from Case where Id=:referenceFieldValue];
				
				objList = c.OpenActivities;
			}
			else if(childObjectName == 'ContentNote'){
				Set<Id> contentDocumentIds = new Set<Id>();
				for(ContentDocumentLink conDoc : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :referenceFieldValue]){
					contentDocumentIds.add(conDoc.ContentDocumentId);
				}
				if(contentDocumentIds.size()>0){
					objList = database.query('SELECT Title from ContentNote where Id IN: contentDocumentIds ORDER BY LastModifiedDate DESC');
				}
			}
			else{
				if(childObjectName == 'FeedItem'){
					chatterCondition = ' AND Type = \'TextPost\'';
					fieldName = ', Body, CreatedBy.Name, CreatedDate';
				}
				String dateCondition = '';
				if(selectedDate !=null){
					dateCondition = ' AND DAY_ONLY(LastModifiedDate) =:selectedDate';
				} 
				
				if(childObjectName =='CH_CaseTeamHistory__c' || childObjectName =='CH_PendingTimeSuspension__c' || childObjectName =='CH_Manage_Escalation__c' || childObjectName =='CH_Track_Field_Change__c'){
					fieldName = ', Name';
				}
				else if(childObjectName =='CaseMilestone'){
					fieldName = ', MilestoneType.Name';
				}
				else if(childObjectName =='EmailMessage'){
					fieldName = ',Subject, MessageDate, HasAttachment, ToAddress, TextBody';
				}
				else if(childObjectName =='CaseComment'){
					fieldName = ',IsPublished, CreatedBy.Name, CommentBody';
				}
				
				String query = 'Select Id'+fieldName+' from ' +childObjectName+ ' where ' +referenceFieldName+ ' =: referenceFieldValue'+ dateCondition+chatterCondition+' ORDER BY LastModifiedDate DESC';
				objList = database.query(query);
			}
			
			
			return objList;
		}
		catch(exception e) {
			system.debug('e'+e);
			return null;
		}
	}
	
	@AuraEnabled
	public static String getMostRelatedList(String recordId, Date selectedDate) {
	   
		CH_CustomPrintableViewWrapper parentWrapper = new CH_CustomPrintableViewWrapper();
		parentWrapper.parentObject = 'Case';
		Case c =[Select Id, CaseNumber,LastModifiedDate,CreatedDate, (Select LastModifiedDate,CreatedDate from OpenActivities ORDER BY LastModifiedDate) from Case where Id=:recordId];
			
		parentWrapper.parentName = c.CaseNumber;
		parentWrapper.startDate = c.CreatedDate.date();
		parentWrapper.currentCaseRecord = c; //NOKIASC-36679
		List<CH_CustomPrintableViewWrapper.childWrapper> childwrapperLst = new List<CH_CustomPrintableViewWrapper.childWrapper>();
		
		Map<String, String> relatedObjectsMap = new Map<String, String>{'CH_CaseTeamHistory__c' => 'Case Team History', 'EmailMessage' => 'Emails', 'CaseComment' => 'Support Ticket Comments', 'CaseMilestone' => 'Case Milestones', 'FeedItem' => 'Chatter', 'CH_PendingTimeSuspension__c' => 'Pending Time/Suspensions', 'CH_Manage_Escalation__c' => 'Manage Escalations', 'CH_Track_Field_Change__c' => 'Audit Trails', 'OpenActivity' => 'Open Activities', 'ContentNote' => 'Notes' };
		Map<Date, List<CH_CustomPrintableViewWrapper.childWrapper>> dateSetMap = new Map<Date, List<CH_CustomPrintableViewWrapper.childWrapper>>();
		Map<Date, List<CH_CustomPrintableViewWrapper.childWrapper>> finalDateSetMap = new Map<Date, List<CH_CustomPrintableViewWrapper.childWrapper>>();
		Set<Date> dateSetToOrder = new Set<Date>();
		for(String relatedObj :relatedObjectsMap.keySet()){
			//if(relatedObjects.contains(relatedObj)){
			String  query = null;
			String  referenceField = null;
			if(relatedObj == 'CH_CaseTeamHistory__c' || relatedObj == 'CH_Track_Field_Change__c'){
				referenceField = 'Support_Ticket__c';
			}
			else if(relatedObj == 'CaseComment' || relatedObj == 'EmailMessage' || relatedObj == 'FeedItem'){
				referenceField = 'ParentId';
			}
			else if(relatedObj == 'CaseMilestone'){
				referenceField = 'CaseId';
			}
			else if(relatedObj == 'CH_PendingTimeSuspension__c'){
				referenceField = 'CH_SupportTicket__c';
			}
			else if(relatedObj == 'CH_Manage_Escalation__c'){
				referenceField = 'CH_CaseNumber__c';
			}
			Date recentDate = null;
			if(relatedObj == 'OpenActivity' && c.OpenActivities.size()>0){
				referenceField = 'WhatId';
				for(sObject toShowRelObj : c.OpenActivities){
					DateTime lastModDateTime = (DateTime) toShowRelObj.get('LastModifiedDate');
					Date lastModDate = lastModDateTime.date();
					if(recentDate !=lastModDate){
						recentDate = lastModDate;
						if(dateSetMap.containskey(lastModDate)){
							dateSetMap.get(lastModDate).add(new CH_CustomPrintableViewWrapper.childWrapper(relatedObj, relatedObjectsMap.get(relatedObj), referenceField, lastModDateTime));
						}
						else{
							dateSetMap.put(lastModDate, new List<CH_CustomPrintableViewWrapper.childWrapper>{new CH_CustomPrintableViewWrapper.childWrapper(relatedObj, relatedObjectsMap.get(relatedObj), referenceField, lastModDateTime)});
						}
					}
				} 
				 
			}
			else if(relatedObj == 'ContentNote'){
				referenceField = 'Id';
				Set<Id> contentDocumentIds = new Set<Id>();
				for(ContentDocumentLink conDoc : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId]){
					contentDocumentIds.add(conDoc.ContentDocumentId);
				}
				if(contentDocumentIds.size()>0){
					for(sObject toShowRelObj : database.query('SELECT LastModifiedDate from ContentNote where Id IN: contentDocumentIds ORDER BY LastModifiedDate')){
						DateTime lastModDateTime = (DateTime) toShowRelObj.get('LastModifiedDate');
						Date lastModDate = lastModDateTime.date();
						if(recentDate !=lastModDate){
							recentDate = lastModDate;
							if(dateSetMap.containskey(lastModDate)){
								dateSetMap.get(lastModDate).add(new CH_CustomPrintableViewWrapper.childWrapper(relatedObj, relatedObjectsMap.get(relatedObj), referenceField, lastModDateTime));
							}
							else{
								dateSetMap.put(lastModDate, new List<CH_CustomPrintableViewWrapper.childWrapper>{new CH_CustomPrintableViewWrapper.childWrapper(relatedObj, relatedObjectsMap.get(relatedObj), referenceField, lastModDateTime)});
							}
						}
					} 
				}				
			}
			else{
				query = getCreatableFieldsSOQL(relatedObj, referenceField, recordId,selectedDate);
				if(query !=null){
					
					for(sObject toShowRelObj : database.query(query)){
						DateTime lastModDateTime = (DateTime) toShowRelObj.get('LastModifiedDate');
						Date lastModDate = lastModDateTime.date();
						if(recentDate !=lastModDate){
							recentDate = lastModDate;
							if(dateSetMap.containskey(lastModDate)){
								dateSetMap.get(lastModDate).add(new CH_CustomPrintableViewWrapper.childWrapper(relatedObj, relatedObjectsMap.get(relatedObj), referenceField, lastModDateTime));
							}
							else{
								dateSetMap.put(lastModDate, new List<CH_CustomPrintableViewWrapper.childWrapper>{new CH_CustomPrintableViewWrapper.childWrapper(relatedObj, relatedObjectsMap.get(relatedObj), referenceField, lastModDateTime)});
							}
						}
					}								 
				}	 
			}
			
			// }
		}		
		if(dateSetMap.size()>0){
			List<Date> dateLst = new List<Date>(dateSetMap.keySet());
		   
			dateLst.sort();
			
			for(Date d :dateLst){
				List<CH_CustomPrintableViewWrapper.childWrapper> wr = dateSetMap.get(d);
				wr.sort();
				finalDateSetMap.put(d, wr);
			}
			parentWrapper.allChildDateSetMap = finalDateSetMap;
		}
		system.debug('parentWrapper:: '+json.serialize(parentWrapper));
		return json.serialize(parentWrapper);
	}
	
	public static Map<String, String> getRelatedObjects(string masterObjectName){
		map<string,string> relatedObjectsMap = new map<string,string>();
		list<Schema.Childrelationship> relatedObjectsList = Schema.getGlobalDescribe().get(masterObjectName).getdescribe().getChildRelationships();
		for (Schema.Childrelationship  relatedObject : relatedObjectsList) {
			if(relatedObject.getChildSObject().getDescribe().isUpdateable()
			   && 
			   relatedObject.getChildSObject().getDescribe().getKeyPrefix()!=null
			   && 
			   !relatedObject.getChildSObject().getDescribe().isCustomSetting()
			   &&
			   relatedObject.getChildSObject().getDescribe().isCreateable()
			  )
				relatedObjectsMap.put(relatedObject.getChildSObject().getDescribe().getName(),relatedObject.getChildSObject().getDescribe().getLabel());
			else if(relatedObject.getChildSObject().getDescribe().getName() == 'CaseMilestone'){
				relatedObjectsMap.put(relatedObject.getChildSObject().getDescribe().getName(),relatedObject.getChildSObject().getDescribe().getLabel());
			}
		}
		return relatedObjectsMap;
	}
	
	public static string getCreatableFieldsSOQL(String objectName, String whereConditionField, String recordId, Date selectedDate){
		if(whereConditionField !=null )
		{		String selects = '';
		String chatterCondition = '';
		if(objectName == 'FeedItem'){
			chatterCondition = ' AND Type = \'TextPost\'';
		}
		String dateCondition = '';
		if(selectedDate !=null ){
			dateCondition = ' AND DAY_ONLY(LastModifiedDate) =:selectedDate';
		}
		return 'SELECT Id, LastModifiedDate ' + selects + ' FROM ' + objectName + ' WHERE ' + whereConditionField + ' =:recordId' + dateCondition+chatterCondition+' ORDER BY LastModifiedDate DESC';
	}
	
	else {
		return null;
	}
	}
	
}