@IsTest
public class CH_TrackFieldChangeTriggerHelperTest {
	
	@testSetup	
	static void setuptestdata()
	{  
		// Create custom setting tracking records
		list<CH_AuditTrailFields__c> trailFields = new list<CH_AuditTrailFields__c>();
		trailFields.add(new CH_AuditTrailFields__c(Name = 'Text TEST', Field_API_Name__c = 'Subject', Field_Tracking_Active__c = true));
		trailFields.add(new CH_AuditTrailFields__c(Name = 'Owner TEST', Field_API_Name__c = 'OwnerId', Field_Tracking_Active__c = true));
		trailFields.add(new CH_AuditTrailFields__c(Name = 'DateTime Test', Field_API_Name__c = 'CH_AssignedDate__c', Field_Tracking_Active__c = true));
		trailFields.add(new CH_AuditTrailFields__c(Name = 'boolean Test', Field_API_Name__c = 'CH_Article_Attached__c', Field_Tracking_Active__c = true));	  
		insert trailFields;
		
		CH_UTIL_TEST.setupCase(false);	 
	}
	
	@isTest
	static void trackCaseFieldsChange()
	{ 
		test.starttest();
		
		// Create a CH case
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
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
		
		// Track field changes
		CH_CustomFieldTracking.handleCaseFieldChanges(new map<id, Case>{oldCase.Id => oldCase} , new map<id, Case>{newCase.Id => newCase}  );

		test.stoptest();
		
		// Check that tracking records have been created
		list<CH_Track_Field_Change__c> changes = new list<CH_Track_Field_Change__c>([SELECT name FROM CH_Track_Field_Change__c]);
		system.assert(!changes.isEmpty());
		
		
	}
	
	@isTest
	static void trackCaseFieldsChangeOldOwner()
	{ 
		test.starttest();
		
		// Create a CH case
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);
		Insert newCase;		
		
		// Deep clone the newly created case
		Case oldCase = newCase.clone(true, false, false, false);
		
		newCase.CH_Article_Attached__c = true;
		oldCase.CH_Article_Attached__c = false;
		
		newCase.OwnerId = null;
		oldCase.ownerId = userInfo.getUserId();
		
		// Track field changes
		CH_CustomFieldTracking.handleCaseFieldChanges(new map<id, Case>{oldCase.Id => oldCase} , new map<id, Case>{newCase.Id => newCase}  );

		test.stoptest();
		
		// Check that tracking records have been created
		list<CH_Track_Field_Change__c> changes = new list<CH_Track_Field_Change__c>([SELECT name FROM CH_Track_Field_Change__c]);
		system.assert(!changes.isEmpty());
		
		
	}

}