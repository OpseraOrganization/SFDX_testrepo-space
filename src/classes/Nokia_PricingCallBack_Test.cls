@isTest(SeeAllData = true) 
private class Nokia_PricingCallBack_Test{
static testMethod void directNSW() {


/*  Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
custSetting.Name = 'Nokia_CallBack1';
insert custSetting;*/


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
Product2 prod1 = new product2(
Name = 'Test1', 
ProductCode = '123', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'Nokia Software',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Bundle',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Standard SW (STD)',
NokiaCPQ_License_Usage__c='Commercial Term License',
NokiaCPQ_Product_Discount_Category__c = 'XYZ'
); 
prods.add(prod1);
Product2 prod2 = new product2(
Name = 'Option1Care', 
ProductCode = '784800098209', 
Business_Group__c = 'MN', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'Nokia Software',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Standard SW (STD)',
NokiaCPQ_License_Usage__c='Commercial Licence'); 
prods.add(prod2);

Product2 prod3 = new product2(
Name = 'Option2SRS', 
ProductCode = 'SRS', 
Business_Group__c = 'MN', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'Nokia Software',
IsActive = true,
NokiaCPQ_Product_Discount_Category__c = 'NFM-P',
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Standard SW (STD)',
NokiaCPQ_License_Usage__c='Commercial Licence'
); 
prods.add(prod3);

Product2 prod4 = new product2(
Name = 'Option3', 
ProductCode = '12345', 
Business_Group__c = 'MN', 
CurrencyIsoCode = 'USD',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Standard SW (STD)',
NokiaCPQ_License_Usage__c='Commercial Licence'
);  
prods.add(prod4);

Product2 prod5 = new product2(
Name = 'Test1', 
ProductCode = '12356', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'Nokia Software',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Bundle',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base',
NokiaCPQ_License_Usage__c='Commercial Licence',
NokiaCPQ_Product_Discount_Category__c = 'NSW'
); 
prods.add(prod5);

Product2 prod6 = new product2(
Name = 'Option2Care', 
ProductCode = '784800098210', 
Business_Group__c = 'MN', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'Nokia Software',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Standard SW (STD)',
NokiaCPQ_License_Usage__c='Commercial Licence'); 
prods.add(prod6);

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
Apttus_Config2__PriceIncludedInBundle__c = true,
Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
);
//insert pLI2;
plistItems.add(pLI2);

Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod3.Id, 
Apttus_Config2__ChargeType__c = 'SRS',
Apttus_Config2__PriceIncludedInBundle__c = true,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI3);

Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod4.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price'
);
//insert pLI1;
plistItems.add(pLI4);

Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod5.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price'
);
//insert pLI1;
plistItems.add(pLI5);

Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
Apttus_Config2__ListPrice__c = 200, 
Apttus_Config2__ProductId__c = prod6.Id, 
Apttus_Config2__PriceIncludedInBundle__c = true,
Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
);
//insert pLI2;
plistItems.add(pLI6);

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
		NokiaCPQ_Portfolio__c = 'Nokia Software',
		Apttus_Proposal__Approval_Stage__c = 'Draft',
		NokiaCPQ_No_of_Years__c = '1',
		RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
		Apttus_Proposal__Account__c=accounts[0].id,
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		NokiaCPQ_Existing_IONMaint_Contract__c='No',
		Sold_To_Party__c = accLegalEntity.id,
		Is_List_Price_Only__c =false
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
Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__PriceListItemId__c = pLI1.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePrice__c=120,
Apttus_Config2__ListPrice__c = 100,
Apttus_Config2__Quantity__c = 1,
Source__c='',
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=1180.52,
Apttus_Config2__AddedBy__c = 'added by code',
NokiaCPQ_Is_Direct_Option__c=true,
Apttus_Config2__NetAdjustmentPercent__c=0,
Item_Type_From_CAT__c='PS',
NokiaCPQ_Account_Region__c='RG_NAM'


);
allLineItems.add(LineItem1);

Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 2,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Year 1 Maintenance', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod2.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
Apttus_Config2__PriceListItemId__c = pLI2.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
is_Custom_Product__c=false,
Apttus_Config2__ListPrice__c = 200,
Apttus_Config2__BasePrice__c=200,
Apttus_Config2__Quantity__c = 1,
Apttus_Config2__BasePriceOverride__c=1185.02,
Apttus_Config2__PrimaryLineNumber__c = 2,
Apttus_Config2__ShipToAccountId__c = account.Id,

NokiaCPQ_Account_Region__c='RG_LAM',
Apttus_Config2__AddedBy__c = 'added by code'
);
//insert LineItem1;
allLineItems.add(LineItem2);

Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 3,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'SRS', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod3.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
Apttus_Config2__PriceListItemId__c = pLI3.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 2,
Apttus_Config2__ShipToAccountId__c = account.Id,

NokiaCPQ_Account_Region__c='RG_MEA',
Apttus_Config2__AddedBy__c = 'added by code'
);

allLineItems.add(LineItem3);

Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 4,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod4.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
Apttus_Config2__PriceListItemId__c = pLI4.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
Apttus_Config2__ListPrice__c = 120,
Apttus_Config2__BasePrice__c=120,
Apttus_Config2__Quantity__c = 1,
Apttus_Config2__PriceIncludedInBundle__c = true,
Apttus_Config2__PrimaryLineNumber__c = 2,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
NokiaCPQ_Account_Region__c= 'RG_ASIA',
Apttus_Config2__AddedBy__c = 'added by code'	 
);
allLineItems.add(LineItem4);

Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 5,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod5.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
Apttus_Config2__PriceListItemId__c = pLI5.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
Apttus_Config2__ListPrice__c = 120,
Apttus_Config2__BasePrice__c=120,
Apttus_Config2__Quantity__c = 1,
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__PrimaryLineNumber__c = 2,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
NokiaCPQ_Account_Region__c= 'RG_CHINA',
Apttus_Config2__AddedBy__c = 'added by code'	 
);
//insert LineItem1;
allLineItems.add(LineItem5);

Apttus_Config2__LineItem__c LineItem6 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 6,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Year 1 Maintenance', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod6.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
Apttus_Config2__PriceListItemId__c = pLI6.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
is_Custom_Product__c=false,
Apttus_Config2__ListPrice__c = 200,
Apttus_Config2__BasePrice__c=200,
Apttus_Config2__Quantity__c = 1,
Apttus_Config2__BasePriceOverride__c=1185.02,
Apttus_Config2__PrimaryLineNumber__c = 2,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Account_Region__c  = 'RG_EUROPE',
Apttus_Config2__AddedBy__c = 'added by code'
);

allLineItems.add(LineItem6);

insert allLineItems;

Test.startTest(); 

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



		}
		Test.stopTest();
}
	
/*static testMethod void directPOL() 
{
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
		Direct_Portfolio__c = 'Fixed Network',
		Portfolio__c = 'Fixed Access - POL',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Bundle',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010P-A POL'
		); 
		prods.add(prod1);

		Product2 prod2 = new product2(
		Name = 'Maintenance Year1', 
		ProductCode = 'MT001', 
		//Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Direct_Portfolio__c = 'Fixed Network',
			Portfolio__c = 'Fixed Access - POL',
		IsActive = true,
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010P-A POL',
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base'); 
		prods.add(prod2);

		Product2 prod3 = new product2(
		Name = 'SSP', 
		ProductCode = 'SSP002', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Direct_Portfolio__c = 'Fixed Network',
		Portfolio__c = 'Fixed Access - POL',
		IsActive = true,
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010P-A POL',
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		); 
		prods.add(prod3);   
		Product2 prod4 = new product2(
		Name = 'Maintenance Year2+', 
		ProductCode = 'MT002', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Direct_Portfolio__c = 'Fixed Network',
			Portfolio__c = 'Fixed Access - POL',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010P-A POL'
		); 
		prods.add(prod4);

		Product2 prod5 = new product2(
		Name = 'SRS', 
		ProductCode = 'SRS002', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Direct_Portfolio__c = 'Fixed Network',
			Portfolio__c = 'Fixed Access - POL',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'ONT-G-010P-A POL'
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
		disc.Product_Discount_Category__c = 'ONT-G-010P-A POL';
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
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		Sold_To_Party__c = accLegalEntity.id,
		Is_List_Price_Only__c =false
		);
		insert testProposal;


		system.debug('testProposal:'+testProposal);

		//create product configuration
		//Apttus_Config2__ProductConfiguration__c ProdConfigList = new Apttus_Config2__ProductConfiguration__c();
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
		//ProdConfigList.add(ProdConfig);
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
		Total_ONT_Quantity__c = 1.5,  
			Total_ONT_Quantity_FBA__c = 1.4,
			Total_ONT_Quantity_P2P__c = 1,
		Apttus_Config2__AddedBy__c = 'added by code'
		);

		allLineItems.add(LineItem1);

		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
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
		Total_ONT_Quantity__c = 1.5, 
			Total_ONT_Quantity_FBA__c = 1.4,
			Total_ONT_Quantity_P2P__c = 1,
		Advanced_pricing_done__c = false			
		);

		allLineItems.add(LineItem2);


		Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
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
			Total_ONT_Quantity__c = 1.5, 
			Total_ONT_Quantity_FBA__c = 1.4,
			Total_ONT_Quantity_P2P__c = 1,
		Apttus_Config2__AddedBy__c = 'added by code'	 
		);

		allLineItems.add(LineItem3);

		Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
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
			Total_ONT_Quantity__c = 1.5, 
			Total_ONT_Quantity_FBA__c = 1.4,
			Total_ONT_Quantity_P2P__c = 1,
		Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		allLineItems.add(LineItem4);

		Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
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
			Total_ONT_Quantity__c = 1.6, 
			Total_ONT_Quantity_FBA__c = 1.4,
			Total_ONT_Quantity_P2P__c = 1,
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
		rec1.Maintenance_Category__c = 'ONT-G-010P-A POL';
		insert rec1;
		Nokia_PricingCallBack obj = new Nokia_PricingCallBack();

		obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
		Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);

		obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);

		Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
		Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);

		obj.finish();
		Nokia_PricingCallBack.calculateEquivalentPrice(allLineItems, 'Market India');
		for (Apttus_Config2__LineItem__c item: allLineItems) 
		{
	 Nokia_PricingCallBack.getProductDiscountCategory(item);
	 obj.getCLP(item);
	 Nokia_PricingCallBack.getClassification(item);
			Nokia_PricingCallBack.getConfigType(item);
			obj.getMaximumIRPDiscount(item);
			Nokia_PricingCallBack.getLicenseUsage(item);
	obj.getMinimumSalesMargin(item);
			Nokia_PricingCallBack.getItemType(item);
	obj.getPartNumber(item);
	obj.getPortfolio(item);

		}
		testProposal.NokiaCPQ_No_of_Years__c = '1';
		testProposal.NokiaCPQ_Maintenance_Type__c='Gold (Return for Exchange)';
		update testProposal;

		Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
		Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
		}
		Test.stopTest();
}*/

	//method for testDS_Equivalentprice
/*static testMethod void Airscalewifisoftware() 
{
		/*Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
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

//Create Product
List<Product2> prods = new List<Product2>();

Product2 prod1 = new product2(
Name = 'Test1', 
ProductCode = '123',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Bundle',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod1);

Product2 prod2 = new product2(
Name = 'Maintenance Year1', 
ProductCode = 'MT001', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'IP Routing',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'); 
prods.add(prod2);

Product2 prod3 = new product2(
Name = 'Test2', 
ProductCode = '1234',  
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'
); 
prods.add(prod3);

Product2 prod5 = new product2(
Name = 'Maintenance Year2+', 
ProductCode = 'MT002', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'IP Routing',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone'
); 
prods.add(prod5); 

Product2 prod6 = new product2(
Name = 'Test1Arcadia', 
ProductCode = '123Arcadia',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Bundle',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod6);   

Product2 prod7 = new product2(
Name = 'Test2Arcadia', 
ProductCode = 'Arcadia2',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Bundle',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod7); 


Product2 prod8 = new product2(
Name = '12678', 
ProductCode = '12678',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod8); 

insert prods;

//Create PriceList

Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
Name = 'Commercial Price List', 
Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
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
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
);
//insert pLI2;
plistItems.add(pLI2);

Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod3.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI3);


Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod5.Id, 
Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond'
);
//insert pLI1;
plistItems.add(pLI5);

Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod6.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI6);

Apttus_Config2__PriceListItem__c pLI7 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod7.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI7);

Apttus_Config2__PriceListItem__c pLI8 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod8.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI8);

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
		NokiaCPQ_Portfolio__c = 'Airscale Wifi',
		NokiaCPQ_No_of_Years__c = '1',
		NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced',
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		NokiaCPQ_Existing_IONMaint_Contract__c='No',
		RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
		Apttus_Proposal__Account__c=accLegalEntity.id,
		Sold_To_Party__c = accLegalEntity.id,
		Is_List_Price_Only__c =false
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
Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__PriceListItemId__c = pLI1.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePrice__c=100,
Apttus_Config2__ListPrice__c = 100,
Apttus_Config2__Quantity__c = 1,
Source__c='',
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__AddedBy__c = 'added by code',
NokiaCPQ_Product_Type__c='Controller'

);
//insert LineItem2;
allLineItems.add(LineItem1);

Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 2,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod6.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
Apttus_Config2__PriceListItemId__c = pLI6.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 2,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Product_Type__c = 'Access Point',  
Apttus_Config2__AddedBy__c = 'added by code',
Apttus_Config2__AdjustmentType__c = '% Discount',
Apttus_Config2__AdjustmentAmount__c = 10
);
//insert LineItem1;
allLineItems.add(LineItem3);

Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 3,
Apttus_Config2__LineNumber__c = 2,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Year 1 Maintenance', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod2.Id,
Apttus_Config2__PriceListItemId__c = pLI2.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
Apttus_Config2__ListPrice__c = 120,
Apttus_Config2__BasePrice__c=120,
Apttus_Config2__Quantity__c = 1,
Apttus_Config2__PriceIncludedInBundle__c = true,
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__AddedBy__c = 'added by code'	 
);
//insert LineItem1;
allLineItems.add(LineItem4);

Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 4,
Apttus_Config2__LineNumber__c = 3,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod5.Id,
Apttus_Config2__PriceListItemId__c = pLI5.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
Apttus_Config2__ListPrice__c = 120,
Apttus_Config2__BasePrice__c=120,
Apttus_Config2__Quantity__c = 1,
Apttus_Config2__PriceIncludedInBundle__c = true,
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__AddedBy__c = 'added by code'	 
);
//insert LineItem1;
allLineItems.add(LineItem5);

Apttus_Config2__LineItem__c LineItem6 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 2,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod6.Id,
Apttus_Config2__OptionId__c = prod3.Id,
Apttus_Config2__ParentBundleNumber__c = 2,
Apttus_Config2__PriceListItemId__c = pLI3.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,


Apttus_Config2__AddedBy__c = 'added by code'
);
//insert LineItem1;
allLineItems.add(LineItem6);

Apttus_Config2__LineItem__c LineItem7 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 2,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod7.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
Apttus_Config2__PriceListItemId__c = pLI7.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 3,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Product_Type__c = 'Controller',			
Apttus_Config2__AddedBy__c = 'added by code',
Apttus_Config2__AdjustmentType__c = 'Discount Amount',
Apttus_Config2__AdjustmentAmount__c = 100
);
//insert LineItem1;
allLineItems.add(LineItem7);

Apttus_Config2__LineItem__c LineItem8 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 2,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod7.Id,
Apttus_Config2__OptionId__c = prod8.Id,
Apttus_Config2__ParentBundleNumber__c = 3,
Apttus_Config2__PriceListItemId__c = pLI8.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Product_Type__c = 'Third Party Wavespot',  

Apttus_Config2__AddedBy__c = 'added by code'
);
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
}*/
	
static testMethod void QTCmethod() {


List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();

insert account3;

List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();

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
Apttus_Config2__ChargeType__c = 'Standard Price',
	Apttus_Config2__Cost__c = 10 //DHH
);
insert pLI5;

Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(
RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),
Apttus_Proposal__Account__c = account3[0].Id,
Apttus_Proposal__Opportunity__c = opportunities1.get(0).Id,
Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
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
Apttus_Config2__ProductId__c = prod.Id,
CPQ_Market_Model__c=null,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
is_Custom_Product__c=false,
Apttus_Config2__ListPrice__c = 300,
Advanced_pricing_done__c = true,//DHH
NokiaCPQ_Unitary_Cost__c = 10, //DHH
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__Quantity__c = 10,
Apttus_Config2__NetPrice__c=100,


Apttus_Config2__AddedBy__c = 'added by code'
);
//insert LineItem1;
allLineItems.add(LineItem3);

insert allLineItems;

Nokia_PricingCallBack obj = new Nokia_PricingCallBack();

obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);

obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);

Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
test.stopTest(); 
}

