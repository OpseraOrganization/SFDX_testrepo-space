@isTest(SeeAllData = false)
public class NokiaCPQ_CSP_Export_GeneratorTest {
/***************************************
	 * Class Name : NokiaCPQ_CSP_Export_GeneratorTest
	 * Author : Accenture
	 * Developer : Kamlesh Kumar Jandu
	 * Description : The method is used if Product 'Item Type' = 'Software'
*********************************/
	static testmethod void getPLIbundleOptionMapping_testMethod1(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();		
		insert opportunities;  
		//Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>> cspOderAndPliMap = new Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>>();
		test.startTest();
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].Reprice_In_Progress__c = false;
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId(); 
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Basic';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		proposals[0].NokiaCPQ_Portfolio__c = 'Airscale Wifi';
		proposals[0].NokiaCPQ_SSP_Level__c = '';
		insert proposals;		
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);
		
		
		
		//get a Product
		List <Product2> pList = NOKIA_CPQ_TestDataFactory.productCreationDirect(5);
		pList[0].NokiaCPQ_Category__c = '1000Base-SX';
		pList[0].NokiaCPQ_Product_Discount_Category__c = '';
		pList[0].Pricing_Clusters__c = '';
		pList[0].NokiaCPQ_State__c = 'Ramp Up';
		pList[0].NokiaCPQ_Item_Type__c = 'Service';
		pList[0].Business_Group__c='MN';		   
		pList[0].Portfolio__c = 'Airscale Wifi';
		pList[0].ProductCode = 'AirScaleWiFi';
		pList[0].Apttus_Config2__ConfigurationType__c = 'Bundle';
		
		//get a Product
		pList[1].NokiaCPQ_Category__c = '1000Base-SX';
		pList[1].NokiaCPQ_Product_Discount_Category__c = '';
		pList[1].Pricing_Clusters__c = '';
		pList[1].NokiaCPQ_State__c = 'Ramp Up';
		pList[1].NokiaCPQ_Item_Type__c = 'Service';
		pList[1].Business_Group__c='MN';		   
		pList[1].Portfolio__c = 'Airscale Wifi';
		pList[1].ProductCode = 'AirScaleWiFi';
		pList[1].Apttus_Config2__ConfigurationType__c = 'Standalone';
		
		//get a Product
		pList[2].NokiaCPQ_Category__c = '1000Base-SX';
		pList[2].NokiaCPQ_Product_Discount_Category__c = '';
		pList[2].Pricing_Clusters__c = '';
		pList[2].NokiaCPQ_State__c = 'Ramp Up';
		pList[2].NokiaCPQ_Item_Type__c = 'Service';
		pList[2].ProductCode = 'FC21001';
		pList[2].Business_Group__c='MN';		   
		pList[2].Portfolio__c = 'Airscale Wifi';
		pList[2].ProductCode = 'AirScaleWiFi';
		pList[2].Apttus_Config2__ConfigurationType__c = 'Standalone';
		
		pList[3].NokiaCPQ_Category__c = '1000Base-SX';
		pList[3].NokiaCPQ_Product_Discount_Category__c = '';
		pList[3].Pricing_Clusters__c = '';
		pList[3].NokiaCPQ_State__c = 'Ramp Up';
		pList[3].NokiaCPQ_Item_Type__c = 'Service';
		pList[3].ProductCode = 'FC21001';
		pList[3].Business_Group__c='MN';		   
		pList[3].Portfolio__c = 'Airscale Wifi';
		pList[3].ProductCode = 'AirScaleWiFi';
		pList[3].Apttus_Config2__ConfigurationType__c = 'Standalone';
		pList[3].NokiaCPQ_Classification2__c = 'Deploy Services';
		
		pList[4].NokiaCPQ_Category__c = '1000Base-SX';
		pList[4].NokiaCPQ_Product_Discount_Category__c = '';
		pList[4].Pricing_Clusters__c = '';
		pList[4].NokiaCPQ_State__c = 'Ramp Up';
		pList[4].NokiaCPQ_Item_Type__c = 'Service';
		pList[4].ProductCode = 'FC21001';
		pList[4].Business_Group__c='MN';		   
		pList[4].Portfolio__c = 'Airscale Wifi';
		pList[4].ProductCode = 'AirScaleWiFi';
		pList[4].Apttus_Config2__ConfigurationType__c = 'Standalone';
		pList[3].NokiaCPQ_Classification2__c = 'Deploy Services';
		
		insert pList;
		
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='EUR';
		priceList.Apttus_Config2__Active__c=true;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		insert priceList;
		
		// create a product configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
		insert prodConfigs;
		
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
		insert plistItems;
		
		List<Apttus_Config2__LineItem__c> prodConfigsLineItems = NOKIA_CPQ_TestDataFactory.createLineItem(5);
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
		prodConfigsLineItems[3].Apttus_Config2__LineSequence__c = 2;
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
		prodConfigsLineItems[4].Apttus_Config2__LineSequence__c = 3;
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

		insert prodConfigsLineItems;
		
		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(5);
		proposalLineItemList[0].NokiaCPQ_Spare__c = false;
		proposalLineItemList[0].Apttus_Proposal__Product__c = pList[0].Id;
		proposalLineItemList[0].Apttus_QPConfig__OptionId__c = pList[0].Id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[0].Apttus_QPConfig__ParentBundleNumber__c = Null;
		proposalLineItemList[0].NokiaCPQ_Configuration_Type__c = 'Bundle';
		proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[0].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[0].is_Custom_Product__c = false;
		proposalLineItemList[0].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[0].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[0].Apttus_QPConfig__PrimaryLineNumber__c = 1;
		proposalLineItemList[0].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[0].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[0].id;
	   
		proposalLineItemList[1].NokiaCPQ_Spare__c = false;
		proposalLineItemList[1].Apttus_Proposal__Product__c = pList[1].Id;
		proposalLineItemList[1].Apttus_QPConfig__OptionId__c = pList[1].Id;
		proposalLineItemList[1].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[1].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[1].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[1].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[1].is_Custom_Product__c = false;
		proposalLineItemList[1].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[1].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[1].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[1].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[1].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[1].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[1].id;
		
		proposalLineItemList[2].NokiaCPQ_Spare__c = false;
		proposalLineItemList[2].Apttus_Proposal__Product__c = pList[2].Id;
		proposalLineItemList[2].Apttus_QPConfig__OptionId__c = pList[2].Id;
		proposalLineItemList[2].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[2].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[2].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[2].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[2].is_Custom_Product__c = false;
		proposalLineItemList[2].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[2].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[2].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[2].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[2].Apttus_Proposal__Description__c = 'GS Deploy Services Items';
		proposalLineItemList[2].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[2].id;
		
		proposalLineItemList[3].NokiaCPQ_Spare__c = false;
		proposalLineItemList[3].Apttus_Proposal__Product__c = pList[3].Id;
		proposalLineItemList[3].Apttus_QPConfig__OptionId__c = pList[3].Id;
		proposalLineItemList[3].Apttus_Proposal__Proposal__c = proposals[0].Id;
		//proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[3].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[3].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[3].is_Custom_Product__c = false;
		proposalLineItemList[3].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[3].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[3].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[3].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[3].Apttus_Proposal__Description__c = 'GS Deploy Services Items';
		proposalLineItemList[3].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[3].id;
		
		proposalLineItemList[4].NokiaCPQ_Spare__c = false;
		proposalLineItemList[4].Apttus_Proposal__Product__c = pList[4].Id;
		proposalLineItemList[4].Apttus_QPConfig__OptionId__c = pList[4].Id;
		proposalLineItemList[4].Apttus_Proposal__Proposal__c = proposals[0].Id;
		//proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[4].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[4].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[4].is_Custom_Product__c = false;
		proposalLineItemList[4].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[4].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[4].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[4].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[4].Apttus_Proposal__Description__c = 'GS Deploy Services Items';
		proposalLineItemList[4].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[4].id;
		
		insert proposalLineItemList;
		// Creating Line Item
		Apttus_Config2__LineItem__c lineitem = new Apttus_Config2__LineItem__c();
		lineitem.Apttus_Config2__LineNumber__c=2;
		lineitem.Apttus_Config2__LineType__c='Product/Service';
		lineitem.Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		lineitem.Apttus_Config2__ItemSequence__c=1;
		lineitem.Apttus_Config2__IsPrimaryLine__c=true;
		lineitem.Apttus_Config2__TotalQuantity__c=1;
		lineitem.Apttus_Config2__SellingTerm__c=1;
		lineitem.Apttus_Config2__SellingFrequency__c='One Time';
		lineitem.Apttus_Config2__DeltaPrice__c=1139100.07;
		lineitem.Apttus_Config2__DeltaQuantity__c=1;
		lineitem.NokiaCPQ_IRP_Discount__c=31.66590246982185;
		lineitem.Apttus_Config2__LineSequence__c = 1;

		insert lineitem;
		//Creating Delivery Sales Item
		Quote_Delivery_Sales_Item__c salesitem= new Quote_Delivery_Sales_Item__c();
		salesitem.Arcadia_Product_Code__c='ARC00010AA';
		salesitem.Product_Code__c='3HZ16085AAAA';
		salesitem.Quantity__c=200;
		salesitem.Item_Type__c='Order';
		salesitem.PCI_Code__c='SPS-ALU-PR-SW-PCI';
		salesitem.Proposal__c= proposals[0].Id;
		salesitem.Parent_Line_Item__c=lineitem.Id;
		salesitem.Name='2-ARC00010AA-1';
		insert salesitem; 
		//create Mapping
		NokiaCPQ_CSP_Map_Control__c mapControl = new NokiaCPQ_CSP_Map_Control__c();
		mapControl.Name = 'AirScale Wi-Fi';
		mapControl.Product_Code__c = 'AirScaleWiFi';
		mapControl.Source__c = 'Table';
		mapControl.Splitlevel__c = '1';
		mapControl.Portfolio__c = 'Airscale Wifi';
		mapControl.Map_Mode__c = 'Split';
		insert mapControl;
		NokiaCPQ_output_CSP_mapping__c cspmapping2 = new NokiaCPQ_output_CSP_mapping__c();
		cspmapping2.NokiaCPQ_code__c = 'FC20001';
		cspmapping2.Item_Level__c=1;
		cspmapping2.Quantity__c = 1;
		cspmapping2.QuoteId__c= proposals[0].Id;
		insert cspmapping2;
		
		NokiaCPQ_output_CSP_mapping__c cspmapping = new NokiaCPQ_output_CSP_mapping__c();
		cspmapping.NokiaCPQ_code__c = 'FC21005';
		cspmapping.Item_Level__c=2;
		cspmapping.Quantity__c = 100;
		cspmapping.QuoteId__c= proposals[0].Id;
	   
		cspmapping.NokiaCPQ_Parent_PCI__c=cspmapping2.Id;
		insert cspmapping;
		
		NokiaCPQ_output_CSP_mapping__c cspmapping1 = new NokiaCPQ_output_CSP_mapping__c();
		cspmapping1.NokiaCPQ_code__c = 'FC21009';
		cspmapping1.Item_Level__c=0;
		cspmapping1.Quantity__c = 200;
		cspmapping1.QuoteId__c= proposals[0].Id;
		cspmapping1.NokiaCPQ_Parent_PCI__c=cspmapping2.Id;
		insert cspmapping1;
		  //get a Price List
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
		cspMap.Parent_Product__c = 'AirScale WiFi';
		cspMap.PCI_Type__c = 'Equipment PCI';
		cspMap.PCI_Code__c = 'FC20002';
		cspMap.PCI_Description__c = 'WI-FI Controller SW Physical Delivery';
		cspMap.PName1__c = 'How_is_the_software_to_be_delivered__c';
		cspMap.Pvalue1__c = 'Physically';
		cspMap.Rule__c = 'FC21001,FC21002,FC20002,FC21006,FC21007,FC21019,FC21020,FC21008,FC21009,FC21011,FC21012.T,FC21010,FC21013.T,FC21014,FC21015,FC21013,FC21016,FC21017,FC21015.T,FC21022,FC21021,FC21018,FC21017.T,FC21025,FC21024,FC21023,FC21028,FC21029,FC21027,FC21026,FC21030,FC22003.T,FC22005.T,FC22013.T,FC22015.T,FC22004.T,FC22017.T,FC23005.T,FC23004.T,FC23003.T,FC23013.T,FC23015.T,FC23012.T,FC23017.T,FC22021.T,FC22023.T,FC22027.T,FC22029.T,FC22025.T,FC23021.T,FC23025.T,FC23023.T,FC23029.T,FC23027.T,FC21031,FC21033,FC21032,FC21034,FC21035,FC21036,FC21037,FC21038,FC21039,FC21040,FC21041,FC21042,FC21043,FC21044,FC21003,FC21005,OEMVMSW001,OEMVMSW002,OEMVMSW003';
		cspMap.Rule_Type__c = 'Attribute';
		insert cspMap;
		
		NokiaCPQ_CSP_Export_Generator.PLIbundleOptionMapping(proposals[0].id);
		NokiaCPQ_CSP_Export_Generator.PLIbundleOptionMapping(NULL);
		test.stopTest();			  
	}
