/**
*  Test class for ResetOIFProgramFlagJunction
*
@author	Tang Pengcheng
@created   2018-09-12
@version   1.0
@since	 44.0 (Force.com ApiVersion)
*
@changelog
* 2018-09-12 Tang Pengcheng
* - Created
*/
@isTest
public class ClsResetOIFProgramFlagJunction_Test {
	
	static testMethod void testGeneral(){
		
		List<Account> account = NF_TestDataFactory.getAccounts(1);		
		insert account;
		
		List<opportunity> list_opps = NF_TestDataFactory.getOpportunities(1,account);
		insert list_opps;

		Program_Flag__c pf = new Program_Flag__c();
		pf.Name = 'Test';
		insert pf;
		
		OptyProgramFlagJunction__c opfj = new OptyProgramFlagJunction__c();
		opfj.Program_Flag__c = pf.Id;
		opfj.Opportunity__c = list_opps[0].Id;
		insert opfj;
		
}
	static testmethod void test() {		
		Test.startTest();
		ResetOIFProgramFlagJunction uca = new ResetOIFProgramFlagJunction();
		Database.executeBatch(uca);
		Test.stopTest();
	}
}