//method for InDirect_Quotes

 /*static testMethod void Indirect1111() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
	custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
	custSetting.Name = 'Nokia_CallBack1';
	insert custSetting;
	
	Map < String, List < String >> maintenanceAccredMap = new Map < String, List < String >> (); 
	Map < String, List < String >> productAccredMap = new Map < String, List < String >> ();
	Nokia_PricingCallBack npc = new Nokia_PricingCallBack();

	List<Opportunity> opportunities;
	List<Accreditation__c> accreditations = new List<Accreditation__c>();
	List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
	users[0].Nokia_ID__c = '234597';
	insert users;
	
	System.runAs(users[0]) {   
	 
	//Create Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		List<Account> accounts1 = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		accounts1[0].Acc_No__c = 'Testing1';
		accounts1[0].Partner_Program__c ='';
		accounts1[0].Partner_Type__c = '';
		accounts1[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts1[0].Active__c = true;
		accounts1[0].ParentId = accounts[0].Id;
		insert accounts1;
		
		//Create Opportunity
		opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
		opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		opportunities.get(0).Account_Role__c = 'Alliance Partner';
		insert opportunities.get(0);
		
	//create Accreditation
	 
	Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Nokia Brand of Service',
	Partner__c=accounts[0].Id,
	Portfolio__c='IP Routing',
	Pricing_Cluster__c='NAM'
		);
	 accreditations.add(accreditation2);
		
	 Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Advanced',
	Partner__c=accounts[0].Id,
	Portfolio__c='IP Routing',
	Pricing_Cluster__c='NAM'
		);
	 accreditations.add(accreditation3);
		
	 insert accreditations;
		 
	 //Create Product
	 List<Product2> prods = new List<Product2>();
	 Product2 prod1 = new product2(
			Name = 'Test1', 
			ProductCode = '123', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'IP Routing',
			IsActive = true,
			Apttus_Config2__ConfigurationType__c = 'Standalone'
	 ); 
	 prods.add(prod1);
		
	 Product2 prod2 = new product2(
			Name = 'Maintenance Year1', 
			ProductCode = 'MT001', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'IP Routing',
			IsActive = true,
			Apttus_Config2__ConfigurationType__c = 'Standalone'
			
	 ); 
	 prods.add(prod2);
	 
	 Product2 prod3 = new product2(
			Name = 'SRS', 
			ProductCode = 'SRS001', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'IP Routing',
			IsActive = true,
			Apttus_Config2__ConfigurationType__c = 'Standalone'   
	 ); 
	 prods.add(prod3);
	 
	 Product2 prod4 = new product2(
			Name = 'SSP', 
			ProductCode = 'SSP002', 
			CurrencyIsoCode = 'USD',
			IsActive = true,
			NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
			Apttus_Config2__ConfigurationType__c = 'Standalone'
	 ); 
	 prods.add(prod4);
	 
	 Product2 prod5 = new product2(
			Name = 'Maintenance Year2+', 
			ProductCode = 'MT002',  
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'IP Routing',
			IsActive = true,
			NokiaCPQ_Product_Discount_Category__c ='NFM-P IPR',
			Apttus_Config2__ConfigurationType__c = 'Standalone' 
	 ); 
	 prods.add(prod5);
	
	 Product2 prod6 = new product2(
			Name = 'prod6', 
			ProductCode = 'P6', 
			CurrencyIsoCode = 'USD',
	Portfolio__c = 'IP Routing',
			IsActive = true,
			NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
			Apttus_Config2__ConfigurationType__c = 'Standalone' 
	 ); 
	 prods.add(prod6);
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
			Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
		);
		//insert pLI2;
		plistItems.add(pLI2);
		
		Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod3.Id, 
			Apttus_Config2__ChargeType__c = 'SRS'
		);
		//insert pLI1;
		plistItems.add(pLI3);
		
		Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod4.Id, 
			Apttus_Config2__ChargeType__c = 'SSP'
		);
		//insert pLI1;
		plistItems.add(pLI4);
		
		 Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod5.Id, 
			Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond'
		);
		//insert pLI1;
		plistItems.add(pLI5);
	
	
		 Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 800, 
			Apttus_Config2__ProductId__c = prod6.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		//insert pLI1;
		plistItems.add(pLI6);
		insert plistItems;

		//create proposal
		Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
			NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
			NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
			NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
			NokiaCPQ_SSP_Level__c = 'Unlimited',
			NokiaCPQ_SRS_Level__c = 'Unlimited',
			NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
			NokiaCPQ_Portfolio__c = 'IP Routing',
			NokiaCPQ_No_of_Years__c = '1',
			CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
			NokiaCPQ_LEO_Discount__c=false,
			Is_List_Price_Only__c =false,
			NokiaCPQ_Is_cloned__c = false,
			RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
			isCQ__c = false
	 
		);
		insert testProposal;

		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
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
		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__BasePrice__c=4427,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PriceIncludedInBundle__c=false,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			is_Custom_Product__c =true,
			Custom_Product_Code__c='123',
			Apttus_Config2__AddedBy__c = 'added by code',
			Apttus_Config2__NetPrice__c=120,
			NokiaCPQ_SSP_Rate__c=120
		);
		//insert LineItem2;
		allLineItems.add(LineItem1);
		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 2,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod6.Id,
			Apttus_Config2__PriceListItemId__c = pLI6.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__BasePrice__c=4427,
			Apttus_Config2__ListPrice__c = 200,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PriceIncludedInBundle__c=false,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			is_Custom_Product__c =false,
			Apttus_Config2__AddedBy__c = 'added by code',
			Apttus_Config2__NetPrice__c=120,
			NokiaCPQ_SSP_Rate__c=120
		);
		//insert LineItem1;
		allLineItems.add(LineItem2);
		
		 Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 6,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ChargeType__c = 'SRS', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod3.Id,
			Apttus_Config2__PriceListItemId__c = pLI3.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			is_Custom_Product__c =false,			
			Apttus_Config2__ListPrice__c = 120,
			Apttus_Config2__BasePrice__c=120,
			Apttus_Config2__Quantity__c = 1,
			Nokia_SRS_Base_Extended_Price__c = 80,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			
			
			Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem1;
		allLineItems.add(LineItem3);
		
		Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 3,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ChargeType__c = 'Year 1 Maintenance', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod2.Id,
			Apttus_Config2__PriceListItemId__c = pLI2.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
			Apttus_Config2__ListPrice__c = 120,
			Apttus_Config2__BasePrice__c=120,
			Apttus_Config2__Quantity__c = 1,
			Custom_Product_Code__c=Nokia_CPQ_Constants.SRS,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
	 is_Custom_Product__c =false,
			
			Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem1;
		allLineItems.add(LineItem4);
		
		Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 4,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ChargeType__c = 'SSP', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod4.Id,
			Apttus_Config2__PriceListItemId__c = pLI4.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
	is_Custom_Product__c =false,			
			Apttus_Config2__ListPrice__c = 120,
			Apttus_Config2__BasePrice__c=120,
			Apttus_Config2__Quantity__c = 1,
			Nokia_SRS_Base_Extended_Price__c = 80,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			
			
			Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem1;
		allLineItems.add(LineItem5);
		
		Apttus_Config2__LineItem__c LineItem7 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 5,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod5.Id,
			Apttus_Config2__PriceListItemId__c = pLI5.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'Yearly',
			NokiaCPQ_Maint_Yr2_Extended_Price__c = 100,
			Apttus_Config2__ListPrice__c = 120,
			Apttus_Config2__BasePrice__c=120,
			Apttus_Config2__Quantity__c = 1,
			Nokia_SSP_Base_Extended_Price__c = 200,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
	 is_Custom_Product__c =false,
			
			Apttus_Config2__AddedBy__c = 'added by code'	 
		);
		//insert LineItem1;
		allLineItems.add(LineItem7);
		
		insert allLineItems;
		
		Test.startTest(); 
		
		Shipping_Location__c ship= new Shipping_Location__c();
		ship.Portfolio__c='Fixed Access - FBA';
		ship.Pricing_Cluster__c='NAM Canada';
		ship.Shipping_Location__c='Lewisville, Texas';
		insert ship; 
		
		Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
		Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
		
		obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
		//Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
		Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
		
		obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);

		 Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
	}
		 Test.stopTest();
	} */ 
	
//FOr Direct Enterprise
static testMethod void directEnterprise() {
/*Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
custSetting.Name = 'Nokia_CallBack1';
insert custSetting;*/

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
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No'
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
		Apttus_Config2__BasePriceOverride__c=120,
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
		Apttus_Config2__BasePriceOverride__c=120,
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
		Apttus_Config2__BasePriceOverride__c=120,
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

		Test.startTest(); 

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
		}
		Test.stopTest();
}

static testMethod void directEnterprise10768() 
{
		/*Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
		insert custSetting;*/

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
NokiaCPQ_Existing_IONMaint_Contract__c = 'No'
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
Apttus_Config2__BasePriceOverride__c=120,
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
Apttus_Config2__BasePriceOverride__c=120,
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
Apttus_Config2__BasePriceOverride__c=120,
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

Test.startTest(); 

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
}
Test.stopTest();
}
	static testMethod void directEnterprise1070109() {
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

Test.startTest(); 

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
}
Test.stopTest();
}

//method for InDirect_Quotes

/*static testMethod void DirectMethod1() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
custSetting.Name = 'Nokia_CallBack1';
//insert custSetting;

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

Product2 prod1 = new product2(
Name = 'Test1', 
ProductCode = '123',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Bundle',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod1);

Product2 prod2 = new product2(
Name = 'Maintenance Year1', 
ProductCode = 'MT001', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'IP Routing',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'); 
prods.add(prod2);

Product2 prod3 = new product2(
Name = 'Test2', 
ProductCode = '1234',  
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'
); 
prods.add(prod3);

Product2 prod5 = new product2(
Name = 'Maintenance Year2+', 
ProductCode = 'MT002', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'IP Routing',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone'
); 
prods.add(prod5); 

Product2 prod6 = new product2(
Name = 'Test1Arcadia', 
ProductCode = '123Arcadia',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Bundle',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod6);   

Product2 prod7 = new product2(
Name = 'Test2Arcadia', 
ProductCode = 'Arcadia2',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod7); 


Product2 prod8 = new product2(
Name = '12678', 
ProductCode = '12678',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod8); 

insert prods;

//Create PriceList

Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
Name = 'Commercial Price List', 
Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
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
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
);
//insert pLI2;
plistItems.add(pLI2);

Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod3.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI3);


Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod5.Id, 
Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond'
);
//insert pLI1;
plistItems.add(pLI5);

Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod6.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI6);

Apttus_Config2__PriceListItem__c pLI7 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod7.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI7);

Apttus_Config2__PriceListItem__c pLI8 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod8.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI8);

insert plistItems;


		//create proposal
		Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Portfolio__c = 'Airscale Wifi',
		NokiaCPQ_No_of_Years__c = '4',
		NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced Emergency',
		RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
		Apttus_Proposal__Account__c=accLegalEntity.id,
		Sold_To_Party__c = accLegalEntity.id,
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		NokiaCPQ_Existing_IONMaint_Contract__c='No',
		Is_List_Price_Only__c =false
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
Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__PriceListItemId__c = pLI1.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePrice__c=100,
Apttus_Config2__ListPrice__c = 100,
Apttus_Config2__Quantity__c = 1,
Source__c='',
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__AddedBy__c = 'added by code',
NokiaCPQ_Unitary_IRP__c = 300,
NokiaCPQ_Product_Type__c='Controller'

);
//insert LineItem2;
allLineItems.add(LineItem1);

Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 2,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod6.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
Apttus_Config2__PriceListItemId__c = pLI6.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 2,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Product_Type__c = 'Access Point',  
Apttus_Config2__AddedBy__c = 'added by code',
Apttus_Config2__AdjustmentType__c = '% Discount',
NokiaCPQ_Unitary_IRP__c = 1300,
Apttus_Config2__AdjustmentAmount__c = 10
);
//insert LineItem1;
allLineItems.add(LineItem3);

Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 3,
Apttus_Config2__LineNumber__c = 2,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Year 1 Maintenance', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod2.Id,
Apttus_Config2__PriceListItemId__c = pLI2.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
Apttus_Config2__ListPrice__c = 120,
Apttus_Config2__BasePrice__c=120,
Apttus_Config2__Quantity__c = 1,
Apttus_Config2__PriceIncludedInBundle__c = true,
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
NokiaCPQ_Unitary_IRP__c = 400,
Apttus_Config2__AddedBy__c = 'added by code'	 
);
//insert LineItem1;
allLineItems.add(LineItem4);

Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 4,
Apttus_Config2__LineNumber__c = 3,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod5.Id,
Apttus_Config2__PriceListItemId__c = pLI5.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
Apttus_Config2__ListPrice__c = 120,
Apttus_Config2__BasePrice__c=120,
Apttus_Config2__Quantity__c = 1,
Apttus_Config2__PriceIncludedInBundle__c = true,
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
NokiaCPQ_Unitary_IRP__c = 300,
Apttus_Config2__AddedBy__c = 'added by code'	 
);
//insert LineItem1;
allLineItems.add(LineItem5);

Apttus_Config2__LineItem__c LineItem6 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 5,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod6.Id,
Apttus_Config2__OptionId__c = prod3.Id,
Apttus_Config2__ParentBundleNumber__c = 2,
Apttus_Config2__PriceListItemId__c = pLI3.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 3,
NokiaCPQ_Unitary_IRP__c = 300,
Apttus_Config2__ShipToAccountId__c = account.Id,


Apttus_Config2__AddedBy__c = 'added by code'
);
//insert LineItem1;
allLineItems.add(LineItem6);

Apttus_Config2__LineItem__c LineItem7 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 6,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod7.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
Apttus_Config2__PriceListItemId__c = pLI7.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 2,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Product_Type__c = 'Controller',			
Apttus_Config2__AddedBy__c = 'added by code',
NokiaCPQ_Unitary_IRP__c = 100,
Apttus_Config2__AdjustmentType__c = 'Discount Amount',
Apttus_Config2__AdjustmentAmount__c = 100
);
//insert LineItem1;
allLineItems.add(LineItem7);

Apttus_Config2__LineItem__c LineItem8 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 2,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod6.Id,
Apttus_Config2__OptionId__c = prod8.Id,
Apttus_Config2__ParentBundleNumber__c = 2,
Apttus_Config2__PriceListItemId__c = pLI8.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 3,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Unitary_IRP__c = 600,
NokiaCPQ_Product_Type__c = 'Third Party Wavespot',  

Apttus_Config2__AddedBy__c = 'added by code'
);
allLineItems.add(LineItem8);

insert allLineItems;


Test.startTest(); 

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

}
Test.stopTest();
}*/

/*static testMethod void AirscalewifisoftwareMethod() {
Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
custSetting.Name = 'Nokia_CallBack1';
//insert custSetting;

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

Product2 prod1 = new product2(
Name = 'Test1', 
ProductCode = '123',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Bundle',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod1);


Product2 prod7 = new product2(
Name = 'Test2Arcadia', 
ProductCode = 'Arcadia2',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod7); 

insert prods;

//Create PriceList

Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
Name = 'Commercial Price List', 
Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
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
plistItems.add(pLI1);

Apttus_Config2__PriceListItem__c pLI7 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod7.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
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
		NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.AIRSCALE_WIFI_STRING,
		NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Enhanced Emergency',
		NokiaCPQ_No_of_Years__c = '2',
		RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
		Apttus_Proposal__Account__c=accLegalEntity.id,
		Sold_To_Party__c = accLegalEntity.id,
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		NokiaCPQ_Existing_IONMaint_Contract__c='No',
		Is_List_Price_Only__c =false
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
Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__PriceListItemId__c = pLI1.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePrice__c=100,
Apttus_Config2__ListPrice__c = 100,
Apttus_Config2__Quantity__c = 1,
Source__c='',
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__AddedBy__c = 'added by code',
NokiaCPQ_Product_Type__c='Controller'

);
//insert LineItem2;
allLineItems.add(LineItem1);

Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 2,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod7.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
Apttus_Config2__PriceListItemId__c = pLI7.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 2,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Product_Type__c = 'Access Point',  
Apttus_Config2__AddedBy__c = 'added by code',
Apttus_Config2__AdjustmentType__c = '% Discount',
Apttus_Config2__AdjustmentAmount__c = 10
);
allLineItems.add(LineItem3);

insert allLineItems;

Test.startTest(); 

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

}
Test.stopTest();
}
*/
static testMethod void directEnterpriseMethod() {
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

Product2 prod3 = new product2(
Name = 'SSP', 
ProductCode = 'SSP002', 
Business_Group__c = 'MN', 
CurrencyIsoCode = 'USD',
IsActive = true,
NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR',
Apttus_Config2__ConfigurationType__c = 'Standalone'
); 
prods.add(prod3);   
Product2 prod4 = new product2(
Name = 'Maintenance Year2+', 
ProductCode = 'MT002', 
Business_Group__c = 'MN', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'IP Routing',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
); 
prods.add(prod4);

Product2 prod5 = new product2(
Name = 'SRS', 
ProductCode = 'SRS002', 
//Business_Group__c = 'ION', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'IP Routing',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base',
NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
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
rec1.Maintenance_Category__c = 'NSD-NRC IPR';
insert rec1;

Nokia_PricingCallBack obj = new Nokia_PricingCallBack();

obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfigList[0].Id);

obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
obj.finish();

//Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfigList[0].Id);

//Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
}
Test.stopTest();
}

