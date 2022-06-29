/**
 * @description	:
 * @author			: Yashdeep Prajapati
 * @group	:
 * @last modified on  : 09-27-2021
 * @last modified by  : Yashdeep Prajapati
 **/
@istest(SeeAllData=false)

public with sharing class SearchProductTest{
static testMethod void CurrenychangeTest() {

	//List<User> adminuser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Data Loader Profile');
	
	List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
		Global_Control__c gc = new Global_Control__c();
		gc.ObjectTriggerByPass__c = 'PROD2';
		insert gc; 

		Account acc = new Account();
		acc.Name ='Test Account';
		acc.Partner_Program__c='GPP 3.0';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		List<Account> accounts = new List<Account>();
		accounts.add(acc);
		acc.Active__c= True;
		Insert accounts;

		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = new List<opportunity>();
		opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[0].id;
		insert opportunities;

		//create Accreditation
		List<Accreditation__c > accreditations = new List<Accreditation__c >();
		accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';
		// accreditations[1].Partner_Program__c = 'GPP 3.0';
		insert accreditations;

		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = new List<Apttus_Proposal__Proposal__c >();
		proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing';
		//  proposals[0].Reprice_In_Progress__c = false;
		//Modified for ITCCPQ-2555 by Christie JJ
		//proposals[0].NokiaCPQ_Maintenance_Accreditation__c=accreditations[1].id;
		//proposals[0].NokiaProductAccreditation__c = accreditations[0].id;

		//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
		proposals[0].RecordTypeId ='01241000001EPXcAAO';	//indirect draft quote
		insert proposals;
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);

		Apttus_Config2__PriceList__c objPriceList = new Apttus_Config2__PriceList__c(
			Name = 'Global Price List (EUR)',
			Apttus_Config2__Type__c = 'Standard',
			PriceList_Type__c = 'CPQ',
			Apttus_Config2__Active__c = True,
			CurrencyIsoCode = 'EUR'
			);
		insert objPriceList;

		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Direct Price List (GBP)';
		priceList.CurrencyIsoCode='EUR';		//'GBP';
		priceList.Apttus_Config2__BasedOnPriceListId__c=objPriceList.id;
		priceList.Apttus_Config2__Active__c=true;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		insert priceList;
		//Create Product Configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = new List<Apttus_Config2__ProductConfiguration__c>();
		prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = objPriceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		insert prodConfigs;
		//get a IP Routing Product

		Product2 productInst = new Product2();
		//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
		productInst.Name = 'Test Product';
		productInst.Portfolio__c = 'IP Routing';
		productInst.ProductCode = 'SRS001';
		productInst.Description = 'Vital Suite';
		productInst.NokiaCPQ_State__c = 'Implement';
		productInst.NokiaCPQ_Product_Discount_Category__c = '7210 IPR';
		insert productInst;

		Product2 productInst2 = new Product2();
		//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
		productInst2.Name = 'Test Product';
		productInst2.Portfolio__c = '';
		productInst2.ProductCode = 'CUSTPROD001';
		productInst2.Description = 'Vital Suite';
		productInst2.NokiaCPQ_State__c = 'Implement';
		productInst2.NokiaCPQ_Product_Discount_Category__c = '7210 IPR';
		insert productInst2;

		Product2 productIns = new Product2();
		//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
		productIns.Name = 'PROD11';
		productIns.Portfolio__c = 'IP Routing';
		productIns.ProductCode = 'SRS001';
		productIns.Description = 'Vital Suite';
		productIns.NokiaCPQ_State__c = 'Release';
		productIns.NokiaCPQ_Product_Discount_Category__c = '7210 IPR';
		insert productIns;

		List<Pre_Approved_Custom_Products__c> preApprovedProducts = new List<Pre_Approved_Custom_Products__c>();
		Pre_Approved_Custom_Products__c preApprovedProductsRecord1 = new Pre_Approved_Custom_Products__c(Account__c=acc.Id,Expiration_Date__c=System.Today(),Is_NSP__c=true,List_Price__c=5.0,Maintenance_Beyond_Warranty_Rate__c=1.0,Maintenance_Type__c='Gold (Return for Exchange)',Maintenance_Under_Warranty_Rate__c=2.0,Portfolio__c='IP Routing',Product_Code__c='PROD1',Product_Discount_Rate__c=3.0,SSP_Rate__c=4.0);
		Pre_Approved_Custom_Products__c preApprovedProductsRecord2 = new Pre_Approved_Custom_Products__c(Account__c=acc.Id,Expiration_Date__c=Date.today().addDays(100),Is_NSP__c=true,List_Price__c=5.0,Maintenance_Beyond_Warranty_Rate__c=1.0,Maintenance_Type__c='Gold (Return for Exchange)',Maintenance_Under_Warranty_Rate__c=2.0,Portfolio__c='IP Routing',Product_Code__c='CUSTPROD001',Product_Discount_Rate__c=3.0,SSP_Rate__c=4.0);

		preApprovedProducts.add(preApprovedProductsRecord1);
		preApprovedProducts.add(preApprovedProductsRecord2);
		insert preApprovedProducts;
		//Creating Price Rule Entry
		//Apttus_Config2__PriceRuleEntry__c pr_entry = new Apttus_Config2__PriceRuleEntry__c();
		//Apttus_Config2__PriceRuleEntry__c pr_obj = [Select id,Apttus_Config2__PriceRuleId__c,Apttus_Config2__Sequence__c from Apttus_Config2__PriceRuleEntry__c LIMIT 1 ];
		//pr_entry.id = pr_obj.id;
		//pr_entry.Apttus_Config2__PriceRuleId__c = pr_obj.Apttus_Config2__PriceRuleId__c;
		//pr_entry.Apttus_Config2__Sequence__c = pr_obj.Apttus_Config2__Sequence__c;
		//pr_entry.Apttus_Config2__AdjustmentAmount__c = 65;
		//insert pr_entry;
		// create a Line Item
		Apttus_Config2__PriceListItem__c pli = TestDatafactory.createPriceListItem(1,objPriceList)[0];
		pli.Apttus_Config2__ProductId__c= productInst.id;
		pli.Apttus_Config2__Active__c= true;
		insert pli;

		List<Apttus_Config2__LineItem__c> lineItems = new List<Apttus_Config2__LineItem__c>();
		lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
		lineItems[0].Apttus_Config2__LineNumber__c = 10;
		lineItems[0].Apttus_Config2__PrimaryLineNumber__c =  10;
		lineItems[0].Apttus_Config2__ItemSequence__c = 10;
		lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
		lineItems[0].Apttus_Config2__ProductId__c = productInst.Id;
		lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
		lineItems[0].Apttus_Config2__ChargeType__c ='Standard Price';
		insert lineItems;
		
		NCPQ_Settings__c cpqSetting = new NCPQ_Settings__c();
		cpqSetting.NCPQ_MaintenanceProdCodes__c = 'test';
		cpqSetting.NCPQ_SPS_SRS_ProdCodes__c = 'test';
		cpqSetting.Name = 'test';
		insert cpqSetting; 
		
		map<string,ID> mapCodeId = new map<string,ID>();
		for(Apttus_Config2__LineItem__c LineItemInstance:lineItems)
		{
			mapCodeId.put(LineItemInstance.Apttus_Config2__ProductId__r.ProductCode,LineItemInstance.id);
		}
		map<string,ID> mapSSP = new map<string,ID>();
		for(Apttus_Config2__LineItem__c LineItemInstance:lineItems)
		{
			mapSSP.put('SSP002',LineItemInstance.id);
		}
		SearchProductWrapper wrapper = new SearchProductWrapper();
		wrapper.strProductCode = 'Test';
		SearchProductWrapper wrapper1 = new SearchProductWrapper();
		wrapper.strProductCode = 'CUSTPROD001';

		Test.startTest();
		// SearchProduct.setLineItemsNumber(productInst.Id,wrapper);
		SearchProduct.setLineItemsNumber(prodConfigs[0].id,wrapper);
		//  SearchProduct.setLineItemsNumber(null,null);
		SearchProduct.getDetailsProduct(productInst2.id,prodConfigs[0].id);
		SearchProduct.getDetailsProduct(null,prodConfigs[0].id);
		SearchProduct.getProductConfig(prodConfigs[0].id);
		SearchProduct.getProductConfig(null);
		SearchProduct.getLineItemValue(productInst.id,prodConfigs[0].id,'test Portfolio');
		SearchProduct.fetchProduct('CUSTPROD001',prodConfigs[0].id);
		SearchProduct.fetchProduct('PROD',prodConfigs[0].id);
		SearchProduct.createPriceLineItems(productInst.id,priceList.id);
		SearchProduct.createPriceLineItems(null,null);
		SearchProduct.getProductID();
		SearchProduct.prodAvailabilityCheck(new List<string> {'CUSTPROD001'}, prodConfigs[0].Id);
		/*  SearchProduct.createMaint(prodConfigs[0].id,true);
	 SearchProduct.createMaint(prodConfigs[0].id,false);
	 SearchProduct.createSRSRecord(prodConfigs[0].id,mapCodeId);
	 SearchProduct.createSSPRecord(prodConfigs[0].id,mapSSP);
	 SearchProduct.createmaint2(null,null);
	 SearchProduct.createmaint1(null,null);
	 SearchProduct.createMaint(null,null);
	 SearchProduct.createSRSRecord(null,null); */
		SearchProduct.getDetailsProduct(null,null);
		SearchProduct.executeAdditionalOperation(prodConfigs[0].id);
		SearchProduct.getSubPortfolioPicklistEntry(prodConfigs[0].id);
		Test.stopTest();



	}

}
static testMethod void CurrenychangeTest2(){
	/*Apttus_Config2__LineItem__c objLineItem = [select id,Apttus_Config2__LineNumber__c,Apttus_Config2__PrimaryLineNumber__c,Apttus_Config2__ItemSequence__c
	from Apttus_Config2__LineItem__c LIMIT 1];
	Test.startTest();
	SearchProduct.setLineItemsNumber(objLineItem.id,null);
	Test.stopTest();*/
	//List<User> adminuser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Data Loader Profile');
	List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
		Global_Control__c gc = new Global_Control__c();
		gc.ObjectTriggerByPass__c = 'PROD2';
		insert gc; 
	
		Account acc = new Account();
		acc.Name ='Test Account';
		acc.Partner_Program__c='GPP 3.0';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		List<Account> accounts = new List<Account>();
		accounts.add(acc);
		acc.Active__c= True;
		Insert accounts;

		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = new List<opportunity>();
		opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[0].id;
		insert opportunities;

		//create Accreditation
		List<Accreditation__c > accreditations = new List<Accreditation__c >();
		accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';
		// accreditations[1].Partner_Program__c = 'GPP 3.0';
		insert accreditations;

		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = new List<Apttus_Proposal__Proposal__c >();
		proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing';
		//  proposals[0].Reprice_In_Progress__c = false;
		//proposals[0].NokiaCPQ_Maintenance_Accreditation__c=accreditations[1].id;//FN Commented
		//proposals[0].NokiaProductAccreditation__c = accreditations[0].id; ////FN Commented
		proposals[0].NokiaCPQ_LEO_Discount__c = true;

		//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
		proposals[0].RecordTypeId ='01241000001EPXcAAO';	//indirect draft quote
		insert proposals;
		system.debug('>>>Quote Record Type::>>'+proposals[0].recordtypeID);

		Apttus_Config2__PriceList__c objPriceList = new Apttus_Config2__PriceList__c(
			Name = 'Global Price List (EUR)',
			Apttus_Config2__Type__c = 'Standard',
			PriceList_Type__c = 'CPQ',
			Apttus_Config2__Active__c = True,
			CurrencyIsoCode = 'EUR'
			);
		insert objPriceList;

		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Direct Price List (GBP)';
		priceList.CurrencyIsoCode='EUR';		//'GBP';
		priceList.Apttus_Config2__BasedOnPriceListId__c=objPriceList.id;
		priceList.Apttus_Config2__Active__c=true;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		insert priceList;
		//Create Product Configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = new List<Apttus_Config2__ProductConfiguration__c>();
		prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = objPriceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		insert prodConfigs;
		//get a IP Routing Product

		Product2 productInst = new Product2();
		//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
		productInst.Name = 'Test Product';
		productInst.Portfolio__c = 'IP Routing';
		productInst.ProductCode = 'SRS001';
		productInst.Description = 'Vital Suite';
		productInst.NokiaCPQ_State__c = 'Implement';
		productInst.NokiaCPQ_Product_Discount_Category__c = '7210 IPR';
		insert productInst;

		Product2 productInst2 = new Product2();
		//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
		productInst2.Name = 'Test Product';
		productInst2.Portfolio__c = '';
		productInst2.ProductCode = 'CUSTPROD001';
		productInst2.Description = 'Vital Suite';
		productInst2.NokiaCPQ_State__c = 'Implement';
		productInst2.NokiaCPQ_Product_Discount_Category__c = '7210 IPR';
		insert productInst2;

		Product2 productIns = new Product2();
		//productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c Limit 1];
		productIns.Name = 'PROD11';
		productIns.Portfolio__c = 'IP Routing';
		productIns.ProductCode = 'SRS001';
		productIns.Description = 'Vital Suite';
		productIns.NokiaCPQ_State__c = 'Release';
		productIns.NokiaCPQ_Product_Discount_Category__c = '7210 IPR';
		insert productIns;
		//Creating Price Rule Entry
		//Apttus_Config2__PriceRuleEntry__c pr_entry = new Apttus_Config2__PriceRuleEntry__c();
		//Apttus_Config2__PriceRuleEntry__c pr_obj = [Select id,Apttus_Config2__PriceRuleId__c,Apttus_Config2__Sequence__c from Apttus_Config2__PriceRuleEntry__c LIMIT 1 ];
		//pr_entry.id = pr_obj.id;
		//pr_entry.Apttus_Config2__PriceRuleId__c = pr_obj.Apttus_Config2__PriceRuleId__c;
		//pr_entry.Apttus_Config2__Sequence__c = pr_obj.Apttus_Config2__Sequence__c;
		//pr_entry.Apttus_Config2__AdjustmentAmount__c = 65;
		//insert pr_entry;
		// create a Line Item
		Apttus_Config2__PriceListItem__c pli = TestDatafactory.createPriceListItem(1,objPriceList)[0];
		pli.Apttus_Config2__ProductId__c= productInst.id;
		pli.Apttus_Config2__Active__c= true;
		insert pli;

		List<Apttus_Config2__LineItem__c> lineItems = new List<Apttus_Config2__LineItem__c>();
		lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
		lineItems[0].Apttus_Config2__LineNumber__c = 10;
		lineItems[0].Apttus_Config2__PrimaryLineNumber__c =  10;
		lineItems[0].Apttus_Config2__ItemSequence__c = 10;
		lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
		lineItems[0].Apttus_Config2__ProductId__c = productInst.Id;
		lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
		lineItems[0].Apttus_Config2__ChargeType__c ='Standard Price';
		insert lineItems;

		map<string,ID> mapCodeId = new map<string,ID>();
		for(Apttus_Config2__LineItem__c LineItemInstance:lineItems)
		{
			mapCodeId.put(LineItemInstance.Apttus_Config2__ProductId__r.ProductCode,LineItemInstance.id);
		}
		map<string,ID> mapSSP = new map<string,ID>();
		for(Apttus_Config2__LineItem__c LineItemInstance:lineItems)
		{
			mapSSP.put('SSP002',LineItemInstance.id);
		}
		SearchProductWrapper wrapper = new SearchProductWrapper();
		wrapper.strProductCode = 'Test';
		SearchProductWrapper wrapper1 = new SearchProductWrapper();
		wrapper.strProductCode = 'CUSTPROD001';

		Test.startTest();
		// SearchProduct.setLineItemsNumber(productInst.Id,wrapper);
		SearchProduct.setLineItemsNumber(prodConfigs[0].id,wrapper);
		// SearchProduct.setLineItemsNumber(null,null);
		SearchProduct.getDetailsProduct(productInst2.id,prodConfigs[0].id);
		SearchProduct.getDetailsProduct(null,prodConfigs[0].id);
		SearchProduct.getProductConfig(prodConfigs[0].id);
		SearchProduct.getProductConfig(null);
		SearchProduct.getLineItemValue(productInst.id,prodConfigs[0].id,'Test Portfolio');
		SearchProduct.fetchProduct('CUSTPROD001',prodConfigs[0].id);
		SearchProduct.fetchProduct('PROD',prodConfigs[0].id);
		SearchProduct.createPriceLineItems(productInst.id,priceList.id);
		SearchProduct.createPriceLineItems(null,null);
		SearchProduct.getProductID();
		/*  SearchProduct.createMaint(prodConfigs[0].id,true);
	 SearchProduct.createMaint(prodConfigs[0].id,false);
	 SearchProduct.createSRSRecord(prodConfigs[0].id,mapCodeId);
	 SearchProduct.createSSPRecord(prodConfigs[0].id,mapSSP);
	 SearchProduct.createmaint2(null,null);
	 SearchProduct.createmaint1(null,null);
	 SearchProduct.createMaint(null,null);
	 SearchProduct.createSRSRecord(null,null); */
		SearchProduct.getDetailsProduct(null,null);
		Test.stopTest();



	}

}

}