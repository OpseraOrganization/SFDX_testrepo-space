/**
 * @description	   : 
 * @author			: Yashdeep Prajapati
 * @group			 : 
 * @last modified on  : 03-01-2022
 * @last modified by  : Yashdeep Prajapati
**/
@isTest(seealldata=false)
public with sharing class NokiaCPQ_Validate_Quote_CtrlrTestDirect {
/***********************
 * Method Name: validateQuoteController_InitTest1
 * Description: To cover the method inti method of vf page controller class: NokiaCPQ_Validate_Quote_Ctrlr
 * Parameters: NA
 ************************/

static testmethod void validateQuoteController_InitTestDirect001(){
	//List<User> PartnerUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Partner Profile');
	//insert PartnerUser;
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
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	insert opportunities;

	Opportunity updatedOppty = new Opportunity();
	updatedOppty = opportunities[0];
	updatedOppty.Apttus_Approval__Approval_Status__c = 'Approved';
	updatedOppty.stageName = 'Create Offer (bid)';
	updatedOppty.Phase_Status__c = 'Submitted for G4 Approval';
	updatedOppty.No_Loa__c = true;
	updatedOppty.LOA_Level__c = 'A';

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[0].Accreditation_Type__c = 'Maintenance';
	accreditations[0].Accreditation_Level__c = 'Premium';
	accreditations[0].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	// system.runAs(PartnerUser[0])
	{
		//create a quote
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing';
		proposals[0].Is_List_Price_Only__c = true;
		proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c =true;
		proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
		proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		// proposals[0].NokiaCPQ_Maintenance_Type__c = '';
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();  //direct quote

		//  proposals[0].Reprice_In_Progress__c = false;


		insert proposals;
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);


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

		//get a IP Routing Product
		Product2 productInst = new Product2();
		//productInst = [SELECT Id, NAME, IsActive, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
		productInst.Name = 'Product9';
		productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
		productInst.NokiaCPQ_State__c = 'Release';
		insert productInst;

		//productInst.IsActive = true;
		//  update productInst;


		// create a Line Item
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
		lineItems[0].NokiaCPQ_Extended_floor_price__c = 200;
		lineItems[0].NokiaCPQ_Extended_CNP_Non_Contracted__c = 250;
		lineItems[0].NokiaCPQ_Is_CLP_in_PDC__c = false;
		lineItems[0].NokiaCPQ_Is_Contracted_PLI__c = false;
		lineItems[0].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
		lineItems[0].Apttus_Config2__AddedBy__c = 'added by code';
		insert lineItems;

		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		insert proposalLineItemList;


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
		//Summary Group
		Apttus_Config2__SummaryGroup__c SummaryGrp1 = new Apttus_Config2__SummaryGroup__c(
			Apttus_Config2__AdjustmentAmount__c = 10,
			CurrencyIsoCode = 'USD',
			name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Apttus_Config2__ItemSequence__c =1,
			Apttus_Config2__LineNumber__c=1
								  // NokiaCPQ_Guidance_Traffic_Light__c='Red'
			);
		insert SummaryGrp1;

		ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
		ApexPages.currentPage().getParameters().put('oppId',opportunities[0].Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();
		test.stopTest();

	}
}
static testmethod void validateQuoteController_InitTest6(){
	List<user> runUSer = TestDataFactory.userCreation(1,'System Administrator');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
	//create a Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='30130230312';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);

	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
	//opportunities[0].StageName = 'Handover (Prepare for Delivery)';
	//opportunities[0].Phase_Status__c = 'Submitted for G6 Approval';
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	insert opportunities;

	/*opportunities[0].StageName = 'Create Offer (Bid)';
	opportunities[0].Phase_Status__c = 'Offer in Progress';
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].StageName='Create Offer (Bid)';
	//opportunities[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities[0].LOA_Level__c = '';
	opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities[0].G2_Approval_Date__c = Date.Today();

	opportunities[0].G3_Planned_Date__c =  Date.Today();
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';

	opportunities[0].G4_Planned_Date__c =  Date.Today();

	update opportunities[0];
	system.debug(opportunities[0].StageName);
	system.debug(opportunities[0].Phase_Status__c);
		*/
	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[0].NokiaCPQ_No_of_Years__c = '1';

	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	//proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
	insert proposals;
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);

	//create a quote Line Item
	List<Apttus_Proposal__Proposal_Line_Item__c > proposalsLineItem = NOKIA_CPQ_TestDataFactory.createProposalLineItem(2);
	proposalsLineItem[0].Apttus_Proposal__Proposal__c = proposals[0].id;
	//insert proposalsLineItem;

	proposalsLineItem[1].Apttus_Proposal__Proposal__c = proposals[0].id;
	proposalsLineItem[1].Apttus_QPConfig__LineType__c = 'Option';
	proposalsLineItem[1].Item_Type_From_CAT__c = 'Offer';
	proposalsLineItem[1].Apttus_QPConfig__NetAdjustmentPercent__c = 1;
	insert proposalsLineItem;

	//get a Price List
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='GBP';
	priceList.Apttus_Config2__Active__c=false;
	priceList.PriceList_Type__c='CPQ';
	priceList.Apttus_Config2__Type__c='Standard';

	insert priceList;

	// create a product configuration
	List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
	prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
	prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
	prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
	prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
	insert prodConfigs;

	//get a IP Routing Product
	/*
	List<Product2> productInst = NOKIA_CPQ_TestDataFactory.productCreation(1);
	productInst[0].Portfolio__c= proposals[0].NokiaCPQ_Portfolio__c;
	productInst[0].NokiaCPQ_State__c = 'Implement';
	insert productInst;
	 */
	Product2 productInst = new Product2();
	// productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
	productInst.Name = 'Product9';
	productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
	productInst.NokiaCPQ_State__c = 'Release';
	insert productInst;

	// create a Line Item
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


	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	test.stopTest();
}
}

static testmethod void validateQuoteController_InitTest5(){
	List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
	//create a Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='30130230313';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);

	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
	//opportunities[0].StageName = 'Win the Case (Negotiate)';
	//opportunities[0].StageName = 'Create Offer (Bid)';
	//opportunities[0].Phase_Status__c = 'Pending Win/Loss Declaration';
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].CurrencyIsoCode='EUR';
	opportunities[0].No_Loa__c=true;
	insert opportunities;


	/*opportunities[0].StageName = 'Create Offer (Bid)';
	opportunities[0].Phase_Status__c = 'Offer in Progress';
	//opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].StageName='Create Offer (Bid)';
	//  opportunities[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities[0].LOA_Level__c = '';
	opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities[0].G2_Approval_Date__c = Date.Today();

	opportunities[0].G3_Planned_Date__c =  Date.Today();
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';

	opportunities[0].G4_Planned_Date__c =  Date.Today();

	update opportunities[0];
	system.debug(opportunities[0].StageName);
	system.debug(opportunities[0].Phase_Status__c);
		*/
	Offer__c offer = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Pre_approved_Price_List_for_Acc_Managers__c = true,
		LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
		Opportunity__c = opportunities[0].Id
		);
	insert offer;



	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c =true;
	proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[0].NokiaCPQ_No_of_Years__c = '1';
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	//proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
	insert proposals;
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);

	//create a quote Line Item
	//List<Apttus_Proposal__Proposal_Line_Item__c > proposalsLineItem = NOKIA_CPQ_TestDataFactory.createProposalLineItem(2);
	//proposalsLineItem[0].Apttus_Proposal__Proposal__c = proposals[0].id;
	//insert proposalsLineItem;

	//proposalsLineItem[1].Apttus_Proposal__Proposal__c = proposals[0].id;
	//proposalsLineItem[1].Apttus_QPConfig__LineType__c = 'Option';
	//proposalsLineItem[1].Item_Type_From_CAT__c = 'Offer';
	//proposalsLineItem[1].Apttus_QPConfig__NetAdjustmentPercent__c = 1;
	//insert proposalsLineItem;

	Apttus_QPConfig__ProposalSummaryGroup__c ProposalSummaryGroupobj = new Apttus_QPConfig__ProposalSummaryGroup__c();
	ProposalSummaryGroupobj.Name  = 'Total (One Time)';
	ProposalSummaryGroupobj.Apttus_QPConfig__AdjustmentAmount__c = 1;
	ProposalSummaryGroupobj.Apttus_QPConfig__ProposalId__c = proposals[0].id;
	ProposalSummaryGroupobj.Apttus_QPConfig__ItemSequence__c=1;
	ProposalSummaryGroupobj.Apttus_QPConfig__LineNumber__c=1;
	insert ProposalSummaryGroupobj;
	//get a Price List
	/*
		 Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		 priceList.Name='Global Price List (EUR)';
		 priceList.CurrencyIsoCode='GBP';
		 priceList.Apttus_Config2__Active__c=false;
		 priceList.PriceList_Type__c='CPQ';
		 priceList.Apttus_Config2__Type__c='Standard';

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
		 productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];

		 // create a Line Item
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
	 */

	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	test.stopTest();
	}
}


static testmethod void validateQuoteController_InitTest7(){
	List<user> runUSer = TestDataFactory.userCreation(1,'System Administrator');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
	//create a Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='30130230314';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);

	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
	//opportunities[0].StageName = 'Handover (Prepare for Delivery)';
	//opportunities[0].Phase_Status__c = 'Pending Win/Loss Declaration';
	//opportunities[0].Phase_Status__c='Submitted for G6 Approval';
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	insert opportunities;

	/*opportunities[0].StageName = 'Create Offer (Bid)';
	opportunities[0].Phase_Status__c = 'Offer in Progress';
	// opportunities[0].End_Customer_LE__c = account3[1].id;
	opportunities[0].StageName='Create Offer (Bid)';
	//opportunities[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities[0].LOA_Level__c = '';
	opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities[0].G2_Approval_Date__c = Date.Today();

	opportunities[0].G3_Planned_Date__c =  Date.Today();
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';

	opportunities[0].G4_Planned_Date__c =  Date.Today();

	update opportunities[0];


	system.debug(opportunities[0].StageName);
	system.debug(opportunities[0].Phase_Status__c);
	*/
	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = true;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[0].NokiaCPQ_No_of_Years__c = '1';
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	//proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
	insert proposals;
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);


	//get a Price List
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='GBP';
	priceList.Apttus_Config2__Active__c=false;
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

	//get a IP Routing Product
	Product2 productInst = new Product2();
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
	productInst.Name = 'Product7';
	productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
	productInst.NokiaCPQ_State__c = 'Release';
	insert productInst;

	// create a Line Item
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


	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	test.stopTest();
}
}

