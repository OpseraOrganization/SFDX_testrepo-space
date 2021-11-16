/**************************************** 
* Class Name : BatchOifUpdateTest
* Created Date: 6 February 2018
* Created By : SDC
* Modified by: HCL Technologies
* Modified Date: 19-Jan-2021
* Description : Test class for BatchOifUpdateTest class
*****************************************/

@isTest
private class BatchOifUpdateTest{
	/******************************
*Method Name: Batchtest
*Description: Test Method to cover batchoifCurrencyUpdate class
********************************/
	@testSetup
	static void Batchtest()
	{
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		
		System.RunAs(userCreation)
		{
			Account acc = TestDataFactory.createAccount(1)[0];
			database.insert(acc);
			
			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc)[0];
			opp1.CurrencyIsoCode='BRL';
			database.insert(opp1);
			product2 prod = TestDataFactory.productCreation(1)[0];
			prod.Business_Group__c='MN';
			prod.Family= 'FN';
			database.insert (prod);
			
			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal);			
			
			List<Dated_Exchange_Rates__c> newExchange=new List<Dated_Exchange_Rates__c>();
			newExchange=TestDataFactory.datedExchnageRateCreation(4);
			newExchange.get(0).DER_Period__c=nokiaFinCal.id;
			newExchange.get(0).CurrencyIsoCode='BRL';
			newExchange.get(0).Exchange_Rate__c=3.93;
			
			newExchange.get(1).DER_Period__c=nokiaFinCal.id;
			newExchange.get(1).CurrencyIsoCode='USD';
			
			newExchange.get(2).DER_Period__c=nokiaFinCal.id;
			newExchange.get(2).CurrencyIsoCode='EUR';
			newExchange.get(2).Exchange_Rate__c=1.00;
			
			newExchange.get(3).DER_Period__c=nokiaFinCal.id;
			
			database.insert(newExchange);
			
			List<Order_Intake_Forecast__c> oif=new List<Order_Intake_Forecast__c>();
			oif=TestDataFactory.orderIntakeCreation(3,opp1,prod,nokiaFinCal);
			database.insert(oif);
			
			oif.get(0).Close_Date__c=NULL;
			oif.get(0).OIF_Value__c=200;
			oif.get(0).CurrencyIsoCode='BRL';
			
			oif.get(1).OIF_Value__c=400;
			oif.get(1).CurrencyIsoCode='USD';
			
