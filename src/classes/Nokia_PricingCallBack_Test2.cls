@isTest(SeeAllData = false) 
public class Nokia_PricingCallBack_Test2{


	static testMethod void pricingTest() {
		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
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
			account.CountryCode__c='IN';
			accountsNew.add(account);

			insert accountsNew;

			List<Account> accounts=new List<Account>();
			accounts.add(account);

			//Create Opportunity
			opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
			opportunities.get(0).StageName = 'Create Offer (Bid)';
			opportunities.get(0).Phase_Status__c = 'Offer in Progress';
			insert opportunities.get(0);


			//Create Product
			List<Product2> prods = new List<Product2>();
			Product2 prod1 = new product2(
			Name = 'Test1', 
			ProductCode = '123', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = Nokia_CPQ_Constants.AIRSCALE_WIFI_STRING,
			NokiaCPQ_OEM__c = false,
			IsActive = true,
			NokiaCPQ_Maximum_IRP_Discount__c = 50,
			Apttus_Config2__ConfigurationType__c = 'Standalone',
			NokiaCPQ_Item_Type__c='Hardware',
			PMD_Product_Classification__c='Sales Item',
			// NokiaCPQ_Classification2__c='Standard SW (STD)',
			// NokiaCPQ_License_Usage__c='Commercial Term License',
			NokiaCPQ_Product_Discount_Category__c = '7705 SAR-8/18 IPR'
			); 
			prods.add(prod1);

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
			Apttus_Config2__ListPrice__c = 1100, 
			Apttus_Config2__ProductId__c = prod1.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
			);
			//insert pLI1;
			plistItems.add(pLI1);

			insert plistItems;

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
			//create proposal
			Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			CurrencyIsoCode = 'USD',
			NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.AIRSCALE_WIFI_STRING,
			// CPQ_NCQ_Check__c = true,
			Apttus_Proposal__Approval_Stage__c = 'Draft',
			// NokiaCPQ_No_of_Years__c = '1',
			RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
			Apttus_Proposal__Account__c=accounts[0].id,
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

			Apttus_Config2__LineItem__c LineItem1 = new Apttus_Config2__LineItem__c(
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
	Apttus_Config2__BasePrice__c=1100,
	Apttus_Config2__ListPrice__c = 1100,
	Apttus_Config2__Quantity__c = 1,
	NokiaCPQ_IRP_Discount__c = 10,
	Source__c='',
	Apttus_Config2__PrimaryLineNumber__c = 1,
	Apttus_Config2__ShipToAccountId__c = account.Id,
	is_Custom_Product__c=false,
	Apttus_Config2__BasePriceOverride__c=800,
	CPQ_Original_Proposed_Price__c = 800,
	Apttus_Config2__AddedBy__c = 'added by code',
	NokiaCPQ_Is_Direct_Option__c=true,
	Apttus_Config2__NetAdjustmentPercent__c=0,
	Item_Type_From_CAT__c='PS',
	NokiaCPQ_Account_Region__c='RG_NAM',
	Apttus_Config2__AdjustmentType__c = '% Disc Off Floor',
	Apttus_Config2__AdjustmentAmount__c = 10,
	CPQ_Market_Model__c = 'group 1',
	CPQ_Group_Quantity__c = 1,
	CPQ_Group_Adjustment_Type__c = 'Price Override',
	CPQ_Group_Adjustment_Amount__c = 2000,
	CPQ_Group_Unit_Override_Price__c = 2000
			);
			insert LineItem1;

			Test.startTest(); 
			
			Apttus_Config2__LineItem__c lineItemSO = new Apttus_Config2__LineItem__c();
			lineItemSO = [SELECT Id,Name,Apttus_Config2__ChargeType__c,Apttus_Config2__LineType__c,NokiaCPQ_Light_Color__c,
	Apttus_Config2__PriceListId__c,Apttus_Config2__PriceListItemId__r.Apttus_Config2__PriceListId__c,
	Apttus_Config2__PriceListItemId__r.Contracted__c,Apttus_Config2__ProductId__r.NokiaCPQ_OEM__c,
	Apttus_Config2__ProductId__r.NokiaCPQ_Maximum_IRP_Discount__c,NokiaCPQ_IRP_Discount__c,
	Apttus_Config2__ProductId__r.NokiaCPQ_Item_Type__c,Apttus_Config2__NetAdjustmentPercent__c,
	Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c,NokiaCPQ_Account_Region__c,
	Apttus_Config2__OptionId__r.NokiaCPQ_Min_SM_North_America__c,NokiaCPQ_Is_Direct_Option__c,
	Apttus_Config2__Quantity__c,Apttus_Config2__NetPrice__c,NokiaCPQ_Floor_Price__c,NokiaCPQ_Custom_Bid__c, 
	NokiaCPQ_Product_Type__c,Item_Type_From_CAT__c,Sales_Margin__c		 
	FROM Apttus_Config2__LineItem__c WHERE Id =: LineItem1.Id];

			Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
			obj.proposalSO = testProposal;
			obj.deal_Guidance_Calculator(lineItemSO,'Standalone');
			Test.stopTest();
			
			Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			CurrencyIsoCode = 'USD',
			NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.NOKIA_SOFTWARE,
			// CPQ_NCQ_Check__c = true,
			Apttus_Proposal__Approval_Stage__c = 'Draft',
			// NokiaCPQ_No_of_Years__c = '1',
			RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
			Apttus_Proposal__Account__c=accounts[0].id,
			Sold_To_Party__c = accLegalEntity.id,
			Is_List_Price_Only__c =false
			);
			insert testProposal1;
			
			Nokia_PricingCallBack obj1 = new Nokia_PricingCallBack();
			obj1.proposalSO = testProposal1;
			obj1.deal_Guidance_Calculator(lineItemSO,'Standalone');
		}
	}
	