static testmethod void validateQuoteController_InitTest8(){
	List<user> runUSer = TestDataFactory.userCreation(1,'System Administrator');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
	//create a Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='30130230315';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);

	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
	//opportunities[0].StageName = 'Handover (Prepare for Delivery)';
	//opportunities[0].Phase_Status__c = 'Pending Win/Loss Declaration';
	//opportunities[0].Phase_Status__c='Submitted for G6 Approval';
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	insert opportunities;


	/*opportunities[0].StageName = 'Create Offer (Bid)';
	opportunities[0].Phase_Status__c = 'Offer in Progress';
	//opportunities[0].End_Customer_LE__c = account3[1].id;
	opportunities[0].StageName='Create Offer (Bid)';
	//opportunities[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities[0].LOA_Level__c = '';
	opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities[0].G2_Approval_Date__c = Date.Today();

	opportunities[0].G3_Planned_Date__c =  Date.Today();
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';

	opportunities[0].G4_Planned_Date__c =  Date.Today();

	update opportunities[0];


	system.debug(opportunities[0].StageName);
	system.debug(opportunities[0].Phase_Status__c);
	*/
	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[0].NokiaCPQ_No_of_Years__c = '1';
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	//proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
	insert proposals;
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);


	//get a Price List
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='GBP';
	priceList.Apttus_Config2__Active__c=false;
	priceList.PriceList_Type__c='CPQ';
	priceList.Apttus_Config2__Type__c='Standard';

	insert priceList;

	// create a product configuration
	List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
	prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
	prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
	prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
	prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
	prodConfigs[0].Apttus_Config2__Status__c = 'Ready For Finalization';
	insert prodConfigs;

	//get a IP Routing Product
	Product2 productInst = new Product2();
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
	productInst.Name = 'Product10';
	productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
	productInst.NokiaCPQ_State__c = 'Release';
	insert productInst;

	// create a Line Item
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


	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	test.stopTest();
}
}

static testmethod void validateQuoteController_InitTest9(){
	List<user> runUSer = TestDataFactory.userCreation(1,'System Administrator');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
	//create a Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='30130230316';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);

	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
	//opportunities[0].StageName = 'Create Offer (Bid)';
	//opportunities[0].No_Loa__c = false;
	//opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	insert opportunities;

	/*opportunities[0].StageName = 'Create Offer (Bid)';
	opportunities[0].Phase_Status__c = 'Offer in Progress';
	//  opportunities[0].End_Customer_LE__c = account3[1].id;
	opportunities[0].StageName='Create Offer (Bid)';
	//opportunities[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities[0].LOA_Level__c = '';
	opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities[0].G2_Approval_Date__c = Date.Today();

	opportunities[0].G3_Planned_Date__c =  Date.Today();
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';

	opportunities[0].G4_Planned_Date__c =  Date.Today();

	update opportunities[0];
	*/


	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[0].NokiaCPQ_No_of_Years__c = '1';
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	//proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
	insert proposals;
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);

	/*
	Apttus_QPConfig__ProposalSummaryGroup__c ProposalSummaryGroupobj = new Apttus_QPConfig__ProposalSummaryGroup__c();
		 ProposalSummaryGroupobj.Name  = 'Total (One Time)';
		 ProposalSummaryGroupobj.Apttus_QPConfig__NetPrice__c = 1 ;
		 insert ProposalSummaryGroupobj;
	 */
	//get a Price List
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='GBP';
	priceList.Apttus_Config2__Active__c=false;
	priceList.PriceList_Type__c='CPQ';
	priceList.Apttus_Config2__Type__c='Standard';

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
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
	productInst.Name = 'Product8';
	productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
	productInst.NokiaCPQ_State__c = 'Release';
	insert productInst;

	// create a Line Item
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


	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	test.stopTest();
}
}

static testmethod void validateQuoteController_InitTest10(){
	List<user> runUSer = TestDataFactory.userCreation(1,'System Administrator');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
	//create a Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='30130230317';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);

	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
	//opportunities[0].StageName = 'Create Offer (Bid)';
	//opportunities[0].No_Loa__c = false;
	//opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	insert opportunities;

	/*opportunities[0].StageName = 'Create Offer (Bid)';
	opportunities[0].Phase_Status__c = 'Offer in Progress';
	//opportunities[0].End_Customer_LE__c = account3[1].id;
	opportunities[0].StageName='Create Offer (Bid)';
	//opportunities[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities[0].LOA_Level__c = '';
	opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities[0].G2_Approval_Date__c = Date.Today();

	opportunities[0].G3_Planned_Date__c =  Date.Today();
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';

	opportunities[0].G4_Planned_Date__c =  Date.Today();

	update opportunities[0];
	*/


	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[0].NokiaCPQ_No_of_Years__c = '1';
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	//proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
	insert proposals;
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);


	Apttus_QPConfig__ProposalSummaryGroup__c ProposalSummaryGroupobj = new Apttus_QPConfig__ProposalSummaryGroup__c();
	ProposalSummaryGroupobj.Name  = 'Total (One Time)';
	ProposalSummaryGroupobj.Apttus_QPConfig__NetPrice__c = 10;
	ProposalSummaryGroupobj.NokiaCPQ_DOD__c = 2;
	ProposalSummaryGroupobj.NokiaCPQ_DPD__c = 2;
	ProposalSummaryGroupobj.Apttus_QPConfig__ProposalId__c = proposals[0].id;
	ProposalSummaryGroupobj.Apttus_QPConfig__ItemSequence__c = 2;
	ProposalSummaryGroupobj.Apttus_QPConfig__LineNumber__c = 1;
	insert ProposalSummaryGroupobj;

	//get a Price List
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='GBP';
	priceList.Apttus_Config2__Active__c=false;
	priceList.PriceList_Type__c='CPQ';
	priceList.Apttus_Config2__Type__c='Standard';

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
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
	productInst.Name = 'Product3';
	productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
	productInst.NokiaCPQ_State__c = 'Release';
	insert productInst;

	// create a Line Item
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


	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	test.stopTest();
}
}

static testmethod void validateQuoteController_InitTest11(){
	//User sysAdminUser = TestDataFactory.createSystemAdminUser();
	// System.runAs(sysAdminUser){
	//create Account
	List<Account>accounts=NOKIA_CPQ_TestDataFactory.getAccounts(2);
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
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	insert opportunities;

	opportunities[0].stageName = 'Create Offer (bid)';
	opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
	opportunities[0].LOA_Level__c = 'A';
	opportunities[0].No_Loa__c = true;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	update opportunities;

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[0].Accreditation_Type__c = 'Maintenance';
	accreditations[0].Accreditation_Level__c = 'Premium';
	accreditations[0].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[0].NokiaCPQ_No_of_Years__c = '1';
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	//proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
	insert proposals;
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);

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

	//get a IP Routing Product
	Product2 productInst = new Product2();
	//productInst = [SELECT Id, NAME, IsActive, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c,NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
	productInst.Name = 'Product1';
	productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
	productInst.NokiaCPQ_State__c = 'Release';
	insert productInst;

	productInst.IsActive = true;
	update productInst;


	// create a Line Item
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

	//create proposal line items
	List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
	proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
	proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
	insert proposalLineItemList;


	// Proposal Summary Group
	Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
		Apttus_QPConfig__ProposalId__c = proposals[0].id,
		CurrencyIsoCode = 'USD',
		Apttus_QPConfig__NetPrice__c = 100.00,
		Apttus_QPConfig__ItemSequence__c = 1,
		Apttus_QPConfig__LineNumber__c = 1,
		Apttus_QPConfig__ExtendedPrice__c = 100,
		name = 'Total (One Time)'
		);
	insert propSummaryGrp1;


	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	test.stopTest();
}


//************************************************ For Direct
static testmethod void validateQuoteController_InitTest22Direct(){
	//List<User> PartnerUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Partner Profile');
	//insert PartnerUser;
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
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	insert opportunities;

	Opportunity updatedOppty = new Opportunity();
	updatedOppty = opportunities[0];
	updatedOppty.Apttus_Approval__Approval_Status__c = 'Approved';
	updatedOppty.stageName = 'Create Offer (bid)';
	updatedOppty.Phase_Status__c = 'Submitted for G4 Approval';
	updatedOppty.No_Loa__c = true;
	updatedOppty.LOA_Level__c = 'A';

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[0].Accreditation_Type__c = 'Maintenance';
	accreditations[0].Accreditation_Level__c = 'Premium';
	accreditations[0].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	// system.runAs(PartnerUser[0])
	{
		//create a quote
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].NokiaCPQ_Portfolio__c = 'Airscale Wifi';
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Enhanced';
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();  //direct quote
		proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c =true;
		//proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
		proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'NO';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		//  proposals[0].Reprice_In_Progress__c = false;


		insert proposals;
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);


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

		//get a IP Routing Product
		Product2 productInst = new Product2();
		//productInst = [SELECT Id, NAME, IsActive, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
		productInst.Name = 'Product20';
		productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
		productInst.NokiaCPQ_State__c = 'Release';
		insert productInst;

		//productInst.IsActive = true;
		//  update productInst;


		// create a Line Item
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

		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		insert proposalLineItemList;


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

		//Summary Group
		Apttus_Config2__SummaryGroup__c SummaryGrp1 = new Apttus_Config2__SummaryGroup__c(
			Apttus_Config2__AdjustmentAmount__c = 10,
			CurrencyIsoCode = 'USD',
			name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Apttus_Config2__ItemSequence__c =1,
			Apttus_Config2__LineNumber__c=1
								  // NokiaCPQ_Guidance_Traffic_Light__c='Red'
			);
		insert SummaryGrp1;

		ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
		ApexPages.currentPage().getParameters().put('oppId',opportunities[0].Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();
		test.stopTest();

	}
}

static testmethod void validateQuoteController_InitTest221Direct(){
	//List<User> PartnerUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Partner Profile');
	//insert PartnerUser;
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
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities[0].stageName = 'Create Offer (bid)';
	opportunities[0].Phase_Status__c = 'Offer in Progress';
	opportunities[0].No_Loa__c = true;
	opportunities[0].LOA_Level__c = 'A';
	insert opportunities;


	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[0].Accreditation_Type__c = 'Maintenance';
	accreditations[0].Accreditation_Level__c = 'Premium';
	accreditations[0].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	// system.runAs(PartnerUser[0])
	{
		//create a quote
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].NokiaCPQ_Portfolio__c = 'Airscale Wifi';
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Enhanced';
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
		proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c =true;
		//proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
		proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'NO';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		//  proposals[0].Reprice_In_Progress__c = false;


		insert proposals;
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);

		/*
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

	 //get a IP Routing Product
	 Product2 productInst = new Product2();
	 productInst = [SELECT Id, NAME, IsActive, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];

	 //productInst.IsActive = true;
	 //  update productInst;


	 // create a Line Item
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

	 //create proposal line items
	 List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
	 proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
	 proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
	 insert proposalLineItemList;


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
		 */

		ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
		ApexPages.currentPage().getParameters().put('oppId',opportunities[0].Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();
		test.stopTest();

	}
}



