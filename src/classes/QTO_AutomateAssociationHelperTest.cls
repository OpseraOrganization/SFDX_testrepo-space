/**
 * Created by Harsha Gobburi
 */ 
@isTest
public without sharing class QTO_AutomateAssociationHelperTest {
	@TestSetup
	static void createData() {
		 
		List<Account> accList = QTO_TestDataFactory.createAccount(2);
		insert accList; 
		
		List<Account> accList1 = QTO_TestDataFactory.createAccount(1);
		accList1[0].Name='Dummy Acc';
		insert accList1;
		
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
		
		Apttus_Config2__PriceList__c plist = QTO_TestDataFactory.priceList();
		plist.Name = 'SFR Price List for Cutlery';
		plist.Apttus_Config2__Description__c = 'SFR Price List for Cutlery';
		plist.Apttus_Config2__Active__c = true;
		plist.Apttus_Config2__AccountId__c = accList[0].Id;
		plist.PriceList_Type__c = 'DS';
		plist.Business_Group__c = 'GS';
		insert plist;
		
		Apttus_Config2__PriceListItem__c plistitem = QTO_TestDataFactory.createPriceListItem(plist);
		plistitem.Apttus_Config2__ProductId__c = productList[0].Id;
		plistitem.Apttus_Config2__ChargeType__c = 'Product Price';
		plistitem.Apttus_Config2__PriceType__c = 'One Time';
		plistitem.Apttus_Config2__PriceUom__c = 'Each';
		plistitem.Apttus_Config2__ContractPrice__c = 2500;
		plistitem.Apttus_Config2__ListPrice__c = 2555;
		plistitem.Apttus_Config2__ContractItemNumber__c = 'Bundle 1S 4 ABIA';
		insert plistitem;
		
		Opportunity op = QTO_TestDataFactory.OpportunityCreation(accList[0]);
		insert op;
		
		Apttus__APTS_Agreement__c agreement = QTO_TestDataFactory.createAgreement(accList[0], op, accList[1]);
		agreement.Apttus__Status_Category__c = 'In Effect';
		agreement.Apttus__Status__c = 'Activated';
		agreement.CurrencyIsoCode = 'EUR';
		agreement.Apttus__Contract_End_Date__c = System.today()+10;
		insert agreement; 
		
		Apttus__AgreementLineItem__c agLine0 = new Apttus__AgreementLineItem__c();
		agLine0.Apttus__AgreementId__c = agreement.Id;
		agLine0.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine0.CLM_CFE_Reference__c = 'My SFR Cutlery';
		agLine0.Apttus__ProductId__c = productList[0].Id;
		agLine0.Apttus__Quantity__c = 0;
		insert agLine0;
		
		List<Apttus_Proposal__Proposal__c> proposals = QTO_TestDataFactory.createProposal(1, op.Id);
		proposals.get(0).NokiaCPQ_Proposal_Id__c = '21.BE.1000005581 Q-00123515';
		proposals[0].Sold_To_Party__c=accList[0].Id;
		proposals[0].Apttus_Proposal__Account__c=accList[0].Id;
		proposals[0].Price_List__c=plist.Id;
		proposals[0].Agreement_Lookup__c=agreement.Id;
		proposals[0].Apttus_Proposal__Opportunity__c=op.Id;
		insert proposals;
		proposals = [SELECT Id, Name, NokiaCPQ_Proposal_Id__c FROM Apttus_Proposal__Proposal__c];
		System.assertNotEquals(null, proposals.get(0).NokiaCPQ_Proposal_Id__c);
		
		Apttus_Proposal__Proposal_Line_Item__c plineitem = QTO_TestDataFactory.proposalLineItemCreation(proposals.get(0).Id, plistitem);
		plineitem.Apttus_Proposal__Product__c = productList[0].Id;
		plineitem.Apttus_QPConfig__Quantity2__c = 100;
		plineitem.Apttus_Proposal__Quantity__c = 100;
		insert plineitem;
		
		Customer_Document__c cd = new Customer_Document__c(
			Customer__c = accList[0].Id,
			QTO_PDF_Customer_Name__c = accList[0].Name,	
			Status__c = 'Exception-Association',
			Customer_Document_ID__c = '124356',
			Customer_Document_Date__c = Date.today()
		);
		insert cd;
		
		Customer_Document_Line_Items__c cdline = QTO_TestDataFactory.createCustomerDocumentLineItem(cd);
		insert cdLine;
		
		QTO_Customer_Document_Quote_Line__c cdlineplineassociation = new QTO_Customer_Document_Quote_Line__c(
			QTO_Customer_Document_Line_Items__c = cdline.id,
			QTO_Proposal_Line_Item__c = plineitem.id
		);
		insert cdlineplineassociation;
		
		Customer_facing_Attribute__c cdcfA1 =new Customer_facing_Attribute__c(
			QTO_Customer_Document__c=cd.id, Attribute_Label__c='PDF CONTRACT REF', Attribute_Value__c='2013/01068');
		Customer_facing_Attribute__c cdcfA2 =new Customer_facing_Attribute__c(
			QTO_Customer_Document__c=cd.id, Attribute_Label__c='PDF Quote Ref', Attribute_Value__c='21.BE.1000005581 Q-00123515');
		Customer_facing_Attribute__c cdlinecfA1 =new Customer_facing_Attribute__c(
			QTO_Customer_Document__c=cd.id, Attribute_Label__c='Site Name', Attribute_Value__c='Site Name');
		Customer_facing_Attribute__c quotelinecfA1 =new Customer_facing_Attribute__c(
			Quote_Line_Item__c=plineitem.id, Attribute_Label__c='Site Code', Attribute_Value__c='Site Code');
		insert new List<Customer_facing_Attribute__c>{cdcfA1,cdcfA2,cdlinecfA1,quotelinecfA1};
	}
	
	@isTest
	static void testUpdateQuoteDetails() {
		test.startTest();
		Customer_Document__c cd = [SELECT Id, Customer_Document_Date__c, QTO_Customer_Account_Number__c FROM Customer_Document__c];
		List<Apttus_Proposal__Proposal__c> proposals = [SELECT Id FROM Apttus_Proposal__Proposal__c];
		for(Apttus_Proposal__Proposal__c resultProposal : QTO_AutomateAssociationHelper.updateQuoteDetails(new Set<Id>{ proposals.get(0).Id }, cd)) {
			System.assertEquals(QTO_Constants.ASSOCIATED, resultProposal.QTO_Association_Status__c, 'association status is not set');
		}
		test.stopTest();  
	}
	
	@isTest
	static void testUpdateUnassociatedCDLIs() {
		test.startTest();
		Customer_Document_Line_Items__c cdLine = [SELECT Id FROM Customer_Document_Line_Items__c];
		for(Customer_Document_Line_Items__c resultCdLine : QTO_AutomateAssociationHelper.updateUnassociatedCDLIs(new Set<Id>{ cdLine.Id })) {
			System.assertEquals(QTO_Constants.CD_STATUS_FAILED, resultCdLine.QTO_Association__c, 'association is not set');
		}
		test.stopTest();  
	}
	
	@isTest
	static void testRemoveAssociatedCDLIs() {
		test.startTest();
		List<Customer_Document_Line_Items__c> cdLines = [SELECT Id FROM Customer_Document_Line_Items__c];
		System.assertEquals(false, QTO_AutomateAssociationHelper.removeAssociatedCDLIs(cdLines, new Set<Id>()).isEmpty(), 'cdline is already associated');
		test.stopTest();  
	}
	
	@isTest
	static void testUpdateAssociatedCDLIs() {
		test.startTest();
		List<QTO_Customer_Document_Quote_Line__c> cdlineplineassociations = [SELECT Id, QTO_Customer_Document_Line_Items__c, QTO_Proposal_Line_Item__c FROM QTO_Customer_Document_Quote_Line__c];
		for(Customer_Document_Line_Items__c resultCdLine : QTO_AutomateAssociationHelper.updateAssociatedCDLIs(cdlineplineassociations).values()) {
			System.assertEquals(QTO_Constants.CD_STATUS_SUCESSFUL, resultCdLine.QTO_Association__c, 'association is not set');
		}
		test.stopTest();  
	}
	
	@isTest
	static void testFetchAccountFromCustomerDocument() {
		test.startTest();
		Customer_Document__c cd = [SELECT Id, Customer__c FROM Customer_Document__c];
		System.assertEquals(cd.Customer__c, QTO_AutomateAssociationHelper.fetchAccountFromCustomerDocument(cd.Id));
		test.stopTest();  
	}
	
	@isTest
	static void testUpdateCustomerDocumentStatus() {
		test.startTest();
		System.assertEquals('Draft with Exceptions', QTO_AutomateAssociationHelper.updateCustomerDocumentStatus(new Customer_Document__c(), 'Draft with Exceptions').Status__c);
		test.stopTest();  
	}
	
	@isTest
	static void testUpdateCustomerDocumentError() {
		test.startTest();
		Customer_Document__c cd = [SELECT Id, Customer__c FROM Customer_Document__c];
		Customer_Document__c result = QTO_AutomateAssociationHelper.updateCustomerDocumentError(
			cd, new List<QTO_Customer_Document_Issue_Log__c>{
					new QTO_Customer_Document_Issue_Log__c(QTO_CustomerDocumentId__c=cd.Id, QTO_ErrorType__c=QTO_Constants.ERROR, QTO_IssueDetails__c = 'Lookup of payment terms failed')
				}
		);
		System.assertEquals('Lookup of payment terms failed', result.QTO_Error_Message__c);
		result = QTO_AutomateAssociationHelper.updateCustomerDocumentError(cd, new List<QTO_Customer_Document_Issue_Log__c>());
		System.assertEquals('', result.QTO_Error_Message__c);
		test.stopTest();  
	}
	
	@isTest
	static void testAutoAssociateCustomerDocuments() {
		test.startTest();
		Account account = [SELECT Id FROM Account LIMIT 1];
		List<Customer_Document__c> cds = [SELECT Id, Customer__c FROM Customer_Document__c];
		cds.get(0).Customer__c = account.Id;
		update cds;
		QTO_AutomateAssociationHelper.autoAssociateCustomerDocuments(cds);
		test.stopTest();  
	}
	
	@isTest
	static void testFetchManualCDAs() {
		test.startTest();
		List<Customer_Document__c> cds = [SELECT Id, Customer__c FROM Customer_Document__c];
		QTO_AutomateAssociationHelper.fetchManualCDAs(new QTO_AssociationOutputWrapper(), cds.get(0).Id);
		test.stopTest();  
	}
	
	@isTest
	static void testFlowIfAgreementReferencesExistInCRM() {
		test.startTest();
		List<Customer_Document__c> cds = [SELECT Id, Customer__c FROM Customer_Document__c];
		QTO_AutomateAssociationHelper.flowIfAgreementReferencesExistInCRM(new QTO_AssociationOutputWrapper(), cds.get(0).Id);
		test.stopTest();  
	}
	
	@isTest
	static void testFlowIfNoReferencesExistInCRM() {  
		test.startTest();
		List<Customer_Document__c> cds = [SELECT Id, Customer__c FROM Customer_Document__c];
		QTO_AutomateAssociationHelper.flowIfNoReferencesExistInCRM(new QTO_AssociationOutputWrapper(), cds.get(0).Id);
		test.stopTest();  
	}
	@isTest
	static void checkRiskOrderTest() {
		test.startTest();
		List<Apttus_Proposal__Proposal__c> prop = [Select Id, Nokia_Customer_Document_ID__c from Apttus_Proposal__Proposal__c];
		QTO_AutomateAssociationHelper.checkRiskOrder(prop);		
		test.stopTest(); 
	}
	
	@isTest
	static void testGetPossibleAssociationOfAgreements() {
		Customer_Document__c cd = [SELECT Id, Customer__c FROM Customer_Document__c LIMIT 1];
		QTO_CDParsingWrapper parsingWrapper = new QTO_CDParsingWrapper();
		parsingWrapper.pdfSiteCodeRefs.add('Site Code');
		Test.startTest();
		QTO_AutomateAssociationHelper.getPossibleAssociationOfAgreements(parsingWrapper, cd.Customer__c, cd.Id);
		Test.stopTest();
	}
	
	@isTest
	static void testFetchAgreementsFromQuotes() {
		List<Apttus_Proposal__Proposal__c> proposals = [Select Id, Agreement_Lookup__c, Account_Legal_Entity__c, Name from Apttus_Proposal__Proposal__c];
		QTO_AssociationOutputWrapper wrapper = new QTO_AssociationOutputWrapper();
		wrapper.listMatchedQuotes.addAll(proposals);
		Test.startTest();
		QTO_AutomateAssociationHelper.fetchAgreementsFromQuotes(wrapper);
		Test.stopTest();
	}
}