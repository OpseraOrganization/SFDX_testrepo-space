@IsTest
private class CPO_OrderEnrichmentLineItemCreationTest {	
	@TestSetup
	static void setupCD(){
	
		Account parentAccount = TestDataFactory.createAccount(1)[0];
		parentAccount.AccountNumber='101234567';
		parentAccount.Acc_No__c = '101234567';
		parentAccount.Name = 'Parent Account';
		parentAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert parentAccount;  
		
		Account soldtopartyAcc = TestDataFactory.createAccount(1)[0];
		soldtopartyAcc.ParentId=parentAccount.id;
		database.insert(soldtopartyAcc);
		
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
		
		// create product
		Product2 product1 = new Product2();
		product1.CurrencyIsoCode = 'USD';
		product1.ProductCode = 'Bundle 1S 4 ABIA';
		product1.Name = 'My SFR Cutlery';
		product1.Description = 'Test Detailed Product Description';
		product1.IsActive=True;
		product1.Apttus_Config2__ConfigurationType__c = 'Bundle';
		product1.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
		insert product1;
		
		//Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		//creating user
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
	   //Opportunity oppty;
		insert userCreation;
		Test.startTest();
		system.runAs(userCreation){
			//oppty = TestDataFactory.OpportunityCreation(1,soldtopartyAcc)[0];
			//oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			//oppty.RecordTypeId=RecordTypeId;
			//oppty.Lead_BG__c ='MN';
			//oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			//database.insert(oppty);
			
			Customer_Document__c cd = QTO_TestDataFactory.createCustomerDocument();
			cd.Status__c = 'Draft';
			cd.Customer_Document_ID__c = '12435678';
			cd.Classification__c = 'Purchase Order';
			cd.Sub_Classification__c = 'Standard';
			cd.Nokia_Legal_Entity_Account__c = soldtopartyAcc.Id;
			cd.Customer__c = soldtopartyAcc.Id;
			insert cd;
			
			cd.QTO_Classification__c = 'Purchase Order';
			cd.QTO_Sub_Classification__c = 'Standard';
			cd.Classification__c = 'Purchase Order';
			cd.Sub_Classification__c = 'Standard';
			cd.Status__c =  QTO_Constants.STATUS_ENRICHED;
			update cd;
			
			// need customer document line items for this customer document
			Customer_Document_Line_Items__c customerDocumentLineItem = QTO_TestDataFactory.createCustomerDocumentLineItem(cd);
			insert customerDocumentLineItem;
			
			//Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
						
			//Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('SWx/CCRE Proposal').getRecordTypeId();
			
			List<Account> accList = QTO_TestDataFactory.createAccount(2);
			insert accList; 
			
			List<Account> accList1 = QTO_TestDataFactory.createAccount(1);
			accList1[0].Name='Dummy Acc';
			insert accList1;
			
			
			
			Opportunity op = QTO_TestDataFactory.OpportunityCreation(accList[0]);
			insert op;
		   
			
			
			
			
			/*
			Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
			quoteProposal2.Apttus_Proposal__Opportunity__c = op.id; 
			quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
			quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
			quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
			//quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
			quoteProposal2.Prices_Aligned__c=true;
			quoteProposal2.Apttus_Proposal__Account__c=soldtopartyAcc.id;
			quoteProposal2.Apttus_QPConfig__PONumber__c='12345';
			quoteProposal2.Apttus_QPConfig__PODate__c=System.today();
			quoteProposal2.Nokia_Customer_Document_ID__c=cd.Id;
			database.insert(quoteProposal2); 
			quoteProposal2.Apttus_Proposal__Approval_Stage__c='Accepted';
			update quoteProposal2;
*/
			// create price list
			Apttus_Config2__PriceList__c priceList = QTO_TestDataFactory.priceList();
			insert priceList;
			
			// create price list item
			Apttus_Config2__PriceListItem__c priceListItem = QTO_TestDataFactory.createPriceListItem(priceList);
			insert priceListItem;
			
			
			 
			Apttus__APTS_Agreement__c agr = QTO_TestDataFactory.createAgreement(accList[0], op, accList[1]);
			agr.Apttus__Status_Category__c = 'In Effect';
			agr.Apttus__Status__c = 'Activated';
			agr.CurrencyIsoCode = 'EUR';
			agr.Apttus__Contract_End_Date__c = System.today()+10;
			insert agr; 
			
			
			
			
			
			
			
			
			List<Apttus_Proposal__Proposal__c> quotes = QTO_TestDataFactory.createProposal(1,op.id); 
			quotes[0].Sold_To_Party__c=accList[0].Id;
			quotes[0].Apttus_Proposal__Account__c=accList[0].Id;
			quotes[0].Price_List__c=priceList.Id;
			quotes[0].Agreement_Lookup__c=agr.Id;
			quotes[0].Apttus_Proposal__Opportunity__c=op.Id;
			insert quotes;
			
			
			
			
			
			
			
			
			// create proposal line items
			Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].Id, priceListItem);
			proposalLineItem.Apttus_QPConfig__LineType__c = 'Option';
			insert proposalLineItem;
			
