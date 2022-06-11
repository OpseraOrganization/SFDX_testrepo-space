/**
* @Name: QTO_ReAssociationControllerTest
* @Author: Pavan Kumar
* @CreateDate: 12/04/2020 
* @Description: unit test coverage for re-association class QTO_ReAssociationController.
---------------------------------------------------------------------------------------------
* @LastModifiedBy: <LastModifiedBy>
* @LastModifiedDate: <LastModifiedDate> 
* @ChangeDescription: <ChangeDescription>
**/
@isTest
private class QTO_ReAssociationControllerTest {
	@TestSetup
	static void createData() {
		Account account = TestDataFactory.createAccount(1)[0];
		Database.insert(account);
		
		Case caseSO = new Case();
		caseSO.Account =account;
		caseSO.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Quote_to_Order_CPO_Case').getRecordTypeId();
		caseSO.Subject = 'Test';
		caseSO.Status = 'Registration';
		caseSO.Description = 'Test';
		caseSO.of_Employees_to_represent_Nokia_CP__c = '0-10%';
		insert caseSO;
		
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case WHERE Id =: caseSO.Id];
		
		Customer_Document__c cd = new Customer_Document__c(
			Customer__c = account.Id,
			Case__c = caseRetrieved.Id,
			QTO_PDF_Customer_Name__c = account.Name,	
			Status__c = 'Exception-Association',
			Customer_Document_ID__c = '124356');
		Database.insert(cd);  
	}
	  
	@IsTest
	static void reAssociationTest(){
		Customer_Document__c cd = [Select Id  from Customer_Document__c Limit 1];
		Test.startTest();
		Id BatchId = QTO_ReAssociationController.submitBatchJob(cd.Id);
		system.assert(BatchId != NULL,'batch submitted');
		String batchStatusInProcess = QTO_ReAssociationController.getBatchStatus('QTO_CustomerDocumentAssociationBatch',BatchId);
		system.assert(batchStatusInProcess != 'Completed','No batch is Running currently');
		Test.stopTest();
		String batchStatusComplete = QTO_ReAssociationController.getBatchStatus('QTO_CustomerDocumentAssociationBatch',BatchId);
		system.assert(batchStatusComplete == 'Completed','Batch is completed');
	}
	 
	@IsTest
	static void reAssociateCustomerDocumentLineItemsTest(){
		Customer_Document__c cd = [Select Id,QTO_PDF_Customer_Name__c,Customer__c from Customer_Document__c Limit 1];
		Test.startTest();
		
		List<Customer_Document_Line_Items__c> cdLines = new List<Customer_Document_Line_Items__c>();
		Customer_Document_Line_Items__c cdli14 = new Customer_Document_Line_Items__c();
		cdli14.High_level_Product__c = 'My SFR Cutlery';
		cdli14.High_level_Product_Description__c = 'My SFR Bundle Description';
		cdli14.Detailed_Product__c = 'Bundle 1S 4 ABIA';
		cdli14.Detailed_Product_Description__c = 'Test Detailed Product Description';
		cdli14.QTO_PDF_Quantity__c = '30';
		cdli14.Quantity__c = '30';
		cdli14.QTO_PDF_Unit_Of_Measure__c = 'PCE';
		cdli14.QTO_Unit_Of_Measure__c = 'Each';
		cdli14.QTO_PDF_Unit_Price__c = '2222,00';
		cdli14.Total_Value__c = 50;
		cdli14.QTO_PDF_Currency_Code__c = 'EUR';
		cdli14.CurrencyIsoCode = 'EUR';
		cdli14.QTO_Unit_Price__c = 2222.00;
		cdli14.Customer_Document__c = cd.Id;
		cdli14.QTO_Unit_of_Measure__c = 'PCE';
		cdli14.QTO_PDF_Total_Value__c = '624.70';					
		cdli14.QTO_PDF_Requested_Delivery_Date__c = '08.08.2021'; 
		cdli14.Status__c='Exception-Association(Lines)';
		cdli14.Association_Comment__c='Association Failed';
		cdLines.add(cdli14);
		
		Customer_Document_Line_Items__c cdli15 = new Customer_Document_Line_Items__c();
		cdli15.High_level_Product__c = 'My SFR Cutlery';
		cdli15.High_level_Product_Description__c = 'My SFR Bundle Description';
		cdli15.Detailed_Product__c = 'Bundle 1S 4 ABIA';
		cdli15.Detailed_Product_Description__c = 'Test Detailed Product Description';
		cdli15.QTO_PDF_Quantity__c = '0';
		cdli15.Quantity__c = '0';
		cdli15.QTO_PDF_Unit_Of_Measure__c = 'PCE';
		cdli15.QTO_Unit_Of_Measure__c = 'Each';
		cdli15.QTO_PDF_Unit_Price__c = '2222,00';
		cdli15.Total_Value__c = 50;
		cdli15.QTO_PDF_Currency_Code__c = 'EUR';
		cdli15.CurrencyIsoCode = 'EUR';
		cdli15.QTO_Unit_Price__c = 2222.00;
		cdli15.Customer_Document__c = cd.Id;
		cdli15.QTO_Unit_of_Measure__c = 'PCE';
		cdli15.QTO_PDF_Total_Value__c = '624.70';					
		cdli15.QTO_PDF_Requested_Delivery_Date__c = '08.08.2021'; 
		cdli15.Status__c='Exception-Matching(Lines)';
		cdLines.add(cdli15);		
		insert cdLines;
		
		List<Customer_facing_Attribute__c> lineItemCfas = new List<Customer_facing_Attribute__c>();
		Customer_facing_Attribute__c linecfa2 = new Customer_facing_Attribute__c();
		linecfa2.Attribute_Label__c = 'PDF CONTRACT REF';
		linecfa2.QTO_Customer_Document__c = null;
		linecfa2.QTO_Customer_Document_Line_Items__c = cdLines[0].Id;
		linecfa2.Quote__c = null;
		linecfa2.Quote_Line_Item__c = null;
		lineItemCfas.add(linecfa2);
		
		Customer_facing_Attribute__c linecfa3 = new Customer_facing_Attribute__c();
		linecfa3.Attribute_Label__c = 'PDF SITE CODE';
		linecfa3.Attribute_Value__c = 'S-00123360';
		linecfa3.QTO_Customer_Document__c = null;
		linecfa3.QTO_Customer_Document_Line_Items__c = cdLines[1].Id;
		lineItemCfas.add(linecfa3);
		
		insert lineItemCfas;
		List<Customer_Document__c> cddoc = new List<Customer_Document__c>{cd};
			QTO_CustomerDocument_Helper.updateCustomerDocument(cddoc);
		QTO_ReAssociationController.reAssociateCustomerDocumentLineItems(cd.Id) ;
		Test.stopTest(); 
	}
	
	@IsTest
	static void reMatchingCustomerDocumentLineItemsTest(){
		Customer_Document__c cd = [Select Id from Customer_Document__c Limit 1];
		Test.startTest();
		
		List<Customer_Document_Line_Items__c> cdLines = new List<Customer_Document_Line_Items__c>();
		Customer_Document_Line_Items__c cdli14 = new Customer_Document_Line_Items__c();
		cdli14.High_level_Product__c = 'My SFR Cutlery';
		cdli14.High_level_Product_Description__c = 'My SFR Bundle Description';
		cdli14.Detailed_Product__c = 'Bundle 1S 4 ABIA';
		cdli14.Detailed_Product_Description__c = 'Test Detailed Product Description';
		cdli14.QTO_PDF_Quantity__c = '30';
		cdli14.Quantity__c = '30';
		cdli14.QTO_PDF_Unit_Of_Measure__c = 'PCE';
		cdli14.QTO_Unit_Of_Measure__c = 'Each';
		cdli14.QTO_PDF_Unit_Price__c = '2222,00';
		cdli14.Total_Value__c = 50;
		cdli14.QTO_PDF_Currency_Code__c = 'EUR';
		cdli14.CurrencyIsoCode = 'EUR';
		cdli14.QTO_Unit_Price__c = 2222.00;
		cdli14.Customer_Document__c = cd.Id;
		cdli14.QTO_Unit_of_Measure__c = 'PCE';
		cdli14.QTO_PDF_Total_Value__c = '624.70';					
		cdli14.QTO_PDF_Requested_Delivery_Date__c = '08.08.2021'; 
		cdli14.Status__c='Exception-Association(Lines)';
		cdli14.Association_Comment__c='Association Failed';
		cdLines.add(cdli14);
		
		Customer_Document_Line_Items__c cdli15 = new Customer_Document_Line_Items__c();
		cdli15.High_level_Product__c = 'My SFR Cutlery';
		cdli15.High_level_Product_Description__c = 'My SFR Bundle Description';
		cdli15.Detailed_Product__c = 'Bundle 1S 4 ABIA';
		cdli15.Detailed_Product_Description__c = 'Test Detailed Product Description';
		cdli15.QTO_PDF_Quantity__c = '0';
		cdli15.Quantity__c = '0';
		cdli15.QTO_PDF_Unit_Of_Measure__c = 'PCE';
		cdli15.QTO_Unit_Of_Measure__c = 'Each';
		cdli15.QTO_PDF_Unit_Price__c = '2222,00';
		cdli15.Total_Value__c = 50;
		cdli15.QTO_PDF_Currency_Code__c = 'EUR';
		cdli15.CurrencyIsoCode = 'EUR';
		cdli15.QTO_Unit_Price__c = 2222.00;
		cdli15.Customer_Document__c = cd.Id;
		cdli15.QTO_Unit_of_Measure__c = 'PCE';
		cdli15.QTO_PDF_Total_Value__c = '624.70';					
		cdli15.QTO_PDF_Requested_Delivery_Date__c = '08.08.2021'; 
		cdli15.Status__c='Exception-Matching(Lines)';
		cdLines.add(cdli15);
		
		Customer_Document_Line_Items__c cdli2 = new Customer_Document_Line_Items__c();
		cdli2.High_level_Product__c = 'My SFR Cutlery1';
		cdli2.High_level_Product_Description__c = 'My SFR Bundle Description1';
		cdli2.Detailed_Product__c = 'Bundle 1S 4 ABIA1';
		cdli2.Detailed_Product_Description__c = 'Test Detailed Product Description1';
		cdli2.Contract_Item_Number__c = 'My SFR Cutlery1';
		cdli2.QTO_Product_Code__c = 'Bundle 1S 4 ABIA1';
		cdli2.QTO_PDF_Quantity__c = '30';
		cdli2.Quantity__c = '30';
		cdli2.QTO_PDF_Unit_Of_Measure__c = 'PCE';
		cdli2.QTO_Unit_Of_Measure__c = 'Each';
		cdli2.QTO_PDF_Unit_Price__c = '2222,00';
		cdli2.Total_Value__c = 50;
		cdli2.QTO_PDF_Currency_Code__c = 'EUR';
		cdli2.CurrencyIsoCode = 'EUR';
		cdli2.QTO_Unit_Price__c = 2222.00;
		cdli2.Customer_Document__c = cd.Id;
		cdli2.QTO_Unit_of_Measure__c = 'PCE';
		cdli2.QTO_PDF_Total_Value__c = '624.70';					
		cdli2.QTO_PDF_Requested_Delivery_Date__c = '08.08.2021';	
		cdli2.Status__c='Exception-Enrichment(Lines)';
		cdLines.add(cdli2);
		insert cdLines;
		
		List<Customer_facing_Attribute__c> lineItemCfas = new List<Customer_facing_Attribute__c>();
		Customer_facing_Attribute__c linecfa2 = new Customer_facing_Attribute__c();
		linecfa2.Attribute_Label__c = 'PDF CONTRACT REF';
		linecfa2.QTO_Customer_Document__c = null;
		linecfa2.QTO_Customer_Document_Line_Items__c = cdLines[0].Id;
		linecfa2.Quote__c = null;
		linecfa2.Quote_Line_Item__c = null;
		lineItemCfas.add(linecfa2);
		
		Customer_facing_Attribute__c linecfa3 = new Customer_facing_Attribute__c();
		linecfa3.Attribute_Label__c = 'PDF SITE CODE';
		linecfa3.Attribute_Value__c = 'S-00123360';
		linecfa3.QTO_Customer_Document__c = null;
		linecfa3.QTO_Customer_Document_Line_Items__c = cdLines[1].Id;
		lineItemCfas.add(linecfa3);
		
		insert lineItemCfas;
		
		QTO_ReAssociationController.reMatchingCustomerDocumentLineItems(cd.Id) ;
		QTO_ReAssociationController.reEnrichmentCustomerDocumentLineItems(cd.Id);
		Test.stopTest(); 
	}
	
	//DSI - 2150
	@IsTest
	static void testReProcessManuallyEnrichedCustomerDocumentLineItems() {
		Customer_Document__c customerDocument = [SELECT Id FROM Customer_Document__c LIMIT 1];
		List<Customer_Document_Line_Items__c> customerDocumentLineItems = new List<Customer_Document_Line_Items__c>();
		Customer_Document_Line_Items__c customerDocumentLineItem_1 = new Customer_Document_Line_Items__c();
		customerDocumentLineItem_1.High_level_Product__c = 'My SFR Cutlery';
		customerDocumentLineItem_1.High_level_Product_Description__c = 'My SFR Bundle Description';
		customerDocumentLineItem_1.Detailed_Product__c = 'Bundle 1S 4 ABIA';
		customerDocumentLineItem_1.Detailed_Product_Description__c = 'Test Detailed Product Description';
		customerDocumentLineItem_1.QTO_PDF_Quantity__c = '30';
		customerDocumentLineItem_1.Quantity__c = '30';
		customerDocumentLineItem_1.QTO_PDF_Unit_Of_Measure__c = 'PCE';
		customerDocumentLineItem_1.QTO_Unit_Of_Measure__c = 'Each';
		customerDocumentLineItem_1.QTO_PDF_Unit_Price__c = '2222,00';
		customerDocumentLineItem_1.Total_Value__c = 50;
		customerDocumentLineItem_1.QTO_PDF_Currency_Code__c = 'EUR';
		customerDocumentLineItem_1.CurrencyIsoCode = 'EUR';
		customerDocumentLineItem_1.QTO_Unit_Price__c = 2222.00;
		customerDocumentLineItem_1.Customer_Document__c = customerDocument.Id;
		customerDocumentLineItem_1.QTO_Unit_of_Measure__c = 'PCE';
		customerDocumentLineItem_1.QTO_PDF_Total_Value__c = '624.70';
		customerDocumentLineItem_1.QTO_PDF_Requested_Delivery_Date__c = '08.08.2021';
		customerDocumentLineItem_1.Status__c='Exception-Enriched(Lines)';
		customerDocumentLineItems.add(customerDocumentLineItem_1);

		Customer_Document_Line_Items__c customerDocumentLineItem_2 = new Customer_Document_Line_Items__c();
		customerDocumentLineItem_2.High_level_Product__c = 'My SFR Cutlery';
		customerDocumentLineItem_2.High_level_Product_Description__c = 'My SFR Bundle Description';
		customerDocumentLineItem_2.Detailed_Product__c = 'Bundle 1S 4 ABIA';
		customerDocumentLineItem_2.Detailed_Product_Description__c = 'Test Detailed Product Description';
		customerDocumentLineItem_2.QTO_PDF_Quantity__c = '0';
		customerDocumentLineItem_2.Quantity__c = '0';
		customerDocumentLineItem_2.QTO_PDF_Unit_Of_Measure__c = 'PCE';
		customerDocumentLineItem_2.QTO_Unit_Of_Measure__c = 'Each';
		customerDocumentLineItem_2.QTO_PDF_Unit_Price__c = '2222,00';
		customerDocumentLineItem_2.Total_Value__c = 50;
		customerDocumentLineItem_2.QTO_PDF_Currency_Code__c = 'EUR';
		customerDocumentLineItem_2.CurrencyIsoCode = 'EUR';
		customerDocumentLineItem_2.QTO_Unit_Price__c = 2222.00;
		customerDocumentLineItem_2.Customer_Document__c = customerDocument.Id;
		customerDocumentLineItem_2.QTO_Unit_of_Measure__c = 'PCE';
		customerDocumentLineItem_2.QTO_PDF_Total_Value__c = '624.70';
		customerDocumentLineItem_2.QTO_PDF_Requested_Delivery_Date__c = '08.08.2021';
		customerDocumentLineItem_2.Status__c='Manually-Enriched(Lines)';
		customerDocumentLineItems.add(customerDocumentLineItem_2);
		insert customerDocumentLineItems;

		List<Customer_facing_Attribute__c> customerFacingAttributes = new List<Customer_facing_Attribute__c>();
		Customer_facing_Attribute__c customerFacingAttribute_1 = new Customer_facing_Attribute__c();
		customerFacingAttribute_1.Attribute_Label__c = 'PDF CONTRACT REF';
		customerFacingAttribute_1.QTO_Customer_Document__c = null;
		customerFacingAttribute_1.QTO_Customer_Document_Line_Items__c = customerDocumentLineItem_2.Id;
		customerFacingAttribute_1.Quote__c = null;
		customerFacingAttribute_1.Quote_Line_Item__c = null;
		customerFacingAttributes.add(customerFacingAttribute_1);

		Customer_facing_Attribute__c customerFacingAttribute_2 = new Customer_facing_Attribute__c();
		customerFacingAttribute_2.Attribute_Label__c = 'PDF SITE CODE';
		customerFacingAttribute_2.Attribute_Value__c = 'S-00123360';
		customerFacingAttribute_2.QTO_Customer_Document__c = null;
		customerFacingAttribute_2.QTO_Customer_Document_Line_Items__c = customerDocumentLineItem_1.Id;
		customerFacingAttributes.add(customerFacingAttribute_2);
		insert customerFacingAttributes;

		Test.startTest();
		QTO_ReAssociationController.reProcessManuallyEnrichedCustomerDocumentLineItems(String.valueOf(customerDocument.Id));
		Test.stopTest();
		System.assertEquals(
			1, 
			[SELECT COUNT() 
	FROM Customer_Document_Line_Items__c 
	WHERE Customer_Document__c = :customerDocument.Id
	AND Status__c <> 'Manually-Enriched(Lines)'],
			'Expected one customer document line witout manually enriched lines status'
		);
	}
}