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
public class QTO_ReAssociationControllerTest {
	@TestSetup
	static void createData() {
		Account account = TestDataFactory.createAccount(1)[0];
		Database.insert(account);

		Customer_Document__c cd = new Customer_Document__c(
		Customer__c = account.Id,
		QTO_PDF_Customer_Name__c = account.Name,	
		Status__c = 'Exception-Association',
		Customer_Document_ID__c = '124356');
		Database.insert(cd);
		
		
		
		
		
	}
	
	public static testmethod void reAssociationTest(){
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
	
	public static testmethod void reAssociateCustomerDocumentLineItemsTest(){
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
	public static testmethod void reMatchingCustomerDocumentLineItemsTest(){
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
		insert cdLines;
		
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
	
	
	
	
}