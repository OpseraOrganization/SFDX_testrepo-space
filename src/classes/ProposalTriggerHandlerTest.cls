/**
 * @description :
 * @author		  : Yashdeep Prajapati
 * @group   :
 * @last modified on  : 11-29-2021
 * @last modified by  : Yashdeep Prajapati
 * Modifications Log
 * Ver   Date		Author   Modification
 * 1.0   06-15-2021   Yashdeep Prajapati   Initial Version
 **/
@isTest(SeeAllData = false)
public class ProposalTriggerHandlerTest
{
static testMethod void ProposalTriggerHandlerTestIndirect() {
List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){
	//create account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
	insert accounts;
	List<Account> accounts1 = NOKIA_CPQ_TestDataFactory.getAccounts(1);
	accounts1[0].Acc_No__c = 'Testing1';
	accounts1[0].Partner_Program__c ='';
	accounts1[0].Partner_Type__c = '';
	accounts1[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	insert accounts1;
	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;

	//Create Opportunity
	List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
	opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities1[0].End_Customer_LE__c = accounts1[0].Id;
	opportunities1[0].Account_Role__c = 'GPP Distributor Partner';

	insert opportunities1;

	opportunities1[0].stageName = GlobalConstants.CREATE_OFFER;
	opportunities1[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
	opportunities1[0].No_Loa__c = true;
	opportunities1[0].Apttus_Approval__Approval_Status__c = 'Approved';
	update opportunities1;

	//Create Product
	List<Product2> prods = new List<Product2>();
	Product2 prod1 = new product2(
		Name = 'Test1',
		ProductCode = '123',
		Business_Group__c = 'MN',
		CurrencyIsoCode = 'USD',
		IsActive = false,
		NokiaCPQ_Item_Type__c='Software',
		Apttus_Config2__ConfigurationType__c='Bundle'

		);
	prods.add(prod1);

	Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List',
		Apttus_Config2__Active__c = True
		);
	insert ApttusTestPriceList;

	//create price list items
	List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__ChargeType__c = 'Standard Price'
		);
	//insert pLI1;
	plistItems.add(pLI1);
	test.startTest();
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
	proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing';		 //MN airscale wifi portfolio
	proposals[0].Apttus_Proposal__Approval_Stage__c = 'Draft';
	//proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Indirect Quote').getRecordTypeId();
	insert proposals;

	List<Apttus_Proposal__Proposal__c > proposals1 = NOKIA_CPQ_TestDataFactory.createProposal(1);

	proposals1[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals1[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
	proposals1[0].NokiaCPQ_Portfolio__c = 'IP Routing';		 //MN airscale wifi portfolio
	proposals1[0].Apttus_Proposal__Approval_Stage__c = 'Approved';

	insert proposals1;

	//create product configuration
	Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
		Name = 'APTTUS Test Config',
		Apttus_Config2__AccountId__c = accounts[0].Id,
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__Proposald__c = proposals[0].Id,
		Apttus_Config2__Status__c = 'New',
		Apttus_Config2__VersionNumber__c = 1,
		Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id),
		Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
	insert ProdConfig;

	//Create Line Items
	list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		NokiaCPQ_Spare__c=true,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,


		Apttus_Config2__AddedBy__c = 'added by code'
		);
	//insert LineItem2;
	allLineItems.add(LineItem1);
	Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 100.00,
		Apttus_Config2__ListPrice__c = 200,
		Apttus_Config2__Quantity__c = 1,
		NokiaCPQ_Spare__c=true,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,


		Apttus_Config2__AddedBy__c = 'added by code'
		);
	//insert LineItem1;
	allLineItems.add(LineItem2);
	Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		NokiaCPQ_Spare__c=true,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,

		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,


