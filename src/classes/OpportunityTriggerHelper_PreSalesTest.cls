/****************************************
* Name : OpportunityTriggerHelper_PreSalesTest 
* Author : Accenture
* Description : Test class for OpportunityTriggerHelper_PreSales
*****************************************/
@istest
private class OpportunityTriggerHelper_PreSalesTest {
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id PSR_ReadOnlyRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_PSR_RECORD_TYPE).getRecordTypeId();	
	private static final Id PSR_EditRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.PSR_RECORD_TYPE).getRecordTypeId();
	private static User userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
	private static String currencyCode = 'USD';
	private static Opportunity preSalesTest ;
	private static List<Opportunity> psroList ;
	private static Opportunity optyCreation;
		
	static testMethod void creationAndClosePSRO() {
		insert userCreation;
		system.runAs(userCreation){
			
			Nokia_Financial_Calendar__c nokiaCalender = TestDataFactory.nokiaFinCalCreation(1)[0];
			nokiaCalender.Start_Date__c = System.today()-2;
			nokiaCalender.End_Date__c = System.today()+6;
			database.insert(nokiaCalender);
			Dated_Exchange_Rates__c exchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			exchangeRate.CurrencyIsoCode = currencyCode;
			exchangeRate.DER_Period__c = nokiaCalender.Id;
			database.insert(exchangeRate);
			
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234'; 
			accountCreation.CurrencyIsoCode = currencyCode;
			accountCreation.L4Name__c = GlobalConstants.MARKET_NORTH_AMERICA;
			database.insert(accountCreation);
			
			optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			optyCreation.Lead_BG__c = GlobalConstants.LEAD_BG_MN;
			optyCreation.Lead_BU__c = GlobalConstants.LEAD_BG_MN;
			optyCreation.RecordTypeId= oppDirectRecordTypeId ;
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			optyCreation.CurrencyIsoCode = currencyCode;
			database.insert(optyCreation);
			
			psroList = TestDataFactory.preSalesOpportunityCreation(2, accountCreation, optyCreation);
			preSalesTest = psroList[0];
			
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Type__c = GlobalConstants.RISK_ORDER;
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = GLobalConstants.RISK_ORDER_ONLY;
			preSalesTest.PSR_Cost_BG_CNS__c = 10;
			preSalesTest.PSR_Sales_Value_BG_CNS__c = 10;
			psroList[1].PSR_Pre_Sales_Risk_Opportunity_Type__c = GlobalConstants.RISK_ORDER;
			psroList[1].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = GLobalConstants.RISK_ORDER_ONLY;
			test.startTest();
			database.insert(preSalesTest);
			
			//test number of PSRO for when there is more than 1 child on Sales Oppty
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES=false;
			database.insert(psroList[1]);
			
			//testing notification on close/cancelled
			Map<Id,Opportunity> optyOldMap = new Map<Id,Opportunity>();
			optyOldMap.put(preSalesTest.Id, preSalesTest.clone(true,true,true,true));
			preSalesTest.StageName = 'Cancelled';
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES=false;
			database.update(preSalesTest);
			test.stopTest();
		}
	}
	
	static testMethod void checkCurrencyPSRO() {
		insert userCreation;
		system.runAs(userCreation){
			
			Nokia_Financial_Calendar__c nokiaCalender = TestDataFactory.nokiaFinCalCreation(1)[0];
			nokiaCalender.Start_Date__c = System.today()-2;
			nokiaCalender.End_Date__c = System.today()+6;
			database.insert(nokiaCalender);
			Dated_Exchange_Rates__c exchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			exchangeRate.CurrencyIsoCode = currencyCode;
			exchangeRate.DER_Period__c = nokiaCalender.Id;
			database.insert(exchangeRate);
			
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234'; 
			accountCreation.CurrencyIsoCode = currencyCode;
			accountCreation.L4Name__c = GlobalConstants.MARKET_NORTH_AMERICA;
			database.insert(accountCreation);
			
			optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];	
			optyCreation.Lead_BG__c = GlobalConstants.LEAD_BG_MN;
			optyCreation.Lead_BU__c = GlobalConstants.LEAD_BG_MN;
			optyCreation.RecordTypeId= oppDirectRecordTypeId ;
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			optyCreation.CurrencyIsoCode = currencyCode;
			database.insert(optyCreation);
			
			preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, accountCreation, optyCreation)[0];
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Type__c = GlobalConstants.RISK_ORDER;
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = GLobalConstants.RISK_ORDER_ONLY;
			preSalesTest.PSR_Cost_BG_CNS__c = 10;
			preSalesTest.PSR_Sales_Value_BG_CNS__c = 10;
			test.startTest();
			//test setting currency from ref oppty
			database.insert(preSalesTest);
			//testing when sales oppty currency changes, should apply to all childs
			optyCreation.CurrencyIsoCode = 'EUR';
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES=false;
			database.update(optyCreation);
			//testing changing currency
			preSalesTest.CurrencyIsoCode = currencyCode;
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES=false;
			try{
				database.update(preSalesTest);
			} catch (Exception e) {
	System.assert(e.getMessage().contains(GlobalConstants.YOU_CANNOT_CHANGE_PRE_SALES_OPPORTUNITIES_CURRENCY));
			}
			test.stopTest();
		}
	}
	
	static testMethod void updatePSRO_CostsCalculation() {
		insert userCreation;
		system.runAs(userCreation){
			List<PSRO_Market_Threshold__c> thresholdsList = new List<PSRO_Market_Threshold__c>();
			thresholdsList.add(new PSRO_Market_Threshold__c(
				Market__c = GlobalConstants.MARKET_NORTH_AMERICA,
				Business_group__c = GlobalConstants.LEAD_BG_MN,
				Business_Unit__c = null,
				Threshold_Value__c = 12000,
				Value_exceeded__c = false,
				Active__c = true,
				Current_value__c = 0.0)
							  );
			thresholdsList.add(new PSRO_Market_Threshold__c(
				Market__c = GlobalConstants.MARKET_NORTH_AMERICA,
				Business_group__c = GlobalConstants.BG_CNS,
				Business_Unit__c = null,
				Threshold_Value__c = 4000,
				Value_exceeded__c = false,
				Active__c = true,
				Current_value__c = 0.0)
							  );
			thresholdsList.add(new PSRO_Market_Threshold__c(
				Market__c = GlobalConstants.MARKET_NORTH_AMERICA,
				Business_group__c = GlobalConstants.BG_NI,
				Business_Unit__c = GlobalConstants.BU_NI_FN,
				Threshold_Value__c = 6000,
				Value_exceeded__c = false,
				Active__c = true,
				Current_value__c = 0.0)
							  );
			thresholdsList.add(new PSRO_Market_Threshold__c(
				Market__c = GlobalConstants.MARKET_NORTH_AMERICA,
				Business_group__c = GlobalConstants.BG_NI,
				Business_Unit__c = GlobalConstants.BU_NI_IPRTG,
				Threshold_Value__c = 2000,
				Value_exceeded__c = false,
				Active__c = true,
				Current_value__c = 0.0)
							  );
			thresholdsList.add(new PSRO_Market_Threshold__c(
				Market__c = GlobalConstants.MARKET_NORTH_AMERICA,
				Business_group__c = GlobalConstants.BG_NI,
				Business_Unit__c = GlobalConstants.BU_NI_OPTICS,
				Threshold_Value__c = 3000,
				Value_exceeded__c = false,
				Active__c = true,
				Current_value__c = 0.0)
							  );
			insert thresholdsList;
			List<PSR_Gate_Classification_Logic__c> loaMatrix = new List<PSR_Gate_Classification_Logic__c>();
			loaMatrix.add( new PSR_Gate_Classification_Logic__c(
				Name = 'Test',
				BG_Value__c = GlobalConstants.BG_NI,
				Min_Value__c = 0,
				Max_Value__c = 3000,
				Opportunity_Type__c = GlobalConstants.RISK_ORDER,
				Opportunity_Sub_Type__c = GlobalConstants.RISK_ORDER_ONLY)
						 );
			insert loaMatrix;
			
			Nokia_Financial_Calendar__c nokiaCalender = TestDataFactory.nokiaFinCalCreation(1)[0];
			nokiaCalender.Start_Date__c = System.today()-2;
			nokiaCalender.End_Date__c = System.today()+6;
			database.insert(nokiaCalender);
			Dated_Exchange_Rates__c exchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			exchangeRate.CurrencyIsoCode = currencyCode;
			exchangeRate.DER_Period__c = nokiaCalender.Id;
			database.insert(exchangeRate);
			
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234'; 
			accountCreation.CurrencyIsoCode = currencyCode;
			accountCreation.L4Name__c = GlobalConstants.MARKET_NORTH_AMERICA;
			database.insert(accountCreation);
			
			optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			optyCreation.Lead_BG__c = GlobalConstants.LEAD_BG_MN;
			optyCreation.Lead_BU__c = GlobalConstants.LEAD_BG_MN;
			optyCreation.RecordTypeId= oppDirectRecordTypeId ;
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			optyCreation.CurrencyIsoCode = currencyCode;
			database.insert(optyCreation);
			
			preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, accountCreation, optyCreation)[0];
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Type__c = GlobalConstants.RISK_ORDER;
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = GLobalConstants.RISK_ORDER_ONLY;
			database.insert(preSalesTest);
			
			optyCreation.G4_Approval_Date__c = System.today();
			database.update(optyCreation);
			
			test.startTest();
			preSalesTest.PSR_Sales_Value_BG_CNS__c = 10;
			preSalesTest.PSR_Cost_BG_MN__c = 20;
			preSalesTest.PSR_Automatically_Calc_Estimated_Cost__c=true;
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES=false;
			//testing error when the flag is active and costs are entered manually
			try{
				database.update(preSalesTest);
			} catch (Exception e) {
	System.assert(e.getMessage().contains(GlobalConstants.ERROR_MESSAGE_COSTS_CANT_CHANGE_MANUALLY));
			}
			
			preSalesTest.PSR_Cost_BG_MN__c = null;
			preSalesTest.PSR_Sales_Value_BG_CNS__c = 10;
			preSalesTest.PSR_Sales_Value_BG_MN__c = 20;
			preSalesTest.PSR_Sales_Value_BU_NI_FN__c = 70;
			preSalesTest.PSR_Sales_Value_BU_NI_IPRTG__c = 50;
			preSalesTest.PSR_Sales_Value_BU_NI_OPTICS__c = 900;
			preSalesTest.PSR_Automatically_Calc_Estimated_Cost__c=true;
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES=false;
			//testing the calculation of costs and sales values and the LoA Level
			database.update(preSalesTest);
			test.stopTest();
		}
	}
	
	static testMethod void updatePSRO_Thresholds() {
		insert userCreation;
		String roleCode = Label.PSRO_Threshold_send_Mail.split(';')[0];
		Sales_Role__c psroValidator = NF_TestDataFactory.createSalesRole(usercreation,roleCode,GlobalConstants.MARKET_NORTH_AMERICA,'BG Finance PSRO Validator');
		psroValidator.BG__c = GlobalConstants.BG_NI;
		insert psroValidator;
		system.runAs(userCreation){
			List<PSRO_Market_Threshold__c> thresholdsList = new List<PSRO_Market_Threshold__c>();
			thresholdsList.add(new PSRO_Market_Threshold__c(
				Market__c = GlobalConstants.MARKET_NORTH_AMERICA,
				Business_group__c = GlobalConstants.LEAD_BG_MN,
				Business_Unit__c = null,
				Threshold_Value__c = 12000,
				Value_exceeded__c = false,
				Active__c = true,
				Current_value__c = 0.0)
							  );
			thresholdsList.add(new PSRO_Market_Threshold__c(
				Market__c = GlobalConstants.MARKET_NORTH_AMERICA,
				Business_group__c = GlobalConstants.BG_CNS,
				Business_Unit__c = null,
				Threshold_Value__c = 4000,
				Value_exceeded__c = false,
				Active__c = true,
				Current_value__c = 0.0)
							  );
			thresholdsList.add(new PSRO_Market_Threshold__c(
				Market__c = GlobalConstants.MARKET_NORTH_AMERICA,
				Business_group__c = GlobalConstants.BG_NI,
				Business_Unit__c = GlobalConstants.BU_NI_FN,
				Threshold_Value__c = 6000,
				Value_exceeded__c = false,
				Active__c = true,
				Current_value__c = 0.0)
							  );
			thresholdsList.add(new PSRO_Market_Threshold__c(
				Market__c = GlobalConstants.MARKET_NORTH_AMERICA,
				Business_group__c = GlobalConstants.BG_NI,
				Business_Unit__c = GlobalConstants.BU_NI_IPRTG,
				Threshold_Value__c = 2000,
				Value_exceeded__c = false,
				Active__c = true,
				Current_value__c = 0.0)
							  );
			thresholdsList.add(new PSRO_Market_Threshold__c(
				Market__c = GlobalConstants.MARKET_NORTH_AMERICA,
				Business_group__c = GlobalConstants.BG_NI,
				Business_Unit__c = GlobalConstants.BU_NI_OPTICS,
				Threshold_Value__c = 3000,
				Value_exceeded__c = false,
				Active__c = true,
				Current_value__c = 0.0)
							  );
			insert thresholdsList;
			
			Nokia_Financial_Calendar__c nokiaCalender = TestDataFactory.nokiaFinCalCreation(1)[0];
			nokiaCalender.Start_Date__c = System.today()-2;
			nokiaCalender.End_Date__c = System.today()+6;
			database.insert(nokiaCalender);
			Dated_Exchange_Rates__c exchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			exchangeRate.CurrencyIsoCode = currencyCode;
			exchangeRate.DER_Period__c = nokiaCalender.Id;
			database.insert(exchangeRate);
			
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234'; 
			accountCreation.CurrencyIsoCode = currencyCode;
			accountCreation.L4Name__c = GlobalConstants.MARKET_NORTH_AMERICA;
			database.insert(accountCreation);
			
			optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];	
			optyCreation.Lead_BG__c = GlobalConstants.LEAD_BG_MN;
			optyCreation.Lead_BU__c = GlobalConstants.LEAD_BG_MN;
			optyCreation.RecordTypeId= oppDirectRecordTypeId ;
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			optyCreation.CurrencyIsoCode = currencyCode;
			database.insert(optyCreation);
			
			preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, accountCreation, optyCreation)[0];
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Type__c = GlobalConstants.RISK_ORDER;
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = GLobalConstants.RISK_ORDER_ONLY;
			database.insert(preSalesTest);
			
			test.startTest();
			preSalesTest.PSR_Sales_Value_BG_CNS__c = 10;
			preSalesTest.PSR_Sales_Value_BG_MN__c = 20;
			preSalesTest.PSR_Sales_Value_BU_NI_FN__c = 70;
			preSalesTest.PSR_Sales_Value_BU_NI_IPRTG__c = 50;
			preSalesTest.PSR_Sales_Value_BU_NI_OPTICS__c = 9000;
			preSalesTest.PSR_Automatically_Calc_Estimated_Cost__c=true;
			preSalesTest.PSR_Is_Cost_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest.PSR_Is_Rv_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest.PSR_Description_Justification__c = 'Test';
			preSalesTest.PSR_Is_BOM_BOQ_Document_Attached__c = true;
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES=false;
			database.update(preSalesTest);
			presalesTest.NF_PRE_Tech_Field__c = 'Gate Submitted';
			preSalesTest.StageName = GlobalConstants.IN_EXECUTION;
			preSalesTest.Apttus_Approval__Approval_Status__c = 'Approved';
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES=false;
			database.update(preSalesTest);
			
			preSalesTest.PSR_Reset_PSRO__c = true;
			preSalesTest.PSR_Reason_for_Reset__c = 'reset';
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES=false;
			database.update(preSalesTest);
			test.stopTest();
		}
	}
}