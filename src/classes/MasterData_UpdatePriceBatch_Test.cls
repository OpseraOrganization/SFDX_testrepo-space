@isTest
public class MasterData_UpdatePriceBatch_Test {
	//test method1
	@isTest static void teststagingData1(){
		
		Product2 prod = new Product2(Name = 'Laptop X200',
									 Family = 'Hardware',
									 ProductCode = 'Prod2020',
									 Portfolio__c = 'Test');
		insert prod;
		
		Apttus_Config2__PriceList__c priceIns = new Apttus_Config2__PriceList__c();
		priceIns.Name = 'Direct Price List (USD)';
		priceIns.PriceList_Type__c =  'FN Direct';
		priceIns.CurrencyIsoCode= 'USD';
		insert priceIns;
		
		Apttus_Config2__PriceListItem__c pricelistitem = new Apttus_Config2__PriceListItem__c();
		pricelistitem.Apttus_Config2__PriceListId__c = priceIns.Id;
		pricelistitem.Apttus_Config2__Active__c = TRUE;
		pricelistitem.CurrencyIsoCode= 'USD';
		pricelistitem.Apttus_Config2__ListPrice__c = 200;
		insert pricelistitem;
		
		CNP_High_Staging__c staging = new CNP_High_Staging__c();
		staging.Product_Code__c = 'Prod2020';
		staging.Type__c = 'APJ Market Price List (USD)';
		staging.Price__c = 200;
		staging.CurrencyIsoCode= 'USD';
		insert staging;
		
		Test.startTest();
		Database.executeBatch(new MasterData_UpdatePriceBatch(), 1);
		Test.stopTest(); 
		
	}
	
	@isTest static void teststagingData2(){
		
		Product2 prod = new Product2(Name = 'Laptop X200',
									 Family = 'Hardware',
									 ProductCode = 'Prod2020');
		insert prod;
		
		Apttus_Config2__PriceList__c priceIns = new Apttus_Config2__PriceList__c();
		priceIns.Name = 'Direct Price List (USD)';
		priceIns.PriceList_Type__c =  'FN Direct';
		priceIns.CurrencyIsoCode= 'USD';
		insert priceIns;
		
		Apttus_Config2__PriceListItem__c pricelistitem = new Apttus_Config2__PriceListItem__c();
		pricelistitem.Apttus_Config2__PriceListId__c = priceIns.Id;
		pricelistitem.Apttus_Config2__Active__c = TRUE;
		pricelistitem.CurrencyIsoCode= 'USD';
		pricelistitem.Apttus_Config2__ListPrice__c = 200;
		insert pricelistitem;
		
		Product_Extension__c prodExt = new Product_Extension__c();
		prodExt.Product__c = prod.Id;
		prodExt.stream__c = 'Enterprise';
		insert prodExt;
		
		CNP_High_Staging__c staging = new CNP_High_Staging__c();
		staging.Product_Code__c = 'Prod2020';
		staging.Type__c = 'Floor Pricing';
		staging.Price__c = 200;
		staging.CurrencyIsoCode= 'USD';
		staging.Stream__c = 'Enterprise';
		insert staging;
		
		Test.startTest();
		Database.executeBatch(new MasterData_UpdatePriceBatch(), 1);
		Test.stopTest(); 
		
	}
	
	@isTest static void teststagingData3(){
		
		Product2 prod = new Product2(Name = 'Laptop X200',
									 Family = 'Hardware',
									 ProductCode = 'Prod2020');
		insert prod;
		
		
		Apttus_Config2__PriceList__c priceIns = new Apttus_Config2__PriceList__c();
		priceIns.Name = 'APJ Market Price List (USD)';
		priceIns.PriceList_Type__c = 'Indirect Market';
		insert priceIns;
		
		Apttus_Config2__PriceListItem__c pricelistitem = new Apttus_Config2__PriceListItem__c();
		pricelistitem.Apttus_Config2__PriceListId__c = priceIns.Id;
		pricelistitem.Apttus_Config2__Active__c = TRUE;
		pricelistitem.Apttus_Config2__ProductId__c = prod.Id;
		pricelistitem.Apttus_Config2__ListPrice__c = 200;
		pricelistitem.currencyISOCode = 'USD'; 
		insert pricelistitem;
		
		CNP_High_Staging__c staging = new CNP_High_Staging__c();
		staging.Product_Code__c = 'Prod2020';
		staging.Type__c = 'APJ Market Price List (USD)';
		staging.Price__c = 200;
		staging.CurrencyIsoCode= 'USD';
		insert staging;
		
		
		Test.startTest();
		Database.executeBatch(new MasterData_UpdatePriceBatch(), 1);
		Test.stopTest(); 
		
	}
	