			// create customer document quote lines
			QTO_Customer_Document_Quote_Line__c customerDocumentQuoteLine = new QTO_Customer_Document_Quote_Line__c();
			customerDocumentQuoteLine.QTO_Customer_Document_Line_Items__c = customerDocumentLineItem.Id;
			customerDocumentQuoteLine.QTO_Proposal_Line_Item__c = proposalLineItem.Id;
			insert customerDocumentQuoteLine;
			
			// Case caseSO = new Case();
			// caseSO.Account = accountsNew[0];
			// caseSO.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Quote_to_Order_CPO_Case').getRecordTypeId();
			// caseSO.Subject = 'Test';
			// caseSO.Status = 'Exception';
			// caseSO.Description = 'Test';
			// caseSO.of_Employees_to_represent_Nokia_CP__c = '0-10%';
			// insert caseSO;			
			// Case caseRetrieved = [SELECT Id, CaseNumber FROM Case WHERE Id =: caseSO.Id];
			
			// create payment term
			Apttus_Config2__PaymentTerm__c paymentTermSO = new Apttus_Config2__PaymentTerm__c();
			paymentTermSO.Apttus_Config2__Label__c = 'Net 60 Days';
			paymentTermSO.Apttus_Config2__Sequence__c = 1;
			insert paymentTermSO;
			
			
					 
			
			
			
			// create agreement
			/*
			Apttus__APTS_Agreement__c agr = new Apttus__APTS_Agreement__c();
			agr.Apttus__Status_Category__c = QTO_Constants.IN_EFFECT;
			agr.name = 'Test';
			agr.Apttus__Account__c = '0010r00000gxhKsAAI';
			agr.Agreement_External_Contract_Number__c = '1234';
			agr.End_Customer__c = '0010r00000gxhKsAAI'; 
			agr.Nokia_Legal_Entity_lookup__c = '0010r00000UpAIjAAN';
			agr.Apttus__Related_Opportunity__c = '0060r000005mn69AAA';
			agr.Lead_BG__c = 'MN';
			agr.Sales_Mode__c = 'Direct Export';
			agr.CLM_Product_Categories__c = 'Others';
			agr.Apttus__Contract_End_Date__c = System.today()+10;
			insert agr;
			*/
			// create agreement line item
			Apttus__AgreementLineItem__c agreementLineItem = new Apttus__AgreementLineItem__c();
			agreementLineItem.Apttus__AgreementId__c = agr.Id;
			agreementLineItem.Apttus__Description__c = 'My SFR Cutlery desc';
			agreementLineItem.Contract_Item_Number__c = 'My SFR Cutlery';
			agreementLineItem.CLM_CFE_Reference__c = 'My SFR Cutlery';
			agreementLineItem.Apttus__ProductId__c = product1.Id;
			agreementLineItem.Apttus__Quantity__c = 10;
			insert agreementLineItem;
			
			// create customer document agreement line
			QTO_Customer_Document_Agreement_Line__c customerDocumentAgreementLine = new QTO_Customer_Document_Agreement_Line__c();
			customerDocumentAgreementLine.QTO_Customer_Document_Line_Items__c = customerDocumentLineItem.Id;
			customerDocumentAgreementLine.QTO_Agreement_Line_Item__c = agreementLineItem.Id;
			insert customerDocumentAgreementLine;
			
