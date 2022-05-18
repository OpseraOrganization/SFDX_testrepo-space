/************************************************************************************************************
* Apex Class Name   : XauthorIntermediatePageControllerTest.cls
* Version	 : 1.0
* Created Date	  : 17 Sep 2017
* Function	: test class for XauthorIntermediatePageController
* Modification Log  :
* Developer	Date		Description
* -----------------------------------------------------------------------------------------------------------
* Aditya Pareek	  17/09/2017	 Created Test Class for XauthorIntermediatePageController
*
************************************************************************************************************/

@isTest(seeAllData = false)

public class XauthorIntermediatePageControllerTest{

public static testMethod void testMethod1(){

	List<User> userList = new List<User>();
	userList = TestDataFactory.userCreation(1,'Data Loader Profile');

	System.runAs(userList[0]){
		Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();


		File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
		fscs.name= 'Opportunity_SalesPhase_FinalStage';
		fscs.Value__c = 'Completed';
		insert fscs;

		List<Account> accounts=new List<Account>();
		Account Customeraccount = NF_TestDataFactory.createAccount('1TestNONV0000');
		Customeraccount.RecordTypeId=custRecordTypeId;
		accounts.add(Customeraccount);
		Database.insert(accounts);

		Account LegalEntityaccount = NF_TestDataFactory.createAccount('10308719999AIA');
		LegalEntityaccount.Accountnumber='1323242223i';
		LegalEntityaccount.Recordtypeid=LERecordTypeId;
		LegalEntityaccount.ParentId=accounts[0].Id;
		LegalEntityaccount.Default_Legal_Entity__c = true;
		LegalEntityaccount.Partner_Program__c=null;
		accounts.add(LegalEntityaccount);
		Database.upsert(accounts);

		Opportunity Opportunity_v1= NF_TestDataFactory.createOpportunity(accounts[0].Id, 'Execute (Start Delivery)', 'In Execution', Date.today().addDays(10), 7000000);
		Opportunity_v1.Lead_BG__c='MN';
		Opportunity_v1.Opportunity_ID__c='19.IN.856951';
		Opportunity_v1.RecordTypeId = oppDirectRecordTypeId;
		Opportunity_v1.Business_Type__c = 'Standard Opportunity';
		Opportunity_v1.Account_Role__c = 'GPP Distributor Partner';
		Database.insert(Opportunity_v1);

		//Territory2Model terrModel = new Territory2Model(DeveloperName='ModelName', Name='Name');
//insert terrModel ;
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;

		user u = new user(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,Nokia_ID__c = '223456',LastName = 'last',Email = 'puser000@amamama.com',Username = 'puser000@amamama.com' + System.currentTimeMillis(),CompanyName = 'TEST',Title = 'title',Alias = 'alias',TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US');
		insert u;
		system.runas(u){
			List<RecordType> recList = [select id,developername from RecordType where (developername = 'Customer' and sobjectType='Account')];
			List<Product2> prods = new List<Product2>();
			Product2 prod1 = new product2(
	Name = 'Test1',
	ProductCode = '123',
	Business_Group__c = 'MN',
	CurrencyIsoCode = 'USD',
	IsActive = true
	);
			prods.add(prod1);


			Product2 prod2 = new product2(
	Name = 'Test2',
	ProductCode = '1234',
	Business_Group__c = 'MN',
	CurrencyIsoCode = 'USD',
	IsActive = true
	);
			prods.add(prod2);
			insert prods;
			//Create PriceList

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

			Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
	Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
	Apttus_Config2__ListPrice__c = 200,
	Apttus_Config2__ProductId__c = prod2.Id,
	Apttus_Config2__ChargeType__c = 'Maintenance Y1'
	);
			//insert pLI2;
			plistItems.add(pLI2);

			//Creation of Accreditation

			List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
			accreditations[0].partner__c = accounts[0].Id;
			accreditations[1].partner__c = accounts[0].Id;
			accreditations[1].Accreditation_Type__c = 'Maintenance';
			accreditations[1].Accreditation_Level__c = 'Premium';
			accreditations[1].Pricing_Level_Override__c = 'Premium';
			insert accreditations;
		}



		test.startTest();
		//create proposal
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = Opportunity_v1.id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].Reprice_In_Progress__c = false;
		//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
		proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
		insert proposals;

		PageReference pageRef = Page.XauthorIntermediatePage;
		Test.setCurrentPage(pageRef);
		pageRef.getParameters().put('selectedRecordId',proposals[0].id);
		pageRef.getParameters().put('appName',Nokia_CPQ_Constants.NOKIA_BOMNONMPW);
		XauthorIntermediatePageController xipc = new XauthorIntermediatePageController();
		PageReference pg = xipc.updateAppName();


		pageRef.getParameters().put('selectedRecordId',proposals[0].id);
		pageRef.getParameters().put('appName','Export Quote');
		XauthorIntermediatePageController xipc1 = new XauthorIntermediatePageController();
		PageReference pg1 = xipc1.updateAppName();
		test.stopTest();
	}
}

