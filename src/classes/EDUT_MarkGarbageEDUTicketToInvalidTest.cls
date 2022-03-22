@isTest
public class EDUT_MarkGarbageEDUTicketToInvalidTest {
	
	static testmethod void testUpdateStatusInvalid(){
	  /*  Account Acc = new Account();
		Acc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
		Acc.Name='Test Account';
		insert Acc;
	
		Contact cont = new Contact();
		cont.FirstName='Test';
		cont.LastName='Test';
		cont.Accountid= Acc.id;
		cont.Email= 'abc@nokia.com';
		insert cont;*/
	
		Case EDUTCase = new Case();
		Id EDURecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('EDU Ticketing').getRecordTypeId();
		EDUTCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('EDU Ticketing').getRecordTypeId();
		EDUTCase.Subject = 'Test';
		EDUTCase.Description = 'Test';
		EDUTCase.Origin = 'Email';
		EDUTCase.SuppliedEmail = 'test@nokia.com';
		EDUTCase.SuppliedName = 'HR Connections Americas Mailbox';
		EDUTCase.Type='Training Request(Employee)';
		EDUTCase.status='New';
		EDUTCase.ownerid='0053h000000QmLe';
	 //   EDUTCase.Accountid= Acc.id;
	   // EDUTCase.contactid= cont.id;
		
		//EDUTCase.EDUT_Valid_Email__c=true;
		insert EDUTCase;
		
		Test.startTest();
			Case EDUTCaseinsert =new Case();
			EDUTCaseinsert = [select id from Case where suppliedEmail='test@nokia.com'];
			system.debug('@@@@@@EDUTCaseinsert'+EDUTCaseinsert);
			List<Id> CaseIds = new List<Id>();
			CaseIds.add(EDUTCaseinsert.id);
			EDUT_MarkGarbageEDUTicketToInvalid.updateStatusInvalid(CaseIds);
		Test.stopTest();
		list<case> cs =new list<case>();
		cs=[select id from case where status='Invalid' and RecordTypeId =:EDURecordTypeID];
		system.debug('!!!!cscount'+cs);
		Integer invalidCount = [select count() from Case where Status = 'Invalid' and RecordTypeId =:EDURecordTypeID];
		System.assertEquals(1, invalidCount, 'EDU Invalid case should be one');
	}
}