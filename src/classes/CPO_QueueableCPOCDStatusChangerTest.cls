@isTest(isParallel=false)
private class CPO_QueueableCPOCDStatusChangerTest {
	@testSetup
	static void dataSetup() {
		
	}
	
	@isTest
	static void testQueueable() {
		List<Account> accList = QTO_TestDataFactory.createAccount(2);
		insert accList; 
		
		//List<Account> accList1 = QTO_TestDataFactory.createAccount(1);
		//accList1[0].Name='Dummy Acc';
		//insert accList1; 
		
		List<Product2> productList = new List<Product2>();
		Product2 product1 = new Product2();
		product1.CurrencyIsoCode = 'USD';
		product1.ProductCode = 'Bundle 1S 4 ABIA';
		product1.Name = 'My SFR Cutlery';
		product1.Description = 'Test Detailed Product Description';
		product1.IsActive=True;
		product1.Apttus_Config2__ConfigurationType__c = 'Bundle';
		product1.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
		productList.add(product1);
		
		Product2 product2 = new Product2();
		product2.CurrencyIsoCode = 'USD';
		product2.ProductCode = 'Bundle 1S 4 ABIA1';
		product2.Name = 'My SFR Cutlery1';
		product2.Description = 'Test Detailed Product Description1';
		product2.IsActive=True;
		product2.Apttus_Config2__ConfigurationType__c = 'Bundle';
		product2.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
		productList.add(product2);
		insert productList;	
		
		Apttus_Config2__PriceList__c priceList = QTO_TestDataFactory.priceList(); 
		priceList.Name = 'SFR Price List for Cutlery';
		priceList.Apttus_Config2__Description__c = 'SFR Price List for Cutlery';
		priceList.Apttus_Config2__Active__c = true;
		priceList.Apttus_Config2__AccountId__c = accList[0].Id;
		priceList.PriceList_Type__c = 'DS';
		priceList.Business_Group__c = 'GS';
		//priceList.Apttus_Config2__ContractNumber__c = 'Bundle 1S 4 ABIA';
		insert priceList;
		
		List<Apttus_Config2__PriceListItem__c> priceListItem = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c priListItem1 = QTO_TestDataFactory.createPriceListItem(priceList); 
		priListItem1.Apttus_Config2__PriceListId__c = priceList.Id;
		priListItem1.Apttus_Config2__ProductId__c = productList[0].Id;
		priListItem1.Apttus_Config2__ChargeType__c = 'Product Price';
		priListItem1.Apttus_Config2__PriceType__c = 'One Time';
		priListItem1.Apttus_Config2__PriceUom__c = 'Each';
		priListItem1.Apttus_Config2__ContractPrice__c = 2500;
		priListItem1.Apttus_Config2__ListPrice__c = 2555;
		priListItem1.Apttus_Config2__ContractItemNumber__c = 'Bundle 1S 4 ABIA';
		priceListItem.add(priListItem1);
		
		Apttus_Config2__PriceListItem__c priListItem2 = QTO_TestDataFactory.createPriceListItem(priceList); 
		priListItem2.Apttus_Config2__PriceListId__c = priceList.Id;
		priListItem2.Apttus_Config2__ProductId__c = productList[1].Id;
		priListItem2.Apttus_Config2__ChargeType__c = 'Product Price';
		priListItem2.Apttus_Config2__PriceType__c = 'One Time';
		priListItem2.Apttus_Config2__PriceUom__c = 'Each';
		priListItem2.Apttus_Config2__ContractPrice__c = 2500;
		priListItem2.Apttus_Config2__ListPrice__c = 2555;
		priListItem2.Apttus_Config2__ContractItemNumber__c = 'Bundle 1S 4 ABIA1';
		priceListItem.add(priListItem2);
		insert priceListItem;
		
		Opportunity opp = QTO_TestDataFactory.OpportunityCreation(accList[0]);
		insert opp;
		
		Apttus__APTS_Agreement__c agr = QTO_TestDataFactory.createAgreement(accList[0], opp, accList[1]);
		agr.Apttus__Status_Category__c = 'In Effect';
		agr.Apttus__Status__c = 'Activated';
		agr.Apttus__Contract_End_Date__c = System.today()+10;
		insert agr; 
		
		List<Apttus__AgreementLineItem__c> agList = new List<Apttus__AgreementLineItem__c>();
		
		Apttus__AgreementLineItem__c agLine0 = new Apttus__AgreementLineItem__c();
		agLine0.Apttus__AgreementId__c = agr.Id;
		agLine0.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine0.Contract_Item_Number__c = 'My SFR Cutlery';
		 agLine0.CLM_CFE_Reference__c = 'My SFR Cutlery';
		agLine0.Apttus__ProductId__c = productList[0].Id;
		agLine0.Apttus__Quantity__c = 0;
		
		
		Apttus__AgreementLineItem__c agLine1 = new Apttus__AgreementLineItem__c();
		agLine1.Apttus__AgreementId__c = agr.Id;
		agLine1.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine1.Contract_Item_Number__c = 'My SFR Cutlery';
		agLine1.CLM_CFE_Reference__c = 'My SFR Cutlery';
		agLine1.Apttus__ProductId__c = productList[1].Id;
		agLine1.Apttus__Quantity__c = 10;
		
		agList.add(agLine0);
		agList.add(agLine1);
		insert agList;
		
		Map<Id,List<Apttus__AgreementLineItem__c>> agreementAndLinesMap = new Map<Id,List<Apttus__AgreementLineItem__c>>();
		agreementAndLinesMap.put(agr.Id, agList);
		Test.startTest();
		List<Apttus_Proposal__Proposal__c> quotes = QTO_TestDataFactory.createProposal(1,opp.id); 
		quotes[0].Sold_To_Party__c=accList[0].Id;
		quotes[0].Apttus_Proposal__Account__c=accList[0].Id;
		quotes[0].Price_List__c=priceList.Id;
		quotes[0].Agreement_Lookup__c=agr.Id;
		quotes[0].Apttus_Proposal__Opportunity__c=opp.Id;
		insert quotes;
		
		List<Apttus_Proposal__Proposal_Line_Item__c> quoteLinesList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		Apttus_Proposal__Proposal_Line_Item__c quoteLines1 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,priceListItem[0]); 
		quoteLines1.Apttus_Proposal__Product__c = productList[0].Id;
		quoteLines1.Apttus_QPConfig__PriceListItemId__c = priceListItem[0].Id;
		quoteLines1.Apttus_QPConfig__Quantity2__c = 100;
		quoteLines1.Apttus_Proposal__Quantity__c = 100;
		quoteLinesList.add(quoteLines1);
		
