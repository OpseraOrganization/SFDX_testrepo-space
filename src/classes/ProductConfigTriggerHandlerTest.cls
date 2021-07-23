@isTest(SeeAllData = true)
public class ProductConfigTriggerHandlerTest {
		
   static testMethod void ProductConfigTriggerHandlerTestmethod1() {
		User sysAdminUser = TestDataFactory.createSystemAdminUser();   
	 System.runAs(sysAdminUser){
		Nokia_Validation_Callback nvc = new Nokia_Validation_Callback();
		Apttus_Config2.CustomClass.ValidationResult result;
		//create account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		 insert accounts;
		
		//Create Opportunity
	  List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();
		insert opportunities1; 
		 
	 List<opportunity> opportunities2 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities2[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();
		insert opportunities2; 
		 
		List<NokiaCPQ_Site__c> siteCreation = new List<NokiaCPQ_Site__c>();
	NokiaCPQ_Site__c site1 = new NokiaCPQ_Site__c(
			Name = 'Test1', 
			Opportunity__c = opportunities1[0].id 
		 
		); 
		 siteCreation.add(site1);
		//Create Product 
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
			Name = 'Test1', 
			ProductCode = '123', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = true
		); 
		prods.add(prod1);
		
		
		Product2 prod2 = new product2(
			Name = 'Test2', 
			ProductCode = '1234', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = true
		); 
		prods.add(prod2);
		Product2 prod3 = new product2(
			Name = 'Test3', 
			ProductCode = '12345', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = false
		); 
		prods.add(prod3);
		insert prods;
		//Create PriceList
		
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
		);
		insert ApttusTestPriceList;
		
		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod1.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		//insert pLI1;
		plistItems.add(pLI1);
		
		Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_Config2__ListPrice__c = 200, 
			Apttus_Config2__ProductId__c = prod2.Id, 
			Apttus_Config2__ChargeType__c = 'Maintenance Y1'
		);
		//insert pLI2;
		plistItems.add(pLI2);
		Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod3.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI3);
		
		test.startTest();
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Basic';
		proposals[0].NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.AIRSCALE_WIFI_STRING; //MN airscale wifi portfolio
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId();//direct draft quote
		insert proposals; 
	List<Apttus_Proposal__Proposal__c > proposals1 = NOKIA_CPQ_TestDataFactory.createProposalDirect(1); 
		 proposals1[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals1[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
		proposals1[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Basic';
		proposals1[0].NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.AIRSCALE_WIFI_STRING; //MN airscale wifi portfolio
		proposals1[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId();//direct draft quote
		
	insert proposals1;
		 
		 
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = proposals[0].Id, 
			Apttus_Config2__Status__c = 'Saved', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal',
			NokiaCPQ_Quote_Type__c='Direct CPQ'
			
		);
		insert ProdConfig;
		
		//Create Line Items
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem2;
		allLineItems.add(LineItem1);
		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 100.00,
			Apttus_Config2__ListPrice__c = 200,
			Apttus_Config2__Quantity__c = 1,
			
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem2);
		Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			
			Apttus_Config2__ListPrice__c = 300,
			Apttus_Config2__Quantity__c = 1,
			
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem3);
		
		Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Maintenance Y1', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			
			Apttus_Config2__ListPrice__c = 120,
			Apttus_Config2__Quantity__c = 1,
			
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			
			
			Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem1;
		allLineItems.add(LineItem4);
	Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod3.Id,
			Apttus_Config2__PriceListItemId__c = pLI3.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			
			Apttus_Config2__ListPrice__c = 300,
			Apttus_Config2__Quantity__c = 1,
			
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem5);
		Apttus_Config2__LineItem__c LineItem6 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Option',
			Apttus_Config2__ProductId__c = prod3.Id,
			Apttus_Config2__PriceListItemId__c = pLI3.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 300,
			Apttus_Config2__Quantity__c = 1,
			
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem6);
		
	Apttus_Config2__LineItem__c LineItem7 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Option',
			Apttus_Config2__ProductId__c = prod3.Id,
			Apttus_Config2__PriceListItemId__c = pLI3.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 100.00,
			Apttus_Config2__ListPrice__c = 300,
			Apttus_Config2__Quantity__c = 1,
			
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		 allLineItems.add(LineItem7);
		insert allLineItems;
		
		//Create summary Group
		//
		list<Apttus_Config2__SummaryGroup__c> allSummarygrps = new List<Apttus_Config2__SummaryGroup__c>();
		Apttus_Config2__SummaryGroup__c allSummarygrp1 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Configurable Products',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 100,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		allSummarygrps.add(allSummarygrp1);
		Apttus_Config2__SummaryGroup__c allSummarygrp2 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Configurable Products',
			Apttus_Config2__LineNumber__c = 2,
			Apttus_Config2__ItemSequence__c = 2,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 120,
			Apttus_Config2__Description__c = 'Maintenance Y1 (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 80,
			Apttus_Config2__ChargeType__c = 'Maintenance Y1',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		
		allSummarygrps.add(allSummarygrp2);
		 Apttus_Config2__SummaryGroup__c allSummarygrp3 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Configurable Products',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 800,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		allSummarygrps.add(allSummarygrp3);
		 
		 Apttus_Config2__SummaryGroup__c allSummarygrp4 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Subtotal - Standard Price (One Time) - Standard Price (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 100,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		allSummarygrps.add(allSummarygrp4);
		insert allSummarygrps;
		
		//negative test scenario
		nvc.isChargeTypeMaintenance(allSummarygrps);
		nvc.isCADCorrect(allSummarygrps);
		
		PageReference pref = Page.Apttus_Config2__CartDetailView;
		Test.setCurrentPage(pref);
		
	//	Apttus_Config2.CallbackTester.testValidationCallback(allLineItems[0].Apttus_Config2__ConfigurationId__c, allLineItems, null, new Nokia_Validation_Callback());
		
		//create product configuration
		Apttus_Config2__ProductConfiguration__c testProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = proposals[0].Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert testProdConfig;	  

list<Apttus_Config2__LineItem__c> testAllLineItems = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c testLineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=testProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		
		testAllLineItems.add(testLineItem1);
		insert testAllLineItems;
		
		
 list<Apttus_Config2__SummaryGroup__c> testAllSummarygrps = new List<Apttus_Config2__SummaryGroup__c>();
		Apttus_Config2__SummaryGroup__c testAllSummarygrp1 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Configurable Products',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = testProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 800,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		testAllSummarygrps.add(testAllSummarygrp1);
		insert testAllSummarygrps;
		
		
		
		nvc.isCADCorrect(testAllSummarygrps);
		
	 //   Apttus_Config2.CallbackTester.testValidationCallback(testAllLineItems[0].Apttus_Config2__ConfigurationId__c, testAllLineItems, null, new Nokia_Validation_Callback());
	
		//create product configuration
		Apttus_Config2__ProductConfiguration__c testProdConfig1 = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = proposals[0].Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id)
		);
		insert testProdConfig1;	 
