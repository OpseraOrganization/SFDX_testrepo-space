@istest
private class Batch_CalculateCurrentValueforPSROTest {
	private static String currencyCode = 'USD';
	
	
	private static PSRO_Market_Threshold__c getThreshold(String market, String bg, String bu, Decimal thresholdValue){
		PSRO_Market_Threshold__c thresholdDef = new PSRO_Market_Threshold__c();
		thresholdDef.Market__c = market;
		thresholdDef.Business_group__c = bg;
		thresholdDef.Business_Unit__c = bu;
		thresholdDef.Threshold_Value__c = thresholdValue;
		thresholdDef.Value_exceeded__c = false;
		thresholdDef.Active__c = true;
		thresholdDef.Current_value__c = 0.0;
		return thresholdDef;
	}
	
	static testmethod void Batch_CalculateTest() {
		
		List<PSRO_Market_Threshold__c> thresholdsList = new List<PSRO_Market_Threshold__c>();
		thresholdsList.add(getThreshold(GlobalConstants.MARKET_NORTH_AMERICA, GlobalConstants.LEAD_BG_MN, null, 12000));
		thresholdsList.add(getThreshold(GlobalConstants.MARKET_NORTH_AMERICA, GlobalConstants.BG_CNS, null, 4000));
		thresholdsList.add(getThreshold(GlobalConstants.MARKET_NORTH_AMERICA, GlobalConstants.BG_NI, GlobalConstants.BU_NI_FN , 6000));
		thresholdsList.add(getThreshold(GlobalConstants.MARKET_NORTH_AMERICA, GlobalConstants.BG_NI, GlobalConstants.BU_NI_IPRTG , 2000));
		thresholdsList.add(getThreshold(GlobalConstants.MARKET_NORTH_AMERICA, GlobalConstants.BG_NI, GlobalConstants.BU_NI_OPTICS , 3000));
		insert thresholdsList;
		
		Nokia_Financial_Calendar__c nokiaCalender = TestDataFactory.nokiaFinCalCreation(1)[0];
		nokiaCalender.Start_Date__c = System.today()-2;
		nokiaCalender.End_Date__c = System.today()+6;
		database.insert(nokiaCalender);
		Dated_Exchange_Rates__c exchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
		exchangeRate.CurrencyIsoCode = currencyCode;
		exchangeRate.DER_Period__c = nokiaCalender.Id;
		database.insert(exchangeRate);

		User userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert userCreation;
		
		String roleCode = Label.PSRO_Threshold_send_Mail.split(';')[0];
		Sales_Role__c psroValidator = NF_TestDataFactory.createSalesRole(usercreation,roleCode,GlobalConstants.MARKET_NORTH_AMERICA,'BG Finance PSRO Validator');
		psroValidator.BG__c = GlobalConstants.BG_CNS;
		insert psroValidator;
		
		system.runAs(userCreation){
			
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.L2Name__c = 'Nokia Customers';
			accountCreation.L3Name__c = 'Markets';
			accountCreation.L4Name__c = GlobalConstants.MARKET_NORTH_AMERICA;
			accountCreation.CurrencyIsoCode = currencyCode;
			database.insert(accountCreation);
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];			
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.CurrencyIsoCode = currencyCode;
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			database.insert(optyCreation);
			//Creating Presales Oppty
			Opportunity preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, accountCreation, optyCreation)[0];
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Type__c = GlobalConstants.RISK_ORDER;
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = GlobalConstants.RISK_ORDER_ONLY;
			preSalesTest.PSR_Sales_Value_BG_MN__c = 1000;
			preSalesTest.PSR_Cost_BG_MN__c = 1000;
			preSalesTest.PSR_Sales_Value_BG_CNS__c = 6000;
			preSalesTest.PSR_Cost_BG_CNS__c = 6000;
			preSalesTest.PSR_Sales_Value_BU_NI_FN__c = 400;
			preSalesTest.PSR_Cost_BU_NI_FN__c = 400;
			preSalesTest.PSR_Sales_Value_BU_NI_IPRTG__c = 150;
			preSalesTest.PSR_Cost_BU_NI_IPRTG__c = 150;
			preSalesTest.PSR_Sales_Value_BU_NI_OPTICS__c = 600;
			preSalesTest.PSR_Cost_BU_NI_OPTICS__c = 600;
			preSalesTest.Lead_BG__c = GlobalConstants.BG_CNS;
			preSalesTest.PSR_Is_Cost_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest.PSR_Is_Rv_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest.PSR_Description_Justification__c = 'Test';
			database.insert(preSalesTest);
			presalesTest.NF_PRE_Tech_Field__c = 'Gate Submitted';
			preSalesTest.StageName = GlobalConstants.IN_EXECUTION;
			preSalesTest.Apttus_Approval__Approval_Status__c = 'Approved';
			system.debug('preSalesTest>>>>>>>>>>'+preSalesTest);
			database.update(preSalesTest);
			
			Test.startTest();
			Batch_CalculateCurrentValueforPSRO batch = new Batch_CalculateCurrentValueforPSRO();
			SchedulableContext sc;
			batch.execute(sc);
			Test.stopTest();	
		}
	}
}