@isTest(SeeAllData = false)
public class OrderExportProviderTest {

  static testmethod void getPLIbundleOptionMapping_testMethod1(){
		//Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSIFinalMap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
		//Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> PLIandAttributeMap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> finalPLImap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
		Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> finalAttributePLImap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>> mappingPLIMap = new Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>();
		Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>> cspOderAndPliMap = new Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>>();
		//create Mapping
		NokiaCPQ_CSP_Map_Control__c mapControl = new NokiaCPQ_CSP_Map_Control__c();
		
		mapControl.Portfolio__c = 'Nokia Software';
		mapControl.Product_Code__c = '833-010330_00';
		mapControl.Source__c = 'External';
		//mapControl.Map_Mode__c = n;
		insert mapControl;
		
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();	 
		insert opportunities;			
		
		//create a quote
		Apttus_Proposal__Proposal__c  proposals = new Apttus_Proposal__Proposal__c();
		proposals.Apttus_Proposal__Account__c = accounts[0].Id;
		proposals.Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals.NokiaCPQ_Needs_Reprice__c = false;
		proposals.Reprice_In_Progress__c = false;
		proposals.RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); 
	   // proposals.NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Enhanced Emergency';
		proposals.NokiaCPQ_No_of_Years__c = '1';
		proposals.NokiaCPQ_Portfolio__c = 'Nokia Software';
		proposals.NokiaCPQ_SSP_Level__c = '';
		insert proposals;	   
		system.debug('>>>Quote Record Type::>>'+proposals.recordtypeID);
		
		//get a Product Apttus_Config2__ConfigurationType__c  
		List <Product2> pList = NOKIA_CPQ_TestDataFactory.productCreationDirect(6);
		pList[0].NokiaCPQ_Category__c = '1000Base-SX';
		pList[0].NokiaCPQ_Product_Discount_Category__c = '';
	   
		pList[0].Pricing_Clusters__c = '';
		pList[0].NokiaCPQ_State__c = 'Ramp Up';
		pList[0].NokiaCPQ_Item_Type__c = 'Service';
		pList[0].Business_Group__c='MN';		   
		pList[0].Portfolio__c = 'Nokia Software';
		pList[0].ProductCode = '833-051870_00_1';
		pList[0].Apttus_Config2__ConfigurationType__c = 'Bundle';
		
		//get a Product
		pList[1].NokiaCPQ_Category__c = '1000Base-SX';
		pList[1].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[1].Pricing_Clusters__c = '';
		pList[1].NokiaCPQ_State__c = 'Ramp Up';
		pList[1].NokiaCPQ_Item_Type__c = 'Service';
		pList[1].Business_Group__c='MN';		   
		pList[1].Portfolio__c = 'Nokia Software';
		pList[1].ProductCode = '833-010330_00_2';
		pList[1].Apttus_Config2__ConfigurationType__c = 'Standalone';
		pList[1].NokiaCPQ_Classification2__c='Deploy Services';
		
		//get a Product
		pList[2].NokiaCPQ_Category__c = '1000Base-SX';
		pList[2].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[2].Pricing_Clusters__c = '';
		pList[2].NokiaCPQ_State__c = 'Ramp Up';
		pList[2].NokiaCPQ_Item_Type__c = 'Service';
		pList[2].ProductCode = 'FC21001';
		pList[2].Business_Group__c='MN';		   
		pList[2].Portfolio__c = 'Nokia Software';
		pList[2].ProductCode = '833-010330_00_3';
		pList[2].Apttus_Config2__ConfigurationType__c = 'Bundle';
		pList[2].Is_P20_Based_Product__c=true;
		
		pList[3].NokiaCPQ_Category__c = '1000Base-SX';
		pList[3].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[3].Pricing_Clusters__c = '';
		pList[3].NokiaCPQ_State__c = 'Ramp Up';
		pList[3].NokiaCPQ_Item_Type__c = 'Service';
		pList[3].ProductCode = 'FC21001';
		pList[3].Business_Group__c='MN';		   
		pList[3].Portfolio__c = 'Nokia Software';
		pList[3].ProductCode = '833-010330_00_4';
		pList[3].Apttus_Config2__ConfigurationType__c = 'Bundle';
		
		pList[4].NokiaCPQ_Category__c = '1000Base-SX';
		pList[4].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[4].Pricing_Clusters__c = '';
		pList[4].NokiaCPQ_State__c = 'Ramp Up';
		pList[4].NokiaCPQ_Item_Type__c = 'Service';
	   // pList[4].ProductCode = 'FC21001';
		pList[4].Business_Group__c='MN';		   
		pList[4].Portfolio__c = 'Nokia Software';
		pList[4].ProductCode = '833-010330_00_5';
		pList[4].Apttus_Config2__ConfigurationType__c = 'Bundle';
		pList[4].Is_Dummy_Bundle_CPQ__c = 'Yes';
	   // pList[4].Is_P20_Based_Product__c=true;
		
		pList[5].NokiaCPQ_Category__c = '1000Base-SX';
		pList[5].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[5].Pricing_Clusters__c = '';
		pList[5].NokiaCPQ_State__c = 'Ramp Up';
		pList[5].NokiaCPQ_Item_Type__c = 'Service';
		pList[5].ProductCode = '833-010330_00_6';
		pList[5].Business_Group__c='MN';		   
		pList[5].Portfolio__c = 'Nokia Software';
	 //   pList[5].ProductCode = '833-010330_00_1';
		pList[5].Apttus_Config2__ConfigurationType__c = 'Option';
		
