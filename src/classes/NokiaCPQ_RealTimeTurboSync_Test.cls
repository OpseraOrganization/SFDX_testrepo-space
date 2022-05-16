/******************************************************************
This test class covers below 

Apex classes 
	1. NokiaCPQ_RealTimeTurboSync
	2. NokiaCPQ_SyncToTurboBatch
	3. NokiaCPQ_SyncToTurboQueueable

Apex triggers
	1. PriceListTrigger
	2. PricelistItemTrigger
******************************************************************/

@isTest
public class NokiaCPQ_RealTimeTurboSync_Test {  

	@isTest static void method1() {
		
		Apttus_Proposal_Proposal__c turboData = new Apttus_Proposal_Proposal__c();
		turboData.Elastic_Sync_API__c = 'https://TestEndPoint';
		turboData.Name = 'Turbo Admin';
		insert turboData;
		
		Apttus_Config2__PriceList__c pricelist=new Apttus_Config2__PriceList__c();
		pricelist.Name='CLPEUR';
		pricelist.Apttus_Config2__Active__c=true;
		pricelist.CurrencyIsoCode='EUR';
		pricelist.Sync_to_Turbo__c = 'Yes';
		insert pricelist;
		
		product2 prod = new product2();
		prod.name = 'A';
		prod.CurrencyIsoCode = 'USD';
		prod.Business_Group__c='MN';
		prod.Family= 'A&A-CEM';
		prod.IsActive=True;
		prod.Partner_Visible__c=True;
		prod.ProductCode='3HE10869BA';
		prod.Apttus_Config2__Version__c= 1;
		prod.Portfolio__c= 'Optics';
		prod.Pricing_Clusters__c='NAM';
		prod.IsActive= True;
		insert prod;
		Test.setMock(HttpCalloutMock.class, new NokiaCPQ_TurboHttpMock_Test());
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c();
		pLI1.Apttus_Config2__PriceListId__c = pricelist.Id;
		pLI1.Apttus_Config2__ListPrice__c = 100;
		pLI1.Apttus_Config2__ProductId__c = prod.Id;
		pLI1.Apttus_Config2__ChargeType__c = 'Standard Price';
		pLI1.Sync_to_Turbo__c = 'Yes';
		insert pLI1;
		
		delete pLI1;
	}
	
	@isTest static void method2() {
		
		Apttus_Proposal_Proposal__c turboData = new Apttus_Proposal_Proposal__c();
		turboData.Elastic_Sync_API__c = 'https://TestEndPoint';
		turboData.Name = 'Turbo Admin';
		insert turboData;
		
		Apttus_Config2__PriceList__c pricelist=new Apttus_Config2__PriceList__c();
		pricelist.Name='CLPEUR';
		pricelist.Apttus_Config2__Active__c=true;
		pricelist.CurrencyIsoCode='EUR';
		pricelist.Sync_to_Turbo__c = 'Yes';
		insert pricelist;
		
	}

}