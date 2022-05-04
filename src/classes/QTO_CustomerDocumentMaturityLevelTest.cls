/*********************************************************************
* Class Name : QTO_CustomerDocumentMaturityLevelTest
* Test Class : QTO_CustomerDocumentMaturityLevelTest
* Created Date: 16 Feb 2022
* Created By : Shaik Johny Basha
* Description : DSI-2413 to adopt the Maturity level changes
*******************************************************************/
@isTest
public class QTO_CustomerDocumentMaturityLevelTest {
	
	@testsetup
	static void testSetupData() {
		List<Account> accList = QTO_TestDataFactory.createAccount(2);
		insert accList; 
		
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
		cd.Status__c =  QTO_Constants.CUSTOMER_DOCUMENT_REGISTRATION_STATUS;
		update cd;
		
		List<Customer_Document_Line_Items__c> customerDocLines = new List<Customer_Document_Line_Items__c>();
		
		Customer_Document_Line_Items__c cdli1 = new Customer_Document_Line_Items__c();		
		cdli1.High_level_Product__c = 'My SFR Cutlery';
		cdli1.High_level_Product_Description__c = 'My SFR Bundle Description';
		cdli1.Detailed_Product__c = 'Bundle1S4ABIA';
		cdli1.Detailed_Product_Description__c = 'Test Detailed Product Description';
		cdli1.QTO_PDF_Quantity__c = '1';
		cdli1.Quantity__c = '1';
		cdli1.QTO_PDF_Unit_Of_Measure__c = 'PCE';
		cdli1.QTO_Unit_Of_Measure__c = 'PCE';
		cdli1.QTO_PDF_Unit_Price__c = '2222,00';
		cdli1.Total_Value__c = 50;
		cdli1.QTO_PDF_Currency_Code__c = 'EUR';
		cdli1.CurrencyIsoCode = 'EUR';
		cdli1.QTO_Unit_Price__c = 2222.00;
		cdli1.Customer_Document__c = cd.Id;
		//cdli1.QTO_Product_Name__c = prdList[0].Id;
		
		customerDocLines.add(cdli1);
		
		insert customerDocLines;
		
		/*
		QTO_CPO_Field_Mapping__c fieldMapping = new QTO_CPO_Field_Mapping__c();
		fieldMapping.Customer_Name__c = accList[0].Name;
		fieldMapping.Mapping__c = '5';
		fieldMapping.PDF_Value__c = 'Exception Waiver';
		fieldMapping.Type__c = 'Maturity Level';
		insert fieldMapping;
		*/
	}
	
	@isTest
	static void cdExceptionAssociationTest() {
		test.startTest();
		Customer_Document__c cd = [Select Id, QTO_Customer_Name__c from Customer_Document__c limit 1];
		cd.Status__c = QTO_Constants.EXCEPTION_ASSOCIATION;
		QTO_CustomerDocumentMaturityLevel.processMaturityLevel(cd, QTO_Constants.EXCEPTION_ASSOCIATION);
		test.stopTest();
	}
	
	@isTest
	static void cdExceptionAssociationTest2() {
		test.startTest();
		Account account = [Select Id, Name from Account limit 1];
		QTO_CPO_Field_Mapping__c fieldMapping = new QTO_CPO_Field_Mapping__c();
		fieldMapping.Customer_Name__c = account.Name;
		fieldMapping.Mapping__c = '1';
		fieldMapping.PDF_Value__c = 'Exception Waiver';
		fieldMapping.Type__c = 'Maturity Level';
		insert fieldMapping;
		
		Customer_Document__c cd = [Select Id, QTO_Customer_Name__c from Customer_Document__c limit 1];
		cd.Status__c = QTO_Constants.EXCEPTION_ASSOCIATION;
		QTO_CustomerDocumentMaturityLevel.processMaturityLevel(cd, QTO_Constants.EXCEPTION_ASSOCIATION);
		test.stopTest();
	}
	
	@isTest
	static void cdExceptionEnrichmentLinesTest() {
		test.startTest();
		Customer_Document__c cd = [Select Id, QTO_Customer_Name__c from Customer_Document__c limit 1];
		cd.Status__c = QTO_Constants.STATUS_ENRICHMENT_FAILED;
		QTO_CustomerDocumentMaturityLevel.processMaturityLevel(cd, QTO_Constants.STATUS_ENRICHMENT_FAILED);
		test.stopTest();
	}
	
