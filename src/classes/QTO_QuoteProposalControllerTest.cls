/**************************************************************************
Class Name: QTO_QuoteProposalControllerTest
Created by: Shaik Johny Basha
Created Date: 28 OCT 2021
Last modified by: Shaik Johny Basha
Description: Test class for QTO_QuoteProposalControllerTest  
UserStory : DSI-2241
***************************************************************************/
@isTest 
public with sharing class QTO_QuoteProposalControllerTest {
	@testsetup
	static void quoteProposalCreationTest(){
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
		
		
		
		
		/*
List<Account> accList = QTO_TestDataFactory.createAccount(2);
accList[0].Name='Test Account';
insert accList; 

List<Account> accList1 = QTO_TestDataFactory.createAccount(1);
accList1[0].Name='Dummy Acc';
insert accList1; 
*/
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
		
		List<Apttus__AgreementLineItem__c> agList = new List<Apttus__AgreementLineItem__c>();
		
		Apttus__AgreementLineItem__c agLine0 = new Apttus__AgreementLineItem__c();
		agLine0.Apttus__AgreementId__c = agr.Id;
		agLine0.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine0.Contract_Item_Number__c = 'My SFR Cutlery';
		agLine0.CLM_CFE_Reference__c = 'My SFR Cutlery';
		agLine0.Apttus__ProductId__c = productList[0].Id;
		agLine0.Apttus__Quantity__c = 0;
		agLine0.Apttus_CMConfig__Uom__c = 'PCE';
		agLine0.Apttus_CMConfig__NetUnitPrice__c = 2222.00;
		agLine0.Apttus__NetPrice__c = 2222.00;
		
		
		Apttus__AgreementLineItem__c agLine1 = new Apttus__AgreementLineItem__c();
		agLine1.Apttus__AgreementId__c = agr.Id;
		agLine1.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine1.Contract_Item_Number__c = 'My SFR Cutlery';
		agLine1.CLM_CFE_Reference__c = 'My SFR Cutlery';
		agLine1.Apttus__ProductId__c = productList[1].Id;
		agLine1.Apttus__Quantity__c = 10;
		agLine1.Apttus_CMConfig__Uom__c = 'PCE';
		agLine1.Apttus_CMConfig__NetUnitPrice__c = 2222.00;
		agLine1.Apttus__NetPrice__c = 2222.00;
		
		Apttus__AgreementLineItem__c agLine2 = new Apttus__AgreementLineItem__c();
		agLine2.Apttus__AgreementId__c = agr.Id;
		agLine2.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine2.Contract_Item_Number__c = 'My SFR Cutlery1';
		agLine2.CLM_CFE_Reference__c = 'My SFR Cutlery1';
		agLine2.Apttus__ProductId__c = product2.Id;
		agLine2.Apttus__Quantity__c = 20;
		agLine2.Apttus_CMConfig__Uom__c = 'PCE';
		agLine2.Apttus_CMConfig__NetUnitPrice__c = 2222.00;
		agLine2.Apttus__NetPrice__c = 2222.00;
		
		Apttus__AgreementLineItem__c agLine3 = new Apttus__AgreementLineItem__c();
		agLine3.Apttus__AgreementId__c = agr.Id;
		agLine3.Apttus__Description__c = 'My SFR Cutlery desc';
		agLine3.Contract_Item_Number__c = 'My SFR Cutlery1';
		agLine3.CLM_CFE_Reference__c = 'My SFR Cutlery1';
		agLine3.Apttus__ProductId__c = product1.Id;
		agLine3.Apttus__Quantity__c = 40;
		agLine3.Apttus_CMConfig__Uom__c = 'PCE';
		agLine3.Apttus_CMConfig__NetUnitPrice__c = 2222.00;
		agLine3.Apttus__NetPrice__c = 2222.00;
		
		agList.add(agLine0);
		agList.add(agLine1);
		agList.add(agLine2);
		agList.add(agLine3);
		insert agList;
		/*
			Apttus_Config2__PaymentTerm__c paymentTerm = new Apttus_Config2__PaymentTerm__c(
			Name = 'P60',		 // Name
			Apttus_Config2__Sequence__c = 5,	 // Sequence
			Apttus_Config2__Label__c = 'Net 60 Days',	// Label
			Apttus_Config2__OffsetType__c = 'On Receipt',   // Offset Type
			Apttus_Config2__StartType__c = 'Invoice Date',  // Start Type
			Apttus_Config2__IsDefault__c = false	 // Is Default
			);
			insert paymentTerm;
		*/
	}
	
	@isTest
	static void quoteProposalApiTest() {
		test.startTest();
		List<Account> accounts = [Select Id, AccountNumber from Account limit 2];	  
		Apttus__APTS_Agreement__c agmt = [Select Id, Apttus__FF_Agreement_Number__c from Apttus__APTS_Agreement__c limit 1];
		Opportunity opp = [Select Id, Opportunity_ID__c from Opportunity limit 1];
		
		String jsonPayload = '[{\"attributes\":{\"type\":\"Apttus_Proposal__Proposal__c\"},'
			+'\"Analytics_File_Refer_ID__c\":\"RV-Q-FLUVIUS-R21#11-CASE-IMPACT-20211004-02.xlsm\",'
			+'\"Agreement_Lookup__c\":\"'+agmt.Apttus__FF_Agreement_Number__c+'\",\"Apttus_Proposal__Account__c\":\"'+accounts[1].AccountNumber+'\",'
			+'\"Apttus_Proposal__Opportunity__c\":\"'+opp.Opportunity_ID__c+'\",\"Contract_Type_Name__c\":\"Project\",'
			+'\"Apttus_Proposal__Proposal_Category__c\":\"Quote\",'
			+'\"Incoterms__c\":\"DDP(DeliveredDutyPaid)\",\"Lead_BU__c\":\"\",'
			+'\"DS_customer_facing_Attributes__r\":{\"totalSize\":1,\"done\":true,'
			+'\"records\":[{\"attributes\":{\"type\":\"Customer_facing_Attribute__c\"},'
			+'\"Attribute_Name__c\":\"\",\"Attribute_Label__c\":\"TestCaseIMPACT\",\"Attribute_Value__c\":\"NoReferencesProvided\",\"CurrencyIsoCode\":\"EUR\"}]},'
			+'\"Apttus_Proposal__R00N70000001yUfBEAU__r\":{\"totalSize\":4,\"done\":true,'
			+'\"records\":[{\"attributes\":{\"type\":\"Apttus_Proposal__Proposal_Line_Item__c\"},\"DS_Grouping_Name__c\":\"CFE-3FE77589AA\",'
			+'\"CFE_Reference__c\":\"\",\"CFE_Description__c\":\"\",\"Product_Code__c\":\"3FE77589AA\",'
			+'\"Apttus_Proposal__Product__c\":\"3FE77589AA\",\"Apttus_QPConfig__LineType__c\":\"Product/Service\",'
			+'\"NokiaCPQ_Configuration_Type__c\":\"Bundle\",\"Apttus_QPConfig__Quantity2__c\":100.0,\"Total_Option_Quantity__c\":100.0,'
			+'\"Apttus_QPConfig__ItemSequence__c\":1,\"Apttus_QPConfig__LineNumber__c\":2,'
			+'\"DS_customer_facing_Attributes__r\":{\"totalSize\":1,\"done\":true,\"records\":[{\"attributes\":{\"type\":\"Customer_facing_Attribute__c\"},'
			+'\"Attribute_Name__c\":\"\",\"Attribute_Label__c\":\"CustomerProductCode\",\"Attribute_Value__c\":\"CFE-3FE77589AA\",\"CurrencyIsoCode\":\"EUR\"}]}},'
			+'{\"attributes\":{\"type\":\"Apttus_Proposal__Proposal_Line_Item__c\"},\"DS_Grouping_Name__c\":\"\",\"CFE_Reference__c\":\"\",'
			+'\"CFE_Description__c\":\"\",\"Product_Code__c\":\"SISRVIOT0001\",\"Apttus_Proposal__Product__c\":\"SISRVIOT0001\",'
			+'\"Apttus_QPConfig__LineType__c\":\"option\",\"NokiaCPQ_Configuration_Type__c\":\"Standalone\",\"Apttus_QPConfig__Quantity2__c\":100.0,'
			+'\"Total_Option_Quantity__c\":100.0,\"Apttus_QPConfig__ItemSequence__c\":2,\"Apttus_QPConfig__LineNumber__c\":2,\"Apttus_QPConfig__NetPrice__c\":0,'
			+'\"Apttus_QPConfig__NetUnitPrice__c\":0,\"Apttus_QPConfig__Uom__c\":\"Each\",\"DS_customer_facing_Attributes__r\":{\"totalSize\":2,\"done\":true,'
			+'\"records\":[{\"attributes\":{\"type\":\"Customer_facing_Attribute__c\"},\"Attribute_Name__c\":\"\",\"Attribute_Label__c\":\"CustomerProductCode\",'
			+'\"Attribute_Value__c\":\"CFE-3FE77589AA\",\"CurrencyIsoCode\":\"EUR\"},{\"attributes\":{\"type\":\"Customer_facing_Attribute__c\"},'
			+'\"Attribute_Name__c\":\"\",\"Attribute_Label__c\":\"SiteCode\",\"Attribute_Value__c\":\"SITE-3X-V20210922-01\",\"CurrencyIsoCode\":\"EUR\"}]}}]}}]';
		
		
		RestRequest request = new RestRequest(); 
		request.addHeader('httpMethod', 'POST');
		request.requestBody = Blob.valueof(jsonPayload);
		RestResponse rp = new RestResponse();
		
		RestContext.request = request;	
		System.debug('STATUS:BEFORE API CALL');		
		QTO_QuoteProposalController.ResponseWrapper res = QTO_QuoteProposalController.quoteProposalCreation();
		System.debug('STATUS:AFTER*** API CALL');
		test.stopTest();	
	}
	@isTest
	static void quoteProposalApiRequestBodyEmptyTest() {
		test.startTest();
		List<Account> accounts = [Select Id, AccountNumber from Account limit 2];	  
		Apttus__APTS_Agreement__c agmt = [Select Id, Apttus__FF_Agreement_Number__c from Apttus__APTS_Agreement__c limit 1];
		Opportunity opp = [Select Id, Opportunity_ID__c from Opportunity limit 1];
		
		String jsonPayload = '';
		
		
		RestRequest request = new RestRequest(); 
		request.addHeader('httpMethod', 'POST');
		request.requestBody = Blob.valueof(jsonPayload);
		RestResponse rp = new RestResponse();
		
		RestContext.request = request;	
		System.debug('STATUS:BEFORE API CALL');		
		QTO_QuoteProposalController.ResponseWrapper res = QTO_QuoteProposalController.quoteProposalCreation();
		System.debug('STATUS:AFTER*** API CALL');
		test.stopTest();  
		
		
	}
}