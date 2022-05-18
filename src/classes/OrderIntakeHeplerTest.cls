/****************************************
* Class Name : OrderIntakeHeplerTest
* Created Date: 28 November 2016
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 
* Description : Test class for OrderIntakeHepler
*****************************************/
@isTest
Private class OrderIntakeHeplerTest
{
	private static  Set<ID> OpptyID = new Set<ID>();

	/******************************
	*Method Name: orderIntake
	*Description: Test Method to cover OrderIntakeHepler, OrderIntakeHandler class
	********************************/
	static testMethod void orderIntake()
	{
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		System.RunAs(userCreation)
		{
			Account acc = TestDataFactory.createAccount(1)[0];
			acc.AccountNumber = '301000000';
			database.insert(acc);

			List<Opportunity> oppties = TestDataFactory.OpportunityCreation(2,acc);
			oppties[1].CurrencyIsoCode='EUR';
			oppties[1].Sales_Outcome__c='Lost to Competitor';
			oppties[1].Sales_Outcome_Reason__c = 'Commercial';
			oppties[1].Second_Reason__c = 'Quality';
			oppties[1].Third_Reason__c = 'Technical';
			database.insert(oppties);
			
			Test.startTest();
			product2 prod = TestDataFactory.productCreation(1)[0];
			prod.Business_Group__c='MN';
			prod.Family= 'FN';
			database.insert (prod);
			
			List<Nokia_Financial_Calendar__c> nokiaFinCal = createCalendars();

			Dated_Exchange_Rates__c exchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			exchangeRate.DER_Period__c = nokiaFinCal[0].id;
			exchangeRate.CurrencyIsoCode ='USD';
			database.insert(exchangeRate);
			
			
			List<Order_Intake_Forecast__c> oif=TestDataFactory.orderIntakeCreation(3,oppties[0],prod,nokiaFinCal[0]);
			oif[1].CurrencyIsoCode='EUR';
			oif[2].CurrencyIsoCode='EUR';
			database.insert(oif);
		  
			oif[1].OIF_Value__c=0;
			oif[2].OIF_Value__c=500;
			oif[1].Close_Date__c=NULL;
			oif[1].Forecast_Category__c='Lost';
			oif[1].Close_Date__c=System.today();
			database.Update(oif);

			OrderIntakeHepler.updateCurrentPeriod(oif);
			map<ID,Opportunity> oifoppid=new map<ID,Opportunity>();
			oifoppid.put(oppties[0].Id,oppties[0]);
			OrderIntakeHepler.ChangeCurrency(oif,oifoppid);
			OrderIntakeHandler.BeforeInsert(oif);
			OrderIntakeHandler.BeforeUpdate(oif,oif);

			List<Order_Intake_Forecast__c> oif1=TestDataFactory.orderIntakeCreation(3,oppties[1],prod,nokiaFinCal[1]);
			oif1[1].Forecast_Category__c='Cancel';
			OrderIntakeHandler.BeforeInsert(oif1);
			Test.stoptest();
		}
	}

	static testMethod void orderIntakeUpdate()
	{
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		System.RunAs(userCreation)
		{
			Account acc = TestDataFactory.createAccount(1)[0];
			acc.AccountNumber = '301000000';
			database.insert(acc);

			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc)[0];
			opp1.Contract_Signing_Entity__c = 'fNOK';
			database.insert(opp1);

			product2 prod = TestDataFactory.productCreation(1)[0];
			prod.Business_Group__c='MN';
			prod.Family= 'FN';
			database.insert (prod);

			List<Nokia_Financial_Calendar__c> nokiaFinCal = createCalendars();
			Dated_Exchange_Rates__c exchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			exchangeRate.CurrencyIsoCode='USD';
			exchangeRate.DER_Period__c=nokiaFinCal[0].id;
			database.insert(exchangeRate);
			Test.starttest();
			
			List<Order_Intake_Forecast__c> oif= TestDataFactory.orderIntakeCreation(3,opp1,prod,nokiaFinCal[0]);
			database.insert(oif);
			oif[1].OIF_Value__c=200;
			oif[2].OIF_Value__c=500;
			oif[2].Forecast_Category__c='ROP';
			oif[1].Forecast_Category__c='ROP';
			oif[1].Close_Date__c=System.today();
			database.update(oif);
			
			Test.Stoptest();
		}
	}

	/***********************
* Method Name: DeletecloneLinesTestt
* Description: This method used to cover the test method of DeletecloneLines
* Parameters: NA
************************/
	static testMethod void  deletecloneLinesTest()
	{
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		System.RunAs(userCreation)
		{
			Account acc = TestDataFactory.createAccount(1)[0];
			acc.AccountNumber = '301000000';
			database.insert(acc);

			Opportunity opp2 = TestDataFactory.OpportunityCreation(1,acc)[0];
			opp2.CurrencyIsoCode='USD';
			opp2.amount=200000;
			opp2.Sales_Outcome__c='';
			database.insert(opp2);

			product2 prod = TestDataFactory.productCreation(1)[0];
			prod.Business_Group__c='MN';
			prod.Family= 'FN';
			database.insert (prod);

			List<Nokia_Financial_Calendar__c> nokiaFinCal = createCalendars();
			Test.starttest();

			List<Order_Intake_Forecast__c> oif=TestDataFactory.orderIntakeCreation(3,opp2,prod,nokiaFinCal[0]);
			oif[1].CurrencyIsoCode='USD';
			oif[2].CurrencyIsoCode='USD';
			database.insert(oif);
			oif[1].OIF_Value__c=200;
			oif[1].CurrencyIsoCode='USD';
			oif[2].OIF_Value__c=500;
			oif[2].Cloned_From__c=oif[1].id;
			oif[2].Update_Status__c=True;
			oif[2].Forecast_Category__c='ROP';
			oif[1].Close_Date__c=System.today();
			database.update(oif);

			system.assertEquals(oif[1].id==oif[2].Cloned_From__c,true,'OIF has not been cloned');
			OrderIntakeHepler.DeletecloneLines(oif);
			OrderIntakeHandler.BeforeDelete(Null);
			Test.StopTest();
		}
	}

	/***********************
* Method Name: copyOpptyProgramFlagToOifTest
* Description: Sales Process : To cover copyOpptyProgramFlagToOif method
* Parameters: NA
************************/
	static testMethod void copyOpptyProgramFlagToOifTest()
	{
		List<Account> accountList = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Order_Intake_Forecast__c> oifCreation = new List<Order_Intake_Forecast__c>();
		product2 productCreation = new product2();

		Program_Flag__c pfdata = new Program_Flag__c();
		Nokia_Financial_Calendar__c nokiaFinCalObjCreation = new Nokia_Financial_Calendar__c();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		System.runAs(userCreation)
		{
			accountList = TestDataFactory.createAccount(1);
			accountList[0].AccountNumber = '301000000';
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
			database.insert(opportunityList);
			productCreation = TestDataFactory.productCreation(1)[0];
			productCreation.Business_Group__c='MN';
			productCreation.Family= 'FN';
			database.insert(productCreation);
			nokiaFinCalObjCreation = TestDataFactory.nokiaFinCalCreation(1)[0];
			Date todayDate = system.today();
			String month = String.valueOf(todayDate.month());
			nokiaFinCalObjCreation.Name = String.valueOf(todayDate.year()) + ' - P' + month.leftPad(2,'0');
			nokiaFinCalObjCreation.Period_Number__c = month;
			database.insert(nokiaFinCalObjCreation);
			pfdata.Name = 'PfData';
			database.insert(pfdata);
			OptyProgramFlagJunction__c opfj = new OptyProgramFlagJunction__c();
			opfj.Opportunity__c = opportunityList[0].id;
			opfj.Program_Flag__c = pfdata.id;
			database.insert(opfj);
			Test.startTest();
			oifCreation = TestDataFactory.orderIntakeCreation(1,opportunityList[0],productCreation,nokiaFinCalObjCreation);
			database.insert(oifCreation[0]);
			OrderIntakeHepler.copyOpptyProgramFlagToOif(Null);
			Test.stopTest();
		}
	}

	/***********************
* Method Name: competitorOIFThresholdNETest
* Description: validate if the logic of mandatory competitor when the total OIF value goes over the threshold for Enterprise oppties
* Parameters: NA
************************/
	static testMethod void competitorOIFThresholdNETest()
	{
		List<Account> accountList = new List<Account>();
		List<Account> accountLEList = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Order_Intake_Forecast__c> oifCreation = new List<Order_Intake_Forecast__c>();
		product2 productCreation = new product2();
		Nokia_Financial_Calendar__c nokiaFinCalObjCreation = new Nokia_Financial_Calendar__c();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		String activitySector = 'GC - SMART CITIES';// changed for SH2022
		String marketSegment = 'GOVERNMENT AND CITIES';// changed for SH2022
		System.runAs(userCreation)
		{
			Activity_Sector_Name__c activitySectorCS = new Activity_Sector_Name__c();
			activitySectorCS.Name = '123';
			activitySectorCS.Activity_Sector_Name__c = activitySector;
			activitySectorCS.Market_Segment_Name__c = marketSegment;
			database.insert(activitySectorCS);
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			accountLEList = TestDataFactory.createAccount('Legal_Entity', 1, accountList[0].id);
			accountLEList[0].Activity_Sector_Name__c = activitySector;
			accountLEList[0].Market_Segment__c = marketSegment;
			database.insert(accountLEList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
			opportunityList[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
			database.insert(opportunityList);
			productCreation = TestDataFactory.productCreation(1)[0];
			productCreation.Business_Group__c='MN';
			productCreation.Family= 'FN';
			database.insert(productCreation);
			nokiaFinCalObjCreation = TestDataFactory.nokiaFinCalCreation(1)[0];
			Date todayDate = system.today();
			String month = String.valueOf(todayDate.month());
			nokiaFinCalObjCreation.Name = String.valueOf(todayDate.year()) + ' - P' + month.leftPad(2,'0');
			nokiaFinCalObjCreation.Period_Number__c = month;
			database.insert(nokiaFinCalObjCreation);
			oifCreation = TestDataFactory.orderIntakeCreation(1,opportunityList[0],productCreation,nokiaFinCalObjCreation);
			try
			{
				test.startTest();
				oifCreation[0].OIF_Value_EUR__c = Integer.valueOf(Label.OpportunityThreshouldValueNE);
				database.insert(oifCreation);
				test.stopTest();
			}
			catch(Exception e){
				System.debug(e.getMessage());
				System.assertEquals(e.getMessage().contains(GlobalConstants.OIF_COMPETITOR_CHECK), true);
			}

		}
	}


	/***********************
* Method Name: competitorOIFThresholdCSPTest
* Description: validate if the logic of mandatory competitor when the total OIF value goes over the threshold for CSP oppties
* Parameters: NA
************************/
	static testMethod void competitorOIFThresholdCSPTest()
	{
		List<Account> accountList = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Order_Intake_Forecast__c> oifCreation = new List<Order_Intake_Forecast__c>();
		product2 productCreation = new product2();
		Nokia_Financial_Calendar__c nokiaFinCalObjCreation = new Nokia_Financial_Calendar__c();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		System.runAs(userCreation)
		{
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
			opportunityList[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
			database.insert(opportunityList);
			productCreation = TestDataFactory.productCreation(1)[0];
			productCreation.Business_Group__c='MN';
			productCreation.Family= 'FN';
			database.insert(productCreation);
			nokiaFinCalObjCreation = TestDataFactory.nokiaFinCalCreation(1)[0];
			Date todayDate = system.today();
			String month = String.valueOf(todayDate.month());
			nokiaFinCalObjCreation.Name = String.valueOf(todayDate.year()) + ' - P' + month.leftPad(2,'0');
			nokiaFinCalObjCreation.Period_Number__c = month;
			database.insert(nokiaFinCalObjCreation);
			oifCreation = TestDataFactory.orderIntakeCreation(1,opportunityList[0],productCreation,nokiaFinCalObjCreation);
			
			try
			{
				test.startTest();
				oifCreation[0].OIF_Value_EUR__c = Integer.valueOf(Label.OpportunityThreshouldValue);
				database.insert(oifCreation);
				test.stopTest();
			}
			catch(Exception e)
			{
				System.debug(e.getMessage());
				System.assertEquals(e.getMessage().contains(GlobalConstants.OIF_COMPETITOR_CHECK), true);
			}
		}
	}


	/***********************
* Method Name: chatterOnInsertandUpdateTest
* Description: This method used to cover the test method of chatterOnInsert and chatterOnUpdate
* Parameters: NA
************************/
	static testMethod void chatterOnInsertandUpdateTest()
	{
		List<Order_Intake_Forecast__c> oif=new List<Order_Intake_Forecast__c>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Nokia_Financial_Calendar__c> nokiaFinCalList = new List<Nokia_Financial_Calendar__c>();
		product2 prod = TestDataFactory.productCreation(1)[0];

		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		System.RunAs(userCreation)
		{
			//create an account needed for creating opportunity
			Account acc = TestDataFactory.createAccount(1)[0];
			database.insert(acc);

			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc)[0];
			opp1.Contract_Signing_Entity__c = 'fNOK';
			opportunityList.add(opp1);
			Database.insert(opportunityList);

			prod.Business_Group__c='MN';
			prod.Family= 'FN';
			database.insert (prod);

			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			Date todayDate = system.today();
			String month = String.valueOf(todayDate.month());
			nokiaFinCal.Name = String.valueOf(todayDate.year()) + ' - P' + month.leftPad(2,'0');
			nokiaFinCal.Period_Number__c = month;
			database.insert(nokiaFinCal);
			nokiaFinCalList.add(nokiaFinCal);

			Dated_Exchange_Rates__c exchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			exchangeRate.DER_Period__c = nokiaFinCal.id;
			exchangeRate.CurrencyIsoCode ='USD';
			database.insert(exchangeRate);
		}
	   
		user userCreation1 = TestDataFactory.userCreation(1,'Nokia Sales Profile')[0];
		insert userCreation1;
		 Test.starttest();
		List<OpportunityTeamMember> opptyTeamMembers = TestDataFactory.optyTeamMemberCreation(1, userCreation1, opportunityList[0]);
		opptyTeamMembers[0].TeamMemberRole = GlobalConstants.TRICON_SCO_ROLE;
		insert opptyTeamMembers;
		System.runAs(userCreation1)
		{
	
			oif = TestDataFactory.orderIntakeCreation(3, opportunityList[0],prod,nokiaFinCalList[0]);
			insert oif;
			Map<Id,Order_Intake_Forecast__c> oldOIF = new Map<Id,Order_Intake_Forecast__c>();
			oldOIF.put(oif[0].Id, oif[0].clone(true,true,true,true));
			oldOIF.put(oif[1].Id, oif[1].clone(true,true,true,true));
			Map<Id,Order_Intake_Forecast__c> newOIF = new Map<Id,Order_Intake_Forecast__c>();
			oif[0].OIF_Value__c = 10;
			oif[1].Forecast_Category__c = 'Secure';
			newOIF.put(oif[0].Id, oif[0]);
			newOIF.put(oif[1].Id, oif[1]);
			OrderIntakeHepler.chatterOnUpdate(newOIF, oldOIF);
			Test.stopTest();
		}
	}
	/***********************
* Method Name: chatterOnInsertandUpdateTest
* Description: This method used to cover the test method of chatterOnInsert and chatterOnUpdate
* Parameters: NA
************************/
	static testMethod void upsellDeltaDoubleInsertTest()
	{
		List<Order_Intake_Forecast__c> oif=new List<Order_Intake_Forecast__c>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Nokia_Financial_Calendar__c> nokiaFinCalList = new List<Nokia_Financial_Calendar__c>();
		product2 prod = TestDataFactory.productCreation(1)[0];

		//Create a test user to create opportunity
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		System.RunAs(userCreation)
		{
			//create an account needed for creating opportunity
			Account acc = TestDataFactory.createAccount(1)[0];
			database.insert(acc);

			opportunityList = TestDataFactory.OpportunityCreation(1,acc);
			opportunityList[0].Contract_Signing_Entity__c = 'fNOK';
			opportunityList[0].Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			opportunityList[0].Committed_Unweighted_Value_in_EUR__c= 10000;
			opportunityList[0].Sales_Outcome__c=null;
			Database.insert(opportunityList);
			
			Deal__c dealCreation = TestDataFactory.createDeal(1)[0];
			dealCreation.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.UPSELL_DEAL_RECORD_TYPE).getRecordTypeId();
			database.insert(dealCreation);

			Opportunity_Group__c opptyGroup = TestDataFactory.DealOpptyGroupingCreation(1,opportunityList[0],dealCreation)[0];
			database.insert(opptyGroup);

			prod.Business_Group__c='MN';
			prod.Family= 'FN';
			database.insert (prod);

			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			Date todayDate = system.today();
			String month = String.valueOf(todayDate.month());
			nokiaFinCal.Name = String.valueOf(todayDate.year()) + ' - P' + month.leftPad(2,'0');
			nokiaFinCal.Period_Number__c = month;
			database.insert(nokiaFinCal);
			nokiaFinCalList.add(nokiaFinCal);

			Dated_Exchange_Rates__c exchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			exchangeRate.DER_Period__c = nokiaFinCal.id;
			exchangeRate.CurrencyIsoCode ='USD';
			database.insert(exchangeRate);
			Test.starttest();
			oif = TestDataFactory.orderIntakeCreation(3, opportunityList[0],prod,nokiaFinCalList[0]);
			insert oif;

			OrderIntakeHandler.insertExecuted = false;
			OrderIntakeHandler.updateExecuted = false;
			OrderIntakeHepler.firstRun_Insert = true;
			List<Order_Intake_Forecast__c> oif1 = new List<Order_Intake_Forecast__c>();
			oif1 = TestDataFactory.orderIntakeCreation(1, opportunityList[0],prod,nokiaFinCalList[0]);
			insert oif1;
			Test.stopTest();
		}
	}

	/***********************
* Method Name: chatterOnInsertandUpdateTest
* Description: This method used to cover the test method of chatterOnInsert and chatterOnUpdate
* Parameters: NA
************************/
	static testMethod void upsellDeltaUpdateTest()
	{
		List<Order_Intake_Forecast__c> oif=new List<Order_Intake_Forecast__c>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Nokia_Financial_Calendar__c> nokiaFinCalList = new List<Nokia_Financial_Calendar__c>();
		product2 prod = TestDataFactory.productCreation(1)[0];

		//Create a test user to create opportunity
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.RunAs(userCreation)
		{
			//create an account needed for creating opportunity
			Account acc = TestDataFactory.createAccount(1)[0];
			database.insert(acc);

			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc)[0];
			opp1.Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			opp1.Committed_Unweighted_Value_in_EUR__c= 10000;
			opp1.Sales_Outcome__c=null;
			opportunityList.add(opp1);
			Database.insert(opportunityList);
		
			Deal__c dealCreation = TestDataFactory.createDeal(1)[0];
			dealCreation.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.UPSELL_DEAL_RECORD_TYPE).getRecordTypeId();
			database.insert(dealCreation);

			Opportunity_Group__c opptyGroup = TestDataFactory.DealOpptyGroupingCreation(1,opportunityList[0],dealCreation)[0];
			database.insert(opptyGroup);

			prod.Business_Group__c='MN';
			prod.Family= 'FN';
			database.insert (prod);

			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			Date todayDate = system.today();
			String month = String.valueOf(todayDate.month());
			nokiaFinCal.Name = String.valueOf(todayDate.year()) + ' - P' + month.leftPad(2,'0');
			nokiaFinCal.Period_Number__c = month;
			nokiaFinCal.Related_Quarter__c = month;
			database.insert(nokiaFinCal);
			nokiaFinCalList.add(nokiaFinCal);

			Dated_Exchange_Rates__c exchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			exchangeRate.DER_Period__c = nokiaFinCal.id;
			exchangeRate.CurrencyIsoCode ='USD';
			database.insert(exchangeRate);
			Test.starttest();
			oif = TestDataFactory.orderIntakeCreation(3, opportunityList[0],prod,nokiaFinCalList[0]);
			insert oif;
			
			OrderIntakeHandler.insertExecuted = false;
			OrderIntakeHandler.updateExecuted = false;

			oif[0].OIF_Value__c = 10;
			oif[1].Forecast_Category__c = 'Secure';
			GlobalConstants.isOrderIntakeUpdateFirstRun  = true;
			update oif;
			Test.stoptest();
		}
	}

	/***********************
* Method Name: chatterOnInsertandUpdateTest
* Description: This method used to cover the test method of chatterOnInsert and chatterOnUpdate
* Parameters: NA
************************/
	static testMethod void upsellDeltaDeleteTest()
	{
		List<Order_Intake_Forecast__c> oif=new List<Order_Intake_Forecast__c>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Nokia_Financial_Calendar__c> nokiaFinCalList = new List<Nokia_Financial_Calendar__c>();
		product2 prod = TestDataFactory.productCreation(1)[0];

		//Create a test user to create opportunity
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		System.RunAs(userCreation)
		{
			//create an account needed for creating opportunity
			Account acc = TestDataFactory.createAccount(1)[0];
			database.insert(acc);

			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc)[0];
			opp1.Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			opp1.Committed_Unweighted_Value_in_EUR__c= 10000;
			opp1.Sales_Outcome__c=null;
			opportunityList.add(opp1);
			Database.insert(opportunityList);
			
			Deal__c dealCreation = TestDataFactory.createDeal(1)[0];
			dealCreation.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.UPSELL_DEAL_RECORD_TYPE).getRecordTypeId();
			database.insert(dealCreation);

			Opportunity_Group__c opptyGroup = TestDataFactory.DealOpptyGroupingCreation(1,opportunityList[0],dealCreation)[0];
			database.insert(opptyGroup);

			prod.Business_Group__c='MN';
			prod.Family= 'FN';
			database.insert (prod);

			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			Date todayDate = system.today();
			String month = String.valueOf(todayDate.month());
			nokiaFinCal.Name = String.valueOf(todayDate.year()) + ' - P' + month.leftPad(2,'0');
			nokiaFinCal.Period_Number__c = month;
			nokiaFinCal.Related_Quarter__c = month;
			database.insert(nokiaFinCal);
			nokiaFinCalList.add(nokiaFinCal);

			Dated_Exchange_Rates__c exchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			exchangeRate.DER_Period__c = nokiaFinCal.id;
			exchangeRate.CurrencyIsoCode ='USD';
			database.insert(exchangeRate);
			
			Test.starttest();
			oif = TestDataFactory.orderIntakeCreation(3, opportunityList[0],prod,nokiaFinCalList[0]);
			insert oif;

			OrderIntakeHandler.insertExecuted = false;
			OrderIntakeHandler.updateExecuted = false;
			GlobalConstants.isOrderIntakeUpdateFirstRun  = true;

			delete oif[0];
			Test.stoptest();
		}
	}
	
	
	private static List<Nokia_Financial_Calendar__c> createCalendars(){
		Date todayDate = system.today();
		String month = String.valueOf(todayDate.month());
		Nokia_Financial_Calendar__c nokiaFinCal = new Nokia_Financial_Calendar__c();
		nokiaFinCal.Name = String.valueOf(todayDate.year()) + ' - P' + month.leftPad(2,'0');
		nokiaFinCal.Start_Date__c = todayDate;
		nokiaFinCal.End_Date__c = todayDate+30;
		nokiaFinCal.Period_Number__c = month;			
		Nokia_Financial_Calendar__c nokiaFinCal1 = new Nokia_Financial_Calendar__c();
		Date nextDate = system.today()+30;
		String nextMonth = String.valueOf(nextDate.month());
		nokiaFinCal1.Name = String.valueOf(nextDate.year()) + ' - P' + nextMonth.leftPad(2,'0');
		nokiaFinCal1.Start_Date__c =nextDate;
		nokiaFinCal1.End_Date__c = nextDate+30;
		nokiaFinCal1.Period_Number__c = nextMonth;	   
		List<Nokia_Financial_Calendar__c> calendars = new List<Nokia_Financial_Calendar__c>{nokiaFinCal,nokiaFinCal1};
		database.insert(calendars);
		return calendars;
	}
}