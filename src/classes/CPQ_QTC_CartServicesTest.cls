@isTest 
public class CPQ_QTC_CartServicesTest {
	 static testMethod void CPQ_QTC_CartServicesTestmethod() 
	 {
		User sysAdminUser = TestDataFactory.createSystemAdminUser();   
		System.runAs(sysAdminUser){
		
		//create account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		 insert accounts;
		
		//Create Opportunity
	  List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		insert opportunities1; 
		test.startTest();
		//Create Product
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
			Name = 'prod1', 
			ProductCode = 'prod1', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = true ,
			Apttus_Config2__HasOptions__c = true,
			Apttus_Config2__ConfigurationType__c = 'Bundle',
			CPQ_Secondary_Category__c = 'Site Model',
			CPQ_Stream__c = 'QTC',
			NokiaCPQ_Item_Type__c = 'OTHER'
		);
		prods.add(prod1);
		Product2 prod2 = new product2(
			Name = 'prod2', 
			ProductCode = 'prod2', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = true ,
			Apttus_Config2__HasOptions__c = false,
			Apttus_Config2__ConfigurationType__c = 'Standalone',
			CPQ_Stream__c = 'QTC',
			NokiaCPQ_Item_Type__c = 'Hardware'		 
		);
		prods.add(prod2);
			System.debug('surround: inserted products: ' + prods);
		//service product

		Product2 prod3 = new product2(
			Name = 'prod3', 
			ProductCode = 'prod3', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = true ,
			Apttus_Config2__HasOptions__c = false,
			Apttus_Config2__ConfigurationType__c = 'Standalone',
			NokiaCPQ_Item_Type__c = 'Service'	
		);
		prods.add(prod3);

		insert prods;
			
		/*
			//Fetching Solution Bundle 
		List<Product2> bundleProdList = [select id,ProductCode,Apttus_Config2__ConfigurationType__c,Apttus_Config2__HasOptions__c from product2 where ProductCode ='ALU01' and Apttus_Config2__ConfigurationType__c = 'Bundle'];
	 prods.addAll(bundleProdList);   
			List<Product2> optionProdList = [select id,ProductCode,Apttus_Config2__ConfigurationType__c,Apttus_Config2__HasOptions__c from product2 where ProductCode ='3FE47068AA' and Apttus_Config2__ConfigurationType__c = 'Option'];
	 //prods.addAll(optionProdList);   
	List<Product2> standaloneProdList = [select id,ProductCode,Apttus_Config2__ConfigurationType__c,Apttus_Config2__HasOptions__c from product2 where ProductCode ='3HE15011AA' and Apttus_Config2__ConfigurationType__c = 'Standalone'];
	prods.addAll(standaloneProdList);  
			//List of Product Data
		*/
		 List<CPQ_QTC_CartServices.ProductData> pdtList = new List<CPQ_QTC_CartServices.ProductData>();
		 
		CPQ_QTC_CartServices.ProductData pdt1 = new CPQ_QTC_CartServices.ProductData();
		pdt1.productCode = prod1.ProductCode;
		pdt1.bomLineNumber = 1;
		pdt1.quantity = 1;
		pdt1.type = 'Site Model';
		pdtList.add(pdt1);

		CPQ_QTC_CartServices.ProductData pdt2 = new CPQ_QTC_CartServices.ProductData();
		pdt2.productCode = prod2.ProductCode;
		pdt2.bomLineNumber = 2;
		pdt2.quantity = 1;
		pdt2.parentLineNumber = 1;
		pdtList.add(pdt2);

		CPQ_QTC_CartServices.ProductData pdt3 = new CPQ_QTC_CartServices.ProductData();
		pdt3.productCode = prod2.ProductCode;
		pdt3.bomLineNumber = 2;
		pdt3.quantity = 1;
		pdt3.parentLineNumber = 5;
		pdt3.proposedPrice = 100;
		pdt3.rollupGrpNo = 1;
			pdt3.flexibleGroup = 'group1';
		pdtList.add(pdt3);

		CPQ_QTC_CartServices.ProductData pdt4 = new CPQ_QTC_CartServices.ProductData();
		pdt4.productCode = prod3.productCode;
		pdt4.bomLineNumber = 2;
		pdt4.quantity = 1;
		pdtList.add(pdt4);
		
		//Create PriceList		
		
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
			Name = 'QTC CQ CPL Test', 
			Apttus_Config2__Active__c = True
		);
		insert ApttusTestPriceList;   
			
		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();

		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 0, 
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
		

		
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
		proposals[0].NokiaCPQ_Maintenance_Type__c = '';
	 proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_CQ_Quote').getRecordTypeId();//QTC CQ draft quote
		insert proposals; 
			
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = proposals[0].Id, 
			Apttus_Config2__Status__c = 'Saved', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal' 
			);
			insert ProdConfig;

	 CPQ_QTC_CartServices.validateBOM(ProdConfig.Id,pdtList);
	 CPQ_QTC_CartServices.addSequencingAndOptions(ProdConfig.Id,pdtList);
	 CPQ_QTC_CartServices.addProductsToCart(ProdConfig.Id,pdtList);
	 Test.stopTest();
	 }
	} 

	 static testMethod void CPQ_QTC_CartServicesTestmethod2() 
	 {
		 
		User sysAdminUser = TestDataFactory.createSystemAdminUser();   
		System.runAs(sysAdminUser){
		
		//create account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		 insert accounts;
		
		//Create Opportunity
	  List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		insert opportunities1; 
		test.startTest();
		//Create Product
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
			Name = 'prod1', 
			ProductCode = 'prod1', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = true ,
			Apttus_Config2__HasOptions__c = true,
			Apttus_Config2__ConfigurationType__c = 'Bundle',
			CPQ_Secondary_Category__c = 'Site Model',
			CPQ_Stream__c = 'QTC',
			NokiaCPQ_Item_Type__c = 'OTHER'
		);
		prods.add(prod1);
		Product2 prod2 = new product2(
			Name = 'prod2', 
			ProductCode = 'prod2', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = true ,
			Apttus_Config2__HasOptions__c = false,
			Apttus_Config2__ConfigurationType__c = 'Standalone',
			CPQ_Stream__c = 'QTC',
			NokiaCPQ_Item_Type__c = 'Service',  
			CPQ_Tertiary_Category__c ='OPS_OTS'		 
		
		);
		prods.add(prod2);
			System.debug('surround: inserted products: ' + prods);
		//service product

		Product2 prod3 = new product2(
			Name = 'prod3', 
			ProductCode = 'prod3', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = true ,
			Apttus_Config2__HasOptions__c = false,
			Apttus_Config2__ConfigurationType__c = 'Standalone',
			NokiaCPQ_Item_Type__c = 'Service'	
		);
		prods.add(prod3);

		insert prods;
			
		/*
			//Fetching Solution Bundle 
		List<Product2> bundleProdList = [select id,ProductCode,Apttus_Config2__ConfigurationType__c,Apttus_Config2__HasOptions__c from product2 where ProductCode ='ALU01' and Apttus_Config2__ConfigurationType__c = 'Bundle'];
	 prods.addAll(bundleProdList);   
			List<Product2> optionProdList = [select id,ProductCode,Apttus_Config2__ConfigurationType__c,Apttus_Config2__HasOptions__c from product2 where ProductCode ='3FE47068AA' and Apttus_Config2__ConfigurationType__c = 'Option'];
	 //prods.addAll(optionProdList);   
	List<Product2> standaloneProdList = [select id,ProductCode,Apttus_Config2__ConfigurationType__c,Apttus_Config2__HasOptions__c from product2 where ProductCode ='3HE15011AA' and Apttus_Config2__ConfigurationType__c = 'Standalone'];
	prods.addAll(standaloneProdList);  
			//List of Product Data
		*/
		List<CPQ_QTC_CartServices.QuoteData> pdtList = new List<CPQ_QTC_CartServices.QuoteData>();
		 
		CPQ_QTC_CartServices.QuoteData pdt1 = new CPQ_QTC_CartServices.QuoteData();
		pdt1.resellername = 'XYZ123';
		pdt1.transtype = 'New';
		pdt1.custtype = 'Enterprise';
		pdt1.purchaseorder = '123ABC';
		pdtList.add(pdt1);

		List<CPQ_QTC_CartServices.ProductData> ppDList = new List<CPQ_QTC_CartServices.ProductData>();
		
		CPQ_QTC_CartServices.ProductData  ppD1 = new CPQ_QTC_CartServices.ProductData();
		ppD1.groupid = '3';
		ppD1.quantity  = 1;
		ppD1.serviceoi = 'prod2';
		ppD1.tss_productoi = 'Product OI GP3';
		ppD1.tss_productname = 'roduct Name Gp3';
		ppD1.servicedesc = '1 Year Term QTY 1 Fixed Discount';
		ppD1.tss_productOIDescription = 'Prod Description Gp3\\';
		ppD1.tss_productManufacturer = 'Mfg Gp3';
		//ppD1.startDate = '01-04-2021';
		//ppD1.endDate = '31-03-2022';
		ppD1.term = '1';
		ppD1.tss_unitRate = '1200';
		ppD1.extunitrate = '1200';
		ppD1.tss_oneTimeCharge = '';
		ppD1.extonetimecharge = '0';
		ppD1.unitdisc = '0.8333';
		ppD1.tss_discUnitRate = '200';
		ppD1.extdiscunitrate = '200';
		ppD1.onetimedisc = '0';
		ppD1.disconetimecharge = '0';
		ppD1.extdisconetimecharge = '0';
		ppD1.adjusttype = 'SVSC';
		ppD1.priceclass = 'V'; 

		ppDList.add(ppD1);
		

		//Create PriceList	  
		
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
			Name = 'QTC CQ CPL Test', 
			Apttus_Config2__Active__c = True
		);
		insert ApttusTestPriceList;   
			
		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();

		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 0, 
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
		
		CPQ_SSFBillingRuleMaster__c ssf = new CPQ_SSFBillingRuleMaster__c();
		ssf.CPQ_Active__c = true;
		ssf.CPQ_Billing_Rule_Code__c = '30';
		ssf.CPQ_Billing_Rule_Description__c = 'test desc';
		insert ssf;
		
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
		proposals[0].NokiaCPQ_Maintenance_Type__c = '';
		proposals[0].CPQ_SSF_Billing_Rule_ID__c = ssf.Id;
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_CQ_Quote').getRecordTypeId();//QTC CQ draft quote
		insert proposals; 
			
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = proposals[0].Id, 
			Apttus_Config2__Status__c = 'Saved', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal' 
			);
			insert ProdConfig;

	 CPQ_QTC_CartServices.updateQuote(ProdConfig.Id,pdtList[0]);
	 CPQ_QTC_CartServices.addProductsToCartSSF(ProdConfig.Id,ppDList);
	 CPQ_QTC_CartServices.validateSSF(ProdConfig.Id,ppDList);
	 Test.stopTest();
	 }
	} 
}