static testmethod void validateQuoteController_InitTest220Direct(){
	//List<User> PartnerUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Partner Profile');
	//insert PartnerUser;
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
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	insert opportunities;

	Opportunity updatedOppty = new Opportunity();
	updatedOppty = opportunities[0];
	updatedOppty.Apttus_Approval__Approval_Status__c = 'Approved';
	updatedOppty.stageName = 'Create Offer (bid)';
	updatedOppty.Phase_Status__c = 'Submitted for G4 Approval';
	updatedOppty.No_Loa__c = true;
	updatedOppty.LOA_Level__c = 'A';

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[0].Accreditation_Type__c = 'Maintenance';
	accreditations[0].Accreditation_Level__c = 'Premium';
	accreditations[0].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	// system.runAs(PartnerUser[0])
	{
		//create a quote
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = true;
		proposals[0].NokiaCPQ_Portfolio__c = 'Airscale Wifi';
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Enhanced';

		proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c =true;
		//proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
		proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'NO';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote

		//  proposals[0].Reprice_In_Progress__c = false;


		insert proposals;
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);


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

		//get a IP Routing Product
		Product2 productInst = new Product2();
		//productInst = [SELECT Id, NAME, IsActive, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
		productInst.Name = 'Product21';
		productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
		productInst.NokiaCPQ_State__c = 'Release';
		insert productInst;

		//productInst.IsActive = true;
		//  update productInst;


		// create a Line Item
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

		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		insert proposalLineItemList;


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

		//Summary Group
		Apttus_Config2__SummaryGroup__c SummaryGrp1 = new Apttus_Config2__SummaryGroup__c(
			Apttus_Config2__AdjustmentAmount__c = 10,
			CurrencyIsoCode = 'USD',
			name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Apttus_Config2__ItemSequence__c =1,
			Apttus_Config2__LineNumber__c=1
								  // NokiaCPQ_Guidance_Traffic_Light__c='Red'
			);
		insert SummaryGrp1;

		ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
		ApexPages.currentPage().getParameters().put('oppId',opportunities[0].Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();
		test.stopTest();

	}
}

static testmethod void validateQuoteController_InitTest21Direct(){
	//List<User> PartnerUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Partner Profile');
	//insert PartnerUser;
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
	opportunities[0].stageName = 'Create Offer (Bid)';
	opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
	// opportunities[0].LOA_Level__c = 'A';
	opportunities[0].No_Loa__c = false;
	opportunities[0].LOA_Level__c = '';
	// opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';

	update opportunities;


	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[0].Accreditation_Type__c = 'Maintenance';
	accreditations[0].Accreditation_Level__c = 'Premium';
	accreditations[0].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	// system.runAs(PartnerUser[0])
	{
		//create a quote
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].NokiaCPQ_Portfolio__c = 'Airscale Wifi';
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Enhanced';
		//proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
		proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'NO';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
		proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c =true;
		//  proposals[0].Reprice_In_Progress__c = false;


		insert proposals;

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

		//get a IP Routing Product
		Product2 productInst = new Product2();
		//productInst = [SELECT Id, NAME, IsActive, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
		productInst.Name = 'Product21';
		productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
		productInst.NokiaCPQ_State__c = 'Release';
		insert productInst;

		//productInst.IsActive = true;
		//  update productInst;


		// create a Line Item
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

		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		insert proposalLineItemList;


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

		//Summary Group
		Apttus_Config2__SummaryGroup__c SummaryGrp1 = new Apttus_Config2__SummaryGroup__c(
			Apttus_Config2__AdjustmentAmount__c = 10,
			CurrencyIsoCode = 'USD',
			name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Apttus_Config2__ItemSequence__c =1,
			Apttus_Config2__LineNumber__c=1
								  // NokiaCPQ_Guidance_Traffic_Light__c='Red'
			);
		insert SummaryGrp1;

		ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
		ApexPages.currentPage().getParameters().put('oppId',opportunities[0].Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();
		test.stopTest();

	}

}

static testmethod void validateQuoteController_InitTest24Direct(){
	/* List<User> PartnerUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Partner Profile');
		 insert PartnerUser;*/
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
	// opportunities[0].LOA_Level__c = 'A';
	opportunities[0].No_Loa__c = true;
	opportunities[0].LOA_Level__c = 'Loa';
	// opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';

	update opportunities;

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[0].Accreditation_Type__c = 'Maintenance';
	accreditations[0].Accreditation_Level__c = 'Premium';
	accreditations[0].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	// system.runAs(PartnerUser[0])
	{
		//create a quote
		system.debug('Accnt' + accounts[0].Id + opportunities[0].Id);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].Reprice_In_Progress__c = false;
		proposals[0].NokiaCPQ_Portfolio__c = 'Airscale Wifi';
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Enhanced';
		//proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
		proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'NO';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
		proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c =true;

		insert proposals;
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);


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

		//get a IP Routing Product
		Product2 productInst = new Product2();
		//productInst = [SELECT Id, NAME, IsActive, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
		productInst.Name = 'Product19';
		productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
		productInst.NokiaCPQ_State__c = 'Release';
		insert productInst;

		//productInst.IsActive = true;
		//  update productInst;


		// create a Line Item
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

		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		insert proposalLineItemList;


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
		//Summary Group
		Apttus_Config2__SummaryGroup__c SummaryGrp1 = new Apttus_Config2__SummaryGroup__c(
			Apttus_Config2__AdjustmentAmount__c = 10,
			CurrencyIsoCode = 'USD',
			name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Apttus_Config2__ItemSequence__c =1,
			Apttus_Config2__LineNumber__c=1
								  // NokiaCPQ_Guidance_Traffic_Light__c='Red'
			);
		insert SummaryGrp1;

		ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
		ApexPages.currentPage().getParameters().put('oppId',opportunities[0].Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();
		test.stopTest();

	}
}

static testmethod void validateQuoteController_InitTest26Direct(){
	/* List<User> PartnerUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Partner Profile');
		 insert PartnerUser;*/
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
	opportunities[0].stageName =GlobalConstants.CREATE_OFFER;
	opportunities[0].Phase_Status__c = GlobalConstants.SUBMITTED_FOR_G4_APPROVAL;
	// opportunities[0].LOA_Level__c = 'A';
	opportunities[0].No_Loa__c = true;
	//  opportunities[0].LOA_Level__c = '';
	// opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';

	update opportunities;

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[0].Accreditation_Type__c = 'Maintenance';
	accreditations[0].Accreditation_Level__c = 'Premium';
	accreditations[0].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	// system.runAs(PartnerUser[0])
	{
		//create a quote
		system.debug('Accnt' + accounts[0].Id + opportunities[0].Id);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].Reprice_In_Progress__c = false;
		proposals[0].NokiaCPQ_Portfolio__c = 'Airscale Wifi';
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Enhanced';
		//proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
		proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'NO';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
		proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c =true;

		insert proposals;
		proposals[0].Apttus_Proposal__Approval_Stage__c='In Review';
		update proposals;
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);


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

		//get a IP Routing Product
		Product2 productInst = new Product2();
		//productInst = [SELECT Id, NAME, IsActive, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
		productInst.Name = 'Product18';
		productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
		productInst.NokiaCPQ_State__c = 'Release';
		insert productInst;

		//productInst.IsActive = true;
		//  update productInst;


		// create a Line Item
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

		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		insert proposalLineItemList;


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
		//Summary Group
		Apttus_Config2__SummaryGroup__c SummaryGrp1 = new Apttus_Config2__SummaryGroup__c(
			Apttus_Config2__AdjustmentAmount__c = 10,
			CurrencyIsoCode = 'USD',
			name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Apttus_Config2__ItemSequence__c =1,
			Apttus_Config2__LineNumber__c=1
								  // NokiaCPQ_Guidance_Traffic_Light__c='Red'
			);
		insert SummaryGrp1;

		ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
		ApexPages.currentPage().getParameters().put('oppId',opportunities[0].Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();

		objControllerClass.currentBatchStatus();
		objControllerClass.cancel();
		test.stopTest();

	}
}


static testmethod void validateQuoteController_InitTest260Direct(){
	/* List<User> PartnerUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Partner Profile');
		 insert PartnerUser;*/
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
	opportunities[0].stageName =GlobalConstants.CREATE_OFFER;
	opportunities[0].Phase_Status__c = GlobalConstants.SUBMITTED_FOR_G4_APPROVAL;
	opportunities[0].LOA_Level__c = 'A';
	opportunities[0].No_Loa__c = false;
	//  opportunities[0].LOA_Level__c = '';
	// opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';

	update opportunities;

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[0].Accreditation_Type__c = 'Maintenance';
	accreditations[0].Accreditation_Level__c = 'Premium';
	accreditations[0].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	// system.runAs(PartnerUser[0])
	{
		//create a quote
		system.debug('Accnt' + accounts[0].Id + opportunities[0].Id);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].Reprice_In_Progress__c = false;
		proposals[0].NokiaCPQ_Portfolio__c = 'Airscale Wifi';
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Enhanced';
		//proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
		proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'NO';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();  //direct quote

		proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c =true;
		insert proposals;
		proposals[0].Apttus_Proposal__Approval_Stage__c='In Review';
		update proposals;
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);


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

		//get a IP Routing Product
		Product2 productInst = new Product2();
		//productInst = [SELECT Id, NAME, IsActive, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
		productInst.Name = 'Product18';
		productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
		productInst.NokiaCPQ_State__c = 'Release';
		insert productInst;

		//productInst.IsActive = true;
		//  update productInst;


		// create a Line Item
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

		//create proposal line items
		//List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		//proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
		//proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		//insert proposalLineItemList;


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

		//Summary Group
		Apttus_Config2__SummaryGroup__c SummaryGrp1 = new Apttus_Config2__SummaryGroup__c(
			Apttus_Config2__AdjustmentAmount__c = 10,
			CurrencyIsoCode = 'USD',
			name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Apttus_Config2__ItemSequence__c =1,
			Apttus_Config2__LineNumber__c=1
								  // NokiaCPQ_Guidance_Traffic_Light__c='Red'
			);
		insert SummaryGrp1;

		ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
		ApexPages.currentPage().getParameters().put('oppId',opportunities[0].Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();

		objControllerClass.currentBatchStatus();
		objControllerClass.cancel();
		test.stopTest();

	}
}


