@isTest
public class CRM_RiskUpsideSubtotal_BatchTest {
	static testmethod  void testPSROLoABatch(){
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);

		Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
		optyCreation.CurrencyIsoCode = 'USD';
		optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
		optyCreation.Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
		database.insert(optyCreation);

		//Creating OIFs 
		Product2 prod = TestDataFactory.productCreation(1)[0];
		prod.Business_Group__c ='MN';
		prod.Family= 'FN';
		database.insert(prod);

		Nokia_Financial_Calendar__c nokiaFinCal = new Nokia_Financial_Calendar__c();
		Date todayDate = system.today();
		String month = String.valueOf(todayDate.month());
		nokiaFinCal.Name = String.valueOf(todayDate.year()) + ' - P' + month.leftPad(2,'0');
		nokiaFinCal.Start_Date__c = system.today();
		nokiaFinCal.End_Date__c = system.today()+20;
		nokiaFinCal.Period_Number__c = month;
		nokiaFinCal.Related_Quarter__c = month;
		database.insert(nokiaFinCal);

		Dated_Exchange_Rates__c exchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
		exchangeRate.DER_Period__c = nokiaFinCal.id;
		exchangeRate.CurrencyIsoCode ='USD';
		database.insert(exchangeRate);

		List<Order_Intake_Forecast__c> oif = TestDataFactory.orderIntakeCreation(2,optyCreation,prod,nokiaFinCal);
		oif[0].CurrencyIsoCode = 'USD';
		oif[1].CurrencyIsoCode='USD';
		oif[0].OIF_Value__c = 500;
		oif[0].Forecast_Category__c = 'Upside';
		database.insert(oif);

		Test.startTest();
			CRM_RiskUpsideSubtotal_Batch batch = new CRM_RiskUpsideSubtotal_Batch();
			Database.executeBatch(batch,10);
		Test.stopTest();
	}
}