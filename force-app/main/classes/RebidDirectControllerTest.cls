/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 03-04-2022
 * @last modified by  : Yashdeep Prajapati
 **/
@isTest
public class RebidDirectControllerTest {
Public String uid= UserInfo.getUserId();
Public String Name='Test Surinder Quote';
Public String OppId;
Public String recordType  = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();
Public String Portfolio = 'IP Routing';
Public String Description = 'Test Shashi Description';
Public Boolean quoteQWM = True;


static testMethod void createQuoteRecord(){
	List<User> userList = new List<User>();
	userList = TestDataFactory.userCreation(1,'Data Loader Profile');

	System.runAs(userList[0]){

		//Create a Customer Account
		Account acc=new Account();
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		acc.name='Test Account';
		acc.AccountNumber ='101234569';
		acc.Acc_No__c ='101234569';
		acc.CurrencyIsoCode ='USD';
		acc.Active__c=true;
		acc.AccountStatusInCRMOM__c = 'Active';
		acc.GEOLevel1ID__c ='RG_NAM';
		acc.AccountLifecycleStatus__c='Opportunity';
		insert acc;
		//Create a Legal Entity Account
		Account accLegalEntity = new Account();
		accLegalEntity.Name = 'Test Account Legal Entity';
		accLegalEntity.AccountNumber='101234570';
		accLegalEntity.Acc_No__c = '101234570';
		accLegalEntity.GEOLevel1ID__c ='RG_NAM';
		accLegalEntity.Active__c = true;
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert accLegalEntity;
		//Create an Opportunity Record
		Opportunity opp = new Opportunity();
		opp.Name='Test Opportunity';
		opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opp.AccountId=acc.Id;
		opp.CurrencyIsoCode='USD';
		opp.Phase_Status__c = 'Opportunity in Progress';
		opp.Lead_BG__c='MN';
		opp.Lead_BU__c='MN';
		opp.Account_Role__c= 'GPP Distributor Partner';//'Alliance Partner';
		opp.StageName='Develop Opportunity';
		opp.Business_Type__c  ='Standard Opportunity';
		opp.CloseDate=System.today();
		insert opp;
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = acc.Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opp.Id;
		proposals[0].NokiaCPQ_Maintenance_Type__c = '';
		proposals[0].isFirstRebidQuote__c=false;
		proposals[0].NokiaCPQ_Proposal_Id__c='21.US.952731 Q 1 C';
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();//QTC CQ draft quote
		insert proposals;
		proposals[0].isFirstRebidQuote__c=false;
		update proposals;
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List',
			Apttus_Config2__Active__c = True
			);
		insert ApttusTestPriceList;
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config',
			Apttus_Config2__AccountId__c = acc.Id,
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_QPConfig__Proposald__c = proposals[0].Id,
			Apttus_Config2__Status__c = 'Saved',
			Apttus_Config2__VersionNumber__c = 1,
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal',
			NokiaCPQ_Quote_Type__c='Direct CPQ',
			XAE_Flag__c = 'sPRM'

			);
		insert ProdConfig;
		NokiaCPQ_Site__c site= new NokiaCPQ_Site__c(Opportunity__c=opp.id,NokiaCPQ_Address__c='test');
		insert site;
		NokiaCPQ_Phase__c phase= new NokiaCPQ_Phase__c(Opportunity__c=opp.id);
		insert phase;
		NokiaCPQ_Site_Phase_Configuration__c sp= new NokiaCPQ_Site_Phase_Configuration__c(NokiaCPQ_Phase__c=phase.id,NokiaCPQ_Site__c=site.id,NokiaCPQ_Configuration__c=ProdConfig.id);
		insert sp;
		list<NokiaCPQ_Site__c> sList= new list<NokiaCPQ_Site__c>();
		sList.add(site);
		list<NokiaCPQ_Phase__c> pList= new list<NokiaCPQ_Phase__c>();
		pList.add(phase);


		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100,
			//Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__ChargeType__c = 'Standard Price'
			);
		insert pLI1;
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
			//Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,

			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = acc.Id,
			Apttus_Config2__AddedBy__c = 'added by code'
			);
		insert LineItem1;
		CPQ_Site_Phase_and_Quantity__c obj = new CPQ_Site_Phase_and_Quantity__c(Line_Item__c=LineItem1.id);
		insert obj;
		test.startTest();
		RebidDirectController.rebidQuote(proposals[0].id);
		//Nokia_CPQ_Utility.insertSitePhaseConfig(ProdConfig.id,sList,pList);
		test.stopTest();
	}
}
static testMethod void createQuoteRecord1(){
	List<User> userList = new List<User>();
	userList = TestDataFactory.userCreation(1,'Data Loader Profile');

	System.runAs(userList[0]){

		//Create a Customer Account
		Account acc=new Account();
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		acc.name='Test Account';
		acc.AccountNumber ='101234569';
		acc.Acc_No__c ='101234569';
		acc.CurrencyIsoCode ='USD';
		acc.Active__c=true;
		acc.AccountStatusInCRMOM__c = 'Active';
		acc.GEOLevel1ID__c ='RG_NAM';
		acc.AccountLifecycleStatus__c='Opportunity';
		insert acc;
		//Create a Legal Entity Account
		Account accLegalEntity = new Account();
		accLegalEntity.Name = 'Test Account Legal Entity';
		accLegalEntity.AccountNumber='101234570';
		accLegalEntity.Acc_No__c = '101234570';
		accLegalEntity.GEOLevel1ID__c ='RG_NAM';
		accLegalEntity.Active__c = true;
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert accLegalEntity;
		//Create an Opportunity Record
		Opportunity opp = new Opportunity();
		opp.Name='Test Opportunity';
		opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opp.AccountId=acc.Id;
		opp.CurrencyIsoCode='USD';
		opp.Phase_Status__c = 'Opportunity in Progress';
		opp.Lead_BG__c='MN';
		opp.Lead_BU__c='MN';
		opp.Account_Role__c= 'GPP Distributor Partner';//'Alliance Partner';
		opp.StageName='Develop Opportunity';
		opp.Business_Type__c = 'Standard Opportunity';
		opp.CloseDate=System.today();
		insert opp;
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = acc.Id;

		proposals[0].Apttus_Proposal__Opportunity__c = opp.Id;
		proposals[0].NokiaCPQ_Maintenance_Type__c = '';
		proposals[0].isFirstRebidQuote__c=false;
		proposals[0].Apttus_Proposal__Approval_Stage__c='Draft';
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();//QTC CQ draft quote
		insert proposals;
		test.startTest();
		RebidDirectController.rebidQuote(proposals[0].id);
		test.StopTest();
	}
}

