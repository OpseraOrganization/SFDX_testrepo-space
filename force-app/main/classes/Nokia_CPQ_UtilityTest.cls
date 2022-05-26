/***
 * @description	:
 * @author			: Yashdeep Prajapati
 * @group	:
 * @last modified on  : 01-31-2022
 * @last modified by  : Yashdeep Prajapati
 ***/
@isTest
public with sharing class Nokia_CPQ_UtilityTest{

@testSetup static void methodName() {
	List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
		Nokia_CPQ_Constants.isCloneRun = true;
		// Create a test account
		List<Account> accounts=TestDataFactory.createAccount(2);
		accounts[0].AccountNumber='3011546567YP';
		accounts[0].Acc_No__c = '3011546567';
		accounts[0].CountryCode__c='IN';
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[1].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[0].Partner_Type__c='Value Added Reseller';
		accounts[0].Partner_Program__c =PRMGlobalConstants.Partner_Program3;
		accounts[1].Partner_Type__c='';
		accounts[1].Partner_Program__c = 'SPAAP';
		insert accounts;

		//Insert Accreditations
		// List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		// accreditations[0].partner__c = accounts[0].Id;
		// accreditations[1].partner__c = accounts[0].Id;
		// accreditations[1].Accreditation_Type__c = 'Maintenance';
		// accreditations[1].Accreditation_Level__c = 'Premium';
		// accreditations[1].Pricing_Level_Override__c = 'Premium';
		// insert accreditations;

		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditationforProd(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Level__c = 'Authorized';
		accreditations[0].Pricing_Level_Override__c ='Authorized';
		accreditations[0].Accreditation_Level__c = 'Expert';
		accreditations[1].Pricing_Level_Override__c ='Expert';
		accreditations[0].RecordTypeId = Schema.SObjectType.Accreditation__c.getRecordTypeInfosByDeveloperName().get('Reseller_GPP_3_0').getRecordTypeId();
		accreditations[1].RecordTypeId = Schema.SObjectType.Accreditation__c.getRecordTypeInfosByDeveloperName().get('Reseller_GPP_3_0').getRecordTypeId();
		accreditations[1].Portfolio__c = 'Fixed Access - FBA';

		accreditations.addAll(NOKIA_CPQ_TestDataFactory.createAccreditationMaintenance(2));
		accreditations[2].partner__c = accounts[0].Id;
		accreditations[3].partner__c = accounts[0].Id;
		accreditations[2].RecordTypeId = Schema.SObjectType.Accreditation__c.getRecordTypeInfosByDeveloperName().get('Reseller_GPP_3_0').getRecordTypeId();
		accreditations[3].RecordTypeId = Schema.SObjectType.Accreditation__c.getRecordTypeInfosByDeveloperName().get('Reseller_GPP_3_0').getRecordTypeId();
		accreditations[3].Portfolio__c = 'Fixed Access - FBA';
		insert accreditations;

		// Creates first opportunity
		List<Opportunity> opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Business_Type__c = 'Standard Opportunity';
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).End_Customer_LE__c = accounts[1].Id;
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		insert opportunities.get(0);
		List<product2> lstProduct = TestDataSetup.createCPQTestproduct(1);
		lstProduct[0].Portfolio__c = 'IP Routing';
		insert lstProduct;
		Apttus_Config2__PriceList__c objPriceList = TestDataSetup.createpriceListSO();
		insert objPriceList;
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = objPriceList.Id,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__ProductId__c = lstProduct[0].Id,
			Apttus_Config2__ChargeType__c = 'Standard Price'
			);
		insert pLI1;
		List<Apttus_Proposal__Proposal__c> propList = new List<Apttus_Proposal__Proposal__c>();
		Apttus_Proposal__Proposal__c objProposal = TestDataSetup.creatProposal(opportunities[0], accounts[0], objPriceList);
		objProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
		//Added for ITCCPQ-2556 byy Christie JJ
		objProposal.CPQ_SubPortfolio__c = 'IP Routing;';
		objProposal.NokiaCPQ_No_of_Years__c = null;
		propList.add(objProposal);
		Apttus_Proposal__Proposal__c objProposal1 = TestDataSetup.creatProposal(opportunities[0], accounts[0], objPriceList);
		objProposal1.NokiaCPQ_Portfolio__c = 'Fixed Networks';
		objProposal1.NokiaCPQ_No_of_Years__c = null;
		objProposal1.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
		propList.add(objProposal1);
		insert propList;
		Apttus_Config2__ProductConfiguration__c objProductConfiguration = TestDataSetup.creatProductConfiguration(accounts[0], objPriceList, objProposal);
		insert objProductConfiguration;
		//List<Apttus_Config2__LineItem__c> objLineItem = TestDataSetup.creatConfigLineItem(accounts[0], objProductConfiguration, objPriceList, lstProduct[0], 1);
		list<Apttus_Config2__LineItem__c> objLineItem = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=objProductConfiguration.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__LineSequence__c = 1,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = objPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price',
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = lstProduct[0].Id,
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
		objLineItem.add(LineItem1);
		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=objProductConfiguration.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__LineSequence__c = 2,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = objPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price',
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = lstProduct[0].Id,
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
		objLineItem.add(LineItem2);
		insert objLineItem;
		List<NokiaCPQ_Phase__c> phaseList = new List<NokiaCPQ_Phase__c>();
		NokiaCPQ_Phase__c objPhase1 = new NokiaCPQ_Phase__c();
		objPhase1.Name = 'TestPhase1';
		objPhase1.Opportunity__c = opportunities[0].Id;
		phaseList.add(objPhase1);
		NokiaCPQ_Phase__c objPhase2 = new NokiaCPQ_Phase__c();
		objPhase2.Name = 'TestPhase2';
		objPhase2.Opportunity__c = opportunities[0].Id;
		phaseList.add(objPhase2);
		Insert phaseList;
		List<NokiaCPQ_Site__c> siteList = new List<NokiaCPQ_Site__c>();
		NokiaCPQ_Site__c objSite1 = new NokiaCPQ_Site__c();
		objSite1.Name = 'TestSite1';
		objSite1.Opportunity__c = opportunities[0].Id;
		siteList.add(objSite1);
		NokiaCPQ_Site__c objSite2 = new NokiaCPQ_Site__c();
		objSite2.Name = 'TestSite2';
		objSite2.Opportunity__c = opportunities[0].Id;
		siteList.add(objSite2);
		NokiaCPQ_Site__c objSite3 = new NokiaCPQ_Site__c();
		objSite3.Name = 'TestSite3';
		objSite3.Opportunity__c = opportunities[0].Id;
		siteList.add(objSite3);
		insert siteList;
		List<CPQ_Site_Phase_and_Quantity__c> spqList = new List<CPQ_Site_Phase_and_Quantity__c>();
		CPQ_Site_Phase_and_Quantity__c objSitePhase1 = new CPQ_Site_Phase_and_Quantity__c();
		objSitePhase1.Name = 'TestSitePhase1';
		objSitePhase1.NCPQ_Phase__c = objPhase1.Id;
		objSitePhase1.NCPQ_Site__c =  objSite1.Id;
		objSitePhase1.NCPQ_Quantity__c = 1;
		objSitePhase1.Line_Item__c = objLineItem[1].Id;
		spqList.add(objSitePhase1);
		CPQ_Site_Phase_and_Quantity__c objSitePhase2 = new CPQ_Site_Phase_and_Quantity__c();
		objSitePhase2.Name = 'TestSitePhase2';
		objSitePhase2.NCPQ_Site__c =  objSite3.Id;
		objSitePhase2.NCPQ_Quantity__c = 1;
		objSitePhase2.Line_Item__c = objLineItem[0].Id;
		spqList.add(objSitePhase2);
		insert spqList;
		List<NokiaCPQ_Site_Phase_Configuration__c> listSitePhaseConfig = new List<NokiaCPQ_Site_Phase_Configuration__c> ();
		NokiaCPQ_Site_Phase_Configuration__c objSitePhaseConfig1 = new NokiaCPQ_Site_Phase_Configuration__c();
		objSitePhaseConfig1.NokiaCPQ_Phase__c = objPhase1.Id;
		objSitePhaseConfig1.NokiaCPQ_Sequence__c = 1;
		objSitePhaseConfig1.NokiaCPQ_Configuration__c = objProductConfiguration.Id;
		listSitePhaseConfig.add(objSitePhaseConfig1);
		NokiaCPQ_Site_Phase_Configuration__c objSitePhaseConfig2 = new NokiaCPQ_Site_Phase_Configuration__c();
		objSitePhaseConfig2.NokiaCPQ_Site__c =  objSite1.Id;
		objSitePhaseConfig2.NokiaCPQ_Sequence__c = 1;
		objSitePhaseConfig2.NokiaCPQ_Configuration__c = objProductConfiguration.Id;
		listSitePhaseConfig.add(objSitePhaseConfig2);
		NokiaCPQ_Site_Phase_Configuration__c objSitePhaseConfig3 = new NokiaCPQ_Site_Phase_Configuration__c();
		objSitePhaseConfig3.NokiaCPQ_Site__c =  objSite2.Id;
		objSitePhaseConfig3.NokiaCPQ_Sequence__c = 2;
		objSitePhaseConfig3.NokiaCPQ_Configuration__c = objProductConfiguration.Id;
		listSitePhaseConfig.add(objSitePhaseConfig3);
		NokiaCPQ_Site_Phase_Configuration__c objSitePhaseConfig4 = new NokiaCPQ_Site_Phase_Configuration__c();
		objSitePhaseConfig4.NokiaCPQ_Site__c =  objSite3.Id;
		objSitePhaseConfig4.NokiaCPQ_Sequence__c = 2;
		objSitePhaseConfig4.NokiaCPQ_Configuration__c = objProductConfiguration.Id;
		listSitePhaseConfig.add(objSitePhaseConfig4);
		NokiaCPQ_Site_Phase_Configuration__c objSitePhaseConfig5 = new NokiaCPQ_Site_Phase_Configuration__c();
		objSitePhaseConfig5.NokiaCPQ_Phase__c =  objPhase2.Id;
		objSitePhaseConfig5.NokiaCPQ_Sequence__c = 2;
		objSitePhaseConfig5.NokiaCPQ_Configuration__c = objProductConfiguration.Id;
		listSitePhaseConfig.add(objSitePhaseConfig5);
		NokiaCPQ_Site_Phase_Configuration__c objSitePhaseConfig6 = new NokiaCPQ_Site_Phase_Configuration__c();
		objSitePhaseConfig6.NokiaCPQ_Phase__c =  objPhase1.Id;
		objSitePhaseConfig6.NokiaCPQ_Site__c =  objSite1.Id;
		objSitePhaseConfig6.NokiaCPQ_Aggregator__c = 2;
		objSitePhaseConfig6.NokiaCPQ_Configuration__c = objProductConfiguration.Id;
		listSitePhaseConfig.add(objSitePhaseConfig6);
		insert listSitePhaseConfig;

		List<Pre_Approved_Custom_Products__c> preApprovedProducts = new List<Pre_Approved_Custom_Products__c>();
		Pre_Approved_Custom_Products__c preApprovedProductsRecord1 = new Pre_Approved_Custom_Products__c();
		preApprovedProductsRecord1.Account__c=accounts[0].Id;
		preApprovedProductsRecord1.Expiration_Date__c=System.Today().addDays(100);
		preApprovedProductsRecord1.Is_NSP__c=true;
		preApprovedProductsRecord1.List_Price__c=5.0;
		preApprovedProductsRecord1.Maintenance_Beyond_Warranty_Rate__c=1.0;
		preApprovedProductsRecord1.Maintenance_Type__c='Gold (Return for Exchange)';
		preApprovedProductsRecord1.Maintenance_Under_Warranty_Rate__c=2.0;
		preApprovedProductsRecord1.Portfolio__c='IP Routing';
		preApprovedProductsRecord1.Product_Code__c= lstProduct[0].ProductCode;
		preApprovedProductsRecord1.Product_Discount_Rate__c=3.0;
		preApprovedProductsRecord1.SSP_Rate__c=4.0;
		Pre_Approved_Custom_Products__c preApprovedProductsRecord2 = new Pre_Approved_Custom_Products__c();
		preApprovedProductsRecord2.Account__c=accounts[0].Id;
		preApprovedProductsRecord2.Expiration_Date__c=Date.today().addDays(100);
		preApprovedProductsRecord2.Is_NSP__c=true;
		preApprovedProductsRecord2.List_Price__c=5.0;
		preApprovedProductsRecord2.Maintenance_Beyond_Warranty_Rate__c=1.0;
		preApprovedProductsRecord2.Maintenance_Type__c='Gold (Return for Exchange)';
		preApprovedProductsRecord2.Maintenance_Under_Warranty_Rate__c=2.0;
		preApprovedProductsRecord2.Portfolio__c='IP Routing';
		preApprovedProductsRecord2.Product_Code__c='CUSTPROD001';
		preApprovedProductsRecord2.Product_Discount_Rate__c=3.0;
		preApprovedProductsRecord2.SSP_Rate__c=4.0;

		preApprovedProducts.add(preApprovedProductsRecord1);
		preApprovedProducts.add(preApprovedProductsRecord2);
		insert preApprovedProducts;

		NCPQ_Settings__c cpqSetting = new NCPQ_Settings__c();
		cpqSetting.NCPQ_MaintenanceProdCodes__c = 'test';
		cpqSetting.NCPQ_SPS_SRS_ProdCodes__c = 'test';
		cpqSetting.Name = 'test';
		insert cpqSetting;
	}
}