			oif.get(2).OIF_Value__c=300;
			oif.get(2).CurrencyIsoCode='EUR';
			database.update(oif);
		}
	}
	
	@isTest
	static void testBatchOIFUpdate()
	{
		Test.startTest();
		
		List<Dated_Exchange_Rates__c> newExchange = [SELECT CurrencyIsoCode, Exchange_Rate__c, DER_Period__r.Name, Start_Date__c, DER_Period__c  FROM Dated_Exchange_Rates__c];
		BatchOifUpdate batch = new BatchOifUpdate (newExchange); 
		Database.executeBatch(batch,1);
		
		Test.StopTest();
	}
	
	@isTest
	static void testBatchOIFUpdate_FailedRecords()
	{
		Test.startTest();
		
		List<Dated_Exchange_Rates__c> newExchange = [SELECT CurrencyIsoCode, Exchange_Rate__c, DER_Period__r.Name, Start_Date__c, DER_Period__c  FROM Dated_Exchange_Rates__c];
		BatchOifUpdate batch = new BatchOifUpdate (newExchange); 
		Database.executeBatch(batch,1);
		
		List<Order_Intake_Forecast__c> oifList = [SELECT Id,Opportunity__c,CurrencyIsoCode,BusinessLine__c,OIF_Value_USD__c,OIF_Value__c,OIF_Value_EUR__c,NFC_Start_Date__c,POPlanReceipt__r.name FROM Order_Intake_Forecast__c];
		oiflist.get(0).OIF_Value__c = 0.0;
		update oiflist;
		Database.BatchableContext BC;
		batch.execute(BC,oiflist);
		
		Test.StopTest();
	}
	
	@isTest
	static void testBatchOIFUpdate_EUR()
	{
		Test.startTest();
		
		List<Dated_Exchange_Rates__c> newExchange = [SELECT CurrencyIsoCode, Exchange_Rate__c, DER_Period__r.Name, Start_Date__c, DER_Period__c  FROM Dated_Exchange_Rates__c];
		BatchOifUpdate_EUR batch = new BatchOifUpdate_EUR (newExchange); 
		Database.executeBatch(batch,1);
		
		Test.StopTest();
	}
	
	@isTest
	static void testBatchOIFUpdate_EUR_FailedRecords()
	{
		Test.startTest();
		
		List<Dated_Exchange_Rates__c> newExchange = [SELECT CurrencyIsoCode, Exchange_Rate__c, DER_Period__r.Name, Start_Date__c, DER_Period__c  FROM Dated_Exchange_Rates__c];
		BatchOifUpdate_EUR batch = new BatchOifUpdate_EUR (newExchange); 
		Database.executeBatch(batch,1);
		
		List<Order_Intake_Forecast__c> oifList = [SELECT Id,Opportunity__c,CurrencyIsoCode,BusinessLine__c,OIF_Value_USD__c,OIF_Value__c,OIF_Value_EUR__c,NFC_Start_Date__c,POPlanReceipt__r.name 
												  FROM Order_Intake_Forecast__c
												  WHERE CurrencyIsoCode = 'EUR'];
		oiflist.get(0).OIF_Value__c = 0.0;
		update oiflist;
		Database.BatchableContext BC;
		batch.execute(BC,oiflist);
		
		Test.StopTest();
	}
	
	
	@isTest
	static void testBatchOIFUpdate_USD()
	{
		Test.startTest();
		
		List<Dated_Exchange_Rates__c> newExchange = [SELECT CurrencyIsoCode, Exchange_Rate__c, DER_Period__r.Name, Start_Date__c, DER_Period__c  FROM Dated_Exchange_Rates__c];
		BatchOifUpdate_USD batch = new BatchOifUpdate_USD (newExchange); 
		Database.executeBatch(batch,1);
		
		Test.StopTest();
	}
	
	@isTest
	static void testBatchOIFUpdate_USD_FailedRecords()
	{
		Test.startTest();
		
		List<Dated_Exchange_Rates__c> newExchange = [SELECT CurrencyIsoCode, Exchange_Rate__c, DER_Period__r.Name, Start_Date__c, DER_Period__c  FROM Dated_Exchange_Rates__c];
		BatchOifUpdate_USD batch = new BatchOifUpdate_USD (newExchange); 
		Database.executeBatch(batch,1);
		
		List<Order_Intake_Forecast__c> oifList = [SELECT Id,Opportunity__c,CurrencyIsoCode,BusinessLine__c,OIF_Value_USD__c,OIF_Value__c,OIF_Value_EUR__c,NFC_Start_Date__c,POPlanReceipt__r.name 
												  FROM Order_Intake_Forecast__c
												  WHERE CurrencyIsoCode = 'USD'];
		oiflist.get(0).OIF_Value__c = 0.0;
		update oiflist;
		Database.BatchableContext BC;
		batch.execute(BC,oiflist);
		
		Test.StopTest();
	}
	
	@isTest
	static void testOIFExceptionEmail()
	{
		Test.startTest();
		Map<Id,Order_Intake_Forecast__c> oifList = new Map<Id,Order_Intake_Forecast__c>(
			[SELECT Id,
			 Name,
			 Opportunity__c,
			 Last_Batch_Update_Period__c,
			 CurrencyIsoCode,
			 OIF_Value_USD__c,
			 OIF_Value__c,
			 OIF_Value_EUR__c,
			 POPlanReceipt__r.Name
			 FROM Order_Intake_Forecast__c]);
		String jobId = '1233445';
		OIF_Exception_Email.sendEmail(oifList,jobId,2,Globalconstants.SCHEDULEJOBNAME,oifList.values());
		Map<Id,Order_Intake_Forecast__c> oifEmptyMap = new Map<Id,Order_Intake_Forecast__c>();
		OIF_Exception_Email.sendEmail(oifEmptyMap,jobId,2,Globalconstants.SCHEDULEJOBNAME,oifList.values());
		Test.StopTest();
	}
}