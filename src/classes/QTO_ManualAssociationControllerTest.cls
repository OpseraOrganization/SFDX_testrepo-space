/**
 * @description	   : 
 * @author			: Lovel Panchal
 * @group			 : 
 * @last modified on  : 12-16-2020
 * @last modified by  : Raj Kamdar
 * Modifications Log 
 * Ver   Date		 Author		  Modification
 * 1.0   11-18-2020   Lovel Panchal   Initial Version
**/
@isTest
private class QTO_ManualAssociationControllerTest{
	
	/*
	@isTest static void testMethod1() {
		
		Account parentAccount = TestDataFactory.createAccount(1)[0];
		parentAccount.AccountNumber='101234567';
		parentAccount.Acc_No__c = '101234567';
		parentAccount.Name = 'Parent Account';
		parentAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert parentAccount;
		
		Account customerAccount = TestDataFactory.createAccount(1)[0];
		customerAccount.AccountNumber='101234568';
		customerAccount.Acc_No__c = '101234568';
		customerAccount.Name = 'Customer Account';
		customerAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		customerAccount.ParentId = parentAccount.Id;
		customerAccount.Active__c = true;
		customerAccount.BillingPostalCode = '92661';		
	  
		insert customerAccount;

		Customer_Document__c cd =new Customer_Document__c();
		cd = QTO_TestDataFactory.createCustomerDocument();	
		cd.Customer_Document_Id__c = '672338872039';
		cd.Customer__c = customerAccount.Id;
		insert cd;

		// Account acc = [Select id from Account limit 1];
		List<Apttus_Proposal__Proposal__c> Quote =  QTO_TestDataFactory.createProposal(1,QTO_TestDataFactory.OpportunityCreation(customerAccount).Id);
		insert Quote;
		System.debug('Quote ...'+Quote);
		String str = '[{"Id":"'+Quote[0].Id+'","Name":"Q-00123361","Quote_Total__c":1743,"Apttus_Proposal__Approval_Stage__c":"Approved","Agreement_Name__c":"Contrat dExecution Accès Radio N°2009/00998 - amendment n°10 #HW Copy Copy Copy","Apttus_Proposal__Proposal_Name__c":"SFR - MN - Winback Renewal Husky - 4G MN and NI diplexers + 5G HW FoC","QTO_Association_Status__c":"Not Associated"}]';
		
		Quote =  QTO_TestDataFactory.createProposal(1,QTO_TestDataFactory.OpportunityCreation(customerAccount).Id);
		insert Quote;
		str = '[{"Id":"'+Quote[0].Id+'","Name":"Q-00123361","Quote_Total__c":1743,"Apttus_Proposal__Approval_Stage__c":"Approved","Agreement_Name__c":"Contrat dExecution Accès Radio N°2009/00998 - amendment n°10 #HW Copy Copy Copy","Apttus_Proposal__Proposal_Name__c":"SFR - MN - Winback Renewal Husky - 4G MN and NI diplexers + 5G HW FoC","QTO_Association_Status__c":"Not Associated"}]';
		Customer_Document__c objCD = [Select Id from Customer_Document__c where Customer_Document_Id__c ='672338872039' Limit 1];
		QTO_ManualAssociationController.saveAssociationData(str,objCD.Id,'Quote');
	   
   
		QTO_ManualAssociationController.getAllAssociationData('Quote',cd.Id);
		QTO_ManualAssociationController.getAllAssociationData('Agreement',cd.Id); 
		QTO_ManualAssociationController.getAllAssociationData('Customer_Document__c',cd.Id); 
		
		QTO_ManualAssociationController.saveAssociationData(str,cd.Id,'Quote');
		QTO_ManualAssociationController.saveAssociationData(str,cd.Id,'Agreement');
		
		
		QTO_ManualAssociationController.getTableHeaders('Quote');
		QTO_ManualAssociationController.getTableHeaders('Agreement');
		QTO_ManualAssociationController.getTableHeaders('Customer_Document__c');
 		QTO_ManualAssociationController.getTableHeaders('QTO_Customer_Document_Quote_Line__c');
		QTO_ManualAssociationController.getTableHeaders('QTO_Customer_Document_Agreement_Line__c');
		QTO_ManualAssociationController.getTableHeaders(cd.Id);
		QTO_ManualAssociationController.getStatus(cd.Id);	
		
		QTO_ManualAssociationControllerHelper ctrl = new QTO_ManualAssociationControllerHelper();
		QTO_ManualAssociationControllerHelper.dataTableHeader dt = new QTO_ManualAssociationControllerHelper.dataTableHeader();
		dt.fieldName = '';
		dt.label = '';
		dt.type = '';  
		
		str = '[{"Id":"'+cd.Id+'","Customer_Document_Id__c":"672338872039"}]';
		QTO_ManualAssociationControllerHelper.saveCustomerDocumentAssociationData(str,cd.Id);
	}
	*/
	
	
	@testsetup
	static void associateCdLineItemsTest() {
		
		List<Account> accList = QTO_TestDataFactory.createAccount(2);
		insert accList;		 
		
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
		insert agr; 
		agr.Apttus__Status__c = 'Activated'; 
		update agr;
		
		List<Apttus__AgreementLineItem__c> agList = new List<Apttus__AgreementLineItem__c>();
		
		Apttus__AgreementLineItem__c agLine0 = new Apttus__AgreementLineItem__c();
		agLine0.Apttus__AgreementId__c = agr.Id;
		agLine0.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine0.CLM_CFE_Reference__c = 'My SFR Cutlery';
		agLine0.Apttus__ProductId__c = productList[0].Id;
		agLine0.Apttus__Quantity__c = 0;
		
		
		Apttus__AgreementLineItem__c agLine1 = new Apttus__AgreementLineItem__c();
		agLine1.Apttus__AgreementId__c = agr.Id;
		agLine1.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine1.CLM_CFE_Reference__c = 'My SFR Cutlery';
		agLine1.Apttus__ProductId__c = productList[1].Id;
		agLine1.Apttus__Quantity__c = 10;
		
		
		Apttus__AgreementLineItem__c agLine2 = new Apttus__AgreementLineItem__c();
		agLine2.Apttus__AgreementId__c = agr.Id;
		agLine2.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine2.CLM_CFE_Reference__c = 'My SFR Cutlery1';
		agLine2.Apttus__ProductId__c = product2.Id;
		agLine2.Apttus__Quantity__c = 20;
		
		Apttus__AgreementLineItem__c agLine3 = new Apttus__AgreementLineItem__c();
		agLine3.Apttus__AgreementId__c = agr.Id;
		agLine3.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine3.CLM_CFE_Reference__c = 'My SFR Cutlery1';
		agLine3.Apttus__ProductId__c = product1.Id;
		agLine3.Apttus__Quantity__c = 40;
		
		agList.add(agLine0);
		agList.add(agLine1);
		agList.add(agLine2);
		agList.add(agLine3);
		insert agList;
		
		
		Map<Id,List<Apttus__AgreementLineItem__c>> agreementAndLinesMap = new Map<Id,List<Apttus__AgreementLineItem__c>>();
		agreementAndLinesMap.put(agr.Id, agList);
		
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
		
		Apttus_Proposal__Proposal_Line_Item__c quoteLines3 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,priceListItem[1]); 
		quoteLines3.Apttus_Proposal__Product__c = productList[1].Id;
		quoteLines3.Apttus_QPConfig__PriceListItemId__c = priceListItem[1].Id;
		quoteLines3.Apttus_QPConfig__Quantity2__c = 10;
		quoteLines3.Apttus_Proposal__Quantity__c = 10;
		quoteLinesList.add(quoteLines3);
		