static testMethod void testSitePhaseConfigCheck() {
	Test.startTest();
	//delete [SELECT Id FROM CPQ_Site_Phase_and_Quantity__c WHERE Name IN ('TestSitePhase1','TestSitePhase4')];
	Apttus_Config2__ProductConfiguration__c config = [SELECT ID FROM Apttus_Config2__ProductConfiguration__c LIMIT 1];
	Nokia_CPQ_Utility.sitePhaseConfigCheck(new Set<Id> {config.Id});
	Nokia_CPQ_Utility.hasAggregation(config.Id);
	Test.stopTest();
}

static testMethod void testCheckForAggregation() {
	Test.startTest();
	Apttus_Proposal__Proposal__c proposal = [SELECT ID FROM Apttus_Proposal__Proposal__c LIMIT 1];
	Nokia_CPQ_Utility.checkForAggregation(proposal.Id);
	Test.stopTest();
}

static testMethod void testCloneSitePhaseQuanity() {
	Test.startTest();
	Apttus_Proposal__Proposal__c proposal = [SELECT ID,NokiaCPQ_Orignal_Quote_Id__c FROM Apttus_Proposal__Proposal__c LIMIT 1];
	Nokia_CPQ_Utility.cloneSitePhaseQuanity(proposal.Id, proposal.Id);
	Test.stopTest();
}

