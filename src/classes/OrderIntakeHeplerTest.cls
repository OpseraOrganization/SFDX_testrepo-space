/****************************************
* Class Name : OrderIntakeHeplerTest
* Created Date: 28 November 2016
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date:
* Description : Test class for OrderIntakeHepler
*****************************************/
// @isTest(seealldata = False)
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
			acc.AccountNumber = '301000000';
			database.insert(acc);

			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc)[0];

			database.insert(opp1);
			Opportunity opp2 = TestDataFactory.OpportunityCreation(1,acc)[0];
			opp2.CurrencyIsoCode='EUR';
			opp2.Sales_Outcome__c='Lost to Competitor';
			opp2.Sales_Outcome_Reason__c = 'Commercial';
			opp2.Second_Reason__c = 'Quality';
			opp2.Third_Reason__c = 'Technical';
			database.insert(opp2);

			product2 prod = TestDataFactory.productCreation(1)[0];
			prod.Business_Group__c='MN';
			prod.Family= 'FN';
			database.insert (prod);

			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal);
			database.update(nokiaFinCal);

			Nokia_Financial_Calendar__c nokiaFinCal1 = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal1);
			nokiaFinCal1.Start_Date__c=system.today();
			nokiaFinCal1.End_Date__c = system.today()+5;
			database.update(nokiaFinCal1);

			Dated_Exchange_Rates__c ExchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			ExchangeRate.DER_Period__c=nokiaFinCal.id;
			ExchangeRate.CurrencyIsoCode ='USD';
			database.insert(ExchangeRate);
			Test.starttest();

			List<Order_Intake_Forecast__c> oif=new List<Order_Intake_Forecast__c>();
			oif=TestDataFactory.orderIntakeCreation(3,opp1,prod,nokiaFinCal);
			oif[1].CurrencyIsoCode='EUR';
			oif[2].CurrencyIsoCode='EUR';
			database.insert(oif);
			oif[1].OIF_Value__c=0;
			oif[2].OIF_Value__c=500;
			oif[1].Close_Date__c=NULL;
			oif[1].Forecast_Category__c='Lost';
			oif[1].Close_Date__c=System.today();
			database.Update(oif);

			system.assertEquals(3,oif.size(),'Insert has not been done properly');

			System.debug('Loop updateCurrentPeriod');

			OrderIntakeHepler.updateCurrentPeriod(oif);
			map<ID,Opportunity> oifoppid=new map<ID,Opportunity>();
			oifoppid.put(opp1.Id,opp1);
			OrderIntakeHepler.ChangeCurrency(oif,oifoppid);
			OpptyID.add(oif.get(0).ID);
			OpptyID.add(oif.get(1).ID);
			OpptyID.add(oif.get(2).ID);

			OrderIntakeHandler.BeforeInsert(oif);
			OrderIntakeHandler.BeforeUpdate(oif,oif);

			List<Order_Intake_Forecast__c> oif1=new List<Order_Intake_Forecast__c>();
			oif1=TestDataFactory.orderIntakeCreation(3,opp2,prod,nokiaFinCal1);
			oif1[1].Forecast_Category__c='Cancel';
			OrderIntakeHandler.BeforeInsert(oif1);
			Test.stoptest();
			System.assertnotequals(oif,oif1);
		}
	}

	static testMethod void orderIntakeUpdate()
	{
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		List<Order_Intake_Forecast__c> empoif=new List<Order_Intake_Forecast__c>();
		Map<id,Opportunity> opptyMap = new Map<id,Opportunity>();
		List<Order_Intake_Forecast__c> oif1=new List<Order_Intake_Forecast__c>();

		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.RunAs(userCreation)
		{

			Account acc = TestDataFactory.createAccount(1)[0];
			acc.AccountNumber = '301000000';
			database.insert(acc);

			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc)[0];
			database.insert(opp1);

			product2 prod = TestDataFactory.productCreation(1)[0];
			prod.Business_Group__c='MN';
			prod.Family= 'FN';
			database.insert (prod);

			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal);

			Nokia_Financial_Calendar__c nokiaFinCal1 = TestDataFactory.nokiaFinCalCreation(1)[0];
			nokiaFinCal1.Start_Date__c=system.today()+1;
			nokiaFinCal1.End_Date__c = system.today()+15;
			database.insert(nokiaFinCal1);

			List<Order_Intake_Forecast__c> oif=new List<Order_Intake_Forecast__c>();
			oif=TestDataFactory.orderIntakeCreation(3,opp1,prod,nokiaFinCal);
			database.insert(oif);
			oif[1].OIF_Value__c=200;
			oif[2].OIF_Value__c=500;
			oif[2].Forecast_Category__c='ROP';
			oif[1].Forecast_Category__c='ROP';
			oif[1].Close_Date__c=System.today();
			database.update(oif);

			Dated_Exchange_Rates__c ExchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			ExchangeRate.CurrencyIsoCode='USD';
			ExchangeRate.DER_Period__c=nokiaFinCal.id;
			Map<String,Decimal> USDCurrencyrate =new Map<String,Decimal>();
			USDCurrencyrate.get(GlobalConstants.USD);

			oif=TestDataFactory.orderIntakeCreation(3,opp1,prod,nokiaFinCal1);

			Test.starttest();

			database.insert(ExchangeRate);
			database.insert(oif1);
			OrderIntakeHandler.BeforeInsert(empoif);
			OrderIntakeHandler.BeforeUpdate(oif,oif1);
			OrderIntakeHepler.updateCurrentPeriod(oif);

			OrderIntakeHepler.updateCurrentPeriod(oif);
			OrderIntakeHepler.updateCurrentPeriod(empoif);
			OrderIntakeHepler.ChangeCurrency(empoif,opptyMap);
			Test.Stoptest();
		}
	}

	/***********************
* Method Name: DeletecloneLinesTestt
* Description: This method used to cover the test method of DeletecloneLines
* Parameters: NA
************************/
	static testMethod void  DeletecloneLinesTest()
	{
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;

		List<Order_Intake_Forecast__c> oif1=new List<Order_Intake_Forecast__c>();

		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;

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

			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal);

			Nokia_Financial_Calendar__c nokiaFinCal1 = TestDataFactory.nokiaFinCalCreation(1)[0];
			nokiaFinCal1.Start_Date__c=system.today()+1;
			nokiaFinCal1.End_Date__c = system.today()+15;
			database.insert(nokiaFinCal1);

			List<Order_Intake_Forecast__c> oif=new List<Order_Intake_Forecast__c>();

			oif=TestDataFactory.orderIntakeCreation(3,opp2,prod,nokiaFinCal);
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

			Dated_Exchange_Rates__c ExchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			ExchangeRate.DER_Period__c=nokiaFinCal.id;
			ExchangeRate.CurrencyIsoCode ='USD';

			oif=TestDataFactory.orderIntakeCreation(3,opp2,prod,nokiaFinCal1);

			Test.starttest();

			database.insert(ExchangeRate);
			database.insert(oif1);
			OrderIntakeHepler.DeletecloneLines(oif);
			OrderIntakeHandler.BeforeDelete(oif1);
			OrderIntakeHandler.BeforeDelete(Null);
			OrderIntakeHandler.BeforeInsert(Null);
			OrderIntakeHepler.DeletecloneLines(oif);
			try
			{
	oif[2].Update_Status__c=false;
	database.update(oif[2]);
			}
			catch(DmlException e)
			{
	OrderIntakeHepler.DeletecloneLines(Null);
			}

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
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;

		List<Account> accountList = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Order_Intake_Forecast__c> oifCreation = new List<Order_Intake_Forecast__c>();
		product2 productCreation = new product2();

		Program_Flag__c pfdata = new Program_Flag__c();
		Nokia_Financial_Calendar__c nokiaFinCalObjCreation = new Nokia_Financial_Calendar__c();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		System.runAs(userCreation)
		{
			accountList = TestDataFactory.createAccount(2);
			accountList[0].AccountNumber = '301000000';
			accountList[1].AccountNumber = '301000001';
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
			database.insert(opportunityList);
			productCreation = TestDataFactory.productCreation(1)[0];
			productCreation.Business_Group__c='MN';
			productCreation.Family= 'FN';
			database.insert(productCreation);
			nokiaFinCalObjCreation = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCalObjCreation);
			pfdata.Name = 'PfData';
			database.insert(pfdata);
			OptyProgramFlagJunction__c opfj = new OptyProgramFlagJunction__c();
			opfj.Opportunity__c = opportunityList[0].id;
			opfj.Program_Flag__c = pfdata.id;
			database.insert(opfj);
			oifCreation = TestDataFactory.orderIntakeCreation(1,opportunityList[0],productCreation,nokiaFinCalObjCreation);
			database.insert(oifCreation[0]);
			OrderIntakeHepler.copyOpptyProgramFlagToOif(Null);
		}
	}

	/***********************
* Method Name: competitorOIFThreshold200kDirectTest
* Description: Sales Process : method to test the limits of OIF value and the competitor requirenment
* Parameters: NA
************************/
	static testMethod void competitorOIFThreshold200kDirectTest()
	{
		List<Account> accountList = new List<Account>();
		List<Account> accountLEList = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Order_Intake_Forecast__c> oifCreation = new List<Order_Intake_Forecast__c>();

		product2 productCreation = new product2();
		Program_Flag__c pfdata = new Program_Flag__c();
		Nokia_Financial_Calendar__c nokiaFinCalObjCreation = new Nokia_Financial_Calendar__c();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		System.runAs(userCreation)
		{
			Activity_Sector_Name__c activitySector = new Activity_Sector_Name__c();
			activitySector.Name = 'GCDS';
			activitySector.Activity_Sector_Name__c = 'GC - DEFENSE';
			activitySector.Market_Segment_Name__c = 'GOVERNMENT AND CITIES';
			database.insert(activitySector);
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			accountLEList = TestDataFactory.createAccount('Legal_Entity', 1, accountList[0].id);
			accountLEList[0].Activity_Sector_Name__c = 'GC - DEFENSE';
			accountLEList[0].Market_Segment__c = 'GOVERNMENT AND CITIES';
			database.insert(accountLEList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
			opportunityList[0].Legal_Entity__c = accountLEList[0].id;
			opportunityList[0].Account_Role__c = 'Alliance Partner';
			opportunityList[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
			database.insert(opportunityList);
			productCreation = TestDataFactory.productCreation(1)[0];
			productCreation.Business_Group__c='MN';
			productCreation.Family= 'FN';
			database.insert(productCreation);
			nokiaFinCalObjCreation = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCalObjCreation);
			pfdata.Name = 'PfData';
			database.insert(pfdata);
			oifCreation = TestDataFactory.orderIntakeCreation(1,opportunityList[0],productCreation,nokiaFinCalObjCreation);
			test.startTest();
			try
			{
	oifCreation[0].OIF_Value_EUR__c = 200000;
	database.insert(oifCreation);
			}
			catch(Exception e){
	Boolean expectedExceptionThrown =  e.getMessage().contains('Request You to add at least one competitor to this Opportunity') ? true : false;
	//System.assertEquals(expectedExceptionThrown, true);
			}
			test.stopTest();
		}
	}
	/***********************
* Method Name: competitorOIFThreshold200kIndirectTest
* Description: Sales Process : method to test the limits of OIF value and the competitor requirenment
* Parameters: NA
************************/
	static testMethod void competitorOIFThreshold200kIndirectTest()
	{
		List<Account> accountList = new List<Account>();
		List<Account> accountLEList = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Order_Intake_Forecast__c> oifCreationIndirect = new List<Order_Intake_Forecast__c>();
		product2 productCreation = new product2();
		Program_Flag__c pfdata = new Program_Flag__c();
		Nokia_Financial_Calendar__c nokiaFinCalObjCreation = new Nokia_Financial_Calendar__c();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		System.runAs(userCreation)
		{
			Activity_Sector_Name__c activitySector = new Activity_Sector_Name__c();
			activitySector.Name = 'GCDS';
			activitySector.Activity_Sector_Name__c = 'GC - DEFENSE';
			activitySector.Market_Segment_Name__c = 'GOVERNMENT AND CITIES';
			database.insert(activitySector);
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			accountLEList = TestDataFactory.createAccount('Legal_Entity', 1, accountList[0].id);
			accountLEList[0].Activity_Sector_Name__c = 'GC - DEFENSE';
			accountLEList[0].Market_Segment__c = 'GOVERNMENT AND CITIES';
			database.insert(accountLEList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
			opportunityList[0].End_Customer_LE__c = accountLEList[0].id;
			opportunityList[0].Account_Role__c = 'Alliance Partner';
			opportunityList[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
			database.insert(opportunityList);
			productCreation = TestDataFactory.productCreation(1)[0];
			productCreation.Business_Group__c='MN';
			productCreation.Family= 'FN';
			database.insert(productCreation);
			nokiaFinCalObjCreation = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCalObjCreation);
			pfdata.Name = 'PfData';
			database.insert(pfdata);
			oifCreationIndirect = TestDataFactory.orderIntakeCreation(1,opportunityList[0],productCreation,nokiaFinCalObjCreation);
			test.startTest();
			try
			{
	oifCreationIndirect[0].OIF_Value_EUR__c = 200000;
	database.insert(oifCreationIndirect);
			}
			catch(Exception e)
			{
	Boolean expectedExceptionThrown =  e.getMessage().contains('Request You to add at least one competitor to this Opportunity') ? true : false;
	//System.assertEquals(expectedExceptionThrown, true);
			}
			test.stopTest();
		}
	}

	/***********************
* Method Name: competitorOIFThreshold1MTest
* Description: Sales Process : method to test the limits of OIF value and the competitor requirenment
* Parameters: NA
************************/
	static testMethod void competitorOIFThreshold1MTest()
	{
		List<Account> accountList = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Order_Intake_Forecast__c> oifCreation = new List<Order_Intake_Forecast__c>();

		product2 productCreation = new product2();
		Program_Flag__c pfdata = new Program_Flag__c();
		Nokia_Financial_Calendar__c nokiaFinCalObjCreation = new Nokia_Financial_Calendar__c();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		System.runAs(userCreation)
		{
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
			opportunityList[0].Account_Role__c = 'Alliance Partner';
			opportunityList[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
			database.insert(opportunityList);
			productCreation = TestDataFactory.productCreation(1)[0];
			productCreation.Business_Group__c='MN';
			productCreation.Family= 'FN';
			database.insert(productCreation);
			nokiaFinCalObjCreation = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCalObjCreation);
			pfdata.Name = 'PfData';
			database.insert(pfdata);
			oifCreation = TestDataFactory.orderIntakeCreation(1,opportunityList[0],productCreation,nokiaFinCalObjCreation);
			test.startTest();
			try
			{
	oifCreation[0].OIF_Value_EUR__c = 2000000;
	database.insert(oifCreation);
			}
			catch(Exception e)
			{
	Boolean expectedExceptionThrown =  e.getMessage().contains('Request You to add at least one competitor to this Opportunity') ? true : false;
	//System.assertEquals(expectedExceptionThrown, true);
			}
			test.stopTest();
		}
	}

	/***********************
* Method Name: DeletecloneLinesTestt
* Description: This method used to cover the test method of DeletecloneLines
* Parameters: NA
************************/ //JOTATR~
/*
	static testMethod void ErrorcheckforOfferlevelTest()
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
			acc.AccountNumber = '301000000';
			database.insert(acc);
			Account acc1 = TestDataFactory.createAccount(1)[0];
			acc.AccountNumber = '301000001';
			acc1.Name = 'Test Acc';
			database.insert(acc1);

			Opportunity opp = TestDataFactory.OpportunityCreation(1,acc)[0];
			database.insert(opp);

			opp.Probability = 10;
			database.update(opp);

			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc1)[0];
			database.insert(opp1);

			set<ID> oppidset =new set<ID>();
			oppidset.add(opp1.id);

			Test.starttest();
			Offer__c offerCreation = TestDataFactory.OfferCreation(1,opp1)[0];
			offerCreation.ActiveOffer__c = true;
			//offerCreation.Expected_LoA_G4_Approval_Level__c = 'A';// JOTATR
			insert offerCreation;

			product2 prod = TestDataFactory.productCreation(1)[0];
			prod.Business_Group__c='MN';
			prod.Family= 'FN';
			database.insert (prod);

			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal);

			Dated_Exchange_Rates__c ExchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			ExchangeRate.DER_Period__c=nokiaFinCal.id;
			ExchangeRate.CurrencyIsoCode ='USD';

			database.insert(ExchangeRate);

			List<Order_Intake_Forecast__c> oif=new List<Order_Intake_Forecast__c>();

			oif=TestDataFactory.orderIntakeCreation(3,opp1,prod,nokiaFinCal);
			OrderIntakeHepler.isOfferWithoutExpectedLoALevel=true;
			OrderIntakeHepler.ErrorcheckforOfferlevel(oif,oppidset);
			OrderIntakeHepler.ErrorcheckforOfferlevel(oif,Null);
			OrderIntakeHepler.ErrorcheckforOfferlevel(Null,Null);
			OrderIntakeHepler.checkForCommittedUpsellOppty(Null);
			OrderIntakeHepler.getOpportuntityData(Null);
			system.assertEquals(oif[0].id,null,'Exception');
			OrderIntakeHepler.updateCurrentPeriod(NUll);
			Test.stoptest();
		}
	}
	*/
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

		//Create a test user to create opportunity
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
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
			database.insert(nokiaFinCal);
			nokiaFinCalList.add(nokiaFinCal);

			Dated_Exchange_Rates__c ExchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			ExchangeRate.DER_Period__c = nokiaFinCal.id;
			ExchangeRate.CurrencyIsoCode ='USD';
			database.insert(ExchangeRate);

			Test.starttest();
		}

		user userCreation1 = TestDataFactory.userCreation(1,'Nokia Sales Profile')[0];
		insert userCreation1;

		List<OpportunityTeamMember> opptyTeamMembers = TestDataFactory.optyTeamMemberCreation(1, userCreation1, opportunityList[0]);
		opptyTeamMembers[0].TeamMemberRole = GlobalConstants.TRICON_SCO_ROLE;
		insert opptyTeamMembers;
		System.runAs(userCreation1)
		{
			oif = TestDataFactory.orderIntakeCreation(3, opportunityList[0],prod,nokiaFinCalList[0]);
			insert oif;
			OrderIntakeHandler.insertExecuted = false;
			OrderIntakeHandler.updateExecuted = false;

			oif[0].OIF_Value__c = 10;
			oif[1].Forecast_Category__c = 'Secure';
			update oif;
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
		insert userCreation;
		System.RunAs(userCreation)
		{
			//create an account needed for creating opportunity
			Account acc = TestDataFactory.createAccount(1)[0];
			database.insert(acc);

			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc)[0];
			opp1.Contract_Signing_Entity__c = 'fNOK';
			opp1.Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			opp1.Committed_Unweighted_Value_in_EUR__c= 10000;
			opp1.Sales_Outcome__c=null;
			opportunityList.add(opp1);
			Database.insert(opportunityList);
			Test.starttest();
			Deal__c dealCreation = TestDataFactory.createDeal(1)[0];
			dealCreation.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.UPSELL_DEAL_RECORD_TYPE).getRecordTypeId();
			database.insert(dealCreation);

			Opportunity_Group__c opptyGroup = TestDataFactory.DealOpptyGroupingCreation(1,opportunityList[0],dealCreation)[0];
			database.insert(opptyGroup);

			prod.Business_Group__c='MN';
			prod.Family= 'FN';
			database.insert (prod);

			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal);
			nokiaFinCalList.add(nokiaFinCal);

			Dated_Exchange_Rates__c ExchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			ExchangeRate.DER_Period__c = nokiaFinCal.id;
			ExchangeRate.CurrencyIsoCode ='USD';
			database.insert(ExchangeRate);

			oif = TestDataFactory.orderIntakeCreation(3, opportunityList[0],prod,nokiaFinCalList[0]);
			insert oif;

			OrderIntakeHandler.insertExecuted = false;
			OrderIntakeHandler.updateExecuted = false;
			Test.stopTest();
			List<Order_Intake_Forecast__c> oif1 = new List<Order_Intake_Forecast__c>();
			oif1 = TestDataFactory.orderIntakeCreation(1, opportunityList[0],prod,nokiaFinCalList[0]);
			insert oif1;
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
			opp1.Contract_Signing_Entity__c = 'fNOK';
			opp1.Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			opp1.Committed_Unweighted_Value_in_EUR__c= 10000;
			opp1.Sales_Outcome__c=null;
			opportunityList.add(opp1);
			Database.insert(opportunityList);
			Test.starttest();
			Deal__c dealCreation = TestDataFactory.createDeal(1)[0];
			dealCreation.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.UPSELL_DEAL_RECORD_TYPE).getRecordTypeId();
			database.insert(dealCreation);

			Opportunity_Group__c opptyGroup = TestDataFactory.DealOpptyGroupingCreation(1,opportunityList[0],dealCreation)[0];
			database.insert(opptyGroup);

			prod.Business_Group__c='MN';
			prod.Family= 'FN';
			database.insert (prod);

			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal);
			nokiaFinCalList.add(nokiaFinCal);

			Dated_Exchange_Rates__c ExchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			ExchangeRate.DER_Period__c = nokiaFinCal.id;
			ExchangeRate.CurrencyIsoCode ='USD';
			database.insert(ExchangeRate);

			oif = TestDataFactory.orderIntakeCreation(3, opportunityList[0],prod,nokiaFinCalList[0]);
			insert oif;

			OrderIntakeHandler.insertExecuted = false;
			OrderIntakeHandler.updateExecuted = false;

			Test.stoptest();
			oif[0].OIF_Value__c = 10;
			oif[1].Forecast_Category__c = 'Secure';
			GlobalConstants.isOrderIntakeUpdateFirstRun  = true;
			update oif;
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
		insert userCreation;
		System.RunAs(userCreation)
		{
			//create an account needed for creating opportunity
			Account acc = TestDataFactory.createAccount(1)[0];
			database.insert(acc);

			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc)[0];
			opp1.Contract_Signing_Entity__c = 'fNOK';
			opp1.Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			opp1.Committed_Unweighted_Value_in_EUR__c= 10000;
			opp1.Sales_Outcome__c=null;
			opportunityList.add(opp1);
			Database.insert(opportunityList);
			Test.starttest();
			Deal__c dealCreation = TestDataFactory.createDeal(1)[0];
			dealCreation.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.UPSELL_DEAL_RECORD_TYPE).getRecordTypeId();
			database.insert(dealCreation);

			Opportunity_Group__c opptyGroup = TestDataFactory.DealOpptyGroupingCreation(1,opportunityList[0],dealCreation)[0];
			database.insert(opptyGroup);

			prod.Business_Group__c='MN';
			prod.Family= 'FN';
			database.insert (prod);

			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal);
			nokiaFinCalList.add(nokiaFinCal);

			Dated_Exchange_Rates__c ExchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			ExchangeRate.DER_Period__c = nokiaFinCal.id;
			ExchangeRate.CurrencyIsoCode ='USD';
			database.insert(ExchangeRate);

			oif = TestDataFactory.orderIntakeCreation(3, opportunityList[0],prod,nokiaFinCalList[0]);
			insert oif;

			Test.stoptest();
			OrderIntakeHandler.insertExecuted = false;
			OrderIntakeHandler.updateExecuted = false;
			GlobalConstants.isOrderIntakeUpdateFirstRun  = true;

			delete oif[0];
		}
	}
}