@isTest(seeAlldata=false)
public without sharing class CH_NEAMessageDigiMop_Test {
	@testSetup static void setup() {
		//Create Support Ticket Record   
		String userval=UserInfo.getUserId();
		List<Case> caseList = new List<Case>();
		caseList = CAPS_TestDataUtil.createCaseRecord(1);
		insert caseList; 
		
		
	}
	@isTest
	public static void testtriggeringpint(){
		Test.startTest();  
		insert  new CH_Settings__c(name='SpecificTimeForOnhold',SettingValue__c='55');
		List<Case> newcaselist =[Select id from case]; 
		Set<ID> caseids = new Set<ID>();
		for(case ocase: newcaselist)
		{
			ID caseid = ocase.id;
			caseids.add(caseid);
			
		}
		CH_NEAMessageDigiMop.invokeNGNAIP(caseids);
		CH_NEAMessageDigiMop.createOutboundLog('a','b','c');
		Test.stopTest();	 
	}
}