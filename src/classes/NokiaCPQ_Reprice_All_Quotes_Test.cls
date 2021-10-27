@isTest(SeeAllData=true)
public with sharing class NokiaCPQ_Reprice_All_Quotes_Test {
	
  /*  static testmethod void RepriceQuoteCtrl_InitTest1(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId();
		insert opportunities;  
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;
		
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = true;
		proposals[0].NokiaCPQ_Last_Reprice__c = system.today();
		//proposals[0].RecordTypeId ='01241000001EPXcAAO';  //indirect draft quote
		insert proposals;  
		
  /*	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = true;
		proposals[0].Reprice_In_Progress__c = true;
		proposals[0].IsCollaborationProgress__c = false;
		//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
		//proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
		insert proposals;
	   */
		//get a Price List
  /*	  Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='EUR';
		priceList.Apttus_Config2__Active__c=false;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		insert priceList;
		
		// create a product configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		insert prodConfigs;
		
		//get a IP Routing Product
		Product2 productInst = NOKIA_CPQ_TestDataFactory.productCreationDirect(1)[0];
		productInst.Apttus_Config2__ConfigurationType__c = 'Bundle';
		insert productInst; 
		
		// create a Line Item
		/*List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
		lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
		lineItems[0].Apttus_Config2__ProductId__c = productInst.Id;
		lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
		lineItems[0].Apttus_Config2__ChargeType__c ='Standard Price';
		lineItems[0].Apttus_Config2__PricingStatus__c = 'Pending';
		insert lineItems;*/
		
	/*	list<Apttus_Config2__LineItem__c> LineItemList = new List<Apttus_Config2__LineItem__c>();

		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = priceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			//Portfolio_from_Quote_Line_Item__c = 'Nokia Software',
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = productInst.Id,
		   // Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__PricingStatus__c = 'Pending',		   
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		 

		//insert LineItem2;
		LineItemList.add(LineItem1);
		
		test.startTest();
	   // ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	   // ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
		NokiaCPQ_Reprice_All_Quotes objControllerClass = new NokiaCPQ_Reprice_All_Quotes();
		objControllerClass.init();
		//objControllerClass.doUpdatePrice();
		objControllerClass.cancel();
		objControllerClass.checkCounter();
		test.stopTest(); 
		
	}
	static testmethod void RepriceQuoteCtrl_InitTest2(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId();
		insert opportunities;  
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;
		
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].NokiaCPQ_Last_Reprice__c = system.today();   
		proposals[0].Apttus_Proposal__Approval_Stage__c = 'Approved';
		insert proposals;  
  
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='EUR';
		priceList.Apttus_Config2__Active__c=false;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		insert priceList;
		
		// create a product configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		insert prodConfigs;
		
		//get a IP Routing Product
		Product2 productInst = NOKIA_CPQ_TestDataFactory.productCreationDirect(1)[0];
		productInst.Apttus_Config2__ConfigurationType__c = 'Bundle';
		insert productInst; 
		
		// create a Line Item
	   /* List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
		lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
		lineItems[0].Apttus_Config2__ProductId__c = productInst.Id;
		lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
		lineItems[0].Apttus_Config2__ChargeType__c ='Standard Price';
		insert lineItems; */
		
  /*	   list<Apttus_Config2__LineItem__c> LineItemList1 = new List<Apttus_Config2__LineItem__c>();

		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = priceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			//Portfolio_from_Quote_Line_Item__c = 'Nokia Software',
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = productInst.Id,
		   // Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__PricingStatus__c = 'Pending',		   
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		 

		//insert LineItem2;
		LineItemList1.add(LineItem2);
		
		
		
		test.startTest();
	   // ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	  //  ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
		NokiaCPQ_Reprice_All_Quotes objControllerClass = new NokiaCPQ_Reprice_All_Quotes();
		//objControllerClass.init();
		objControllerClass.doUpdatePrice();
		test.stopTest(); 
	}*/
}