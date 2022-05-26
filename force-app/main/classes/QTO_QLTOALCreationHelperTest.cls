/**************************************************************************
Class Name: QTO_QLTOALCreationHelperTest
Created by: Shaik Johny Basha
Created Date: 02 Nov 2021
Created By  : Shaik, Johny
Description: Test class for QTO_QLTOALCreationHelper  
UserStory : DSI-2166
***************************************************************************/
@isTest 
public with sharing class QTO_QLTOALCreationHelperTest {

	@testsetup
	static void qlToAlSetUp(){
		test.startTest();
		
		Account parentAccount = TestDataFactory.createAccount(1)[0];
		parentAccount.AccountNumber='101234567';
		parentAccount.Acc_No__c = '101234567';
		parentAccount.Name = 'Parent Account';
		parentAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert parentAccount;		
		
		List<Account> accList = new List<Account>();
		Account customerAccount = TestDataFactory.createAccount(1)[0];
		customerAccount.AccountNumber='101234568';
		customerAccount.Acc_No__c = '101234568';
		customerAccount.Name = 'Customer Account';
		customerAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		customerAccount.ParentId = parentAccount.Id;
		customerAccount.Active__c = true;
		customerAccount.BillingPostalCode = '92661';
		accList.add(customerAccount);
		
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='101234569';
		accLegalEntity.Acc_No__c = '101234569';
		accLegalEntity.Name = 'ALCATEL-LUCENT INTERNATIONAL';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accLegalEntity.ParentId = parentAccount.Id;
		accLegalEntity.Active__c = true;
		accLegalEntity.Type='Internal Customer';
		accLegalEntity.BillingPostalCode = '92661';
		accList.add(accLegalEntity);
		
		Account accLegalEntity1 = TestDataFactory.createAccount(1)[0];
		accLegalEntity1.AccountNumber='101234580';
		accLegalEntity1.Acc_No__c = '101234580';
		accLegalEntity1.Name = 'Legal Account';
		accLegalEntity1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accLegalEntity1.ParentId = parentAccount.Id;
		accLegalEntity1.Active__c = true;
		accLegalEntity1.BillingPostalCode = '92661';
		accList.add(accLegalEntity1);
		insert accList;
		
		List<Product2> productList = new List<Product2>();
		Product2 product1 = new Product2();
		product1.CurrencyIsoCode = 'USD';
		product1.ProductCode = '3FE77589AA';
		product1.Name = '3FE77589AA';
		product1.Description = 'Test Detailed Product Description';
		product1.IsActive=True;
		product1.Apttus_Config2__ConfigurationType__c = 'Bundle';
		product1.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
		productList.add(product1);
		
		Product2 product2 = new Product2();
		product2.CurrencyIsoCode = 'USD';
		product2.ProductCode = 'SISRVIOT0001';
		product2.Name = 'SISRVIOT0001';
		product2.Description = 'Test Detailed Product Description1';
		product2.IsActive=True;
		product2.Apttus_Config2__ConfigurationType__c = 'Standalone';
		product2.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
		productList.add(product2);
		insert productList;
		
		
		
		Apttus_Config2__PriceList__c priceList = QTO_TestDataFactory.priceList(); 
		priceList.Name = 'SFR Price List for Cutlery';
		priceList.Apttus_Config2__Description__c = 'SFR Price List for Cutlery';
		priceList.Apttus_Config2__Active__c = true;
		priceList.Apttus_Config2__AccountId__c = accList[0].Id;
		priceList.PriceList_Type__c = 'DS';
		priceList.Business_Group__c = 'GS';
		insert priceList;
		
		List<Apttus_Config2__PriceListItem__c> priceListItem = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c priListItem1 = QTO_TestDataFactory.createPriceListItem(priceList); 
		priListItem1.Apttus_Config2__PriceListId__c = priceList.Id;
		priListItem1.Apttus_Config2__ProductId__c = productList[0].Id;
		priListItem1.Apttus_Config2__ChargeType__c = 'Product Price';
		priListItem1.Apttus_Config2__PriceType__c = 'One Time';
		priListItem1.Apttus_Config2__PriceUom__c = 'Each';
		priListItem1.Apttus_Config2__ContractPrice__c = 2500;
		priListItem1.Apttus_Config2__ListPrice__c = 2555;
		priListItem1.Apttus_Config2__ContractItemNumber__c = 'Bundle 1S 4 ABIA';
		priceListItem.add(priListItem1);
		
		Apttus_Config2__PriceListItem__c priListItem2 = QTO_TestDataFactory.createPriceListItem(priceList); 
		priListItem2.Apttus_Config2__PriceListId__c = priceList.Id;
		priListItem2.Apttus_Config2__ProductId__c = productList[1].Id;
		priListItem2.Apttus_Config2__ChargeType__c = 'Product Price';
		priListItem2.Apttus_Config2__PriceType__c = 'One Time';
		priListItem2.Apttus_Config2__PriceUom__c = 'Each';
		priListItem2.Apttus_Config2__ContractPrice__c = 2500;
		priListItem2.Apttus_Config2__ListPrice__c = 2555;
		priListItem2.Apttus_Config2__ContractItemNumber__c = 'Bundle 1S 4 ABIA1';
		priceListItem.add(priListItem2);
		insert priceListItem;
		
		Opportunity opp = QTO_TestDataFactory.OpportunityCreation(accList[0]);
		opp.Opportunity_ID__c='21.BE.101234568';
		insert opp;
		
		Apttus__APTS_Agreement__c agr = QTO_TestDataFactory.createAgreement(accList[0], opp, accList[1]);
		agr.Apttus__Status_Category__c = 'In Effect';
		agr.Apttus__Status__c = 'Activated';
		agr.CurrencyIsoCode = 'EUR';
		agr.Apttus__Contract_End_Date__c = System.today()+10;
		agr.Apttus_CMConfig__PriceListId__c = priceList.Id;
		insert agr; 
		
		List<Apttus_Proposal__Proposal__c> quotes = QTO_TestDataFactory.createProposal(1,opp.id); 
		quotes[0].Sold_To_Party__c=accList[0].Id;
		quotes[0].Apttus_Proposal__Account__c=accList[0].Id;
		quotes[0].Price_List__c=priceList.Id;
		quotes[0].Agreement_Lookup__c=agr.Id;
		quotes[0].Apttus_Proposal__Opportunity__c=opp.Id;
		quotes[0].CurrencyIsoCode = 'EUR';
		insert quotes;
		
		List<Apttus_Proposal__Proposal_Line_Item__c> quoteLinesList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		Apttus_Proposal__Proposal_Line_Item__c quoteLines1 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,priceListItem[0]); 
		quoteLines1.Apttus_Proposal__Product__c = productList[0].Id;
		quoteLines1.Apttus_QPConfig__PriceListItemId__c = priceListItem[0].Id;
		quoteLines1.Apttus_QPConfig__Quantity2__c = 100;
		quoteLines1.Apttus_QPConfig__Uom__c = 'PCE';
		quoteLines1.Apttus_QPConfig__NetUnitPrice__c = 2222.00;
		quoteLinesList.add(quoteLines1);
		
		Apttus_Proposal__Proposal_Line_Item__c quoteLines2 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,priceListItem[1]); 
		quoteLines2.Apttus_Proposal__Product__c = productList[1].Id;
		quoteLines2.Apttus_QPConfig__PriceListItemId__c = priceListItem[1].Id;
		quoteLines2.Apttus_QPConfig__Quantity2__c = 100;
		quoteLines2.Apttus_QPConfig__Uom__c = 'PCE';
		quoteLines2.Apttus_QPConfig__NetUnitPrice__c = 2222.00;
		quoteLinesList.add(quoteLines2);
		
		Apttus_Proposal__Proposal_Line_Item__c quoteLines3 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,priceListItem[1]); 
		quoteLines3.Apttus_Proposal__Product__c = productList[1].Id;
		quoteLines3.Apttus_QPConfig__PriceListItemId__c = priceListItem[1].Id;
		quoteLines3.Apttus_QPConfig__Quantity2__c = 10;
		quoteLines3.Apttus_QPConfig__Uom__c = 'PCE';
		quoteLines3.Apttus_QPConfig__NetUnitPrice__c = 2222.00;
		quoteLinesList.add(quoteLines3);
		
		Apttus_Proposal__Proposal_Line_Item__c quoteLines4 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,priceListItem[1]); 
		quoteLines4.Apttus_Proposal__Product__c = productList[1].Id;
		quoteLines4.Apttus_QPConfig__PriceListItemId__c = priceListItem[1].Id;
		quoteLines4.Apttus_QPConfig__Quantity2__c = 30;
		quoteLines4.Apttus_QPConfig__Uom__c = 'PCE';
		quoteLines4.Apttus_QPConfig__NetUnitPrice__c = 2222.00;
		quoteLinesList.add(quoteLines4);
		insert quoteLinesList; 

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
		cd.Status__c =  'Registered'; 
		update cd;


		
	}
	
	@isTest
	static void qlToAlCreationTest() {
		test.startTest();	  
		Apttus_Proposal__Proposal__c quote = [Select Id from Apttus_Proposal__Proposal__c limit 1];
		Apttus__APTS_Agreement__c agmt = [Select Id, Apttus__FF_Agreement_Number__c from Apttus__APTS_Agreement__c limit 1];
		Customer_Document__c cdoc = [Select Id from Customer_Document__c limit 1];
		QTO_QLTOALCreationHelper.createAgreementLines(agmt.Id, quote.Id, cdoc.Id);
		
		test.stopTest();
	}
	
	@isTest
	static void createAgreementLinesTest() {
		test.startTest();	  
		Apttus_Proposal__Proposal__c quote = [Select Id from Apttus_Proposal__Proposal__c limit 1];
		Apttus__APTS_Agreement__c agmt = [Select Id, Apttus__FF_Agreement_Number__c from Apttus__APTS_Agreement__c limit 1];
		Customer_Document__c cdoc = [Select Id from Customer_Document__c limit 1];
		QTO_QLTOALCreationHelper.createAgreementLines(agmt.Id, quote.Id, cdoc.Id);
		
		test.stopTest();
	}
	
	@isTest
	static void createAgreementLinesCreationTest() {
		test.startTest();	  
		Apttus_Proposal__Proposal__c quote = [Select Id from Apttus_Proposal__Proposal__c limit 1];
		Apttus__APTS_Agreement__c agmt = [Select Id, Apttus__FF_Agreement_Number__c from Apttus__APTS_Agreement__c limit 1];
		Customer_Document__c cdoc = [Select Id from Customer_Document__c limit 1];
		QTO_QLTOALCreationController.createAgreementLines(agmt.Id, quote.Id, cdoc.Id);
		test.stopTest();
	}
	
	
	@isTest
	static void quoteStatus() {
		test.startTest();	  
		Apttus_Proposal__Proposal__c quote = [Select Id from Apttus_Proposal__Proposal__c limit 1];
		QTO_QLTOALCreationController.quoteStatus(quote.Id);
		test.stopTest();
	}
}