/***************************************
	 * Class Name : NokiaCPQ_CSP_Export_GeneratorTest
	 * Author : Accenture
	 * Developer : Kamlesh Kumar Jandu
	 * Description : The method is used if Product 'Item Type' = 'Hardware'
*********************************/
	static testmethod void getPLIbundleOptionMapping_testMethod2(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();		
		insert opportunities;  
		
		test.startTest();

		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].Reprice_In_Progress__c = false;
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId(); 
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Basic';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		proposals[0].NokiaCPQ_Portfolio__c = 'Airscale Wifi';
		proposals[0].NokiaCPQ_SSP_Level__c = '';
		insert proposals;		
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);
		
		List <Product2> pList = NOKIA_CPQ_TestDataFactory.productCreationDirect(5);
		pList[0].NokiaCPQ_Category__c = '1000Base-SX';
		pList[0].NokiaCPQ_Product_Discount_Category__c = '';
		pList[0].Pricing_Clusters__c = '';
		pList[0].NokiaCPQ_State__c = 'Ramp Up';
		pList[0].NokiaCPQ_Item_Type__c = 'Service';
		pList[0].Business_Group__c='MN';		   
		pList[0].Portfolio__c = 'Airscale Wifi';
		pList[0].ProductCode = 'AirScaleWiFi';
		pList[0].Apttus_Config2__ConfigurationType__c = 'Bundle';
		
		//get a Product
		pList[1].NokiaCPQ_Category__c = '1000Base-SX';
		pList[1].NokiaCPQ_Product_Discount_Category__c = '';
		pList[1].Pricing_Clusters__c = '';
		pList[1].NokiaCPQ_State__c = 'Ramp Up';
		pList[1].NokiaCPQ_Item_Type__c = 'Service';
		pList[1].Business_Group__c='MN';		   
		pList[1].Portfolio__c = 'Airscale Wifi';
		pList[1].ProductCode = 'AirScaleWiFi';
		pList[1].Apttus_Config2__ConfigurationType__c = 'Standalone';
		
		//get a Product
		pList[2].NokiaCPQ_Category__c = '1000Base-SX';
		pList[2].NokiaCPQ_Product_Discount_Category__c = '';
		pList[2].Pricing_Clusters__c = '';
		pList[2].NokiaCPQ_State__c = 'Ramp Up';
		pList[2].NokiaCPQ_Item_Type__c = 'Service';
		pList[2].ProductCode = 'FC21001';
		pList[2].Business_Group__c='MN';		   
		pList[2].Portfolio__c = 'Airscale Wifi';
		pList[2].ProductCode = 'AirScaleWiFi';
		pList[2].Apttus_Config2__ConfigurationType__c = 'Standalone';
		
		pList[3].NokiaCPQ_Category__c = '1000Base-SX';
		pList[3].NokiaCPQ_Product_Discount_Category__c = '';
		pList[3].Pricing_Clusters__c = '';
		pList[3].NokiaCPQ_State__c = 'Ramp Up';
		pList[3].NokiaCPQ_Item_Type__c = 'Service';
		pList[3].ProductCode = 'FC21001';
		pList[3].Business_Group__c='MN';		   
		pList[3].Portfolio__c = 'Airscale Wifi';
		pList[3].ProductCode = 'AirScaleWiFi';
		pList[3].Apttus_Config2__ConfigurationType__c = 'Standalone';
		pList[3].NokiaCPQ_Classification2__c = 'Deploy Services';
		
		pList[4].NokiaCPQ_Category__c = '1000Base-SX';
		pList[4].NokiaCPQ_Product_Discount_Category__c = '';
		pList[4].Pricing_Clusters__c = '';
		pList[4].NokiaCPQ_State__c = 'Ramp Up';
		pList[4].NokiaCPQ_Item_Type__c = 'Service';
		pList[4].ProductCode = 'FC21001';
		pList[4].Business_Group__c='MN';		   
		pList[4].Portfolio__c = 'Airscale Wifi';
		pList[4].ProductCode = 'AirScaleWiFi';
		pList[4].Apttus_Config2__ConfigurationType__c = 'Standalone';
		pList[3].NokiaCPQ_Classification2__c = 'Deploy Services';
		
		insert pList;
		
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='EUR';
		priceList.Apttus_Config2__Active__c=true;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		
		insert priceList;
		
		// create a product configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
		insert prodConfigs;
		
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
		insert plistItems;
		
		List<Apttus_Config2__LineItem__c> prodConfigsLineItems = NOKIA_CPQ_TestDataFactory.createLineItem(5);
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
		prodConfigsLineItems[3].Apttus_Config2__LineSequence__c = 2;
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
		prodConfigsLineItems[4].Apttus_Config2__LineSequence__c = 3;
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

		insert prodConfigsLineItems;
			   
		NokiaCPQ_CSP_ordering_export_mapping__c cspMap = new NokiaCPQ_CSP_ordering_export_mapping__c();
		//cspMap.Name = 'CSP-0002';
		cspMap.Parent_Product__c = 'AirScale WiFi';
		cspMap.PCI_Type__c = 'Equipment PCI';
		cspMap.PCI_Code__c = 'OEMWSW0000';
		cspMap.PCI_Description__c = '';
		cspMap.PName1__c = '';
		cspMap.Pvalue1__c = '';
		cspMap.Rule__c = 'OEMWSW0001';
		cspMap.Rule_Type__c = 'Option';
		insert cspMap;
		
		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(5);
		proposalLineItemList[0].NokiaCPQ_Spare__c = false;
		proposalLineItemList[0].Apttus_Proposal__Product__c = pList[0].Id;
		proposalLineItemList[0].Apttus_QPConfig__OptionId__c = pList[0].Id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[0].Apttus_QPConfig__ParentBundleNumber__c = Null;
		proposalLineItemList[0].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[0].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[0].is_Custom_Product__c = false;
		proposalLineItemList[0].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[0].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[0].Apttus_QPConfig__PrimaryLineNumber__c = 1;
		proposalLineItemList[0].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[0].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[0].id;
		
		proposalLineItemList[1].NokiaCPQ_Spare__c = false;
		proposalLineItemList[1].Apttus_Proposal__Product__c = pList[1].Id;
		proposalLineItemList[1].Apttus_QPConfig__OptionId__c = pList[1].Id;
		proposalLineItemList[1].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[1].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[1].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[1].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[1].is_Custom_Product__c = false;
		proposalLineItemList[1].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[1].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[1].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[1].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[1].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[1].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[1].id;
		
		proposalLineItemList[2].NokiaCPQ_Spare__c = false;
		proposalLineItemList[2].Apttus_Proposal__Product__c = pList[2].Id;
		proposalLineItemList[2].Apttus_QPConfig__OptionId__c = pList[2].Id;
		proposalLineItemList[2].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[2].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[2].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[2].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[2].is_Custom_Product__c = false;
		proposalLineItemList[2].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[2].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[2].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[2].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[2].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[2].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[2].id;
		
		proposalLineItemList[3].NokiaCPQ_Spare__c = false;
		proposalLineItemList[3].Apttus_Proposal__Product__c = pList[3].Id;
		proposalLineItemList[3].Apttus_QPConfig__OptionId__c = pList[3].Id;
		proposalLineItemList[3].Apttus_Proposal__Proposal__c = proposals[0].Id;
		//proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[3].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[3].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[3].is_Custom_Product__c = false;
		proposalLineItemList[3].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[3].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[3].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[3].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[3].Apttus_Proposal__Description__c = 'GS Deploy Services Items';
		proposalLineItemList[3].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[3].id;
		
		proposalLineItemList[4].NokiaCPQ_Spare__c = false;
		proposalLineItemList[4].Apttus_Proposal__Product__c = pList[4].Id;
		proposalLineItemList[4].Apttus_QPConfig__OptionId__c = pList[4].Id;
		proposalLineItemList[4].Apttus_Proposal__Proposal__c = proposals[0].Id;
		//proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[4].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[4].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[4].is_Custom_Product__c = false;
		proposalLineItemList[4].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[4].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[4].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[4].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[4].Apttus_Proposal__Description__c = 'GS Deploy Services Items';
		proposalLineItemList[4].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[4].id;
		
		insert proposalLineItemList;
		
		//create Mapping
		NokiaCPQ_CSP_Map_Control__c mapControl = new NokiaCPQ_CSP_Map_Control__c();
		mapControl.Name = 'AirScale Wi-Fi';
		mapControl.Product_Code__c = 'AirScaleWiFi';
		mapControl.Source__c = 'Table';
		mapControl.Splitlevel__c = '1';
		mapControl.Portfolio__c = 'Airscale Wifi';
		mapControl.Map_Mode__c = 'Split';
		insert mapControl;	  
		
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
		
		NokiaCPQ_CSP_Export_Generator.PLIbundleOptionMapping(proposals[0].id);
		NokiaCPQ_CSP_Export_Generator.generateMainBundleToSIsMap(proposalLineItemList);
		test.stopTest();			  
	}