static testmethod void validateQuoteController_InitTest2800Direct(){
	/* List<User> PartnerUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Partner Profile');
		 insert PartnerUser;*/
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
	opportunities[0].stageName =GlobalConstants.CREATE_OFFER;
	opportunities[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
	//   opportunities[0].LOA_Level__c = 'C';
	opportunities[0].No_Loa__c = true;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';


	update opportunities;
	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[0].Accreditation_Type__c = 'Maintenance';
	accreditations[0].Accreditation_Level__c = 'Premium';
	accreditations[0].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	// system.runAs(PartnerUser[0])
	{
		//create a quote
		system.debug('Accnt' + accounts[0].Id + opportunities[0].Id);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].Reprice_In_Progress__c = false;
		proposals[0].NokiaCPQ_Portfolio__c = 'Airscale Wifi';
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Enhanced';
		proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c =true;
		//proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
		proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'NO';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
		insert proposals;


		/* proposals[0].Apttus_Proposal__Approval_Stage__c='In Review';
				  update proposals;*/
			
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);


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

		//get a IP Routing Product
		Product2 productInst = new Product2();
		//productInst = [SELECT Id, NAME, IsActive, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
		productInst.Name = 'Product16';
		productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
		productInst.NokiaCPQ_State__c = 'Release';
		insert productInst;

		//productInst.IsActive = true;
		//  update productInst;


		// create a Line Item
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


		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		proposalLineItemList[0].Apttus_QPConfig__NetAdjustmentPercent__c = 1;
		proposalLineItemList[0].Apttus_QPConfig__ChargeType__c = 'Standard Price';
		insert proposalLineItemList;


		// Proposal Summary Group
		Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
			Apttus_QPConfig__ProposalId__c = proposals[0].id,
			Apttus_QPConfig__AdjustmentAmount__c = 0,
			CurrencyIsoCode = 'USD',
			Apttus_QPConfig__NetPrice__c = 100.00,
			Apttus_QPConfig__ItemSequence__c = 1,
			Apttus_QPConfig__LineNumber__c = 1,
			Apttus_QPConfig__ExtendedPrice__c = 100,
			name = 'Grand Total'
			);
		insert propSummaryGrp1;
		//Summary Group
		Apttus_Config2__SummaryGroup__c SummaryGrp1 = new Apttus_Config2__SummaryGroup__c(
			Apttus_Config2__AdjustmentAmount__c = 10,
			CurrencyIsoCode = 'USD',
			name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Apttus_Config2__ItemSequence__c =1,
			Apttus_Config2__LineNumber__c=1
								  // NokiaCPQ_Guidance_Traffic_Light__c='Red'
			);
		insert SummaryGrp1;

		ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
		ApexPages.currentPage().getParameters().put('oppId',opportunities[0].Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();
		objControllerClass.currentBatchStatus();
		objControllerClass.cancel();
		test.stopTest();

	}
}

static testmethod void validateQuoteController_InitTest2801Direct(){
	/* List<User> PartnerUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Partner Profile');
		 insert PartnerUser;*/
			List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
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
	opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';

	insert opportunities;
	opportunities[0].stageName =GlobalConstants.CREATE_OFFER;
	opportunities[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
	opportunities[0].LOA_Level__c = 'C';
	opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';

	update opportunities;

	Offer__c offer = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = false,
		Pre_approved_Price_List_for_Acc_Managers__c = true,
		LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
		Opportunity__c = opportunities[0].Id
		);
	insert offer;

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[0].Accreditation_Type__c = 'Maintenance';
	accreditations[0].Accreditation_Level__c = 'Premium';
	accreditations[0].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	// system.runAs(PartnerUser[0])
	{
		//create a quote
		system.debug('Accnt' + accounts[0].Id + opportunities[0].Id);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].Reprice_In_Progress__c = false;
		proposals[0].NokiaCPQ_Portfolio__c = 'Airscale Wifi';
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Enhanced';
		//proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
		proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'NO';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c =true;
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
		insert proposals;


		/* proposals[0].Apttus_Proposal__Approval_Stage__c='In Review';
				  update proposals;*/
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);


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

		//get a IP Routing Product
		Product2 productInst = new Product2();
		//productInst = [SELECT Id, NAME, IsActive, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
		productInst.Name = 'Product17';
		productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
		productInst.NokiaCPQ_State__c = 'Release';
		insert productInst;

		//productInst.IsActive = true;
		//  update productInst;


		// create a Line Item
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


		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		proposalLineItemList[0].Apttus_QPConfig__NetAdjustmentPercent__c = 1;
		proposalLineItemList[0].Apttus_QPConfig__ChargeType__c = 'Standard Price';
		insert proposalLineItemList;


		// Proposal Summary Group
		Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
			Apttus_QPConfig__ProposalId__c = proposals[0].id,
			Apttus_QPConfig__AdjustmentAmount__c = 0,
			CurrencyIsoCode = 'USD',
			Apttus_QPConfig__NetPrice__c = 100.00,
			Apttus_QPConfig__ItemSequence__c = 1,
			Apttus_QPConfig__LineNumber__c = 1,
			Apttus_QPConfig__ExtendedPrice__c = 100,
			name = 'Grand Total'
			);
		insert propSummaryGrp1;

		//Summary Group
		Apttus_Config2__SummaryGroup__c SummaryGrp1 = new Apttus_Config2__SummaryGroup__c(
			Apttus_Config2__AdjustmentAmount__c = 10,
			CurrencyIsoCode = 'USD',
			name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Apttus_Config2__ItemSequence__c =1,
			Apttus_Config2__LineNumber__c=1
								  // NokiaCPQ_Guidance_Traffic_Light__c='Red'
			);
		insert SummaryGrp1;
		ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
		ApexPages.currentPage().getParameters().put('oppId',opportunities[0].Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();
		objControllerClass.currentBatchStatus();
		objControllerClass.cancel();
		test.stopTest();

	}
}
}

static testmethod void validateQuoteController_InitTestIndirect1000001(){
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
	//create opportunity
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].Id;
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';

	insert opportunities;

	opportunities[0].stageName = GlobalConstants.CREATE_OFFER;
	opportunities[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
	opportunities[0].No_Loa__c = true;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	update opportunities;



	/*opportunities[0].stageName = 'Win the Case (Negotiate)';
	opportunities[0].Phase_Status__c = 'Pending Win/Loss Declaration';
	opportunities[0].LOA_Level__c = 'Test';
	opportunities[0].No_Loa__c = true ;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';

	//opportunities[1].stageName = 'Handover (Prepare for Delivery)';
	//opportunities[1].Phase_Status__c = 'Offer in Progress';
	//opportunities[1].LOA_Level__c = 'A';
	//opportunities[1].No_Loa__c = true;
	//opportunities[1].Apttus_Approval__Approval_Status__c = 'Approved';
	update opportunities;*/
	/*
	Offer__c offer = new Offer__c(
	No_LoA__c = false,
	ActiveOffer__c =true,
	Authorized_for_Pricing_Manager__c = true,
	Pre_approved_Price_List_for_Acc_Managers__c = false,
	LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
	Opportunity__c = opportunities[1].Id
	);
	insert offer;
	 */
	//create Accreditation
	
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[0].NokiaCPQ_No_of_Years__c = '1';
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	//proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
	//   proposals[0].NokiaCPQ_Total_Quote_Discount__c=0;
	insert proposals;
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);

	//get a Price List
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='GBP';
	priceList.Apttus_Config2__Active__c=false;
	priceList.PriceList_Type__c='CPQ';
	priceList.Apttus_Config2__Type__c='Standard';

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
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
	productInst.Name = 'Product13';
	productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
	productInst.NokiaCPQ_State__c = 'Release';
	insert productInst;

	// create a Line Item
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

	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	test.stopTest();
}


static testmethod void validateQuoteController_InitTestIndirect1000002(){
	List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
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
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(2,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[1].End_Customer_LE__c = accounts[1].id;
	insert opportunities;
	opportunities[0].stageName = 'Win the Case (Negotiate)';
	//opportunities[0].Phase_Status__c = 'Pending Win/Loss Declaration';
	opportunities[0].LOA_Level__c = 'Test';
	opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';

	opportunities[1].stageName = 'Win the Case (Negotiate)';
	//opportunities[1].Phase_Status__c = 'Pending Win/Loss Declaration';
	opportunities[1].LOA_Level__c = 'A';
	opportunities[1].No_Loa__c = false;
	opportunities[1].Apttus_Approval__Approval_Status__c = 'Approved';
	update opportunities;

	Offer__c offer = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = true,
		Pre_approved_Price_List_for_Acc_Managers__c = false,
		//LOA_Bypass__c = 'Authorized for Pricing Manager',
		Opportunity__c = opportunities[0].Id
		);
	insert offer;

	Offer__c offer1 = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = false,
		//Pre_approved_Price_List_for_Acc_Managers__c = true,
		//LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
		Opportunity__c = opportunities[1].Id
		);
	insert offer1;
	test.startTest();
	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;

/*	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(1);
				accreditations[0].partner__c = accounts[0].Id;
				//accreditations[1].partner__c = accounts[0].Id;
				accreditations[0].Accreditation_Type__c = 'Maintenance';
				accreditations[0].Accreditation_Level__c = 'Premium';
				accreditations[0].Pricing_Level_Override__c = 'Premium';
		// accreditations[0].Partner_Program__c = 'GPP 3.0';
				insert accreditations;
 */
	/*  List<Accreditation__c > accreditations2 = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	   accreditations2[0].partner__c = accounts[0].Id;
	   //accreditations2[1].partner__c = accounts[0].Id;
	   accreditations2[0].Accreditation_Type__c = 'Product';
	   accreditations2[0].Accreditation_Level__c = 'Premium';
	   accreditations2[0].Pricing_Level_Override__c = 'Premium';
	   insert accreditations2;*/

	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[0].NokiaCPQ_No_of_Years__c = '1';
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	//proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
	//   proposals[0].NokiaCPQ_Total_Quote_Discount__c=0;
	insert proposals;
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);

	//get a Price List
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='GBP';
	priceList.Apttus_Config2__Active__c=false;
	priceList.PriceList_Type__c='CPQ';
	priceList.Apttus_Config2__Type__c='Standard';

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
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
	productInst.Name = 'Product12';
	productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
	productInst.NokiaCPQ_State__c = 'Release';
	insert productInst;

	// create a Line Item
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

	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	test.stopTest();
}
}



static testmethod void validateQuoteController_InitTestIndirect1000000(){
	List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
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
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(2,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[1].End_Customer_LE__c = accounts[1].id;
	opportunities[1].Account_Role__c = 'GPP Distributor Partner';
	insert opportunities;
	
	opportunities[0].stageName = 'Win the Case (Negotiate)';
	opportunities[0].Phase_Status__c = 'Offer Submitted to Customer (Manual)';
	opportunities[0].LOA_Level__c = '';
	opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';

	opportunities[1].stageName = 'Create Offer (bid)';
	opportunities[1].Phase_Status__c = 'Offer in Progress';
	opportunities[1].LOA_Level__c = 'A';
	opportunities[1].No_Loa__c = false;
	opportunities[1].Apttus_Approval__Approval_Status__c = 'Approved';
	update opportunities;

	Offer__c offer = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = true,
		Pre_approved_Price_List_for_Acc_Managers__c = false,
		LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
		Opportunity__c = opportunities[1].Id
		);
	insert offer;

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[0].NokiaCPQ_No_of_Years__c = '1';
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	//proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
	//   proposals[0].NokiaCPQ_Total_Quote_Discount__c=0;
	insert proposals;
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);

	//get a Price List
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='GBP';
	priceList.Apttus_Config2__Active__c=false;
	priceList.PriceList_Type__c='CPQ';
	priceList.Apttus_Config2__Type__c='Standard';

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
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
	productInst.Name = 'Product15';
	productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
	productInst.NokiaCPQ_State__c = 'Release';
	insert productInst;

	// create a Line Item
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

	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	test.stopTest();
}
}

