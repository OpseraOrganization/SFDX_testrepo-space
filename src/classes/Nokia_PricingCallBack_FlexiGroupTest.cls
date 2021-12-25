/* Created this test class to optimize and replace Nokia_PricingCallBack_FlexiGroup_Test*/
@isTest
public class Nokia_PricingCallBack_FlexiGroupTest{


  static testMethod void groupPricingTest() {
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
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  accountsNew.add(accLegalEntity);

	  Account account = TestDataFactory.createAccount(1)[0];
	  account.AccountNumber='3011546567';
	  account.Acc_No__c = '3011546567';
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

	insert opportunities.get(0);
	  
	  /**Product starts*/
	  List<Product2> prods = new List<Product2>();
	  Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod1.Portfolio__c = 'IP Routing';
	  prod1.NokiaCPQ_Item_Type__c='Hardware';
	  prod1.NokiaCPQ_Product_Discount_Category__c = 'Standard';
	  prod1.PMD_Product_Classification__c='Sales Item';
	  prod1.NokiaCPQ_Product_Discount_Category__c = '7705 SAR-8/18 IPR';
	  insert prod1;
	  /**Product ends*/
  
	  //Create PriceList

	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
	  Name = 'Commercial Price List', 
	  Apttus_Config2__Active__c = True
	  );
	  insert ApttusTestPriceList;
	  
	  Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI1.Apttus_Config2__ProductId__c = prod1.Id;
	  insert pLI1;
	  //plistItems.add(pLI1);

	  //create product extensions
	  List<Product_Extension__c> pextList = new List<Product_Extension__c>();
	  Product_Extension__c pext1 = new Product_Extension__c(
		Product__c = prod1.Id,
		CurrencyIsoCode = 'USD',
		Stream__c = 'QTC',
		Floor_Price__c = 715.00,
		Market_Price__c = 770.00
	  );
	  pextList.add(pext1);
	  Product_Extension__c pext2 = new Product_Extension__c(
		Product__c = prod1.Id,
		CurrencyIsoCode = 'EUR',
		Stream__c = 'QTC',
		Floor_Price__c = 715.00,
		Market_Price__c = 770.00
	  );
	  pextList.add(pext2);
	  insert pextList;
	  
	  system.debug('pext: ' + [select Id,Product__c,Market_Price__c,Floor_Price__c,Custom_Bid__c,Stream__c,CurrencyIsoCode from Product_Extension__c where Product__c = :prod1.Id]);
	  
	  /*** Proposal starts***/
	  Apttus_Proposal__Proposal__c testProposal = TestDataSetup.creatProposal(opportunities.get(0), accounts[0], ApttusTestPriceList);
	  testProposal.Sold_To_Party__c = accLegalEntity.id;
	  testProposal.RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId();
	  insert testProposal;
	  /***proposal ends**/  
	  system.debug('testProposal:'+testProposal);
	  
	  /*** create product configuration ***/
	  Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], ApttusTestPriceList, testProposal);
	  insert ProdConfig;
	  /*** create product configuration End ***/
	  
	  /*** Line Item Starts***/
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
			
	  //Line Item#1
	  Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem1.Apttus_Config2__PriceListItemId__c = pLI1.id;
	  LineItem1.Source__c='';
	  LineItem1.Apttus_Config2__NetAdjustmentPercent__c=0;
	  LineItem1.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem1.NokiaCPQ_Account_Region__c='RG_NAM';
	  LineItem1.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem1.CPQ_Group_Adjustment_Type__c = 'Price Override';
	  LineItem1.CPQ_Group_Adjustment_Amount__c = 2000;
	  LineItem1.CPQ_Group_Unit_Override_Price__c = 2000;
	  LineItem1.CPQ_Market_Model__c = 'group 1';
	  LineItem1.Item_Type_From_CAT__c='PS';
	  LineItem1.Apttus_Config2__AdjustmentType__c = '% Disc Off Floor';
	  allLineItems.add(LineItem1);
	  
	  Apttus_Config2__LineItem__c LineItem2 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem2.Apttus_Config2__PriceListItemId__c = pLI1.id;
	  LineItem2.Source__c='';
	  LineItem2.Apttus_Config2__NetAdjustmentPercent__c=0;
	  LineItem2.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem2.NokiaCPQ_Account_Region__c='RG_NAM';
	  LineItem2.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem2.CPQ_Market_Model__c = 'group 1';
	  LineItem2.Item_Type_From_CAT__c='PS';
	  LineItem2.Apttus_Config2__AdjustmentType__c = '% Uplift Off Floor';
	  LineItem2.Apttus_Config2__AdjustmentAmount__c = 10;
	  LineItem2.NokiaCPQ_Is_Direct_Option__c=true;
	  allLineItems.add(LineItem2);

	  Apttus_Config2__LineItem__c LineItem3 = TestDataSetup.creatConfigLineItem(account, ProdConfig, ApttusTestPriceList, prod1,1)[0];
	  LineItem3.Apttus_Config2__PriceListItemId__c = pLI1.id;
	  LineItem3.Source__c='';
	  LineItem3.Apttus_Config2__NetAdjustmentPercent__c=0;
	  LineItem3.Apttus_Config2__PrimaryLineNumber__c = 1;
	  LineItem3.NokiaCPQ_Account_Region__c='RG_NAM';
	  LineItem3.Apttus_Config2__LineType__c = 'Product/Service';
	  LineItem3.CPQ_Market_Model__c = 'group 1';
	  LineItem3.Item_Type_From_CAT__c='PS';
	  LineItem3.Apttus_Config2__AdjustmentType__c = '% Disc Off List';
	  LineItem3.Apttus_Config2__AdjustmentAmount__c = 10;
	  LineItem3.NokiaCPQ_Is_Direct_Option__c=true;
	  allLineItems.add(LineItem3);
	  insert allLineItems;
	  /*** Line Item ends***/
	  Test.startTest(); 

	  Nokia_PricingCallBack obj = new Nokia_PricingCallBack();

	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
	  Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);

	  obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);

	  Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
	  //Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	  obj.finish();
	  Test.stopTest();
	}
  }
}