list<Apttus_Config2__LineItem__c> testAllLineItems1 = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c testLineItem11 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=testProdConfig1.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		
		testAllLineItems1.add(testLineItem11);
		insert testAllLineItems1;
		 
	 
		
 list<Apttus_Config2__SummaryGroup__c> testAllSummarygrps1 = new List<Apttus_Config2__SummaryGroup__c>();
		Apttus_Config2__SummaryGroup__c testAllSummarygrp11 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Configurable Products',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = testProdConfig1.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 800,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		testAllSummarygrps1.add(testAllSummarygrp11);
		insert testAllSummarygrps1;
		
		nvc.isCADCorrect(testAllSummarygrps1);
		ProductConfigTriggerHelper.calculatePrice(150.12);
		ProductConfigTriggerHelper.calculatePrice(150.123);
		 
	set<id> configsetId = new set<id>();
		 List<Apttus_Config2__ProductConfiguration__c> oldList = new List<Apttus_Config2__ProductConfiguration__c>();
		 List<Apttus_Config2__ProductConfiguration__c> newList = new List<Apttus_Config2__ProductConfiguration__c>();

		Apttus_Config2__ProductConfiguration__c testProdConfigSite = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = proposals1[0].Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			NokiaCPQ_Quote_Opportunity_Changed__c = True,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals1[0].Id)
		);
		insert testProdConfigSite;   
		 testProdConfigSite.NokiaCPQ_Quote_Opportunity_Changed__c = True;
		 //update testProdConfigSite;
		newList.add(testProdConfigSite);
		 oldList.add(testProdConfigSite);
		 ProductConfigTriggerHandler.afterUpdate(newList,oldList);
		configsetId.add(testProdConfigSite.id);
			
	list<Apttus_Config2__LineItem__c> testAllLineItems2 = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c testLineItem12 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=testProdConfigSite.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			NokiaCPQ_Opportunity_Site__c = siteCreation[0].id,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		
		testAllLineItems2.add(testLineItem12);
		insert testAllLineItems2;
		 testLineItem11.NokiaCPQ_Opportunity_Site__c = null;
		 update testLineItem12;
		ProductConfigTriggerHelper.clearSiteOnConfiguration(configsetId);

	  //  Apttus_Config2.CallbackTester.testValidationCallback(testAllLineItems1[0].Apttus_Config2__ConfigurationId__c, testAllLineItems1, null, new Nokia_Validation_Callback());
		Test.stopTest();
	 }
	
	}
	static testMethod void ProductConfigTriggerHandlerTestmethod2() {
		List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
	 
		insert account3;
		
		List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();
  
		insert opportunities1;
	 
	/*create product*/
	product2 prod = new product2();
		prod.name = '5G';
		prod.CurrencyIsoCode = 'USD';
		prod.Business_Group__c='MN';
		prod.Family= 'A&A-CEM';
		prod.IsActive=True;
		prod.Partner_Visible__c=True;
		prod.ProductCode='FC11011';
		prod.Apttus_Config2__Version__c=1;
		prod.Portfolio__c='Airscale Wifi';
		prod.Created_by_PMDI__c = False;
		prod.Pricing_Clusters__c='NAM';
		prod.IsActive= True;
		insert prod;

		test.startTest(); 
	/*create pricelist*/
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		PriceList_Type__c='CPQ',
		Apttus_Config2__Type__c='Standard',
		Apttus_Config2__Active__c = True
		);
	
		insert ApttusTestPriceList;
		/*create pricelist Item*/
	Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		insert pLI5;
	 
			Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId(),
			Apttus_Proposal__Account__c = account3[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities1.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = false,
			//NokiaCPQ_Environment_Access_Type__c = 'PRM',
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'QTC',
			//	Apttus_CQApprov__Approval_Status__c= 'Approved'
			//NokiaCPQ_Maintenance_Type__c ='MN GS TSS Basic',
			Is_List_Price_Only__c = true 
		 );
		insert testProposal1;
		
	 //create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = account3[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = testProposal1.Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal1.Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal',
			Apttus_CQApprov__Approval_Status__c = 'Approved'

		);
		insert ProdConfig;
		
	 
		 //Create Line Items
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod.Id,
	CPQ_Market_Model__c='',
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			is_Custom_Product__c=false,
			Apttus_Config2__PrimaryLineNumber__c = 1,
	 
		 
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem2;
		allLineItems.add(LineItem1);
		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod.Id,
			CPQ_Market_Model__c=null,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 100.00,
			Apttus_Config2__ListPrice__c = 200,
			Apttus_Config2__Quantity__c = 1,
	  is_Custom_Product__c=false,			
			Apttus_Config2__PrimaryLineNumber__c = 1,
			
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem2);
		Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod.Id,
	 CPQ_Market_Model__c=null,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			is_Custom_Product__c=false,
			Apttus_Config2__ListPrice__c = 300,
			Apttus_Config2__Quantity__c = 1,
			
			Apttus_Config2__PrimaryLineNumber__c = 1,
		 
			
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem3);
		
		Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Maintenance Y1', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod.Id,
	CPQ_Market_Model__c=null,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			is_Custom_Product__c=false,
			Apttus_Config2__ListPrice__c = 120,
			Apttus_Config2__Quantity__c = 1,
			
			Apttus_Config2__PrimaryLineNumber__c = 1,
		 
			
			
			Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem1;
		allLineItems.add(LineItem4);
	Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod.Id,
			CPQ_Market_Model__c=null,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			is_Custom_Product__c=false,
			Apttus_Config2__ListPrice__c = 300,
			Apttus_Config2__Quantity__c = 1,
			
			Apttus_Config2__PrimaryLineNumber__c = 1,
	
			
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem5);
		Apttus_Config2__LineItem__c LineItem6 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Option',
			Apttus_Config2__ProductId__c = prod.Id,
			CPQ_Market_Model__c=null,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 300,
			Apttus_Config2__Quantity__c = 1,
			is_Custom_Product__c=false,
			Apttus_Config2__PrimaryLineNumber__c = 1,
		 
			
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem6);
		
	Apttus_Config2__LineItem__c LineItem7 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Option',
			Apttus_Config2__ProductId__c = prod.Id,
	CPQ_Market_Model__c=null,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 100.00,
			Apttus_Config2__ListPrice__c = 300,
			Apttus_Config2__Quantity__c = 1,
			is_Custom_Product__c=false,
			Apttus_Config2__PrimaryLineNumber__c = 1,
		  
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		 allLineItems.add(LineItem7);
	 
	Apttus_Config2__LineItem__c LineItem8 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Option',
			Apttus_Config2__ProductId__c = prod.Id,
	CPQ_Market_Model__c='Test1 QTY(1)',
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 100.00,
			Apttus_Config2__ListPrice__c = 300,
			Apttus_Config2__Quantity__c = 1,
			is_Custom_Product__c=false,
			Apttus_Config2__PrimaryLineNumber__c = 1,
		  
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		 allLineItems.add(LineItem8);
		insert allLineItems;
		System.debug('debug here for allLineItems' +allLineItems);
		//Create summary Group
		//
		list<Apttus_Config2__SummaryGroup__c> allSummarygrps = new List<Apttus_Config2__SummaryGroup__c>();
		Apttus_Config2__SummaryGroup__c allSummarygrp1 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Total (One Time)',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Total (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 100,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
		);
		allSummarygrps.add(allSummarygrp1);
		Apttus_Config2__SummaryGroup__c allSummarygrp2 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Configurable Products',
			Apttus_Config2__LineNumber__c = 2,
			Apttus_Config2__ItemSequence__c = 2,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 120,
			Apttus_Config2__Description__c = 'Maintenance Y1 (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 80,
			Apttus_Config2__ChargeType__c = 'Maintenance Y1',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);

		 Apttus_Config2__SummaryGroup__c allSummarygrp4 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Subtotal - Standard Price (One Time) - Standard Price (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 100,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		allSummarygrps.add(allSummarygrp4);
	
	Apttus_Config2__SummaryGroup__c allSummarygrp5 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 10,
			Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c =5,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		allSummarygrps.add(allSummarygrp5);
		insert allSummarygrps;
		

		
		test.stopTest();
	}
}