	@isTest
	static void cdExceptionEnrichmentLinesTest_2() {
		test.startTest();
		
		Account account = [Select Id, Name from Account limit 1];
		QTO_CPO_Field_Mapping__c fieldMapping = new QTO_CPO_Field_Mapping__c();
		fieldMapping.Customer_Name__c = account.Name;
		fieldMapping.Mapping__c = '3';
		fieldMapping.PDF_Value__c = 'Exception Waiver';
		fieldMapping.Type__c = 'Maturity Level';
		insert fieldMapping;
		
		
		Customer_Document__c cd = [Select Id, QTO_Customer_Name__c from Customer_Document__c limit 1];
		cd.Status__c = QTO_Constants.STATUS_ENRICHMENT_FAILED;
		QTO_CustomerDocumentMaturityLevel.processMaturityLevel(cd, QTO_Constants.STATUS_ENRICHMENT_FAILED);
		test.stopTest();
	}
	
	@isTest
	static void cdExceptionAssociationLinesTest() {
		test.startTest();
		Customer_Document__c cd = [Select Id, QTO_Customer_Name__c from Customer_Document__c limit 1];
		cd.Status__c = QTO_Constants.STATUS_ASSOCIATION_FAILED;
		QTO_CustomerDocumentMaturityLevel.processMaturityLevel(cd, QTO_Constants.STATUS_ASSOCIATION_FAILED);
		test.stopTest();
	}
	
	@isTest
	static void cdExceptionAssociationLinesTest_2() {
		test.startTest();
		Account account = [Select Id, Name from Account limit 1];
		QTO_CPO_Field_Mapping__c fieldMapping = new QTO_CPO_Field_Mapping__c();
		fieldMapping.Customer_Name__c = account.Name;
		fieldMapping.Mapping__c = '4';
		fieldMapping.PDF_Value__c = 'Exception Waiver';
		fieldMapping.Type__c = 'Maturity Level';
		insert fieldMapping;
		Customer_Document__c cd = [Select Id, QTO_Customer_Name__c from Customer_Document__c limit 1];
		cd.Status__c = QTO_Constants.STATUS_ASSOCIATION_FAILED;
		QTO_CustomerDocumentMaturityLevel.processMaturityLevel(cd, QTO_Constants.STATUS_ASSOCIATION_FAILED);
		test.stopTest();
	}
	
	@isTest
	static void cdExceptionMatchedLinesTest() {
		test.startTest();
		Customer_Document__c cd = [Select Id, QTO_Customer_Name__c, QTO_Line_Iteam_Association_Comment__c, QTO_Line_Item_Matching_Comment__c, Status__c from Customer_Document__c limit 1];
		cd.Status__c = QTO_Constants.STATUS_MATCHING_FAILED;
		QTO_CustomerDocumentMaturityLevel.processMaturityLevel(cd, QTO_Constants.STATUS_MATCHING_FAILED);
		test.stopTest();
	}
	@isTest
	static void cdExceptionMatchedLinesTest_2() {
		test.startTest();
		Account account = [Select Id, Name from Account limit 1];
		QTO_CPO_Field_Mapping__c fieldMapping = new QTO_CPO_Field_Mapping__c();
		fieldMapping.Customer_Name__c = account.Name;
		fieldMapping.Mapping__c = '5';
		fieldMapping.PDF_Value__c = 'Exception Waiver';
		fieldMapping.Type__c = 'Maturity Level';
		insert fieldMapping;
		Customer_Document__c cd = [Select Id, QTO_Customer_Name__c, QTO_Line_Iteam_Association_Comment__c, QTO_Line_Item_Matching_Comment__c, Status__c from Customer_Document__c limit 1];
		cd.Status__c = QTO_Constants.STATUS_MATCHING_FAILED;
		QTO_CustomerDocumentMaturityLevel.processMaturityLevel(cd, QTO_Constants.STATUS_MATCHING_FAILED);
		test.stopTest();
	}
	@isTest
	static void cdE2ETest() {
		test.startTest();
		Customer_Document__c cd = [Select Id, QTO_Customer_Name__c, QTO_Line_Iteam_Association_Comment__c, QTO_Line_Item_Matching_Comment__c, Status__c from Customer_Document__c limit 1];
		cd.Status__c = QTO_Constants.CUSTOMER_DOCUMENT_REGISTRATION_STATUS;
		QTO_CustomerDocumentMaturityLevel.processMaturityLevel(cd, QTO_Constants.STATUS_MATCHING_FAILED);
		test.stopTest();
	}
}