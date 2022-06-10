/**************************************************************************
Class Name: QTO_CustomerDocumentLineItemHelperTest
Created by: Shaik Johny Basha
Created Date: 14 June 2021
Last modified by: Shaik Johny Basha
Description: Test class for QTO_CustomerDocumentLineItem_Helper 
UserStory : DSI-2148/DSI-2153
***************************************************************************/
@isTest
public class  QTO_CustomerDocumentLineItemHelperTest {
	
	@testsetup
	static void enrichmentTest() {
		
		List<Account> accList = QTO_TestDataFactory.createAccount(2);
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
		//insert product1;
		prdList.add(product1);
		
		Product2 product2 = new Product2();
		product2.CurrencyIsoCode = 'USD';
		product2.ProductCode = 'Bundle1S4ABIA1';
		product2.Name = 'My SFR Cutlery1';
		product2.Description = 'Test Detailed Product Description1';
		product2.IsActive=True;
		product2.Apttus_Config2__ConfigurationType__c = 'Bundle';
		product2.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
		//insert product2;
		prdList.add(product2);
		
		Product2 product3 = new Product2();
		product3.CurrencyIsoCode = 'USD';
		product3.ProductCode = 'Bundle1S4ABIA1';
		product3.Name = 'My SFR Cutlery1';
		product3.Description = 'Test Detailed Product Description1';
		product3.IsActive=True;
		product3.Apttus_Config2__ConfigurationType__c = 'Bundle';
		product3.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
		//insert product3;
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
		
		List<Apttus_Proposal__Proposal__c> dbquotes = [select Id, Name,Apttus_Proposal__Proposal_Name__c from Apttus_Proposal__Proposal__c order by createddate desc LIMIT 1];		
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
		
		List<Customer_facing_Attribute__c> allCusfacingAttributes = new List<Customer_facing_Attribute__c>();
		Customer_facing_Attribute__c cfa = new Customer_facing_Attribute__c();
		cfa.Attribute_Label__c = 'PDF QUOTE REF';
		cfa.Attribute_Value__c = dbquotes[0].Name;
		cfa.QTO_Customer_Document__c = cd.Id;
		cfa.QTO_Customer_Document_Line_Items__c = null;
		cfa.Quote__c = quotes[0].id;
		cfa.Quote_Line_Item__c = quoteLines.id;
		allCusfacingAttributes.add(cfa);
		
		Customer_facing_Attribute__c cfa2 = new Customer_facing_Attribute__c();
		cfa2.Attribute_Label__c = 'PDF CONTRACT REF';
		cfa2.Attribute_Value__c = agr.Name;
		cfa2.QTO_Customer_Document__c = cd.Id;
		cfa2.QTO_Customer_Document_Line_Items__c = null;
		cfa2.Quote__c = null;
		cfa2.Quote_Line_Item__c = null;
		allCusfacingAttributes.add(cfa2);
		
		Customer_facing_Attribute__c cfa3 = new Customer_facing_Attribute__c();
		cfa3.Attribute_Label__c = 'PDF SITE CODE';
		cfa3.Attribute_Value__c = 'S-00123360';
		cfa3.QTO_Customer_Document__c = cd.Id;
		cfa3.QTO_Customer_Document_Line_Items__c = null;
		cfa.Quote__c = quotes[0].id;
		cfa.Quote_Line_Item__c = quoteLines.id;
		allCusfacingAttributes.add(cfa3);
		
		Customer_facing_Attribute__c cfa4 = new Customer_facing_Attribute__c();
		cfa4.Attribute_Label__c = 'ANTICIPATION REF';
		cfa4.Attribute_Value__c = 'ANT-00123360';
		cfa4.QTO_Customer_Document__c = cd.Id;
		cfa4.QTO_Customer_Document_Line_Items__c = null;
		cfa.Quote__c = quotes[0].id;
		cfa.Quote_Line_Item__c = quoteLines.id;
		allCusfacingAttributes.add(cfa4);
		
		insert allCusfacingAttributes;		
		
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
		
		List<Customer_facing_Attribute__c> lineItemCfas = new List<Customer_facing_Attribute__c>();
		Customer_facing_Attribute__c linecfa1 = new Customer_facing_Attribute__c();
		linecfa1.Attribute_Label__c = 'PDF QUOTE REF';
		linecfa1.Attribute_Value__c = dbquotes[0].Name;
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
		
		Map<Id,List<Apttus__AgreementLineItem__c>> agreementAndLinesMap = new Map<Id,List<Apttus__AgreementLineItem__c>>();
		agreementAndLinesMap.put(agr.Id, agList);
		
		Map<Id,Id> pdfQuoteRefQuoteIdAndAgreeIdMap = new Map<Id,Id>();
		pdfQuoteRefQuoteIdAndAgreeIdMap.put(quotes[0].Id, quotes[0].Agreement_Lookup__c);
		Boolean lineFound = QTO_CustomerDocumentLineItem_Helper.searchProductInQuoteAndAgreement(pdfQuoteRefQuoteIdAndAgreeIdMap, customerDocLines[0], agreementAndLinesMap);
	
	}
	