static testMethod void testCloneSiteConfiguration() {
	Test.startTest();
	Apttus_Proposal__Proposal__c proposal = [SELECT ID,NokiaCPQ_Orignal_Quote_Id__c FROM Apttus_Proposal__Proposal__c LIMIT 1];
	Nokia_CPQ_Utility.cloneSiteConfiguration(proposal.Id, proposal.Id);
	Test.stopTest();
}

static testMethod void testInsertSitePhaseConfig() {
	Test.startTest();
	List<Opportunity> opportunities = [SELECT ID FROM Opportunity];
	List<NokiaCPQ_Phase__c> phaseList = new List<NokiaCPQ_Phase__c>();
	NokiaCPQ_Phase__c objPhase1 = new NokiaCPQ_Phase__c();
	objPhase1.Name = 'tt';
	objPhase1.Opportunity__c = opportunities[0].Id;
	phaseList.add(objPhase1);
	NokiaCPQ_Phase__c objPhase2 = new NokiaCPQ_Phase__c();
	objPhase2.Name = 'jj';
	objPhase2.Opportunity__c = opportunities[0].Id;
	phaseList.add(objPhase2);
	Insert phaseList;
	List<NokiaCPQ_Site__c> siteList = new List<NokiaCPQ_Site__c>();
	NokiaCPQ_Site__c objSite1 = new NokiaCPQ_Site__c();
	objSite1.Name = 'kk';
	objSite1.Opportunity__c = opportunities[0].Id;
	siteList.add(objSite1);
	NokiaCPQ_Site__c objSite2 = new NokiaCPQ_Site__c();
	objSite2.Name = 'mm';
	objSite2.Opportunity__c = opportunities[0].Id;
	siteList.add(objSite2);
	Insert siteList;
	Apttus_Config2__ProductConfiguration__c config = [SELECT ID FROM Apttus_Config2__ProductConfiguration__c LIMIT 1];
	Nokia_CPQ_Utility.insertSitePhaseConfig(config.Id, new List<Id> {objSite1.Id,objSite2.Id}, new List<Id> {objPhase1.Id,objPhase2.Id});
	Test.stopTest();
}

