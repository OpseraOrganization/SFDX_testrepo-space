/*******************************
Class Name: DS_DisplayQuoteLI_InformationTest
Created by: Accenture
Created Date: 1 feb 2019
Last modified by: Accenture
Description: Test class for DS_DisplayQuoteLI_InformationTest
*******************************/

@isTest
private with sharing class DS_DisplayQuoteLI_InformationTest{


	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
	public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();


	 static testmethod void DS_DisplayQuoteLI_InformationTest1(){


		/************ Account Insertion  ***************/
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='100006843';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		database.insert(accLegalEntity);

		Account accountCreationDP = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreationDP);

		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();

		 /**************** Product Insertion  *******************/

		product2 prod = new product2();
			prod.name = 'BundleTest2';
			prod.CurrencyIsoCode = 'USD';
			prod.ProductCode='123';
			prod.IsActive=True;
			Prod.Apttus_Config2__ConfigurationType__c = 'Bundle';

			insert prod;


		 product2 prodB2 = new product2();
			prodB2.name = 'BundleTest';
			prodB2.CurrencyIsoCode = 'USD';
			prodB2.ProductCode='12345';
			prodB2.IsActive=True;
			ProdB2.Apttus_Config2__ConfigurationType__c = 'Bundle';

			insert prodB2;


		product2 prod2 = new product2();
			prod2.name = 'StandaloneTest';
			prod2.CurrencyIsoCode = 'USD';
			prod2.ProductCode='1234';
			prod2.IsActive=True;
			Prod2.Apttus_Config2__ConfigurationType__c = 'Standalone';

			insert prod2;

		 product2 prodS2 = new product2();
			prodS2.name = 'StandaloneTest2';
			prodS2.CurrencyIsoCode = 'USD';
			prodS2.ProductCode='12345678';
			prodS2.IsActive=True;
			ProdS2.Apttus_Config2__ConfigurationType__c = 'Standalone';

			insert prodS2;



		product2 Option2 = new product2();
			Option2.name = 'StandaloneTest2';
			Option2.CurrencyIsoCode = 'USD';
			Option2.ProductCode='123456789';
			Option2.IsActive=True;
			Option2.Apttus_Config2__ConfigurationType__c = 'Standalone';

			insert Option2;


		/****************  Price List  ********************/
		Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
		database.insert(priceList);

		/***************** PLI Record ********************/
		Apttus_Config2__PriceListItem__c PriceListItem= TestdataFactory.createPriceListItem(1,priceList)[0];

		PriceListItem.Apttus_Config2__ProductId__c =  prod.id;
		database.insert(PriceListItem);


		/********************** feature  *********************/

		ProductFeature__c   feature = new ProductFeature__c();
		feature.Feature_Commercial_Number__c ='Feature_SMB';
		feature.Description__c ='Test';
		feature.NSNClassification__c ='Feature Component';
		feature.NSN_Code__c ='123';

		insert feature;



		Product_Feature_Junction__c  pfj = new Product_Feature_Junction__c();
		pfj.Product__c = prod.id;
		pfj.Product_Feature__c = feature.id;

		insert pfj;


		 Product_Feature_Junction__c  pfj2 = new Product_Feature_Junction__c();
		pfj2.Product__c = prod2.id;
		pfj2.Product_Feature__c = feature.id;

		insert pfj2;



		/*************  Digital Proposal  ********************/

		SWx_Upsell_Proposal__c upsellProposal_SWX= new SWx_Upsell_Proposal__c();
		upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal_SWX.Analytics_Source__c='CXM';
		upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
		upsellProposal_SWX.P20_Id__c=215616;
		upsellProposal_SWX.Sold_To_Party__c = accLegalEntity.id;
		upsellProposal_SWX.CurrencyIsoCode='EUR';
		upsellProposal_SWX.Unweighted_Value__c=429052.07;
		upsellProposal_SWX.Account_ID__c=accLegalEntity.id;
		upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
		database.insert(upsellProposal_SWX);

		/*************** DP Item insertion *************************/

		set<ID> upsellproposalId_SWX= new set<Id>();
		upsellproposalId_SWX.add(upsellProposal_SWX.Id);

		List<SWx_Upsell_Items__c> lstSWXUpsellItems = TestDataFactory.createSWXLineItems(upsellproposalId_SWX,1);
		database.insert(lstSWXUpsellItems);

		/************** opty Insertion *****************************/
		Opportunity oppty ;
		oppty = TestDataFactory.OpportunityCreation(1,accountCreationDP)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=RecordTypeId;
		oppty.SWx_Upsell_Proposal__c =upsellProposal_SWX.Id;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;

		database.insert(oppty);


	   DS_DisplayQuoteLI_Information.CustomerGrouping objCustomerGroup = new  DS_DisplayQuoteLI_Information.CustomerGrouping();

	   Test.startTest();


		/******************** Quote Insertion  ******************************/

		Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id;
		quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';

		quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal2.Prices_Aligned__c=true;
		quoteProposal2.Apttus_Proposal__Account__c=accLegalEntity.id;
		 quoteProposal2.Sold_To_Party__c = accLegalEntity.id;
		database.insert(quoteProposal2);

		/************************  Quote LI  *****************************/
		Apttus_Proposal__Proposal_Line_Item__c QuoteLI = new Apttus_Proposal__Proposal_Line_Item__c();
		QuoteLI.Apttus_Proposal__Proposal__c = quoteProposal2.id;
		QuoteLI.Apttus_QPConfig__LineType__c = 'Product/Service';
		QuoteLI.Apttus_QPConfig__ItemSequence__c = 1;
		QuoteLI.Apttus_QPConfig__LineNumber__c =1;
		QuoteLI.NokiaCPQ_Configuration_Type__c ='Bundle';
		QuoteLI.Apttus_Proposal__Product__c = prod.id;
		QuoteLI.DS_Grouping_Name__c ='Test';
		QuoteLI.Apttus_QPConfig__NetPrice__c =10;

		insert QuoteLI;




		Apttus_Proposal__Proposal_Line_Item__c QuoteLIB2 = new Apttus_Proposal__Proposal_Line_Item__c();
		QuoteLIB2.Apttus_Proposal__Proposal__c = quoteProposal2.id;
		QuoteLIB2.Apttus_QPConfig__LineType__c = 'Product/Service';
		QuoteLIB2.Apttus_QPConfig__ItemSequence__c = 3;
		QuoteLIB2.Apttus_QPConfig__LineNumber__c =3;
		QuoteLIB2.NokiaCPQ_Configuration_Type__c ='Bundle';
		QuoteLIB2.Apttus_Proposal__Product__c = prodB2.id;
		QuoteLIB2.DS_Grouping_Name__c ='Test';
		QuoteLIB2.Apttus_QPConfig__NetPrice__c =10;

		insert QuoteLIB2;



		Apttus_Proposal__Proposal_Line_Item__c QuoteLI2 = new Apttus_Proposal__Proposal_Line_Item__c();
		QuoteLI2.Apttus_Proposal__Proposal__c = quoteProposal2.id;
		QuoteLI2.Apttus_QPConfig__LineType__c = 'Option';
		QuoteLI2.Apttus_QPConfig__ItemSequence__c = 1;
		QuoteLI2.Apttus_QPConfig__LineNumber__c =1;
		QuoteLI2.NokiaCPQ_Configuration_Type__c ='Standalone';
		QuoteLI2.Apttus_Proposal__Product__c = prod.id;
		QuoteLI2.Apttus_QPConfig__OptionId__c = prod2.id;
		QuoteLI2.Apttus_QPConfig__NetPrice__c =10;


		insert QuoteLI2;

		/*  --- with Option ---*/

		 Apttus_Proposal__Proposal_Line_Item__c Option2QLI  = new Apttus_Proposal__Proposal_Line_Item__c();
		Option2QLI.Apttus_Proposal__Proposal__c = quoteProposal2.id;
		Option2QLI.Apttus_QPConfig__LineType__c = 'Option';
		Option2QLI.Apttus_QPConfig__ItemSequence__c = 3;
		Option2QLI.Apttus_QPConfig__LineNumber__c =3;
		Option2QLI.NokiaCPQ_Configuration_Type__c ='Standalone';
		Option2QLI.Apttus_Proposal__Product__c = prodB2.id;
		Option2QLI.Apttus_QPConfig__OptionId__c = Option2.id;
		Option2QLI.Apttus_QPConfig__NetPrice__c =10;


		insert Option2QLI;

		// Quote LI2
		Apttus_Proposal__Proposal_Line_Item__c QuoteLI3 = new Apttus_Proposal__Proposal_Line_Item__c();
		QuoteLI3.Apttus_Proposal__Proposal__c = quoteProposal2.id;
		QuoteLI3.Apttus_QPConfig__ItemSequence__c = 2;
		QuoteLI3.Apttus_QPConfig__LineNumber__c =2;
		QuoteLI3.NokiaCPQ_Configuration_Type__c ='Standalone';
		QuoteLI3.DS_Grouping_Name__c ='Test';
		QuoteLI3.Apttus_Proposal__Product__c = prod2.id;
		QuoteLI3.Apttus_QPConfig__LineType__c ='Product/Service';

		QuoteLI3.Apttus_QPConfig__NetPrice__c =10;

		insert QuoteLI3;


		Apttus_Proposal__Proposal_Line_Item__c QuoteLIS2 = new Apttus_Proposal__Proposal_Line_Item__c();
		QuoteLIS2.Apttus_Proposal__Proposal__c = quoteProposal2.id;
		QuoteLIS2.Apttus_QPConfig__ItemSequence__c = 2;
		QuoteLIS2.Apttus_QPConfig__LineNumber__c =2;
		QuoteLIS2.NokiaCPQ_Configuration_Type__c ='Standalone';
		QuoteLIS2.DS_Grouping_Name__c ='Test';
		QuoteLIS2.Apttus_Proposal__Product__c = prodS2.id;
		QuoteLIS2.Apttus_QPConfig__LineType__c ='Product/Service';

		QuoteLIS2.Apttus_QPConfig__NetPrice__c =10;

		insert QuoteLIS2;



		DS_DisplayQuoteLI_Information.getQuoteDetails(quoteProposal2.id);
		Test.stopTest();


	}


	 static testmethod void DS_DisplayQuoteLI_InformationTest2(){

		/********  Account Insertion *************/
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='100006843';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		database.insert(accLegalEntity);

		Account accountCreationDP = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreationDP);

		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();

		/**************** Product Insertion  ************/
		product2 prod2 = new product2();
			prod2.name = 'StandaloneTest';
			prod2.CurrencyIsoCode = 'USD';
			prod2.ProductCode='1234';
			prod2.IsActive=True;
			Prod2.Apttus_Config2__ConfigurationType__c = 'Standalone';

			insert prod2;

		/**************** Price List  *****************/
		Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
		database.insert(priceList);

		/****************** PLI Record  *****************/
		Apttus_Config2__PriceListItem__c PriceListItem= TestdataFactory.createPriceListItem(1,priceList)[0];

		PriceListItem.Apttus_Config2__ProductId__c =  prod2.id;
		database.insert(PriceListItem);


		/*************** feature ************************/

		ProductFeature__c   feature = new ProductFeature__c();
		feature.Feature_Commercial_Number__c ='Feature_SMB';
		feature.Description__c ='Test';
		feature.NSNClassification__c ='Feature Component';
		feature.NSN_Code__c ='123';

		insert feature;

		Product_Feature_Junction__c  pfj = new Product_Feature_Junction__c();
		pfj.Product__c = prod2.id;
		pfj.Product_Feature__c = feature.id;

		insert pfj;

		/***************** Digital Proposal *******************/

		SWx_Upsell_Proposal__c upsellProposal_SWX= new SWx_Upsell_Proposal__c();
		upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal_SWX.Analytics_Source__c='CXM';
		upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
		upsellProposal_SWX.P20_Id__c=215616;
		upsellProposal_SWX.Sold_To_Party__c = accLegalEntity.id;
		upsellProposal_SWX.CurrencyIsoCode='EUR';
		upsellProposal_SWX.Unweighted_Value__c=429052.07;
		upsellProposal_SWX.Account_ID__c=accLegalEntity.id;
		upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
		database.insert(upsellProposal_SWX);

		/************** DP Item insertion ********************/

		set<ID> upsellproposalId_SWX= new set<Id>();
		upsellproposalId_SWX.add(upsellProposal_SWX.Id);

		List<SWx_Upsell_Items__c> lstSWXUpsellItems = TestDataFactory.createSWXLineItems(upsellproposalId_SWX,1);
		database.insert(lstSWXUpsellItems);

		/************** opty Insertion ************************/
		Opportunity oppty ;
		oppty = TestDataFactory.OpportunityCreation(1,accountCreationDP)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=RecordTypeId;
		oppty.SWx_Upsell_Proposal__c =upsellProposal_SWX.Id;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;

		database.insert(oppty);

		Test.startTest();

		/*********************** Quote Insertion ********************************/
		Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id;
		quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';

		quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal2.Prices_Aligned__c=true;
		quoteProposal2.Apttus_Proposal__Account__c=accLegalEntity.id;
		 quoteProposal2.Sold_To_Party__c = accLegalEntity.id;
		database.insert(quoteProposal2);

		/******************** Quote LI Insertion ******************************/

		Apttus_Proposal__Proposal_Line_Item__c QuoteLI2 = new Apttus_Proposal__Proposal_Line_Item__c();
		QuoteLI2.Apttus_Proposal__Proposal__c = quoteProposal2.id;
		QuoteLI2.Apttus_QPConfig__LineType__c = 'Product/Service';
		QuoteLI2.Apttus_QPConfig__ItemSequence__c = 1;
		QuoteLI2.Apttus_QPConfig__LineNumber__c =1;
		QuoteLI2.NokiaCPQ_Configuration_Type__c ='Standalone';
		QuoteLI2.Apttus_Proposal__Product__c = prod2.id;
		QuoteLI2.Apttus_QPConfig__OptionId__c = prod2.id;
		QuoteLI2.Apttus_QPConfig__NetPrice__c =10;

		insert QuoteLI2;
		Set<Id> AccRecIdSet = new Set<Id>();
		AccRecIdSet.add(accountCreationDP.id);
		DS_DisplayQuoteLI_Information.getQuoteDetails(quoteProposal2.id);
		Test.stopTest();


	}

	static testmethod void getAttributeMapForQuoteTest(){
		//Account Insertion
		Account legalEntity = TestDataFactory.createAccount(1)[0];
		legalEntity.AccountNumber = '100006843';
		legalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		Database.insert(legalEntity);

		Account account = TestDataFactory.createAccount(1)[0];
		Database.insert(account);

		//DS Staging
		String json = '{'+
			'  \"header\": {'+
			'	\"source_id\": \"CXM-FDD LTE-Robot12321\",'+
			'	\"file_reference_id\": \"CXM000001-DCOOcdfdgasad\",'+
			'	\"account_id\": \"100006843\",'+
			'	\"creation_date\": \"2018-07-04\",'+
			'	\"start_date\": \"2018-05-02\",'+
			'	\"end_date\": \"2018-05-02\",'+
			'	\"category_Type\": \"SW Recommendation\"'+
			'  },'+
			'  \"line_items\":['+
			'   '+
			'	{'+
			'	  \"use_case\":\"Air interface UL\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000319.T\",'+
			'	  \"quantity\": 11'+
			'	},'+
			'	{'+
			'	  \"use_case\":\"Energy Efficiency\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000172.T\",'+
			'	  \"quantity\": 7'+
			'	}'+
			'  ]'+
			'}';

		DS_Staging__c staging = new DS_Staging__c();
		staging.Payload_Status__c='Success';
		staging.DS_Payload__c= json ;
		Database.insert(staging);

		//Agreement
		Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
		agreement.Apttus__Account__c = legalEntity.id;
		agreement.Sold_to_party_number__c = legalEntity.id;
		Database.insert(agreement);

		//Product
		Product2 product = new Product2(
			Name = 'Test1',
			ProductCode = '123',
			Business_Group__c = 'NSW',
			CurrencyIsoCode = 'USD',
			IsActive = true
		);
		Database.insert(product);

		//Price List
		Apttus_Config2__PriceList__c priceList = TestdataFactory.priceList(1)[0];
		Database.insert(priceList);

		//PLI Record
		Apttus_Config2__PriceListItem__c PriceListItem = TestdataFactory.createPriceListItem(1, priceList)[0];
		Database.insert(PriceListItem);

		//Opportunity
		Opportunity opportunity = TestDataFactory.OpportunityCreation(1, account)[0];
		opportunity.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		opportunity.Lead_BG__c = 'MN';
		opportunity.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		Database.insert(opportunity);

		//Quote/Proposal
		Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal.DS_Staging__c = staging.id;
		quoteProposal.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
		quoteProposal.Contract_Type_Name__c = 'Project';
		quoteProposal.Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal.Apttus_Proposal__Proposal_Name__c = 'Test Data';
		quoteProposal.Apttus_Proposal__Opportunity__c = opportunity.id;
		quoteProposal.Apttus_Proposal__Account__c = account.Id;
		quoteProposal.Sold_To_Party__c = legalEntity.id;
		quoteProposal.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal.Apttus_Proposal__Approval_Stage__c = 'Approved';
		quoteProposal.LOA_Status__c = 'Approved';
		Database.insert(quoteProposal);

		//create product configuration
		Apttus_Config2__ProductConfiguration__c productConfiguration = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config',
			Apttus_Config2__AccountId__c = account.Id,
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_QPConfig__Proposald__c = quoteProposal.Id,
			Apttus_Config2__Status__c = 'New',
			Apttus_Config2__VersionNumber__c = 1,
			Apttus_Config2__EffectivePriceListId__c = priceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(quoteProposal.Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		Database.insert(productConfiguration);

		//Attributes
		Map<Integer, List<Sobject>> attributeMap = new Map<Integer, List<Sobject>>();
		List<Sobject> attributeList = new List<SObject>();
		Customer_facing_Attribute__c attribute1 = new Customer_facing_Attribute__c(
			Attribute_Name__c = 'Use Case',
			Attribute_Label__c = 'Use Case',
			Attribute_Value__c = 'Energy Efficiency',
			Attribute_Visibility__c = 'Yes'
		);
		attributeList.add((SObject) attribute1);
		attributeMap.put(1, attributeList);

		Customer_facing_Attribute__c attribute2 = new Customer_facing_Attribute__c(
			Attribute_Name__c = 'Technology',
			Attribute_Label__c = 'Technology',
			Attribute_Value__c = 'FDD LTE',
			Attribute_Visibility__c = 'Yes'
		);
		attributeList.add((SObject) attribute2);
		attributeMap.put(2, attributeList);

		Customer_facing_Attribute__c attribute3 = new Customer_facing_Attribute__c(
			Attribute_Name__c = 'Not visible test Attribute',
			Attribute_Label__c = 'Not visible test Attribute',
			Attribute_Value__c = 'Whatever',
			Attribute_Visibility__c = 'No'
		);
		attributeList.add((SObject) attribute3);
		attributeMap.put(3, attributeList);

		List<Apttus_Proposal__Proposal__c> quoteList = new List<Apttus_Proposal__Proposal__c>();
		quoteList.add(quoteProposal);

		DS_Populate_CFAttributes.createCFAforQuote(attributeList, quoteList);

		//CPO
		Apttus_Config2__CustomerPurchaseOrder__c cpoRecord = new Apttus_Config2__CustomerPurchaseOrder__c(
			Sold_to_party__c = legalEntity.id,
			Opportunity__c = opportunity.id,
			Contract_start_date__c = System.today(),
			Contract_end_date__c = system.today()+365,
			Terms__c = 12,
			WBS__c = 'Test_WBS',
			Legacy_CPO__c = true,
			Apttus_QPConfig__ProposalId__c = quoteProposal.id
		);
		Database.insert(cpoRecord);

		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoList = new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		cpoList.add(cpoRecord);

		//Create Line Items
		list<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c = productConfiguration.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineStatus__c ='New',
			Apttus_Config2__PriceListId__c = priceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price',
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = product.Id,
			Apttus_Config2__PriceListItemId__c = pricelistitem.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__LineNumber__c = 1.0,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = account.Id,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		lineItemList.add(lineItem);
		Database.insert(lineItemList);

		DS_Populate_CFAttributes.createCFAforConfigItem(attributeMap, quoteList);

		//Quote Line Item
		Apttus_Proposal__Proposal_Line_Item__c quoteLI = new Apttus_Proposal__Proposal_Line_Item__c(
			Apttus_Proposal__Proposal__c = quoteProposal.id,
			Apttus_QPConfig__ItemSequence__c = 1,
			Apttus_QPConfig__LineNumber__c = 1,
			Apttus_QPConfig__LineType__c = 'Product/Service',
			NokiaCPQ_Configuration_Type__c ='Standalone',
			Apttus_Proposal__Product__c = product.id,
			Apttus_QPConfig__OptionId__c = product.id,
			Apttus_QPConfig__NetPrice__c = 10
		);
		Database.insert(quoteLI);

		//A little hack from my friends
		List<Customer_facing_Attribute__c> Items = [SELECT Id FROM Customer_facing_Attribute__c WHERE Attribute_Indicator__c = 'Item'];
		for ( Customer_facing_Attribute__c item : Items) {
			item.Quote_Line_Item__c = quoteLI.Id;
		}
		Database.update(Items);

		//Customer PO Item
		Apttus_Config2__CustomerPOItem__c cpoItem = new Apttus_Config2__CustomerPOItem__c(
			Apttus_Config2__PurchaseOrderId__c = cpoRecord.id,
			Apttus_QPConfig__ProposalLineItemId__c = quoteLI.id,
			Apttus_Config2__ProductId__c = product.id,
			Apttus_Config2__StartDate__c = Date.today() + 5,
			Apttus_Config2__EndDate__c = system.today() + 365
		);
		Database.insert(cpoItem);

		List<Apttus_Config2__CustomerPOItem__c> cpoItemList = new List<Apttus_Config2__CustomerPOItem__c>();
		cpoItemList.add(cpoItem);

		DS_Populate_CFAttributes.updateCFAforCPO(cpoList, cpoItemList);

		Map<String, Map<String, String>> resultMap = DS_DisplayQuoteLI_Information.getAttributeMapForQuote(quoteProposal.Id);
		System.debug('getAttributeMapForQuote -> resultMap=' + resultMap);
		System.debug('getAttributes query->' + [SELECT Attribute_Label__c, Attribute_Name__c, Quote_Line_Item__c, Attribute_Visibility__c, Attribute_Indicator__c FROM Customer_facing_Attribute__c WHERE Attribute_Indicator__c = 'Item']);
		System.assert(resultMap.keySet().size() == 1);
		Map<String, String> expectedValues = new Map<String, String>();
		expectedValues.put('Technology', 'FDD LTE');
		expectedValues.put('Use Case', 'Energy Efficiency');
		System.assert(resultMap.get(quoteLI.Id) == expectedValues);
	}


}