@IsTest
private class QTO_CDLineItemsService_Tests {
	@IsTest
	static void testOnBeforeUpdate() {
		// create account
		List<Account> accounts = QTO_TestDataFactory.createAccount(2);
		insert accounts;		
		
		// create products
		List<Product2> products = new List<Product2>();
		Product2 product1 = new Product2();
		product1.CurrencyIsoCode = 'USD';
		product1.ProductCode = 'Bundle 1S 4 ABIA';
		product1.Name = 'My SFR Cutlery';
		product1.Description = 'Test Detailed Product Description';
		product1.IsActive=True;
		product1.Apttus_Config2__ConfigurationType__c = 'Bundle';
		product1.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
		products.add(product1);
		
		Product2 product2 = new Product2();
		product2.CurrencyIsoCode = 'USD';
		product2.ProductCode = 'Bundle 1S 4 ABIA1';
		product2.Name = 'My SFR Cutlery1';
		product2.Description = 'Test Detailed Product Description1';
		product2.IsActive=True;
		product2.Apttus_Config2__ConfigurationType__c = 'Bundle';
		product2.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
		products.add(product2);
		insert products;
		
		// create price list and price list item
		Apttus_Config2__PriceList__c priceList = QTO_TestDataFactory.priceList(); 
		priceList.Name = 'SFR Price List for Cutlery';
		priceList.Apttus_Config2__Description__c = 'SFR Price List for Cutlery';
		priceList.Apttus_Config2__Active__c = true;
		priceList.Apttus_Config2__AccountId__c = accounts[0].Id;
		priceList.PriceList_Type__c = 'DS';
		priceList.Business_Group__c = 'GS';
		//priceList.Apttus_Config2__ContractNumber__c = 'Bundle 1S 4 ABIA';
		insert priceList;
		
		List<Apttus_Config2__PriceListItem__c> priceListItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c priceListItem_1 = QTO_TestDataFactory.createPriceListItem(priceList); 
		priceListItem_1.Apttus_Config2__PriceListId__c = priceList.Id;
		priceListItem_1.Apttus_Config2__ProductId__c = products[0].Id;
		priceListItem_1.Apttus_Config2__ChargeType__c = 'Product Price';
		priceListItem_1.Apttus_Config2__PriceType__c = 'One Time';
		priceListItem_1.Apttus_Config2__PriceUom__c = 'Each';
		priceListItem_1.Apttus_Config2__ContractPrice__c = 2500;
		priceListItem_1.Apttus_Config2__ListPrice__c = 2555;
		priceListItem_1.Apttus_Config2__ContractItemNumber__c = 'Bundle 1S 4 ABIA';
		priceListItem_1.DS_Grouping_Name__c = 'DBS 1S 4 ABIA';
		priceListItems.add(priceListItem_1);
		
		Apttus_Config2__PriceListItem__c priceListItem_2 = QTO_TestDataFactory.createPriceListItem(priceList); 
		priceListItem_2.Apttus_Config2__PriceListId__c = priceList.Id;
		priceListItem_2.Apttus_Config2__ProductId__c = products[1].Id;
		priceListItem_2.Apttus_Config2__ChargeType__c = 'Product Price';
		priceListItem_2.Apttus_Config2__PriceType__c = 'One Time';
		priceListItem_2.Apttus_Config2__PriceUom__c = 'Each';
		priceListItem_2.Apttus_Config2__ContractPrice__c = 2500;
		priceListItem_2.Apttus_Config2__ListPrice__c = 2555;
		priceListItem_2.Apttus_Config2__ContractItemNumber__c = 'Bundle 1S 4 ABIA1';
		priceListItem_2.DS_Grouping_Name__c = 'DBS 1S 4 ABIA';
		priceListItems.add(priceListItem_2);
		insert priceListItems;
		
		// create opportunity
		Opportunity opp = QTO_TestDataFactory.OpportunityCreation(accounts[0]);
		insert opp;
		// create agreement
		Apttus__APTS_Agreement__c agr = QTO_TestDataFactory.createAgreement(accounts[0], opp, accounts[1]);
		agr.Apttus__Status_Category__c = 'In Effect';
		agr.Apttus__Status__c = 'Activated';
		agr.Apttus__Contract_End_Date__c = System.today().addDays(10);
		insert agr; 
		// create agreement line items
		List<Apttus__AgreementLineItem__c> agList = new List<Apttus__AgreementLineItem__c>();		
		Apttus__AgreementLineItem__c agLine0 = new Apttus__AgreementLineItem__c();
		agLine0.Apttus__AgreementId__c = agr.Id;
		agLine0.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine0.Contract_Item_Number__c = 'My SFR Cutlery';
		agLine0.CLM_CFE_Reference__c = 'My SFR Cutlery';
		agLine0.Apttus__ProductId__c = products[0].Id;
		agLine0.Apttus__Quantity__c = 0;		
		
		Apttus__AgreementLineItem__c agLine1 = new Apttus__AgreementLineItem__c();
		agLine1.Apttus__AgreementId__c = agr.Id;
		agLine1.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine1.Contract_Item_Number__c = 'My SFR Cutlery';
		agLine1.CLM_CFE_Reference__c = 'My SFR Cutlery';
		agLine1.Apttus__ProductId__c = products[1].Id;
		agLine1.Apttus__Quantity__c = 10;		
		
		Apttus__AgreementLineItem__c agLine2 = new Apttus__AgreementLineItem__c();
		agLine2.Apttus__AgreementId__c = agr.Id;
		agLine2.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine2.CLM_CFE_Reference__c = 'My SFR Cutlery1';
		agLine2.Contract_Item_Number__c = 'My SFR Cutlery1';
		agLine2.Apttus__ProductId__c = products[1].Id;
		agLine2.Apttus__Quantity__c = 20;
		
		Apttus__AgreementLineItem__c agLine3 = new Apttus__AgreementLineItem__c();
		agLine3.Apttus__AgreementId__c = agr.Id;
		agLine3.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine3.Contract_Item_Number__c = 'My SFR Cutlery1';
		agLine3.CLM_CFE_Reference__c = 'My SFR Cutlery1';
		agLine3.Apttus__ProductId__c = products[0].Id;
		agLine3.Apttus__Quantity__c = 40;
		
		agList.add(agLine0);
		agList.add(agLine1);
		agList.add(agLine2);
		agList.add(agLine3);
		insert agList;		
		
		// Map<Id,List<Apttus__AgreementLineItem__c>> agreementAndLinesMap = new Map<Id,List<Apttus__AgreementLineItem__c>>();
		// agreementAndLinesMap.put(agr.Id, agList);
		// create quote
		List<Apttus_Proposal__Proposal__c> quotes = QTO_TestDataFactory.createProposal(1,opp.id); 
		quotes[0].Sold_To_Party__c=accounts[0].Id;
		quotes[0].Apttus_Proposal__Account__c=accounts[0].Id;
		quotes[0].Price_List__c=priceList.Id;
		quotes[0].Agreement_Lookup__c=agr.Id;
		quotes[0].Apttus_Proposal__Opportunity__c=opp.Id;
		insert quotes;
		// create quote lines
		List<Apttus_Proposal__Proposal_Line_Item__c> quoteLinesList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		Apttus_Proposal__Proposal_Line_Item__c quoteLines1 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,priceListItems[0]); 
		quoteLines1.Apttus_Proposal__Product__c = products[0].Id;
		quoteLines1.Apttus_QPConfig__PriceListItemId__c = priceListItems[0].Id;
		quoteLines1.Apttus_QPConfig__Quantity2__c = 100;
		quoteLinesList.add(quoteLines1);
		
