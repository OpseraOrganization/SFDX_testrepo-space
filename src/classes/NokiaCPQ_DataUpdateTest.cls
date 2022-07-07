/**
* @description	   : 
* @author			: Yashdeep Prajapati
* @group			 : 
* @last modified on  : 06-29-2021
* @last modified by  : Yashdeep Prajapati
* Modifications Log 
* Ver   Date		 Author			   Modification
* 1.0   06-24-2021   Yashdeep Prajapati   Initial Version
**/
@isTest
public without sharing class NokiaCPQ_DataUpdateTest{
	@TestSetup
	static void makeData(){
		List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
		runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runUSer[0].NSA_Compliant__c = true;
		database.insert(runUSer);
		system.runAs(runUSer[0]){
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;
		
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();  
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].stageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		opportunities[0].No_Loa__c = true;
		opportunities[0].LOA_Level__c = 'A';
		insert opportunities;  
		
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[0].Accreditation_Type__c = 'Maintenance';
		accreditations[0].Accreditation_Level__c = 'Premium';
		accreditations[0].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;
		
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = true;
		proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing';
		proposals[0].isCQ__c = false;
		proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c =true;
		proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'NO';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(); //direct quote
		insert proposals;	
		proposals[0].CPQ_PortfolioClusterSF1__c = '';
		Nokia_CPQ_Constants.BYPASS_PROPOSAL_TRIGGER = true;
		update proposals[0];
		system.debug('proposals1>>'+proposals[0].CPQ_PortfolioClusterSF1__c);
		system.debug('proposals2>>'+proposals[0].Quote_Type__c);

		//system.assertEquals([SELECT Id,CPQ_PortfolioClusterSF1__c,Quote_Type__c FROM Apttus_Proposal__Proposal__c][0].Quote_Type__c,'testst');
		
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='GBP';
		priceList.Apttus_Config2__Active__c=true;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		insert priceList;
		

		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
		insert prodConfigs;
		
		
		Product2 productInst = new Product2();
		productInst.Name = 'Product18';  
		productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
		productInst.NokiaCPQ_State__c = 'Release';
		insert productInst;

		List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
		lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
		lineItems[0].Apttus_Config2__ProductId__c = productInst.Id;
		lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
		lineItems[0].Apttus_Config2__ItemSequence__c = 1;
		lineItems[0].Apttus_Config2__LineNumber__c = 1;
		lineItems[0].Apttus_Config2__LineStatus__c='New';
		lineItems[0].Apttus_Config2__ChargeType__c = 'Standard Price';
		lineItems[0].Apttus_Config2__LineType__c = 'Product/Service';
		lineItems[0].Apttus_Config2__PriceMethod__c = 'Per Unit';
		lineItems[0].Apttus_Config2__Frequency__c = 'One Time';
		lineItems[0].Apttus_Config2__AdjustmentAmount__c = 10;
		lineItems[0].Apttus_Config2__ListPrice__c = 100;
		lineItems[0].Apttus_Config2__Quantity__c = 1;
		lineItems[0].Apttus_Config2__PrimaryLineNumber__c = 1;
		lineItems[0].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		lineItems[0].Apttus_Config2__AddedBy__c = 'added by code';
		insert lineItems;
		
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		insert proposalLineItemList;
		

		}
	}
	
	@IsTest
	static void testBatch(){   
		Test.startTest();
		Database.executeBatch(new NokiaCPQ_DataUpdate('Apttus_Config2__LineItem__c'));
		Database.executeBatch(new NokiaCPQ_DataUpdate('Apttus_Proposal__Proposal_Line_Item__c'));
		Database.executeBatch(new NokiaCPQ_DataUpdate('Apttus_Proposal__Proposal__c'));
		Test.stopTest();
		
	}
	@IsTest
	static void testBatchAttach(){   

	 
		Test.startTest();
		Attachment attch = new Attachment();
		attch.name = 'Maintenance Catalogue_Test';
		attch.parentId = [select Id from Accreditation__c][0].Id;
		attch.body = Blob.valueOf('Test');
		insert attch;

		Database.executeBatch(new NokiaCPQ_DataUpdate('Attachment'));
		Test.stopTest();
		
	}	
}