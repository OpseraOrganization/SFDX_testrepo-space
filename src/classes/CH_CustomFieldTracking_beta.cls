/****************************************
 * Class Name : CH_CustomFieldTracking_beta 
 * Created Date: 24 September 2019
 * Created By : SFDC
 * Last Modified by: SFDC
 * Last Modified Date: 24 September 2019
 * Description : Call trackFieldChanges(map<id, Case> oldCases, map<id, Case> newCases) 
 * to track changes according to Custom setting 'CH_AuditTrailFields__c'. 
 * Changes detected will be passed to a queable class for inserting into the db after the transaction is complete.
 * No changes will result in no queable job. Queable job is preferred to allow reflection.
 * Test Class: Tested when Cases are inserted
 *****************************************/

public with sharing class CH_CustomFieldTracking_beta {
	static map<id, caseFieldUpdate> transactionChanges = new map<id, caseFieldUpdate>();

	public static Id trackFieldChanges(map<id, Case> oldCases, Case[] newCases){	
		//System.debug(LoggingLevel.INFO,'## trackFieldChanges START');
		map<id, caseFieldUpdate> newUpdates = new map<id, caseFieldUpdate>();
		for (Case c : newCases) {
			Case newCase = c;
			Case oldCase = oldCases.get(c.Id);
			caseFieldUpdate changes = collectFieldChanges(oldCase, newCase);
			if (changes.size()>0) {
				//System.debug(LoggingLevel.INFO,'## Field changes for case '+c.Id+': '+changes.size()+': '+changes);
				appendAndDeduplicateChanges(newUpdates, c.Id, changes);
			}
		}
		if (newUpdates.size()>0) return queueChanges(newUpdates);
		return null;
	}

	static map<id, caseFieldUpdate> appendAndDeduplicateChanges(map<id, caseFieldUpdate> newUpdates, Id sObjectId, caseFieldUpdate thisUpdate) {
		if (transactionChanges.containsKey(sObjectId)) {
			caseFieldUpdate lastUpdate = transactionChanges.get(sObjectId);
			
			// Deduplicate. If the field exists already (from another trigger pass for example), compare the new Value. 
			for (String fieldName : thisUpdate.getFieldNames()) {

				if (lastUpdate.getFieldNames().contains(fieldName)) {
					Object lastNewVal = lastUpdate.getNew(fieldName);
					Object currNewVal = thisUpdate.getNew(fieldName);

					if (lastNewVal == currNewVal) {

						// This is the same, remove the field from the change as it will have already been processed
						System.debug(LoggingLevel.INFO,'## Field changes for case '+sObjectId+': is NOW NEW. REMOVING this field from the update list: '+fieldName);
						thisUpdate.remove(fieldName);

					} else {
						// Not the same, update the transaction cache, keep the change
						System.debug(LoggingLevel.INFO,'## Field changes for case '+sObjectId+' ARE ADDITIONAL. This field will be queued additionally for audit '+fieldName);
						lastUpdate.put(thisUpdate.getOld(fieldName),thisUpdate.getNew(fieldName),fieldName);

					}

				} else {
					// Not tracked before, update the transaction cache, keep the change
					System.debug(LoggingLevel.INFO,'## All field changes for case '+sObjectId+' ARE NEW for this whole transaction');
					lastUpdate.put(thisUpdate.getOld(fieldName),thisUpdate.getNew(fieldName),fieldName);
				}
			}

			// If any fields remain, then return the changes to be queued for writing to the db
			if (thisUpdate.size() > 0) {
				newUpdates.put(sObjectId,thisUpdate);
			} else if (newUpdates.containsKey(sObjectId)) {
				newUpdates.remove(sObjectId);
			}

		} else {
			// The object record is new, so cache the update and return the changes to be queued
			transactionChanges.put(sObjectId, thisUpdate);
			newUpdates.put(sObjectId, thisUpdate);
		}
		return newUpdates;
	}

	static Id queueChanges(map<id, caseFieldUpdate> newUpdates) {
		Id trackingJobId;
		
		if (newUpdates.size()>0)
		{
			processFieldChanges job = new processFieldChanges(newUpdates);
			trackingJobId = System.enqueueJob(job);
		}

		return trackingJobId;
	}

	static List<CH_AuditTrailFields__c> customAuditFields {
		  get {
				if (customAuditFields == null) {
					// Should be custom metadata type to make this cached at the type level
					customAuditFields = new List<CH_AuditTrailFields__c>([
						SELECT Name, Field_API_Name__c, Field_Tracking_Active__c 
						FROM CH_AuditTrailFields__c 
						WHERE Field_Tracking_Active__c = TRUE 
						LIMIT 200]);
				}			   
				return customAuditFields;
		  }
		  set;
	}

	static caseFieldUpdate collectFieldChanges(Case oldCase, Case newCase) {
		caseFieldUpdate c = new caseFieldUpdate(newCase.Id);

		for (CH_AuditTrailFields__c f : customAuditFields){
			String fieldName = f.Field_API_Name__c;
			try {
				object newValue = newCase.get(fieldName); 
				object oldValue = oldCase.get(fieldName);

				if (newValue!=oldValue)
				{
					c.put(oldValue, newValue, fieldName);
					//System.debug(LoggingLevel.INFO,'## Audit Field found updated: '+fieldName);
				}  
			} catch (exception e) {
				System.debug(LoggingLevel.ERROR,'## Audit Field not found: '+fieldName+' exception: '+e.getMessage());
			}
		}	  

		return c;
	}

	class caseFieldUpdate {
		map<String, object> oldValues = new map<String, object>();
		map<String, object> newValues = new map<String, object>();
		public id sObjectId;
		public datetime timestamp;
		public id userId;
		
		caseFieldUpdate(id sobjectId) {
			this.userId = System.UserInfo.getUserId();
			this.sObjectId = sobjectId;
			this.timestamp = System.now();
		}
		public void put(object oldValue, object newValue, string fieldName) {
			this.userId = System.UserInfo.getUserId();
			this.timestamp = System.now();
			this.oldValues.put(fieldName, oldValue);
			this.newValues.put(fieldName, newValue);
		}
		public object getOld(string fieldName) {
			return oldValues.get(fieldName);
		}
		public object getNew(string fieldName) {
			return newValues.get(fieldName);
		}
		public Set<String> getFieldNames() {
			return newValues.keySet();
		}
		public void remove(string fieldName) {
			oldValues.remove(fieldName);
			newValues.remove(fieldName);
		}
		public integer size() {
			return newValues.size();
		}
	}

	class processFieldChanges implements Queueable {
		map<id, CH_CustomFieldTracking_beta.caseFieldUpdate> transactionChanges;
		map<string, String> fieldLabels = new map<string, String>();
		
		public processFieldChanges(map<id, CH_CustomFieldTracking_beta.caseFieldUpdate> transactionChanges) {
			this.transactionChanges = transactionChanges;
		}

		public void execute(QueueableContext context) {
			System.debug(Logginglevel.INFO,'## processFieldChanges Queueable START, QueueableContext: ' + context);
			CH_Track_Field_Change__c[] trackChanges = new CH_Track_Field_Change__c[]{};

			Map<String, CH_AuditTrailFields__c> customAuditFields = new Map<String, CH_AuditTrailFields__c>();
			for (CH_AuditTrailFields__c f : [
						SELECT Name, Field_API_Name__c, Field_Tracking_Active__c, Store_as_Date_Time__c, Store_as_Long_Text__c
						FROM CH_AuditTrailFields__c 
						WHERE Field_Tracking_Active__c = TRUE 
						LIMIT 200]) {
				customAuditFields.put(f.Field_API_Name__c, f);
			}

			for (id recordId : transactionChanges.keySet()) {
				CH_CustomFieldTracking_beta.caseFieldUpdate c = transactionChanges.get(recordId);
				
				for (string fieldName : c.newValues.keySet()) {
					
					CH_AuditTrailFields__c f = customAuditFields.get(fieldName);
					String displayName = f.Name;
					object newVal = c.getNew(fieldName); 
					object oldVal = c.getOld(fieldName);
					Id sObjectId = c.sObjectId;
					
					try {
						if (newVal!=oldVal) {
							
							CH_Track_Field_Change__c fieldChange = new CH_Track_Field_Change__c( name = displayName,
									Support_Ticket__c = sObjectId,  
									CH_API_name_Field__c = fieldName,
									field_name__c = displayName);

							if (f.Store_as_Long_Text__c) {
								// For long text
								try {
									if (newVal!=null) fieldChange.CH_New_value__c = String.valueOf(newVal).trim().stripHtmlTags().left(34999);
									if (oldVal!=null) fieldChange.CH_Old_value__c = String.valueOf(oldVal).trim().stripHtmlTags().left(34999); 
								} catch (exception longTextCapture){
									System.debug(Logginglevel.ERROR,'##Field track failed:' + displayName + ' ' + fieldName + ' tracking error longTextCapture:' + longTextCapture);
								}
							} else if (f.Store_as_Date_Time__c) {
								// For date fields
								try {
									if (newVal!=null) fieldChange.Date_new__c = (Datetime)newVal;
									if (oldVal!=null) fieldChange.Date_old__c = (Datetime)oldVal; 
								} catch (exception datetimeConvert){
									System.debug(Logginglevel.ERROR,'##Field track failed:' + displayName + ' ' + fieldName + ' tracking error datetimeConvert:' + datetimeConvert);
								}
							} else {
								// For everything else
								try { 
									if (newVal!=null) fieldChange.Text_new__c = String.valueOf(newVal).trim().stripHtmlTags().left(254);
									if (oldVal!=null) fieldChange.Text_old__c = String.valueOf(oldVal).trim().stripHtmlTags().left(254); 
								} catch (exception everythingElse){
									System.debug(Logginglevel.ERROR,'##Field track failed:' + displayName + ' ' + fieldName + ' tracking error everythingElse:' + everythingElse);
								}
							}

							if (fieldChange.Text_new__c != null && fieldChange.Text_new__c == 'true' )  fieldChange.Text_new__c = 'True' ; 
							if (fieldChange.Text_old__c != null && fieldChange.Text_old__c == 'true' )  fieldChange.Text_old__c = 'True' ; 
							if (fieldChange.Text_new__c != null && fieldChange.Text_new__c == 'false' )  fieldChange.Text_new__c = 'False' ; 
							if (fieldChange.Text_old__c != null && fieldChange.Text_old__c == 'false' )  fieldChange.Text_old__c = 'False' ; 

							System.debug(Logginglevel.INFO,'##Tracked Change:' + fieldChange);
							trackChanges.add(fieldChange);
						}
					} catch (exception couldNotTrack){
						System.debug(Logginglevel.ERROR,'##Could not track:' + fieldName + ' :' + couldNotTrack.getMessage());
					}
				}	  
			}

			if (!trackChanges.isEmpty()) {
				System.debug(Logginglevel.INFO,'## Tracking changes to DB:' + trackChanges);
				insert trackChanges;
			}
		}
	}
	//*/
}