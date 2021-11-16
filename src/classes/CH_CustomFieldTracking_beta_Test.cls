@IsTest
public class CH_CustomFieldTracking_beta_Test {

	@testSetup	
	static void setuptestdata()
	{  
		// Create custom setting tracking records
		list<CH_AuditTrailFields__c> trailFields = new list<CH_AuditTrailFields__c>();
		trailFields.add(new CH_AuditTrailFields__c(Name = 'Text TEST', Field_API_Name__c = 'Subject', Field_Tracking_Active__c = true, Store_as_Long_Text__c = TRUE));
		trailFields.add(new CH_AuditTrailFields__c(Name = 'Owner TEST', Field_API_Name__c = 'OwnerId', Field_Tracking_Active__c = true));
		trailFields.add(new CH_AuditTrailFields__c(Name = 'DateTime Test', Field_API_Name__c = 'CH_AssignedDate__c', Field_Tracking_Active__c = true, Store_as_Date_Time__c = TRUE));
		trailFields.add(new CH_AuditTrailFields__c(Name = 'boolean Test', Field_API_Name__c = 'CH_Article_Attached__c', Field_Tracking_Active__c = true)); 
		
		//insert trailFields;
		//suniti
		trailFields.add(new CH_AuditTrailFields__c(Name = 'Assessed Priority', Field_API_Name__c = 'Priority', Field_Tracking_Active__c = true));
		trailFields.add(new CH_AuditTrailFields__c(Name = 'Assessed Outage', Field_API_Name__c = 'CH_AssessedOutage__c', Field_Tracking_Active__c = true));
		insert trailFields;
		//suniti
		
		CH_UTIL_TEST.setupCase(false);
	}
	
	@isTest
	static void trackCaseFieldsChange()
	{ 
		test.starttest();
		
		// Create a CH case
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
		Insert newCase;		
		
		// Deep clone the newly created case
		Case oldCase = newCase.clone(true, false, false, false);
		
		// imitate subject & owner field change
		newCase.subject = 'new subject';
		oldCase.subject = 'old subject';
		
		newCase.CH_AssignedDate__c = DateTime.newInstance(2001, 7, 19, 10, 7, 12);
		oldCase.CH_AssignedDate__c = Datetime.now();
		
		newCase.OwnerId = userInfo.getUserId();
		oldCase.ownerId = null;
		
		//suniti
		newCase.Priority = 'Meduim';
		oldCase.Priority = 'High';
		
		newCase.CH_AssessedOutage__c = 'No';
		oldCase.CH_AssessedOutage__c = 'Yes';
		////suniti
		
				
		// Track field changes
		CH_CustomFieldTracking_beta.trackFieldChanges(new map<id, Case>{oldCase.Id => oldCase} , new List<Case>{newCase});
		
		test.stoptest();
		// Queuable should be logged

		// Check that tracking records have been created
		list<CH_Track_Field_Change__c> changes = new list<CH_Track_Field_Change__c>([SELECT name FROM CH_Track_Field_Change__c]);
		system.assert(!changes.isEmpty());
	  
	}

	@isTest
	static void trackCaseFieldsChangeOldOwner()
	{ 
		test.starttest();
		
		// Create a CH case
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'Nokia Standard Case', false);
		Insert newCase;		
	   
		// Deep clone the newly created case
		Case oldCase = newCase.clone(true, false, false, false); 
		
		newCase.CH_Article_Attached__c = true;
		oldCase.CH_Article_Attached__c = false;
		
		newCase.OwnerId = null;
		oldCase.ownerId = userInfo.getUserId();
	   
		// Track field changes
		CH_CustomFieldTracking_beta.trackFieldChanges(new map<id, Case>{oldCase.Id => oldCase} , new List<Case>{newCase});

		test.stoptest();
		
		// Check that tracking records have been created
		list<CH_Track_Field_Change__c> changes = new list<CH_Track_Field_Change__c>([SELECT name FROM CH_Track_Field_Change__c]);
		system.assert(!changes.isEmpty(), 'No fields where tracked');
	 
	}

}