/****************************************
 * Name : NokiaCPQ_Reprice_Quote_Controller_Test
 * Author : Accenture
 * Description : Test class for NokiaCPQ_Reprice_Quote_controller, ProcessLineItemBatch, RepriceAllQuotesBatch & lightning component.
 *****************************************/

@isTest
public class NokiaCPQ_Reprice_Quote_Controller_Test {

	/***********************
	* Method Name: submitForRepriceTest
	* Description: To cover the method submitForReprice from class NokiaCPQ_Reprice_Quote_controller.
	* Parameters: NA
	************************/
	static testmethod void submitForRepriceTest(){
		test.startTest();
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].Acc_No__c = 'Test10';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			accounts[1].Partner_Type__c = '';
			accounts[1].Partner_Program__c = '';
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		 opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities;  
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;
		 
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = true;
		proposals[0].Reprice_In_Progress__c = false;
		insert proposals;
		
		system.debug('proposals[0].Id;--->'+proposals[0].Id);
		
		//get a Price List
		/*Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList = [SELECT ID, Name, PriceList_Type__c, Apttus_Config2__Active__c FROM Apttus_Config2__PriceList__c WHERE Name='Global Price List (EUR)' Limit 1];
		*/
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(
			Name = 'Global Price List (EUR)', 
			Apttus_Config2__Active__c = True
		);
		insert priceList;
		
		// create a product configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		insert prodConfigs;
		
		//get a IP Routing Product
		Product2 productInst = new Product2();
		productInst.Name = 'Test1'; 
		productInst.ProductCode = '123'; 
		productInst.CurrencyIsoCode = 'USD';
		productInst.Pricing_Clusters__c='NAM';
		productInst.Portfolio__c = 'IP Routing';
		productInst.isActive = true;
		productInst.Apttus_Config2__ConfigurationType__c = 'Standalone';
		productInst.NokiaCPQ_Item_Type__c='Software';
		productInst.NokiaCPQ_Classification2__c='Standard SW (STD)';
		productInst.NokiaCPQ_License_Usage__c='Commercial Term License';
		productInst.NokiaCPQ_Product_Discount_Category__c = 'XYZ';
		insert productInst;
			
		// create a Line Item
		List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
		lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
		lineItems[0].Apttus_Config2__ProductId__c = productInst.Id;
		lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
		insert lineItems;
		
		
		NokiaCPQ_Reprice_Quote_controller.submitForReprice(proposals[0].Apttus_Proposal__Opportunity__c);
		test.stopTest(); 
		
	}
	
	/***********************
	* Method Name: submitForRepriceTest2
	* Description: To cover the method submitForReprice from class NokiaCPQ_Reprice_Quote_controller such that validquoteList is empty.
	* Parameters: NA
	************************/
	static testmethod void submitForRepriceTest2(){
		test.startTest();
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].Acc_No__c = 'Test11';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			accounts[1].Partner_Type__c = '';
			accounts[1].Partner_Program__c = '';
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		 opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities;  
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;
		 
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].Reprice_In_Progress__c = false;
		insert proposals;
		
		system.debug('proposals[0].Id;--->'+proposals[0].Id);
		
		//get a Price List
		/*Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList = [SELECT ID, Name, PriceList_Type__c, Apttus_Config2__Active__c FROM Apttus_Config2__PriceList__c WHERE Name='Global Price List (EUR)' Limit 1];
		*/
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(
			Name = 'Global Price List (EUR)', 
			Apttus_Config2__Active__c = True
		);
		insert priceList;
		
		// create a product configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		insert prodConfigs;
		
		//get a IP Routing Product
		Product2 productInst = new Product2();
		productInst.Name = 'Test1'; 
		productInst.ProductCode = '123'; 
		productInst.CurrencyIsoCode = 'USD';
		productInst.Pricing_Clusters__c='NAM';
		productInst.Portfolio__c = 'IP Routing';
		productInst.isActive = true;
		productInst.Apttus_Config2__ConfigurationType__c = 'Standalone';
		productInst.NokiaCPQ_Item_Type__c='Software';
		productInst.NokiaCPQ_Classification2__c='Standard SW (STD)';
		productInst.NokiaCPQ_License_Usage__c='Commercial Term License';
		productInst.NokiaCPQ_Product_Discount_Category__c = 'XYZ';
		insert productInst;
			
		// create a Line Item
		List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
		lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
		lineItems[0].Apttus_Config2__ProductId__c = productInst.Id;
		lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
		insert lineItems;
		
		NokiaCPQ_Reprice_Quote_controller newVar = new NokiaCPQ_Reprice_Quote_controller();
		NokiaCPQ_Reprice_Quote_controller.submitForReprice(proposals[0].Apttus_Proposal__Opportunity__c);
		test.stopTest(); 
		
	}
	
}