		Apttus_Proposal__Proposal_Line_Item__c quoteLines2 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,priceListItem[1]); 
		quoteLines2.Apttus_Proposal__Product__c = productList[1].Id;
		quoteLines2.Apttus_QPConfig__PriceListItemId__c = priceListItem[1].Id;
		quoteLines2.Apttus_QPConfig__Quantity2__c = 100;
		quoteLines2.Apttus_Proposal__Quantity__c = 100;
		quoteLinesList.add(quoteLines2);
		insert quoteLinesList;  
		
		Customer_Document__c cd = QTO_TestDataFactory.createCustomerDocument();
		cd.Status__c = 'Draft';
		cd.Customer_Document_ID__c = '12435678';
		cd.Classification__c = 'Purchase Order';
		cd.Nokia_Legal_Entity_Account__c = accList[0].Id;
		cd.Customer__c = accList[0].Id;
		cd.QTO_OfferingType__c = 'Maintenance';
		insert cd;
		
		cd.QTO_Sub_Classification__c = 'Standard';
		cd.Status__c =  QTO_Constants.STATUS_ENRICHED;
		update cd;
		
		//Customer Document Line Item
		List<Customer_Document_Line_Items__c> customerDocLines = new List<Customer_Document_Line_Items__c>();
		Customer_Document_Line_Items__c cdli0 = new Customer_Document_Line_Items__c();
		cdli0.High_level_Product__c = 'My SFR Cutlery';
		cdli0.High_level_Product_Description__c = 'My SFR Bundle Description';
		cdli0.Detailed_Product__c = 'Bundle 1S 4 ABIA';
		cdli0.Detailed_Product_Description__c = 'Test Detailed Product Description';
		cdli0.Contract_Item_Number__c = 'My SFR Cutlery';
		cdli0.QTO_Product_Code__c = 'Bundle 1S 4 ABIA';
		cdli0.QTO_Product_Name__c = productList[0].Id;
		cdli0.Price_List_Item__c = priceListItem[0].Id;
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
		cdli0.Status__c='Enriched(Lines)';				
		customerDocLines.add(cdli0);
		
		insert customerDocLines;
		
		Id DS_CPO_RecordTypeId = Schema.SObjectType.Apttus_Config2__CustomerPurchaseOrder__c
			.getRecordTypeInfosByDeveloperName()
			.get('DS_Customer_Purchase_Order')
			.getRecordTypeId();		
		
		Apttus_Config2__CustomerPurchaseOrder__c cpoRecord = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpoRecord.Sold_to_party__c = accList.get(0).id;
		cpoRecord.Opportunity__c =opp.id;
		cpoRecord.Contract_start_date__c = system.today();
		cpoRecord.Contract_end_date__c=system.today()+365;
		cpoRecord.Terms__c = 12;
		cpoRecord.WBS__c='Test_WBS';
		cpoRecord.Legacy_CPO__c=true;
		cpoRecord.Apttus_QPConfig__ProposalId__c =quotes.get(0).id;
		cpoRecord.Apttus_Config2__Status__c = 'Draft';
		cpoRecord.Nokia_Customer_Document_ID__c = cd.Id;
		cpoRecord.RecordTypeId = DS_CPO_RecordTypeId;
		insert cpoRecord;
		
		Apttus_Config2__CustomerPOItem__c cpoItem = new Apttus_Config2__CustomerPOItem__c();
		cpoItem.Apttus_Config2__PurchaseOrderId__c=cpoRecord.Id;
		cpoItem.Apttus_Config2__ProductId__c=productList[0].id;
		cpoItem.Consumed_Quantity__c=0;
		cpoItem.Authorised_Quantity__c=0;
		cpoItem.Pending_Quantity__c=5;
		cpoItem.Non_Consumed_Quantity__c = 0;
		cpoItem.Apttus_Config2__Quantity__c = 5;
		cpoItem.Commercial_Entitlement_Status__c = 'Pending';
		cpoItem.Apttus_Config2__StartDate__c = system.today() ;
		cpoItem.Apttus_Config2__EndDate__c = system.today()+30;
		cpoItem.Quantity_Batch_Update__c = null;
		cpoItem.QTO_POI_Risk_Order_Alert__c = 'Yes';
		insert cpoItem;
		
		List<Apttus_Config2__CustomerPurchaseOrder__c> recordsUnderTest = [SELECT Id FROM Apttus_Config2__CustomerPurchaseOrder__c LIMIT 1];
		update new Apttus_Config2__CustomerPurchaseOrder__c(Id=recordsUnderTest.get(0).Id,Apttus_Config2__Status__c='Fully Enriched');
		
		CPO_QueueableCPOCDStatusChanger.checkCPOCommercialEnrichmentEligibity(
			new List<Apttus_Config2__CustomerPurchaseOrder__c>{
	new Apttus_Config2__CustomerPurchaseOrder__c(Id=recordsUnderTest.get(0).Id,Apttus_Config2__Status__c='Fully Enriched')
		},
			new Map<Id,Apttus_Config2__CustomerPurchaseOrder__c>{
	recordsUnderTest.get(0).Id =>
		new Apttus_Config2__CustomerPurchaseOrder__c(Id=recordsUnderTest.get(0).Id,Apttus_Config2__Status__c='Draft')
			}
		);
		Test.stopTest();
		//System.assertEquals(1, [SELECT COUNT() FROM Customer_Document__c WHERE Status__c = 'Closed-validated'], 'Customer document did not update');
		//System.assertEquals(true, [SELECT COUNT() FROM Task WHERE WhatId = :recordsUnderTest.get(0).Id] <> 0, 'Tasks did not create');
	}
}