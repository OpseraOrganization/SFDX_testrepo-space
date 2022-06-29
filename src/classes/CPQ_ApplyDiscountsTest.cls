//The test class covers the changes in made in the following classes as part of surround CQ MAy release
//1. Nokia_PricingCallBack : CQ logic
//2. CPQ_PriceListItemWrapper - Entire class
//3. QTC_DataExtract - Pricing CQ Related helper classes
@isTest
public with sharing class CPQ_ApplyDiscountsTest {
	static testMethod void applyDiscountsPricingTest() {

		List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
		users[0].Nokia_ID__c = '234597';
		insert users;

		System.runAs(users[0]) {  
			//create account
			List<Account> accounts=new List<Account>();
			Account account = TestDataFactory.createAccount(1)[0];
			account.AccountNumber='3011546567';
			account.Acc_No__c = '3011546567';
			account.CountryCode__c='IN';
			account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			accounts.add(account);
			insert accounts;

			//create global agreement/price list
			//create contract agreement/price list
			List<Apttus_Config2__PriceList__c> plList = new List<Apttus_Config2__PriceList__c>();
			Apttus_Config2__PriceList__c globalPriceList = new Apttus_Config2__PriceList__c(
	Name = 'Global Price List', 
	Apttus_Config2__Active__c = True,
	CurrencyIsoCode = 'USD'
			);
			plList.add(globalPriceList);
			Apttus_Config2__PriceList__c contractPriceList = new Apttus_Config2__PriceList__c(
	Name = 'Contract Price List', 
	Apttus_Config2__Active__c = True,
	CurrencyIsoCode = 'USD'
			);
			plList.add(contractPriceList);
			insert plList;

			//get contract number
			List<Apttus_Config2__PriceList__c> cplis = [Select id, Apttus_Config2__ContractNumber__c from Apttus_Config2__PriceList__c where id =:contractPriceList.Id limit 1];
			System.debug('surround queried PL: ' + cplis);
			String agreementNumber = cplis[0].Apttus_Config2__ContractNumber__c;

			//create price pool
			CPQ_PricingPool__c testPool = new CPQ_PricingPool__c();
			testPool.CPQ_Pricing_Pool_Name__c = 'Test Pool';
			testPool.CPQ_Active__c = true;
			insert testPool;

			//create price pool agreement map
			CPQ_Pricing_Pool_Agreement_Map__c poolAgrMap = new CPQ_Pricing_Pool_Agreement_Map__c();
			poolAgrMap.CPQ_Pricing_Pool_Id__c = testPool.Id;
			poolAgrMap.CPQ_Agreement_Name__c = contractPriceList.Id;
			poolAgrMap.CPQ_Active__c = true;
			poolAgrMap.CPQ_Rank__c = 1;
			insert poolAgrMap;

			//create price pool account map
			CPQ_PricingPoolAccountMap__c poolAccMap = new CPQ_PricingPoolAccountMap__c();
			poolAccMap.CPQ_Account__c = account.Id;
			poolAccMap.CPQ_Pricing_Pool_ID__c = testPool.Id;
			poolAccMap.CPQ_Active__c = true;
			insert poolAccMap;

			//create 1 Conditional, 1 ILDs, 2 QLDs, 2ICDs
			List<CPQ_ContractConditionDisc__c> discountList = new List<CPQ_ContractConditionDisc__c>();
			CPQ_ContractConditionDisc__c cond1 = new CPQ_ContractConditionDisc__c();
			cond1.CPQ_Agreement_Name__c = contractPriceList.Id;
			cond1.CPQ_Code__c = 'CND1';
			cond1.CPQ_Description__c = 'CND2';
			cond1.CPQ_Active__c = true;
			cond1.RecordTypeId = Schema.SObjectType.CPQ_ContractConditionDisc__c.getRecordTypeInfosByDeveloperName().get('Conditional').getRecordTypeId();
			discountList.add(cond1);

			CPQ_ContractConditionDisc__c ild1 = new CPQ_ContractConditionDisc__c();
			ild1.CPQ_Agreement_Name__c = contractPriceList.Id;
			ild1.CPQ_Code__c = 'ILD01';
			ild1.CPQ_Description__c = 'ILD01';
			ild1.CPQ_Active__c = true;
			ild1.RecordTypeId = Schema.SObjectType.CPQ_ContractConditionDisc__c.getRecordTypeInfosByDeveloperName().get('ILD').getRecordTypeId();
			discountList.add(ild1);

			CPQ_ContractConditionDisc__c qld1 = new CPQ_ContractConditionDisc__c();
			qld1.CPQ_Agreement_Name__c = contractPriceList.Id;
			qld1.CPQ_Code__c = 'QLD1';
			qld1.CPQ_Description__c = 'QLD1';
			qld1.CPQ_Active__c = true;
			qld1.RecordTypeId = Schema.SObjectType.CPQ_ContractConditionDisc__c.getRecordTypeInfosByDeveloperName().get('QLD').getRecordTypeId();
			qld1.CPQ_Discount_Type__c = 'Percent';
			qld1.CPQ_Discount_Value__c = 10;
			discountList.add(qld1);

			CPQ_ContractConditionDisc__c qld2 = new CPQ_ContractConditionDisc__c();
			qld2.CPQ_Agreement_Name__c = contractPriceList.Id;
			qld2.CPQ_Code__c = 'QLD2';
			qld2.CPQ_Description__c = 'QLD2';
			qld2.CPQ_Active__c = true;
			qld2.RecordTypeId = Schema.SObjectType.CPQ_ContractConditionDisc__c.getRecordTypeInfosByDeveloperName().get('QLD').getRecordTypeId();
			qld2.CPQ_Discount_Type__c = 'Amount';
			qld2.CPQ_Discount_Value__c = 10;
			discountList.add(qld2);

			CPQ_ContractConditionDisc__c icd1Disc = new CPQ_ContractConditionDisc__c();
			icd1Disc.CPQ_Agreement_Name__c = contractPriceList.Id;
			icd1Disc.CPQ_Code__c = 'ICD1';
			icd1Disc.CPQ_Description__c = 'ICD1';
			icd1Disc.CPQ_Active__c = true;
			icd1Disc.RecordTypeId = Schema.SObjectType.CPQ_ContractConditionDisc__c.getRecordTypeInfosByDeveloperName().get('ICD').getRecordTypeId();
			icd1Disc.CPQ_Discount_Type__c = 'Percent';
			icd1Disc.CPQ_Discount_Value__c = 10;
			discountList.add(icd1Disc);

			CPQ_ContractConditionDisc__c icd2Disc = new CPQ_ContractConditionDisc__c();
			icd2Disc.CPQ_Agreement_Name__c = contractPriceList.Id;
			icd2Disc.CPQ_Code__c = 'ICD2';
			icd2Disc.CPQ_Description__c = 'ICD2';
			icd2Disc.CPQ_Active__c = true;
			icd2Disc.RecordTypeId = Schema.SObjectType.CPQ_ContractConditionDisc__c.getRecordTypeInfosByDeveloperName().get('ICD').getRecordTypeId();
			icd2Disc.CPQ_Discount_Type__c = 'Amount';
			icd2Disc.CPQ_Discount_Value__c = 10;
			discountList.add(icd2Disc);
			
			insert discountList;
			//create Products
			List<Product2> prdList = new List<Product2>();
			// 1. site parent
			Product2 siteModelParent = new Product2();
			siteModelParent.name = 'SITM01';
			siteModelParent.ProductCode='SITM01';
			siteModelParent.CurrencyIsoCode = 'USD';
			siteModelParent.Business_Group__c='MN';
			siteModelParent.Family= 'A&A-CEM';
			siteModelParent.IsActive=True;
			siteModelParent.Portfolio__c='Airscale Wifi';
			siteModelParent.Pricing_Clusters__c='NAM';
			siteModelParent.IsActive= True;
			siteModelParent.NokiaCPQ_Item_Type__c= 'OTHER';
			siteModelParent.CPQ_Secondary_Category__c = 'Site Model';
			siteModelParent.CPQ_Stream__c = 'QTC';
			siteModelParent.Apttus_Config2__ConfigurationType__c = 'Bundle';
			siteModelParent.Apttus_Config2__HasOptions__c = true;
			prdList.add(siteModelParent);

			// 2. Solution Parent
			Product2 solutionParent = new Product2();
			solutionParent.name = 'SOLM01';
			solutionParent.ProductCode='SOLM01';
			solutionParent.CurrencyIsoCode = 'USD';
			solutionParent.Business_Group__c='MN';
			solutionParent.Family= 'A&A-CEM';
			solutionParent.IsActive=True;
			solutionParent.Portfolio__c='Airscale Wifi';
			solutionParent.Pricing_Clusters__c='NAM';
			solutionParent.IsActive= True;
			solutionParent.NokiaCPQ_Item_Type__c= 'OTHER';
			solutionParent.CPQ_Secondary_Category__c = 'Solution Model';
			solutionParent.CPQ_Stream__c = 'QTC';
			solutionParent.Apttus_Config2__ConfigurationType__c = 'Bundle';
			solutionParent.Apttus_Config2__HasOptions__c = true;
			prdList.add(solutionParent);

			// 3. Standalone hardware - for site & solution
			Product2 option1 = new Product2();
			option1.name = 'OPT01';
			option1.ProductCode='OPT01';
			option1.CurrencyIsoCode = 'USD';
			option1.Business_Group__c='MN';
			option1.Family= 'A&A-CEM';
			option1.IsActive=True;
			option1.Portfolio__c='Airscale Wifi';
			option1.Pricing_Clusters__c='NAM';
			option1.IsActive= True;
			option1.NokiaCPQ_Item_Type__c= 'Hardware';
			option1.CPQ_Stream__c = 'QTC';
			option1.Apttus_Config2__ConfigurationType__c = 'Standalone';
			prdList.add(option1);

			Product2 option2 = new Product2();
			option2.name = 'OPT02';
			option2.ProductCode='OPT02';
			option2.CurrencyIsoCode = 'USD';
			option2.Business_Group__c='MN';
			option2.Family= 'A&A-CEM';
			option2.IsActive=True;
			option2.Portfolio__c='Airscale Wifi';
			option2.Pricing_Clusters__c='NAM';
			option2.IsActive= True;
			option2.NokiaCPQ_Item_Type__c= 'Hardware';
			option2.CPQ_Stream__c = 'QTC';
			option2.Apttus_Config2__ConfigurationType__c = 'Standalone';
			prdList.add(option2);

			// 4. Standalone harware - for ILD
			Product2 stnd1 = new Product2();
			stnd1.name = 'STND1';
			stnd1.ProductCode='STND1';
			stnd1.CurrencyIsoCode = 'USD';
			stnd1.Business_Group__c='MN';
			stnd1.Family= 'A&A-CEM';
			stnd1.IsActive=True;
			stnd1.Portfolio__c='Airscale Wifi';
			stnd1.Pricing_Clusters__c='NAM';
			stnd1.IsActive= True;
			stnd1.NokiaCPQ_Item_Type__c= 'Hardware';
			stnd1.CPQ_Stream__c = 'QTC';
			stnd1.NokiaCPQ_Portfolio_Package_Code__c = 'ILD01';
			stnd1.Apttus_Config2__ConfigurationType__c = 'Standalone';
			prdList.add(stnd1);

			// 5. Standalone hardware - for conditional - apply ICD & QLD
			Product2 stndcnd1 = new Product2();
			stndcnd1.name = 'stndcnd1';
			stndcnd1.ProductCode='stndcnd1';
			stndcnd1.CurrencyIsoCode = 'USD';
			stndcnd1.Business_Group__c='MN';
			stndcnd1.Family= 'A&A-CEM';
			stndcnd1.IsActive=True;
			stndcnd1.Portfolio__c='Airscale Wifi';
			stndcnd1.Pricing_Clusters__c='NAM';
			stndcnd1.IsActive= True;
			stndcnd1.NokiaCPQ_Item_Type__c= 'Hardware';
			stndcnd1.CPQ_Stream__c = 'QTC';
			stndcnd1.Apttus_Config2__ConfigurationType__c = 'Standalone';
			prdList.add(stndcnd1);

			// 6. Standalone harware - fixed - apply ICD & QLD
			Product2 stndfxd1 = new Product2();
			stndfxd1.name = 'stndfxd1';
			stndfxd1.ProductCode='stndfxd1';
			stndfxd1.CurrencyIsoCode = 'USD';
			stndfxd1.Business_Group__c='MN';
			stndfxd1.Family= 'A&A-CEM';
			stndfxd1.IsActive=True;
			stndfxd1.Portfolio__c='Airscale Wifi';
			stndfxd1.Pricing_Clusters__c='NAM';
			stndfxd1.IsActive= True;
			stndfxd1.NokiaCPQ_Item_Type__c= 'Hardware';
			stndfxd1.CPQ_Stream__c = 'QTC';
			stndfxd1.Apttus_Config2__ConfigurationType__c = 'Standalone';
			prdList.add(stndfxd1);

			// 7. Standalone service - for proposed and product description
			Product2 serv1 = new Product2();
			serv1.name = 'serv1';
			serv1.ProductCode='serv1';
			serv1.CurrencyIsoCode = 'USD';
			serv1.Business_Group__c='MN';
			serv1.Family= 'A&A-CEM';
			serv1.IsActive=True;
			serv1.Portfolio__c='Airscale Wifi';
			serv1.Pricing_Clusters__c='NAM';
			serv1.IsActive= True;
			serv1.NokiaCPQ_Item_Type__c= 'Service';
			serv1.CPQ_Stream__c = 'QTC';
			serv1.Apttus_Config2__ConfigurationType__c = 'Standalone';
			prdList.add(serv1);

			// 8. ICD product 1  & ICD product 2
			Product2 icd1 = new Product2();
			icd1.name = 'icd1';
			icd1.ProductCode='icd1';
			icd1.CurrencyIsoCode = 'USD';
			icd1.Business_Group__c='MN';
			icd1.Family= 'A&A-CEM';
			icd1.IsActive=True;
			icd1.Portfolio__c='Airscale Wifi';
			icd1.Pricing_Clusters__c='NAM';
			icd1.IsActive= True;
			icd1.NokiaCPQ_Item_Type__c= 'Service';
			icd1.CPQ_Secondary_Category__c = 'Incentive';
			icd1.CPQ_Stream__c = 'QTC';
			icd1.CPQ_ICD_Code__c = 'ICD1';
			icd1.Apttus_Config2__ConfigurationType__c = 'Standalone';
			prdList.add(icd1);

			Product2 icd2 = new Product2();
			icd2.name = 'icd2';
			icd2.ProductCode='icd2';
			icd2.CurrencyIsoCode = 'USD';
			icd2.Business_Group__c='MN';
			icd2.Family= 'A&A-CEM';
			icd2.IsActive=True;
			icd2.Portfolio__c='Airscale Wifi';
			icd2.Pricing_Clusters__c='NAM';
			icd2.IsActive= True;
			icd2.NokiaCPQ_Item_Type__c= 'Service';
			icd2.CPQ_Secondary_Category__c = 'Incentive';
			icd2.CPQ_Stream__c = 'QTC';
			icd2.CPQ_ICD_Code__c = 'ICD2';
			icd2.Apttus_Config2__ConfigurationType__c = 'Standalone';
			prdList.add(icd2);

			insert prdList;


			
			CPQ_FRUCustItemCdMap__c cicEntry = new CPQ_FRUCustItemCdMap__c(
	CPQ_Account__c = account.Id,
	CPQ_Customer_Item_Code__c = 'TTT',
	CPQ_Product__c = stndfxd1.Id,
	CPQ_Active__c = true,
	RecordTypeId = Schema.SObjectType.CPQ_FRUCustItemCdMap__c.getRecordTypeInfosByDeveloperName().get('CIC').getRecordTypeId()
			);

			insert cicEntry;

			List<Apttus_Config2__PriceListItem__c> pliList = new List<Apttus_Config2__PriceListItem__c>();
			//create PLIs under global price list for all products
			Apttus_Config2__PriceListItem__c pli1 = new Apttus_Config2__PriceListItem__c(
	Apttus_Config2__PriceListId__c = globalPriceList.Id,
	Apttus_Config2__ListPrice__c = 100, 
	Apttus_Config2__ProductId__c = siteModelParent.Id, 
	Apttus_Config2__ChargeType__c = 'Standard Price',
	CurrencyISOCode = 'USD'
			);
			pliList.add(pli1);
			Apttus_Config2__PriceListItem__c pli2 = new Apttus_Config2__PriceListItem__c(
	Apttus_Config2__PriceListId__c = globalPriceList.Id,
	Apttus_Config2__ListPrice__c = 0, 
	Apttus_Config2__ProductId__c = solutionParent.Id, 
	Apttus_Config2__ChargeType__c = 'Standard Price',
	CurrencyISOCode = 'USD'
			);
			pliList.add(pli2);
			Apttus_Config2__PriceListItem__c pli3 = new Apttus_Config2__PriceListItem__c(
	Apttus_Config2__PriceListId__c = globalPriceList.Id,
	Apttus_Config2__ListPrice__c = 100, 
	Apttus_Config2__ProductId__c = option1.Id, 
	Apttus_Config2__ChargeType__c = 'Standard Price',
	CurrencyISOCode = 'USD'
			);
			pliList.add(pli3);
			Apttus_Config2__PriceListItem__c pli4 = new Apttus_Config2__PriceListItem__c(
	Apttus_Config2__PriceListId__c = globalPriceList.Id,
	Apttus_Config2__ListPrice__c = 100, 
	Apttus_Config2__ProductId__c = option2.Id, 
	Apttus_Config2__ChargeType__c = 'Standard Price',
	CurrencyISOCode = 'USD'
			);
			pliList.add(pli4);
			Apttus_Config2__PriceListItem__c pli5 = new Apttus_Config2__PriceListItem__c(
	Apttus_Config2__PriceListId__c = globalPriceList.Id,
	Apttus_Config2__ListPrice__c = 100, 
	Apttus_Config2__ProductId__c = stnd1.Id, 
	Apttus_Config2__ChargeType__c = 'Standard Price',
	CurrencyISOCode = 'USD'
			);
			pliList.add(pli5);
			Apttus_Config2__PriceListItem__c pli6 = new Apttus_Config2__PriceListItem__c(
	Apttus_Config2__PriceListId__c = globalPriceList.Id,
	Apttus_Config2__ListPrice__c = 100, 
	Apttus_Config2__ProductId__c = stndcnd1.Id, 
	Apttus_Config2__ChargeType__c = 'Standard Price',
	CurrencyISOCode = 'USD'
			);
			pliList.add(pli6);
			Apttus_Config2__PriceListItem__c pli7 = new Apttus_Config2__PriceListItem__c(
	Apttus_Config2__PriceListId__c = globalPriceList.Id,
	Apttus_Config2__ListPrice__c = 100, 
	Apttus_Config2__ProductId__c = stndfxd1.Id, 
	Apttus_Config2__ChargeType__c = 'Standard Price',
	CurrencyISOCode = 'USD'
			);
			pliList.add(pli7);
			Apttus_Config2__PriceListItem__c pli8 = new Apttus_Config2__PriceListItem__c(
	Apttus_Config2__PriceListId__c = globalPriceList.Id,
	Apttus_Config2__ListPrice__c = 0, 
	Apttus_Config2__ProductId__c = serv1.Id, 
	Apttus_Config2__ChargeType__c = 'Standard Price',
	CurrencyISOCode = 'USD'
			);
			pliList.add(pli8);
			Apttus_Config2__PriceListItem__c pli9 = new Apttus_Config2__PriceListItem__c(
	Apttus_Config2__PriceListId__c = globalPriceList.Id,
	Apttus_Config2__ListPrice__c = 0, 
	Apttus_Config2__ProductId__c = icd1.Id, 
	Apttus_Config2__ChargeType__c = 'Standard Price',
	CurrencyISOCode = 'USD'
			);
			pliList.add(pli9);
			Apttus_Config2__PriceListItem__c pli10 = new Apttus_Config2__PriceListItem__c(
	Apttus_Config2__PriceListId__c = globalPriceList.Id,
	Apttus_Config2__ListPrice__c = 0, 
	Apttus_Config2__ProductId__c = icd2.Id, 
	Apttus_Config2__ChargeType__c = 'Standard Price',
	CurrencyISOCode = 'USD'
			);
			pliList.add(pli10);
			//create PLIs under contract price list for, site parent, one conditional product, one fixed price
			Apttus_Config2__PriceListItem__c plic1 = new Apttus_Config2__PriceListItem__c(
	Apttus_Config2__PriceListId__c = contractPriceList.Id,
	Apttus_Config2__ListPrice__c = 1000, 
	Apttus_Config2__ProductId__c = siteModelParent.Id, 
	Apttus_Config2__ChargeType__c = 'Standard Price',
	CurrencyISOCode = 'USD'
			);
			pliList.add(plic1);
			Apttus_Config2__PriceListItem__c plic2 = new Apttus_Config2__PriceListItem__c(
	Apttus_Config2__PriceListId__c = contractPriceList.Id,
	Apttus_Config2__ListPrice__c = 1000, 
	Apttus_Config2__ProductId__c = stndcnd1.Id, 
	Apttus_Config2__ChargeType__c = 'Standard Price',
	CurrencyISOCode = 'USD',
	Apttus_Config2__ContractPrice__c = 1000,
	CPQ_Conditional_Price_Code__c = 'CND1'
			);
			pliList.add(plic2);
			Apttus_Config2__PriceListItem__c plic3 = new Apttus_Config2__PriceListItem__c(
	Apttus_Config2__PriceListId__c = contractPriceList.Id,
	Apttus_Config2__ListPrice__c = 1000,
	Apttus_Config2__ProductId__c = stndfxd1.Id, 
	Apttus_Config2__ChargeType__c = 'Standard Price',
	CurrencyISOCode = 'USD',
	Apttus_Config2__ContractPrice__c = 1000
			);
			pliList.add(plic3);
			// siteModelParent,solutionParent,option1,option2,stnd1,stndcnd1,stndfxd1,serv1,icd1,icd2
			insert pliList;

			//make pli wrapper
			List<CPQ_PriceListItemWrapper> pliWrapperList = new List<CPQ_PriceListItemWrapper>();
			for(Apttus_Config2__PriceListItem__c pli : pliList) {
	pliWrapperList.add(new CPQ_PriceListItemWrapper(pli));
			}
			Nokia_CPQ_Constants.AGREEMENT_NUMBERS = new List<String>{agreementNumber};
			pliWrapperList.sort();
			//create rest of the Apttus quote related objects
			//Create Opportunity
			List<Opportunity> opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
			insert opportunities.get(0);
			
			//create proposal
			Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
	Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
	Apttus_QPConfig__PriceListId__c = globalPriceList.Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	CurrencyIsoCode = 'USD',
	// NokiaCPQ_Portfolio__c = 'Nokia Software',
	// CPQ_NCQ_Check__c = true,
	Apttus_Proposal__Approval_Stage__c = 'Draft',
	// NokiaCPQ_No_of_Years__c = '1',
	RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_CQ_Quote').getRecordTypeId(),//direct Prices_Aligned__c=true,
	Apttus_Proposal__Account__c=accounts[0].id,
	Sold_To_Party__c = accounts[0].id,
	Is_List_Price_Only__c =false,
	CPQ_Pricing_Pool__c = 'Test Pool',
	CPQ_Contractual_Price_Condition__c = 'CND1',
	CPQ_Contractual_Price_Condition_Code__c = 'CND1'
			);
			insert testProposal;
			system.debug('testProposal:'+testProposal);

			testProposal.CPQ_Applicable_Agreements__c = agreementNumber;
			update testProposal;
			
			//create quote contractual discounts entries under quote
			List<CPQ_QuoteContractualDiscount__c> quoteDiscounts = new List<CPQ_QuoteContractualDiscount__c>();
			CPQ_QuoteContractualDiscount__c qd1 = new CPQ_QuoteContractualDiscount__c(
	CPQ_Proposal__c = testProposal.Id,
	CPQ_QLD_ICD_ID__c = qld1.Id,
	CPQ_Sequence__c = 1
			);
			quoteDiscounts.add(qd1);
			CPQ_QuoteContractualDiscount__c qd2 = new CPQ_QuoteContractualDiscount__c(
	CPQ_Proposal__c = testProposal.Id,
	CPQ_QLD_ICD_ID__c = icd1Disc.Id,
	CPQ_Sequence__c = 2
			);
			quoteDiscounts.add(qd2);
			CPQ_QuoteContractualDiscount__c qd3 = new CPQ_QuoteContractualDiscount__c(
	CPQ_Proposal__c = testProposal.Id,
	CPQ_QLD_ICD_ID__c = qld2.Id,
	CPQ_Sequence__c = 3
			);
			quoteDiscounts.add(qd3);
			CPQ_QuoteContractualDiscount__c qd4 = new CPQ_QuoteContractualDiscount__c(
	CPQ_Proposal__c = testProposal.Id,
	CPQ_QLD_ICD_ID__c = icd2Disc.Id,
	CPQ_Sequence__c = 4
			);
			quoteDiscounts.add(qd4);
			insert quoteDiscounts;

			//create product configuration
			Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
	Name = 'APTTUS Test Config', 
	Apttus_Config2__AccountId__c = account.Id, 
	Apttus_Config2__PriceListId__c = globalPriceList.Id, 
	Apttus_QPConfig__Proposald__c = testProposal.Id, 
	Apttus_Config2__Status__c = 'New', 
	Apttus_Config2__VersionNumber__c = 1, 
	Apttus_Config2__EffectivePriceListId__c = globalPriceList.Id,
	Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
			);
			insert ProdConfig;
			
			//Create Line Items
			list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
			//solution parent
			Apttus_Config2__LineItem__c li1 = new Apttus_Config2__LineItem__c(
	Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
	Apttus_Config2__ItemSequence__c = 1,
	Apttus_Config2__LineNumber__c = 1,
	Apttus_Config2__PrimaryLineNumber__c = 1,
	Apttus_Config2__IsPrimaryLine__c = true,
	
	//product fields
	Apttus_Config2__ProductId__c = solutionParent.Id,
	Apttus_Config2__LineType__c = 'Product/Service',
	// Apttus_Config2__LineType__c = 'Option'
	Apttus_Config2__HasOptions__c = true,
	Apttus_Config2__Quantity__c = 1,
	
	//option fields
	// Apttus_Config2__OptionId__c
	// Apttus_Config2__ParentBundleNumber__c

	//other fields
	Apttus_Config2__PriceListId__c = globalPriceList.id,
	Apttus_Config2__SellingTerm__c = 1,
	Apttus_Config2__LineStatus__c='New',
	Apttus_Config2__PriceMethod__c = 'Per Unit',
	Apttus_Config2__Frequency__c = 'One Time',
	Apttus_Config2__PricingStatus__c = 'Pending'
	// Apttus_Config2__BasePriceOverride__c
	// CPQ_Product_Description__c
			);
			allLineItems.add(li1);
			//solution child1
			Apttus_Config2__LineItem__c li2 = new Apttus_Config2__LineItem__c(
	Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
	Apttus_Config2__ItemSequence__c = 2,
	Apttus_Config2__LineNumber__c = 1,
	Apttus_Config2__PrimaryLineNumber__c = 2,
	Apttus_Config2__IsPrimaryLine__c = true,
	Apttus_Config2__ParentBundleNumber__c = 1,

	//product fields
	Apttus_Config2__ProductId__c = solutionParent.Id,
	// Apttus_Config2__LineType__c = 'Product/Service';
	Apttus_Config2__LineType__c = 'Option',
	Apttus_Config2__OptionId__c = option1.Id,
	// Apttus_Config2__HasOptions__c = true;
	Apttus_Config2__Quantity__c = 1,

	//other fields
	Apttus_Config2__PriceListId__c = globalPriceList.id,
	Apttus_Config2__SellingTerm__c = 1,
	Apttus_Config2__LineStatus__c='New',
	Apttus_Config2__PriceMethod__c = 'Per Unit',
	Apttus_Config2__Frequency__c = 'One Time',
	Apttus_Config2__PricingStatus__c = 'Pending'
	// Apttus_Config2__BasePriceOverride__c
	// CPQ_Product_Description__c
			);
			allLineItems.add(li2);
			//site parent
			Apttus_Config2__LineItem__c li3 = new Apttus_Config2__LineItem__c(
	Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
	Apttus_Config2__ItemSequence__c = 3,
	Apttus_Config2__LineNumber__c = 2,
	Apttus_Config2__PrimaryLineNumber__c = 3,
	Apttus_Config2__IsPrimaryLine__c = true,
	
	//product fields
	Apttus_Config2__ProductId__c = siteModelParent.Id,
	Apttus_Config2__LineType__c = 'Product/Service',
	// Apttus_Config2__LineType__c = 'Option'
	Apttus_Config2__HasOptions__c = true,
	Apttus_Config2__Quantity__c = 1,
	
	//option fields
	// Apttus_Config2__OptionId__c
	// Apttus_Config2__ParentBundleNumber__c

	//other fields
	Apttus_Config2__PriceListId__c = globalPriceList.id,
	Apttus_Config2__SellingTerm__c = 1,
	Apttus_Config2__LineStatus__c='New',
	Apttus_Config2__PriceMethod__c = 'Per Unit',
	Apttus_Config2__Frequency__c = 'One Time',
	Apttus_Config2__PricingStatus__c = 'Pending'
	// Apttus_Config2__BasePriceOverride__c
	// CPQ_Product_Description__c
			);
			allLineItems.add(li3);
			//site child 1
			Apttus_Config2__LineItem__c li4 = new Apttus_Config2__LineItem__c(
	Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
	Apttus_Config2__ItemSequence__c = 4,
	Apttus_Config2__LineNumber__c = 2,
	Apttus_Config2__PrimaryLineNumber__c = 4,
	Apttus_Config2__IsPrimaryLine__c = true,
	Apttus_Config2__ParentBundleNumber__c = 3,
	
	//product fields
	Apttus_Config2__ProductId__c = siteModelParent.Id,
	// Apttus_Config2__LineType__c = 'Product/Service';
	Apttus_Config2__LineType__c = 'Option',
	Apttus_Config2__OptionId__c = option1.Id,
	// Apttus_Config2__HasOptions__c = true;
	Apttus_Config2__Quantity__c = 1,
	

	//other fields
	Apttus_Config2__PriceListId__c = globalPriceList.id,
	Apttus_Config2__SellingTerm__c = 1,
	Apttus_Config2__LineStatus__c='New',
	Apttus_Config2__PriceMethod__c = 'Per Unit',
	Apttus_Config2__Frequency__c = 'One Time',
	Apttus_Config2__PricingStatus__c = 'Pending'
	// Apttus_Config2__BasePriceOverride__c
	// CPQ_Product_Description__c
			);
			allLineItems.add(li4);
			//site child 2
			Apttus_Config2__LineItem__c li5 = new Apttus_Config2__LineItem__c(
	Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
	Apttus_Config2__ItemSequence__c = 5,
	Apttus_Config2__LineNumber__c = 2,
	Apttus_Config2__PrimaryLineNumber__c = 5,
	Apttus_Config2__IsPrimaryLine__c = true,
	Apttus_Config2__ParentBundleNumber__c = 3,
	
	//product fields
	Apttus_Config2__ProductId__c = siteModelParent.Id,
	// Apttus_Config2__LineType__c = 'Product/Service';
	Apttus_Config2__LineType__c = 'Option',
	Apttus_Config2__OptionId__c = option2.Id,
	// Apttus_Config2__HasOptions__c = true;
	Apttus_Config2__Quantity__c = 1,
	

	//other fields
	Apttus_Config2__PriceListId__c = globalPriceList.id,
	Apttus_Config2__SellingTerm__c = 1,
	Apttus_Config2__LineStatus__c='New',
	Apttus_Config2__PriceMethod__c = 'Per Unit',
	Apttus_Config2__Frequency__c = 'One Time',
	Apttus_Config2__PricingStatus__c = 'Pending'
	// Apttus_Config2__BasePriceOverride__c
	// CPQ_Product_Description__c
			);
			allLineItems.add(li5);

			// ild standalone line
			Apttus_Config2__LineItem__c li6 = new Apttus_Config2__LineItem__c(
	Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
	Apttus_Config2__ItemSequence__c = 6,
	Apttus_Config2__LineNumber__c = 3,
	Apttus_Config2__PrimaryLineNumber__c = 6,
	Apttus_Config2__IsPrimaryLine__c = true,
	// Apttus_Config2__ParentBundleNumber__c = 3,
	
	//product fields
	Apttus_Config2__ProductId__c = stnd1.Id,
	Apttus_Config2__LineType__c = 'Product/Service',
	// Apttus_Config2__LineType__c = 'Option'
	// Apttus_Config2__OptionId__c = option2.Id
	// Apttus_Config2__HasOptions__c = true;
	Apttus_Config2__Quantity__c = 1,
	
	CPQ_Contracted_Price__c = 100,
	//other fields
	Apttus_Config2__PriceListId__c = globalPriceList.id,
	Apttus_Config2__SellingTerm__c = 1,
	Apttus_Config2__LineStatus__c='New',
	Apttus_Config2__PriceMethod__c = 'Per Unit',
	Apttus_Config2__Frequency__c = 'One Time',
	Apttus_Config2__PricingStatus__c = 'Pending'
	// Apttus_Config2__BasePriceOverride__c
	// CPQ_Product_Description__c
			);
			allLineItems.add(li6);

			// condition standalone line with qld & icd
			Apttus_Config2__LineItem__c li7 = new Apttus_Config2__LineItem__c(
	Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
	Apttus_Config2__ItemSequence__c = 7,
	Apttus_Config2__LineNumber__c = 4,
	Apttus_Config2__PrimaryLineNumber__c = 7,
	Apttus_Config2__IsPrimaryLine__c = true,
	// Apttus_Config2__ParentBundleNumber__c = 3,
	
	//product fields
	Apttus_Config2__ProductId__c = stndcnd1.Id,
	Apttus_Config2__LineType__c = 'Product/Service',
	// Apttus_Config2__LineType__c = 'Option'
	// Apttus_Config2__OptionId__c = option2.Id
	// Apttus_Config2__HasOptions__c = true;
	Apttus_Config2__Quantity__c = 1,
	

	//other fields
	Apttus_Config2__PriceListId__c = globalPriceList.id,
	Apttus_Config2__SellingTerm__c = 1,
	Apttus_Config2__LineStatus__c='New',
	Apttus_Config2__PriceMethod__c = 'Per Unit',
	Apttus_Config2__Frequency__c = 'One Time',
	Apttus_Config2__PricingStatus__c = 'Pending',
	// Apttus_Config2__BasePriceOverride__c
	// CPQ_Product_Description__c
	CPQ_Contracted_Price__c = 100,
	CPQ_Conditional_Price_Code__c = 'CND1',
	CPQ_Contractual_Discounts__c = 'QLD1;ICD1;QLD2;ICD2'
			);
			allLineItems.add(li7);

			// fixed standalone line with qld & icd
			Apttus_Config2__LineItem__c li8 = new Apttus_Config2__LineItem__c(
	Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
	Apttus_Config2__ItemSequence__c = 8,
	Apttus_Config2__LineNumber__c = 5,
	Apttus_Config2__PrimaryLineNumber__c = 8,
	Apttus_Config2__IsPrimaryLine__c = true,
	// Apttus_Config2__ParentBundleNumber__c = 3,
	
	//product fields
	Apttus_Config2__ProductId__c = stndfxd1.Id,
	Apttus_Config2__LineType__c = 'Product/Service',
	// Apttus_Config2__LineType__c = 'Option'
	// Apttus_Config2__OptionId__c = option2.Id
	// Apttus_Config2__HasOptions__c = true;
	Apttus_Config2__Quantity__c = 1,
	

	//other fields
	Apttus_Config2__PriceListId__c = globalPriceList.id,
	Apttus_Config2__SellingTerm__c = 1,
	Apttus_Config2__LineStatus__c='New',
	Apttus_Config2__PriceMethod__c = 'Per Unit',
	Apttus_Config2__Frequency__c = 'One Time',
	Apttus_Config2__PricingStatus__c = 'Pending',
	// Apttus_Config2__BasePriceOverride__c
	// CPQ_Product_Description__c
	CPQ_Contracted_Price__c = 100,
	CPQ_Contractual_Discounts__c = 'QLD1;ICD1;QLD2;ICD2'
			);
			allLineItems.add(li8);

			// service product
			Apttus_Config2__LineItem__c li9 = new Apttus_Config2__LineItem__c(
	Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
	Apttus_Config2__ItemSequence__c = 9,
	Apttus_Config2__LineNumber__c = 6,
	Apttus_Config2__PrimaryLineNumber__c = 9,
	Apttus_Config2__IsPrimaryLine__c = true,
	// Apttus_Config2__ParentBundleNumber__c = 3,
	
	//product fields
	Apttus_Config2__ProductId__c = serv1.Id,
	Apttus_Config2__LineType__c = 'Product/Service',
	// Apttus_Config2__LineType__c = 'Option'
	// Apttus_Config2__OptionId__c = option2.Id
	// Apttus_Config2__HasOptions__c = true;
	Apttus_Config2__Quantity__c = 1,
	

	//other fields
	Apttus_Config2__PriceListId__c = globalPriceList.id,
	Apttus_Config2__SellingTerm__c = 1,
	Apttus_Config2__LineStatus__c='New',
	Apttus_Config2__PriceMethod__c = 'Per Unit',
	Apttus_Config2__Frequency__c = 'One Time',
	Apttus_Config2__PricingStatus__c = 'Pending',
	Apttus_Config2__BasePriceOverride__c = 100,
	CPQ_Product_Description__c = 'prod description'
			);
			allLineItems.add(li9);

			// icd product
			Apttus_Config2__LineItem__c li10 = new Apttus_Config2__LineItem__c(
	Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
	Apttus_Config2__ItemSequence__c = 10,
	Apttus_Config2__LineNumber__c = 7,
	Apttus_Config2__PrimaryLineNumber__c = 10,
	Apttus_Config2__IsPrimaryLine__c = true,
	// Apttus_Config2__ParentBundleNumber__c = 3,
	
	//product fields
	Apttus_Config2__ProductId__c = icd1.Id,
	Apttus_Config2__LineType__c = 'Product/Service',
	// Apttus_Config2__LineType__c = 'Option'
	// Apttus_Config2__OptionId__c = option2.Id
	// Apttus_Config2__HasOptions__c = true;
	Apttus_Config2__Quantity__c = 1,
	

	//other fields
	Apttus_Config2__PriceListId__c = globalPriceList.id,
	Apttus_Config2__SellingTerm__c = 1,
	Apttus_Config2__LineStatus__c='New',
	Apttus_Config2__PriceMethod__c = 'Per Unit',
	Apttus_Config2__Frequency__c = 'One Time',
	Apttus_Config2__PricingStatus__c = 'Pending'
	
			);
			allLineItems.add(li10);
			// siteModelParent,solutionParent,option1,option2,stnd1,stndcnd1,stndfxd1,serv1,icd1,icd2
			insert allLineItems;

			Test.startTest();
			
			//test apply discounts controller - start
			CPQ_ApplyDiscountsController.InitData initData = CPQ_ApplyDiscountsController.initializePage(ProdConfig.Id);
			CPQ_ApplyDiscountsController.applyDiscounts(testProposal.Id, ProdConfig.Id, JSON.serialize(initData.lineItemData));
			
			QTC_DataExtract.getCustomerItemCodeMap(new Set<Id>{stndfxd1.id}, account.Id);
			QTC_DataExtract.getContractedPriceListItems(new Set<Id>{stndfxd1.id}, new List<String>{agreementNumber}, 'USD');
			QTC_DataExtract.getGlobalPriceListItems(new Set<Id>{stndfxd1.id}, globalPriceList.Id);
			QTC_DataExtract.getApplicableILDs(new Set<String>{'ILD01'}, new List<String>{agreementNumber});
			QTC_DataExtract.getQuoteContractualDiscounts(testProposal.Id);
			
			
			Test.stopTest();

		}
	}
}