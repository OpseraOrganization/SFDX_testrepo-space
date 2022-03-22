@isTest
public class EDUT_InvalidSubjectTest {
	
	static testmethod void invalidCase(){
		Case EDUTCase = new Case();
		EDUTCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('EDU Ticketing').getRecordTypeId();
		EDUTCase.Subject = 'Out of Office';
		EDUTCase.Description = 'Test';
		EDUTCase.Origin = 'Email';
		EDUTCase.Status = 'New';
		EDUTCase.SuppliedEmail = 'test@test.com';
		EDUTCase.Invalid_subject_Capture__c ='Test';
		insert EDUTCase;
		
	   // EDUTCase.Status = 'Invalid';
	  //  update EDUTCase;		
		
		Test.startTest();
			 scheduleInvalidsubject  s=new scheduleInvalidsubject ();
			 String jobid = System.schedule('Invalidschedule', '00 00 * * * ?', s);   
		Test.stopTest();
	  //  Integer invalidCount = [select count() from Case where Status = 'Invalid'];
	   // System.assertEquals(0, invalidCount, 'EDU Invalid case should be zero');
	}
	
   /* static testmethod void scheduledBatchMethod(){
		Test.startTest();   
			EDUT_InvalidCaseDeleterBatch eduBatch = new EDUT_InvalidCaseDeleterBatch();   
			String chron = '0 0 23 * * ?';	  
			String jobid = System.schedule('testScheduledApex', chron, eduBatch);		   
			CronTrigger ct = [Select id , CronExpression from CronTrigger where id = :jobId];
			System.assertEquals(chron,ct.CronExpression);	   
		Test.stopTest();
	} */
}