	@isTest static void teststagingData4(){
		
		Product2 prod = new Product2(Name = 'Laptop X200',
									 Family = 'Hardware',
									 ProductCode = 'Prod2020');
		insert prod;
		
		prod = new Product2(Name = 'Laptop X201',
							Family = 'Hardware1',
							ProductCode = 'Prod2021');
		insert prod;
		
		Apttus_Config2__PriceList__c priceIns = new Apttus_Config2__PriceList__c();
		priceIns.Name = 'Direct Pricelist FN (USD)';
		priceIns.PriceList_Type__c =  'FN Direct';
		insert priceIns;
		
		Apttus_Config2__PriceListItem__c pricelistitem = new Apttus_Config2__PriceListItem__c();
		pricelistitem.Apttus_Config2__PriceListId__c = priceIns.Id;
		pricelistitem.Apttus_Config2__Active__c = TRUE;
		insert pricelistitem;
		
		CNP_High_Staging__c staging = new CNP_High_Staging__c();
		staging.Product_Code__c = 'Prod2020';
		staging.Type__c = 'Direct Pricelist FN (USD)';
		staging.Price__c = 200;
		staging.CurrencyIsoCode= 'USD';
		insert staging;
		
		staging = new CNP_High_Staging__c();
		staging.Product_Code__c = 'Prod2021';
		staging.Type__c = 'Direct Pricelist FN (USD)';
		staging.Price__c = 200;
		staging.CurrencyIsoCode= 'USD';
		insert staging;
		
		Test.startTest();
		Database.executeBatch(new MasterData_UpdatePriceBatch(), 2);
		Test.stopTest(); 
		
	}
	
	@isTest static void teststagingData5(){
		
		Product2 prod = new Product2(Name = 'Laptop X200',
									 Family = 'Hardware',
									 ProductCode = 'Prod2020');
		insert prod;
		
		prod = new Product2(Name = 'Laptop X201',
							Family = 'Hardware1',
							ProductCode = 'Prod2021');
		insert prod;
		
		Apttus_Config2__PriceList__c priceIns = new Apttus_Config2__PriceList__c();
		priceIns.Name = 'APJ Market Price List (USD)';
		priceIns.PriceList_Type__c =  'FN Direct';
		priceIns.CurrencyIsoCode= 'USD';
		insert priceIns;
		
		Apttus_Config2__PriceListItem__c pricelistitem = new Apttus_Config2__PriceListItem__c();
		pricelistitem.Apttus_Config2__PriceListId__c = priceIns.Id;
		pricelistitem.Apttus_Config2__Active__c = TRUE;
		pricelistitem.CurrencyIsoCode= 'USD';
		pricelistitem.Apttus_Config2__ListPrice__c = 200;
		insert pricelistitem;
		
		CNP_High_Staging__c staging = new CNP_High_Staging__c();
		staging.Product_Code__c = 'Prod2020';
		staging.Type__c = 'APJ Market Price List (USD)';
		staging.Price__c = 200;
		staging.CurrencyIsoCode= 'USD';
		insert staging;
		
		staging = new CNP_High_Staging__c();
		staging.Product_Code__c = 'Prod2021';
		staging.Type__c = 'APJ Market Price List (USD)';
		staging.Price__c = 200;
		staging.CurrencyIsoCode= 'USD';
		insert staging;
		
		Test.startTest();
		Database.executeBatch(new MasterData_UpdatePriceBatch(), 2);
		Test.stopTest(); 
		
	}
	
