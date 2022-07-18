@isTest(seeAllData=false)
public class CPQ_UpdateLineItemReferencesTest {
	public static testmethod void method1(){
		
	  List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){
		List<Product2> prods = new List<Product2>();

		Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
		prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
		prod1.NokiaCPQ_Static_Bundle_Option__c = true;
		prods.add(prod1);

		Product2 prod2 = TestDataSetup.createCPQTestproduct(1)[0];
		prod2.Name = 'Option1Care';
		prod2.ProductCode = '784800098209';
		prods.add(prod2);

		Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
		prod3.Name = 'Option2SRS'; 
		prod3.Business_Group__c = 'MN';
		prod3.ProductCode = 'SRS';
		prod3.NokiaCPQ_Product_Discount_Category__c = 'NFM-P';
		prods.add(prod3);

		Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
		prod4.Name = 'Option1Care';
		prod4.ProductCode = '784800098209_TBD';
		prods.add(prod4);

		Product2 prod5 = TestDataSetup.createCPQTestproduct(1)[0];
		prod5.Name = 'Option2SRS'; 
		prod5.Business_Group__c = 'MN';
		prod5.ProductCode = 'SRS_TBD';
		prod5.NokiaCPQ_Product_Discount_Category__c = 'NFM-P';
		prods.add(prod5);

		insert prods;

		//Create PriceList

		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True
		);
		insert ApttusTestPriceList;

		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
		pLI1.Apttus_Config2__ProductId__c = prod1.id;
		plistItems.add(pLI1);

		Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
		pLI2.Apttus_Config2__ProductId__c = prod2.Id;
		pLI2.Apttus_Config2__PriceIncludedInBundle__c = true;
		pLI2.Apttus_Config2__ChargeType__c = 'Standard Price';
		plistItems.add(pLI2); 

		Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
		pLI3.Apttus_Config2__ProductId__c = prod3.Id;
		pLI3.Apttus_Config2__PriceIncludedInBundle__c = true;
		pLI3.Apttus_Config2__ChargeType__c = 'Standard Price';
		plistItems.add(pLI3);   

		Apttus_Config2__PriceListItem__c pLI4 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
		pLI4.Apttus_Config2__ProductId__c = prod4.Id;
		pLI4.Apttus_Config2__PriceIncludedInBundle__c = true;
		pLI4.Apttus_Config2__ChargeType__c = 'Standard Price';
		plistItems.add(pLI4); 

		Apttus_Config2__PriceListItem__c pLI5 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
		pLI5.Apttus_Config2__ProductId__c = prod5.Id;
		pLI5.Apttus_Config2__PriceIncludedInBundle__c = true;
		pLI5.Apttus_Config2__ChargeType__c = 'Standard Price';
		plistItems.add(pLI5);   
		insert  plistItems;

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
		list<Opportunity> opportunities = new list<Opportunity>();
		opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities.get(0).Account_Role__c = 'GPP Distributor Partner';
		opportunities.get(0).Business_Type__c = 'Standard Opportunity';
		insert opportunities.get(0);
		
		
		Apttus_Proposal__Proposal__c testProposal = TestDataSetup.creatProposal(opportunities[0], accounts[0], ApttusTestPriceList);
		testProposal.Sold_To_Party__c = accLegalEntity.id;
		testProposal.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
		insert testProposal;

		//system.debug('testProposal:'+testProposal);

		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = TestDataSetup.creatProductConfiguration(accounts[0], ApttusTestPriceList, testProposal);
		insert ProdConfig;


		//Create Line Items
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c LineItem1 = TestDataSetup.creatConfigLineItem(accounts[0], ProdConfig, ApttusTestPriceList, prod4,1)[0];
		LineItem1.Apttus_Config2__PriceListItemId__c = pLI4.id;
		LineItem1.Apttus_Config2__ItemSequence__c = 1;
		LineItem1.Apttus_Config2__LineType__c = 'Product/Service';
		LineItem1.Apttus_Config2__NetPrice__c=100;
		LineItem1.Apttus_Config2__ProductId__c = prod4.Id;
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
		LineItem1.Apttus_Config2__PriceListItemId__c = pLI5.id;
		lineItem2.Apttus_Config2__ListPrice__c = 200;
		lineItem2.Apttus_Config2__NetPrice__c=100;
		lineItem2.Apttus_Config2__OptionId__c = prod5.Id;
		LineItem1.Apttus_Config2__LineType__c = 'Option';
		lineItem2.Apttus_Config2__BasePrice__c=200;
		lineItem2.Apttus_Config2__BasePriceOverride__c=1185.02;
		lineItem2.Apttus_Config2__ChargeType__c = 'Option';
		lineItem2.NokiaCPQ_Account_Region__c='RG_LAM';
		lineItem2.Apttus_Config2__LineNumber__c =1;
		allLineItems.add(lineItem2);
		insert allLineItems;

		Test.startTest();
		CPQ_UpdateLineItemReferences.execute();
		Test.stopTest();

	}}
	
}