/*static testMethod void DirectMethod11() {
		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
		//insert custSetting;
		
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
			
			Product2 prod1 = new product2(
	Name = 'Test1', 
	ProductCode = '123',
	CurrencyIsoCode = 'USD',
	Portfolio__c = 'Airscale Wifi',
	IsActive = true,
	Apttus_Config2__ConfigurationType__c = 'Bundle',
	NokiaCPQ_Item_Type__c='Software',
	NokiaCPQ_Classification2__c='Base'   
			); 
			prods.add(prod1); 
	 
	 Product2 prod2 = new product2(
			Name = 'Test1Arcadia', 
			ProductCode = '123Arcadia',
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'Airscale Wifi',
			IsActive = true,
			Apttus_Config2__ConfigurationType__c = 'Standalone',
			NokiaCPQ_Item_Type__c='Hardware',
			NokiaCPQ_Classification2__c='Base'   
			); 
		prods.add(prod2);  
		insert prods;
			
			//Create PriceList
			
			Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
	Name = 'Commercial Price List', 
	Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
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
			
			plistItems.add(pLI1);   
			
			Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
	Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
	Apttus_Config2__ListPrice__c = 100, 
	Apttus_Config2__ProductId__c = prod2.Id, 
	Apttus_Config2__ChargeType__c = 'Standard Price'
			);
			plistItems.add(pLI2); 
			insert plistItems;
			
			//create proposal
			Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Portfolio__c = 'Airscale Wifi',
	NokiaCPQ_No_of_Years__c = '4',
	NokiaCPQ_Maintenance_Type__c='MN GS TSS Basic',
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
	Apttus_Proposal__Account__c=accLegalEntity.id,
	Sold_To_Party__c = accLegalEntity.id,
	NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	Is_List_Price_Only__c =false
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
			Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
	Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
	Apttus_Config2__ItemSequence__c = 1,
	Apttus_Config2__LineNumber__c = 1,
	Apttus_Config2__LineStatus__c='New',
	Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
	Apttus_Config2__ChargeType__c = 'Standard Price', 
	Apttus_Config2__LineType__c = 'Product/Service',
	Apttus_Config2__ProductId__c = prod1.Id,
	Apttus_Config2__PriceListItemId__c = pLI1.id,
	Apttus_Config2__PriceMethod__c = 'Per Unit',
	Apttus_Config2__Frequency__c = 'One Time',
	Apttus_Config2__BasePrice__c=100,
	Apttus_Config2__ListPrice__c = 100,
	Apttus_Config2__Quantity__c = 1,
	Source__c='',
	Apttus_Config2__PrimaryLineNumber__c = 1,
	Apttus_Config2__ShipToAccountId__c = account.Id,
	is_Custom_Product__c=false,
	Apttus_Config2__BasePriceOverride__c=120,
	Apttus_Config2__AddedBy__c = 'added by code',
	NokiaCPQ_Unitary_IRP__c = 300,
	NokiaCPQ_Product_Type__c='Controller',
	Total_ONT_Quantity_FBA__c = 300
	
			);
			
			allLineItems.add(LineItem1);
			
			Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 2,
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Option',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__OptionId__c = prod2.Id,
			Apttus_Config2__ParentBundleNumber__c = 1,
			Apttus_Config2__PriceListItemId__c = pLI2.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__BasePriceOverride__c=120,
			Apttus_Config2__ListPrice__c = 300,
			Apttus_Config2__BasePrice__c=300,
			Apttus_Config2__Quantity__c = 1,
			is_Custom_Product__c=false,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = account.Id,
	Total_ONT_Quantity_FBA__c = 300,
			Apttus_Config2__AddedBy__c = 'added by code'
			);
			allLineItems.add(LineItem2);
			insert allLineItems;
			
			Test.startTest(); 
			
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
			
		}
		Test.stopTest();
	}
   */

	
	 static testMethod void IndirectIPRouting() {
	
	Apttus_Config2__ClassificationName__c categoerySO = new Apttus_Config2__ClassificationName__c (Apttus_Config2__Active__c = true
	, Apttus_Config2__Type__c = 'Offering'
	, Apttus_Config2__HierarchyLabel__c = 'Test826');
	insert categoerySO;

	Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
	);
	insert priceListSO;
	
	//Create Product
   List<Product2> prods = new List<Product2>();
   Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		, NokiaCPQ_Product_Discount_Category__c = 'Standard'
   ); 
   prods.add(prod1);
	
   Product2 prod2 = new product2(
	  Name = 'Maintenance Year1', 
	  ProductCode = 'MT001', 
	  Business_Group__c = 'MN', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = 'IP Routing',
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'
			
   ); 
   prods.add(prod2);
   
   Product2 prod3 = new product2(
	  Name = 'SRS', 
	  ProductCode = 'SRS001', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = 'IP Routing',
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'  
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'   
   ); 
   prods.add(prod3);
   
   Product2 prod4 = new product2(
	  Name = 'SSP', 
	  ProductCode = 'SSP002', 
	  CurrencyIsoCode = 'USD',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'   
   ); 
   prods.add(prod4);
   
   Product2 prod5 = new product2(
	  Name = 'Maintenance Year2+', 
	  ProductCode = 'MT002',  
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = 'IP Routing',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c ='NFM-P IPR',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
   ); 
   prods.add(prod5);
	 
   Product2 prod6 = new product2(
	  Name = 'prod6', 
	  ProductCode = 'P6', 
	  CurrencyIsoCode = 'USD',
	Portfolio__c = 'IP Routing',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone' 
   ); 
   prods.add(prod6);
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
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 100, 
	  Apttus_Config2__ProductId__c = prod1.Id, 
	  Apttus_Config2__ChargeType__c = 'Standard Price'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
   );
   //insert pLI1;
   plistItems.add(pLI1);
	
	Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod2.Id, 
	  Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI2;
	plistItems.add(pLI2);
	
	Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod3.Id, 
	  Apttus_Config2__ChargeType__c = 'SRS'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI1;
	plistItems.add(pLI3);
	
	Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'SSP'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI4);
	
	 Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI5);
	 
	 
	 Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 800, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit' 
	);
	//insert pLI1;
	plistItems.add(pLI6);
	insert plistItems;

	Apttus_Config2__PriceListCategory__c priceListCategorySO 
		= new Apttus_Config2__PriceListCategory__c(Apttus_Config2__HierarchyId__c = categoerySO.id
	, Apttus_Config2__PriceListId__c = priceListSO.id
	, Apttus_Config2__Sequence__c =1);

	Apttus_Config2__ClassificationHierarchy__c chSO 
		= new Apttus_Config2__ClassificationHierarchy__c(Apttus_Config2__HierarchyId__c = categoerySO.id
		, Apttus_Config2__Left__c=1
		, Apttus_Config2__Right__c=2
		, Apttus_Config2__Label__c= 'My Category');
	insert chSO;

	List<Apttus_Config2__ProductClassification__c> productClassificationList = new List<Apttus_Config2__ProductClassification__c>();
	Apttus_Config2__ProductClassification__c productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod1.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 1;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod2.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 2;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	
	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod3.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 3;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod4.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 4;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod5.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 5;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod6.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 6;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	try{
		insert productClassificationList;
	}catch(Exception ex){

	}

	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
	custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
	custSetting.Name = 'Nokia_CallBack1';
	//insert custSetting;
	
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
		/*  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
			opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
			opportunities.get(0).Account_Role__c = 'Alliance Partner';
			insert opportunities.get(0);*/
			opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts1[0].Id;
	insert opportunities;
			
			//create Accreditation
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c='IP Routing',
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Co-Branded',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c='IP Routing',
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Advanced',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = 'IP Routing';
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
	testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	NokiaCPQ_SSP_Level__c = 'Unlimited',
	NokiaCPQ_SRS_Level__c = 'Unlimited',
	NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
	NokiaCPQ_Portfolio__c = 'IP Routing',
	NokiaCPQ_No_of_Years__c = '1',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Level__c = 'Yes',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	NokiaCPQ_LEO_Discount__c=false,
	Is_List_Price_Only__c =false,
	NokiaCPQ_Is_cloned__c = false,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
	isCQ__c = false
			
	);
			
			
	insert testProposal;
		}
		

		/*Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
		request.QuoteId = testProposal.Id;
		// Excute the createCart routine
		Apttus_CPQApi.CPQ.CreateCartResponseDO cartResponse = Apttus_CPQApi.CPQWebService.createCart(request);
		*/
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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
	from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:	 ProdConfig.id];//cartResponse.CartID];
			if(lineItem != null && lineItem.size() > 0){
	system.debug('cart lines size...' + lineItem.size());
	system.debug('cart lines...' + lineItem);
	for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
		System.debug('lineItemSO...'+ lineItemSO);
	}
			}else{
	system.debug('cart lines does not exist...');
			}
			
			/*
			Apttus_CPQApi.CPQ.ProductSearchResultDO productResult = Apttus_CPQApi.CPQWebService.getProductsForPriceList(priceListSO.id);
	system.debug('productResult....'+productResult);
			For(Apttus_CPQApi.CPQ.ProductDO catresult : productResult.Products){
	system.debug('price list products....'+ productSO.id + '...' + catresult.Name + '...' + catresult.Prices);
			}
			*/
			//Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
		}catch(Exception ex){
			throw ex;
		}
	}
		 Test.stopTest();
	}
	 static testMethod void IndirectIPRouting770() {
	
	Apttus_Config2__ClassificationName__c categoerySO = new Apttus_Config2__ClassificationName__c (Apttus_Config2__Active__c = true
	, Apttus_Config2__Type__c = 'Offering'
	, Apttus_Config2__HierarchyLabel__c = 'Test826');
	insert categoerySO;

	Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
	);
	insert priceListSO;
	
	//Create Product
   List<Product2> prods = new List<Product2>();
   Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		, NokiaCPQ_Product_Discount_Category__c = 'Standard'
   ); 
   prods.add(prod1);
	
   Product2 prod2 = new product2(
	  Name = 'Maintenance Year1', 
	  ProductCode = 'MT001', 
	  Business_Group__c = 'MN', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = 'IP Routing',
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'
			
   ); 
   prods.add(prod2);
   
   Product2 prod3 = new product2(
	  Name = 'SRS', 
	  ProductCode = 'SRS001', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = 'IP Routing',
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'  
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'   
   ); 
   prods.add(prod3);
   
   Product2 prod4 = new product2(
	  Name = 'SSP', 
	  ProductCode = 'SSP002', 
	  CurrencyIsoCode = 'USD',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'   
   ); 
   prods.add(prod4);
   
   Product2 prod5 = new product2(
	  Name = 'Maintenance Year2+', 
	  ProductCode = 'MT002',  
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = 'IP Routing',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c ='NFM-P IPR',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
   ); 
   prods.add(prod5);
	 
   Product2 prod6 = new product2(
	  Name = 'prod6', 
	  ProductCode = 'P6', 
	  CurrencyIsoCode = 'USD',
	Portfolio__c = 'IP Routing',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone' 
   ); 
   prods.add(prod6);
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
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 100, 
	  Apttus_Config2__ProductId__c = prod1.Id, 
	  Apttus_Config2__ChargeType__c = 'Standard Price'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
   );
   //insert pLI1;
   plistItems.add(pLI1);
	
	Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod2.Id, 
	  Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI2;
	plistItems.add(pLI2);
	
	Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod3.Id, 
	  Apttus_Config2__ChargeType__c = 'SRS'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI1;
	plistItems.add(pLI3);
	
	Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'SSP'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI4);
	
	 Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI5);
	 
	 
	 Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 800, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit' 
	);
	//insert pLI1;
	plistItems.add(pLI6);
	insert plistItems;

	Apttus_Config2__PriceListCategory__c priceListCategorySO 
		= new Apttus_Config2__PriceListCategory__c(Apttus_Config2__HierarchyId__c = categoerySO.id
	, Apttus_Config2__PriceListId__c = priceListSO.id
	, Apttus_Config2__Sequence__c =1);

	Apttus_Config2__ClassificationHierarchy__c chSO 
		= new Apttus_Config2__ClassificationHierarchy__c(Apttus_Config2__HierarchyId__c = categoerySO.id
		, Apttus_Config2__Left__c=1
		, Apttus_Config2__Right__c=2
		, Apttus_Config2__Label__c= 'My Category');
	insert chSO;

	List<Apttus_Config2__ProductClassification__c> productClassificationList = new List<Apttus_Config2__ProductClassification__c>();
	Apttus_Config2__ProductClassification__c productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod1.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 1;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod2.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 2;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	
	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod3.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 3;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod4.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 4;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod5.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 5;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod6.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 6;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	try{
		insert productClassificationList;
	}catch(Exception ex){

	}

	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
	custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
	custSetting.Name = 'Nokia_CallBack1';
	//insert custSetting;
	
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
		/*  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
			opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
			opportunities.get(0).Account_Role__c = 'Alliance Partner';
			insert opportunities.get(0);*/
			opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts1[0].Id;
	insert opportunities;
			//create Accreditation
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c='IP Routing',
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Co-Branded',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c='IP Routing',
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Advanced',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = 'IP Routing';
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
	testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	NokiaCPQ_SSP_Level__c = 'Unlimited',
	NokiaCPQ_SRS_Level__c = 'Unlimited',
	NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
	NokiaCPQ_Portfolio__c = 'IP Routing',
	NokiaCPQ_No_of_Years__c = '1',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Level__c = 'Yes',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	NokiaCPQ_LEO_Discount__c=false,
	Is_List_Price_Only__c =false,
	NokiaCPQ_Is_cloned__c = false,
	Maintenance_Y1__c = 5,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
	isCQ__c = false
			
	);
			
			
	insert testProposal;
		}
		

		/*Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
		request.QuoteId = testProposal.Id;
		// Excute the createCart routine
		Apttus_CPQApi.CPQ.CreateCartResponseDO cartResponse = Apttus_CPQApi.CPQWebService.createCart(request);
		*/
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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
	from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:	 ProdConfig.id];//cartResponse.CartID];
			if(lineItem != null && lineItem.size() > 0){
	system.debug('cart lines size...' + lineItem.size());
	system.debug('cart lines...' + lineItem);
	for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
		System.debug('lineItemSO...'+ lineItemSO);
	}
			}else{
	system.debug('cart lines does not exist...');
			}
			
			/*
			Apttus_CPQApi.CPQ.ProductSearchResultDO productResult = Apttus_CPQApi.CPQWebService.getProductsForPriceList(priceListSO.id);
	system.debug('productResult....'+productResult);
			For(Apttus_CPQApi.CPQ.ProductDO catresult : productResult.Products){
	system.debug('price list products....'+ productSO.id + '...' + catresult.Name + '...' + catresult.Prices);
			}
			*/
			//Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
		}catch(Exception ex){
			throw ex;
		}
	}
		 Test.stopTest();
	}
	static testMethod void IndirectIPRouting299() {
	
	Apttus_Config2__ClassificationName__c categoerySO = new Apttus_Config2__ClassificationName__c (Apttus_Config2__Active__c = true
	, Apttus_Config2__Type__c = 'Offering'
	, Apttus_Config2__HierarchyLabel__c = 'Test826');
	insert categoerySO;

	Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
	);
	insert priceListSO;
	
	//Create Product
   List<Product2> prods = new List<Product2>();
   Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		, NokiaCPQ_Product_Discount_Category__c = 'Standard'
   ); 
   prods.add(prod1);
	
   Product2 prod2 = new product2(
	  Name = 'Maintenance Year1', 
	  ProductCode = 'MT001', 
	  Business_Group__c = 'MN', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = 'IP Routing',
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'
			
   ); 
   prods.add(prod2);
   
   Product2 prod3 = new product2(
	  Name = 'SRS', 
	  ProductCode = 'SRS001', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = 'IP Routing',
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'  
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'   
   ); 
   prods.add(prod3);
   
   Product2 prod4 = new product2(
	  Name = 'SSP', 
	  ProductCode = 'SSP002', 
	  CurrencyIsoCode = 'USD',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'   
   ); 
   prods.add(prod4);
   
   Product2 prod5 = new product2(
	  Name = 'Maintenance Year2+', 
	  ProductCode = 'MT002',  
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = 'IP Routing',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c ='NFM-P IPR',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
   ); 
   prods.add(prod5);
	 
   Product2 prod6 = new product2(
	  Name = 'prod6', 
	  ProductCode = 'P6', 
	  CurrencyIsoCode = 'USD',
	Portfolio__c = 'IP Routing',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone' 
   ); 
   prods.add(prod6);
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
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 100, 
	  Apttus_Config2__ProductId__c = prod1.Id, 
	  Apttus_Config2__ChargeType__c = 'Standard Price'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
   );
   //insert pLI1;
   plistItems.add(pLI1);
	
	Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod2.Id, 
	  Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI2;
	plistItems.add(pLI2);
	
	Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod3.Id, 
	  Apttus_Config2__ChargeType__c = 'SRS'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI1;
	plistItems.add(pLI3);
	
	Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'SSP'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI4);
	
	 Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI5);
	 
	 
	 Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 800, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit' 
	);
	//insert pLI1;
	plistItems.add(pLI6);
	insert plistItems;

	Apttus_Config2__PriceListCategory__c priceListCategorySO 
		= new Apttus_Config2__PriceListCategory__c(Apttus_Config2__HierarchyId__c = categoerySO.id
	, Apttus_Config2__PriceListId__c = priceListSO.id
	, Apttus_Config2__Sequence__c =1);

	Apttus_Config2__ClassificationHierarchy__c chSO 
		= new Apttus_Config2__ClassificationHierarchy__c(Apttus_Config2__HierarchyId__c = categoerySO.id
		, Apttus_Config2__Left__c=1
		, Apttus_Config2__Right__c=2
		, Apttus_Config2__Label__c= 'My Category');
	insert chSO;

	List<Apttus_Config2__ProductClassification__c> productClassificationList = new List<Apttus_Config2__ProductClassification__c>();
	Apttus_Config2__ProductClassification__c productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod1.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 1;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod2.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 2;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	
	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod3.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 3;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod4.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 4;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod5.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 5;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod6.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 6;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	try{
		insert productClassificationList;
	}catch(Exception ex){

	}

	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
	custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
	custSetting.Name = 'Nokia_CallBack1';
	//insert custSetting;
	
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
			opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
			opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
			opportunities.get(0).Account_Role__c = 'Alliance Partner';
			insert opportunities.get(0);
			
			//create Accreditation
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c='IP Routing',
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Co-Branded',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c='IP Routing',
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Advanced',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = 'IP Routing';
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
	testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	NokiaCPQ_SSP_Level__c = 'Unlimited',
	NokiaCPQ_SRS_Level__c = 'Unlimited',
	NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
	NokiaCPQ_Portfolio__c = 'IP Routing',
	NokiaCPQ_No_of_Years__c = '1',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Level__c = 'Yes',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	NokiaCPQ_LEO_Discount__c=true,
	Is_List_Price_Only__c =false,
	NokiaCPQ_Is_cloned__c = false,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
	isCQ__c = false
			
	);
			
			
	insert testProposal;
	//CurrencyIsoCode = Nokia_CPQ_Constants.EUR_CURR;
	//update testProposal;
		}
		

		/*Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
		request.QuoteId = testProposal.Id;
		// Excute the createCart routine
		Apttus_CPQApi.CPQ.CreateCartResponseDO cartResponse = Apttus_CPQApi.CPQWebService.createCart(request);
		*/
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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
	from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:	 ProdConfig.id];//cartResponse.CartID];
			if(lineItem != null && lineItem.size() > 0){
	system.debug('cart lines size...' + lineItem.size());
	system.debug('cart lines...' + lineItem);
	for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
		System.debug('lineItemSO...'+ lineItemSO);
	}
			}else{
	system.debug('cart lines does not exist...');
			}
			
			/*
			Apttus_CPQApi.CPQ.ProductSearchResultDO productResult = Apttus_CPQApi.CPQWebService.getProductsForPriceList(priceListSO.id);
	system.debug('productResult....'+productResult);
			For(Apttus_CPQApi.CPQ.ProductDO catresult : productResult.Products){
	system.debug('price list products....'+ productSO.id + '...' + catresult.Name + '...' + catresult.Prices);
			}
			*/
			//Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
		}catch(Exception ex){
			throw ex;
		}
	}
		 Test.stopTest();
	}
	static testMethod void IndirectIPRouting308() {
	
	Apttus_Config2__ClassificationName__c categoerySO = new Apttus_Config2__ClassificationName__c (Apttus_Config2__Active__c = true
	, Apttus_Config2__Type__c = 'Offering'
	, Apttus_Config2__HierarchyLabel__c = 'Test826');
	insert categoerySO;

	Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
	);
	insert priceListSO;
	
	//Create Product
   List<Product2> prods = new List<Product2>();
   Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		, NokiaCPQ_Product_Discount_Category__c = 'Standard'
   ); 
   prods.add(prod1);
	
   Product2 prod2 = new product2(
	  Name = 'Maintenance Year1', 
	  ProductCode = 'MT001', 
	  Business_Group__c = 'MN', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = 'IP Routing',
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'
			
   ); 
   prods.add(prod2);
   
   Product2 prod3 = new product2(
	  Name = 'SRS', 
	  ProductCode = 'SRS001', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = 'IP Routing',
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'  
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'   
   ); 
   prods.add(prod3);
   
   Product2 prod4 = new product2(
	  Name = 'SSP', 
	  ProductCode = 'SSP002', 
	  CurrencyIsoCode = 'USD',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'   
   ); 
   prods.add(prod4);
   
   Product2 prod5 = new product2(
	  Name = 'Maintenance Year2+', 
	  ProductCode = 'MT002',  
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = 'IP Routing',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c ='NFM-P IPR',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
   ); 
   prods.add(prod5);
	 
   Product2 prod6 = new product2(
	  Name = 'prod6', 
	  ProductCode = 'P6', 
	  CurrencyIsoCode = 'USD',
	Portfolio__c = 'IP Routing',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone' 
   ); 
   prods.add(prod6);
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
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 100, 
	  Apttus_Config2__ProductId__c = prod1.Id, 
	  Apttus_Config2__ChargeType__c = 'Standard Price'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
   );
   //insert pLI1;
   plistItems.add(pLI1);
	
	Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod2.Id, 
	  Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI2;
	plistItems.add(pLI2);
	
	Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod3.Id, 
	  Apttus_Config2__ChargeType__c = 'SRS'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI1;
	plistItems.add(pLI3);
	
	Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'SSP'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI4);
	
	 Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI5);
	 
	 
	 Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 800, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit' 
	);
	//insert pLI1;
	plistItems.add(pLI6);
	insert plistItems;

	Apttus_Config2__PriceListCategory__c priceListCategorySO 
		= new Apttus_Config2__PriceListCategory__c(Apttus_Config2__HierarchyId__c = categoerySO.id
	, Apttus_Config2__PriceListId__c = priceListSO.id
	, Apttus_Config2__Sequence__c =1);

	Apttus_Config2__ClassificationHierarchy__c chSO 
		= new Apttus_Config2__ClassificationHierarchy__c(Apttus_Config2__HierarchyId__c = categoerySO.id
		, Apttus_Config2__Left__c=1
		, Apttus_Config2__Right__c=2
		, Apttus_Config2__Label__c= 'My Category');
	insert chSO;

	List<Apttus_Config2__ProductClassification__c> productClassificationList = new List<Apttus_Config2__ProductClassification__c>();
	Apttus_Config2__ProductClassification__c productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod1.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 1;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod2.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 2;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	
	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod3.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 3;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod4.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 4;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod5.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 5;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod6.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 6;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	try{
		insert productClassificationList;
	}catch(Exception ex){

	}

	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
	custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
	custSetting.Name = 'Nokia_CallBack1';
	//insert custSetting;
	
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
		/*  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
			opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
			opportunities.get(0).Account_Role__c = 'Alliance Partner';
			insert opportunities.get(0);*/
			opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts1[0].Id;
	insert opportunities;
			
			//create Accreditation
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c='IP Routing',
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Advanced',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c='IP Routing',
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Advanced',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = 'IP Routing';
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
	testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	NokiaCPQ_SSP_Level__c = 'Unlimited',
	NokiaCPQ_SRS_Level__c = 'Unlimited',
	NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
	NokiaCPQ_Portfolio__c = 'IP Routing',
	NokiaCPQ_No_of_Years__c = '1',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Level__c = 'No',
	CurrencyIsoCode = Nokia_CPQ_Constants.EUR_CURR,
	NokiaCPQ_LEO_Discount__c=false,
	Is_List_Price_Only__c =false,
	NokiaCPQ_Is_cloned__c = false,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
	isCQ__c = false
			
	);
			
			
	insert testProposal;
	testProposal.CurrencyIsoCode = Nokia_CPQ_Constants.EUR_CURR;
	update testProposal;
		}
		

		/*Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
		request.QuoteId = testProposal.Id;
		// Excute the createCart routine
		Apttus_CPQApi.CPQ.CreateCartResponseDO cartResponse = Apttus_CPQApi.CPQWebService.createCart(request);
		*/
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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
	from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:	 ProdConfig.id];//cartResponse.CartID];
			if(lineItem != null && lineItem.size() > 0){
	system.debug('cart lines size...' + lineItem.size());
	system.debug('cart lines...' + lineItem);
	for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
		System.debug('lineItemSO...'+ lineItemSO);
	}
			}else{
	system.debug('cart lines does not exist...');
			}
			
			/*
			Apttus_CPQApi.CPQ.ProductSearchResultDO productResult = Apttus_CPQApi.CPQWebService.getProductsForPriceList(priceListSO.id);
	system.debug('productResult....'+productResult);
			For(Apttus_CPQApi.CPQ.ProductDO catresult : productResult.Products){
	system.debug('price list products....'+ productSO.id + '...' + catresult.Name + '...' + catresult.Prices);
			}
			*/
			//Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
		}catch(Exception ex){
			throw ex;
		}
	}
		 Test.stopTest();
	}
	static testMethod void IndirectIPRouting305() {
	
	Apttus_Config2__ClassificationName__c categoerySO = new Apttus_Config2__ClassificationName__c (Apttus_Config2__Active__c = true
	, Apttus_Config2__Type__c = 'Offering'
	, Apttus_Config2__HierarchyLabel__c = 'Test826');
	insert categoerySO;

	Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
	);
	insert priceListSO;
	
	//Create Product
   List<Product2> prods = new List<Product2>();
   Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		, NokiaCPQ_Product_Discount_Category__c = 'Standard'
   ); 
   prods.add(prod1);
	
   Product2 prod2 = new product2(
	  Name = 'Maintenance Year1', 
	  ProductCode = 'MT001', 
	  Business_Group__c = 'MN', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = 'IP Routing',
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'
			
   ); 
   prods.add(prod2);
   
   Product2 prod3 = new product2(
	  Name = 'SRS', 
	  ProductCode = 'SRS001', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = 'IP Routing',
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'  
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'   
   ); 
   prods.add(prod3);
   
   Product2 prod4 = new product2(
	  Name = 'SSP', 
	  ProductCode = 'SSP002', 
	  CurrencyIsoCode = 'EUR',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'   
   ); 
   prods.add(prod4);
   
   Product2 prod5 = new product2(
	  Name = 'Maintenance Year2+', 
	  ProductCode = 'MT002',  
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = 'IP Routing',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c ='NFM-P IPR',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
   ); 
   prods.add(prod5);
	 
   Product2 prod6 = new product2(
	  Name = 'prod6', 
	  ProductCode = 'P6', 
	  CurrencyIsoCode = 'USD',
	Portfolio__c = 'IP Routing',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone' 
   ); 
   prods.add(prod6);
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
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 100, 
	  Apttus_Config2__ProductId__c = prod1.Id, 
	  Apttus_Config2__ChargeType__c = 'Standard Price'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
   );
   //insert pLI1;
   plistItems.add(pLI1);
	
	Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod2.Id, 
	  Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI2;
	plistItems.add(pLI2);
	
	Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod3.Id, 
	  Apttus_Config2__ChargeType__c = 'SRS'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI1;
	plistItems.add(pLI3);
	
	Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'SSP'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI4);
	
	 Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI5);
	 
	 
	 Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 800, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit' 
	);
	//insert pLI1;
	plistItems.add(pLI6);
	insert plistItems;

	Apttus_Config2__PriceListCategory__c priceListCategorySO 
		= new Apttus_Config2__PriceListCategory__c(Apttus_Config2__HierarchyId__c = categoerySO.id
	, Apttus_Config2__PriceListId__c = priceListSO.id
	, Apttus_Config2__Sequence__c =1);

	Apttus_Config2__ClassificationHierarchy__c chSO 
		= new Apttus_Config2__ClassificationHierarchy__c(Apttus_Config2__HierarchyId__c = categoerySO.id
		, Apttus_Config2__Left__c=1
		, Apttus_Config2__Right__c=2
		, Apttus_Config2__Label__c= 'My Category');
	insert chSO;

	List<Apttus_Config2__ProductClassification__c> productClassificationList = new List<Apttus_Config2__ProductClassification__c>();
	Apttus_Config2__ProductClassification__c productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod1.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 1;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod2.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 2;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	
	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod3.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 3;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod4.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 4;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod5.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 5;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod6.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 6;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	try{
		insert productClassificationList;
	}catch(Exception ex){

	}

	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
	custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
	custSetting.Name = 'Nokia_CallBack1';
	//insert custSetting;
	
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
		/*  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
			opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
			opportunities.get(0).Account_Role__c = 'Alliance Partner';
			insert opportunities.get(0);*/
			opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts1[0].Id;
	insert opportunities;
			
			//create Accreditation
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c='IP Routing',
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Co-Branded',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c='IP Routing',
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Advanced',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = 'IP Routing';
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
	testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	NokiaCPQ_SSP_Level__c = 'Unlimited',
	NokiaCPQ_SRS_Level__c = 'Unlimited',
	NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
	NokiaCPQ_Portfolio__c = 'IP Routing',
	NokiaCPQ_No_of_Years__c = '1',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Level__c = 'Yes',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	NokiaCPQ_LEO_Discount__c=true,
	Is_List_Price_Only__c =false,
	NokiaCPQ_Is_cloned__c = false,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
	isCQ__c = false
			
	);
			
			
	insert testProposal;
	testProposal.CurrencyIsoCode = Nokia_CPQ_Constants.EUR_CURR;
	update testProposal;
		}
		

		/*Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
		request.QuoteId = testProposal.Id;
		// Excute the createCart routine
		Apttus_CPQApi.CPQ.CreateCartResponseDO cartResponse = Apttus_CPQApi.CPQWebService.createCart(request);
		*/
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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
	from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:	 ProdConfig.id];//cartResponse.CartID];
			if(lineItem != null && lineItem.size() > 0){
	system.debug('cart lines size...' + lineItem.size());
	system.debug('cart lines...' + lineItem);
	for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
		System.debug('lineItemSO...'+ lineItemSO);
	}
			}else{
	system.debug('cart lines does not exist...');
			}
			
			/*
			Apttus_CPQApi.CPQ.ProductSearchResultDO productResult = Apttus_CPQApi.CPQWebService.getProductsForPriceList(priceListSO.id);
	system.debug('productResult....'+productResult);
			For(Apttus_CPQApi.CPQ.ProductDO catresult : productResult.Products){
	system.debug('price list products....'+ productSO.id + '...' + catresult.Name + '...' + catresult.Prices);
			}
			*/
			//Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
		}catch(Exception ex){
			throw ex;
		}
	}
		 Test.stopTest();
	}
	static testMethod void IndirectFBA() {
	
	Apttus_Config2__ClassificationName__c categoerySO = new Apttus_Config2__ClassificationName__c (Apttus_Config2__Active__c = true
	, Apttus_Config2__Type__c = 'Offering'
	, Apttus_Config2__HierarchyLabel__c = 'Test826');
	insert categoerySO;

	Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
	);
	insert priceListSO;
	
	//Create Product
   List<Product2> prods = new List<Product2>();
   Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		, NokiaCPQ_Product_Discount_Category__c = 'Standard'
   ); 
   prods.add(prod1);
	
   Product2 prod2 = new product2(
	  Name = 'Maintenance Year1', 
	  ProductCode = 'MT001', 
	  Business_Group__c = 'MN', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'
			
   ); 
   prods.add(prod2);
   
   Product2 prod3 = new product2(
	  Name = 'SRS', 
	  ProductCode = 'SRS001', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'  
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'   
   ); 
   prods.add(prod3);
   
   Product2 prod4 = new product2(
	  Name = 'SSP', 
	  ProductCode = 'SSP002', 
	  CurrencyIsoCode = 'USD',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'   
   ); 
   prods.add(prod4);
   
   Product2 prod5 = new product2(
	  Name = 'Maintenance Year2+', 
	  ProductCode = 'MT002',  
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c ='NFM-P IPR',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
   ); 
   prods.add(prod5);
	 
   Product2 prod6 = new product2(
	  Name = 'prod6', 
	  ProductCode = 'P6', 
	  CurrencyIsoCode = 'USD',
	Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone' 
   ); 
   prods.add(prod6);
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
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 100, 
	  Apttus_Config2__ProductId__c = prod1.Id, 
	  Apttus_Config2__ChargeType__c = 'Standard Price'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
   );
   //insert pLI1;
   plistItems.add(pLI1);
	
	Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod2.Id, 
	  Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI2;
	plistItems.add(pLI2);
	
	Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod3.Id, 
	  Apttus_Config2__ChargeType__c = 'SRS'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI1;
	plistItems.add(pLI3);
	
	Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'SSP'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI4);
	
	 Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI5);
	 
	 
	 Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 800, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit' 
	);
	//insert pLI1;
	plistItems.add(pLI6);
	insert plistItems;

	Apttus_Config2__PriceListCategory__c priceListCategorySO 
		= new Apttus_Config2__PriceListCategory__c(Apttus_Config2__HierarchyId__c = categoerySO.id
	, Apttus_Config2__PriceListId__c = priceListSO.id
	, Apttus_Config2__Sequence__c =1);

	Apttus_Config2__ClassificationHierarchy__c chSO 
		= new Apttus_Config2__ClassificationHierarchy__c(Apttus_Config2__HierarchyId__c = categoerySO.id
		, Apttus_Config2__Left__c=1
		, Apttus_Config2__Right__c=2
		, Apttus_Config2__Label__c= 'My Category');
	insert chSO;

	List<Apttus_Config2__ProductClassification__c> productClassificationList = new List<Apttus_Config2__ProductClassification__c>();
	Apttus_Config2__ProductClassification__c productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod1.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 1;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod2.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 2;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	
	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod3.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 3;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod4.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 4;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod5.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 5;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod6.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 6;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	try{
		insert productClassificationList;
	}catch(Exception ex){

	}

	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
	custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
	custSetting.Name = 'Nokia_CallBack1';
	//insert custSetting;
	
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
		/*  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
			opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
			opportunities.get(0).Account_Role__c = 'Alliance Partner';
			insert opportunities.get(0);*/
			opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts1[0].Id;
	insert opportunities;
			
			//create Accreditation
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c=Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Co-Branded',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c=Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Advanced',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
	testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	NokiaCPQ_SSP_Level__c = '',
	NokiaCPQ_SRS_Level__c = '',
	NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
	NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
	NokiaCPQ_No_of_Years__c = '1',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Level__c = 'Yes',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	NokiaCPQ_LEO_Discount__c=false,
	Is_List_Price_Only__c =false,
	NokiaCPQ_Is_cloned__c = false,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
	isCQ__c = false
			
	);
			
			
	insert testProposal;
		}
		

		/*Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
		request.QuoteId = testProposal.Id;
		// Excute the createCart routine
		Apttus_CPQApi.CPQ.CreateCartResponseDO cartResponse = Apttus_CPQApi.CPQWebService.createCart(request);
		*/
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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
	from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:	 ProdConfig.id];//cartResponse.CartID];
			if(lineItem != null && lineItem.size() > 0){
	system.debug('cart lines size...' + lineItem.size());
	system.debug('cart lines...' + lineItem);
	for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
		System.debug('lineItemSO...'+ lineItemSO);
	}
			}else{
	system.debug('cart lines does not exist...');
			}
			
			/*
			Apttus_CPQApi.CPQ.ProductSearchResultDO productResult = Apttus_CPQApi.CPQWebService.getProductsForPriceList(priceListSO.id);
	system.debug('productResult....'+productResult);
			For(Apttus_CPQApi.CPQ.ProductDO catresult : productResult.Products){
	system.debug('price list products....'+ productSO.id + '...' + catresult.Name + '...' + catresult.Prices);
			}
			*/
			//Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
		}catch(Exception ex){
			throw ex;
		}
	}
		 Test.stopTest();
	}  
	 static testMethod void IndirectFBA8() {
	
	Apttus_Config2__ClassificationName__c categoerySO = new Apttus_Config2__ClassificationName__c (Apttus_Config2__Active__c = true
	, Apttus_Config2__Type__c = 'Offering'
	, Apttus_Config2__HierarchyLabel__c = 'Test826');
	insert categoerySO;

	Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
	);
	insert priceListSO;
	
	//Create Product
   List<Product2> prods = new List<Product2>();
   Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		, NokiaCPQ_Product_Discount_Category__c = 'Standard'
   ); 
   prods.add(prod1);
	
   Product2 prod2 = new product2(
	  Name = 'Maintenance Year1', 
	  ProductCode = 'MT001', 
	  Business_Group__c = 'MN', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'
			
   ); 
   prods.add(prod2);
   
   Product2 prod3 = new product2(
	  Name = 'SRS', 
	  ProductCode = 'SRS001', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'  
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'   
   ); 
   prods.add(prod3);
   
   Product2 prod4 = new product2(
	  Name = 'SSP', 
	  ProductCode = 'SSP002', 
	  CurrencyIsoCode = 'USD',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'   
   ); 
   prods.add(prod4);
   
   Product2 prod5 = new product2(
	  Name = 'Maintenance Year2+', 
	  ProductCode = 'MT002',  
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c ='NFM-P IPR',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
   ); 
   prods.add(prod5);
	 
   Product2 prod6 = new product2(
	  Name = 'prod6', 
	  ProductCode = 'P6', 
	  CurrencyIsoCode = 'USD',
	Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone' 
   ); 
   prods.add(prod6);
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
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 100, 
	  Apttus_Config2__ProductId__c = prod1.Id, 
	  Apttus_Config2__ChargeType__c = 'Standard Price'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
   );
   //insert pLI1;
   plistItems.add(pLI1);
	
	Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod2.Id, 
	  Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI2;
	plistItems.add(pLI2);
	
	Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod3.Id, 
	  Apttus_Config2__ChargeType__c = 'SRS'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI1;
	plistItems.add(pLI3);
	
	Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'SSP'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI4);
	
	 Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI5);
	 
	 
	 Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 800, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit' 
	);
	//insert pLI1;
	plistItems.add(pLI6);
	insert plistItems;

	Apttus_Config2__PriceListCategory__c priceListCategorySO 
		= new Apttus_Config2__PriceListCategory__c(Apttus_Config2__HierarchyId__c = categoerySO.id
	, Apttus_Config2__PriceListId__c = priceListSO.id
	, Apttus_Config2__Sequence__c =1);

	Apttus_Config2__ClassificationHierarchy__c chSO 
		= new Apttus_Config2__ClassificationHierarchy__c(Apttus_Config2__HierarchyId__c = categoerySO.id
		, Apttus_Config2__Left__c=1
		, Apttus_Config2__Right__c=2
		, Apttus_Config2__Label__c= 'My Category');
	insert chSO;

	List<Apttus_Config2__ProductClassification__c> productClassificationList = new List<Apttus_Config2__ProductClassification__c>();
	Apttus_Config2__ProductClassification__c productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod1.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 1;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod2.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 2;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	
	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod3.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 3;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod4.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 4;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod5.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 5;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod6.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 6;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	try{
		insert productClassificationList;
	}catch(Exception ex){

	}

	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
	custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
	custSetting.Name = 'Nokia_CallBack1';
	//insert custSetting;
	
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
			accounts1[0].NokiaCPQ_Renewal__c = true;
			accounts1[0].NokiaCPQ_Attachment__c = true;
			accounts1[0].NokiaCPQ_Performance__c = true;
			insert accounts1;
			
			//Create Opportunity
		/*  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
			opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
			opportunities.get(0).Account_Role__c = 'Alliance Partner';
			insert opportunities.get(0); */
			opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts1[0].Id;
	insert opportunities;
			
			//create Accreditation
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c=Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Co-Branded',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c=Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Advanced',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
	testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	NokiaCPQ_SSP_Level__c = '',
	NokiaCPQ_SRS_Level__c = '',
	NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
	NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
	NokiaCPQ_No_of_Years__c = '1',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Level__c = 'Yes',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	NokiaCPQ_LEO_Discount__c=false,
	Is_List_Price_Only__c =false,
	NokiaCPQ_Is_cloned__c = false,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
	isCQ__c = false
			
	);
			
			
	insert testProposal;
		}
		

		/*Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
		request.QuoteId = testProposal.Id;
		// Excute the createCart routine
		Apttus_CPQApi.CPQ.CreateCartResponseDO cartResponse = Apttus_CPQApi.CPQWebService.createCart(request);
		*/
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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
	from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:	 ProdConfig.id];//cartResponse.CartID];
			if(lineItem != null && lineItem.size() > 0){
	system.debug('cart lines size...' + lineItem.size());
	system.debug('cart lines...' + lineItem);
	for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
		System.debug('lineItemSO...'+ lineItemSO);
	}
			}else{
	system.debug('cart lines does not exist...');
			}
			
			/*
			Apttus_CPQApi.CPQ.ProductSearchResultDO productResult = Apttus_CPQApi.CPQWebService.getProductsForPriceList(priceListSO.id);
	system.debug('productResult....'+productResult);
			For(Apttus_CPQApi.CPQ.ProductDO catresult : productResult.Products){
	system.debug('price list products....'+ productSO.id + '...' + catresult.Name + '...' + catresult.Prices);
			}
			*/
			//Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
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

		Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
	Name = 'Commercial Price List', 
	Apttus_Config2__Active__c = True
		);
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

		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
		//insert custSetting;

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
			insert opportunities.get(0); */
			opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts1[0].Id;
	insert opportunities;
			
			//create Accreditation
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c=portFolio,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Co-Branded',
	  // NokiaCPQ_Incoterm__c = 'EXW Ex Works', //DHH
	  // NokiaCPQ_Incoterm_Percentage__c = 10, //DHH
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c=portFolio,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Advanced',
	  // NokiaCPQ_Incoterm_Percentage__c = 10, //DHH
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
			testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	NokiaCPQ_SSP_Level__c = '',
	NokiaCPQ_SRS_Level__c = '',
	NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
	NokiaCPQ_Portfolio__c = portFolio,
	NokiaCPQ_No_of_Years__c = '1',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Level__c = 'Yes',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	NokiaCPQ_LEO_Discount__c=false,
	Is_List_Price_Only__c =false,
	NokiaCPQ_Is_cloned__c = false,
	Maintenance_Y1__c = 10,
	Maintenance_Y2__c = 10,
	SRS__c = 10,
	SSP__c = 10,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
	isCQ__c = false
			);
		
	 // if(isDSCustomer == true){
	// testProposal.Quote_Type__c = 'Direct DS';
	 // }
	 
			insert testProposal;
			//Nokia_PricingCallBack nb = new Nokia_PricingCallBack();
			
			//testProposal.NokiaCPQ_LEO_Discount__c=true;
			//update testProposal;
		}
		
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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

		Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
	Name = 'Commercial Price List', 
	Apttus_Config2__Active__c = True
		);
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

		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
		//insert custSetting;

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
		/*  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
			opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
			opportunities.get(0).Account_Role__c = 'Alliance Partner';
			insert opportunities.get(0);*/
			opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts1[0].Id;
	insert opportunities;
			
			//create Accreditation
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c=portFolio,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Co-Branded',
	  // NokiaCPQ_Incoterm__c = 'EXW Ex Works', //DHH
	  // NokiaCPQ_Incoterm_Percentage__c = 10, //DHH
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c=portFolio,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Advanced',
	  // NokiaCPQ_Incoterm_Percentage__c = 10, //DHH
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
			testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	NokiaCPQ_SSP_Level__c = '',
	NokiaCPQ_SRS_Level__c = '',
	NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
	NokiaCPQ_Portfolio__c = portFolio,
	NokiaCPQ_No_of_Years__c = '1',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Level__c = 'Yes',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	NokiaCPQ_LEO_Discount__c=false,
	Is_List_Price_Only__c =false,
	NokiaCPQ_Is_cloned__c = false,
	Maintenance_Y1__c = 10,
	Maintenance_Y2__c = 10,
	SRS__c = 10,
	SSP__c = 10,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
	isCQ__c = false
			);
		
		
			insert testProposal;
			//Nokia_PricingCallBack nb = new Nokia_PricingCallBack();
			
			//testProposal.NokiaCPQ_LEO_Discount__c=true;
			//update testProposal;
		}
		
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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
		Test.startTest(); 
	
		Shipping_Location__c ship= new Shipping_Location__c();
		ship.Portfolio__c=portFolio;
		ship.Pricing_Cluster__c='NAM Canada';
		ship.Shipping_Location__c='Lewisville, Texas';
		insert ship;
		Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
		
		 list<Apttus_Config2__LineItem__c> LineItemList = new List<Apttus_Config2__LineItem__c>();

		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=prodConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
	 
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = priceListSO.Id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			//Portfolio_from_Quote_Line_Item__c = 'Nokia Software',
			Apttus_Config2__LineType__c = 'Option',
			Apttus_Config2__ProductId__c = productList[0].Id,
			//NokiaCPQ_Category__c = Nokia_CPQ_Constants.NOKIA_ONT,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__PricingStatus__c = 'Pending',   
			Apttus_Config2__AddedBy__c = 'added by code',
			is_Custom_Product__c = true
		);
		 

		//insert LineItem2;
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
		Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
	Name = 'Commercial Price List', 
	Apttus_Config2__Active__c = True
		);
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

		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
		//insert custSetting;

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
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c=portFolio,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Co-Branded',
	  // NokiaCPQ_Incoterm__c = 'EXW Ex Works', //DHH
	  // NokiaCPQ_Incoterm_Percentage__c = 10, //DHH
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c=portFolio,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Advanced',
	  // NokiaCPQ_Incoterm_Percentage__c = 10, //DHH
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
			testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	  // NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	  // NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	  // NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	  // NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	  // NokiaCPQ_SSP_Level__c = '',
	  // NokiaCPQ_SRS_Level__c = '',
	  // NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
	NokiaCPQ_Portfolio__c = 'QTC',
	  // NokiaCPQ_No_of_Years__c = '1',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	  // NokiaCPQ_Maintenance_Level__c = 'No',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	
	
 NokiaCPQ_Existing_IONMaint_Contract__c='',
	NokiaCPQ_LEO_Discount__c=false,
	//Is_List_Price_Only__c =false,
	  // NokiaCPQ_Is_cloned__c = false,
	  // Maintenance_Y1__c = 10,
	  // Maintenance_Y2__c = 10,
	  // SRS__c = 10,
	  // SSP__c = null,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId()
	// isCQ__c = false
			);
		
		
			insert testProposal;
			testProposal.NokiaCPQ_LEO_Discount__c=false ;
			update testProposal;
		}
		
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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
		//RG: Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(addProductRequest);
		Test.startTest(); 
	
		Shipping_Location__c ship= new Shipping_Location__c();
		ship.Portfolio__c=portFolio;
		ship.Pricing_Cluster__c='NAM Canada';
		ship.Shipping_Location__c='Lewisville, Texas';
		insert ship;
		Nokia_CPQ_Constants.PCBBEFOREPRICINGINADJ = 'False';
		
		list<Apttus_Config2__LineItem__c> LineItemList = new List<Apttus_Config2__LineItem__c>();

		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = plistItems[0].id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			//Portfolio_from_Quote_Line_Item__c = 'Nokia Software',
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = productList[0].Id,
	 // Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			//Apttus_Config2__ShipToAccountId__c = accounts1[0].Id,
			Apttus_Config2__PricingStatus__c = 'Pending',   
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		 

		//insert LineItem2;
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

		Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
	Name = 'Commercial Price List', 
	Apttus_Config2__Active__c = True
		);
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

		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
		//insert custSetting;

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
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c=portFolio,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Co-Branded',
	  // NokiaCPQ_Incoterm__c = 'EXW Ex Works', //DHH
	  // NokiaCPQ_Incoterm_Percentage__c = 10, //DHH
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c=portFolio,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Advanced',
	  // NokiaCPQ_Incoterm_Percentage__c = 10, //DHH
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
			testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=false,
	NokiaCPQ_Existing_IONMaint_Contract__c='',
	  // NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	  // NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	  // NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	  // NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	  // NokiaCPQ_SSP_Level__c = '',
	  // NokiaCPQ_SRS_Level__c = '',
	  // NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
	NokiaCPQ_Portfolio__c = 'QTC',
	  // NokiaCPQ_No_of_Years__c = '1',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	  // NokiaCPQ_Maintenance_Level__c = 'No',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	NokiaCPQ_LEO_Discount__c=false,
	//Is_List_Price_Only__c =false,
	  // NokiaCPQ_Is_cloned__c = false,
	  // Maintenance_Y1__c = 10,
	  // Maintenance_Y2__c = 10,
	  // SRS__c = 10,
	  // SSP__c = null,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId()
	// isCQ__c = false
			);
		
		
			insert testProposal;
			testProposal.NokiaCPQ_LEO_Discount__c=false ;
			update testProposal;
		}
		
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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

		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = plistItems[0].id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			//Portfolio_from_Quote_Line_Item__c = 'Nokia Software',
			Apttus_Config2__LineType__c = Nokia_CPQ_Constants.NOKIA_OPTION,
			Apttus_Config2__ProductId__c = productList[0].Id,
	 // Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			//Apttus_Config2__ShipToAccountId__c = accounts1[0].Id,
			Apttus_Config2__PricingStatus__c = 'Pending',   
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		 

		//insert LineItem2;
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

		Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
	Name = 'Commercial Price List', 
	Apttus_Config2__Active__c = True
		);
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

		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
		//insert custSetting;

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
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c=portFolio,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Co-Branded',
	  // NokiaCPQ_Incoterm__c = 'EXW Ex Works', //DHH
	  // NokiaCPQ_Incoterm_Percentage__c = 10, //DHH
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c=portFolio,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Advanced',
	  // NokiaCPQ_Incoterm_Percentage__c = 10, //DHH
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
			testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	  // NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	  // NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	  // NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	  // NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	  // NokiaCPQ_SSP_Level__c = '',
	  // NokiaCPQ_SRS_Level__c = '',
	  // NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
	NokiaCPQ_Portfolio__c = 'QTC',
	  // NokiaCPQ_No_of_Years__c = '1',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	  // NokiaCPQ_Maintenance_Level__c = 'No',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	NokiaCPQ_LEO_Discount__c=false,
	//Is_List_Price_Only__c =false,
	  // NokiaCPQ_Is_cloned__c = false,
	  // Maintenance_Y1__c = 10,
	  // Maintenance_Y2__c = 10,
	  // SRS__c = 10,
	  // SSP__c = null,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId()
	// isCQ__c = false
			);
		
		
			insert testProposal;
			testProposal.NokiaCPQ_LEO_Discount__c=false ;
			update testProposal;
		}
		
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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

		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = plistItems[0].id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			//Portfolio_from_Quote_Line_Item__c = 'Nokia Software',
			Apttus_Config2__LineType__c = Nokia_CPQ_Constants.NOKIA_OPTION,
			Apttus_Config2__ProductId__c = productList[0].Id,
	 // Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Advanced_pricing_done__c = true,
			//Apttus_Config2__ShipToAccountId__c = accounts1[0].Id,
			Apttus_Config2__PricingStatus__c = 'Pending',   
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		 
		
		//insert LineItem2;
		LineItemList.add(LineItem1);
			
	/* Direct_Portfolio_General_Setting__mdt mt = new Direct_Portfolio_General_Setting__mdt(
			Cost_Calculation_In_PCB__c = true,
			Direct_CPQ__c = true
			);
		insert mt;
	*/  
			
		
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
	/*
   static testMethod void Airscalewifisoftware1500() {
Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
custSetting.Name = 'Nokia_CallBack1';
//insert custSetting;

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

Product2 prod1 = new product2(
Name = 'Test1', 
ProductCode = '123',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = Nokia_CPQ_Constants.NOKIA_STANDALONE,
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod1);


Product2 prod8 = new product2(
Name = '12678', 
ProductCode = '12678',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod8); 

insert prods;

//Create PriceList

Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
Name = 'Commercial Price List', 
Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
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



Apttus_Config2__PriceListItem__c pLI8 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod8.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI8);

insert plistItems;

Product_Discount__c disc = new Product_Discount__c ();
disc.Discount__c = 8.00;
disc.Market__c = account.Market__c;
disc.Product_Discount_Category__c = 'NFM-P';
insert disc;

	Test.startTest(); 
//create proposal
Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
NokiaCPQ_Portfolio__c = 'Airscale Wifi',
NokiaCPQ_No_of_Years__c = '1',
NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced',
RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
Apttus_Proposal__Account__c=accLegalEntity.id,
Sold_To_Party__c = accLegalEntity.id,
Is_List_Price_Only__c =false
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
Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__PriceListItemId__c = pLI1.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePrice__c=100,
Apttus_Config2__ListPrice__c = 100,
Apttus_Config2__Quantity__c = 1,
Source__c='',
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__AddedBy__c = 'added by code',
NokiaCPQ_Product_Type__c='Controller'

);
//insert LineItem2;
allLineItems.add(LineItem1);
insert allLineItems;



Nokia_PricingCallBack obj = new Nokia_PricingCallBack();

obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
//Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
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
*/

	static testMethod void Indirect326() {

		IndirectFixedAccess2(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL);
	} 

	static testMethod void IndirectFixedAccessFBA2() {

		IndirectFixedAccess2(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA);
	}

	public static void IndirectFixedAccess2(string portFolio) {

		Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
	Name = 'Commercial Price List', 
	Apttus_Config2__Active__c = True
		);
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

		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
		//insert custSetting;

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
		/*  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
			opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
			opportunities.get(0).Account_Role__c = 'Alliance Partner';
			insert opportunities.get(0);*/
			opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
			opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities[0].End_Customer_LE__c = accounts1[0].Id;
			insert opportunities;
			//create Accreditation
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c=portFolio,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Co-Branded',
	  // NokiaCPQ_Incoterm__c = 'EXW Ex Works', //DHH
	  // NokiaCPQ_Incoterm_Percentage__c = 10, //DHH
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c=portFolio,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Advanced',
	  // NokiaCPQ_Incoterm_Percentage__c = 10, //DHH
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
			testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	NokiaCPQ_SSP_Level__c = '',
	NokiaCPQ_SRS_Level__c = '',
	NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
	NokiaCPQ_Portfolio__c = portFolio,
	NokiaCPQ_No_of_Years__c = '1',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Level__c = 'No',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	NokiaCPQ_LEO_Discount__c=false,
	Is_List_Price_Only__c =false,
	NokiaCPQ_Is_cloned__c = false,
	Maintenance_Y1__c = 10,
	Maintenance_Y2__c = 10,
	SRS__c = 10,
	SSP__c = null,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
	isCQ__c = false
			);
		
		
			insert testProposal;
			testProposal.NokiaCPQ_LEO_Discount__c=false ;
			update testProposal;
		}
		
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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

		Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
	Name = 'Commercial Price List', 
	Apttus_Config2__Active__c = True
		);
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

		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
		//insert custSetting;

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
		/*  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
			opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
			opportunities.get(0).Account_Role__c = 'Alliance Partner';
			insert opportunities.get(0);*/
			opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
			opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities[0].End_Customer_LE__c = accounts1[0].Id;
			insert opportunities;
			
			//create Accreditation
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c=portFolio,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Co-Branded',
	  // NokiaCPQ_Incoterm__c = 'EXW Ex Works', //DHH
	  // NokiaCPQ_Incoterm_Percentage__c = 10, //DHH
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c=portFolio,
			Pricing_Cluster__c='NAM',
			Pricing_Level_Override__c = 'Advanced',
	  // NokiaCPQ_Incoterm_Percentage__c = 10, //DHH
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
			testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	NokiaCPQ_SSP_Level__c = '',
	NokiaCPQ_SRS_Level__c = '',
	NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
	NokiaCPQ_Portfolio__c = portFolio,
	NokiaCPQ_No_of_Years__c = '1',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Level__c = 'No',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	NokiaCPQ_LEO_Discount__c=true,
	Is_List_Price_Only__c =false,
	NokiaCPQ_Is_cloned__c = false,
	Maintenance_Y1__c = 10,
	Maintenance_Y2__c = 10,
	SRS__c = null,
	SSP__c = null,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
	isCQ__c = false
			);
		
		
			insert testProposal;
			testProposal.NokiaCPQ_LEO_Discount__c=true ;
			update testProposal;
		}
		
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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
	/*static testMethod void DirectMethod1471() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
custSetting.Name = 'Nokia_CallBack1';
//insert custSetting;

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

Product2 prod1 = new product2(
Name = 'Test1', 
ProductCode = '123',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Bundle',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod1);

Product2 prod2 = new product2(
Name = 'Maintenance Year1', 
ProductCode = 'MT001', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'IP Routing',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'); 
prods.add(prod2);

Product2 prod3 = new product2(
Name = 'Test2', 
ProductCode = '1234',  
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'
); 
prods.add(prod3);

Product2 prod5 = new product2(
Name = 'Maintenance Year2+', 
ProductCode = 'MT002', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'IP Routing',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone'
); 
prods.add(prod5); 

Product2 prod6 = new product2(
Name = 'Test1Arcadia', 
ProductCode = '123Arcadia',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Bundle',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod6);   

Product2 prod7 = new product2(
Name = 'Test2Arcadia', 
ProductCode = 'Arcadia2',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod7); 


Product2 prod8 = new product2(
Name = '12678', 
ProductCode = '12678',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod8); 

insert prods;

//Create PriceList

Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
Name = 'Commercial Price List', 
Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
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
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
);
//insert pLI2;
plistItems.add(pLI2);

Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod3.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI3);


Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod5.Id, 
Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond'
);
//insert pLI1;
plistItems.add(pLI5);

Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod6.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI6);

Apttus_Config2__PriceListItem__c pLI7 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod7.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI7);

Apttus_Config2__PriceListItem__c pLI8 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod8.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI8);

insert plistItems;


		//create proposal
		Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Portfolio__c = 'Airscale Wifi',
		NokiaCPQ_No_of_Years__c = '1',
		NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced Emergency',
		RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
		Apttus_Proposal__Account__c=accLegalEntity.id,
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		NokiaCPQ_Existing_IONMaint_Contract__c='No',
		Sold_To_Party__c = accLegalEntity.id,
		Is_List_Price_Only__c =false
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
Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__PriceListItemId__c = pLI1.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePrice__c=100,
Apttus_Config2__ListPrice__c = 100,
Apttus_Config2__Quantity__c = 1,
Source__c='',
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__AddedBy__c = 'added by code',
NokiaCPQ_Unitary_IRP__c = 300,
NokiaCPQ_Product_Type__c='Controller'

);
//insert LineItem2;
allLineItems.add(LineItem1);

Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 2,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod6.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
Apttus_Config2__PriceListItemId__c = pLI6.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 2,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Product_Type__c = 'Access Point',  
Apttus_Config2__AddedBy__c = 'added by code',
Apttus_Config2__AdjustmentType__c = '% Discount',
NokiaCPQ_Unitary_IRP__c = 1300,
Apttus_Config2__AdjustmentAmount__c = 10
);
//insert LineItem1;
allLineItems.add(LineItem3);

Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 3,
Apttus_Config2__LineNumber__c = 2,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Year 1 Maintenance', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod2.Id,
Apttus_Config2__PriceListItemId__c = pLI2.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
Apttus_Config2__ListPrice__c = 120,
Apttus_Config2__BasePrice__c=120,
Apttus_Config2__Quantity__c = 1,
Apttus_Config2__PriceIncludedInBundle__c = true,
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
NokiaCPQ_Unitary_IRP__c = 400,
Apttus_Config2__AddedBy__c = 'added by code'	 
);
//insert LineItem1;
allLineItems.add(LineItem4);

Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 4,
Apttus_Config2__LineNumber__c = 3,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod5.Id,
Apttus_Config2__PriceListItemId__c = pLI5.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
Apttus_Config2__ListPrice__c = 120,
Apttus_Config2__BasePrice__c=120,
Apttus_Config2__Quantity__c = 1,
Apttus_Config2__PriceIncludedInBundle__c = true,
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
NokiaCPQ_Unitary_IRP__c = 300,
Apttus_Config2__AddedBy__c = 'added by code'	 
);
//insert LineItem1;
allLineItems.add(LineItem5);

Apttus_Config2__LineItem__c LineItem6 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 5,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod6.Id,
Apttus_Config2__OptionId__c = prod3.Id,
Apttus_Config2__ParentBundleNumber__c = 2,
Apttus_Config2__PriceListItemId__c = pLI3.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 3,
NokiaCPQ_Unitary_IRP__c = 300,
Apttus_Config2__ShipToAccountId__c = account.Id,


Apttus_Config2__AddedBy__c = 'added by code'
);
//insert LineItem1;
allLineItems.add(LineItem6);

Apttus_Config2__LineItem__c LineItem7 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 6,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod7.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
Apttus_Config2__PriceListItemId__c = pLI7.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 2,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Product_Type__c = 'Controller',			
Apttus_Config2__AddedBy__c = 'added by code',
NokiaCPQ_Unitary_IRP__c = 100,
Apttus_Config2__AdjustmentType__c = 'Discount Amount',
Apttus_Config2__AdjustmentAmount__c = 100
);
//insert LineItem1;
allLineItems.add(LineItem7);

Apttus_Config2__LineItem__c LineItem8 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 2,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod6.Id,
Apttus_Config2__OptionId__c = prod8.Id,
Apttus_Config2__ParentBundleNumber__c = 2,
Apttus_Config2__PriceListItemId__c = pLI8.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 3,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Unitary_IRP__c = 600,
NokiaCPQ_Product_Type__c = 'Third Party Wavespot',  

Apttus_Config2__AddedBy__c = 'added by code'
);
allLineItems.add(LineItem8);

insert allLineItems;


Test.startTest(); 

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

}
Test.stopTest();
}*/
/*  static testMethod void DirectMethod1528() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
custSetting.Name = 'Nokia_CallBack1';
//insert custSetting;

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

Product2 prod1 = new product2(
Name = 'Test1', 
ProductCode = '123',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Bundle',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod1);

Product2 prod2 = new product2(
Name = 'Maintenance Year1', 
ProductCode = 'MT001', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'IP Routing',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'); 
prods.add(prod2);

Product2 prod3 = new product2(
Name = 'Test2', 
ProductCode = '1234',  
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'
); 
prods.add(prod3);

Product2 prod5 = new product2(
Name = 'Maintenance Year2+', 
ProductCode = 'MT002', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'IP Routing',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone'
); 
prods.add(prod5); 

Product2 prod6 = new product2(
Name = 'Test1Arcadia', 
ProductCode = '123Arcadia',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Bundle',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod6);   

Product2 prod7 = new product2(
Name = 'Test2Arcadia', 
ProductCode = 'Arcadia2',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod7); 


Product2 prod8 = new product2(
Name = '12678', 
ProductCode = '12678',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod8); 

insert prods;

//Create PriceList

Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
Name = 'Commercial Price List', 
Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
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
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
);
//insert pLI2;
plistItems.add(pLI2);

Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod3.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI3);


Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod5.Id, 
Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond'
);
//insert pLI1;
plistItems.add(pLI5);

Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod6.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI6);

Apttus_Config2__PriceListItem__c pLI7 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod7.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI7);

Apttus_Config2__PriceListItem__c pLI8 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod8.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI8);

insert plistItems;


	//create proposal
	Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Portfolio__c = 'Airscale Wifi',
	NokiaCPQ_No_of_Years__c = '2',
	NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced Emergency',
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
	Apttus_Proposal__Account__c=accLegalEntity.id,
	NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		NokiaCPQ_Existing_IONMaint_Contract__c='No',
	Sold_To_Party__c = accLegalEntity.id,
	Is_List_Price_Only__c =false
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
Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__PriceListItemId__c = pLI1.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePrice__c=100,
Apttus_Config2__ListPrice__c = 100,
Apttus_Config2__Quantity__c = 1,
Source__c='',
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__AddedBy__c = 'added by code',
NokiaCPQ_Unitary_IRP__c = 300,
NokiaCPQ_Product_Type__c='Controller',
NokiaCPQ_Spare__c = true

);
//insert LineItem2;
allLineItems.add(LineItem1);


insert allLineItems;


Test.startTest(); 

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

}
Test.stopTest();
}*/

  /* static testMethod void DirectMethod1502() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
custSetting.Name = 'Nokia_CallBack1';
//insert custSetting;

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

Product2 prod1 = new product2(
Name = 'Test1', 
ProductCode = '123',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Bundle',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod1);

Product2 prod2 = new product2(
Name = 'Maintenance Year1', 
ProductCode = 'MT001', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'IP Routing',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'); 
prods.add(prod2);

Product2 prod3 = new product2(
Name = 'Test2', 
ProductCode = '1234',  
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'
); 
prods.add(prod3);

Product2 prod5 = new product2(
Name = 'Maintenance Year2+', 
ProductCode = 'MT002', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'IP Routing',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone'
); 
prods.add(prod5); 

Product2 prod6 = new product2(
Name = 'Test1Arcadia', 
ProductCode = '123Arcadia',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Bundle',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod6);   

Product2 prod7 = new product2(
Name = 'Test2Arcadia', 
ProductCode = 'Arcadia2',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod7); 


Product2 prod8 = new product2(
Name = '12678', 
ProductCode = '12678',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod8); 

insert prods;

//Create PriceList

Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
Name = 'Commercial Price List', 
Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
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
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
);
//insert pLI2;
plistItems.add(pLI2);

Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod3.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI3);


Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod5.Id, 
Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond'
);
//insert pLI1;
plistItems.add(pLI5);

Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod6.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI6);

Apttus_Config2__PriceListItem__c pLI7 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod7.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI7);

Apttus_Config2__PriceListItem__c pLI8 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod8.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI8);

insert plistItems;


	//create proposal
	Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Portfolio__c = 'Airscale Wifi',
	NokiaCPQ_No_of_Years__c = '2',
	NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced Emergency',
	//NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),
	NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,//direct Prices_Aligned__c=true,
	Apttus_Proposal__Account__c=accLegalEntity.id,
		NokiaCPQ_Existing_IONMaint_Contract__c='No',
	Sold_To_Party__c = accLegalEntity.id,
	Is_List_Price_Only__c =false
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
Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__PriceListItemId__c = pLI1.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePrice__c=100,
Apttus_Config2__ListPrice__c = 100,
Apttus_Config2__Quantity__c = 1,
Source__c='',
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__AddedBy__c = 'added by code',
NokiaCPQ_Unitary_IRP__c = 300,
NokiaCPQ_Product_Type__c='Controller'

);
//insert LineItem2;
allLineItems.add(LineItem1);

Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 2,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod6.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
Apttus_Config2__PriceListItemId__c = pLI6.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 2,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Product_Type__c = 'Access Point',  
Apttus_Config2__AddedBy__c = 'added by code',
Apttus_Config2__AdjustmentType__c = '% Discount',
NokiaCPQ_Unitary_IRP__c = 1300,
Apttus_Config2__AdjustmentAmount__c = 10
);
//insert LineItem1;
allLineItems.add(LineItem3);

Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 3,
Apttus_Config2__LineNumber__c = 2,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Year 1 Maintenance', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod2.Id,
Apttus_Config2__PriceListItemId__c = pLI2.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
Apttus_Config2__ListPrice__c = 120,
Apttus_Config2__BasePrice__c=120,
Apttus_Config2__Quantity__c = 1,
Apttus_Config2__PriceIncludedInBundle__c = true,
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
NokiaCPQ_Unitary_IRP__c = 400,
Apttus_Config2__AddedBy__c = 'added by code'	 
);
//insert LineItem1;
allLineItems.add(LineItem4);

Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 4,
Apttus_Config2__LineNumber__c = 3,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod5.Id,
Apttus_Config2__PriceListItemId__c = pLI5.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
Apttus_Config2__ListPrice__c = 120,
Apttus_Config2__BasePrice__c=120,
Apttus_Config2__Quantity__c = 1,
Apttus_Config2__PriceIncludedInBundle__c = true,
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
NokiaCPQ_Unitary_IRP__c = 300,
Apttus_Config2__AddedBy__c = 'added by code'	 
);
//insert LineItem1;
allLineItems.add(LineItem5);

Apttus_Config2__LineItem__c LineItem6 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 5,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod6.Id,
Apttus_Config2__OptionId__c = prod3.Id,
Apttus_Config2__ParentBundleNumber__c = 2,
Apttus_Config2__PriceListItemId__c = pLI3.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 3,
NokiaCPQ_Unitary_IRP__c = 300,
Apttus_Config2__ShipToAccountId__c = account.Id,


Apttus_Config2__AddedBy__c = 'added by code'
);
//insert LineItem1;
allLineItems.add(LineItem6);

Apttus_Config2__LineItem__c LineItem7 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 6,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod7.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
Apttus_Config2__PriceListItemId__c = pLI7.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 2,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Product_Type__c = 'Controller',			
Apttus_Config2__AddedBy__c = 'added by code',
NokiaCPQ_Unitary_IRP__c = 100,
Apttus_Config2__AdjustmentType__c = 'Discount Amount',
Apttus_Config2__AdjustmentAmount__c = 100
);
//insert LineItem1;
allLineItems.add(LineItem7);

Apttus_Config2__LineItem__c LineItem8 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 2,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod6.Id,
Apttus_Config2__OptionId__c = prod8.Id,
Apttus_Config2__ParentBundleNumber__c = 2,
Apttus_Config2__PriceListItemId__c = pLI8.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 3,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Unitary_IRP__c = 600,
NokiaCPQ_Product_Type__c = 'Third Party Wavespot',  

Apttus_Config2__AddedBy__c = 'added by code'
);
allLineItems.add(LineItem8);

insert allLineItems;


Test.startTest(); 

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

}
Test.stopTest();
}*/

