/****************************************
* Class Name : CH_CaseProcessQueueable_Test 
* Created Date: 13 April 2020
* Created By :  TCS
* Description : Test class for CH_CaseProcessQueueable
************/
@isTest
public class CH_CaseProcessQueueable_Test {
	@testSetup	
	static void setuptestdata(){  
		CH_UTIL_TEST.setupCase(false);		 
	}
	
	public static testmethod void queueableTest(){ 
		test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Major', 'Yes', 'CH_NokiaStandardCase', false);   
		Set<Id> caseIdSet = new Set<Id>();		
		Map<Id,Case> oldCaseMap = new Map<Id,Case>();
		QueueableContext context;
		newCase.CH_BlockCases__c = false;
		insert newCase;
		CH_Settings__c cta = new CH_Settings__c();
		cta.Name = 'checkEntitlementExceptionCases';
		cta.SettingValue__c = 'False';
		insert cta;
		CH_Settings__c cta1 = new CH_Settings__c();
		cta1.Name = 'CH_BlacklistCaseReportTrigger';
		cta1.SettingValue__c = 'False';
		insert cta1;
		oldCaseMap.put(newCase.Id,newCase);
		System.debug('CASE BLOCK CASE###'+newCase.CH_BlockCases__c);
		newCase.CH_BlockCases__c = true;
		newCase.CH_EntitlementReport__c='';
		update newCase;
		caseIdSet.add(newCase.Id);
		CH_CaseProcessQueueable cq = new CH_CaseProcessQueueable(caseIdSet,oldCaseMap,true,true);
		cq.execute(context);
		test.stopTest();
	}
	public static testmethod void queueableTest1(){ 
		test.startTest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST2', 'Major', 'Yes', 'CH_NokiaStandardCase', false);   
		Set<Id> caseIdSet = new Set<Id>();		
		Map<Id,Case> oldCaseMap = new Map<Id,Case>();
		
		QueueableContext context;
		insert newCase;
		oldCaseMap.put(newCase.Id,newCase);
		System.debug('CASE BLOCK CASE###'+newCase.CH_BlockCases__c);
		newCase.CH_BlockCases__c = true;
		newCase.CH_EntitlementReport__c='';
		update newCase;
		caseIdSet.add(newCase.Id);
		CH_Settings__c cta = new CH_Settings__c();
		cta.Name = 'checkEntitlementExceptionCases';
		cta.SettingValue__c = 'False';
		insert cta;
		CH_Settings__c cta1 = new CH_Settings__c();
		cta1.Name = 'CH_BlacklistCaseReportTrigger';
		cta1.SettingValue__c = 'False';
		insert cta1;
		CH_CaseProcessQueueable cq = new CH_CaseProcessQueueable(caseIdSet,oldCaseMap,true,true);
		cq.execute(context);
		test.stopTest();
	}
}