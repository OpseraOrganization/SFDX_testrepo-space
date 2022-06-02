@isTest
public class CartService_Test {
	
	@testSetup
	public static void testdataSetup() {
		insert new Product2(Name = 'Smart Plan Suite (SPS)', ProductCode = '833-052315');
	}
	
	@isTest
	public static void testUpsertData() {			
		CartService.UpsertData();
		//create account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//Create Opportunity
		List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		insert opportunities1;
						
		//List<Product2> prods1 = [select Business_Group__c,Id,ProductCode from Product2 where name = 'Smart Plan Suite (SPS)' ];
		List<Product2> prods1 = new list<Product2>();
		product2 prod = TestDataFactory.productCreation(1)[0];
			prod.Business_Group__c='MN';
			prod.Family= 'FN';
		prod.name='Smart Plan Suite (SPS)';
		prod.ProductCode = 'ARC00010AA';
			prod.Portfolio__c = 'test';
		prods1.add(prod);
			database.insert (prods1);
		
		List<Apttus_Config2__PriceList__c> ApttusTestPriceList = new List<Apttus_Config2__PriceList__c>{new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
		), new Apttus_Config2__PriceList__c(
			Name = 'Global Price List (EUR)', 
			Apttus_Config2__Active__c = True
		)};
		insert ApttusTestPriceList;
		