/***************************************
	 * Class Name : NokiaCPQ_CSP_Export_GeneratorTest
	 * Author : Accenture
	 * Developer : Kamlesh Kumar Jandu
	 * Description : The method is used if Product 'Item Type' = 'Service'
*********************************/
	static testmethod void getPLIbundleOptionMapping_testMethod3(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();		
		insert opportunities;  
		
		test.startTest();
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].Reprice_In_Progress__c = false;
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId(); 
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Basic';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		proposals[0].NokiaCPQ_Portfolio__c = 'Airscale Wifi';
		proposals[0].NokiaCPQ_SSP_Level__c = '';
		insert proposals;		
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);
		
		//get a Product
		List <Product2> pList = NOKIA_CPQ_TestDataFactory.productCreationDirect(5);
		pList[0].NokiaCPQ_Category__c = '1000Base-SX';
		pList[0].NokiaCPQ_Product_Discount_Category__c = '';
		pList[0].Pricing_Clusters__c = '';
		pList[0].NokiaCPQ_State__c = 'Ramp Up';
		pList[0].NokiaCPQ_Item_Type__c = 'Service';
		pList[0].Business_Group__c='MN';		   
		pList[0].Portfolio__c = 'Airscale Wifi';
		pList[0].ProductCode = 'AirScaleWiFi';
		pList[0].Apttus_Config2__ConfigurationType__c = 'Bundle';
		
		//get a Product
		pList[1].NokiaCPQ_Category__c = '1000Base-SX';
		pList[1].NokiaCPQ_Product_Discount_Category__c = '';
		pList[1].Pricing_Clusters__c = '';
		pList[1].NokiaCPQ_State__c = 'Ramp Up';
		pList[1].NokiaCPQ_Item_Type__c = 'Service';
		pList[1].Business_Group__c='MN';		   
		pList[1].Portfolio__c = 'Airscale Wifi';
		pList[1].ProductCode = 'AirScaleWiFi';
		pList[1].Apttus_Config2__ConfigurationType__c = 'Standalone';
		
		//get a Product
		pList[2].NokiaCPQ_Category__c = '1000Base-SX';
		pList[2].NokiaCPQ_Product_Discount_Category__c = '';
		pList[2].Pricing_Clusters__c = '';
		pList[2].NokiaCPQ_State__c = 'Ramp Up';
		pList[2].NokiaCPQ_Item_Type__c = 'Service';
		pList[2].ProductCode = 'FC21001';
		pList[2].Business_Group__c='MN';		   
		pList[2].Portfolio__c = 'Airscale Wifi';
		pList[2].ProductCode = 'OEMWSW0003';
		pList[2].Apttus_Config2__ConfigurationType__c = 'Standalone';
		
		pList[3].NokiaCPQ_Category__c = '1000Base-SX';
		pList[3].NokiaCPQ_Product_Discount_Category__c = '';
		pList[3].Pricing_Clusters__c = '';
		pList[3].NokiaCPQ_State__c = 'Ramp Up';
		pList[3].NokiaCPQ_Item_Type__c = 'Service';
		pList[3].ProductCode = 'FC21001';
		pList[3].Business_Group__c='MN';		   
		pList[3].Portfolio__c = 'Airscale Wifi';
		pList[3].ProductCode = 'OEMWSW0002';
		pList[3].Apttus_Config2__ConfigurationType__c = 'Standalone';
		pList[3].NokiaCPQ_Classification2__c = 'Deploy Services';
		
		pList[4].NokiaCPQ_Category__c = '1000Base-SX';
		pList[4].NokiaCPQ_Product_Discount_Category__c = '';
		pList[4].Pricing_Clusters__c = '';
		pList[4].NokiaCPQ_State__c = 'Ramp Up';
		pList[4].NokiaCPQ_Item_Type__c = 'Service';
		pList[4].ProductCode = 'FC21001';
		pList[4].Business_Group__c='MN';		   
		pList[4].Portfolio__c = 'Airscale Wifi';
		pList[4].ProductCode = 'OEMWSW0001';
		pList[4].Apttus_Config2__ConfigurationType__c = 'Standalone';
		pList[3].NokiaCPQ_Classification2__c = 'Deploy Services';
		
		insert pList;
		
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='EUR';
		priceList.Apttus_Config2__Active__c=true;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		
		insert priceList;
		
		// create a product configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
		insert prodConfigs;
		
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
		insert plistItems;
		
		List<Apttus_Config2__LineItem__c> prodConfigsLineItems = NOKIA_CPQ_TestDataFactory.createLineItem(5);
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
		prodConfigsLineItems[3].Apttus_Config2__LineSequence__c = 2;
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
		prodConfigsLineItems[4].Apttus_Config2__LineSequence__c = 3;
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

		insert prodConfigsLineItems;
		
		NokiaCPQ_CSP_ordering_export_mapping__c cspMap = new NokiaCPQ_CSP_ordering_export_mapping__c();
		//cspMap.Name = 'CSP-0002';
		cspMap.Parent_Product__c = 'AirScale WiFi';
		cspMap.PCI_Type__c = 'Equipment PCI';
		cspMap.PCI_Code__c = 'OEMWSW0000';
		cspMap.PCI_Description__c = '';
		cspMap.PName1__c = '';
		cspMap.Pvalue1__c = '';
		cspMap.Rule__c = 'OEMWSW0001,OEMWSW0002,OEMWSW0003,OEMWSW0004,OEMWSW0005,OEMWSW0006,OEMWSW0007,OEMWSW0008,OEMWSW0009,OEMWSW0010,OEMWSW0011,OEMWSW0012,OEMWSW0013,OEMWSW0014,OEMWSW0015,OEMWSW0016,OEMWSW0017,OEMWSW0018,OEMWSW0019,OEMWSW0020,OEMWSW0021,OEMWSW0022,OEMWSW0023,OEMWSW0024,OEMWSW0025,OEMWSW0026';
		cspMap.Rule_Type__c = 'Option';
		insert cspMap;
		
		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(5);
		proposalLineItemList[0].NokiaCPQ_Spare__c = false;
		proposalLineItemList[0].Apttus_Proposal__Product__c = pList[0].Id;
		proposalLineItemList[0].Apttus_QPConfig__OptionId__c = pList[0].Id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[0].Apttus_QPConfig__ParentBundleNumber__c = Null;
		proposalLineItemList[0].NokiaCPQ_Configuration_Type__c = 'Bundle';
		proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[0].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[0].is_Custom_Product__c = false;
		proposalLineItemList[0].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[0].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[0].Apttus_QPConfig__PrimaryLineNumber__c = 1;
		proposalLineItemList[0].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[0].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[0].id;
		
		proposalLineItemList[1].NokiaCPQ_Spare__c = false;
		proposalLineItemList[1].Apttus_Proposal__Product__c = pList[1].Id;
		proposalLineItemList[1].Apttus_QPConfig__OptionId__c = pList[1].Id;
		proposalLineItemList[1].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[1].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[1].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[1].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[1].is_Custom_Product__c = false;
		proposalLineItemList[1].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[1].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[1].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[1].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[1].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[1].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[1].id;
		
		proposalLineItemList[2].NokiaCPQ_Spare__c = false;
		proposalLineItemList[2].Apttus_Proposal__Product__c = pList[2].Id;
		proposalLineItemList[2].Apttus_QPConfig__OptionId__c = pList[2].Id;
		proposalLineItemList[2].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[2].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[2].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[2].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[2].is_Custom_Product__c = false;
		proposalLineItemList[2].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[2].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[2].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[2].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[2].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[2].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[2].id;
		
		proposalLineItemList[3].NokiaCPQ_Spare__c = false;
		proposalLineItemList[3].Apttus_Proposal__Product__c = pList[3].Id;
		proposalLineItemList[3].Apttus_QPConfig__OptionId__c = pList[3].Id;
		proposalLineItemList[3].Apttus_Proposal__Proposal__c = proposals[0].Id;
		//proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[3].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[3].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[3].is_Custom_Product__c = false;
		proposalLineItemList[3].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[3].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[3].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[3].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[3].Apttus_Proposal__Description__c = 'GS Deploy Services Items';
		proposalLineItemList[3].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[3].id;
		
		proposalLineItemList[4].NokiaCPQ_Spare__c = false;
		proposalLineItemList[4].Apttus_Proposal__Product__c = pList[4].Id;
		proposalLineItemList[4].Apttus_QPConfig__OptionId__c = pList[4].Id;
		proposalLineItemList[4].Apttus_Proposal__Proposal__c = proposals[0].Id;
		//proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[4].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[4].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[4].is_Custom_Product__c = false;
		proposalLineItemList[4].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[4].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[4].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[4].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[4].Apttus_Proposal__Description__c = 'GS Deploy Services Items';
		proposalLineItemList[4].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[4].id;
		
		insert proposalLineItemList;	  
		
		//create Mapping
		NokiaCPQ_CSP_Map_Control__c mapControl = new NokiaCPQ_CSP_Map_Control__c();
		mapControl.Name = 'AirScale Wi-Fi';
		mapControl.Product_Code__c = 'AirScaleWiFi';
		mapControl.Source__c = 'Table';
		mapControl.Splitlevel__c = '1';
		mapControl.Portfolio__c = 'Airscale Wifi';
		mapControl.Map_Mode__c = 'Split';
		insert mapControl;
		
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
		
		NokiaCPQ_CSP_Export_Generator.PLIbundleOptionMapping(proposals[0].id);
		NokiaCPQ_CSP_Export_Generator.PLIbundleOptionMapping(null);
		test.stopTest();			  
	}
	static testmethod void getPLIbundleOptionMapping_testMethod4(){
	  //Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSIFinalMap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
	  //Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> PLIandAttributeMap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> finalPLImap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
		Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> finalAttributePLImap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
		 Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c> mapLineNumberAndMainBundlePLIObj = new Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c>();
		 Map<String, NokiaCPQ_CSP_Map_Control__c> productNameAndNokiaCSPMapControl = new Map<String, NokiaCPQ_CSP_Map_Control__c>();
		//create Mapping
		List<NokiaCPQ_CSP_Map_Control__c> mapControlList = new List<NokiaCPQ_CSP_Map_Control__c>();
		NokiaCPQ_CSP_Map_Control__c mapControl = new NokiaCPQ_CSP_Map_Control__c();
		mapControl.Portfolio__c = 'Airscale Wifi';
		mapControl.Product_Code__c = 'AirScaleWiFi';
		mapControl.Source__c = 'Table';
		mapControl.Map_Mode__c = 'Split';
		insert mapControl;
		mapControlList.add(mapControl);
		productNameAndNokiaCSPMapControl.put(mapControl.Product_Code__c,mapControl);
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();		
		insert opportunities;			 
		
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].Reprice_In_Progress__c = false;
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId(); 
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Basic';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		proposals[0].NokiaCPQ_Portfolio__c = 'Airscale Wifi';
		proposals[0].NokiaCPQ_SSP_Level__c = '';
		insert proposals;		
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);
		
		//get a Product Apttus_Config2__ConfigurationType__c  
		List <Product2> pList = NOKIA_CPQ_TestDataFactory.productCreationDirect(5);
		pList[0].NokiaCPQ_Category__c = '1000Base-SX';
		pList[0].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		 pList[0].Pricing_Clusters__c = '';
		pList[0].NokiaCPQ_State__c = 'Ramp Up';
		pList[0].NokiaCPQ_Item_Type__c = 'Service';
		pList[0].Business_Group__c='MN';		   
		pList[0].Portfolio__c = 'Airscale Wifi';
		pList[0].ProductCode = 'AirScaleWiFi';
		pList[0].Apttus_Config2__ConfigurationType__c = 'Bundle';
		
		//get a Product
		pList[1].NokiaCPQ_Category__c = '1000Base-SX';
		 pList[1].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[1].Pricing_Clusters__c = '';
		 pList[1].NokiaCPQ_State__c = 'Ramp Up';
		pList[1].NokiaCPQ_Item_Type__c = 'Service';
		pList[1].Business_Group__c='MN';		   
		pList[1].Portfolio__c = 'Airscale Wifi';
		pList[1].ProductCode = 'AirScaleWiFi';
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
		pList[2].Portfolio__c = 'Airscale Wifi';
		pList[2].ProductCode = 'AirScaleWiFi';
		pList[2].Apttus_Config2__ConfigurationType__c = 'Bundle';
		
		pList[3].NokiaCPQ_Category__c = '1000Base-SX';
		pList[3].NokiaCPQ_Product_Discount_Category__c = '';
		pList[3].Pricing_Clusters__c = '';
		pList[3].NokiaCPQ_State__c = 'Ramp Up';
		pList[3].NokiaCPQ_Item_Type__c = 'Service';
		pList[3].ProductCode = 'FC21001';
		pList[3].Business_Group__c='MN';		   
		pList[3].Portfolio__c = 'Airscale Wifi';
		pList[3].ProductCode = 'AirScaleWiFi';
		pList[3].Apttus_Config2__ConfigurationType__c = 'Standalone';
		pList[3].NokiaCPQ_Classification2__c = 'Deploy Services';
		
		pList[4].NokiaCPQ_Category__c = '1000Base-SX';
		pList[4].NokiaCPQ_Product_Discount_Category__c = '';
		pList[4].Pricing_Clusters__c = '';
		pList[4].NokiaCPQ_State__c = 'Ramp Up';
		pList[4].NokiaCPQ_Item_Type__c = 'Service';
		pList[4].ProductCode = 'FC21001';
		pList[4].Business_Group__c='MN';		   
		pList[4].Portfolio__c = 'Airscale Wifi';
		pList[4].ProductCode = 'AirScaleWiFi';
		pList[4].Apttus_Config2__ConfigurationType__c = 'Standalone';
		pList[3].NokiaCPQ_Classification2__c = 'Deploy Services';
		insert pList;
  
		NokiaCPQ_output_CSP_mapping__c cspmapping2 = new NokiaCPQ_output_CSP_mapping__c();
		cspmapping2.NokiaCPQ_code__c = 'FC20001';
		cspmapping2.Item_Level__c=1;
		cspmapping2.Quantity__c = 1;
		cspmapping2.QuoteId__c= proposals[0].Id;
		insert cspmapping2;
		
		NokiaCPQ_output_CSP_mapping__c cspmapping = new NokiaCPQ_output_CSP_mapping__c();
		cspmapping.NokiaCPQ_code__c = 'FC21005';
		cspmapping.Item_Level__c=2;
		cspmapping.Quantity__c = 100;
		cspmapping.QuoteId__c= proposals[0].Id;
	   
		cspmapping.NokiaCPQ_Parent_PCI__c=cspmapping2.Id;
		insert cspmapping;
		
		NokiaCPQ_output_CSP_mapping__c cspmapping1 = new NokiaCPQ_output_CSP_mapping__c();
		cspmapping1.NokiaCPQ_code__c = 'FC21009';
		cspmapping1.Item_Level__c=0;
		cspmapping1.Quantity__c = 200;
		cspmapping1.QuoteId__c= proposals[0].Id;
		cspmapping1.NokiaCPQ_Parent_PCI__c=cspmapping2.Id;
		insert cspmapping1;
		  //get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='EUR';
		priceList.Apttus_Config2__Active__c=true;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		insert priceList;
		
		Apttus_Config2__PriceListItem__c pli=new Apttus_Config2__PriceListItem__c();
		pli.Apttus_Config2__PriceListId__c=priceList.Id;
		pli.Apttus_Config2__ProductId__c=pList[1].Id;
		pli.Apttus_Config2__ChargeType__c='Standard Price';
		pli.Apttus_Config2__ListPrice__c=0;
		insert pli;
		 // create a product configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
		insert prodConfigs;
		// Creating Line Item
		Apttus_Config2__LineItem__c lineitem = new Apttus_Config2__LineItem__c();
		lineitem.Apttus_Config2__LineNumber__c=2;
		lineitem.Apttus_Config2__LineType__c='Product/Service';
		lineitem.Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		lineitem.Apttus_Config2__ItemSequence__c=1;
		lineitem.Apttus_Config2__IsPrimaryLine__c=true;
		lineitem.Apttus_Config2__TotalQuantity__c=1;
		lineitem.Apttus_Config2__SellingTerm__c=1;
		lineitem.Apttus_Config2__SellingFrequency__c='One Time';
		lineitem.Apttus_Config2__DeltaPrice__c=1139100.07;
		lineitem.Apttus_Config2__DeltaQuantity__c=1;
		lineitem.NokiaCPQ_IRP_Discount__c=31.66590246982185;

		insert lineitem;
		//Creating Delivery Sales Item
		Quote_Delivery_Sales_Item__c salesitem= new Quote_Delivery_Sales_Item__c();
		salesitem.Arcadia_Product_Code__c='ARC00010AA';
		salesitem.Product_Code__c='3HZ16085AAAA';
		salesitem.Quantity__c=200;
		salesitem.Item_Type__c='Order';
		salesitem.PCI_Code__c='SPS-ALU-PR-SW-PCI';
		salesitem.Proposal__c= proposals[0].Id;
		salesitem.Parent_Line_Item__c=lineitem.Id;
		salesitem.Name='2-ARC00010AA-1';
		insert salesitem;
		
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
		insert plistItems;
		
		List<Apttus_Config2__LineItem__c> prodConfigsLineItems = NOKIA_CPQ_TestDataFactory.createLineItem(5);
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
		prodConfigsLineItems[3].Apttus_Config2__LineSequence__c = 2;
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
		prodConfigsLineItems[4].Apttus_Config2__LineSequence__c = 3;
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

		insert prodConfigsLineItems;
		
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(5);
		proposalLineItemList[0].NokiaCPQ_Spare__c = false;
		proposalLineItemList[0].Apttus_Proposal__Product__c  = pList[0].Id;
		proposalLineItemList[0].Apttus_QPConfig__OptionId__c = pList[0].Id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[0].Apttus_QPConfig__ParentBundleNumber__c = Null;
		proposalLineItemList[0].NokiaCPQ_Configuration_Type__c = 'Bundle';
		proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[0].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[0].is_Custom_Product__c = false;
		proposalLineItemList[0].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[0].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[0].Apttus_QPConfig__PrimaryLineNumber__c = 1;
		proposalLineItemList[0].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[0].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[0].id;
		
		proposalLineItemList[1].NokiaCPQ_Spare__c = false;
		proposalLineItemList[1].Apttus_Proposal__Product__c  = pList[1].Id;
		proposalLineItemList[1].Apttus_QPConfig__OptionId__c = pList[1].Id;
		proposalLineItemList[1].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[1].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[1].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[1].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[1].is_Custom_Product__c = false;
		proposalLineItemList[1].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[1].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[1].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[1].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[1].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[1].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[1].id;
		
		proposalLineItemList[2].NokiaCPQ_Spare__c = false;
		proposalLineItemList[2].Apttus_Proposal__Product__c  = pList[2].Id;
		proposalLineItemList[2].Apttus_QPConfig__OptionId__c = pList[2].Id;
		proposalLineItemList[2].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[2].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[2].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[2].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[2].is_Custom_Product__c = false;
		proposalLineItemList[2].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[2].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[2].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[2].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[2].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[2].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[2].id;
		
		proposalLineItemList[3].NokiaCPQ_Spare__c = false;
		proposalLineItemList[3].Apttus_Proposal__Product__c = pList[3].Id;
		proposalLineItemList[3].Apttus_QPConfig__OptionId__c = pList[3].Id;
		proposalLineItemList[3].Apttus_Proposal__Proposal__c = proposals[0].Id;
		//proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[3].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[3].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[3].is_Custom_Product__c = false;
		proposalLineItemList[3].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[3].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[3].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[3].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[3].Apttus_Proposal__Description__c = 'GS Deploy Services Items';
		proposalLineItemList[3].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[3].id;
		
		proposalLineItemList[4].NokiaCPQ_Spare__c = false;
		proposalLineItemList[4].Apttus_Proposal__Product__c = pList[4].Id;
		proposalLineItemList[4].Apttus_QPConfig__OptionId__c = pList[4].Id;
		proposalLineItemList[4].Apttus_Proposal__Proposal__c = proposals[0].Id;
		//proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[4].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[4].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[4].is_Custom_Product__c = false;
		proposalLineItemList[4].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[4].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[4].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[4].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[4].Apttus_Proposal__Description__c = 'GS Deploy Services Items';
		proposalLineItemList[4].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[4].id;
		
		insert proposalLineItemList;
		System.debug('proposalLineItemList[0] : '+proposalLineItemList[0]);
		System.debug('proposalLineItemList[1] : '+proposalLineItemList[1]);
		System.debug('proposalLineItemList[2] : '+proposalLineItemList[2]);
		
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
		
		for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItemObj : proposalLineItemList){
		  finalPLImap.put(proposalLineItemObj, proposalLineItemList);
			mapLineNumberAndMainBundlePLIObj.put(proposalLineItemObj.Apttus_QPConfig__LineNumber__c,proposalLineItemObj);
		}
	   /*for(NokiaCPQ_CSP_Map_Control__c cspMapControl1 : mapControlList){
			productNameAndNokiaCSPMapControl.put(cspMapControl1.Product_Code__c,cspMapControl1);
		}*/
		for(Apttus_QPConfig__ProposalProductAttributeValue__c pavObj : pavList){
			finalAttributePLImap.put(pavObj.Apttus_QPConfig__LineItemId__c,pavObj);
			
		}
		//finalAttributePLImap.put(pav.Apttus_QPConfig__LineItemId__c,pav);
		Test.startTest();
		NokiaCPQ_CSP_Export_Generator.mapPLIwithCSPexportMap(finalPLImap, finalAttributePLImap, proposals[0].id);
		//NokiaCPQ_CSP_Export_Generator.generateCSPOutpurRec(null);
		//NokiaCPQ_CSP_Export_Generator.generateCSPOutpurRec(proposalLineItemList,salesitem,2, '', proposals[0].id,3,'EUR',cspmapping,proposalLineItemList,'','',3,'');
		NokiaCPQ_CSP_Export_Generator.generateParentToSIFinalMap(finalPLImap,productNameAndNokiaCSPMapControl);
		NokiaCPQ_CSP_Export_Generator.PLIbundleOptionMapping(null);
		NokiaCPQ_CSP_Export_Generator.gernerateMapPCICodeAndListPLIs(finalPLImap);
		NokiaCPQ_CSP_Export_Generator.getPCICodeAndDeliverySalesItem(proposals[0].id,proposalLineItemList,mapLineNumberAndMainBundlePLIObj);
		Test.stopTest();
	}
	
	static testmethod void getPLIbundleOptionMapping_testMethod5(){
	  //Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSIFinalMap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
	  //Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> PLIandAttributeMap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
		Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> finalPLImap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
		Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> finalAttributePLImap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
		 Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c> mapLineNumberAndMainBundlePLIObj = new Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c>();
		 Map<String, NokiaCPQ_CSP_Map_Control__c> productNameAndNokiaCSPMapControl = new Map<String, NokiaCPQ_CSP_Map_Control__c>();
		//create Mapping
		List<NokiaCPQ_CSP_Map_Control__c> mapControlList = new List<NokiaCPQ_CSP_Map_Control__c>();
		NokiaCPQ_CSP_Map_Control__c mapControl = new NokiaCPQ_CSP_Map_Control__c();
		mapControl.Name = 'AirScale Wi-Fi';
		mapControl.Portfolio__c = 'Airscale Wifi';
		mapControl.Product_Code__c = 'AirScaleWiFi';
		mapControl.Source__c = 'Table';
		//mapControl.Map_Mode__c = 'Split';
		mapControl.Splitlevel__c = '1';
		insert mapControl;
		mapControlList.add(mapControl);
		productNameAndNokiaCSPMapControl.put(mapControl.Product_Code__c,mapControl);
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();		
		insert opportunities;			 
		
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].Reprice_In_Progress__c = false;
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId(); 
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Basic';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		proposals[0].NokiaCPQ_Portfolio__c = 'Airscale Wifi';
		proposals[0].NokiaCPQ_SSP_Level__c = '';
		insert proposals;		
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);
		
		//get a Product Apttus_Config2__ConfigurationType__c  
		List <Product2> pList = NOKIA_CPQ_TestDataFactory.productCreationDirect(9);
		pList[0].NokiaCPQ_Category__c = '1000Base-SX';
		pList[0].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		 pList[0].Pricing_Clusters__c = '';
		pList[0].NokiaCPQ_State__c = 'Ramp Up';
		pList[0].NokiaCPQ_Item_Type__c = 'Service';
		pList[0].Business_Group__c='MN';		   
		pList[0].Portfolio__c = 'Airscale Wifi';
		pList[0].ProductCode = 'AirScaleWiFi';
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
		pList[1].Portfolio__c = 'Airscale Wifi';
		pList[1].ProductCode = 'AirScaleWiFi';
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
		pList[2].Portfolio__c = 'Airscale Wifi';
		pList[2].ProductCode = 'AirScaleWiFi';
		pList[2].Apttus_Config2__ConfigurationType__c = 'Bundle';
		
		pList[3].NokiaCPQ_Category__c = '1000Base-SX';
		pList[3].NokiaCPQ_Product_Discount_Category__c = '';
		pList[3].Pricing_Clusters__c = '';
		pList[3].NokiaCPQ_State__c = 'Ramp Up';
		pList[3].NokiaCPQ_Item_Type__c = 'Service';
		pList[3].ProductCode = 'FC21001';
		pList[3].Business_Group__c='MN';		   
		pList[3].Portfolio__c = 'Airscale Wifi';
		pList[3].ProductCode = 'AirScaleWiFi';
		pList[3].Apttus_Config2__ConfigurationType__c = 'Standalone';
		pList[3].NokiaCPQ_Classification2__c = 'Deploy Services';
		
		pList[4].NokiaCPQ_Category__c = '1000Base-SX';
		pList[4].NokiaCPQ_Product_Discount_Category__c = '';
		pList[4].Pricing_Clusters__c = '';
		pList[4].NokiaCPQ_State__c = 'Ramp Up';
		pList[4].NokiaCPQ_Item_Type__c = 'Service';
		pList[4].ProductCode = 'FC21001';
		pList[4].Business_Group__c='MN';		   
		pList[4].Portfolio__c = 'Airscale Wifi';
		pList[4].ProductCode = 'AirScaleWiFi';
		pList[4].Apttus_Config2__ConfigurationType__c = 'Standalone';
		pList[4].NokiaCPQ_Classification2__c = 'Deploy Services';
		
		pList[5].NokiaCPQ_Category__c = '1000Base-SX';
		pList[5].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[5].Pricing_Clusters__c = '';
		pList[5].NokiaCPQ_State__c = 'Ramp Up';
		pList[5].NokiaCPQ_Item_Type__c = 'Service';
		pList[5].Business_Group__c='MN';		   
		pList[5].Portfolio__c = 'Airscale Wifi';
		pList[5].ProductCode = 'CUSTPROD001';
		pList[5].Apttus_Config2__ConfigurationType__c = 'Bundle';
		
		pList[6].NokiaCPQ_Category__c = '1000Base-SX';
		pList[6].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[6].Pricing_Clusters__c = '';
		pList[6].NokiaCPQ_State__c = 'Ramp Up';
		pList[6].NokiaCPQ_Item_Type__c = 'Software';
		pList[6].Business_Group__c='MN';		   
		pList[6].Portfolio__c = 'Airscale Wifi';
		pList[6].ProductCode = 'CUSTPRO';
		pList[6].Apttus_Config2__ConfigurationType__c = 'Bundle';
		pList[6].NokiaCPQ_Classification2__c ='Deploy Services';
	   
		pList[7].NokiaCPQ_Category__c = '1000Base-SX';
		pList[7].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[7].Pricing_Clusters__c = '';
		pList[7].NokiaCPQ_State__c = 'Ramp Up';
		pList[7].NokiaCPQ_Item_Type__c = 'Hardware';
		pList[7].Business_Group__c='MN';		   
		pList[7].Portfolio__c = 'Airscale Wifi';
		pList[7].ProductCode = 'CUSTPROD';
		pList[7].Apttus_Config2__ConfigurationType__c = 'Bundle';
		pList[7].NokiaCPQ_Classification2__c ='Deploy Services';
		
		pList[8].NokiaCPQ_Category__c = '1000Base-SX';
		pList[8].NokiaCPQ_Product_Discount_Category__c = '';
		//pList[0].Pricing_Clusters_Search_Filter__c =',';
		pList[8].Pricing_Clusters__c = '';
		pList[8].NokiaCPQ_State__c = 'Ramp Up';
		pList[8].NokiaCPQ_Item_Type__c = 'Service';
		pList[8].Business_Group__c='MN';		   
		pList[8].Portfolio__c = 'Airscale Wifi';
		pList[8].ProductCode = 'AirScaleWiFi';
		pList[8].Apttus_Config2__ConfigurationType__c = 'Bundle';
		pList[8].NokiaCPQ_Classification2__c ='Deploy Services';
		insert pList;

		NokiaCPQ_output_CSP_mapping__c cspmapping2 = new NokiaCPQ_output_CSP_mapping__c();
		cspmapping2.NokiaCPQ_code__c = 'FC20001';
		cspmapping2.Item_Level__c=1;
		cspmapping2.Quantity__c = 1;
		cspmapping2.QuoteId__c= proposals[0].Id;
		insert cspmapping2;
		
		NokiaCPQ_output_CSP_mapping__c cspmapping = new NokiaCPQ_output_CSP_mapping__c();
		cspmapping.NokiaCPQ_code__c = 'FC21005';
		cspmapping.Item_Level__c=2;
		cspmapping.Quantity__c = 100;
		cspmapping.QuoteId__c= proposals[0].Id;
	   
		cspmapping.NokiaCPQ_Parent_PCI__c=cspmapping2.Id;
		insert cspmapping;
		
		NokiaCPQ_output_CSP_mapping__c cspmapping1 = new NokiaCPQ_output_CSP_mapping__c();
		cspmapping1.NokiaCPQ_code__c = 'FC21009';
		cspmapping1.Item_Level__c=0;
		cspmapping1.Quantity__c = 200;
		cspmapping1.QuoteId__c= proposals[0].Id;
		cspmapping1.NokiaCPQ_Parent_PCI__c=cspmapping2.Id;
		insert cspmapping1;
		  //get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='EUR';
		priceList.Apttus_Config2__Active__c=true;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		insert priceList;
		
		Apttus_Config2__PriceListItem__c pli=new Apttus_Config2__PriceListItem__c();
		pli.Apttus_Config2__PriceListId__c=priceList.Id;
		pli.Apttus_Config2__ProductId__c=pList[1].Id;
		pli.Apttus_Config2__ChargeType__c='Standard Price';
		pli.Apttus_Config2__ListPrice__c=0;
		insert pli;
		 // create a product configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
		insert prodConfigs;
		
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
		
		Apttus_Config2__PriceListItem__c pLI7 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[6].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI7);
		
		Apttus_Config2__PriceListItem__c pLI8 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[7].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI8);
		
		Apttus_Config2__PriceListItem__c pLI9 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = pList[8].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI9);
		insert plistItems;
		
		List<Apttus_Config2__LineItem__c> prodConfigsLineItems = NOKIA_CPQ_TestDataFactory.createLineItem(9);
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
		prodConfigsLineItems[3].Apttus_Config2__LineSequence__c = 2;
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
		prodConfigsLineItems[4].Apttus_Config2__LineSequence__c = 3;
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
		prodConfigsLineItems[5].Apttus_Config2__LineSequence__c = 4;
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
		
		prodConfigsLineItems[6].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[6].Apttus_Config2__LineSequence__c = 5;
		prodConfigsLineItems[6].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[6].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[6].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[6].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[6].Apttus_Config2__ProductId__c = pList[6].Id;
		prodConfigsLineItems[6].Apttus_Config2__PriceListItemId__c = pLI7.id;
		prodConfigsLineItems[6].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[6].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[6].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[6].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[6].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[6].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[7].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[7].Apttus_Config2__LineSequence__c = 6;
		prodConfigsLineItems[7].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[7].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[7].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[7].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[7].Apttus_Config2__ProductId__c = pList[7].Id;
		prodConfigsLineItems[7].Apttus_Config2__PriceListItemId__c = pLI8.id;
		prodConfigsLineItems[7].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[7].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[7].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[7].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[7].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[7].Apttus_Config2__AddedBy__c = 'added by code';
		
		prodConfigsLineItems[8].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
		prodConfigsLineItems[8].Apttus_Config2__LineSequence__c = 6;
		prodConfigsLineItems[8].Apttus_Config2__LineStatus__c='New';
		prodConfigsLineItems[8].Apttus_Config2__PriceListId__c = priceList.id;
		prodConfigsLineItems[8].Apttus_Config2__ChargeType__c = 'Standard Price';
		prodConfigsLineItems[8].Apttus_Config2__LineType__c = 'Product/Service';
		prodConfigsLineItems[8].Apttus_Config2__ProductId__c = pList[8].Id;
		prodConfigsLineItems[8].Apttus_Config2__PriceListItemId__c = pLI9.id;
		prodConfigsLineItems[8].Apttus_Config2__PriceMethod__c = 'Per Unit';
		prodConfigsLineItems[8].Apttus_Config2__Frequency__c = 'One Time';
		prodConfigsLineItems[8].Apttus_Config2__AdjustmentAmount__c = 100.00;
		prodConfigsLineItems[8].Apttus_Config2__ListPrice__c = 200;
		prodConfigsLineItems[8].Apttus_Config2__PrimaryLineNumber__c = 1;
		//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		prodConfigsLineItems[8].Apttus_Config2__AddedBy__c = 'added by code';

		insert prodConfigsLineItems;
		
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(9);
		proposalLineItemList[0].NokiaCPQ_Spare__c = false;
		proposalLineItemList[0].Apttus_Proposal__Product__c  = pList[0].Id;
		proposalLineItemList[0].Apttus_QPConfig__OptionId__c = pList[0].Id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[0].Apttus_QPConfig__ParentBundleNumber__c = Null;
		proposalLineItemList[0].NokiaCPQ_Configuration_Type__c = 'Bundle';
		proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[0].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[0].is_Custom_Product__c = false;
		proposalLineItemList[0].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[0].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[0].Apttus_QPConfig__PrimaryLineNumber__c = 1;
		proposalLineItemList[0].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[0].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[0].id;
		
		proposalLineItemList[1].NokiaCPQ_Spare__c = false;
		proposalLineItemList[1].Apttus_Proposal__Product__c  = pList[1].Id;
		proposalLineItemList[1].Apttus_QPConfig__OptionId__c = pList[1].Id;
		proposalLineItemList[1].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[1].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[1].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[1].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[1].is_Custom_Product__c = false;
		proposalLineItemList[1].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[1].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[1].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[1].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[1].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[1].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[1].id;
		
		proposalLineItemList[2].NokiaCPQ_Spare__c = false;
		proposalLineItemList[2].Apttus_Proposal__Product__c  = pList[2].Id;
		proposalLineItemList[2].Apttus_QPConfig__OptionId__c = pList[2].Id;
		proposalLineItemList[2].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[2].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[2].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[2].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[2].is_Custom_Product__c = false;
		proposalLineItemList[2].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[2].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[2].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[2].Apttus_QPConfig__PrimaryLineNumber__c = 3;
		proposalLineItemList[2].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[2].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[2].id;
		
		proposalLineItemList[3].NokiaCPQ_Spare__c = false;
		proposalLineItemList[3].Apttus_Proposal__Product__c = pList[3].Id;
		proposalLineItemList[3].Apttus_QPConfig__OptionId__c = pList[3].Id;
		proposalLineItemList[3].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[3].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[3].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[3].is_Custom_Product__c = false;
		proposalLineItemList[3].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[3].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[3].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[3].Apttus_QPConfig__PrimaryLineNumber__c = 4;
		proposalLineItemList[3].Apttus_Proposal__Description__c = 'GS Deploy Services Items';
		proposalLineItemList[3].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[3].id;
		
		proposalLineItemList[4].NokiaCPQ_Spare__c = false;
		proposalLineItemList[4].Apttus_Proposal__Product__c = pList[4].Id;
		proposalLineItemList[4].Apttus_QPConfig__OptionId__c = pList[4].Id;
		proposalLineItemList[4].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[4].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[4].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[4].is_Custom_Product__c = false;
		proposalLineItemList[4].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[4].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[4].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[4].Apttus_QPConfig__PrimaryLineNumber__c = 5;
		proposalLineItemList[4].Apttus_Proposal__Description__c = 'GS Deploy Services Items';
		proposalLineItemList[4].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[4].id;
		
		proposalLineItemList[5].NokiaCPQ_Spare__c = false;
		proposalLineItemList[5].Apttus_Proposal__Product__c  = pList[5].Id;
		proposalLineItemList[5].Apttus_QPConfig__OptionId__c = pList[5].Id;
		proposalLineItemList[5].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[5].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[5].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[5].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[5].is_Custom_Product__c = false;
		proposalLineItemList[5].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[5].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[5].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[5].Apttus_QPConfig__PrimaryLineNumber__c = 6;
		proposalLineItemList[5].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[5].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[5].id;
		
		proposalLineItemList[6].Apttus_Proposal__Product__c  = pList[6].Id;
		proposalLineItemList[6].Apttus_QPConfig__OptionId__c = pList[6].Id;
		proposalLineItemList[6].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[6].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[6].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[6].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[6].is_Custom_Product__c = false;
		proposalLineItemList[6].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[6].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[6].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[6].Apttus_QPConfig__PrimaryLineNumber__c = 7;
		proposalLineItemList[6].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[6].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[6].id;
		
		proposalLineItemList[7].Apttus_Proposal__Product__c  = pList[7].Id;
		proposalLineItemList[7].Apttus_QPConfig__OptionId__c = pList[7].Id;
		proposalLineItemList[7].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[7].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[7].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[7].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[7].is_Custom_Product__c = false;
		proposalLineItemList[7].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItemList[7].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[7].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[7].Apttus_QPConfig__PrimaryLineNumber__c = 8;
		proposalLineItemList[7].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[7].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[7].id;
		
		proposalLineItemList[8].Apttus_Proposal__Product__c  = pList[8].Id;
		proposalLineItemList[8].Apttus_QPConfig__OptionId__c = pList[8].Id;
		proposalLineItemList[8].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[8].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[8].NokiaCPQ_Configuration_Type__c = 'Product/Service';
		proposalLineItemList[8].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[8].is_Custom_Product__c = false;
		proposalLineItemList[8].Apttus_QPConfig__LineType__c = 'Standalone';
		proposalLineItemList[8].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[8].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[8].Apttus_QPConfig__PrimaryLineNumber__c = 9;
		proposalLineItemList[8].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[8].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[8].id;
		
		insert proposalLineItemList;
		System.debug('proposalLineItemList[0] : '+proposalLineItemList[0]);
		System.debug('proposalLineItemList[1] : '+proposalLineItemList[1]);
		System.debug('proposalLineItemList[2] : '+proposalLineItemList[2]);
		
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
		
		for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItemObj : proposalLineItemList){
		  finalPLImap.put(proposalLineItemObj, proposalLineItemList);
			mapLineNumberAndMainBundlePLIObj.put(proposalLineItemObj.Apttus_QPConfig__LineNumber__c,proposalLineItemObj);
		}
		for(Apttus_QPConfig__ProposalProductAttributeValue__c pavObj : pavList){
			finalAttributePLImap.put(pavObj.Apttus_QPConfig__LineItemId__c,pavObj);
			
		}
		//finalAttributePLImap.put(pav.Apttus_QPConfig__LineItemId__c,pav);
		Test.startTest();
		//NokiaCPQ_CSP_Export_Generator.mapPLIwithCSPexportMap(finalPLImap, finalAttributePLImap, proposals[0].id);
		//NokiaCPQ_CSP_Export_Generator.generateParentToSIFinalMap(finalPLImap,productNameAndNokiaCSPMapControl);
		NokiaCPQ_CSP_Export_Generator.PLIbundleOptionMapping(proposals[0].id);
		//NokiaCPQ_CSP_Export_Generator.gernerateMapPCICodeAndListPLIs(finalPLImap);
		//NokiaCPQ_CSP_Export_Generator.getPCICodeAndDeliverySalesItem(proposals[0].id,proposalLineItemList,mapLineNumberAndMainBundlePLIObj);
		Test.stopTest();
	}
	
	static testmethod void testMethod6(){
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
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();		
		insert opportunities;			 
		
		//create a quote
		Apttus_Proposal__Proposal__c  proposals = new Apttus_Proposal__Proposal__c();
		proposals.Apttus_Proposal__Account__c = accounts[0].Id;
		proposals.Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals.NokiaCPQ_Needs_Reprice__c = false;
		proposals.Reprice_In_Progress__c = false;
		proposals.RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId(); 
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
		prodConfigsLineItems[1].Apttus_Config2__PrimaryLineNumber__c = 2;
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
		prodConfigsLineItems[2].Apttus_Config2__PrimaryLineNumber__c = 3;
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
		prodConfigsLineItems[3].Apttus_Config2__PrimaryLineNumber__c = 4;
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
		prodConfigsLineItems[4].Apttus_Config2__PrimaryLineNumber__c = 5;
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
		prodConfigsLineItems[5].Apttus_Config2__PrimaryLineNumber__c = 6;
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
		proposalLineItemList[2].PCI_Code__c = 'FC20002';
		
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
		
		list<Quote_Delivery_Sales_Item__c> listQDSI = new list<Quote_Delivery_Sales_Item__c>();
		Quote_Delivery_Sales_Item__c salesitem= new Quote_Delivery_Sales_Item__c();
		salesitem.Arcadia_Product_Code__c='ARC00010AA';
		salesitem.Product_Code__c='3HZ16085AAAA';
		salesitem.Quantity__c=200;
		salesitem.Item_Type__c='Order';
		salesitem.PCI_Code__c='FC20002';
		salesitem.Proposal__c= proposals.Id;
		salesitem.Parent_Line_Item__c=prodConfigsLineItems[2].Id;
		salesitem.Name='2-ARC00010AA-1';
		listQDSI.add(salesitem);
		
		insert listQDSI;
		
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
		//finalAttributePLImap.put(pav.Apttus_QPConfig__LineItemId__c,pav);
		Test.startTest();
		NokiaCPQ_CSP_Export_Generator.PLIbundleOptionMapping(proposals.id);
		NokiaCPQ_CSP_Export_Generator.PLIbundleOptionMapping(NULL);
		Test.stopTest();
	}
}