		insert pList;
		
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='EUR';
		priceList.Apttus_Config2__Active__c=true;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		insert priceList;
		
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[0].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI1);
		Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[1].Id, 
			
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI2);
		Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[2].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI3);
		Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[3].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI4);
		Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[4].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI5);
		Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[5].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI6);
		insert plistItems;
		
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals.Id;
		prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
		insert prodConfigs;
		
		List<Apttus_Config2__LineItem__c> prodConfigsLineItems = NOKIA_CPQ_TestDataFactory.createLineItem(6);
		prodConfigsLineItems[0].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[0].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[0].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[0].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[0].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[0].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[0].Apttus_Config2__ProductId__c = pList[0].Id;
		prodConfigsLineItems[0].Apttus_Config2__PriceListItemId__c = pLI1.id;
		prodConfigsLineItems[0].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[0].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[0].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[0].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[0].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[0].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[0].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[1].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[1].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[1].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[1].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[1].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[1].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[1].Apttus_Config2__ProductId__c = pList[1].Id;
		prodConfigsLineItems[1].Apttus_Config2__PriceListItemId__c = pLI2.id;
		prodConfigsLineItems[1].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[1].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[1].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[1].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[1].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[1].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[1].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[2].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[2].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[2].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[2].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[2].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[2].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[2].Apttus_Config2__ProductId__c = pList[2].Id;
		prodConfigsLineItems[2].Apttus_Config2__PriceListItemId__c = pLI3.id;
		prodConfigsLineItems[2].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[2].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[2].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[2].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[2].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[2].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[3].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[3].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[3].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[3].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[3].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[3].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[3].Apttus_Config2__ProductId__c = pList[3].Id;
		prodConfigsLineItems[3].Apttus_Config2__PriceListItemId__c = pLI4.id;
		prodConfigsLineItems[3].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[3].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[3].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[3].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[3].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[3].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[4].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[4].Apttus_Config2__LineNumber__c =1;
		prodConfigsLineItems[4].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[4].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[4].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[4].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[4].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[4].Apttus_Config2__ProductId__c = pList[4].Id;
		prodConfigsLineItems[4].Apttus_Config2__PriceListItemId__c = pLI5.id;
		prodConfigsLineItems[4].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[4].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[4].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[4].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[4].Apttus_Config2__PrimaryLineNumber__c =1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[4].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[5].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[5].Apttus_Config2__LineSequence__c = 6;
		prodConfigsLineItems[5].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[5].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[5].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[5].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[5].Apttus_Config2__ProductId__c = pList[5].Id;
		prodConfigsLineItems[5].Apttus_Config2__PriceListItemId__c = pLI6.id;
		prodConfigsLineItems[5].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[5].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[5].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[5].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[5].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[5].Apttus_Config2__AddedBy__c = 'added by code';
		insert prodConfigsLineItems;
		
		
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(6);
		proposalLineItemList[0].NokiaCPQ_Spare__c = false;
		proposalLineItemList[0].Apttus_Proposal__Product__c  = pList[0].Id;
		proposalLineItemList[0].Apttus_QPConfig__OptionId__c = pList[0].Id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[0].Apttus_QPConfig__ParentBundleNumber__c = Null;
		proposalLineItemList[0].NokiaCPQ_Configuration_Type__c = 'Bundle';
		proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'Product Service';
		proposalLineItemList[0].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[0].is_Custom_Product__c = false;
		proposalLineItemList[0].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[0].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[0].Apttus_QPConfig__PrimaryLineNumber__c = 1;
		proposalLineItemList[0].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[0].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[0].id;
		proposalLineItemList[0].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[0].NokiaCPQ_ExtendedPrice_CNP__c = 10;
		proposalLineItemList[0].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[0].Total_Option_Quantity__c=1;
		
		
		proposalLineItemList[1].NokiaCPQ_Spare__c = false;
		proposalLineItemList[1].Apttus_Proposal__Product__c  = pList[1].Id;
		proposalLineItemList[1].Apttus_QPConfig__OptionId__c = pList[1].Id;
		proposalLineItemList[1].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[1].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[1].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[1].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[1].is_Custom_Product__c = false;
		proposalLineItemList[1].Apttus_QPConfig__LineType__c = 'Product Service';
		proposalLineItemList[1].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[1].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[1].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[1].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[1].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[1].id;
		proposalLineItemList[1].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[1].NokiaCPQ_ExtendedPrice_CNP__c = 10;
		proposalLineItemList[1].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[1].Total_Option_Quantity__c=1;
		
		proposalLineItemList[2].NokiaCPQ_Spare__c = false;
		proposalLineItemList[2].Apttus_Proposal__Product__c  = pList[2].Id;
		proposalLineItemList[2].Apttus_QPConfig__OptionId__c = pList[2].Id;
		proposalLineItemList[2].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[2].Apttus_QPConfig__ParentBundleNumber__c = null;
		proposalLineItemList[2].NokiaCPQ_Configuration_Type__c = 'Bundle';
		proposalLineItemList[2].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[2].is_Custom_Product__c = false;
		proposalLineItemList[2].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[2].NokiaCPQ_Is_Direct_Option__c  = true;
		proposalLineItemList[2].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[2].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[2].Apttus_QPConfig__PrimaryLineNumber__c = 3;
		proposalLineItemList[2].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[2].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[2].id;
		proposalLineItemList[2].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[2].NokiaCPQ_IsArcadiaBundle__c = true;
		proposalLineItemList[2].NokiaCPQ_ExtendedPrice_CNP__c = 10;
		proposalLineItemList[2].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[2].Total_Option_Quantity__c=1;
		
		proposalLineItemList[3].NokiaCPQ_Spare__c = false;
		proposalLineItemList[3].Apttus_Proposal__Product__c  = pList[3].Id;
		proposalLineItemList[3].Apttus_QPConfig__OptionId__c = pList[3].Id;
		proposalLineItemList[3].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 3;
		proposalLineItemList[3].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[3].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[3].is_Custom_Product__c = false;
		proposalLineItemList[3].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[3].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[3].Apttus_QPConfig__LineNumber__c = 4;
		proposalLineItemList[3].Apttus_QPConfig__PrimaryLineNumber__c = 4;
		proposalLineItemList[3].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[3].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[3].id;
		proposalLineItemList[3].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[3].NokiaCPQ_ExtendedPrice_CNP__c = 10;
		proposalLineItemList[3].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[3].Total_Option_Quantity__c=1;
		
		proposalLineItemList[4].NokiaCPQ_Spare__c = false;
		proposalLineItemList[4].Apttus_Proposal__Product__c  = pList[4].Id;
		proposalLineItemList[4].Apttus_QPConfig__OptionId__c = pList[4].Id;
		proposalLineItemList[4].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[4].Apttus_QPConfig__ParentBundleNumber__c = 3;
		proposalLineItemList[4].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[4].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[4].is_Custom_Product__c = false;
		proposalLineItemList[4].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[4].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[4].Apttus_QPConfig__LineNumber__c = 5;
		proposalLineItemList[4].Apttus_QPConfig__PrimaryLineNumber__c = 5;
		proposalLineItemList[4].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[4].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[4].id;
		proposalLineItemList[4].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[4].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[4].Total_Option_Quantity__c=1;
		
		
		proposalLineItemList[5].NokiaCPQ_Spare__c = false;
		proposalLineItemList[5].Apttus_Proposal__Product__c  = pList[5].Id;
		proposalLineItemList[5].Apttus_QPConfig__OptionId__c = pList[5].Id;
		proposalLineItemList[5].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[5].Apttus_QPConfig__ParentBundleNumber__c = 5;
		proposalLineItemList[5].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[5].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[5].is_Custom_Product__c = false;
		proposalLineItemList[5].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[5].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[5].Apttus_QPConfig__LineNumber__c = 6;
		proposalLineItemList[5].Apttus_QPConfig__PrimaryLineNumber__c = 6;
		proposalLineItemList[5].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[5].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[5].id;
		proposalLineItemList[5].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[5].NokiaCPQ_ExtendedPrice_CNP__c = 10;
		proposalLineItemList[5].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[5].Total_Option_Quantity__c=1;
		
		
		insert proposalLineItemList;
		System.debug('proposalLineItemList[0] : '+proposalLineItemList[0]);
		System.debug('proposalLineItemList[1] : '+proposalLineItemList[1]);
		System.debug('proposalLineItemList[2] : '+proposalLineItemList[2]);
		
		
		
		
		
		Alliance_Order_Export_Mapping__c obj = new Alliance_Order_Export_Mapping__c();
		obj.Arcadia_Options_Product_Code__c='3HZ15362AA';
		obj.Arcadia_Product_Code__c='833-010330_00_6';
		obj.Main_Bundle_Product_Code__c='833-010330_00_1';
		obj.PCI_Category__c='CHARGING';
		obj.Product_Code_For_Alliance_Export_File__c='1AK40746AAAA';
		
		insert obj;
		
		Alliance_Order_Export_Mapping__c obj1 = new Alliance_Order_Export_Mapping__c();
		obj1.Arcadia_Options_Product_Code__c='3HZ15362AA';
		obj1.Arcadia_Product_Code__c='833-010330_00_6';
		obj1.Main_Bundle_Product_Code__c='833-010330_00_1';
		obj1.PCI_Category__c='CHARGING';
		obj1.Product_Code_For_Alliance_Export_File__c='1AK40746AAAA';
		insert obj1;
 
		Alliance_Order_Export_Mapping__c obj3 = new Alliance_Order_Export_Mapping__c();
		obj3.Arcadia_Options_Product_Code__c='3HZ16084AAAA';
		obj3.Arcadia_Product_Code__c='833-010330_00_6';
		obj3.Main_Bundle_Product_Code__c='833-051870_00_1';
		obj3.PCI_Category__c='CE';
		obj3.Product_Code_For_Alliance_Export_File__c='3HZ16084AAAA';
		insert obj3;
		
		Alliance_Order_Export_Mapping__c obj2 = new Alliance_Order_Export_Mapping__c();
		obj2.Arcadia_Options_Product_Code__c='';
		obj2.Arcadia_Product_Code__c='833-010330_00_6';
		obj2.Main_Bundle_Product_Code__c='833-010330_00_1';
		obj2.PCI_Category__c='CHARGING';
		obj2.Product_Code_For_Alliance_Export_File__c='1AK40746AEAA';
		insert obj2;
		
		
		
		Quote_Delivery_Sales_Item__c salesitem= new Quote_Delivery_Sales_Item__c();
		salesitem.Arcadia_Product_Code__c='833-010330_00_2';
		salesitem.Product_Code__c='833-010330_00_2';
		salesitem.Quantity__c=200;
		salesitem.Item_Type__c='Order';
		salesitem.PCI_Code__c='SPS-ALU-PR-SW-PCI';
		salesitem.Proposal__c= proposals.Id;
		salesitem.Parent_Line_Item__c=prodConfigsLineItems[4].Id;
		salesitem.Name='2-ARC00010AA-1';
		insert salesitem;
		
		
		 Quote_Delivery_Sales_Item__c salesitem2= new Quote_Delivery_Sales_Item__c();
		salesitem2.Arcadia_Product_Code__c='833-010330_00_2';
		salesitem2.Product_Code__c='833-010330_00_Test2';
		salesitem2.Quantity__c=200;
		salesitem2.Item_Type__c='Order';
		salesitem2.PCI_Code__c='SPS-ALU-PR-SW-PCI';
		salesitem2.Proposal__c= proposals.Id;
		salesitem2.Parent_Line_Item__c=prodConfigsLineItems[4].Id;
		salesitem2.Name='2-ARC00010AA-1';
		insert salesitem2;
		
		
		
		
		List<Apttus_QPConfig__ProposalProductAttributeValue__c> pavList = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Apttus_QPConfig__ProposalProductAttributeValue__c pav1 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
		pav1.How_is_the_software_to_be_delivered__c = 'Physically';
		pav1.Apttus_QPConfig__LineItemId__c = proposalLineItemList[0].Id;
		pavList.add(pav1);
		
		Apttus_QPConfig__ProposalProductAttributeValue__c pav2 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
		pav2.How_is_the_software_to_be_delivered__c = 'Physically';
		pav2.Apttus_QPConfig__LineItemId__c = proposalLineItemList[1].Id;
		pavList.add(pav2);
		
		Apttus_QPConfig__ProposalProductAttributeValue__c pav3 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
		pav3.How_is_the_software_to_be_delivered__c = 'Physically';
		pav3.Apttus_QPConfig__LineItemId__c = proposalLineItemList[2].Id;
		pavList.add(pav3);
		
		insert pavList;
		
		
		Additional_Mapping_For_Alliance__c objAlliance = new Additional_Mapping_For_Alliance__c();
		objAlliance.Business_Unit__c='L36070';
		objAlliance.Main_Product_Code__c='833-051870_00_1';
		objAlliance.Product_acronym__c='Smart Plan Suite (SPS)';
		objAlliance.Product_Line_Profit_Center__c='A000506';
		objAlliance.Product_release_acronym__c='ALL';
		objAlliance.Sourcing_Unit__c='FI-FI1';
		objAlliance.What_Group_1__c='MAT_IPP_EDC';
		insert objAlliance;
		 
		Map<String, Additional_Mapping_For_Alliance__c> mapAdditionalMappingAlliance = new Map<String, Additional_Mapping_For_Alliance__c>();
		mapAdditionalMappingAlliance.put('Test',objAlliance);
		
		NokiaCPQ_CSP_ordering_export_mapping__c cspMap = new NokiaCPQ_CSP_ordering_export_mapping__c();
		cspMap.Parent_Product__c = 'AirScale WiFi';
		cspMap.PCI_Type__c = 'Equipment PCI';
		cspMap.PCI_Code__c = 'FC20002';
		cspMap.PCI_Description__c = 'WI-FI Controller SW Physical Delivery';
		cspMap.PName1__c = 'How_is_the_software_to_be_delivered__c';
		cspMap.Pvalue1__c = 'Physically';
		cspMap.Rule__c = 'FC21001,FC21002,FC21006,FC21007,SPS-ALU-PR-SW-PCI,FC21019,FC21020,FC21008,FC21009,FC21011,FC21012.T,FC21010,FC21013.T,FC21014,FC21015,FC21013,FC21016,FC21017,FC21015.T,FC21022,FC21021,FC21018,FC21017.T,FC21025,FC21024,FC21023,FC21028,FC21029,FC21027,FC21026,FC21030,FC22003.T,FC22005.T,FC22013.T,FC22015.T,FC22004.T,FC22017.T,FC23005.T,FC23004.T,FC23003.T,FC23013.T,FC23015.T,FC23012.T,FC23017.T,FC22021.T,FC22023.T,FC22027.T,FC22029.T,FC22025.T,FC23021.T,FC23025.T,FC23023.T,FC23029.T,FC23027.T,FC21031,FC21033,FC21032,FC21034,FC21035,FC21036,FC21037,FC21038,FC21039,FC21040,FC21041,FC21042,FC21043,FC21044,FC21003,FC21005,OEMVMSW001,OEMVMSW002,OEMVMSW003';
		cspMap.Rule_Type__c = 'Attribute';
		insert cspMap;
		
		mappingPLIMap.put(cspMap, proposalLineItemList);
		
		
		
		
		for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItemObj : proposalLineItemList){
			cspOderAndPliMap.put(proposalLineItemObj, mappingPLIMap);
		}
		  List<Order_Export_Result_For_External_System__c> oplist = new List<Order_Export_Result_For_External_System__c>();
		Order_Export_Result_For_External_System__c op = new Order_Export_Result_For_External_System__c(); 
		op.Product_Level__c='CO';
		op.Item_description__c = 'LIC, SPS POLICY, CORE, PER DEVICE, CLTU';
		op.Customer_Item_Code__c = '3HZ16092AAAA';
		op.Quantity__c = 500;
		op.Price_per_unit__c = 14.04;
		op.PO_Item_text__c = '';
		op.Quote_Id__c = proposals.id;
		op.External_System_Name__c = Nokia_CPQ_Constants.QUOTE_EXTERNAL_TARGET_SYSTEM_ALLIANCE ;
		op.Item_code__c='FP_MF02_MAT_EXTER';
		insert op;
		oplist.add(op);
		 Test.startTest();
		OrderExportProvider.generateAllianceOrderExportRecord('CO','1','On-Site-Training Wavespot Capt.Portal 1dy','OEMWSWMAINT07',1.0,10.0,'FP_SF03_NE_S_INTEG','','a3k210000009Dq0AAE','Alliance','','','','','1','sCPQ','','1a3i21000000AgLZAA0-CO-1','sCPQ','18.US.833457 Q 43','1');
		OrderExportProvider.deleteExistingAllianceOrderData(oplist);
		
		 OrderExportProvider.intiateExportForAllianceSystem(Nokia_CPQ_Constants.ALLIANCE_EXPORT_SUCCESS_STRING,proposals.id);
		 
		   OrderExportProvider.gernateAllianceOrder(proposalLineItemList,Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_MESSAGE_STRING,proposals.id);
			OrderExportProvider.intiateExportForQTCSystem(proposals.id,'');
		
		
	   
	   // NokiaCPQquoteActionsController.generateReconciliationExport(proposals.id);
		Test.stopTest();
	}
	
	
	 static testmethod void testMethodCrossOrderingTestM2(){
		//Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSIFinalMap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
		//Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> PLIandAttributeMap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> finalPLImap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
		Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> finalAttributePLImap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>> mappingPLIMap = new Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>();
		Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>> cspOderAndPliMap = new Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>>();
		//create Mapping
		NokiaCPQ_CSP_Map_Control__c mapControl = new NokiaCPQ_CSP_Map_Control__c();
		
	mapControl.Name = 'Data Refinery';
		mapControl.Portfolio__c = 'Nokia Software';
		mapControl.Product_Code__c = '833-052264_00';
		mapControl.Source__c = 'External';
		//mapControl.Map_Mode__c = 'Split';
	mapControl.Splitlevel__c = '1';
		insert mapControl;
		
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();	 
		insert opportunities;			
		
		//create a quote
		Apttus_Proposal__Proposal__c  proposals = new Apttus_Proposal__Proposal__c();
		proposals.Apttus_Proposal__Account__c = accounts[0].Id;
		proposals.Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals.NokiaCPQ_Needs_Reprice__c = false;
		proposals.Reprice_In_Progress__c = false;
		proposals.RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); 
		//proposals.NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Basic';
		proposals.NokiaCPQ_No_of_Years__c = '1';
		proposals.NokiaCPQ_Portfolio__c = 'Nokia Software';
		proposals.NokiaCPQ_SSP_Level__c = '';
		insert proposals;	   
		system.debug('>>>Quote Record Type::>>'+proposals.recordtypeID);
		
		//get a Product Apttus_Config2__ConfigurationType__c  
		List <Product2> pList = NOKIA_CPQ_TestDataFactory.productCreationDirect(6);
		pList[0].NokiaCPQ_Category__c = '1000Base-SX';
		pList[0].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[0].Pricing_Clusters__c = '';
		pList[0].NokiaCPQ_State__c = 'Ramp Up';
		pList[0].NokiaCPQ_Item_Type__c = 'Service';
		pList[0].Business_Group__c='MN';		   
		pList[0].Portfolio__c = 'Nokia Software';
		pList[0].ProductCode = '833-052264_00';
		pList[0].Apttus_Config2__ConfigurationType__c = 'Bundle';
		pList[0].Is_P20_Based_Product__c = true;
		//get a Product
		pList[1].NokiaCPQ_Category__c = '1000Base-SX';
		pList[1].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[1].Pricing_Clusters__c = '';
		pList[1].NokiaCPQ_State__c = 'Ramp Up';
		pList[1].NokiaCPQ_Item_Type__c = 'Service';
		pList[1].Business_Group__c='MN';		   
		pList[1].Portfolio__c = 'Nokia Software';
		pList[1].ProductCode = '833-052264_00';
		pList[1].Apttus_Config2__ConfigurationType__c = 'Standalone';
		
		//get a Product
		pList[2].NokiaCPQ_Category__c = '1000Base-SX';
		pList[2].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[2].Pricing_Clusters__c = '';
		pList[2].NokiaCPQ_State__c = 'Ramp Up';
		pList[2].NokiaCPQ_Item_Type__c = 'Service';
		pList[2].ProductCode = 'FC21001';
		pList[2].Business_Group__c='MN';		   
		pList[2].Portfolio__c = 'Nokia Software';
		pList[2].ProductCode = 'ARC00010AA';
		pList[2].Apttus_Config2__ConfigurationType__c = 'Bundle';
		
		pList[3].NokiaCPQ_Category__c = '1000Base-SX';
		pList[3].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[3].Pricing_Clusters__c = '';
		pList[3].NokiaCPQ_State__c = 'Ramp Up';
		pList[3].NokiaCPQ_Item_Type__c = 'Service';
		pList[3].ProductCode = 'FC21001';
		pList[3].Business_Group__c='MN';		   
		pList[3].Portfolio__c = 'Nokia Software';
		pList[3].ProductCode = '833-052264_00';
		pList[3].Apttus_Config2__ConfigurationType__c = 'Bundle';
		
		pList[4].NokiaCPQ_Category__c = '1000Base-SX';
		pList[4].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[4].Pricing_Clusters__c = '';
		pList[4].NokiaCPQ_State__c = 'Ramp Up';
		pList[4].NokiaCPQ_Item_Type__c = 'Service';
		pList[4].ProductCode = 'FC21001';
		pList[4].Business_Group__c='MN';		   
		pList[4].Portfolio__c = 'Nokia Software';
		pList[4].ProductCode = '833-052264_00';
		pList[4].Apttus_Config2__ConfigurationType__c = 'Bundle';
		pList[4].Is_Dummy_Bundle_CPQ__c = 'Yes';
		
		pList[5].NokiaCPQ_Category__c = '1000Base-SX';
		pList[5].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[5].Pricing_Clusters__c = '';
		pList[5].NokiaCPQ_State__c = 'Ramp Up';
		pList[5].NokiaCPQ_Item_Type__c = 'Service';
		pList[5].ProductCode = 'FC21001';
		pList[5].Business_Group__c='MN';		   
		pList[5].Portfolio__c = 'Nokia Software';
		pList[5].ProductCode = '3HZ16085AAAA';
		pList[5].Apttus_Config2__ConfigurationType__c = 'Option';
		
		insert pList;
		
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='EUR';
		priceList.Apttus_Config2__Active__c=true;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		insert priceList;
		
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[0].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI1);
		Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[1].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI2);
		Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[2].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI3);
		Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[3].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI4);
		Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[4].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI5);
		Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[5].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI6);
		insert plistItems;
		
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals.Id;
		prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
		insert prodConfigs;
		
		List<Apttus_Config2__LineItem__c> prodConfigsLineItems = NOKIA_CPQ_TestDataFactory.createLineItem(6);
		prodConfigsLineItems[0].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[0].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[0].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[0].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[0].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[0].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[0].Apttus_Config2__ProductId__c = pList[0].Id;
		prodConfigsLineItems[0].Apttus_Config2__PriceListItemId__c = pLI1.id;
		prodConfigsLineItems[0].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[0].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[0].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[0].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[0].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[0].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[0].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[1].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[1].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[1].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[1].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[1].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[1].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[1].Apttus_Config2__ProductId__c = pList[1].Id;
		prodConfigsLineItems[1].Apttus_Config2__PriceListItemId__c = pLI2.id;
		prodConfigsLineItems[1].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[1].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[1].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[1].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[1].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[1].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[1].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[2].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[2].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[2].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[2].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[2].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[2].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[2].Apttus_Config2__ProductId__c = pList[2].Id;
		prodConfigsLineItems[2].Apttus_Config2__PriceListItemId__c = pLI3.id;
		prodConfigsLineItems[2].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[2].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[2].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[2].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[2].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[2].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[3].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[3].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[3].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[3].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[3].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[3].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[3].Apttus_Config2__ProductId__c = pList[3].Id;
		prodConfigsLineItems[3].Apttus_Config2__PriceListItemId__c = pLI4.id;
		prodConfigsLineItems[3].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[3].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[3].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[3].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[3].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[3].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[4].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[4].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[4].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[4].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[4].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[4].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[4].Apttus_Config2__ProductId__c = pList[4].Id;
		prodConfigsLineItems[4].Apttus_Config2__PriceListItemId__c = pLI5.id;
		prodConfigsLineItems[4].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[4].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[4].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[4].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[4].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[4].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[5].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[5].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[5].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[5].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[5].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[5].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[5].Apttus_Config2__ProductId__c = pList[5].Id;
		prodConfigsLineItems[5].Apttus_Config2__PriceListItemId__c = pLI6.id;
		prodConfigsLineItems[5].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[5].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[5].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[5].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[5].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[5].Apttus_Config2__AddedBy__c = 'added by code';
		insert prodConfigsLineItems;
		
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(6);
		proposalLineItemList[0].NokiaCPQ_Spare__c = false;
		proposalLineItemList[0].Apttus_Proposal__Product__c  = pList[0].Id;
		proposalLineItemList[0].Apttus_QPConfig__OptionId__c = pList[0].Id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[0].Apttus_QPConfig__ParentBundleNumber__c = Null;
		proposalLineItemList[0].NokiaCPQ_Configuration_Type__c = 'Bundle';
		proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[0].Custom_Product_Code__c = '833-052264_00';
		proposalLineItemList[0].is_Custom_Product__c = false;
		proposalLineItemList[0].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[0].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[0].Apttus_QPConfig__PrimaryLineNumber__c = 1;
		proposalLineItemList[0].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[0].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[0].id;
		proposalLineItemList[0].Apttus_QPConfig__IsPrimaryLine__c = true;
		
		proposalLineItemList[1].NokiaCPQ_Spare__c = false;
		proposalLineItemList[1].Apttus_Proposal__Product__c  = pList[1].Id;
		proposalLineItemList[1].Apttus_QPConfig__OptionId__c = pList[1].Id;
		proposalLineItemList[1].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[1].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[1].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[1].Custom_Product_Code__c = '833-052264_00';
		proposalLineItemList[1].is_Custom_Product__c = false;
		proposalLineItemList[1].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[1].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[1].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[1].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[1].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[1].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[1].id;
		proposalLineItemList[1].Apttus_QPConfig__IsPrimaryLine__c = true;
		
		proposalLineItemList[2].NokiaCPQ_Spare__c = false;
		proposalLineItemList[2].Apttus_Proposal__Product__c  = pList[2].Id;
		proposalLineItemList[2].Apttus_QPConfig__OptionId__c = pList[2].Id;
		proposalLineItemList[2].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[2].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[2].NokiaCPQ_Configuration_Type__c = 'Bundle';
		proposalLineItemList[2].Custom_Product_Code__c = 'ARC00010AA';
		proposalLineItemList[2].is_Custom_Product__c = false;
		proposalLineItemList[2].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[2].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[2].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[2].Apttus_QPConfig__PrimaryLineNumber__c = 3;
		proposalLineItemList[2].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[2].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[2].id;
		proposalLineItemList[2].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[2].NokiaCPQ_IsArcadiaBundle__c = true;
		proposalLineItemList[2].PCI_Code__c = 'SPS-ALU-PR-SW-PCI';
		
		proposalLineItemList[3].NokiaCPQ_Spare__c = false;
		proposalLineItemList[3].Apttus_Proposal__Product__c  = pList[3].Id;
		proposalLineItemList[3].Apttus_QPConfig__OptionId__c = pList[3].Id;
		proposalLineItemList[3].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 3;
		proposalLineItemList[3].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[3].Custom_Product_Code__c = '833-052264_00';
		proposalLineItemList[3].is_Custom_Product__c = false;
		proposalLineItemList[3].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[3].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[3].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[3].Apttus_QPConfig__PrimaryLineNumber__c = 4;
		proposalLineItemList[3].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[3].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[3].id;
		proposalLineItemList[3].Apttus_QPConfig__IsPrimaryLine__c = true;
		
		proposalLineItemList[4].NokiaCPQ_Spare__c = false;
		proposalLineItemList[4].Apttus_Proposal__Product__c  = pList[4].Id;
		proposalLineItemList[4].Apttus_QPConfig__OptionId__c = pList[4].Id;
		proposalLineItemList[4].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[4].Apttus_QPConfig__ParentBundleNumber__c = 3;
		proposalLineItemList[4].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[4].Custom_Product_Code__c = '833-052264_00';
		proposalLineItemList[4].is_Custom_Product__c = false;
		proposalLineItemList[4].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[4].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[4].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[4].Apttus_QPConfig__PrimaryLineNumber__c = 5;
		proposalLineItemList[4].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[4].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[4].id;
		proposalLineItemList[4].Apttus_QPConfig__IsPrimaryLine__c = true;
		
		proposalLineItemList[5].NokiaCPQ_Spare__c = false;
		proposalLineItemList[5].Apttus_Proposal__Product__c  = pList[5].Id;
		proposalLineItemList[5].Apttus_QPConfig__OptionId__c = pList[5].Id;
		proposalLineItemList[5].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[5].Apttus_QPConfig__ParentBundleNumber__c = 5;
		proposalLineItemList[5].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[5].Custom_Product_Code__c = '833-052264_00';
		proposalLineItemList[5].is_Custom_Product__c = false;
		proposalLineItemList[5].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[5].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[5].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[5].Apttus_QPConfig__PrimaryLineNumber__c = 6;
		proposalLineItemList[5].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[5].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[5].id;
		proposalLineItemList[5].Apttus_QPConfig__IsPrimaryLine__c = true;
		
		
		insert proposalLineItemList;
		System.debug('proposalLineItemList[0] : '+proposalLineItemList[0]);
		System.debug('proposalLineItemList[1] : '+proposalLineItemList[1]);
		System.debug('proposalLineItemList[2] : '+proposalLineItemList[2]);
		
		Quote_Delivery_Sales_Item__c salesitem= new Quote_Delivery_Sales_Item__c();
		salesitem.Arcadia_Product_Code__c='ARC00010AA';
		salesitem.Product_Code__c='3HZ16085AAAA';
		salesitem.Quantity__c=200;
		salesitem.Item_Type__c='Order';
		salesitem.PCI_Code__c='FC20002';
		salesitem.Proposal__c= proposals.Id;
		salesitem.Parent_Line_Item__c=prodConfigsLineItems[2].Id;
		salesitem.Name='2-ARC00010AA-1';
		insert salesitem;
		
		List<Apttus_QPConfig__ProposalProductAttributeValue__c> pavList = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Apttus_QPConfig__ProposalProductAttributeValue__c pav1 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
		pav1.How_is_the_software_to_be_delivered__c = 'Physically';
		pav1.Apttus_QPConfig__LineItemId__c = proposalLineItemList[0].Id;
		pavList.add(pav1);
		
		Apttus_QPConfig__ProposalProductAttributeValue__c pav2 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
		pav2.How_is_the_software_to_be_delivered__c = 'Physically';
		pav2.Apttus_QPConfig__LineItemId__c = proposalLineItemList[1].Id;
		pavList.add(pav2);
		
		Apttus_QPConfig__ProposalProductAttributeValue__c pav3 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
		pav3.How_is_the_software_to_be_delivered__c = 'Physically';
		pav3.Apttus_QPConfig__LineItemId__c = proposalLineItemList[2].Id;
		pavList.add(pav3);
		
		insert pavList;
		
		NokiaCPQ_CSP_ordering_export_mapping__c cspMap = new NokiaCPQ_CSP_ordering_export_mapping__c();
		cspMap.Parent_Product__c = 'Data Refinery';
		cspMap.PCI_Type__c = 'Equipment PCI';
		cspMap.PCI_Code__c = 'FC20002';
		cspMap.PCI_Description__c = 'WI-FI Controller SW Physical Delivery';
		cspMap.PName1__c = 'How_is_the_software_to_be_delivered__c';
		cspMap.Pvalue1__c = 'Physically';
		cspMap.Rule__c = 'FC21001,FC21002,FC21006,FC21007,FC21019,FC21020,FC21008,FC21009,FC21011,FC21012.T,FC21010,FC21013.T,FC21014,FC21015,FC21013,FC21016,FC21017,FC21015.T,FC21022,FC21021,FC21018,FC21017.T,FC21025,FC21024,FC21023,FC21028,FC21029,FC21027,FC21026,FC21030,FC22003.T,FC22005.T,FC22013.T,FC22015.T,FC22004.T,FC22017.T,FC23005.T,FC23004.T,FC23003.T,FC23013.T,FC23015.T,FC23012.T,FC23017.T,FC22021.T,FC22023.T,FC22027.T,FC22029.T,FC22025.T,FC23021.T,FC23025.T,FC23023.T,FC23029.T,FC23027.T,FC21031,FC21033,FC21032,FC21034,FC21035,FC21036,FC21037,FC21038,FC21039,FC21040,FC21041,FC21042,FC21043,FC21044,FC21003,FC21005,OEMVMSW001,OEMVMSW002,OEMVMSW003';
		cspMap.Rule_Type__c = 'Attribute';
		insert cspMap;
		
		mappingPLIMap.put(cspMap, proposalLineItemList);
		
		for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItemObj : proposalLineItemList){
			cspOderAndPliMap.put(proposalLineItemObj, mappingPLIMap);
		}
		
		Additional_Mapping_For_Alliance__c objAlliance = new Additional_Mapping_For_Alliance__c();
		objAlliance.Business_Unit__c='L36070';
		objAlliance.Main_Product_Code__c='833-052264_00';
		objAlliance.Product_acronym__c='Smart Plan Suite (SPS)';
		objAlliance.Product_Line_Profit_Center__c='A000506';
		objAlliance.Product_release_acronym__c='ALL';
		objAlliance.Sourcing_Unit__c='FI-FI1';
		objAlliance.What_Group_1__c='MAT_IPP_EDC';
		insert objAlliance;
		 
		Map<String, Additional_Mapping_For_Alliance__c> mapAdditionalMappingAlliance = new Map<String, Additional_Mapping_For_Alliance__c>();
		mapAdditionalMappingAlliance.put('Test',objAlliance);
		
		//finalAttributePLImap.put(pav.Apttus_QPConfig__LineItemId__c,pav);
		Test.startTest();
		 OrderExportProvider.intiateExportForAllianceSystem(Nokia_CPQ_Constants.ALLIANCE_EXPORT_SUCCESS_STRING,proposals.id);
	   // NokiaCPQ_CSP_Export_Generator.PLIbundleOptionMapping(proposals.id);
		//NokiaCPQ_CSP_Export_Generator.PLIbundleOptionMapping(NULL);
		Test.stopTest();
	}
	
	static testmethod void testMethodCSPStandaloneTestM3(){
		//Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSIFinalMap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
		//Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> PLIandAttributeMap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> finalPLImap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
		Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> finalAttributePLImap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>> mappingPLIMap = new Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>();
		Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>> cspOderAndPliMap = new Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>>();
		//create Mapping
		NokiaCPQ_CSP_Map_Control__c mapControl = new NokiaCPQ_CSP_Map_Control__c();
		
	mapControl.Name = 'Data Refinery';
		mapControl.Portfolio__c = 'Nokia Software';
		mapControl.Product_Code__c = '833-052264_00';
		mapControl.Source__c = 'External';
		//mapControl.Map_Mode__c = 'Split';
	mapControl.Splitlevel__c = '1';
		insert mapControl;
		
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();	 
		insert opportunities;			
		
		//create a quote
		Apttus_Proposal__Proposal__c  proposals = new Apttus_Proposal__Proposal__c();
		proposals.Apttus_Proposal__Account__c = accounts[0].Id;
		proposals.Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals.NokiaCPQ_Needs_Reprice__c = false;
		proposals.Reprice_In_Progress__c = false;
		proposals.RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); 
		//proposals.NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Basic';
		proposals.NokiaCPQ_No_of_Years__c = '1';
		proposals.NokiaCPQ_Portfolio__c = 'Nokia Software';
		proposals.NokiaCPQ_SSP_Level__c = '';
		insert proposals;	   
		system.debug('>>>Quote Record Type::>>'+proposals.recordtypeID);
		
		//get a Product Apttus_Config2__ConfigurationType__c  
		List <Product2> pList = NOKIA_CPQ_TestDataFactory.productCreationDirect(1);
		pList[0].NokiaCPQ_Category__c = '1000Base-SX';
		pList[0].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[0].Pricing_Clusters__c = '';
		pList[0].NokiaCPQ_State__c = 'Ramp Up';
		pList[0].NokiaCPQ_Item_Type__c = 'Service';
		pList[0].Business_Group__c='MN';		   
		pList[0].Portfolio__c = 'Nokia Software';
		pList[0].ProductCode = '833-052264_00';
		pList[0].Apttus_Config2__ConfigurationType__c = 'Standalone';
		pList[0].NokiaCPQ_Classification2__c ='Deploy Services';
		 pList[0].NokiaCPQ_Item_Type__c=Nokia_CPQ_Constants.SERVICE_STRING;
	   
		
		
		
		insert pList;
		
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='EUR';
		priceList.Apttus_Config2__Active__c=true;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		insert priceList;
		
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[0].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI1);
	   
		insert plistItems;
		
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals.Id;
		prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
		insert prodConfigs;
		
		List<Apttus_Config2__LineItem__c> prodConfigsLineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
		prodConfigsLineItems[0].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[0].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[0].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[0].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[0].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[0].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[0].Apttus_Config2__ProductId__c = pList[0].Id;
		prodConfigsLineItems[0].Apttus_Config2__PriceListItemId__c = pLI1.id;
		prodConfigsLineItems[0].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[0].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[0].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[0].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[0].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[0].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[0].Apttus_Config2__AddedBy__c = 'added by code';
		
	  
		insert prodConfigsLineItems;
		
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList[0].NokiaCPQ_Spare__c = false;
		proposalLineItemList[0].Apttus_Proposal__Product__c  = pList[0].Id;
		proposalLineItemList[0].Apttus_QPConfig__OptionId__c = pList[0].Id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[0].Apttus_QPConfig__ParentBundleNumber__c = Null;
		proposalLineItemList[0].NokiaCPQ_Configuration_Type__c = Nokia_CPQ_Constants.NOKIA_STANDALONE;
		proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[0].Custom_Product_Code__c = '833-052264_00';
		proposalLineItemList[0].is_Custom_Product__c = false;
		//proposalLineItemList[0].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[0].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[0].Apttus_QPConfig__PrimaryLineNumber__c = 1;
		proposalLineItemList[0].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[0].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[0].id;
		proposalLineItemList[0].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[0].Apttus_QPConfig__ChargeType__c = Nokia_CPQ_Constants.STANDARD;
	  //  proposalLineItemList[0].NokiaCPQ_Item_Type__c = Nokia_CPQ_Constants.SERVICE_STRING;
		  
	  
		
		insert proposalLineItemList;
		System.debug('proposalLineItemList[0] : '+proposalLineItemList[0]);
	   
		
		Quote_Delivery_Sales_Item__c salesitem= new Quote_Delivery_Sales_Item__c();
		salesitem.Arcadia_Product_Code__c='ARC00010AA';
		salesitem.Product_Code__c='3HZ16085AAAA';
		salesitem.Quantity__c=200;
		salesitem.Item_Type__c='Order';
		salesitem.PCI_Code__c='FC20002';
		salesitem.Proposal__c= proposals.Id;
		salesitem.Parent_Line_Item__c=prodConfigsLineItems[0].Id;
		salesitem.Name='2-ARC00010AA-1';
		insert salesitem;
		
		List<Apttus_QPConfig__ProposalProductAttributeValue__c> pavList = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Apttus_QPConfig__ProposalProductAttributeValue__c pav1 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
		pav1.How_is_the_software_to_be_delivered__c = 'Physically';
		pav1.Apttus_QPConfig__LineItemId__c = proposalLineItemList[0].Id;
		pavList.add(pav1);
		
		Apttus_QPConfig__ProposalProductAttributeValue__c pav2 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
		pav2.How_is_the_software_to_be_delivered__c = 'Physically';
		pav2.Apttus_QPConfig__LineItemId__c = proposalLineItemList[0].Id;
		pavList.add(pav2);
		
		Apttus_QPConfig__ProposalProductAttributeValue__c pav3 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
		pav3.How_is_the_software_to_be_delivered__c = 'Physically';
		pav3.Apttus_QPConfig__LineItemId__c = proposalLineItemList[0].Id;
		pavList.add(pav3);
		
		insert pavList;
		
		NokiaCPQ_CSP_ordering_export_mapping__c cspMap = new NokiaCPQ_CSP_ordering_export_mapping__c();
		cspMap.Parent_Product__c = 'Data Refinery';
		cspMap.PCI_Type__c = 'Equipment PCI';
		cspMap.PCI_Code__c = 'FC20002';
		cspMap.PCI_Description__c = 'WI-FI Controller SW Physical Delivery';
		cspMap.PName1__c = 'How_is_the_software_to_be_delivered__c';
		cspMap.Pvalue1__c = 'Physically';
		cspMap.Rule__c = 'FC21001,FC21002,FC21006,FC21007,FC21019,FC21020,FC21008,FC21009,FC21011,FC21012.T,FC21010,FC21013.T,FC21014,FC21015,FC21013,FC21016,FC21017,FC21015.T,FC21022,FC21021,FC21018,FC21017.T,FC21025,FC21024,FC21023,FC21028,FC21029,FC21027,FC21026,FC21030,FC22003.T,FC22005.T,FC22013.T,FC22015.T,FC22004.T,FC22017.T,FC23005.T,FC23004.T,FC23003.T,FC23013.T,FC23015.T,FC23012.T,FC23017.T,FC22021.T,FC22023.T,FC22027.T,FC22029.T,FC22025.T,FC23021.T,FC23025.T,FC23023.T,FC23029.T,FC23027.T,FC21031,FC21033,FC21032,FC21034,FC21035,FC21036,FC21037,FC21038,FC21039,FC21040,FC21041,FC21042,FC21043,FC21044,FC21003,FC21005,OEMVMSW001,OEMVMSW002,OEMVMSW003';
		cspMap.Rule_Type__c = 'Attribute';
		insert cspMap;
		
		mappingPLIMap.put(cspMap, proposalLineItemList);
		
		for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItemObj : proposalLineItemList){
			cspOderAndPliMap.put(proposalLineItemObj, mappingPLIMap);
		}
		//finalAttributePLImap.put(pav.Apttus_QPConfig__LineItemId__c,pav);
		
		Additional_Mapping_For_Alliance__c objAlliance = new Additional_Mapping_For_Alliance__c();
		objAlliance.Business_Unit__c='L36070';
		objAlliance.Main_Product_Code__c='833-051870_00_1';
		objAlliance.Product_acronym__c='Smart Plan Suite (SPS)';
		objAlliance.Product_Line_Profit_Center__c='A000506';
		objAlliance.Product_release_acronym__c='ALL';
		objAlliance.Sourcing_Unit__c='FI-FI1';
		objAlliance.What_Group_1__c='MAT_IPP_EDC';
		insert objAlliance;
		 
		Map<String, Additional_Mapping_For_Alliance__c> mapAdditionalMappingAlliance = new Map<String, Additional_Mapping_For_Alliance__c>();
		mapAdditionalMappingAlliance.put('Test',objAlliance);
		Test.startTest();
		 OrderExportProvider.intiateExportForAllianceSystem(Nokia_CPQ_Constants.ALLIANCE_EXPORT_SUCCESS_STRING,proposals.id);
	   // NokiaCPQ_CSP_Export_Generator.PLIbundleOptionMapping(proposals.id);
		//NokiaCPQ_CSP_Export_Generator.PLIbundleOptionMapping(NULL);
		Test.stopTest();
	}
	
	 /*static testmethod void getPLIbundleOptionMapping_testException(){
	
		OrderExportProvider.intiateExportForQTCSystem('0012200000GdoWk','');
	
	}*/
	
	
	  static testmethod void getPLIbundleOptionMapping_elseparttestMethod4(){
		//Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSIFinalMap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
		//Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> PLIandAttributeMap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> finalPLImap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
		Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> finalAttributePLImap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>> mappingPLIMap = new Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>();
		Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>> cspOderAndPliMap = new Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>>();
		//create Mapping
		NokiaCPQ_CSP_Map_Control__c mapControl = new NokiaCPQ_CSP_Map_Control__c();
		
		mapControl.Portfolio__c = 'Nokia Software';
		mapControl.Product_Code__c = '833-010330_00';
		mapControl.Source__c = 'External';
		//mapControl.Map_Mode__c = n;
		insert mapControl;
		
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();	 
		insert opportunities;			
		
		//create a quote
		Apttus_Proposal__Proposal__c  proposals = new Apttus_Proposal__Proposal__c();
		proposals.Apttus_Proposal__Account__c = accounts[0].Id;
		proposals.Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals.NokiaCPQ_Needs_Reprice__c = false;
		proposals.Reprice_In_Progress__c = false;
		proposals.RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); 
	   // proposals.NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Enhanced Emergency';
		proposals.NokiaCPQ_No_of_Years__c = '1';
		proposals.NokiaCPQ_Portfolio__c = 'Nokia Software';
		proposals.NokiaCPQ_SSP_Level__c = '';
		insert proposals;	   
		system.debug('>>>Quote Record Type::>>'+proposals.recordtypeID);
		
		//get a Product Apttus_Config2__ConfigurationType__c  
		List <Product2> pList = NOKIA_CPQ_TestDataFactory.productCreationDirect(6);
		pList[0].NokiaCPQ_Category__c = '1000Base-SX';
		pList[0].NokiaCPQ_Product_Discount_Category__c = '';
	   
		pList[0].Pricing_Clusters__c = '';
		pList[0].NokiaCPQ_State__c = 'Ramp Up';
		pList[0].NokiaCPQ_Item_Type__c = 'Service';
		pList[0].Business_Group__c='MN';		   
		pList[0].Portfolio__c = 'Nokia Software';
		pList[0].ProductCode = '833-051870_00_1';
		pList[0].Apttus_Config2__ConfigurationType__c = 'Bundle';
		
		//get a Product
		pList[1].NokiaCPQ_Category__c = '1000Base-SX';
		pList[1].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[1].Pricing_Clusters__c = '';
		pList[1].NokiaCPQ_State__c = 'Ramp Up';
		pList[1].NokiaCPQ_Item_Type__c = 'Service';
		pList[1].Business_Group__c='MN';		   
		pList[1].Portfolio__c = 'Nokia Software';
		pList[1].ProductCode = '833-010330_00_2';
		pList[1].Apttus_Config2__ConfigurationType__c = 'Standalone';
		pList[1].NokiaCPQ_Classification2__c='Deploy Services';
	   
		
		//get a Product
		pList[2].NokiaCPQ_Category__c = '1000Base-SX';
		pList[2].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[2].Pricing_Clusters__c = '';
		pList[2].NokiaCPQ_State__c = 'Ramp Up';
		pList[2].NokiaCPQ_Item_Type__c = 'Service';
		pList[2].ProductCode = 'FC21001';
		pList[2].Business_Group__c='MN';		   
		pList[2].Portfolio__c = 'Nokia Software';
		pList[2].ProductCode = '833-010330_00_3';
		pList[2].Apttus_Config2__ConfigurationType__c = 'Bundle';
		pList[2].Is_P20_Based_Product__c=true;
		
		pList[3].NokiaCPQ_Category__c = '1000Base-SX';
		pList[3].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[3].Pricing_Clusters__c = '';
		pList[3].NokiaCPQ_State__c = 'Ramp Up';
		pList[3].NokiaCPQ_Item_Type__c = 'Service';
		pList[3].ProductCode = 'FC21001';
		pList[3].Business_Group__c='MN';		   
		pList[3].Portfolio__c = 'Nokia Software';
		pList[3].ProductCode = '833-010330_00_4';
		pList[3].Apttus_Config2__ConfigurationType__c = 'Bundle';
		
		pList[4].NokiaCPQ_Category__c = '1000Base-SX';
		pList[4].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[4].Pricing_Clusters__c = '';
		pList[4].NokiaCPQ_State__c = 'Ramp Up';
		pList[4].NokiaCPQ_Item_Type__c = 'Service';
	   // pList[4].ProductCode = 'FC21001';
		pList[4].Business_Group__c='MN';		   
		pList[4].Portfolio__c = 'Nokia Software';
		pList[4].ProductCode = '833-010330_00_5';
		pList[4].Apttus_Config2__ConfigurationType__c = 'Bundle';
		pList[4].Is_Dummy_Bundle_CPQ__c = 'Yes';
	   // pList[4].Is_P20_Based_Product__c=true;
		
		pList[5].NokiaCPQ_Category__c = '1000Base-SX';
		pList[5].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[5].Pricing_Clusters__c = '';
		pList[5].NokiaCPQ_State__c = 'Ramp Up';
		pList[5].NokiaCPQ_Item_Type__c = 'Service';
		pList[5].ProductCode = '833-010330_00_6';
		pList[5].Business_Group__c='MN';		   
		pList[5].Portfolio__c = 'Nokia Software';
	 //   pList[5].ProductCode = '833-010330_00_1';
		pList[5].Apttus_Config2__ConfigurationType__c = 'Option';
		
		insert pList;
		
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='EUR';
		priceList.Apttus_Config2__Active__c=true;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		insert priceList;
		
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[0].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI1);
		Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[1].Id, 
			
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI2);
		Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[2].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI3);
		Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[3].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI4);
		Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[4].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI5);
		Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[5].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI6);
		insert plistItems;
		
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals.Id;
		prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
		insert prodConfigs;
		
		List<Apttus_Config2__LineItem__c> prodConfigsLineItems = NOKIA_CPQ_TestDataFactory.createLineItem(6);
		prodConfigsLineItems[0].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[0].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[0].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[0].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[0].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[0].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[0].Apttus_Config2__ProductId__c = pList[0].Id;
		prodConfigsLineItems[0].Apttus_Config2__PriceListItemId__c = pLI1.id;
		prodConfigsLineItems[0].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[0].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[0].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[0].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[0].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[0].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[0].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[1].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[1].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[1].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[1].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[1].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[1].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[1].Apttus_Config2__ProductId__c = pList[1].Id;
		prodConfigsLineItems[1].Apttus_Config2__PriceListItemId__c = pLI2.id;
		prodConfigsLineItems[1].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[1].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[1].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[1].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[1].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[1].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[1].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[2].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[2].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[2].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[2].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[2].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[2].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[2].Apttus_Config2__ProductId__c = pList[2].Id;
		prodConfigsLineItems[2].Apttus_Config2__PriceListItemId__c = pLI3.id;
		prodConfigsLineItems[2].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[2].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[2].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[2].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[2].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[2].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[3].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[3].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[3].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[3].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[3].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[3].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[3].Apttus_Config2__ProductId__c = pList[3].Id;
		prodConfigsLineItems[3].Apttus_Config2__PriceListItemId__c = pLI4.id;
		prodConfigsLineItems[3].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[3].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[3].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[3].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[3].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[3].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[4].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[4].Apttus_Config2__LineNumber__c =1;
		prodConfigsLineItems[4].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[4].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[4].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[4].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[4].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[4].Apttus_Config2__ProductId__c = pList[4].Id;
		prodConfigsLineItems[4].Apttus_Config2__PriceListItemId__c = pLI5.id;
		prodConfigsLineItems[4].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[4].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[4].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[4].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[4].Apttus_Config2__PrimaryLineNumber__c =1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[4].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[5].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[5].Apttus_Config2__LineSequence__c = 6;
		prodConfigsLineItems[5].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[5].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[5].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[5].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[5].Apttus_Config2__ProductId__c = pList[5].Id;
		prodConfigsLineItems[5].Apttus_Config2__PriceListItemId__c = pLI6.id;
		prodConfigsLineItems[5].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[5].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[5].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[5].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[5].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[5].Apttus_Config2__AddedBy__c = 'added by code';
		insert prodConfigsLineItems;
		
		
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(6);
		proposalLineItemList[0].NokiaCPQ_Spare__c = false;
		proposalLineItemList[0].Apttus_Proposal__Product__c  = pList[0].Id;
		proposalLineItemList[0].Apttus_QPConfig__OptionId__c = pList[0].Id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[0].Apttus_QPConfig__ParentBundleNumber__c = Null;
		proposalLineItemList[0].NokiaCPQ_Configuration_Type__c = 'Bundle';
		proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'Product Service';
		proposalLineItemList[0].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[0].is_Custom_Product__c = false;
		proposalLineItemList[0].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[0].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[0].Apttus_QPConfig__PrimaryLineNumber__c = 1;
		proposalLineItemList[0].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[0].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[0].id;
		proposalLineItemList[0].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[0].NokiaCPQ_ExtendedPrice_CNP__c = 10;
		proposalLineItemList[0].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[0].Total_Option_Quantity__c=1;
		
		
		proposalLineItemList[1].NokiaCPQ_Spare__c = false;
		proposalLineItemList[1].Apttus_Proposal__Product__c  = pList[1].Id;
		proposalLineItemList[1].Apttus_QPConfig__OptionId__c = pList[1].Id;
		proposalLineItemList[1].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[1].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[1].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[1].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[1].is_Custom_Product__c = false;
		proposalLineItemList[1].Apttus_QPConfig__LineType__c = 'Product Service';
		proposalLineItemList[1].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[1].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[1].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[1].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[1].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[1].id;
		proposalLineItemList[1].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[1].NokiaCPQ_ExtendedPrice_CNP__c = 10;
		proposalLineItemList[1].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[1].Total_Option_Quantity__c=1;
		
		proposalLineItemList[2].NokiaCPQ_Spare__c = false;
		proposalLineItemList[2].Apttus_Proposal__Product__c  = pList[2].Id;
		proposalLineItemList[2].Apttus_QPConfig__OptionId__c = pList[2].Id;
		proposalLineItemList[2].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[2].Apttus_QPConfig__ParentBundleNumber__c = null;
		proposalLineItemList[2].NokiaCPQ_Configuration_Type__c = 'Bundle';
		proposalLineItemList[2].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[2].is_Custom_Product__c = false;
		proposalLineItemList[2].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[2].NokiaCPQ_Is_Direct_Option__c  = true;
		proposalLineItemList[2].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[2].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[2].Apttus_QPConfig__PrimaryLineNumber__c = 3;
		proposalLineItemList[2].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[2].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[2].id;
		proposalLineItemList[2].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[2].NokiaCPQ_IsArcadiaBundle__c = true;
		proposalLineItemList[2].NokiaCPQ_ExtendedPrice_CNP__c = 10;
		proposalLineItemList[2].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[2].Total_Option_Quantity__c=1;
		
		proposalLineItemList[3].NokiaCPQ_Spare__c = false;
		proposalLineItemList[3].Apttus_Proposal__Product__c  = pList[3].Id;
		proposalLineItemList[3].Apttus_QPConfig__OptionId__c = pList[3].Id;
		proposalLineItemList[3].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 3;
		proposalLineItemList[3].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[3].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[3].is_Custom_Product__c = false;
		proposalLineItemList[3].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[3].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[3].Apttus_QPConfig__LineNumber__c = 4;
		proposalLineItemList[3].Apttus_QPConfig__PrimaryLineNumber__c = 4;
		proposalLineItemList[3].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[3].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[3].id;
		proposalLineItemList[3].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[3].NokiaCPQ_ExtendedPrice_CNP__c = 10;
		proposalLineItemList[3].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[3].Total_Option_Quantity__c=1;
		
		proposalLineItemList[4].NokiaCPQ_Spare__c = false;
		proposalLineItemList[4].Apttus_Proposal__Product__c  = pList[4].Id;
		proposalLineItemList[4].Apttus_QPConfig__OptionId__c = pList[4].Id;
		proposalLineItemList[4].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[4].Apttus_QPConfig__ParentBundleNumber__c = 3;
		proposalLineItemList[4].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[4].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[4].is_Custom_Product__c = false;
		proposalLineItemList[4].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[4].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[4].Apttus_QPConfig__LineNumber__c = 5;
		proposalLineItemList[4].Apttus_QPConfig__PrimaryLineNumber__c = 5;
		proposalLineItemList[4].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[4].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[4].id;
		proposalLineItemList[4].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[4].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[4].Total_Option_Quantity__c=1;
		
		
		proposalLineItemList[5].NokiaCPQ_Spare__c = false;
		proposalLineItemList[5].Apttus_Proposal__Product__c  = pList[5].Id;
		proposalLineItemList[5].Apttus_QPConfig__OptionId__c = pList[5].Id;
		proposalLineItemList[5].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[5].Apttus_QPConfig__ParentBundleNumber__c = 5;
		proposalLineItemList[5].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[5].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[5].is_Custom_Product__c = false;
		proposalLineItemList[5].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[5].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[5].Apttus_QPConfig__LineNumber__c = 6;
		proposalLineItemList[5].Apttus_QPConfig__PrimaryLineNumber__c = 6;
		proposalLineItemList[5].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[5].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[5].id;
		proposalLineItemList[5].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[5].NokiaCPQ_ExtendedPrice_CNP__c = 10;
		proposalLineItemList[5].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[5].Total_Option_Quantity__c=1;
		
		
		insert proposalLineItemList;
		System.debug('proposalLineItemList[0] : '+proposalLineItemList[0]);
		System.debug('proposalLineItemList[1] : '+proposalLineItemList[1]);
		System.debug('proposalLineItemList[2] : '+proposalLineItemList[2]);
		
		
		
		
		
		Alliance_Order_Export_Mapping__c obj = new Alliance_Order_Export_Mapping__c();
		obj.Arcadia_Options_Product_Code__c='3HZ15362AA';
		obj.Arcadia_Product_Code__c='833-010330_00_6';
		obj.Main_Bundle_Product_Code__c='833-010330_00_1';
		obj.PCI_Category__c='CHARGING';
		obj.Product_Code_For_Alliance_Export_File__c='1AK40746AAAA';
		
		insert obj;
		
		Alliance_Order_Export_Mapping__c obj1 = new Alliance_Order_Export_Mapping__c();
		obj1.Arcadia_Options_Product_Code__c='3HZ15362AA';
		obj1.Arcadia_Product_Code__c='833-010330_00_6';
		obj1.Main_Bundle_Product_Code__c='833-010330_00_1';
		obj1.PCI_Category__c='CHARGING';
		obj1.Product_Code_For_Alliance_Export_File__c='1AK40746AAAA';
		insert obj1;
 
		Alliance_Order_Export_Mapping__c obj3 = new Alliance_Order_Export_Mapping__c();
		obj3.Arcadia_Options_Product_Code__c='3HZ16084AAAA';
		obj3.Arcadia_Product_Code__c='833-010330_00_6';
		obj3.Main_Bundle_Product_Code__c='833-051870_00_1';
		obj3.PCI_Category__c='CE';
		obj3.Product_Code_For_Alliance_Export_File__c='3HZ16084AAAA';
		insert obj3;
		
		Alliance_Order_Export_Mapping__c obj2 = new Alliance_Order_Export_Mapping__c();
		obj2.Arcadia_Options_Product_Code__c='';
		obj2.Arcadia_Product_Code__c='833-010330_00_6';
		obj2.Main_Bundle_Product_Code__c='833-010330_00_1';
		obj2.PCI_Category__c='CHARGING';
		obj2.Product_Code_For_Alliance_Export_File__c='1AK40746AEAA';
		insert obj2;
		
		
		
		Quote_Delivery_Sales_Item__c salesitem= new Quote_Delivery_Sales_Item__c();
		salesitem.Arcadia_Product_Code__c='833-010330_00_2Test';
		salesitem.Product_Code__c='833-010330_00_2';
		salesitem.Quantity__c=200;
		salesitem.Item_Type__c='Order';
		salesitem.PCI_Code__c='SPS-ALU-PR-SW-PCI';
		salesitem.Proposal__c= proposals.Id;
		salesitem.Parent_Line_Item__c=prodConfigsLineItems[4].Id;
		salesitem.Name='2-ARC00010AA-1';
		insert salesitem;
		
		
		 Quote_Delivery_Sales_Item__c salesitem2= new Quote_Delivery_Sales_Item__c();
		salesitem2.Arcadia_Product_Code__c='833-010330_00_2Test';
		salesitem2.Product_Code__c='833-010330_00_Test2';
		salesitem2.Quantity__c=200;
		salesitem2.Item_Type__c='Order';
		salesitem2.PCI_Code__c='SPS-ALU-PR-SW-PCI';
		salesitem2.Proposal__c= proposals.Id;
		salesitem2.Parent_Line_Item__c=prodConfigsLineItems[4].Id;
		salesitem2.Name='2-ARC00010AA-1';
		insert salesitem2;
		
		
		
		
		List<Apttus_QPConfig__ProposalProductAttributeValue__c> pavList = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Apttus_QPConfig__ProposalProductAttributeValue__c pav1 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
		pav1.How_is_the_software_to_be_delivered__c = 'Physically';
		pav1.Apttus_QPConfig__LineItemId__c = proposalLineItemList[0].Id;
		pavList.add(pav1);
		
		Apttus_QPConfig__ProposalProductAttributeValue__c pav2 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
		pav2.How_is_the_software_to_be_delivered__c = 'Physically';
		pav2.Apttus_QPConfig__LineItemId__c = proposalLineItemList[1].Id;
		pavList.add(pav2);
		
		Apttus_QPConfig__ProposalProductAttributeValue__c pav3 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
		pav3.How_is_the_software_to_be_delivered__c = 'Physically';
		pav3.Apttus_QPConfig__LineItemId__c = proposalLineItemList[2].Id;
		pavList.add(pav3);
		
		insert pavList;
		
		
		Additional_Mapping_For_Alliance__c objAlliance = new Additional_Mapping_For_Alliance__c();
		objAlliance.Business_Unit__c='L36070';
		objAlliance.Main_Product_Code__c='833-051870_00_1';
		objAlliance.Product_acronym__c='Smart Plan Suite (SPS)';
		objAlliance.Product_Line_Profit_Center__c='A000506';
		objAlliance.Product_release_acronym__c='ALL';
		objAlliance.Sourcing_Unit__c='FI-FI1';
		objAlliance.What_Group_1__c='MAT_IPP_EDC';
		insert objAlliance;
		 
		Map<String, Additional_Mapping_For_Alliance__c> mapAdditionalMappingAlliance = new Map<String, Additional_Mapping_For_Alliance__c>();
		mapAdditionalMappingAlliance.put('Test',objAlliance);
		
		NokiaCPQ_CSP_ordering_export_mapping__c cspMap = new NokiaCPQ_CSP_ordering_export_mapping__c();
		cspMap.Parent_Product__c = 'AirScale WiFi';
		cspMap.PCI_Type__c = 'Equipment PCI';
		cspMap.PCI_Code__c = 'FC20002';
		cspMap.PCI_Description__c = 'WI-FI Controller SW Physical Delivery';
		cspMap.PName1__c = 'How_is_the_software_to_be_delivered__c';
		cspMap.Pvalue1__c = 'Physically';
		cspMap.Rule__c = 'FC21001,FC21002,FC21006,FC21007,SPS-ALU-PR-SW-PCI,FC21019,FC21020,FC21008,FC21009,FC21011,FC21012.T,FC21010,FC21013.T,FC21014,FC21015,FC21013,FC21016,FC21017,FC21015.T,FC21022,FC21021,FC21018,FC21017.T,FC21025,FC21024,FC21023,FC21028,FC21029,FC21027,FC21026,FC21030,FC22003.T,FC22005.T,FC22013.T,FC22015.T,FC22004.T,FC22017.T,FC23005.T,FC23004.T,FC23003.T,FC23013.T,FC23015.T,FC23012.T,FC23017.T,FC22021.T,FC22023.T,FC22027.T,FC22029.T,FC22025.T,FC23021.T,FC23025.T,FC23023.T,FC23029.T,FC23027.T,FC21031,FC21033,FC21032,FC21034,FC21035,FC21036,FC21037,FC21038,FC21039,FC21040,FC21041,FC21042,FC21043,FC21044,FC21003,FC21005,OEMVMSW001,OEMVMSW002,OEMVMSW003';
		cspMap.Rule_Type__c = 'Attribute';
		insert cspMap;
		
		mappingPLIMap.put(cspMap, proposalLineItemList);
		
		
		
		
		for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItemObj : proposalLineItemList){
			cspOderAndPliMap.put(proposalLineItemObj, mappingPLIMap);
		}
		  List<Order_Export_Result_For_External_System__c> oplist = new List<Order_Export_Result_For_External_System__c>();
		Order_Export_Result_For_External_System__c op = new Order_Export_Result_For_External_System__c(); 
		op.Product_Level__c='CO';
		op.Item_description__c = 'LIC, SPS POLICY, CORE, PER DEVICE, CLTU';
		op.Customer_Item_Code__c = '3HZ16092AAAA';
		op.Quantity__c = 500;
		op.Price_per_unit__c = 14.04;
		op.PO_Item_text__c = '';
		op.Quote_Id__c = proposals.id;
		op.External_System_Name__c = Nokia_CPQ_Constants.QUOTE_EXTERNAL_TARGET_SYSTEM_ALLIANCE ;
		op.Item_code__c='FP_MF02_MAT_EXTER';
		insert op;
		oplist.add(op);
		 Test.startTest();
		OrderExportProvider.generateAllianceOrderExportRecord('CO','1','On-Site-Training Wavespot Capt.Portal 1dy','OEMWSWMAINT07',1.0,10.0,'FP_SF03_NE_S_INTEG','','a3k210000009Dq0AAE','Alliance','','','','','1','sCPQ','','1a3i21000000AgLZAA0-CO-1','sCPQ','18.US.833457 Q 43','1');
		OrderExportProvider.deleteExistingAllianceOrderData(oplist);
		
		 OrderExportProvider.intiateExportForAllianceSystem(Nokia_CPQ_Constants.ALLIANCE_EXPORT_SUCCESS_STRING,proposals.id);
		 
		   OrderExportProvider.gernateAllianceOrder(proposalLineItemList,Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_MESSAGE_STRING,proposals.id);
			OrderExportProvider.intiateExportForQTCSystem(proposals.id,'');
		
		
	   
	   // NokiaCPQquoteActionsController.generateReconciliationExport(proposals.id);
		Test.stopTest();
	}
	
	
	  static testmethod void getPLIbundleOptionMapping_testMethod5(){
		//Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSIFinalMap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
		//Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> PLIandAttributeMap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> finalPLImap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
		Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> finalAttributePLImap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>> mappingPLIMap = new Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>();
		Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>> cspOderAndPliMap = new Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>>();
		//create Mapping
		NokiaCPQ_CSP_Map_Control__c mapControl = new NokiaCPQ_CSP_Map_Control__c();
		
		mapControl.Portfolio__c = 'Nokia Software';
		mapControl.Product_Code__c = '833-010330_00';
		mapControl.Source__c = 'External';
		//mapControl.Map_Mode__c = n;
		insert mapControl;
		
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();	 
		insert opportunities;			
		
		//create a quote
		Apttus_Proposal__Proposal__c  proposals = new Apttus_Proposal__Proposal__c();
		proposals.Apttus_Proposal__Account__c = accounts[0].Id;
		proposals.Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals.NokiaCPQ_Needs_Reprice__c = false;
		proposals.Reprice_In_Progress__c = false;
		proposals.RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); 
	   // proposals.NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Enhanced Emergency';
		proposals.NokiaCPQ_No_of_Years__c = '1';
		proposals.NokiaCPQ_Portfolio__c = 'Nokia Software';
		proposals.NokiaCPQ_SSP_Level__c = '';
		insert proposals;	   
		system.debug('>>>Quote Record Type::>>'+proposals.recordtypeID);
		
		//get a Product Apttus_Config2__ConfigurationType__c  
		List <Product2> pList = NOKIA_CPQ_TestDataFactory.productCreationDirect(6);
		pList[0].NokiaCPQ_Category__c = '1000Base-SX';
		pList[0].NokiaCPQ_Product_Discount_Category__c = '';
	   
		pList[0].Pricing_Clusters__c = '';
		pList[0].NokiaCPQ_State__c = 'Ramp Up';
		pList[0].NokiaCPQ_Item_Type__c = 'Service';
		pList[0].Business_Group__c='MN';		   
		pList[0].Portfolio__c = 'Nokia Software';
		pList[0].ProductCode = '833-051870_00_1';
		pList[0].Apttus_Config2__ConfigurationType__c = 'Bundle';
		//pList[0].Is_P20_Based_Product__c=true;
		
		//get a Product
		pList[1].NokiaCPQ_Category__c = '1000Base-SX';
		pList[1].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[1].Pricing_Clusters__c = '';
		pList[1].NokiaCPQ_State__c = 'Ramp Up';
		pList[1].NokiaCPQ_Item_Type__c = 'Service';
		pList[1].Business_Group__c='MN';		   
		pList[1].Portfolio__c = 'Nokia Software';
		pList[1].ProductCode = '833-010330_00_2';
		pList[1].Apttus_Config2__ConfigurationType__c = 'Standalone';
		pList[1].NokiaCPQ_Classification2__c='Deploy Services';
	   
	   
		
		//get a Product
		pList[2].NokiaCPQ_Category__c = '1000Base-SX';
		pList[2].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[2].Pricing_Clusters__c = '';
		pList[2].NokiaCPQ_State__c = 'Ramp Up';
		pList[2].NokiaCPQ_Item_Type__c = 'Service';
		pList[2].ProductCode = 'FC21001';
		pList[2].Business_Group__c='MN';		   
		pList[2].Portfolio__c = 'Nokia Software';
		pList[2].ProductCode = '833-010330_00_3';
		pList[2].Apttus_Config2__ConfigurationType__c = 'Bundle';
	   // pList[2].Is_P20_Based_Product__c=true;
		
		pList[3].NokiaCPQ_Category__c = '1000Base-SX';
		pList[3].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[3].Pricing_Clusters__c = '';
		pList[3].NokiaCPQ_State__c = 'Ramp Up';
		pList[3].NokiaCPQ_Item_Type__c = 'Service';
		pList[3].ProductCode = 'FC21001';
		pList[3].Business_Group__c='MN';		   
		pList[3].Portfolio__c = 'Nokia Software';
		pList[3].ProductCode = '833-010330_00_4';
		pList[3].Apttus_Config2__ConfigurationType__c = 'Bundle';
		
		pList[4].NokiaCPQ_Category__c = '1000Base-SX';
		pList[4].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[4].Pricing_Clusters__c = '';
		pList[4].NokiaCPQ_State__c = 'Ramp Up';
		pList[4].NokiaCPQ_Item_Type__c = 'Service';
	   // pList[4].ProductCode = 'FC21001';
		pList[4].Business_Group__c='MN';		   
		pList[4].Portfolio__c = 'Nokia Software';
		pList[4].ProductCode = '833-010330_00_5';
		pList[4].Apttus_Config2__ConfigurationType__c = 'Bundle';
		pList[4].Is_Dummy_Bundle_CPQ__c = 'Yes';
	   // pList[4].Is_P20_Based_Product__c=true;
		
		pList[5].NokiaCPQ_Category__c = '1000Base-SX';
		pList[5].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[5].Pricing_Clusters__c = '';
		pList[5].NokiaCPQ_State__c = 'Ramp Up';
		pList[5].NokiaCPQ_Item_Type__c = 'Service';
		pList[5].ProductCode = '833-010330_00_6';
		pList[5].Business_Group__c='MN';		   
		pList[5].Portfolio__c = 'Nokia Software';
	 //   pList[5].ProductCode = '833-010330_00_1';
		pList[5].Apttus_Config2__ConfigurationType__c = 'Option';
		
		insert pList;
		
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='EUR';
		priceList.Apttus_Config2__Active__c=true;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		insert priceList;
		
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[0].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI1);
		Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[1].Id, 
			
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI2);
		Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[2].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI3);
		Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[3].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI4);
		Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[4].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI5);
		Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[5].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI6);
		insert plistItems;
		
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals.Id;
		prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
		insert prodConfigs;
		
		List<Apttus_Config2__LineItem__c> prodConfigsLineItems = NOKIA_CPQ_TestDataFactory.createLineItem(6);
		prodConfigsLineItems[0].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[0].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[0].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[0].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[0].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[0].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[0].Apttus_Config2__ProductId__c = pList[0].Id;
		prodConfigsLineItems[0].Apttus_Config2__PriceListItemId__c = pLI1.id;
		prodConfigsLineItems[0].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[0].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[0].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[0].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[0].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[0].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[0].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[1].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[1].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[1].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[1].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[1].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[1].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[1].Apttus_Config2__ProductId__c = pList[1].Id;
		prodConfigsLineItems[1].Apttus_Config2__PriceListItemId__c = pLI2.id;
		prodConfigsLineItems[1].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[1].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[1].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[1].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[1].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[1].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[1].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[2].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[2].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[2].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[2].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[2].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[2].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[2].Apttus_Config2__ProductId__c = pList[2].Id;
		prodConfigsLineItems[2].Apttus_Config2__PriceListItemId__c = pLI3.id;
		prodConfigsLineItems[2].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[2].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[2].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[2].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[2].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[2].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[3].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[3].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[3].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[3].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[3].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[3].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[3].Apttus_Config2__ProductId__c = pList[3].Id;
		prodConfigsLineItems[3].Apttus_Config2__PriceListItemId__c = pLI4.id;
		prodConfigsLineItems[3].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[3].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[3].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[3].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[3].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[3].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[4].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[4].Apttus_Config2__LineNumber__c =1;
		prodConfigsLineItems[4].Apttus_Config2__LineSequence__c = 1;
		prodConfigsLineItems[4].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[4].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[4].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[4].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[4].Apttus_Config2__ProductId__c = pList[4].Id;
		prodConfigsLineItems[4].Apttus_Config2__PriceListItemId__c = pLI5.id;
		prodConfigsLineItems[4].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[4].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[4].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[4].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[4].Apttus_Config2__PrimaryLineNumber__c =1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[4].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[5].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[5].Apttus_Config2__LineSequence__c = 6;
		prodConfigsLineItems[5].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[5].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[5].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[5].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[5].Apttus_Config2__ProductId__c = pList[5].Id;
		prodConfigsLineItems[5].Apttus_Config2__PriceListItemId__c = pLI6.id;
		prodConfigsLineItems[5].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[5].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[5].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[5].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[5].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[5].Apttus_Config2__AddedBy__c = 'added by code';
		insert prodConfigsLineItems;
	 
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(6);
		proposalLineItemList[0].NokiaCPQ_Spare__c = false;
		proposalLineItemList[0].Apttus_Proposal__Product__c  = pList[0].Id;
		proposalLineItemList[0].Apttus_QPConfig__OptionId__c = pList[0].Id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[0].Apttus_QPConfig__ParentBundleNumber__c = Null;
		proposalLineItemList[0].NokiaCPQ_Configuration_Type__c = 'Bundle';
		proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'Product Service';
		proposalLineItemList[0].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[0].is_Custom_Product__c = false;
		proposalLineItemList[0].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[0].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[0].Apttus_QPConfig__PrimaryLineNumber__c = 1;
		proposalLineItemList[0].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[0].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[0].id;
		proposalLineItemList[0].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[0].NokiaCPQ_ExtendedPrice_CNP__c = 10;
		proposalLineItemList[0].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[0].Total_Option_Quantity__c=1;
		
	   
		proposalLineItemList[1].NokiaCPQ_Spare__c = false;
		proposalLineItemList[1].Apttus_Proposal__Product__c  = pList[1].Id;
		proposalLineItemList[1].Apttus_QPConfig__OptionId__c = pList[1].Id;
		proposalLineItemList[1].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[1].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[1].NokiaCPQ_Configuration_Type__c = 'Bundle';
		proposalLineItemList[1].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[1].is_Custom_Product__c = false;
		proposalLineItemList[1].Apttus_QPConfig__LineType__c = 'Product Service';
		proposalLineItemList[1].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[1].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[1].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[1].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[1].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[1].id;
		proposalLineItemList[1].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[1].NokiaCPQ_ExtendedPrice_CNP__c = 10;
		proposalLineItemList[1].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[1].Total_Option_Quantity__c=1;
		
		proposalLineItemList[2].NokiaCPQ_Spare__c = false;
		proposalLineItemList[2].Apttus_Proposal__Product__c  = pList[2].Id;
		proposalLineItemList[2].Apttus_QPConfig__OptionId__c = pList[2].Id;
		proposalLineItemList[2].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[2].Apttus_QPConfig__ParentBundleNumber__c = 2;
		proposalLineItemList[2].NokiaCPQ_Configuration_Type__c = 'Bundle';
		proposalLineItemList[2].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[2].is_Custom_Product__c = false;
		proposalLineItemList[2].Apttus_QPConfig__LineType__c = 'Product Service';
	   // proposalLineItemList[2].NokiaCPQ_Is_Direct_Option__c  = true;
		proposalLineItemList[2].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[2].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[2].Apttus_QPConfig__PrimaryLineNumber__c = 3;
		proposalLineItemList[2].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[2].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[2].id;
		proposalLineItemList[2].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[2].NokiaCPQ_IsArcadiaBundle__c = true;
		proposalLineItemList[2].NokiaCPQ_ExtendedPrice_CNP__c = 10;
		proposalLineItemList[2].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[2].Total_Option_Quantity__c=1;
		
		proposalLineItemList[3].NokiaCPQ_Spare__c = false;
		proposalLineItemList[3].Apttus_Proposal__Product__c  = pList[3].Id;
		proposalLineItemList[3].Apttus_QPConfig__OptionId__c = pList[3].Id;
		proposalLineItemList[3].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 3;
		proposalLineItemList[3].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[3].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[3].is_Custom_Product__c = false;
		proposalLineItemList[3].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[3].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[3].Apttus_QPConfig__LineNumber__c = 4;
		proposalLineItemList[3].Apttus_QPConfig__PrimaryLineNumber__c = 4;
		proposalLineItemList[3].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[3].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[3].id;
		proposalLineItemList[3].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[3].NokiaCPQ_ExtendedPrice_CNP__c = 10;
		proposalLineItemList[3].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[3].Total_Option_Quantity__c=1;
		
		proposalLineItemList[4].NokiaCPQ_Spare__c = false;
		proposalLineItemList[4].Apttus_Proposal__Product__c  = pList[4].Id;
		proposalLineItemList[4].Apttus_QPConfig__OptionId__c = pList[4].Id;
		proposalLineItemList[4].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[4].Apttus_QPConfig__ParentBundleNumber__c = 4;
		proposalLineItemList[4].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[4].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[4].is_Custom_Product__c = false;
		proposalLineItemList[4].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[4].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[4].Apttus_QPConfig__LineNumber__c = 5;
		proposalLineItemList[4].Apttus_QPConfig__PrimaryLineNumber__c = 5;
		proposalLineItemList[4].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[4].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[4].id;
		proposalLineItemList[4].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[4].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[4].Total_Option_Quantity__c=1;
		
		
		proposalLineItemList[5].NokiaCPQ_Spare__c = false;
		proposalLineItemList[5].Apttus_Proposal__Product__c  = pList[5].Id;
		proposalLineItemList[5].Apttus_QPConfig__OptionId__c = pList[5].Id;
		proposalLineItemList[5].Apttus_Proposal__Proposal__c = proposals.Id;
		proposalLineItemList[5].Apttus_QPConfig__ParentBundleNumber__c = 5;
		proposalLineItemList[5].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[5].Custom_Product_Code__c = 'Nokia Software';
		proposalLineItemList[5].is_Custom_Product__c = false;
		proposalLineItemList[5].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[5].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[5].Apttus_QPConfig__LineNumber__c = 6;
		proposalLineItemList[5].Apttus_QPConfig__PrimaryLineNumber__c = 6;
		proposalLineItemList[5].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[5].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[5].id;
		proposalLineItemList[5].Apttus_QPConfig__IsPrimaryLine__c = true;
		proposalLineItemList[5].NokiaCPQ_ExtendedPrice_CNP__c = 10;
		proposalLineItemList[5].Apttus_QPConfig__Quantity2__c = 10;
		proposalLineItemList[5].Total_Option_Quantity__c=1;
		
		
		insert proposalLineItemList;
		System.debug('proposalLineItemList[0] : '+proposalLineItemList[0]);
		System.debug('proposalLineItemList[1] : '+proposalLineItemList[1]);
		System.debug('proposalLineItemList[2] : '+proposalLineItemList[2]);
		
		
		
		
		
		Alliance_Order_Export_Mapping__c obj = new Alliance_Order_Export_Mapping__c();
		obj.Arcadia_Options_Product_Code__c='3HZ15362AA';
		obj.Arcadia_Product_Code__c='833-010330_00_6';
		obj.Main_Bundle_Product_Code__c='833-010330_00_1';
		obj.PCI_Category__c='CHARGING';
		obj.Product_Code_For_Alliance_Export_File__c='1AK40746AAAA';
		
		insert obj;
		
		Alliance_Order_Export_Mapping__c obj1 = new Alliance_Order_Export_Mapping__c();
		obj1.Arcadia_Options_Product_Code__c='3HZ15362AA';
		obj1.Arcadia_Product_Code__c='833-010330_00_6';
		obj1.Main_Bundle_Product_Code__c='833-010330_00_1';
		obj1.PCI_Category__c='CHARGING';
		obj1.Product_Code_For_Alliance_Export_File__c='1AK40746AAAA';
		insert obj1;
 
		Alliance_Order_Export_Mapping__c obj3 = new Alliance_Order_Export_Mapping__c();
		obj3.Arcadia_Options_Product_Code__c='3HZ16084AAAA';
		obj3.Arcadia_Product_Code__c='833-010330_00_6';
		obj3.Main_Bundle_Product_Code__c='833-051870_00_1';
		obj3.PCI_Category__c='CE';
		obj3.Product_Code_For_Alliance_Export_File__c='3HZ16084AAAA';
		insert obj3;
		
		Alliance_Order_Export_Mapping__c obj2 = new Alliance_Order_Export_Mapping__c();
		obj2.Arcadia_Options_Product_Code__c='';
		obj2.Arcadia_Product_Code__c='833-010330_00_6';
		obj2.Main_Bundle_Product_Code__c='833-010330_00_1';
		obj2.PCI_Category__c='CHARGING';
		obj2.Product_Code_For_Alliance_Export_File__c='1AK40746AEAA';
		insert obj2;
		
		
		
		Quote_Delivery_Sales_Item__c salesitem= new Quote_Delivery_Sales_Item__c();
		salesitem.Arcadia_Product_Code__c='833-010330_00_2Test';
		salesitem.Product_Code__c='833-010330_00_2';
		salesitem.Quantity__c=200;
		salesitem.Item_Type__c='Order';
		salesitem.PCI_Code__c='SPS-ALU-PR-SW-PCI';
		salesitem.Proposal__c= proposals.Id;
		salesitem.Parent_Line_Item__c=prodConfigsLineItems[4].Id;
		salesitem.Name='2-ARC00010AA-1';
		insert salesitem;
		
		
		 Quote_Delivery_Sales_Item__c salesitem2= new Quote_Delivery_Sales_Item__c();
		salesitem2.Arcadia_Product_Code__c='833-010330_00_2Test';
		salesitem2.Product_Code__c='833-010330_00_Test2';
		salesitem2.Quantity__c=200;
		salesitem2.Item_Type__c='Order';
		salesitem2.PCI_Code__c='SPS-ALU-PR-SW-PCI';
		salesitem2.Proposal__c= proposals.Id;
		salesitem2.Parent_Line_Item__c=prodConfigsLineItems[4].Id;
		salesitem2.Name='2-ARC00010AA-1';
		insert salesitem2;
		
		
		
		
		List<Apttus_QPConfig__ProposalProductAttributeValue__c> pavList = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Apttus_QPConfig__ProposalProductAttributeValue__c pav1 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
		pav1.How_is_the_software_to_be_delivered__c = 'Physically';
		pav1.Apttus_QPConfig__LineItemId__c = proposalLineItemList[0].Id;
		pavList.add(pav1);
		
		Apttus_QPConfig__ProposalProductAttributeValue__c pav2 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
		pav2.How_is_the_software_to_be_delivered__c = 'Physically';
		pav2.Apttus_QPConfig__LineItemId__c = proposalLineItemList[1].Id;
		pavList.add(pav2);
		
		Apttus_QPConfig__ProposalProductAttributeValue__c pav3 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
		pav3.How_is_the_software_to_be_delivered__c = 'Physically';
		pav3.Apttus_QPConfig__LineItemId__c = proposalLineItemList[2].Id;
		pavList.add(pav3);
		
		insert pavList;
		
		
		Additional_Mapping_For_Alliance__c objAlliance = new Additional_Mapping_For_Alliance__c();
		objAlliance.Business_Unit__c='L36070';
		objAlliance.Main_Product_Code__c='833-051870_00_1';
		objAlliance.Product_acronym__c='Smart Plan Suite (SPS)';
		objAlliance.Product_Line_Profit_Center__c='A000506';
		objAlliance.Product_release_acronym__c='ALL';
		objAlliance.Sourcing_Unit__c='FI-FI1';
		objAlliance.What_Group_1__c='MAT_IPP_EDC';
		insert objAlliance;
		 
		Map<String, Additional_Mapping_For_Alliance__c> mapAdditionalMappingAlliance = new Map<String, Additional_Mapping_For_Alliance__c>();
		mapAdditionalMappingAlliance.put('Test',objAlliance);
		
		NokiaCPQ_CSP_ordering_export_mapping__c cspMap = new NokiaCPQ_CSP_ordering_export_mapping__c();
		cspMap.Parent_Product__c = 'AirScale WiFi';
		cspMap.PCI_Type__c = 'Equipment PCI';
		cspMap.PCI_Code__c = 'FC20002';
		cspMap.PCI_Description__c = 'WI-FI Controller SW Physical Delivery';
		cspMap.PName1__c = 'How_is_the_software_to_be_delivered__c';
		cspMap.Pvalue1__c = 'Physically';
		cspMap.Rule__c = 'FC21001,FC21002,FC21006,FC21007,SPS-ALU-PR-SW-PCI,FC21019,FC21020,FC21008,FC21009,FC21011,FC21012.T,FC21010,FC21013.T,FC21014,FC21015,FC21013,FC21016,FC21017,FC21015.T,FC21022,FC21021,FC21018,FC21017.T,FC21025,FC21024,FC21023,FC21028,FC21029,FC21027,FC21026,FC21030,FC22003.T,FC22005.T,FC22013.T,FC22015.T,FC22004.T,FC22017.T,FC23005.T,FC23004.T,FC23003.T,FC23013.T,FC23015.T,FC23012.T,FC23017.T,FC22021.T,FC22023.T,FC22027.T,FC22029.T,FC22025.T,FC23021.T,FC23025.T,FC23023.T,FC23029.T,FC23027.T,FC21031,FC21033,FC21032,FC21034,FC21035,FC21036,FC21037,FC21038,FC21039,FC21040,FC21041,FC21042,FC21043,FC21044,FC21003,FC21005,OEMVMSW001,OEMVMSW002,OEMVMSW003';
		cspMap.Rule_Type__c = 'Attribute';
		insert cspMap;
		
		mappingPLIMap.put(cspMap, proposalLineItemList);
		
		
		
		
		for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItemObj : proposalLineItemList){
			cspOderAndPliMap.put(proposalLineItemObj, mappingPLIMap);
		}
		  List<Order_Export_Result_For_External_System__c> oplist = new List<Order_Export_Result_For_External_System__c>();
		Order_Export_Result_For_External_System__c op = new Order_Export_Result_For_External_System__c(); 
		op.Product_Level__c='CO';
		op.Item_description__c = 'LIC, SPS POLICY, CORE, PER DEVICE, CLTU';
		op.Customer_Item_Code__c = '3HZ16092AAAA';
		op.Quantity__c = 500;
		op.Price_per_unit__c = 14.04;
		op.PO_Item_text__c = '';
		op.Quote_Id__c = proposals.id;
		op.External_System_Name__c = Nokia_CPQ_Constants.QUOTE_EXTERNAL_TARGET_SYSTEM_ALLIANCE ;
		op.Item_code__c='FP_MF02_MAT_EXTER';
		insert op;
		oplist.add(op);
		 Test.startTest();
		OrderExportProvider.generateAllianceOrderExportRecord('CO','1','On-Site-Training Wavespot Capt.Portal 1dy','OEMWSWMAINT07',1.0,10.0,'FP_SF03_NE_S_INTEG','','a3k210000009Dq0AAE','Alliance','','','','','1','sCPQ','','1a3i21000000AgLZAA0-CO-1','sCPQ','18.US.833457 Q 43','1');
		OrderExportProvider.deleteExistingAllianceOrderData(oplist);
		
		 OrderExportProvider.intiateExportForAllianceSystem(Nokia_CPQ_Constants.ALLIANCE_EXPORT_SUCCESS_STRING,proposals.id);
		 
		   OrderExportProvider.gernateAllianceOrder(proposalLineItemList,Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_MESSAGE_STRING,proposals.id);
			OrderExportProvider.intiateExportForQTCSystem(proposals.id,'');
		
		
	   
	   // NokiaCPQquoteActionsController.generateReconciliationExport(proposals.id);
		Test.stopTest();
	}


}