/*static testMethod void DirectMethod1483() {
	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
custSetting.Name = 'Nokia_CallBack1';
//insert custSetting;

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

Product2 prod1 = new product2(
Name = 'Test1', 
ProductCode = '123',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Bundle',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod1);

Product2 prod2 = new product2(
Name = 'Maintenance Year1', 
ProductCode = 'MT001', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'IP Routing',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'); 
prods.add(prod2);

Product2 prod3 = new product2(
Name = 'Test2', 
ProductCode = '1234',  
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base'
); 
prods.add(prod3);

Product2 prod5 = new product2(
Name = 'Maintenance Year2+', 
ProductCode = 'MT002', 
CurrencyIsoCode = 'USD',
Portfolio__c = 'IP Routing',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone'
); 
prods.add(prod5); 

Product2 prod6 = new product2(
Name = 'Test1Arcadia', 
ProductCode = '123Arcadia',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Bundle',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod6);   

Product2 prod7 = new product2(
Name = 'Test2Arcadia', 
ProductCode = 'Arcadia2',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod7); 


Product2 prod8 = new product2(
Name = '12678', 
ProductCode = '12678',
CurrencyIsoCode = 'USD',
Portfolio__c = 'Airscale Wifi',
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Hardware',
NokiaCPQ_Classification2__c='Base'   
); 
prods.add(prod8); 

insert prods;

//Create PriceList

Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
Name = 'Commercial Price List', 
Apttus_Config2__Active__c = True, PriceList_Type__c = 'CPQ'
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
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
);
//insert pLI2;
plistItems.add(pLI2);

Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod3.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI3);


Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod5.Id, 
Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond'
);
//insert pLI1;
plistItems.add(pLI5);

Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod6.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI6);

Apttus_Config2__PriceListItem__c pLI7 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod7.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI7);

Apttus_Config2__PriceListItem__c pLI8 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod8.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__PriceIncludedInBundle__c = false,
Apttus_Config2__ContractPrice__c = 100
);
//insert pLI1;
plistItems.add(pLI8);

insert plistItems;


	//create proposal
	Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Portfolio__c = 'Airscale Wifi',
	NokiaCPQ_No_of_Years__c = '5',
	NokiaCPQ_Maintenance_Type__c='MN GS TSS Enhanced Emergency',
	//NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
	Apttus_Proposal__Account__c=accLegalEntity.id,
	NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		NokiaCPQ_Existing_IONMaint_Contract__c='No',
	Sold_To_Party__c = accLegalEntity.id,
	Is_List_Price_Only__c =false
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
Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 1,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__PriceListItemId__c = pLI1.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePrice__c=100,
Apttus_Config2__ListPrice__c = 100,
Apttus_Config2__Quantity__c = 1,
Source__c='',
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__AddedBy__c = 'added by code',
NokiaCPQ_Unitary_IRP__c = 300,
NokiaCPQ_Product_Type__c='Controller'

);
//insert LineItem2;
allLineItems.add(LineItem1);

Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 2,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod6.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
Apttus_Config2__PriceListItemId__c = pLI6.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 2,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Product_Type__c = 'Access Point',  
Apttus_Config2__AddedBy__c = 'added by code',
Apttus_Config2__AdjustmentType__c = '% Discount',
NokiaCPQ_Unitary_IRP__c = 1300,
Apttus_Config2__AdjustmentAmount__c = 10
);
//insert LineItem1;
allLineItems.add(LineItem3);

Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 3,
Apttus_Config2__LineNumber__c = 2,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Year 1 Maintenance', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod2.Id,
Apttus_Config2__PriceListItemId__c = pLI2.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
Apttus_Config2__ListPrice__c = 120,
Apttus_Config2__BasePrice__c=120,
Apttus_Config2__Quantity__c = 1,
Apttus_Config2__PriceIncludedInBundle__c = true,
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
NokiaCPQ_Unitary_IRP__c = 400,
Apttus_Config2__AddedBy__c = 'added by code'	 
);
//insert LineItem1;
allLineItems.add(LineItem4);

Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 4,
Apttus_Config2__LineNumber__c = 3,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
Apttus_Config2__ChargeType__c = 'Maintenance for Y2 & Beyond', 
Apttus_Config2__LineType__c = 'Product/Service',
Apttus_Config2__ProductId__c = prod5.Id,
Apttus_Config2__PriceListItemId__c = pLI5.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
Apttus_Config2__ListPrice__c = 120,
Apttus_Config2__BasePrice__c=120,
Apttus_Config2__Quantity__c = 1,
Apttus_Config2__PriceIncludedInBundle__c = true,
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
is_Custom_Product__c=false,
Apttus_Config2__BasePriceOverride__c=120,
NokiaCPQ_Unitary_IRP__c = 300,
Apttus_Config2__AddedBy__c = 'added by code'	 
);
//insert LineItem1;
allLineItems.add(LineItem5);

Apttus_Config2__LineItem__c LineItem6 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 5,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod6.Id,
Apttus_Config2__OptionId__c = prod3.Id,
Apttus_Config2__ParentBundleNumber__c = 2,
Apttus_Config2__PriceListItemId__c = pLI3.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 3,
NokiaCPQ_Unitary_IRP__c = 300,
Apttus_Config2__ShipToAccountId__c = account.Id,


Apttus_Config2__AddedBy__c = 'added by code'
);
//insert LineItem1;
allLineItems.add(LineItem6);

Apttus_Config2__LineItem__c LineItem7 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 6,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod7.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
Apttus_Config2__PriceListItemId__c = pLI7.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 2,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Product_Type__c = 'Controller',			
Apttus_Config2__AddedBy__c = 'added by code',
NokiaCPQ_Unitary_IRP__c = 100,
Apttus_Config2__AdjustmentType__c = 'Discount Amount',
Apttus_Config2__AdjustmentAmount__c = 100
);
//insert LineItem1;
allLineItems.add(LineItem7);

Apttus_Config2__LineItem__c LineItem8 =new Apttus_Config2__LineItem__c(
Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
Apttus_Config2__ItemSequence__c = 2,
Apttus_Config2__LineNumber__c = 1,
Apttus_Config2__LineStatus__c='New',
Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
//Apttus_Config2__ChargeType__c = 'Standard Type',
Apttus_Config2__ChargeType__c = 'Standard Price', 
Apttus_Config2__LineType__c = 'Option',
Apttus_Config2__ProductId__c = prod6.Id,
Apttus_Config2__OptionId__c = prod8.Id,
Apttus_Config2__ParentBundleNumber__c = 2,
Apttus_Config2__PriceListItemId__c = pLI8.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePriceOverride__c=120,
Apttus_Config2__ListPrice__c = 300,
Apttus_Config2__BasePrice__c=300,
Apttus_Config2__Quantity__c = 1,
is_Custom_Product__c=false,
Apttus_Config2__PrimaryLineNumber__c = 3,
Apttus_Config2__ShipToAccountId__c = account.Id,
NokiaCPQ_Unitary_IRP__c = 600,
NokiaCPQ_Product_Type__c = 'Third Party Wavespot',  

Apttus_Config2__AddedBy__c = 'added by code'
);
allLineItems.add(LineItem8);

insert allLineItems;


Test.startTest(); 

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

}
Test.stopTest();
}*/
static testMethod void QTCmethod2() {


List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();

insert account3;

List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();

insert opportunities1;

/*create product*/
product2 prod = new product2();
prod.name = '5G';
prod.CurrencyIsoCode = 'EUR';
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
product2 prod1 = new product2();
prod1.name = '5G';
prod1.CurrencyIsoCode = 'EUR';
prod1.Business_Group__c='MN';
prod1.Family= 'A&A-CEM';
prod1.IsActive=True;
prod1.Partner_Visible__c=True;
prod1.ProductCode='FC11012';
prod1.Apttus_Config2__Version__c=1;
prod1.Portfolio__c='Airscale Wifi';
prod1.Created_by_PMDI__c = False;
prod1.Pricing_Clusters__c='NAM';
prod1.IsActive= True;
insert prod1;
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
Apttus_Config2__ChargeType__c = 'Standard Price',
	Apttus_Config2__Cost__c = 10 //DHH
);
insert pLI5;
/*create pricelist Item*/
Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod1.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
	Apttus_Config2__Cost__c = 10 //DHH
);
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
Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(
RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),
Apttus_Proposal__Account__c = account3[0].Id,
Apttus_Proposal__Opportunity__c = opportunities1.get(0).Id,
Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
NokiaCPQ_FN_Maintenance_Type__c='',
NokiaCPQ_SRS_Level__c='',
CurrencyIsoCode = 'EUR',
NokiaCPQ_Existing_IONMaint_Contract__c='',
NokiaCPQ_Needs_Reprice__c = false,
//NokiaCPQ_Environment_Access_Type__c = 'PRM',
Reprice_In_Progress__c = false,
NokiaCPQ_Existing_FN_Maint_Contract__c='',
NokiaCPQ_No_of_Years__c = '',
NokiaCPQ_ION_Maintenance_Type__c='',
NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
NokiaCPQ_SSP_Level__c='',
NokiaCPQ_Portfolio__c = 'QTC',
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
Apttus_Config2__ProductId__c = prod.Id,
CPQ_Market_Model__c=null,
NokiaCPQ_Floor_Price__c = 100,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
is_Custom_Product__c=false,
NokiaCPQ_Custom_Bid__c =true,
Apttus_Config2__ListPrice__c = 300,
Advanced_pricing_done__c = true,//DHH
NokiaCPQ_Unitary_Cost__c = 10, //DHH
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__Quantity__c = 10,
Apttus_Config2__NetPrice__c=100,


