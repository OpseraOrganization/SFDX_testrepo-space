@isTest
public class EDUT_RandomNumberGeneratorTest {
	
	
	static testMethod void EDUT_RandomNumberGeneratorTest(){
		
		Case EDUTCase = new Case();
		EDUTCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('EDU Ticketing').getRecordTypeId();
		EDUTCase.Subject = 'Test';
		EDUTCase.Description = 'Test';
		EDUTCase.SuppliedEmail = 'test@test.com';
		insert EDUTCase;
		
		Test.startTest();
		List<Id> CaseIds = new List<Id>();
		CaseIds.add(EDUTCase.id);
		EDUT_RandomNumberGenerator.EDUT_RandomNumberGenerator(CaseIds);
		Test.stopTest();
	}
}