static testmethod void validateQuoteController_InitTestIndirect1000000IN(){
	List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
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
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(2,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[1].End_Customer_LE__c = accounts[1].id;
	insert opportunities;
	opportunities[0].stageName = 'Win the Case (Negotiate)';
	opportunities[0].Phase_Status__c = 'Offer Submitted to Customer (Manual)';
	opportunities[0].LOA_Level__c = '';
	opportunities[0].No_Loa__c = true;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';

	opportunities[1].stageName = 'Create Offer (bid)';
	opportunities[1].Phase_Status__c = 'Offer in Progress';
	opportunities[1].LOA_Level__c = 'A';
	opportunities[1].No_Loa__c = true;
	opportunities[1].Apttus_Approval__Approval_Status__c = 'Approved';
	update opportunities;

	Offer__c offer = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = true,
		Pre_approved_Price_List_for_Acc_Managers__c = false,
		LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
		Opportunity__c = opportunities[1].Id
		);
	insert offer;

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[0].NokiaCPQ_No_of_Years__c = '1';
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	//proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
	//   proposals[0].NokiaCPQ_Total_Quote_Discount__c=0;
	insert proposals;
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);

	//get a Price List
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='GBP';
	priceList.Apttus_Config2__Active__c=false;
	priceList.PriceList_Type__c='CPQ';
	priceList.Apttus_Config2__Type__c='Standard';

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
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
	productInst.Name = 'Product14';
	productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
	productInst.NokiaCPQ_State__c = 'Release';
	insert productInst;

	// create a Line Item
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

	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	test.stopTest();
}
}
static testmethod void validateQuoteController_InitTestIndirect10IN(){
	List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
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
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(2,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[1].End_Customer_LE__c = accounts[1].id;
	insert opportunities;
	
	opportunities[0].stageName = 'Win the Case (Negotiate)';
	opportunities[0].Phase_Status__c = 'Offer Submitted to Customer (Manual)';
	opportunities[0].LOA_Level__c = 'C';
	opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';

	opportunities[1].stageName = 'Create Offer (bid)';
	opportunities[1].Phase_Status__c = 'Offer in Progress';
	opportunities[1].LOA_Level__c = 'A';
	opportunities[1].No_Loa__c = false;
	opportunities[1].Apttus_Approval__Approval_Status__c = 'Approved';
	update opportunities;

	Offer__c offer = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = true,
		Pre_approved_Price_List_for_Acc_Managers__c = false,
		LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
		Opportunity__c = opportunities[1].Id
		);
	insert offer;

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[0].NokiaCPQ_No_of_Years__c = '1';
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	//proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
	//   proposals[0].NokiaCPQ_Total_Quote_Discount__c=0;
	insert proposals;
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);

	//get a Price List
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='GBP';
	priceList.Apttus_Config2__Active__c=false;
	priceList.PriceList_Type__c='CPQ';
	priceList.Apttus_Config2__Type__c='Standard';

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
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
	productInst.Name = 'Product1';
	productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
	productInst.NokiaCPQ_State__c = 'Release';
	insert productInst;

	// create a Line Item
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

	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	test.stopTest();
}
}
static testmethod void validateQuoteController_InitTestIndirect011IN(){
	List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
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
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(2,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[1].End_Customer_LE__c = accounts[1].id;
	insert opportunities;
	
	opportunities[0].stageName = 'Win the Case (Negotiate)';
	opportunities[0].Phase_Status__c = 'Offer Submitted to Customer (Manual)';
	opportunities[0].LOA_Level__c = '';
	opportunities[0].No_Loa__c = true;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';

	opportunities[1].stageName = 'Create Offer (bid)';
	opportunities[1].Phase_Status__c = 'Offer in Progress';
	opportunities[1].LOA_Level__c = '';
	opportunities[1].No_Loa__c = true;
	opportunities[1].Apttus_Approval__Approval_Status__c = 'Approved';
	update opportunities;

	Offer__c offer = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = true,
		Pre_approved_Price_List_for_Acc_Managers__c = false,
		LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
		Opportunity__c = opportunities[1].Id
		);
	insert offer;

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[0].NokiaCPQ_No_of_Years__c = '1';
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
	//proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
	//   proposals[0].NokiaCPQ_Total_Quote_Discount__c=0;
	insert proposals;
	system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);

	//get a Price List
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='GBP';
	priceList.Apttus_Config2__Active__c=false;
	priceList.PriceList_Type__c='CPQ';
	priceList.Apttus_Config2__Type__c='Standard';

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
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
	productInst.Name = 'Product3';
	productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
	productInst.NokiaCPQ_State__c = 'Release';
	insert productInst;

	// create a Line Item
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

	// Proposal Summary Group
	Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
		Apttus_QPConfig__ProposalId__c = proposals[0].id,
		Apttus_QPConfig__AdjustmentAmount__c = 1,
		CurrencyIsoCode = 'USD',
		Apttus_QPConfig__NetPrice__c = 100.00,
		Apttus_QPConfig__ItemSequence__c = 1,
		Apttus_QPConfig__LineNumber__c = 1,
		Apttus_QPConfig__ExtendedPrice__c = 100,
		name = 'Total (One Time)'
		);
	insert propSummaryGrp1;

	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	test.stopTest();
}
}

static testmethod void initTestEnterprise001(){

	List<User> userList = new List<User>();
	userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	system.runas(userList[0]){

		List<Account> accounts = getAccountLE();

		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities[0].StageName = GlobalConstants.CREATE_OFFER;
		opportunities[0].No_Loa__c = true;
		opportunities[0].Phase_Status__c='Offer in Progress';
		opportunities[0].LOA_Level__c='A';
		opportunities[0].Account_Role__c = 'GPP Distributor Partner';
		insert opportunities;

		test.startTest();
		List<Apttus_Proposal__Proposal__c> proposals = getproposals(opportunities[0]);
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);


		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (USD)';
		priceList.CurrencyIsoCode='USD';
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

		//get a IP Routing Product
		Product2 productInst = new Product2();
		//productInst = [SELECT Id, NAME, IsActive, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
		productInst.Name = 'Product5';
		productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
		productInst.NokiaCPQ_State__c = 'Release';
		insert productInst;

		//productInst.IsActive = true;
		//  update productInst;


		// create a Line Item
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
		lineItems[0].NokiaCPQ_Light_Color__c = 'Red';
		insert lineItems;

		Apttus_Config2__ProductConfiguration__c pd = [select id,NokiaCPQ_Count_Of_Red_Lights__c from Apttus_Config2__ProductConfiguration__c where id = :prodConfigs[0].Id];
		system.debug('config red ligth:'+pd.NokiaCPQ_Count_Of_Red_Lights__c);
		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		insert proposalLineItemList;



		// Proposal Summary Group
		Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
			Apttus_QPConfig__ProposalId__c = proposals[0].id,
			Apttus_QPConfig__AdjustmentAmount__c = 0,
			CurrencyIsoCode = 'USD',
			Apttus_QPConfig__NetPrice__c = 100.00,
			Apttus_QPConfig__ItemSequence__c = 1,
			Apttus_QPConfig__LineNumber__c = 1,
			Apttus_QPConfig__ExtendedPrice__c = 100,
			name = 'Subtotal - Standard Price (One Time)'
			);
		insert propSummaryGrp1;

		// Proposal Summary Group
		Apttus_Config2__SummaryGroup__c SummaryGrp1 = new Apttus_Config2__SummaryGroup__c(
			Apttus_Config2__AdjustmentAmount__c = 10,
			CurrencyIsoCode = 'USD',
			name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Apttus_Config2__ItemSequence__c =1,
			Apttus_Config2__LineNumber__c=1
								  // NokiaCPQ_Guidance_Traffic_Light__c='Red'
			);
		insert SummaryGrp1;

		System.debug('summary d: '+propSummaryGrp1.NokiaCPQ_Guidance_Traffic_Light__c);

		ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
		ApexPages.currentPage().getParameters().put('oppId',opportunities[0].Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();
		test.stopTest();
	}
}

static testmethod void initTestEnterprise002(){

	List<User> userList = new List<User>();
	userList = TestDataFactory.userCreation(1,'Data Loader Profile');
	system.runas(userList[0]){

		List<Account> accounts = getAccountLE();

		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities[0].StageName = GlobalConstants.CREATE_OFFER;
		opportunities[0].No_Loa__c = true;
		opportunities[0].Phase_Status__c='Offer in Progress';
		opportunities[0].LOA_Level__c='A';
		opportunities[0].Account_Role__c = 'GPP Distributor Partner';
		insert opportunities;

		test.startTest();
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();

		{
			proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
			proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
			proposals[0].NokiaCPQ_Needs_Reprice__c = false;
			proposals[0].Reprice_In_Progress__c = false;
			proposals[0].Is_List_Price_Only__c = false;
			proposals[0].CurrencyIsoCode ='USD';
			proposals[0].Exchange_Rate__c = 1.8;
			proposals[0].Apttus_Proposal__Approval_Stage__c = 'Approved';
			proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c =true;
			proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
			proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
			proposals[0].NokiaCPQ_No_of_Years__c = '1';
			insert proposals;

			//get a Price List
			Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
			priceList.Name='Global Price List (USD)';
			priceList.CurrencyIsoCode='USD';
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

			//get a IP Routing Product
			Product2 productInst = new Product2();
			//productInst = [SELECT Id, NAME, IsActive, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
			productInst.Name = 'Product4';
			productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
			productInst.NokiaCPQ_State__c = 'Release';
			insert productInst;

			//productInst.IsActive = true;
			//  update productInst;


			// create a Line Item
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
			lineItems[0].NokiaCPQ_Light_Color__c = 'Red';
			insert lineItems;

			Apttus_Config2__ProductConfiguration__c pd = [select id,NokiaCPQ_Count_Of_Red_Lights__c from Apttus_Config2__ProductConfiguration__c where id = :prodConfigs[0].Id];
			system.debug('config red ligth:'+pd.NokiaCPQ_Count_Of_Red_Lights__c);
			//create proposal line items
			List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
			proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
			proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
			insert proposalLineItemList;



			// Proposal Summary Group
			Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
	Apttus_QPConfig__ProposalId__c = proposals[0].id,
	Apttus_QPConfig__AdjustmentAmount__c = 0,
	CurrencyIsoCode = 'USD',
	Apttus_QPConfig__NetPrice__c = 100.00,
	Apttus_QPConfig__ItemSequence__c = 1,
	Apttus_QPConfig__LineNumber__c = 1,
	Apttus_QPConfig__ExtendedPrice__c = 100,
	name = 'Subtotal - Standard Price (One Time)'
	);
			insert propSummaryGrp1;

			// Proposal Summary Group
			Apttus_Config2__SummaryGroup__c SummaryGrp1 = new Apttus_Config2__SummaryGroup__c(
	Apttus_Config2__AdjustmentAmount__c = 10,
	CurrencyIsoCode = 'USD',
	name = 'Subtotal - Standard Price (One Time)',
	Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
	Apttus_Config2__ItemSequence__c =1,
	Apttus_Config2__LineNumber__c=1
								   // NokiaCPQ_Guidance_Traffic_Light__c='Red'
	);
			insert SummaryGrp1;

			System.debug('summary d: '+propSummaryGrp1.NokiaCPQ_Guidance_Traffic_Light__c);

			ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
			ApexPages.currentPage().getParameters().put('oppId',opportunities[0].Id);
			NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
			objControllerClass.init();
			test.stopTest();
		}
	}
}

