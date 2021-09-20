/* Created this test class to optimize  and replace Nokia_PricingCallBack_Test*/
@isTest
private class Nokia_PricingCallBackTest3
{

  static testMethod void directNSW() {   
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	  insert custSetting;
	
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;   
	
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	
	System.runAs(users[0]) {   
	  
	  List<Account> accountsNew = new List<Account>();
	  Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	  accLegalEntity.AccountNumber='101234567';
	  accLegalEntity.Acc_No__c = '101234567';
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  accountsNew.add(accLegalEntity);
	  
	  Account account = TestDataFactory.createAccount(1)[0];
	  account.AccountNumber='3011234567';
	  account.Acc_No__c = '3011234567';
	  account.Active__c= true;
	  account.CountryCode__c='IN';
	  accountsNew.add(account);
	  
	  insert accountsNew;
	  
	  List<Account> accounts=new List<Account>();
	  accounts.add(account);
	  
	  //Create Opportunity
	  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
	  opportunities.get(0).Lead_BG__c = 'MN';
	  opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities.get(0).Account_Role__c = 'Alliance Partner';
	  insert opportunities.get(0);
	  
	  
	  //Create Product
	  List<Product2> prods = new List<Product2>();
	  
	  Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prods.add(prod1);
	  
	  Product2 prod2 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod2.Name = 'Option1Care';
	  prod2.ProductCode = '784800098209';
	  prod2.Business_Group__c = 'MN';
	  prods.add(prod2);
	  
	  Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod3.Name = 'Option2SRS'; 
	  prod3.Business_Group__c = 'MN';
	  prod3.ProductCode = 'SRS';
	  prod3.NokiaCPQ_Product_Discount_Category__c = 'NFM-P';
	  prods.add(prod3);
	  
	  Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod4.Name = 'Option3';
	  prod4.Business_Group__c = 'MN';
	  prods.add(prod4);
	  
	  Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod5.ProductCode = '12356';
	  prod5.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod5.NokiaCPQ_Item_Type__c='Hardware';
	  prod5.NokiaCPQ_Classification2__c='Base';
	  prod5.NokiaCPQ_License_Usage__c='Commercial Licence';
	   // prod5.NokiaCPQ_Product_Discount_Category__c = 'NSW';
	  prod5.NokiaCPQ_Product_Discount_Category__c = 'MN';
	  prods.add(prod5);
	  
	  Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod6.Name = 'Option2Care'; 
	  prod6.Business_Group__c = 'MN';
	  prod6.ProductCode = '784800098210'; 
	  prods.add(prod6);
	  
	  insert prods;
	  system.debug('prods>>>>>:'+prods);
	  
	  //Create PriceList
	  
	  Test.startTest();
	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True
	  );
	  insert ApttusTestPriceList;
	  
	  //create price list items
	  List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	  Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI1.Apttus_Config2__ProductId__c = prod1.Id;
	  plistItems.add(pLI1);
	  
	  Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI2.Apttus_Config2__ProductId__c = prod2.Id;
	  pLI2.Apttus_Config2__PriceIncludedInBundle__c = true;
	  pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	  plistItems.add(pLI2);
	  
	  Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	  pLI3.Apttus_Config2__ChargeType__c = 'SRS';
	  pLI3.Apttus_Config2__PriceIncludedInBundle__c = true;
	  pLI3.Apttus_Config2__ContractPrice__c = 100;
	  plistItems.add(pLI3);
	  
	  Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI4.Apttus_Config2__ProductId__c = prod4.Id;
	  plistItems.add(pLI4);
	  
	  Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];	  
	  pLI5.Apttus_Config2__ProductId__c = prod5.Id;
	  plistItems.add(pLI5);
	  
	  Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI6.Apttus_Config2__ProductId__c = prod6.Id;
	  pLI6.Apttus_Config2__PriceIncludedInBundle__c = true;
	  pLI6.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	  plistItems.add(pLI6);
	  
	  insert plistItems;
	  
	  Product_Discount__c disc = new Product_Discount__c ();
	  disc.Discount__c = 8.00;
	  disc.Market__c = account.Market__c;
	  disc.Product_Discount_Category__c = 'NFM-P';
	  insert disc;
	  
	  //create proposal
	  
	  Apttus_Proposal__Proposal__c testProposal = TestDataSetup.creatProposal(opportunities[0], accounts[0], ApttusTestPriceList);
	  testProposal.Sold_To_Party__c = accLegalEntity.id;
	  testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	  insert testProposal;
	  
	  //system.debug('testProposal:'+testProposal);
	  
