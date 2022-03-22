/**********************************************************************
* Class name : QTO_CustomerDocumentTriggerTest
* Test Class for : QTO_CustomerDocument_Helper, CustomerDocumentTrigger
* Created Date: 7 Jan 2021
* Created By : Neeharika Upadrasta , Nokia
***********************************************************************/
@isTest
public class QTO_CustomerDocumentTriggerTest {
	
	@testsetup
	public static void setupCD(){
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
		accLegalEntity.Name = 'ALCATEL-LUCENT INTERNATIONAL';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accLegalEntity.ParentId = parentAccount.Id;
		accLegalEntity.Active__c = true;
		accLegalEntity.Type='Internal Customer';
		accLegalEntity.BillingPostalCode = '92661';
		accountsNew.add(accLegalEntity);
		
		Account accLegalEntity1 = TestDataFactory.createAccount(1)[0];
		accLegalEntity1.AccountNumber='101234580';
		accLegalEntity1.Acc_No__c = '101234580';
		accLegalEntity1.Name = 'Legal Account';
		accLegalEntity1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accLegalEntity1.ParentId = parentAccount.Id;
		accLegalEntity1.Active__c = true;
		accLegalEntity1.BillingPostalCode = '92661';
		accountsNew.add(accLegalEntity1);
		insert accountsNew;
		
		Mandatory_fields_for_Customer_Document__c mandFields = new Mandatory_fields_for_Customer_Document__c();
		mandFields.Object__c = 'Customer_Document__c';
		mandFields.Status__c = QTO_Constants.CUSTOMER_DOCUMENT_REGISTRATION_STATUS;
		mandFields.Classification__c = QTO_Constants.CLASS_STANDARDPO;
		mandFields.Sub_Classification__c = QTO_Constants.SUB_CLASS_LEGACY;
		mandFields.Name = 'CDFields_Agmt';
		mandFields.Mandatory_Fields__c = 'Customer_Document_ID__c';
		insert mandFields;
		
		Case caseSO = new Case();
		caseSO.Account = accountsNew[0];
		caseSO.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Quote_to_Order_CPO_Case').getRecordTypeId();
		caseSO.Subject = 'Test';
		caseSO.Status = 'Exception';
		caseSO.Description = 'Test';
		caseSO.of_Employees_to_represent_Nokia_CP__c = '0-10%';
		insert caseSO;
		
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case WHERE Id =: caseSO.Id];
		
		Apttus_Config2__PaymentTerm__c paymentTermSO = new Apttus_Config2__PaymentTerm__c();
		paymentTermSO.Apttus_Config2__Label__c = 'Net 60 Days';
		paymentTermSO.Apttus_Config2__Sequence__c = 1;
		insert paymentTermSO;
		
		Apttus__APTS_Agreement__c agr = QTO_TestDataFactory.createAgreement(parentAccount);
		agr.Apttus__Status_Category__c = QTO_Constants.IN_EFFECT;
		agr.Apttus__Contract_End_Date__c = Date.today();
		insert agr;
		
		QTO_CPO_Field_Mapping__c cpoFieldMap1 = new QTO_CPO_Field_Mapping__c(Type__c='Customer Name',
																			 PDF_Value__c='Pan Dacom Networking AG',
																			 Mapping__c='Customer Account');
		insert cpoFieldMap1;
		
		
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
		String payload = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "Purchase Order",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "Standard",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "450005512822",'+
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
		