			// create customer facing attribute
			Customer_facing_Attribute__c customerFacingAttribute = QTO_TestDataFactory.createCFA(quotes[0].Id, proposalLineItem.Id);
			customerFacingAttribute.QTO_Customer_Document__c = cd.Id;
			customerFacingAttribute.QTO_Customer_Document_Line_Items__c = customerDocumentLineItem.Id;
			insert customerFacingAttribute;
			
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
			/*String payload = '{'+
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
			*/
			/* 
			Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
			agreement.Name= 'test Agreement';
			agreement.Apttus__Account__c = soldtopartyAcc.id;
			agreement.CurrencyIsoCode = 'EUR';
			insert agreement;

			Apttus_Config2__CustomerPurchaseOrder__c cpoRecord = new Apttus_Config2__CustomerPurchaseOrder__c();
			cpoRecord.Sold_to_party__c = soldtopartyAcc.id;
			cpoRecord.Opportunity__c =oppty.id;
			cpoRecord.Contract_start_date__c = system.today();
			cpoRecord.Contract_end_date__c=system.today()+365;
			cpoRecord.Terms__c = 12;
			cpoRecord.WBS__c='Test_WBS';
			cpoRecord.Legacy_CPO__c=true;
			cpoRecord.Apttus_QPConfig__ProposalId__c =quoteProposal2.id;
			cpoRecord.Apttus_Config2__Status__c = 'Ready for Enrichment';
			
			Apttus_Config2__CustomerPurchaseOrder__c cpoRecord1 = new Apttus_Config2__CustomerPurchaseOrder__c();
			cpoRecord1.Sold_to_party__c = soldtopartyAcc.id;
			cpoRecord1.Payer__c = soldtopartyAcc.id;
			cpoRecord.Contract_start_date__c = system.today();
			cpoRecord.Contract_end_date__c=system.today()+365;
			cpoRecord.Terms__c = 12;
			cpoRecord.WBS__c='Test_WBS';
			cpoRecord1.Apttus_Config2__BillToAccountId__c = soldtopartyAcc.id;
			cpoRecord1.Apttus_Config2__ShipToAccountId__c = soldtopartyAcc.id;
			cpoRecord1.Sales_Org__c = 'Test';
			cpoRecord1.Sales_Office__c = 'Test';
			cpoRecord1.Sales_Group__c = 'Test';
			cpoRecord1.Distribution_Channel__c = 'Test';
			cpoRecord1.Division__c = 'Test';
			cpoRecord1.Apttus_QPConfig__ProposalId__c = quoteProposal2.id;
			//cpoRecord1.Grand_Total__c = 230;
			cpoRecord1.CurrencyIsoCode ='EUR';
			//cpoRecord1.Apttus_CMConfig__AgreementId__c = agreement.Id;
			cpoRecord1.PO_number__c = '12564';
			cpoRecord1.Apttus_Config2__PODate__c =system.today();
			cpoRecord1.Comments__c = 'test';
			cpoRecord1.Contract_Type_Name__c ='Contract';
			cpoRecord1.Business_category__c = '2G';
			cpoRecord1.Reporting__c ='Excl contr from OBL';
			cpoRecord1.Master_contract__c = 'NA';
			cpoRecord1.ERP__c = 'P20';
			cpoRecord1.Legacy_CPO__c=true;		
			cpoRecord1.Opportunity__c =oppty.id;
			database.insert(new List<Apttus_Config2__CustomerPurchaseOrder__c>{cpoRecord,cpoRecord1});*/
		}
		Test.stopTest();
	}
	
	@IsTest
	static void testCreateLineItemsPoisitve(){
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
		
		cd.Status__c = 'Enriched(Lines)';
		update cd;
		
		cd.Status__c= QTO_Constants.CD_STATUS_LEGACY; // QTO_Constants.CD_STATUS_LINES_HANDOFF;
		cd.QTO_Nokia_Legal_Entity_Account__c='ALCATEL-LUCENT INTERNATIONAL';
		cd.QTO_Nokia_Legal_Entity_Postal_Code__c=null;
		update cd;
		
		List<String> cpoFieldList = getAllObjectFields('Apttus_Config2__CustomerPurchaseOrder__c');
		String queryString = 'SELECT ' + String.join(cpoFieldList, ',') + ' FROM Apttus_Config2__CustomerPurchaseOrder__c LIMIT 2';
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpo = Database.query(queryString);
		System.assertNotEquals(true, cpo.isEmpty(), 'Expected purchase orders list not to be empty');
		System.assertNotEquals(true, cpo.get(0).Nokia_Customer_Document_ID__c == null, 'Expected a customer document id in the field');
		
		Test.startTest();
		CPO_OrderEnrichmentLineItemCreation.createLineItems(cpo);
		Test.stopTest();
		// System.assertNotEquals(
		//	0,
		//	[SELECT COUNT() FROM Apttus_Config2__CustomerPOItem__c WHERE Apttus_Config2__PurchaseOrderId__c = :cpo],
		//	'Expected at least one purchase order item to be created'
		// );
	}
	
	private static List<String> getAllObjectFields(String type) {
		List<String> allFields = new List<String>();
		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.SObjectType leadSchema = schemaMap.get(type);
		Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
		
		for (String fieldName: fieldMap.keySet()) {
			allFields.add(fieldName);
		}
		
		return allFields;
	}
}