		List<Apttus_Config2__PriceList__c> ApttusTestPriceList1 = [select id,name , Apttus_Config2__Active__c from Apttus_Config2__PriceList__c where name = 'Global Price List (EUR)' ];			   
		
		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList[0].Id,
			Apttus_Config2__ListPrice__c = 100,		 
			Apttus_Config2__ChargeType__c = 'Standard Price',
			Apttus_Config2__ProductId__c = prods1[0].Id
		);					
		
		//insert pLI1;
		plistItems.add(pLI1);
		if(!plistItems.isempty()) {
			insert plistItems;	
		}
		
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();//direct draft quote
		proposals[0].NokiaCPQ_Maintenance_Type__c = '';
		insert proposals;
		test.startTest();
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c();
		ProdConfig.Name = 'APTTUS Test Config';
		ProdConfig.Apttus_Config2__AccountId__c = accounts[0].Id;
		ProdConfig.Apttus_Config2__PriceListId__c = ApttusTestPriceList[0].Id;
		ProdConfig.Apttus_QPConfig__Proposald__c = proposals[0].Id;
		ProdConfig.Apttus_Config2__Status__c = 'New';
		ProdConfig.Apttus_Config2__VersionNumber__c = 1;
		ProdConfig.Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList[0].Id;
		ProdConfig.Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id);
		ProdConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
		
		insert ProdConfig;
		
		//Create Line Items
		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c= ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList[0].id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prods1[0].Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code',
			Apttus_Config2__OptionId__c = prods1[0].Id
		);							
		insert LineItem1;
		
		//Create summary Group
		list<Apttus_Config2__SummaryGroup__c> allSummarygrps = new List<Apttus_Config2__SummaryGroup__c>();
		Apttus_Config2__SummaryGroup__c allSummarygrp1 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Configurable Products',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 0,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		allSummarygrps.add(allSummarygrp1);
		Apttus_Config2__SummaryGroup__c allSummarygrp2 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Configurable Products',
			Apttus_Config2__LineNumber__c = 2,
			Apttus_Config2__ItemSequence__c = 2,
			Apttus_Config2__ConfigurationId__c =  ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 120,
			Apttus_Config2__Description__c = 'Maintenance Y1 (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 80,
			Apttus_Config2__ChargeType__c = 'Maintenance Y1',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		
		allSummarygrps.add(allSummarygrp2);
		Apttus_Config2__SummaryGroup__c allSummarygrp3 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Configurable Products',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600, 
			Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 800,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		allSummarygrps.add(allSummarygrp3);
		insert(allSummarygrps);
		
		
		//creation of json 
		CARTServiceData.bom_data cd = new CARTServiceData.bom_data();
		cd.product_code = '833-052315.00';
		cd.quantity = 1;
		cd.pci_code = '0';
		cd.item_type = 'Hardware';
		
		CARTServiceData csd = new CARTServiceData();
		CARTServiceData.Header hdr = new CARTServiceData.Header();
		hdr.cart_id = ProdConfig.Id;
		hdr.config_id = LineItem1.Id;
		csd.header = hdr;
		
		csd.cfg_data = 'eyJkYXRhIjp7Ii1aSUQiOiJDMTU1OTA1MjcwNzAwMjEiLCItUk9PVF9OUiI6IjEiLCItQ09OU0lTVEVOVCI6IlQiLCItQ09NUExFVEUiOiJUIiwiLUtCTkFNRSI6IjgzMy0wMDU5MDMuMDAiLCItS0JCVUlMRCI6IjkiLCItS0JWRVJTSU9OIjoiVEVTVF8yMDE3MDMyMCIsIi1aTkFNRSI6IlNQQiIsIi1aU0FDVElPTiI6Ii96aXBjNy9pcGMvRHluYW1pY1VJTmF2aWdhdGlvbi8obGF5b3V0PTEzXzBfMV83XzhfMTJfMjRfOV82JmNTY3JvbGxDaGFyR3JvdXBOYW1lPTEpLy5kbztqc2Vzc2lvbmlkPVBCclJieWNWRzlmc2NESkdNZWE3cm9FUGI4ai1hZ0VMR2tVQV9TQVBqeENISGFKLVZCa3NRX00xa3lzZGpuOXQ7c2FwbGJfKj0oSjJFRTQ1Mjg2MjApNDUyODY1MSIsIi1aU1BBUkVOVCI6IiIsIi1aVEFCSURYIjoiIiwiLVpTVUkiOiI4MzMtMDA1OTAzLjAwIiwiLVpGTFVJRCI6IiIsIi1aQk9NIjoiIiwiLVpCT01ERUxUQSI6IiIsIklOU1QiOnsiZGF0YSI6eyItTlIiOiIxIiwiLU9CSl9UWVBFIjoiTUFSQSIsIi1DTEFTU19UWVBFIjoiMzAwIiwiLU9CSl9LRVkiOiI4MzMtMDA1OTAzLjAwIiwiLU9CSl9UWFQiOiJTbWFydCBQbGFuIEJ1aWxkZXIiLCItUVRZIjoiMS4wIiwiLVVOSVQiOiJTVCIsIi1BVVRIT1IiOiI2IiwiLUNPTVBMRVRFIjoiVCIsIi1DT05TSVNURU5UIjoiVCIsIkNTVElDUyI6eyJDU1RJQyI6W3siZGF0YSI6eyItQVVUSE9SIjoiICIsIi1DSEFSQyI6IlNQQl9BUkNfVVNFUl9UWVBFIiwiLUNIQVJDX1RYVCI6IlVTRVIiLCItVkFMVUUiOiJFWFBFUlQiLCItVkFMVUVfVFhUIjoiIn19LHsiZGF0YSI6eyItQVVUSE9SIjoiICIsIi1DSEFSQyI6IlNQQl9BUkNfQ0hBUkdJTkdfRSIsIi1DSEFSQ19UWFQiOiJDaGFyZ2luZyBlbmFibGVkIiwiLVZBTFVFIjoiVCIsIi1WQUxVRV9UWFQiOiIifX0seyJkYXRhIjp7Ii1BVVRIT1IiOiIgIiwiLUNIQVJDIjoiU1BCX0FSQ19DSEFSR0lOR19ERVZJQ0VfRSIsIi1DSEFSQ19UWFQiOiJOdW1iZXIgb2YgQ2hhcmdpbmcgRGV2aWNlcyIsIi1WQUxVRSI6IjIwMC4wMDAuMDAwIiwiLVZBTFVFX1RYVCI6IiJ9fSx7ImRhdGEiOnsiLUFVVEhPUiI6IiAiLCItQ0hBUkMiOiJTUEJfQVJDX0NIQVJHX1ZNU19FIiwiLUNIQVJDX1RYVCI6Ik51bWJlciBvZiBDaGFyZ2luZyBWTXMiLCItVkFMVUUiOiI5LjAwMCIsIi1WQUxVRV9UWFQiOiIifX0seyJkYXRhIjp7Ii1BVVRIT1IiOiIgIiwiLUNIQVJDIjoiU1BCX0NERV9FIiwiLUNIQVJDX1RYVCI6Ik51bWJlciBvZiBtb250aHMgb2YgdGVjaG5pY2FsIGhlYWRjb3VudCBzdXBwb3J0IHJlcXVpcmVkIGZvciBDdXN0b20gRmVhdHVyZSIsIi1WQUxVRSI6IjEuMDAwIiwiLVZBTFVFX1RYVCI6IiJ9fSx7ImRhdGEiOnsiLUFVVEhPUiI6IiAiLCItQ0hBUkMiOiJHRU5fRUNDX1NXXzAxIiwiLUNIQVJDX1RYVCI6IlNXIERhdGEgQ2FycmllciBzZWxlY3Rpb24iLCItVkFMVUUiOiJOTyIsIi1WQUxVRV9UWFQiOiIifX0seyJkYXRhIjp7Ii1BVVRIT1IiOiIgIiwiLUNIQVJDIjoiR0VOX0VDQ19MSUNfMDEiLCItQ0hBUkNfVFhUIjoiTGljZW5zZSBDZXJ0aWZpY2F0ZSBEYXRhIGNhcnJpZXIgc2VsZWN0aW9uIiwiLVZBTFVFIjoiTk8iLCItVkFMVUVfVFhUIjoiIn19LHsiZGF0YSI6eyItQVVUSE9SIjoiICIsIi1DSEFSQyI6IkdFTl9FQ0NfQ09VTlRSWSIsIi1DSEFSQ19UWFQiOiJDb3VudHJ5IiwiLVZBTFVFIjoiREUiLCItVkFMVUVfVFhUIjoiIn19XX19fSwiUEFSVFMiOnsiUEFSVCI6W119fX0=';	 
		
		CARTServiceData.bom_data  bdata = new CARTServiceData.bom_data();
		bdata.product_code= '833-051870.00';
		bdata.pci_code= '0';
		bdata.item_type= 'Product';
		
		List<CARTServiceData.bom_data> children = new List<CARTServiceData.bom_data>();
		CARTServiceData.bom_data  bdata1 = new CARTServiceData.bom_data();
		bdata1.product_code= '833-051870.00';
		bdata1.pci_code= '0';
		bdata1.item_type= 'Product';
		List<CARTServiceData.bom_data> children1 = new List<CARTServiceData.bom_data>();
		CARTServiceData.bom_data  bdata2 = new CARTServiceData.bom_data();
		bdata2.product_code= 'ARC00010AA';
		bdata2.quantity= 200;
		bdata2.pci_code= 'SPS-ALU-PR-SW-PCI';
		bdata2.item_type='Offer';
		children.add(bdata1);
		children1.add(bdata2);
		List<CARTServiceData.bom_data> children2 = new List<CARTServiceData.bom_data>();
		CARTServiceData.bom_data  bdata3 = new CARTServiceData.bom_data();
		bdata3.product_code= '1AK40746AAAA';
		bdata3.quantity= 2;
		bdata3.pci_code= 'SPS-ARC10AA-SW-PCI';
		bdata3.item_type='Order'; 
		children2.add(bdata3);
		bdata2.children = children2;
		bdata1.children = children1;
		bdata.children = children;
		List<CARTServiceData.bom_data> childrenmain = new List<CARTServiceData.bom_data>();
		csd.bom_data = bdata.children;
		
		String myJSON = JSON.serialize(csd);
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/cartService/'; 
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(myJSON);
		RestContext.request = req;		
		RestContext.response= res;
		CartService cs = new CartService();
		List<CARTServiceData.bom_data> firstLineItem = new List<CARTServiceData.bom_data>();		
		CartService.addArcadiaItems('',1.1,ProdConfig,firstLineItem,true);
		CartService.UpsertData();		
		Apttus_CPQApi.CPQ.ProductOptionGroupSearchResultDO result;
		result = Apttus_CPQApi.CPQWebService.getOptionGroupsForPriceListProduct(ApttusTestPriceList1[0].id,prods1[0].id);						  
		List<Apttus_CPQApi.CPQ.ProductOptionGroupDO> prodOptGrpDOList = result.OptionGroups;			
		Set<String> arcadiaProductList = new Set<String>();
		arcadiaProductList.add(prods1[0].Id);  
		Map<String,Integer> productAndQuantityMap = new Map<String,Integer>();
		Map<String,String> prodIdAndCodeMap = new Map<String,String>();
		Map<String,Decimal> arcadiaAndCostMap = new Map<String,Decimal>();
		Map<String,CARTServiceData.bom_data> arcadiaProductsMap = new Map<String,CARTServiceData.bom_data>();
		productAndQuantityMap.put('833-052315.00',1);
		prodIdAndCodeMap.put(prods1[0].Id,'833-052315.00');
		arcadiaAndCostMap.put(prods1[0].Id,0);
		arcadiaProductsMap.put(bdata2.product_code,bdata2);
		CartService.addSelectedOptions(prodOptGrpDOList, arcadiaProductList, productAndQuantityMap, prodIdAndCodeMap, arcadiaAndCostMap, arcadiaProductsMap);
		Set<String> productNumberSet = new Set<String>();
		productNumberSet.add('ARC00010AA');
		productNumberSet.add('AK40746AAAA');		
		List<String> deliverySalesItemList = new List<String>();
		CartService.DeliverySalesItems page = new CartService.DeliverySalesItems();
		page.name = 'aCQ56000000CcAj';
		page.quoteId = proposals[0].id;
		page.product_code = '833-052315.00';
		page.pci_code = 'ANA-ARC00451AA-SW-PCI';
		page.quantity = 1;
		page.arcadiaProductCode = 'ARC00451AA';
		page.item_type ='Order';
		page.parentLineItem = LineItem1.id;
		deliverySalesItemList.add(JSON.serialize(page));
		CartService.createDeliveryItems(deliverySalesItemList);
		Map<String,Apttus_Config2__LineItem__c> existingLineItemMap = new Map<String,Apttus_Config2__LineItem__c>();
		existingLineItemMap.put('833-052315.00', LineItem1);
		
		//LineItem1.Apttus_Config2__LineType__c = 'option';
		//Apttus_Config2__LineNumber__c
		children1 = arcadiaProductsMap.values();
		Attachment att=new Attachment();
		String bodyStr='title' + '\n' + 'notes';
att.Body=Blob.valueOf(bodyStr);
att.Name='Note_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt';
att.parentId=LineItem1.id;
insert att;
		CartService.UpsertData();
		CartService.addArcadiaItems(prods1[0].id,1.1,ProdConfig,children1,false);
		
		CartService.checkArcadiaItems(existingLineItemMap,prods1[0].Id,1,ProdConfig,children,True);
		CartService.createInterfaceLog('Success', 'abcd', 'abcd');
		CartService.createInterfaceLog(null,null,null);
		
		
		Test.stopTest();		
	}
}