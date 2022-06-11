/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 09-16-2021
 * @last modified by  : Yashdeep Prajapati
 **/
@isTest
public with sharing class NokiaCPQ_SitePhaseQuntityTriggerTest {
@testSetup static void methodName() {
	List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
		Nokia_CPQ_Constants.isCloneRun = true;
		// Create a test account
		List<Account> accounts=new List<Account>();
		Account testAcct = TestDataFactory.createAccount(1)[0];
		testAcct.AccountNumber='3011546567YP';
		testAcct.Acc_No__c = '3011546567';
		testAcct.CountryCode__c='IN';
		testAcct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts.add(testAcct);
		insert accounts;
		// Creates first opportunity
		List<Opportunity> opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		insert opportunities.get(0);
		List<product2> lstProduct = TestDataSetup.createCPQTestproduct(1);
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
		Apttus_Proposal__Proposal__c objProposal = TestDataSetup.creatProposal(opportunities[0], testAcct, objPriceList);
		insert objProposal;
		Apttus_Config2__ProductConfiguration__c objProductConfiguration = TestDataSetup.creatProductConfiguration(testAcct, objPriceList, objProposal);
		insert objProductConfiguration;
		//List<Apttus_Config2__LineItem__c> objLineItem = TestDataSetup.creatConfigLineItem(testAcct, objProductConfiguration, objPriceList, lstProduct[0], 1);
		list<Apttus_Config2__LineItem__c> objLineItem = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=objProductConfiguration.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
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
			Apttus_Config2__ShipToAccountId__c = testAcct.Id,
			Apttus_Config2__AddedBy__c = 'added by code'
			);
		//insert LineItem2;
		objLineItem.add(LineItem1);
		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=objProductConfiguration.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
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
			Apttus_Config2__ShipToAccountId__c = testAcct.Id,
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
		objSitePhase1.Line_Item__c = objLineItem[0].Id;
		spqList.add(objSitePhase1);
		CPQ_Site_Phase_and_Quantity__c objSitePhase2 = new CPQ_Site_Phase_and_Quantity__c();
		objSitePhase2.Name = 'TestSitePhase2';
		objSitePhase2.NCPQ_Site__c =  objSite3.Id;
		objSitePhase2.NCPQ_Quantity__c = 1;
		objSitePhase2.Line_Item__c = objLineItem[0].Id;
		spqList.add(objSitePhase2);
		CPQ_Site_Phase_and_Quantity__c objSitePhase3 = new CPQ_Site_Phase_and_Quantity__c();
		objSitePhase3.Name = 'TestSitePhase3';
		objSitePhase3.NCPQ_Site__c =  objSite3.Id;
		objSitePhase3.NCPQ_Phase__c = objPhase2.Id;
		objSitePhase3.NCPQ_Quantity__c = 1;
		objSitePhase3.Line_Item__c = objLineItem[0].Id;
		spqList.add(objSitePhase3);
		CPQ_Site_Phase_and_Quantity__c objSitePhase4 = new CPQ_Site_Phase_and_Quantity__c();
		objSitePhase4.Name = 'TestSitePhase4';
		objSitePhase4.NCPQ_Site__c =  objSite1.Id;
		objSitePhase4.NCPQ_Quantity__c = 1;
		objSitePhase4.Line_Item__c = objLineItem[0].Id;
		spqList.add(objSitePhase4);
		//objSitePhase.NCPQ_SiteUsesPhases__c = True ;
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
		insert listSitePhaseConfig;
	}
}

static testMethod void testTrigger() {
	delete [SELECT Id FROM CPQ_Site_Phase_and_Quantity__c WHERE Name IN ('TestSitePhase1','TestSitePhase3')];
}

static testMethod void testTriggerUpdate() {
	List<CPQ_Site_Phase_and_Quantity__c> listSPQ = [SELECT Id,NCPQ_Quantity__c FROM CPQ_Site_Phase_and_Quantity__c];
	for (CPQ_Site_Phase_and_Quantity__c spq : listSPQ) {
		spq.NCPQ_Quantity__c = 0;
	}
	update listSPQ;
}
}