		Apttus_Config2__AddedBy__c = 'added by code'
		);
	//insert LineItem1;
	allLineItems.add(LineItem3);

	Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Maintenance Y1',
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		NokiaCPQ_Spare__c=true,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__Quantity__c = 1,

		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,


		Apttus_Config2__AddedBy__c = 'added by code'
		);
	//insert LineItem1;
	allLineItems.add(LineItem4);
	Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		NokiaCPQ_Spare__c=true,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,

		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,


		Apttus_Config2__AddedBy__c = 'added by code'
		);
	//insert LineItem1;
	allLineItems.add(LineItem5);
	Apttus_Config2__LineItem__c LineItem6 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__LineType__c = 'Option',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,

		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,


		Apttus_Config2__AddedBy__c = 'added by code'
		);
	//insert LineItem1;
	allLineItems.add(LineItem6);

	list<Apttus_Config2__LineItem__c> testAllLineItems1 = new List<Apttus_Config2__LineItem__c>();
	Apttus_Config2__LineItem__c testLineItem11 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price',
		Apttus_Config2__LineType__c = 'Option',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',

		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,

		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,


		Apttus_Config2__AddedBy__c = 'added by code'
		);

	testAllLineItems1.add(testLineItem11);
	insert testAllLineItems1;

	//Create summary Group
	//
	list<Apttus_Config2__SummaryGroup__c> allSummarygrps = new List<Apttus_Config2__SummaryGroup__c>();
	Apttus_Config2__SummaryGroup__c allSummarygrp1 =new Apttus_Config2__SummaryGroup__c(
		Name = 'Configurable Products',
		Apttus_Config2__LineNumber__c = 1,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__ConfigurationId__c = ProdConfig.Id,
		Apttus_Config2__ExtendedPrice__c = 600,
		Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
		Apttus_Config2__AdjustmentAmount__c = 100,
		Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__Frequency__c = 'One Time'

		);
	allSummarygrps.add(allSummarygrp1);
	Apttus_Config2__SummaryGroup__c allSummarygrp2 =new Apttus_Config2__SummaryGroup__c(
		Name = 'Configurable Products',
		Apttus_Config2__LineNumber__c = 2,
		Apttus_Config2__ItemSequence__c = 2,
		Apttus_Config2__ConfigurationId__c = ProdConfig.Id,
		Apttus_Config2__ExtendedPrice__c = 120,
		Apttus_Config2__Description__c = 'Maintenance Y1 (One Time) (One Time)',
		Apttus_Config2__AdjustmentAmount__c = 80,
		Apttus_Config2__ChargeType__c = 'Maintenance Y1',
		Apttus_Config2__Frequency__c = 'One Time'

		);

	allSummarygrps.add(allSummarygrp2);

	Apttus_Config2__SummaryGroup__c allSummarygrp4 =new Apttus_Config2__SummaryGroup__c(
		Name = 'Subtotal - Standard Price (One Time)',
		Apttus_Config2__LineNumber__c = 1,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__ConfigurationId__c = ProdConfig.Id,
		Apttus_Config2__ExtendedPrice__c = 600,
		Apttus_Config2__Description__c = 'Subtotal - Standard Price (One Time) - Standard Price (One Time)',
		Apttus_Config2__AdjustmentAmount__c = 100,
		Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__Frequency__c = 'One Time'

		);
	allSummarygrps.add(allSummarygrp4);
	insert allSummarygrps;
	ProposalTriggerHandler pt=new ProposalTriggerHandler();
	test.stopTest();
}}