static testmethod void directBatchStatus(){
	/* List<User> PartnerUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Partner Profile');
		 insert PartnerUser;*/
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
	
	opportunities[0].stageName = 'Create Offer (Bid)';
	opportunities[0].Phase_Status__c = 'Offer in Progress';

	opportunities[0].LOA_Level__c = GlobalConstants.LOA_BYPASS_LEVEL;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';

	update opportunities;
	


	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[0].Accreditation_Type__c = 'Maintenance';
	accreditations[0].Accreditation_Level__c = 'Premium';
	accreditations[0].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();

	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();

	{
		//create a quote
		system.debug('Accnt' + accounts[0].Id + opportunities[0].Id);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].Reprice_In_Progress__c = false;
		proposals[0].Is_List_Price_Only__c = false;
		proposals[0].CurrencyIsoCode ='USD';
		proposals[0].Exchange_Rate__c = 5;
		proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
		proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = true;
		insert proposals;

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

		//get a IP Routing Product
		Product2 productInst = new Product2();
		//productInst = [SELECT Id, NAME, IsActive, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
		productInst.Name = 'Product6';
		productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
		productInst.NokiaCPQ_State__c = 'Release';
		insert productInst;

		list<Apttus_Config2__LineItem__c> LineItemList = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = priceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price',
			//Portfolio_from_Quote_Line_Item__c = 'Nokia Software',
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = productInst.Id,
			// Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			NokiaCPQ_Light_Color__c = 'Green',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			NokiaCPQ_Extended_floor_price__c = 200,
			NokiaCPQ_Extended_CNP_Non_Contracted__c = 250,
			NokiaCPQ_Is_CLP_in_PDC__c = false,
			NokiaCPQ_Is_Contracted_PLI__c = false,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__PricingStatus__c = 'Pending',
			Apttus_Config2__AddedBy__c = 'added by code'
			);


		insert LineItem1;
		LineItemList.add(LineItem1);

		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		insert proposalLineItemList;


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
		//Summary Group
		Apttus_Config2__SummaryGroup__c SummaryGrp1 = new Apttus_Config2__SummaryGroup__c(
			Apttus_Config2__AdjustmentAmount__c = 10,
			CurrencyIsoCode = 'USD',
			name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Apttus_Config2__ItemSequence__c =1,
			Apttus_Config2__LineNumber__c=1
								  // NokiaCPQ_Guidance_Traffic_Light__c='Red'
			);
		insert SummaryGrp1;


		Direct_Portfolio_General_Setting__mdt mdt = new Direct_Portfolio_General_Setting__mdt(
			Approval_Based_On_Traffic_Lights__c = false
			);


		ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
		ApexPages.currentPage().getParameters().put('oppId',opportunities[0].Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();
		objControllerClass.currentBatchstatus();
		objControllerClass.init();
		objControllerClass.loaBypass = true;
		objControllerClass.currentBatchstatus();
		test.stopTest();
	}
}

private static List<Account> getAccountLE(){
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;
	return accounts;
}
static List<Apttus_Proposal__Proposal__c> getproposals(Opportunity Oppty){

	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	proposals[0].Apttus_Proposal__Account__c = Oppty.AccountId;
	proposals[0].Apttus_Proposal__Opportunity__c = Oppty.Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing';
	proposals[0].Is_List_Price_Only__c = false;
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();		 //direct quote
	proposals[0].NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)';
	proposals[0].Apttus_Proposal__Approval_Stage__c = Nokia_CPQ_Constants.ApprovalRequired;
	proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = true;
	proposals[0].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[0].NokiaCPQ_No_of_Years__c = '1';
	insert proposals;
	return proposals;
}
/*
   static testmethod void validateQuoteController_InitTest11(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='301030872123654789123456789';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		List<Account> acclist = new List<Account>();
		acclist.add(accounts[0]);

		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
		opportunities[0].StageName = 'Identify Opportunity';
		//opportunities[0].No_Loa__c = false;
		//opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		opportunities[0].Account_Role__c = 'GPP Distributor Partner';
		insert opportunities;

		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';
		insert accreditations;
		test.startTest();
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].Reprice_In_Progress__c = false;
		//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
		proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
		insert proposals;
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);



		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='GBP';
		priceList.Apttus_Config2__Active__c=false;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';

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
		productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];

		// create a Line Item
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


		ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
		ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();
		test.stopTest();

   }

 */

/***********************
 * Method Name: validateQuoteController_InitTest1
 * Description: To cover the method inti method of vf page controller class: NokiaCPQ_Validate_Quote_Ctrlr(Authorized_for_Pricing_manager__c > 0) ;
 * Parameters: NA
 ************************/
/*static testmethod void validateQuoteController_InitDirectTest6()
   {
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;

		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities[0].Account_Role__c = 'GPP Distributor Partner';
		insert opportunities;

		Opportunity updatedOppty = new Opportunity();
		updatedOppty = opportunities[0];
		updatedOppty.Apttus_Approval__Approval_Status__c = 'Approved';
		updatedOppty.stageName = 'Create Offer (bid)';
		updatedOppty.Phase_Status__c = 'Offer in Progress';
		updatedOppty.No_Loa__c = false;
   //  updatedOppty.Business_Type__c = 'Standard Opportunity';
   // updatedOppty.LOA_Level__c = 'A';
		update updatedOppty;
		//create offer
		 Offer__c offer = new Offer__c(
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = true,
		//LOA_Bypass__c = 'Authorized for Pricing Manager',
		Opportunity__c = opportunities[0].Id
		);
		insert offer;
		 opportunity opportunities1 = [select id,stageName,phase_Status__c,Authorized_for_Pricing_Manager__c,Pre_approved_Price_List_for_AM__c from opportunity where id =: opportunities[0].Id];
		 system.debug(' opportunities[0].Id>>'+opportunities1.Authorized_for_Pricing_Manager__c+ ' ' +opportunities1.Pre_approved_Price_List_for_AM__c);
		// system.debug('Authorized for Pricing Manager'+opportunities[0].Authorized for Pricing Manager+ ' '+Pre_approved_Price_List_for_AM__c == 0);
		 //create a quote
		 test.startTest();
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].NokiaCPQ_Portfolio__c = 'Airscale Wifi';
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Enhanced';
   proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
		insert proposals;

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

		//get a Direct Products
   //  Product2 productInst = new Product2();
   //   productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
				List<product2> productInst = NOKIA_CPQ_TestDataFactory.productCreationDirect(1);
				insert productInst;
		// create a Line Item
		List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
		lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
		lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
		lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
		insert lineItems;

		// Create Summary Group
		Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
		Apttus_QPConfig__ProposalId__c = proposals[0].Id,
		CurrencyIsoCode = 'USD',
		Apttus_QPConfig__NetPrice__c = 100.00,
		Apttus_QPConfig__ItemSequence__c = 1,
		Apttus_QPConfig__LineNumber__c = 1,
		Apttus_QPConfig__ExtendedPrice__c = 100,
		name = 'Total (One Time)'
		);
		insert propSummaryGrp1;
		Apttus_Proposal__Proposal_Line_Item__c propLineItem = new Apttus_Proposal__Proposal_Line_Item__c(
				Apttus_Proposal__Product__c = productInst[0].id,
				Apttus_QPConfig__LineType__c = 'Product/Service',
				Apttus_QPConfig__OptionId__c = productInst[0].id,
				Apttus_Proposal__Proposal__c = proposals[0].Id

		);



		ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
		ApexPages.currentPage().getParameters().put('oppId',updatedOppty.id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();
		test.stopTest();
   }
   static testmethod void validateQuoteController_InitDirectTest7()
   {
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;

		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities[0].Account_Role__c = 'GPP Distributor Partner';
		insert opportunities;

		Opportunity updatedOppty = new Opportunity();
		updatedOppty = opportunities[0];
		updatedOppty.Apttus_Approval__Approval_Status__c = 'Approved';
		updatedOppty.stageName = 'Create Offer (bid)';
		updatedOppty.Phase_Status__c = 'Offer in Progress';
		updatedOppty.No_Loa__c = false;
   //  updatedOppty.Business_Type__c = 'Standard Opportunity';
   // updatedOppty.LOA_Level__c = 'A';
		update updatedOppty;
		//create offer
		 Offer__c offer = new Offer__c(
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = true,
		//LOA_Bypass__c = 'Authorized for Pricing Manager',
		Opportunity__c = opportunities[0].Id
		);
		insert offer;
		 opportunity opportunities1 = [select id,stageName,phase_Status__c,Authorized_for_Pricing_Manager__c,Pre_approved_Price_List_for_AM__c from opportunity where id =: opportunities[0].Id];
		 system.debug(' opportunities[0].Id>>'+opportunities1.Authorized_for_Pricing_Manager__c+ ' ' +opportunities1.Pre_approved_Price_List_for_AM__c);
		// system.debug('Authorized for Pricing Manager'+opportunities[0].Authorized for Pricing Manager+ ' '+Pre_approved_Price_List_for_AM__c == 0);
		 //create a quote
		 test.startTest();
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		 proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
		insert proposals;

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

		//get a Direct Products
   //  Product2 productInst = new Product2();
   //  productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
   List<product2> productInst = NOKIA_CPQ_TestDataFactory.productCreationDirect(1);
				insert productInst;
		// create a Line Item
		List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
		lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
		lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
		lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
		insert lineItems;

		// Create Summary Group
		Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
		Apttus_QPConfig__ProposalId__c = proposals[0].Id,
		CurrencyIsoCode = 'USD',
		Apttus_QPConfig__NetPrice__c = 100.00,
		Apttus_QPConfig__ItemSequence__c = 1,
		Apttus_QPConfig__LineNumber__c = 1,
		Apttus_QPConfig__ExtendedPrice__c = 100,
		name = 'Total (One Time)'
		);
		insert propSummaryGrp1;
   Apttus_Proposal__Proposal_Line_Item__c propLineItem = new Apttus_Proposal__Proposal_Line_Item__c(
				Apttus_Proposal__Product__c = productInst[0].id,
				Apttus_QPConfig__LineType__c = 'Product/Service',
				Apttus_QPConfig__OptionId__c = productInst[0].id,
   // Apttus_Proposal__Product__c =  productInst.Id,
				Apttus_QPConfig__ChargeType__c = 'Standard Price',
				Apttus_QPConfig__Quantity2__c = 2,
				Apttus_QPConfig__ListPrice__c = 98,
				Net_Option_Standalone_Price__c = 99,
				Apttus_QPConfig__PriceListId__c = priceList.Id  ,
				Apttus_Proposal__Proposal__c = proposals[0].Id

		);
		insert propLineItem;


		ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
		ApexPages.currentPage().getParameters().put('oppId',updatedOppty.id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();
		test.stopTest();
   }
 */
