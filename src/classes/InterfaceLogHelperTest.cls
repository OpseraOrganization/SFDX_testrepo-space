@istest
public class InterfaceLogHelperTest {
	@IsTest public static void test(){
		Test.startTest();
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '1234'; 
		database.insert(accountCreation);
		System.debug('====>'+accountCreation);
		Opportunity optyCreation = New Opportunity();
		optyCreation.Name='Test';
		optyCreation.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		optyCreation.AccountId=accountCreation.Id;
		optyCreation.Business_Type__c='Standard Opportunity';
		optyCreation.StageName='Identify Opportunity';
		optyCreation.Phase_Status__c='Planned';
		optyCreation.Contract_Signing_Entity__c='fALU';
		optyCreation.G3_Planned_Date__c=System.today();
		optyCreation.G4_Planned_Date__c=System.today();
		optyCreation.G5_Planned_Date__c=System.today();
		optyCreation.G6_Planned_Date__c=System.today();
		optyCreation.CloseDate=System.today();
		optyCreation.Amount=1000;
		optyCreation.CurrencyIsoCode='USD'; 
		database.insert(optyCreation);
		System.debug('====>'+optyCreation.Opportunity_ID__c);
		String iLogName='Opportunity #'+[Select ID,Opportunity_ID__c from Opportunity where id=:optyCreation.ID][0].Opportunity_ID__c;
		Interface_Log__c iLog=new Interface_Log__c();
		iLog.Name=iLogName;
		iLog.Comment__c='Success';
		iLog.Interface_Type__c='fALU Oppty Sync';
		iLog.Operation_Type__c='Insert';
		iLog.Status__c='Success';
		iLog.Interface_Request_Sent__c='AccountId: 001d000001TqmbhAAB,RecordTypeId: 012d0000001lBfrAAE,Name: CR405 vCCF: '+
			'Routing ASN.1 CDRs from badfiles to th,Description: ,StageName: Identify Opportunity,Amount: 50000,Probability:'+ 
			'50,CloseDate: 2018-07-31,Type: ,ForecastCategory Pipeline,CurrencyIsoCode: USD,Actual_Contract_Signing_Date__c: ,ALU_I_R'+
			'elevant__c: false,Country__c: United States of America,Customer_Type__c: Existing,End_Customer__c: 001d000001TqmbhAA'+
			'BIndirect_Reseller__c: false,Lead_BL__c: Application & Analytics,Probability_to_Win__c: 50,Reference_Number__c:'+
			'18.US.812891,Status__c: Planned,OpportunityUniqueCrossOrgId__c: 0064100000NzyYNAAZ,Opportunity_Decision_Date__c:,Win_Loss'+
			'_Reason_Comment__c: ,G2_Passed__c: ,G2_Planned__c: ,G6_Passed__c: ,G6_Planned__c: 2018-07-31,Total_FAS_Amount_EUR__c:'+
			'40581.120000000002619,Last_SCRM_SystemModStamp__c:2018-04-03T18:41:36Z,Is_Opportunity_Sync__c: 1';
		insert iLog;
		Boolean checkbox=[Select ID,isOpportunitySync__c from Opportunity where id=:optyCreation.ID][0].isOpportunitySync__c;
		System.debug('====>checkbox '+checkbox);
		//System.assertEquals(true, checkbox);
		Test.stopTest();
		
	}
	@IsTest public static void ifLogTest(){
		Test.startTest();
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '1234'; 
		database.insert(accountCreation);
		System.debug('====>'+accountCreation);
		Opportunity optyCreation = New Opportunity();
		optyCreation.Name='Test';
		optyCreation.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		optyCreation.AccountId=accountCreation.Id;
		optyCreation.Business_Type__c='Standard Opportunity';
		optyCreation.StageName='Identify Opportunity';
		optyCreation.Phase_Status__c='Planned';
		optyCreation.Contract_Signing_Entity__c='fALU';
		optyCreation.G3_Planned_Date__c=System.today();
		optyCreation.G4_Planned_Date__c=System.today();
		optyCreation.G5_Planned_Date__c=System.today();
		optyCreation.G6_Planned_Date__c=System.today();
		optyCreation.CloseDate=System.today();
		optyCreation.Amount=1000;
		optyCreation.CurrencyIsoCode='USD'; 
		database.insert(optyCreation);
		System.debug('====>'+optyCreation.Opportunity_ID__c);
		String iLogName='Opportunity #'+[Select ID,Opportunity_ID__c from Opportunity where id=:optyCreation.ID][0].Opportunity_ID__c;
		Interface_Log__c iLog=new Interface_Log__c();
		iLog.Name=iLogName;
		iLog.Comment__c='Success';
		iLog.Interface_Type__c='Business Hours';
		iLog.Operation_Type__c='Insert';
		iLog.Status__c='Success';
		iLog.Interface_Request_Sent__c='AccountId: 001d000001TqmbhAAB,RecordTypeId: 012d0000001lBfrAAE,Name: CR405 vCCF: '+
			'Routing ASN.1 CDRs from badfiles to th,Description: ,StageName: Identify Opportunity,Amount: 50000,Probability:'+ 
			'50,CloseDate: 2018-07-31,Type: ,ForecastCategory Pipeline,CurrencyIsoCode: USD,Actual_Contract_Signing_Date__c: ,ALU_I_R'+
			'elevant__c: false,Country__c: United States of America,Customer_Type__c: Existing,End_Customer__c: 001d000001TqmbhAA'+
			'BIndirect_Reseller__c: false,Lead_BL__c: Application & Analytics,Probability_to_Win__c: 50,Reference_Number__c:'+
			'18.US.812891,Status__c: Planned,OpportunityUniqueCrossOrgId__c: 0064100000NzyYNAAZ,Opportunity_Decision_Date__c:,Win_Loss'+
			'_Reason_Comment__c: ,G2_Passed__c: ,G2_Planned__c: ,G6_Passed__c: ,G6_Planned__c: 2018-07-31,Total_FAS_Amount_EUR__c:'+
			'40581.120000000002619,Last_SCRM_SystemModStamp__c:2018-04-03T18:41:36Z,Is_Opportunity_Sync__c: 1';
		insert iLog;
		Boolean checkbox=[Select ID,isOpportunitySync__c from Opportunity where id=:optyCreation.ID][0].isOpportunitySync__c;
		System.debug('====>checkbox '+checkbox);
		//System.assertEquals(true, checkbox);
		Test.stopTest();
		
	}
}