	@isTest
	static void test1(){
		
		test.startTest();		
		List<Customer_Document_Line_Items__c>  customerDocumentLines = [Select Id,High_level_Product__c,High_level_Product_Description__c,
						Detailed_Product__c,Detailed_Product_Description__c,
						QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,
						Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c
						from Customer_Document_Line_Items__c];
		QTO_CustomerDocumentLineItem_Helper.lineItemEnrichment(customerDocumentLines);		
		test.stopTest();
	}	
	
	@isTest
	static void test2(){
		
		test.startTest();
		Apttus_Proposal__Proposal__c prop = [Select Id from Apttus_Proposal__Proposal__c limit 1];
		delete prop;
		
		List<Customer_Document_Line_Items__c>  customerDocumentLines = [Select Id,High_level_Product__c,High_level_Product_Description__c,
						Detailed_Product__c,Detailed_Product_Description__c,
						QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,
						Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c
						from Customer_Document_Line_Items__c];
		QTO_CustomerDocumentLineItem_Helper.lineItemEnrichment(customerDocumentLines);		
		test.stopTest();
	}
	
	@isTest
	static void test3(){
		
		test.startTest();
		Apttus_Proposal__Proposal__c prop = [Select Id from Apttus_Proposal__Proposal__c limit 1];
		delete prop;		
		Apttus__APTS_Agreement__c agmt = [Select Id from Apttus__APTS_Agreement__c limit 1];
		delete agmt;
		
		List<Customer_Document_Line_Items__c>  customerDocumentLines = [Select Id,High_level_Product__c,High_level_Product_Description__c,
						Detailed_Product__c,Detailed_Product_Description__c,
						QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,
						Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c
						from Customer_Document_Line_Items__c];
		QTO_CustomerDocumentLineItem_Helper.lineItemEnrichment(customerDocumentLines);		
		test.stopTest();
	}
	
	@isTest
	static void test4(){
		
		test.startTest();
		Apttus_Proposal__Proposal__c prop = [Select Id from Apttus_Proposal__Proposal__c limit 1];
		delete prop;		
		Apttus__APTS_Agreement__c agmt = [Select Id from Apttus__APTS_Agreement__c limit 1];
		delete agmt;
		Apttus_Config2__PriceList__c pl = [Select Id from Apttus_Config2__PriceList__c limit 1];
		delete pl;		
		
		List<Customer_Document_Line_Items__c>  customerDocumentLines = [Select Id,High_level_Product__c,High_level_Product_Description__c,
						Detailed_Product__c,Detailed_Product_Description__c,
						QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,
						Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c
						from Customer_Document_Line_Items__c];
		QTO_CustomerDocumentLineItem_Helper.lineItemEnrichment(customerDocumentLines);		
		test.stopTest();
	} 
	
	@isTest
	static void test5(){
		
		test.startTest();		
		List<Customer_Document_Line_Items__c>  customerDocumentLines = [Select Id,High_level_Product__c,High_level_Product_Description__c,
						Detailed_Product__c,Detailed_Product_Description__c,
						QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,
						Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c
						from Customer_Document_Line_Items__c];
		QTOCustomerDocumentUtil.findAllCDLinesByCusDocId(customerDocumentLines[0].Customer_Document__c, QTO_Constants.ENRICHMENT);  
		QTOCustomerDocumentUtil.findAllCDLinesByCusDocId(customerDocumentLines[0].Customer_Document__c, QTO_Constants.ASSOCIATION); 
		QTOCustomerDocumentUtil.findCfasByAttributeType(customerDocumentLines[0].Customer_Document__c, 'PDF QUOTE REF');
		QTOCustomerDocumentUtil.findCfasByAttributeType(customerDocumentLines[0].Customer_Document__c, 'PDF CONTRACT REF');
		QTOCustomerDocumentUtil.findAllQuoteLinesBySoldToParty(customerDocumentLines[0].Customer_Document__r.Customer__c);
		Apttus_Proposal__Proposal__c prop = [Select Id,Name from Apttus_Proposal__Proposal__c limit 1];
		List<String> pId = new List<String> {prop.Name};
		QTOCustomerDocumentUtil.findAllAssociatedQuotes(customerDocumentLines[0].Customer_Document__c, pId , customerDocumentLines[0].Customer_Document__r.Customer__c);
		test.stopTest();
	}	
	
	
}