/******************************************************************************************************
Name : QTO_StagingToCustomerDocTranslation
Created Date: 2 September 2020
Created by: Bogdan Botcharov
Test class for : QTO_StagingToCustomerDocTranslation 
*********************************************************************************************************/
@isTest
public class QTO_StagingToCustomerDocTranslationTest {
	
	@testsetup
	public static void setupData(){
		
		Account parentAccount = TestDataFactory.createAccount(1)[0];
		parentAccount.AccountNumber='101234567';
		parentAccount.Acc_No__c = '101234567';
		parentAccount.Name = 'Parent Account';
		parentAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert parentAccount;
		
		List<Account> accountsNew = new List<Account>();
		
		Account customerAccount = TestDataFactory.createAccount(1)[0];
		customerAccount.AccountNumber='101234568';
		customerAccount.Acc_No__c = '101234568';
		customerAccount.Name = 'Customer Account';
		customerAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		customerAccount.ParentId = parentAccount.Id;
		customerAccount.Active__c = true;
		customerAccount.BillingPostalCode = '92661';		
		accountsNew.add(customerAccount);
		
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='101234569';
		accLegalEntity.Acc_No__c = '101234569';
		accLegalEntity.Name = 'Legal Account';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accLegalEntity.ParentId = parentAccount.Id;
		accLegalEntity.Active__c = true;
		accLegalEntity.BillingPostalCode = '92661';
		accLegalEntity.Type = 'Internal Customer';
		accountsNew.add(accLegalEntity);
		
		insert accountsNew;
		
		Case caseSO = new Case();
		caseSO.Account = accountsNew[0];
		caseSO.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Quote_to_Order_CPO_Case').getRecordTypeId();
		caseSO.Subject = 'Test';
		caseSO.Status = 'Exception';
		caseSO.Description = 'Test';
		caseSO.of_Employees_to_represent_Nokia_CP__c = '0-10%';
		
		insert caseSO;
		
		Apttus_Config2__PaymentTerm__c paymentTermSO = new Apttus_Config2__PaymentTerm__c();
		paymentTermSO.Apttus_Config2__Label__c = 'Net 60 Days';
		paymentTermSO.Apttus_Config2__Sequence__c = 1;
		insert paymentTermSO;
		
		
		QTO_CPO_Field_Mapping__c cpoFieldMap1 = new QTO_CPO_Field_Mapping__c(Type__c='Customer Name',
																			 PDF_Value__c='Pan Dacom Networking AG',
																			 Mapping__c='Customer Account');
		insert cpoFieldMap1;
				
		Apttus_Config2__PaymentTerm__c paymentTerms = new Apttus_Config2__PaymentTerm__c();
		paymentTerms.Name = 'P30';
		paymentTerms.Apttus_Config2__Sequence__c = 1;
		insert paymentTerms;
		
		QTO_CPO_Field_Mapping__c incoFieldMap1 = new QTO_CPO_Field_Mapping__c(Type__c='Inco Terms',
																			 PDF_Value__c='60NE',
																			 Mapping__c='P60',
																			 Customer_Name__c = 'Customer Account');
		insert incoFieldMap1;
		
		QTO_CPO_Field_Mapping__c payFieldMap1 = new QTO_CPO_Field_Mapping__c(Type__c='Payment Terms',
																			 PDF_Value__c='30 Tage netto',
																			 Mapping__c='P30',
																			 Customer_Name__c = 'Customer Account');
		insert payFieldMap1;
							   
		String payload1 = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "4500055128",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_INFO": "Customer Account",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
			'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
			'"OCR_INCO_TERM_INFO": "FH .",'+
			'"OCR_NOKIA_LEGAL_ENTITY_INFO": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_NAME": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE": "91620",'+
			'"OCR_NOKIA_REFERENCE": "Selon CONTRAT D EXECUTION ACCES RADIO FOURNITURE ET MAINTENANCE n°2009 00998 2009 2012 et ses avenants",'+
			'"OCR_PAYMENT_TERM_INFO": "60 Jours nets",'+
			'"OCR_TOTAL_VALUE": "911277",'+
			'"PEGA_CASE_CREATED_BY": "2020-09-01",'+
			'"PEGA_CASE_ID": "P00102032",'+
			'"PEGA_OMC_MANAGER_EMAIL": "OMC.Manager@Nokia.com",'+
			'"SF_CASE_CREATED_BY": "2020-09-01",'+
			'"SF_CASE_ID": "'+caseSO.CaseNumber+'",'+
			'"SF_CASE_WEB_MAIL": "SFR.procurement@SFR.COM",'+
			'"PDF_File_Reference_c": "00P0r000000vS0EEAU",'+
			'"Header_attribute": ['+
			'{'+
			'"OCR_HDS_ATTRIBUTE_LABEL": "Code Fournisseur",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'},'+
			'"Line_items": ['+
			'{'+
			'"OCR_CUSTOMER_DOCUMENT_LINE_ITEM": "10",'+
			'"OCR_CUSTOMER_PRODUCT_CODE": "921251",'+
			'"OCR_CUSTOMER_PRODUCT_DESCRIPTION": " SWAP ZTD CPX FDL AVEC ANTENNE NETTNT ",'+
			'"OCR_ITEM_PRICE_UNIT": "19153",'+
			'"OCR_ITEM_QUANTITY": "1",'+
			'"OCR_ITEM_TOTAL_VALUE": "19153",'+
			'"OCR_ITEM_UNIT_OF_MEASURE": "PCE",'+
			'"OCR_REQUESTED_DELIVERY_DATE": "25-10-2019",'+
			'"Result": "TRUE",'+
			'"Line_item_attribute": ['+
			'{'+
			'"OCR_ITS_ATTRIBUTE_LABEL": "Site",'+
			'"OCR_ITS_ATTRIBUTE_VALUE": " 930342 AUBERVILLIERS(LILAS)",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'}'+
			']'+
			'}';
				
		DS_Staging__c dsStagingSO1 = new DS_Staging__c();
		dsStagingSO1.DS_Payload__c = payload1;
		dsStagingSO1.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO1;
		
		String payload2 = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "In-House Order",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "4500055128",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "Risk-Order",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_INFO": "Customer Account",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
			'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
			'"OCR_INCO_TERM_INFO": "FH .",'+
			'"OCR_NOKIA_LEGAL_ENTITY_INFO": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_NAME": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE": "91620",'+
			'"OCR_NOKIA_REFERENCE": "Selon CONTRAT D EXECUTION ACCES RADIO FOURNITURE ET MAINTENANCE n°2009 00998 2009 2012 et ses avenants",'+
			'"OCR_PAYMENT_TERM_INFO": "60 Jours nets",'+
			'"OCR_TOTAL_VALUE": "911277",'+
			'"PEGA_CASE_CREATED_BY": "2020-09-01",'+
			'"PEGA_CASE_ID": "P00102032",'+
			'"PEGA_OMC_MANAGER_EMAIL": "OMC.Manager@Nokia.com",'+
			'"SF_CASE_CREATED_BY": "2020-09-01",'+
			'"SF_CASE_ID": "'+caseSO.CaseNumber+'",'+
			'"SF_CASE_WEB_MAIL": "SFR.procurement@SFR.COM",'+
			'"PDF_File_Reference_c": "00P0r000000vS0EEAU",'+
			'"Header_attribute": ['+
			'{'+
			'"OCR_HDS_ATTRIBUTE_LABEL": "Code Fournisseur",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'},'+
			'"Line_items": ['+
			'{'+
			'"OCR_CUSTOMER_DOCUMENT_LINE_ITEM": "10",'+
			'"OCR_CUSTOMER_PRODUCT_CODE": "921251",'+
			'"OCR_CUSTOMER_PRODUCT_DESCRIPTION": " SWAP ZTD CPX FDL AVEC ANTENNE NETTNT ",'+
			'"OCR_ITEM_PRICE_UNIT": "19153",'+
			'"OCR_ITEM_QUANTITY": "1",'+
			'"OCR_ITEM_TOTAL_VALUE": "19153",'+
			'"OCR_ITEM_UNIT_OF_MEASURE": "PCE",'+
			'"OCR_REQUESTED_DELIVERY_DATE": "25-10-2019",'+
			'"Result": "TRUE",'+
			'"Line_item_attribute": ['+
			'{'+
			'"OCR_ITS_ATTRIBUTE_LABEL": "Site",'+
			'"OCR_ITS_ATTRIBUTE_VALUE": " 930342 AUBERVILLIERS(LILAS)",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'}'+
			']'+
			'}';
				
		DS_Staging__c dsStagingSO2 = new DS_Staging__c();
		dsStagingSO2.DS_Payload__c = payload2;
		dsStagingSO2.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO2;
	}
	@isTest
	static void testmethod1(){
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case LIMIT 1];
		
		String payload = '{'+
							'"Header": {'+
							'"OCR_CURRENCY_INFO": "EUR",'+
							'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
							'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
							'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
							'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "Purchase Order",'+
							'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "",'+
							'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
							'"OCR_CUSTOMER_DOCUMENT_ID": "4500055128",'+
							'"OCR_CUSTOMER_INVOICING_ADDRESS_INFO": "Customer Account",'+
							'"OCR_CUSTOMER_INVOICING_ADDRESS_NAME": "Customer Account",'+
							'"OCR_CUSTOMER_NAME": "Customer Account",'+
							'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
							'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
							'"OCR_INCO_TERM_INFO": "FH .",'+
							'"OCR_NOKIA_LEGAL_ENTITY_INFO": "Legal Account",'+
							'"OCR_NOKIA_LEGAL_ENTITY_NAME": "Legal Account",'+
							'"OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE": "91620",'+
							'"OCR_NOKIA_REFERENCE": "Selon CONTRAT D EXECUTION ACCES RADIO FOURNITURE ET MAINTENANCE n°2009 00998 2009 2012 et ses avenants",'+
							'"OCR_PAYMENT_TERM_INFO": "60 Jours nets",'+
							'"OCR_TOTAL_VALUE": "911277",'+
							'"PEGA_CASE_CREATED_BY": "2020-09-01",'+
							'"PEGA_CASE_ID": "P00102032",'+
							'"PEGA_OMC_MANAGER_EMAIL": "OMC.Manager@Nokia.com",'+
							'"SF_CASE_CREATED_BY": "2020-09-01",'+
							'"SF_CASE_ID": "'+caseRetrieved.CaseNumber+'",'+
							'"SF_CASE_WEB_MAIL": "SFR.procurement@SFR.COM",'+
							'"PDF_File_Reference_c": "00P0r000000vS0EEAU",'+
							'"Header_attribute": ['+
							'{'+
							'"OCR_HDS_ATTRIBUTE_LABEL": "Code Fournisseur",'+
							'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
							'}'+
							']'+
							'},'+
							'"Line_items": ['+
							'{'+
							'"OCR_CUSTOMER_DOCUMENT_LINE_ITEM": "10",'+
							'"OCR_CUSTOMER_PRODUCT_CODE": "921251",'+
							'"OCR_CUSTOMER_PRODUCT_DESCRIPTION": " SWAP ZTD CPX FDL AVEC ANTENNE NETTNT ",'+
							'"OCR_ITEM_PRICE_UNIT": "19153",'+
							'"OCR_ITEM_QUANTITY": "1",'+
							'"OCR_ITEM_TOTAL_VALUE": "19153",'+
							'"OCR_ITEM_UNIT_OF_MEASURE": "PCE",'+
							'"OCR_REQUESTED_DELIVERY_DATE": "25-10-2019",'+
							'"Result": "TRUE",'+
							'"Line_item_attribute": ['+
							'{'+
							'"OCR_ITS_ATTRIBUTE_LABEL": "Site",'+
							'"OCR_ITS_ATTRIBUTE_VALUE": " 930342 AUBERVILLIERS(LILAS)",'+
							'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
							'}'+
							']'+
							'}'+
							']'+
							'}';

		test.startTest();
		DS_Staging__c dsStagingSO = new DS_Staging__c();
		dsStagingSO.DS_Payload__c = payload;
		dsStagingSO.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO;
		test.stopTest();
	}
	@isTest
	static void testmethod2(){
		
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case LIMIT 1];
		
		String payload = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "Purchase Order",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "4500055128",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_INFO": "Customer Account",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_NAME": "Customer Account Dummy",'+
			'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
			'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
			'"OCR_INCO_TERM_INFO": "FH . Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_INFO": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_NAME": "Legal Account Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE": "91620",'+
			'"OCR_NOKIA_REFERENCE": "Selon CONTRAT D EXECUTION ACCES RADIO FOURNITURE ET MAINTENANCE n°2009 00998 2009 2012 et ses avenants",'+
			'"OCR_PAYMENT_TERM_INFO": "60 Jours nets Dummy",'+
			'"OCR_TOTAL_VALUE": "911277",'+
			'"PEGA_CASE_CREATED_BY": "2020-09-01",'+
			'"PEGA_CASE_ID": "P00102032",'+
			'"PEGA_OMC_MANAGER_EMAIL": "OMC.Manager@Nokia.com",'+
			'"SF_CASE_CREATED_BY": "2020-09-01",'+
			'"SF_CASE_ID": "'+caseRetrieved.CaseNumber+'",'+
			'"SF_CASE_WEB_MAIL": "SFR.procurement@SFR.COM",'+
			'"PDF_File_Reference_c": "00P0r000000vS0EEAU",'+
			'"Header_attribute": ['+
			'{'+
			'"OCR_HDS_ATTRIBUTE_LABEL": "Code Fournisseur",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'},'+
			'"Line_items": ['+
			'{'+
			'"OCR_CUSTOMER_DOCUMENT_LINE_ITEM": "10",'+
			'"OCR_CUSTOMER_PRODUCT_CODE": "921251",'+
			'"OCR_CUSTOMER_PRODUCT_DESCRIPTION": " SWAP ZTD CPX FDL AVEC ANTENNE NETTNT ",'+
			'"OCR_ITEM_PRICE_UNIT": "19153",'+
			'"OCR_ITEM_QUANTITY": "1",'+
			'"OCR_ITEM_TOTAL_VALUE": "19153",'+
			'"OCR_ITEM_UNIT_OF_MEASURE": "PCE",'+
			'"OCR_REQUESTED_DELIVERY_DATE": "25-10-2019",'+
			'"Result": "TRUE",'+
			'"Line_item_attribute": ['+
			'{'+
			'"OCR_ITS_ATTRIBUTE_LABEL": "Site",'+
			'"OCR_ITS_ATTRIBUTE_VALUE": " 930342 AUBERVILLIERS(LILAS)",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'}'+
			']'+
			'}';
		
		test.startTest();
		DS_Staging__c dsStagingSO = new DS_Staging__c();
		dsStagingSO.DS_Payload__c = payload;
		dsStagingSO.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO;		
	   // QTO_StagingToCustomerDocTranslation.checkDuplicate(null,null);
		test.stopTest();
	}
	@isTest
	public static void testNatureCopy() {
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case LIMIT 1];
		String payload1 = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "Purchase Order",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "Create",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "Standard",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "450005512822",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_INFO": "Customer Account",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_NAME": "Customer Account Dummy",'+
			'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
			'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
			'"OCR_INCO_TERM_INFO": "FH . Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_INFO": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_NAME": "Legal Account Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE": "91620",'+
			'"OCR_NOKIA_REFERENCE": "Selon CONTRAT D EXECUTION ACCES RADIO FOURNITURE ET MAINTENANCE n°2009 00998 2009 2012 et ses avenants",'+
			'"OCR_PAYMENT_TERM_INFO": "60 Jours nets Dummy",'+
			'"OCR_TOTAL_VALUE": "911277",'+
			'"PEGA_CASE_CREATED_BY": "2020-09-01",'+
			'"PEGA_CASE_ID": "P00102032",'+
			'"PEGA_OMC_MANAGER_EMAIL": "OMC.Manager@Nokia.com",'+
			'"SF_CASE_CREATED_BY": "2020-09-01",'+
			'"SF_CASE_ID": "'+caseRetrieved.CaseNumber+'",'+
			'"SF_CASE_WEB_MAIL": "SFR.procurement@SFR.COM",'+
			'"PDF_File_Reference_c": "00P0r000000vS0EEAU",'+
			'"Header_attribute": ['+
			'{'+
			'"OCR_HDS_ATTRIBUTE_LABEL": "Code Fournisseur",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'},'+
			'"Line_items": ['+
			'{'+
			'"OCR_CUSTOMER_DOCUMENT_LINE_ITEM": "10",'+
			'"OCR_CUSTOMER_PRODUCT_CODE": "921251",'+
			'"OCR_CUSTOMER_PRODUCT_DESCRIPTION": " SWAP ZTD CPX FDL AVEC ANTENNE NETTNT ",'+
			'"OCR_ITEM_PRICE_UNIT": "19153",'+
			'"OCR_ITEM_QUANTITY": "1",'+
			'"OCR_ITEM_TOTAL_VALUE": "19153",'+
			'"OCR_ITEM_UNIT_OF_MEASURE": "PCE",'+
			'"OCR_REQUESTED_DELIVERY_DATE": "25-10-2019",'+
			'"Result": "TRUE",'+
			'"Line_item_attribute": ['+
			'{'+
			'"OCR_ITS_ATTRIBUTE_LABEL": "Site",'+
			'"OCR_ITS_ATTRIBUTE_VALUE": " 930342 AUBERVILLIERS(LILAS)",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'}'+
			']'+
			'}';
		
		
		String payload2 = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "Purchase Order",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "Copy",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "Standard",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "450005512822",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_INFO": "Customer Account",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_NAME": "Customer Account Dummy",'+
			'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
			'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
			'"OCR_INCO_TERM_INFO": "FH . Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_INFO": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_NAME": "Legal Account Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE": "91620",'+
			'"OCR_NOKIA_REFERENCE": "Selon CONTRAT D EXECUTION ACCES RADIO FOURNITURE ET MAINTENANCE n°2009 00998 2009 2012 et ses avenants",'+
			'"OCR_PAYMENT_TERM_INFO": "60 Jours nets Dummy",'+
			'"OCR_TOTAL_VALUE": "911277",'+
			'"PEGA_CASE_CREATED_BY": "2020-09-01",'+
			'"PEGA_CASE_ID": "P00102032",'+
			'"PEGA_OMC_MANAGER_EMAIL": "OMC.Manager@Nokia.com",'+
			'"SF_CASE_CREATED_BY": "2020-09-01",'+
			'"SF_CASE_ID": "'+caseRetrieved.CaseNumber+'",'+
			'"SF_CASE_WEB_MAIL": "SFR.procurement@SFR.COM",'+
			'"PDF_File_Reference_c": "00P0r000000vS0EEAU",'+
			'"Header_attribute": ['+
			'{'+
			'"OCR_HDS_ATTRIBUTE_LABEL": "Code Fournisseur",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'},'+
			'"Line_items": ['+
			'{'+
			'"OCR_CUSTOMER_DOCUMENT_LINE_ITEM": "10",'+
			'"OCR_CUSTOMER_PRODUCT_CODE": "921251",'+
			'"OCR_CUSTOMER_PRODUCT_DESCRIPTION": " SWAP ZTD CPX FDL AVEC ANTENNE NETTNT ",'+
			'"OCR_ITEM_PRICE_UNIT": "19153",'+
			'"OCR_ITEM_QUANTITY": "1",'+
			'"OCR_ITEM_TOTAL_VALUE": "19153",'+
			'"OCR_ITEM_UNIT_OF_MEASURE": "PCE",'+
			'"OCR_REQUESTED_DELIVERY_DATE": "25-10-2019",'+
			'"Result": "TRUE",'+
			'"Line_item_attribute": ['+
			'{'+
			'"OCR_ITS_ATTRIBUTE_LABEL": "Site",'+
			'"OCR_ITS_ATTRIBUTE_VALUE": " 930342 AUBERVILLIERS(LILAS)",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'}'+
			']'+
			'}';
		test.startTest();
		
		DS_Staging__c dsStagingSO1 = new DS_Staging__c();
		dsStagingSO1.DS_Payload__c = payload1;
		dsStagingSO1.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO1; 
		
		DS_Staging__c dsStagingSO2 = new DS_Staging__c();
		dsStagingSO2.DS_Payload__c = payload2;
		dsStagingSO2.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO2;		
		test.stopTest();
	}
	@isTest
	public static void testNatureCreate() {
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case LIMIT 1];
		String payload1 = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "Purchase Order",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "Create",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "Standard",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "450005512823",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_INFO": "Customer Account",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_NAME": "Customer Account Dummy",'+
			'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
			'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
			'"OCR_INCO_TERM_INFO": "FH . Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_INFO": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_NAME": "Legal Account Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE": "91620",'+
			'"OCR_NOKIA_REFERENCE": "Selon CONTRAT D EXECUTION ACCES RADIO FOURNITURE ET MAINTENANCE n°2009 00998 2009 2012 et ses avenants",'+
			'"OCR_PAYMENT_TERM_INFO": "60 Jours nets Dummy",'+
			'"OCR_TOTAL_VALUE": "911277",'+
			'"PEGA_CASE_CREATED_BY": "2020-09-01",'+
			'"PEGA_CASE_ID": "P00102032",'+
			'"PEGA_OMC_MANAGER_EMAIL": "OMC.Manager@Nokia.com",'+
			'"SF_CASE_CREATED_BY": "2020-09-01",'+
			'"SF_CASE_ID": "'+caseRetrieved.CaseNumber+'",'+
			'"SF_CASE_WEB_MAIL": "SFR.procurement@SFR.COM",'+
			'"PDF_File_Reference_c": "00P0r000000vS0EEAU",'+
			'"Header_attribute": ['+
			'{'+
			'"OCR_HDS_ATTRIBUTE_LABEL": "Code Fournisseur",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'},'+
			'"Line_items": ['+
			'{'+
			'"OCR_CUSTOMER_DOCUMENT_LINE_ITEM": "10",'+
			'"OCR_CUSTOMER_PRODUCT_CODE": "921251",'+
			'"OCR_CUSTOMER_PRODUCT_DESCRIPTION": " SWAP ZTD CPX FDL AVEC ANTENNE NETTNT ",'+
			'"OCR_ITEM_PRICE_UNIT": "19153",'+
			'"OCR_ITEM_QUANTITY": "1",'+
			'"OCR_ITEM_TOTAL_VALUE": "19153",'+
			'"OCR_ITEM_UNIT_OF_MEASURE": "PCE",'+
			'"OCR_REQUESTED_DELIVERY_DATE": "25-10-2019",'+
			'"Result": "TRUE",'+
			'"Line_item_attribute": ['+
			'{'+
			'"OCR_ITS_ATTRIBUTE_LABEL": "Site",'+
			'"OCR_ITS_ATTRIBUTE_VALUE": " 930342 AUBERVILLIERS(LILAS)",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'}'+
			']'+
			'}';
		
		
		String payload2 = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "Purchase Order",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "Create",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "Standard",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "450005512823",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_INFO": "Customer Account",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_NAME": "Customer Account Dummy",'+
			'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
			'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
			'"OCR_INCO_TERM_INFO": "FH . Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_INFO": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_NAME": "Legal Account Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE": "91620",'+
			'"OCR_NOKIA_REFERENCE": "Selon CONTRAT D EXECUTION ACCES RADIO FOURNITURE ET MAINTENANCE n°2009 00998 2009 2012 et ses avenants",'+
			'"OCR_PAYMENT_TERM_INFO": "60 Jours nets Dummy",'+
			'"OCR_TOTAL_VALUE": "911277",'+
			'"PEGA_CASE_CREATED_BY": "2020-09-01",'+
			'"PEGA_CASE_ID": "P00102032",'+
			'"PEGA_OMC_MANAGER_EMAIL": "OMC.Manager@Nokia.com",'+
			'"SF_CASE_CREATED_BY": "2020-09-01",'+
			'"SF_CASE_ID": "'+caseRetrieved.CaseNumber+'",'+
			'"SF_CASE_WEB_MAIL": "SFR.procurement@SFR.COM",'+
			'"PDF_File_Reference_c": "00P0r000000vS0EEAU",'+
			'"Header_attribute": ['+
			'{'+
			'"OCR_HDS_ATTRIBUTE_LABEL": "Code Fournisseur",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'},'+
			'"Line_items": ['+
			'{'+
			'"OCR_CUSTOMER_DOCUMENT_LINE_ITEM": "10",'+
			'"OCR_CUSTOMER_PRODUCT_CODE": "921251",'+
			'"OCR_CUSTOMER_PRODUCT_DESCRIPTION": " SWAP ZTD CPX FDL AVEC ANTENNE NETTNT ",'+
			'"OCR_ITEM_PRICE_UNIT": "19153",'+
			'"OCR_ITEM_QUANTITY": "1",'+
			'"OCR_ITEM_TOTAL_VALUE": "19153",'+
			'"OCR_ITEM_UNIT_OF_MEASURE": "PCE",'+
			'"OCR_REQUESTED_DELIVERY_DATE": "25-10-2019",'+
			'"Result": "TRUE",'+
			'"Line_item_attribute": ['+
			'{'+
			'"OCR_ITS_ATTRIBUTE_LABEL": "Site",'+
			'"OCR_ITS_ATTRIBUTE_VALUE": " 930342 AUBERVILLIERS(LILAS)",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'}'+
			']'+
			'}';
		test.startTest();
		
		DS_Staging__c dsStagingSO1 = new DS_Staging__c();
		dsStagingSO1.DS_Payload__c = payload1;
		dsStagingSO1.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO1; 
		
		DS_Staging__c dsStagingSO2 = new DS_Staging__c();
		dsStagingSO2.DS_Payload__c = payload2;
		dsStagingSO2.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO2;		
		//QTO_StagingToCustomerDocTranslation.checkDuplicate(null,null);
		test.stopTest();
	}
	@isTest
	public static void testNatureUnset() {
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case LIMIT 1];
		String payload1 = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "Purchase Order",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "Standard",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "450005512824",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_INFO": "Customer Account",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_NAME": "Customer Account Dummy",'+
			'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
			'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
			'"OCR_INCO_TERM_INFO": "FH . Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_INFO": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_NAME": "Legal Account Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE": "91620",'+
			'"OCR_NOKIA_REFERENCE": "Selon CONTRAT D EXECUTION ACCES RADIO FOURNITURE ET MAINTENANCE n°2009 00998 2009 2012 et ses avenants",'+
			'"OCR_PAYMENT_TERM_INFO": "60 Jours nets Dummy",'+
			'"OCR_TOTAL_VALUE": "911277",'+
			'"PEGA_CASE_CREATED_BY": "2020-09-01",'+
			'"PEGA_CASE_ID": "P00102032",'+
			'"PEGA_OMC_MANAGER_EMAIL": "OMC.Manager@Nokia.com",'+
			'"SF_CASE_CREATED_BY": "2020-09-01",'+
			'"SF_CASE_ID": "'+caseRetrieved.CaseNumber+'",'+
			'"SF_CASE_WEB_MAIL": "SFR.procurement@SFR.COM",'+
			'"PDF_File_Reference_c": "00P0r000000vS0EEAU",'+
			'"Header_attribute": ['+
			'{'+
			'"OCR_HDS_ATTRIBUTE_LABEL": "Code Fournisseur",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'},'+
			'"Line_items": ['+
			'{'+
			'"OCR_CUSTOMER_DOCUMENT_LINE_ITEM": "10",'+
			'"OCR_CUSTOMER_PRODUCT_CODE": "921251",'+
			'"OCR_CUSTOMER_PRODUCT_DESCRIPTION": " SWAP ZTD CPX FDL AVEC ANTENNE NETTNT ",'+
			'"OCR_ITEM_PRICE_UNIT": "19153",'+
			'"OCR_ITEM_QUANTITY": "1",'+
			'"OCR_ITEM_TOTAL_VALUE": "19153",'+
			'"OCR_ITEM_UNIT_OF_MEASURE": "PCE",'+
			'"OCR_REQUESTED_DELIVERY_DATE": "25-10-2019",'+
			'"Result": "TRUE",'+
			'"Line_item_attribute": ['+
			'{'+
			'"OCR_ITS_ATTRIBUTE_LABEL": "Site",'+
			'"OCR_ITS_ATTRIBUTE_VALUE": " 930342 AUBERVILLIERS(LILAS)",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'}'+
			']'+
			'}';
		
		
		String payload2 = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "Purchase Order",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "Standard",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "450005512824",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_INFO": "Customer Account",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_NAME": "Customer Account Dummy",'+
			'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
			'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
			'"OCR_INCO_TERM_INFO": "FH . Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_INFO": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_NAME": "Legal Account Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE": "91620",'+
			'"OCR_NOKIA_REFERENCE": "Selon CONTRAT D EXECUTION ACCES RADIO FOURNITURE ET MAINTENANCE n°2009 00998 2009 2012 et ses avenants",'+
			'"OCR_PAYMENT_TERM_INFO": "60 Jours nets Dummy",'+
			'"OCR_TOTAL_VALUE": "911277",'+
			'"PEGA_CASE_CREATED_BY": "2020-09-01",'+
			'"PEGA_CASE_ID": "P00102032",'+
			'"PEGA_OMC_MANAGER_EMAIL": "OMC.Manager@Nokia.com",'+
			'"SF_CASE_CREATED_BY": "2020-09-01",'+
			'"SF_CASE_ID": "'+caseRetrieved.CaseNumber+'",'+
			'"SF_CASE_WEB_MAIL": "SFR.procurement@SFR.COM",'+
			'"PDF_File_Reference_c": "00P0r000000vS0EEAU",'+
			'"Header_attribute": ['+
			'{'+
			'"OCR_HDS_ATTRIBUTE_LABEL": "Code Fournisseur",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'},'+
			'"Line_items": ['+
			'{'+
			'"OCR_CUSTOMER_DOCUMENT_LINE_ITEM": "10",'+
			'"OCR_CUSTOMER_PRODUCT_CODE": "921251",'+
			'"OCR_CUSTOMER_PRODUCT_DESCRIPTION": " SWAP ZTD CPX FDL AVEC ANTENNE NETTNT ",'+
			'"OCR_ITEM_PRICE_UNIT": "19153",'+
			'"OCR_ITEM_QUANTITY": "1",'+
			'"OCR_ITEM_TOTAL_VALUE": "19153",'+
			'"OCR_ITEM_UNIT_OF_MEASURE": "PCE",'+
			'"OCR_REQUESTED_DELIVERY_DATE": "25-10-2019",'+
			'"Result": "TRUE",'+
			'"Line_item_attribute": ['+
			'{'+
			'"OCR_ITS_ATTRIBUTE_LABEL": "Site",'+
			'"OCR_ITS_ATTRIBUTE_VALUE": " 930342 AUBERVILLIERS(LILAS)",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'}'+
			']'+
			'}';
		test.startTest();
		
		DS_Staging__c dsStagingSO1 = new DS_Staging__c();
		dsStagingSO1.DS_Payload__c = payload1;
		dsStagingSO1.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO1; 
		
		DS_Staging__c dsStagingSO2 = new DS_Staging__c();
		dsStagingSO2.DS_Payload__c = payload2;
		dsStagingSO2.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO2;		
		//QTO_StagingToCustomerDocTranslation.checkDuplicate(null,null);
		test.stopTest();
	}
	@isTest
	public static void testCopyValidation() {
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case LIMIT 1];
		String payload1 = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "Purchase Order",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "Copy",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "Standard",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "4500055128223",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_INFO": "Customer Account",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_NAME": "Customer Account Dummy",'+
			'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
			'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
			'"OCR_INCO_TERM_INFO": "FH . Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_INFO": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_NAME": "Legal Account Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE": "91620",'+
			'"OCR_NOKIA_REFERENCE": "Selon CONTRAT D EXECUTION ACCES RADIO FOURNITURE ET MAINTENANCE n°2009 00998 2009 2012 et ses avenants",'+
			'"OCR_PAYMENT_TERM_INFO": "60 Jours nets Dummy",'+
			'"OCR_TOTAL_VALUE": "911277",'+
			'"PEGA_CASE_CREATED_BY": "2020-09-01",'+
			'"PEGA_CASE_ID": "P00102032",'+
			'"PEGA_OMC_MANAGER_EMAIL": "OMC.Manager@Nokia.com",'+
			'"SF_CASE_CREATED_BY": "2020-09-01",'+
			'"SF_CASE_ID": "'+caseRetrieved.CaseNumber+'",'+
			'"SF_CASE_WEB_MAIL": "SFR.procurement@SFR.COM",'+
			'"PDF_File_Reference_c": "00P0r000000vS0EEAU",'+
			'"Header_attribute": ['+
			'{'+
			'"OCR_HDS_ATTRIBUTE_LABEL": "Code Fournisseur",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'},'+
			'"Line_items": ['+
			'{'+
			'"OCR_CUSTOMER_DOCUMENT_LINE_ITEM": "10",'+
			'"OCR_CUSTOMER_PRODUCT_CODE": "921251",'+
			'"OCR_CUSTOMER_PRODUCT_DESCRIPTION": " SWAP ZTD CPX FDL AVEC ANTENNE NETTNT ",'+
			'"OCR_ITEM_PRICE_UNIT": "19153",'+
			'"OCR_ITEM_QUANTITY": "1",'+
			'"OCR_ITEM_TOTAL_VALUE": "19153",'+
			'"OCR_ITEM_UNIT_OF_MEASURE": "PCE",'+
			'"OCR_REQUESTED_DELIVERY_DATE": "25-10-2019",'+
			'"Result": "TRUE",'+
			'"Line_item_attribute": ['+
			'{'+
			'"OCR_ITS_ATTRIBUTE_LABEL": "Site",'+
			'"OCR_ITS_ATTRIBUTE_VALUE": " 930342 AUBERVILLIERS(LILAS)",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'}'+
			']'+
			'}';
		test.startTest();
		DS_Staging__c dsStagingSO = new DS_Staging__c();
		dsStagingSO.DS_Payload__c = payload1;
		dsStagingSO.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO;		
		test.stopTest();
	}
	
	@isTest
	public static void testClassificationValidationInHouseOrder() {
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case LIMIT 1];
		String payload = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "In-House Order",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "4500055128223",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_INFO": "Customer Account",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_NAME": "Customer Account Dummy",'+
			'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
			'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
			'"OCR_INCO_TERM_INFO": "FH . Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_INFO": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_NAME": "Legal Account Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE": "91620",'+
			'"OCR_NOKIA_REFERENCE": "Selon CONTRAT D EXECUTION ACCES RADIO FOURNITURE ET MAINTENANCE n°2009 00998 2009 2012 et ses avenants",'+
			'"OCR_PAYMENT_TERM_INFO": "60 Jours nets Dummy",'+
			'"OCR_TOTAL_VALUE": "911277",'+
			'"PEGA_CASE_CREATED_BY": "2020-09-01",'+
			'"PEGA_CASE_ID": "P00102032",'+
			'"PEGA_OMC_MANAGER_EMAIL": "OMC.Manager@Nokia.com",'+
			'"SF_CASE_CREATED_BY": "2020-09-01",'+
			'"SF_CASE_ID": "'+caseRetrieved.CaseNumber+'",'+
			'"SF_CASE_WEB_MAIL": "SFR.procurement@SFR.COM",'+
			'"PDF_File_Reference_c": "00P0r000000vS0EEAU",'+
			'"Header_attribute": ['+
			'{'+
			'"OCR_HDS_ATTRIBUTE_LABEL": "Code Fournisseur",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'},'+
			'"Line_items": ['+
			'{'+
			'"OCR_CUSTOMER_DOCUMENT_LINE_ITEM": "10",'+
			'"OCR_CUSTOMER_PRODUCT_CODE": "921251",'+
			'"OCR_CUSTOMER_PRODUCT_DESCRIPTION": " SWAP ZTD CPX FDL AVEC ANTENNE NETTNT ",'+
			'"OCR_ITEM_PRICE_UNIT": "19153",'+
			'"OCR_ITEM_QUANTITY": "1",'+
			'"OCR_ITEM_TOTAL_VALUE": "19153",'+
			'"OCR_ITEM_UNIT_OF_MEASURE": "PCE",'+
			'"OCR_REQUESTED_DELIVERY_DATE": "25-10-2019",'+
			'"Result": "TRUE",'+
			'"Line_item_attribute": ['+
			'{'+
			'"OCR_ITS_ATTRIBUTE_LABEL": "Site",'+
			'"OCR_ITS_ATTRIBUTE_VALUE": " 930342 AUBERVILLIERS(LILAS)",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'}'+
			']'+
			'}';
		test.startTest();
		DS_Staging__c dsStagingSO = new DS_Staging__c();
		dsStagingSO.DS_Payload__c = payload;
		dsStagingSO.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO;		
		test.stopTest();
	}
	@isTest
	public static void testClassificationValidationPOBlanket() {
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case LIMIT 1];
		String payload = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "Purchase Order",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "Blanket",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "4500055128223",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_INFO": "Customer Account",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_NAME": "Customer Account Dummy",'+
			'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
			'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
			'"OCR_INCO_TERM_INFO": "FH . Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_INFO": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_NAME": "Legal Account Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE": "91620",'+
			'"OCR_NOKIA_REFERENCE": "Selon CONTRAT D EXECUTION ACCES RADIO FOURNITURE ET MAINTENANCE n°2009 00998 2009 2012 et ses avenants",'+
			'"OCR_PAYMENT_TERM_INFO": "60 Jours nets Dummy",'+
			'"OCR_TOTAL_VALUE": "911277",'+
			'"PEGA_CASE_CREATED_BY": "2020-09-01",'+
			'"PEGA_CASE_ID": "P00102032",'+
			'"PEGA_OMC_MANAGER_EMAIL": "OMC.Manager@Nokia.com",'+
			'"SF_CASE_CREATED_BY": "2020-09-01",'+
			'"SF_CASE_ID": "'+caseRetrieved.CaseNumber+'",'+
			'"SF_CASE_WEB_MAIL": "SFR.procurement@SFR.COM",'+
			'"PDF_File_Reference_c": "00P0r000000vS0EEAU",'+
			'"Header_attribute": ['+
			'{'+
			'"OCR_HDS_ATTRIBUTE_LABEL": "Code Fournisseur",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'},'+
			'"Line_items": ['+
			'{'+
			'"OCR_CUSTOMER_DOCUMENT_LINE_ITEM": "10",'+
			'"OCR_CUSTOMER_PRODUCT_CODE": "921251",'+
			'"OCR_CUSTOMER_PRODUCT_DESCRIPTION": " SWAP ZTD CPX FDL AVEC ANTENNE NETTNT ",'+
			'"OCR_ITEM_PRICE_UNIT": "19153",'+
			'"OCR_ITEM_QUANTITY": "1",'+
			'"OCR_ITEM_TOTAL_VALUE": "19153",'+
			'"OCR_ITEM_UNIT_OF_MEASURE": "PCE",'+
			'"OCR_REQUESTED_DELIVERY_DATE": "25-10-2019",'+
			'"Result": "TRUE",'+
			'"Line_item_attribute": ['+
			'{'+
			'"OCR_ITS_ATTRIBUTE_LABEL": "Site",'+
			'"OCR_ITS_ATTRIBUTE_VALUE": " 930342 AUBERVILLIERS(LILAS)",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'}'+
			']'+
			'}';
		test.startTest();
		DS_Staging__c dsStagingSO = new DS_Staging__c();
		dsStagingSO.DS_Payload__c = payload;
		dsStagingSO.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO;		
		test.stopTest();
	}
	
	/*
	@isTest
	public static void testMandatoryFields(){
		test.startTest();
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case LIMIT 1];
		String payload = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "Purchase Order",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "TOTO",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "4500055128223",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_INFO": "Customer Account",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_NAME": "Customer Account Dummy",'+
			'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
			'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
			'"OCR_INCO_TERM_INFO": "FH . Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_INFO": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_NAME": "Legal Account Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE": "91620",'+
			'"OCR_NOKIA_REFERENCE": "Selon CONTRAT D EXECUTION ACCES RADIO FOURNITURE ET MAINTENANCE n°2009 00998 2009 2012 et ses avenants",'+
			'"OCR_PAYMENT_TERM_INFO": "60 Jours nets Dummy",'+
			'"OCR_TOTAL_VALUE": "911277",'+
			'"PEGA_CASE_CREATED_BY": "2020-09-01",'+
			'"PEGA_CASE_ID": "P00102032",'+
			'"PEGA_OMC_MANAGER_EMAIL": "OMC.Manager@Nokia.com",'+
			'"SF_CASE_CREATED_BY": "2020-09-01",'+
			'"SF_CASE_ID": "'+caseRetrieved.CaseNumber+'",'+
			'"SF_CASE_WEB_MAIL": "SFR.procurement@SFR.COM",'+
			'"PDF_File_Reference_c": "00P0r000000vS0EEAU",'+
			'"Header_attribute": ['+
			'{'+
			'"OCR_HDS_ATTRIBUTE_LABEL": "Code Fournisseur",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'},'+
			'"Line_items": ['+
			'{'+
			'"OCR_CUSTOMER_DOCUMENT_LINE_ITEM": "10",'+
			'"OCR_CUSTOMER_PRODUCT_CODE": "921251",'+
			'"OCR_CUSTOMER_PRODUCT_DESCRIPTION": " SWAP ZTD CPX FDL AVEC ANTENNE NETTNT ",'+
			'"OCR_ITEM_PRICE_UNIT": "19153",'+
			'"OCR_ITEM_QUANTITY": "1",'+
			'"OCR_ITEM_TOTAL_VALUE": "19153",'+
			'"OCR_ITEM_UNIT_OF_MEASURE": "PCE",'+
			'"OCR_REQUESTED_DELIVERY_DATE": "25-10-2019",'+
			'"Result": "TRUE",'+
			'"Line_item_attribute": ['+
			'{'+
			'"OCR_ITS_ATTRIBUTE_LABEL": "Site",'+
			'"OCR_ITS_ATTRIBUTE_VALUE": " 930342 AUBERVILLIERS(LILAS)",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'}'+
			']'+
			'}';
	 
		DS_Staging__c dsStagingSO = new DS_Staging__c();
		dsStagingSO.DS_Payload__c = payload;
		dsStagingSO.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO;		
		Customer_Document__c cd = [Select Id from Customer_Document__c LIMIT 1];		 
		cd.Status__c = QTO_Constants.CUSTOMER_DOCUMENT_REGISTRATION_STATUS;
		update cd;
		test.stopTest();
	}
	
	@isTest
	public static void testTaskClose(){
		test.startTest();
		Customer_Document__c cd = [Select Id from Customer_Document__c LIMIT 1];		
		cd.Status__c = QTO_Constants.CLOSED_CANCELLED;
		update cd;
		test.stopTest();
	}
	
	/*
	@isTest
	public static void testValidateAssociations(){
		test.startTest();
		Customer_Document__c cdSO = [Select Id from Customer_Document__c LIMIT 1]; 
		Map<Id,Customer_Document__c> associatedCDs = new Map<Id,Customer_Document__c>();
		associatedCDs.put(cdSO.Id,cdSO);
		QTO_CustomerDocument_Helper.validateAssociations(associatedCDs);
	  	//update cd;
		test.stopTest();
	}
	*/
	
	@isTest
	public static void testChangeValidation() {
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case LIMIT 1];
		String payload1 = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "Purchase Order",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "Change",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "Standard",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "45000551282231",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_INFO": "Customer Account",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_NAME": "Customer Account Dummy",'+
			'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
			'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
			'"OCR_INCO_TERM_INFO": "FH . Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_INFO": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_NAME": "Legal Account Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE": "91620",'+
			'"OCR_NOKIA_REFERENCE": "Selon CONTRAT D EXECUTION ACCES RADIO FOURNITURE ET MAINTENANCE n°2009 00998 2009 2012 et ses avenants",'+
			'"OCR_PAYMENT_TERM_INFO": "60 Jours nets Dummy",'+
			'"OCR_TOTAL_VALUE": "911277",'+
			'"PEGA_CASE_CREATED_BY": "2020-09-01",'+
			'"PEGA_CASE_ID": "P00102032",'+
			'"PEGA_OMC_MANAGER_EMAIL": "OMC.Manager@Nokia.com",'+
			'"SF_CASE_CREATED_BY": "2020-09-01",'+
			'"SF_CASE_ID": "'+caseRetrieved.CaseNumber+'",'+
			'"SF_CASE_WEB_MAIL": "SFR.procurement@SFR.COM",'+
			'"PDF_File_Reference_c": "00P0r000000vS0EEAU",'+
			'"Header_attribute": ['+
			'{'+
			'"OCR_HDS_ATTRIBUTE_LABEL": "Code Fournisseur",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'},'+
			'"Line_items": ['+
			'{'+
			'"OCR_CUSTOMER_DOCUMENT_LINE_ITEM": "10",'+
			'"OCR_CUSTOMER_PRODUCT_CODE": "921251",'+
			'"OCR_CUSTOMER_PRODUCT_DESCRIPTION": " SWAP ZTD CPX FDL AVEC ANTENNE NETTNT ",'+
			'"OCR_ITEM_PRICE_UNIT": "19153",'+
			'"OCR_ITEM_QUANTITY": "1",'+
			'"OCR_ITEM_TOTAL_VALUE": "19153",'+
			'"OCR_ITEM_UNIT_OF_MEASURE": "PCE",'+
			'"OCR_REQUESTED_DELIVERY_DATE": "25-10-2019",'+
			'"Result": "TRUE",'+
			'"Line_item_attribute": ['+
			'{'+
			'"OCR_ITS_ATTRIBUTE_LABEL": "Site",'+
			'"OCR_ITS_ATTRIBUTE_VALUE": " 930342 AUBERVILLIERS(LILAS)",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'}'+
			']'+
			'}';
		test.startTest();
		DS_Staging__c dsStagingSO = new DS_Staging__c();
		dsStagingSO.DS_Payload__c = payload1;
		dsStagingSO.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO;		
		test.stopTest();
	}
	 @isTest
	public static void testCancelValidation() {
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case LIMIT 1];
		String payload1 = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "Purchase Order",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "Change",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "Standard",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "4500055128223122",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_INFO": "Customer Account",'+
			'"OCR_CUSTOMER_INVOICING_ADDRESS_NAME": "Customer Account",'+
			'"OCR_CUSTOMER_NAME": "Customer Account Dummy",'+
			'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
			'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
			'"OCR_INCO_TERM_INFO": "FH . Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_INFO": "Legal Account",'+
			'"OCR_NOKIA_LEGAL_ENTITY_NAME": "Legal Account Dummy",'+
			'"OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE": "91620",'+
			'"OCR_NOKIA_REFERENCE": "Selon CONTRAT D EXECUTION ACCES RADIO FOURNITURE ET MAINTENANCE n°2009 00998 2009 2012 et ses avenants",'+
			'"OCR_PAYMENT_TERM_INFO": "60 Jours nets Dummy",'+
			'"OCR_TOTAL_VALUE": "911277",'+
			'"PEGA_CASE_CREATED_BY": "2020-09-01",'+
			'"PEGA_CASE_ID": "P00102032",'+
			'"PEGA_OMC_MANAGER_EMAIL": "OMC.Manager@Nokia.com",'+
			'"SF_CASE_CREATED_BY": "2020-09-01",'+
			'"SF_CASE_ID": "'+caseRetrieved.CaseNumber+'",'+
			'"SF_CASE_WEB_MAIL": "SFR.procurement@SFR.COM",'+
			'"PDF_File_Reference_c": "00P0r000000vS0EEAU",'+
			'"Header_attribute": ['+
			'{'+
			'"OCR_HDS_ATTRIBUTE_LABEL": "Code Fournisseur",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'},'+
			'"Line_items": ['+
			'{'+
			'"OCR_CUSTOMER_DOCUMENT_LINE_ITEM": "10",'+
			'"OCR_CUSTOMER_PRODUCT_CODE": "921251",'+
			'"OCR_CUSTOMER_PRODUCT_DESCRIPTION": " SWAP ZTD CPX FDL AVEC ANTENNE NETTNT ",'+
			'"OCR_ITEM_PRICE_UNIT": "19153",'+
			'"OCR_ITEM_QUANTITY": "1",'+
			'"OCR_ITEM_TOTAL_VALUE": "19153",'+
			'"OCR_ITEM_UNIT_OF_MEASURE": "PCE",'+
			'"OCR_REQUESTED_DELIVERY_DATE": "25-10-2019",'+
			'"Result": "TRUE",'+
			'"Line_item_attribute": ['+
			'{'+
			'"OCR_ITS_ATTRIBUTE_LABEL": "Site",'+
			'"OCR_ITS_ATTRIBUTE_VALUE": " 930342 AUBERVILLIERS(LILAS)",'+
			'"pxObjClass": "NSN-FW-MOOFW-Int-IQBotRes"'+
			'}'+
			']'+
			'}'+
			']'+
			'}';
		test.startTest();
		DS_Staging__c dsStagingSO = new DS_Staging__c();
		dsStagingSO.DS_Payload__c = payload1;
		dsStagingSO.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO;		
		test.stopTest();
	}
}