@isTest
public with sharing class NokiaCPQ_Reprice_Quote_Ctrlr_Test {
  static testmethod void RepriceQuoteCtrl_InitTest2(){ 
	//create a Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='301030872';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;
	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);
	
	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
	opportunities[0].StageName = 'Handover (Prepare for Delivery)';
	opportunities[0].Phase_Status__c = 'Submitted for G6 Approval';
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
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
	//  proposals[0].Reprice_In_Progress__c = false;
	
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	proposals[0].RecordTypeId ='01241000001EPXcAAO';  //indirect draft quote
	insert proposals;	 
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);
	
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
	//Product2 productInst = new Product2();
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
	List<Product2> productInst = TestDataSetup.createCPQTestproduct(1);
	insert productInst;
	
	// create a Line Item
	List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
	lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
	lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
	lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
	lineItems[0].Apttus_Config2__ChargeType__c ='Standard Price';
	insert lineItems;
	
	test.startTest();
	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Reprice_Quote_Ctrlr objControllerClass = new NokiaCPQ_Reprice_Quote_Ctrlr();
	objControllerClass.totalLineItems = 2;
	objControllerClass.init();
	test.stopTest(); 
	
  } 
  
  
  static testmethod void RepriceQuoteCtrl_InitTest3(){
	//create a Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='301030872';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;
	
	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);
	
	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
	opportunities[0].StageName = 'Handover (Prepare for Delivery)';
	opportunities[0].Phase_Status__c = 'Submitted for G6 Approval';
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
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
	proposals[0].Reprice_In_Progress__c = true;
	proposals[0].IsCollaborationProgress__c = true;
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(); //indirect draft quote
	insert proposals;	 
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);
	
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
	//Product2 productInst = new Product2();
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
	List<Product2> productInst = TestDataSetup.createCPQTestproduct(1);
	insert productInst;
	
	// create a Line Item
	List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
	lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
	lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
	lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
	
	insert lineItems;
	
	test.startTest();
	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Reprice_Quote_Ctrlr objControllerClass = new NokiaCPQ_Reprice_Quote_Ctrlr();
	objControllerClass.init();
	test.stopTest(); 
	
  }
  static testmethod void RepriceQuoteCtrl_InitTest4(){
	//create a Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='301030872';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;
	
	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);
	
	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
	opportunities[0].StageName = 'Handover (Prepare for Delivery)';
	opportunities[0].Phase_Status__c = 'Submitted for G6 Approval';
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
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
	proposals[0].Reprice_In_Progress__c = true;
	proposals[0].IsCollaborationProgress__c=false;
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(); //indirect draft quote
	insert proposals;	 
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);
	
	
	test.startTest();
	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	
	NokiaCPQ_Reprice_Quote_Ctrlr objControllerClass = new NokiaCPQ_Reprice_Quote_Ctrlr();
	objControllerClass.init();
	test.stopTest();
  }
  // method for
  // if(configLineItem.NokiaCPQ_Configuration_Type__c == 'Bundle' && configLineItem.Apttus_Config2__ChargeType__c =='Standard Price')
  static testmethod void Reprice_Quote_CtrlrTest5(){
	//create a Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='301030872';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;
	
	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);
	
	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
	opportunities[0].StageName = 'Handover (Prepare for Delivery)';
	opportunities[0].Phase_Status__c = 'Submitted for G6 Approval';
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
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
	proposals[0].Reprice_In_Progress__c = true;
	proposals[0].IsCollaborationProgress__c = false;
	proposals[0].NokiaCPQ_Is_Maintenance_Quote__c = true;
	proposals[0].NokiaCPQ_Contract_Start_Date__c = System.today();
	proposals[0].Warranty_credit__c = 'Yes';
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
	insert proposals;	 
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);
	
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
	//Product2 productInst = new Product2();
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
	List<Product2> productInst = TestDataSetup.createCPQTestproduct(1);
	insert productInst;
	
	// create a Line Item
	List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
	lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
	lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
	lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
	lineItems[0].Apttus_Config2__ChargeType__c = 'Standard Price';
	insert lineItems;
	
	test.startTest();
	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Reprice_Quote_Ctrlr objControllerClass = new NokiaCPQ_Reprice_Quote_Ctrlr();
	objControllerClass.isFinalized = true;
	objControllerClass.init();
	objControllerClass.flagUpdatePrice = true;
	objControllerClass.doUpdatePrice();
	test.stopTest();  
	
  }
  static testmethod void Reprice_Quote_CtrlrTest50(){
	//create a Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
	insert accounts;
	
	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].CurrencyIsoCode='EUR';//'GBP';
	
	insert opportunities;  
	
	
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = true;
	//  proposals[0].Reprice_In_Progress__c = false;
	proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote 
	proposals[0].Direct_Price_List_Number__c = '50';
	proposals[0].NokiaCPQ_Contract_Start_Date__c = System.today();
	proposals[0].Warranty_credit__c = 'Yes';
	proposals[0].NokiaCPQ_Is_Maintenance_Quote__c = true;
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
	prodConfigs[0].Apttus_Config2__ContractNumbers__c = '4';
	insert prodConfigs;
	
	//get a IP Routing Product
	//   Product2 productInst = new Product2();
	//   productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
	/*  List<Product2> productInst = NOKIA_CPQ_TestDataFactory.productCreationDirect(1);
productInst[0].Id = '01t22000000aGNKAA2';
productInst[0].Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
productInst[0].Apttus_Config2__ConfigurationType__c  = Nokia_CPQ_Constants.BUNDLE;
*/   List<Product2> productInst = NOKIA_CPQ_TestDataFactory.productCreation(2);
	// productInst = [SELECT Id, NAME, IsActive, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
	// productInst
	productInst[0].NAME = 'NSW - DI Customer Insights (BL)';
	productInst[0].IsActive  = false;
	productInst[0].ProductCode = 'DICIBL';
	productInst[0].Apttus_Config2__ConfigurationType__c ='Standalone';
	productInst[0].NokiaCPQ_State__c = 'Implement';
	productInst[0].Business_Group__c = 'MN';
	productInst[1].IsActive  = True;
	productInst[1].Apttus_Config2__ConfigurationType__c = 'Bundle';
	productInst[1].NokiaCPQ_State__c = 'Implement';
	productInst[1].Business_Group__c = 'MN';
	insert productInst;
	
	// create a Line Item
	List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(3);
	lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
	lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
	lineItems[0].Apttus_Config2__OptionId__c = productInst[1].Id;
	lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
	lineItems[0].Apttus_Config2__ChargeType__c = 'Standard Price';
	lineItems[0].Apttus_Config2__LineType__c = 'Option';
	
	lineItems[1].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
	lineItems[1].Apttus_Config2__ProductId__c = productInst[1].Id;
	//lineItems[1].Apttus_Config2__OptionId__c = productInst[1].Id;
	lineItems[1].Apttus_Config2__PriceListId__c = priceList.Id;
	lineItems[1].Apttus_Config2__ChargeType__c = 'Standard Price';
	lineItems[1].Apttus_Config2__LineType__c = 'Product/Service';
	
	lineItems[2].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
	lineItems[2].Apttus_Config2__ProductId__c = productInst[0].Id;
	lineItems[2].Apttus_Config2__OptionId__c = productInst[0].Id;
	lineItems[2].Apttus_Config2__PriceListId__c = priceList.Id;
	lineItems[2].Apttus_Config2__ChargeType__c = 'Standard Price';
	//lineItems[2].Apttus_Config2__LineType__c = 'Option'
	//lineItems[0].NokiaCPQ_Configuration_Type__c = Nokia_CPQ_Constants.BUNDLE;
	insert lineItems;
	
	test.startTest();
	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Reprice_Quote_Ctrlr objControllerClass = new NokiaCPQ_Reprice_Quote_Ctrlr();
	objControllerClass.init();
	objControllerClass.flagUpdatePrice = true;
	objControllerClass.doUpdatePrice();
	test.stopTest();  
	
  }
  
  static testmethod void RepriceQuoteCtrl_InitTest6(){
	//create a Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='301030872';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;
	
	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);
	
	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
	opportunities[0].StageName = 'Handover (Prepare for Delivery)';
	opportunities[0].Phase_Status__c = 'Submitted for G6 Approval';
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
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
	proposals[0].Reprice_In_Progress__c = true;
	proposals[0].IsCollaborationProgress__c = true;
	proposals[0].NokiaCPQ_Prior_Leo_Value__c = true;
	proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = true;
	proposals[0].NokiaCPQ_LEO_Discount__c = false;
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c ='No';
	proposals[0].NokiaCPQ_No_of_Years__c = '1';
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(); //indirect draft quote
	insert proposals;	 
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);
	
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
	//Product2 productInst = new Product2();
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
	List<Product2> productInst = TestDataSetup.createCPQTestproduct(1);
	insert productInst;
	
	// create a Line Item
	List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
	lineItems[0].Nokia_Maint_Y1_Per__c = null ;
	lineItems[0].is_Custom_Product__c = true ;
	lineItems[0].Apttus_Config2__ChargeType__c = 'Maintenance Beyond Warranty';
	lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
	lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
	lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
	
	insert lineItems;
	
	test.startTest();
	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Reprice_Quote_Ctrlr objControllerClass = new NokiaCPQ_Reprice_Quote_Ctrlr();
	objControllerClass.init();
	objControllerClass.cancel();
	//objControllerClass.callConstraintRule();
	test.stopTest(); 
	
  }
  static testmethod void RepriceQuoteCtrl_InitTest(){
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='301030872';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;
	
	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);
	
	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
	opportunities[0].StageName = 'Handover (Prepare for Delivery)';
	opportunities[0].Phase_Status__c = 'Submitted for G6 Approval';
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	insert opportunities;
	
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
	//  proposals[0].Reprice_In_Progress__c = false;
	
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	proposals[0].RecordTypeId ='01241000001EPXcAAO';  //indirect draft quote
	insert proposals;
	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	NokiaCPQ_Reprice_Quote_Ctrlr objControllerClass = new NokiaCPQ_Reprice_Quote_Ctrlr();
	objControllerClass.totalLineItems = 2;
	objControllerClass.init();
  }
	static testmethod void Reprice_Quote_CtrlrTest77(){  
	//create a Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='301030872';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;
	 
	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);
	
	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
	opportunities[0].StageName = 'Handover (Prepare for Delivery)';
	opportunities[0].Phase_Status__c = 'Submitted for G6 Approval';
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
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
	proposals[0].Reprice_In_Progress__c = true;
	proposals[0].IsCollaborationProgress__c = false;
	proposals[0].NokiaCPQ_Is_Maintenance_Quote__c = true;
	proposals[0].NokiaCPQ_Contract_Start_Date__c = System.today();
	proposals[0].Warranty_credit__c = 'No';
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
	insert proposals;	 
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);
	
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
	//Product2 productInst = new Product2();
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
	List<Product2> productInst = TestDataSetup.createCPQTestproduct(1);
	insert productInst;
	
	// create a Line Item
	List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
	lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
	lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
	lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
	lineItems[0].Apttus_Config2__ChargeType__c= 'Maintenance Beyond Warranty';
	//lineItems[0].Apttus_Config2__ChargeType__c = 'Standard Price';
	insert lineItems; 
	
	test.startTest();
	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Reprice_Quote_Ctrlr objControllerClass = new NokiaCPQ_Reprice_Quote_Ctrlr();
	objControllerClass.isFinalized = true;
	objControllerClass.init();
	objControllerClass.flagUpdatePrice = true;
	objControllerClass.doUpdatePrice();
	test.stopTest();  
	
  }
}