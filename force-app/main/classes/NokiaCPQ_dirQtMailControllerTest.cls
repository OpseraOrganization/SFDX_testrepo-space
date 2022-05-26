@isTest
public with sharing class NokiaCPQ_dirQtMailControllerTest {
	@testSetup 
	Public static void Testdata(){
	
		 List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);

		 List<User> sysAdminUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'System Administrator');
		 System.runAs(sysAdminUser[0]){
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;
		
		List<Account> acclist = new List<Account>();
		acclist.add(accounts[0]);
			
			product2 prod = new product2();
			prod.name = 'A';
			prod.CurrencyIsoCode = 'EUR';
			prod.Business_Group__c='ION';
			prod.Family= 'A&A-CEM';
			prod.IsActive=True;
			prod.Partner_Visible__c=True;
			prod.ProductCode='3HE10869BA';
			prod.Apttus_Config2__Version__c= 1;
			prod.Portfolio__c= 'IP Routing';
			prod.Pricing_Clusters__c='NAM';
			prod.IsActive= True;
			insert prod;
		
			product2 prod1 = new product2();
			prod1.name = 'A2';
			prod1.CurrencyIsoCode = 'EUR';
			prod1.Business_Group__c='FN';
			prod1.Family= 'A&A-CEM';
			prod1.IsActive=True;
			prod1.Partner_Visible__c=True;
			prod1.ProductCode='3HE10869AAAA';
			prod1.Apttus_Config2__Version__c= 1;
			prod1.Portfolio__c= 'Fixed Access - FBA';
			prod1.Pricing_Clusters__c='NAM';
			prod1.IsActive= True;
			insert prod1;

		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();	 
		insert opportunities;  
		Opportunity updatedOppty = new Opportunity();
		updatedOppty = opportunities[0];
		updatedOppty.Apttus_Approval__Approval_Status__c = 'Approved';
		updatedOppty.stageName = 'Create Offer (bid)';
		updatedOppty.Phase_Status__c = 'Submitted for G4 Approval';
		updatedOppty.No_Loa__c = true;
		updatedOppty.LOA_Level__c = 'A';
			
		//create a quote
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing';
		proposals[0].Is_List_Price_Only__c = true;
		
		// proposals[0].NokiaCPQ_Maintenance_Type__c = '';
		 proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
	  
	//  proposals[0].Reprice_In_Progress__c = false;
	
	
		insert proposals;	
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);
			
		proposals[0].Maintenance_Y1__c=2000;
		proposals[0].Maintenance_Y2__c=1000;
		proposals[0].SRS__c=20;
		proposals[0].SSP__c=10;
		update proposals;
		
		
		
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='GBP';
		priceList.Apttus_Config2__Active__c=true;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		insert priceList;
		
		// create a product configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
		insert prodConfigs;
		

		
		//productInst.IsActive = true;
	//  update productInst;
		
		
	// create a Line Item
		List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
		lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
		lineItems[0].Apttus_Config2__ProductId__c = prod.Id;
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
		lineItems[0].NokiaCPQ_Light_Color__c='Red';
		lineItems[0].NokiaCPQ_Floor_Price__c=100;
		lineItems[0].NokiaCPQ_Extended_CNP_Without_LSD__c=174;
		lineItems[0].NokiaCPQ_Is_Contracted_PLI__c=false;
		 lineItems[0].NokiaCPQ_Is_CLP_in_PDC__c=false;
		//lineItems[0].NokiaCPQ_ExtendedPrice_CUP__c=174;
		lineItems[0].is_Custom_Product__c=true;
		lineItems[0].is_Custom_Product__c=true;
		insert lineItems;
		lineItems[0].NokiaCPQ_Light_Color__c='RED';
		lineItems[0].NokiaCPQ_Floor_Price__c=null;
		update lineItems;
		
		
		
		
		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList[0].Apttus_Proposal__Product__c = prod.id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		insert proposalLineItemList;
		
		//create summarygroup
		Apttus_Config2__ProductConfiguration__c configRecord = new Apttus_Config2__ProductConfiguration__c();
		configRecord = prodConfigs.get(0);
		Apttus_Config2__SummaryGroup__c summarygrp= new Apttus_Config2__SummaryGroup__c(
		Apttus_Config2__ConfigurationId__c=configRecord.id,
		Name='Subtotal - Standard Price (One Time)',
		Apttus_Config2__NetPrice__c=20,
		Apttus_Config2__AdjustmentAmount__c=10,
		Apttus_Config2__ItemSequence__c=1,
		Apttus_Config2__LineNumber__c=2
		);
		insert summarygrp;
	
	  
		// Proposal Summary Group
		Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
		Apttus_QPConfig__ProposalId__c = proposals[0].id,
		Apttus_QPConfig__AdjustmentAmount__c = 0,
		CurrencyIsoCode = 'USD',
		Apttus_QPConfig__NetPrice__c = 100.00,
		Apttus_QPConfig__ItemSequence__c = 1,
		Apttus_QPConfig__LineNumber__c = 1,
		Apttus_QPConfig__ExtendedPrice__c = 100,
		name = 'Total (One Time)'
		);
		insert propSummaryGrp1;
			
			Apttus_Approval__Approval_Request__c appRequest = New Apttus_Approval__Approval_Request__c();
			appRequest.Apttus_Approval__Assigned_To_Type__c = 'User';
			appRequest.Apttus_Approval__Assigned_To__c = sysAdminUser[0].id;
			appRequest.Apttus_Approval__Initial_Submitter__c = sysAdminUser[0].id;
			appRequest.Apttus_Approval__Active__c = true;
			appRequest.Apttus_QPApprov__ProposalId__c = proposals[0].id;
			appRequest.Apttus_Approval__Approval_Status__c = 'Assigned';
			appRequest.Apttus_Approval__Backup_From_User__c = sysAdminUser[0].id;
			appRequest.Apttus_Approval__Object_Type__c = 'Apttus_Proposal__Proposal__c';
			appRequest.Apttus_Approval__RequestType__c = 'Standard';
			appRequest.Apttus_Approval__Sequence__c = '1';
			appRequest.CurrencyIsoCode = 'EUR';
			appRequest.NF_Assignee_Type__c = 'Approver';
			insert appRequest;
			System.debug('appRequest-->'+appRequest);
			
		
		 }		 
	}

public static testMethod void Testmethod1(){
	test.startTest();
   Apttus_Proposal__Proposal__c  QuoteProposal = [Select id,CurrencyIsoCode,Maintenance_Y1__c,Maintenance_Y2__c,SRS__c,SSP__c from Apttus_Proposal__Proposal__c limit 1];

	NokiaCPQ_dirQtMailController quoteApprovalCtrl = new NokiaCPQ_dirQtMailController();
	quoteApprovalCtrl.quoteId=QuoteProposal.id;
		 string Value=quoteApprovalCtrl.getQuoteAppvlDtls();
	//system.assertEquals('- Maintenance price override \n- Custom Product\n- Floor Price not maintained\n', Value);
	 test.stopTest();

	  }
	  

	  }