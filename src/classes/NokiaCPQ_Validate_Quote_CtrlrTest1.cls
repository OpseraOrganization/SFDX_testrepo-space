@isTest(SeeAllData=false)
public class NokiaCPQ_Validate_Quote_CtrlrTest1
{ 
	
static testmethod void testMethod1111()
	{
		
	  List<user>userList = new List<User>();
		List<Account> accounts2 = new list<Account>();
		List<Account> acclist2 = new list<Account>();
		userList = TestDataFactory.userCreation(2,'Data Loader Profile');
		database.insert(userList);
		
		 List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;
		
		List<Account> acclist = new List<Account>();
		acclist.add(accounts[0]);
		
		 GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		opportunities[0].Account_Role__c = 'Alliance Partner';
		insert opportunities; 
		
		Offer__c offer = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = false,
		Pre_approved_Price_List_for_Acc_Managers__c = true,
		LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
		Opportunity__c = opportunities[0].Id
	); 
	insert offer;  
	opportunities[0].stageName = GlobalConstants.CREATE_OFFER;
		opportunities[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
		opportunities[0].No_Loa__c = true;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		update opportunities[0]; 
		
		
	
	
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium'; 
	accreditations[0].Portfolio__c = 'Microwave';
	accreditations[1].Portfolio__c ='Microwave';
	
	insert accreditations;
	test.startTest(); 
	PermissionSet ps = [Select id from PermissionSet Where name = 'Nokia_CPQ_Partner_User' Limit 1];
	System.debug('psid>>'+ps.Id);
	
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	proposals[0].NokiaCPQ_LEO_Discount__c= false;
	 //  proposals[0].Indirect_Approval_Required__c = true;
	proposals[0].Maintenance_Y1__c = null;
	proposals[0].Maintenance_Y2__c = null;
	proposals[0].NokiaCPQ_SSP_Level__c = '';
			proposals[0].NokiaCPQ_SRS_Level__c = '';
	proposals[0].NokiaCPQ_Portfolio__c = 'Microwave';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
	 proposals[0].NokiaCPQ_No_of_Years__c  = '1';
	 proposals[0].NokiaCPQ_Maintenance_Type__c  = 'Pro Support';
	 proposals[0].Apttus_QPConfig__ConfigurationFinalizedDate__c = Date.Today();
	
	insert proposals;   
	
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='USD';
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
	prodConfigs[0].Apttus_Config2__BusinessObjectType__c = 'Proposal';
	insert prodConfigs;
	
	//get a IP Routing Product
	Product2 productInst = new Product2();
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
	  	productInst.Name = 'Product1';  
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
	
	  /*	//create proposal line items
	List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
	proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
	proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
	proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'option';
	proposalLineItemList[0].is_Custom_Product__c = false;
	insert proposalLineItemList;
	
	Apttus_Config2__SummaryGroup__c sg = new Apttus_Config2__SummaryGroup__c(
		Apttus_Config2__ConfigurationId__c = prodConfigs[0].id,
		//NokiaCPQ_Guidance_Traffic_Light__c = 'GREEN',
		NokiaCPQ_Additional_Information__c = 'dummy',
		Name = 'Subtotal - Standard Price (One Time)',
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 2
		
	);
	insert sg; */
	
	//system.debug('>>>opportunities[0]: '+select stagename from opportunity where stagename =: opportunities[0].id);	  
	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	 test.stopTest();  
	
	}
	static testmethod void testMethod1112()
	{
		
	  List<user>userList = new List<User>();
		List<Account> accounts2 = new list<Account>();
		List<Account> acclist2 = new list<Account>();
		userList = TestDataFactory.userCreation(2,'Data Loader Profile');
		database.insert(userList);
		
		 List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;
		
		List<Account> acclist = new List<Account>();
		acclist.add(accounts[0]);
		
		 GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		opportunities[0].Account_Role__c = 'Alliance Partner';
		opportunities[0].LOA_Level__c = '';
		insert opportunities; 
		
		Offer__c offer = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = false,
		Pre_approved_Price_List_for_Acc_Managers__c = true,
		LOA_Bypass__c = 'No LoA',
		Opportunity__c = opportunities[0].Id
	); 
	insert offer;  
	opportunities[0].stageName = GlobalConstants.CREATE_OFFER;
		opportunities[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
		opportunities[0].No_Loa__c = true;
		opportunities[0].LOA_Level__c = 'A';
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		update opportunities[0]; 
		
		
	
	
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium'; 
	accreditations[0].Portfolio__c = 'Microwave';
	accreditations[1].Portfolio__c ='Microwave';
	
	insert accreditations;
	test.startTest(); 
	PermissionSet ps = [Select id from PermissionSet Where name = 'Nokia_CPQ_Partner_User' Limit 1];
	System.debug('psid>>'+ps.Id);
	
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	proposals[0].NokiaCPQ_LEO_Discount__c= false;
	 //  proposals[0].Indirect_Approval_Required__c = true;
	proposals[0].Maintenance_Y1__c = null;
	proposals[0].Maintenance_Y2__c = null;
	proposals[0].NokiaCPQ_SSP_Level__c = '';
			proposals[0].NokiaCPQ_SRS_Level__c = '';
	proposals[0].NokiaCPQ_Portfolio__c = 'Microwave';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
	 proposals[0].NokiaCPQ_No_of_Years__c  = '1';
	 proposals[0].NokiaCPQ_Maintenance_Type__c  = 'Pro Support';
	 proposals[0].Maintenance_Y1__c = 100;
	 proposals[0].Apttus_QPConfig__ConfigurationFinalizedDate__c = Date.Today();
	
	insert proposals;   
	
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='USD';
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
	prodConfigs[0].Apttus_Config2__BusinessObjectType__c = 'Proposal';
	insert prodConfigs;
	
	//get a IP Routing Product
	Product2 productInst = new Product2();
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
		productInst.Name = 'Product2';  
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
	
	  /*	//create proposal line items
	List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
	proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
	proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
	proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'option';
	proposalLineItemList[0].is_Custom_Product__c = false;
	insert proposalLineItemList;
	
	Apttus_Config2__SummaryGroup__c sg = new Apttus_Config2__SummaryGroup__c(
		Apttus_Config2__ConfigurationId__c = prodConfigs[0].id,
		//NokiaCPQ_Guidance_Traffic_Light__c = 'GREEN',
		NokiaCPQ_Additional_Information__c = 'dummy',
		Name = 'Subtotal - Standard Price (One Time)',
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 2
		
	);
	insert sg; */
	
	//system.debug('>>>opportunities[0]: '+select stagename from opportunity where stagename =: opportunities[0].id);	  
	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	 test.stopTest();  
	
	}
	static testmethod void testMethod42()
	{
		
	  List<user>userList = new List<User>();
		List<Account> accounts2 = new list<Account>();
		List<Account> acclist2 = new list<Account>();
		userList = TestDataFactory.userCreation(2,'Data Loader Profile');
		database.insert(userList);
		
		 List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;
		
		List<Account> acclist = new List<Account>();
		acclist.add(accounts[0]);
		system.runAs(userList[0]){
		 GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		opportunities[0].Account_Role__c = 'Alliance Partner';
		opportunities[0].No_Loa__c = false;
		insert opportunities; 
		
		Offer__c offer = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = false,
		Pre_approved_Price_List_for_Acc_Managers__c = true,
		LOA_Bypass__c = 'No LOA',
		Opportunity__c = opportunities[0].Id
	); 
	insert offer;  
	opportunities[0].stageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
		opportunities[0].Phase_Status__c = 'Pending Win/Loss Declaration';
		opportunities[0].No_Loa__c = true;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].LOA_Level__c = GlobalConstants.LOA_BYPASS_LEVEL;
		update opportunities[0]; 
		
		
	
	
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium'; 
	accreditations[0].Portfolio__c = 'Microwave';
	accreditations[1].Portfolio__c ='Microwave';
	
