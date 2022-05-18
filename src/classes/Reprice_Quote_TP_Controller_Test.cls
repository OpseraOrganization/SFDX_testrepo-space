@isTest
public class Reprice_Quote_TP_Controller_Test 
{
  static testMethod void testInit1()
  {
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
	opportunities[0].Phase_Status__c = 'Submitted for G6 Approval'; //'Pending Win/Loss Declaration';
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].Account_Role__c = 'Alliance Partner';
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
	proposals[0].IsCollaborationProgress__c = false;
	//proposals[0].NokiaCPQ_Is_Maintenance_Quote__c = true;
	//proposals[0].NokiaCPQ_Contract_Start_Date__c = date.today();
	//  proposals[0].Reprice_In_Progress__c = false;
	
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();  //indirect draft quote
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
	test.startTest();
	//get a IP Routing Product
	Product2 productInst = new Product2();
	productInst.Name = 'Test1'; 
	productInst.ProductCode = '123'; 
	productInst.CurrencyIsoCode = 'USD';
	productInst.Pricing_Clusters__c='NAM';
	productInst.Portfolio__c = 'IP Routing';
	productInst.isActive = true;
	productInst.Apttus_Config2__ConfigurationType__c = 'Standalone';
	productInst.NokiaCPQ_Item_Type__c='Software';
	productInst.NokiaCPQ_Classification2__c='Standard SW (STD)';
	productInst.NokiaCPQ_License_Usage__c='Commercial Term License';
	productInst.NokiaCPQ_Product_Discount_Category__c = 'XYZ';
	insert productInst;
	
	// create a Line Item
	List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
	lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
	lineItems[0].Apttus_Config2__ProductId__c = productInst.Id;
	lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
	lineItems[0].Apttus_Config2__ChargeType__c ='Standard Price';
	insert lineItems;
	
	
	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);

	Reprice_Quote_TP_Controller objControllerClass = new Reprice_Quote_TP_Controller();
	objControllerClass.init();

	objControllerClass = new Reprice_Quote_TP_Controller();
	proposals[0].IsCollaborationProgress__c = true;
	update proposals[0];
	objControllerClass.init();

	objControllerClass = new Reprice_Quote_TP_Controller();
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	update proposals[0];
	objControllerClass.init();

	delete prodConfigs;
	proposals[0].NokiaCPQ_Needs_Reprice__c = true;
	proposals[0].IsCollaborationProgress__c = false;
	update proposals[0];
	objControllerClass = new Reprice_Quote_TP_Controller();
	objControllerClass.init();

	test.stoptest();
  }
  
  static testMethod void testInit2()
  {
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
	insert accounts;
	
	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].CurrencyIsoCode='EUR';//'GBP';
	opportunities[0].Account_Role__c = 'Alliance Partner';
	insert opportunities;  
	
	
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = true;
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
  
	List<Product2> productInst = NOKIA_CPQ_TestDataFactory.productCreation(2);
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
	test.startTest();
	
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
	
	
	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	Reprice_Quote_TP_Controller objControllerClass = new Reprice_Quote_TP_Controller();
	objControllerClass.init();
	objControllerClass.cancel();
	
	test.stopTest();  
  }
  static testMethod void testWrapper()
  {
	Reprice_Quote_TP_Controller.initializeRequest req = new Reprice_Quote_TP_Controller.initializeRequest();

	Reprice_Quote_TP_Controller.ProductConfiguration prodConfig = new Reprice_Quote_TP_Controller.ProductConfiguration();
	prodConfig.id = 'test';
	prodConfig.name = 'test config';
	prodConfig.priceListId = 'test pricelist';
	prodConfig.effectivepriceListId = 'test pricelist';
	req.prodConfig = prodConfig;

	Reprice_Quote_TP_Controller.ConfigLineItemPutRequest putRequest = new Reprice_Quote_TP_Controller.ConfigLineItemPutRequest();
	putRequest.Id = 'test';
	putRequest.Name = 'test';
	putRequest.PriceListId = 'test';
	putRequest.PricingStatus = 'pending';
	putRequest.ProductId = 'test';
	putRequest.ItemSequence = 1.0;
	putRequest.LineType = 'Product';
	putRequest.IsPrimaryLine = true;
	putRequest.PrimaryLineNumber = 1.0;
	putRequest.LineNumber = 1.0;

  }
  
}