/**
*  Test class for ProgramFlag2Trigger
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
public class ClsProgramFlag2Trigger_Test {
	
	static testMethod void testGeneral() {
		
		Program_Flag__c pf = new Program_Flag__c();
		pf.Name = 'Test';
		
		Program_Flag__c pf2 = new Program_Flag__c();
		pf2.Name = 'Test2';
		insert pf2;
		
		Test.startTest();
		insert pf;
		Test.stopTest();
			
	}
	
}