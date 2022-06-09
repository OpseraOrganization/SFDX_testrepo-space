@isTest(seeAllData=false) 
public class BatchPSROUpdateTest 
{
	Private static List<Account> accountList = new List<Account>();
	private static List<Opportunity> PSROList = new List<Opportunity>();
	Private static List<opportunity> optyList = new List<Opportunity>();
	Private static List<Nokia_Financial_Calendar__c> nfcList = new List<Nokia_Financial_Calendar__c>();
	Private static List<Dated_Exchange_Rates__c> derList = new List<Dated_Exchange_Rates__c>();
	Private static Id PSRORecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.PSRO_RECORD_TYPE).getRecordTypeId();
	Private static Id DirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	
	

	static testMethod void currencyEUR() 
	{
			
			nfcList = TestDataFactory.nokiaFinCalCreation(1);
			nfcList[0].Name = '2020 - P01';
			nfcList[0].Period_Number__c = '1';
			nfcList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			nfcList[0].End_Date__c = Date.newInstance(2020, 01, 31);
			insert nfcList;
			
			derList = TestDataFactory.datedExchnageRateCreation(1);
			derList[0].CurrencyIsoCode = 'EUR';
			derList[0].Exchange_Rate__c = 2;
			derList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			derList[0].DER_Period__c = nfcList[0].id;
			insert derList;
			
			
			
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			System.debug('test accountList' + accountList);
			optyList =  TestDataFactory.OpportunityCreation(1,accountList[0]);
			optyList[0].currencyISOCODE = 'EUR';
			optyList[0].StageName = 'Develop Opportunity';
			optyList[0].Phase_Status__c = 'Opportunity in Progress';
			
			database.insert(optyList);
			
			PSROList = TestDataFactory.preSalesOpportunityCreation(1,accountList[0],optyList[0]);
			PSROList[0].StageName = 'Identify Opportunity';
			PSROList[0].RecordTypeId  = PSRORecordTypeId ;
			PSROList[0].PSR_Total_Cost_In_Euro__c = 4;
			PSROList[0].PSR_Total_Sales_Value_In_Euro__c = 1;
			database.insert(PSROList);
			
			Test.startTest(); 
			BatchPSROUpdate PSRO = new BatchPSROUpdate(derList);
			Database.executeBatch(PSRO);
			Test.stopTest();
			
			opportunity PSR = [select PSR_Total_Cost_In_Euro__c,PSR_Total_Sales_Value_In_Euro__c, PSR_Total_Sales_Value_in_Local_Currency__c, PSR_Total_Cost_in_Local_Currency__c from opportunity where RecordTypeId = :PSRORecordTypeId];  
			
	} 
	static testMethod void currencyEURExcep() 
	{
	
			nfcList = TestDataFactory.nokiaFinCalCreation(1);
			nfcList[0].Name = '2020 - P01';
			nfcList[0].Period_Number__c = '1';
			nfcList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			nfcList[0].End_Date__c = Date.newInstance(2020, 01, 31);
			insert nfcList;
			
			Dated_Exchange_Rates__c der = new Dated_Exchange_Rates__c();
			insert der;
			
			Dated_Exchange_Rates__c der1 = new Dated_Exchange_Rates__c();
			insert der1;
			
			derList.add(der1);
	 
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			optyList =  TestDataFactory.OpportunityCreation(1,accountList[0]);
			optyList[0].currencyISOCODE = 'EUR';
			optyList[0].StageName = 'Develop Opportunity';
			optyList[0].Phase_Status__c = 'Opportunity in Progress';
			database.insert(optyList);
			PSROList = TestDataFactory.preSalesOpportunityCreation(1,accountList[0],optyList[0]);
			PSROList[0].StageName = 'Identify Opportunity';
			PSROList[0].RecordTypeId  = PSRORecordTypeId ;
			
			database.insert(PSROList);
			
			Test.startTest(); 
			BatchPSROUpdate PSRO = new BatchPSROUpdate(derList);
			Database.executeBatch(PSRO);
			Test.stopTest();
			
			opportunity PSR = [select PSR_Total_Cost_In_Euro__c,PSR_Total_Sales_Value_In_Euro__c, PSR_Total_Sales_Value_in_Local_Currency__c, PSR_Total_Cost_in_Local_Currency__c from opportunity where RecordTypeId = :PSRORecordTypeId ];  
	 
			System.assertequals(PSR.PSR_Total_Cost_In_Euro__c,0);
			System.assertequals(PSR.PSR_Total_Sales_Value_In_Euro__c,0);
	} 
	static testMethod void currencyEURZero() 
	{
			Nokia_Financial_Calendar__c nfc = new Nokia_Financial_Calendar__c();
			nfc.Name = '2020 - P01';
			nfc.Period_Number__c = '1';
			nfc.Start_Date__c = Date.newInstance(2020, 01, 01);
			nfc.End_Date__c = Date.newInstance(2020, 01, 31);
			insert nfc;
			
			Dated_Exchange_Rates__c der = new Dated_Exchange_Rates__c();
			der.CurrencyIsoCode = 'EUR';
			der.Exchange_Rate__c = 2;
			der.Start_Date__c = Date.newInstance(2020, 01, 01);
			der.DER_Period__c = nfc.id;
			insert der;
			
			derList.add(der);
			
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			optyList =  TestDataFactory.OpportunityCreation(1,accountList[0]);
			optyList[0].currencyISOCODE = 'EUR';
			optyList[0].StageName = 'Develop Opportunity';
			optyList[0].Phase_Status__c = 'Opportunity in Progress';
			database.insert(optyList);
			PSROList = TestDataFactory.preSalesOpportunityCreation(1,accountList[0],optyList[0]);
			PSROList[0].StageName = 'Identify Opportunity';
			PSROList[0].RecordTypeId  = PSRORecordTypeId ;
			PSROList[0].PSR_Total_Cost_In_Euro__c = 3;
			PSROList[0].PSR_Total_Sales_Value_In_Euro__c = 1;
	 
			database.insert(PSROList);
			
			Test.startTest(); 
			BatchPSROUpdate PSRO = new BatchPSROUpdate(derList);
			Database.executeBatch(PSRO);
			Test.stopTest();
			
			opportunity PSR = [select PSR_Total_Cost_In_Euro__c,PSR_Total_Sales_Value_In_Euro__c, PSR_Total_Sales_Value_in_Local_Currency__c, PSR_Total_Cost_in_Local_Currency__c from opportunity where RecordTypeId = :PSRORecordTypeId ];  
			
			System.assertequals(PSR.PSR_Total_Cost_In_Euro__c,0);
			System.assertequals(PSR.PSR_Total_Sales_Value_In_Euro__c,0);
	} 
	 static testMethod void currencyUSD() 
	{
			nfcList = TestDataFactory.nokiaFinCalCreation(1);
			nfcList[0].Name = '2020 - P01';
			nfcList[0].Period_Number__c = '1';
			nfcList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			nfcList[0].End_Date__c = Date.newInstance(2020, 01, 31);
			insert nfcList;
			
			derList = TestDataFactory.datedExchnageRateCreation(1);
			derList[0].CurrencyIsoCode = 'USD';
			derList[0].Exchange_Rate__c = 1;
			derList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			derList[0].DER_Period__c = nfcList[0].id;
			insert derList;
			
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			optyList =  TestDataFactory.OpportunityCreation(1,accountList[0]);
			optyList[0].currencyISOCODE = 'USD';
			optyList[0].StageName = 'Develop Opportunity';
			optyList[0].Phase_Status__c = 'Opportunity in Progress';
			database.insert(optyList);
			PSROList = TestDataFactory.preSalesOpportunityCreation(1,accountList[0],optyList[0]);
			PSROList[0].StageName = 'Identify Opportunity';
			PSROList[0].RecordTypeId  = PSRORecordTypeId ;
			PSROList[0].PSR_Total_Cost_In_Euro__c = 9;
			PSROList[0].PSR_Total_Sales_Value_In_Euro__c = 6;
			PSROList[0].currencyISOCODE = 'USD';
			database.insert(PSROList);
			
			Test.startTest(); 
			BatchPSROUpdate PSRO = new BatchPSROUpdate(derList);
			Database.executeBatch(PSRO);
			Test.stopTest();
			
			opportunity PSR = [select PSR_Total_Cost_In_Euro__c,PSR_Total_Sales_Value_In_Euro__c, PSR_Total_Sales_Value_in_Local_Currency__c, PSR_Total_Cost_in_Local_Currency__c from opportunity where RecordTypeId = :PSRORecordTypeId ];  
	} 
	 static testMethod void currencyUSDZero() 
	{
			nfcList = TestDataFactory.nokiaFinCalCreation(1);
			nfcList[0].Name = '2020 - P01';
			nfcList[0].Period_Number__c = '1';
			nfcList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			nfcList[0].End_Date__c = Date.newInstance(2020, 01, 31);
			insert nfcList;
			
			derList = TestDataFactory.datedExchnageRateCreation(1);
			derList[0].CurrencyIsoCode = 'USD';
			derList[0].Exchange_Rate__c = 2;
			derList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			derList[0].DER_Period__c = nfcList[0].id;
			insert derList;
	 
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			optyList =  TestDataFactory.OpportunityCreation(1,accountList[0]);
			optyList[0].currencyISOCODE = 'USD';
			optyList[0].StageName = 'Develop Opportunity';
			optyList[0].Phase_Status__c = 'Opportunity in Progress';
			database.insert(optyList);
			PSROList = TestDataFactory.preSalesOpportunityCreation(1,accountList[0],optyList[0]);
			PSROList[0].StageName = 'Identify Opportunity';
			PSROList[0].RecordTypeId  = PSRORecordTypeId ;
			PSROList[0].PSR_Total_Cost_In_Euro__c = 0;
			PSROList[0].PSR_Total_Sales_Value_In_Euro__c = 0;
			
			database.insert(PSROList);
			
			Test.startTest(); 
			BatchPSROUpdate PSRO = new BatchPSROUpdate(derList);
			Database.executeBatch(PSRO);
			Test.stopTest();
			
			opportunity PSR = [select PSR_Total_Cost_In_Euro__c,PSR_Total_Sales_Value_In_Euro__c, PSR_Total_Sales_Value_in_Local_Currency__c, PSR_Total_Cost_in_Local_Currency__c from opportunity where RecordTypeId = :PSRORecordTypeId ];  
			
			System.assertequals(PSR.PSR_Total_Cost_In_Euro__c,0);
			System.assertequals(PSR.PSR_Total_Sales_Value_In_Euro__c,0);
	}  
		static testMethod void closedOpty() 
	{
			nfcList = TestDataFactory.nokiaFinCalCreation(1);
			nfcList[0].Name = '2020 - P01';
			nfcList[0].Period_Number__c = '1';
			nfcList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			nfcList[0].End_Date__c = Date.newInstance(2020, 01, 31);
			insert nfcList;
			
			derList = TestDataFactory.datedExchnageRateCreation(1);
			derList[0].CurrencyIsoCode = 'USD';
			derList[0].Exchange_Rate__c = 2;
			derList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			derList[0].DER_Period__c = nfcList[0].id;
			insert derList;
	 
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			optyList =  TestDataFactory.OpportunityCreation(1,accountList[0]);
			optyList[0].currencyISOCODE = 'USD';
			optyList[0].StageName = 'Develop Opportunity';
			optyList[0].Phase_Status__c = 'Opportunity in Progress';
			database.insert(optyList);
			PSROList = TestDataFactory.preSalesOpportunityCreation(1,accountList[0],optyList[0]);
			PSROList[0].StageName = 'Cancelled';
			PSROList[0].RecordTypeId  = PSRORecordTypeId ;
			PSROList[0].PSR_Total_Cost_In_Euro__c = 0;
			PSROList[0].PSR_Total_Sales_Value_In_Euro__c = 0;
			
			database.insert(PSROList);
			
			Test.startTest(); 
			BatchPSROUpdate PSRO = new BatchPSROUpdate(derList);
			Database.executeBatch(PSRO);
			Test.stopTest();
			
			opportunity PSR = [select PSR_Total_Cost_In_Euro__c,PSR_Total_Sales_Value_In_Euro__c, PSR_Total_Sales_Value_in_Local_Currency__c, PSR_Total_Cost_in_Local_Currency__c from opportunity where RecordTypeId = :PSRORecordTypeId ];  
			
			System.assertequals(PSR.PSR_Total_Cost_In_Euro__c,0);
			System.assertequals(PSR.PSR_Total_Sales_Value_In_Euro__c,0);
	} 
	
	
	
		static testMethod void currencyEURPSRO() 
	{
			
			nfcList = TestDataFactory.nokiaFinCalCreation(1);
			nfcList[0].Name = '2020 - P01';
			nfcList[0].Period_Number__c = '1';
			nfcList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			nfcList[0].End_Date__c = Date.newInstance(2020, 01, 31);
			insert nfcList;
			
			derList = TestDataFactory.datedExchnageRateCreation(1);
			derList[0].CurrencyIsoCode = 'EUR';
			derList[0].Exchange_Rate__c = 2;
			derList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			derList[0].DER_Period__c = nfcList[0].id;
			insert derList;
			
			
			
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			System.debug('test accountList' + accountList);
			optyList =  TestDataFactory.OpportunityCreation(1,accountList[0]);
			optyList[0].currencyISOCODE = 'EUR';
			optyList[0].StageName = 'Develop Opportunity';
			optyList[0].Phase_Status__c = 'Opportunity in Progress';
			
			database.insert(optyList);
			
			PSROList = TestDataFactory.preSalesOpportunityCreation(1,accountList[0],optyList[0]);
			PSROList[0].StageName = 'Identify Opportunity';
			PSROList[0].RecordTypeId  = PSRORecordTypeId ;
			PSROList[0].PSR_Total_Cost_In_Euro__c = 4;
			PSROList[0].PSR_Total_Sales_Value_In_Euro__c = 1;
			database.insert(PSROList);
			
			Test.startTest(); 
			BatchPSROUpdateEUR  PSRO = new BatchPSROUpdateEUR(derList);
			Database.executeBatch(PSRO);
			Test.stopTest();
			
			opportunity PSR = [select PSR_Total_Cost_In_Euro__c,PSR_Total_Sales_Value_In_Euro__c, PSR_Total_Sales_Value_in_Local_Currency__c, PSR_Total_Cost_in_Local_Currency__c from opportunity where RecordTypeId = :PSRORecordTypeId];  
	} 
	static testMethod void currencyEURExcepPSRO() 
	{
	
			nfcList = TestDataFactory.nokiaFinCalCreation(1);
			nfcList[0].Name = '2020 - P01';
			nfcList[0].Period_Number__c = '1';
			nfcList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			nfcList[0].End_Date__c = Date.newInstance(2020, 01, 31);
			insert nfcList;
			
			Dated_Exchange_Rates__c der = new Dated_Exchange_Rates__c();
			insert der;
			
			Dated_Exchange_Rates__c der1 = new Dated_Exchange_Rates__c();
			insert der1;
			
			derList.add(der1);
	 
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			optyList =  TestDataFactory.OpportunityCreation(1,accountList[0]);
			optyList[0].currencyISOCODE = 'EUR';
			optyList[0].StageName = 'Develop Opportunity';
			optyList[0].Phase_Status__c = 'Opportunity in Progress';
			database.insert(optyList);
			PSROList = TestDataFactory.preSalesOpportunityCreation(1,accountList[0],optyList[0]);
			PSROList[0].StageName = 'Identify Opportunity';
			PSROList[0].RecordTypeId  = PSRORecordTypeId ;
			
			database.insert(PSROList);
			
			Test.startTest(); 
			BatchPSROUpdateEUR  PSRO = new BatchPSROUpdateEUR(derList);
			Database.executeBatch(PSRO);
			Test.stopTest();
			
			opportunity PSR = [select PSR_Total_Cost_In_Euro__c,PSR_Total_Sales_Value_In_Euro__c, PSR_Total_Sales_Value_in_Local_Currency__c, PSR_Total_Cost_in_Local_Currency__c from opportunity where RecordTypeId = :PSRORecordTypeId ];  
	 
			System.assertequals(PSR.PSR_Total_Cost_In_Euro__c,0);
			System.assertequals(PSR.PSR_Total_Sales_Value_In_Euro__c,0);
	} 
	static testMethod void currencyEURZeroPSRO() 
	{
			Nokia_Financial_Calendar__c nfc = new Nokia_Financial_Calendar__c();
			nfc.Name = '2020 - P01';
			nfc.Period_Number__c = '1';
			nfc.Start_Date__c = Date.newInstance(2020, 01, 01);
			nfc.End_Date__c = Date.newInstance(2020, 01, 31);
			insert nfc;
			
			Dated_Exchange_Rates__c der = new Dated_Exchange_Rates__c();
			der.CurrencyIsoCode = 'EUR';
			der.Exchange_Rate__c = 2;
			der.Start_Date__c = Date.newInstance(2020, 01, 01);
			der.DER_Period__c = nfc.id;
			insert der;
			
			derList.add(der);
			
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			optyList =  TestDataFactory.OpportunityCreation(1,accountList[0]);
			optyList[0].currencyISOCODE = 'EUR';
			optyList[0].StageName = 'Develop Opportunity';
			optyList[0].Phase_Status__c = 'Opportunity in Progress';
			database.insert(optyList);
			PSROList = TestDataFactory.preSalesOpportunityCreation(1,accountList[0],optyList[0]);
			PSROList[0].StageName = 'Identify Opportunity';
			PSROList[0].RecordTypeId  = PSRORecordTypeId ;
			PSROList[0].PSR_Total_Cost_In_Euro__c = 3;
			PSROList[0].PSR_Total_Sales_Value_In_Euro__c = 1;
	 
			database.insert(PSROList);
			
			Test.startTest(); 
			BatchPSROUpdateEUR  PSRO = new BatchPSROUpdateEUR(derList);
			Database.executeBatch(PSRO);
			Test.stopTest();
			
			opportunity PSR = [select PSR_Total_Cost_In_Euro__c,PSR_Total_Sales_Value_In_Euro__c, PSR_Total_Sales_Value_in_Local_Currency__c, PSR_Total_Cost_in_Local_Currency__c from opportunity where RecordTypeId = :PSRORecordTypeId ];  
			
			System.assertequals(PSR.PSR_Total_Cost_In_Euro__c,0);
			System.assertequals(PSR.PSR_Total_Sales_Value_In_Euro__c,0);
	} 
	 static testMethod void currencyUSDPSRO() 
	{
			nfcList = TestDataFactory.nokiaFinCalCreation(1);
			nfcList[0].Name = '2020 - P01';
			nfcList[0].Period_Number__c = '1';
			nfcList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			nfcList[0].End_Date__c = Date.newInstance(2020, 01, 31);
			insert nfcList;
			
			derList = TestDataFactory.datedExchnageRateCreation(1);
			derList[0].CurrencyIsoCode = 'USD';
			derList[0].Exchange_Rate__c = 1;
			derList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			derList[0].DER_Period__c = nfcList[0].id;
			insert derList;
			
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			optyList =  TestDataFactory.OpportunityCreation(1,accountList[0]);
			optyList[0].currencyISOCODE = 'USD';
			optyList[0].StageName = 'Develop Opportunity';
			optyList[0].Phase_Status__c = 'Opportunity in Progress';
			database.insert(optyList);
			PSROList = TestDataFactory.preSalesOpportunityCreation(1,accountList[0],optyList[0]);
			PSROList[0].StageName = 'Identify Opportunity';
			PSROList[0].RecordTypeId  = PSRORecordTypeId ;
			PSROList[0].PSR_Total_Cost_In_Euro__c = 9;
			PSROList[0].PSR_Total_Sales_Value_In_Euro__c = 6;
			PSROList[0].currencyISOCODE = 'USD';
			database.insert(PSROList);
			
			Test.startTest(); 
			BatchPSROUpdateEUR PSRO = new BatchPSROUpdateEUR(derList);
			Database.executeBatch(PSRO);
			Test.stopTest();
			
			opportunity PSR = [select PSR_Total_Cost_In_Euro__c,PSR_Total_Sales_Value_In_Euro__c, PSR_Total_Sales_Value_in_Local_Currency__c, PSR_Total_Cost_in_Local_Currency__c from opportunity where RecordTypeId = :PSRORecordTypeId ];  
			
	} 
	 static testMethod void currencyUSDZeroPSRO() 
	{
			nfcList = TestDataFactory.nokiaFinCalCreation(1);
			nfcList[0].Name = '2020 - P01';
			nfcList[0].Period_Number__c = '1';
			nfcList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			nfcList[0].End_Date__c = Date.newInstance(2020, 01, 31);
			insert nfcList;
			
			derList = TestDataFactory.datedExchnageRateCreation(1);
			derList[0].CurrencyIsoCode = 'USD';
			derList[0].Exchange_Rate__c = 2;
			derList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			derList[0].DER_Period__c = nfcList[0].id;
			insert derList;
	 
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			optyList =  TestDataFactory.OpportunityCreation(1,accountList[0]);
			optyList[0].currencyISOCODE = 'USD';
			optyList[0].StageName = 'Develop Opportunity';
			optyList[0].Phase_Status__c = 'Opportunity in Progress';
			database.insert(optyList);
			PSROList = TestDataFactory.preSalesOpportunityCreation(1,accountList[0],optyList[0]);
			PSROList[0].StageName = 'Identify Opportunity';
			PSROList[0].RecordTypeId  = PSRORecordTypeId ;
			PSROList[0].PSR_Total_Cost_In_Euro__c = 0;
			PSROList[0].PSR_Total_Sales_Value_In_Euro__c = 0;
			
			database.insert(PSROList);
			
			Test.startTest(); 
			BatchPSROUpdateEUR PSRO = new BatchPSROUpdateEUR(derList);
			Database.executeBatch(PSRO);
			Test.stopTest();
			
			opportunity PSR = [select PSR_Total_Cost_In_Euro__c,PSR_Total_Sales_Value_In_Euro__c, PSR_Total_Sales_Value_in_Local_Currency__c, PSR_Total_Cost_in_Local_Currency__c from opportunity where RecordTypeId = :PSRORecordTypeId ];  
			
			System.assertequals(PSR.PSR_Total_Cost_In_Euro__c,0);
			System.assertequals(PSR.PSR_Total_Sales_Value_In_Euro__c,0);
	}  
		static testMethod void closedOptyPSRO() 
	{
			nfcList = TestDataFactory.nokiaFinCalCreation(1);
			nfcList[0].Name = '2020 - P01';
			nfcList[0].Period_Number__c = '1';
			nfcList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			nfcList[0].End_Date__c = Date.newInstance(2020, 01, 31);
			insert nfcList;
			
			derList = TestDataFactory.datedExchnageRateCreation(1);
			derList[0].CurrencyIsoCode = 'USD';
			derList[0].Exchange_Rate__c = 2;
			derList[0].Start_Date__c = Date.newInstance(2020, 01, 01);
			derList[0].DER_Period__c = nfcList[0].id;
			insert derList;
	 
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			optyList =  TestDataFactory.OpportunityCreation(1,accountList[0]);
			optyList[0].currencyISOCODE = 'USD';
			optyList[0].StageName = 'Develop Opportunity';
			optyList[0].Phase_Status__c = 'Opportunity in Progress';
			database.insert(optyList);
			PSROList = TestDataFactory.preSalesOpportunityCreation(1,accountList[0],optyList[0]);
			PSROList[0].StageName = 'Cancelled';
			PSROList[0].RecordTypeId  = PSRORecordTypeId ;
			PSROList[0].PSR_Total_Cost_In_Euro__c = 0;
			PSROList[0].PSR_Total_Sales_Value_In_Euro__c = 0;
			
			database.insert(PSROList);
			
			Test.startTest(); 
			BatchPSROUpdateEUR PSRO = new BatchPSROUpdateEUR(derList);
			Database.executeBatch(PSRO);
			Test.stopTest();
			
			opportunity PSR = [select PSR_Total_Cost_In_Euro__c,PSR_Total_Sales_Value_In_Euro__c, PSR_Total_Sales_Value_in_Local_Currency__c, PSR_Total_Cost_in_Local_Currency__c from opportunity where RecordTypeId = :PSRORecordTypeId ];  
			
			System.assertequals(PSR.PSR_Total_Cost_In_Euro__c,0);
			System.assertequals(PSR.PSR_Total_Sales_Value_In_Euro__c,0);
	}

}