static testMethod void testProdAvailabilityCheck() {
	List<string> prodCodes = new List<string>();
	for (Product2 prod : [SELECT ProductCode FROM Product2]) {
		prodCodes.add(prod.ProductCode);
	}
	Apttus_Config2__ProductConfiguration__c config = [SELECT ID,Apttus_Config2__AccountId__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Maintenance_Type__c,NokiaCPQ_Portfolio_From_Quote__c,Quote_Type__c,NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c,Pricing_Cluster_Search_Filter__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_LEO_Discount__c,CPQ_PortfolioClusterSF1__c,CPQ_PortfolioClusterSF2__c,CPQ_PortfolioClusterSF3__c,CPQ_PortfolioClusterSF4__c FROM Apttus_Config2__ProductConfiguration__c LIMIT 1];
	Test.startTest();
	Nokia_CPQ_Utility.prodAvailabilityCheck(prodCodes, config);
	Test.stopTest();
}


static testMethod void testExistingMaintenanceContractCheck() {
	//Need to add additional code to setup test data for Service Contract and Contract Line Items
	Apttus_Proposal__Proposal__c proposal = [SELECT ID,CPQ_SubPortfolio__c,NokiaCPQ_Orignal_Quote_Id__c,NokiaCPQ_Opportunity_Id__c,NokiaCPQ_systemVerifiedContract__c,NokiaCPQ_No_of_Years__c,NokiaCPQ_Existing_IONMaint_Contract__c,NokiaCPQ_Needs_Reprice__c,NokiaCPQ_Portfolio__c FROM Apttus_Proposal__Proposal__c LIMIT 1];
	User objUser = [SELECT ID FROM USER LIMIT 1];
	Test.startTest();
	Nokia_CPQ_Utility.existingMaintenanceContractCheck(proposal);
	Nokia_CPQ_Utility.isUserhasTurboPermission();
	Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing utilNoSharing = new Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing();
	utilNoSharing.isUserLicensedForPackage(objUser.Id, 'CPQ');
	Test.stopTest();
}

