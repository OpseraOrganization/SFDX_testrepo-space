/**************************************************************************
Class Name: QTOCustomerDocumentUtilTest
Created by: Shaik Johny Basha
Created Date: 14 June 2021
Last modified by: Shaik Johny Basha
Description: Test class for QTOCustomerDocumentUtil 
***************************************************************************/
@isTest
public class QTOCustomerDocumentUtilTest {

	@testsetup 
	static void setupData() { 
		
	}
	
	@isTest
	static void testQueries1(){
		
		List<Account> accList = QTO_TestDataFactory.createAccount(2);
		accList[0].Type = 'Internal Customer';
		insert accList; 
		
		List<Product2> prdList = new List<Product2>();
		Product2 product1 = new Product2();
		product1.CurrencyIsoCode = 'USD';
		product1.ProductCode = 'Bundle 1S 4 ABIA';
		product1.Name = 'My SFR Cutlery';
		product1.Description = 'Test Detailed Product Description';
		product1.IsActive=True;
		product1.Apttus_Config2__ConfigurationType__c = 'Bundle';
		product1.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
		prdList.add(product1);
		
		Product2 product2 = new Product2();
		product2.CurrencyIsoCode = 'USD';
		product2.ProductCode = 'Bundle1S4ABIA1';
		product2.Name = 'My SFR Cutlery1';
		product2.Description = 'Test Detailed Product Description1';
		product2.IsActive=True;
		product2.Apttus_Config2__ConfigurationType__c = 'Bundle';
		product2.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
		prdList.add(product2);
		
		Product2 product3 = new Product2();
		product3.CurrencyIsoCode = 'USD';
		product3.ProductCode = 'Bundle1S4ABIA1';
		product3.Name = 'My SFR Cutlery1';
		product3.Description = 'Test Detailed Product Description1';
		product3.IsActive=True;
		product3.Apttus_Config2__ConfigurationType__c = 'Bundle';
		product3.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
		prdList.add(product3);
		
		insert prdList;
		
		
		Apttus_Config2__PriceList__c priceList = QTO_TestDataFactory.priceList(); 
		priceList.Name = 'SFR Price List for Cutlery';
		priceList.Apttus_Config2__Description__c = 'SFR Price List for Cutlery';
		priceList.Apttus_Config2__Active__c = true;
		priceList.Apttus_Config2__AccountId__c = accList[0].Id;
		priceList.PriceList_Type__c = 'DS';
		priceList.Business_Group__c = 'GS';
		priceList.Apttus_Config2__ContractNumber__c = 'PPLN-00148';
		insert priceList;
		
		List<Apttus_Config2__PriceListItem__c> plist = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c priListItem = QTO_TestDataFactory.createPriceListItem(priceList); 
		priListItem.Apttus_Config2__PriceListId__c = priceList.Id;
		priListItem.Apttus_Config2__ProductId__c = prdList[0].Id;
		priListItem.Apttus_Config2__ChargeType__c = 'Product Price';
		priListItem.Apttus_Config2__PriceType__c = 'One Time';
		priListItem.Apttus_Config2__PriceUom__c = 'Each';
		priListItem.Apttus_Config2__ContractPrice__c = 2500;
		priListItem.Apttus_Config2__ListPrice__c = 2555;
		priListItem.Apttus_Config2__ContractItemNumber__c = 'My SFR Cutlery';
		
		plist.add(priListItem);
		
		Apttus_Config2__PriceListItem__c priListItem2 = QTO_TestDataFactory.createPriceListItem(priceList); 
		priListItem2.Apttus_Config2__PriceListId__c = priceList.Id;
		priListItem2.Apttus_Config2__ProductId__c = prdList[1].Id;
		priListItem2.Apttus_Config2__ChargeType__c = 'Product Price';
		priListItem2.Apttus_Config2__PriceType__c = 'One Time';
		priListItem2.Apttus_Config2__PriceUom__c = 'Each';
		priListItem2.Apttus_Config2__ContractPrice__c = 2500;
		priListItem2.Apttus_Config2__ListPrice__c = 2555;
		priListItem2.Apttus_Config2__ContractItemNumber__c = 'My SFR Cutlery';
		plist.add(priListItem2);
		
		insert plist;
		
		Opportunity opp = QTO_TestDataFactory.OpportunityCreation(accList[0]);
		insert opp;
		
		Apttus__APTS_Agreement__c agr = QTO_TestDataFactory.createAgreement(accList[0], opp, accList[1]);
		agr.Apttus__Status_Category__c = 'In Effect';
		agr.Apttus__Status__c = 'Activated';
		insert agr; 
		
		List<Apttus__AgreementLineItem__c> agList = new List<Apttus__AgreementLineItem__c>();
		Apttus__AgreementLineItem__c agLine1 = new Apttus__AgreementLineItem__c();
		agLine1.Apttus__AgreementId__c = agr.Id;
		agLine1.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine1.Contract_Item_Number__c = 'My SFR Cutlery';
		agLine1.CLM_CFE_Reference__c = 'My SFR Cutlery';
		agLine1.Apttus__ProductId__c = prdList[0].Id;
		agLine1.Apttus__Quantity__c = 10;
		
		Apttus__AgreementLineItem__c agLine2 = new Apttus__AgreementLineItem__c();
		agLine2.Apttus__AgreementId__c = agr.Id;
		agLine2.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine2.Contract_Item_Number__c = 'My SFR Cutlery';
		agLine1.CLM_CFE_Reference__c = 'My SFR Cutlery';
		agLine2.Apttus__ProductId__c = prdList[1].Id;
		agLine2.Apttus__Quantity__c = 15;
		
		agList.add(agLine1);
		agList.add(agLine2);
		
		insert agList;
		
		test.startTest();
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
		cd.Status__c =  'Ready for line item hand-off';
		update cd;
			   
		
		//Customer Document Line Item
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
		cdli1.QTO_Product_Name__c = prdList[0].Id;
		
		customerDocLines.add(cdli1);
		
		Customer_Document_Line_Items__c cdli2 = new Customer_Document_Line_Items__c();
		cdli2.High_level_Product__c = 'My SFR Cutlery';
		cdli2.High_level_Product_Description__c = 'My SFR Bundle Description';
		cdli2.Detailed_Product__c = 'Bundle 1S 4 ABIA';
		cdli2.Detailed_Product_Description__c = 'Test Detailed Product Description';
		cdli2.QTO_PDF_Quantity__c = '';
		cdli2.Quantity__c = '';
		cdli2.QTO_PDF_Unit_Of_Measure__c = '';
		cdli2.QTO_Unit_Of_Measure__c = '';
		cdli2.QTO_PDF_Unit_Price__c = '2222,00';
		cdli2.Total_Value__c = 50;
		cdli2.QTO_PDF_Currency_Code__c = 'EUR';
		cdli2.CurrencyIsoCode = 'EUR';
		cdli2.QTO_Unit_Price__c = 2222.00;
		cdli2.Customer_Document__c = cd.Id;
		cdli2.QTO_Product_Name__c = prdList[1].Id;
		customerDocLines.add(cdli2);
		
		Customer_Document_Line_Items__c cdli3 = new Customer_Document_Line_Items__c();
		cdli3.High_level_Product__c = 'My SFR Cutlery';
		cdli3.High_level_Product_Description__c = 'My SFR Bundle Description';
		cdli3.Detailed_Product__c = '';
		cdli3.Detailed_Product_Description__c = '';
		cdli3.QTO_PDF_Quantity__c = '1';
		cdli3.Quantity__c = '1';
		cdli3.QTO_PDF_Unit_Of_Measure__c = '1';
		cdli3.QTO_Unit_Of_Measure__c = '1';
		cdli3.QTO_PDF_Unit_Price__c = '2222,00';
		cdli3.Total_Value__c = 50;
		cdli3.QTO_PDF_Currency_Code__c = 'EUR';
		cdli3.CurrencyIsoCode = 'EUR';
		cdli3.QTO_Unit_Price__c = 2222.00;
		cdli3.Customer_Document__c = cd.Id;
		cdli3.QTO_Product_Name__c = prdList[1].Id;
		cdli3.Status__c = 'Enriched(Lines)';
		customerDocLines.add(cdli3);
		
		Customer_Document_Line_Items__c cdli4 = new Customer_Document_Line_Items__c();
		cdli4.High_level_Product__c = '';
		cdli4.High_level_Product_Description__c = '';
		cdli4.Detailed_Product__c = 'My SFR Cutlery1';
		cdli4.Detailed_Product_Description__c = 'Test Detailed Product Description1';
		cdli4.QTO_PDF_Quantity__c = '1';
		cdli4.Quantity__c = '1';
		cdli4.QTO_PDF_Unit_Of_Measure__c = '1';
		cdli4.QTO_Unit_Of_Measure__c = '1';
		cdli4.QTO_PDF_Unit_Price__c = '2222,00';
		cdli4.Total_Value__c = 50;
		cdli4.QTO_PDF_Currency_Code__c = 'EUR';
		cdli4.CurrencyIsoCode = 'EUR';
		cdli4.QTO_Unit_Price__c = 2222.00;
		cdli4.Customer_Document__c = cd.Id;
		cdli4.QTO_Product_Name__c = prdList[2].Id;
		customerDocLines.add(cdli4);
		insert customerDocLines;
		
		List<Apttus_Proposal__Proposal__c> quotes = QTO_TestDataFactory.createProposal(1,opp.id); 
		quotes[0].Sold_To_Party__c=accList[0].Id;
		quotes[0].Apttus_Proposal__Account__c=accList[0].Id;
		quotes[0].Price_List__c=priceList.Id;
		quotes[0].Agreement_Lookup__c=agr.Id;
		quotes[0].Apttus_Proposal__Opportunity__c=opp.Id;
		insert quotes;
		
		List<Apttus_Proposal__Proposal_Line_Item__c> quoteLineList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		Apttus_Proposal__Proposal_Line_Item__c quoteLines = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,plist[0]); 
		quoteLines.Apttus_Proposal__Product__c = prdList[0].Id;
		quoteLines.Apttus_QPConfig__PriceListItemId__c = plist[0].Id;
		quoteLines.Apttus_QPConfig__Quantity2__c = 10;
		quoteLineList.add(quoteLines);
		
		
		Apttus_Proposal__Proposal_Line_Item__c quoteLines2 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,plist[1]); 
		quoteLines2.Apttus_Proposal__Product__c = prdList[1].Id;
		quoteLines.Apttus_QPConfig__PriceListItemId__c = plist[1].Id;
		quoteLines2.Apttus_QPConfig__Quantity2__c = 100; 
		quoteLineList.add(quoteLines2); 
		
		insert quoteLineList;
		
		
		List<Customer_facing_Attribute__c> lineItemCfas = new List<Customer_facing_Attribute__c>();
		Customer_facing_Attribute__c linecfa1 = new Customer_facing_Attribute__c();
		linecfa1.Attribute_Label__c = 'PDF QUOTE REF';
		linecfa1.Attribute_Value__c = quotes[0].Name;
		linecfa1.QTO_Customer_Document__c = null;
		linecfa1.QTO_Customer_Document_Line_Items__c = customerDocLines[0].id;
		linecfa1.Quote__c = quotes[0].id;
		linecfa1.Quote_Line_Item__c = quoteLines.id;
		lineItemCfas.add(linecfa1);
		
		Customer_facing_Attribute__c linecfa2 = new Customer_facing_Attribute__c();
		linecfa2.Attribute_Label__c = 'PDF CONTRACT REF';
		linecfa2.Attribute_Value__c = agr.Name;
		linecfa2.QTO_Customer_Document__c = null;
		linecfa2.QTO_Customer_Document_Line_Items__c = customerDocLines[0].Id;
		linecfa2.Quote__c = null;
		linecfa2.Quote_Line_Item__c = null;
		lineItemCfas.add(linecfa2);
		
		Customer_facing_Attribute__c linecfa3 = new Customer_facing_Attribute__c();
		linecfa3.Attribute_Label__c = 'PDF SITE CODE';
		linecfa3.Attribute_Value__c = 'S-00123360';
		linecfa3.QTO_Customer_Document__c = null;
		linecfa3.QTO_Customer_Document_Line_Items__c = customerDocLines[1].Id;
		linecfa3.Quote__c = quotes[0].id;
		linecfa3.Quote_Line_Item__c = quoteLines.id;
		lineItemCfas.add(linecfa3);
		
		Customer_facing_Attribute__c linecfa4 = new Customer_facing_Attribute__c();
		linecfa4.Attribute_Label__c = 'ANTICIPATION REF';
		linecfa4.Attribute_Value__c = 'ANT-00123360';
		linecfa4.QTO_Customer_Document__c = null;
		linecfa4.QTO_Customer_Document_Line_Items__c = customerDocLines[1].Id;
		linecfa4.Quote__c = quotes[0].id;
		linecfa4.Quote_Line_Item__c = quoteLines.id;
		lineItemCfas.add(linecfa4);
		
		Customer_facing_Attribute__c linecfa5 = new Customer_facing_Attribute__c();
		linecfa5.Attribute_Label__c = 'Quote Line';
		linecfa5.Attribute_Value__c = 'Quote Line';
		linecfa5.QTO_Customer_Document__c = null;
		linecfa5.QTO_Customer_Document_Line_Items__c = customerDocLines[2].Id;
		linecfa5.Quote__c = null;
		linecfa5.Quote_Line_Item__c = null;
		lineItemCfas.add(linecfa5);
		insert lineItemCfas;
		
		
		Customer_Document__c cdoc = [Select Id, Customer__c from Customer_Document__c limit 1];
		QTOCustomerDocumentUtil.findAllCDLinesByCusDocId(cdoc.Id, QTO_Constants.ENRICHMENT);
		QTOCustomerDocumentUtil.findAllCDLinesByCusDocId(cdoc.Id, QTO_Constants.ASSOCIATION);
		QTOCustomerDocumentUtil.findAllCdLinesByStatus(new Set<Id>{cdoc.Id}, 'Enriched(Lines)');
		QTOCustomerDocumentUtil.findAllAssociatedQuotes(cdoc.Id, new List<String> {'PDF QUOTE REF'}, cdoc.Customer__c );
		QTOCustomerDocumentUtil.findCfasByAttributeType(cdoc.Id, 'PDF QUOTE REF');
		QTOCustomerDocumentUtil.findAllQuoteLinesBySoldToParty(cdoc.Customer__c);
		QTOCustomerDocumentUtil.findByCustomerDocumentId(new List<Id> {cdoc.Id});
		QTOCustomerDocumentUtil.findAllCDLines(new List<Id>{cdli4.Id});
		QTOCustomerDocumentUtil.findAllCDocAndCDocLinesByCdIdsAndStatus(new Set<Id>{cdoc.Id}, 'Enriched(Lines)');
		QTOCustomerDocumentUtil.findAllCDocAndCDocLinesByCdIds(new Set<Id> {cdoc.Id});
		QTOCustomerDocumentUtil.updateCustomerDocumentStatus(new Set<Id> {cdoc.Id}, QTO_Constants.EXCEPTION_ASSOCIATION) ;
		test.stopTest();
	} 
	
 
	
}