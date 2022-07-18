@isTest(SeeAllData = false)
public class ProductConfigTriggerHandlerTest{
		
		 private static final String Nokia_Opportunity_Type_For_Test = 'Fast Track Opportunity';

	static testMethod void ProductConfigTriggerHandlerTestmethod2() {
	List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){
	  //  User sysAdminUser = TestDataFactory.createSystemAdminUser();  
Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(); 
product2 prod = new product2();  
Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c();
Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c();
Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c();
	 // System.runAs(sysAdminUser){
		List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	 
		insert account3;
		
		List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
  
		insert opportunities1;
	 
	/*create product*/
	 prod = new product2();
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

		
	/*create pricelist*/
		 ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		PriceList_Type__c='CPQ',
		Apttus_Config2__Type__c='Standard',
		Apttus_Config2__Active__c = True
		);
	
		insert ApttusTestPriceList;
		/*create pricelist Item*/
	 pLI5 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		insert pLI5;
	 
			 testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),
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
			NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'IP Routing',
			//  Apttus_CQApprov__Approval_Status__c= 'Approved'
			//NokiaCPQ_Maintenance_Type__c ='Gold(Return for Exchange)',
			Is_List_Price_Only__c = true 
		 );
		insert testProposal1;
	test.startTest();		
	 //create product configuration
		 ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = account3[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = testProposal1.Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal1.Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal',
			Apttus_CQApprov__Approval_Status__c = 'Approved',
			XAE_Flag__c = 'ADD_LineItem'

		);
		insert ProdConfig;
		
	   
		TempConfigItem__c gppTemObject = New TempConfigItem__c();
			gppTemObject.ConfigItem_Product_Configuration__c = ProdConfig.Id;
			gppTemObject.ProductID__c = prod.Id;
			gppTemObject.Quantity__c = 1;
			
		insert gppTemObject;
	 //}
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
	Nokia_CPQ_Constants.ProductConfigAfterUpdate = 'False';
		insert allLineItems;
		System.debug('debug here for allLineItems' +allLineItems);
		//Create summary Group
		//
	
		test.stopTest();
	}}
	
	static testMethod void ProductConfigTriggerHandlerTestmethod2_site() {
	List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){
	  //  User sysAdminUser = TestDataFactory.createSystemAdminUser();  
Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(); 
Apttus_Config2__ProductConfiguration__c ProdConfig1 = new Apttus_Config2__ProductConfiguration__c(); 
product2 prod = new product2();  
Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c();
Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c();
Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c();
	 // System.runAs(sysAdminUser){
		List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	 
		insert account3;
		
		List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
  
		insert opportunities1;
		
		NokiaCPQ_Site__c site = new NokiaCPQ_Site__c();
	site.name = 'A';
	site.Opportunity__c= opportunities1.get(0).Id;
	
	insert site;
	
	  
	NokiaCPQ_Phase__c phase = new NokiaCPQ_Phase__c();
	phase.name= '2021';
	phase.Opportunity__c= opportunities1.get(0).Id;
	insert phase;
	 
	/*create product*/
	 prod = new product2();
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

		
	/*create pricelist*/
		 ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		PriceList_Type__c='CPQ',
		Apttus_Config2__Type__c='Standard',
		Apttus_Config2__Active__c = True
		);
	
		insert ApttusTestPriceList;
		/*create pricelist Item*/
	 pLI5 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		insert pLI5;
	 
			 testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),
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
			NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'IP Routing',
			//  Apttus_CQApprov__Approval_Status__c= 'Approved'
			//NokiaCPQ_Maintenance_Type__c ='Gold(Return for Exchange)',
			Is_List_Price_Only__c = true 
		 );
		insert testProposal1;
	  test.startTest(); 
	 //create product configuration
	 List<Apttus_Config2__ProductConfiguration__c> config = new List<Apttus_Config2__ProductConfiguration__c>();
		 ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = account3[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = testProposal1.Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal1.Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal',
			Apttus_CQApprov__Approval_Status__c = 'Approved',
			XAE_Flag__c = 'ADD_LineItem'

		);
		insert ProdConfig;
		  //	  config.add(ProdConfig);
		ProdConfig1 = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = account3[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = testProposal1.Id, 
			Apttus_Config2__AncestorId__c= ProdConfig.id,
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal1.Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal',
			Apttus_CQApprov__Approval_Status__c = 'Approved',
			XAE_Flag__c = 'ADD_LineItem'

		);
		config.add(ProdConfig1);
		insert config;
		
	   
		
	 //}
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
insert	LineItem1;   
		CPQ_Site_Phase_and_Quantity__c siteph = new CPQ_Site_Phase_and_Quantity__c();
		siteph.Line_Item__c = LineItem1.id;
		siteph.NCPQ_Phase__c = phase.id;
		siteph.NCPQ_Quantity__c = 5;
		siteph.NCPQ_Site__c = site.id;
	 //   siteph.NCPQ_SiteUsesPhases__c= true;
		insert siteph;
		
		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=config[0].Id,
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
		insert LineItem2;
	   // allLineItems.add(LineItem2);
		
	   CPQ_Site_Phase_and_Quantity__c siteph1 = new CPQ_Site_Phase_and_Quantity__c();
		siteph1.Line_Item__c = LineItem2.id;
		siteph1.NCPQ_Phase__c = phase.id;
		siteph1.NCPQ_Quantity__c = 5;
		siteph1.NCPQ_Site__c = site.id;
   //	siteph1.NCPQ_SiteUsesPhases__c= true;
		
	//  lisiteph.add(siteph1);
		
		insert siteph1;
	   
	   
	  //  allLineItems.add(LineItem3);
	   // insert allLineItems;
		
		List<CPQ_Site_Phase_and_Quantity__c> lisiteph = new List<CPQ_Site_Phase_and_Quantity__c>();
		
		
		lisiteph.add(siteph);
		
		
		
		System.debug('debug here for allLineItems' +allLineItems);
		//Create summary Group
		//
	 
		
		ProductConfigTriggerHandler.cloneChildItems(config);
		
		test.stopTest();
	}}
  static testMethod void ProductConfigTriggerHandlerTestmethod21() {
  List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){
	  //  User sysAdminUser = TestDataFactory.createSystemAdminUser();  
Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(); 
 Apttus_Config2__ProductConfiguration__c oldProdConfig = new Apttus_Config2__ProductConfiguration__c(); 
product2 prod = new product2();  
Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c();
Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c();
Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c();

	
		 List<Account> accounts;
		 accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		  insert accounts;
		  string partnerType = 'Distributor';
		  string partnerProgram = 'Global Alliance';
		  List<Account> accounts1 = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		  accounts1[0].Acc_No__c = 'Testing1';
		  accounts1[0].Partner_Program__c = partnerProgram;
		  accounts1[0].Partner_Type__c = partnerType;
		  accounts1[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		  accounts1[0].Active__c = true;
		  accounts1[0].NokiaCPQ_Renewal__c = true;
		  accounts1[0].ParentId = accounts[0].Id;
		  insert accounts1;

		  //Create Opportunity
		  list<opportunity> opportunities = new list<opportunity>();
		  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		  opportunities.get(0).Lead_BG__c = 'MN';
		  opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		  opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		  opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		  opportunities.get(0).Account_Role__c = 'GPP Distributor Partner';
		  opportunities.get(0).StageName ='Create Offer (Bid)';
		  opportunities.get(0).Phase_Status__c = 'Offer in Progress';
		   opportunities.get(0).Business_Type__c = Nokia_Opportunity_Type_For_Test;
		  insert opportunities.get(0);
	 
	/*create product*/
	 prod = new product2();
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
		 ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		PriceList_Type__c='CPQ',
		Apttus_Config2__Type__c='Standard',
		Apttus_Config2__Active__c = True
		);
	
		insert ApttusTestPriceList;
		/*create pricelist Item*/
	 pLI5 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		insert pLI5;
		
		 /***Accreditation Creation starts***/
		  List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		  accredList[0].Portfolio__c='IP Routing';
		  accredList[0].Pricing_Cluster__c='NAM';
		  accredList[0].Pricing_Level_Override__c = 'Advanced';
		  accredList[1].Portfolio__c='IP Routing';
		  accredList[1].Pricing_Cluster__c='NAM';
		  insert accredList;
		  /***Accreditation ends ***/
	
			 testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
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
			NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'IP Routing',
			CPQ_PortfolioClusterSF1__c = 'FBA_N1',
			CPQ_PortfolioClusterSF2__c = 'FBA_N1',
			CPQ_PortfolioClusterSF3__c = 'POL_N1',
			CPQ_PortfolioClusterSF4__c = 'FBA_N1',
			//  Apttus_CQApprov__Approval_Status__c= 'Approved'
			//NokiaCPQ_Maintenance_Type__c ='Gold(Return for Exchange)',
			Is_List_Price_Only__c = true 
		 );
		insert testProposal1;
		 
		List<Apttus_Config2__ProductConfiguration__c> liconfig = new List<Apttus_Config2__ProductConfiguration__c>();
	 //create product configuration
		 ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = testProposal1.Id, 
			Apttus_Config2__Status__c = 'Saved', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal1.Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal',
			Apttus_CQApprov__Approval_Status__c = 'Approval Required',
			NokiaCPQ_Quote_Opportunity_Changed__c= true,
			XAE_Flag__c = 'ADD_LineItem'

		);
		liconfig.add(ProdConfig);
		insert liconfig;
		
		List<Apttus_Config2__ProductConfiguration__c> lioldconfig = new List<Apttus_Config2__ProductConfiguration__c>();
	 //create product configuration
		 oldProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = testProposal1.Id, 
			Apttus_Config2__Status__c = 'Saved', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal1.Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal',
			Apttus_CQApprov__Approval_Status__c = 'Approval Required',
			NokiaCPQ_Quote_Opportunity_Changed__c= true,
			XAE_Flag__c = 'ADD_LineItem'

		);
		lioldconfig.add(oldProdConfig);
		insert lioldconfig;
		
	   
		TempConfigItem__c gppTemObject = New TempConfigItem__c();
			gppTemObject.ConfigItem_Product_Configuration__c = liconfig[0].Id;
			gppTemObject.ProductID__c = prod.Id;
			gppTemObject.Quantity__c = 1;
			
		insert gppTemObject;
	 //}
		 //Create Line Items
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=liconfig[0].Id,
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
		
		// allLineItems.add(LineItem8);
		insert allLineItems;
		System.debug('debug here for allLineItems' +allLineItems);
		//Create summary Group
		//
		ProductConfigTriggerHandler.afterUpdate(liconfig,lioldconfig );
		ProductConfigTriggerHelper.updateClusterSearchFieldsFromQuote(new list<Apttus_Config2__ProductConfiguration__c>{ProdConfig});
	//  ProductConfigTriggerHandler.afterUpdate_QTC(liconfig,lioldconfig );
		test.stopTest();
	}
	  
	  
}   
	
	 static testMethod void ProductConfigTriggerHandlerTestmethod222() {
	  //  User sysAdminUser = TestDataFactory.createSystemAdminUser();  
Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(); 
 Apttus_Config2__ProductConfiguration__c oldProdConfig = new Apttus_Config2__ProductConfiguration__c(); 
product2 prod = new product2();  
Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c();
Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c();
	 // System.runAs(sysAdminUser){
		List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	 
		insert account3;
		
		List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
  
		insert opportunities1;
	 
	/*create product*/
	 prod = new product2();
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
		 ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		PriceList_Type__c='CPQ',
		Apttus_Config2__Type__c='Standard',
		Apttus_Config2__Active__c = True
		);
	
		insert ApttusTestPriceList;
		/*create pricelist Item*/
	 pLI5 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		insert pLI5;
	 
			 Apttus_Proposal__Proposal__c testProposal1 = TestDataSetup.creatProposal(opportunities1[0], account3[0], ApttusTestPriceList);
	
	testProposal1.NokiaCPQ_FN_Maintenance_Type__c='';
	testProposal1.NokiaCPQ_SRS_Level__c='';
	testProposal1.NokiaCPQ_No_of_Years__c='';
	testProposal1.NokiaCPQ_Existing_IONMaint_Contract__c='';
	testProposal1.NokiaCPQ_Needs_Reprice__c = false;
	testProposal1.Reprice_In_Progress__c = false;
	testProposal1.NokiaCPQ_Existing_FN_Maint_Contract__c='';
	testProposal1.NokiaCPQ_ION_Maintenance_Type__c='';
	//testProposal1.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	testProposal1.NokiaCPQ_SSP_Level__c='';
	testProposal1.NokiaCPQ_Portfolio__c = 'QTC';
	testProposal1.CPQ_PortfolioClusterSF1__c = 'FBA_N1';
	testProposal1.CPQ_PortfolioClusterSF2__c = 'FBA_N1';
	testProposal1.CPQ_PortfolioClusterSF3__c = 'FBA_N1';
	testProposal1.CPQ_PortfolioClusterSF4__c = 'FBA_N1';
	testProposal1.Is_List_Price_Only__c = true;
	insert testProposal1;
	
	
		List<Apttus_Config2__ProductConfiguration__c> liconfig = new List<Apttus_Config2__ProductConfiguration__c>();
	 //create product configuration
		 ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = account3[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = testProposal1.Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal1.Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal',
			Apttus_CQApprov__Approval_Status__c = 'Approved',
			NokiaCPQ_Quote_Opportunity_Changed__c= true,
			XAE_Flag__c = 'ADD_LineItem'

		);
		liconfig.add(ProdConfig);
		insert liconfig;
		
		List<Apttus_Config2__ProductConfiguration__c> lioldconfig = new List<Apttus_Config2__ProductConfiguration__c>();
	 //create product configuration
		 oldProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = account3[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = testProposal1.Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal1.Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal',
			Apttus_CQApprov__Approval_Status__c = 'Approved',
			NokiaCPQ_Quote_Opportunity_Changed__c= true,
			XAE_Flag__c = 'ADD_LineItem'

		);
		lioldconfig.add(oldProdConfig);
		insert lioldconfig;
		
	   
		TempConfigItem__c gppTemObject = New TempConfigItem__c();
			gppTemObject.ConfigItem_Product_Configuration__c = liconfig[0].Id;
			gppTemObject.ProductID__c = prod.Id;
			gppTemObject.Quantity__c = 1;
			
		insert gppTemObject;
	 //}
		 //Create Line Items
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=liconfig[0].Id,
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
		
		// allLineItems.add(LineItem8);
		insert allLineItems;
		System.debug('debug here for allLineItems' +allLineItems);
		//Create summary Group
		//
		ProductConfigTriggerHandler.afterUpdate_QTC(liconfig,lioldconfig );
		ProductConfigTriggerHelper.clearSiteOnConfiguration(new set<Id>{ProdConfig.Id});
		ProductConfigTriggerHelper.calculatePrice(10.50);
		ProductConfigTriggerHelper.gPPPricingToolLogic(new list<Apttus_Config2__ProductConfiguration__c>{ProdConfig});
		ProductConfigTriggerHelper.gPPPricingToolConstRule(ProdConfig.Id, 'Indirect CPQ', false);
		
	
		test.stopTest();
		
	}
	
}