//ITCCPQ-504
static testMethod void testFetchProposalRecordType() {
	Apttus_Proposal__Proposal__c proposal = [SELECT ID,NokiaCPQ_Orignal_Quote_Id__c,Quote_Type__c,NokiaCPQ_Opportunity_Id__c,NokiaCPQ_systemVerifiedContract__c,NokiaCPQ_No_of_Years__c,NokiaCPQ_Existing_IONMaint_Contract__c,NokiaCPQ_Needs_Reprice__c,NokiaCPQ_Portfolio__c FROM Apttus_Proposal__Proposal__c LIMIT 1];
	Test.startTest();
	Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing utilNoSharing = new Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing();
	String Id = utilNoSharing.fetchProposalRecordType();
	String Id_Direct = utilNoSharing.fetchProposalRecordType('Direct_Quote');
	Test.stopTest();
}
static void testCheckExistingMaintenanceContract() {
	//Need to add additional code to setup test data for Service Contract and Contract Line Items
	Account accountRecord = [SELECT ID FROM Account LIMIT 1];
	Set<String> buSet =new Set<String>();
	buSet.add('ION');
	Test.startTest();
	// Nokia_CPQ_Utility.checkExistingMaintenanceContract(accountRecord.Id,buSet);
	Test.stopTest();
}
static testMethod void testupdateQuoteAndRedirect() {
	Apttus_Proposal__Proposal__c proposal = [SELECT ID,NokiaCPQ_Orignal_Quote_Id__c,Quote_Type__c,Configure_grid_flow_button__c,Is_Turbo_Pricing__c,Turbo_Pricing_Enable__c,NokiaCPQ_Opportunity_Id__c,NokiaCPQ_systemVerifiedContract__c,NokiaCPQ_No_of_Years__c,NokiaCPQ_Existing_IONMaint_Contract__c,NokiaCPQ_Needs_Reprice__c,NokiaCPQ_Portfolio__c FROM Apttus_Proposal__Proposal__c LIMIT 1];
	Test.startTest();
	Nokia_CPQ_Utility.updateQuoteAndRedirect(proposal );
	Test.stopTest();
}

// Added for ITCCPQ-2555 by Christie JJ
//Start
static testMethod void testgetPortfolio() {
	Apttus_Proposal__Proposal__c proposal = [SELECT ID,CPQ_SubPortfolio__c,NokiaCPQ_Portfolio__c FROM Apttus_Proposal__Proposal__c LIMIT 1];
	Test.startTest();
	List<String> subPortfolios = Nokia_CPQ_Utility.getPortfolio(proposal);
	Test.stopTest();
}