		DS_Staging__c dsStagingSO = new DS_Staging__c();
		dsStagingSO.DS_Payload__c = payload;
		dsStagingSO.QTO_Received_From_PEGA__c = true;
		insert dsStagingSO;
		
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
	public static void test1ActiveAgmt(){
		test.startTest();
		Apttus__APTS_Agreement__c agmt = [Select Id from Apttus__APTS_Agreement__c limit 1];
		Customer_Document__c cd = [Select Id from Customer_Document__c LIMIT 1];	  
		if(agmt!=null){
			QTO_Customer_Document_Agreement__c objCD = new QTO_Customer_Document_Agreement__c();
			objCD.QTO_Agreement__c = agmt.Id;
			objCD.QTO_Customer_Document__c = cd.Id;
			objCD.QTO_Source__c = QTO_Constants.MANUAL;
			insert objCD;
		}		
		
		cd.Status__c = QTO_Constants.ASSOCIATED;
		update cd;
		
		cd.INCO_Terms__c = 'EXW (Ex Works)';
		cd.Status__c = QTO_Constants.ASSOCIATED;
		
		update cd;
		
		cd.Status__c=QTO_Constants.CD_STATUS_LINES_HANDOFF;
		cd.QTO_Nokia_Legal_Entity_Account__c='ALCATEL-LUCENT INTERNATIONAL';
		cd.QTO_Nokia_Legal_Entity_Postal_Code__c=null;
		update cd;
		
		Map<String,Account> mapofLE=QTO_CustomerDocument_Helper.getNokiaLegalEntity(cd);

		test.stopTest();
	}
	
	@isTest
	public static void test1InActiveAgmt(){
		test.startTest();
		Apttus__APTS_Agreement__c agmt = [Select Id from Apttus__APTS_Agreement__c limit 1];
		Customer_Document__c cd = [Select Id from Customer_Document__c LIMIT 1];
		
		if(agmt!=null){
			agmt.Apttus__Status_Category__c = 'Request';
			agmt.SW_business_type__c = QTO_Constants.AGMT_BUSTYPE_SWM;
			update agmt;
			
			QTO_Customer_Document_Agreement__c objCD = new QTO_Customer_Document_Agreement__c();
			objCD.QTO_Agreement__c = agmt.Id;
			objCD.QTO_Customer_Document__c = cd.Id;
			objCD.QTO_Source__c = QTO_Constants.MANUAL;
			insert objCD;
			
			QTO_Customer_Document_Agreement__c objCD1 = new QTO_Customer_Document_Agreement__c();
			objCD1.QTO_Agreement__c = agmt.Id;
			objCD1.QTO_Customer_Document__c = cd.Id;
			objCD1.QTO_Source__c = QTO_Constants.MANUAL;
			objCD1.QTO_Used__c=true;
			insert objCD1;
		}		
		cd.Status__c = QTO_Constants.ASSOCIATED;
		cd.Payment_terms__c = null;
		cd.QTO_PDF_Place_of_Delivery_Shipment__c = null;
		cd.INCO_Terms__c = null;
		cd.CurrencyIsoCode = null;
		cd.QTO_Nokia_Legal_Entity_Account__c='ALCATEL-LUCENT INTERNATIONAL';
		cd.QTO_Nokia_Legal_Entity_Postal_Code__c='92661';
		update cd;
		
	   Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CCRE_Proposal').getRecordTypeId();
	   Account acc=[SELECT Id from Account LIMIT 1];
		Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		//quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
		//quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
		//quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal2.Prices_Aligned__c=true;
		quoteProposal2.Apttus_Proposal__Account__c=acc.id;
		database.insert(quoteProposal2); 
		quoteProposal2.LOA_Status__c='G4 Submission';
		quoteProposal2.Apttus_Proposal__Approval_Stage__c='In Review';
		quoteProposal2.Contract_Start_Date__c = system.today();	  
		update quoteProposal2;
		quoteProposal2.Apttus_Proposal__Approval_Stage__c='Approved';
		quoteProposal2.LOA_Status__c='Approved';
		update quoteProposal2;  

		Customer_Document_Junction__c cdJunc=new Customer_Document_Junction__c();
		cdJunc.Customer_Document__c=cd.Id;
		cdJunc.Quote_Proposal__c=quoteProposal2.Id;
		insert cdJunc;
		
		Map<Id, Customer_Document__c> cdMap=new Map<Id,Customer_Document__c>();
		cdMap.put(cd.Id,cd);
		Map<Id, List<Customer_Document_Junction__c>> allCustomerQuotesWithCds=QTO_CustomerDocument_Helper.allCustomerQuotesWithCds(cdMap);
		
		Map<String,Account> mapofLE=QTO_CustomerDocument_Helper.getNokiaLegalEntity(cd);

		test.stopTest();
	}
	