		Apttus_Proposal__Proposal_Line_Item__c quoteLines2 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,priceListItems[1]); 
		quoteLines2.Apttus_Proposal__Product__c = products[1].Id;
		quoteLines2.Apttus_QPConfig__PriceListItemId__c = priceListItems[1].Id;
		quoteLines2.Apttus_QPConfig__Quantity2__c = 100;
		quoteLinesList.add(quoteLines2);
		
		Apttus_Proposal__Proposal_Line_Item__c quoteLines3 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,priceListItems[1]); 
		quoteLines3.Apttus_Proposal__Product__c = products[1].Id;
		quoteLines3.Apttus_QPConfig__PriceListItemId__c = priceListItems[1].Id;
		quoteLines3.Apttus_QPConfig__Quantity2__c = 10;
		quoteLinesList.add(quoteLines3);
		
		Apttus_Proposal__Proposal_Line_Item__c quoteLines4 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].Id,priceListItems[0]); 
		quoteLines4.Apttus_Proposal__Product__c = products[0].Id;
		quoteLines4.Apttus_QPConfig__PriceListItemId__c = priceListItems[0].Id;
		quoteLines4.Apttus_QPConfig__Quantity2__c = 30;
		quoteLinesList.add(quoteLines4);
		insert quoteLinesList;

		// create customer document
		Customer_Document__c cd = QTO_TestDataFactory.createCustomerDocument();
		cd.Status__c = 'Draft';
		cd.Customer_Document_ID__c = '12435678';
		cd.Classification__c = 'Purchase Order';
		cd.Sub_Classification__c = 'Standard';
		cd.Nokia_Legal_Entity_Account__c = accounts[0].Id;
		cd.Customer__c = accounts[0].Id;
		insert cd;
		cd.Status__c =  QTO_Constants.STATUS_ENRICHED;
		update cd;		
		
		// create Customer Document Line Item
		List<Customer_Document_Line_Items__c> customerDocLines = new List<Customer_Document_Line_Items__c>();
		Customer_Document_Line_Items__c cdli0 = new Customer_Document_Line_Items__c();
		cdli0.High_level_Product__c = 'My SFR Cutlery';
		cdli0.High_level_Product_Description__c = 'My SFR Bundle Description';
		cdli0.Detailed_Product__c = 'Bundle 1S 4 ABIA';
		cdli0.Detailed_Product_Description__c = 'Test Detailed Product Description';
		// cdli0.Contract_Item_Number__c = 'My SFR Cutlery';
		// cdli0.QTO_Product_Code__c = 'Bundle 1S 4 ABIA';
		// cdli0.QTO_Product_Name__c = products[0].Id;
		// cdli0.Price_List_Item__c = priceListItems[0].Id;
		cdli0.QTO_PDF_Quantity__c = '10';
		cdli0.Quantity__c = '10';
		cdli0.QTO_PDF_Unit_Of_Measure__c = 'PCE';
		cdli0.QTO_Unit_Of_Measure__c = 'PCE';
		cdli0.QTO_PDF_Unit_Price__c = '2222,00';
		cdli0.Total_Value__c = 50;
		cdli0.QTO_PDF_Currency_Code__c = 'EUR';
		cdli0.CurrencyIsoCode = 'EUR';
		cdli0.QTO_Unit_Price__c = 2222.00;
		cdli0.Customer_Document__c = cd.Id;
		cdli0.QTO_Unit_of_Measure__c = 'PCE';
		cdli0.QTO_PDF_Total_Value__c = '624.70';														
		cdli0.QTO_PDF_Requested_Delivery_Date__c = '08.08.2021';											  
		cdli0.Status__c='Exception-Enriched(Lines)';														  
		customerDocLines.add(cdli0);
		
		Customer_Document_Line_Items__c cdli1 = new Customer_Document_Line_Items__c();
		cdli1.High_level_Product__c = 'My SFR Cutlery1';
		cdli1.High_level_Product_Description__c = 'My SFR Bundle Description1';
		cdli1.Detailed_Product__c = 'Bundle 1S 4 ABIA1';
		cdli1.Detailed_Product_Description__c = 'Test Detailed Product Description1';
		// cdli1.Contract_Item_Number__c = 'My SFR Cutlery1';
		// cdli1.QTO_Product_Code__c = 'Bundle 1S 4 ABIA1';
		// cdli1.QTO_Product_Name__c = products[1].Id;
		// cdli1.Price_List_Item__c = priceListItems[1].Id;
		cdli1.QTO_PDF_Quantity__c = '0';
		cdli1.Quantity__c = '0';
		cdli1.QTO_PDF_Unit_Of_Measure__c = 'PCE';
		cdli1.QTO_Unit_Of_Measure__c = 'PCE';
		cdli1.QTO_PDF_Unit_Price__c = '2222,00';
		cdli1.Total_Value__c = 50;
		cdli1.QTO_PDF_Currency_Code__c = 'EUR';
		cdli1.CurrencyIsoCode = 'EUR';
		cdli1.QTO_Unit_Price__c = 2222.00;
		cdli1.Customer_Document__c = cd.Id;
		cdli1.QTO_Unit_of_Measure__c = 'PCE';
		cdli1.QTO_PDF_Total_Value__c = '624.70';														
		cdli1.QTO_PDF_Requested_Delivery_Date__c = '08.08.2021';											  
		cdli1.Status__c='Exception-Enriched(Lines)';														
		customerDocLines.add(cdli1);

		insert customerDocLines;

		Test.startTest();
		cdli0.Price_List_Item__c = priceListItems[0].Id;
		cdli0.Status__c = 'Manually-Enriched(Lines)';
		cdli1.QTO_Product_Name__c = products[1].Id;
		cdli1.Status__c = 'Manually-Enriched(Lines)';
		update New List<Customer_Document_Line_Items__c>{ cdli0, cdli1 };
		Test.stopTest();

		System.assertEquals(
			'Bundle 1S 4 ABIA1', 
			[SELECT Id, QTO_Product_Code__c FROM Customer_Document_Line_Items__c WHERE Id = :cdli1.Id].QTO_Product_Code__c,
			'Product code did not auto populate when product is updated'
		);
	}
}