static testMethod void testgetPortfolioMapping() {
	Apttus_Proposal__Proposal__c proposal = [SELECT ID,CPQ_SubPortfolio__c,NokiaCPQ_Portfolio__c FROM Apttus_Proposal__Proposal__c LIMIT 1];
	Test.startTest();
	Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing utilObj = new Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing();
	Map<string, List<string> > subPortfolioMappings = utilObj.getPortfolioMapping(proposal.NokiaCPQ_Portfolio__c);
	Test.stopTest();
}

static testMethod void testfetchSubPortfolios() {
	Apttus_Proposal__Proposal__c proposal = [SELECT ID,CPQ_SubPortfolio__c,NokiaCPQ_Portfolio__c,Apttus_Proposal__Opportunity__r.AccountId FROM Apttus_Proposal__Proposal__c LIMIT 1];
	Test.startTest();
	Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing utilObj = new Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing();
	List<String> subPortfolios = utilObj.fetchSubPortfolios(proposal.NokiaCPQ_Portfolio__c,proposal.Apttus_Proposal__Opportunity__r.AccountId);
	//Boolean checkAccreditation =  utilObj.checkQuoteAccredSoln(proposal);
	Test.stopTest();
}

static testMethod void testHasExistingMaintenanceContractList() {
	Apttus_Proposal__Proposal__c proposal = [SELECT ID,CPQ_SubPortfolio__c,NokiaCPQ_Portfolio__c,Apttus_Proposal__Opportunity__r.AccountId FROM Apttus_Proposal__Proposal__c LIMIT 1];
	Account legalEntity = [SELECT Id,RecordTypeId FROM Account WHERE RecordTypeId=:Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId() LIMIT 1];
	Test.startTest();
	Boolean result = Nokia_CPQ_Utility.hasExistingMaintenanceContractList(legalEntity.Id,Nokia_CPQ_Utility.getPortfolio(proposal));
	Test.stopTest();
}


static testMethod void testCheckProdAndMaintAccreditation() {
	Apttus_Proposal__Proposal__c proposal = [SELECT ID,CPQ_SubPortfolio__c,NokiaCPQ_Portfolio__c,Apttus_Proposal__Opportunity__r.AccountId FROM Apttus_Proposal__Proposal__c LIMIT 1];
	List<Accreditation__c > accreditations = [SELECT Id,Portfolio__c,Accreditation_Type__c FROM Accreditation__c LIMIT 2];
	Test.startTest();
	Boolean result = Nokia_CPQ_Utility.checkProdAndMaintAccreditation(accreditations,Nokia_CPQ_Utility.getPortfolio(proposal));
	Test.stopTest();
}
//End

static testMethod void testCheckQuoteAccredSoln() {
	Apttus_Proposal__Proposal__c proposal = [SELECT ID,Apttus_Proposal__Account__c,CPQ_SubPortfolio__c,NokiaCPQ_Portfolio__c,Apttus_Proposal__Opportunity__r.AccountId FROM Apttus_Proposal__Proposal__c WHERE NokiaCPQ_Portfolio__c = 'Fixed Networks' LIMIT 1];
	Test.startTest();
	Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing utilObj = new Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing();
	utilObj.checkQuoteAccredSoln(proposal);
	Test.stopTest();
}
static testMethod void testGenericMethods() {
	Test.startTest();
	List<string> list1 = new List<String> {'a','b','c'};
	List<string> list2 = new List<String> {'a','b'};
	List<string> resultList = Nokia_CPQ_Utility.getDuplicatesFrom2Lists(list1, list2);
	Nokia_CPQ_Utility.getPicklistLabelsByValue('Apttus_Proposal__Proposal__c', 'NokiaCPQ_Portfolio__c', new List<string> {'IP Routing'});
	Nokia_CPQ_Utility.getPicklistValuesByLabel('Apttus_Proposal__Proposal__c', 'NokiaCPQ_Portfolio__c', new List<string> {'IP Routing'});
	Nokia_CPQ_Utility.getXAEApps(new List<string> {'OEP'});
	Nokia_CPQ_Utility.getMaintAndSSPSRSProdCodes();
	Test.stopTest();
}
}