Apttus_Config2__AddedBy__c = 'added by code'
);
	allLineItems.add(LineItem3);
 
Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
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
CPQ_Market_Model__c=null,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
is_Custom_Product__c=false,
NokiaCPQ_Floor_Price__c = 10,
Apttus_Config2__ListPrice__c = 300,
Advanced_pricing_done__c = true,//DHH
NokiaCPQ_Unitary_Cost__c = 100, //DHH
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__Quantity__c = 1,
Apttus_Config2__NetPrice__c=10000,


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
Apttus_Config2__ProductId__c = prod1.Id,
CPQ_Market_Model__c=null,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
is_Custom_Product__c=false,
NokiaCPQ_Floor_Price__c = 100,
Apttus_Config2__ListPrice__c = 3000,
Advanced_pricing_done__c = true,//DHH
NokiaCPQ_Unitary_Cost__c = 1000, //DHH
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__Quantity__c = 1,
Apttus_Config2__NetPrice__c=1000,


Apttus_Config2__AddedBy__c = 'added by code'
);
//insert LineItem1;
allLineItems.add(LineItem5);
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
CPQ_Market_Model__c=null,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
is_Custom_Product__c=false,
NokiaCPQ_Floor_Price__c = 100,
NokiaCPQ_Custom_Bid__c = true,
Apttus_Config2__ListPrice__c = 300,
Advanced_pricing_done__c = true,//DHH
NokiaCPQ_Unitary_Cost__c = 10, //DHH
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__Quantity__c = 5,
Apttus_Config2__NetPrice__c=1000,


