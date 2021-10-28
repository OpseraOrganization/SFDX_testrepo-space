//The test class covers the QuoteContractDiscTrigger and QuoteContractDiscHelper

@isTest
public with sharing class QuoteContractDiscTest {
	static testMethod void Test1() {


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
			
			insert discountList;
			//Create Opportunity
			List<Opportunity> opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
			opportunities.get(0).Lead_BG__c = 'MN';
			opportunities.get(0).StageName = 'Create Offer (Bid)';
			opportunities.get(0).Phase_Status__c = 'Offer in Progress';
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

			insert quoteDiscounts;
			
			CPQ_QuoteContractualDiscount__c qd2 = new CPQ_QuoteContractualDiscount__c(
				CPQ_Proposal__c = testProposal.Id,
				CPQ_QLD_ICD_ID__c = qld2.Id,
				Id = quoteDiscounts[0].Id,
				CPQ_Sequence__c = 1
			);
			
			update qd2;
			

		}
	}
}