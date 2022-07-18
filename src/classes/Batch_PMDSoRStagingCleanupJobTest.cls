/****************************************
 * Class Name : PMDSoRAttributeMappingTest
 * Created Date: 01 Dec 2021
 * Created By : Standav
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for Batch_PMDSoRStagingCleanupJob Class
*****************************************/
@isTest
public with sharing class Batch_PMDSoRStagingCleanupJobTest {
	@isTest
	static void testClassvariables() {
		
		CPQ_PMDSOR_Staging_Data__c staging = new CPQ_PMDSOR_Staging_Data__c();
		staging.NSNCode__c='prd1';

		staging.NSN_Secondary_Category__c = 'Site Model';
		staging.NSN_Tertiary_Category__c = 'OPS';
		staging.Finance_Reporting_BG__c = 'FN';
		staging.Finance_Reporting_BU__c = 'GSSIV';
		staging.Finance_Reporting_PP_Code__c = 'p';
		staging.Finance_Reporting_BL_Code__c = 'b';

		staging.PMDSOR_PCI_UpdateDateTime__c = system.today();
		staging.PMDSOR_SI_UpdateDateTime__c = system.today();
		staging.NSN_Published_to_QtC__c = true;
		staging.Is_Partial_Success__c = false;
		staging.Is_Data_Processed__c = true;
		staging.Is_PLI_Processed__c = true;
		insert staging;
		Test.startTest();
		Batch_PMDSoRStagingCleanupJob  batch = new Batch_PMDSoRStagingCleanupJob();
		SchedulableContext sc;
		batch.execute(sc);
		Database.executebatch(batch, 1);
		Test.stopTest();
		System.assert(true, (new List<CPQ_PMDSOR_Staging_Data__c>([select id from CPQ_PMDSOR_Staging_Data__c])).isEmpty());
	}
}