@isTest(seeAlldata=false)
public without sharing class CH_NEAMessageDigiMop_Test{
	@testSetup static void setup(){
		//Create Support Ticket Record   
		String userval=UserInfo.getUserId();
		List<Case> caseList = new List<Case>();
		caseList = CAPS_TestDataUtil.createCaseRecord(1);
		insert caseList; 
		//CH_AutomatedLogCollection__c record creation
		CH_AutomatedLogCollection__c autocollectionRecord = new CH_AutomatedLogCollection__c();
		autocollectionRecord.CH_AccountName__c = caseList[0].AccountId;
		autocollectionRecord.CH_Product__c = caseList[0].ProductId;
		autocollectionRecord.CH_Status__c = TRUE;
		insert autocollectionRecord;
		
		//CH_ProductLogType__c record creation
		CH_ProductLogType__c prLogs = new CH_ProductLogType__c();
		prLogs.CH_Product__c = caseList[0].ProductId;
		prLogs.CH_AutoLogCollection__c = TRUE;
		prLogs.CH_Status__c = TRUE;
		prLogs.CH_Category__c = 'Mandatory';
		prLogs.CH_LogType__c = 'Full Snapshot';
		prLogs.CH_CollectorLogType__c = 'Test Collector';
		prLogs.CH_LogType__c = 'Test Log';
		insert prLogs;
	}
	@isTest
	public static void testtriggeringpint(){
		Test.startTest();  
		insert new CH_Settings__c(name='SpecificTimeForOnhold',SettingValue__c='55');
		List<Case> newcaselist =[Select id, CaseNumber, Subject, CH_CustomerDescription__c,CH_Product_Release__c,CH_Product_Release__r.CH_NSNLegacyCode__c,CH_NetworkElementAsset__c,CH_NetworkElementAsset__r.Name,ProductId,product.ProductCode, AccountId from case];
		List<CH_AutomatedLogCollection__c> autoLoglist =[Select id, CH_AccountName__c, CH_Product__c,CH_Status__c from CH_AutomatedLogCollection__c];
		List<CH_ProductLogType__c> prodLoglist =[Select id, CH_Product__c, CH_AutoLogCollection__c, CH_Status__c, CH_Category__c, CH_LogType__c,CH_CollectorLogType__c from CH_ProductLogType__c];
		Set<ID> caseids = new Set<ID>();
		for(case ocase: newcaselist){
			ID caseid = ocase.id;
			caseids.add(caseid);
		}
		CH_NEAMessageDigiMop.invokeNGNAIP(caseids);
		try{
			CH_NEAMessageDigiMop.sendCaseToNDA('testkey12213',newcaselist[0],'Test post');
		}catch(Exception Ex){ /* Do Nothing */
		}
		CH_NEAMessageDigiMop.createOutboundLog('a','b','c','Test Log');
		Test.stopTest();	 
	}
	@isTest
	public static void oneTouchLogTest(){
		Test.startTest();  
		List<Case> newcaselist =[Select id, CaseNumber, Subject, CH_CustomerDescription__c,CH_Product_Release__c,CH_Product_Release__r.CH_NSNLegacyCode__c,CH_NetworkElementAsset__c,CH_NetworkElementAsset__r.Name,ProductId,product.ProductCode, AccountId from case];
		List<CH_AutomatedLogCollection__c> autoLoglist =[Select id, CH_AccountName__c, CH_Product__c,CH_Status__c from CH_AutomatedLogCollection__c];
		List<CH_ProductLogType__c> prodLoglist =[Select id, CH_Product__c, CH_AutoLogCollection__c, CH_Status__c, CH_Category__c, CH_LogType__c,CH_CollectorLogType__c from CH_ProductLogType__c];
		try{
			CH_NEAMessageDigiMop.sendOneTouchLogInformation(newcaselist[0].Id, null, 'Test NEA', prodLoglist);
		}catch(Exception Ex){/* Do Nothing */
		}
		Test.stopTest();	 
	}
}