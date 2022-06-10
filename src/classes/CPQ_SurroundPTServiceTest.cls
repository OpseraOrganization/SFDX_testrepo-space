@isTest(SeeAllData = true)
public with sharing class CPQ_SurroundPTServiceTest {

	static testMethod void getDynamicPricingResponseTest() {

		List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
		users[0].Nokia_ID__c = '234597';
		insert users;

		System.runAs(users[0]) {

			List<Account> accounts = TestDataFactory.createAccount(5);

			accounts[0].AccountNumber='3011546560';
			accounts[0].Acc_No__c = '3011546560';
			accounts[0].CountryCode__c='IN';
			accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();

			accounts[1].AccountNumber='3011546561';
			accounts[1].Acc_No__c = '3011546561';
			accounts[1].CountryCode__c='IN';
			accounts[1].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();

			accounts[2].AccountNumber='3011546562';
			accounts[2].Acc_No__c = '3011546562';
			accounts[2].CountryCode__c='IN';
			accounts[2].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();

			accounts[3].AccountNumber='3011546563';
			accounts[3].Acc_No__c = '3011546563';
			accounts[3].CountryCode__c='IN';
			accounts[3].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();

			accounts[4].AccountNumber='3011546564';
			accounts[4].Acc_No__c = '3011546564';
			accounts[4].CountryCode__c='IN';
			accounts[4].QTC_Sold_To__c = '666666';
			accounts[4].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();

			insert accounts;

			accounts[1].ParentId = accounts[0].Id;
			accounts[2].ParentId = accounts[1].Id;
			accounts[3].ParentId = accounts[2].Id;
			accounts[4].ParentId = accounts[3].Id;

			update accounts;

			//create contract price list
			List<Apttus_Config2__PriceList__c> plList = new List<Apttus_Config2__PriceList__c>();
			Apttus_Config2__PriceList__c agr1 = new Apttus_Config2__PriceList__c(
				Name = 'agr_1', 
				Apttus_Config2__Active__c = True,
				CurrencyIsoCode = 'USD'
			);
			plList.add(agr1);
			Apttus_Config2__PriceList__c agr2 = new Apttus_Config2__PriceList__c(
				Name = 'agr_2', 
				Apttus_Config2__Active__c = True,
				CurrencyIsoCode = 'USD'
			);
			plList.add(agr2);
			insert plList;

			//create price pool
			CPQ_PricingPool__c testPool = new CPQ_PricingPool__c();
			testPool.CPQ_Pricing_Pool_Name__c = 'Test Pool';
			testPool.CPQ_Active__c = true;
			insert testPool;

			//create price pool agreement map
			List<CPQ_Pricing_Pool_Agreement_Map__c> poolAgrMapList = new List<CPQ_Pricing_Pool_Agreement_Map__c>();
			
			CPQ_Pricing_Pool_Agreement_Map__c poolAgr1 = new CPQ_Pricing_Pool_Agreement_Map__c();
			poolAgr1.CPQ_Pricing_Pool_Id__c = testPool.Id;
			poolAgr1.CPQ_Agreement_Name__c = plList[0].Id;
			poolAgr1.CPQ_Active__c = true;
			poolAgr1.CPQ_Rank__c = 1;
			poolAgrMapList.add(poolAgr1);

			CPQ_Pricing_Pool_Agreement_Map__c poolAgr2 = new CPQ_Pricing_Pool_Agreement_Map__c();
			poolAgr2.CPQ_Pricing_Pool_Id__c = testPool.Id;
			poolAgr2.CPQ_Agreement_Name__c = plList[1].Id;
			poolAgr2.CPQ_Active__c = true;
			poolAgr2.CPQ_Rank__c = 2;
			poolAgrMapList.add(poolAgr2);

			insert poolAgrMapList;

			//create price pool account map
			CPQ_PricingPoolAccountMap__c poolAccMap = new CPQ_PricingPoolAccountMap__c();
			poolAccMap.CPQ_Account__c = accounts[0].Id;
			poolAccMap.CPQ_Pricing_Pool_ID__c = testPool.Id;
			poolAccMap.CPQ_Active__c = true;
			poolAccMap.CPQ_Default__c = true;
			insert poolAccMap;

			//create products
			List<Product2> prdList = new List<Product2>();

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
			stnd1.Apttus_Config2__ConfigurationType__c = 'Standalone';
			prdList.add(stnd1);

			Product2 stnd2 = new Product2();
			stnd2.name = 'STND2';
			stnd2.ProductCode='STND3';
			stnd2.CurrencyIsoCode = 'USD';
			stnd2.Business_Group__c='MN';
			stnd2.Family= 'A&A-CEM';
			stnd2.IsActive=True;
			stnd2.Portfolio__c='Airscale Wifi';
			stnd2.Pricing_Clusters__c='NAM';
			stnd2.IsActive= True;
			stnd2.NokiaCPQ_Item_Type__c= 'Hardware';
			stnd2.CPQ_Stream__c = 'QTC';
			stnd2.Apttus_Config2__ConfigurationType__c = 'Standalone';
			prdList.add(stnd2);

			insert prdList;

			//create PLIs
			List<Apttus_Config2__PriceListItem__c> pliList = new List<Apttus_Config2__PriceListItem__c>();

			Apttus_Config2__PriceListItem__c pli1 = new Apttus_Config2__PriceListItem__c(
				Apttus_Config2__PriceListId__c = plList[0].Id,
				Apttus_Config2__ListPrice__c = 100, 
				Apttus_Config2__ProductId__c = stnd1.Id, 
				Apttus_Config2__ChargeType__c = 'Standard Price',
				CurrencyISOCode = 'USD'
			);
			pliList.add(pli1);

			Apttus_Config2__PriceListItem__c pli2 = new Apttus_Config2__PriceListItem__c(
				Apttus_Config2__PriceListId__c = plList[1].Id,
				Apttus_Config2__ListPrice__c = 100, 
				Apttus_Config2__ProductId__c = stnd2.Id, 
				Apttus_Config2__ChargeType__c = 'Standard Price',
				CurrencyISOCode = 'USD'
			);
			pliList.add(pli2);

			insert pliList;

			Test.startTest();
			String productCodes = stnd1.ProductCode + ',' + stnd2.ProductCode;
			CPQ_SurroundPTService.getDynamicPricingResponse(accounts[4].QTC_Sold_To__c, agr2.Name, productCodes);
			Test.stopTest();

		}

	}

}