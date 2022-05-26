/**************************************************************************
Class Name: QTO_CPOLineItemHelperTest
Created by: Shaik Johny Basha
Created Date: 29 June 2021
Last modified by: Shaik Johny Basha
Description: Test class for QTO_CPOLineItemHelper   
UserStory : DSI-2156
***************************************************************************/
@IsTest
public class QTO_CPOLineItemHelperTest {	
	
	@TestSetup
	static void setupCD() {   
  
	}
	
	@IsTest
	static void createCPOLineItems(){
	   
		//Customer_Document__c cd = [Select Id from Customer_Document__c LIMIT 1];	  
		//List<String> cpoFieldList = getAllObjectFields('Apttus_Config2__CustomerPurchaseOrder__c');
		//String queryString = 'SELECT ' + String.join(cpoFieldList, ',') + ' FROM Apttus_Config2__CustomerPurchaseOrder__c LIMIT 1';
		//List<Apttus_Config2__CustomerPurchaseOrder__c> cpo = Database.query(queryString);
		//System.assertNotEquals(true, cpo.isEmpty(), 'Expected purchase orders list not to be empty');
		//System.assertNotEquals(true, cpo.get(0).Nokia_Customer_Document_ID__c == null, 'Expected a customer document id in the field');
		
		List<Account> customer = QTO_TestDataFactory.createAccount(1);
		customer[0].Name='Test Account';
		insert customer;

		List<Account> legalEntity = QTO_TestDataFactory.createAccount(2);
		legalEntity[0].Name='Test LegalEntity';
		legalEntity[0].Type = 'Internal Customer';
		insert legalEntity; 
			  
		Opportunity opportunity = QTO_TestDataFactory.OpportunityCreation(customer[0]);
		insert opportunity;
		
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
		
		Customer_Document__c cd = QTO_TestDataFactory.createCustomerDocument();
		cd.Status__c = 'Draft';
		cd.Customer_Document_ID__c = '12435678';
		cd.Classification__c = 'Purchase Order';
		cd.Sub_Classification__c = 'Standard';
		cd.Nokia_Legal_Entity_Account__c = legalEntity[0].Id;
		cd.Customer__c = customer[0].Id;
		cd.Total_Value__c=234.50;
		cd.Nokia_Document_Receipt_Date__c = Date.today();
		cd.QTO_Nature__c='Create';
		insert cd;
		
		cd.Status__c =  QTO_Constants.CD_STATUS_LEGACY;
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
		cdli1.QTO_Product_Name__c = product1.Id;
		
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
		cdli2.QTO_Product_Name__c = product1.Id;
		customerDocLines.add(cdli2);
		insert customerDocLines;
		
		
		Apttus_Config2__PriceList__c priceList = QTO_TestDataFactory.priceList(); 
		priceList.Name = 'SFR Price List for Cutlery';
		priceList.Apttus_Config2__Description__c = 'SFR Price List for Cutlery';
		priceList.Apttus_Config2__Active__c = true;
		priceList.Apttus_Config2__AccountId__c = customer[0].Id;
		priceList.PriceList_Type__c = 'DS';
		priceList.Business_Group__c = 'GS';
		priceList.Apttus_Config2__ContractNumber__c = 'PPLN-00148';
		insert priceList;
		
		List<Apttus_Config2__PriceListItem__c> plist = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c priListItem = QTO_TestDataFactory.createPriceListItem(priceList); 
		priListItem.Apttus_Config2__PriceListId__c = priceList.Id;
		priListItem.Apttus_Config2__ProductId__c = product1.Id;
		priListItem.Apttus_Config2__ChargeType__c = 'Product Price';
		priListItem.Apttus_Config2__PriceType__c = 'One Time';
		priListItem.Apttus_Config2__PriceUom__c = 'Each';
		priListItem.Apttus_Config2__ContractPrice__c = 2500;
		priListItem.Apttus_Config2__ListPrice__c = 2555;
		priListItem.Apttus_Config2__ContractItemNumber__c = 'My SFR Cutlery';
		
		plist.add(priListItem);
		
		Apttus_Config2__PriceListItem__c priListItem2 = QTO_TestDataFactory.createPriceListItem(priceList); 
		priListItem2.Apttus_Config2__PriceListId__c = priceList.Id;
		priListItem2.Apttus_Config2__ProductId__c = product1.Id;
		priListItem2.Apttus_Config2__ChargeType__c = 'Product Price';
		priListItem2.Apttus_Config2__PriceType__c = 'One Time';
		priListItem2.Apttus_Config2__PriceUom__c = 'Each';
		priListItem2.Apttus_Config2__ContractPrice__c = 2500;
		priListItem2.Apttus_Config2__ListPrice__c = 2555;
		priListItem2.Apttus_Config2__ContractItemNumber__c = 'My SFR Cutlery';
		
		plist.add(priListItem2);
		insert plist;
		
		
		
		Apttus__APTS_Agreement__c agr = QTO_TestDataFactory.createAgreement(legalEntity[0], opportunity, legalEntity[1]);
		agr.Apttus__Status_Category__c = 'In Effect';
		agr.Apttus__Status__c = 'Activated';
		agr.CurrencyIsoCode = 'EUR';
		agr.Apttus__Contract_End_Date__c = System.today()+10;
		insert agr; 
		
		Test.startTest();
		List<Apttus_Proposal__Proposal__c> quotes = QTO_TestDataFactory.createProposal(1,opportunity.id); 
		quotes[0].Sold_To_Party__c = customer[0].Id;
		quotes[0].Apttus_Proposal__Account__c =customer[0].Id;
		quotes[0].Price_List__c = priceList.Id;
		quotes[0].Agreement_Lookup__c = agr.Id;
		quotes[0].Apttus_Proposal__Opportunity__c = opportunity.Id;
		insert quotes;
		
		// create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		Apttus_Proposal__Proposal_Line_Item__c proposalLineItem1 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].Id, plist[0]);
		proposalLineItem1.Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItem1.Apttus_QPConfig__LineNumber__c=100;
		proposalLineItem1.Apttus_QPConfig__ItemSequence__c=101;
		
		Apttus_Proposal__Proposal_Line_Item__c proposalLineItem2 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].Id, plist[1]);
		proposalLineItem2.Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItem2.Apttus_QPConfig__LineNumber__c=100;
		proposalLineItem2.Apttus_QPConfig__ItemSequence__c=102;
		
		Apttus_Proposal__Proposal_Line_Item__c proposalLineItem3 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].Id, plist[0]);
		proposalLineItem3.Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItem3.Apttus_QPConfig__LineNumber__c=100;
		proposalLineItem3.Apttus_QPConfig__ItemSequence__c=103; 
		
		Apttus_Proposal__Proposal_Line_Item__c proposalLineItem4 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].Id, plist[0]);
		proposalLineItem4.Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalLineItem4.Apttus_QPConfig__LineNumber__c=103;
		proposalLineItem4.Apttus_QPConfig__ItemSequence__c=104;
		
		 Apttus_Proposal__Proposal_Line_Item__c proposalLineItem5 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].Id, plist[0]);
		proposalLineItem5.Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItem5.Apttus_QPConfig__LineNumber__c=103;
		proposalLineItem5.Apttus_QPConfig__ItemSequence__c=105;
		
		proposalLineItems.add(proposalLineItem1);
		proposalLineItems.add(proposalLineItem2);
		proposalLineItems.add(proposalLineItem3);
		proposalLineItems.add(proposalLineItem4);
		proposalLineItems.add(proposalLineItem5);
		
		insert proposalLineItems;
		
		// create customer document quote lines
		QTO_Customer_Document_Quote_Line__c customerDocumentQuoteLine = new QTO_Customer_Document_Quote_Line__c();
		customerDocumentQuoteLine.QTO_Customer_Document_Line_Items__c = customerDocLines[0].Id;
		customerDocumentQuoteLine.QTO_Proposal_Line_Item__c = proposalLineItems[0].Id;
		insert customerDocumentQuoteLine;
				
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
		customerDocumentAgreementLine.QTO_Customer_Document_Line_Items__c = customerDocLines[1].Id;
		customerDocumentAgreementLine.QTO_Agreement_Line_Item__c = agreementLineItem.Id;
		insert customerDocumentAgreementLine;
		
		QTO_Customer_Document_Quote_Line__c cusQuoteLine = new QTO_Customer_Document_Quote_Line__c();
		cusQuoteLine.QTO_Customer_Document_Line_Items__c = customerDocLines[1].Id;
		cusQuoteLine.QTO_Proposal_Line_Item__c = proposalLineItem1.Id; 
		insert cusQuoteLine;
		
		
		QTO_AALI_Associations_to_Quote_LI__c alql = new QTO_AALI_Associations_to_Quote_LI__c();
		alql.Agreement_Line_Item__c= agreementLineItem.Id;
		alql.Quote_Line_Item__c=proposalLineItem1.Id; 
		insert alql;
		
		
		
		
		List<Customer_facing_Attribute__c> allCusfacingAttributes = new List<Customer_facing_Attribute__c>();
		Customer_facing_Attribute__c cfa = new Customer_facing_Attribute__c();
		cfa.Attribute_Label__c = 'PDF QUOTE REF';
		cfa.Attribute_Value__c = quotes[0].Name;
		cfa.QTO_Customer_Document__c = cd.Id;
		cfa.QTO_Customer_Document_Line_Items__c = customerDocLines[1].Id;
		cfa.Quote__c = quotes[0].id;
		// cfa.Quote_Line_Item__c = quoteLines.id;
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
		cfa.Quote_Line_Item__c = proposalLineItem1.id;
		allCusfacingAttributes.add(cfa3);
		
		Customer_facing_Attribute__c cfa4 = new Customer_facing_Attribute__c();
		cfa4.Attribute_Label__c = 'ANTICIPATION REF';
		cfa4.Attribute_Value__c = 'ANT-00123360';
		//cfa4.QTO_Customer_Document__c = cd.Id;
		cfa4.QTO_Customer_Document_Line_Items__c = cdli1.Id;
		cfa.Quote__c = quotes[0].id;
		cfa.Quote_Line_Item__c = proposalLineItem1.id;
		allCusfacingAttributes.add(cfa4);
		insert allCusfacingAttributes; 
		
		Apttus_Config2__CustomerPurchaseOrder__c cpo = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpo.Nokia_Customer_Document_ID__c = cd.Id;
		cpo.Apttus_Config2__Status__c='Draft';
		insert cpo;
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		Apttus_Config2__CustomerPurchaseOrder__c cpolist = [Select Id, Nokia_Customer_Document_ID__c, Apttus_Config2__Status__c from Apttus_Config2__CustomerPurchaseOrder__c LIMIT 1]; 
		QTO_CPOLineItemHelper.createLineItems(new List<Apttus_Config2__CustomerPurchaseOrder__c> {cpolist});
		Test.stopTest();
	}
	
	
}