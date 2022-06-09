@isTest
public class NokiaCPQ_newQuoteControllerTestclass {
Public String uid= UserInfo.getUserId();
Public String Name='Test Shashi Quote';
Public String OppId;
Public String recordType  = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();
Public String Portfolio = 'IP Routing';
Public String Description = 'Test Shashi Description';
Public Boolean quoteQWM = True;

static testMethod void createQuoteRecordWM(){

	//Create a Customer Account
	Account acc=new Account();
	acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	acc.name='Test Account';
	acc.AccountNumber ='101234567';
	acc.Acc_No__c ='101234567';
	acc.CurrencyIsoCode ='USD';
	acc.Active__c=true;
	acc.AccountStatusInCRMOM__c = 'Active';
	acc.GEOLevel1ID__c ='RG_NAM';
	acc.AccountLifecycleStatus__c='Opportunity';
	insert acc;

	//Create a Legal Entity Account
	Account accLegalEntity = new Account();
	accLegalEntity.Name = 'Test Account Legal Entity';
	accLegalEntity.AccountNumber='101234568';
	accLegalEntity.Acc_No__c = '101234568';
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
	opp.Lead_BU__c ='MN';
	opp.Account_Role__c='Alliance Partner';
	opp.StageName='Develop Opportunity';
	opp.CloseDate=System.today();
	insert opp;
	Opportunity oppList = [Select Id,accountId,CurrencyIsoCode,Legal_Entity__c,End_Customer__c from Opportunity where Id =: opp.Id];
	NokiaCPQ_newQuoteControllerclass.createQuoteRecordWM('Direct_Quote', 'Test Shashi Quote',null,' ','IP Routing',false);

	NokiaCPQ_newQuoteControllerclass.getRecTypeId('Direct_Quote');
	NokiaCPQ_newQuoteControllerclass.getBaseUrl();
	try{
		NokiaCPQ_newQuoteControllerclass.createQuoteRecordWM('Direct_Quote', 'Test Shashi Quote',opp.Id,'Test Shashi Description','IP Routing',false);
	}
	catch(exception e) {
	}

}

static testMethod void createQuoteRecord(){

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
	opp.Account_Role__c='Alliance Partner';
	opp.StageName='Develop Opportunity';
	opp.CloseDate=System.today();
	insert opp;
	Opportunity oppList = [Select Id,accountId,CurrencyIsoCode,Legal_Entity__c,End_Customer__c from Opportunity where Id =: opp.Id];

	try{
		NokiaCPQ_newQuoteControllerclass.createQuoteRecord('Direct_Quote','Test Anant Quote',opp.Id,'Test Anant Description','IP Routing',false,'','','');
	}
	catch(exception e) {
	}

}

static testMethod void createQTCQuoteCPQRecord(){

	//Create a Customer Account
	Account acc=new Account();
	acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	acc.name='Test Account';
	acc.AccountNumber ='101234571';
	acc.Acc_No__c ='101234571';
	acc.CurrencyIsoCode ='USD';
	acc.Active__c=true;
	acc.AccountStatusInCRMOM__c = 'Active';
	acc.GEOLevel1ID__c ='RG_NAM';
	acc.AccountLifecycleStatus__c='Opportunity';
	insert acc;

	//Create a Legal Entity Account
	Account accLegalEntity = new Account();
	accLegalEntity.Name = 'Test Account Legal Entity';
	accLegalEntity.AccountNumber='101234572';
	accLegalEntity.Acc_No__c = '101234572';
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
	opp.Lead_BU__c = 'MN';
	opp.Account_Role__c='Alliance Partner';
	opp.StageName='Develop Opportunity';
	opp.CloseDate=System.today();
	insert opp;
	Opportunity oppList = [Select Id,accountId,CurrencyIsoCode,Legal_Entity__c,End_Customer__c from Opportunity where Id =: opp.Id];

	try{
		NokiaCPQ_newQuoteControllerclass.createQTCQuoteCPQRecord('CPQ_QTC_NCQ_Quote','Test Navdeep Quote',opp.Id,'Test Navdeep Description',Date.today(),'',false,
														   2,NULL,NULL,'1234',NULL,'Delhi', 'Goa',NULL,NULL,'','','');
	}
	catch(exception e) {
	}
}

static testMethod void createQTCQuoteSPTRecord(){

	//Create a Customer Account
	Account acc=new Account();
	acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	acc.name='Test Account';
	acc.AccountNumber ='101234573';
	acc.Acc_No__c ='101234573';
	acc.CurrencyIsoCode ='USD';
	acc.Active__c=true;
	acc.AccountStatusInCRMOM__c = 'Active';
	acc.GEOLevel1ID__c ='RG_NAM';
	acc.AccountLifecycleStatus__c='Opportunity';
	insert acc;

	//Create a Legal Entity Account
	Account accLegalEntity = new Account();
	accLegalEntity.Name = 'Test Account Legal Entity';
	accLegalEntity.AccountNumber='101234574';
	accLegalEntity.Acc_No__c = '101234574';
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
	opp.Lead_BU__c ='MN';
	opp.Account_Role__c='Alliance Partner';
	opp.StageName='Develop Opportunity';
	opp.CloseDate=System.today();
	insert opp;
	Opportunity oppList = [Select Id,accountId,CurrencyIsoCode,Legal_Entity__c,End_Customer__c from Opportunity where Id =: opp.Id];
	List<Opportunity> optyList= NokiaCPQ_newQuoteControllerclass.getOpportunityRecord(opp.Id);

	try{
		// String errorRelease =
		NokiaCPQ_newQuoteControllerclass.createQTCQuoteSPTRecord('Direct_Quote','Test Nokia Quote_1',opp.Id,opp.Id,123,'Test Nokia Quote',Date.today(),NULL,false,123,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
	}
	catch(exception e) {
	}
}

static testMethod void testPricingPoolLogic(){
	//Create a Customer Account
	Account acc=new Account();
	acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	acc.name='Test Account';
	acc.AccountNumber ='101234573';
	acc.Acc_No__c ='101234573';
	acc.CurrencyIsoCode ='USD';
	acc.Active__c=true;
	acc.AccountStatusInCRMOM__c = 'Active';
	acc.GEOLevel1ID__c ='RG_NAM';
	acc.AccountLifecycleStatus__c='Opportunity';
	insert acc;

	//Create an Opportunity Record
	Opportunity opp = new Opportunity();
	opp.Name='Test Opportunity';
	opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opp.AccountId=acc.Id;
	opp.CurrencyIsoCode='USD';
	opp.Phase_Status__c = 'Opportunity in Progress';
	opp.Lead_BG__c='MN';
	opp.Lead_BU__c ='MN';
	opp.Account_Role__c='Alliance Partner';
	opp.StageName='Develop Opportunity';
	opp.CloseDate=System.today();
	insert opp;

	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	proposals[0].Apttus_Proposal__Account__c = acc.Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opp.Id;
	proposals[0].NokiaCPQ_Maintenance_Type__c = '';
	proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_CQ_Quote').getRecordTypeId();	//QTC CQ draft quote
	insert proposals;

	CPQ_PricingPool__c pp = new CPQ_PricingPool__c();
	pp.CPQ_Active__c = true;
	insert pp;

	CPQ_PricingPoolAccountMap__c ppaccMap = new CPQ_PricingPoolAccountMap__c();
	ppaccMap.CPQ_Active__c = true;
	ppaccMap.CPQ_Pricing_Pool_Id__c = pp.Id;
	ppaccMap.CPQ_Account__c = acc.Id;
	insert ppaccMap;

	Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
	pl.Name = 'Test pl';
	insert pl;

	CPQ_Pricing_Pool_Agreement_Map__c ppAgrMap = new CPQ_Pricing_Pool_Agreement_Map__c();
	ppAgrMap.CPQ_Active__c = true;
	ppAgrMap.CPQ_Agreement_Name__c = pl.id;
	ppAgrMap.CPQ_Pricing_Pool_Id__c = pp.id;
	insert ppAgrMap;

	CPQ_ContractConditionDisc__c con = new CPQ_ContractConditionDisc__c();
	con.CPQ_Active__c = true;
	con.CPQ_Account__c = acc.Id;
	con.CPQ_Agreement_Name__c = pl.id;
	con.CPQ_Code__c = '111';
	con.CPQ_Description__c = 'Test desc';
	con.recordtypeid = Schema.SObjectType.CPQ_ContractConditionDisc__c.getRecordTypeInfosByDeveloperName().get('Conditional').getRecordTypeId();
	// con.CPQ_Start_Date__c = Date.today();
	// con.CPQ_End_Date__c = Date.today();
	insert con;

	NokiaCPQ_newQuoteControllerclass.WrapperData wd = new NokiaCPQ_newQuoteControllerclass.WrapperData();
	wd.quoteData = null;
	wd.poolData = null;

	Test.startTest();
	List<CPQ_PricingPool__c> ppList = NokiaCPQ_newQuoteControllerclass.getPricingPool(opp.Id);
	List<CPQ_ContractConditionDisc__c> conList = NokiaCPQ_newQuoteControllerclass.getPricingConditions(opp.Id, ppList[0].Id);
	NokiaCPQ_newQuoteControllerclass.getPricingPoolOnQuote(proposals[0].Id);
	NokiaCPQ_newQuoteControllerclass.getContractualDiscount(proposals[0].Id);
	NokiaCPQ_newQuoteControllerclass.createQuoteContractualDiscount(proposals[0].id,con.id,2);
	System.assertNotEquals(null, ppList);
	System.assertNotEquals(null, conList);
	Test.stopTest();
}

@isTest
public static void validaeGetPricingPool(){

}

@isTest
public static void validateGetPricingConditions(){

}

@isTest
public static void validateGetPricingPoolOnQuote(){

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
	insert opportunities;

	opportunities[0].stageName = GlobalConstants.CREATE_OFFER;
	opportunities[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
	opportunities[0].No_Loa__c = true;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities[0].Account_Role__c = 'Alliance Partner';
	update opportunities;

	CPQ_PricingPool__c pool = new CPQ_PricingPool__c();
	pool.CPQ_Pricing_Pool_Name__c = 'AAA Pool';
	pool.CPQ_Active__c = true;
	insert pool;

	Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
	pl.Name = 'Test PL';
	pl.Apttus_Config2__Active__c = true;
	insert pl;

	CPQ_Pricing_Pool_Agreement_Map__c aggr = new CPQ_Pricing_Pool_Agreement_Map__c();
	aggr.CPQ_Active__c = true;
	aggr.CPQ_Agreement_Name__c = pl.Id;
	aggr.CPQ_Pricing_Pool_Id__c = pool.Id;
	insert aggr;

	Id recTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_CQ_Quote').getRecordTypeId();
	List<Apttus_Proposal__Proposal__c> proposalList = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposalList[0].Apttus_Proposal__Approval_Stage__c = 'In Review';
	proposalList[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposalList[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposalList[0].RecordTypeId = recTypeId;
	proposalList[0].NokiaCPQ_Approval_Required_Flag__c = true;
	proposalList[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true;
	proposalList[0].NokiaCPQ_Existing_IONMaint_Contract__c='No';
	proposalList[0].NokiaCPQ_No_of_Years__c = '1';
	proposalList[0].NokiaCPQ_Maintenance_Type__c='Gold (Return for Exchange)';
	insert proposalList[0];

	Test.startTest();
	Apttus_Proposal__Proposal__c qot = [Select id,CPQ_Pricing_Pool__c from Apttus_Proposal__Proposal__c where RecordTypeId = :recTypeId LIMIT 1];
	qot.CPQ_Pricing_Pool__c = 'AAA Pool';
	update qot;

	NokiaCPQ_newQuoteControllerclass.WrapperData w = new NokiaCPQ_newQuoteControllerclass.WrapperData();
	//class wrapper  = NokiaCPQ_newQuoteControllerclass.getPricingPoolOnQuote(opportunities[0].Id);
	// List<CPQ_PricingPool__c> ppList = NokiaCPQ_newQuoteControllerclass.getPricingPool(opportunities[0].Id);


	Test.stopTest();
}



@isTest
public static void getSavedQuoteContractualDiscountTest() {
	NokiaCPQ_newQuoteControllerclass.getSavedQuoteContractualDiscount('a3k030000001kT0');
}
@isTest
public static void deleteQuoteContractualDiscountTest() {
	NokiaCPQ_newQuoteControllerclass.deleteQuoteContractualDiscount('a3k030000001kT0');
}

@isTest
public static void testFetchRecordType() {
	String IdRecordType = NokiaCPQ_newQuoteControllerclass.getRecordType('Direct_Quote');

}
@isTest
public static void testIsUserLicensed() {
	Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
	User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
				   EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				   LocaleSidKey='en_US', ProfileId = p.Id,
				   TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');

	Boolean isLicensed = NokiaCPQ_newQuoteControllerclass.isUserLicensedForCPQPackage(u.Id);
}

}