public static testMethod void testMethod2(){
	List<RecordType> recList = [select id,developername from RecordType where (developername = 'Customer' and sobjectType='Account')];
	Account acc = new Account(recordtypeid=recList[0].id,name='acc01' + Utils.generateRandomInteger(2)+Utils.generateRandomString(2));
	acc.Partner_Program__c='GPP 3.0';
	insert acc;
	List<RecordType> recList2 = [select id,developername from RecordType where (developername='Reseller_GPP_3_0' and SobjectType='Accreditation__c')];
	Accreditation__c accre = new Accreditation__c(Partner__c=acc.id,recordtypeid=recList2[0].id);
	insert accre;
	PageReference pageRef = Page.XauthorIntermediatePage;
	Test.setCurrentPage(pageRef);
	pageRef.getParameters().put('selectedRecordId',accre.id);
	pageRef.getParameters().put('appName','PriceCatalogExport');
	XauthorIntermediatePageController xipc = new XauthorIntermediatePageController();
	PageReference pg = xipc.updateAppName();

	pageRef.getParameters().put('selectedRecordId',accre.id);
	pageRef.getParameters().put('appName','Maintenance');
	XauthorIntermediatePageController xipc1 = new XauthorIntermediatePageController();
	PageReference pg1 = xipc1.updateAppName();

	pageRef.getParameters().put('selectedRecordId',accre.id);
	pageRef.getParameters().put('appName','Order Generation');
	XauthorIntermediatePageController xipc2 = new XauthorIntermediatePageController();
	PageReference pg2 = xipc2.updateAppName();
}

public static testMethod void testMethod3(){

	User sysAdminUser = TestDataFactory.createSystemAdminUser();
	System.runAs(sysAdminUser){
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;

		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		insert opportunities;



		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
			Name = 'Test1',
			ProductCode = '123',
			Business_Group__c = 'MN',
			CurrencyIsoCode = 'USD',
			IsActive = true
			);
		prods.add(prod1);


		Product2 prod2 = new product2(
			Name = 'Test2',
			ProductCode = '1234',
			Business_Group__c = 'MN',
			CurrencyIsoCode = 'USD',
			IsActive = true
			);
		prods.add(prod2);
		insert prods;
		//Create PriceList

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

		Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 200,
			Apttus_Config2__ProductId__c = prod2.Id,
			Apttus_Config2__ChargeType__c = 'Maintenance Y1'
			);
		//insert pLI2;
		plistItems.add(pLI2);

		//Creation of Accreditation

		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';
		insert accreditations;
		test.startTest();
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = true;
		//	proposals[0].Reprice_In_Progress__c = false;
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();
		//  proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
		// proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
		insert proposals;

		PageReference pageRef = Page.XauthorIntermediatePage;
		Test.setCurrentPage(pageRef);

		pageRef.getParameters().put('selectedRecordId',proposals[0].id);
		pageRef.getParameters().put('appName',Nokia_CPQ_Constants.NOKIA_DIRECTEXPORTQUOTE);
		XauthorIntermediatePageController xipc = new XauthorIntermediatePageController();
		PageReference pg = xipc.updateAppName();

		pageRef.getParameters().put('selectedRecordId',proposals[0].id);
		pageRef.getParameters().put('appName',Nokia_CPQ_Constants.NOKIA_CSPEXPORT);
		XauthorIntermediatePageController xipc1 = new XauthorIntermediatePageController();
		PageReference pg1 = xipc1.updateAppName();
		test.stopTest();
	}
}
}