		Apttus_Proposal__Proposal_Line_Item__c quoteLines4 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,priceListItem[1]); 
		quoteLines4.Apttus_Proposal__Product__c = productList[1].Id;
		quoteLines4.Apttus_QPConfig__PriceListItemId__c = priceListItem[1].Id;
		quoteLines4.Apttus_QPConfig__Quantity2__c = 30;
		quoteLines4.Apttus_Proposal__Quantity__c = 30;
		quoteLinesList.add(quoteLines4);
		insert quoteLinesList;  
		
		Customer_Document__c cd = QTO_TestDataFactory.createCustomerDocument();
		cd.Status__c = 'Draft';
		cd.Customer_Document_ID__c = '12435678';
		cd.Classification__c = 'Purchase Order';
		cd.Sub_Classification__c = 'Standard';
		cd.Nokia_Legal_Entity_Account__c = accList[0].Id;
		cd.Customer__c = accList[0].Id;
		insert cd;
		
		cd.Customer__c = accList[0].Id;
		cd.QTO_Classification__c = 'Purchase Order';
		cd.QTO_Sub_Classification__c = 'Standard';
		cd.Classification__c = 'Purchase Order';
		cd.Sub_Classification__c = 'Standard';
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

	}
	@isTest
	static void manualAssociationTest1(){
		test.startTest();
		List<Customer_Document_Line_Items__c>  customerDocumentLines = [Select Id,High_level_Product__c,High_level_Product_Description__c,Detailed_Product_Code__c,Detailed_Product_Description__c,Site__c,
																		QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,QTO_Product_Name__r.Name,Contract_Item_Number__c,
																		Price_List_Item__c,Customer_Document__c, Status__c, Association_Comment__c, QTO_CDLI_Matching_Comment__c,QTO_Association__c , Customer_Document__r.Customer__c, 
																		Quantity__c, QTO_CDLI_Matched_Quoted_Quantity__c,QTO_CDLI_Matched_Contracted_Quantity__c, Customer_Document__r.Status__c 
																		from Customer_Document_Line_Items__c];
		
		QTO_ManualAssociationControllerHelper.getAllAssociationData('QTO_Customer_Document_Quote_Line__c', customerDocumentLines[0].Id);
		QTO_ManualAssociationControllerHelper.getAllAssociationData('QTO_Customer_Document_Agreement_Line__c', customerDocumentLines[0].Id);
		QTO_ManualAssociationController.getAllAssociationData('Quote',customerDocumentLines[0].Customer_Document__c);
		QTO_ManualAssociationController.getAllAssociationData('Agreement',customerDocumentLines[0].Customer_Document__c); 
		QTO_ManualAssociationController.getAllAssociationData('Customer_Document__c',customerDocumentLines[0].Customer_Document__c); 
		QTO_ManualAssociationController.getAllAssociationData('Customer_Document_Line_Items__c',customerDocumentLines[0].Customer_Document__c); 

		QTO_ManualAssociationController.getTableHeaders('Quote');
		QTO_ManualAssociationController.getTableHeaders('Agreement');
		QTO_ManualAssociationController.getTableHeaders('Customer_Document__c');
		QTO_ManualAssociationController.getTableHeaders('Customer_Document_Line_Items__c');
 		QTO_ManualAssociationController.getTableHeaders('QTO_Customer_Document_Quote_Line__c');
		QTO_ManualAssociationController.getTableHeaders('QTO_Customer_Document_Agreement_Line__c');
		QTO_ManualAssociationController.getTableHeaders(customerDocumentLines[0].Customer_Document__c);
		QTO_ManualAssociationController.getStatus(customerDocumentLines[0].Customer_Document__c);	
		
		QTO_ManualAssociationControllerHelper ctrl = new QTO_ManualAssociationControllerHelper();
		QTO_ManualAssociationControllerHelper.dataTableHeader dt = new QTO_ManualAssociationControllerHelper.dataTableHeader();
		dt.fieldName = '';
		dt.label = '';
		dt.type = ''; 
		
		
		Apttus_Proposal__Proposal__c prop = [Select Id from Apttus_Proposal__Proposal__c limit 1];
		Apttus_Proposal__Proposal_Line_Item__c propLine = [Select Id from Apttus_Proposal__Proposal_Line_Item__c limit 1];
		
		Apttus__APTS_Agreement__c agree = [Select Id from Apttus__APTS_Agreement__c limit 1];
		Apttus__AgreementLineItem__c agreeLine = [Select Id from Apttus__AgreementLineItem__c limit 1];
		Product2 prd = [Select Id from Product2 limit 1];
	   
		String str = '[{"Id":"'+prop.Id+'","Name":"Q-00123361","Quote_Total__c":1743,"Apttus_Proposal__Approval_Stage__c":"Approved","Agreement_Name__c":"Contrat dExecution Accès Radio N°2009/00998 - amendment n°10 #HW Copy Copy Copy","Apttus_Proposal__Proposal_Name__c":"SFR - MN - Winback Renewal Husky - 4G MN and NI diplexers + 5G HW FoC","QTO_Association_Status__c":"Not Associated"}]';
		QTO_ManualAssociationController.saveAssociationData(str, customerDocumentLines[0].Customer_Document__c, 'Quote');
	   
		String agrStr = '[{"Id":"'+agree.Id+'","Apttus__Status_Category__c":"In Effect","Agreement_External_Contract_Number__c":"BELNET-Contract-21.BE.1000005581-3HE","Name":"BELNET-Contract-21.BE.1000005581-3HE"}]';
		QTO_ManualAssociationController.saveAssociationData(agrStr, customerDocumentLines[0].Customer_Document__c, 'Agreement');
	   
		String agrLineStr = '[{"Apttus__Description__c":"My SFR Cutlery - VDSL2 Vectoring SW Package","Apttus__ProductId__r":{"Name":"VDSL2 Vectoring SW Package","Id":"'+prd.Id+'"},"Apttus__ProductId__c":"'+prd.Id+'","Apttus__NetPrice__c":26562.45,"Product_Code__c":"My SFR Cutlery","Apttus__Quantity__c":1000000,"Id":"'+agreeLine.Id+'","CLM_CFE_Reference__c":"3EC17929MW","Apttus__ExtendedPrice__c":26562.45,"Apttus__AgreementId__r":{"Apttus__Status_Category__c":"In Effect","Apttus__Status__c":"Activated","Id":"'+agree.Id+'"},"Apttus__AgreementId__c":"'+agree.Id+'","Name":"AL-0000000048"}]';
		QTO_ManualAssociationController.saveAssociationData(agrLineStr, customerDocumentLines[0].Id, 'QTO_Customer_Document_Agreement_Line__c');
	   
		String quLineStr = '[{"Product_Code__c":"My SFR Cutlery","Apttus_Proposal__Proposal__r":{"NokiaCPQ_Proposal_Id__c":"21.BE.1000005581 Q-00123495","Name":"Q-00123495","Id":"'+prop.Id+'"},"Apttus_Proposal__Product__r":{"ProductCode":"My SFR Cutlery","Id":"'+prd.Id+'"},"Apttus_Proposal__Quantity__c":50,"NokiaCPQ_Product_Name__c":"VDSL2 Vectoring SW Package","Name":"QL-0000153985","Apttus_QPConfig__Quantity2__c":50,"Apttus_QPConfig__PriceListItemId__c":"a5s0r000000CqBjAAK","Apttus_Proposal__Proposal__c":"a3k0r000001hTmBAAU","Apttus_Proposal__Product__c":"01t41000004Mz8BAAS","DS_Grouping_Name__c":"Other","External_Reference__c":"My SFR Cutlery","Id":"'+propLine.Id+'"}]';
		QTO_ManualAssociationController.saveAssociationData(quLineStr, customerDocumentLines[0].Id, 'QTO_Customer_Document_Quote_Line__c');
	   
		String cdStr='[{"Sub_Classification__c":"Standard","Customer_Document_ID__c":"PO-Q-00123444-Test Case 002-A","Nokia_Document_Receipt_Date__c":"2021-08-08","QTO_Nature__c":"Cancel","Total_Value__c":725.8,"Nokia_Legal_entity__c":"FI-FI1","Id":"'+customerDocumentLines[0].Customer_Document__c+'","Classification__c":"Purchase Order","Name":"CD-7107"}]';
		QTO_ManualAssociationController.saveAssociationData(cdStr, customerDocumentLines[0].Customer_Document__c, 'Customer_Document__c');
	   
		test.stopTest();	
	}
	
	@isTest
	static void testSaveDraftCDLinesPositive() {
		Customer_Document__c customerDocument = [SELECT Id, (SELECT Id FROM Customer_Document_Line_Items__r) FROM Customer_Document__c LIMIT 1];
		customerDocument.Status__c = 'Exception-Association(Lines)';
		update customerDocument;
		String draftCDLinesString =
			'[{"QTO_CDLI_Waiver_Matching__c":"false","QTO_CDLI_Waiver_Association__c":"false","Id":"' +
			String.valueOf(customerDocument.Customer_Document_Line_Items__r.get(0).Id) + '"}]';
		QTO_ManualAssociationController.saveAssociationData(draftCDLinesString,String.valueOf(customerDocument.Id),'Customer_Document_Line_Items__c');
		// System.assertEquals(true, result, 'Waiver comment update failed');
	}
	
	@isTest
	static void testSaveDraftCDLinesNegative() {
		Customer_Document__c customerDocument = [SELECT Id, (SELECT Id FROM Customer_Document_Line_Items__r) FROM Customer_Document__c LIMIT 1];
		try { QTO_ManualAssociationController.saveAssociationData('',String.valueOf(customerDocument.Id),'Customer_Document_Line_Items__c'); }
		catch(Exception exc){ System.assertEquals('Script-thrown exception', exc.getMessage(), 'Expected an exception'); }
	}
	
	@isTest
	static void testFindAgreementLineItemById() {
		Map<Id, Apttus__AgreementLineItem__c> agreementLineItems = new Map<Id, Apttus__AgreementLineItem__c>(
			[
				SELECT Id FROM Apttus__AgreementLineItem__c
				WHERE Apttus__AgreementId__r.Apttus__Status__c='Activated' 
				AND Apttus__AgreementId__r.Apttus__Status_Category__c= 'In Effect' 
			]
		);
		System.assertNotEquals(true, QTO_ManualAssociationControllerHelper.findAgreementLineItemById(agreementLineItems.keySet()).isEmpty(), 'Agreement lines not found');
	}
	
	@isTest
	static void testReviseAgreementLineQuantity() {
		Apttus__AgreementLineItem__c agreementLineItem = 
			[
				SELECT Id FROM Apttus__AgreementLineItem__c
				WHERE Apttus__AgreementId__r.Apttus__Status__c='Activated' 
				AND Apttus__AgreementId__r.Apttus__Status_Category__c= 'In Effect'
				LIMIT 1
			];
		Customer_Document_Line_Items__c customerDocumentLineItem = [SELECT Id FROM Customer_Document_Line_Items__c LIMIT 1];
		update new Customer_Document_Line_Items__c(
			Status__c = 'Exception-Matching(Lines)',
			QTO_CDLI_Matched_Contracted_Quantity__c = 1,
			Id = customerDocumentLineItem.Id
		);
		QTO_Customer_Document_Agreement_Line__c associatedAgreementLine = new QTO_Customer_Document_Agreement_Line__c(
			QTO_Agreement_Line_Item__c = agreementLineItem.Id,
			QTO_Customer_Document_Line_Items__c = customerDocumentLineItem.Id,
			QTO_CDLIA_Matched_Contracted_Quantity__c = 1
		);
		insert associatedAgreementLine;
		QTO_ManualAssociationControllerHelper.reviseAgreementLineQuantity(
			new Set<Id>{ agreementLineItem.Id },
			customerDocumentLineItem.Id,
			new Map<Id, QTO_Customer_Document_Agreement_Line__c>{
				agreementLineItem.Id => associatedAgreementLine
			}
		);
	}
	
	@isTest
	static void testSaveCDLineAgreementAssociationData() {
		List<Apttus__AgreementLineItem__c> agreementLineItems = 
			[
				SELECT Id FROM Apttus__AgreementLineItem__c
				WHERE Apttus__AgreementId__r.Apttus__Status__c='Activated' 
				AND Apttus__AgreementId__r.Apttus__Status_Category__c= 'In Effect'
			];
		List<String> saveDataStrings = new List<String>();
		for(Apttus__AgreementLineItem__c agreementLineItem : agreementLineItems) {
			saveDataStrings.add('{"Id":"' + String.valueOf(agreementLineItem.Id) + '"}');
		}
		Customer_Document_Line_Items__c customerDocumentLineItem = [SELECT Id FROM Customer_Document_Line_Items__c LIMIT 1];
		update new Customer_Document_Line_Items__c(
			Status__c = 'Exception-Matching(Lines)',
			QTO_CDLI_Matched_Contracted_Quantity__c = 1,
			Id = customerDocumentLineItem.Id
		);
		QTO_Customer_Document_Agreement_Line__c associatedAgreementLine = new QTO_Customer_Document_Agreement_Line__c(
			QTO_Agreement_Line_Item__c = agreementLineItems.get(0).Id,
			QTO_Customer_Document_Line_Items__c = customerDocumentLineItem.Id,
			QTO_CDLIA_Matched_Contracted_Quantity__c = 1
		);
		insert associatedAgreementLine;
		QTO_ManualAssociationControllerHelper.saveCDLineAgreementAssociationData(
			'[' + String.join(saveDataStrings, ',') + ']',
			String.valueOf(customerDocumentLineItem.Id)
		);
	}
	
	@isTest
	static void testReviseQuoteLineQuantity() {
		Apttus_Proposal__Proposal__c proposal = [SELECT Id FROM Apttus_Proposal__Proposal__c LIMIT 1];
		proposal.Apttus_Proposal__Approval_Stage__c = 'Approved';
		update proposal;
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItems = 
			[
				SELECT Id FROM Apttus_Proposal__Proposal_Line_Item__c
				WHERE Apttus_Proposal__Proposal__c = :proposal.Id
			];
		Set<Id> ids = new Set<Id>{proposalLineItems.get(0).Id};
		for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem : proposalLineItems) {
			// ids.add(proposalLineItem.Id);
			proposalLineItem.Apttus_Proposal__Quantity__c = 1;
		}
		update proposalLineItems;
		Customer_Document_Line_Items__c customerDocumentLineItem = [SELECT Id FROM Customer_Document_Line_Items__c LIMIT 1];
		update new Customer_Document_Line_Items__c(
			Status__c = 'Exception-Matching(Lines)',
			QTO_CDLI_Matched_Quoted_Quantity__c = 1,
			Id = customerDocumentLineItem.Id
		);
		QTO_Customer_Document_Quote_Line__c associatedProposalLine = new QTO_Customer_Document_Quote_Line__c(
			QTO_Proposal_Line_Item__c = proposalLineItems.get(0).Id,
			QTO_Customer_Document_Line_Items__c = customerDocumentLineItem.Id,
			QTO_CDLIA_Matched_Quoted_Quantity__c =1
		);
		insert associatedProposalLine;
		QTO_ManualAssociationControllerHelper.reviseQuoteLineQuantity(
			ids,
			customerDocumentLineItem.Id,
			new Map<Id, QTO_Customer_Document_Quote_Line__c>{
				proposalLineItems.get(0).Id => associatedProposalLine
			}
		);
	}
	
	@isTest
	static void testSaveCDLineQuoteAssociationData() {
		Apttus_Proposal__Proposal__c proposal = [SELECT Id FROM Apttus_Proposal__Proposal__c LIMIT 1];
		proposal.Apttus_Proposal__Approval_Stage__c = 'Approved';
		update proposal;
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItems = 
			[
				SELECT Id FROM Apttus_Proposal__Proposal_Line_Item__c
				WHERE Apttus_Proposal__Proposal__c = :proposal.Id
			];
		List<String> saveDataStrings = new List<String>();
		for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem : proposalLineItems) {
			saveDataStrings.add('{"Id":"' + String.valueOf(proposalLineItem.Id) + '"}');
		}
		Customer_Document_Line_Items__c customerDocumentLineItem = [SELECT Id FROM Customer_Document_Line_Items__c LIMIT 1];
		update new Customer_Document_Line_Items__c(
			Status__c = 'Exception-Matching(Lines)',
			QTO_CDLI_Matched_Contracted_Quantity__c = 1,
			Id = customerDocumentLineItem.Id
		);
		insert new QTO_Customer_Document_Quote_Line__c(
			QTO_Proposal_Line_Item__c = proposalLineItems.get(0).Id,
			QTO_Customer_Document_Line_Items__c = customerDocumentLineItem.Id
		);
		QTO_ManualAssociationControllerHelper.saveCDLineQuoteAssociationData(
			'[' + String.join(saveDataStrings, ',') + ']',
			String.valueOf(customerDocumentLineItem.Id)
		);
	}
	
	@isTest
	static void testGetQuoteLinesToAssociate() {
		Customer_Document_Line_Items__c customerDocumentLineItem = [SELECT Id FROM Customer_Document_Line_Items__c LIMIT 1];
		QTO_ManualAssociationController.getQuoteLinesToAssociate(String.valueOf(customerDocumentLineItem.Id),'sold_to_party');
		QTO_ManualAssociationController.getQuoteLinesToAssociate(String.valueOf(customerDocumentLineItem.Id),'header_associations');
		QTO_ManualAssociationController.getQuoteLinesToAssociate(String.valueOf(customerDocumentLineItem.Id),'all');
	}
}