	insert accreditations;
	test.startTest(); 
	PermissionSet ps = [Select id from PermissionSet Where name = 'Nokia_CPQ_Partner_User' Limit 1];
	System.debug('psid>>'+ps.Id);
	
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Draft_Quote_Cannot_Validate').getRecordTypeId();
	proposals[0].NokiaCPQ_LEO_Discount__c= false;
	 //  proposals[0].Indirect_Approval_Required__c = true;
	proposals[0].Maintenance_Y1__c = null;
	proposals[0].Maintenance_Y2__c = null;
	proposals[0].NokiaCPQ_SSP_Level__c = '';
			proposals[0].NokiaCPQ_SRS_Level__c = '';
	proposals[0].NokiaCPQ_Portfolio__c = 'Microwave';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
	 proposals[0].NokiaCPQ_No_of_Years__c  = '1';
	 proposals[0].NokiaCPQ_Maintenance_Type__c  = 'Pro Support';
	 proposals[0].Apttus_QPConfig__ConfigurationFinalizedDate__c = Date.Today();
	 proposals[0].Maintenance_Y1__c = 100;
	
	insert proposals;   
	
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='USD';
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
	prodConfigs[0].Apttus_Config2__BusinessObjectType__c = 'Proposal';
	insert prodConfigs;
	