	@isTest
	public static void testMandatoryFields(){
		test.startTest();
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
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.JAN.2020",'+
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
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.JAN.2020",'+
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
		
		test.stopTest();
	}
	@isTest
	public static void testUnsetSubclassification() {
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case LIMIT 1];
		String payload1 = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "Purchase Order",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "Create",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.JAN.2020",'+
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
		
		test.stopTest();
	}
	@isTest
	public static void testPORiskOrder() {
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case LIMIT 1];
		String payload1 = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "In-House Order",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "Create",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "Risk-Order",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.JAN.2020",'+
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
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.JAN.2020",'+
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
	@isTest
	public static void testCustomerValidation() {
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
	public static void testValidateAssociations(){
		test.startTest();
		Customer_Document__c cdSO = [Select Id from Customer_Document__c LIMIT 1]; 
		Map<Id,Customer_Document__c> associatedCDs = new Map<Id,Customer_Document__c>();
		associatedCDs.put(cdSO.Id,cdSO);
		QTO_CustomerDocument_Helper.validateAssociations(associatedCDs);
		//  update cd;
		test.stopTest();
	}
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
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "Cancel",'+
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
	@isTest
	public static void testPOModificationTerm() {
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
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.JAN.2020",'+
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
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "Cancel",'+
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
		//QTO_StagingToCustomerDocTranslation.checkDuplicate(null,null);
		test.stopTest();
	}
	@isTest
	public static void testNatureUnsetDuplicate() {
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
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.JAN.2020",'+
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
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "",'+
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
		//QTO_StagingToCustomerDocTranslation.checkDuplicate(null,null);
		test.stopTest();
	}
	@isTest
	public static void testNatureCreateDuplicate() {
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
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.JAN.2020",'+
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
	public static void testNatureChangeDuplicate() {
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
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.JAN.2020",'+
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
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "Change",'+
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
		//QTO_StagingToCustomerDocTranslation.checkDuplicate(null,null);
		test.stopTest();
	}
	@isTest
	public static void testNatureCancelDuplicate() {
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
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.JAN.2020",'+
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
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "Cancel",'+
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
		Set<Id> openCds = new Set<Id> ();
		
		
		Apttus_Config2__PaymentTerm__c paymentTermSO = [SELECT Id,Name FROM Apttus_Config2__PaymentTerm__c LIMIT 1];
		Account accLegalEntity = [SELECT Id,Name  FROM Account LIMIT 1];
		
		Customer_Document__c sobj = new Customer_Document__c(
			Status__c = 'Closed-validated',																		   
			Nokia_Document_Receipt_Date__c = Date.today(),										 
			isDuplicate__c = false,																			 
			Modification_term__c = 'None (empty)',															  
			Case__c = caseRetrieved.Id,																																					
			Matches_Quotes__c = 'No associated quote. Please associate relevant quotes asap.',				  
			QTO_Customer_Document_Date__c = '09.10.20',																							   
			QTO_PDF_Customer_Name__c = 'SFR',																   
			Customer__c = accLegalEntity.Id,																		  
			QTO_PDF_Total_Value__c = '287,38',																  
			Total_Value__c = 287.38,																			
			QTO_Currency__c = 'EUR',																			
			QTO_Payment_Terms__c = '60NE',																	  
			Payment_terms__c = paymentTermSO.Id,															
			QTO_INCO_Terms__c = 'Free house',																   
			INCO_Terms__c = 'DDP (Delivered Duty Paid)',														
			QTO_Nokia_Legal_Entity_Account__c = 'ALCATEL-LUCENT INTERNATIONAL',								 
			Nokia_Legal_Entity_Account__c = accLegalEntity.Id,														
			Nokia_Legal_entity__c = 'FR-ALI',																   
			QTO_Classification__c = 'Purchase Order',														   
			Classification__c = 'Purchase Order',															   
			QTO_Sub_Classification__c = 'TOTO',																 
			Sub_Classification__c = 'Standard',																 
			QTO_Nature__c = 'Create',																		   
			QTO_Customer_Contact_Commercial__c = 'RGUERRA / +33 (0) 1 87 26 81 63',							 
			QTO_Customer_Contact_Delivery__c = 'P. du PARC /',												  
			QTO_Nokia_Legal_Entity_Info__c = 'ALCATEL-LUCENT INTERNATIONAL. CENTRE DE VILLARCEAUX 91620 NOZAY', 
			QTO_Nokia_Legal_Entity_Postal_Code__c = '91620',													
			Customer_Invoicing_Address__c = 'SFR TSA 32662 91166 LONGJUMEAU CEDEX',							 
			Customer_Delivery_Address__c = 'Plusieurs adresses : voir données de poste',						
			QTO_Customer_Postal_Code__c = '75015'
			
		);
		insert sobj;
		QTO_CustomerDocument_Helper.getNokiaLegalEntity(sobj);
		List<Customer_Document__c> listCustomerDocsSO = new List<Customer_Document__c>(); 
		listCustomerDocsSO.add(sobj);
		QTO_CustomerDocument_Helper.afterUpdate(listCustomerDocsSO);
		QTO_CustomerDocument_Helper.updateOpenToClosed(openCds);
		test.stopTest();
	}
	@isTest
	public static void testUnsetClassificationSubClassification() {
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case LIMIT 1];
		String payload1 = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "",'+
			'"OCR_CUSTOMER_DOCUMENT_DATE": "23.01.2020",'+
			'"OCR_CUSTOMER_DOCUMENT_ID": "4500055128223122",'+
			
			'"OCR_CUSTOMER_NAME": "Customer Account Dummy",'+
			'"OCR_CUSTOMER_POSTAL_CODE": "92661",'+
			'"OCR_CUSTOMER_REFERENCE": "R-19-146-M-1-HUS",'+
			'"OCR_INCO_TERM_INFO": "FH . Dummy",'+
			
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
	public static void testInHouseEngineeringOrder() {
		Case caseRetrieved = [SELECT Id, CaseNumber FROM Case LIMIT 1];
		String payload1 = '{'+
			'"Header": {'+
			'"OCR_CURRENCY_INFO": "EUR",'+
			'"OCR_CUSTOMER_CONTACT_COMMERCIAL": "GAËLLE CATTIEUW/+33 (0) 1 87 26 21 28",'+
			'"OCR_CUSTOMER_CONTACT_DELIVERY": "Laurent MAHERAULT",'+
			'"OCR_CUSTOMER_DELIVERY_ADDRESS_INFO": "16 Rue Général A. de Boissieu 75015 PARIS France",'+
			'"OCR_CUSTOMER_DOCUMENT_CLASSIFICATION": "In-House Order",'+
			'"OCR_CUSTOMER_DOCUMENT_NATURE": "",'+
			'"OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION": "Engineering Order",'+
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
		
		
		QTO_CustomerDocument_Helper.getDocumentDate('2020-09-01');
		QTO_CustomerDocument_Helper.getDocumentDate('23.JAN.2020');
		QTO_CustomerDocument_Helper.getDocumentDate('23.FEB.2020');
		QTO_CustomerDocument_Helper.getDocumentDate('23.MAR.2020');
		QTO_CustomerDocument_Helper.getDocumentDate('23.APR.2020');
		QTO_CustomerDocument_Helper.getDocumentDate('23.MAY.2020');
		QTO_CustomerDocument_Helper.getDocumentDate('23.JUN.2020');
		QTO_CustomerDocument_Helper.getDocumentDate('23.JUL.2020');
		QTO_CustomerDocument_Helper.getDocumentDate('23.AUG.2020');
		QTO_CustomerDocument_Helper.getDocumentDate('23.SEP.2020');
		QTO_CustomerDocument_Helper.getDocumentDate('23.OCT.2020');
		QTO_CustomerDocument_Helper.getDocumentDate('23.NOV.2020');
		QTO_CustomerDocument_Helper.getDocumentDate('23.DEC.2020');
		QTO_CustomerDocument_Helper.getDocumentDate('---');
		QTO_CustomerDocument_Helper.getDocumentDate(null);
		QTO_CustomerDocument_Helper.getDocumentDate('23_DEC_2020');
		QTO_CustomerDocument_Helper.getDocumentDate('23 DEC 2020');
		QTO_CustomerDocument_Helper.formatCurrency('22 66');
		QTO_CustomerDocument_Helper.formatCurrency(null);
		QTO_CustomerDocument_Helper.createIssueLog(null, null,'','','');
	  
		test.stopTest();
	}
	
	@IsTest
	static void testAfterUpdateWithStatusClosedConsumed() {
		List<Customer_Document__c> customerDocuments = new List<Customer_Document__c>();
		Customer_Document__c customerDocument_1 = QTO_TestDataFactory.createCustomerDocument();
		customerDocument_1.Status__c = QTO_Constants.CLOSED_CONSUMED;
		customerDocuments.add(customerDocument_1);
		Customer_Document__c customerDocument_2 = QTO_TestDataFactory.createCustomerDocument();
		customerDocument_2.Status__c = QTO_Constants.CLOSED_REJECTED;
		customerDocuments.add(customerDocument_2);
		QTO_CustomerDocument_Helper.afterUpdate(customerDocuments);
	}
	
	@IsTest
	static void testCreateCPO() {
		Customer_Document__c customerDocument = QTO_TestDataFactory.createCustomerDocument();
		customerDocument.Status__c = 'Enriched(Lines)';
		insert customerDocument;
		Map<Id, Customer_Document__c> oldMap = 
			new Map<Id, Customer_Document__c>{
				customerDocument.Id => customerDocument.clone(false,false,false,false)
			};
		customerDocument.Status__c = QTO_Constants.CD_STATUS_LEGACY;
		Map<Id, Customer_Document__c> newMap = new Map<Id, Customer_Document__c>{customerDocument.Id => customerDocument};
		//QTO_CustomerDocument_Helper.createCPO(newMap,oldMap);
	}  
	
	@IsTest
	static void testBeforeUpdateWithChangeAndCancellationAllowedModificationTerm() {
		List<Customer_Document__c> customerDocuments = new List<Customer_Document__c>();
		Customer_Document__c customerDocument_1 = QTO_TestDataFactory.createCustomerDocument();
		customerDocument_1.Modification_term__c = QTO_Constants.CHANGE_ALLOWED;
		customerDocuments.add(customerDocument_1);
		Customer_Document__c customerDocument_2 = QTO_TestDataFactory.createCustomerDocument();
		customerDocument_2.Modification_term__c = QTO_Constants.CANCELLATION_ALLOWED;
		customerDocuments.add(customerDocument_2);
		insert customerDocuments;
		Map<Id, Customer_Document__c> customerDocumentsById = new Map<Id, Customer_Document__c>(customerDocuments); 
		QTO_CustomerDocument_Helper.beforeUpdate(customerDocuments,customerDocumentsById);
	}
	
	@IsTest
	static void testCheckIsUsedWithCustomerDocumentAssociations() {
		Customer_Document__c customerDocument = QTO_TestDataFactory.createCustomerDocument();
		List<QTO_Customer_Document_Agreement__c> customerDocumentAgreements = new List<QTO_Customer_Document_Agreement__c>();
		customerDocumentAgreements.add(new QTO_Customer_Document_Agreement__c(QTO_Used__c=true));
		customerDocumentAgreements.add(new QTO_Customer_Document_Agreement__c(QTO_Used__c=true));
		// QTO_CustomerDocument_Helper.checkIsUsed(customerDocument,customerDocumentAgreements,'Some error',new List<QTO_Customer_Document_Agreement__c>());
		// System.FinalException: Cannot modify a collection while it is being iterated.
	}
	
	@IsTest
	static void testIsAgreementMatchedAllElseScenario() {
		Account account = QTO_TestDataFactory.createAccount(1).get(0);
		insert account;
		Apttus_Config2__PaymentTerm__c paymentTerm = new Apttus_Config2__PaymentTerm__c();
		paymentTerm.Apttus_Config2__Label__c = 'Net 60 Days';
		paymentTerm.Apttus_Config2__Sequence__c = 1;
		insert paymentTerm;
		Customer_Document__c customerDocument = QTO_TestDataFactory.createCustomerDocument();
		QTO_Customer_Document_Agreement__c customerDocumentAgreement = new QTO_Customer_Document_Agreement__c(QTO_Used__c=true);
		customerDocument.Nokia_Legal_Entity_Account__c = account.Id;
		customerDocument.Payment_terms__c = paymentTerm.Id;
		customerDocument.CurrencyIsoCode = 'CAD';
		customerDocument.INCO_Terms__c = 'EXW (Ex Works)';
		customerDocument.QTO_PDF_Place_of_Delivery_Shipment__c = 'Canada';
		String result = QTO_CustomerDocument_Helper.isAgreementMatched(customerDocument, customerDocumentAgreement);
	}
	
	@IsTest
	static void testUpdateCDModificationTermWithCDAssociations() {
		Customer_Document__c existingCustomerDocument = [SELECT Id FROM Customer_Document__c LIMIT 1];
		Customer_Document__c customerDocument = QTO_TestDataFactory.createCustomerDocument();
		insert customerDocument;
		CD_Association_to_CD__c associatedCustomerDocument = new CD_Association_to_CD__c();
		associatedCustomerDocument.QTO_Nokia_Customer_Document_ID__c = existingCustomerDocument.Id;
		associatedCustomerDocument.Customer_Document__c = customerDocument.Id;
		insert associatedCustomerDocument;
		Apttus__APTS_Agreement__c agreement = [Select Id from Apttus__APTS_Agreement__c limit 1];
		agreement.Purchase_Order_Modification_Term__c = QTO_Constants.CHANGE_CONTRACTUAL_ALLOWED + ';' + QTO_Constants.CANCELLATION_CONTRACTUAL_ALLOWED;
		update agreement;
		QTO_Customer_Document_Agreement__c customerDocumentAgreement = new QTO_Customer_Document_Agreement__c();
		customerDocumentAgreement.QTO_Agreement__c = agreement.Id;
		customerDocumentAgreement.QTO_Customer_Document__c = existingCustomerDocument.Id;
		customerDocumentAgreement.QTO_Source__c = QTO_Constants.MANUAL;
		customerDocumentAgreement.QTO_Used__c = true;
		insert customerDocumentAgreement;
		QTO_CustomerDocument_Helper.updateCDModificationTerm(customerDocument, new List<CD_Association_to_CD__c>{associatedCustomerDocument});
	}
	
	@IsTest
	static void testGetAccountByNameAndAddressWithMultipleAccounts() {
		List<Account> accounts = QTO_TestDataFactory.createAccount(2);
		Account duplicateNamedAccount = QTO_TestDataFactory.createAccount(1).get(0);
		duplicateNamedAccount.Name=accounts.get(0).Name;
		accounts.add(duplicateNamedAccount);
		insert accounts;
		Customer_Document__c customerDocument = QTO_TestDataFactory.createCustomerDocument();
		customerDocument.QTO_PDF_Customer_Name__c = accounts.get(1).Name;
		customerDocument.QTO_Customer_Postal_Code__c = '';// accounts.get(1).BillingPostalCode;
		insert customerDocument;	  
		// insert new QTO_CPO_Field_Mapping__c(Type__c='Customer Name', PDF_Value__c=accounts.get(1).Name, Mapping__c=accounts.get(1).Name);
		// QTO_CustomerDocument_Helper.populateCustomSettings();
		QTO_CustomerDocument_Helper.getAccountByNameAndAddress(customerDocument, accounts);
	}
	
	@IsTest
	static void testGetAccountByNameAndAddressWithMultipleAccountsAndPostalCode() {
		List<Account> accounts = QTO_TestDataFactory.createAccount(2);
		insert accounts;
		Customer_Document__c customerDocument = QTO_TestDataFactory.createCustomerDocument();
		customerDocument.QTO_PDF_Customer_Name__c = accounts.get(1).Name+'test';
		customerDocument.QTO_Customer_Postal_Code__c = accounts.get(1).BillingPostalCode;
		insert customerDocument;	  
		// insert new QTO_CPO_Field_Mapping__c(Type__c='Customer Name', PDF_Value__c=accounts.get(1).Name, Mapping__c=accounts.get(1).Name);
		QTO_CPO_Field_Mapping__c fieldMapping = [SELECT Type__c,PDF_Value__c,Mapping__c FROM QTO_CPO_Field_Mapping__c WHERE Type__c = 'Customer Name' LIMIT 1];
		fieldMapping.PDF_Value__c = accounts.get(1).Name+'test';
		fieldMapping.Mapping__c = accounts.get(1).Name;
		update fieldMapping;
		QTO_CustomerDocument_Helper.populateCustomSettings();
		QTO_CustomerDocument_Helper.getAccountByNameAndAddress(customerDocument, accounts);
	}
	
	@IsTest
	static void testGetNokiaLegalEntity() {
		List<Account> accounts = QTO_TestDataFactory.createAccount(2);
		accounts.get(0).Type = 'Internal Customer';
		accounts.get(0).Active__c = true;
		Account duplicateNamedAccount = QTO_TestDataFactory.createAccount(1).get(0);
		duplicateNamedAccount.Name=accounts.get(0).Name;
		duplicateNamedAccount.Type = 'Internal Customer';
		duplicateNamedAccount.Active__c = true;
		accounts.add(duplicateNamedAccount);
		insert accounts;
		Customer_Document__c customerDocument = QTO_TestDataFactory.createCustomerDocument();
		customerDocument.QTO_Nokia_Legal_Entity_Account__c = accounts.get(0).Name;
		customerDocument.QTO_PDF_Customer_Name__c = accounts.get(0).Name;
		customerDocument.QTO_Nokia_Legal_Entity_Postal_Code__c = accounts.get(0).BillingPostalCode;
		insert customerDocument;	  
		QTO_CustomerDocument_Helper.getNokiaLegalEntity(customerDocument);
	}
	
	@IsTest
	static void testGetNokiaLegalEntityWithModifiedEntityName() {
		List<Account> accounts = QTO_TestDataFactory.createAccount(2);
		accounts.get(0).Type = 'Internal Customer';
		accounts.get(0).Active__c = true;
		insert accounts;
		Customer_Document__c customerDocument = QTO_TestDataFactory.createCustomerDocument();
		customerDocument.QTO_Nokia_Legal_Entity_Account__c = accounts.get(1).Name+'test';
		customerDocument.QTO_Nokia_Legal_Entity_Postal_Code__c = accounts.get(1).BillingPostalCode;
		insert customerDocument;	  
		QTO_CPO_Field_Mapping__c fieldMapping = [SELECT Type__c,PDF_Value__c,Mapping__c FROM QTO_CPO_Field_Mapping__c WHERE Type__c = 'Customer Name' LIMIT 1];
		fieldMapping.PDF_Value__c = accounts.get(1).Name+'test';
		fieldMapping.Mapping__c = accounts.get(1).Name;
		update fieldMapping;
		QTO_CustomerDocument_Helper.populateCustomSettings();
		QTO_CustomerDocument_Helper.getNokiaLegalEntity(customerDocument);
	}
}