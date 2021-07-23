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
Private class OrderIntakeHeplerTest{
	private static  Set<ID> OpptyID = new Set<ID>();
	/******************************
*Method Name: orderIntake
*Description: Test Method to cover OrderIntakeHepler, OrderIntakeHandler class
********************************/
	static testMethod void orderIntake(){
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.RunAs(userCreation){
	
			Account acc = TestDataFactory.createAccount(1)[0];
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
			prod.Business_Group__c='FN';
			prod.Family= 'FNCABLE';
			database.insert (prod);
			
			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal);
			//nokiaFinCal.Start_Date__c=system.today()+1;
			//nokiaFinCal.End_Date__c = system.today()-1;
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
			
			// OrderIntakeHepler.CloneLinesChangeCurrency(OpptyID);

			
			
			
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
		 
		
	
	
	static testMethod void orderIntakeUpdate(){
	
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		List<Order_Intake_Forecast__c> empoif=new List<Order_Intake_Forecast__c>();
		Map<id,Opportunity> opptyMap = new Map<id,Opportunity>();
		List<Order_Intake_Forecast__c> oif1=new List<Order_Intake_Forecast__c>();
		
		List<Opportunity> optylist = new List<Opportunity>();
		
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.RunAs(userCreation){
	
			Account acc = TestDataFactory.createAccount(1)[0];
			database.insert(acc);
			
			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc)[0];
	
			database.insert(opp1);
			//Opportunity opp2 = TestDataFactory.OpportunityCreation(1,acc)[0];
			//opp2.CurrencyIsoCode='USD';
			//opp2.Sales_Outcome__c='Lost to Competitor';
			//database.insert(opp2);
			
			product2 prod = TestDataFactory.productCreation(1)[0];
			prod.Business_Group__c='FN';
			prod.Family= 'FNCABLE';
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
	
	List<Order_Intake_Forecast__c> empoif=new List<Order_Intake_Forecast__c>();
		Map<id,Opportunity> opptyMap = new Map<id,Opportunity>();
		List<Order_Intake_Forecast__c> oif1=new List<Order_Intake_Forecast__c>();
		
		List<Opportunity> optylist = new List<Opportunity>();
		
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		
		System.RunAs(userCreation){
			Account acc = TestDataFactory.createAccount(1)[0];
			database.insert(acc);
	 
			
			Opportunity opp2 = TestDataFactory.OpportunityCreation(1,acc)[0];
			opp2.CurrencyIsoCode='USD';
			opp2.amount=200000;
			opp2.Sales_Outcome__c='';
			//opp2.Sales_Outcome_Reason__c='Commercial';
			//opp2.Second_Reason__c='Quality';
			//opp2.Third_Reason__c='Technical';
			
			database.insert(opp2);
			
			product2 prod = TestDataFactory.productCreation(1)[0];
			prod.Business_Group__c='FN';
			prod.Family= 'FNCABLE';
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
			try {
			oif[2].Update_Status__c=false;
	 database.update(oif[2]);
	 
	
		}
		catch(DmlException e) {
		
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
	static testMethod void copyOpptyProgramFlagToOifTest(){
	
	
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
		//OptyProgramFlagJunction__c opfj = new OptyProgramFlagJunction__c();
		Program_Flag__c pfdata = new Program_Flag__c();
		Nokia_Financial_Calendar__c nokiaFinCalObjCreation = new Nokia_Financial_Calendar__c();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		System.runAs(userCreation){
			
			accountList = TestDataFactory.createAccount(2);
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
			database.insert(opportunityList);
			productCreation = TestDataFactory.productCreation(1)[0];
			productCreation.Business_Group__c='FN';
			productCreation.Family= 'FNCABLE';
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
	* Method Name: DeletecloneLinesTestt
	* Description: This method used to cover the test method of DeletecloneLines
	* Parameters: NA
	************************/ 
	
	
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
		System.RunAs(userCreation){
	
	
			Account acc = TestDataFactory.createAccount(1)[0];
			database.insert(acc);
			Account acc1 = TestDataFactory.createAccount(1)[0];
			acc1.Name = 'Test Acc';
			database.insert(acc1);
	
			Opportunity opp = TestDataFactory.OpportunityCreation(1,acc)[0];
			database.insert(opp);
	
			//opp.StageName = 'Win the Case (Negotiate)';
			//opp.Phase_Status__c = 'Submitted for G5 Approval';
			opp.Probability = 10;
			
			database.update(opp);
			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc1)[0];
			database.insert(opp1);
			
			set<ID> oppidset =new set<ID>();
			oppidset.add(opp1.id);
			
			Test.starttest();
			Offer__c offerCreation = TestDataFactory.OfferCreation(1,opp1)[0];
	 offerCreation.ActiveOffer__c = true;
	 offerCreation.Expected_LoA_G4_Approval_Level__c = 'A';
			insert offerCreation;
			
			product2 prod = TestDataFactory.productCreation(1)[0];
			prod.Business_Group__c='FN';
			prod.Family= 'FNCABLE';
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
	
	/*
	static testMethod void testCreateandCloneOIF(){
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.RunAs(userCreation){
			
			Account acc = TestDataFactory.createAccount(1)[0];
			database.insert(acc);
			
			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc)[0];
			opp1.Contract_Signing_Entity__c = 'fNOK';
			database.insert(opp1);
			Opportunity opp2 = TestDataFactory.OpportunityCreation(1,acc)[0];
			opp2.CurrencyIsoCode='EUR';
			opp2.Sales_Outcome__c='Lost to Competitor';
			opp2.Sales_Outcome_Reason__c = 'Commercial';
			opp2.Second_Reason__c = 'Quality';
			opp2.Third_Reason__c = 'Technical';
			opp2.Contract_Signing_Entity__c = 'fNOK';
			database.insert(opp2);
			
			
			Test.starttest();
			product2 prod = new product2();
			prod.name = 'FN - 5G(BL)';
			prod.ProductCode = 'BBA7342';
			prod.CurrencyIsoCode = 'USD';
			prod.IsActive=True;
			prod.Business_Group__c='FN';
			prod.Family= 'FN SER';
			prod.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Business Line').getRecordTypeId();
			
			
			product2 prod2 = new product2();
			prod2.name = 'NSW - 8G(BL)';
			prod2.ProductCode = 'NM';
			prod2.CurrencyIsoCode = 'USD';
			prod.Business_Group__c='NSW';
			prod.Family= 'NSW SER';
			prod2.IsActive=True;
			prod2.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Business Line').getRecordTypeId();
			
			//Insert prod2;
			//prod.Allocated_BL_1__c = prod2.Id;
			//prod.Post_Allocation_1__c = 5;
			Insert prod;
			
			
			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal);
			//nokiaFinCal.Start_Date__c=system.today()+1;
			//nokiaFinCal.End_Date__c = system.today()-1;
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
			
			Order_Intake_Forecast__c oifResult = [Select Id, Opportunity__c, Opportunity__r.CurrencyIsoCode ,Opportunity__r.Contract_Signing_Entity__c, BusinessLine__c, BusinessLine__r.Family,
					BusinessLine__r.Business_Group__c, BusinessLine__r.Total_Allocation__c, BusinessLine__r.Allocated_BL_1__c, 
					BusinessLine__r.Allocated_BL_2__c, BusinessLine__r.Allocated_BL_3__c, CurrencyIsoCode, Exclude_Reason__c, 
					Allocation__c, Forecast_Category__c, Notes__c, OIF_Value__c, POPlanReceipt__c, Rev_RecPlan_Receipt__c, Software__c,
					BusinessLine__r.Post_Allocation_1__c, BusinessLine__r.Post_Allocation_2__c, BusinessLine__r.Post_Allocation_3__c
					From Order_Intake_Forecast__c Where Id =: oif[1].Id];
			OrderIntakeHepler.setInfo2AllocationOIF(oifResult.Id, oifResult, oifResult);
			//OrderIntakeHepler.setInfo2CreateAllocationOIF(oifResult);
			Test.stoptest();
		*/ 
	/***********************
	* Method Name: chatterOnInsertandUpdateTest
	* Description: This method used to cover the test method of chatterOnInsert and chatterOnUpdate
	* Parameters: NA
	************************/ 
	static testMethod void chatterOnInsertandUpdateTest()
	{
		//Get Id of territory 
		Id territoryId = TestDataFactory.getTerritoryId();	
		
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		
		//Create a test user to create opportunity
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.RunAs(userCreation){
	
			//create an account needed for creating opportunity
			Account acc = TestDataFactory.createAccount(1)[0];
			database.insert(acc);
			
			//Asscociate account to the territory
			List<ObjectTerritory2Association> objTerr2Association = TestDataFactory.assigningAccountToTerritory(1,acc,territoryId);
			insert objTerr2Association;
			
			//Associate the test user who creates opportunity to the territory
			List<UserTerritory2Association> userToTerritory = TestDataFactory.assigningUserToTerritory(1,userCreation,territoryId);
			insert userToTerritory;
			
			List<Opportunity> opportunityList = new List<Opportunity>();
			
			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc)[0];
	opp1.Contract_Signing_Entity__c = 'fNOK';
			opportunityList.add(opp1);
			
			/*Opportunity opp2 = TestDataFactory.OpportunityCreation(1,acc)[0];
			opp2.CurrencyIsoCode='EUR';
			opp2.Sales_Outcome__c='Lost to Competitor';
			opp2.Sales_Outcome_Reason__c = 'Commercial';
			opp2.Second_Reason__c = 'Quality';
			opp2.Third_Reason__c = 'Technical';
			opportunityList.add(opp2);*/
			Database.insert(opportunityList);
			
			product2 prod = TestDataFactory.productCreation(1)[0];
			prod.Business_Group__c='FN';
			prod.Family= 'FNCABLE';
			database.insert (prod);
			
			List<Nokia_Financial_Calendar__c> nokiaFinCalList = new List<Nokia_Financial_Calendar__c>();
			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal);
			//nokiaFinCal.Start_Date__c=system.today()+1;
			//nokiaFinCal.End_Date__c = system.today()-1;
			nokiaFinCalList.add(nokiaFinCal);
			
			Nokia_Financial_Calendar__c nokiaFinCal1 = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal1);
			nokiaFinCal1.Start_Date__c=system.today();
			nokiaFinCal1.End_Date__c = system.today()+5;
			nokiaFinCalList.add(nokiaFinCal1);
			database.update(nokiaFinCalList);
			
			
			Dated_Exchange_Rates__c ExchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			ExchangeRate.DER_Period__c=nokiaFinCal.id;
			ExchangeRate.CurrencyIsoCode ='USD';
			database.insert(ExchangeRate);
	
			Test.starttest();
	 
			user userCreation1 = TestDataFactory.userCreation(1,'Nokia Sales Profile')[0];
			//insert userCreation1;
			
			List<UserTerritory2Association> userToTerritory1 = TestDataFactory.assigningUserToTerritory(1,userCreation1,territoryId);
			//insert userToTerritory1;
	 
			List<Order_Intake_Forecast__c> oif=new List<Order_Intake_Forecast__c>();
	 
			//System.runAs(userCreation1)
			//{
	 
	 oif=TestDataFactory.orderIntakeCreation(3,opp1,prod,nokiaFinCal);
	insert oif;
			
	OrderIntakeHandler.insertExecuted = false;
	oif[0].OIF_Value__c = 10;
	oif[0].notes__c = 'test';
	update oif;
			//adding for test class failures
		 OrderIntakeHepler.chatterOnInsert(oif); 
	//OrderIntakeHepler.chatterOnInsert(oif); 
			
	Map<Id,Order_Intake_Forecast__c> oldmap = new Map<Id,Order_Intake_Forecast__c>();
	oldmap.put(oif[0].id,oif[0]);
	  
			//map<String, Order_Intake_Forecast__c> map_oifId_oppValue = new map<String, Order_Intake_Forecast__c>();
	 // map_oifId_oppValue.put(oif[0].Id, oif[0]);
	  Order_Intake_Forecast__c OppforNewOif = null;
			
	
	//opp1.Contract_Signing_Entity__c = 'fNOK';
	//update opp1;
	
	OrderIntakeHepler.setInfo2CreateAllocationOIF(oif[0]);
	
	OrderIntakeHepler.setInfo2AllocationOIF(oif[0].id,oif[0],oif[0]);
	//SFticket 14672 modified by YiShao change createAllocationOIF method to future to avoid too many soql issue 20181017
	Set<String> oifIdSet = new Set<String>();
	oifIdSet.add(oif[0].Id);
	//OrderIntakeHepler.createAllocationOIF(oifIdSet);
	//SFticket 14672 End
	Map<Id,Order_Intake_Forecast__c> newmap = new Map<Id,Order_Intake_Forecast__c>();	  
	oif[1].notes__c = 'testing';
	oif[1].Allocation_Clone__c = oif[1].id;
	oif[1].Allocation_Line_1__c = oif[2].id; 
	  // oif[1].Allocation_Line_2__c = oif[1].id;
	
	newmap.put(oif[0].id,oif[1]);
			
	  OrderIntakeHepler.updateAllocationOIF(newmap,oldmap);
			OrderIntakeHepler.clearAllocationOIF(oif);
			GlobalConstants.isOrderIntakeFirstRun = null;
			OrderIntakeHepler.businessLineDataInsert(oif,newmap);
			OrderIntakeHepler.createAllocationOIF(null);
	opp1.Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			opp1.Committed_Unweighted_Value_in_EUR__c= 10000;
			opp1.Sales_Outcome__c=null;
			OrderIntakeHepler.UpsellDelta_OpptyCheck(oif);
			OrderIntakeHepler.UpsellDelta_OpptyCheckInsert(oif,new Map<ID,Opportunity>{opp1.Id=>opp1});
			OrderIntakeHepler.UpsellDealvalidator(oif,new Map<ID,Opportunity>{opp1.Id=>opp1});
			OrderIntakeHepler.UpsellDelta_OpptyCheckDelete(oif,new Map<ID,Opportunity>{opp1.Id=>opp1});
			//system.assert(oldmap.containskey(oif[0].id));
		}
		}
}