/*  static testmethod void validateQuoteController_InitDirectTest8(){
			  //create a Account
			  List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
			  insert accounts;

			  //create opportunity
			  GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
			  List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
			  opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
			  opportunities[0].Account_Role__c = 'GPP Distributor Partner';
			  insert opportunities;

			  Opportunity updatedOppty = new Opportunity();
			  updatedOppty = opportunities[0];
			  updatedOppty.Apttus_Approval__Approval_Status__c = 'Approved';
			  updatedOppty.stageName = 'Create Offer (bid)';
			  updatedOppty.Phase_Status__c = 'Offer in Progress';
			  updatedOppty.No_Loa__c = true;
			  updatedOppty.LOA_Level__c = 'A';
			  update updatedOppty;

			   //create offer
			   Offer__c offer = new Offer__c(
			  ActiveOffer__c =true,
			  LoA_Approval_Level__c= 'A',
	  // Authorized_for_Pricing_Manager__c = true,
	   //   LOA_Bypass__c = 'Authorized for Pricing Manager',
			  Opportunity__c = opportunities[0].Id
			  );
			  insert offer;
			  //create a quote
			   test.startTest();
			  List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
			  proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
			  proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
			  proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	  //  proposals[0].Reprice_In_Progress__c = false;
					  proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
		//  proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
			  insert proposals;
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

			  //get a Direct Products
		//  Product2 productInst = new Product2();
		//  productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
	   List<product2> productInst = NOKIA_CPQ_TestDataFactory.productCreationDirect(1);
					  insert productInst;
			  // create a Line Item
			  List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
			  lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
			  lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
			  lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
			  insert lineItems;

			  // Create Summary Group
			  Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
			  Apttus_QPConfig__ProposalId__c = proposals[0].Id,
			  CurrencyIsoCode = 'USD',
			  Apttus_QPConfig__NetPrice__c = 100.00,
			  Apttus_QPConfig__ItemSequence__c = 1,
			  Apttus_QPConfig__LineNumber__c = 1,
			  Apttus_QPConfig__ExtendedPrice__c = 100,
			  name = 'Total (One Time)'
			  );
			  insert propSummaryGrp1;


			  ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
			  ApexPages.currentPage().getParameters().put('oppId',updatedOppty.id);
			  NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
			  objControllerClass.init();
			  test.stopTest();


	  } */
//No loa Test starts
/*   static testmethod void validateQuoteController_InitDirectTest9(){
			  //create a Account
			  List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
			  insert accounts;

			  //create opportunity
			  GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
			  List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
			  opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
			  opportunities[0].Account_Role__c = 'GPP Distributor Partner';
			  insert opportunities;

			  Opportunity updatedOppty = new Opportunity();
			  updatedOppty = opportunities[0];
			  updatedOppty.Apttus_Approval__Approval_Status__c = 'Approved';
			  updatedOppty.stageName = 'Create Offer (bid)';
			  updatedOppty.Phase_Status__c = 'Offer in Progress';
			  updatedOppty.No_Loa__c = true;
			  updatedOppty.LOA_Level__c = 'LoA Bypass';
			  update updatedOppty;

			   //create offer
		/*   Offer__c offer = new Offer__c(
			  ActiveOffer__c =true,
			  LoA_Approval_Level__c= 'A',
	  // Authorized_for_Pricing_Manager__c = true,
	   //   LOA_Bypass__c = 'Authorized for Pricing Manager',
			  Opportunity__c = opportunities[0].Id
			  );
			  insert offer;*/
//create a quote
/*	  test.startTest();
			  List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
			  proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
			  proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
			  proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	  //  proposals[0].Reprice_In_Progress__c = false;
					  proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
		//  proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
			  insert proposals;
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

			  //get a Direct Products
	  // Product2 productInst = new Product2();
		//  productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
	   List<product2> productInst = NOKIA_CPQ_TestDataFactory.productCreationDirect(1);
					  insert productInst;
			  // create a Line Item
			  List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
			  lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
			  lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
			  lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
			  insert lineItems;

			  // Create Summary Group
			  Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
			  Apttus_QPConfig__ProposalId__c = proposals[0].Id,
			  CurrencyIsoCode = 'USD',
			  Apttus_QPConfig__NetPrice__c = 100.00,
			  Apttus_QPConfig__ItemSequence__c = 1,
			  Apttus_QPConfig__LineNumber__c = 1,
			  Apttus_QPConfig__ExtendedPrice__c = 100,
			  name = 'Total (One Time)'
			  );
			  insert propSummaryGrp1;


			  ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
			  ApexPages.currentPage().getParameters().put('oppId',updatedOppty.id);
			  NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
			  objControllerClass.init();
			  test.stopTest();


	  } */
// preapproved starts create offer(bid)
/*   static testmethod void validateQuoteController_InitDirectTest10()
	   {
			   //create a Account
			   List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
			   insert accounts;

			   //create opportunity
			   GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
			   List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
			   opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
			   opportunities[0].Account_Role__c = 'GPP Distributor Partner';
			   insert opportunities;

			   Opportunity updatedOppty = new Opportunity();
			   updatedOppty = opportunities[0];
			   updatedOppty.Apttus_Approval__Approval_Status__c = 'Approved';
			   updatedOppty.stageName = 'Create Offer (bid)';
			   updatedOppty.Phase_Status__c = 'Offer in Progress';
			   updatedOppty.No_Loa__c = false;
		 //  updatedOppty.Business_Type__c = 'Standard Opportunity';
	   // updatedOppty.LOA_Level__c = 'A';
			   update updatedOppty;
			   //create offer
				Offer__c offer = new Offer__c(
			   ActiveOffer__c =true,
			   Authorized_for_Pricing_Manager__c = true,
			   LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
			   Opportunity__c = opportunities[0].Id
			   );
			   insert offer;
				opportunity opportunities1 = [select id,stageName,phase_Status__c,Authorized_for_Pricing_Manager__c,Pre_approved_Price_List_for_AM__c from opportunity where id =: opportunities[0].Id];
				system.debug(' opportunities[0].Id>>'+opportunities1.Authorized_for_Pricing_Manager__c+ ' ' +opportunities1.Pre_approved_Price_List_for_AM__c);
			   // system.debug('Authorized for Pricing Manager'+opportunities[0].Authorized for Pricing Manager+ ' '+Pre_approved_Price_List_for_AM__c == 0);
				//create a quote
	   test.startTest();
			   List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
			   proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
			   proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
			   proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
			   insert proposals;

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

			   //get a Direct Products
		 //  Product2 productInst = new Product2();
		//   productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
				List<product2> productInst = NOKIA_CPQ_TestDataFactory.productCreationDirect(1);
					   insert productInst;
			   // create a Line Item
			   List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
			   lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
			   lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
			   lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
			   insert lineItems;

			   // Create Summary Group
			   Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
			   Apttus_QPConfig__ProposalId__c = proposals[0].Id,
			   CurrencyIsoCode = 'USD',
			   Apttus_QPConfig__NetPrice__c = 100.00,
			   Apttus_QPConfig__ItemSequence__c = 1,
			   Apttus_QPConfig__LineNumber__c = 1,
			   Apttus_QPConfig__ExtendedPrice__c = 100,
			   name = 'Total (One Time)'
			   );
			   insert propSummaryGrp1;
		Apttus_Proposal__Proposal_Line_Item__c propLineItem = new Apttus_Proposal__Proposal_Line_Item__c(
					   Apttus_Proposal__Product__c = productInst[0].id,
					   Apttus_QPConfig__LineType__c = 'Product/Service',
					   Apttus_QPConfig__OptionId__c = productInst[0].id,
		// Apttus_Proposal__Product__c =  productInst.Id,
					   Apttus_QPConfig__ChargeType__c = 'Standard Price',
					   Apttus_QPConfig__Quantity2__c = 2,
					   Apttus_QPConfig__ListPrice__c = 98,
					   Net_Option_Standalone_Price__c = 99,
					   Apttus_QPConfig__PriceListId__c = priceList.Id  ,
					   Apttus_Proposal__Proposal__c = proposals[0].Id

			   );
			   insert propLineItem;


			   ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
			   ApexPages.currentPage().getParameters().put('oppId',updatedOppty.id);
			   NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
			   objControllerClass.init();
			   test.stopTest();
	   }
 */
/*   static testmethod void validateQuoteController_InitDirectTest11()
	  {
			   List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
			  insert accounts;

			  //create opportunity
			  GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
			  List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
			  opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
					  opportunities[0].Account_Role__c = 'GPP Distributor Partner';
			  insert opportunities;

			  Opportunity updatedOppty = new Opportunity();
			  updatedOppty = opportunities[0];
			  updatedOppty.Apttus_Approval__Approval_Status__c = 'Approved';
			  updatedOppty.stageName = 'Create Offer (bid)';
			  updatedOppty.Phase_Status__c = 'Offer in Progress';
			  updatedOppty.No_Loa__c = false;
		//  updatedOppty.Business_Type__c = 'Standard Opportunity';
	  // updatedOppty.LOA_Level__c = 'A';
			  update updatedOppty;
			  //create offer
			   Offer__c offer = new Offer__c(
			  ActiveOffer__c =true,
			  Authorized_for_Pricing_Manager__c = true,
			  LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
			  Opportunity__c = opportunities[0].Id
			  );
			  insert offer;
			   opportunity opportunities1 = [select id,stageName,phase_Status__c,Authorized_for_Pricing_Manager__c,Pre_approved_Price_List_for_AM__c from opportunity where id =: opportunities[0].Id];
			   system.debug(' opportunities[0].Id>>'+opportunities1.Authorized_for_Pricing_Manager__c+ ' ' +opportunities1.Pre_approved_Price_List_for_AM__c);
			  // system.debug('Authorized for Pricing Manager'+opportunities[0].Authorized for Pricing Manager+ ' '+Pre_approved_Price_List_for_AM__c == 0);
			   //create a quote
	  test.startTest();
			  List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
			  proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
			  proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
			  proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	   proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();//direct quote
			  insert proposals;

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

			  //get a Direct Products
		//  Product2 productInst = new Product2();
	   //   productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
	  List<product2> productInst = NOKIA_CPQ_TestDataFactory.productCreationDirect(1);
					  insert productInst;
			  // create a Line Item
			  List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
			  lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
			  lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
			  lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
			  insert lineItems;

			  // Create Summary Group
			  Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
			  Apttus_QPConfig__ProposalId__c = proposals[0].Id,
			  CurrencyIsoCode = 'USD',
			  Apttus_QPConfig__NetPrice__c = 100.00,
			  Apttus_QPConfig__ItemSequence__c = 1,
			  Apttus_QPConfig__LineNumber__c = 1,
			  Apttus_QPConfig__ExtendedPrice__c = 100,
			  name = 'Total (One Time)'
			  );
			  insert propSummaryGrp1;

			  ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
			  ApexPages.currentPage().getParameters().put('oppId',updatedOppty.id);
			  NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
			  objControllerClass.init();
			  test.stopTest();
	  }
 */// Pre approved manager