static testMethod void createQuoteRecord11(){
	List<User> userList = new List<User>();
	userList = TestDataFactory.userCreation(1,'Data Loader Profile');

	System.runAs(userList[0]){

		//Create a Customer Account
		Account acc=new Account();
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		acc.name='Test Account';
		acc.AccountNumber ='101234569';
		acc.Acc_No__c ='101234569';
		acc.CurrencyIsoCode ='USD';
		acc.Active__c=true;
		acc.AccountStatusInCRMOM__c = 'Active';
		acc.GEOLevel1ID__c ='RG_NAM';
		acc.AccountLifecycleStatus__c='Opportunity';
		insert acc;
		//Create a Legal Entity Account
		Account accLegalEntity = new Account();
		accLegalEntity.Name = 'Test Account Legal Entity';
		accLegalEntity.AccountNumber='101234570';
		accLegalEntity.Acc_No__c = '101234570';
		accLegalEntity.GEOLevel1ID__c ='RG_NAM';
		accLegalEntity.Active__c = true;
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert accLegalEntity;
		//Create an Opportunity Record
		Opportunity opp = new Opportunity();
		opp.Name='Test Opportunity';
		opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opp.AccountId=acc.Id;
		opp.CurrencyIsoCode='USD';
		opp.Phase_Status__c = 'Opportunity in Progress';
		opp.Lead_BG__c='MN';
		opp.Lead_BU__c='MN';
		opp.Account_Role__c= 'GPP Distributor Partner';//'Alliance Partner';
		opp.StageName='Develop Opportunity';
		opp.Business_Type__c = 'Standard Opportunity';
		opp.CloseDate=System.today();
		insert opp;
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = acc.Id;

		proposals[0].Apttus_Proposal__Opportunity__c = opp.Id;
		proposals[0].NokiaCPQ_Maintenance_Type__c = '';
		proposals[0].isFirstRebidQuote__c=false;
		proposals[0].Apttus_Proposal__Approval_Stage__c='REBID';
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();//QTC CQ draft quote
		insert proposals;
		test.startTest();
		RebidDirectController.rebidQuote(proposals[0].id);
		test.StopTest();
	}
}

static testMethod void createQuoteRecordIndirect(){
	List<User> userList = new List<User>();
	userList = TestDataFactory.userCreation(1,'Data Loader Profile');

	System.runAs(userList[0]){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='301030872';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		List<Account> acclist = new List<Account>();
		acclist.add(accounts[0]);

		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities;

		Offer__c offer = TestDataFactory.OfferCreation(1, opportunities[0])[0];
		insert offer;

		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(4);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[2].partner__c = accounts[0].Id;
		accreditations[3].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';
		accreditations[3].Accreditation_Type__c = 'Maintenance';
		accreditations[3].Accreditation_Level__c = 'Premium';
		accreditations[3].Pricing_Level_Override__c = 'Premium';
		accreditations[0].Portfolio__c = 'Fixed Access - FBA';
		accreditations[1].Portfolio__c = 'Fixed Access - FBA';
		accreditations[2].Portfolio__c = 'Fixed Access - POL';
		accreditations[3].Portfolio__c = 'Fixed Access - POL';
		insert accreditations;


		test.startTest();
		Apttus_Proposal__Proposal__c proposal =new Apttus_Proposal__Proposal__c(
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities[0].Id,
			NokiaCPQ_Portfolio__c  = 'Fixed Networks',
			CPQ_SubPortfolio__c = 'Fixed Access - FBA',
			Offer__c = offer.id,
			Quote_Status__c='Price',
			Submitted_Date__c = System.today(),
			RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId()//indirect draft quote
			);
		insert proposal;

		RebidDirectController.rebidQuote(proposal.id);
		test.StopTest();
	}
}
}