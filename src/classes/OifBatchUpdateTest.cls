/****************************************
* Class Name : OifBatchUpdateTest
* Created Date: 22 December 2016
* Created By : Accenture
* Modified by: HCL Technologies
* Modified Date: 19-Jan-2021
* Description : Test class for OifBatchUpdate class
*****************************************/

@isTest
Private class OifBatchUpdateTest
{
	/******************************
	*Method Name: Batchtest
	*Description: Test Method to cover batchoifCurrencyUpdate class
	********************************/
	static testMethod void Batchtest()
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
			
			List<Order_Intake_Forecast__c> oif=new List<Order_Intake_Forecast__c>();
			oif=TestDataFactory.orderIntakeCreation(3,opp1,prod,nokiaFinCal);
			database.insert(oif);
			
			List<Dated_Exchange_Rates__c> newExchange=new List<Dated_Exchange_Rates__c>();
			newExchange=TestDataFactory.datedExchnageRateCreation(4);
			newExchange.get(0).DER_Period__c=nokiaFinCal.id;
			newExchange.get(0).CurrencyIsoCode='BRL';
			newExchange.get(1).DER_Period__c=nokiaFinCal.id;			
			newExchange.get(2).DER_Period__c=nokiaFinCal.id;			
			newExchange.get(3).DER_Period__c=nokiaFinCal.id;
			database.insert(newExchange);
			
			List<Dated_Exchange_Rates__c> newExchange1=new List<Dated_Exchange_Rates__c>();
			newExchange1=TestDataFactory.datedExchnageRateCreation(4);
			newExchange1.get(0).DER_Period__c=nokiaFinCal.id;
			newExchange1.get(0).CurrencyIsoCode='BRL';
			newExchange1.get(0).Exchange_Rate__c=3.93;			
			newExchange1.get(1).DER_Period__c=nokiaFinCal.id;
			newExchange1.get(1).CurrencyIsoCode='USD';			
			newExchange1.get(2).DER_Period__c=nokiaFinCal.id;
			newExchange1.get(2).CurrencyIsoCode='EUR';
			newExchange1.get(2).Exchange_Rate__c=1.00;			
			newExchange1.get(3).DER_Period__c=nokiaFinCal.id;			
			database.insert(newExchange1);
			
			oif.get(0).Close_Date__c=NULL;
			oif.get(0).OIF_Value__c=200;
			oif.get(1).OIF_Value__c=400;
			oif.get(2).OIF_Value__c=300;
			database.update(oif);
			
			Test.startTest();
			Id batchJobId = Database.executeBatch(new OifBatchUpdate(newExchange), 200);
			
			List<Order_Intake_Forecast__c> oiflist=new List<Order_Intake_Forecast__c>();
			oiflist=TestDataFactory.orderIntakeCreation(3,opp1,prod,nokiaFinCal);
			database.insert(oiflist);
			
			oiflist.get(0).Close_Date__c=NULL;
			oiflist.get(0).OIF_Value__c=200;
			oiflist.get(0).CurrencyIsoCode='BRL';
			
			oiflist.get(1).OIF_Value__c=400;
			oiflist.get(1).CurrencyIsoCode='USD';
			
			oiflist.get(2).OIF_Value__c=300;
			oiflist.get(2).CurrencyIsoCode='EUR';
			database.update(oiflist);
			
			Test.StopTest();
		}
	}
}