static testMethod void directEnterprise111() 
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

		/************ Account Insertion  ***************/

		List<Account> accountsNew = new List<Account>();
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='101234567';
		accLegalEntity.Acc_No__c = '101234567';
		accLegalEntity.GEOLevel1ID__c ='RG_EUROPE';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accountsNew.add(accLegalEntity);
		//database.insert(accLegalEntity);

		Account account = TestDataFactory.createAccount(1)[0];
		account.AccountNumber='3011234567';
		account.Acc_No__c = '3011234567';
		account.GEOLevel1ID__c ='RG_EUROPE';
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
		Number_of_GE_Ports__c = 10,
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA,
		Direct_Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA,
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Bundle',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR',
		NokiaCPQ_Category__c = 'PSU'
		); 
		prods.add(prod1);

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
Apttus_Config2__LineType__c = 'Option', //Product/Service',
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__OptionId__c = prod1.Id,
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
//NokiaCPQ_Account_Region__c='RG_NAM',
Apttus_Config2__AddedBy__c = 'added by code'
);
//insert LineItem1;
allLineItems.add(LineItem3);

insert allLineItems;

Test.startTest(); 

CPQ_Maintenance_and_SSP_Rule__c rec1 = new CPQ_Maintenance_and_SSP_Rule__c();
rec1.Maintenance_Level__c = 'Nokia Brand of Service';
rec1.Maintenance_Type__c = 'Gold (Return for Exchange)';
rec1.Region__c = 'RG_EUROPE';
rec1.Service_Rate_Y1__c = 0.05;
rec1.Service_Rate_Y2__c = 0.05;
rec1.Unlimited_SSP_Discount__c = 0.03; 
rec1.Maintenance_Category__c = 'NSD-NRC IPR';
insert rec1;
list<NokiaCPQ_Maintenance_and_SSP_Rules__c> listMaintSSPRule =  [SELECT NokiaCPQ_withPMA__c, NokiaCPQ_Pricing_Cluster__c, NokiaCPQ_Product_Discount_Category__c, NokiaCPQ_Product_Discount_Category_per__c, NokiaCPQ_Unlimited_SSP_Discount__c, NokiaCPQ_Biennial_SSP_Discount__c, NokiaCPQ_Maintenance_Level__c, NokiaCPQ_Maintenance_Type__c, NokiaCPQ_Service_Rate_Y1__c, NokiaCPQ_Service_Rate_Y2__c FROM NokiaCPQ_Maintenance_and_SSP_Rules__c ]; 

			// testProposal.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
			// LineItem3.Product_Number_Of_Ports__c = 1;
			// public static String NOKIA_PTP ='PTP';
			// select testProposal DB
			// select LineItem3 from DB
			// Nokia_PricingCallBack.getSSPQuantityFN(testProposal, LineItem3);
/*
Nokia_PricingCallBack obj = new Nokia_PricingCallBack();
obj.setMode(Apttus_Config2.CustomClass.PricingMode.BASEPRICE);
Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);
obj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
//obj.finish();
Apttus_Config2.PricingWebService.updatePriceForCart(ProdConfig.Id);

//Apttus_Config2.PricingWebService.computeBasePriceForItemColl(ProdConfig.Id, 1);
*/