	  //create product configuration
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], ApttusTestPriceList, testProposal);
	  insert ProdConfig;
	  
	  //system.debug('ProdConfig>>>>>:'+ProdConfig);
		  
	  //Create Line Items
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();	  
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(accounts[0], ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem1.Apttus_Config2__PriceListItemId__c = pLI1.id;
	  LineItem1.Apttus_Config2__ItemSequence__c = 1;
	  LineItem1.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem1.Source__c='';
	  LineItem1.Item_Type_From_CAT__c='PS';
	  LineItem1.Apttus_Config2__ParentBundleNumber__c=null;
	  LineItem1.NokiaCPQ_Is_Direct_Option__c=true;
	  LineItem1.Apttus_Config2__NetAdjustmentPercent__c=0;
	  LineItem1.Item_Type_From_CAT__c='PS';
	  LineItem1.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem1.NokiaCPQ_Account_Region__c='RG_NAM';
	  allLineItems.add(LineItem1);
	  
	  Apttus_Config2__LineItem__c lineItem2 = TestDataSetup.creatConfigLineItem(accounts[0], ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem2.Apttus_Config2__ItemSequence__c = 2;
	  lineItem2.Apttus_Config2__ListPrice__c = 200;
	  lineItem2.Apttus_Config2__BasePrice__c=200;
	  lineItem2.Apttus_Config2__BasePriceOverride__c=1185.02;
	  lineItem2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	  lineItem2.Apttus_Config2__OptionId__c = prod2.Id;
	  lineItem2.NokiaCPQ_Account_Region__c='RG_LAM';
	  allLineItems.add(lineItem2);
	  
	  Apttus_Config2__LineItem__c lineItem3 = TestDataSetup.creatConfigLineItem(accounts[0], ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem3.Apttus_Config2__ItemSequence__c = 3;	  
	  lineItem3.Apttus_Config2__ChargeType__c = 'SRS'; 
	  lineItem3.Apttus_Config2__BasePrice__c=300;
	  lineItem3.Apttus_Config2__ListPrice__c = 300;
	  lineItem3.Apttus_Config2__OptionId__c = prod3.Id;
	  lineItem3.Apttus_Config2__PriceListItemId__c = pLI3.id;
	  lineItem3.NokiaCPQ_Account_Region__c='RG_MEA';
	  allLineItems.add(lineItem3);
	  
	  Apttus_Config2__LineItem__c lineItem4 = TestDataSetup.creatConfigLineItem(accounts[0], ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem4.Apttus_Config2__ItemSequence__c = 4;
	  lineItem4.Apttus_Config2__OptionId__c = prod4.Id;
	  lineItem4.Apttus_Config2__PriceListItemId__c = pLI4.id; 
	  lineItem4.Apttus_Config2__ListPrice__c = 120;
	  lineItem4.Apttus_Config2__BasePrice__c=120;   
	  lineItem4.Apttus_Config2__PriceIncludedInBundle__c = true;
	  lineItem4.NokiaCPQ_Account_Region__c= 'RG_ASIA';
	  allLineItems.add(lineItem4);
	  
	  Apttus_Config2__LineItem__c lineItem5 = TestDataSetup.creatConfigLineItem(accounts[0], ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem5.Apttus_Config2__ItemSequence__c = 5;
	  lineItem5.Apttus_Config2__OptionId__c = prod5.Id;
	  lineItem5.Apttus_Config2__ListPrice__c = 120;
	  lineItem5.Apttus_Config2__BasePrice__c=120;
	  lineItem5.Apttus_Config2__PriceIncludedInBundle__c = false;
	  lineItem5.NokiaCPQ_Account_Region__c= 'RG_CHINA';
	  allLineItems.add(lineItem5);
	  
	  Apttus_Config2__LineItem__c lineItem6 = TestDataSetup.creatConfigLineItem(accounts[0], ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem6.Apttus_Config2__ItemSequence__c = 6;
	  lineItem6.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'; 
	  lineItem6.Apttus_Config2__OptionId__c = prod6.Id;
	  lineItem6.Apttus_Config2__PriceListItemId__c = pLI6.id;
	  lineItem6.NokiaCPQ_Account_Region__c  = 'RG_EUROPE';
	  allLineItems.add(lineItem6);
	  
	  insert allLineItems;
	  
	  system.debug('allLineItems>>>>>:'+allLineItems);
	  
	  //Test.startTest(); 
	  
	  Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
	  
	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  obj.finish();
	  
	  obj.getPortfolio(LineItem5);
	  Nokia_PricingCallBack.getProductDiscountCategory(LineItem5);
	  Nokia_PricingCallBack.getProductDiscountCategory(LineItem1);
	  obj.getMinimumSalesMargin(LineItem1); 
	  obj.getMinimumSalesMargin(LineItem2); 
	  obj.getMinimumSalesMargin(LineItem3); 
	  obj.getMinimumSalesMargin(LineItem4); 
	  obj.getMinimumSalesMargin(LineItem5); 
	  obj.getMinimumSalesMargin(LineItem6); 
	
	Test.stopTest();
	}   
  }
  //method for testDS_Equivalentprice
  static testMethod void Airscalewifisoftware() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	
	
	System.runAs(users[0]) {
	  
	  List<Account> accountsNew = new List<Account>();
	  Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	  accLegalEntity.AccountNumber='101234567';
	  accLegalEntity.Acc_No__c = '101234567';
	  accLegalEntity.GeoLevel1Id__c = 'RG_NAM';
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  accountsNew.add(accLegalEntity);
	  
	  Account account = TestDataFactory.createAccount(1)[0];
	  account.AccountNumber='3011234567';
	  account.Acc_No__c = '3011234567';
	   // account.GeoLevel1Id__c = 'RG_NAM';
	  account.Active__c= true;
	  account.CountryCode__c='IN';
	  accountsNew.add(account);
	  
	  insert accountsNew;
	  
	  List<Account> accounts=new List<Account>();
	  accounts.add(account);
	  
	  //Create Opportunity
	  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
	  opportunities.get(0).Lead_BG__c = 'MN';
	  opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities.get(0).Account_Role__c = 'Alliance Partner';
	  List<User> userList2 = new List<User>();
	  userList2 = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  System.runAs(userList2[0]){
		insert opportunities.get(0);
	  }
	  
	  /*** Product Creation starts ***/
	  List<Product2> prods = new List<Product2>();
	  
	  //Product#1
	  Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod1.Portfolio__c = 'Airscale Wifi';
	  prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod1.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod1);
	  
	  //Product#2
	  Product2 prod2 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod2.ProductCode = 'MT001'; 
	  prod2.Portfolio__c = 'IP Routing';
	  prod2.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod2);
	  
	  //Product#3
	  Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod3.Portfolio__c = 'Airscale Wifi';
	  prod3.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod3);
	  
	  //Product#4
	  Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod5.ProductCode = 'MT002';
	  prod5.Portfolio__c = 'IP Routing'; 
	  prods.add(prod5); 
	  
	  //Product#5
	  Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod6.ProductCode = '123Arcadia';
	  prod6.Portfolio__c = 'Airscale Wifi';
	  prod6.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod6.NokiaCPQ_Item_Type__c='Hardware';
	  prod6.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod6);   
	  
	  //Product#6
	  Product2 prod7 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod7.ProductCode = 'Arcadia2';
	  prod7.Portfolio__c = 'Airscale Wifi';
	  prod7.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod7.NokiaCPQ_Item_Type__c='Hardware';
	  prod7.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod7); 
	  
	  //Product#7
	  Product2 prod8 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod8.ProductCode = '12678';
	  prod8.Portfolio__c = 'Airscale Wifi';
	  prod8.NokiaCPQ_Item_Type__c='Hardware';
	  prod8.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod8);
	  insert prods;
	  /*** Product Creation Ends***/
	  //Create PriceList
	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
	  );
	  insert ApttusTestPriceList;
	  
	  //create price list items
	  List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	  Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI1.Apttus_Config2__ProductId__c = prod1.Id;
	  plistItems.add(pLI1);
	  
	  Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI2.Apttus_Config2__ProductId__c = prod2.Id;
	  pLI2.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	  plistItems.add(pLI2);
	  
	  Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	  pLI3.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI3.Apttus_Config2__ContractPrice__c = 100;
	  plistItems.add(pLI3);
	  
	  Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];	  
	  pLI5.Apttus_Config2__ProductId__c = prod5.Id;
	  pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	  plistItems.add(pLI5);
	  
	  Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI6.Apttus_Config2__ProductId__c = prod6.Id;
	  pLI6.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI6.Apttus_Config2__ContractPrice__c = 100;
	  plistItems.add(pLI6);
	  
	  Apttus_Config2__PriceListItem__c pLI7 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI7.Apttus_Config2__ProductId__c = prod7.Id;
	  pLI7.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI7.Apttus_Config2__ContractPrice__c = 100;
	  plistItems.add(pLI7);
	  
	  Apttus_Config2__PriceListItem__c pLI8 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI8.Apttus_Config2__ProductId__c = prod8.Id;
	  pLI8.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI8.Apttus_Config2__ContractPrice__c = 100;
	  plistItems.add(pLI8);
	  
	  insert plistItems;
	  
	  Product_Discount__c disc = new Product_Discount__c ();
	  disc.Discount__c = 8.00;
	  disc.Market__c = account.Market__c;
	  disc.Product_Discount_Category__c = 'NFM-P';
	  insert disc;
	  
	  //create proposal
	  Apttus_Proposal__Proposal__c testProposal = TestDataSetup.creatProposal(opportunities[0], accounts[0], ApttusTestPriceList);
	  testProposal.Sold_To_Party__c = accLegalEntity.id;
	  testProposal.Apttus_Proposal__Account__c=accLegalEntity.id; 
	  testProposal.NokiaCPQ_Existing_IONMaint_Contract__c= 'Yes';
	  testProposal.NokiaCPQ_Portfolio__c = 'Airscale Wifi';
	  testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	  testProposal.NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced';
	  insert testProposal;
	  
	  system.debug('testProposal:'+testProposal);
	  
	  //create product configuration
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(account, ApttusTestPriceList, testProposal);
	  insert ProdConfig;
	  
	  system.debug('ProdConfig>>>>:'+ProdConfig);
	  
	  //Create Line Items
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem1.Apttus_Config2__PriceListItemId__c = pLI1.id;
	  LineItem1.Apttus_Config2__ItemSequence__c = 1; 
	  LineItem1.Source__c='';
	  LineItem1.Apttus_Config2__BasePrice__c=100;
	  LineItem1.Apttus_Config2__ListPrice__c = 100;
	  LineItem1.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem1.Apttus_Config2__LineType__c = 'Product/Service';
	  allLineItems.add(LineItem1);
	  
	  Apttus_Config2__LineItem__c lineItem3 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem3.Apttus_Config2__ItemSequence__c = 2;	  
	  lineItem3.Apttus_Config2__ChargeType__c = 'SRS'; 
	  lineItem3.Apttus_Config2__OptionId__c = prod6.Id;
	  lineItem3.Apttus_Config2__PriceListItemId__c = pLI6.id;
	  lineItem3.NokiaCPQ_Product_Type__c = 'Access Point';
	  lineItem3.Apttus_Config2__ListPrice__c = 300;
	  lineItem3.Apttus_Config2__BasePrice__c=300;
	  lineItem3.Apttus_Config2__AdjustmentType__c = '% Discount';
	  lineItem3.Apttus_Config2__AdjustmentAmount__c = 10;
	  allLineItems.add(lineItem3);
	  
	  
	  Apttus_Config2__LineItem__c lineItem4 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem4.Apttus_Config2__ItemSequence__c = 3;
	  lineItem4.Apttus_Config2__ProductId__c = prod2.Id;
	  lineItem4.Apttus_Config2__PriceListItemId__c = pLI2.id;	 
	  lineItem4.Apttus_Config2__PriceIncludedInBundle__c = true;
	  lineItem4.Apttus_Config2__ListPrice__c = 120;
	  lineItem4.Apttus_Config2__BasePrice__c=120;
	  lineItem4.Apttus_Config2__BasePriceOverride__c=120;
	  lineItem4.Apttus_Config2__ChargeType__c= 'Year 1 Maintenance'; 
	  lineItem4.Apttus_Config2__LineType__c = 'Product/Service';
	  allLineItems.add(lineItem4);
	  
	  Apttus_Config2__LineItem__c lineItem5 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem5.Apttus_Config2__ItemSequence__c = 4;
	  lineItem5.Apttus_Config2__ProductId__c = prod5.Id;
	  lineItem5.Apttus_Config2__PriceListItemId__c = pLI5.id;
	  lineItem5.Apttus_Config2__PriceIncludedInBundle__c = true;
	  lineItem5.Apttus_Config2__ListPrice__c = 120;
	  lineItem5.Apttus_Config2__BasePrice__c=120;
	  lineItem5.Apttus_Config2__BasePriceOverride__c=120;
	  lineItem5.Apttus_Config2__LineType__c = 'Product/Service';
	  lineItem5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	  lineItem5.NokiaCPQ_Maint_Yr1_Extended_Price__c =  100;
	  allLineItems.add(lineItem5);
	  
	  Apttus_Config2__LineItem__c lineItem6 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem6.Apttus_Config2__ItemSequence__c = 2;
	  lineItem6.Apttus_Config2__OptionId__c = prod3.Id;
	  lineItem6.Apttus_Config2__PriceListItemId__c = pLI3.id;
	  lineItem6.Apttus_Config2__BasePriceOverride__c=120;
	  lineItem6.Apttus_Config2__ListPrice__c = 300;
	  lineItem6.Apttus_Config2__BasePrice__c=300;
	  lineItem6.Apttus_Config2__ProductId__c = prod6.Id;
	  lineItem6.Apttus_Config2__ParentBundleNumber__c = 2;
	  allLineItems.add(lineItem6);
	  
	  Apttus_Config2__LineItem__c LineItem7 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem7.Apttus_Config2__ItemSequence__c = 2;
	  LineItem7.Apttus_Config2__OptionId__c = prod7.Id;
	  LineItem7.Apttus_Config2__PriceListItemId__c = pLI7.id;
	  LineItem7.Apttus_Config2__ParentBundleNumber__c =1;
	  LineItem7.Apttus_Config2__BasePriceOverride__c=120;
	  LineItem7.Apttus_Config2__ListPrice__c = 300;
	  LineItem7.Apttus_Config2__BasePrice__c=300;
	  LineItem7.Apttus_Config2__AdjustmentType__c = 'Discount Amount';
	  LineItem7.Apttus_Config2__AdjustmentAmount__c = 100;
	  LineItem7.NokiaCPQ_Product_Type__c = 'Controller';
	  allLineItems.add(LineItem7);
	  
	  Apttus_Config2__LineItem__c LineItem8 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem8.Apttus_Config2__ItemSequence__c = 2;
	  LineItem8.Apttus_Config2__OptionId__c = prod8.Id;
	  LineItem8.Apttus_Config2__ParentBundleNumber__c = 3;
	  LineItem8.Apttus_Config2__BasePriceOverride__c=120;
	  LineItem8.Apttus_Config2__ListPrice__c = 300;
	  LineItem8.Apttus_Config2__BasePrice__c=300;
	  LineItem8.Apttus_Config2__ProductId__c = prod7.Id;
	  LineItem8.Apttus_Config2__PriceListItemId__c = pLI8.id;
	  LineItem8.NokiaCPQ_Product_Type__c = 'Third Party Wavespot';
	  allLineItems.add(LineItem8);
	  
	  insert allLineItems;
	  
	  Test.startTest(); 
	  Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
	  
	  obj.finish();
	  //obj.onPriceItemSet(pLI8,null);
	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  Nokia_PricingCallBack.calculateEquivalentPrice(allLineItems, 'Market India');
	  
	  testProposal.NokiaCPQ_No_of_Years__c = '1';
	  testProposal.NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced';
	  update testProposal;
	  
	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	}
	Test.stopTest();
  }
  static testMethod void QTCmethod() {
	List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	
	insert account3;
	
	List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
	opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	
	insert opportunities1;
	
	/*create product*/	  
	Product2 prod = TestDataSetup.createCPQTestproduct(1)[0];
	prod.Business_Group__c='MN';
	prod.Family= 'A&A-CEM';
	prod.Partner_Visible__c=True;
	prod.ProductCode='FC11011';
	prod.Apttus_Config2__Version__c=1;
	prod.Portfolio__c='Airscale Wifi';
	prod.Created_by_PMDI__c = False;
	prod.Pricing_Clusters__c='NAM';
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
	Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	pLI5.Apttus_Config2__ProductId__c = prod.Id;
	pLI5.Apttus_Config2__Cost__c = 10; //DHH
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
	testProposal1.Is_List_Price_Only__c = true;
	insert testProposal1;
	
	system.debug('testProposal1>>>>:'+testProposal1);
	
	//create product configuration
	Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(account3[0], ApttusTestPriceList, testProposal1);
	insert ProdConfig;
	
	system.debug('ProdConfig>>>>:'+ProdConfig);
	
	//Create Line Items
	list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	Apttus_Config2__LineItem__c lineItem3 = TestDataSetup.creatConfigLineItem(account3[0], ProdConfig, ApttusTestPriceList, prod,1)[0];
	lineItem3.Apttus_Config2__PriceListItemId__c = pLI5.id;
	lineItem3.Apttus_Config2__LineType__c = 'Product/Service';
	lineItem3.Apttus_Config2__ListPrice__c = 300;
	lineItem3.Apttus_Config2__BasePrice__c=300;
	lineItem3.Apttus_Config2__NetPrice__c=100;
	lineItem3.Advanced_pricing_done__c = true;//DHH
	lineItem3.NokiaCPQ_Unitary_Cost__c = 10;//DHH
	lineItem3.Apttus_Config2__PrimaryLineNumber__c = 1;
	lineItem3.Apttus_Config2__Quantity__c = 10;
	lineItem3.Apttus_Config2__AdjustmentType__c = '% Discount';
	lineItem3.Apttus_Config2__AdjustmentAmount__c = 10;
	allLineItems.add(lineItem3);

	insert allLineItems;
	
	Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
	
	obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	
	obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
	
	Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	test.stopTest(); 
  }
  //FOr Direct Enterprise
  static testMethod void directEnterprise() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	//Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	//Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	Custom_Constant_Field__c ccf = new Custom_Constant_Field__c();
	ccf.Name = 'Custom Constant Field';
	
	List<Opportunity> opportunities;
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	
	
	System.runAs(users[0]){  
	  
	  /************ Account Insertion  ***************/
	  
	  List<Account> accountsNew = new List<Account>();
	  Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	  accLegalEntity.AccountNumber='101234567';
	  accLegalEntity.Acc_No__c = '101234567';
	  accLegalEntity.GEOLevel1ID__c ='RG_NAM';
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  accountsNew.add(accLegalEntity);
	  //database.insert(accLegalEntity);
	  
	  Account account = TestDataFactory.createAccount(1)[0];
	  account.AccountNumber='3011234567';
	  account.Acc_No__c = '3011234567';
	  account.Active__c= true;
	  account.GEOLevel1ID__c ='RG_NAM';
	  accountsNew.add(account);
	  //database.insert(account);
	  
	  
	  insert accountsNew;
	  
	  List<Account> accounts=new List<Account>();
	  accounts.add(account);
	  
	  //Create Opportunity
	  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
	  opportunities.get(0).Lead_BG__c = 'MN';
	  opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities.get(0).Account_Role__c = 'Alliance Partner';
	  insert opportunities.get(0);
	  
	  
	  //Create Product
	  List<Product2> prods = new List<Product2>();
	  Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod1.Portfolio__c = 'IP Routing';
	  prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod1.NokiaCPQ_Classification2__c='Base';
	  prod1.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod1);
	  
	  //product#2
	  Product2 prod2 =  TestDataSetup.createCPQTestproduct(1)[0];
	  prod2.ProductCode = 'MT001';
	  prod2.Portfolio__c = 'IP Routing';
	  prod2.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prod2.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod2);
	  
	  //Product#3
	  Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod4.ProductCode = 'SSP002';
	   // prod4.Business_Group__c = 'NSW'; 
	  prod4.Business_Group__c = 'MN';
	  prod4.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod4); 
	  
	  //Product#4
	  Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod5.Name = 'Maintenance Year2+'; 
	  prod5.ProductCode = 'MT002'; 
	  //prod5.Business_Group__c = 'NSW';
	  prod5.Business_Group__c = 'MN'  ;	 
	  prod5.Portfolio__c = 'IP Routing';
	  prod5.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod5);
	  
	  //Product#5
	  Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod6.Name = 'Bundle';
	  prod6.Portfolio__c = 'IP Routing';
	  prod6.NokiaCPQ_Classification2__c='Base';
	  prod6.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod6);
	  insert prods;
	 
	Test.startTest();
	  /****Create PriceList *******/
	  List<Apttus_Config2__PriceList__c> priceLists = new List<Apttus_Config2__PriceList__c>();
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
	  );
	  priceLists.add(ApttusTestPriceList);
	  Apttus_Config2__PriceList__c ApttusTestPriceList2 = new Apttus_Config2__PriceList__c(
		Name = 'CLP', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'Direct'
	  );
	  priceLists.add(ApttusTestPriceList2);
	  insert priceLists;
	  /**** PriceList *******/
	  
	  /** create price list items ***/
	  List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	  //PLI#1
	  Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	  pLI1.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI1);
	  
	  //PLI#2
	  Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	  pLI2.Apttus_Config2__PriceIncludedInBundle__c = true;
	  pLI2.Apttus_Config2__ChargeType__c = 'Maintenance Year1';
	  pLI2.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI2);
	  
	  //PLI#3
	  Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI4.Apttus_Config2__ProductId__c = prod4.Id;
	  pLI4.Apttus_Config2__ChargeType__c = 'SSP';
	  pLI4.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI4);
	  
	  //PLI#4
	  Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	  pLI5.Apttus_Config2__ChargeType__c = 'Maintenance Year2+';
	  pLI5.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI5);
	  
	  //PLI#5
	  Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	  pLI6.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI6);
	  
	  //PLI#6
	  Apttus_Config2__PriceListItem__c pLI7 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];	  
	  pLI7.Apttus_Config2__ProductId__c = prod6.Id; 
	  pLI7.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI7);
	  
	  insert plistItems;
	  /** price list items end***/
	  
	  Product_Discount__c disc = new Product_Discount__c ();
	  disc.Discount__c = 8.00;
	  disc.Market__c = account.Market__c;
	  disc.Product_Discount_Category__c = 'NFM-P';
	  insert disc;
	  
	  /*** create proposal ***/
	  Apttus_Proposal__Proposal__c testProposal = TestDataSetup.creatProposal(opportunities[0], accounts[0], ApttusTestPriceList);
	  testProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
	  testProposal.NokiaCPQ_No_of_Years__c = '3';
	  testProposal.NokiaCPQ_Maintenance_Type__c='Gold (Return for Exchange)';
	  testProposal.Apttus_Proposal__Account__c=accLegalEntity.id;
	  testProposal.Sold_To_Party__c = accLegalEntity.id;
	  testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	  testProposal.NokiaCPQ_Existing_IONMaint_Contract__c='No';
	  insert testProposal; 
	  /*** create proposal End ***/   
	  system.debug('testProposal:'+testProposal);
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(account, ApttusTestPriceList, testProposal);
	  insert ProdConfig;
	  /*** create product configuration End ***/
	  
	  system.debug('ProdConfig>>>>:'+ProdConfig);
	  
	  /*** Line Items Creation starts **/
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	  
	  //Line Item#1
	  Apttus_Config2__LineItem__c lineItem3 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];	
	  lineItem3.Apttus_Config2__LineType__c = 'Product/Service';
	  lineItem3.Apttus_Config2__PriceListItemId__c = pLI1.id;
	  lineItem3.Apttus_Config2__PrimaryLineNumber__c = 1;
	  lineItem3.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem3);
	  
	  //Line Item#2
	  Apttus_Config2__LineItem__c LineItem4 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem4.Apttus_Config2__LineNumber__c = 2;
	  LineItem4.Apttus_Config2__ChargeType__c = 'Maintenance Year1';
	  LineItem4.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem4.Apttus_Config2__ProductId__c = prod2.Id;
	  LineItem4.Apttus_Config2__PriceListItemId__c = pLI2.id;
	  LineItem4.Apttus_Config2__PriceIncludedInBundle__c = true;
	  LineItem4.Apttus_Config2__PrimaryLineNumber__c = 1;
	  //LineItem4.Apttus_Config2__BasePriceOverride__c=120;
	  LineItem4.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem4);
	  
	  //Line Item#3
	  Apttus_Config2__LineItem__c LineItem6 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem6.Apttus_Config2__LineNumber__c = 3;
	  LineItem6.Apttus_Config2__ChargeType__c = 'SSP'; 
	  LineItem6.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem6.Apttus_Config2__ProductId__c = prod4.Id;
	  LineItem6.Apttus_Config2__PriceListItemId__c = pLI4.id;
	  LineItem6.Nokia_SSP_Base_Extended_Price__c = 90;
	  LineItem6.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem6);
	  
	  //Line Item#4
	  Apttus_Config2__LineItem__c LineItem7 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem7.Apttus_Config2__LineNumber__c = 4;	  
	  LineItem7.Apttus_Config2__ChargeType__c = 'Maintenance Year2+';
	  LineItem7.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem7.Apttus_Config2__ProductId__c = prod5.Id;
	  LineItem7.Apttus_Config2__PriceListItemId__c = pLI5.id;
	  LineItem7.Apttus_Config2__Frequency__c = 'Yearly';
	  LineItem7.NokiaCPQ_Maint_Yr2_Extended_Price__c = 100;
	  LineItem7.Nokia_SSP_Base_Extended_Price__c = 200;
	  LineItem7.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem7);
	  
	  //Line Item#5
	  Apttus_Config2__LineItem__c LineItem8 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem8.Apttus_Config2__ProductId__c = prod1.Id;
	  LineItem8.Apttus_Config2__OptionId__c = prod6.Id;
	  LineItem8.Apttus_Config2__PriceListItemId__c = pLI7.id;
	  LineItem8.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem8);
	  
	  insert allLineItems;
	  /*** Line Items Ends ***/
	  
	 // Test.startTest(); 
	  
	  CPQ_Maintenance_and_SSP_Rule__c rec1 = new CPQ_Maintenance_and_SSP_Rule__c();
	  rec1.Maintenance_Level__c = 'Nokia Brand of Service';
	  rec1.Maintenance_Type__c = 'Gold (Return for Exchange)';
	  rec1.Region__c = 'RG_NAM';
	  rec1.Service_Rate_Y1__c = 0.05;
	  rec1.Service_Rate_Y2__c = 0.05;
	  rec1.Unlimited_SSP_Discount__c = 0.03; 
	  rec1.Maintenance_Category__c = 'NSD-NRC IPR';
	  insert rec1;
	  list<NokiaCPQ_Maintenance_and_SSP_Rules__c> listMaintSSPRule =  [SELECT NokiaCPQ_withPMA__c, NokiaCPQ_Pricing_Cluster__c, NokiaCPQ_Product_Discount_Category__c, NokiaCPQ_Product_Discount_Category_per__c, NokiaCPQ_Unlimited_SSP_Discount__c, NokiaCPQ_Biennial_SSP_Discount__c, NokiaCPQ_Maintenance_Level__c, NokiaCPQ_Maintenance_Type__c, NokiaCPQ_Service_Rate_Y1__c, NokiaCPQ_Service_Rate_Y2__c FROM NokiaCPQ_Maintenance_and_SSP_Rules__c ]; 
	  Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
	  //obj.finish();
	  
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  //Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	Test.stopTest();
	}
	
  }
  static testMethod void directEnterprise1070() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	/*Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();*/
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	Custom_Constant_Field__c ccf = new Custom_Constant_Field__c();
	ccf.Name = 'Custom Constant Field';
	
	List<Opportunity> opportunities;
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	
	
	System.runAs(users[0]) {  
	  
	  /************ Account Insertion  ***************/
	  
	  List<Account> accountsNew = new List<Account>();
	  Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	  accLegalEntity.AccountNumber='101234567';
	  accLegalEntity.Acc_No__c = '101234567';
	  accLegalEntity.GEOLevel1ID__c ='RG_NAM';
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  accountsNew.add(accLegalEntity);
	  //database.insert(accLegalEntity);
	  
	  Account account = TestDataFactory.createAccount(1)[0];
	  account.AccountNumber='3011234567';
	  account.Acc_No__c = '3011234567';
	  account.GEOLevel1ID__c ='RG_NAM';
	  account.Active__c= true;
	  accountsNew.add(account);
	  //database.insert(account);
	  
	  insert accountsNew;
	  
	  List<Account> accounts=new List<Account>();
	  accounts.add(account);
	  
	  //Create Opportunity
	  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
	  //opportunities.get(0).Lead_BG__c = 'NSW';
	  opportunities.get(0).Lead_BG__c = 'MN';
	  opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities.get(0).Account_Role__c = 'Alliance Partner';
	  insert opportunities.get(0);
	  
	  
	  /*** Product Creation starts ***/
	  List<Product2> prods = new List<Product2>();
	  Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod1.Portfolio__c = 'IP Routing';
	  prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod1.NokiaCPQ_Classification2__c='Base';
	  prod1.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod1);
	  
	  //product#2
	  Product2 prod2 =  TestDataSetup.createCPQTestproduct(1)[0];
	  prod2.ProductCode = 'MT001';
	  prod2.Portfolio__c = 'IP Routing';
	  prod2.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prod2.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod2);
	  
	  //Product#3
	  Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod4.ProductCode = 'SSP002';
	  //prod4.Business_Group__c = 'NSW'; 
	  prod4.Business_Group__c = 'MN';
	  prod4.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod4); 
	  
	  //Product#4
	  Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod5.Name = 'Maintenance Year2+'; 
	  prod5.ProductCode = 'MT002'; 
	  //prod5.Business_Group__c = 'NSW'; 
	  prod5.Business_Group__c = 'MN';
	  prod5.Portfolio__c = 'IP Routing';
	  prod5.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod5);
	  
	  
	  //Product#5
	  Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod6.Name = 'Bundle';
	  prod6.Portfolio__c = 'IP Routing';
	  prod6.NokiaCPQ_Classification2__c='Base';
	  prod6.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod6);
	  insert prods;
	  /*** Product Creation ends ***/
	  
	  Test.startTest();
	  //Create PriceList
	  List<Apttus_Config2__PriceList__c> priceLists = new List<Apttus_Config2__PriceList__c>();
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
	  );
	  priceLists.add(ApttusTestPriceList);
	  Apttus_Config2__PriceList__c ApttusTestPriceList2 = new Apttus_Config2__PriceList__c(
		Name = 'CLP', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'Direct'
	  );
	  priceLists.add(ApttusTestPriceList2);
	  insert priceLists;
	  
	  /*** Price List Item Creation starts ***/
	  List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	  
	  //PLI#1
	  Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	  pLI1.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI1);
	  
	  //PLI#2
	  Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	  pLI2.Apttus_Config2__PriceIncludedInBundle__c = true;
	  pLI2.Apttus_Config2__ChargeType__c = 'Maintenance Year1';
	  pLI2.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI2);
	  
	  //PLI#3
	  Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI4.Apttus_Config2__ProductId__c = prod4.Id;
	  pLI4.Apttus_Config2__ChargeType__c = 'SSP';
	  pLI4.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI4);
	  
	  //PLI#4
	  Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	  pLI5.Apttus_Config2__ChargeType__c = 'Maintenance Year2+';
	  pLI5.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI5);
	  
	  //PLI#5
	  Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	  pLI6.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI6);
	  
	  //PLI#6
	  Apttus_Config2__PriceListItem__c pLI7 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];	  
	  pLI7.Apttus_Config2__ProductId__c = prod6.Id; 
	  pLI7.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI7);
	  
	  insert plistItems;	  
	  /*** Price List Item Creation ends ***/
	  
	  Product_Discount__c disc = new Product_Discount__c ();
	  disc.Discount__c = 8.00;
	  disc.Market__c = account.Market__c;
	  disc.Product_Discount_Category__c = 'NFM-P';
	  insert disc;
	  
	  /*** proposal creation starts ***/
	  Apttus_Proposal__Proposal__c testProposal = TestDataSetup.creatProposal(opportunities[0], accounts[0], ApttusTestPriceList);
	  testProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
	  testProposal.NokiaCPQ_No_of_Years__c = '3';
	  testProposal.NokiaCPQ_Maintenance_Type__c='Gold (Return for Exchange)';
	  testProposal.Apttus_Proposal__Account__c=accLegalEntity.id;
	  testProposal.Sold_To_Party__c = accLegalEntity.id;
	  testProposal.Apttus_Proposal__Account__c=accLegalEntity.id;
	  testProposal.Sold_To_Party__c = accLegalEntity.id;
	  //testProposal.NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	  testProposal.NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
	  testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true; 
	  insert testProposal;
	  /*** proposal creation Ends ***/
	  system.debug('testProposal:'+testProposal);
	  
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(account, ApttusTestPriceList, testProposal);
	  insert ProdConfig;
	  /*** create product configuration End ***/
	  
	  /*** Line Items Creation starts **/
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	  
	  //Line Item#1
	  Apttus_Config2__LineItem__c lineItem3 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];	
	  lineItem3.Apttus_Config2__LineType__c = 'Product/Service';
	  lineItem3.Apttus_Config2__PriceListItemId__c = pLI1.id;
	  lineItem3.Apttus_Config2__PrimaryLineNumber__c = 1;
	  lineItem3.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem3);
	  
	  //Line Item#2
	  Apttus_Config2__LineItem__c LineItem4 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem4.Apttus_Config2__LineNumber__c = 2;
	  LineItem4.Apttus_Config2__ChargeType__c = 'Maintenance Year1';
	  LineItem4.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem4.Apttus_Config2__ProductId__c = prod2.Id;
	  LineItem4.Apttus_Config2__PriceListItemId__c = pLI2.id;
	  LineItem4.Apttus_Config2__PriceIncludedInBundle__c = true;
	  LineItem4.Apttus_Config2__PrimaryLineNumber__c = 1;
	  //LineItem4.Apttus_Config2__BasePriceOverride__c=120;
	  LineItem4.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem4);
	  
	  //Line Item#3
	  Apttus_Config2__LineItem__c LineItem6 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem6.Apttus_Config2__LineNumber__c = 3;
	  LineItem6.Apttus_Config2__ChargeType__c = 'SSP'; 
	  LineItem6.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem6.Apttus_Config2__ProductId__c = prod4.Id;
	  LineItem6.Apttus_Config2__PriceListItemId__c = pLI4.id;
	  LineItem6.Nokia_SSP_Base_Extended_Price__c = 90;
	  LineItem6.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem6);
	  
	  //Line Item#4
	  Apttus_Config2__LineItem__c LineItem7 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem7.Apttus_Config2__LineNumber__c = 4;	  
	  LineItem7.Apttus_Config2__ChargeType__c = 'Maintenance Year2+';
	  LineItem7.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem7.Apttus_Config2__ProductId__c = prod5.Id;
	  LineItem7.Apttus_Config2__PriceListItemId__c = pLI5.id;
	  LineItem7.Apttus_Config2__Frequency__c = 'Yearly';
	  LineItem7.NokiaCPQ_Maint_Yr2_Extended_Price__c = 100;
	  LineItem7.Nokia_SSP_Base_Extended_Price__c = 200;
	  LineItem7.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem7);
	  
	  //Line Item#5
	  Apttus_Config2__LineItem__c LineItem8 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem8.Apttus_Config2__ProductId__c = prod1.Id;
	  LineItem8.Apttus_Config2__OptionId__c = prod6.Id;
	  LineItem8.Apttus_Config2__PriceListItemId__c = pLI7.id;
	  LineItem8.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem8);
	  
	  insert allLineItems;
	  /*** Line Items End ***/
	  //Test.startTest(); 
	  
	  CPQ_Maintenance_and_SSP_Rule__c rec1 = new CPQ_Maintenance_and_SSP_Rule__c();
	  rec1.Maintenance_Level__c = 'Nokia Brand of Service';
	  rec1.Maintenance_Type__c = 'Gold (Return for Exchange)';
	  rec1.Region__c = 'RG_NAM';
	  rec1.Service_Rate_Y1__c = 0.05;
	  rec1.Service_Rate_Y2__c = 0.05;
	  rec1.Unlimited_SSP_Discount__c = 0.03; 
	  rec1.Maintenance_Category__c = 'NSD-NRC IPR';
	  insert rec1;
	  list<NokiaCPQ_Maintenance_and_SSP_Rules__c> listMaintSSPRule =  [SELECT NokiaCPQ_withPMA__c, NokiaCPQ_Pricing_Cluster__c, NokiaCPQ_Product_Discount_Category__c, NokiaCPQ_Product_Discount_Category_per__c, NokiaCPQ_Unlimited_SSP_Discount__c, NokiaCPQ_Biennial_SSP_Discount__c, NokiaCPQ_Maintenance_Level__c, NokiaCPQ_Maintenance_Type__c, NokiaCPQ_Service_Rate_Y1__c, NokiaCPQ_Service_Rate_Y2__c FROM NokiaCPQ_Maintenance_and_SSP_Rules__c ]; 
	  Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
	  //obj.finish();
	  
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  //Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	Test.stopTest();
	}
	
  }
	  static testMethod void directEnterprise1070109() {
		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
		insert custSetting;

		Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
		Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
		Nokia_PricingCallBack npc = new Nokia_PricingCallBack();

		Custom_Constant_Field__c ccf = new Custom_Constant_Field__c();
		ccf.Name = 'Custom Constant Field';

		List<Opportunity> opportunities;
		List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
		users[0].Nokia_ID__c = '234597';
		insert users;


		System.runAs(users[0]) {   

		/************ Account Insertion  ***************/

		List<Account> accountsNew = new List<Account>();
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='101234567';
		accLegalEntity.Acc_No__c = '101234567';
		accLegalEntity.GEOLevel1ID__c ='RG_NAM';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accountsNew.add(accLegalEntity);
		//database.insert(accLegalEntity);

		Account account = TestDataFactory.createAccount(1)[0];
		account.AccountNumber='3011234567';
		account.Acc_No__c = '3011234567';
		account.GEOLevel1ID__c ='RG_NAM';
		accountsNew.add(account);
		//database.insert(account);

		insert accountsNew;

		List<Account> accounts=new List<Account>();
		accounts.add(account);

		//Create Opportunity
		opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);


		//Create Product
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Bundle',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
		); 
		prods.add(prod1);

		Product2 prod2 = new product2(
		Name = 'Maintenance Year1', 
		ProductCode = 'MT001', 
		//Business_Group__c = 'NSW', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR',
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base'); 
		prods.add(prod2);

		Product2 prod4 = new product2(
		Name = 'SSP', 
		ProductCode = 'SSP002', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		IsActive = true,
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR',
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		); 
		prods.add(prod4);   
		Product2 prod5 = new product2(
		Name = 'Maintenance Year2+', 
		ProductCode = 'MT002', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
		); 
		prods.add(prod5);

		Product2 prod6 = new product2(
		Name = 'Bundle', 
		ProductCode = '123', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
		); 
		prods.add(prod6);

		insert prods;
		
		Test.startTest();
		//Create PriceList
		List<Apttus_Config2__PriceList__c> priceLists = new List<Apttus_Config2__PriceList__c>();
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
		);
		priceLists.add(ApttusTestPriceList);
		Apttus_Config2__PriceList__c ApttusTestPriceList2 = new Apttus_Config2__PriceList__c(
		Name = 'CLP', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'Direct'
		);
		priceLists.add(ApttusTestPriceList2);
		insert priceLists;

		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod1.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI1);

		Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod2.Id, 
		Apttus_Config2__PriceIncludedInBundle__c = true,
		Apttus_Config2__ChargeType__c = 'Maintenance Year1',
		Apttus_Config2__Cost__c = 10
		);
		//insert pLI2;
		plistItems.add(pLI2);

		Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'SSP',
		Apttus_Config2__Cost__c = 10
		);
		//insert pLI1;
		plistItems.add(pLI4);

		Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance Year2+',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI5);

		Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI6);

		Apttus_Config2__PriceListItem__c pLI7 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList2.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI7);

		insert plistItems;

		Product_Discount__c disc = new Product_Discount__c ();
		disc.Discount__c = 8.00;
		disc.Market__c = account.Market__c;
		disc.Product_Discount_Category__c = 'NFM-P';
		insert disc;

		//create proposal
		Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '3',
		NokiaCPQ_Maintenance_Type__c='Gold (Return for Exchange)',
		RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
		Apttus_Proposal__Account__c=accLegalEntity.id,
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		Sold_To_Party__c = accLegalEntity.id,
		Is_List_Price_Only__c =false,
		NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes'
		);
		insert testProposal;


		system.debug('testProposal:'+testProposal);

		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
		Name = 'APTTUS Test Config', 
		Apttus_Config2__AccountId__c = account.Id, 
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
		Apttus_QPConfig__Proposald__c = testProposal.Id, 
		Apttus_Config2__Status__c = 'New', 
		Apttus_Config2__VersionNumber__c = 1, 
		Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
		Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

		//Create Line Items
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();

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
		Apttus_Config2__BasePriceOverride__c=123,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__BasePrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem3);

		Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 2,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Maintenance Year1', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod2.Id,
		Apttus_Config2__PriceListItemId__c = pLI2.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Apttus_Config2__PriceIncludedInBundle__c = true,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		is_Custom_Product__c=false,
		Apttus_Config2__BasePriceOverride__c=123,
		Apttus_Config2__AddedBy__c = 'added by code',
		Advanced_pricing_done__c = false			
		);
		//insert LineItem1;
		allLineItems.add(LineItem4);


		Apttus_Config2__LineItem__c LineItem6 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 3,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'SSP', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod4.Id,
		Apttus_Config2__PriceListItemId__c = pLI4.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 90,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem1;
		allLineItems.add(LineItem6);

		Apttus_Config2__LineItem__c LineItem7 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 4,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Maintenance Year2+', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod5.Id,
		Apttus_Config2__PriceListItemId__c = pLI5.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'Yearly',
		NokiaCPQ_Maint_Yr2_Extended_Price__c = 100,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 200,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem1;
		allLineItems.add(LineItem7);

		Apttus_Config2__LineItem__c LineItem8 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Option',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__OptionId__c = prod6.Id,
		Apttus_Config2__ParentBundleNumber__c = 1,
		Apttus_Config2__PriceListItemId__c = pLI7.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePriceOverride__c=123,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__BasePrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem8);

		insert allLineItems;

	   // Test.startTest(); 

		CPQ_Maintenance_and_SSP_Rule__c rec1 = new CPQ_Maintenance_and_SSP_Rule__c();
		rec1.Maintenance_Level__c = 'Nokia Brand of Service';
		rec1.Maintenance_Type__c = 'Gold (Return for Exchange)';
		rec1.Region__c = 'RG_NAM';
		rec1.Service_Rate_Y1__c = 0.05;
		rec1.Service_Rate_Y2__c = 0.05;
		rec1.Unlimited_SSP_Discount__c = 0.03; 
		rec1.Maintenance_Category__c = 'NSD-NRC IPR';
		insert rec1;
		list<NokiaCPQ_Maintenance_and_SSP_Rules__c> listMaintSSPRule =  [SELECT NokiaCPQ_withPMA__c, NokiaCPQ_Pricing_Cluster__c, NokiaCPQ_Product_Discount_Category__c, NokiaCPQ_Product_Discount_Category_per__c, NokiaCPQ_Unlimited_SSP_Discount__c, NokiaCPQ_Biennial_SSP_Discount__c, NokiaCPQ_Maintenance_Level__c, NokiaCPQ_Maintenance_Type__c, NokiaCPQ_Service_Rate_Y1__c, NokiaCPQ_Service_Rate_Y2__c FROM NokiaCPQ_Maintenance_and_SSP_Rules__c ]; 
		Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
			
		obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
		Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);

		obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
		//obj.finish();

		Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);

		//Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
		//}
		Test.stopTest();
	  }
	}
  
  static testMethod void DirectMethod1() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	
	
	System.runAs(users[0]) {
	  List<Account> accountsNew = new List<Account>();
	  Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	  accLegalEntity.AccountNumber='101234567';
	  accLegalEntity.Acc_No__c = '101234567';
	  accLegalEntity.GeoLevel1Id__c = 'RG_NAM';
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  accountsNew.add(accLegalEntity);
	  
	  Account account = TestDataFactory.createAccount(1)[0];
	  account.AccountNumber='3011234567';
	  account.Acc_No__c = '3011234567';
	  account.GeoLevel1Id__c = 'RG_NAM';
	  account.Active__c= true;
	  accountsNew.add(account);
	  
	  insert accountsNew;
	  
	  List<Account> accounts=new List<Account>();
	  accounts.add(account);
	  
	  //Create Opportunity
	  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
	  opportunities.get(0).Lead_BG__c = 'MN';
	  opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities.get(0).Account_Role__c = 'Alliance Partner';
	  insert opportunities.get(0);
	  
	  /*** Product Creation starts ***/
	  List<Product2> prods = new List<Product2>();
	  
	  //Product#1
	  Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod1.Portfolio__c = 'Airscale Wifi';
	  prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod1.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod1);
	  
	  //Product#2
	  Product2 prod2 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod2.ProductCode = 'MT001'; 
	  prod2.Portfolio__c = 'IP Routing';
	  prod2.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod2);
	  
	  //Product#3
	  Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod3.Portfolio__c = 'Airscale Wifi';
	  prod3.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod3);
	  
	  //Product#4
	  Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod5.ProductCode = 'MT002';
	  prod5.Portfolio__c = 'IP Routing'; 
	  prods.add(prod5); 
	  
	  //Product#5
	  Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod6.ProductCode = '123Arcadia';
	  prod6.Portfolio__c = 'Airscale Wifi';
	  prod6.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod6.NokiaCPQ_Item_Type__c='Hardware';
	  prod6.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod6);   
	  
	  //Product#6
	  Product2 prod7 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod7.ProductCode = 'Arcadia2';
	  prod7.Portfolio__c = 'Airscale Wifi';
	  prod7.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod7.NokiaCPQ_Item_Type__c='Hardware';
	  prod7.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod7); 
	  
	  //Product#7
	  Product2 prod8 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod8.ProductCode = '12678';
	  prod8.Portfolio__c = 'Airscale Wifi';
	  prod8.NokiaCPQ_Item_Type__c='Hardware';
	  prod8.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod8);
	  insert prods;
	  
	  /*** Product Creation ends ***/
	  Test.startTest();
	  /*** PriceList Creation starts ***/
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
	  );
	  insert ApttusTestPriceList;   
	  /*** PriceList Creation ends ***/
	  
	  
	  /*** PriceList Item Creation starts ***/
	  List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	  //PLI#1
	  Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	  plistItems.add(pLI1);
	  
	  //PLI#2
	  Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	  pLI2.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	  plistItems.add(pLI2);
	  
	  //PLI#3
	  Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	  pLI3.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI3.Apttus_Config2__ContractPrice__c = 100;
	  plistItems.add(pLI3);
	  
	  //PLI#4
	  Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	  pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	  pLI5.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI5);
	  
	  //PLI#5
	  Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	  pLI6.Apttus_Config2__Cost__c = 10;
	  pLI6.Apttus_Config2__ContractPrice__c = 100;
	  pLI6.Apttus_Config2__PriceIncludedInBundle__c = false;
	  plistItems.add(pLI6);
	  
	  //PLI#6
	  Apttus_Config2__PriceListItem__c pLI7 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];	  
	  pLI7.Apttus_Config2__ProductId__c = prod7.Id; 
	  pLI7.Apttus_Config2__Cost__c = 10;
	  pLI7.Apttus_Config2__ContractPrice__c = 100;
	  pLI7.Apttus_Config2__PriceIncludedInBundle__c = false;
	  plistItems.add(pLI7);
	  
	  //PLI#7
	  Apttus_Config2__PriceListItem__c pLI8 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI8.Apttus_Config2__ProductId__c = prod8.Id;
	  pLI8.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI8.Apttus_Config2__ContractPrice__c = 100;
	  plistItems.add(pLI8);
	  insert plistItems;
	  /*** PriceList Item ends ***/
	  
	  /*** proposal creation starts ***/	  
	  Apttus_Proposal__Proposal__c testProposal = TestDataSetup.creatProposal(opportunities[0], accounts[0], ApttusTestPriceList);
	  testProposal.Sold_To_Party__c = accLegalEntity.id;
	  testProposal.Apttus_Proposal__Account__c=accLegalEntity.id;
	  testProposal.NokiaCPQ_Portfolio__c = 'Airscale Wifi';
	  //testProposal.NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced';
	  testProposal.NokiaCPQ_No_of_Years__c = '4';
	  testProposal.NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced Emergency';
	  testProposal.NokiaCPQ_Existing_IONMaint_Contract__c='No';
	  testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	  insert testProposal;
	  /*** proposal creation Ends ***/
	  system.debug('testProposal:'+testProposal);
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(account, ApttusTestPriceList, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  /*** Line Item Starts***/
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	  
	  //Line Item#1
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem1.Apttus_Config2__PriceListItemId__c = pLI1.id;
	  LineItem1.Apttus_Config2__ItemSequence__c = 1;
	  LineItem1.Source__c='';
	  LineItem1.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem1.Apttus_Config2__LineType__c = 'Product/Service';
	  allLineItems.add(LineItem1);
	  
	  //Line Item#2
	  Apttus_Config2__LineItem__c lineItem3 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem3.Apttus_Config2__ItemSequence__c = 2;	  
	  lineItem3.Apttus_Config2__OptionId__c = prod6.Id;
	  lineItem3.Apttus_Config2__PriceListItemId__c = pLI6.id;
	  lineItem3.NokiaCPQ_Product_Type__c = 'Access Point';
	  lineItem3.Apttus_Config2__AdjustmentType__c = '% Discount';
	  lineItem3.Apttus_Config2__AdjustmentAmount__c = 10;
	  allLineItems.add(lineItem3);
	  
	  //Line Item#3
	  Apttus_Config2__LineItem__c lineItem4 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem4.Apttus_Config2__ItemSequence__c = 3;
	  lineItem4.Apttus_Config2__ProductId__c = prod2.Id;
	  lineItem4.Apttus_Config2__PriceListItemId__c = pLI2.id;	 
	  lineItem4.Apttus_Config2__PriceIncludedInBundle__c = true;
	  lineItem4.Apttus_Config2__ChargeType__c= 'Year 1 Maintenance'; 
	  lineItem4.Apttus_Config2__LineType__c = 'Product/Service';
	  allLineItems.add(lineItem4);
	  
	  //Line Item#4
	  Apttus_Config2__LineItem__c lineItem5 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem5.Apttus_Config2__ItemSequence__c = 4;
	  lineItem5.Apttus_Config2__ProductId__c = prod5.Id;
	  lineItem5.Apttus_Config2__PriceListItemId__c = pLI5.id;
	  lineItem5.Apttus_Config2__PriceIncludedInBundle__c = true;
	  lineItem5.Apttus_Config2__LineType__c = 'Product/Service';
	  lineItem5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	  lineItem5.NokiaCPQ_Maint_Yr1_Extended_Price__c =  100;
	  allLineItems.add(lineItem5);
	  
	  //Line Item#5	   
	  Apttus_Config2__LineItem__c lineItem6 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem6.Apttus_Config2__ItemSequence__c = 5;
	  lineItem6.Apttus_Config2__OptionId__c = prod3.Id;
	  lineItem6.Apttus_Config2__PriceListItemId__c = pLI3.id;
	  lineItem6.Apttus_Config2__ProductId__c = prod6.Id;
	  lineItem6.Apttus_Config2__ParentBundleNumber__c = 2;
	  allLineItems.add(lineItem6);
	  
	  //Line Item#6
	  Apttus_Config2__LineItem__c LineItem7 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem7.Apttus_Config2__ItemSequence__c = 2;
	  LineItem7.Apttus_Config2__OptionId__c = prod7.Id;
	  LineItem7.Apttus_Config2__ProductId__c = prod1.Id;
	  LineItem7.Apttus_Config2__PriceListItemId__c = pLI7.id;
	  LineItem7.Apttus_Config2__AdjustmentType__c = 'Discount Amount';
	  LineItem7.Apttus_Config2__AdjustmentAmount__c = 100;
	  LineItem7.NokiaCPQ_Product_Type__c = 'Controller';
	  allLineItems.add(LineItem7);
	  
	  //Line Item#7
	  Apttus_Config2__LineItem__c LineItem8 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem8.Apttus_Config2__ItemSequence__c = 2;
	  LineItem8.Apttus_Config2__OptionId__c = prod8.Id;
	  LineItem8.Apttus_Config2__ProductId__c = prod6.Id;
	  LineItem8.Apttus_Config2__PriceListItemId__c = pLI8.id;
	  LineItem8.NokiaCPQ_Product_Type__c = 'Third Party Wavespot';
	  allLineItems.add(LineItem8);
	  
	  insert allLineItems;
	  /*** Line Item Ends***/
	  //Test.startTest(); 
	  
	  Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
	  
	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.finish();
	  Nokia_PricingCallBack.calculateEquivalentPrice(allLineItems, 'Market India');
	  
	  testProposal.NokiaCPQ_No_of_Years__c = '1';
	  testProposal.NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced';
	  update testProposal;
	  
	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	 Test.stopTest();
	}   
  }
  static testMethod void AirscalewifisoftwareMethod() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	
	
	System.runAs(users[0]) {
	  
	  List<Account> accountsNew = new List<Account>();
	  Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	  accLegalEntity.AccountNumber='101234567';
	  accLegalEntity.Acc_No__c = '101234567';
	  accLegalEntity.GeoLevel1Id__c = 'RG_NAM';
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  accountsNew.add(accLegalEntity);
	  
	  Account account = TestDataFactory.createAccount(1)[0];
	  account.AccountNumber='3011234567';
	  account.Acc_No__c = '3011234567';
	  account.GeoLevel1Id__c = 'RG_NAM';
	  account.Active__c= true;
	  accountsNew.add(account);
	  
	  insert accountsNew;
	  
	  
	  List<Account> accounts=new List<Account>();
	  accounts.add(account);
	  
	  //Create Opportunity
	  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
	  //opportunities.get(0).Lead_BG__c = 'NSW';
	  opportunities.get(0).Lead_BG__c = 'MN';
	  opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities.get(0).Account_Role__c = 'Alliance Partner';
	  insert opportunities.get(0);
	  
	  /*** Product Creation starts ***/
	  List<Product2> prods = new List<Product2>();
	  
	  //Product#1
	  Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod1.Portfolio__c = 'Airscale Wifi';
	  prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod1.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod1);
	  
	  //Product#2
	  Product2 prod7 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod7.ProductCode = 'Arcadia2';
	  prod7.Portfolio__c = 'Airscale Wifi';
	  prod7.NokiaCPQ_Item_Type__c='Hardware';
	  prod7.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod7); 
	  
	  insert prods;
	  /*** Product Creation starts ***/
	  
	  Test.startTest();
	  /*** PriceList Creation starts ***/
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True, 
		PriceList_Type__c = 'CPQ');
	  insert ApttusTestPriceList;
	  /*** PriceList Creation ends ***/
	  
	  /*** PriceList Item Creation starts ***/
	  List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	  //PLI#1
	  Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	  plistItems.add(pLI1);
	  
	  //PLI#6
	  Apttus_Config2__PriceListItem__c pLI7 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];	  
	  pLI7.Apttus_Config2__ProductId__c = prod7.Id; 
	  pLI7.Apttus_Config2__ContractPrice__c = 100;
	  pLI7.Apttus_Config2__PriceIncludedInBundle__c = false;
	  plistItems.add(pLI7);
	  insert plistItems;
	  /*** PriceList Item Creation ends ***/
	  
	  Product_Discount__c disc = new Product_Discount__c ();
	  disc.Discount__c = 8.00;
	  disc.Market__c = account.Market__c;
	  disc.Product_Discount_Category__c = 'NFM-P';
	  insert disc;
	  
	  /*** proposal creation starts ***/	  
	  Apttus_Proposal__Proposal__c testProposal = TestDataSetup.creatProposal(opportunities[0], accounts[0], ApttusTestPriceList);
	  testProposal.Sold_To_Party__c = accLegalEntity.id;
	  testProposal.NokiaCPQ_Existing_IONMaint_Contract__c='No';
	  testProposal.Apttus_Proposal__Account__c=accLegalEntity.id;
	  testProposal.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.AIRSCALE_WIFI_STRING;
	  testProposal.NokiaCPQ_Maintenance_Type__c= 'MN GS TSS Enhanced Emergency';
	  testProposal.NokiaCPQ_No_of_Years__c = '2';
	  testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	  insert testProposal;
	  /*** proposal creation Ends ***/
	  system.debug('testProposal:'+testProposal);
	  
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(account, ApttusTestPriceList, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  
	  /*** Line Item Starts***/
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  
	  //Line Item#1
	  LineItem1.Apttus_Config2__PriceListItemId__c = pLI1.id;
	  LineItem1.Apttus_Config2__ItemSequence__c = 1;
	  LineItem1.Source__c='';
	  LineItem1.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem1.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem1.NokiaCPQ_Product_Type__c='Controller';	
	  allLineItems.add(LineItem1);
	  
	  //Line Item#2
	  Apttus_Config2__LineItem__c lineItem3 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem3.Apttus_Config2__ItemSequence__c = 2;	  
	  lineItem3.Apttus_Config2__OptionId__c = prod7.Id;
	  lineItem3.Apttus_Config2__PriceListItemId__c = pLI7.id;
	  lineItem3.Apttus_Config2__ProductId__c = prod1.Id;
	  lineItem3.NokiaCPQ_Product_Type__c = 'Access Point';
	  lineItem3.Apttus_Config2__AdjustmentType__c = '% Discount';
	  lineItem3.Apttus_Config2__AdjustmentAmount__c = 10;
	  allLineItems.add(lineItem3);
	  
	  insert allLineItems;
	  /*** Line Item Ends***/
	  
	  // Test.startTest(); 
	  
	  Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
	  
	  
	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  obj.finish();
	  
	  Nokia_PricingCallBack.calculateEquivalentPrice(allLineItems, 'Market India');
	  
	  //Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  //Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  Test.stopTest();
	}	
  }
  static testMethod void directEnterpriseMethod() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	//Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	//Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	Custom_Constant_Field__c ccf = new Custom_Constant_Field__c();
	ccf.Name = 'Custom Constant Field';
	
	List<Opportunity> opportunities;
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	
	
	System.runAs(users[0]) {   
	  
	  /************ Account Insertion  ***************/
	  List<Account> accountsNew = new List<Account>();
	  Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	  accLegalEntity.AccountNumber='101234567';
	  accLegalEntity.Acc_No__c = '101234567';
	  accLegalEntity.GEOLevel1ID__c ='RG_NAM';
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  accountsNew.add(accLegalEntity);
	  //database.insert(accLegalEntity);
	  
	  Account account = TestDataFactory.createAccount(1)[0];
	  account.AccountNumber='3011234567';
	  account.Acc_No__c = '3011234567';
	  account.GEOLevel1ID__c ='RG_NAM';
	  account.Active__c= true;
	  accountsNew.add(account);
	  //database.insert(account);
	  
	  insert accountsNew;
	  
	  List<Account> accounts=new List<Account>();
	  accounts.add(account);
	  
	  //Create Opportunity
	  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
	  opportunities.get(0).Lead_BG__c = 'MN';
	  opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities.get(0).Account_Role__c = 'Alliance Partner';
	  insert opportunities.get(0);
	  
	  /*** Product Creation starts ***/
	  List<Product2> prods = new List<Product2>();
	  Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod1.Portfolio__c = 'IP Routing';
	  prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod1.NokiaCPQ_Classification2__c='Base';
	  prod1.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod1);
	  
	  //product#2
	  Product2 prod2 =  TestDataSetup.createCPQTestproduct(1)[0];
	  prod2.ProductCode = 'MT001';
	  prod2.Portfolio__c = 'IP Routing';
	  prod2.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prod2.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod2);
	  
	  //Product#3
	  Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod3.ProductCode = 'SSP002';
	  prod3.Business_Group__c = 'MN';
	  //prod3.Business_Group__c = 'NSW'; 
	  prod3.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod3); 
	  
	  //Product#4
	  Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod4.Name = 'Maintenance Year2+'; 
	  prod4.ProductCode = 'MT002'; 
	  //prod4.Business_Group__c = 'NSW'; 
	  prod4.Business_Group__c = 'MN';
	  prod4.Portfolio__c = 'IP Routing';
	  prod4.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod4);
	  
	  //Product#5
	  Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod5.Name = 'SRS'; 
	  prod5.ProductCode = 'SRS002'; 
	  //prod5.Business_Group__c = 'NSW';
	  prod5.Business_Group__c = 'MN';	 
	  prod5.Portfolio__c = 'IP Routing';
	  prod5.NokiaCPQ_Classification2__c='Base';
	  prod5.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod5);
	  insert prods; 
	  System.debug('prods>>> '+prods);
	  /*** Product Creation ends ***/   
	  
	  Test.startTest(); 
	  /*** PriceList Creation starts ***/
	  List<Apttus_Config2__PriceList__c> priceLists = new List<Apttus_Config2__PriceList__c>();
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
	  );
	  priceLists.add(ApttusTestPriceList);
	  Apttus_Config2__PriceList__c ApttusTestPriceList2 = new Apttus_Config2__PriceList__c(
		Name = 'CLP', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'Direct'
	  );
	  priceLists.add(ApttusTestPriceList2);
	  insert priceLists;
	  /*** PriceList Creation ends ***/
	  
	  /*** PriceList Item Creation starts ***/
	  List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	  //PLI#1
	  Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	  pLI1.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI1);
	  
	  //PLI#2
	  Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	  pLI2.Apttus_Config2__PriceIncludedInBundle__c = true;
	  pLI2.Apttus_Config2__ChargeType__c = 'Maintenance Year1';
	  pLI2.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI2);
	  
	  //PLI#3
	  Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	  pLI3.Apttus_Config2__ChargeType__c = 'SSP';
	  pLI3.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI3);
	  
	  //PLI#4
	  Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI4.Apttus_Config2__ProductId__c = prod4.Id; 
	  pLI4.Apttus_Config2__ChargeType__c = 'Maintenance Year2+';
	  pLI4.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI4);
	  
	  //PLI#5
	  Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	  pLI5.Apttus_Config2__ChargeType__c = 'SRS';
	  pLI5.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI5);
	  insert plistItems;
	  
	  Product_Discount__c disc = new Product_Discount__c();
	  disc.Discount__c = 8.00;
	  disc.Market__c = account.Market__c;
	  disc.Product_Discount_Category__c = 'NFM-P';
	  insert disc;
	  /*** PriceList Item Creation Ends ***/
	  
	  /*** proposal creation starts ***/
	  Apttus_Proposal__Proposal__c testProposal = TestDataSetup.creatProposal(opportunities[0], accounts[0], ApttusTestPriceList);
	  testProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
	  testProposal.NokiaCPQ_No_of_Years__c = '3';
	  testProposal.NokiaCPQ_Maintenance_Type__c='Gold (Return for Exchange)';
	  testProposal.Apttus_Proposal__Account__c=accLegalEntity.id;
	  testProposal.Sold_To_Party__c = accLegalEntity.id;
	  //testProposal.NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
	  testProposal.NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	  testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	  insert testProposal;
	  /*** proposal creation Ends ***/
	  system.debug('testProposal:'+testProposal);
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], ApttusTestPriceList, testProposal);
	  insert ProdConfig;
	  system.debug('ProdConfig>>>:'+ProdConfig);
	  /*** product configuration creation Ends***/
	  
	  /*** Line Item Starts***/
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();	
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(accounts[0], ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem1.Apttus_Config2__PriceListItemId__c = pLI1.id;
	  LineItem1.Apttus_Config2__ItemSequence__c = 1;
	  LineItem1.Source__c='';
	  LineItem1.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem1.Apttus_Config2__LineType__c = 'Product/Service'; 
	  LineItem1.Apttus_Config2__BasePriceOverride__c=120;
	  LineItem1.Advanced_pricing_done__c = false;
	  LineItem1.Nokia_Maint_Y1_Per__c = 7;
	  LineItem1.Nokia_Maint_Y2_Per__c = 7;
	  allLineItems.add(LineItem1);
	  
	  System.Debug('allLineItems>>>>>> '+allLineItems);
	  
	  //Line Item#2
	  Apttus_Config2__LineItem__c LineItem2 = TestDataSetup.creatConfigLineItem(accounts[0], ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem2.Apttus_Config2__PriceListItemId__c = pLI2.id;
	  LineItem2.Apttus_Config2__ProductId__c = prod2.Id;
	  LineItem2.Apttus_Config2__LineNumber__c = 2;
	  LineItem2.Apttus_Config2__ChargeType__c = 'Maintenance Year1';
	  LineItem2.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem2.Apttus_Config2__AdjustmentType__c = '% Discount';
	  LineItem2.Apttus_Config2__AdjustmentAmount__c = 10;
	  LineItem2.NokiaCPQ_Maint_Yr1_Extended_Price__c =  100;
	  LineItem2.Apttus_Config2__PriceIncludedInBundle__c = true;
	  LineItem2.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem2);
	  
	  //Line Item#3
	  Apttus_Config2__LineItem__c LineItem3 = TestDataSetup.creatConfigLineItem(accounts[0], ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem3.Apttus_Config2__LineNumber__c = 3;
	  LineItem3.Apttus_Config2__ChargeType__c = 'SSP'; 
	  LineItem3.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem3.Apttus_Config2__ProductId__c = prod3.Id;
	  LineItem3.Apttus_Config2__PriceListItemId__c = pLI3.id;
	  LineItem3.Nokia_SSP_Base_Extended_Price__c = 90;
	  LineItem3.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem3);
	  
	  //Line Item#4
	  Apttus_Config2__LineItem__c LineItem4 = TestDataSetup.creatConfigLineItem(accounts[0], ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem4.Apttus_Config2__LineNumber__c = 4;
	  LineItem4.Apttus_Config2__ProductId__c = prod4.Id;
	  LineItem4.Apttus_Config2__PriceListItemId__c = pLI4.id;
	  LineItem4.Apttus_Config2__PriceIncludedInBundle__c = true;
	  LineItem4.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem4.Apttus_Config2__ChargeType__c = 'Maintenance Y2+';
	  LineItem4.Apttus_Config2__Frequency__c = 'Yearly';
	  LineItem4.Advanced_pricing_done__c = false;
	  LineItem4.NokiaCPQ_Maint_Yr1_Extended_Price__c =  100;
	  allLineItems.add(LineItem4);
	  
	  //Line Item#5		   
	  Apttus_Config2__LineItem__c LineItem5 = TestDataSetup.creatConfigLineItem(accounts[0], ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem5.Apttus_Config2__LineNumber__c = 4;
	  LineItem5.Apttus_Config2__PriceListItemId__c = pLI5.id;
	  LineItem5.Apttus_Config2__ProductId__c = prod5.Id;
	  LineItem5.Apttus_Config2__ChargeType__c = 'SRS';
	  LineItem5.Apttus_Config2__Frequency__c = 'Yearly';
	  LineItem5.Apttus_Config2__ParentBundleNumber__c = 2;
	  LineItem5.NokiaCPQ_Maint_Yr2_Extended_Price__c = 100;
	  LineItem5.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem5.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem5.Nokia_SSP_Base_Extended_Price__c = 200;
	  LineItem5.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem5);
	  insert allLineItems;
	  System.Debug('allLineItems >>>>'+allLineItems);
	  /*** Line Item Ends***/
	  // Test.startTest(); 
	  
	  CPQ_Maintenance_and_SSP_Rule__c rec1 = new CPQ_Maintenance_and_SSP_Rule__c();
	  rec1.Maintenance_Level__c = 'Nokia Brand of Service';
	  rec1.Maintenance_Type__c = 'Gold (Return for Exchange)';
	  rec1.Region__c = 'RG_NAM';
	  rec1.Service_Rate_Y1__c = 0.05;
	  rec1.Service_Rate_Y2__c = 0.05;
	  rec1.Unlimited_SSP_Discount__c = 0.03; 
	  rec1.Maintenance_Category__c = 'NSD-NRC IPR';
	  insert rec1;
	  
	  Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	  System.Debug('ProdConfig.Id>>>> '+ProdConfig.Id);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  //Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfigList[0].Id);
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
	  obj.finish();
	  
	  //Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfigList[0].Id);
	  
	  //Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	Test.stopTest();
	}
	
  }
  static testMethod void DirectMethod11() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	
	System.runAs(users[0]) {
	  
	  List<Account> accountsNew = new List<Account>();
	  Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	  accLegalEntity.AccountNumber='101234567';
	  accLegalEntity.Acc_No__c = '101234567';
	  accLegalEntity.GeoLevel1Id__c = 'RG_NAM';
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  accountsNew.add(accLegalEntity);
	  
	  Account account = TestDataFactory.createAccount(1)[0];
	  account.AccountNumber='3011234567';
	  account.Acc_No__c = '3011234567';
	  account.GeoLevel1Id__c = 'RG_NAM';
	  account.Active__c= true;
	  accountsNew.add(account);
	  
	  insert accountsNew;
	  
	  List<Account> accounts=new List<Account>();
	  accounts.add(account);
	  
	  //Create Opportunity
	  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
	  opportunities.get(0).Lead_BG__c = 'MN';
	  opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities.get(0).Account_Role__c = 'Alliance Partner';
	  insert opportunities.get(0);
	  
	  /*** Product Creation starts ***/
	  List<Product2> prods = new List<Product2>();
	  
	  //Product#1
	  Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod1.Portfolio__c = 'Airscale Wifi';
	  prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod1.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod1);
	  
	  //Product#2
	  Product2 prod2 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod2.ProductCode = '123Arcadia';
	  prod2.Portfolio__c = 'Airscale Wifi';
	  prod2.NokiaCPQ_Item_Type__c='Hardware';
	  prod2.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod2); 
	  
	  insert prods;
	  /*** Product Creation ends ***/
	  
	  Test.startTest();
	  //Create PriceList	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
	  );
	  insert ApttusTestPriceList;
	  
	  /*** PriceList Item Creation starts ***/
	  List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	  //PLI#1
	  Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	  plistItems.add(pLI1);
	  
	  //PLI#2
	  Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI2.Apttus_Config2__ProductId__c = prod2.Id;
	  plistItems.add(pLI2);
	  insert plistItems;
	  /*** PriceList Item Creation ends ***/
	  /*** proposal creation starts ***/	  
	  Apttus_Proposal__Proposal__c testProposal = TestDataSetup.creatProposal(opportunities[0], accounts[0], ApttusTestPriceList);
	  testProposal.Sold_To_Party__c = accLegalEntity.id;
	  testProposal.Apttus_Proposal__Account__c=accLegalEntity.id;
	  testProposal.NokiaCPQ_No_of_Years__c = '4';
	  testProposal.NokiaCPQ_Portfolio__c = 'Airscale Wifi';
	  testProposal.NokiaCPQ_Maintenance_Type__c='MN GS TSS Basic';
	  //testProposal.NokiaCPQ_Existing_IONMaint_Contract__c='Yes';
	  testProposal.NokiaCPQ_Existing_IONMaint_Contract__c='No';
	  testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	  insert testProposal;
	  /*** proposal creation Ends ***/
	  system.debug('testProposal:'+testProposal);
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(account, ApttusTestPriceList, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  
	  /*** Line Item Starts***/			 
	  //Line Item#1
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem1.Apttus_Config2__PriceListItemId__c = pLI1.id;
	  LineItem1.Source__c='';
	  LineItem1.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem1.Apttus_Config2__LineType__c = 'Product/Service';
	  allLineItems.add(LineItem1);
	  
	  //Line Item#2
	  Apttus_Config2__LineItem__c LineItem2 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem2.Apttus_Config2__PriceListItemId__c = pLI2.id;
	  LineItem2.Apttus_Config2__OptionId__c = prod2.Id;
	  LineItem2.Apttus_Config2__ChargeType__c = 'Maintenance Year1';
	  LineItem2.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem2.Apttus_Config2__AdjustmentType__c = '% Discount';
	  LineItem2.Apttus_Config2__AdjustmentAmount__c = 10;
	  LineItem2.NokiaCPQ_Maint_Yr1_Extended_Price__c =  100;
	  LineItem2.Apttus_Config2__PriceIncludedInBundle__c = true;
	  LineItem2.Advanced_pricing_done__c = false;
	  LineItem2.Total_ONT_Quantity_FBA__c = 300;
	  allLineItems.add(LineItem2);
	  insert allLineItems;
	  /*** Line Item ends***/
	  
	  //Test.startTest(); 
	  
	  Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
	  
	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.finish();
	  Nokia_PricingCallBack.calculateEquivalentPrice(allLineItems, 'Market India');
	
	Test.stopTest();
	}
  }
  static testMethod void IndirectIPRouting() {
	Apttus_Config2__ClassificationName__c categoerySO = TestDataSetup.createCategorySO();
	insert categoerySO;
	
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	/*** Product Creation starts ***/
	List<Product2> prods = new List<Product2>();
	Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	prod1.Portfolio__c = 'IP Routing';
	prod1.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod1);
	
	//product#2
	Product2 prod2 =  TestDataSetup.createCPQTestproduct(1)[0];
	prod2.ProductCode = 'MT001';
	prod2.Business_Group__c = 'MN';
	prod2.Portfolio__c = 'IP Routing';
	prod2.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prod2.NokiaCPQ_Classification2__c='Base';
	prods.add(prod2);
	
	//Product#3
	Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	prod3.Name = 'SRS'; 
	prod3.ProductCode = 'SRS001';
	prod3.Portfolio__c = 'IP Routing';
	prod3.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod3);
	
	//Product#4
	Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	prod4.ProductCode = 'SSP002'; 
	prod4.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod4);
	
	//Product#5
	Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	prod5.Name = 'Maintenance Year2+'; 
	prod5.ProductCode = 'MT002'; 
	prod5.Portfolio__c = 'IP Routing';
	prod5.NokiaCPQ_Product_Discount_Category__c = 'NFM-P IPR';
	prods.add(prod5);
	
	//Product#6
	Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	prod6.ProductCode = 'P6';
	prod6.Portfolio__c = 'IP Routing';
	prod6.NokiaCPQ_Classification2__c='Base';
	prod6.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod6);
	insert prods;
	/*** Product Creation ends ***/
	
	//Test.startTest();
	//Create PriceList
	/*Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name = 'Commercial Price List', Apttus_Config2__Active__c = True);
insert ApttusTestPriceList; */
	
	/*** PriceList Item Creation starts ***/
	List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	//PLI#1
	Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	plistItems.add(pLI1);
	
	//PLI#2
	Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	pLI2.Apttus_Config2__PriceIncludedInBundle__c = false;
	pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	plistItems.add(pLI2);
	
	//PLI#3
	Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	pLI3.Apttus_Config2__ChargeType__c = 'SRS';
	pLI3.Apttus_Config2__ContractPrice__c = 100;
	plistItems.add(pLI3);
	
	//PLI#4
	Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI4.Apttus_Config2__ProductId__c = prod4.Id;
	pLI4.Apttus_Config2__ChargeType__c = 'SSP';
	plistItems.add(pLI4);
	
	//PLI#5
	Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	plistItems.add(pLI5);
	
	//PLI#6
	Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	plistItems.add(pLI6);
	insert plistItems;
	/*** PriceList Item ends ***/
	//Create PriceList SO//** need to be checked for usability*//
	Apttus_Config2__PriceListCategory__c priceListCategorySO = TestDataSetup.createPriceListCategorySO(categoerySO, priceListSO);
	
	//Create Classification HierarchySO
	Apttus_Config2__ClassificationHierarchy__c chSO = TestDataSetup.createPriceListCategorySO(categoerySO);
	insert chSO;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : prods){
	  productIDList.add(productSO.id);
	}
	
	/** Product classification*-------------------------------*/
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	/** Product classification ends**/
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	
	System.runAs(users[0]) { 
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  System.runAs(userList[0]){
		//Create Account
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
		/*opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);*/
		
		opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].End_Customer_LE__c = accounts1[0].Id;
		insert opportunities;
		
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		accredList[0].Portfolio__c='IP Routing';
		accredList[0].Pricing_Level_Override__c = 'Co-Branded';
		accredList[0].Pricing_Cluster__c='NAM';
		accredList[1].Portfolio__c='IP Routing';
		accredList[1].Pricing_Cluster__c='NAM';
		insert accredList;
		/***Accreditation ends ***/
		
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		
		/*** proposal creation starts ***/	  
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		insert testProposal;
		/*** proposal creation starts ***/
	  }
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], priceListSO, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  
	  // Add the products to the request
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod1.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  selectedProduct.CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100');
	  selectedProduct.CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c'};
		addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod2.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod3.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod4.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod5.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod6.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  // Execute the addMultiProducts routine
	  Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  //Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c='Fixed Access - FBA';
	  ship.Pricing_Cluster__c='NAM Canada';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  
	  try{
		  Test.startTest();
		// create the update price request
		Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
		
		// add request parameters
		objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
		
		// update price for the cart
		Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		Boolean hasPendingItems = result.IsPricePending;
		
		system.debug('Is Price Pending...' + hasPendingItems);
		for(integer i=0;i<6;i++){
		  if(hasPendingItems){
			result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
			hasPendingItems = result.IsPricePending;
			system.debug('Is Price Pending...' + hasPendingItems);
		  }
		}
		List<Apttus_Config2__LineItem__c> lineItem = [select id, Apttus_Config2__NetPrice__c,Apttus_Config2__PriceListItemId__c
								,Apttus_Config2__BasePrice__c, Apttus_Config2__Quantity__c, Apttus_Config2__PricingStatus__c
								, Apttus_Config2__ProductId__c, Apttus_Config2__ListPrice__c
								from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:   ProdConfig.id];//cartResponse.CartID];
		if(lineItem != null && lineItem.size() > 0){
		  system.debug('cart lines size...' + lineItem.size());
		  system.debug('cart lines...' + lineItem);
		  for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
			System.debug('lineItemSO...'+ lineItemSO);
		  }
		}else{
		  system.debug('cart lines does not exist...');
		}
		Test.stopTest();
	  }catch(Exception ex){
		throw ex;
	  }
	}
	// Test.stopTest();
  }
  static testMethod void IndirectIPRouting770() {
	Apttus_Config2__ClassificationName__c categoerySO = TestDataSetup.createCategorySO();
	insert categoerySO;
	
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	/*** Product Creation starts ***/
	List<Product2> prods = new List<Product2>();
	Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	prod1.Portfolio__c = 'IP Routing';
	prod1.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod1);
	
	//product#2
	Product2 prod2 =  TestDataSetup.createCPQTestproduct(1)[0];
	prod2.ProductCode = 'MT001';
	prod2.Business_Group__c = 'MN';
	prod2.Portfolio__c = 'IP Routing';
	prod2.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod2);
	
	//Product#3
	Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	prod3.Name = 'SRS'; 
	prod3.ProductCode = 'SRS001';
	prod3.Portfolio__c = 'IP Routing';
	prod3.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod3);
	
	//Product#4
	Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	prod4.ProductCode = 'SSP002';
	prod4.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod4);
	
	//Product#5
	Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	prod5.Name = 'Maintenance Year2+'; 
	prod5.ProductCode = 'MT002'; 
	prod5.Portfolio__c = 'IP Routing';
	prod5.NokiaCPQ_Product_Discount_Category__c = 'NFM-P IPR';
	prods.add(prod5);
	
	//Product#6
	Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	prod6.ProductCode = 'P6';
	prod6.Portfolio__c = 'IP Routing';
	prod6.NokiaCPQ_Classification2__c='Base';
	prod6.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod6);
	
	insert prods;
	/*** Product Creation ends ***/
	
	/*** PriceList Item Creation starts ***/
	List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	//PLI#1
	Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	plistItems.add(pLI1);
	
	//PLI#2
	Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	plistItems.add(pLI2);
	
	//PLI#3
	Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	pLI3.Apttus_Config2__ChargeType__c = 'SRS';
	plistItems.add(pLI3);
	
	//PLI#4
	Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI4.Apttus_Config2__ProductId__c = prod4.Id;
	pLI4.Apttus_Config2__ChargeType__c = 'SSP';
	plistItems.add(pLI4);
	
	//PLI#5
	Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	plistItems.add(pLI5);
	
	//PLI#6
	Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	plistItems.add(pLI6);
	insert plistItems;
	/*** PriceList Item ends ***/
		
		/*Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
	Name = 'Commercial Price List', 
	Apttus_Config2__Active__c = True
	);
	insert ApttusTestPriceList;*/
	
	//Create PriceList SO //** need to be checked for usability*//
	Apttus_Config2__PriceListCategory__c priceListCategorySO = TestDataSetup.createPriceListCategorySO(categoerySO, priceListSO);
	
	//Create Classification HierarchySO
	Apttus_Config2__ClassificationHierarchy__c chSO = TestDataSetup.createPriceListCategorySO(categoerySO);
	insert chSO;
	List<id> productIDList = new List<id>();
	for(Product2 productSO : prods){
	  productIDList.add(productSO.id);
	}
	
	/** Product classification*-------------------------------*/
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	/** Product classification ends**/
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	//Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	//Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	
	System.runAs(users[0]) {   
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  System.runAs(userList[0]){
		//Create Account
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
		/*opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);*/
		
		opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].Lead_BG__c = 'MN';	 
		opportunities[0].End_Customer_LE__c = accounts1[0].Id;
		insert opportunities;
		
		//create Accreditation
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		accredList[0].Portfolio__c='IP Routing';
		accredList[0].Pricing_Cluster__c='NAM';
		accredList[0].Pricing_Level_Override__c = 'Co-Branded';
		accredList[1].Portfolio__c='IP Routing';
		accredList[1].Pricing_Cluster__c='NAM';
		insert accredList;
		/***Accreditation ends ***/
		
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		
		/*** proposal creation starts ***/	  
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		testProposal.Maintenance_Y1__c = 5;
		insert testProposal;
		/*** proposal creation starts ***/
	  }
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], priceListSO, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  
	  // Add the products to the request
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod1.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  selectedProduct.CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100');
	  selectedProduct.CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c'};
		addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod2.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod3.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod4.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod5.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod6.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  // Execute the addMultiProducts routine
	  Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c='Fixed Access - FBA';
	  ship.Pricing_Cluster__c='NAM Canada';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  
	  try{
		// create the update price request
		Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
		
		// add request parameters
		objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
		
		// update price for the cart
		Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		Boolean hasPendingItems = result.IsPricePending;
		
		system.debug('Is Price Pending...' + hasPendingItems);
		for(integer i=0;i<6;i++){
		  if(hasPendingItems){
			result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
			hasPendingItems = result.IsPricePending;
			system.debug('Is Price Pending...' + hasPendingItems);
		  }
		}
		List<Apttus_Config2__LineItem__c> lineItem = [select id, Apttus_Config2__NetPrice__c,Apttus_Config2__PriceListItemId__c
								,Apttus_Config2__BasePrice__c, Apttus_Config2__Quantity__c, Apttus_Config2__PricingStatus__c
								, Apttus_Config2__ProductId__c, Apttus_Config2__ListPrice__c
								from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:   ProdConfig.id];//cartResponse.CartID];
		
		if(lineItem != null && lineItem.size() > 0){  
		  system.debug('cart lines size...' + lineItem.size());
		  system.debug('cart lines...' + lineItem);
		  for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
			System.debug('lineItemSO...'+ lineItemSO);
		  }
		}else{
		  system.debug('cart lines does not exist...');
		}
	  }catch(Exception ex){
		throw ex;
	  }
	Test.stopTest();
	}
  }
  /*static testMethod void IndirectIPRouting299() {
	Apttus_Config2__ClassificationName__c categoerySO = TestDataSetup.createCategorySO();
	insert categoerySO;
	
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	/*** Product Creation starts ***--
	List<Product2> prods = new List<Product2>();
	Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	prod1.Portfolio__c = 'IP Routing';
	prod1.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod1);
	
	//product#2
	Product2 prod2 =  TestDataSetup.createCPQTestproduct(1)[0];
	prod2.ProductCode = 'MT001';
	prod2.Business_Group__c = 'MN';
	prod2.Portfolio__c = 'IP Routing';
	prod2.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod2);
	
	//Product#3
	Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	prod3.Name = 'SRS'; 
	prod3.ProductCode = 'SRS001';
	prod3.Portfolio__c = 'IP Routing';
	prod3.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod3);
	
	//Product#4
	Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	prod4.ProductCode = 'SSP002';
	prod4.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod4);
	
	//Product#5
	Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	prod5.Name = 'Maintenance Year2+'; 
	prod5.ProductCode = 'MT002'; 
	prod5.Portfolio__c = 'IP Routing';
	prod5.NokiaCPQ_Product_Discount_Category__c = 'NFM-P IPR';
	prods.add(prod5);
	
	//Product#6
	Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	prod6.ProductCode = 'P6';
	prod6.Portfolio__c = 'IP Routing';
	prod6.NokiaCPQ_Classification2__c='Base';
	prod6.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod6);
	
	insert prods;
	/*** Product Creation ends ***---
	
	Test.startTest();
	
	//Create PriceList
	
	/*Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
Name = 'Commercial Price List', 
Apttus_Config2__Active__c = True
);
insert ApttusTestPriceList;*/
	
	/*** PriceList Item Creation starts ***--
	List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	//PLI#1
	Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	plistItems.add(pLI1);
	
	//PLI#2
	Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	plistItems.add(pLI2);
	
	//PLI#3
	Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	pLI3.Apttus_Config2__ChargeType__c = 'SRS';
	plistItems.add(pLI3);
	
	//PLI#4
	Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI4.Apttus_Config2__ProductId__c = prod4.Id;
	pLI4.Apttus_Config2__ChargeType__c = 'SSP';
	plistItems.add(pLI4);
	
	//PLI#5
	Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	plistItems.add(pLI5);
	
	//PLI#6
	Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	plistItems.add(pLI6);
	insert plistItems;
	/*** PriceList Item ends ***--
	
	//Create PriceList SO //** need to be checked for usability---
	Apttus_Config2__PriceListCategory__c priceListCategorySO = TestDataSetup.createPriceListCategorySO(categoerySO, priceListSO);
	
	//Create Classification HierarchySO
	Apttus_Config2__ClassificationHierarchy__c chSO = TestDataSetup.createPriceListCategorySO(categoerySO);
	insert chSO;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : prods){
	  productIDList.add(productSO.id);
	}
	/** Product classification*-------------------------------*--
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	/** Product classification ends**--
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	//Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	//Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	
	System.runAs(users[0]) {   
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  System.runAs(userList[0]){
		//Create Account
		accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		string partnerType = 'Distributor';
		string partnerProgram = 'Global Alliance';
		List<Account> accounts1 = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		accounts1[0].Acc_No__c = 'Testing1';
		accounts1[0].Partner_Program__c = partnerProgram;
		//accounts1[0].Partner_Type__c = partnerType;
		accounts1[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts1[0].Active__c = true;
		accounts1[0].NokiaCPQ_Renewal__c = true;
		//accounts1[0].Type = 'Vendor';
		accounts1[0].ParentId = accounts[0].Id;
		
	   // accounts1[0].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		//accounts1[0].Partner_Type__c = '';
		//accounts1[0].Partner_Program__c = '';
		
		insert accounts1;
		
		//Create Opportunity
		/*opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		//opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		opportunities.get(0).StageName ='Create Offer (Bid)';
		opportunities.get(0).Phase_Status__c = 'Offer in Progress';
		insert opportunities.get(0);*--
		
		opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].End_Customer_LE__c = accounts1[0].Id;
		insert opportunities;
		
		//create Accreditation
		
		/***Accreditation Creation starts***--
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		accredList[0].Portfolio__c='IP Routing';
		accredList[0].Pricing_Cluster__c='NAM';
		accredList[0].Pricing_Level_Override__c = 'Advanced';
		insert accredList;
		/***Accreditation ends ***--
		
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		
		/*** proposal creation starts ***  --   
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		//testProposal.Maintenance_Y1__c = 5;
		//testProposal.CurrencyIsoCode = Nokia_CPQ_Constants.EUR_CURR;
		//testProposal.NokiaCPQ_Portfolio__c = 'QTC';
		testProposal.NokiaCPQ_Existing_IONMaint_Contract__c='Yes';
		//testProposal.NokiaCPQ_Existing_IONMaint_Contract__c='No';
		insert testProposal;
		/*** proposal creation starts ***--
	  }
	  
	  /*** create product configuration ***--
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], priceListSO, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***--
	  
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  
	  // Add the products to the request
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod1.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  selectedProduct.CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100');
	  selectedProduct.CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c'};
		addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod2.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod3.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod4.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod5.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod6.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  // Execute the addMultiProducts routine
	  Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  //Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c='Fixed Access - FBA';
	  ship.Pricing_Cluster__c='NAM Canada';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  
	  try{
		// create the update price request
		Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
		
		// add request parameters
		objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
		
		// update price for the cart
		Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		Boolean hasPendingItems = result.IsPricePending;
		
		system.debug('Is Price Pending...' + hasPendingItems);
		
		for(integer i=0;i<6;i++){
		  if(hasPendingItems){
			result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
			hasPendingItems = result.IsPricePending;
			system.debug('Is Price Pending...' + hasPendingItems);
		  }
		}
		List<Apttus_Config2__LineItem__c> lineItem = [select id, Apttus_Config2__NetPrice__c,Apttus_Config2__PriceListItemId__c
								,Apttus_Config2__BasePrice__c, Apttus_Config2__Quantity__c, Apttus_Config2__PricingStatus__c
								, Apttus_Config2__ProductId__c, Apttus_Config2__ListPrice__c
								from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:   ProdConfig.id];//cartResponse.CartID];
		if(lineItem != null && lineItem.size() > 0){
		  system.debug('cart lines size...' + lineItem.size());
		  system.debug('cart lines...' + lineItem);
		  for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
			System.debug('lineItemSO...'+ lineItemSO);
		  }
		}else{
		  system.debug('cart lines does not exist...');
		}
	  }catch(Exception ex){
		throw ex;
	  }
	
	}
	Test.stopTest();
  }*/
  static testMethod void IndirectIPRouting308() {
	Apttus_Config2__ClassificationName__c categoerySO = TestDataSetup.createCategorySO();
	insert categoerySO;
	
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	/*** Product Creation starts ***/
	List<Product2> prods = new List<Product2>();
	Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	prod1.Portfolio__c = 'IP Routing';
	prod1.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod1);
	
	//product#2
	Product2 prod2 =  TestDataSetup.createCPQTestproduct(1)[0];
	prod2.ProductCode = 'MT001';
	prod2.Portfolio__c = 'IP Routing';
	//prod2.Business_Group__c = 'NSW';
	prod2.Business_Group__c = 'MN';
	prod2.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod2);
	
	//Product#3
	Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	prod3.Name = 'SRS'; 
	prod3.ProductCode = 'SRS001';
	prod3.Portfolio__c = 'IP Routing';
	prod3.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod3);
	
	//Product#4
	Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	prod4.ProductCode = 'SSP002';
	prod4.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod4);
	
	//Product#5
	Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	prod5.Name = 'Maintenance Year2+'; 
	prod5.ProductCode = 'MT002'; 
	prod5.Portfolio__c = 'IP Routing';
	prod5.NokiaCPQ_Product_Discount_Category__c = 'NFM-P IPR';
	prods.add(prod5);
	
	//Product#6
	Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	prod6.ProductCode = 'P6';
	prod6.Portfolio__c = 'IP Routing';
	prod6.NokiaCPQ_Classification2__c='Base';
	prod6.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod6);
	
	insert prods;
	/*** Product Creation ends ***/
	
	//Test.startTest();
	
	//Create PriceList
	/* Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
Name = 'Commercial Price List', 
Apttus_Config2__Active__c = True
);
insert ApttusTestPriceList;*/
	/*** PriceList Item Creation starts ***/
	List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	//PLI#1
	Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	plistItems.add(pLI1);
	
	//PLI#2
	Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	plistItems.add(pLI2);
	
	//PLI#3
	Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	pLI3.Apttus_Config2__ChargeType__c = 'SRS';
	plistItems.add(pLI3);
	
	//PLI#4
	Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI4.Apttus_Config2__ProductId__c = prod4.Id;
	pLI4.Apttus_Config2__ChargeType__c = 'SSP';
	plistItems.add(pLI4);
	
	//PLI#5
	Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	plistItems.add(pLI5);
	
	//PLI#6
	Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	plistItems.add(pLI6);
	insert plistItems;
	/*** PriceList Item ends ***/
	
	//Create PriceList SO //** need to be checked for usability*//
	Apttus_Config2__PriceListCategory__c priceListCategorySO = TestDataSetup.createPriceListCategorySO(categoerySO, priceListSO);
	
	//Create Classification HierarchySO
	Apttus_Config2__ClassificationHierarchy__c chSO = TestDataSetup.createPriceListCategorySO(categoerySO);
	insert chSO;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : prods){
	  productIDList.add(productSO.id);
	}
	
	/** Product classification*-------------------------------*/
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	/** Product classification ends**/
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	//Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	//Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	
	System.runAs(users[0]) {   
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  System.runAs(userList[0]){
		//Create Account
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
		/*opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);*/
		
		opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].End_Customer_LE__c = accounts1[0].Id;
		insert opportunities;
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		accredList[0].Portfolio__c='IP Routing';
		accredList[0].Pricing_Cluster__c='NAM';
		accredList[0].Pricing_Level_Override__c = 'Advanced';
		accredList[1].Portfolio__c='IP Routing';
		accredList[1].Pricing_Cluster__c='NAM';
		insert accredList;
		/***Accreditation ends ***/
		
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		
		/*** proposal creation starts ***/	  
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		testProposal.CurrencyIsoCode = Nokia_CPQ_Constants.EUR_CURR;
		insert testProposal;
		/*** proposal creation ends***/
	  }
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], priceListSO, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  
	  // Add the products to the request
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod1.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  selectedProduct.CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100');
	  selectedProduct.CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c'};
		addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod2.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod3.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod4.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod5.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod6.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  // Execute the addMultiProducts routine
	  Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  // Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c='Fixed Access - FBA';
	  ship.Pricing_Cluster__c='NAM Canada';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  
	  try{
		  Test.startTest();
		// create the update price request
		Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
		
		// add request parameters
		objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
		
		// update price for the cart
		Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		Boolean hasPendingItems = result.IsPricePending;
		
		system.debug('Is Price Pending...' + hasPendingItems);
		
		for(integer i=0;i<6;i++){
		  if(hasPendingItems){
			result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
			hasPendingItems = result.IsPricePending;
			system.debug('Is Price Pending...' + hasPendingItems);
		  }
		}
		List<Apttus_Config2__LineItem__c> lineItem = [select id, Apttus_Config2__NetPrice__c,Apttus_Config2__PriceListItemId__c
								,Apttus_Config2__BasePrice__c, Apttus_Config2__Quantity__c, Apttus_Config2__PricingStatus__c
								, Apttus_Config2__ProductId__c, Apttus_Config2__ListPrice__c
								from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:   ProdConfig.id];//cartResponse.CartID];
		
		if(lineItem != null && lineItem.size() > 0){
		  system.debug('cart lines size...' + lineItem.size());
		  system.debug('cart lines...' + lineItem);
		  for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
			System.debug('lineItemSO...'+ lineItemSO);
		  }
		}else{
		  system.debug('cart lines does not exist...');
		}
		Test.stopTest();
	  }catch(Exception ex){
		throw ex;
	  }
	}
	// Test.stopTest();
  }
  static testMethod void IndirectIPRouting305() {
	Apttus_Config2__ClassificationName__c categoerySO = TestDataSetup.createCategorySO();
	insert categoerySO;
	
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	/*** Product Creation starts ***/
	List<Product2> prods = new List<Product2>();
	Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	prod1.Portfolio__c = 'IP Routing';
	prod1.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod1);
	
	//product#2
	Product2 prod2 =  TestDataSetup.createCPQTestproduct(1)[0];
	prod2.ProductCode = 'MT001';
	prod2.Portfolio__c = 'IP Routing';
	//prod2.Business_Group__c = 'NSW';
	prod2.Business_Group__c = 'MN';
	prod2.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod2);
	
	//Product#3
	Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	prod3.Name = 'SRS'; 
	prod3.ProductCode = 'SRS001';
	prod3.Portfolio__c = 'IP Routing';
	prod3.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod3);
	
	//Product#4
	Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	prod4.ProductCode = 'SSP002';
	prod4.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod4);
	
	//Product#5
	Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	prod5.Name = 'Maintenance Year2+'; 
	prod5.ProductCode = 'MT002'; 
	prod5.Portfolio__c = 'IP Routing';
	prod5.NokiaCPQ_Product_Discount_Category__c = 'NFM-P IPR';
	prods.add(prod5);
	
	//Product#6
	Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	prod6.ProductCode = 'P6';
	prod6.Portfolio__c = 'IP Routing';
	prod6.NokiaCPQ_Classification2__c='Base';
	prod6.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod6);
	
	insert prods;
	/*** Product Creation ends ***/
	//Create PriceList  
	/*Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
Name = 'Commercial Price List', 
Apttus_Config2__Active__c = True
);
insert ApttusTestPriceList;*/
	
	/*** PriceList Item Creation starts ***/
	List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	//PLI#1
	Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	plistItems.add(pLI1);
	
	//PLI#2
	Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	plistItems.add(pLI2);
	
	//PLI#3
	Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	pLI3.Apttus_Config2__ChargeType__c = 'SRS';
	plistItems.add(pLI3);
	
	//PLI#4
	Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI4.Apttus_Config2__ProductId__c = prod4.Id;
	pLI4.Apttus_Config2__ChargeType__c = 'SSP';
	plistItems.add(pLI4);
	
	//PLI#5
	Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	plistItems.add(pLI5);
	
	//PLI#6
	Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	plistItems.add(pLI6);
	insert plistItems;
	/*** PriceList Item ends ***/
	
	//Create PriceList SO //** need to be checked for usability*//
	Apttus_Config2__PriceListCategory__c priceListCategorySO = TestDataSetup.createPriceListCategorySO(categoerySO, priceListSO);
	
	//Create Classification HierarchySO
	Apttus_Config2__ClassificationHierarchy__c chSO = TestDataSetup.createPriceListCategorySO(categoerySO);
	insert chSO;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : prods){
	  productIDList.add(productSO.id);
	}
	/** Product classification*-------------------------------*/
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	/** Product classification ends**/
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	//Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	//Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	
	System.runAs(users[0]) { 
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  System.runAs(userList[0]){
		//Create Account
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
		/*opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);*/
		
		opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].End_Customer_LE__c = accounts1[0].Id;
		insert opportunities;
		
		//create Accreditation
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		accredList[0].Pricing_Level_Override__c = 'Co-Branded';
		accredList[0].Portfolio__c='IP Routing';
		accredList[0].Pricing_Cluster__c='NAM';
		accredList[1].Portfolio__c='IP Routing';
		accredList[1].Pricing_Cluster__c='NAM';
		insert accredList;
		/***Accreditation ends ***/
		
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		
		/*** proposal creation starts ***/	  
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		testProposal.NokiaCPQ_LEO_Discount__c=true;
		insert testProposal;
		
		testProposal.CurrencyIsoCode = Nokia_CPQ_Constants.EUR_CURR;
		update testProposal;
		/*** proposal creation ends***/
	  }
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], priceListSO, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  
	  // Add the products to the request
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod1.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  selectedProduct.CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100');
	  selectedProduct.CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c'};
		addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod2.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod3.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod4.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod5.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod6.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  // Execute the addMultiProducts routine
	  Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c='Fixed Access - FBA';
	  ship.Pricing_Cluster__c='NAM Canada';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  
	  try{
		// create the update price request
		Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
		
		// add request parameters
		objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
		
		// update price for the cart
		Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		Boolean hasPendingItems = result.IsPricePending;
		
		system.debug('Is Price Pending...' + hasPendingItems);
		for(integer i=0;i<6;i++){
		  if(hasPendingItems){
			result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
			hasPendingItems = result.IsPricePending;
			system.debug('Is Price Pending...' + hasPendingItems);
		  }
		}
		List<Apttus_Config2__LineItem__c> lineItem = [select id, Apttus_Config2__NetPrice__c,Apttus_Config2__PriceListItemId__c
								,Apttus_Config2__BasePrice__c, Apttus_Config2__Quantity__c, Apttus_Config2__PricingStatus__c
								, Apttus_Config2__ProductId__c, Apttus_Config2__ListPrice__c
								from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:   ProdConfig.id];//cartResponse.CartID];
		
		if(lineItem != null && lineItem.size() > 0){
		  system.debug('cart lines size...' + lineItem.size());
		  system.debug('cart lines...' + lineItem);			 
		  for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
			System.debug('lineItemSO...'+ lineItemSO);
		  }
		}else{
		  system.debug('cart lines does not exist...');
		}
	  }catch(Exception ex){
		throw ex;
	  }
	}
	Test.stopTest();
  }
  static testMethod void IndirectFBA() {
	Apttus_Config2__ClassificationName__c categoerySO = TestDataSetup.createCategorySO();
	insert categoerySO;
	
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	/*** Product Creation starts ***/
	List<Product2> prods = new List<Product2>();
	Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	prod1.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
	prod1.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod1);
	
	//product#2
	Product2 prod2 =  TestDataSetup.createCPQTestproduct(1)[0];
	prod2.ProductCode = 'MT001';
	prod2.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
	prod2.Business_Group__c = 'MN';
	prod2.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod2);
	
	//Product#3
	Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	prod3.Name = 'SRS'; 
	prod3.ProductCode = 'SRS001';
	prod3.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
	prod3.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod3);
	
	//Product#4
	Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	prod4.ProductCode = 'SSP002';
	prod4.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod4);
	
	//Product#5
	Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	prod5.Name = 'Maintenance Year2+'; 
	prod5.ProductCode = 'MT002'; 
	prod5.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
	prod5.NokiaCPQ_Product_Discount_Category__c = 'NFM-P IPR';
	prods.add(prod5);
	
	//Product#6
	Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	prod6.ProductCode = 'P6';
	prod6.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
	prod6.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod6);
	
	insert prods;
	/*** Product Creation ends ***/
	/*
Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
Name = 'Commercial Price List', 
Apttus_Config2__Active__c = True
);
insert ApttusTestPriceList;*/
	
	/*** PriceList Item Creation starts ***/
	List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	//PLI#1
	Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	plistItems.add(pLI1);
	
	//PLI#2
	Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	plistItems.add(pLI2);
	
	//PLI#3
	Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	pLI3.Apttus_Config2__ChargeType__c = 'SRS';
	plistItems.add(pLI3);
	
	//PLI#4
	Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI4.Apttus_Config2__ProductId__c = prod4.Id;
	pLI4.Apttus_Config2__ChargeType__c = 'SSP';
	plistItems.add(pLI4);
	
	//PLI#5
	Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	plistItems.add(pLI5);
	
	//PLI#6
	Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	plistItems.add(pLI6);
	insert plistItems;
	/*** PriceList Item ends ***/
	
	//Create PriceList SO //** need to be checked for usability*//
	Apttus_Config2__PriceListCategory__c priceListCategorySO = TestDataSetup.createPriceListCategorySO(categoerySO, priceListSO);
	
	//Create Classification HierarchySO
	Apttus_Config2__ClassificationHierarchy__c chSO = TestDataSetup.createPriceListCategorySO(categoerySO);
	insert chSO;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : prods){
	  productIDList.add(productSO.id);
	}
	/** Product classification*-------------------------------*/
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	/** Product classification ends**/
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	//Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	//Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	
	System.runAs(users[0]) {   
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  System.runAs(userList[0]){
		//Create Account
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
		/*opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);*/
		
		
		opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].End_Customer_LE__c = accounts1[0].Id;
		insert opportunities;
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		accredList[0].Pricing_Cluster__c='NAM';		
		accredList[0].Portfolio__c=Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
		accredList[0].Pricing_Level_Override__c = 'Co-Branded';
		accredList[1].Portfolio__c=Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
		accredList[1].Pricing_Cluster__c='NAM';
		insert accredList;
		/***Accreditation ends ***/
		
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		
		/*** proposal creation starts ***/	  
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		testProposal.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
		testProposal.NokiaCPQ_SSP_Level__c = '';
		testProposal.NokiaCPQ_SRS_Level__c = '';
		insert testProposal;
		/*** proposal creation ends***/
	  }
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], priceListSO, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  
	  // Add the products to the request
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod1.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  selectedProduct.CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100');
	  selectedProduct.CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c'};
		addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod2.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod3.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod4.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod5.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod6.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  // Execute the addMultiProducts routine
	  Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c='Fixed Access - FBA';
	  ship.Pricing_Cluster__c='NAM Canada';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  
	  try{
		// create the update price request
		Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
		
		// add request parameters
		objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
		
		// update price for the cart
		Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		Boolean hasPendingItems = result.IsPricePending;
		
		system.debug('Is Price Pending...' + hasPendingItems);
		for(integer i=0;i<6;i++){
		  if(hasPendingItems){
			result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
			hasPendingItems = result.IsPricePending;
			system.debug('Is Price Pending...' + hasPendingItems);
		  }
		}
		List<Apttus_Config2__LineItem__c> lineItem = [select id, Apttus_Config2__NetPrice__c,Apttus_Config2__PriceListItemId__c
								,Apttus_Config2__BasePrice__c, Apttus_Config2__Quantity__c, Apttus_Config2__PricingStatus__c
								, Apttus_Config2__ProductId__c, Apttus_Config2__ListPrice__c
								from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:   ProdConfig.id];//cartResponse.CartID];
		if(lineItem != null && lineItem.size() > 0){
		  system.debug('cart lines size...' + lineItem.size());
		  system.debug('cart lines...' + lineItem);
		  for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
			System.debug('lineItemSO...'+ lineItemSO);
		  }
		}else{
		  system.debug('cart lines does not exist...');
		}
	  }catch(Exception ex){
		throw ex;
	  }
	}
	Test.stopTest();
  }
  static testMethod void IndirectFBA8() { 
	Apttus_Config2__ClassificationName__c categoerySO = TestDataSetup.createCategorySO();
	insert categoerySO;
	
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	/*** Product Creation starts ***/
	List<Product2> prods = new List<Product2>();
	Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	prod1.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
	prod1.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod1);
	
	//product#2
	Product2 prod2 =  TestDataSetup.createCPQTestproduct(1)[0];
	prod2.ProductCode = 'MT001';
	prod2.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
	//prod2.Business_Group__c = 'NSW';
	prod2.Business_Group__c = 'MN';
	prod2.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod2);
	
	//Product#3
	Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	prod3.Name = 'SRS'; 
	prod3.ProductCode = 'SRS001';
	prod3.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
	prod3.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod3);
	
	//Product#4
	Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	prod4.ProductCode = 'SSP002';
	prod4.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod4);
	
	//Product#5
	Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	prod5.Name = 'Maintenance Year2+'; 
	prod5.ProductCode = 'MT002'; 
	prod5.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
	prod5.NokiaCPQ_Product_Discount_Category__c = 'NFM-P IPR';
	prods.add(prod5);
	
	//Product#6
	Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	prod6.ProductCode = 'P6';
	prod6.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
	prod6.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod6);
	
	insert prods;
	/*** Product Creation ends ***/
	
	//Create PriceList	   
	/* Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
Name = 'Commercial Price List', 
Apttus_Config2__Active__c = True
);
insert ApttusTestPriceList;*/
	
	/*** PriceList Item Creation starts ***/
	List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	//PLI#1
	Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	plistItems.add(pLI1);
	
	//PLI#2
	Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	plistItems.add(pLI2);
	
	//PLI#3
	Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	pLI3.Apttus_Config2__ChargeType__c = 'SRS';
	plistItems.add(pLI3);
	
	//PLI#4
	Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI4.Apttus_Config2__ProductId__c = prod4.Id;
	pLI4.Apttus_Config2__ChargeType__c = 'SSP';
	plistItems.add(pLI4);
	
	//PLI#5
	Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	plistItems.add(pLI5);
	
	//PLI#6
	Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	plistItems.add(pLI6);
	insert plistItems;
	/*** PriceList Item ends ***/
	
	Apttus_Config2__PriceListCategory__c priceListCategorySO = TestDataSetup.createPriceListCategorySO(categoerySO, priceListSO);
	
	//Create Classification HierarchySO
	Apttus_Config2__ClassificationHierarchy__c chSO = TestDataSetup.createPriceListCategorySO(categoerySO);
	insert chSO;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : prods){
	  productIDList.add(productSO.id);
	}
	
	/** Product classification*-------------------------------*/
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	/** Product classification ends**/
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	//Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	//Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	//List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	
	System.runAs(users[0]) {   
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  System.runAs(userList[0]){
		//Create Account
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
		accounts1[0].NokiaCPQ_Renewal__c = true;
		accounts1[0].NokiaCPQ_Attachment__c = true;
		accounts1[0].NokiaCPQ_Performance__c = true;
		insert accounts1;
		
		//Create Opportunity
		/*opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);*/
		
		opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].End_Customer_LE__c = accounts1[0].Id;
		insert opportunities;
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);	   
		accredList[0].Portfolio__c=Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
		accredList[0].Pricing_Cluster__c='NAM';
		accredList[0].Pricing_Level_Override__c = 'Co-Branded';
		accredList[1].Portfolio__c=Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
		accredList[1].Pricing_Cluster__c='NAM';
		insert accredList;
		/***Accreditation ends ***/
		
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		
		/*** proposal creation starts ***/	  
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		testProposal.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
		testProposal.NokiaCPQ_SSP_Level__c='';
		testProposal.NokiaCPQ_SRS_Level__c='';
		insert testProposal;
		/*** proposal creation ends***/
	  }
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], priceListSO, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  
	  // Add the products to the request
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod1.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  selectedProduct.CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100');
	  selectedProduct.CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c'};
		addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod2.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod3.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod4.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod5.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod6.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  // Execute the addMultiProducts routine
	  Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c='Fixed Access - FBA';
	  ship.Pricing_Cluster__c='NAM Canada';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  try{
		// create the update price request
		Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
		
		// add request parameters
		objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
		
		// update price for the cart
		Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		Boolean hasPendingItems = result.IsPricePending;
		
		system.debug('Is Price Pending...' + hasPendingItems);
		for(integer i=0;i<6;i++){
		  if(hasPendingItems){
			result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
			hasPendingItems = result.IsPricePending;
			system.debug('Is Price Pending...' + hasPendingItems);
		  }
		}
		List<Apttus_Config2__LineItem__c> lineItem = [select id, Apttus_Config2__NetPrice__c,Apttus_Config2__PriceListItemId__c
								,Apttus_Config2__BasePrice__c, Apttus_Config2__Quantity__c, Apttus_Config2__PricingStatus__c
								, Apttus_Config2__ProductId__c, Apttus_Config2__ListPrice__c
								from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:   ProdConfig.id];//cartResponse.CartID];
		if(lineItem != null && lineItem.size() > 0){
		  system.debug('cart lines size...' + lineItem.size());
		  system.debug('cart lines...' + lineItem);
		  for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
			System.debug('lineItemSO...'+ lineItemSO);
		  }
		}else{
		  system.debug('cart lines does not exist...');
		}
	  }catch(Exception ex){
		throw ex;
	  }
	}
	Test.stopTest();
  }
  static testMethod void IndirectFixedAccessPOL() {
	IndirectFixedAccess(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL);
  } 
  static testMethod void IndirectFixedAccessFBA() {
	IndirectFixedAccess(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA);
  }
  public static void IndirectFixedAccess(string portFolio) {
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	//Create Product
	List<Product2> productList =  getProducts(portFolio);
	productList[0].Number_of_GE_Ports__c = 10;
	productList[1].Number_of_GE_Ports__c = 10;
	//set category for Fixed Access FBA
	if(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA == portFolio){
	  productList[0].NokiaCPQ_Category__c = Nokia_CPQ_Constants.NOKIA_PTP;
	  productList[1].NokiaCPQ_Category__c = Nokia_CPQ_Constants.NOKIA_ONT;
	}
	insert productList;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : productList){
	  productIDList.add(productSO.id);
	}
	
	//Create PriceList
	//create price list items
	List<Apttus_Config2__PriceListItem__c> plistItems = getPriceListItems(priceListSO.id, productIDList);
	insert plistItems;
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	List<Opportunity> opportunities;
	//List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	
	System.runAs(users[0]) { 
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  System.runAs(userList[0]){
		//Create Account
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
		/*opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);*/
		
		opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type'). getRecordTypeId();
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].End_Customer_LE__c = accounts1[0].Id;
		insert opportunities;
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		accredList[0].Portfolio__c=portFolio;
		accredList[0].Pricing_Cluster__c='NAM';
		accredList[0].Pricing_Level_Override__c = 'Co-Branded';
		accredList[1].Portfolio__c=portFolio;
		accredList[1].Pricing_Cluster__c='NAM';
		insert accredList;
		/***Accreditation ends ***/
		
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		
		/*** proposal creation starts ***/	  
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		testProposal.NokiaCPQ_Portfolio__c = portFolio;
		testProposal.Maintenance_Y1__c = 10;
		testProposal.Maintenance_Y2__c = 10;
		testProposal.NokiaCPQ_SSP_Level__c = '';
		testProposal.NokiaCPQ_SRS_Level__c = '';
		testProposal.SRS__c = 10;
		testProposal.SSP__c = 10;
		insert testProposal;
		/*** proposal creation ends***/
	  }
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], priceListSO, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct;
	  
	  // Add the products to the request
	  for(integer counter =0; counter < 6; counter++){	  
		selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
		selectedProduct.ProductId =productIDList[counter];
		selectedProduct.Quantity = 1;
		selectedProduct.SellingTerm = 1;
		addProductRequest.SelectedProducts.add(selectedProduct);
	  }
	  //add custom fields for one of products
	  addProductRequest.SelectedProducts[0].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true,Custom_Product_Code__c='SSP' , CustomProductValue__c='100;100;100', Total_ONT_Quantity_FBA__c = 200, Source__c = 'EPT' );
	  addProductRequest.SelectedProducts[0].CustomFields = new List<string>{'is_Custom_Product__c','Custom_Product_Code__c', 'CustomProductValue__c', 'Total_ONT_Quantity_FBA__c'};//,'Apttus_Config2__LineType__c', 'NokiaCPQ_SSP_Rate__c','Source__c};
		
		addProductRequest.SelectedProducts[1].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100', Total_ONT_Quantity_P2P__c = 100);
	  addProductRequest.SelectedProducts[1].CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c', 'Total_ONT_Quantity_P2P__c'};
		
		addProductRequest.SelectedProducts[2].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = false, CustomProductValue__c='100;100;100', Is_Contract_Pricing_2__c = true, Apttus_Config2__Quantity__c = 1,NokiaCPQ_Unitary_IRP__c=1,Nokia_Maint_Y1_Per__c=10, Nokia_Maint_Y2_Per__c=10, Advanced_pricing_done__c = true);
	  addProductRequest.SelectedProducts[2].CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c', 'Is_Contract_Pricing_2__c','Apttus_Config2__Quantity__c','NokiaCPQ_Unitary_IRP__c','Nokia_Maint_Y1_Per__c', 'Nokia_Maint_Y2_Per__c', 'Advanced_pricing_done__c' };
		
		// Execute the addMultiProducts routine
		Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c=portFolio;
	  ship.Pricing_Cluster__c='NAM Canada';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  
	  // create the update price request
	  Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
	  
	  // add request parameters
	  objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
	  
	  // update price for the cart
	  Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
	  Boolean hasPendingItems = result.IsPricePending;
	  
	  system.debug('Is Price Pending...' + hasPendingItems);
	  for(integer i=0;i<6;i++){
		if(hasPendingItems){
		  result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		  hasPendingItems = result.IsPricePending;
		  system.debug('Is Price Pending...' + hasPendingItems);
		}
	  }
	}
	Test.stopTest();
  }
  static testMethod void IndirectFixedAccessFBA2082() {
	IndirectFixedAccess6(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA);
  }
  public static void IndirectFixedAccess6(string portFolio) {
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	//Create Product
	List<Product2> productList =  getProducts(portFolio);
	productList[0].Number_of_GE_Ports__c = 10;
	productList[1].Number_of_GE_Ports__c = 10;
	//set category for Fixed Access FBA
	if(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA == portFolio){
	  productList[0].NokiaCPQ_Category__c = Nokia_CPQ_Constants.NOKIA_PTP;
	  productList[1].NokiaCPQ_Category__c = Nokia_CPQ_Constants.NOKIA_ONT;
	}
	insert productList;
	productList[0].NokiaCPQ_Category__c = Nokia_CPQ_Constants.NOKIA_PTP;
	update productList;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : productList){
	  productIDList.add(productSO.id);
	}
	
	//Create PriceList
	//create price list items
	List<Apttus_Config2__PriceListItem__c> plistItems = getPriceListItems(priceListSO.id, productIDList);
	insert plistItems;
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	
	System.runAs(users[0]){   
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  //System.runAs(userList[0]){
		//Create Account
		accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		string partnerType = 'Distributor';
		string partnerProgram = 'Global Alliance';
		List<Account> accounts1 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts1[0].Acc_No__c = 'Testing2'; 
		accounts1[0].Partner_Program__c = partnerProgram;
		accounts1[0].Partner_Type__c = partnerType;
		accounts1[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts1[0].Active__c = true;
		accounts1[0].NokiaCPQ_Renewal__c = true;
		accounts1[0].Type = 'Vendor';
		accounts1[0].ParentId = accounts[0].Id;
		
		accounts1[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			accounts1[1].Partner_Type__c = '';
			accounts1[1].Partner_Program__c = '';
		insert accounts1;
		
		//Create Opportunity
		/*opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);*/
		
		opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].End_Customer_LE__c = accounts1[1].Id;
		insert opportunities;
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		accredList[0].Portfolio__c='Fixed Access - FBA';
		accredList[1].Portfolio__c='Fixed Access - FBA';
		insert accredList;
		/***Accreditation ends ***/
		
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		Test.startTest(); 
		/*** proposal creation starts ***/	  
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		testProposal.NokiaCPQ_Portfolio__c = 'Fixed Access - FBA';
		testProposal.Maintenance_Y1__c = 10;
		testProposal.Maintenance_Y2__c = 10;
		testProposal.NokiaCPQ_SSP_Level__c = '';
		testProposal.NokiaCPQ_SRS_Level__c = '';
		testProposal.SRS__c = 10;
		testProposal.SSP__c = 10;
		insert testProposal;
		/*** proposal creation ends***/
	  //}
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], priceListSO, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct;
	  
	  // Add the products to the request
	  for(integer counter =0; counter < 6; counter++){	  
		selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
		selectedProduct.ProductId =productIDList[counter];
		selectedProduct.Quantity = 1;
		selectedProduct.SellingTerm = 1;
		addProductRequest.SelectedProducts.add(selectedProduct);
	  }
	  //add custom fields for one of products
	  addProductRequest.SelectedProducts[0].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true,Apttus_Config2__ListPrice__c=5,Custom_Product_Code__c='SSP' , CustomProductValue__c='100;100;100', Total_ONT_Quantity_FBA__c = 200, Source__c = 'EPT', Apttus_Config2__LineType__c ='Option' );
	  addProductRequest.SelectedProducts[0].CustomFields = new List<string>{'is_Custom_Product__c','Custom_Product_Code__c', 'CustomProductValue__c', 'Total_ONT_Quantity_FBA__c'};//,'Apttus_Config2__LineType__c', 'NokiaCPQ_SSP_Rate__c','Source__c};
		
		addProductRequest.SelectedProducts[1].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true,Apttus_Config2__ListPrice__c=5, CustomProductValue__c='100;100;100', Total_ONT_Quantity_P2P__c = 100,  Apttus_Config2__LineType__c ='Option');
	  addProductRequest.SelectedProducts[1].CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c', 'Total_ONT_Quantity_P2P__c'};
		
		addProductRequest.SelectedProducts[2].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = false,Apttus_Config2__ListPrice__c=5, CustomProductValue__c='100;100;100', Is_Contract_Pricing_2__c = true, Apttus_Config2__Quantity__c = 1,NokiaCPQ_Unitary_IRP__c=1,Nokia_Maint_Y1_Per__c=10, Nokia_Maint_Y2_Per__c=10, Advanced_pricing_done__c = true,  Apttus_Config2__LineType__c ='Option');
	  addProductRequest.SelectedProducts[2].CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c', 'Is_Contract_Pricing_2__c','Apttus_Config2__Quantity__c','NokiaCPQ_Unitary_IRP__c','Nokia_Maint_Y1_Per__c', 'Nokia_Maint_Y2_Per__c', 'Advanced_pricing_done__c' };	 
		
		// Execute the addMultiProducts routine
		Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  //Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c=portFolio;
	  ship.Pricing_Cluster__c='NAM Canada';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  
	  List<Apttus_Config2__LineItem__c> LineItemList = new List<Apttus_Config2__LineItem__c>();		
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(accounts[0], ProdConfig, priceListSO, productList[0],1)[0];
	  LineItem1.Apttus_Config2__AdjustmentAmount__c = 10;
	  LineItem1.Apttus_Config2__PricingStatus__c = 'Pending';
	  LineItemList.add(LineItem1);
	  
	  // create the update price request
	  Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
	  
	  // add request parameters
	  objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
	  
	  // update price for the cart
	  Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
	  Boolean hasPendingItems = result.IsPricePending;
	  
	  system.debug('Is Price Pending...' + hasPendingItems);
	  for(integer i=0;i<6;i++){
		if(hasPendingItems){
		  result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		  hasPendingItems = result.IsPricePending;
		  system.debug('Is Price Pending...' + hasPendingItems);
		}
	  }
	}
	Test.stopTest();
  }
  static testMethod void Indirect1507() {
	IndirectFixedAccess3(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL);
  } 
  static testMethod void IndirectFixedAccessFBA3() {
	IndirectFixedAccess3(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA);
  }
  public static void IndirectFixedAccess3(string portFolio) {
	Nokia_PricingCallBack pcbb = new Nokia_PricingCallBack();
	// pcbb.addPCBtotalCost();
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	//Create Product
	List<Product2> productList =  getProducts(portFolio);
	productList[0].Number_of_GE_Ports__c = 10;
	productList[1].Number_of_GE_Ports__c = 10;
	//set category for Fixed Access FBA
	if(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA == portFolio){
	  productList[0].NokiaCPQ_Category__c = Nokia_CPQ_Constants.NOKIA_PTP;
	  productList[1].NokiaCPQ_Category__c = Nokia_CPQ_Constants.NOKIA_ONT;
	}
	insert productList;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : productList){
	  productIDList.add(productSO.id);
	}
	
	//Create PriceList
	//create price list items
	List<Apttus_Config2__PriceListItem__c> plistItems = getPriceListItems(priceListSO.id, productIDList);
	insert plistItems;
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	
	System.runAs(users[0]) {   
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  System.runAs(userList[0]){
		//Create Account
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
		opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);
		
		//create Accreditation
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		accredList[0].Portfolio__c=portFolio;
		accredList[0].Pricing_Cluster__c='NAM';
		accredList[0].Pricing_Level_Override__c = 'Co-Branded';
		accredList[1].Portfolio__c=portFolio;  
		accredList[1].Pricing_Cluster__c='NAM';
		insert accredList;
		/***Accreditation ends ***/
		
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		
		/*** proposal creation starts ***/	  
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		testProposal.NokiaCPQ_Portfolio__c = 'QTC';
		testProposal.RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();
		testProposal.NokiaCPQ_Existing_IONMaint_Contract__c = ''; 
		testProposal.NokiaCPQ_Maintenance_Type__c ='';
		testProposal.NokiaCPQ_No_of_Years__c='';
		testProposal.NokiaCPQ_SRS_Level__c='';
		testProposal.NokiaCPQ_SSP_Level__c='';
		testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=false;
		testProposal.NokiaCPQ_ION_Maintenance_Type__c='';
		insert testProposal;
		
		testProposal.NokiaCPQ_LEO_Discount__c=false ;
		update testProposal;
		/*** proposal creation ends***/
	  }
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], priceListSO, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct;
	  
	  // Add the products to the request
	  for(integer counter =0; counter < 6; counter++){	  
		selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
		selectedProduct.ProductId =productIDList[counter];
		selectedProduct.Quantity = 1;
		selectedProduct.SellingTerm = 1;
		addProductRequest.SelectedProducts.add(selectedProduct);
	  }
	  //add custom fields for one of products
	  addProductRequest.SelectedProducts[0].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true,Custom_Product_Code__c='SSP' , CustomProductValue__c='100;100;100', Total_ONT_Quantity_FBA__c = 200, Source__c = 'EPT' );
	  addProductRequest.SelectedProducts[0].CustomFields = new List<string>{'is_Custom_Product__c','Custom_Product_Code__c', 'CustomProductValue__c', 'Total_ONT_Quantity_FBA__c'};//,'Apttus_Config2__LineType__c', 'NokiaCPQ_SSP_Rate__c','Source__c};
		
		addProductRequest.SelectedProducts[1].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100', Total_ONT_Quantity_P2P__c = 100);
	  addProductRequest.SelectedProducts[1].CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c', 'Total_ONT_Quantity_P2P__c'};
		
		addProductRequest.SelectedProducts[2].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = false, CustomProductValue__c='100;100;100', Is_Contract_Pricing_2__c = true, Apttus_Config2__Quantity__c = 1,NokiaCPQ_Unitary_IRP__c=1,Nokia_Maint_Y1_Per__c=10, Nokia_Maint_Y2_Per__c=10, Advanced_pricing_done__c = true);
	  addProductRequest.SelectedProducts[2].CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c', 'Is_Contract_Pricing_2__c','Apttus_Config2__Quantity__c','NokiaCPQ_Unitary_IRP__c','Nokia_Maint_Y1_Per__c', 'Nokia_Maint_Y2_Per__c', 'Advanced_pricing_done__c' };
		
		Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c=portFolio;
	  ship.Pricing_Cluster__c='NAM Canada';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  
	  list<Apttus_Config2__LineItem__c> LineItemList = new List<Apttus_Config2__LineItem__c>();
	  
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(accounts[0], ProdConfig, priceListSO, productList[0],1)[0];
	  LineItem1.Apttus_Config2__AdjustmentAmount__c = 10;
	  LineItem1.Apttus_Config2__PricingStatus__c = 'Pending';
	  LineItem1.Apttus_Config2__PriceListId__c = plistItems[0].id;
	  LineItemList.add(LineItem1);
	  
	  // create the update price request
	  Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
	  
	  // add request parameters
	  objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
	  
	  // update price for the cart
	  Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
	  Boolean hasPendingItems = result.IsPricePending;
	  
	  system.debug('Is Price Pending...' + hasPendingItems);
	  for(integer i=0;i<6;i++){
		if(hasPendingItems){
		  result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		  hasPendingItems = result.IsPricePending;
		  system.debug('Is Price Pending...' + hasPendingItems);
		}
	  }
	}
	Test.stopTest();
  }
  static testMethod void direct1500() {
	IndirectFixedAccess4(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL);
  } 
  static testMethod void IndirectFixedAccessFBA4() {
	IndirectFixedAccess4(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA);
  }
  public static void IndirectFixedAccess4(string portFolio) {
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	//Create Product
	List<Product2> productList =  getProducts(portFolio);
	productList[0].Number_of_GE_Ports__c = 10;
	productList[1].Number_of_GE_Ports__c = 10;
	//set category for Fixed Access FBA
	if(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA == portFolio){
	  productList[0].NokiaCPQ_Category__c = Nokia_CPQ_Constants.NOKIA_PTP;
	  productList[1].NokiaCPQ_Category__c = Nokia_CPQ_Constants.NOKIA_ONT;
	}
	insert productList;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : productList){
	  productIDList.add(productSO.id);
	}
	
	//Create PriceList
	//create price list items
	List<Apttus_Config2__PriceListItem__c> plistItems = getPriceListItems(priceListSO.id, productIDList);
	insert plistItems;
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	
	System.runAs(users[0]) {   
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  System.runAs(userList[0]){
		//Create Account
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
		opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		accredList[0].Portfolio__c=portFolio;
		accredList[0].Pricing_Cluster__c='NAM';
		accredList[0].Pricing_Level_Override__c = 'Co-Branded';
		accredList[1].Pricing_Cluster__c='NAM';
		accredList[1].Portfolio__c=portFolio;
		insert accredList;
		/***Accreditation ends ***/
		
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		
		/*** proposal creation starts ***/	  
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		testProposal.NokiaCPQ_Portfolio__c = 'QTC';
		testProposal.RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); 
		testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = false;
		testProposal.NokiaCPQ_Existing_IONMaint_Contract__c = '';
		testProposal.NokiaCPQ_Maintenance_Type__c ='';
		testProposal.NokiaCPQ_No_of_Years__c='';
		testProposal.NokiaCPQ_SRS_Level__c='';
		testProposal.NokiaCPQ_SSP_Level__c='';
		insert testProposal;
		
		testProposal.NokiaCPQ_LEO_Discount__c=false ;
		update testProposal;
		/*** proposal creation ends***/
	  }
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], priceListSO, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct;
	  
	  // Add the products to the request
	  for(integer counter =0; counter < 6; counter++){	  
		selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
		selectedProduct.ProductId =productIDList[counter];
		selectedProduct.Quantity = 1;
		selectedProduct.SellingTerm = 1;
		addProductRequest.SelectedProducts.add(selectedProduct);
	  }
	  //add custom fields for one of products
	  addProductRequest.SelectedProducts[0].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true,Custom_Product_Code__c='SSP' , CustomProductValue__c='100;100;100', Total_ONT_Quantity_FBA__c = 200, Source__c = 'EPT' );
	  addProductRequest.SelectedProducts[0].CustomFields = new List<string>{'is_Custom_Product__c','Custom_Product_Code__c', 'CustomProductValue__c', 'Total_ONT_Quantity_FBA__c'};//,'Apttus_Config2__LineType__c', 'NokiaCPQ_SSP_Rate__c','Source__c};
		
		addProductRequest.SelectedProducts[1].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100', Total_ONT_Quantity_P2P__c = 100);
	  addProductRequest.SelectedProducts[1].CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c', 'Total_ONT_Quantity_P2P__c'};
		
		addProductRequest.SelectedProducts[2].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = false, CustomProductValue__c='100;100;100', Is_Contract_Pricing_2__c = true, Apttus_Config2__Quantity__c = 1,NokiaCPQ_Unitary_IRP__c=1,Nokia_Maint_Y1_Per__c=10, Nokia_Maint_Y2_Per__c=10, Advanced_pricing_done__c = true);
	  addProductRequest.SelectedProducts[2].CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c', 'Is_Contract_Pricing_2__c','Apttus_Config2__Quantity__c','NokiaCPQ_Unitary_IRP__c','Nokia_Maint_Y1_Per__c', 'Nokia_Maint_Y2_Per__c', 'Advanced_pricing_done__c' };
		
		// Execute the addMultiProducts routine
		Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c=portFolio;
	  ship.Pricing_Cluster__c='NAM Canada';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  
	  list<Apttus_Config2__LineItem__c> LineItemList = new List<Apttus_Config2__LineItem__c>();
	  
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(accounts[0], ProdConfig, priceListSO, productList[0],1)[0];
	  LineItem1.Apttus_Config2__AdjustmentAmount__c = 10;
	  LineItem1.Apttus_Config2__PricingStatus__c = 'Pending';
	  LineItem1.Apttus_Config2__PriceListId__c = plistItems[0].id;
	  LineItem1.Apttus_Config2__LineType__c = Nokia_CPQ_Constants.NOKIA_OPTION;
	  LineItemList.add(LineItem1);
	  // create the update price request
	  Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
	  
	  // add request parameters
	  objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
	  
	  // update price for the cart
	  Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
	  Boolean hasPendingItems = result.IsPricePending;
	  
	  system.debug('Is Price Pending...' + hasPendingItems);
	  for(integer i=0;i<6;i++){
		if(hasPendingItems){
		  result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		  hasPendingItems = result.IsPricePending;
		  system.debug('Is Price Pending...' + hasPendingItems);
		}
	  }
	}
	Test.stopTest();
  }
  static testMethod void direct1680() {
	IndirectFixedAccess5(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL);
  } 
  static testMethod void IndirectFixedAccessFBA5() {
	IndirectFixedAccess5(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA);
  }
  public static void IndirectFixedAccess5(string portFolio) {
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	//Create Product
	List<Product2> productList =  getProducts(portFolio);
	productList[0].Number_of_GE_Ports__c = 10;
	productList[1].Number_of_GE_Ports__c = 10;
	//set category for Fixed Access FBA
	if(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA == portFolio){
	  productList[0].NokiaCPQ_Category__c = Nokia_CPQ_Constants.NOKIA_PTP;
	  productList[1].NokiaCPQ_Category__c = Nokia_CPQ_Constants.NOKIA_ONT;
	}
	insert productList;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : productList){
	  productIDList.add(productSO.id);
	}
	
	//Create PriceList
	//create price list items
	List<Apttus_Config2__PriceListItem__c> plistItems = getPriceListItems(priceListSO.id, productIDList);
	insert plistItems;
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	
	System.runAs(users[0]) {   
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  System.runAs(userList[0]){
		//Create Account
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
		opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		accredList[0].Pricing_Cluster__c='NAM';
		accredList[0].Portfolio__c=portFolio;
		accredList[0].Pricing_Level_Override__c = 'Co-Branded';
		accredList[1].Pricing_Cluster__c='NAM';
		accredList[1].Portfolio__c=portFolio;
		insert accredList;
		/***Accreditation ends ***/
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		
		/*** proposal creation starts ***/	  
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		//testProposal.NokiaCPQ_Portfolio__c = 'QTC';
		testProposal.NokiaCPQ_Portfolio__c = 'Nokia Software';
		testProposal.RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); 
		testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = false;		
		testProposal.NokiaCPQ_Maintenance_Type__c='';
		testProposal.NokiaCPQ_No_of_Years__c='';
		testProposal.NokiaCPQ_SSP_Level__c ='';
		testProposal.NokiaCPQ_SRS_Level__c ='';
		testProposal.NokiaCPQ_Existing_IONMaint_Contract__c = '';
		insert testProposal;
		
		 testProposal.NokiaCPQ_LEO_Discount__c=false ;
		 update testProposal;
		
		/*** proposal creation ends***/
	  }
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], priceListSO, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct;
	  
	  // Add the products to the request
	  for(integer counter =0; counter < 6; counter++){	  
		selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
		selectedProduct.ProductId =productIDList[counter];
		selectedProduct.Quantity = 1;
		selectedProduct.SellingTerm = 1;
		addProductRequest.SelectedProducts.add(selectedProduct);
	  }
	  //add custom fields for one of products
	  addProductRequest.SelectedProducts[0].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true,Custom_Product_Code__c='SSP' , CustomProductValue__c='100;100;100', Total_ONT_Quantity_FBA__c = 200, Source__c = 'EPT' );
	  addProductRequest.SelectedProducts[0].CustomFields = new List<string>{'is_Custom_Product__c','Custom_Product_Code__c', 'CustomProductValue__c', 'Total_ONT_Quantity_FBA__c'};//,'Apttus_Config2__LineType__c', 'NokiaCPQ_SSP_Rate__c','Source__c};
		
		addProductRequest.SelectedProducts[1].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100', Total_ONT_Quantity_P2P__c = 100);
	  addProductRequest.SelectedProducts[1].CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c', 'Total_ONT_Quantity_P2P__c'};
		
		addProductRequest.SelectedProducts[2].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = false, CustomProductValue__c='100;100;100', Is_Contract_Pricing_2__c = true, Apttus_Config2__Quantity__c = 1,NokiaCPQ_Unitary_IRP__c=1,Nokia_Maint_Y1_Per__c=10, Nokia_Maint_Y2_Per__c=10, Advanced_pricing_done__c = true);
	  addProductRequest.SelectedProducts[2].CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c', 'Is_Contract_Pricing_2__c','Apttus_Config2__Quantity__c','NokiaCPQ_Unitary_IRP__c','Nokia_Maint_Y1_Per__c', 'Nokia_Maint_Y2_Per__c', 'Advanced_pricing_done__c' };
		
		// Execute the addMultiProducts routine
		Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c=portFolio;
	  ship.Pricing_Cluster__c='NAM Canada';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  
	  list<Apttus_Config2__LineItem__c> LineItemList = new List<Apttus_Config2__LineItem__c>();
	  
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(accounts[0], ProdConfig, priceListSO, productList[0],1)[0];
	  LineItem1.Apttus_Config2__AdjustmentAmount__c = 10;
	  LineItem1.Apttus_Config2__PricingStatus__c = 'Pending';
	  LineItem1.Apttus_Config2__PriceListId__c = plistItems[0].id; 
	  LineItem1.Apttus_Config2__AdjustmentAmount__c = 10;
	  LineItem1.Apttus_Config2__ListPrice__c = 100; 
	  LineItem1.Apttus_Config2__PrimaryLineNumber__c = 1; 
	  LineItem1.Advanced_pricing_done__c = true;
	  //LineItem1.Apttus_Config2__LineType__c = Nokia_CPQ_Constants.NOKIA_OPTION;
	  LineItem1.Apttus_Config2__LineType__c = Nokia_CPQ_Constants.NOKIA_PRODUCT_SERVICES;
	  LineItemList.add(LineItem1);
	  // create the update price request
	  Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
	  
	  // add request parameters
	  objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
	  
	  // update price for the cart
	  Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
	  Boolean hasPendingItems = result.IsPricePending;
	  
	  system.debug('Is Price Pending...' + hasPendingItems);
	  for(integer i=0;i<6;i++){
		if(hasPendingItems){
		  result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		  hasPendingItems = result.IsPricePending;
		  system.debug('Is Price Pending...' + hasPendingItems);
		}
	  }
	}
	Test.stopTest();
  }
  static testMethod void Indirect326() {
	IndirectFixedAccess2(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL);
  } 
  static testMethod void IndirectFixedAccessFBA2() {
	IndirectFixedAccess2(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA);
  }
  public static void IndirectFixedAccess2(string portFolio) {
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	//Create Product
	List<Product2> productList =  getProducts(portFolio);
	productList[0].Number_of_GE_Ports__c = 10;
	productList[1].Number_of_GE_Ports__c = 10;
	//set category for Fixed Access FBA
	if(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA == portFolio){
	  productList[0].NokiaCPQ_Category__c = Nokia_CPQ_Constants.NOKIA_PTP;
	  productList[1].NokiaCPQ_Category__c = Nokia_CPQ_Constants.NOKIA_ONT;
	}
	insert productList;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : productList){
	  productIDList.add(productSO.id);
	}
	
	//Create PriceList
	//create price list items
	List<Apttus_Config2__PriceListItem__c> plistItems = getPriceListItems(priceListSO.id, productIDList);
	insert plistItems;
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	
	System.runAs(users[0]) {   
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  System.runAs(userList[0]){
		//Create Account
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
		/*opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);*/
		
		opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].End_Customer_LE__c = accounts1[0].Id;
		insert opportunities;
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		accredList[0].Portfolio__c=portFolio;
		accredList[0].Pricing_Cluster__c='NAM';
		accredList[1].Portfolio__c=portFolio;
		insert accredList;
		/***Accreditation ends ***/
		
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		
		/*** proposal creation starts ***/	  
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		testProposal.NokiaCPQ_Portfolio__c = portFolio;
		testProposal.Maintenance_Y1__c = 10; 
		testProposal.Maintenance_Y2__c = 10;
		testProposal.SRS__c = 10;
		testProposal.NokiaCPQ_SSP_Level__c='';
		testProposal.SSP__c = null;
		insert testProposal;
		
		testProposal.NokiaCPQ_LEO_Discount__c=false ;
		update testProposal;
		/*** proposal creation ends***/
	  }
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], priceListSO, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct;
	  
	  // Add the products to the request
	  for(integer counter =0; counter < 6; counter++){	  
		selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
		selectedProduct.ProductId =productIDList[counter];
		selectedProduct.Quantity = 1;
		selectedProduct.SellingTerm = 1;
		addProductRequest.SelectedProducts.add(selectedProduct);
	  }
	  //add custom fields for one of products
	  addProductRequest.SelectedProducts[0].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true,Custom_Product_Code__c='SSP' , CustomProductValue__c='100;100;100', Total_ONT_Quantity_FBA__c = 200, Source__c = 'EPT' );
	  addProductRequest.SelectedProducts[0].CustomFields = new List<string>{'is_Custom_Product__c','Custom_Product_Code__c', 'CustomProductValue__c', 'Total_ONT_Quantity_FBA__c'};//,'Apttus_Config2__LineType__c', 'NokiaCPQ_SSP_Rate__c','Source__c};
		
		addProductRequest.SelectedProducts[1].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100', Total_ONT_Quantity_P2P__c = 100);
	  addProductRequest.SelectedProducts[1].CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c', 'Total_ONT_Quantity_P2P__c'};
		
		addProductRequest.SelectedProducts[2].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = false, CustomProductValue__c='100;100;100', Is_Contract_Pricing_2__c = true, Apttus_Config2__Quantity__c = 1,NokiaCPQ_Unitary_IRP__c=1,Nokia_Maint_Y1_Per__c=10, Nokia_Maint_Y2_Per__c=10, Advanced_pricing_done__c = true);
	  addProductRequest.SelectedProducts[2].CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c', 'Is_Contract_Pricing_2__c','Apttus_Config2__Quantity__c','NokiaCPQ_Unitary_IRP__c','Nokia_Maint_Y1_Per__c', 'Nokia_Maint_Y2_Per__c', 'Advanced_pricing_done__c' };
		
		// Execute the addMultiProducts routine
		Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c=portFolio;
	  ship.Pricing_Cluster__c='NAM Canada';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  
	  
	  // create the update price request
	  Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
	  
	  // add request parameters
	  objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
	  
	  // update price for the cart
	  Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
	  Boolean hasPendingItems = result.IsPricePending;
	  
	  system.debug('Is Price Pending...' + hasPendingItems);
	  for(integer i=0;i<6;i++){
		if(hasPendingItems){
		  result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		  hasPendingItems = result.IsPricePending;
		  system.debug('Is Price Pending...' + hasPendingItems);
		}
	  }
	}
	Test.stopTest();
  }
  static testMethod void Indirect804() {
	IndirectFixedAccess1(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL);
  } 
  static testMethod void IndirectFixedAccessFBA1() {
	IndirectFixedAccess1(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA);
  }
  public static void IndirectFixedAccess1(string portFolio) {
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	//Create Product
	List<Product2> productList =  getProducts(portFolio);
	productList[0].Number_of_GE_Ports__c = 10;
	productList[1].Number_of_GE_Ports__c = 10;
	//set category for Fixed Access FBA
	if(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA == portFolio){
	  productList[0].NokiaCPQ_Category__c = Nokia_CPQ_Constants.NOKIA_PTP;
	  productList[1].NokiaCPQ_Category__c = Nokia_CPQ_Constants.NOKIA_ONT;
	}
	insert productList;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : productList){
	  productIDList.add(productSO.id);
	}
	
	//Create PriceList
	//create price list items
	List<Apttus_Config2__PriceListItem__c> plistItems = getPriceListItems(priceListSO.id, productIDList);
	insert plistItems;

	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	System.runAs(users[0]) {   
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  System.runAs(userList[0]){
		//Create Account
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
		/*opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);*/
		
		opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].End_Customer_LE__c = accounts1[0].Id;
		insert opportunities;
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		accredList[0].Portfolio__c=portFolio;
		accredList[0].Pricing_Cluster__c='NAM';
		accredList[0].Pricing_Level_Override__c = 'Co-Branded';
		accredList[1].Portfolio__c=portFolio;
		accredList[1].Pricing_Cluster__c='NAM';
		insert accredList;
		/***Accreditation ends ***/
		
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		
		/*** proposal creation starts ***/	  
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		testProposal.NokiaCPQ_Portfolio__c = portFolio;
		testProposal.Maintenance_Y1__c = 10;
		testProposal.Maintenance_Y2__c = 10;
		testProposal.NokiaCPQ_SSP_Level__c = '';
		testProposal.NokiaCPQ_SRS_Level__c = '';
		testProposal.NokiaCPQ_LEO_Discount__c=true;
		testProposal.SRS__c = null;
		testProposal.SSP__c = null;
		insert testProposal;
		
		testProposal.NokiaCPQ_LEO_Discount__c=true ;
		update testProposal;
		/*** proposal creation ends***/
	  }
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], priceListSO, testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct;
	  
	  // Add the products to the request
	  for(integer counter =0; counter < 6; counter++){	  
		selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
		selectedProduct.ProductId =productIDList[counter];
		selectedProduct.Quantity = 1;
		selectedProduct.SellingTerm = 1;
		addProductRequest.SelectedProducts.add(selectedProduct);
	  }
	  //add custom fields for one of products
	  addProductRequest.SelectedProducts[0].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true,Custom_Product_Code__c='SSP' , CustomProductValue__c='100;100;100', Total_ONT_Quantity_FBA__c = 200, Source__c = 'EPT' );
	  addProductRequest.SelectedProducts[0].CustomFields = new List<string>{'is_Custom_Product__c','Custom_Product_Code__c', 'CustomProductValue__c', 'Total_ONT_Quantity_FBA__c'};//,'Apttus_Config2__LineType__c', 'NokiaCPQ_SSP_Rate__c','Source__c};
		
		addProductRequest.SelectedProducts[1].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100', Total_ONT_Quantity_P2P__c = 100);
	  addProductRequest.SelectedProducts[1].CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c', 'Total_ONT_Quantity_P2P__c'};
		
		addProductRequest.SelectedProducts[2].CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = false, CustomProductValue__c='100;100;100', Is_Contract_Pricing_2__c = true, Apttus_Config2__Quantity__c = 1,NokiaCPQ_Unitary_IRP__c=1,Nokia_Maint_Y1_Per__c=10, Nokia_Maint_Y2_Per__c=10, Advanced_pricing_done__c = true);
	  addProductRequest.SelectedProducts[2].CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c', 'Is_Contract_Pricing_2__c','Apttus_Config2__Quantity__c','NokiaCPQ_Unitary_IRP__c','Nokia_Maint_Y1_Per__c', 'Nokia_Maint_Y2_Per__c', 'Advanced_pricing_done__c' };
		
		// Execute the addMultiProducts routine
		Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c=portFolio;
	  ship.Pricing_Cluster__c='NAM Canada';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  
	  
	  // create the update price request
	  Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
	  
	  // add request parameters
	  objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
	  
	  // update price for the cart
	  Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
	  Boolean hasPendingItems = result.IsPricePending;
	  
	  system.debug('Is Price Pending...' + hasPendingItems);
	  for(integer i=0;i<6;i++){
		if(hasPendingItems){
		  result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		  hasPendingItems = result.IsPricePending;
		  system.debug('Is Price Pending...' + hasPendingItems);
		}
	  }
	}
	Test.stopTest();
  }
  static testMethod void DirectMethod1471() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	
	
	System.runAs(users[0]) {
	  List<Account> accountsNew = new List<Account>();
	  Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	  accLegalEntity.AccountNumber='101234567';
	  accLegalEntity.Acc_No__c = '101234567';
	  accLegalEntity.GeoLevel1Id__c = 'RG_NAM';
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  accountsNew.add(accLegalEntity);
	  
	  Account account = TestDataFactory.createAccount(1)[0];
	  account.AccountNumber='3011234567';
	  account.Acc_No__c = '3011234567';
	  account.GeoLevel1Id__c = 'RG_NAM';
	  account.Active__c= true;
	  accountsNew.add(account);
	  
	  insert accountsNew;
	  
	  List<Account> accounts=new List<Account>();
	  accounts.add(account);
	  
	  //Create Opportunity
	  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
	  opportunities.get(0).Lead_BG__c = 'MN';
	  opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities.get(0).Account_Role__c = 'Alliance Partner';
	  insert opportunities.get(0);
	  
	  /*** Product Creation starts ***/
	  List<Product2> prods = new List<Product2>();
	  
	  //Product#1
	  Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod1.Portfolio__c = 'Airscale Wifi';
	  prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod1.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod1);
	  
	  //Product#2
	  Product2 prod2 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod2.ProductCode = 'MT001'; 
	  prod2.Portfolio__c = 'IP Routing';
	  prod2.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod2);
	  
	  //Product#3
	  Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod3.Portfolio__c = 'Airscale Wifi';
	  prod3.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod3);
	  
	  //Product#4
	  Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod5.ProductCode = 'MT002';
	  prod5.Portfolio__c = 'IP Routing'; 
	  prods.add(prod5); 
	  
	  //Product#5
	  Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod6.ProductCode = '123Arcadia';
	  prod6.Portfolio__c = 'Airscale Wifi';
	  prod6.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod6.NokiaCPQ_Item_Type__c='Hardware';
	  prod6.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod6); 
	  
	  //Product#6
	  Product2 prod7 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod7.ProductCode = 'Arcadia2';
	  prod7.Portfolio__c = 'Airscale Wifi';
	  prod7.NokiaCPQ_Item_Type__c='Hardware';
	  prod7.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod7); 
	  
	  //Product#7
	  Product2 prod8 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod8.ProductCode = '12678';
	  prod8.Portfolio__c = 'Airscale Wifi';
	  prod8.NokiaCPQ_Item_Type__c='Hardware';
	  prod8.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod8);
	  insert prods;
	  
	  /*** Product Creation ends ***/
	  //Create PriceList
	  Test.startTest();
	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
	  );
	  insert ApttusTestPriceList;
	  
	  /*** PriceList Item Creation starts ***/
	  List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	  //PLI#1
	  Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	  plistItems.add(pLI1);
	  
	  //PLI#2
	  Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	  pLI2.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	  plistItems.add(pLI2);
	  
	  //PLI#3
	  Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	  pLI3.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI3.Apttus_Config2__ContractPrice__c = 100;
	  plistItems.add(pLI3);
	  
	  //PLI#4
	  Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	  pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	  plistItems.add(pLI5);
	  
	  //PLI#5
	  Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	  pLI6.Apttus_Config2__ContractPrice__c = 100;
	  pLI6.Apttus_Config2__PriceIncludedInBundle__c = false;
	  plistItems.add(pLI6);
	  
	  //PLI#6
	  Apttus_Config2__PriceListItem__c pLI7 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];	  
	  pLI7.Apttus_Config2__ProductId__c = prod7.Id;
	  pLI7.Apttus_Config2__ContractPrice__c = 100;
	  pLI7.Apttus_Config2__PriceIncludedInBundle__c = false;
	  plistItems.add(pLI7);
	  
	  //PLI#7
	  Apttus_Config2__PriceListItem__c pLI8 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI8.Apttus_Config2__ProductId__c = prod8.Id;
	  pLI8.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI8.Apttus_Config2__ContractPrice__c = 100;
	  plistItems.add(pLI8);
	  insert plistItems;
	  /*** PriceList Item ends ***/
	  /*** proposal creation starts ***/	  
	  Apttus_Proposal__Proposal__c testProposal = TestDataSetup.creatProposal(opportunities[0], accounts[0], ApttusTestPriceList);
	  testProposal.Sold_To_Party__c = accLegalEntity.id;
	  testProposal.Apttus_Proposal__Account__c=accLegalEntity.id;
	  testProposal.NokiaCPQ_Portfolio__c = 'Airscale Wifi';
	  testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	  testProposal.NokiaCPQ_Existing_IONMaint_Contract__c='No';
	  //testProposal.NokiaCPQ_Existing_IONMaint_Contract__c='Yes';
	  testProposal.NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced Emergency';
	  insert testProposal;
	  /*** proposal creation Ends ***/
	  
	  //create product configuration
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], ApttusTestPriceList,testProposal);
	  insert ProdConfig;
	  /*** product configuration creation Ends***/
	  
	  /*** Line Item Starts***/
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	  
	  //Line Item#1
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem1.Apttus_Config2__PriceListItemId__c = pLI1.id;
	  LineItem1.Apttus_Config2__ItemSequence__c = 1;
	  LineItem1.Apttus_Config2__BasePriceOverride__c=120;
	  LineItem1.Apttus_Config2__BasePrice__c=100;
	  LineItem1.Source__c='';
	  LineItem1.NokiaCPQ_Unitary_IRP__c = 300;
	  LineItem1.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem1.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem1.NokiaCPQ_Product_Type__c='Controller';
	  allLineItems.add(LineItem1);
	  
	  //Line Item#2
	  Apttus_Config2__LineItem__c lineItem3 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem3.Apttus_Config2__ItemSequence__c = 2;	  
	  lineItem3.Apttus_Config2__OptionId__c = prod6.Id;
	  lineItem3.Apttus_Config2__PriceListItemId__c = pLI6.id;
	  lineItem3.NokiaCPQ_Product_Type__c = 'Access Point';
	  lineItem3.Apttus_Config2__AdjustmentType__c = '% Discount';
	  lineItem3.Apttus_Config2__BasePriceOverride__c=120;
	  lineItem3.Apttus_Config2__ListPrice__c = 300;
	  lineItem3.NokiaCPQ_Unitary_IRP__c = 1300;
	  lineItem3.Apttus_Config2__BasePrice__c=300;
	  lineItem3.Apttus_Config2__AdjustmentAmount__c = 10;
	  allLineItems.add(lineItem3);
	  
	  //Line Item#3
	  Apttus_Config2__LineItem__c lineItem4 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem4.Apttus_Config2__ItemSequence__c = 3;
	  lineItem4.Apttus_Config2__ProductId__c = prod2.Id;
	  lineItem4.Apttus_Config2__ListPrice__c = 120;
	  lineItem4.Apttus_Config2__BasePriceOverride__c=120;
	  lineItem4.Apttus_Config2__PriceListItemId__c = pLI2.id;	 
	  lineItem4.Apttus_Config2__PriceIncludedInBundle__c = true;
	  lineItem4.Apttus_Config2__ChargeType__c= 'Year 1 Maintenance'; 
	  lineItem4.Apttus_Config2__LineType__c = 'Product/Service';
	  lineItem4.NokiaCPQ_Unitary_IRP__c = 400;
	  allLineItems.add(lineItem4);
	  
	  //Line Item#4
	  Apttus_Config2__LineItem__c lineItem5 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem5.Apttus_Config2__ItemSequence__c = 4;
	  lineItem5.Apttus_Config2__ProductId__c = prod5.Id;
	  lineItem5.Apttus_Config2__PriceListItemId__c = pLI5.id;
	  lineItem5.Apttus_Config2__PriceIncludedInBundle__c = true;
	  lineItem5.Apttus_Config2__LineType__c = 'Product/Service';
	  lineItem5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	  lineItem5.NokiaCPQ_Maint_Yr1_Extended_Price__c =  100;
	  lineItem5.NokiaCPQ_Unitary_IRP__c = 300;
	  allLineItems.add(lineItem5);
	  
	  //Line Item#5	   
	  Apttus_Config2__LineItem__c lineItem6 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem6.Apttus_Config2__ItemSequence__c = 5;
	  lineItem6.Apttus_Config2__OptionId__c = prod3.Id;
	  lineItem6.Apttus_Config2__PriceListItemId__c = pLI3.id;
	  lineItem6.Apttus_Config2__ProductId__c = prod6.Id;
	  lineItem6.Apttus_Config2__ParentBundleNumber__c = 2;
	  lineItem6.NokiaCPQ_Unitary_IRP__c= 300;
	  allLineItems.add(lineItem6);
	  
	  //Line Item#6
	  Apttus_Config2__LineItem__c LineItem7 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem7.Apttus_Config2__ItemSequence__c = 6;
	  LineItem7.Apttus_Config2__OptionId__c = prod7.Id;
	  LineItem7.Apttus_Config2__ProductId__c = prod1.Id;
	  LineItem7.Apttus_Config2__PriceListItemId__c = pLI7.id;
	  LineItem7.Apttus_Config2__AdjustmentType__c = 'Discount Amount';
	  LineItem7.Apttus_Config2__AdjustmentAmount__c = 100;
	  LineItem7.NokiaCPQ_Product_Type__c = 'Controller';
	  allLineItems.add(LineItem7);
	  
	  //Line Item#7
	  Apttus_Config2__LineItem__c LineItem8 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem8.Apttus_Config2__ItemSequence__c = 2;
	  LineItem8.Apttus_Config2__OptionId__c = prod8.Id;
	  LineItem8.Apttus_Config2__ProductId__c = prod6.Id;
	  LineItem8.Apttus_Config2__PriceListItemId__c = pLI8.id;
	  LineItem8.NokiaCPQ_Product_Type__c = 'Third Party Wavespot';
	  LineItem8.NokiaCPQ_Unitary_IRP__c = 600;
	  allLineItems.add(LineItem8);
	  
	  insert allLineItems;
	  /*** Line Item Ends***/
	  
	  //Test.startTest(); 
	  
	  Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
	  
	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.finish();
	  Nokia_PricingCallBack.calculateEquivalentPrice(allLineItems, 'Market India');
	  
	  testProposal.NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced';
	  update testProposal;
	  
	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	 
	Test.stopTest();	 
	}
  }
  static testMethod void DirectMethod1528() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	//List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	
	System.runAs(users[0]) {	  
	  List<Account> accountsNew = new List<Account>();
	  Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	  accLegalEntity.AccountNumber='101234567';
	  accLegalEntity.Acc_No__c = '101234567';
	  accLegalEntity.GeoLevel1Id__c = 'RG_NAM';
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  accountsNew.add(accLegalEntity);
	  
	  Account account = TestDataFactory.createAccount(1)[0];
	  account.AccountNumber='3011234567';
	  account.Acc_No__c = '3011234567';
	  account.GeoLevel1Id__c = 'RG_NAM';
	  account.Active__c= true;
	  accountsNew.add(account);
	  
	  insert accountsNew;
	  
	  
	  List<Account> accounts=new List<Account>();
	  accounts.add(account);
	  
	  //Create Opportunity
	  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
	  opportunities.get(0).Lead_BG__c = 'MN';
	  opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities.get(0).Account_Role__c = 'Alliance Partner';
	  insert opportunities.get(0);
	  
	  /*** Product Creation starts ***/
	  List<Product2> prods = new List<Product2>();
	  
	  //Product#1
	  Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod1.Portfolio__c = 'Airscale Wifi';
	  prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod1.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod1);
	  
	  //Product#2
	  Product2 prod2 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod2.ProductCode = 'MT001'; 
	  prod2.Portfolio__c = 'IP Routing';
	  prod2.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod2);
	  
	  //Product#3
	  Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod3.Portfolio__c = 'Airscale Wifi';
	  prod3.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod3);
	  
	  //Product#4
	  Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod5.ProductCode = 'MT002';
	  prod5.Portfolio__c = 'IP Routing'; 
	  prods.add(prod5); 
	  
	  //Product#5
	  Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod6.ProductCode = '123Arcadia';
	  prod6.Portfolio__c = 'Airscale Wifi';
	  prod6.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod6.NokiaCPQ_Item_Type__c='Hardware';
	  prod6.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod6); 
	  
	  //Product#6
	  Product2 prod7 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod7.ProductCode = 'Arcadia2';
	  prod7.Portfolio__c = 'Airscale Wifi';
	  prod7.NokiaCPQ_Item_Type__c='Hardware';
	  prod7.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod7); 
	  
	  //Product#7
	  Product2 prod8 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod8.ProductCode = '12678';
	  prod8.Portfolio__c = 'Airscale Wifi';
	  prod8.NokiaCPQ_Item_Type__c='Hardware';
	  prod8.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod8);
	  insert prods;
	  
	  /*** Product Creation ends ***/
	  //Create PriceList
	  
	  Test.startTest();
	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
	  );
	  insert ApttusTestPriceList;
	  
	  /*** PriceList Item Creation starts ***/
	  List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	  //PLI#1
	  Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	  plistItems.add(pLI1);
	  
	  //PLI#2
	  Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	  pLI2.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	  plistItems.add(pLI2);
	  
	  //PLI#3
	  Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	  pLI3.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI3.Apttus_Config2__ContractPrice__c = 100;
	  plistItems.add(pLI3);
	  
	  //PLI#4
	  Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	  pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	  plistItems.add(pLI5);
	  
	  //PLI#5
	  Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	  pLI6.Apttus_Config2__ContractPrice__c = 100;
	  pLI6.Apttus_Config2__PriceIncludedInBundle__c = false;
	  plistItems.add(pLI6);
	  
	  //PLI#6
	  Apttus_Config2__PriceListItem__c pLI7 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];	  
	  pLI7.Apttus_Config2__ProductId__c = prod7.Id;
	  pLI7.Apttus_Config2__ContractPrice__c = 100;
	  pLI7.Apttus_Config2__PriceIncludedInBundle__c = false;
	  plistItems.add(pLI7);
	  
	  //PLI#7
	  Apttus_Config2__PriceListItem__c pLI8 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI8.Apttus_Config2__ProductId__c = prod8.Id;
	  pLI8.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI8.Apttus_Config2__ContractPrice__c = 100;
	  plistItems.add(pLI8);
	  insert plistItems;
	  /*** PriceList Item ends ***/
	  
	  Apttus_Proposal__Proposal__c testProposal = TestDataSetup.creatProposal(opportunities[0], accounts[0], ApttusTestPriceList);
	  testProposal.Sold_To_Party__c = accLegalEntity.id;
	  testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	  testProposal.Apttus_Proposal__Account__c=accLegalEntity.id; 
	  testProposal.NokiaCPQ_Portfolio__c = 'Airscale Wifi';
	  testProposal.NokiaCPQ_No_of_Years__c = '2';
	  testProposal.NokiaCPQ_Existing_IONMaint_Contract__c='No';
	  testProposal.NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced Emergency';
	  insert testProposal;
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], ApttusTestPriceList,testProposal);
	  insert ProdConfig;
	  /*** product configuration Ends***/
	  
	  //Line Item
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	  
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem1.Apttus_Config2__PriceListItemId__c = pLI1.id;
	  LineItem1.Apttus_Config2__ItemSequence__c = 1;
	  LineItem1.Source__c='';
	  LineItem1.NokiaCPQ_Unitary_IRP__c = 300;
	  LineItem1.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem1.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem1.NokiaCPQ_Product_Type__c='Controller';
	  allLineItems.add(LineItem1);
	  
	  insert allLineItems;
	  
	  //Test.startTest(); 
	  Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
	  
	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.finish();
	  Nokia_PricingCallBack.calculateEquivalentPrice(allLineItems, 'Market India');
	  
	  testProposal.NokiaCPQ_No_of_Years__c = '2';
	  testProposal.NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced';
	  update testProposal;
	  
	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	
	Test.stopTest();
	}
  }
  static testMethod void DirectMethod1502() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	
	
	System.runAs(users[0]) {
	  
	  List<Account> accountsNew = new List<Account>();
	  Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	  accLegalEntity.AccountNumber='101234567';
	  accLegalEntity.Acc_No__c = '101234567';
	  accLegalEntity.GeoLevel1Id__c = 'RG_NAM';
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  accountsNew.add(accLegalEntity);
	  
	  Account account = TestDataFactory.createAccount(1)[0];
	  account.AccountNumber='3011234567';
	  account.Acc_No__c = '3011234567';
	  account.GeoLevel1Id__c = 'RG_NAM';
	  account.Active__c= true;
	  accountsNew.add(account);
	  
	  insert accountsNew;
	  
	  List<Account> accounts=new List<Account>();
	  accounts.add(account);
	  
	  //Create Opportunity
	  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
	  opportunities.get(0).Lead_BG__c = 'MN';
	  opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities.get(0).Account_Role__c = 'Alliance Partner';
	  insert opportunities.get(0);
	  
	  /*** Product Creation starts ***/
	  List<Product2> prods = new List<Product2>();
	  
	  //Product#1
	  Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod1.Portfolio__c = 'Airscale Wifi';
	  prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod1.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod1);
	  
	  //Product#2
	  Product2 prod2 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod2.ProductCode = 'MT001'; 
	  prod2.Portfolio__c = 'IP Routing';
	  prod2.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod2);
	  
	  //Product#3
	  Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod3.Portfolio__c = 'Airscale Wifi';
	  prod3.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod3);
	  
	  //Product#4
	  Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod5.ProductCode = 'MT002';
	  prod5.Portfolio__c = 'IP Routing'; 
	  prods.add(prod5); 
	  
	  //Product#5
	  Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod6.ProductCode = '123Arcadia';
	  prod6.Portfolio__c = 'Airscale Wifi';
	  prod6.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod6.NokiaCPQ_Item_Type__c='Hardware';
	  prod6.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod6); 
	  
	  //Product#6
	  Product2 prod7 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod7.ProductCode = 'Arcadia2';
	  prod7.Portfolio__c = 'Airscale Wifi';
	  prod7.NokiaCPQ_Item_Type__c='Hardware';
	  prod7.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod7); 
	  
	  //Product#7
	  Product2 prod8 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod8.ProductCode = '12678';
	  prod8.Portfolio__c = 'Airscale Wifi';
	  prod8.NokiaCPQ_Item_Type__c='Hardware';
	  prod8.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod8);
	  insert prods;	   
	  /*** Product ends ***/
	  //Create PriceList
	  
	  Test.startTest();
	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
	  );
	  insert ApttusTestPriceList;
	  
	  /*** PriceList Item Creation starts ***/
	  List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	  //PLI#1
	  Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	  plistItems.add(pLI1);
	  
	  //PLI#2
	  Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	  pLI2.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	  plistItems.add(pLI2);
	  
	  //PLI#3
	  Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	  pLI3.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI3.Apttus_Config2__ContractPrice__c = 100;
	  plistItems.add(pLI3);
	  
	  //PLI#4
	  Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	  pLI5.Apttus_Config2__ListPrice__c = 100;
	  pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	  plistItems.add(pLI5);
	  
	  //PLI#5
	  Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	  pLI6.Apttus_Config2__ContractPrice__c = 100;
	  pLI6.Apttus_Config2__PriceIncludedInBundle__c = false;
	  plistItems.add(pLI6);
	  
	  //PLI#6
	  Apttus_Config2__PriceListItem__c pLI7 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];	  
	  pLI7.Apttus_Config2__ProductId__c = prod7.Id;
	  pLI7.Apttus_Config2__ContractPrice__c = 100;
	  pLI7.Apttus_Config2__PriceIncludedInBundle__c = false;
	  plistItems.add(pLI7);
	  
	  //PLI#7
	  Apttus_Config2__PriceListItem__c pLI8 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI8.Apttus_Config2__ProductId__c = prod8.Id;
	  pLI8.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI8.Apttus_Config2__ContractPrice__c = 100;
	  plistItems.add(pLI8);
	  insert plistItems;
	  /*** PriceList Item ends ***/
	  
	  /*** proposal creation starts ***/	  
	  Apttus_Proposal__Proposal__c testProposal = TestDataSetup.creatProposal(opportunities[0], accounts[0], ApttusTestPriceList);
	  testProposal.Sold_To_Party__c = accLegalEntity.id;
	  testProposal.Apttus_Proposal__Account__c=accLegalEntity.id;
	  testProposal.NokiaCPQ_No_of_Years__c = '2';
	  testProposal.NokiaCPQ_Portfolio__c = 'Airscale Wifi';
	  testProposal.NokiaCPQ_Existing_IONMaint_Contract__c='No';
	  testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	  testProposal.NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced Emergency';
	  insert testProposal;
	  /*** proposal creation Ends ***/
	  system.debug('testProposal:'+testProposal);
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], ApttusTestPriceList,testProposal);
	  insert ProdConfig;
	  /*** product configuration Ends***/
	  
	  /*** Line Item Starts***/
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	  
	  //Line Item#1
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem1.Apttus_Config2__PriceListItemId__c = pLI1.id;
	  LineItem1.Apttus_Config2__ItemSequence__c = 1;
	  LineItem1.Source__c='';
	  LineItem1.NokiaCPQ_Unitary_IRP__c = 300;
	  LineItem1.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem1.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem1.NokiaCPQ_Product_Type__c='Controller';
	  allLineItems.add(LineItem1);
	  
	  //Line Item#2
	  Apttus_Config2__LineItem__c lineItem3 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem3.Apttus_Config2__ItemSequence__c = 2;	  
	  lineItem3.Apttus_Config2__OptionId__c = prod6.Id;
	  lineItem3.Apttus_Config2__PriceListItemId__c = pLI6.id;
	  lineItem3.NokiaCPQ_Product_Type__c = 'Access Point';
	  lineItem3.Apttus_Config2__AdjustmentType__c = '% Discount';
	  lineItem3.Apttus_Config2__AdjustmentAmount__c = 10;
	  allLineItems.add(lineItem3);
	  
	  //Line Item#3
	  Apttus_Config2__LineItem__c lineItem4 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem4.Apttus_Config2__ItemSequence__c = 3;
	  lineItem4.Apttus_Config2__ProductId__c = prod2.Id;
	  lineItem4.Apttus_Config2__PriceListItemId__c = pLI2.id;	 
	  lineItem4.Apttus_Config2__PriceIncludedInBundle__c = true;
	  lineItem4.Apttus_Config2__ChargeType__c= 'Year 1 Maintenance'; 
	  lineItem4.Apttus_Config2__LineType__c = 'Product/Service';
	  lineItem4.NokiaCPQ_Unitary_IRP__c = 400;
	  allLineItems.add(lineItem4);
	  
	  //Line Item#4
	  Apttus_Config2__LineItem__c lineItem5 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem5.Apttus_Config2__ItemSequence__c = 4;
	  lineItem5.Apttus_Config2__ProductId__c = prod5.Id;
	  lineItem5.Apttus_Config2__PriceListItemId__c = pLI5.id;
	  lineItem5.Apttus_Config2__PriceIncludedInBundle__c = true;
	  lineItem5.Apttus_Config2__LineType__c = 'Product/Service';
	  lineItem5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	  lineItem5.NokiaCPQ_Maint_Yr1_Extended_Price__c =  100;
	  lineItem5.NokiaCPQ_Unitary_IRP__c = 300;
	  allLineItems.add(lineItem5);
	  
	  //Line Item#5	   
	  Apttus_Config2__LineItem__c lineItem6 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem6.Apttus_Config2__ItemSequence__c = 5;
	  lineItem6.Apttus_Config2__OptionId__c = prod3.Id;
	  lineItem6.Apttus_Config2__PriceListItemId__c = pLI3.id;
	  lineItem6.Apttus_Config2__ProductId__c = prod6.Id;
	  lineItem6.Apttus_Config2__ParentBundleNumber__c = 2;
	  lineItem6.NokiaCPQ_Unitary_IRP__c= 300;
	  allLineItems.add(lineItem6);
	  
	  //Line Item#6
	  Apttus_Config2__LineItem__c LineItem7 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem7.Apttus_Config2__ItemSequence__c = 6;
	  LineItem7.Apttus_Config2__OptionId__c = prod7.Id;
	  LineItem7.Apttus_Config2__ProductId__c = prod1.Id;
	  LineItem7.Apttus_Config2__PriceListItemId__c = pLI7.id;
	  LineItem7.Apttus_Config2__AdjustmentType__c = 'Discount Amount';
	  LineItem7.Apttus_Config2__AdjustmentAmount__c = 100;
	  LineItem7.NokiaCPQ_Product_Type__c = 'Controller';
	  allLineItems.add(LineItem7);
	  
	  //Line Item#7
	  Apttus_Config2__LineItem__c LineItem8 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem8.Apttus_Config2__ItemSequence__c = 2;
	  LineItem8.Apttus_Config2__OptionId__c = prod8.Id;
	  LineItem8.Apttus_Config2__ProductId__c = prod6.Id;
	  LineItem8.Apttus_Config2__PriceListItemId__c = pLI8.id;
	  LineItem8.NokiaCPQ_Product_Type__c = 'Third Party Wavespot';
	  LineItem8.NokiaCPQ_Unitary_IRP__c = 600;
	  allLineItems.add(LineItem8);
	  
	  insert allLineItems;
	  /*** Line Item Ends***/
	  
	  //Test.startTest(); 
	  
	  Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
	  
	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.finish();
	  Nokia_PricingCallBack.calculateEquivalentPrice(allLineItems, 'Market India');
	  
	  testProposal.NokiaCPQ_No_of_Years__c = '2';
	  testProposal.NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced';
	  update testProposal;
	  
	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	
	Test.stopTest();
	}
  }
  static testMethod void DirectMethod1483() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	
	System.runAs(users[0]) {
	  
	  List<Account> accountsNew = new List<Account>();
	  Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	  accLegalEntity.AccountNumber='101234567';
	  accLegalEntity.Acc_No__c = '101234567';
	  accLegalEntity.GeoLevel1Id__c = 'RG_NAM';
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  accountsNew.add(accLegalEntity);
	  
	  Account account = TestDataFactory.createAccount(1)[0];
	  account.AccountNumber='3011234567';
	  account.Acc_No__c = '3011234567';
	  account.GeoLevel1Id__c = 'RG_NAM';
	  account.Active__c= true;
	  accountsNew.add(account);
	  
	  insert accountsNew;
	  
	  List<Account> accounts=new List<Account>();
	  accounts.add(account);
	  
	  //Create Opportunity
	  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
	  opportunities.get(0).Lead_BG__c = 'MN';
	  opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities.get(0).Account_Role__c = 'Alliance Partner';
	  insert opportunities.get(0);
	  
	  /*** Product Creation starts ***/
	  List<Product2> prods = new List<Product2>();
	  
	  //Product#1
	  Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod1.Portfolio__c = 'Airscale Wifi';
	  prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod1.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod1);
	  
	  //Product#2
	  Product2 prod2 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod2.ProductCode = 'MT001'; 
	  prod2.Portfolio__c = 'IP Routing';
	  prod2.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod2);
	  
	  //Product#3
	  Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod3.Portfolio__c = 'Airscale Wifi';
	  prod3.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod3);
	  
	  //Product#4
	  Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod5.ProductCode = 'MT002';
	  prod5.Portfolio__c = 'IP Routing'; 
	  prods.add(prod5); 
	  
	  //Product#5
	  Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod6.ProductCode = '123Arcadia';
	  prod6.Portfolio__c = 'Airscale Wifi';
	  prod6.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod6.NokiaCPQ_Item_Type__c='Hardware';
	  prod6.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod6); 
	  
	  //Product#6
	  Product2 prod7 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod7.ProductCode = 'Arcadia2';
	  prod7.Portfolio__c = 'Airscale Wifi';
	  prod7.NokiaCPQ_Item_Type__c='Hardware';
	  prod7.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod7); 
	  
	  //Product#7
	  Product2 prod8 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod8.ProductCode = '12678';
	  prod8.Portfolio__c = 'Airscale Wifi';
	  prod8.NokiaCPQ_Item_Type__c='Hardware';
	  prod8.NokiaCPQ_Classification2__c='Base'; 
	  prods.add(prod8);
	  insert prods;	   
	  /*** Product ends ***/
	  //Create PriceList
	  
	  Test.startTest();
	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
	  );
	  insert ApttusTestPriceList;
	  
	  /*** PriceList Item Creation starts ***/
	  List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	  //PLI#1
	  Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	  plistItems.add(pLI1);
	  
	  //PLI#2
	  Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	  pLI2.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	  plistItems.add(pLI2);
	  
	  //PLI#3
	  Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	  pLI3.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI3.Apttus_Config2__ContractPrice__c = 100;
	  plistItems.add(pLI3);
	  
	  //PLI#4
	  Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	  pLI5.Apttus_Config2__ListPrice__c = 100;
	  pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	  plistItems.add(pLI5);
	  
	  //PLI#5
	  Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	  pLI6.Apttus_Config2__ContractPrice__c = 100;
	  pLI6.Apttus_Config2__PriceIncludedInBundle__c = false;
	  plistItems.add(pLI6);
	  
	  //PLI#6
	  Apttus_Config2__PriceListItem__c pLI7 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];	  
	  pLI7.Apttus_Config2__ProductId__c = prod7.Id;
	  pLI7.Apttus_Config2__ContractPrice__c = 100;
	  pLI7.Apttus_Config2__PriceIncludedInBundle__c = false;
	  plistItems.add(pLI7);
	  
	  //PLI#7
	  Apttus_Config2__PriceListItem__c pLI8 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI8.Apttus_Config2__ProductId__c = prod8.Id;
	  pLI8.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI8.Apttus_Config2__ContractPrice__c = 100;
	  plistItems.add(pLI8);
	  insert plistItems;
	  /*** PriceList Item ends ***/
	  
	  /*** proposal creation starts ***/	  
	  Apttus_Proposal__Proposal__c testProposal = TestDataSetup.creatProposal(opportunities[0], accounts[0], ApttusTestPriceList);
	  testProposal.Sold_To_Party__c = accLegalEntity.id;
	  testProposal.Apttus_Proposal__Account__c=accLegalEntity.id;
	  testProposal.NokiaCPQ_No_of_Years__c = '5';
	  testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	  testProposal.NokiaCPQ_Existing_IONMaint_Contract__c='No';
	  testProposal.NokiaCPQ_Portfolio__c = 'Airscale Wifi';
	  testProposal.NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced Emergency';
	  insert testProposal;
	  /*** proposal creation Ends ***/
	  
	  system.debug('testProposal:'+testProposal);
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], ApttusTestPriceList,testProposal);
	  insert ProdConfig;
	  /*** product configuration Ends***/
	  
	  /*** Line Item Starts***/
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	  
	  //Line Item#1
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem1.Apttus_Config2__PriceListItemId__c = pLI1.id;
	  LineItem1.Apttus_Config2__ItemSequence__c = 1;
	  LineItem1.Source__c='';
	  LineItem1.NokiaCPQ_Unitary_IRP__c = 300;
	  LineItem1.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem1.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem1.NokiaCPQ_Product_Type__c='Controller';
	  allLineItems.add(LineItem1);
	  
	  //Line Item#2
	  Apttus_Config2__LineItem__c lineItem3 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem3.Apttus_Config2__ItemSequence__c = 2;	  
	  lineItem3.Apttus_Config2__OptionId__c = prod6.Id;
	  lineItem3.Apttus_Config2__PriceListItemId__c = pLI6.id;
	  lineItem3.NokiaCPQ_Product_Type__c = 'Access Point';
	  lineItem3.Apttus_Config2__AdjustmentType__c = '% Discount';
	  lineItem3.NokiaCPQ_Unitary_IRP__c = 1300;
	  lineItem3.Apttus_Config2__AdjustmentAmount__c = 10;
	  allLineItems.add(lineItem3);
	  
	  //Line Item#3
	  Apttus_Config2__LineItem__c lineItem4 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem4.Apttus_Config2__ItemSequence__c = 3;
	  lineItem4.Apttus_Config2__ProductId__c = prod2.Id;
	  lineItem4.Apttus_Config2__PriceListItemId__c = pLI2.id;	 
	  lineItem4.Apttus_Config2__PriceIncludedInBundle__c = true;
	  lineItem4.Apttus_Config2__ChargeType__c= 'Year 1 Maintenance'; 
	  lineItem4.Apttus_Config2__LineType__c = 'Product/Service';
	  lineItem4.NokiaCPQ_Unitary_IRP__c = 400;
	  allLineItems.add(lineItem4);
	  
	  //Line Item#4
	  Apttus_Config2__LineItem__c lineItem5 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem5.Apttus_Config2__ItemSequence__c = 4;
	  lineItem5.Apttus_Config2__ProductId__c = prod5.Id;
	  lineItem5.Apttus_Config2__PriceListItemId__c = pLI5.id;
	  lineItem5.Apttus_Config2__PriceIncludedInBundle__c = true;
	  lineItem5.Apttus_Config2__LineType__c = 'Product/Service';
	  lineItem5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond';
	  lineItem5.NokiaCPQ_Maint_Yr1_Extended_Price__c =  100;
	  lineItem5.NokiaCPQ_Unitary_IRP__c = 300;
	  allLineItems.add(lineItem5);
	  
	  //Line Item#5	   
	  Apttus_Config2__LineItem__c lineItem6 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem6.Apttus_Config2__ItemSequence__c = 5;
	  lineItem6.Apttus_Config2__OptionId__c = prod3.Id;
	  lineItem6.Apttus_Config2__PriceListItemId__c = pLI3.id;
	  lineItem6.Apttus_Config2__ProductId__c = prod6.Id;
	  lineItem6.Apttus_Config2__ParentBundleNumber__c = 2;
	  lineItem6.NokiaCPQ_Unitary_IRP__c= 300;
	  allLineItems.add(lineItem6);
	  
	  //Line Item#6
	  Apttus_Config2__LineItem__c LineItem7 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem7.Apttus_Config2__ItemSequence__c = 6;
	  LineItem7.Apttus_Config2__OptionId__c = prod7.Id;
	  LineItem7.Apttus_Config2__ProductId__c = prod1.Id;
	  LineItem7.Apttus_Config2__PriceListItemId__c = pLI7.id;
	  LineItem7.Apttus_Config2__AdjustmentType__c = 'Discount Amount';
	  LineItem7.Apttus_Config2__AdjustmentAmount__c = 100;
	  LineItem7.NokiaCPQ_Product_Type__c = 'Controller';
	  allLineItems.add(LineItem7);
	  
	  //Line Item#7
	  Apttus_Config2__LineItem__c LineItem8 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem8.Apttus_Config2__ItemSequence__c = 2;
	  LineItem8.Apttus_Config2__OptionId__c = prod8.Id;
	  LineItem8.Apttus_Config2__ProductId__c = prod6.Id;
	  LineItem8.Apttus_Config2__PriceListItemId__c = pLI8.id;
	  LineItem8.NokiaCPQ_Product_Type__c = 'Third Party Wavespot';
	  LineItem8.NokiaCPQ_Unitary_IRP__c = 600;
	  allLineItems.add(LineItem8);
	  
	  insert allLineItems;
	  /*** Line Item Ends***/
	  
	  //Test.startTest(); 
	  
	  Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
	  
	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.finish();
	  Nokia_PricingCallBack.calculateEquivalentPrice(allLineItems, 'Market India');
	  
	  testProposal.NokiaCPQ_No_of_Years__c = '5';
	  testProposal.NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced';
	  update testProposal;
	  
	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	Test.stopTest();
	}
  }
  static testMethod void QTCmethod2() {
	List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	
	insert account3;
	
	List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
	opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	
	insert opportunities1;
	
	/*create product*/  
	List<Product2> prods = new List<Product2>();
	Product2 prod = TestDataSetup.createCPQTestproduct(1)[0];
	prod.Business_Group__c='MN';
	prod.Family= 'A&A-CEM';
	prod.CurrencyIsoCode = 'EUR';
	prod.Partner_Visible__c=True;
	prod.ProductCode='FC11011';
	prod.Apttus_Config2__Version__c=1;
	prod.Portfolio__c='Airscale Wifi';
	prod.Created_by_PMDI__c = False;
	prod.Pricing_Clusters__c='NAM';
	prods.add(prod);
	
	Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	prod1.Business_Group__c='MN';
	prod1.Family= 'A&A-CEM';
	prod1.CurrencyIsoCode = 'EUR';
	prod1.Partner_Visible__c=True;
	prod1.ProductCode='FC11011';
	prod1.Apttus_Config2__Version__c=1;
	prod1.Portfolio__c='Airscale Wifi';
	prod1.Created_by_PMDI__c = False;
	prod1.Pricing_Clusters__c='NAM';
	prods.add(prod1);
	insert prods;
	/* product ends*/
	
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
	Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	pLI5.Apttus_Config2__ProductId__c = prod.Id;
	pLI5.Apttus_Config2__Cost__c = 10; //DHH
	insert pLI5;
	
	Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	pLI6.Apttus_Config2__ProductId__c = prod1.Id;
	pLI6.Apttus_Config2__Cost__c = 10; //DHH
	insert pLI6;
	
	List<Product_Extension__c> PEList = new List<Product_Extension__c>();
	Product_Extension__c PE1 = new Product_Extension__c(
	  Product__c = prod1.id,
	  Market__c = 'Market North America',
	  List_Price__c = 100,
	  Floor_Price__c = 75,
	  CurrencyIsoCode = 'EUR'
	);
	PEList.add(PE1);
	insert PEList;
	
	/** Proposal Creation starts**/
	Apttus_Proposal__Proposal__c testProposal1 = TestDataSetup.creatProposal(opportunities1[0], account3[0], ApttusTestPriceList);
	testProposal1.NokiaCPQ_Portfolio__c = 'QTC';
	testProposal1.NokiaCPQ_FN_Maintenance_Type__c='';
	testProposal1.NokiaCPQ_SRS_Level__c='';
	testProposal1.NokiaCPQ_Existing_IONMaint_Contract__c='';
	testProposal1.NokiaCPQ_Needs_Reprice__c = false;
	testProposal1.Reprice_In_Progress__c = false;
	//testProposal1.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	testProposal1.NokiaCPQ_Existing_FN_Maint_Contract__c='';
	testProposal1.NokiaCPQ_ION_Maintenance_Type__c='';
	testProposal1.NokiaCPQ_SSP_Level__c='';
	testProposal1.NokiaCPQ_No_of_Years__c='';
	testProposal1.Is_List_Price_Only__c = true;
	testProposal1.CurrencyIsoCode = 'EUR';
	insert testProposal1;
	
	/*** create product configuration ***/
	Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(account3[0], ApttusTestPriceList,testProposal1);
	insert ProdConfig;
	/*** product configuration Ends***/
	
	
	/*** Line Items Creation starts **/
	list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	
	//Line Item#1
	Apttus_Config2__LineItem__c lineItem3 = TestDataSetup.creatConfigLineItem(account3[0], ProdConfig, ApttusTestPriceList, prod1,1)[0];	
	lineItem3.Apttus_Config2__LineType__c = 'Product/Service';
	lineItem3.Apttus_Config2__PrimaryLineNumber__c = 1;
	lineItem3.Advanced_pricing_done__c = true;
	lineItem3.Apttus_Config2__NetPrice__c=100;
	lineItem3.Apttus_Config2__Quantity__c = 10;
	lineItem3.NokiaCPQ_Unitary_Cost__c = 10;
	lineItem3.CPQ_Market_Model__c=null;
	lineItem3.NokiaCPQ_Custom_Bid__c =true;
	allLineItems.add(LineItem3);
	
	//Line Item#2
	Apttus_Config2__LineItem__c LineItem4 = TestDataSetup.creatConfigLineItem(account3[0], ProdConfig, ApttusTestPriceList, prod1,1)[0];	
	LineItem4.Apttus_Config2__LineType__c = 'Product/Service';
	LineItem4.Apttus_Config2__PrimaryLineNumber__c = 1;
	LineItem4.Advanced_pricing_done__c = true;
	LineItem4.Apttus_Config2__NetPrice__c=10000;
	LineItem4.NokiaCPQ_Unitary_Cost__c = 100;
	LineItem4.CPQ_Market_Model__c=null;
	allLineItems.add(LineItem4);
	
	//Line Item#3
	Apttus_Config2__LineItem__c LineItem6 = TestDataSetup.creatConfigLineItem(account3[0], ProdConfig, ApttusTestPriceList, prod1,1)[0];
	LineItem6.Apttus_Config2__LineType__c = 'Product/Service';
	LineItem6.NokiaCPQ_Unitary_Cost__c = 1000;
	LineItem6.Nokia_SSP_Base_Extended_Price__c = 90;
	LineItem6.NokiaCPQ_Floor_Price__c = 100;
	LineItem6.Advanced_pricing_done__c = true;
	LineItem6.Apttus_Config2__NetPrice__c=1000;
	LineItem6.CPQ_Market_Model__c=null;
	allLineItems.add(LineItem6);
	
	//Line Item#4
	Apttus_Config2__LineItem__c LineItem7 = TestDataSetup.creatConfigLineItem(account3[0], ProdConfig, ApttusTestPriceList, prod1,1)[0];
	LineItem7.Apttus_Config2__LineType__c = 'Product/Service';
	LineItem7.Apttus_Config2__ProductId__c = prod.Id;
	LineItem7.Apttus_Config2__Frequency__c = 'Yearly';
	LineItem7.NokiaCPQ_Maint_Yr2_Extended_Price__c = 100;
	LineItem7.Nokia_SSP_Base_Extended_Price__c = 200;
	LineItem7.Advanced_pricing_done__c = true;
	LineItem7.Apttus_Config2__Quantity__c = 5;
	LineItem7.Apttus_Config2__NetPrice__c=1000;
	LineItem7.NokiaCPQ_Unitary_Cost__c = 10;
	allLineItems.add(LineItem7);
	
	//Line Item#5
	Apttus_Config2__LineItem__c LineItem8 = TestDataSetup.creatConfigLineItem(account3[0], ProdConfig, ApttusTestPriceList, prod1,1)[0];
	LineItem8.Apttus_Config2__LineType__c = 'Product/Service';
	LineItem8.Advanced_pricing_done__c = true;
	LineItem8.CPQ_Market_Model__c=null;
	LineItem8.Apttus_Config2__NetPrice__c=100;
	LineItem8.CPQ_Market_Model__c=null;
	allLineItems.add(LineItem8);
	insert allLineItems;
	/*** Line Items Ends ***/
	Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
	
	obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	
	obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
	
	Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	test.stopTest(); 
  }
  static testMethod void directEnterprise_coverage() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	//Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	//Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	Custom_Constant_Field__c ccf = new Custom_Constant_Field__c();
	ccf.Name = 'Custom Constant Field';
	
	List<Opportunity> opportunities;
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	
	System.runAs(users[0]) {   
	  
	  /************ Account Insertion  ***************/
	  
	  List<Account> accountsNew = new List<Account>();
	  Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	  accLegalEntity.AccountNumber='101234567';
	  accLegalEntity.Acc_No__c = '101234567';
	  accLegalEntity.GEOLevel1ID__c ='RG_NAM';
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  accountsNew.add(accLegalEntity);
	  //database.insert(accLegalEntity);
	  
	  Account account = TestDataFactory.createAccount(1)[0];
	  account.AccountNumber='3011234567';
	  account.Acc_No__c = '3011234567';
	  account.GEOLevel1ID__c ='RG_NAM';
	  account.Active__c= true;
	  accountsNew.add(account);
	  //database.insert(account);
	  
	  insert accountsNew;
	  
	  List<Account> accounts=new List<Account>();
	  accounts.add(account);
	  
	  //Create Opportunity
	  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
	  opportunities.get(0).Lead_BG__c = 'MN';
	  opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities.get(0).Account_Role__c = 'Alliance Partner';
	  insert opportunities.get(0);
	  
	  
	  //Create Product
	  List<Product2> prods = new List<Product2>();
	  Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod1.Portfolio__c = 'IP Routing';
	  prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod1.NokiaCPQ_Classification2__c='Base';
	  prod1.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod1);
	  
	  //product#2
	  Product2 prod2 =  TestDataSetup.createCPQTestproduct(1)[0];
	  prod2.ProductCode = 'MT001';
	  prod2.Portfolio__c = 'IP Routing';
	  prod2.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prod2.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod2);
	  
	  //Product#3
	  Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod4.ProductCode = 'SSP002';
	  //prod4.Business_Group__c = 'NSW';
	  prod4.Business_Group__c = 'MN';   
	  prod4.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod4);  
	  
	  //Product#4
	  Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod5.Name = 'Maintenance Year2+'; 
	  prod5.ProductCode = 'MT002'; 
	  //prod5.Business_Group__c = 'NSW'; 
	  prod5.Business_Group__c = 'MN';
	  prod5.Portfolio__c = 'IP Routing';
	  prod5.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod5);
	  
	  //Product#5
	  Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod6.Name = 'Bundle';
	  prod6.Portfolio__c = 'IP Routing';
	  prod6.NokiaCPQ_Classification2__c='Base';
	  prod6.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod6);
	  
	  //Product#6
	  Product2 prod7 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod7.ProductCode = 'SRS001';
	  prod7.Portfolio__c = 'IP Routing';
	  //prod7.Business_Group__c = 'NSW';
	  prod7.Business_Group__c = 'MN';
	  prod7.NokiaCPQ_Classification2__c='Base';
	  prod7.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod7);
	  
	  //Product#7
	  Product2 prod8 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod8.ProductCode = 'CL_TEST';
	  prod8.Portfolio__c = 'IP Routing';
	  prod8.Business_Group__c = 'MN';
	  prod8.NokiaCPQ_Classification2__c='Base';
	  prod8.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod8);
	  
	  
	  //Product#8
	  Product2 prod9 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod9.ProductCode = 'CL_TEST1';
	  prod9.Portfolio__c = 'IP Routing';
	  prod9.Business_Group__c = 'MN';
	  prod9.NokiaCPQ_Classification2__c='Base';
	  prod9.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod9);
	  
	  insert prods;
	  
	  Test.startTest();
	  //Create PriceList
	  List<Apttus_Config2__PriceList__c> priceLists = new List<Apttus_Config2__PriceList__c>();
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
	  Name = 'Commercial Price List', CurrencyIsoCode = 'USD',
	  Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
	  );
	  priceLists.add(ApttusTestPriceList);
	  Apttus_Config2__PriceList__c ApttusTestPriceList2 = new Apttus_Config2__PriceList__c(
	  Name = 'CLP', CurrencyIsoCode = 'USD',
	  Apttus_Config2__Active__c = True, PriceList_Type__c = 'Direct'
	  );
	  priceLists.add(ApttusTestPriceList2);
	  insert priceLists;
	  
	  
	  /*** PriceList Item Creation starts ***/
	  List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	  //PLI#1
	  Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	  pLI1.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI1);
	  
	  //PLI#2
	  Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	  pLI2.Apttus_Config2__PriceIncludedInBundle__c = true;
	  pLI2.Apttus_Config2__ChargeType__c = 'Maintenance Year1';
	  pLI2.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI2);
	  
	  //PLI#3
	  Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI3.Apttus_Config2__ProductId__c = prod4.Id;
	  pLI3.Apttus_Config2__PriceIncludedInBundle__c = false;
	  pLI3.Apttus_Config2__ContractPrice__c = 100;
	  plistItems.add(pLI3);
	  
	  //PLI#4
	  Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI4.Apttus_Config2__ProductId__c = prod4.Id; 
	  pLI4.Apttus_Config2__ChargeType__c = 'SSP';
	  pLI4.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI4);
	  
	  //PLI#5
	  Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	  pLI5.Apttus_Config2__ChargeType__c = 'Maintenance Year2+';
	  pLI5.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI5);
	  
	  //PLI#6
	  Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	  pLI6.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI6);
	  
	  //PLI#7
	  Apttus_Config2__PriceListItem__c pLI7 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];	  
	  pLI7.Apttus_Config2__ProductId__c = prod6.Id;
	  pLI7.Apttus_Config2__PriceListId__c = ApttusTestPriceList2.Id;
	  pLI7.Apttus_Config2__Cost__c = 10;
	  pLI7.Contracted__c = 'Yes';
	  plistItems.add(pLI7);
	  
	  //PLI#8
	  Apttus_Config2__PriceListItem__c pLI8 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI8.Apttus_Config2__ProductId__c = prod7.Id;
	  pLI8.Apttus_Config2__ChargeType__c = 'SRS';
	  pLI8.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI8);
	  
	  //PLI#9
	  Apttus_Config2__PriceListItem__c pLI9 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI9.Apttus_Config2__ProductId__c = prod8.Id;
	  pLI9.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI9);
	  
	  //PLI#10
	  Apttus_Config2__PriceListItem__c pLI11 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI11.Apttus_Config2__ProductId__c = prod9.Id;
	  pLI11.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI11);
	  
	  insert plistItems;
	  /*** PriceList Item ends ***/
	  
	  List<Product_Extension__c> PEList = new List<Product_Extension__c>();
	  Product_Extension__c PE1 = new Product_Extension__c(
		Product__c = prod6.id,
		Market__c = 'Market North America',
		List_Price__c = 100,
		Floor_Price__c = 75,
		CurrencyIsoCode = 'USD'
	  );
	  PEList.add(PE1);
	  Product_Extension__c PE2 = new Product_Extension__c(
		Product__c = prod8.id,
		Market__c = 'Market North America',
		List_Price__c = 100,
		Floor_Price__c = 110,
		CurrencyIsoCode = 'USD'
	  );
	  PEList.add(PE2);
	  Product_Extension__c PE3 = new Product_Extension__c(
		Product__c = prod9.id,
		Market__c = 'Market North America',
		List_Price__c = 100,
		Floor_Price__c = 75,
		CurrencyIsoCode = 'USD'
	  );
	  PEList.add(PE3);
	  Product_Extension__c PE4 = new Product_Extension__c(
		Product__c = prod1.id,
		Market__c = 'Market North America',
		List_Price__c = 100,
		Floor_Price__c = 75,
		CurrencyIsoCode = 'USD'
	  );
	  PEList.add(PE4);
	  insert PEList;
	  
	  Product_Discount__c disc = new Product_Discount__c ();
	  disc.Discount__c = 8.00;
	  disc.Market__c = account.Market__c;
	  disc.Product_Discount_Category__c = 'NFM-P';
	  insert disc;
	  
	  /** Proposal Creation starts**/
	  Apttus_Proposal__Proposal__c testProposal = TestDataSetup.creatProposal(opportunities[0], account, ApttusTestPriceList2);
	  
	  testProposal.NokiaCPQ_Existing_IONMaint_Contract__c='No';
	  testProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
	  testProposal.Is_List_Price_Only__c = false;
	  testProposal.Price_List__c = 'CLP';
	  testProposal.NokiaCPQ_No_of_Years__c = '3';
	  testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	  testProposal.NokiaCPQ_Maintenance_Type__c='Gold (Return for Exchange)';
	  insert testProposal;
	  System.debug('testProposal>>>> '+testProposal);
	  /**Proposal ends ***/
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(account, ApttusTestPriceList2,testProposal);
	  insert ProdConfig;
	  
	  System.debug('ProdConfig>>>'+ProdConfig);
	  /*** product configuration Ends***/
	  
	  /*** Line Item Starts***/
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem1.Apttus_Config2__PriceListItemId__c = pLI7.id;
	  LineItem1.Apttus_Config2__PriceListId__c = ApttusTestPriceList2.id;
	  LineItem1.Total_option_Quantity__c = 1;
	  LineItem1.NokiaCPQ_Floor_Price__c = 50; 
	  LineItem1.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem1.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem1.Advanced_pricing_done__c= false;
	  LineItem1.Apttus_Config2__AllowManualAdjustment__c = true;
	  allLineItems.add(LineItem1);
	  
	  //Line Item#2	   
	  Apttus_Config2__LineItem__c lineItem3 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem3.Apttus_Config2__OptionId__c = prod6.Id;
	  lineItem3.Total_option_Quantity__c =1;
	  lineItem3.NokiaCPQ_Floor_Price__c = 50;
	  lineItem3.Apttus_Config2__PriceListItemId__c = pLI7.id;
	  lineItem3.Apttus_Config2__PriceListId__c = ApttusTestPriceList2.id;
	  lineItem3.Apttus_Config2__AdjustmentType__c = 'Price Override';
	  lineItem3.Apttus_Config2__AdjustmentAmount__c = 150;
	  lineItem3.Apttus_Config2__AllowManualAdjustment__c = true;
	  lineItem3.Advanced_pricing_done__c = false;
	  allLineItems.add(lineItem3);
	  
	  //Line Item#3	   
	  Apttus_Config2__LineItem__c lineItem4 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem4.Apttus_Config2__ItemSequence__c = 2;
	  lineItem4.Apttus_Config2__LineNumber__c = 2;
	  lineItem4.Apttus_Config2__PriceListItemId__c = pLI9.id; 
	  lineItem4.Apttus_Config2__OptionId__c = prod8.Id;	   
	  lineItem4.Apttus_Config2__LineType__c = 'Product/Service';
	  lineItem4.Advanced_pricing_done__c = false;
	  lineItem4.Apttus_Config2__AdjustmentType__c = 'Discount Amount';
	  lineItem4.Apttus_Config2__AdjustmentAmount__c = 10;
	  lineItem4.NokiaCPQ_Floor_Price__c = 110;
	  lineItem4.Apttus_Config2__PrimaryLineNumber__c = 1;
	  lineItem4.Nokia_SSP_Base_Extended_Price__c = 90;
	  lineItem4.Apttus_Config2__AllowManualAdjustment__c = true;
	  allLineItems.add(lineItem4);
	  
	  //Line Item#4	   
	  Apttus_Config2__LineItem__c lineItem5 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem5.Apttus_Config2__ItemSequence__c = 3;
	  lineItem5.Apttus_Config2__LineNumber__c = 3;
	  lineItem5.Apttus_Config2__ProductId__c = prod9.Id;
	  lineItem5.Apttus_Config2__PriceListItemId__c = pLI11.id;
	  lineItem5.Apttus_Config2__LineType__c = 'Product/Service';
	  lineItem5.Apttus_Config2__AdjustmentType__c = '% Discount';
	  lineItem5.Advanced_pricing_done__c = false;
	  lineItem5.Apttus_Config2__AdjustmentAmount__c = 30;
	  lineItem5.Apttus_Config2__AllowManualAdjustment__c = true;
	  lineItem5.NokiaCPQ_Floor_Price__c = 110;
	  allLineItems.add(lineItem5);
	  
	  //Line Item#5	   
	  Apttus_Config2__LineItem__c lineItem6 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem6.Apttus_Config2__ItemSequence__c = 4;
	  lineItem6.Apttus_Config2__LineNumber__c = 4;
	  lineItem6.Apttus_Config2__PriceListItemId__c = pLI11.id;
	  lineItem6.Apttus_Config2__LineType__c = 'Product/Service';
	  lineItem6.Apttus_Config2__ProductId__c = prod9.Id;
	  lineItem6.NokiaCPQ_Floor_Price__c = 10;
	  lineItem6.Apttus_Config2__AdjustmentAmount__c = 150;
	  lineItem6.Apttus_Config2__AllowManualAdjustment__c = true;
	  allLineItems.add(lineItem6);
	  
	  //Line Item#6	   
	  Apttus_Config2__LineItem__c LineItem7 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem7.Apttus_Config2__ItemSequence__c = 9;
	  LineItem7.Total_option_Quantity__c = 1;
	  LineItem7.Apttus_Config2__LineNumber__c = 9;
	  LineItem7.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem7.Apttus_Config2__ProductId__c = prod9.Id;
	  LineItem7.Apttus_Config2__PriceListItemId__c = pLI11.id;
	  LineItem7.Apttus_Config2__AdjustmentType__c = 'Price Override';
	  LineItem7.Apttus_Config2__AdjustmentAmount__c = 150;
	  LineItem7.Apttus_Config2__AllowManualAdjustment__c = true;
	  allLineItems.add(LineItem7);
	  
	  //Line Item#7	   
	  Apttus_Config2__LineItem__c LineItem8 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem8.Apttus_Config2__ItemSequence__c = 5;
	  LineItem8.Apttus_Config2__LineNumber__c = 5;
	  LineItem8.Apttus_Config2__ChargeType__c = 'Maintenance Year1';
	  LineItem8.Apttus_Config2__ProductId__c = prod2.Id;
	  LineItem8.Apttus_Config2__PriceListItemId__c = pLI2.id;
	  LineItem8.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem8.Apttus_Config2__PriceIncludedInBundle__c = true;
	  LineItem8.NokiaCPQ_Maint_Yr1_Extended_Price__c =  100;
	  LineItem8.Apttus_Config2__BasePriceOverride__c=120;
	  LineItem8.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem8);
	  
	  //Line Item#8	   
	  Apttus_Config2__LineItem__c LineItem9 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem9.Apttus_Config2__ItemSequence__c = 6;
	  LineItem9.Apttus_Config2__LineNumber__c = 6;
	  LineItem9.Apttus_Config2__ChargeType__c = 'SSP';
	  LineItem9.Apttus_Config2__ProductId__c = prod4.Id;
	  LineItem9.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem9.Apttus_Config2__PriceListItemId__c = pLI4.id;
	  LineItem9.Nokia_SSP_Base_Extended_Price__c = 90;
	  LineItem9.Apttus_Config2__ListPrice__c = 120;
	  LineItem9.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem9.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem9);
	  
	  //Line Item#9	   
	  Apttus_Config2__LineItem__c LineItem10 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem10.Apttus_Config2__ItemSequence__c = 7;
	  LineItem10.Apttus_Config2__LineNumber__c = 7;
	  LineItem10.Apttus_Config2__ChargeType__c = 'Maintenance Year2+';
	  LineItem10.Apttus_Config2__ProductId__c = prod5.Id;
	  LineItem10.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem10.Apttus_Config2__PriceListItemId__c = pLI5.id;
	  LineItem10.Apttus_Config2__Quantity__c = 1;
	  LineItem10.Nokia_SSP_Base_Extended_Price__c = 90;
	  LineItem10.Apttus_Config2__Frequency__c = 'Yearly';
	  LineItem10.NokiaCPQ_Maint_Yr2_Extended_Price__c = 100;
	  LineItem10.Advanced_pricing_done__c = false;
	  LineItem10.Apttus_Config2__PrimaryLineNumber__c = 1;
	  allLineItems.add(LineItem10);
	  
	  //Line Item#10
	  Apttus_Config2__LineItem__c LineItem11 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem11.Apttus_Config2__ItemSequence__c = 8;
	  LineItem11.Apttus_Config2__LineNumber__c = 8;
	  LineItem11.Apttus_Config2__ChargeType__c = 'SRS';
	  LineItem11.Apttus_Config2__ProductId__c = prod7.Id;
	  LineItem11.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem11.Apttus_Config2__PriceListItemId__c = pLI8.id;
	  LineItem11.Apttus_Config2__BasePrice__c = 120;
	  LineItem11.Nokia_SSP_Base_Extended_Price__c = 90;
	  LineItem11.Apttus_Config2__Quantity__c = 1;
	  LineItem11.Apttus_Config2__ListPrice__c = 120;
	  LineItem11.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem11.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem11);
	  
	  insert allLineItems;
	  system.debug('allLineItems>>>>'+allLineItems);
	  /*** Line Item Ends***/
	  
	  //Test.startTest(); 
	  
	  CPQ_Maintenance_and_SSP_Rule__c rec1 = new CPQ_Maintenance_and_SSP_Rule__c();
	  rec1.Maintenance_Level__c = 'Nokia Brand of Service';
	  rec1.Maintenance_Type__c = 'Gold (Return for Exchange)';
	  rec1.Region__c = 'RG_NAM';
	  rec1.Service_Rate_Y1__c = 0.05;
	  rec1.Service_Rate_Y2__c = 0.05;
	  rec1.Unlimited_SSP_Discount__c = 0.03; 
	  rec1.Maintenance_Category__c = 'NSD-NRC IPR';
	  insert rec1;
	  list<NokiaCPQ_Maintenance_and_SSP_Rules__c> listMaintSSPRule =  [SELECT NokiaCPQ_withPMA__c, NokiaCPQ_Pricing_Cluster__c, NokiaCPQ_Product_Discount_Category__c, NokiaCPQ_Product_Discount_Category_per__c, NokiaCPQ_Unlimited_SSP_Discount__c, NokiaCPQ_Biennial_SSP_Discount__c, NokiaCPQ_Maintenance_Level__c, NokiaCPQ_Maintenance_Type__c, NokiaCPQ_Service_Rate_Y1__c, NokiaCPQ_Service_Rate_Y2__c FROM NokiaCPQ_Maintenance_and_SSP_Rules__c ]; 
	  
	  //obj.finish();
	  
	  testProposal.NokiaCPQ_Needs_Reprice__c = true;
	  update testProposal;
	  Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
	  obj.finish();
	Test.stopTest();
	}
  }
  static testMethod void directEnterprise_trafficlight() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	//Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	//Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	Custom_Constant_Field__c ccf = new Custom_Constant_Field__c();
	ccf.Name = 'Custom Constant Field';
	
	List<Opportunity> opportunities;
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	
	System.runAs(users[0]) {   
	  
	  /************ Account Insertion  ***************/
	  
	  List<Account> accountsNew = new List<Account>();
	  Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	  accLegalEntity.AccountNumber='101234567';
	  accLegalEntity.Acc_No__c = '101234567';
	  accLegalEntity.GEOLevel1ID__c ='RG_NAM';
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  accountsNew.add(accLegalEntity);
	  //database.insert(accLegalEntity);
	  
	  Account account = TestDataFactory.createAccount(1)[0];
	  account.AccountNumber='3011234567';
	  account.Acc_No__c = '3011234567';
	  account.GEOLevel1ID__c ='RG_NAM';
	  account.Active__c= true;
	  accountsNew.add(account);
	  //database.insert(account);
	  
	  insert accountsNew;
	  
	  List<Account> accounts=new List<Account>();
	  accounts.add(account);
	  
	  //Create Opportunity
	  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
	  opportunities.get(0).Lead_BG__c = 'MN';
	  opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities.get(0).Account_Role__c = 'Alliance Partner';
	  insert opportunities.get(0);
	  
	  /**Product starts*/
	  List<Product2> prods = new List<Product2>();
	  
	  Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod1.Portfolio__c = 'IP Routing';
	  prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod1.NokiaCPQ_Classification2__c='Base';
	  prod1.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod1);
	  
	  //product#2
	  Product2 prod2 =  TestDataSetup.createCPQTestproduct(1)[0];
	  prod2.ProductCode = 'MT001';
	  prod2.Portfolio__c = 'IP Routing';
	  prod2.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prod2.NokiaCPQ_Classification2__c='Base';
	  prods.add(prod2);
	  
	  //Product#3
	  Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod4.Name = 'SSP';
	  prod4.ProductCode = 'SSP002';
	  prod4.Business_Group__c = 'MN';
	  //prod4.Business_Group__c = 'NSW'; 
	  prod4.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod4);
	  
	  //Product#4
	  Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod5.Name = 'Maintenance Year2+'; 
	  prod5.ProductCode = 'MT002'; 
	  prod5.Business_Group__c = 'MN';
	  //prod5.Business_Group__c = 'NSW'; 
	  prod5.Portfolio__c = 'IP Routing';
	  prod5.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod5);
	  
	  //Product#5
	  Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod6.Name = 'Bundle';
	  prod6.Portfolio__c = 'IP Routing';
	  prod6.NokiaCPQ_Classification2__c='Base';
	  prod6.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod6);
	  
	  //Product#6
	  Product2 prod7 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod7.ProductCode = 'SRS001';
	  prod7.Portfolio__c = 'IP Routing';
	  //prod7.Business_Group__c = 'NSW';
	  prod7.Business_Group__c = 'MN';
	  prod7.NokiaCPQ_Classification2__c='Base';
	  prod7.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod7);
	  
	  //Product#7
	  Product2 prod8 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod8.ProductCode = 'CL_TEST';
	  prod8.Portfolio__c = 'IP Routing';
	  prod8.NokiaCPQ_Classification2__c='Base';
	  prod8.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod8);
	  
	  //Product#8
	  Product2 prod9 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod9.ProductCode = 'CL_TEST1';
	  prod9.Portfolio__c = 'IP Routing';
	  prod9.NokiaCPQ_Classification2__c='Base';
	  prod9.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	  prods.add(prod9);
	  
	  insert prods;
	  /*** Product ends***/
	  
	  Test.startTest();
	  
	  //Create PriceList
	  /*List<Apttus_Config2__PriceList__c> priceLists = new List<Apttus_Config2__PriceList__c>();
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', CurrencyIsoCode = 'USD',
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
		);
		priceLists.add(ApttusTestPriceList);
		Apttus_Config2__PriceList__c ApttusTestPriceList2 = new Apttus_Config2__PriceList__c(
		Name = 'CLP', CurrencyIsoCode = 'USD',
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'Direct'
		);
		priceLists.add(ApttusTestPriceList2);
		insert priceLists;*/
	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', CurrencyIsoCode = 'USD',
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
	  );
	  insert ApttusTestPriceList;
	  
	  /*** PriceList Item Creation starts ***/
	  List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	  //PLI#1
	  Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	  pLI1.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI1);
	  
	  //PLI#2
	  Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI2.Apttus_Config2__ProductId__c = prod2.Id; 
	  pLI2.Apttus_Config2__PriceIncludedInBundle__c = true;
	  pLI2.Apttus_Config2__ChargeType__c = 'Maintenance Year1';
	  pLI2.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI2);
	  
	  //PLI#4
	  Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI4.Apttus_Config2__ProductId__c = prod4.Id; 
	  pLI4.Apttus_Config2__ChargeType__c = 'SSP';
	  pLI4.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI4);
	  
	  //PLI#5
	  Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	  pLI5.Apttus_Config2__ChargeType__c = 'Maintenance Year2+';
	  pLI5.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI5);
	  
	  //PLI#6
	  Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	  pLI6.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI6);
	  
	  //PLI#7
	  Apttus_Config2__PriceListItem__c pLI7 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];	  
	  pLI7.Apttus_Config2__ProductId__c = prod6.Id;
	  pLI7.Apttus_Config2__Cost__c = 10;
	  pLI7.Contracted__c = 'Yes';
	  plistItems.add(pLI7);
	  
	  //PLI#8
	  Apttus_Config2__PriceListItem__c pLI8 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI8.Apttus_Config2__ProductId__c = prod7.Id;
	  pLI8.Apttus_Config2__ChargeType__c = 'SRS';
	  pLI8.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI8);
	  
	  //PLI#9
	  Apttus_Config2__PriceListItem__c pLI9 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI9.Apttus_Config2__ProductId__c = prod8.Id;
	  pLI9.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI9);
	  
	  //PLI#10
	  Apttus_Config2__PriceListItem__c pLI11 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI11.Apttus_Config2__ProductId__c = prod9.Id;
	  pLI11.Apttus_Config2__Cost__c = 10;
	  plistItems.add(pLI11);
	  
	  insert plistItems;
	  /*** PriceList Item ends ***/
	  
	  List<Product_Extension__c> PEList = new List<Product_Extension__c>();
	  Product_Extension__c PE1 = new Product_Extension__c(
		Product__c = prod6.id,
		Market__c = 'Market North America',
		List_Price__c = 100,
		Floor_Price__c = 75,
		CurrencyIsoCode = 'USD'
	  );
	  PEList.add(PE1);
	  Product_Extension__c PE2 = new Product_Extension__c(
		Product__c = prod8.id,
		Market__c = 'Market North America',
		List_Price__c = 100,
		Floor_Price__c = 110,
		CurrencyIsoCode = 'USD'
	  );
	  PEList.add(PE2);
	  Product_Extension__c PE3 = new Product_Extension__c(
		Product__c = prod9.id,
		Market__c = 'Market North America',
		List_Price__c = 100,
		Floor_Price__c = 75,
		CurrencyIsoCode = 'USD'
	  );
	  PEList.add(PE3);
	  Product_Extension__c PE4 = new Product_Extension__c(
		Product__c = prod1.id,
		Market__c = 'Market North America',
		List_Price__c = 100,
		Floor_Price__c = 75,
		CurrencyIsoCode = 'USD'
	  );
	  PEList.add(PE4);
	  insert PEList;
	  
	  Product_Discount__c disc = new Product_Discount__c ();
	  disc.Discount__c = 8.00;
	  disc.Market__c = account.Market__c;
	  disc.Product_Discount_Category__c = 'NFM-P';
	  insert disc;
	  
	  /** Proposal Creation starts**/
		Apttus_Proposal__Proposal__c testProposal = TestDataSetup.creatProposal(opportunities[0], account, ApttusTestPriceList);
		testProposal.NokiaCPQ_Existing_IONMaint_Contract__c='No';
		testProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
		testProposal.Is_List_Price_Only__c = false;
		testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
		testProposal.NokiaCPQ_No_of_Years__c = '3';
		testProposal.NokiaCPQ_Maintenance_Type__c='Gold (Return for Exchange)';
		insert testProposal;
	  
		testProposal.Price_List__c = 'CLP';
		testProposal.CurrencyIsoCode = 'USD';
	  /**Proposal ends ***/
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(account, ApttusTestPriceList,testProposal);
	  insert ProdConfig;
	  /*** product configuration Ends***/
	  
	  /*** Line Item Starts***/
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	  
	  //Line Item#1
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem1.Apttus_Config2__PriceListItemId__c = pLI7.id;
	  LineItem1.NokiaCPQ_Floor_Price__c = 50;
	  LineItem1.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem1.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem1.Advanced_pricing_done__c= false;
	  LineItem1.Apttus_Config2__AllowManualAdjustment__c = true;
	  allLineItems.add(LineItem1);
	  
	  //Line Item#2
	  Apttus_Config2__LineItem__c lineItem3 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem3.Apttus_Config2__OptionId__c = prod6.Id;
	  lineItem3.Apttus_Config2__PriceListItemId__c = pLI7.id;
	  lineItem3.Apttus_Config2__AdjustmentType__c = 'Price Override';
	  lineItem3.Apttus_Config2__AdjustmentAmount__c = 150;
	  lineItem3.Apttus_Config2__AllowManualAdjustment__c = true;
	  lineItem3.NokiaCPQ_Floor_Price__c = 50;
	  lineItem3.Advanced_pricing_done__c = false;
	  allLineItems.add(lineItem3);
	  
	  //Line Item#3--Done
	  Apttus_Config2__LineItem__c lineItem4 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem4.Apttus_Config2__ItemSequence__c = 2;
	  lineItem4.Apttus_Config2__PriceListItemId__c = pLI9.id; 
	  lineItem4.Apttus_Config2__OptionId__c = prod8.Id;	   
	  lineItem4.Apttus_Config2__LineType__c = 'Product/Service';
	  lineItem4.Advanced_pricing_done__c = false;
	  lineItem4.Apttus_Config2__AdjustmentType__c = 'Discount Amount';
	  lineItem4.Apttus_Config2__AdjustmentAmount__c = 10;
	  lineItem4.NokiaCPQ_Floor_Price__c = 110;
	  lineItem4.Nokia_SSP_Base_Extended_Price__c = 90;
	  lineItem4.Apttus_Config2__AllowManualAdjustment__c = true;
	  allLineItems.add(lineItem4);
	  
	  //Line Item#4--Done
	  Apttus_Config2__LineItem__c lineItem5 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem5.Apttus_Config2__ItemSequence__c = 3;
	  lineItem5.Apttus_Config2__ProductId__c = prod9.Id;
	  lineItem5.Apttus_Config2__PriceListItemId__c = pLI11.id;
	  lineItem5.Apttus_Config2__LineType__c = 'Product/Service';
	  lineItem5.Apttus_Config2__AdjustmentType__c = '% Discount';
	  lineItem5.Advanced_pricing_done__c = false;
	  lineItem5.Apttus_Config2__AllowManualAdjustment__c = true;
	  lineItem5.Apttus_Config2__AdjustmentAmount__c = 30;
	  lineItem5.NokiaCPQ_Floor_Price__c = 110;
	  allLineItems.add(lineItem5);
	  
	  //Line Item#5-done	
	  Apttus_Config2__LineItem__c lineItem6 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  lineItem6.Apttus_Config2__ItemSequence__c = 4;
	  lineItem6.Apttus_Config2__PriceListItemId__c = pLI11.id;
	  lineItem6.Apttus_Config2__ProductId__c = prod9.Id;
	  lineItem6.Apttus_Config2__LineType__c = 'Product/Service';
	  lineItem6.NokiaCPQ_Floor_Price__c = 10;
	  lineItem6.Apttus_Config2__AdjustmentAmount__c = 150;
	  lineItem6.Apttus_Config2__AdjustmentType__c = 'Price Override';
	  lineItem6.Apttus_Config2__AllowManualAdjustment__c = true;
	  allLineItems.add(lineItem6);
	  
	  //Line Item#6--done
	  Apttus_Config2__LineItem__c LineItem7 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem7.Apttus_Config2__ItemSequence__c = 9;
	  LineItem7.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem7.Apttus_Config2__ProductId__c = prod9.Id;
	  LineItem7.Apttus_Config2__PriceListItemId__c = pLI11.id;
	  LineItem7.Apttus_Config2__AdjustmentType__c = 'Price Override';
	  LineItem7.Apttus_Config2__AdjustmentAmount__c = 150;
	  LineItem7.Apttus_Config2__AllowManualAdjustment__c = true;
	  allLineItems.add(LineItem7);
	  
	  //Line Item#7--done
	  Apttus_Config2__LineItem__c LineItem8 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem8.Apttus_Config2__ItemSequence__c = 5;
	  LineItem8.Apttus_Config2__ChargeType__c = 'Maintenance Year1';
	  LineItem8.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem8.Apttus_Config2__ProductId__c = prod2.Id;
	  LineItem8.Apttus_Config2__PriceListItemId__c = pLI2.id;
	  LineItem8.NokiaCPQ_Maint_Yr1_Extended_Price__c =  100;
	  LineItem8.Apttus_Config2__PriceIncludedInBundle__c = true;
	  LineItem8.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem8);
	  
	  //Line Item#8
	  Apttus_Config2__LineItem__c LineItem9 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem9.Apttus_Config2__ItemSequence__c = 6;
	  LineItem9.Apttus_Config2__ChargeType__c = 'SSP';
	  LineItem9.Apttus_Config2__ProductId__c = prod4.Id;
	  LineItem9.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem9.Apttus_Config2__PriceListItemId__c = pLI4.id;
	  LineItem9.Nokia_SSP_Base_Extended_Price__c = 90;
	  LineItem9.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem9);
	  
	  //Line Item#9
	  Apttus_Config2__LineItem__c LineItem10 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem10.Apttus_Config2__ItemSequence__c = 7;
	  LineItem10.Apttus_Config2__ChargeType__c = 'Maintenance Year2+';
	  LineItem10.Apttus_Config2__ProductId__c = prod5.Id;
	  LineItem10.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem10.Apttus_Config2__PriceListItemId__c = pLI5.id;
	  LineItem10.Nokia_SSP_Base_Extended_Price__c = 200;
	  LineItem10.Apttus_Config2__Frequency__c = 'Yearly';
	  LineItem10.NokiaCPQ_Maint_Yr2_Extended_Price__c = 100;
	  LineItem10.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem10);
	  
	  //Line Item#10
	  Apttus_Config2__LineItem__c LineItem11 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem11.Apttus_Config2__ItemSequence__c = 8;
	  LineItem11.Apttus_Config2__ChargeType__c = 'SRS';
	  LineItem11.Apttus_Config2__ProductId__c = prod7.Id;
	  LineItem11.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem11.Apttus_Config2__PriceListItemId__c = pLI8.id;
	  LineItem11.Nokia_SSP_Base_Extended_Price__c = 90;
	  LineItem11.Advanced_pricing_done__c = false;
	  allLineItems.add(LineItem11);
	  
	  //Test.startTest(); 
	  
	  CPQ_Maintenance_and_SSP_Rule__c rec1 = new CPQ_Maintenance_and_SSP_Rule__c();
	  rec1.Maintenance_Level__c = 'Nokia Brand of Service';
	  rec1.Maintenance_Type__c = 'Gold (Return for Exchange)';
	  rec1.Region__c = 'RG_NAM';
	  rec1.Service_Rate_Y1__c = 0.05;
	  rec1.Service_Rate_Y2__c = 0.05;
	  rec1.Unlimited_SSP_Discount__c = 0.03; 
	  rec1.Maintenance_Category__c = 'NSD-NRC IPR';
	  insert rec1;
	  list<NokiaCPQ_Maintenance_and_SSP_Rules__c> listMaintSSPRule =  [SELECT NokiaCPQ_withPMA__c, NokiaCPQ_Pricing_Cluster__c, NokiaCPQ_Product_Discount_Category__c, NokiaCPQ_Product_Discount_Category_per__c, NokiaCPQ_Unlimited_SSP_Discount__c, NokiaCPQ_Biennial_SSP_Discount__c, NokiaCPQ_Maintenance_Level__c, NokiaCPQ_Maintenance_Type__c, NokiaCPQ_Service_Rate_Y1__c, NokiaCPQ_Service_Rate_Y2__c FROM NokiaCPQ_Maintenance_and_SSP_Rules__c ]; 
	  
	  //obj.finish();
	  testProposal.Maintenance_Y1__c = 100;
	  testProposal.Maintenance_Y2__c = 100;
	  testProposal.SSP__c = 100;
	  testProposal.SRS__c = 100;
	  testProposal.NokiaCPQ_Needs_Reprice__c = true;
	  update testProposal;
	  Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  
	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
	  obj.finish();
	Test.stopTest();
	}
  }
  static testMethod void IndirectMPW() {
	Apttus_Config2__ClassificationName__c categoerySO = TestDataSetup.createCategorySO();
	insert categoerySO;
	
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	/**Product starts*/
	List<Product2> prods = new List<Product2>();
	
	//product#1
	Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	prod1.ProductCode = 'MPW';
	prod1.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
	prods.add(prod1);
	
	//product#2
	Product2 prod2 =  TestDataSetup.createCPQTestproduct(1)[0];
	prod2.ProductCode = 'MT001';
	prod2.Business_Group__c = 'MN';
	prod2.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prods.add(prod2);
	
	//Product#3
	Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	prod3.ProductCode = 'SRS001';
	prod3.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod3.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod3);
	
	//Product#4
	Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	prod4.ProductCode = 'SSP002'; 
	prod4.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod4);
	
	//Product#5
	Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	prod5.ProductCode = 'MT002';
	prod5.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod5.NokiaCPQ_Classification2__c='Base';
	prod5.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	prods.add(prod5);
	
	//Product#6
	Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	prod6.ProductCode = 'RANFWEAB3';
	prod6.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod6.NokiaCPQ_Product_Discount_Category__c = Nokia_CPQ_Constants.MPW_RADIO;
	prods.add(prod6);
	insert prods;
	/*** Product ends ***/
	
	//Create PriceList  
	Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name = 'Commercial Price List',Apttus_Config2__Active__c= True);
	insert ApttusTestPriceList;
	
	/*** PriceList Item Creation starts ***/
	List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	//PLI#1
	Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	pLI1.Apttus_Config2__PriceType__c = 'One Time';
	pLI1.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI1);
	
	//PLI#2--
	Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI2.Apttus_Config2__ProductId__c = prod2.Id;
	pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	pLI2.Apttus_Config2__PriceType__c = 'One Time';
	pLI2.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI2);
	
	
	//PLI#3--
	Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	pLI3.Apttus_Config2__ChargeType__c = 'SRS';
	pLI3.Apttus_Config2__PriceType__c = 'One Time';
	pLI3.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI3);
	
	//PLI#4--
	Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI4.Apttus_Config2__ProductId__c = prod4.Id; 
	pLI4.Apttus_Config2__ChargeType__c = 'SSP';
	pLI4.Apttus_Config2__PriceType__c = 'One Time';
	pLI4.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI4);
	
	//PLI#5--
	Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond';
	pLI5.Apttus_Config2__PriceType__c = 'One Time';
	pLI5.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI5);
	
	//PLI#6--
	Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	pLI6.Apttus_Config2__PriceType__c = 'One Time';
	pLI6.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI6);
	
	insert plistItems;
	/*** Price List Item ends***/
	
	Apttus_Config2__PriceListCategory__c priceListCategorySO = TestDataSetup.createPriceListCategorySO(categoerySO, priceListSO);
	//Create Classification HierarchySO
	Apttus_Config2__ClassificationHierarchy__c chSO = TestDataSetup.createPriceListCategorySO(categoerySO);
	insert chSO;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : prods){
	  productIDList.add(productSO.id);
	}
	
	/** Product classification*-------------------------------*/
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	/** Product classification ends**/
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;  
	
	//Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	//Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	
	System.runAs(users[0]) {  
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  System.runAs(userList[0]){
		//Create Account
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
		/*opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);*/
		
		opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].End_Customer_LE__c = accounts1[0].Id;
		insert opportunities;
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		insert accredList;
		/***Accreditation ends ***/
		
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		
		/** Proposal Creation starts* --------needs to be optimized*/
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		testProposal.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
		testProposal.NokiaCPQ_SSP_Level__c = '';
		testProposal.NokiaCPQ_Maintenance_Type__c = 'Solution Support';
		testProposal.NokiaCPQ_SRS_Level__c = '';
		testProposal.NokiaCPQ_No_of_Years__c = '3';
		insert testProposal;
		/**Proposal ends ***/
	  }
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], ApttusTestPriceList,testProposal);
	  insert ProdConfig;
	  /*** product configuration Ends***/
	  
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  
	  // Add the products to the request
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod1.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  selectedProduct.CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100');
	  selectedProduct.CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c'};
		addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod2.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod3.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod4.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod5.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod6.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  // Execute the addMultiProducts routine
	  Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c=Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	  ship.Pricing_Cluster__c='MPW Cluster 2';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  try{
		// create the update price request
		Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
		
		// add request parameters
		objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
		
		// update price for the cart
		Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		Boolean hasPendingItems = result.IsPricePending;
		
		system.debug('Is Price Pending...' + hasPendingItems);
		
		for(integer i=0;i<6;i++){
		  if(hasPendingItems){
			result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
			hasPendingItems = result.IsPricePending;
			system.debug('Is Price Pending...' + hasPendingItems);
		  }
		}
		List<Apttus_Config2__LineItem__c> lineItem = [select id, Apttus_Config2__NetPrice__c,Apttus_Config2__PriceListItemId__c
								,Apttus_Config2__BasePrice__c, Apttus_Config2__Quantity__c, Apttus_Config2__PricingStatus__c
								, Apttus_Config2__ProductId__c, Apttus_Config2__ListPrice__c
								from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:   ProdConfig.id];//cartResponse.CartID];
		if(lineItem != null && lineItem.size() > 0){
		  system.debug('cart lines size...' + lineItem.size());
		  system.debug('cart lines...' + lineItem);
		  for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
			System.debug('lineItemSO...'+ lineItemSO);
		  }
		}else{
		  system.debug('cart lines does not exist...');
		}
	  }catch(Exception ex){
		throw ex;
	  }
	}
	Test.stopTest();
  }
  static testMethod void IndirectMPWEURR() {
	Apttus_Config2__ClassificationName__c categoerySO = TestDataSetup.createCategorySO();
	insert categoerySO;
	
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	/**Product starts*/
	List<Product2> prods = new List<Product2>();
	//product#1-
	Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	prod1.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod1.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod1);
	
	//product#2--
	Product2 prod2 =  TestDataSetup.createCPQTestproduct(1)[0];
	prod2.ProductCode = 'MT001';
	//prod2.Business_Group__c = 'NSW';
	prod2.Business_Group__c = 'MN';
	prod2.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod2.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod2);
	
	//Product#3--
	Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	prod3.ProductCode = 'SRS001';
	prod3.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod3.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod3);
	
	//Product#4--
	Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	prod4.ProductCode = 'SSP002'; 
	prod4.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod4);
	
	//Product#5--
	Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	prod5.ProductCode = 'MT002';
	prod5.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod5.NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR';
	prods.add(prod5);	 
	
	//Product#6
	Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	prod6.ProductCode = 'P6';
	prod6.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod6.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod6);
	insert prods;
	/*** Product ends ***/  
	
	//Create PriceList
	
	Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
	  Name = 'Commercial Price List', 
	  Apttus_Config2__Active__c = True
	);
	insert ApttusTestPriceList;
	
	/*** PriceList Item Creation starts ***/
	List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	//PLI#1
	Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	pLI1.Apttus_Config2__PriceType__c = 'One Time';
	pLI1.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI1);
	
	//PLI#2
	Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI2.Apttus_Config2__ProductId__c = prod2.Id;
	pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	pLI2.Apttus_Config2__PriceType__c = 'One Time';
	pLI2.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI2);
	
	//PLI#3
	Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	pLI3.Apttus_Config2__ChargeType__c = 'SRS';
	pLI3.Apttus_Config2__PriceType__c = 'One Time';
	pLI3.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI3);
	
	//PLI#4
	Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI4.Apttus_Config2__ProductId__c = prod4.Id; 
	pLI4.Apttus_Config2__ChargeType__c = 'SSP';
	pLI4.Apttus_Config2__PriceType__c = 'One Time';
	pLI4.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI4);
	
	
	//PLI#5--
	Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond';
	pLI5.Apttus_Config2__PriceType__c = 'One Time';
	pLI5.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI5);
	
	//PLI#6--
	Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	pLI6.Apttus_Config2__PriceType__c = 'One Time';
	pLI6.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI6);
	
	insert plistItems;
	/*** Price List Item ends***/
	
	Apttus_Config2__PriceListCategory__c priceListCategorySO = TestDataSetup.createPriceListCategorySO(categoerySO, priceListSO);
	//Create Classification HierarchySO
	Apttus_Config2__ClassificationHierarchy__c chSO = TestDataSetup.createPriceListCategorySO(categoerySO);
	insert chSO;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : prods){
	  productIDList.add(productSO.id);
	}
	
	/** Product classification*-------------------------------*/
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	/** Product classification ends**/
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	//Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	//Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	System.runAs(users[0]) {   
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  System.runAs(userList[0]){
		//Create Account
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
		/*opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);*/
		
		opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].End_Customer_LE__c = accounts1[0].Id;
		insert opportunities;
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		accredList[0].Pricing_Level_Override__c = 'Co-Branded';		 
		insert accredList;
		/***Accreditation ends ***/
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		
		/** Proposal Creation starts* --------needs to be optimized*/
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		testProposal.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
		testProposal.NokiaCPQ_Maintenance_Type__c = 'Solution Support';
		testProposal.NokiaCPQ_SSP_Level__c = '';
		testProposal.NokiaCPQ_SRS_Level__c = '';
		testProposal.NokiaCPQ_No_of_Years__c = '3';
		insert testProposal;
		
		testProposal.CurrencyIsoCode = Nokia_CPQ_Constants.EUR_CURR;
		update testProposal;
		/**Proposal ends ***/
	  }
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], ApttusTestPriceList,testProposal);
	  insert ProdConfig;
	  /*** product configuration Ends***/
	  
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  
	  // Add the products to the request
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod1.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  selectedProduct.CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100');
	  selectedProduct.CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c'};
		addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod2.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod3.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod4.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod5.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod6.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  // Execute the addMultiProducts routine
	  Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c=Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	  ship.Pricing_Cluster__c='MPW Cluster 2';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  
	  try{
		// create the update price request
		Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
		
		// add request parameters
		objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
		
		// update price for the cart
		Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		Boolean hasPendingItems = result.IsPricePending;
		
		system.debug('Is Price Pending...' + hasPendingItems);
		for(integer i=0;i<6;i++){
		  if(hasPendingItems){
			result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
			hasPendingItems = result.IsPricePending;
			system.debug('Is Price Pending...' + hasPendingItems);
		  }
		}
		List<Apttus_Config2__LineItem__c> lineItem = [select id, Apttus_Config2__NetPrice__c,Apttus_Config2__PriceListItemId__c
								,Apttus_Config2__BasePrice__c, Apttus_Config2__Quantity__c, Apttus_Config2__PricingStatus__c
								, Apttus_Config2__ProductId__c, Apttus_Config2__ListPrice__c
								from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:   ProdConfig.id];//cartResponse.CartID];
		if(lineItem != null && lineItem.size() > 0){
		  system.debug('cart lines size...' + lineItem.size());
		  system.debug('cart lines...' + lineItem);
		  for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
			System.debug('lineItemSO...'+ lineItemSO);
		  }
		}else{
		  system.debug('cart lines does not exist...');
		}
	  }catch(Exception ex){
		throw ex;
	  }
	}
	Test.stopTest();
  }
  static testMethod void IndirectMPWEUR2() {
	Apttus_Config2__ClassificationName__c categoerySO = TestDataSetup.createCategorySO();
	insert categoerySO;
	
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	/**Product starts*/
	List<Product2> prods = new List<Product2>();
	//product#1
	Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	prod1.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod1.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod1);
	
	//product#2
	Product2 prod2 =  TestDataSetup.createCPQTestproduct(1)[0];
	prod2.ProductCode = 'MT001';
	prod2.Business_Group__c = 'MN';
	prod2.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod2.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod2);
	
	//Product#3
	Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	prod3.ProductCode = 'SRS001';
	prod3.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod3.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod3);
	
	//Product#4
	Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	prod4.ProductCode = 'SSP002'; 
	prod4.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod4);
	
	//Product#5
	Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	prod5.ProductCode = 'MT002';
	prod5.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod5.NokiaCPQ_Product_Discount_Category__c = 'NFM-P IPR';
	prods.add(prod5);   
	
	//Product#6
	Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	prod6.ProductCode = 'P6';
	prod6.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod6.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod6);
	
	insert prods;
	/*** Product ends ***/ 
	
	//Create PriceList
	
	Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
	  Name = 'Commercial Price List', 
	  Apttus_Config2__Active__c = True
	);
	insert ApttusTestPriceList;
	
	/*** PriceList Item Creation starts ***/
	List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	//PLI#1--
	Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	pLI1.Apttus_Config2__PriceType__c = 'One Time';
	pLI1.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI1);
	
	
	//PLI#2--
	Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI2.Apttus_Config2__ProductId__c = prod2.Id;
	pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	pLI2.Apttus_Config2__PriceType__c = 'One Time';
	pLI2.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI2);
	
	//PLI#3--
	Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	pLI3.Apttus_Config2__ChargeType__c = 'SRS';
	pLI3.Apttus_Config2__PriceType__c = 'One Time';
	pLI3.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI3);
	
	//PLI#4--
	Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI4.Apttus_Config2__ProductId__c = prod4.Id; 
	pLI4.Apttus_Config2__ChargeType__c = 'SSP';
	pLI4.Apttus_Config2__PriceType__c = 'One Time';
	pLI4.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI4);
	
	//PLI#5--
	Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond';
	pLI5.Apttus_Config2__PriceType__c = 'One Time';
	pLI5.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI5);
	
	//PLI#6--
	Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	pLI6.Apttus_Config2__PriceType__c = 'One Time';
	pLI6.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI6);
	
	insert plistItems;
	/*** Price List Item ends***/
	
	Apttus_Config2__PriceListCategory__c priceListCategorySO = TestDataSetup.createPriceListCategorySO(categoerySO, priceListSO);
	//Create Classification HierarchySO
	Apttus_Config2__ClassificationHierarchy__c chSO = TestDataSetup.createPriceListCategorySO(categoerySO);
	insert chSO;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : prods){
	  productIDList.add(productSO.id);
	}
	
	/** Product classification*-------------------------------*/
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	/** Product classification ends**/
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	//Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	//Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	
	System.runAs(users[0]) {   
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  System.runAs(userList[0]){
		//Create Account
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
		/*opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);*/
		
		opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].End_Customer_LE__c = accounts1[0].Id;
		insert opportunities;
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		accredList[0].Pricing_Cluster__c='MPW Cluster 2';
		accredList[0].Pricing_Level_Override__c = 'Co-Branded';
		insert accredList;
		/***Accreditation ends ***/
		
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		
		/** Proposal Creation starts* --------needs to be optimized*/
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		testProposal.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
		testProposal.NokiaCPQ_SSP_Level__c = '';
		testProposal.NokiaCPQ_SRS_Level__c = '';
		testProposal.NokiaCPQ_Maintenance_Type__c = 'Solution Support';
		testProposal.NokiaCPQ_No_of_Years__c = '4';
		insert testProposal;
		
		testProposal.CurrencyIsoCode = Nokia_CPQ_Constants.EUR_CURR;
		update testProposal;
		/**Proposal ends ***/
	  }
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], ApttusTestPriceList,testProposal);
	  insert ProdConfig;
	  /*** product configuration Ends***/
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  
	  // Add the products to the request
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod1.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  selectedProduct.CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100');
	  selectedProduct.CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c'};
		addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod2.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod3.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod4.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod5.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod6.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  // Execute the addMultiProducts routine
	  Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c=Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	  ship.Pricing_Cluster__c='MPW Cluster 2';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  
	  try{
		// create the update price request
		Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
		
		// add request parameters
		objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
		
		// update price for the cart
		Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		Boolean hasPendingItems = result.IsPricePending;
		
		system.debug('Is Price Pending...' + hasPendingItems);
		for(integer i=0;i<6;i++){
		  if(hasPendingItems){
			result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
			hasPendingItems = result.IsPricePending;
			system.debug('Is Price Pending...' + hasPendingItems);
		  }
		}
		List<Apttus_Config2__LineItem__c> lineItem = [select id, Apttus_Config2__NetPrice__c,Apttus_Config2__PriceListItemId__c
								,Apttus_Config2__BasePrice__c, Apttus_Config2__Quantity__c, Apttus_Config2__PricingStatus__c
								, Apttus_Config2__ProductId__c, Apttus_Config2__ListPrice__c
								from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:   ProdConfig.id];//cartResponse.CartID];
		
		if(lineItem != null && lineItem.size() > 0){
		  system.debug('cart lines size...' + lineItem.size());
		  system.debug('cart lines...' + lineItem);
		  for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
			System.debug('lineItemSO...'+ lineItemSO);
		  }
		}else{
		  system.debug('cart lines does not exist...');
		}
	  }catch(Exception ex){
		throw ex;
	  }
	}
	Test.stopTest();
  }
  static testMethod void IndirectMPWUSD() {
	Apttus_Config2__ClassificationName__c categoerySO = TestDataSetup.createCategorySO();
	insert categoerySO;
	
	Apttus_Config2__PriceList__c priceListSO = TestDataSetup.createpriceListSO();
	insert priceListSO;
	
	
	/**Product starts*/
	List<Product2> prods = new List<Product2>();
	//product#1
	Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	prod1.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod1.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod1);
	
	//product#2
	Product2 prod2 =  TestDataSetup.createCPQTestproduct(1)[0];
	prod2.ProductCode = 'MT001';
	prod2.Business_Group__c = 'MN';
	 // prod2.Business_Group__c = 'NSW';
	prod2.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod2.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod2);   
	
	//Product#3
	Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	prod3.ProductCode = 'SRS001';
	prod3.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod3.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	prods.add(prod3);
	
	//Product#4
	Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	prod4.ProductCode = 'SSP002'; 
	prod4.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod4);
	
	//Product#5
	Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
	prod5.ProductCode = 'MT002';
	prod5.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod5.NokiaCPQ_Product_Discount_Category__c = 'NFM-P IPR';
	prods.add(prod5);
	
	//Product#6--
	Product2 prod6 = TestDataSetup.createCPQTestproduct(1)[0];
	prod6.ProductCode = 'P6';
	prod6.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	prod6.NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION';
	prods.add(prod6);
	insert prods;
	/*** Product ends ***/
	/*Create PriceList

Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
Name = 'Commercial Price List', 
Apttus_Config2__Active__c = True
);
insert ApttusTestPriceList;*/
	
	/*** PriceList Item Creation starts ***/
	List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	//PLI#1
	Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI1.Apttus_Config2__ProductId__c = prod1.Id; 
	pLI1.Apttus_Config2__PriceType__c = 'One Time';
	pLI1.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI1);
	
	//PLI#2
	Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI2.Apttus_Config2__ProductId__c = prod2.Id;
	pLI2.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
	pLI2.Apttus_Config2__PriceType__c = 'One Time';
	pLI2.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI2);
	
	//PLI#3
	Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI3.Apttus_Config2__ProductId__c = prod3.Id;
	pLI3.Apttus_Config2__ChargeType__c = 'SRS';
	pLI3.Apttus_Config2__PriceType__c = 'One Time';
	pLI3.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI3);
	
	//PLI#4
	Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI4.Apttus_Config2__ProductId__c = prod4.Id; 
	pLI4.Apttus_Config2__ChargeType__c = 'SSP';
	pLI4.Apttus_Config2__PriceType__c = 'One Time';
	pLI4.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI4);
	
	//PLI#5
	Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI5.Apttus_Config2__ProductId__c = prod5.Id; 
	pLI5.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond';
	pLI5.Apttus_Config2__PriceType__c = 'One Time';
	pLI5.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI5);
	
	//PLI#6
	Apttus_Config2__PriceListItem__c pLI6 = TestDataSetup.creatPriceListItem(priceListSO, 1)[0];
	pLI6.Apttus_Config2__ProductId__c = prod6.Id; 
	pLI6.Apttus_Config2__PriceType__c = 'One Time';
	pLI6.Apttus_Config2__PriceMethod__c = 'Per Unit';
	plistItems.add(pLI6);
	
	insert plistItems;
	/*** Price List Item ends***/
	
	Apttus_Config2__PriceListCategory__c priceListCategorySO = TestDataSetup.createPriceListCategorySO(categoerySO, priceListSO);
	//Create Classification HierarchySO
	Apttus_Config2__ClassificationHierarchy__c chSO = TestDataSetup.createPriceListCategorySO(categoerySO);
	insert chSO;
	
	List<id> productIDList = new List<id>();
	for(Product2 productSO : prods){
	  productIDList.add(productSO.id);
	}
	
	/** Product classification*-------------------------------*/
	List<Apttus_Config2__ProductClassification__c> productClassificationList = getProductClasssification(priceListSO.id, productIDList);
	try{
	  insert productClassificationList;
	}catch(Exception ex){
	  
	}
	/** Product classification ends**/
	
	Apttus_Config2__ConfigCustomClasses__c custSetting = TestDataSetup.customSettingsRecord();
	insert custSetting;
	
	//Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	//Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();
	
	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	List<Account> accounts;
	Apttus_Proposal__Proposal__c testProposal;
	System.runAs(users[0]) {   
	  List<User> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	  
	  System.runAs(userList[0]){
		//Create Account
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
		opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';	  
		opportunities.get(0).StageName ='Create Offer (Bid)';
		opportunities.get(0).Phase_Status__c = 'Offer in Progress';
		insert opportunities.get(0);
		
		//create Accreditation
		
		/***Accreditation Creation starts***/
		List<Accreditation__c> accredList = TestDataSetup.createAccreditation(accounts[0]);
		accredList[0].Pricing_Level_Override__c = 'Co-Branded';
		insert accredList;
		/***Accreditation ends ***/
		
		Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
		tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
		tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
		insert tierDiscountSO;
		//create proposal
		
		
		/** Proposal Creation starts* --------needs to be optimized*/
		testProposal = TestDataSetup.createIPProposal(opportunities[0], accounts[0], priceListSO, accredList[0]);
		testProposal.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
		testProposal.NokiaCPQ_Maintenance_Type__c = 'Solution Support';
		testProposal.NokiaCPQ_SSP_Level__c = '';
		testProposal.NokiaCPQ_SRS_Level__c = '';
		testProposal.NokiaCPQ_No_of_Years__c = '5';
		insert testProposal;
		/**Proposal ends ***/
	  }
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], priceListSO,testProposal);
	  insert ProdConfig;
	  /*** product configuration Ends***/
	  
	  // Create the request object
	  Apttus_CPQApi.CPQ.AddMultiProductRequestDO addProductRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	  addProductRequest.CartId = ProdConfig.id;
	  
	  // Add the products to the request
	  Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod1.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  selectedProduct.CustomData = new Apttus_Config2__LineItem__c(is_Custom_Product__c = true, CustomProductValue__c='100;100;100');
	  selectedProduct.CustomFields = new List<string>{'is_Custom_Product__c', 'CustomProductValue__c'};
		addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod2.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod3.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod4.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod5.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  selectedProduct.ProductId = prod6.id;
	  selectedProduct.Quantity = 1;
	  selectedProduct.SellingTerm = 1;
	  addProductRequest.SelectedProducts.add(selectedProduct);
	  
	  // Execute the addMultiProducts routine
	  Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
	  Test.startTest(); 
	  
	  Shipping_Location__c ship= new Shipping_Location__c();
	  ship.Portfolio__c=Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
	  ship.Pricing_Cluster__c='MPW Cluster 2';
	  ship.Shipping_Location__c='Lewisville, Texas';
	  insert ship;
	  Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
	  
	  try{
		// create the update price request
		Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
		
		// add request parameters
		objUpdatePriceRequestDO.CartId = ProdConfig.id;//cartResponse.CartID;
		
		// update price for the cart
		Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		Boolean hasPendingItems = result.IsPricePending;
		
		system.debug('Is Price Pending...' + hasPendingItems);
		for(integer i=0;i<6;i++){
		  if(hasPendingItems){
			result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
			hasPendingItems = result.IsPricePending;
			system.debug('Is Price Pending...' + hasPendingItems);
		  }
		}
		List<Apttus_Config2__LineItem__c> lineItem = [select id, Apttus_Config2__NetPrice__c,Apttus_Config2__PriceListItemId__c
								,Apttus_Config2__BasePrice__c, Apttus_Config2__Quantity__c, Apttus_Config2__PricingStatus__c
								, Apttus_Config2__ProductId__c, Apttus_Config2__ListPrice__c
								from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:   ProdConfig.id];//cartResponse.CartID];
		if(lineItem != null && lineItem.size() > 0){
		  system.debug('cart lines size...' + lineItem.size());
		  system.debug('cart lines...' + lineItem);
		  for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
			System.debug('lineItemSO...'+ lineItemSO);
		  }
		}else{
		  system.debug('cart lines does not exist...');
		}
	  }catch(Exception ex){
		throw ex;
	  }
	}
	Test.stopTest();
  }
  
	static testMethod void directEnterprise_Guidance_NoMain() {
		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
		insert custSetting;

		Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
		Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
		Nokia_PricingCallBack npc = new Nokia_PricingCallBack();

		Custom_Constant_Field__c ccf = new Custom_Constant_Field__c();
		ccf.Name = 'Custom Constant Field';

		List<Opportunity> opportunities;
		List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
		users[0].Nokia_ID__c = '234597';
		insert users;


		System.runAs(users[0]) {   

		/************ Account Insertion  ***************/

		List<Account> accountsNew = new List<Account>();
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='101234567';
		accLegalEntity.Acc_No__c = '101234567';
		accLegalEntity.GEOLevel1ID__c ='RG_NAM';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accountsNew.add(accLegalEntity);
		//database.insert(accLegalEntity);

		Account account = TestDataFactory.createAccount(1)[0];
		account.AccountNumber='3011234567';
		account.Acc_No__c = '3011234567';
		account.GEOLevel1ID__c ='RG_NAM';
		accountsNew.add(account);
		//database.insert(account);

		insert accountsNew;

		List<Account> accounts=new List<Account>();
		accounts.add(account);

		//Create Opportunity
		opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);


		//Create Product
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Bundle',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
		); 
		prods.add(prod1);

		Product2 prod2 = new product2(
		Name = 'Maintenance Year1', 
		ProductCode = 'MT001', 
		//Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR',
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base'); 
		prods.add(prod2);

		Product2 prod4 = new product2(
		Name = 'SSP', 
		ProductCode = 'SSP002', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		IsActive = true,
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR',
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		); 
		prods.add(prod4);   
		Product2 prod5 = new product2(
		Name = 'Maintenance Year2+', 
		ProductCode = 'MT002', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
		); 
		prods.add(prod5);

		Product2 prod6 = new product2(
		Name = 'Bundle', 
		ProductCode = '123', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
		); 
		prods.add(prod6);

		Product2 prod7 = new product2(
		Name = 'SRS', 
		ProductCode = 'SRS001', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		IsActive = true,
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR',
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		); 
		prods.add(prod7);

		Product2 prod8 = new product2(
		Name = 'Contracted_sL', 
		ProductCode = 'CL_TEST', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
		); 
		prods.add(prod8);

		Product2 prod9 = new product2(
		Name = 'Contracted_sL1', 
		ProductCode = 'CL_TEST1', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IP'
		); 
		prods.add(prod9);

		insert prods;
		Test.startTest();
		
		//Create PriceList
		List<Apttus_Config2__PriceList__c> priceLists = new List<Apttus_Config2__PriceList__c>();
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', CurrencyIsoCode = 'USD',
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
		);
		priceLists.add(ApttusTestPriceList);
		Apttus_Config2__PriceList__c ApttusTestPriceList2 = new Apttus_Config2__PriceList__c(
		Name = 'CLP', CurrencyIsoCode = 'USD',
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'Direct'
		);
		priceLists.add(ApttusTestPriceList2);
		insert priceLists;

		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod1.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI1);

		Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod2.Id, 
		Apttus_Config2__PriceIncludedInBundle__c = true,
		Apttus_Config2__ChargeType__c = 'Maintenance Year1',
		Apttus_Config2__Cost__c = 10
		);
		//insert pLI2;
		plistItems.add(pLI2);

		Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'SSP',
		Apttus_Config2__Cost__c = 10
		);
		//insert pLI1;
		plistItems.add(pLI4);

		Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance Year2+',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI5);

		Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI6);

		Apttus_Config2__PriceListItem__c pLI7 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList2.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10,
		Contracted__c = 'Yes'
		);
		plistItems.add(pLI7);

		Apttus_Config2__PriceListItem__c pLI8 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod7.Id, 
		Apttus_Config2__ChargeType__c = 'SRS',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI8);

		Apttus_Config2__PriceListItem__c pLI9 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod8.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI9);

		/* Apttus_Config2__PriceListItem__c pLI10 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList2.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod8.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10,
		Contracted__c = 'Yes'
		);
		plistItems.add(pLI10); */

		Apttus_Config2__PriceListItem__c pLI11 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod9.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI11);

		insert plistItems;

		List<Product_Extension__c> PEList = new List<Product_Extension__c>();
		Product_Extension__c PE1 = new Product_Extension__c(
		Product__c = prod6.id,
		Market__c = 'Market North America',
		List_Price__c = 100,
		Floor_Price__c = 75,
		CurrencyIsoCode = 'USD'
		);
		PEList.add(PE1);
		Product_Extension__c PE2 = new Product_Extension__c(
		Product__c = prod8.id,
		Market__c = 'Market North America',
		List_Price__c = 100,
		Floor_Price__c = 110,
		CurrencyIsoCode = 'USD'
		);
		PEList.add(PE2);
		Product_Extension__c PE3 = new Product_Extension__c(
		Product__c = prod9.id,
		Market__c = 'Market North America',
		List_Price__c = 100,
		Floor_Price__c = 75,
		CurrencyIsoCode = 'USD'
		);
		PEList.add(PE3);
		Product_Extension__c PE4 = new Product_Extension__c(
		Product__c = prod1.id,
		Market__c = 'Market North America',
		List_Price__c = 100,
		Floor_Price__c = 75,
		CurrencyIsoCode = 'USD'
		);
		PEList.add(PE4);
		insert PEList;

		Product_Discount__c disc = new Product_Discount__c ();
		disc.Discount__c = 8.00;
		disc.Market__c = account.Market__c;
		disc.Product_Discount_Category__c = 'NFM-P';
		insert disc;

		//create proposal
		Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList2.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '3',
		NokiaCPQ_Maintenance_Type__c='Gold (Advanced Exchange)',
		NokiaCPQ_Existing_IONMaint_Contract__c = '',
		RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
		Apttus_Proposal__Account__c=accLegalEntity.id,
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		//NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=false,
		Sold_To_Party__c = accLegalEntity.id,
		Is_List_Price_Only__c =false,
		NokiaCPQ_SRS_Level__c = '',
		NokiaCPQ_SSP_Level__c='',
		Price_List__c = 'CLP',
		CurrencyIsoCode = 'USD'
		);
		insert testProposal;

	   /* testProposal.Price_List__c = 'CLP';
		testProposal.CurrencyIsoCode = 'USD';
			update testProposal;*/

		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
		Name = 'APTTUS Test Config', 
		Apttus_Config2__AccountId__c = account.Id, 
		Apttus_Config2__PriceListId__c = ApttusTestPriceList2.Id, 
		Apttus_QPConfig__Proposald__c = testProposal.Id, 
		Apttus_Config2__Status__c = 'New', 
		Apttus_Config2__VersionNumber__c = 1, 
		Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList2.Id,
		Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
		Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

		//Create Line Items
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();

		Apttus_Config2__LineItem__c LineItem=new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList2.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__PriceListItemId__c = pLI7.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__BasePrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		NokiaCPQ_Floor_Price__c = 50,
		Apttus_Config2__AllowManualAdjustment__c = true,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem);

		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList2.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Option',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__OptionId__c = prod6.Id,
		Apttus_Config2__PriceListItemId__c = pLI7.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__BasePrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__AllowManualAdjustment__c = true,
		NokiaCPQ_Floor_Price__c = 50,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__AdjustmentType__c = 'Price Override',
		Apttus_Config2__AdjustmentAmount__c = 150,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem1);


			Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 2,
		Apttus_Config2__LineNumber__c = 2,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Option', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__OptionId__c = prod8.Id,
		Apttus_Config2__PriceListItemId__c = pLI9.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AllowManualAdjustment__c = true,
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 90,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		NokiaCPQ_Floor_Price__c = 110,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,
		Apttus_Config2__AdjustmentType__c = 'Discount Amount',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem2;
		allLineItems.add(LineItem2);

		Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 3,
		Apttus_Config2__LineNumber__c = 3,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod9.Id,
		Apttus_Config2__PriceListItemId__c = pLI11.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__BasePrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		NokiaCPQ_Floor_Price__c = 110,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,
		Apttus_Config2__AllowManualAdjustment__c = true,
		Apttus_Config2__AdjustmentType__c = '% Discount',
		Apttus_Config2__AdjustmentAmount__c = 30,
		Apttus_Config2__AddedBy__c = 'added by code'
		);

		allLineItems.add(LineItem3);



		Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 4,
		Apttus_Config2__LineNumber__c = 4,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod9.Id,
		Apttus_Config2__PriceListItemId__c = pLI11.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__BasePrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		NokiaCPQ_Floor_Price__c = 10,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Apttus_Config2__AllowManualAdjustment__c = true,
		Apttus_Config2__AdjustmentType__c = 'Price Override',
		Apttus_Config2__AdjustmentAmount__c = 150,
		Apttus_Config2__AddedBy__c = 'added by code'
		);
		allLineItems.add(LineItem4);

		Apttus_Config2__LineItem__c LineItem14 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 9,
		Apttus_Config2__LineNumber__c = 9,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod9.Id,
		Apttus_Config2__PriceListItemId__c = pLI11.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__BasePrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Apttus_Config2__AllowManualAdjustment__c = true,
		Apttus_Config2__AdjustmentType__c = 'Price Override',
		Apttus_Config2__AdjustmentAmount__c = 150,
		Apttus_Config2__AddedBy__c = 'added by code'
		);
		allLineItems.add(LineItem14);

		Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 5,
		Apttus_Config2__LineNumber__c = 5,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Maintenance Year1', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod2.Id,
		Apttus_Config2__PriceListItemId__c = pLI2.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Apttus_Config2__PriceIncludedInBundle__c = true,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		is_Custom_Product__c=false,
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__AddedBy__c = 'added by code',
		Advanced_pricing_done__c = false			
		);
		//insert LineItem1;
		allLineItems.add(LineItem5);




		Apttus_Config2__LineItem__c LineItem6 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 6,
		Apttus_Config2__LineNumber__c = 6,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'SSP', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod4.Id,
		Apttus_Config2__PriceListItemId__c = pLI4.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 90,
			
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem1;
		allLineItems.add(LineItem6);

		Apttus_Config2__LineItem__c LineItem7 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 7,
		Apttus_Config2__LineNumber__c = 7,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Maintenance Year2+', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod5.Id,
		Apttus_Config2__PriceListItemId__c = pLI5.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'Yearly',
		NokiaCPQ_Maint_Yr2_Extended_Price__c = 100,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 200,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem1;
		allLineItems.add(LineItem7);
			Apttus_Config2__LineItem__c LineItem8 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 8,
		Apttus_Config2__LineNumber__c = 8,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'SRS', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod7.Id,
		Apttus_Config2__PriceListItemId__c = pLI8.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 90,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem1;
		allLineItems.add(LineItem8);
			
		insert allLineItems;

		// Test.startTest(); 

		CPQ_Maintenance_and_SSP_Rule__c rec1 = new CPQ_Maintenance_and_SSP_Rule__c();
		rec1.Maintenance_Level__c = 'Nokia Brand of Service';
		rec1.Maintenance_Type__c = 'Gold (Return for Exchange)';
		rec1.Region__c = 'RG_NAM';
		rec1.Service_Rate_Y1__c = 0.05;
		rec1.Service_Rate_Y2__c = 0.05;
		rec1.Unlimited_SSP_Discount__c = 0.03; 
		rec1.Maintenance_Category__c = 'NSD-NRC IPR';
		insert rec1;
		list<NokiaCPQ_Maintenance_and_SSP_Rules__c> listMaintSSPRule =  [SELECT NokiaCPQ_withPMA__c, NokiaCPQ_Pricing_Cluster__c, NokiaCPQ_Product_Discount_Category__c, NokiaCPQ_Product_Discount_Category_per__c, NokiaCPQ_Unlimited_SSP_Discount__c, NokiaCPQ_Biennial_SSP_Discount__c, NokiaCPQ_Maintenance_Level__c, NokiaCPQ_Maintenance_Type__c, NokiaCPQ_Service_Rate_Y1__c, NokiaCPQ_Service_Rate_Y2__c FROM NokiaCPQ_Maintenance_and_SSP_Rules__c ]; 

		//obj.finish();

	  //  testProposal.SSP__c = 100;
	  //  testProposal.SRS__c = 100;
		testProposal.NokiaCPQ_Needs_Reprice__c = true;
		update testProposal;
		Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
		obj.deal_Guidance_Calculator(allLineItems[1],'Standalone');
			obj.deal_Guidance_Calculator(allLineItems[2],'Standalone');
			obj.deal_Guidance_Calculator(allLineItems[3],'Standalone');
			obj.deal_Guidance_Calculator(allLineItems[4],'Standalone');
			obj.deal_Guidance_Calculator(allLineItems[5],'Bundle');
			obj.deal_Guidance_Calculator(allLineItems[6],'Standalone');
			obj.deal_Guidance_Calculator(allLineItems[7],'Bundle');
		obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
		Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);

		obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
		obj.finish();
		Test.stopTest();
		}
		// Test.stopTest();
	}

	static testMethod void directEnterprise_Guidance(){
		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
		insert custSetting;

		Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
		Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
		Nokia_PricingCallBack npc = new Nokia_PricingCallBack();

		Custom_Constant_Field__c ccf = new Custom_Constant_Field__c();
		ccf.Name = 'Custom Constant Field';

		List<Opportunity> opportunities;
		List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
		users[0].Nokia_ID__c = '234597';
		insert users;


		System.runAs(users[0]) {   

		/************ Account Insertion  ***************/

		List<Account> accountsNew = new List<Account>();
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='101234567';
		accLegalEntity.Acc_No__c = '101234567';
		accLegalEntity.GEOLevel1ID__c ='RG_NAM';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accountsNew.add(accLegalEntity);
		//database.insert(accLegalEntity);

		Account account = TestDataFactory.createAccount(1)[0];
		account.AccountNumber='3011234567';
		account.Acc_No__c = '3011234567';
		account.GEOLevel1ID__c ='RG_NAM';
		accountsNew.add(account);
		//database.insert(account);

		insert accountsNew;

		List<Account> accounts=new List<Account>();
		accounts.add(account);

		//Create Opportunity
		opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);


		//Create Product
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Bundle',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
		); 
		prods.add(prod1);

		Product2 prod2 = new product2(
		Name = 'Maintenance Year1', 
		ProductCode = 'MT001', 
		//Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR',
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base'); 
		prods.add(prod2);

		Product2 prod4 = new product2(
		Name = 'SSP', 
		ProductCode = 'SSP002', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		IsActive = true,
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR',
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		); 
		prods.add(prod4);   
		Product2 prod5 = new product2(
		Name = 'Maintenance Year2+', 
		ProductCode = 'MT002', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
		); 
		prods.add(prod5);

		Product2 prod6 = new product2(
		Name = 'Bundle', 
		ProductCode = '123', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
		); 
		prods.add(prod6);

		Product2 prod7 = new product2(
		Name = 'SRS', 
		ProductCode = 'SRS001', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		IsActive = true,
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR',
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		); 
		prods.add(prod7);

		Product2 prod8 = new product2(
		Name = 'Contracted_sL', 
		ProductCode = 'CL_TEST', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
		); 
		prods.add(prod8);

		Product2 prod9 = new product2(
		Name = 'Contracted_sL1', 
		ProductCode = 'CL_TEST1', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IP'
		); 
		prods.add(prod9);

		insert prods;

		Test.startTest();
		//Create PriceList
		List<Apttus_Config2__PriceList__c> priceLists = new List<Apttus_Config2__PriceList__c>();
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', CurrencyIsoCode = 'USD',
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
		);
		priceLists.add(ApttusTestPriceList);
		Apttus_Config2__PriceList__c ApttusTestPriceList2 = new Apttus_Config2__PriceList__c(
		Name = 'CLP', CurrencyIsoCode = 'USD',
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'Direct'
		);
		priceLists.add(ApttusTestPriceList2);
		insert priceLists;

		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod1.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI1);

		Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod2.Id, 
		Apttus_Config2__PriceIncludedInBundle__c = true,
		Apttus_Config2__ChargeType__c = 'Maintenance Year1',
		Apttus_Config2__Cost__c = 10
		);
		//insert pLI2;
		plistItems.add(pLI2);

		Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'SSP',
		Apttus_Config2__Cost__c = 10
		);
		//insert pLI1;
		plistItems.add(pLI4);

		Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance Year2+',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI5);

		Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI6);

		Apttus_Config2__PriceListItem__c pLI7 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList2.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10,
		Contracted__c = 'Yes'
		);
		plistItems.add(pLI7);

		Apttus_Config2__PriceListItem__c pLI8 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod7.Id, 
		Apttus_Config2__ChargeType__c = 'SRS',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI8);

		Apttus_Config2__PriceListItem__c pLI9 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod8.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI9);

		/* Apttus_Config2__PriceListItem__c pLI10 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList2.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod8.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10,
		Contracted__c = 'Yes'
		);
		plistItems.add(pLI10); */

		Apttus_Config2__PriceListItem__c pLI11 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod9.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI11);

		insert plistItems;

		List<Product_Extension__c> PEList = new List<Product_Extension__c>();
		Product_Extension__c PE1 = new Product_Extension__c(
		Product__c = prod6.id,
		Market__c = 'Market North America',
		List_Price__c = 100,
		Floor_Price__c = 75,
		CurrencyIsoCode = 'USD'
		);
		PEList.add(PE1);
		Product_Extension__c PE2 = new Product_Extension__c(
		Product__c = prod8.id,
		Market__c = 'Market North America',
		List_Price__c = 100,
		Floor_Price__c = 110,
		CurrencyIsoCode = 'USD'
		);
		PEList.add(PE2);
		Product_Extension__c PE3 = new Product_Extension__c(
		Product__c = prod9.id,
		Market__c = 'Market North America',
		List_Price__c = 100,
		Floor_Price__c = 75,
		CurrencyIsoCode = 'USD'
		);
		PEList.add(PE3);
		Product_Extension__c PE4 = new Product_Extension__c(
		Product__c = prod1.id,
		Market__c = 'Market North America',
		List_Price__c = 100,
		Floor_Price__c = 75,
		CurrencyIsoCode = 'USD'
		);
		PEList.add(PE4);
		insert PEList;

		Product_Discount__c disc = new Product_Discount__c ();
		disc.Discount__c = 8.00;
		disc.Market__c = account.Market__c;
		disc.Product_Discount_Category__c = 'NFM-P';
		insert disc;

		//create proposal
		Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList2.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '3',
		NokiaCPQ_Maintenance_Type__c='Gold (Return for Exchange)',
		RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
		Apttus_Proposal__Account__c=accLegalEntity.id,
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		Sold_To_Party__c = accLegalEntity.id,
		Is_List_Price_Only__c =false,
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No'
		);
		insert testProposal;

		testProposal.Price_List__c = 'CLP';
		testProposal.CurrencyIsoCode = 'USD';
		update testProposal;

		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
		Name = 'APTTUS Test Config', 
		Apttus_Config2__AccountId__c = account.Id, 
		Apttus_Config2__PriceListId__c = ApttusTestPriceList2.Id, 
		Apttus_QPConfig__Proposald__c = testProposal.Id, 
		Apttus_Config2__Status__c = 'New', 
		Apttus_Config2__VersionNumber__c = 1, 
		Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList2.Id,
		Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
		Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

		//Create Line Items
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();

		Apttus_Config2__LineItem__c LineItem=new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList2.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__PriceListItemId__c = pLI7.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__BasePrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		NokiaCPQ_Floor_Price__c = 50,
		Apttus_Config2__AllowManualAdjustment__c = true,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem);

		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList2.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Option',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__OptionId__c = prod6.Id,
		Apttus_Config2__PriceListItemId__c = pLI7.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__BasePrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__AllowManualAdjustment__c = true,
		NokiaCPQ_Floor_Price__c = 50,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__AdjustmentType__c = 'Price Override',
		Apttus_Config2__AdjustmentAmount__c = 150,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem1);


		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 2,
		Apttus_Config2__LineNumber__c = 2,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Option', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__OptionId__c = prod8.Id,
		Apttus_Config2__PriceListItemId__c = pLI9.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AllowManualAdjustment__c = true,
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 90,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		NokiaCPQ_Floor_Price__c = 110,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,
		Apttus_Config2__AdjustmentType__c = 'Discount Amount',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem2;
		allLineItems.add(LineItem2);

		Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 3,
		Apttus_Config2__LineNumber__c = 3,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod9.Id,
		Apttus_Config2__PriceListItemId__c = pLI11.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__BasePrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		NokiaCPQ_Floor_Price__c = 110,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,
		Apttus_Config2__AllowManualAdjustment__c = true,
		Apttus_Config2__AdjustmentType__c = '% Discount',
		Apttus_Config2__AdjustmentAmount__c = 30,
		Apttus_Config2__AddedBy__c = 'added by code'
		);

		allLineItems.add(LineItem3);



		Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 4,
		Apttus_Config2__LineNumber__c = 4,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod9.Id,
		Apttus_Config2__PriceListItemId__c = pLI11.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__BasePrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		NokiaCPQ_Floor_Price__c = 10,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Apttus_Config2__AllowManualAdjustment__c = true,
		Apttus_Config2__AdjustmentType__c = 'Price Override',
		Apttus_Config2__AdjustmentAmount__c = 150,
		Apttus_Config2__AddedBy__c = 'added by code'
		);
		allLineItems.add(LineItem4);

		Apttus_Config2__LineItem__c LineItem14 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 9,
		Apttus_Config2__LineNumber__c = 9,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod9.Id,
		Apttus_Config2__PriceListItemId__c = pLI11.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__BasePrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Apttus_Config2__AllowManualAdjustment__c = true,
		Apttus_Config2__AdjustmentType__c = 'Price Override',
		Apttus_Config2__AdjustmentAmount__c = 150,
		Apttus_Config2__AddedBy__c = 'added by code'
		);
		allLineItems.add(LineItem14);

		Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 5,
		Apttus_Config2__LineNumber__c = 5,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Maintenance Year1', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod2.Id,
		Apttus_Config2__PriceListItemId__c = pLI2.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Apttus_Config2__PriceIncludedInBundle__c = true,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		is_Custom_Product__c=false,
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__AddedBy__c = 'added by code',
		Advanced_pricing_done__c = false			
		);
		//insert LineItem1;
		allLineItems.add(LineItem5);




		Apttus_Config2__LineItem__c LineItem6 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 6,
		Apttus_Config2__LineNumber__c = 6,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'SSP', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod4.Id,
		Apttus_Config2__PriceListItemId__c = pLI4.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 90,
			
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem1;
		allLineItems.add(LineItem6);

		Apttus_Config2__LineItem__c LineItem7 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 7,
		Apttus_Config2__LineNumber__c = 7,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Maintenance Year2+', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod5.Id,
		Apttus_Config2__PriceListItemId__c = pLI5.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'Yearly',
		NokiaCPQ_Maint_Yr2_Extended_Price__c = 100,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 200,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem1;
		allLineItems.add(LineItem7);
		Apttus_Config2__LineItem__c LineItem8 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 8,
		Apttus_Config2__LineNumber__c = 8,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'SRS', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod7.Id,
		Apttus_Config2__PriceListItemId__c = pLI8.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 90,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem1;
		allLineItems.add(LineItem8);
			
		insert allLineItems;

	   // Test.startTest(); 

		CPQ_Maintenance_and_SSP_Rule__c rec1 = new CPQ_Maintenance_and_SSP_Rule__c();
		rec1.Maintenance_Level__c = 'Nokia Brand of Service';
		rec1.Maintenance_Type__c = 'Gold (Return for Exchange)';
		rec1.Region__c = 'RG_NAM';
		rec1.Service_Rate_Y1__c = 0.05;
		rec1.Service_Rate_Y2__c = 0.05;
		rec1.Unlimited_SSP_Discount__c = 0.03; 
		rec1.Maintenance_Category__c = 'NSD-NRC IPR';
		insert rec1;
		list<NokiaCPQ_Maintenance_and_SSP_Rules__c> listMaintSSPRule =  [SELECT NokiaCPQ_withPMA__c, NokiaCPQ_Pricing_Cluster__c, NokiaCPQ_Product_Discount_Category__c, NokiaCPQ_Product_Discount_Category_per__c, NokiaCPQ_Unlimited_SSP_Discount__c, NokiaCPQ_Biennial_SSP_Discount__c, NokiaCPQ_Maintenance_Level__c, NokiaCPQ_Maintenance_Type__c, NokiaCPQ_Service_Rate_Y1__c, NokiaCPQ_Service_Rate_Y2__c FROM NokiaCPQ_Maintenance_and_SSP_Rules__c ]; 

		//obj.finish();
		testProposal.Maintenance_Y1__c = 100;
		testProposal.Maintenance_Y2__c = 100;
		testProposal.SSP__c = 100;
		testProposal.SRS__c = 100;
		testProposal.NokiaCPQ_Needs_Reprice__c = true;
		update testProposal;
		Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
		obj.deal_Guidance_Calculator(allLineItems[1],'Standalone');
			obj.deal_Guidance_Calculator(allLineItems[2],'Standalone');
			obj.deal_Guidance_Calculator(allLineItems[3],'Standalone');
			obj.deal_Guidance_Calculator(allLineItems[4],'Standalone');
			obj.deal_Guidance_Calculator(allLineItems[5],'Bundle');
			obj.deal_Guidance_Calculator(allLineItems[6],'Standalone');
			obj.deal_Guidance_Calculator(allLineItems[7],'Bundle');
		obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
		Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);

		obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
		obj.finish();
		Test.stopTest();
		}
	}

	static testMethod void directEnterprise_FN() {
		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
		insert custSetting;

		Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
		Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
		Nokia_PricingCallBack npc = new Nokia_PricingCallBack();

		Custom_Constant_Field__c ccf = new Custom_Constant_Field__c();
		ccf.Name = 'Custom Constant Field';

		List<Opportunity> opportunities;
		List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
		users[0].Nokia_ID__c = '234597';
		insert users;


		System.runAs(users[0]) {   

		/************ Account Insertion  ***************/

		List<Account> accountsNew = new List<Account>();
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='101234567';
		accLegalEntity.Acc_No__c = '101234567';
		accLegalEntity.GEOLevel1ID__c ='RG_NAM';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accountsNew.add(accLegalEntity);
		//database.insert(accLegalEntity);

		Account account = TestDataFactory.createAccount(1)[0];
		account.AccountNumber='3011234567';
		account.Acc_No__c = '3011234567';
		account.GEOLevel1ID__c ='RG_NAM';
		accountsNew.add(account);
		//database.insert(account);

		insert accountsNew;

		List<Account> accounts=new List<Account>();
		accounts.add(account);

		//Create Opportunity
		opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		//opportunities.get(0).Lead_BG__c = 'FN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);


		//Create Product
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Direct_Portfolio__c = 'Fixed Network',
		Portfolio__c = 'Fixed Network',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Bundle',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010G-A FBA'
		); 
		prods.add(prod1);

		Product2 prod2 = new product2(
		Name = 'Maintenance Year1', 
		ProductCode = 'MT001', 
		//Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Direct_Portfolio__c = 'Fixed Network',
		Portfolio__c = 'Fixed Network',
		IsActive = true,
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010G-A FBA',
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base'); 
		prods.add(prod2);

		Product2 prod4 = new product2(
		Name = 'SSP', 
		ProductCode = 'SSP002', 
	   // Business_Group__c = 'FN', 
		CurrencyIsoCode = 'USD',
		IsActive = true,
		Direct_Portfolio__c = 'Fixed Network',
		Portfolio__c = 'Fixed Network',
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010G-A FBA',
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		); 
		prods.add(prod4);   
		Product2 prod5 = new product2(
		Name = 'Maintenance Year2+', 
		ProductCode = 'MT002', 
	   // Business_Group__c = 'FN', 
		CurrencyIsoCode = 'USD',
		Direct_Portfolio__c = 'Fixed Network',
		Portfolio__c = 'Fixed Network',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010G-A FBA'
		); 
		prods.add(prod5);

		Product2 prod6 = new product2(
		Name = 'Bundle', 
		ProductCode = '123', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Direct_Portfolio__c = 'Fixed Network',
		Portfolio__c = 'Fixed Network',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010G-A FBA'
		); 
		prods.add(prod6);

		insert prods;
		
		Test.startTest();
		//Create PriceList
		List<Apttus_Config2__PriceList__c> priceLists = new List<Apttus_Config2__PriceList__c>();
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
		);
		priceLists.add(ApttusTestPriceList);
		Apttus_Config2__PriceList__c ApttusTestPriceList2 = new Apttus_Config2__PriceList__c(
		Name = 'CLP', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'Direct'
		);
		priceLists.add(ApttusTestPriceList2);
		insert priceLists;

		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod1.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI1);

		Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod2.Id, 
		Apttus_Config2__PriceIncludedInBundle__c = true,
		Apttus_Config2__ChargeType__c = 'Maintenance Year1',
		Apttus_Config2__Cost__c = 10
		);
		//insert pLI2;
		plistItems.add(pLI2);

		Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'SSP',
		Apttus_Config2__Cost__c = 10
		);
		//insert pLI1;
		plistItems.add(pLI4);

		Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance Year2+',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI5);

		Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI6);

		Apttus_Config2__PriceListItem__c pLI7 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList2.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI7);

		insert plistItems;

		Product_Discount__c disc = new Product_Discount__c ();
		disc.Discount__c = 8.00;
		disc.Market__c = account.Market__c;
		disc.Product_Discount_Category__c = 'ONT-G-010G-A FBA';
		insert disc;

		//create proposal
		Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Portfolio__c = 'Fixed Network',
		NokiaCPQ_No_of_Years__c = '3',
		NokiaCPQ_Maintenance_Type__c='Gold (Return for Exchange)',
		RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
		Apttus_Proposal__Account__c=accLegalEntity.id,
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		Sold_To_Party__c = accLegalEntity.id,
		Is_List_Price_Only__c =false,
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No'
		);
		insert testProposal;


		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
		Name = 'APTTUS Test Config', 
		Apttus_Config2__AccountId__c = account.Id, 
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
		Apttus_QPConfig__Proposald__c = testProposal.Id, 
		Apttus_Config2__Status__c = 'New', 
		Apttus_Config2__VersionNumber__c = 1, 
		Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
		Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

		//Create Line Items
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();

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
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__BasePrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
			Total_ONT_Quantity__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem3);

		Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 2,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Maintenance Year1', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod2.Id,
		Apttus_Config2__PriceListItemId__c = pLI2.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Apttus_Config2__PriceIncludedInBundle__c = true,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		is_Custom_Product__c=false,
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__AddedBy__c = 'added by code',
			Total_ONT_Quantity__c =1,
		Advanced_pricing_done__c = false			
		);
		//insert LineItem1;
		allLineItems.add(LineItem4);


		Apttus_Config2__LineItem__c LineItem6 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 3,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'SSP', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod4.Id,
		Apttus_Config2__PriceListItemId__c = pLI4.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 90,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
			Total_ONT_Quantity__c =1,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem1;
		allLineItems.add(LineItem6);

		Apttus_Config2__LineItem__c LineItem7 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 4,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Maintenance Year2+', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod5.Id,
		Apttus_Config2__PriceListItemId__c = pLI5.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'Yearly',
		NokiaCPQ_Maint_Yr2_Extended_Price__c = 100,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 200,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
			Total_ONT_Quantity__c = 1,
		Advanced_pricing_done__c = false,

		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem1;
		allLineItems.add(LineItem7);

		Apttus_Config2__LineItem__c LineItem8 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Option',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__OptionId__c = prod6.Id,
		Apttus_Config2__ParentBundleNumber__c = 1,
		Apttus_Config2__PriceListItemId__c = pLI7.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__BasePrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,
		Total_ONT_Quantity__c = 1,
		Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem8);

		insert allLineItems;

		//Test.startTest(); 

		CPQ_Maintenance_and_SSP_Rule__c rec1 = new CPQ_Maintenance_and_SSP_Rule__c();
		rec1.Maintenance_Level__c = 'Nokia Brand of Service';
		rec1.Maintenance_Type__c = 'Gold (Return for Exchange)';
		rec1.Region__c = 'RG_NAM';
		rec1.Service_Rate_Y1__c = 0.05;
		rec1.Service_Rate_Y2__c = 0.05;
		rec1.Unlimited_SSP_Discount__c = 0.03; 
		rec1.Maintenance_Category__c = 'ONT-G-010G-A FBA';
		insert rec1;
		list<NokiaCPQ_Maintenance_and_SSP_Rules__c> listMaintSSPRule =  [SELECT NokiaCPQ_withPMA__c, NokiaCPQ_Pricing_Cluster__c, NokiaCPQ_Product_Discount_Category__c, NokiaCPQ_Product_Discount_Category_per__c, NokiaCPQ_Unlimited_SSP_Discount__c, NokiaCPQ_Biennial_SSP_Discount__c, NokiaCPQ_Maintenance_Level__c, NokiaCPQ_Maintenance_Type__c, NokiaCPQ_Service_Rate_Y1__c, NokiaCPQ_Service_Rate_Y2__c FROM NokiaCPQ_Maintenance_and_SSP_Rules__c ]; 
		Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
			
		obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
		Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);

		obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
		Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);

		//Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
		Test.stopTest();
		}
	}

	static testMethod void directFBA(){
		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
		insert custSetting;

		Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
		Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
		Nokia_PricingCallBack npc = new Nokia_PricingCallBack();

		Custom_Constant_Field__c ccf = new Custom_Constant_Field__c();
		ccf.Name = 'Custom Constant Field';

		List<Opportunity> opportunities;
		List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
		users[0].Nokia_ID__c = '234597';
		insert users;


		System.runAs(users[0]) {   

		/************ Account Insertion  ***************/

		List<Account> accountsNew = new List<Account>();
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='101234567';
		accLegalEntity.Acc_No__c = '101234567';
		accLegalEntity.GEOLevel1ID__c ='RG_NAM';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accountsNew.add(accLegalEntity);
		//database.insert(accLegalEntity);

		Account account = TestDataFactory.createAccount(1)[0];
		account.AccountNumber='3011234567';
		account.Acc_No__c = '3011234567';
		account.GEOLevel1ID__c ='RG_NAM';
		accountsNew.add(account);
		//database.insert(account);

		insert accountsNew;

		List<Account> accounts=new List<Account>();
		accounts.add(account);

		//Create Opportunity
		opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);


		//Create Product
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'Fixed Access - FBA',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Bundle',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010P-A FBA'
		); 
		prods.add(prod1);

		Product2 prod2 = new product2(
		Name = 'Maintenance Year1', 
		ProductCode = 'MT001', 
		//Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'Fixed Access - FBA',
		IsActive = true,
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010P-A FBA',
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base'); 
		prods.add(prod2);

		Product2 prod3 = new product2(
		Name = 'SSP', 
		ProductCode = 'SSP002', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		IsActive = true,
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010P-A FBA',
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		); 
		prods.add(prod3);   
		Product2 prod4 = new product2(
		Name = 'Maintenance Year2+', 
		ProductCode = 'MT002', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'Fixed Access - FBA',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010P-A FBA'
		); 
		prods.add(prod4);

		Product2 prod5 = new product2(
		Name = 'SRS', 
		ProductCode = 'SRS002', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'Fixed Access - FBA',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010P-A FBA'
		); 
		prods.add(prod5);

		insert prods;
		
		Test.startTest();

		//Create PriceList
		List<Apttus_Config2__PriceList__c> priceLists = new List<Apttus_Config2__PriceList__c>();
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
		);
		priceLists.add(ApttusTestPriceList);
		Apttus_Config2__PriceList__c ApttusTestPriceList2 = new Apttus_Config2__PriceList__c(
		Name = 'CLP', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'Direct'
		);
		priceLists.add(ApttusTestPriceList2);
		insert priceLists;

		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod1.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI1);

		Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod2.Id, 
		Apttus_Config2__PriceIncludedInBundle__c = true,
		Apttus_Config2__ChargeType__c = 'Maintenance Year1',
		Apttus_Config2__Cost__c = 10
		);
		//insert pLI2;
		plistItems.add(pLI2);

		Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod3.Id, 
		Apttus_Config2__ChargeType__c = 'SSP',
		Apttus_Config2__Cost__c = 10
		);
		//insert pLI1;
		plistItems.add(pLI3);

		Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance Year2+',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI4);

		Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'SRS',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI5);

		insert plistItems;

		Product_Discount__c disc = new Product_Discount__c ();
		disc.Discount__c = 8.00;
		disc.Market__c = account.Market__c;
		disc.Product_Discount_Category__c = 'NFM-P';
		insert disc;

		//create proposal
		Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.NOKIA_FN, 
		NokiaCPQ_No_of_Years__c = '3',
		NokiaCPQ_Maintenance_Type__c='Gold (Return for Exchange)',
		RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
		Apttus_Proposal__Account__c=accLegalEntity.id,
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes',
		Sold_To_Party__c = accLegalEntity.id,
		Is_List_Price_Only__c =false
		);
		insert testProposal;


		system.debug('testProposal:'+testProposal);

		//create product configuration
		list<Apttus_Config2__ProductConfiguration__c> ProdConfigList = new list<Apttus_Config2__ProductConfiguration__c>();
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
		Name = 'APTTUS Test Config', 
		Apttus_Config2__AccountId__c = account.Id, 
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
		Apttus_QPConfig__Proposald__c = testProposal.Id, 
		Apttus_Config2__Status__c = 'New', 
		Apttus_Config2__VersionNumber__c = 1, 
		Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
		Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;
		ProdConfigList.add(ProdConfig);
		//Create Line Items
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();

		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfigList[0].Id,
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
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__BasePrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,
		Nokia_Maint_Y1_Per__c = 7,
		Nokia_Maint_Y2_Per__c = 7,
			
		Apttus_Config2__AddedBy__c = 'added by code'
		);

		allLineItems.add(LineItem1);

		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfigList[0].Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 2,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Maintenance Year1', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod2.Id,
		Apttus_Config2__PriceListItemId__c = pLI2.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Apttus_Config2__PriceIncludedInBundle__c = true,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		is_Custom_Product__c=false,
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__AddedBy__c = 'added by code',
		Advanced_pricing_done__c = false			
		);

		allLineItems.add(LineItem2);


		Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfigList[0].Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 3,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'SSP', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod3.Id,
		Apttus_Config2__PriceListItemId__c = pLI3.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 90,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,
		is_Custom_Product__c=false,
		Apttus_Config2__AddedBy__c = 'added by code'	 
		);

		allLineItems.add(LineItem3);

		Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfigList[0].Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 4,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Maintenance Y2+', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod4.Id,
		Apttus_Config2__PriceListItemId__c = pLI4.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'Yearly',
		NokiaCPQ_Maint_Yr2_Extended_Price__c = 100,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 200,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,
		is_Custom_Product__c=false,
		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		allLineItems.add(LineItem4);

		Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfigList[0].Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 4,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'SRS', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod5.Id,
		Apttus_Config2__PriceListItemId__c = pLI5.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'Yearly',
		NokiaCPQ_Maint_Yr2_Extended_Price__c = 100,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 200,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,
		is_Custom_Product__c=false,
		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		allLineItems.add(LineItem5);

		insert allLineItems;

		//Test.startTest(); 

		CPQ_Maintenance_and_SSP_Rule__c rec1 = new CPQ_Maintenance_and_SSP_Rule__c();
		rec1.Maintenance_Level__c = 'Nokia Brand of Service';
		rec1.Maintenance_Type__c = 'Gold (Return for Exchange)';
		rec1.Region__c = 'RG_NAM';
		rec1.Service_Rate_Y1__c = 0.05;
		rec1.Service_Rate_Y2__c = 0.05;
		rec1.Unlimited_SSP_Discount__c = 0.03; 
		rec1.Maintenance_Category__c = 'ONT-G-010P-A FBA';
		insert rec1;

		Nokia_PricingCallBack obj = new Nokia_PricingCallBack();

		obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
		Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfigList[0].Id);

		obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
		obj.finish();

		//Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfigList[0].Id);

		//Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
		Test.stopTest();
		}
	}
	
	
	static testMethod void directFBA23() {
		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
		//insert custSetting;

		Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
		Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
		Nokia_PricingCallBack npc = new Nokia_PricingCallBack();

		Custom_Constant_Field__c ccf = new Custom_Constant_Field__c();
		ccf.Name = 'Custom Constant Field';

		List<Opportunity> opportunities;
		List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
		users[0].Nokia_ID__c = '234597';
		insert users;

		System.runAs(users[0]) {   

		/************ Account Insertion  ***************/

		List<Account> accountsNew = new List<Account>();
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='101234567';
		accLegalEntity.Acc_No__c = '101234567';
		accLegalEntity.GEOLevel1ID__c ='RG_NAM';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accountsNew.add(accLegalEntity);
		//database.insert(accLegalEntity);

		Account account = TestDataFactory.createAccount(1)[0];
		account.AccountNumber='3011234567';
		account.Acc_No__c = '3011234567';
		account.GEOLevel1ID__c ='RG_NAM';
		accountsNew.add(account);
		//database.insert(account);

		insert accountsNew;

		List<Account> accounts=new List<Account>();
		accounts.add(account);

		//Create Opportunity
		opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);


		//Create Product
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'Fixed Access - FBA',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Bundle',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010P-A FBA'
		); 
		prods.add(prod1);

		Product2 prod2 = new product2(
		Name = 'Maintenance Year1', 
		ProductCode = 'MT001', 
		//Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'Fixed Access - FBA',
		IsActive = true,
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010P-A FBA',
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base'); 
		prods.add(prod2);

		Product2 prod3 = new product2(
		Name = 'SSP', 
		ProductCode = 'SSP002', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		IsActive = true,
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010P-A FBA',
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		); 
		prods.add(prod3);   
		Product2 prod4 = new product2(
		Name = 'Maintenance Year2+', 
		ProductCode = 'MT002', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'Fixed Access - FBA',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010P-A FBA'
		); 
		prods.add(prod4);

		Product2 prod5 = new product2(
		Name = 'SRS', 
		ProductCode = 'SRS002', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'Fixed Access - FBA',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010P-A FBA'
		); 
		prods.add(prod5);

		insert prods;

		//Create PriceList
		List<Apttus_Config2__PriceList__c> priceLists = new List<Apttus_Config2__PriceList__c>();
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
		);
		priceLists.add(ApttusTestPriceList);
		Apttus_Config2__PriceList__c ApttusTestPriceList2 = new Apttus_Config2__PriceList__c(
		Name = 'CLP', 
		Apttus_Config2__Active__c = True, PriceList_Type__c = 'Direct'
		);
		priceLists.add(ApttusTestPriceList2);
		insert priceLists;

		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod1.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI1);

		Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod2.Id, 
		Apttus_Config2__PriceIncludedInBundle__c = true,
		Apttus_Config2__ChargeType__c = 'Maintenance Year1',
		Apttus_Config2__Cost__c = 10
		);
		//insert pLI2;
		plistItems.add(pLI2);

		Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod3.Id, 
		Apttus_Config2__ChargeType__c = 'SSP',
		Apttus_Config2__Cost__c = 10
		);
		//insert pLI1;
		plistItems.add(pLI3);

		Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance Year2+',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI4);

		Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'SRS',
		Apttus_Config2__Cost__c = 10
		);
		plistItems.add(pLI5);

		insert plistItems;

		Product_Discount__c disc = new Product_Discount__c ();
		disc.Discount__c = 8.00;
		disc.Market__c = account.Market__c;
		disc.Product_Discount_Category__c = 'NFM-P';
		insert disc;

		//create proposal
		Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.NOKIA_FN, 
		NokiaCPQ_No_of_Years__c = '3',
		NokiaCPQ_Maintenance_Type__c='Gold (Return for Exchange)',
		RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
		Apttus_Proposal__Account__c=accLegalEntity.id,
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes',
		Sold_To_Party__c = accLegalEntity.id,
		Is_List_Price_Only__c =false
		);
		insert testProposal;


		system.debug('testProposal:'+testProposal);

		//create product configuration
		list<Apttus_Config2__ProductConfiguration__c> ProdConfigList = new list<Apttus_Config2__ProductConfiguration__c>();
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
		Name = 'APTTUS Test Config', 
		Apttus_Config2__AccountId__c = account.Id, 
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
		Apttus_QPConfig__Proposald__c = testProposal.Id, 
		Apttus_Config2__Status__c = 'New', 
		Apttus_Config2__VersionNumber__c = 1, 
		Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
		Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;
		ProdConfigList.add(ProdConfig);
		//Create Line Items
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();

		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfigList[0].Id,
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
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__BasePrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,
		Nokia_Maint_Y1_Per__c = 7,
		Nokia_Maint_Y2_Per__c = 7,
			
		Apttus_Config2__AddedBy__c = 'added by code'
		);

		allLineItems.add(LineItem1);

		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfigList[0].Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 2,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Maintenance Year1', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod2.Id,
		Apttus_Config2__PriceListItemId__c = pLI2.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Apttus_Config2__PriceIncludedInBundle__c = true,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		is_Custom_Product__c=false,
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__AddedBy__c = 'added by code',
		Advanced_pricing_done__c = false			
		);

		allLineItems.add(LineItem2);


		Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfigList[0].Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 3,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'SSP', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod3.Id,
		Apttus_Config2__PriceListItemId__c = pLI3.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 90,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,
		is_Custom_Product__c=false,
		Apttus_Config2__AddedBy__c = 'added by code'	 
		);

		allLineItems.add(LineItem3);

		Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfigList[0].Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 4,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Maintenance Y2+', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod4.Id,
		Apttus_Config2__PriceListItemId__c = pLI4.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'Yearly',
		NokiaCPQ_Maint_Yr2_Extended_Price__c = 100,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 200,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,
		is_Custom_Product__c=false,
		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		allLineItems.add(LineItem4);

		Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfigList[0].Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 4,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'SRS', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod5.Id,
		Apttus_Config2__PriceListItemId__c = pLI5.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'Yearly',
		NokiaCPQ_Maint_Yr2_Extended_Price__c = 100,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__BasePrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Nokia_SSP_Base_Extended_Price__c = 200,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = account.Id,
		Advanced_pricing_done__c = false,
		is_Custom_Product__c=false,
		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		allLineItems.add(LineItem5);

		insert allLineItems;

		Test.startTest(); 

		CPQ_Maintenance_and_SSP_Rule__c rec1 = new CPQ_Maintenance_and_SSP_Rule__c();
		rec1.Maintenance_Level__c = 'Nokia Brand of Service';
		rec1.Maintenance_Type__c = 'Gold (Return for Exchange)';
		rec1.Region__c = 'RG_NAM';
		rec1.Service_Rate_Y1__c = 0.05;
		rec1.Service_Rate_Y2__c = 0.05;
		rec1.Unlimited_SSP_Discount__c = 0.03; 
		rec1.Maintenance_Category__c = 'ONT-G-010P-A FBA';
		insert rec1;

		Nokia_PricingCallBack obj = new Nokia_PricingCallBack();

		obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
		Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfigList[0].Id);

		obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
		obj.finish();

		//Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfigList[0].Id);

		//Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
			Test.stopTest();
		}
	}
  
  public static List<Product2> getProducts(string Portfolio){
	List<Product2> productList = new List<Product2>();
	Product2 prod1 = new product2(
	  Name = 'Test1', 
	  ProductCode = '123', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Portfolio,
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'
	); 
	productList.add(prod1);
	
	Product2 prod2 = new product2(
	  Name = 'Maintenance Year1', 
	  ProductCode = 'MT001', 
	  Business_Group__c = 'MN', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Portfolio,
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'
	  
	); 
	productList.add(prod2);
	
	Product2 prod3 = new product2(
	  Name = 'SRS', 
	  ProductCode = 'SRS001', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Portfolio,
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'  
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'   
	); 
	productList.add(prod3);
	
	Product2 prod4 = new product2(
	  Name = 'SSP', 
	  ProductCode = 'SSP002', 
	  CurrencyIsoCode = 'USD',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'   
	); 
	productList.add(prod4);
	
	Product2 prod5 = new product2(
	  Name = 'Maintenance Year2+', 
	  ProductCode = 'MT002',  
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Portfolio,
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c ='NFM-P IPR',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
	); 
	productList.add(prod5);
	
	Product2 prod6 = new product2(
	  Name = 'prod6', 
	  ProductCode = 'P6', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Portfolio,
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone' 
	); 
	productList.add(prod6);
	return productList;
  }
  //create price list item for test methods
  public static List<Apttus_Config2__PriceListItem__c> getPriceListItems(id priceListID, List<id> productIDList){
	Apttus_Config2__PriceListItem__c pLISO;
	List<Apttus_Config2__PriceListItem__c> priceListItemList = new List<Apttus_Config2__PriceListItem__c>();
	List<string> chargeTypeList = new List<string>{'Standard Price', 'Year 1 Maintenance', 'SRS', 'SSP', 'Maintenance for Y2 and Beyond', 'Standard Price'};
	  List<Integer> listPriceList = new List<Integer>{100,200,200,200,200,800};
		List<string> priceTypeList = new List<string>{'One Time','One Time','One Time','One Time','One Time','One Time'};
		  List<string> priceMethodList = new List<string>{'Per Unit','Per Unit','Per Unit','Per Unit','Per Unit','Per Unit'};
			
			if(priceListID != null && productIDList != null && productIDList.size() > 0){
			  for(Integer counter = 0; counter < productIDList.size() && counter < 6; counter++){
				pLISO = new Apttus_Config2__PriceListItem__c(
				  Apttus_Config2__PriceListId__c = priceListID,
				  Apttus_Config2__ListPrice__c = listPriceList[counter], 
				  Apttus_Config2__ProductId__c = productIDList[counter], 
				  Apttus_Config2__ChargeType__c = chargeTypeList[counter]
				  , Apttus_Config2__PriceType__c = priceTypeList[counter]
				  , Apttus_Config2__PriceMethod__c = priceMethodList[counter]
				  , Apttus_Config2__Cost__c =10
				);  
				priceListItemList.add(pLISO);
			  }
			}
	return priceListItemList;
  }
  //create product classification for test methods
  public static List<Apttus_Config2__ProductClassification__c> getProductClasssification(id priceListID, List<id> productIDList){
	List<Apttus_Config2__ProductClassification__c> productClassificationList = new List<Apttus_Config2__ProductClassification__c>();
	Apttus_Config2__ProductClassification__c productClassificationSO;
	Apttus_Config2__ClassificationName__c categoerySO = new Apttus_Config2__ClassificationName__c (Apttus_Config2__Active__c = true
													 , Apttus_Config2__Type__c = 'Offering'
													 , Apttus_Config2__HierarchyLabel__c = 'Test826');
	insert categoerySO;
	
	Apttus_Config2__PriceListCategory__c priceListCategorySO 
	  = new Apttus_Config2__PriceListCategory__c(Apttus_Config2__HierarchyId__c = categoerySO.id
							 , Apttus_Config2__PriceListId__c = priceListID
							 , Apttus_Config2__Sequence__c =1);
	insert priceListCategorySO;
	
	Apttus_Config2__ClassificationHierarchy__c classificationHierarchySO 
	  = new Apttus_Config2__ClassificationHierarchy__c(Apttus_Config2__HierarchyId__c = categoerySO.id
							   , Apttus_Config2__Left__c=1
							   , Apttus_Config2__Right__c=2
							   , Apttus_Config2__Label__c= 'My Category');
	insert classificationHierarchySO;
	if(productIDList != null && productIDList.size() > 0){
	  for(integer counter = 0; counter < productIDList.size()  ; counter++){
		productClassificationSO = new Apttus_Config2__ProductClassification__c();
		productClassificationSO.Apttus_Config2__ClassificationId__c = classificationHierarchySO.id;
		productClassificationSO.Apttus_Config2__ProductId__c = productIDList[counter];
		productClassificationSO.Apttus_Config2__Sequence__c = counter + 1;
		productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
		productClassificationList.add(productClassificationSO);
	  }
	}
	return productClassificationList;
  }
}