Apttus_Config2__AddedBy__c = 'added by code'
);
//insert LineItem1;
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
is_Custom_Product__c=false,
NokiaCPQ_Custom_Bid__c =true,
Apttus_Config2__ListPrice__c = 300,
Advanced_pricing_done__c = true,//DHH
NokiaCPQ_Unitary_Cost__c = 10, //DHH
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__Quantity__c = 10,
Apttus_Config2__NetPrice__c=100,


Apttus_Config2__AddedBy__c = 'added by code'
);
//insert LineItem1;
allLineItems.add(LineItem2);

insert allLineItems;

Nokia_PricingCallBack obj = new Nokia_PricingCallBack();

obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);

obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);

Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
test.stopTest(); 
}

static testMethod void directEnterprise_coverage() {
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
NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
NokiaCPQ_Portfolio__c = 'IP Routing',
NokiaCPQ_No_of_Years__c = '3',
NokiaCPQ_Maintenance_Type__c='Gold (Return for Exchange)',
RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
//NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
Apttus_Proposal__Account__c=accLegalEntity.id,
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
Total_option_Quantity__c = 1,
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
Total_option_Quantity__c =1,
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
Total_option_Quantity__c = 1,
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
Total_option_Quantity__c = 1,
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
Total_option_Quantity__c = 1,
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
Total_option_Quantity__c = 1,
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
Total_option_Quantity__c = 1,
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
Total_option_Quantity__c = 1,
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
Total_option_Quantity__c = 1,
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

Test.startTest(); 

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
}
Test.stopTest();


}
 