Test.stopTest();
}

}

	
static testMethod void directEnterprise107689() 
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

		/************ Account Insertion  ***************/

		List<Account> accountsNew = new List<Account>();
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='101234567';
		accLegalEntity.Acc_No__c = '101234567';
		accLegalEntity.GEOLevel1ID__c ='RG_EUROPE';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accountsNew.add(accLegalEntity);
		//database.insert(accLegalEntity);

		Account account = TestDataFactory.createAccount(1)[0];
		account.AccountNumber='3011234567';
		account.Acc_No__c = '3011234567';
		account.GEOLevel1ID__c ='RG_EUROPE';
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
		Number_of_GE_Ports__c = 10,
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA,
		Direct_Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA,
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Bundle',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
		); 
		prods.add(prod1);

	/* Product2 prod2 = new product2(
		Name = 'Maintenance Year1', 
		ProductCode = 'MT001',
		Number_of_GE_Ports__c = 10,
		//Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
		Direct_Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
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
Number_of_GE_Ports__c = 10,
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
Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
Direct_Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
); 
prods.add(prod5);

Product2 prod6 = new product2(
Name = 'Bundle', 
ProductCode = '123', 
//Business_Group__c = 'ION',
Number_of_GE_Ports__c = 10,
CurrencyIsoCode = 'USD',
Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
Direct_Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Item_Type__c='Software',
NokiaCPQ_Classification2__c='Base',

NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
); 
prods.add(prod6);*/

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

/*Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
Apttus_Config2__ListPrice__c = 200, 
Apttus_Config2__ProductId__c = prod1.Id, 
Apttus_Config2__PriceIncludedInBundle__c = true,
Apttus_Config2__ChargeType__c = 'Maintenance Year1',
Apttus_Config2__Cost__c = 10
);
insert pLI2;
plistItems.add(pLI2);

Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod1.Id, 
Apttus_Config2__ChargeType__c = 'SSP',
Apttus_Config2__Cost__c = 10
);
insert pLI1;
plistItems.add(pLI4);

Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod1.Id, 
Apttus_Config2__ChargeType__c = 'Maintenance Year2+',
Apttus_Config2__Cost__c = 10
);
plistItems.add(pLI5);

Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod1.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__Cost__c = 10
);
plistItems.add(pLI6);

Apttus_Config2__PriceListItem__c pLI7 = new Apttus_Config2__PriceListItem__c(
Apttus_Config2__PriceListId__c = ApttusTestPriceList2.Id,
Apttus_Config2__ListPrice__c = 100, 
Apttus_Config2__ProductId__c = prod1.Id, 
Apttus_Config2__ChargeType__c = 'Standard Price',
Apttus_Config2__Cost__c = 10
);
plistItems.add(pLI7);*/

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
//NokiaCPQ_Account_Region__c='RG_NAM',
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
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__PriceListItemId__c = pLI1.id,
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
//NokiaCPQ_Account_Region__c='RG_NAM',
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
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__PriceListItemId__c = pLI1.id,
Apttus_Config2__PriceMethod__c = 'Per Unit',
Apttus_Config2__Frequency__c = 'One Time',
Apttus_Config2__BasePrice__c = 120,
Apttus_Config2__ListPrice__c = 120,
Apttus_Config2__Quantity__c = 1,
Nokia_SSP_Base_Extended_Price__c = 90,
Apttus_Config2__PrimaryLineNumber__c = 1,
Apttus_Config2__ShipToAccountId__c = account.Id,
Advanced_pricing_done__c = false,
//NokiaCPQ_Account_Region__c='RG_NAM',
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
Apttus_Config2__ProductId__c = prod1.Id,
Apttus_Config2__PriceListItemId__c = pLI1.id,
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
//NokiaCPQ_Account_Region__c='RG_NAM',
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
Apttus_Config2__OptionId__c = prod1.Id,
Apttus_Config2__ParentBundleNumber__c = 1,
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
//NokiaCPQ_Account_Region__c='RG_NAM',

Apttus_Config2__AddedBy__c = 'added by code'
);
//insert LineItem1;
allLineItems.add(LineItem8);

insert allLineItems;

Test.startTest(); 

CPQ_Maintenance_and_SSP_Rule__c rec1 = new CPQ_Maintenance_and_SSP_Rule__c();
rec1.Maintenance_Level__c = 'Nokia Brand of Service';
rec1.Maintenance_Type__c = 'Gold (Return for Exchange)';
rec1.Region__c = 'RG_EUROPE';
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
		Number_of_GE_Ports__c = 10,
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
		Direct_Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
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
		Number_of_GE_Ports__c = 10,
		//Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
		Direct_Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
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
Number_of_GE_Ports__c = 10,
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
Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
Direct_Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
IsActive = true,
Apttus_Config2__ConfigurationType__c = 'Standalone',
NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
); 
prods.add(prod5);

Product2 prod6 = new product2(
Name = 'Bundle', 
ProductCode = '123', 
//Business_Group__c = 'ION',
Number_of_GE_Ports__c = 10,
CurrencyIsoCode = 'USD',
Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
Direct_Portfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
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
NokiaCPQ_Account_Region__c='RG_NAM',
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
NokiaCPQ_Account_Region__c='RG_NAM',
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
NokiaCPQ_Account_Region__c='RG_NAM',
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
NokiaCPQ_Account_Region__c='RG_NAM',
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
NokiaCPQ_Account_Region__c='RG_NAM',

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
}