	//get a IP Routing Product
	Product2 productInst = new Product2();
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
		productInst.Name = 'Product3';  
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
	
	  /*	//create proposal line items
	List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
	proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
	proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
	proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'option';
	proposalLineItemList[0].is_Custom_Product__c = false;
	insert proposalLineItemList;
	
	Apttus_Config2__SummaryGroup__c sg = new Apttus_Config2__SummaryGroup__c(
		Apttus_Config2__ConfigurationId__c = prodConfigs[0].id,
		//NokiaCPQ_Guidance_Traffic_Light__c = 'GREEN',
		NokiaCPQ_Additional_Information__c = 'dummy',
		Name = 'Subtotal - Standard Price (One Time)',
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 2
		
	);
	insert sg; */
	
	//system.debug('>>>opportunities[0]: '+select stagename from opportunity where stagename =: opportunities[0].id);	  
	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	 test.stopTest();  
		}
	}
	static testmethod void testMethod422()
	{
		
	  List<user>userList = new List<User>();
		List<Account> accounts2 = new list<Account>();
		List<Account> acclist2 = new list<Account>();
		userList = TestDataFactory.userCreation(2,'Data Loader Profile');
		database.insert(userList);
		
		 List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;
		
		List<Account> acclist = new List<Account>();
		acclist.add(accounts[0]);
		system.runAs(userList[0]){
		 GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		opportunities[0].Account_Role__c = 'Alliance Partner';
		insert opportunities; 
		
		Offer__c offer = new Offer__c(
		No_LoA__c = true,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = false,
		//Pre_approved_Price_List_for_Acc_Managers__c = true,
		LOA_Bypass__c = 'No LOA',
		Opportunity__c = opportunities[0].Id,
		Pre_approved_Price_List_for_Acc_Managers__c = false
		
		
	); 
	insert offer;  
	 opportunities[0].stageName = GlobalConstants.CREATE_OFFER;
		opportunities[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
		opportunities[0].No_Loa__c = true;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].LOA_Level__c = GlobalConstants.LOA_BYPASS_LEVEL;
		update opportunities[0]; 
		
		system.debug('opportunities[0]'+opportunities[0]);
	
	
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium'; 
	accreditations[0].Portfolio__c = 'Microwave';
	accreditations[1].Portfolio__c ='Microwave';
	
	insert accreditations;
	test.startTest(); 
	PermissionSet ps = [Select id from PermissionSet Where name = 'Nokia_CPQ_Partner_User' Limit 1];
	System.debug('psid>>'+ps.Id);
	
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	proposals[0].NokiaCPQ_LEO_Discount__c= false;
	 //  proposals[0].Indirect_Approval_Required__c = true;
	proposals[0].Maintenance_Y1__c = null;
	proposals[0].Maintenance_Y2__c = null;
	proposals[0].NokiaCPQ_SSP_Level__c = '';
			proposals[0].NokiaCPQ_SRS_Level__c = '';
	proposals[0].NokiaCPQ_Portfolio__c = 'Microwave';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
	 proposals[0].NokiaCPQ_No_of_Years__c  = '1';
	 proposals[0].NokiaCPQ_Maintenance_Type__c  = 'Pro Support';
	 proposals[0].Apttus_QPConfig__ConfigurationFinalizedDate__c = Date.Today();
	 proposals[0].Maintenance_Y1__c = 100;
	
	insert proposals;   
	system.debug('proposals'+proposals);
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='USD';
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
	prodConfigs[0].Apttus_Config2__BusinessObjectType__c = 'Proposal';
	insert prodConfigs;
	
	//get a IP Routing Product
	Product2 productInst = new Product2();
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
		productInst.Name = 'Product4';  
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
	
	  /*	//create proposal line items
	List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
	proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
	proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
	proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'option';
	proposalLineItemList[0].is_Custom_Product__c = false;
	insert proposalLineItemList;
	
	Apttus_Config2__SummaryGroup__c sg = new Apttus_Config2__SummaryGroup__c(
		Apttus_Config2__ConfigurationId__c = prodConfigs[0].id,
		//NokiaCPQ_Guidance_Traffic_Light__c = 'GREEN',
		NokiaCPQ_Additional_Information__c = 'dummy',
		Name = 'Subtotal - Standard Price (One Time)',
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 2
		
	);
	insert sg; */
	
	//system.debug('>>>opportunities[0]: '+select stagename from opportunity where stagename =: opportunities[0].id);	  
	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	 test.stopTest();  
		}
	}
	static testmethod void testMethod4LEO()
	{
		
	  List<user>userList = new List<User>();
		List<Account> accounts2 = new list<Account>();
		List<Account> acclist2 = new list<Account>();
		userList = TestDataFactory.userCreation(2,'Data Loader Profile');
		database.insert(userList);
		
		 List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;
		
		List<Account> acclist = new List<Account>();
		acclist.add(accounts[0]);
		system.runAs(userList[0]){
		 GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		opportunities[0].Account_Role__c = 'Alliance Partner';
		insert opportunities; 
		
		Offer__c offer = new Offer__c(
		No_LoA__c = true,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = false,
		//Pre_approved_Price_List_for_Acc_Managers__c = true,
		LOA_Bypass__c = 'No LOA',
		Opportunity__c = opportunities[0].Id,
		Pre_approved_Price_List_for_Acc_Managers__c = false
		
		
	); 
	insert offer;  
	 opportunities[0].stageName = GlobalConstants.CREATE_OFFER;
		opportunities[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
		opportunities[0].No_Loa__c = true;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].LOA_Level__c = GlobalConstants.LOA_BYPASS_LEVEL;
		update opportunities[0]; 
		
		system.debug('opportunities[0]'+opportunities[0]);
	
	
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium'; 
	accreditations[0].Portfolio__c = 'IP Routing';
	accreditations[1].Portfolio__c ='IP Routing';
	
	insert accreditations;
	test.startTest(); 
	PermissionSet ps = [Select id from PermissionSet Where name = 'Nokia_CPQ_Partner_User' Limit 1];
	System.debug('psid>>'+ps.Id);
	
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	proposals[0].NokiaCPQ_LEO_Discount__c= false;
	 //  proposals[0].Indirect_Approval_Required__c = true;
	proposals[0].Maintenance_Y1__c = null;
	proposals[0].Maintenance_Y2__c = null;
	proposals[0].NokiaCPQ_SSP_Level__c = '';
			proposals[0].NokiaCPQ_SRS_Level__c = '';
	proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
	 proposals[0].NokiaCPQ_No_of_Years__c  = '1';
	 proposals[0].NokiaCPQ_Maintenance_Type__c  = 'Gold (Return for Exchange)';
	 proposals[0].Apttus_QPConfig__ConfigurationFinalizedDate__c = Date.Today();
	 //proposals[0].Maintenance_Y1__c = 100;
	 proposals[0].NokiaCPQ_has_Partner_Certified__c = false;
	 proposals[0].NokiaCPQ_LEO_Discount__c = true;
	
	insert proposals;   
	system.debug('proposals'+proposals);
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='USD';
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
	prodConfigs[0].Apttus_Config2__BusinessObjectType__c = 'Proposal';
	insert prodConfigs;
	
	//get a IP Routing Product
	Product2 productInst = new Product2();
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
		productInst.Name = 'Product5';  
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
	
	  /*	//create proposal line items
	List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
	proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
	proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
	proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'option';
	proposalLineItemList[0].is_Custom_Product__c = false;
	insert proposalLineItemList;
	
	Apttus_Config2__SummaryGroup__c sg = new Apttus_Config2__SummaryGroup__c(
		Apttus_Config2__ConfigurationId__c = prodConfigs[0].id,
		//NokiaCPQ_Guidance_Traffic_Light__c = 'GREEN',
		NokiaCPQ_Additional_Information__c = 'dummy',
		Name = 'Subtotal - Standard Price (One Time)',
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 2
		
	);
	insert sg; */
	
	//system.debug('>>>opportunities[0]: '+select stagename from opportunity where stagename =: opportunities[0].id);	  
	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	 test.stopTest();  
		}
	}
	static testmethod void testMethodLineitem()
	{
		
	  List<user>userList = new List<User>();
		List<Account> accounts2 = new list<Account>();
		List<Account> acclist2 = new list<Account>();
		userList = TestDataFactory.userCreation(2,'Data Loader Profile');
		database.insert(userList);
		
		 List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;
		
		List<Account> acclist = new List<Account>();
		acclist.add(accounts[0]);
		system.runAs(userList[0]){
		 GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		opportunities[0].Account_Role__c = 'Alliance Partner';
		insert opportunities; 
		
		Offer__c offer = new Offer__c(
		No_LoA__c = true,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = false,
		//Pre_approved_Price_List_for_Acc_Managers__c = true,
		LOA_Bypass__c = 'No LOA',
		Opportunity__c = opportunities[0].Id,
		Pre_approved_Price_List_for_Acc_Managers__c = false
		
		
	); 
	insert offer;  
	 opportunities[0].stageName = GlobalConstants.CREATE_OFFER;
		opportunities[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
		opportunities[0].No_Loa__c = true;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].LOA_Level__c = GlobalConstants.LOA_BYPASS_LEVEL;
		update opportunities[0]; 
		
		system.debug('opportunities[0]'+opportunities[0]);
	
	
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium'; 
	accreditations[0].Portfolio__c = 'IP Routing';
	accreditations[1].Portfolio__c ='IP Routing';
	
	insert accreditations;
	test.startTest(); 
	PermissionSet ps = [Select id from PermissionSet Where name = 'Nokia_CPQ_Partner_User' Limit 1];
	System.debug('psid>>'+ps.Id);
	
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	proposals[0].NokiaCPQ_LEO_Discount__c= false;
	 //  proposals[0].Indirect_Approval_Required__c = true;
	proposals[0].Maintenance_Y1__c = null;
	proposals[0].Maintenance_Y2__c = null;
	proposals[0].NokiaCPQ_SSP_Level__c = '';
			proposals[0].NokiaCPQ_SRS_Level__c = '';
	proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
	 proposals[0].NokiaCPQ_No_of_Years__c  = '1';
	 proposals[0].NokiaCPQ_Maintenance_Type__c  = 'Gold (Return for Exchange)';
	 proposals[0].Apttus_QPConfig__ConfigurationFinalizedDate__c = Date.Today();
	 //proposals[0].Maintenance_Y1__c = 100;
	// proposals[0].NokiaCPQ_has_Partner_Certified__c = false;
	// proposals[0].NokiaCPQ_LEO_Discount__c = true;
	
	insert proposals;   
	system.debug('proposals'+proposals);
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='USD';
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
	prodConfigs[0].Apttus_Config2__BusinessObjectType__c = 'Proposal';
	insert prodConfigs;
	
	//get a IP Routing Product
	Product2 productInst = new Product2();
	//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
		productInst.Name = 'Product5';  
	  	productInst.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
	  	productInst.NokiaCPQ_State__c = 'Release';
	  	insert productInst;
	productInst.IsActive = false;
	update productInst;
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
		
		 Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
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
		insert LineItem2;
		LineItemList.add(LineItem2);
		
		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(2);
		proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		proposalLineItemList[1].Apttus_Proposal__Product__c = productInst.id;
		proposalLineItemList[1].Apttus_Proposal__Proposal__c =proposals[0].id;
		proposalLineItemList[1].Apttus_QPConfig__LineType__c = 'Option';
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
	
	  /*	//create proposal line items
	List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
	proposalLineItemList[0].Apttus_Proposal__Product__c = productInst.id;
	proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
	proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'option';
	proposalLineItemList[0].is_Custom_Product__c = false;
	insert proposalLineItemList;
	
	Apttus_Config2__SummaryGroup__c sg = new Apttus_Config2__SummaryGroup__c(
		Apttus_Config2__ConfigurationId__c = prodConfigs[0].id,
		//NokiaCPQ_Guidance_Traffic_Light__c = 'GREEN',
		NokiaCPQ_Additional_Information__c = 'dummy',
		Name = 'Subtotal - Standard Price (One Time)',
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 2
		
	);
	insert sg; */
	
	//system.debug('>>>opportunities[0]: '+select stagename from opportunity where stagename =: opportunities[0].id);	  
	ApexPages.currentPage().getParameters().put('quoteId',proposals[0].id);
	ApexPages.currentPage().getParameters().put('oppId',opportunities[0].id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	 test.stopTest();  
		}
	}
	}