@isTest
public class SummaryGroupTriggerHelperTest{

	 static testMethod void SummaryGroupTriggerHelperTestmethod() 
	 {
		 
		User sysAdminUser = TestDataFactory.createSystemAdminUser();   
	 System.runAs(sysAdminUser){
		
		//create account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		 insert accounts;
		
		//Create Opportunity
	  List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();
		insert opportunities1; 
		
		//Create Product
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
			Name = 'Test1', 
			ProductCode = '123', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = true
		); 
		prods.add(prod1);
		
		
		Product2 prod2 = new product2(
			Name = 'Test2', 
			ProductCode = '1234', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = true
		); 
		prods.add(prod2);
		Product2 prod3 = new product2(
			Name = 'Test3', 
			ProductCode = '12345', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = false
		); 
		prods.add(prod3);
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
			Apttus_Config2__ProductId__c = prod2.Id
			//Apttus_Config2__ChargeType__c = 'Maintenance Y1'
		);
		//insert pLI2;
		plistItems.add(pLI2);
		Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod3.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI3);
		
		test.startTest();
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
		proposals[0].NokiaCPQ_Maintenance_Type__c = '';
		proposals[0].NokiaCPQ_Is_cloned__c=True;
	  //  proposals[0].NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.AIRSCALE_WIFI_STRING; //MN airscale wifi portfolio
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId();//direct draft quote
		insert proposals;   
		   proposals[0].app_Name__c='BOM'+proposals[0].id;
				update proposals;
		
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = proposals[0].Id, 
			Apttus_Config2__Status__c = 'Saved', 
			 NokiaCPQ_Quote_Type__c ='Indirect CPQ',
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;
		
		//Create Line Items
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
		list<Apttus_Config2__LineItem__c> LineItemList = new List<Apttus_Config2__LineItem__c>();

		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			//Portfolio_from_Quote_Line_Item__c = 'Nokia Software',
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		 
		//insert LineItem2;
		allLineItems.add(LineItem1);
		insert allLineItems;
		 
		 list<Apttus_Config2__SummaryGroup__c> allSummarygrps = new List<Apttus_Config2__SummaryGroup__c>();
		  Apttus_Config2__SummaryGroup__c allSummarygrp4 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Subtotal - Standard Price (One Time) - Standard Price (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 100,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		allSummarygrps.add(allSummarygrp4);
		insert allSummarygrps;	
		 
		 
	   
		//create product configuration
		Apttus_Config2__ProductConfiguration__c testProdConfig1 = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			NokiaCPQ_Quote_Type__c ='Indirect CPQ',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = proposals[0].Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id)
		);
		insert testProdConfig1;  
		update testProdConfig1;
		

		list<Apttus_Config2__LineItem__c> testAllLineItems1 = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c testLineItem11 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=testProdConfig1.Id,
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
			
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		
		testAllLineItems1.add(testLineItem11);
		insert testAllLineItems1;
	 
		
 list<Apttus_Config2__SummaryGroup__c> testAllSummarygrps1 = new List<Apttus_Config2__SummaryGroup__c>();
		Apttus_Config2__SummaryGroup__c testAllSummarygrp11 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Total (One Time)',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = testProdConfig1.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 800,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		testAllSummarygrps1.add(testAllSummarygrp11);
		insert testAllSummarygrps1;
		update testAllSummarygrps1;
		
		Test.stopTest();
	 }
	}

}