	@isTest static void teststagingData6(){
		
		Product2 prod = new Product2(Name = 'Laptop X200',
									 Family = 'Hardware',
									 ProductCode = 'Prod2020');
		insert prod;
		
		prod = new Product2(Name = 'Laptop X201',
							Family = 'Hardware1',
							ProductCode = 'Prod2021');
		insert prod;
		
		Apttus_Config2__PriceList__c priceIns = new Apttus_Config2__PriceList__c();
		priceIns.Name = 'APJ Market Price List (USD)';
		priceIns.PriceList_Type__c =  'FN Direct';
		priceIns.CurrencyIsoCode= 'USD';
		insert priceIns;
		
		Apttus_Config2__PriceListItem__c pricelistitem = new Apttus_Config2__PriceListItem__c();
		pricelistitem.Apttus_Config2__PriceListId__c = priceIns.Id;
		pricelistitem.Apttus_Config2__Active__c = TRUE;
		pricelistitem.CurrencyIsoCode= 'USD';
		pricelistitem.Apttus_Config2__ListPrice__c = 200;
		insert pricelistitem;
		
		CNP_High_Staging__c staging = new CNP_High_Staging__c();
		staging.Product_Code__c = 'Prod2020';
		staging.Type__c = 'APJ Market Price List (USD)';
		staging.Price__c = 200;
		staging.CurrencyIsoCode= 'USD';
		staging.Stream__c = 'Enterprise';
		insert staging;
		
		staging = new CNP_High_Staging__c();
		staging.Product_Code__c = 'Prod2021';
		staging.Type__c = 'APJ Market Price List (USD)';
		staging.Price__c = 200;
		staging.CurrencyIsoCode= 'USD';
		staging.Stream__c = 'Enterprise';
		insert staging;
		
		Test.startTest();
		Database.executeBatch(new MasterData_UpdatePriceBatch(), 2);
		Test.stopTest(); 
		
	}
	
	 @isTest static void teststagingData7(){
		
		Product2 prod = new Product2(Name = 'Laptop X200',
									 Family = 'Hardware',
									 ProductCode = 'Prod2020');
		insert prod;
		
		prod = new Product2(Name = 'Laptop X201',
							Family = 'Hardware1',
							ProductCode = 'Prod2021');
		insert prod;
		
		Apttus_Config2__PriceList__c priceIns = new Apttus_Config2__PriceList__c();
		priceIns.Name = 'APJ Market Price List (USD)';
		priceIns.PriceList_Type__c =  'FN Direct';
		priceIns.CurrencyIsoCode= 'USD';
		insert priceIns;
		
		Apttus_Config2__PriceListItem__c pricelistitem = new Apttus_Config2__PriceListItem__c();
		pricelistitem.Apttus_Config2__PriceListId__c = priceIns.Id;
		pricelistitem.Apttus_Config2__Active__c = TRUE;
		pricelistitem.CurrencyIsoCode= 'USD';
		pricelistitem.Apttus_Config2__ListPrice__c = 200;
		pricelistitem.Apttus_Config2__ProductId__c = prod.Id;
		insert pricelistitem;
		
		CNP_High_Staging__c staging = new CNP_High_Staging__c();
		staging.Product_Code__c = 'Prod2020';
		staging.Type__c = 'APJ Market Price List (USD)';
		staging.Price__c = 200;
		staging.CurrencyIsoCode= 'USD';
		staging.Stream__c = 'Enterprise';
		insert staging;
		
		staging = new CNP_High_Staging__c();
		staging.Product_Code__c = 'Prod2021';
		staging.Type__c = 'APJ Market Price List (USD)';
		staging.Price__c = 200;
		staging.CurrencyIsoCode= 'USD';
		staging.Stream__c = 'Enterprise';
		insert staging;
		
		Test.startTest();
		Database.executeBatch(new MasterData_UpdatePriceBatch(), 2);
		Test.stopTest(); 
		
	}
}