static testmethod void Direct1(){
List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){

	//create a Account

	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);

	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	insert opportunities;

	opportunities[0].stageName = 'Win the Case (Negotiate)';
	opportunities[0].Phase_Status__c = 'Submitted for G5 Approval';
	opportunities[0].No_Loa__c = true;
	opportunities[0].LOA_Level__c = 'Loa';
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	update opportunities;



	// List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(2);
	//  proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	// proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	// proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	//  proposals[0].Reprice_In_Progress__c = false;
	//  proposals[0].RecordTypeId = '01241000001coFv'; //direct quote
	// proposals[0].Apttus_Proposal__Approval_Stage__c = 'In Review';
	//  insert proposals;
	// proposals[0].Apttus_Proposal__Approval_Stage__c = Nokia_CPQ_Constants.QUOTEAPPROVED;

	// update proposals;
	Apttus_Proposal__Proposal__c proposals = new Apttus_Proposal__Proposal__c();
	proposals.Apttus_Proposal__Proposal_Name__c='test proposal';
	proposals.Apttus_Proposal__Account__c = accounts[0].Id;
	proposals.Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals.NokiaCPQ_Needs_Reprice__c = false;
	proposals.Reprice_In_Progress__c = false;
	proposals.RecordTypeId = '01241000001coFv';		 //direct quote01241000001coFvAAI
	proposals.Apttus_Proposal__Approval_Stage__c = 'In Review';
	proposals.NokiaCPQ_Portfolio__c = 'Nokia Software';
	//  test.startTest();
	insert proposals;
	proposals.Apttus_Proposal__Approval_Stage__c = 'Approved';
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
	prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals.Id;
	prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
	prodConfigs[0].Apttus_Config2__BusinessObjectType__c = 'Proposal';
	insert prodConfigs;

	//get a IP Routing Product
	/*   Product2 productInst = new Product2();
				 productInst = [select Business_Group__c,Id,ProductCode from Product2 where name = 'Smart Plan Suite (SPS)' AND NokiaCPQ_State__c != null];

				  productInst.NokiaCPQ_Item_Type__c='Hardware';
				  productInst.NokiaCPQ_Classification2__c='Base';
		 productInst.Apttus_Config2__ConfigurationType__c='Bundle';
		   update productInst; */

	//List<Product2> prods1 = [select Business_Group__c,Id,ProductCode from Product2 where name = 'Smart Plan Suite (SPS)' ];
	List<Product2> prods1 = new List<Product2>();
	product2 prod1 = new product2();
	prod1.name = 'Smart Plan Suite (SPS)';
	prod1.CurrencyIsoCode = 'USD';
	prod1.IsActive=True;
	prod1.ProductCode='833-051870';
	prods1.add(prod1);

	product2 prod2 = new product2();
	prod2.name = 'Smart Plan Suite (SPS)';
	prod2.CurrencyIsoCode = 'USD';
	prod2.IsActive=True;
	prod2.ProductCode='833-051870_00';
	prods1.add(prod2);
	insert prods1;

	// create a Line Item
	List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
	lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
	lineItems[0].Apttus_Config2__ProductId__c = prods1[0].Id;
	lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
	test.startTest();
	insert lineItems;


	//create proposal line items
	//List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
	//proposalLineItemList[0].Apttus_Proposal__Product__c = prods1[0].id;
	//proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals.id;
	//insert proposalLineItemList;


	// Proposal Summary Group
	Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
		Apttus_QPConfig__ProposalId__c = proposals.id,
		Apttus_QPConfig__AdjustmentAmount__c = 0,
		CurrencyIsoCode = 'USD',
		Apttus_QPConfig__NetPrice__c = 100.00,
		Apttus_QPConfig__ItemSequence__c = 1,
		Apttus_QPConfig__LineNumber__c = 1,
		Apttus_QPConfig__ExtendedPrice__c = 100,
		name = 'Total (One Time)'
		);
	insert propSummaryGrp1;

	test.stopTest();

	//  ProposalTriggerHandler pt=new ProposalTriggerHandler();

	ProposalTriggerHandler.handleBeforeInsertTrigger(null);
	ProposalTriggerHandler.createServiceRecord(null,null);
	ProposalTriggerHandler.afterUpdateCPQTrigger(null,null);
	ProposalTriggerHandler.afterInsertCPQTrigger(null);
}

}
static testMethod void testProposalTriggerHandlerAprlIndir(){
	//create a Account
	List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){

	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);


	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;

	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	insert opportunities;

	opportunities[0].stageName = GlobalConstants.CREATE_OFFER;
	opportunities[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
	opportunities[0].No_Loa__c = true;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	update opportunities;

	List<Apttus_Proposal__Proposal__c> proposalList = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposalList[0].Apttus_Proposal__Approval_Stage__c = 'Approved';
	proposalList[0].CQ_Value__c = 0;
	proposalList[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposalList[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposalList[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	proposalList[0].Indirect_Approval_Required__c = true;

	Test.startTest();
	insert proposalList;
	Test.stopTest();
}
}
static testMethod void testProposalTriggerHandlerAprlDir(){
	//create a Account
	List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){

	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);

	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	insert opportunities;

	opportunities[0].stageName = GlobalConstants.CREATE_OFFER;
	opportunities[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
	opportunities[0].No_Loa__c = true;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	update opportunities;

	List<Apttus_Proposal__Proposal__c> proposalList = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposalList[0].Apttus_Proposal__Approval_Stage__c = 'In Review';
	proposalList[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposalList[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposalList[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();
	proposalList[0].NokiaCPQ_Approval_Required_Flag__c = true;
	proposalList[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	proposalList[0].NokiaCPQ_Existing_IONMaint_Contract__c='No';
	proposalList[0].NokiaCPQ_No_of_Years__c = '1';
	proposalList[0].NokiaCPQ_Maintenance_Type__c='Gold (Return for Exchange)';

	Test.startTest();
	insert proposalList;
	Test.stopTest();
}
}
static testMethod void test_CLLI(){
List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){
	//create a Account
	Test.startTest();
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);

	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	insert opportunities;

	opportunities[0].stageName = GlobalConstants.CREATE_OFFER;
	opportunities[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
	opportunities[0].No_Loa__c = true;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	update opportunities;


	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (USD)';
	priceList.CurrencyIsoCode='USD';
	priceList.Apttus_Config2__Active__c=true;
	priceList.PriceList_Type__c='CPQ';
	priceList.Apttus_Config2__Type__c='Standard';

	insert priceList;

	CPQ_CLLI_Master__c clli = new CPQ_CLLI_Master__c();
	clli.CPQ_Active__c = true;
	clli.CPQ_CLLI_Code__c = '123';
	clli.CPQ_CLLI_Key__c = '123';
	clli.CPQ_CLLI_Site_Name__c = '123';
	clli.CPQ_CLLI_Site_City__c = '123';
	clli.CPQ_CLLI_Site_State__c = '123';
	insert clli;
	CPQ_SSFBillingRuleMaster__c ssf = new CPQ_SSFBillingRuleMaster__c();
	ssf.CPQ_Billing_Rule_Code__c = 'SSFC';
	ssf.CPQ_Billing_Rule_Description__c = 'SSFDE';
	insert ssf;

	Id recTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_CQ_Quote').getRecordTypeId();
	List<Apttus_Proposal__Proposal__c> proposalList = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposalList[0].Apttus_Proposal__Approval_Stage__c = 'Draft';
	proposalList[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposalList[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposalList[0].RecordTypeId = recTypeId;
	proposalList[0].NokiaCPQ_Approval_Required_Flag__c = true;
	proposalList[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	proposalList[0].NokiaCPQ_Existing_IONMaint_Contract__c='No';
	proposalList[0].NokiaCPQ_No_of_Years__c = '1';
	proposalList[0].NokiaCPQ_Maintenance_Type__c='Gold (Return for Exchange)';
	proposalList[0].Apttus_QPConfig__ConfigurationFinalizedDate__c = System.today();
	proposalList[0].CPQ_Include_Transportation__c = true;
	insert proposalList;

	List<Apttus_Proposal__Proposal__c > insertedProposals = [select id,Apttus_Proposal__Opportunity__c,CPQ_Pricing_Pool__c,CPQ_SSF_Billing_Rule_ID__c,RecordTypeId,CPQ_Include_Transportation__c,Apttus_QPConfig__ConfigurationFinalizedDate__c,CPQ_CQ_Check__c,CPQ_CLLI_ID__c from Apttus_Proposal__Proposal__c where id = :proposalList[0].Id];
	ProposalTriggerHandler.handleBeforeInsertCQOperations(insertedProposals);
	Apttus_Proposal__Proposal__c oldProposal = insertedProposals[0];
	Apttus_Proposal__Proposal__c newProposal = insertedProposals[0];
	Map<Id, Apttus_Proposal__Proposal__c> proposalOldTrigger = new Map<Id, Apttus_Proposal__Proposal__c>();
	proposalOldTrigger.put(oldProposal.Id, oldProposal);

	List<Apttus_Proposal__Proposal__c> proposalNewTriggerList = new List<Apttus_Proposal__Proposal__c>();
	Apttus_Proposal__Proposal__c modifiedProp = new Apttus_Proposal__Proposal__c();
	modifiedProp.Id = insertedProposals[0].Id;
	modifiedProp.CPQ_CLLI_ID__c = clli.Id;
	modifiedProp.CPQ_SSF_Billing_Rule_ID__c = ssf.Id;
	modifiedProp.Apttus_Proposal__Opportunity__c = insertedProposals[0].Apttus_Proposal__Opportunity__c;
	modifiedProp.Apttus_QPConfig__ConfigurationFinalizedDate__c = insertedProposals[0].Apttus_QPConfig__ConfigurationFinalizedDate__c;
	modifiedProp.RecordTypeId = insertedProposals[0].RecordTypeId;
	modifiedProp.CPQ_Include_Transportation__c = true;
	proposalNewTriggerList.add(modifiedProp);

	ProposalTriggerHandler.handleBeforeUpdateCQOperations(proposalNewTriggerList, proposalOldTrigger);

	Test.stopTest();
}
}
static testMethod void test_Pricing_Pool(){
	//create a Account
	List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){

	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);

	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	insert opportunities;

	opportunities[0].stageName = GlobalConstants.CREATE_OFFER;
	opportunities[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
	opportunities[0].No_Loa__c = true;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	update opportunities;

	CPQ_PricingPool__c pool = new CPQ_PricingPool__c();
	pool.CPQ_Pricing_Pool_Name__c = 'AAA Pool';
	pool.CPQ_Active__c = true;
	insert pool;

	Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
	pl.Name = 'Test PL';
	pl.Apttus_Config2__Active__c = true;
	insert pl;

	CPQ_CLLI_Master__c clli = new CPQ_CLLI_Master__c();
	clli.CPQ_Active__c = true;
	clli.CPQ_CLLI_Code__c = '123';
	clli.CPQ_CLLI_Key__c = '123';
	clli.CPQ_CLLI_Site_Name__c = '123';
	clli.CPQ_CLLI_Site_City__c = '123';
	clli.CPQ_CLLI_Site_State__c = '123';
	insert clli;
	CPQ_SSFBillingRuleMaster__c ssf = new CPQ_SSFBillingRuleMaster__c();
	ssf.CPQ_Billing_Rule_Code__c = 'SSFC';
	ssf.CPQ_Billing_Rule_Description__c = 'SSFDE';
	insert ssf;

	CPQ_Pricing_Pool_Agreement_Map__c aggr = new CPQ_Pricing_Pool_Agreement_Map__c();
	aggr.CPQ_Active__c = true;
	aggr.CPQ_Agreement_Name__c = pl.Id;
	aggr.CPQ_Pricing_Pool_Id__c = pool.Id;
	insert aggr;
	Test.startTest();
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_ION_Maintenance_Type__c = '';
	proposals[0].NokiaCPQ_Maintenance_Type__c='';
	proposals[0].NokiaCPQ_Existing_FN_Maint_Contract__c  = '';
	proposals[0].NokiaCPQ_FN_Maintenance_Type__c= '';
	proposals[0].CurrencyIsoCode ='USD';
	proposals[0].Apttus_Proposal__Approval_Stage__c = 'Draft';
	proposals[0].Creation_Date__c = system.today();
	proposals[0].NokiaCPQ_Portfolio__c = '';
	proposals[0].NokiaCPQ_No_of_Years__c='';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c ='';
	proposals[0].NokiaCPQ_SSP_Level__c='';
	proposals[0].CPQ_Pricing_Pool__c = 'AAA Pool';
	proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_CQ_Quote').getRecordTypeId();
	proposals[0].Apttus_QPConfig__ConfigurationFinalizedDate__c = System.today();
	insert proposals;

	List<Apttus_Proposal__Proposal__c > insertedProposals = [select id,Apttus_QPConfig__ConfigurationFinalizedDate__c,Apttus_Proposal__Opportunity__c,CPQ_CQ_Check__c,CPQ_Pricing_Pool__c,CPQ_Contractual_Condition_Updated__c,CPQ_CLLI_ID__c,CPQ_Include_Transportation__c,CPQ_SSF_Billing_Rule_ID__c,RecordTypeId from Apttus_Proposal__Proposal__c where id = :proposals[0].Id];

	//ProposalTriggerHandler.handleBeforeInsertCQOperations(insertedProposals);

	Map<Id, Apttus_Proposal__Proposal__c> proposalOldTrigger = new Map<Id, Apttus_Proposal__Proposal__c>();
	proposalOldTrigger.put(insertedProposals[0].Id, insertedProposals[0]);

	System.debug('ksks inserted prop CPQ_CQ_Check__c : ' + insertedProposals[0].CPQ_CQ_Check__c);
	System.debug('ksks inserted prop pool : ' + insertedProposals[0].CPQ_Pricing_Pool__c);

	List<Apttus_Proposal__Proposal__c> proposalNewTriggerList = new List<Apttus_Proposal__Proposal__c>();
	Apttus_Proposal__Proposal__c modifiedProp = new Apttus_Proposal__Proposal__c();
	modifiedProp.Id = insertedProposals[0].Id;
	modifiedProp.RecordTypeId = insertedProposals[0].RecordTypeId;
	modifiedProp.CPQ_Pricing_Pool__c = 'AAA';
	modifiedProp.CPQ_Contractual_Condition_Updated__c = insertedProposals[0].CPQ_Contractual_Condition_Updated__c;
	modifiedProp.CPQ_Include_Transportation__c = true;
	modifiedProp.Apttus_QPConfig__ConfigurationFinalizedDate__c = insertedProposals[0].Apttus_QPConfig__ConfigurationFinalizedDate__c;
	modifiedProp.Apttus_Proposal__Opportunity__c = insertedProposals[0].Apttus_Proposal__Opportunity__c;
	modifiedProp.CPQ_CLLI_ID__c = clli.Id;
	modifiedProp.CPQ_SSF_Billing_Rule_ID__c = ssf.Id;
	modifiedProp.CPQ_Include_Transportation__c = true;
	proposalNewTriggerList.add(modifiedProp);

	ProposalTriggerHandler.handleBeforeUpdateCQOperations(proposalNewTriggerList, proposalOldTrigger);

	ProposalTriggerHandler.deleteQuotecontractualdiscounts(proposalNewTriggerList);
	Test.stopTest();
}
}
static testMethod void testSitePhaseCopyOnProposalClone(){
	//create a Account
List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);

	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	insert opportunities;

	opportunities[0].stageName = GlobalConstants.CREATE_OFFER;
	opportunities[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
	opportunities[0].No_Loa__c = true;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	update opportunities;

	List<Apttus_Proposal__Proposal__c> proposalList = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposalList[0].Apttus_Proposal__Approval_Stage__c = 'In Review';
	proposalList[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposalList[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposalList[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();
	proposalList[0].NokiaCPQ_Approval_Required_Flag__c = true;
	proposalList[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	proposalList[0].NokiaCPQ_Existing_IONMaint_Contract__c='No';
	proposalList[0].NokiaCPQ_No_of_Years__c = '1';
	proposalList[0].NokiaCPQ_Maintenance_Type__c='Gold (Return for Exchange)';

	Test.startTest();
	insert proposalList;
	Apttus_Proposal__Proposal__c updateQte = new Apttus_Proposal__Proposal__c();
	updateQte = proposalList[0];
	updateQte.id = null;
	updateQte.NokiaCPQ_Orignal_Quote_Id__c = null;
	updateQte.NokiaCPQ_Is_cloned__c = false;
	insert updateQte;
	system.debug('updateQte-' + updateQte);

	updateQte.NokiaCPQ_Orignal_Quote_Id__c = proposalList[0].Id;
	updateQte.NokiaCPQ_Is_cloned__c = true;
	update updateQte;
	delete updateQte;
	system.debug('proposalList-' + proposalList);
	Test.stopTest();
}}
}