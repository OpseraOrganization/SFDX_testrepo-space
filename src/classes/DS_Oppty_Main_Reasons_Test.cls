@istest
private with sharing class DS_Oppty_Main_Reasons_Test{
	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
	public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
	
   static testmethod void bypassLogicTest(){
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
		
		Account accountCreationDP = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreationDP);
		
		Account acc = new Account();
		acc.Name='Legal Entity Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreationDP.Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		
		//Create Digital Proposal
		SWx_Upsell_Proposal__c upsellProposal_SWX=TestDataFactory.upsellList(1,accountCreationDP)[0];
		upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal_SWX.Analytics_Source__c='CXM';
		upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
		upsellProposal_SWX.P20_Id__c=215616;
		upsellProposal_SWX.CurrencyIsoCode='EUR';
		upsellProposal_SWX.Unweighted_Value__c=429052.07;
		upsellProposal_SWX.Account_ID__c=accountCreationDP.Id;
		upsellProposal_SWX.Sold_To_Party__c = accountCreationDP.Id;
		upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
		database.insert(upsellProposal_SWX);
			
		//Create Opportunity
			Opportunity oppty = TestDataFactory.OpportunityCreation(1,accountCreationDP)[0];
			oppty.SWx_Upsell_Proposal__c=upsellProposal_SWX.id;
			database.insert(oppty);
			
			oppty.StageName = 'Win the Case (Negotiate)';
			oppty.Phase_Status__c = 'Offer Submitted to Customer (Manual)';
			oppty.Lead_BG__c ='MN';
			database.update(oppty);
			
			Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
			database.insert(priceList);
			
			Product2 product = TestDataFactory.productCreation(1)[0];
			insert product;
			Nokia_Financial_Calendar__c nfc =  TestDataFactory.nokiaFinCalCreation(1)[0];
			insert nfc;
		 /*   Order_Intake_Forecast__c oif = TestDataFactory.orderIntakeCreation(1,oppty, product, nfc)[0];
			oif.OIF_Value__c  = 12000;
			oif.Business_Unit__c = 'CCN';
			insert oif;
			oif.Forecast_Category__c = 'RoP';
			update oif;
			system.debug('oif amount >>'+ oppty.OIF_Amount_EUR__c); */
			
			
			Apttus_Approval__Approval_Request__c appreq = new Apttus_Approval__Approval_Request__c();
			appreq.Apttus_Approval__Step_Name__c = 'G4 Process Test';
			appreq.Apttus_Approval__Assigned_To_Type__c = 'User';
			appreq.Apttus_Approval__Related_Opportunity__c = oppty.id;
			insert appreq;

			Apttus_Approval__Approval_Process__c appProcess = new Apttus_Approval__Approval_Process__c();
			appProcess.Apttus_Approval__Process_Name__c = 'G5 Contract Approvals (Bypass)';
			appProcess.Apttus_Approval__Object_Type__c = 'Opportunity';
			insert appProcess;
			
			Apttus_Approval__Approval_Process__c appProcess1 = new Apttus_Approval__Approval_Process__c();
			appProcess1.Apttus_Approval__Process_Name__c = 'G6 Approvals (Bypass)';
			appProcess1.Apttus_Approval__Object_Type__c = 'Opportunity';
			insert appProcess1; 
	
			Apttus_Approval__Approval_Process__c appProcess2 = new Apttus_Approval__Approval_Process__c();
			appProcess2.Apttus_Approval__Process_Name__c = 'G5 Approvals Bypass';
			appProcess2.Apttus_Approval__Object_Type__c = 'Opportunity';
			insert appProcess2; 
			
			Test.startTest();
			Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
			quoteProposal.Apttus_Proposal__Opportunity__c = oppty.id; 
			quoteProposal.Apttus_QPConfig__PriceListId__c = priceList.Id;
			quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
			quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited';
			quoteProposal.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
			quoteProposal.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource_CCRE;
			quoteProposal.Apttus_Proposal__Account__c=accountCreationDP.id;
			quoteProposal.Prices_Aligned__c=true;
			quoteProposal.RecordTypeId = swxQuoteRecordTypeId;
			insert quoteProposal;
				checkRecursive.run=true;
		
				quoteProposal.Apttus_Proposal__Approval_Stage__c='Accepted';
				update quoteProposal;
			Integer i = DS_Oppty_Main_Reasons.checkOpttyStageParams(oppty.id);
				
			Test.stopTest();
	   
		
   }
	
   }	
	
}