/*   static testmethod void validateQuoteController_InitDirectTest12()
	   {
			   //create a Account
			   List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
			   insert accounts;

			   //create opportunity
			   GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
			   List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
			   opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
			   opportunities[0].Account_Role__c = 'GPP Distributor Partner';
			   insert opportunities;

			   Opportunity updatedOppty = new Opportunity();
			   updatedOppty = opportunities[0];
			   updatedOppty.Apttus_Approval__Approval_Status__c = 'Approved';
	   updatedOppty.stageName = 'Win the Case (Negotiate)';
	   // updatedOppty.Phase_Status__c = 'Won (Requested)';
			   updatedOppty.No_Loa__c = false;
		 //  updatedOppty.Business_Type__c = 'Standard Opportunity';
	   // updatedOppty.LOA_Level__c = 'A';
			   update updatedOppty;
			   //create offer
				Offer__c offer = new Offer__c(
			   ActiveOffer__c =true,
			   Authorized_for_Pricing_Manager__c = true,
			   LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
			   Opportunity__c = opportunities[0].Id
			   );
			   insert offer;
				opportunity opportunities1 = [select id,stageName,phase_Status__c,Authorized_for_Pricing_Manager__c,Pre_approved_Price_List_for_AM__c from opportunity where id =: opportunities[0].Id];
				system.debug(' opportunities[0].Id>>'+opportunities1.Authorized_for_Pricing_Manager__c+ ' ' +opportunities1.Pre_approved_Price_List_for_AM__c);
			   // system.debug('Authorized for Pricing Manager'+opportunities[0].Authorized for Pricing Manager+ ' '+Pre_approved_Price_List_for_AM__c == 0);
				//create a quote
	   test.startTest();
			   List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
			   proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
			   proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
			   proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
			   insert proposals;

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

			   //get a Direct Products
		 //  Product2 productInst = new Product2();
	   //  productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
					   List<product2> productInst = NOKIA_CPQ_TestDataFactory.productCreationDirect(1);
					   insert productInst;
			   // create a Line Item
			   List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
			   lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
			   lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
			   lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
			   insert lineItems;

			   // Create Summary Group
			   Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
			   Apttus_QPConfig__ProposalId__c = proposals[0].Id,
			   CurrencyIsoCode = 'USD',
			   Apttus_QPConfig__NetPrice__c = 100.00,
			   Apttus_QPConfig__ItemSequence__c = 1,
			   Apttus_QPConfig__LineNumber__c = 1,
			   Apttus_QPConfig__ExtendedPrice__c = 100,
			   name = 'Total (One Time)'
			   );
			   insert propSummaryGrp1;
		Apttus_Proposal__Proposal_Line_Item__c propLineItem = new Apttus_Proposal__Proposal_Line_Item__c(
					   Apttus_Proposal__Product__c = productInst[0].id,
					   Apttus_QPConfig__LineType__c = 'Product/Service',
					   Apttus_QPConfig__OptionId__c = productInst[0].id,
		// Apttus_Proposal__Product__c =  productInst.Id,
					   Apttus_QPConfig__ChargeType__c = 'Standard Price',
					   Apttus_QPConfig__Quantity2__c = 2,
					   Apttus_QPConfig__ListPrice__c = 98,
					   Net_Option_Standalone_Price__c = 99,
					   Apttus_QPConfig__PriceListId__c = priceList.Id  ,
					   Apttus_Proposal__Proposal__c = proposals[0].Id

			   );
			   insert propLineItem;


			   ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
			   ApexPages.currentPage().getParameters().put('oppId',updatedOppty.id);
			   NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
			   objControllerClass.init();
			   test.stopTest();
	   }
 */// negative scenarion of pre approved win the case
/*   static testmethod void validateQuoteController_InitDirectTest13()
	  {
			  //create a Account
			  List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
			  insert accounts;

			  //create opportunity
			  GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
			  List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
			  opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
			  opportunities[0].Account_Role__c = 'GPP Distributor Partner';
			  insert opportunities;

			  Opportunity updatedOppty = new Opportunity();
			  updatedOppty = opportunities[0];
			  updatedOppty.Apttus_Approval__Approval_Status__c = 'Approved';
			  updatedOppty.stageName = 'Win the Case (Negotiate)';
	  // updatedOppty.Phase_Status__c = 'Won (Requested)';
			  updatedOppty.No_Loa__c = false;
		//  updatedOppty.Business_Type__c = 'Standard Opportunity';
	  // updatedOppty.LOA_Level__c = 'A';
			  update updatedOppty;
			  //create offer
			   Offer__c offer = new Offer__c(
			  ActiveOffer__c =true,
			  Authorized_for_Pricing_Manager__c = true,
			  LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
			  Opportunity__c = opportunities[0].Id
			  );
			  insert offer;
			   opportunity opportunities1 = [select id,stageName,phase_Status__c,Authorized_for_Pricing_Manager__c,Pre_approved_Price_List_for_AM__c from opportunity where id =: opportunities[0].Id];
			   system.debug(' opportunities[0].Id>>'+opportunities1.Authorized_for_Pricing_Manager__c+ ' ' +opportunities1.Pre_approved_Price_List_for_AM__c);
			  // system.debug('Authorized for Pricing Manager'+opportunities[0].Authorized for Pricing Manager+ ' '+Pre_approved_Price_List_for_AM__c == 0);
			   //create a quote
	  test.startTest();
			  List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
			  proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
			  proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
			  proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	   proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
			  insert proposals;

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

			  //get a Direct Products
		//	  Product2 productInst = new Product2();
	   //   productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
	  List<product2> productInst = NOKIA_CPQ_TestDataFactory.productCreationDirect(1);
					  insert productInst;
			  // create a Line Item
			  List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
			  lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
			  lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
			  lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
			  insert lineItems;

			  // Create Summary Group
			  Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
			  Apttus_QPConfig__ProposalId__c = proposals[0].Id,
			  CurrencyIsoCode = 'USD',
			  Apttus_QPConfig__NetPrice__c = 100.00,
			  Apttus_QPConfig__ItemSequence__c = 1,
			  Apttus_QPConfig__LineNumber__c = 1,
			  Apttus_QPConfig__ExtendedPrice__c = 100,
			  name = 'Total (One Time)'
			  );
			  insert propSummaryGrp1;

			  ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
			  ApexPages.currentPage().getParameters().put('oppId',updatedOppty.id);
			  NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
			  objControllerClass.init();
			  test.stopTest();
	  }

	  // else if(opportunity.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE && ((opportunity.LOA_Level__c != null && opportunity.LOA_Level__c != GlobalConstants.LOA_BYPASS_LEVEL) || opportunity.Authorized_for_Pricing_manager__c > 0)
					   //   && opportunity.Pre_approved_Price_List_for_AM__c == 0 && opportunity.No_Loa__c == false)
 */
/*  static testmethod void validateQuoteController_InitDirectTest14()
   {
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;

		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
				opportunities[0].Account_Role__c = 'GPP Distributor Partner';
		insert opportunities;

		Opportunity updatedOppty = new Opportunity();
		updatedOppty = opportunities[0];
		updatedOppty.Apttus_Approval__Approval_Status__c = 'Approved';
		updatedOppty.stageName = 'Win the Case (Negotiate)';
   //	updatedOppty.Phase_Status__c = 'Won (Requested)';
		updatedOppty.No_Loa__c = false;
   //  updatedOppty.Business_Type__c = 'Standard Opportunity';
		updatedOppty.LOA_Level__c = 'A';
		update updatedOppty;*/
/*  //create offer
	   Offer__c offer = new Offer__c(
	  ActiveOffer__c =true,
	  Authorized_for_Pricing_Manager__c = true,
	  LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
	  Opportunity__c = opportunities[0].Id
	  );
	  insert offer;*/
/*  opportunity opportunities1 = [select id,stageName,phase_Status__c,Authorized_for_Pricing_Manager__c,Pre_approved_Price_List_for_AM__c from opportunity where id =: opportunities[0].Id];
				system.debug(' opportunities[0].Id>>'+opportunities1.Authorized_for_Pricing_Manager__c+ ' ' +opportunities1.Pre_approved_Price_List_for_AM__c);
			   // system.debug('Authorized for Pricing Manager'+opportunities[0].Authorized for Pricing Manager+ ' '+Pre_approved_Price_List_for_AM__c == 0);
				//create a quote
	   test.startTest();
			   List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
			   proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
			   proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
			   proposals[0].NokiaCPQ_Needs_Reprice__c = false;
				proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();//direct quote
			   insert proposals;

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

			   //get a Direct Products
	   // Product2 productInst = new Product2();
		//   productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
					   List<product2> productInst = NOKIA_CPQ_TestDataFactory.productCreationDirect(1);
					   insert productInst;
			   // create a Line Item
			   List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
			   lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
			   lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
			   lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
			   insert lineItems;

			   // Create Summary Group
			   Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
			   Apttus_QPConfig__ProposalId__c = proposals[0].Id,
			   CurrencyIsoCode = 'USD',
			   Apttus_QPConfig__NetPrice__c = 100.00,
			   Apttus_QPConfig__ItemSequence__c = 1,
			   Apttus_QPConfig__LineNumber__c = 1,
			   Apttus_QPConfig__ExtendedPrice__c = 100,
			   name = 'Total (One Time)'
			   );
			   insert propSummaryGrp1;

			   ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
			   ApexPages.currentPage().getParameters().put('oppId',updatedOppty.id);
			   NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
			   objControllerClass.init();
			   test.stopTest();
	   }
 */
}