static testMethod void directEnterprise_trafficlight() {
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

Test.startTest(); 

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
}
Test.stopTest();


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
		Apttus_Config2__ClassificationName__c categoerySO 
			= new Apttus_Config2__ClassificationName__c (Apttus_Config2__Active__c = true
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
	 //added by monika
 static testMethod void IndirectMPW() {
	
	Apttus_Config2__ClassificationName__c categoerySO = new Apttus_Config2__ClassificationName__c (Apttus_Config2__Active__c = true
	, Apttus_Config2__Type__c = 'Offering'
	, Apttus_Config2__HierarchyLabel__c = 'Test826');
	insert categoerySO;

	Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
	);
	insert priceListSO;
	
	//Create Product
   List<Product2> prods = new List<Product2>();
   Product2 prod1 = new product2(
		Name = 'Modular Private Wireless Network Solution', 
		ProductCode = 'MPW', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Bundle'
		
   ); 
   prods.add(prod1);
	
   Product2 prod2 = new product2(
	  Name = 'Maintenance Year1', 
	  ProductCode = 'MT001', 
	  Business_Group__c = 'MN', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
	  
			
   ); 
   prods.add(prod2);
   
   Product2 prod3 = new product2(
	  Name = 'SRS', 
	  ProductCode = 'SRS001', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'  
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'   
   ); 
   prods.add(prod3);
   
   Product2 prod4 = new product2(
	  Name = 'SSP', 
	  ProductCode = 'SSP002', 
	  CurrencyIsoCode = 'USD',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'   
   ); 
   prods.add(prod4);
   
   Product2 prod5 = new product2(
	  Name = 'Maintenance Year2+', 
	  ProductCode = 'MT002',  
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
   ); 
   prods.add(prod5);
	 
   Product2 prod6 = new product2(
	  Name = 'FWEA B3 (1800 MHz)',  
	  ProductCode = 'RANFWEAB3', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = Nokia_CPQ_Constants.MPW_RADIO,
	  Apttus_Config2__ConfigurationType__c = 'Standalone' 
   ); 
   prods.add(prod6);
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
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 100, 
	  Apttus_Config2__ProductId__c = prod1.Id, 
	  Apttus_Config2__ChargeType__c = 'Standard Price'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
   );
   //insert pLI1;
   plistItems.add(pLI1);
	
	Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod2.Id, 
	  Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI2;
	plistItems.add(pLI2);
	
	Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod3.Id, 
	  Apttus_Config2__ChargeType__c = 'SRS'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI1;
	plistItems.add(pLI3);
	
	Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'SSP'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI4);
	
	 Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI5);
	 
	 
	 Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 800, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit' 
	);
	//insert pLI1;
	plistItems.add(pLI6);
	insert plistItems;

	Apttus_Config2__PriceListCategory__c priceListCategorySO 
		= new Apttus_Config2__PriceListCategory__c(Apttus_Config2__HierarchyId__c = categoerySO.id
	, Apttus_Config2__PriceListId__c = priceListSO.id
	, Apttus_Config2__Sequence__c =1);

	Apttus_Config2__ClassificationHierarchy__c chSO 
		= new Apttus_Config2__ClassificationHierarchy__c(Apttus_Config2__HierarchyId__c = categoerySO.id
		, Apttus_Config2__Left__c=1
		, Apttus_Config2__Right__c=2
		, Apttus_Config2__Label__c= 'My Category');
	insert chSO;

	List<Apttus_Config2__ProductClassification__c> productClassificationList = new List<Apttus_Config2__ProductClassification__c>();
	Apttus_Config2__ProductClassification__c productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod1.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 1;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod2.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 2;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	
	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod3.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 3;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod4.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 4;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod5.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 5;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod6.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 6;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	try{
		insert productClassificationList;
	}catch(Exception ex){

	}

	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
	custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
	custSetting.Name = 'Nokia_CallBack1';
	//insert custSetting;
	
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
		/*  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
			opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
			opportunities.get(0).Account_Role__c = 'Alliance Partner';
			insert opportunities.get(0); */
	opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
			opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities[0].End_Customer_LE__c = accounts1[0].Id;
			insert opportunities;
			
			//create Accreditation
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c=Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
			Pricing_Cluster__c='MPW Cluster 2',

			Pricing_Level_Override__c = 'Nokia Brand of Service',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c=Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
			Pricing_Cluster__c='MPW Cluster 2',
			Pricing_Level_Override__c = 'Advanced',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
	testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	NokiaCPQ_SSP_Level__c = '',
	NokiaCPQ_SRS_Level__c = '',
	NokiaCPQ_Maintenance_Type__c = 'Solution Support',
	NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	NokiaCPQ_No_of_Years__c = '3',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Level__c = 'Yes',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	NokiaCPQ_LEO_Discount__c=false,
	Is_List_Price_Only__c =false,
	NokiaCPQ_Is_cloned__c = false,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
	isCQ__c = false);	
	insert testProposal;
		}
		

		/*Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
		request.QuoteId = testProposal.Id;
		// Excute the createCart routine
		Apttus_CPQApi.CPQ.CreateCartResponseDO cartResponse = Apttus_CPQApi.CPQWebService.createCart(request);
		*/
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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
	from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:	 ProdConfig.id];//cartResponse.CartID];
			if(lineItem != null && lineItem.size() > 0){
	system.debug('cart lines size...' + lineItem.size());
	system.debug('cart lines...' + lineItem);
	for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
		System.debug('lineItemSO...'+ lineItemSO);
	}
			}else{
	system.debug('cart lines does not exist...');
			}
			
			/*
			Apttus_CPQApi.CPQ.ProductSearchResultDO productResult = Apttus_CPQApi.CPQWebService.getProductsForPriceList(priceListSO.id);
	system.debug('productResult....'+productResult);
			For(Apttus_CPQApi.CPQ.ProductDO catresult : productResult.Products){
	system.debug('price list products....'+ productSO.id + '...' + catresult.Name + '...' + catresult.Prices);
			}
			*/
			//Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
		}catch(Exception ex){
			throw ex;
		}
	}
		 Test.stopTest();
	}  
	
	//end monika
	
	//added by monika for EURR CurrencyIsoCode
 static testMethod void IndirectMPWEURR() {
	Apttus_Config2__ClassificationName__c categoerySO = new Apttus_Config2__ClassificationName__c (Apttus_Config2__Active__c = true
	, Apttus_Config2__Type__c = 'Offering'
	, Apttus_Config2__HierarchyLabel__c = 'Test826');
	insert categoerySO;

	Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
	);
	insert priceListSO;
	
	//Create Product
   List<Product2> prods = new List<Product2>();
   Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		, NokiaCPQ_Product_Discount_Category__c = 'Standard'
   ); 
   prods.add(prod1);
	
   Product2 prod2 = new product2(
	  Name = 'Maintenance Year1', 
	  ProductCode = 'MT001', 
	  Business_Group__c = 'MN', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'
			
   ); 
   prods.add(prod2);
   
   Product2 prod3 = new product2(
	  Name = 'SRS', 
	  ProductCode = 'SRS001', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'  
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'   
   ); 
   prods.add(prod3);
   
   Product2 prod4 = new product2(
	  Name = 'SSP', 
	  ProductCode = 'SSP002', 
	  CurrencyIsoCode = 'USD',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'   
   ); 
   prods.add(prod4);
   
   Product2 prod5 = new product2(
	  Name = 'Maintenance Year2+', 
	  ProductCode = 'MT002',  
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c ='NFM-P IPR',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
   ); 
   prods.add(prod5);
	 
   Product2 prod6 = new product2(
	  Name = 'prod6', 
	  ProductCode = 'P6', 
	  CurrencyIsoCode = 'USD',
	Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone' 
   ); 
   prods.add(prod6);
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
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 100, 
	  Apttus_Config2__ProductId__c = prod1.Id, 
	  Apttus_Config2__ChargeType__c = 'Standard Price'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
   );
   //insert pLI1;
   plistItems.add(pLI1);
	
	Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod2.Id, 
	  Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI2;
	plistItems.add(pLI2);
	
	Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod3.Id, 
	  Apttus_Config2__ChargeType__c = 'SRS'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI1;
	plistItems.add(pLI3);
	
	Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'SSP'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI4);
	
	 Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI5);
	 
	 
	 Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 800, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit' 
	);
	//insert pLI1;
	plistItems.add(pLI6);
	insert plistItems;

	Apttus_Config2__PriceListCategory__c priceListCategorySO 
		= new Apttus_Config2__PriceListCategory__c(Apttus_Config2__HierarchyId__c = categoerySO.id
	, Apttus_Config2__PriceListId__c = priceListSO.id
	, Apttus_Config2__Sequence__c =1);

	Apttus_Config2__ClassificationHierarchy__c chSO 
		= new Apttus_Config2__ClassificationHierarchy__c(Apttus_Config2__HierarchyId__c = categoerySO.id
		, Apttus_Config2__Left__c=1
		, Apttus_Config2__Right__c=2
		, Apttus_Config2__Label__c= 'My Category');
	insert chSO;

	List<Apttus_Config2__ProductClassification__c> productClassificationList = new List<Apttus_Config2__ProductClassification__c>();
	Apttus_Config2__ProductClassification__c productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod1.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 1;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod2.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 2;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	
	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod3.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 3;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod4.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 4;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod5.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 5;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod6.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 6;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	try{
		insert productClassificationList;
	}catch(Exception ex){

	}

	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
	custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
	custSetting.Name = 'Nokia_CallBack1';
	//insert custSetting;
	
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
		/*  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
			opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
			opportunities.get(0).Account_Role__c = 'Alliance Partner';
			insert opportunities.get(0);*/
			opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
			opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities[0].End_Customer_LE__c = accounts1[0].Id;
			insert opportunities;
			
			//create Accreditation
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c=Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
			Pricing_Cluster__c='MPW Cluster 2',
			Pricing_Level_Override__c = 'Co-Branded',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c=Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
			Pricing_Cluster__c='MPW Cluster 2',
			Pricing_Level_Override__c = 'Advanced',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
	testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	NokiaCPQ_SSP_Level__c = '',
	NokiaCPQ_SRS_Level__c = '',
	NokiaCPQ_Maintenance_Type__c = 'Solution Support',
	NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	NokiaCPQ_No_of_Years__c = '3',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Level__c = 'Yes',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	NokiaCPQ_LEO_Discount__c=false,
	Is_List_Price_Only__c =false,
	NokiaCPQ_Is_cloned__c = false,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
	isCQ__c = false);	
	insert testProposal;
	testProposal.CurrencyIsoCode = Nokia_CPQ_Constants.EUR_CURR;
	update testProposal;
		}
		

		/*Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
		request.QuoteId = testProposal.Id;
		// Excute the createCart routine
		Apttus_CPQApi.CPQ.CreateCartResponseDO cartResponse = Apttus_CPQApi.CPQWebService.createCart(request);
		*/
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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
	from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:	 ProdConfig.id];//cartResponse.CartID];
			if(lineItem != null && lineItem.size() > 0){
	system.debug('cart lines size...' + lineItem.size());
	system.debug('cart lines...' + lineItem);
	for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
		System.debug('lineItemSO...'+ lineItemSO);
	}
			}else{
	system.debug('cart lines does not exist...');
			}
			
			/*
			Apttus_CPQApi.CPQ.ProductSearchResultDO productResult = Apttus_CPQApi.CPQWebService.getProductsForPriceList(priceListSO.id);
	system.debug('productResult....'+productResult);
			For(Apttus_CPQApi.CPQ.ProductDO catresult : productResult.Products){
	system.debug('price list products....'+ productSO.id + '...' + catresult.Name + '...' + catresult.Prices);
			}
			*/
			//Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
		}catch(Exception ex){
			throw ex;
		}
	}
		 Test.stopTest();
	}  
	
	//end monika
 //kamlesh started from here..
 static testMethod void IndirectMPWEUR2() {
	Apttus_Config2__ClassificationName__c categoerySO = new Apttus_Config2__ClassificationName__c (Apttus_Config2__Active__c = true
	, Apttus_Config2__Type__c = 'Offering'
	, Apttus_Config2__HierarchyLabel__c = 'Test826');
	insert categoerySO;

	Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
	);
	insert priceListSO;
	
	//Create Product
   List<Product2> prods = new List<Product2>();
   Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		, NokiaCPQ_Product_Discount_Category__c = 'Standard'
   ); 
   prods.add(prod1);
	
   Product2 prod2 = new product2(
	  Name = 'Maintenance Year1', 
	  ProductCode = 'MT001', 
	  Business_Group__c = 'MN', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'
			
   ); 
   prods.add(prod2);
   
   Product2 prod3 = new product2(
	  Name = 'SRS', 
	  ProductCode = 'SRS001', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'  
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'   
   ); 
   prods.add(prod3);
   
   Product2 prod4 = new product2(
	  Name = 'SSP', 
	  ProductCode = 'SSP002', 
	  CurrencyIsoCode = 'USD',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'   
   ); 
   prods.add(prod4);
   
   Product2 prod5 = new product2(
	  Name = 'Maintenance Year2+', 
	  ProductCode = 'MT002',  
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c ='NFM-P IPR',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
   ); 
   prods.add(prod5);
	 
   Product2 prod6 = new product2(
	  Name = 'prod6', 
	  ProductCode = 'P6', 
	  CurrencyIsoCode = 'USD',
	Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone' 
   ); 
   prods.add(prod6);
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
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 100, 
	  Apttus_Config2__ProductId__c = prod1.Id, 
	  Apttus_Config2__ChargeType__c = 'Standard Price'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
   );
   //insert pLI1;
   plistItems.add(pLI1);
	
	Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod2.Id, 
	  Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI2;
	plistItems.add(pLI2);
	
	Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod3.Id, 
	  Apttus_Config2__ChargeType__c = 'SRS'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI1;
	plistItems.add(pLI3);
	
	Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'SSP'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI4);
	
	 Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI5);
	 
	 
	 Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 800, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit' 
	);
	//insert pLI1;
	plistItems.add(pLI6);
	insert plistItems;

	Apttus_Config2__PriceListCategory__c priceListCategorySO 
		= new Apttus_Config2__PriceListCategory__c(Apttus_Config2__HierarchyId__c = categoerySO.id
	, Apttus_Config2__PriceListId__c = priceListSO.id
	, Apttus_Config2__Sequence__c =1);

	Apttus_Config2__ClassificationHierarchy__c chSO 
		= new Apttus_Config2__ClassificationHierarchy__c(Apttus_Config2__HierarchyId__c = categoerySO.id
		, Apttus_Config2__Left__c=1
		, Apttus_Config2__Right__c=2
		, Apttus_Config2__Label__c= 'My Category');
	insert chSO;

	List<Apttus_Config2__ProductClassification__c> productClassificationList = new List<Apttus_Config2__ProductClassification__c>();
	Apttus_Config2__ProductClassification__c productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod1.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 1;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod2.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 2;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	
	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod3.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 3;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod4.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 4;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod5.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 5;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod6.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 6;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	try{
		insert productClassificationList;
	}catch(Exception ex){

	}

	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
	custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
	custSetting.Name = 'Nokia_CallBack1';
	//insert custSetting;
	
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
		/*  opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
			opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
			opportunities.get(0).Account_Role__c = 'Alliance Partner';
			insert opportunities.get(0);*/
	opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
			opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities[0].End_Customer_LE__c = accounts1[0].Id;
			insert opportunities;
			
			//create Accreditation
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c=Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
			Pricing_Cluster__c='MPW Cluster 2',
			Pricing_Level_Override__c = 'Co-Branded',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c=Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
			Pricing_Cluster__c='MPW Cluster 2',
			Pricing_Level_Override__c = 'Advanced',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
	testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	NokiaCPQ_SSP_Level__c = '',
	NokiaCPQ_SRS_Level__c = '',
	NokiaCPQ_Maintenance_Type__c = 'Solution Support',
	NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	NokiaCPQ_No_of_Years__c = '4',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Level__c = 'Yes',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	NokiaCPQ_LEO_Discount__c=true,
	Is_List_Price_Only__c =false,
	NokiaCPQ_Is_cloned__c = false,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
	isCQ__c = false);	
	insert testProposal;
	testProposal.CurrencyIsoCode = Nokia_CPQ_Constants.EUR_CURR;
	update testProposal;
		}
		

		/*Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
		request.QuoteId = testProposal.Id;
		// Excute the createCart routine
		Apttus_CPQApi.CPQ.CreateCartResponseDO cartResponse = Apttus_CPQApi.CPQWebService.createCart(request);
		*/
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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
	from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:	 ProdConfig.id];//cartResponse.CartID];
			if(lineItem != null && lineItem.size() > 0){
	system.debug('cart lines size...' + lineItem.size());
	system.debug('cart lines...' + lineItem);
	for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
		System.debug('lineItemSO...'+ lineItemSO);
	}
			}else{
	system.debug('cart lines does not exist...');
			}
			
			/*
			Apttus_CPQApi.CPQ.ProductSearchResultDO productResult = Apttus_CPQApi.CPQWebService.getProductsForPriceList(priceListSO.id);
	system.debug('productResult....'+productResult);
			For(Apttus_CPQApi.CPQ.ProductDO catresult : productResult.Products){
	system.debug('price list products....'+ productSO.id + '...' + catresult.Name + '...' + catresult.Prices);
			}
			*/
			//Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
		}catch(Exception ex){
			throw ex;
		}
	}
		 Test.stopTest();
	}  
	static testMethod void IndirectMPWUSD() {
	Apttus_Config2__ClassificationName__c categoerySO = new Apttus_Config2__ClassificationName__c (Apttus_Config2__Active__c = true
	, Apttus_Config2__Type__c = 'Offering'
	, Apttus_Config2__HierarchyLabel__c = 'Test826');
	insert categoerySO;

	Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
	);
	insert priceListSO;
	
	//Create Product
   List<Product2> prods = new List<Product2>();
   Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Standalone'
		, NokiaCPQ_Product_Discount_Category__c = 'Standard'
   ); 
   prods.add(prod1);
	
   Product2 prod2 = new product2(
	  Name = 'Maintenance Year1', 
	  ProductCode = 'MT001', 
	  Business_Group__c = 'MN', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'
			
   ); 
   prods.add(prod2);
   
   Product2 prod3 = new product2(
	  Name = 'SRS', 
	  ProductCode = 'SRS001', 
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	  IsActive = true,
	  Apttus_Config2__ConfigurationType__c = 'Standalone'  
	  , NokiaCPQ_Product_Discount_Category__c = 'Standard'   
   ); 
   prods.add(prod3);
   
   Product2 prod4 = new product2(
	  Name = 'SSP', 
	  ProductCode = 'SSP002', 
	  CurrencyIsoCode = 'USD',
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'   
   ); 
   prods.add(prod4);
   
   Product2 prod5 = new product2(
	  Name = 'Maintenance Year2+', 
	  ProductCode = 'MT002',  
	  CurrencyIsoCode = 'USD',
	  Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c ='NFM-P IPR',
	  Apttus_Config2__ConfigurationType__c = 'Standalone'
   ); 
   prods.add(prod5);
	 
   Product2 prod6 = new product2(
	  Name = 'prod6', 
	  ProductCode = 'P6', 
	  CurrencyIsoCode = 'USD',
	Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	  IsActive = true,
	  NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION',
	  Apttus_Config2__ConfigurationType__c = 'Standalone' 
   ); 
   prods.add(prod6);
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
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 100, 
	  Apttus_Config2__ProductId__c = prod1.Id, 
	  Apttus_Config2__ChargeType__c = 'Standard Price'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
   );
   //insert pLI1;
   plistItems.add(pLI1);
	
	Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod2.Id, 
	  Apttus_Config2__ChargeType__c = 'Year 1 Maintenance'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI2;
	plistItems.add(pLI2);
	
	Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
	  Apttus_Config2__ListPrice__c = 200, 
	  Apttus_Config2__ProductId__c = prod3.Id, 
	  Apttus_Config2__ChargeType__c = 'SRS'
	  , Apttus_Config2__PriceType__c = 'One Time'
	  , Apttus_Config2__PriceMethod__c = 'Per Unit'
	);
	//insert pLI1;
	plistItems.add(pLI3);
	
	Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod4.Id, 
		Apttus_Config2__ChargeType__c = 'SSP'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI4);
	
	 Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 200, 
		Apttus_Config2__ProductId__c = prod5.Id, 
		Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit'   
	);
	//insert pLI1;
	plistItems.add(pLI5);
	 
	 
	 Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
	  Apttus_Config2__PriceListId__c = priceListSO.Id,
		Apttus_Config2__ListPrice__c = 800, 
		Apttus_Config2__ProductId__c = prod6.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
		, Apttus_Config2__PriceType__c = 'One Time'
		, Apttus_Config2__PriceMethod__c = 'Per Unit' 
	);
	//insert pLI1;
	plistItems.add(pLI6);
	insert plistItems;

	Apttus_Config2__PriceListCategory__c priceListCategorySO 
		= new Apttus_Config2__PriceListCategory__c(Apttus_Config2__HierarchyId__c = categoerySO.id
	, Apttus_Config2__PriceListId__c = priceListSO.id
	, Apttus_Config2__Sequence__c =1);

	Apttus_Config2__ClassificationHierarchy__c chSO 
		= new Apttus_Config2__ClassificationHierarchy__c(Apttus_Config2__HierarchyId__c = categoerySO.id
		, Apttus_Config2__Left__c=1
		, Apttus_Config2__Right__c=2
		, Apttus_Config2__Label__c= 'My Category');
	insert chSO;

	List<Apttus_Config2__ProductClassification__c> productClassificationList = new List<Apttus_Config2__ProductClassification__c>();
	Apttus_Config2__ProductClassification__c productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod1.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 1;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod2.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 2;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	
	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod3.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 3;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod4.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 4;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod5.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 5;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);

	productClassificationSO = new Apttus_Config2__ProductClassification__c();
	productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
	productClassificationSO.Apttus_Config2__ProductId__c = prod6.id;
	productClassificationSO.Apttus_Config2__Sequence__c = 6;
	productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
	productClassificationList.add(productClassificationSO);
	try{
		insert productClassificationList;
	}catch(Exception ex){

	}

	Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
	custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
	custSetting.Name = 'Nokia_CallBack1';
	//insert custSetting;
	
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
			opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
			opportunities.get(0).End_Customer_LE__c = accounts1[0].Id;
			opportunities.get(0).CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
			opportunities.get(0).Account_Role__c = 'Alliance Partner';
			insert opportunities.get(0);
			
			//create Accreditation
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Maintenance',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Nokia Brand of Service',
			Partner__c=accounts[0].Id,
			Portfolio__c=Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
			Pricing_Cluster__c='MPW Cluster 2',
			Pricing_Level_Override__c = 'Co-Branded',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation2);
	
			Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
			Accreditation_Date__c = date.today(),
			Accreditation_Level__c='Advanced',
			Partner__c=accounts[0].Id,
			Portfolio__c=Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
			Pricing_Cluster__c='MPW Cluster 2',
			Pricing_Level_Override__c = 'Advanced',
			Pricing_Override_Expiration__c = Date.today().addDays(10)
				);
			accreditations.add(accreditation3);
	
			insert accreditations;

			Tier_Discount_Detail__c tierDiscountSO = new Tier_Discount_Detail__c();
			tierDiscountSO.NokiaCPQ_Partner_Type__c = partnerType;
			tierDiscountSO.Nokia_CPQ_Partner_Program__c = partnerProgram;
			insert tierDiscountSO;

			/*
			Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSRSdefaultMDT = new Nokia_CPQ_SSP_SRS_Default_Values__mdt();
			sspSRSdefaultMDT.Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION;
			sspSRSdefaultMDT.SSP_Visible__c = true;
			sspSRSdefaultMDT.SRS_Visible__c = true;
			sspSRSdefaultMDT.SRS_Percentage__c = 10;
			sspSRSdefaultMDT.Tier_Discount_Applicable__c = sspSRSdefaultMDT.AccountLevel_Discount_Applicable__c = sspSRSdefaultMDT.Multi_Year_Discount_Applicable__c= true;
			insert sspSRSdefaultMDT;
			*/
	

			//create proposal
	testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = priceListSO.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	NokiaCPQ_SSP_Level__c = '',
	NokiaCPQ_SRS_Level__c = '',
	NokiaCPQ_Maintenance_Type__c = 'Solution Support',
	NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	NokiaCPQ_No_of_Years__c = '5',
	NokiaProductAccreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Accreditation__c = accreditation2.id,
	NokiaCPQ_Maintenance_Level__c = 'Yes',
	CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
	NokiaCPQ_LEO_Discount__c=true,
	Is_List_Price_Only__c =false,
	NokiaCPQ_Is_cloned__c = false,
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
	isCQ__c = false);	
	insert testProposal;
	//testProposal.CurrencyIsoCode = Nokia_CPQ_Constants.EUR_CURR;
	update testProposal;
		}
		

		/*Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
		request.QuoteId = testProposal.Id;
		// Excute the createCart routine
		Apttus_CPQApi.CPQ.CreateCartResponseDO cartResponse = Apttus_CPQApi.CPQWebService.createCart(request);
		*/
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = accounts[0].Id, 
	Apttus_Config2__PriceListId__c = priceListSO.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = priceListSO.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

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
	from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:	 ProdConfig.id];//cartResponse.CartID];
			if(lineItem != null && lineItem.size() > 0){
	system.debug('cart lines size...' + lineItem.size());
	system.debug('cart lines...' + lineItem);
	for(Apttus_Config2__LineItem__c lineItemSO : lineItem){
		System.debug('lineItemSO...'+ lineItemSO);
	}
			}else{
	system.debug('cart lines does not exist...');
			}
			
			/*
			Apttus_CPQApi.CPQ.ProductSearchResultDO productResult = Apttus_CPQApi.CPQWebService.getProductsForPriceList(priceListSO.id);
	system.debug('productResult....'+productResult);
			For(Apttus_CPQApi.CPQ.ProductDO catresult : productResult.Products){
	system.debug('price list products....'+ productSO.id + '...' + catresult.Name + '...' + catresult.Prices);
			}
			*/
			//Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
		}catch(Exception ex){
			throw ex;
		}
	}
		 Test.stopTest();
} 

static testMethod void directEnterprise_Guidance_NoMain() 
{
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
   NokiaCPQ_No_of_Years__c = '',
	NokiaCPQ_Maintenance_Type__c='',
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
	Apttus_Proposal__Account__c=accLegalEntity.id,
	NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=false,
	Sold_To_Party__c = accLegalEntity.id,
	Is_List_Price_Only__c =false,
	NokiaCPQ_SRS_Level__c = '',
	NokiaCPQ_SSP_Level__c='',
	NokiaCPQ_Existing_IONMaint_Contract__c = '',
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

	Test.startTest(); 

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
	}
	Test.stopTest();
}

static testMethod void directEnterprise_Guidance() 
{
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

	Test.startTest(); 

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
	}
	Test.stopTest();
}

static testMethod void directEnterprise_FN() 
{
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

		Test.startTest(); 

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
		}
		Test.stopTest();
}

static testMethod void directFBA() 
{
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
		}
		Test.stopTest();
}



}