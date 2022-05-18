/*******************************
   Class Name:ProposalTriggerHelperTest
   Created by: Accenture
   Created Date: 06 April 2018
   Last modified by: Accenture
   Description: Test class for ProposalTriggerHelper
*******************************/
@istest
public class ProposalTriggerHelperTest {
	

@testSetup
static void methodData()  {

	list<user> userList = new list<user>();
	/* User sysAdminUser = TestDataFactory.createSystemAdminUser();
	usrList.add(sysAdminUser);
	User sysAdminUser2 = TestDataFactory.createSystemAdminUser();
	usrList.add(sysAdminUser2);*/
	userList = TestDataFactory.userCreation(2, 'System Administrator');
	//userList[0].NSA_Compliant__c = True;
	userList[0].Restriction_Level__c = 'Unrestricted';
	//userList[1].NSA_Compliant__c = True;
	userList[1].Restriction_Level__c = 'Unrestricted';
	insert userList;
	/*File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
	fscs.name= 'Opportunity_SalesPhase_FinalStage';
	fscs.Value__c = 'Completed';
	insert fscs;


	//Create Account
	Account account = NF_TestDataFactory.createAccount('Test Account');
	account.L2Name__c = 'TestL2Name';
	List<Account> accounts=new List<Account>();
	accounts.add(account);
	insert accounts;
	QuoteWarningMessage.callInit(accounts[0].Id);
	//Create Opportunity
	List<opportunity> opportunities = NF_TestDataFactory.getOpportunities(3,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[1].Account_Role__c = 'GPP Distributor Partner';
	opportunities[2].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[2].CurrencyIsoCode = 'USD';
	opportunities[2].Account_Role__c = 'GPP Distributor Partner';
	insert opportunities;

	Shipping_Location__c shipping_location = new Shipping_Location__c();
	shipping_location.Portfolio__c = 'IP Routing';
	shipping_location.Pricing_Cluster__c = 'Europe';
	insert shipping_location;*/
	
		Apttus_Proposal_Proposal__c turbosetting =  Apttus_Proposal_Proposal__c.getOrgDefaults();
		turbosetting.Enable_Turbo_Pricing_Button_for_Partner__c = true;
		turbosetting.Enable_Classic_Pricing_Button_forPartner__c = true;
		turbosetting.Enable_Turbo_Pricing_Button__c = true;
		turbosetting.Enable_Classic_Pricing_Button__c = true;
		turbosetting.Enable_Surround_Turbo_Pricing_Button__c = true;
		turbosetting.Enable_Surround_Classic_Pricing_Button__c = true;
		insert turbosetting;
}

static testMethod void test_Proposaltrigger(){
	//List<Account> account_Obj  =  [SELECT Id,Name from Account];
	//List<Opportunity> opportunity_Obj  =  [SELECT Id from Opportunity];

	File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
	fscs.name= 'Opportunity_SalesPhase_FinalStage';
	fscs.Value__c = 'Completed';
	insert fscs;


	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	NokiaCPQ_Estimate_date_with_PortfolioObj__c estimatedate = new NokiaCPQ_Estimate_date_with_PortfolioObj__c();
	estimatedate.Master_Currency__c='USD';
	estimatedate.Portfolio__c='IP Routing';
	insert estimatedate;

	List<Account> account_Obj = new List<Account>();
	account_Obj.add(accounts[0]);
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunity_Obj = NOKIA_CPQ_TestDataFactory.getOpportunities(3,account_Obj);
	opportunity_Obj[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunity_Obj[0].End_Customer_LE__c = accounts[1].id;
	opportunity_Obj[0].Account_Role__c = 'GPP Distributor Partner';
	opportunity_Obj[0].CurrencyIsoCode = 'USD';
	insert opportunity_Obj;
	//QuoteWarningMessage.getQuoteId(accounts[0].Id);

	//Apttus_Proposal_Proposal__c turbosetting =  Apttus_Proposal_Proposal__c.getOrgDefaults();
	//turbosetting.Enable_Turbo_Pricing_Button_for_Partner__c = true;
	//turbosetting.Enable_Classic_Pricing_Button_forPartner__c = true;
	//insert turbosetting;


	Contract Con = new Contract();
	//Con.Account = accounts[0];
	Con.AccountId = account_Obj[0].Id;
	Con.NokiaCPQ_Sub_Contract_Type__c = 'Primary';
	Con.Status = 'Draft';
	Con.Contract_Type__c = 'PPA-RES';
	Con.Name='Test';
	Con.Contract_Status_New__c = 'Active';
	Con.StartDate =  Date.Today();
	insert Con;
	/*  List<Account> accounts1 = NOKIA_CPQ_TestDataFactory.getAccounts(1);
	accounts1[0].Acc_No__c = 'Testing1';
	accounts1[0].Partner_Program__c ='';
	accounts1[0].NokiaCPQ_Applicable_Price_Lists__c = 'Dummy Price List1';
	accounts1[0].Partner_Type__c = '';
	accounts1[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	insert accounts1;*/
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = account_Obj[0].Id;
	accreditations[1].partner__c = account_Obj[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();

	Apttus_Proposal__Proposal__c Quote_Obj = new Apttus_Proposal__Proposal__c(
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Draft',
		Apttus_Proposal__Account__c = account_Obj[0].Id,
		Apttus_Proposal__Opportunity__c = opportunity_Obj[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		//NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '1',
		NokiaCPQ_Is_Maintenance_Quote__c = false,
		Master_Currency_Code__c=estimatedate.Master_Currency__c
		 //Warranty_credit__c = 'No',
		 //NokiaCPQ_Contract_Start_Date__c = date.Today()
		);
	insert Quote_Obj;

	Apttus_Proposal__Proposal__c Quote_Obj1 = new Apttus_Proposal__Proposal__c(
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Draft',
		Apttus_Proposal__Account__c = account_Obj[0].Id,
		Apttus_Proposal__Opportunity__c = opportunity_Obj[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		//NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_SSP_Level__c = '',
		NokiaCPQ_SRS_Level__c = '',
		NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = ''
		);
	insert Quote_Obj1;

	Shipping_Location__c shipping_location = new Shipping_Location__c();
	shipping_location.Portfolio__c = 'IP Routing';
	shipping_location.Pricing_Cluster__c = 'Europe';
	insert shipping_location;


	Map<Id, Apttus_Proposal__Proposal__c> proposalNewTriggerMapIndirect =new Map<Id, Apttus_Proposal__Proposal__c>();
	Map<Id, Apttus_Proposal__Proposal__c> proposalNewTriggerMap=new Map<Id, Apttus_Proposal__Proposal__c>();
	Map<Id, Apttus_Proposal__Proposal__c> proposalOldTriggerMap=new Map<Id, Apttus_Proposal__Proposal__c>();
	proposalNewTriggerMap.put(Quote_Obj.Id,Quote_Obj);
	proposalOldTriggerMap.put(Quote_Obj.Id,Quote_Obj);
	proposalNewTriggerMapIndirect.put(Quote_Obj1.Id,Quote_Obj1);
	ProposalTriggerHelper.checkBlankFieldsValidation(proposalNewTriggerMap,proposalOldTriggerMap);
	ProposalTriggerHelper.updateDirectExchangeRate(NULL,NULL);
	//ProposalTriggerHelper.sspsrsValueReturn('IP Routing','SSP');
	ProposalTriggerHelper.sspsrsValueReturn(new List<String>{'IP Routing'},'SSP');
	ProposalTriggerHelper.checkBlankFieldsValidation(proposalNewTriggerMapIndirect,proposalOldTriggerMap);

	ProposalTriggerHelper.customValidationOnDirectQickActions(proposalNewTriggerMap,proposalOldTriggerMap);
	List<Apttus_Proposal__Proposal__c> lt_quote=new List<Apttus_Proposal__Proposal__c>();
	lt_quote.add(Quote_Obj);
	ProposalTriggerHelper.updateExchangeRateFieldsOnBeforeInsert(lt_quote);
	ProposalTriggerHelper.updateExchangeRateFieldsOnBeforeInsert(null);

	//Added for ITCCPQ 2557
	ProposalTriggerHelper.populateSearchClusterFields(lt_quote);

	test.stopTest();
}


static testMethod void test_insertServiceRecord(){
	//List<Account> account_Obj  =  [SELECT Id,Name, Acc_No__c from Account where Acc_No__c ='Test Account' Limit 1];
	//List<Opportunity> opportunity_Obj  =  [SELECT Id from Opportunity];

	File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
	fscs.name= 'Opportunity_SalesPhase_FinalStage';
	fscs.Value__c = 'Completed';
	insert fscs;


	//Create Account
	/*  Account account = NF_TestDataFactory.createAccount('Test Account');
	account.L2Name__c = 'TestL2Name';
	List<Account> account_Obj=new List<Account>();
	account_Obj.add(account);
	insert accounts1;
	QuoteWarningMessage.getQuoteId(account_Obj[0].Id);*/
	//Create Opportunity
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].L2Name__c = 'Nokia Networks';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> account_Obj = new List<Account>();
	account_Obj.add(accounts[0]);
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunity_Obj = NOKIA_CPQ_TestDataFactory.getOpportunities(3,account_Obj);
	opportunity_Obj[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunity_Obj[0].End_Customer_LE__c = accounts[1].id;
	opportunity_Obj[0].Account_Role__c = 'GPP Distributor Partner';
	opportunity_Obj[0].CurrencyIsoCode = 'USD';
	insert opportunity_Obj;
	//QuoteWarningMessage.getQuoteId(accounts[0].Id);

	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = account_Obj[0].Id;
	accreditations[1].partner__c = account_Obj[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	//Create Proposal
	Apttus_Proposal__Proposal__c Quote_Obj = new Apttus_Proposal__Proposal__c(
		Apttus_Proposal__Proposal_Name__c = 'quote',
		Apttus_Proposal__Approval_Stage__c = 'Draft',
		Apttus_Proposal__Account__c = account_Obj[0].Id,
		Apttus_Proposal__Opportunity__c = opportunity_Obj[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		//NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		//NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing'
		//NokiaCPQ_No_of_Years__c = '1'
		);
	insert Quote_Obj;

	Quote_Obj.Apttus_Proposal__Proposal_Name__c= 'quote1';
	Quote_Obj.Apttus_Proposal__Approval_Stage__c = 'Approved';
	update Quote_Obj;
	test.stopTest();
}
static testMethod void test_Proposaltrigger1(){
	//List<Account> account_Obj  =  [SELECT Id,Name, Acc_No__c from Account where Acc_No__c ='Test Account' Limit 1];
	//List<Opportunity> opportunity_Obj  =  [SELECT Id from Opportunity];

	File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
	fscs.name= 'Opportunity_SalesPhase_FinalStage';
	fscs.Value__c = 'Completed';
	insert fscs;


	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> account_Obj = new List<Account>();
	account_Obj.add(accounts[0]);
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunity_Obj = NOKIA_CPQ_TestDataFactory.getOpportunities(3,account_Obj);
	opportunity_Obj[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunity_Obj[0].End_Customer_LE__c = accounts[1].id;
	opportunity_Obj[0].Account_Role__c = 'GPP Distributor Partner';
	opportunity_Obj[0].CurrencyIsoCode = 'USD';
	insert opportunity_Obj;
	//QuoteWarningMessage.getQuoteId(accounts[0].Id);

	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = account_Obj[0].Id;
	accreditations[1].partner__c = account_Obj[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	//Create Proposal
	Apttus_Proposal__Proposal__c Quote_Obj = new Apttus_Proposal__Proposal__c(
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Approved',
		Apttus_Proposal__Account__c = account_Obj[0].Id,
		Apttus_Proposal__Opportunity__c = opportunity_Obj[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '1'//,
		//NokiaProductAccreditation__c = accreditations[0].Id
		);
	insert Quote_Obj;

	Shipping_Location__c shipping_location = new Shipping_Location__c();
	shipping_location.Portfolio__c = 'IP Routing';
	shipping_location.Pricing_Cluster__c = 'Europe';
	insert shipping_location;

	Map<Id, Apttus_Proposal__Proposal__c> proposalNewTriggerMap=new Map<Id, Apttus_Proposal__Proposal__c>();
	Map<Id, Apttus_Proposal__Proposal__c> proposalOldTriggerMap=new Map<Id, Apttus_Proposal__Proposal__c>();
	proposalNewTriggerMap.put(Quote_Obj.Id,Quote_Obj);
	proposalOldTriggerMap.put(Quote_Obj.Id,Quote_Obj);
	ProposalTriggerHelper.checkBlankFieldsValidation(proposalNewTriggerMap,proposalOldTriggerMap);

	List<Apttus_Proposal__Proposal__c> lt_quote=new List<Apttus_Proposal__Proposal__c>();
	lt_quote.add(Quote_Obj);
	ProposalTriggerHelper.updateExchangeRateFieldsOnBeforeInsert(lt_quote);
	ProposalTriggerHelper.insertServiceRecord(NULL);
	ProposalTriggerHelper.InsertMaintenanceSSPandSRS(NULL);

	test.stopTest();
}
static testMethod void test_Proposaltrigger2(){
	//List<Account> account_Obj  =  [SELECT Id,Name, Acc_No__c from Account where Acc_No__c ='Test Account' Limit 1];
	//List<Opportunity> opportunity_Obj  =  [SELECT Id from Opportunity];

	File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
	fscs.name= 'Opportunity_SalesPhase_FinalStage';
	fscs.Value__c = 'Completed';
	insert fscs;


	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> account_Obj = new List<Account>();
	account_Obj.add(accounts[0]);
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunity_Obj = NOKIA_CPQ_TestDataFactory.getOpportunities(3,account_Obj);
	opportunity_Obj[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunity_Obj[0].End_Customer_LE__c = accounts[1].id;
	opportunity_Obj[0].Account_Role__c = 'GPP Distributor Partner';
	opportunity_Obj[0].CurrencyIsoCode = 'USD';
	insert opportunity_Obj;
	//QuoteWarningMessage.getQuoteId(accounts[0].Id);

	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = account_Obj[0].Id;
	accreditations[1].partner__c = account_Obj[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();
	//Create Proposal
	list<Apttus_Proposal__Proposal__c> QuoteList = new list<Apttus_Proposal__Proposal__c>();
	Apttus_Proposal__Proposal__c Quote_Obj = new Apttus_Proposal__Proposal__c(
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Draft',
		Apttus_Proposal__Account__c = account_Obj[0].Id,
		Apttus_Proposal__Opportunity__c = opportunity_Obj[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '1',
		//NokiaProductAccreditation__c = accreditations[0].Id,
		NokiaCPQ_Is_Maintenance_Quote__c=false
		);
	QuoteList.add(Quote_Obj);
	Apttus_Proposal__Proposal__c Quote_Obj1 = new Apttus_Proposal__Proposal__c(
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Draft',
		Apttus_Proposal__Account__c = account_Obj[0].Id,
		Apttus_Proposal__Opportunity__c = opportunity_Obj[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		//NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '1',
		//NokiaProductAccreditation__c = accreditations[0].Id,
		NokiaCPQ_Is_Maintenance_Quote__c=false
		);
	QuoteList.add(Quote_Obj1);
	insert QuoteList;
	QuoteList[0].NokiaCPQ_No_of_Years__c = '2';
	update QuoteList[0];

	Shipping_Location__c shipping_location = new Shipping_Location__c();
	shipping_location.Portfolio__c = 'IP Routing';
	shipping_location.Pricing_Cluster__c = 'Europe';
	insert shipping_location;




	List<Product2 > prodList = NOKIA_CPQ_TestDataFactory.productCreationDirect(1);
	prodList[0].name = 'Comptel SRS';
	prodList[0].CurrencyIsoCode = 'USD';
	prodList[0].Business_Group__c='MN';
	prodList[0].Family= 'A&A-CEM';
	prodList[0].Portfolio__c = 'IP Routing';
	prodList[0].ProductCode = 'COMP-1234';
	prodList[0].Apttus_Config2__ConfigurationType__c = 'Standalone';
	prodList[0].IsActive=True;
	prodList[0].RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
	insert prodList;

	Apttus_Config2__PriceList__c pricelist=new Apttus_Config2__PriceList__c();

	// List<Apttus_Config2__PriceList__c> pricelist=[select Name,CurrencyIsoCode from Apttus_Config2__PriceList__c where Name='Global Price List (USD)' LIMIT 1];
	pricelist.Name='GPL';
	pricelist.Apttus_Config2__Active__c=true;
	pricelist.CurrencyIsoCode='USD';
	insert pricelist;
	//  pricelist.CurrencyIsoCode='EUR';
	//  update pricelist;

	Apttus_Config2__PriceListItem__c pli= new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c=pricelist.Id,Apttus_Config2__ListPrice__c= 100.00, Apttus_Config2__ProductId__c=prodList[0].Id,Apttus_Config2__ChargeType__c='Product Price');
	insert pli;

	Optional_Services_Detail__c optionalservice = new Optional_Services_Detail__c(
		Accreditation_Level__c = 'Advanced',Portfolio__c = 'IP Routing',
		CurrencyIsoCode='USD',Product__c=prodList[0].Id);

	//  List<Optional_Services_Detail__c> osdetail =[SELECT Id,Product__r.Id,Product__r.ProductCode,Product__r.Description,Portfolio__c, NMS__c,Accreditation_Level__c from Optional_Services_Detail__c where Portfolio__c = 'IP Routing' LIMIT 1];


	insert optionalservice;


	Map<Id, Apttus_Proposal__Proposal__c> proposalNewTriggerMap=new Map<Id, Apttus_Proposal__Proposal__c>();
	Map<Id, Apttus_Proposal__Proposal__c> proposalOldTriggerMap=new Map<Id, Apttus_Proposal__Proposal__c>();
	proposalNewTriggerMap.put(QuoteList[0].Id,QuoteList[0]);
	proposalOldTriggerMap.put(QuoteList[0].Id,QuoteList[0]);
	ProposalTriggerHelper.checkBlankFieldsValidation(proposalNewTriggerMap,proposalOldTriggerMap);
	ProposalTriggerHelper.updateRepriseOnMaintChange(proposalNewTriggerMap,proposalOldTriggerMap);
	List<Apttus_Proposal__Proposal__c> lt_quote=new List<Apttus_Proposal__Proposal__c>();
	lt_quote.add(QuoteList[0]);
	ProposalTriggerHelper.updateExchangeRateFieldsOnBeforeInsert(lt_quote);
	ProposalTriggerHelper.insertServiceRecord(lt_quote);
	/*
	Map<Id, Apttus_Proposal__Proposal__c> proposalNewTriggerMap1=new Map<Id, Apttus_Proposal__Proposal__c>();
	Map<Id, Apttus_Proposal__Proposal__c> proposalOldTriggerMap1=new Map<Id, Apttus_Proposal__Proposal__c>();
	proposalNewTriggerMap.put(QuoteList[1].Id,QuoteList[1]);
	proposalOldTriggerMap.put(QuoteList[1].Id,QuoteList[1]);
	ProposalTriggerHelper.checkBlankFieldsValidation(proposalNewTriggerMap1,proposalOldTriggerMap1);
	ProposalTriggerHelper.updateRepriseOnMaintChange(proposalNewTriggerMap1,proposalOldTriggerMap1);
	List<Apttus_Proposal__Proposal__c> lt_quote1=new List<Apttus_Proposal__Proposal__c>();
	lt_quote.add(QuoteList[1]);
	ProposalTriggerHelper.updateExchangeRateFieldsOnBeforeInsert(lt_quote1);
	ProposalTriggerHelper.insertServiceRecord(lt_quote1);*/



	test.stopTest();
}

static testMethod void test_PriceList(){

	//List<Account> account_Obj  =  [SELECT Id,Name, Acc_No__c from Account where Acc_No__c ='Test Account' Limit 1];
	//List<Opportunity> opportunity_Obj  =  [SELECT Id from Opportunity];

	File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
	fscs.name= 'Opportunity_SalesPhase_FinalStage';
	fscs.Value__c = 'Completed';
	insert fscs;

	Shipping_Location__c shipping_location = new Shipping_Location__c();
	shipping_location.Portfolio__c = 'IP Routing';
	shipping_location.Pricing_Cluster__c = 'Europe';
	insert shipping_location;

	list<Apttus_Config2__PriceList__c> listPriceList = new list<Apttus_Config2__PriceList__c>();
	Apttus_Config2__PriceList__c pricelist=new Apttus_Config2__PriceList__c();
	pricelist.Name='GPL';
	pricelist.Apttus_Config2__Active__c=true;
	pricelist.PriceList_Type__c = 'CPQ';
	pricelist.Apttus_Config2__Active__c = TRUE;
	pricelist.CurrencyIsoCode='USD';
	//pricelist.Apttus_Config2__BasedOnPriceListId__c='a5t2100000099P2AAI';
	Apttus_Config2__PriceList__c pricelist1=new Apttus_Config2__PriceList__c();
	pricelist1.Name='Test1';
	pricelist1.Apttus_Config2__Active__c=true;
	pricelist1.PriceList_Type__c = 'Direct';
	pricelist1.Apttus_Config2__Active__c = TRUE;
	pricelist1.CurrencyIsoCode='USD';
	pricelist1.NokiaCPQ_Name__c = 'Dummy Price List2';
	listPriceList.add(pricelist1);

	Apttus_Config2__PriceList__c pricelist2=new Apttus_Config2__PriceList__c();
	pricelist2.Name='Test2';
	pricelist2.Apttus_Config2__Active__c=true;
	pricelist2.PriceList_Type__c = 'Direct';
	pricelist2.Apttus_Config2__Active__c = TRUE;
	pricelist2.CurrencyIsoCode='USD';
	pricelist2.NokiaCPQ_Name__c = 'Smoke MN EUR Price List';
	listPriceList.add(pricelist2);

	insert listPriceList;

	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> account_Obj = new List<Account>();
	// accounts[0].NokiaCPQ_Applicable_Price_Lists__c = 'NASPO PriceList';
	accounts[0].Partner_Type__c = 'Distributor';
	account_Obj.add(accounts[0]);
	// update accounts[0];

	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunity_Obj = NOKIA_CPQ_TestDataFactory.getOpportunities(3,account_Obj);
	opportunity_Obj[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunity_Obj[0].End_Customer_LE__c = accounts[1].id;
	opportunity_Obj[0].Account_Role__c = 'GPP Distributor Partner';
	opportunity_Obj[0].CurrencyIsoCode = 'USD';
	opportunity_Obj[0].PRMDeal_Origination_Discount_Status__c = 'Approved with DOD';
	insert opportunity_Obj;
	//QuoteWarningMessage.getQuoteId(accounts[0].Id);

	Contract Con = new Contract();
	//Con.Account = accounts[0];
	Con.AccountId = account_Obj[0].Id;
	Con.NokiaCPQ_Sub_Contract_Type__c = 'Primary';
	Con.Status = 'Activated';
	Con.Contract_Type__c = 'PPA-RES';
	Con.Name='Test';
	Con.Contract_Status_New__c = 'Active';
	Con.StartDate =  Date.Today();
	// insert Con;
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = account_Obj[0].Id;
	accreditations[1].partner__c = account_Obj[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();

	//Create Proposal
	list<Apttus_Proposal__Proposal__c> listProposal = new list<Apttus_Proposal__Proposal__c>();
	Apttus_Proposal__Proposal__c Quote_Obj = new Apttus_Proposal__Proposal__c(
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Approved',
		Apttus_Proposal__Account__c = account_Obj[0].Id,
		Apttus_Proposal__Opportunity__c = opportunity_Obj[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '1',
		CurrencyISOCode = 'USD',
		exchange_rate__c = 1.1147,
		//NokiaProductAccreditation__c = accreditations[0].Id,
		NokiaCPQPricing_Cluster__c = 'Europe'
		);
	insert Quote_Obj;
	listProposal.add(Quote_Obj);

	//Create Proposal
	list<Apttus_Proposal__Proposal__c> listProposal1 = new list<Apttus_Proposal__Proposal__c>();
	Apttus_Proposal__Proposal__c Quote_Obj1 = new Apttus_Proposal__Proposal__c(
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Draft',
		Apttus_Proposal__Account__c = account_Obj[0].Id,
		Apttus_Proposal__Opportunity__c = opportunity_Obj[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today()+30,
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '2',
		CurrencyISOCode = 'USD',
		exchange_rate__c = 1.15327,
		//NokiaProductAccreditation__c = accreditations[0].Id,
		NokiaCPQPricing_Cluster__c = 'Europe'
		);
	insert Quote_Obj1;
	listProposal1.add(Quote_Obj);

	//GlobalConstants.DIRECT_QUOTE_TYPE = 'Direct CPQ';


	List<CurrencyType> currencyObj = [select IsoCode, ConversionRate from CurrencyType];

	Map<Id, Apttus_Proposal__Proposal__c> proposalNewTriggerMap2=new Map<Id, Apttus_Proposal__Proposal__c>();
	Map<Id, Apttus_Proposal__Proposal__c> proposaloldTriggerMap3=new Map<Id, Apttus_Proposal__Proposal__c>();
	proposalNewTriggerMap2.put(Quote_Obj1.id,Quote_Obj1);
	proposaloldTriggerMap3.put(Quote_Obj.id,Quote_Obj);
	ProposalTriggerHelper.updateDirectExchangeRate(proposalNewTriggerMap2,proposaloldTriggerMap3);
	ProposalTriggerHelper.associateDirectPriceList(listProposal);
	ProposalTriggerHelper.updateQuoteExpiryDate(listProposal);
	ProposalTriggerHelper.updateQuoteExpiryDate(NULL);
	ProposalTriggerHelper.updateQuoteRecordType(listProposal);
	ProposalTriggerHelper.updateContractNameOnQuote(listProposal);
	ProposalTriggerHelper.quoteStatusToValidate(listProposal);
	ProposalTriggerHelper.updateListPriceIONDirect(listProposal);
	ProposalTriggerHelper.updateIndirectOnOppChange(listProposal);
	//ProposalTriggerHelper.associateDirectPriceList(pricelist);
	test.stopTest();
}

static testMethod void testDirectQuote(){

	//List<Account> account_Obj  =  [SELECT Id,Name, Acc_No__c from Account where Acc_No__c ='Test Account' Limit 1];
	//List<Opportunity> opportunity_Obj  =  [SELECT Id from Opportunity];

	File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
	fscs.name= 'Opportunity_SalesPhase_FinalStage';
	fscs.Value__c = 'Completed';
	insert fscs;


	//Create Account
	/* Account account = NF_TestDataFactory.createAccount('Test Account');
	account.L2Name__c = 'TestL2Name';
	List<Account> account_Obj=new List<Account>();
	account_Obj.add(account);
	insert account_Obj;*/
	//  QuoteWarningMessage.getQuoteId(account_Obj[0].Id);
	//Create Opportunity
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);
	update accounts[0];
	acclist.add(accounts[0]);
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	opportunities[0].CurrencyIsoCode = 'USD';
	insert opportunities;
	//QuoteWarningMessage.getQuoteId(accounts[0].Id);

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;

	//create opportunity

	test.startTest();

	//Create Proposal
	list<Apttus_Proposal__Proposal__c> listProposal = new list<Apttus_Proposal__Proposal__c>();
	Apttus_Proposal__Proposal__c Quote_Obj = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Approved',
		Apttus_Proposal__Account__c = accounts[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c	  = true,
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '1',
		CurrencyISOCode = 'USD',
		exchange_rate__c = 2//,
		//NokiaProductAccreditation__c = accreditations[0].Id
		);
	insert Quote_Obj;
	listProposal.add(Quote_Obj);

	//Create Proposal
	list<Apttus_Proposal__Proposal__c> listProposal1 = new list<Apttus_Proposal__Proposal__c>();
	Apttus_Proposal__Proposal__c Quote_Obj1 = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote_Read_Only').getRecordTypeId(),
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Draft',
		Apttus_Proposal__Account__c = accounts[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today()+30,
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '2',
		CurrencyISOCode = 'EUR',
		exchange_rate__c = 1.15327//,
		//NokiaProductAccreditation__c = accreditations[0].Id
		);
	insert Quote_Obj1;

	//GlobalConstants.DIRECT_QUOTE_TYPE = 'Direct CPQ';
	Apttus_Config2__PriceList__c pricelist=new Apttus_Config2__PriceList__c();
	pricelist.Name='GPL';
	pricelist.Apttus_Config2__Active__c=true;
	pricelist.PriceList_Type__c = 'CPQ';
	pricelist.Apttus_Config2__Active__c = TRUE;
	pricelist.CurrencyIsoCode='EUR';
	//pricelist.Apttus_Config2__BasedOnPriceListId__c='a5t2100000099P2AAI';
	insert pricelist;

	List<CurrencyType> currencyObj = [select IsoCode, ConversionRate from CurrencyType];

	Map<Id, Apttus_Proposal__Proposal__c> proposalNewTriggerMap2=new Map<Id, Apttus_Proposal__Proposal__c>();
	Map<Id, Apttus_Proposal__Proposal__c> proposaloldTriggerMap3=new Map<Id, Apttus_Proposal__Proposal__c>();
	proposalNewTriggerMap2.put(Quote_Obj1.id,Quote_Obj1);
	proposaloldTriggerMap3.put(Quote_Obj.id,Quote_Obj);
	ProposalTriggerHelper.updateDirectExchangeRate(proposalNewTriggerMap2,proposaloldTriggerMap3);
	ProposalTriggerHelper.associateDirectPriceList(listProposal);
	ProposalTriggerHelper.updateQuoteExpiryDate(listProposal);
	ProposalTriggerHelper.updateQuoteExpiryDate(NULL);
	ProposalTriggerHelper.updateQuoteRecordType(listProposal);
	ProposalTriggerHelper.updateContractNameOnQuote(listProposal);
	ProposalTriggerHelper.quoteStatusToValidate(listProposal);
	ProposalTriggerHelper.updateListPriceIONDirect(listProposal);
	ProposalTriggerHelper.updateIndirectOnOppChange(listProposal);
	test.stopTest();
}

static testMethod void testDirectQuote1(){

	//List<Account> account_Obj  =  [SELECT Id,Name, Acc_No__c from Account where Acc_No__c ='Test Account' Limit 1];
	//List<Opportunity> opportunity_Obj  =  [SELECT Id from Opportunity];

	File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
	fscs.name= 'Opportunity_SalesPhase_FinalStage';
	fscs.Value__c = 'Completed';
	insert fscs;


	//Create Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> account_Obj = new List<Account>();
	account_Obj.add(accounts[0]);
	update accounts[0];
	account_Obj.add(accounts[0]);
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunity_Obj =  NOKIA_CPQ_TestDataFactory.getOpportunities(1,account_Obj);
	opportunity_Obj[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunity_Obj[0].End_Customer_LE__c = accounts[1].id;
	opportunity_Obj[0].Account_Role__c = 'GPP Distributor Partner';
	opportunity_Obj[0].CurrencyIsoCode = 'USD';
	insert opportunity_Obj;
	//QuoteWarningMessage.getQuoteId(accounts[0].Id);


	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = account_Obj[0].Id;
	accreditations[1].partner__c = account_Obj[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	test.startTest();

	//Create Proposal
	list<Apttus_Proposal__Proposal__c> listProposal = new list<Apttus_Proposal__Proposal__c>();
	Apttus_Proposal__Proposal__c Quote_Obj = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Approved',
		Apttus_Proposal__Account__c = account_Obj[0].Id,
		Apttus_Proposal__Opportunity__c = opportunity_Obj[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		// NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c= true,
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '1',
		CurrencyISOCode = 'EUR',
		exchange_rate__c = 1.1147//,
		//NokiaProductAccreditation__c = accreditations[0].Id
		);
	insert Quote_Obj;
	listProposal.add(Quote_Obj);

	//Create Proposal
	list<Apttus_Proposal__Proposal__c> listProposal1 = new list<Apttus_Proposal__Proposal__c>();
	Apttus_Proposal__Proposal__c Quote_Obj1 = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote_Read_Only').getRecordTypeId(),
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Draft',
		Apttus_Proposal__Account__c = account_Obj[0].Id,
		Apttus_Proposal__Opportunity__c = opportunity_Obj[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today()+30,
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '2',
		CurrencyISOCode = 'USD',
		exchange_rate__c = 1.15327,
		//NokiaProductAccreditation__c = accreditations[0].Id,
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = true
		);
	insert Quote_Obj1;

	//GlobalConstants.DIRECT_QUOTE_TYPE = 'Direct CPQ';
	Apttus_Config2__PriceList__c pricelist=new Apttus_Config2__PriceList__c();
	pricelist.Name='GPL';
	pricelist.Apttus_Config2__Active__c=true;
	pricelist.PriceList_Type__c = 'CPQ';
	pricelist.Apttus_Config2__Active__c = TRUE;
	pricelist.CurrencyIsoCode='USD';
	//pricelist.Apttus_Config2__BasedOnPriceListId__c='a5t2100000099P2AAI';
	insert pricelist;

	List<CurrencyType> currencyObj = [select IsoCode, ConversionRate from CurrencyType];

	Map<Id, Apttus_Proposal__Proposal__c> proposalNewTriggerMap2=new Map<Id, Apttus_Proposal__Proposal__c>();
	Map<Id, Apttus_Proposal__Proposal__c> proposaloldTriggerMap3=new Map<Id, Apttus_Proposal__Proposal__c>();
	proposalNewTriggerMap2.put(Quote_Obj1.id,Quote_Obj1);
	proposaloldTriggerMap3.put(Quote_Obj.id,Quote_Obj);
	ProposalTriggerHelper.updateDirectExchangeRate(proposalNewTriggerMap2,proposaloldTriggerMap3);
	ProposalTriggerHelper.associateDirectPriceList(listProposal);
	ProposalTriggerHelper.updateQuoteExpiryDate(listProposal);
	ProposalTriggerHelper.updateQuoteExpiryDate(NULL);
	ProposalTriggerHelper.updateQuoteRecordType(listProposal);
	ProposalTriggerHelper.updateContractNameOnQuote(listProposal);
	ProposalTriggerHelper.quoteStatusToValidate(listProposal);
	ProposalTriggerHelper.updateListPriceIONDirect(listProposal);
	ProposalTriggerHelper.updateIndirectOnOppChange(listProposal);

	//added by Rajitha
	Apttus_Config2__PriceList__c pricelist1 = new Apttus_Config2__PriceList__c();
	pricelist1.Name='Global Price List (USD)';
	pricelist1.Apttus_Config2__Active__c=true;
	pricelist1.PriceList_Type__c = 'CPQ';
	pricelist1.Apttus_Config2__Active__c = TRUE;
	pricelist1.CurrencyIsoCode='USD';
	insert pricelist1;
	ProposalTriggerHelper.updateNCQQuotes(listProposal);
	// ProposalTriggerHelper.createGppCart(listProposal);
	//end
	test.stopTest();
}




/*static testmethod void ProposalTriggerhelperTestNew(){
   List<Account> accounts1 = NOKIA_CPQ_TestDataFactory.getAccounts(1);
   accounts1[0].Acc_No__c = 'Testing New2';
   accounts1[0].Partner_Program__c ='';
   accounts1[0].NokiaCPQ_Applicable_Price_Lists__c = 'Dummy Price List1';
   accounts1[0].Partner_Type__c = '';
   accounts1[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
   insert accounts1;
   List<opportunity> opportunities = NF_TestDataFactory.getOpportunities(1,accounts1);
   opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
   opportunities[0].Account_Role__c = 'GPP Distributor Partner';
   insert opportunities;
   list<Apttus_Proposal__Proposal__c> propList = new list<Apttus_Proposal__Proposal__c>();
   Apttus_Proposal__Proposal__c proposals = new Apttus_Proposal__Proposal__c(
   Apttus_Proposal__Account__c = accounts1[0].Id,
   Apttus_Proposal__Opportunity__c = opportunities[0].Id,
   NokiaCPQ_Needs_Reprice__c = false,
   Reprice_In_Progress__c = false,
   NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
   //NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
   //NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
   //NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
   NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
   NokiaCPQ_SSP_Level__c = 'Unlimited',
   NokiaCPQ_SRS_Level__c = 'Unlimited',
   Apttus_Proposal__Approval_Stage__c = 'Approved',
   NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
   NokiaCPQ_Portfolio__c = 'IP Routing',
   NokiaCPQ_No_of_Years__c = '2'
   );
   insert proposals;
   propList.add(proposals);
   list<Apttus_Proposal__Proposal__c> propList1 = new list<Apttus_Proposal__Proposal__c>();
   Apttus_Proposal__Proposal__c proposals1 = new Apttus_Proposal__Proposal__c(
   Apttus_Proposal__Account__c = accounts1[0].Id,
   Apttus_Proposal__Opportunity__c = opportunities[0].Id,
   NokiaCPQ_Needs_Reprice__c = false,
   Reprice_In_Progress__c = false,
   NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
   //NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
   //NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
   //NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
   NokiaCPQ_Capture_Cancel_Recall_Action__c='Test1',
   NokiaCPQ_SSP_Level__c = 'Unlimited',
   NokiaCPQ_SRS_Level__c = 'Unlimited',
   Apttus_Proposal__Approval_Stage__c = 'Draft',
   NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
   NokiaCPQ_Portfolio__c = 'IP Routing',
   NokiaCPQ_No_of_Years__c = '1'
   );
   insert proposals1;
   propList1.add(proposals1);
   Map<Id, Apttus_Proposal__Proposal__c> proposalTriggerMap = new Map<Id, Apttus_Proposal__Proposal__c>();
   proposalTriggerMap.put(propList[0].id,proposals);
   Map<Id, Apttus_Proposal__Proposal__c> proposalTriggerMap2 = new Map<Id, Apttus_Proposal__Proposal__c>();
   proposalTriggerMap2.put(propList1[0].id,proposals1);
   ProposalTriggerHelper.customValidationOnDirectQickActions(proposalTriggerMap,proposalTriggerMap2);
   }*/
   /*
static testMethod void test_Proposaltrigger10(){
	File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
	fscs.name= 'Opportunity_SalesPhase_FinalStage';
	fscs.Value__c = 'Completed';
	insert fscs;

	List<User> userList = new List<User>();
	Sales_Role__c sr = new Sales_Role__c();



	//Create Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].L2Name__c = 'Nokia Networks';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> account_Obj = new List<Account>();
	account_Obj.add(accounts[0]);
	update accounts[0];
	account_Obj.add(accounts[0]);
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunity_Obj = NOKIA_CPQ_TestDataFactory.getOpportunities(3,account_Obj);
	opportunity_Obj[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunity_Obj[0].End_Customer_LE__c = accounts[1].id;
	opportunity_Obj[0].Account_Role__c = 'GPP Distributor Partner';
	opportunity_Obj[0].CurrencyIsoCode = 'USD';
	insert opportunity_Obj;
	//QuoteWarningMessage.getQuoteId(accounts[0].Id);


	userList = TestDataFactory.userCreation(1, 'System Administrator');
	userList[0].NSA_Compliant__c = True;
	userList[0].Restriction_Level__c = 'Unrestricted';
	Database.insert(userList);
	System.runAs(userList[0]){
		//sr.First_Name__c = 'Holger1';
		//sr.Last_Name__c ='Streckert';
		sr.Organisation__c = 'Nokia Networks';
		sr.Role_Code__c ='NSND_PrMBG';
		sr.Role_Name__c  ='5 - BG Pricing Manager';

		sr.BG__c = 'FN';
		sr.User__c = userList[0].Id;
		Database.insert(sr);

		OpportunityTeamMember opt = new OpportunityTeamMember();
		opt.UserId = userList[0].Id;
		opt.OpportunityId = opportunity_Obj[0].Id;
		opt.TeamMemberRole = 'Account Manager';
		Database.insert(opt);



		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = account_Obj[0].Id;
		accreditations[1].partner__c = account_Obj[0].Id;
		//accreditations[0].Portfolio__c = 'Fixed Access - POL';
		//accreditations[1].Portfolio__c = 'Fixed Access - POL';
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';
		insert accreditations;
		test.startTest();
		//Create Proposal
		Apttus_Proposal__Proposal__c Quote_Obj = new Apttus_Proposal__Proposal__c(
			Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Approved',
			Apttus_Proposal__Account__c = account_Obj[0].Id,
			Apttus_Proposal__Opportunity__c = opportunity_Obj[0].Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
			NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
			//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
			//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
			//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
			NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
			NokiaCPQ_SSP_Level__c = 'Unlimited',
			NokiaCPQ_SRS_Level__c = 'Unlimited',
			NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
			NokiaCPQ_Portfolio__c = 'IP Routing',
			NokiaCPQ_No_of_Years__c = '1',
			NokiaCPQ_Is_Maintenance_Quote__c=true,
			Warranty_credit__c = 'No',
			NokiaCPQ_Contract_Start_Date__c = System.today()//,
			//NokiaProductAccreditation__c = accreditations[0].Id
			);
		insert Quote_Obj;

		//  Apttus_Config2__PriceList__c objPriceList = [Select Id, Name, Apttus_Config2__Type__c FROM Apttus_Config2__PriceList__c WHERE Name = 'Global Price List (EUR)' LIMIT 1];
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
		priceList.CurrencyIsoCode='EUR';//'GBP';
		priceList.Apttus_Config2__BasedOnPriceListId__c=objPriceList.id;
		priceList.Apttus_Config2__Active__c=true;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		insert priceList;

		// create a product configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = objPriceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = Quote_Obj.Id;
		insert prodConfigs;


		/* Product2 productInst = new Product2();
	 productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND Apttus_Config2__ConfigurationType__c = 'Option' LIMIT 1];
	 system.debug('>>>direct product::>>'+productInst.Apttus_Config2__ConfigurationType__c); */

		/*List<Product2> productInst = NOKIA_CPQ_TestDataFactory.productCreationDirect(1);
		productInst[0].CurrencyIsoCode = 'EUR';
		insert productInst;

		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = objPriceList.Id,
			Apttus_Config2__ListPrice__c = 100,
			CurrencyIsoCode='EUR',
			Apttus_Config2__ProductId__c = productInst[0].Id,
			Apttus_Config2__ChargeType__c = 'Standard Price'
			);
		insert pLI1;

		// create a Line Item
		List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
		lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
		lineItems[0].Apttus_Config2__ProductId__c = productInst[0].Id;
		lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;
		lineItems[0].Apttus_Config2__PriceListItemId__c = pLI1.id;
		//  lineItems[0].Apttus_Config2__LineType__c = 'Product/Service';
		//   lineItems[0].Apttus_Config2__ChargeType__c ='Standard Price';


		insert lineItems;

		Shipping_Location__c shipping_location = new Shipping_Location__c();
		shipping_location.Portfolio__c = 'IP Routing';
		shipping_location.Pricing_Cluster__c = 'Europe';
		insert shipping_location;

		Map<Id, Apttus_Proposal__Proposal__c> proposalNewTriggerMap=new Map<Id, Apttus_Proposal__Proposal__c>();
		Map<Id, Apttus_Proposal__Proposal__c> proposalOldTriggerMap=new Map<Id, Apttus_Proposal__Proposal__c>();
		proposalNewTriggerMap.put(Quote_Obj.Id,Quote_Obj);
		proposalOldTriggerMap.put(Quote_Obj.Id,Quote_Obj);
		ProposalTriggerHelper.checkBlankFieldsValidation(proposalNewTriggerMap,proposalOldTriggerMap);

		List<Apttus_Proposal__Proposal__c> lt_quote=new List<Apttus_Proposal__Proposal__c>();
		lt_quote.add(Quote_Obj);
		Set<Id> quoteIdSet = New Set<Id>();
		quoteIdSet.add(Quote_Obj.id);
		ProposalTriggerHelper.updateExchangeRateFieldsOnBeforeInsert(lt_quote);
		ProposalTriggerHelper.insertServiceRecord(NULL);
		ProposalTriggerHelper.InsertMaintenanceSSPandSRS(NULL);
		//ProposalTriggerHelper.createGppCart(lt_quote);
		ProposalTriggerHelper.updateStatusonLI(quoteIdSet);
		// ProposalTriggerHelper.updateNCQfieldsOnUpdate(proposalNewTriggerMap,proposalOldTriggerMap);
		test.stopTest();
	}

}*/

static testmethod void test_Proposaltrigger11(){

	//List<Account> account_Obj  =  [SELECT Id,Name, Acc_No__c from Account where Acc_No__c ='Test Account' Limit 1];
	//List<Opportunity> opportunity_Obj  =  [SELECT Id from Opportunity];

	File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
	fscs.name= 'Opportunity_SalesPhase_FinalStage';
	fscs.Value__c = 'Completed';
	insert fscs;


	//Create Account
	/* Account account = NF_TestDataFactory.createAccount('Test Account');
	account.L2Name__c = 'TestL2Name';
	List<Account> account_Obj=new List<Account>();
	account_Obj.add(account);
	insert account_Obj;*/
	//  QuoteWarningMessage.getQuoteId(account_Obj[0].Id);
	//Create Opportunity
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);
	update accounts[0];
	acclist.add(accounts[0]);
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	opportunities[0].CurrencyIsoCode = 'USD';
	insert opportunities;
	//QuoteWarningMessage.getQuoteId(accounts[0].Id);

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;

	//create opportunity

	test.startTest();

	//Create Proposal
	list<Apttus_Proposal__Proposal__c> listProposal = new list<Apttus_Proposal__Proposal__c>();
	Apttus_Proposal__Proposal__c Quote_Obj = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId(),
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Approved',
		Apttus_Proposal__Account__c = accounts[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c	  = true,
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '1',
		CurrencyISOCode = 'USD',
		exchange_rate__c = 2,
		CQ_Value__c =100,
		//NokiaProductAccreditation__c = accreditations[0].Id,


		isCQ__c=true,
		CQ_Initial_Pricing_Date__c= date.today(),
		CQ_Ready_for_Submission__c=date.today()
		);
	insert Quote_Obj;
	listProposal.add(Quote_Obj);

	//Create Proposal
	list<Apttus_Proposal__Proposal__c> listProposal1 = new list<Apttus_Proposal__Proposal__c>();
	Apttus_Proposal__Proposal__c Quote_Obj1 = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NCQ_ReadOnly_Recordtype').getRecordTypeId(),
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Approved',
		Apttus_Proposal__Account__c = accounts[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today()+30,
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '2',
		CurrencyISOCode = 'USD',
		CQ_Value__c =100,
		exchange_rate__c = 1.15327,
		//NokiaProductAccreditation__c = accreditations[0].Id,


		isCQ__c=true,
		CQ_Initial_Pricing_Date__c= date.today(),
		CQ_Ready_for_Submission__c=date.today()
		);
	insert Quote_Obj1;
	Apttus_Config2__PriceList__c pricelist=new Apttus_Config2__PriceList__c();
	pricelist.Name='Global Price List (USD)';
	pricelist.Apttus_Config2__Active__c=true;
	pricelist.PriceList_Type__c = 'CPQ';
	pricelist.Apttus_Config2__Active__c = TRUE;
	pricelist.CurrencyIsoCode='USD';
	//pricelist.Apttus_Config2__BasedOnPriceListId__c='a5t2100000099P2AAI';
	insert pricelist;


	// create a product configuration
	List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
	prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
	prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
	prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
	prodConfigs[0].Apttus_QPConfig__Proposald__c = listProposal[0].Id;
	prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
	insert prodConfigs;

	//get a IP Routing Product
	List<Product2> productInst = new List<Product2>();

	Product2 prod1 = new product2(
		Name = 'Test1',
		ProductCode = '123',
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Bundle',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Standard SW (STD)',
		NokiaCPQ_License_Usage__c='Commercial Term License',
		NokiaCPQ_Product_Discount_Category__c = 'XYZ'
		);
	productInst.add(prod1);
	insert productInst;


	// create a Line Item
	/* List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
	lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
	lineItems[0].Apttus_Config2__ProductId__c = productInst.Id;
	lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;

	insert lineItems;*/

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
		Apttus_Config2__ProductId__c = productInst[0].Id,
		// Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		Apttus_Config2__PricingStatus__c = 'Pending',
		Apttus_Config2__AddedBy__c = 'added by code'
		);


	//insert LineItem2;
	LineItemList.add(LineItem1);

	//create proposal line items
	List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
	proposalLineItemList[0].Apttus_Proposal__Product__c = productInst[0].id;
	proposalLineItemList[0].Apttus_Proposal__Proposal__c =listProposal[0].id;
	proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'option';
	proposalLineItemList[0].Item_Type__c = 'Service';
	insert proposalLineItemList;

	//GlobalConstants.DIRECT_QUOTE_TYPE = 'Direct CPQ';


	List<CurrencyType> currencyObj = [select IsoCode, ConversionRate from CurrencyType];

	Map<Id, Apttus_Proposal__Proposal__c> proposalNewTriggerMap2=new Map<Id, Apttus_Proposal__Proposal__c>();
	Map<Id, Apttus_Proposal__Proposal__c> proposaloldTriggerMap3=new Map<Id, Apttus_Proposal__Proposal__c>();
	proposalNewTriggerMap2.put(Quote_Obj1.id,Quote_Obj1);
	proposaloldTriggerMap3.put(Quote_Obj.id,Quote_Obj);
	ProposalTriggerHelper.updateNCQfieldsOnUpdate(proposalNewTriggerMap2,proposaloldTriggerMap3);

	ProposalTriggerHelper.updateDirectExchangeRate(proposalNewTriggerMap2,proposaloldTriggerMap3);
	ProposalTriggerHelper.associateDirectPriceList(listProposal);
	ProposalTriggerHelper.updateQuoteExpiryDate(listProposal);
	ProposalTriggerHelper.updateQuoteExpiryDate(NULL);
	ProposalTriggerHelper.updateQuoteRecordType(listProposal);
	ProposalTriggerHelper.updateContractNameOnQuote(listProposal);
	ProposalTriggerHelper.quoteStatusToValidate(listProposal);
	ProposalTriggerHelper.updateListPriceIONDirect(listProposal);
	ProposalTriggerHelper.updateIndirectOnOppChange(listProposal);
	ProposalTriggerHelper.updateNCQQuotes(listProposal);
	test.stopTest();
}


static testMethod void test_exceptions(){
	test.startTest();

	ProposalTriggerHelper.sspsrsValueReturn(null,null);

//ProposalTriggerHelper.approvalRequiredChangeStatus(null,null);

	ProposalTriggerHelper.updateIndirectOnOppChange(null);

	ProposalTriggerHelper.quoteStatusToValidate(null);

	ProposalTriggerHelper.updateContractNameOnQuote(null);

	ProposalTriggerHelper.quoteCancelIndirect(null,null);

	ProposalTriggerHelper.updateListPriceIONDirect(null);

	ProposalTriggerHelper.updateStatusonLI(null);

	test.stopTest();
}


static void updateNCQQuotestestDirectQuote(){

	//List<Account> account_Obj  =  [SELECT Id,Name, Acc_No__c from Account where Acc_No__c ='Test Account' Limit 1];
	//List<Opportunity> opportunity_Obj  =  [SELECT Id from Opportunity];

	File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
	fscs.name= 'Opportunity_SalesPhase_FinalStage';
	fscs.Value__c = 'Completed';
	insert fscs;


	//Create Account
	/* Account account = NF_TestDataFactory.createAccount('Test Account');
	account.L2Name__c = 'TestL2Name';
	List<Account> account_Obj=new List<Account>();
	account_Obj.add(account);
	insert account_Obj;*/
	//  QuoteWarningMessage.getQuoteId(account_Obj[0].Id);
	//Create Opportunity
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);
	update accounts[0];
	acclist.add(accounts[0]);
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	opportunities[0].CurrencyIsoCode = 'USD';
	insert opportunities;
	//QuoteWarningMessage.getQuoteId(accounts[0].Id);

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;

	//create opportunity

	test.startTest();

	//Create Proposal
	list<Apttus_Proposal__Proposal__c> listProposal = new list<Apttus_Proposal__Proposal__c>();
	Apttus_Proposal__Proposal__c Quote_Obj = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId(),
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Approved',
		Apttus_Proposal__Account__c = accounts[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c	  = true,
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '1',
		CurrencyISOCode = 'USD',
		exchange_rate__c = 2,
		CQ_Value__c =100//,
		//NokiaProductAccreditation__c = accreditations[0].Id
		);
	insert Quote_Obj;
	listProposal.add(Quote_Obj);

	//Create Proposal
	list<Apttus_Proposal__Proposal__c> listProposal1 = new list<Apttus_Proposal__Proposal__c>();
	Apttus_Proposal__Proposal__c Quote_Obj1 = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote_Read_Only').getRecordTypeId(),
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Draft',
		Apttus_Proposal__Account__c = accounts[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today()+30,
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '2',
		CurrencyISOCode = 'EUR',
		CQ_Value__c =100,
		exchange_rate__c = 1.15327//,
		//NokiaProductAccreditation__c = accreditations[0].Id
		);
	insert Quote_Obj1;
	Apttus_Config2__PriceList__c pricelist=new Apttus_Config2__PriceList__c();
	pricelist.Name='Global Price List (USD)';
	pricelist.Apttus_Config2__Active__c=true;
	pricelist.PriceList_Type__c = 'CPQ';
	pricelist.Apttus_Config2__Active__c = TRUE;
	pricelist.CurrencyIsoCode='USD';
	//pricelist.Apttus_Config2__BasedOnPriceListId__c='a5t2100000099P2AAI';
	insert pricelist;


	// create a product configuration
	List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
	prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
	prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
	prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
	prodConfigs[0].Apttus_QPConfig__Proposald__c = listProposal[0].Id;
	prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
	insert prodConfigs;

	//get a IP Routing Product
	List<Product2> productInst = new List<Product2>();

	Product2 prod1 = new product2(
		Name = 'Test1',
		ProductCode = '123',
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Bundle',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Standard SW (STD)',
		NokiaCPQ_License_Usage__c='Commercial Term License',
		NokiaCPQ_Product_Discount_Category__c = 'XYZ'
		);
	productInst.add(prod1);
	insert productInst;


	// create a Line Item
	/* List<Apttus_Config2__LineItem__c> lineItems = NOKIA_CPQ_TestDataFactory.createLineItem(1);
	lineItems[0].Apttus_Config2__ConfigurationId__c = prodConfigs[0].id;
	lineItems[0].Apttus_Config2__ProductId__c = productInst.Id;
	lineItems[0].Apttus_Config2__PriceListId__c = priceList.Id;

	insert lineItems;*/

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
		Apttus_Config2__ProductId__c = productInst[0].Id,
		// Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		Apttus_Config2__PricingStatus__c = 'Pending',
		Apttus_Config2__AddedBy__c = 'added by code'
		);


	//insert LineItem2;
	LineItemList.add(LineItem1);

	//create proposal line items
	List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
	proposalLineItemList[0].Apttus_Proposal__Product__c = productInst[0].id;
	proposalLineItemList[0].Apttus_Proposal__Proposal__c =listProposal[0].id;
	proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'option';
	proposalLineItemList[0].Item_Type__c = 'Service';
	insert proposalLineItemList;

	//GlobalConstants.DIRECT_QUOTE_TYPE = 'Direct CPQ';


	List<CurrencyType> currencyObj = [select IsoCode, ConversionRate from CurrencyType];

	Map<Id, Apttus_Proposal__Proposal__c> proposalNewTriggerMap2=new Map<Id, Apttus_Proposal__Proposal__c>();
	Map<Id, Apttus_Proposal__Proposal__c> proposaloldTriggerMap3=new Map<Id, Apttus_Proposal__Proposal__c>();
	proposalNewTriggerMap2.put(Quote_Obj1.id,Quote_Obj1);
	proposaloldTriggerMap3.put(Quote_Obj.id,Quote_Obj);
	ProposalTriggerHelper.updateDirectExchangeRate(proposalNewTriggerMap2,proposaloldTriggerMap3);
	ProposalTriggerHelper.associateDirectPriceList(listProposal);
	ProposalTriggerHelper.updateQuoteExpiryDate(listProposal);
	ProposalTriggerHelper.updateQuoteExpiryDate(NULL);
	ProposalTriggerHelper.updateQuoteRecordType(listProposal);
	ProposalTriggerHelper.updateContractNameOnQuote(listProposal);
	ProposalTriggerHelper.quoteStatusToValidate(listProposal);
	ProposalTriggerHelper.updateListPriceIONDirect(listProposal);
	ProposalTriggerHelper.updateIndirectOnOppChange(listProposal);
	ProposalTriggerHelper.updateNCQQuotes(listProposal);
	test.stopTest();
}


static testmethod void directInitTest1(){
	List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();
	List<User> userList = new List<User>();
	userList = TestDataFactory.userCreation(3, 'System Administrator');

	userList[0].NSA_Compliant__c = True;
	userList[0].Restriction_Level__c = 'Unrestricted';
	userList[1].Restriction_Level__c = 'Unrestricted';
	userList[2].Restriction_Level__c = 'Unrestricted';
	Database.insert(userList);
	//create a Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
	insert accounts;

	Account acc = new Account();
	acc.Name='Legal Entity Account For Test';
	acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	acc.ParentId = accounts[0].Id;
	acc.AccountNumber = '100006843';
	database.insert(acc);


	//create opportunity with non-euro currency
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(2,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].CurrencyIsoCode = 'GBP';
	opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[1].CurrencyIsoCode = 'EUR';
	insert opportunities;
	opportunityTeamMemberList = TestDataFactory.optyTeamMemberCreation(2, userList[0], opportunities[0]);
	opportunityTeamMemberList[1].OpportunityId = opportunities[1].Id;
	database.insert(opportunityTeamMemberList);
	Test.startTest();
	//create a quote with non-euro currency
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].CurrencyIsoCode = 'GBP';
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();	 //direct quote
	proposals[0].NokiaCPQ_Maintenance_Type__c = '';
	insert proposals;

	//create opportunity with euro currency
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	//List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
	//opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	//opportunities1[0].CurrencyIsoCode = 'EUR';
	//opportunities1[0].SWx_Upsell_Proposal__c = DigiObj2.Id;
	//insert opportunities1;

	Shipping_Location__c shipping_location = new Shipping_Location__c();
	shipping_location.Portfolio__c = 'IP Routing';
	shipping_location.Pricing_Cluster__c = 'Europe';
	insert shipping_location;

	//Test.startTest();
	//create a quote with non-euro currency
	List<Apttus_Proposal__Proposal__c > proposals1 = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	proposals1[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals1[0].Apttus_Proposal__Opportunity__c = opportunities[1].Id;
	proposals1[0].CurrencyIsoCode = 'EUR';
	proposals1[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();	//direct quote
	proposals1[0].NokiaCPQ_Maintenance_Type__c = '';
	insert proposals1;

	Test.stopTest();




}


static testmethod void test_Proposaltrigger11nan(){

	//List<Account> account_Obj  =  [SELECT Id,Name, Acc_No__c from Account where Acc_No__c ='Test Account' Limit 1];
	//List<Opportunity> opportunity_Obj  =  [SELECT Id from Opportunity];

	File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
	fscs.name= 'Opportunity_SalesPhase_FinalStage';
	fscs.Value__c = 'Completed';
	insert fscs;


	//Create Account
	/* Account account = NF_TestDataFactory.createAccount('Test Account');
	account.L2Name__c = 'TestL2Name';
	List<Account> account_Obj=new List<Account>();
	account_Obj.add(account);
	insert account_Obj;*/
	//  QuoteWarningMessage.getQuoteId(account_Obj[0].Id);
	//Create Opportunity
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);
	update accounts[0];
	acclist.add(accounts[0]);
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	opportunities[0].CurrencyIsoCode = 'USD';
	insert opportunities;
	//QuoteWarningMessage.getQuoteId(accounts[0].Id);

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;

	//create opportunity

	test.startTest();
	Apttus_Config2__PriceList__c pricelist=new Apttus_Config2__PriceList__c();
	pricelist.Name='Global Price List (USD)';
	pricelist.Apttus_Config2__Active__c=true;
	pricelist.PriceList_Type__c = 'FN Direct';
	pricelist.Apttus_Config2__Active__c = TRUE;
	pricelist.CurrencyIsoCode='USD';
	//pricelist.Apttus_Config2__BasedOnPriceListId__c='a5t2100000099P2AAI';
	insert pricelist;
	Apttus_Config2__PriceList__c pricelist1=new Apttus_Config2__PriceList__c();
	pricelist1.Name='Global Price List (USD)';
	pricelist1.Apttus_Config2__Active__c=true;
	pricelist1.PriceList_Type__c = 'FN Direct';
	pricelist1.Apttus_Config2__Active__c = TRUE;
	pricelist1.CurrencyIsoCode='USD';
	pricelist1.Apttus_Config2__BasedOnPriceListId__c=pricelist.id;
	insert pricelist1;

	//Create Proposal
	list<Apttus_Proposal__Proposal__c> listProposal = NOKIA_CPQ_TestDataFactory.createProposal(1);

	listProposal[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();
	listProposal[0].Apttus_Proposal__Account__c = accounts[0].Id;
	listProposal[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	listProposal[0].Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today();
	listProposal[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'No';


	listProposal[0].NokiaCPQ_SSP_Level__c = '';
	listProposal[0].NokiaCPQ_SRS_Level__c = '';
	listProposal[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c	  = true;

	listProposal[0].NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)';
	listProposal[0].NokiaCPQ_Portfolio__c = 'Fixed Network';
	listProposal[0].NokiaCPQ_No_of_Years__c = '1';
	listProposal[0].CurrencyISOCode = 'USD';
	//	exchange_rate__c = 2
	//  CQ_Value__c =100,
	//NokiaProductAccreditation__c = accreditations[0].Id,
	listProposal[0].Apttus_QPConfig__PriceListId__c=pricelist1.id;
	listProposal[0].Master_Currency_Code__c='USD';
	// isCQ__c=true,
	// CQ_Initial_Pricing_Date__c= date.today(),
	// CQ_Ready_for_Submission__c=date.today()
	// );
	insert listProposal[0];
	listProposal.add(listProposal[0]);

	//Create Proposal
	/*  list<Apttus_Proposal__Proposal__c> listProposal1 = new list<Apttus_Proposal__Proposal__c>();
	Apttus_Proposal__Proposal__c Quote_Obj1 = new Apttus_Proposal__Proposal__c(
	RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),
	Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Approved',
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Opportunity__c = opportunities[0].Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today()+30,
	NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
	//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
	//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
	//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
	NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
	NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
	NokiaCPQ_SSP_Level__c = 'Unlimited',
	NokiaCPQ_SRS_Level__c = 'Unlimited',
	NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
	NokiaCPQ_Portfolio__c = 'IP Routing',
	NokiaCPQ_No_of_Years__c = '2',
	CurrencyISOCode = 'USD',
	CQ_Value__c =100,
	exchange_rate__c = 1.15327,
	NokiaProductAccreditation__c = accreditations[0].Id,
	Apttus_QPConfig__PriceListId__c=pricelist1.id,
	Master_Currency_Code__c='USD',
	isCQ__c=true

	);
	insert Quote_Obj1;*/
	//  listProposal.add(Quote_Obj1);



	// create a product configuration
	List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
	prodConfigs[0].Apttus_Config2__PriceListId__c = priceList1.Id;
	prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = pricelist1.Id;
	prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
	prodConfigs[0].Apttus_QPConfig__Proposald__c = listProposal[0].Id;
	prodConfigs[0].Apttus_Config2__Status__c = 'Approved';
	insert prodConfigs;

	//get a IP Routing Product
	List<Product2> productInst = new List<Product2>();

	Product2 prod1 = new product2(
		Name = 'Test1',
		ProductCode = '123',
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Bundle',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Standard SW (STD)',
		NokiaCPQ_License_Usage__c='Commercial Term License',
		NokiaCPQ_Product_Discount_Category__c = 'XYZ'
		);
	productInst.add(prod1);
	insert productInst;



	list<Apttus_Config2__LineItem__c> LineItemList = new List<Apttus_Config2__LineItem__c>();

	Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = pricelist1.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price',
		//Portfolio_from_Quote_Line_Item__c = 'Nokia Software',
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = productInst[0].Id,
		// Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		Apttus_Config2__PricingStatus__c = 'Pending',
		Apttus_Config2__AddedBy__c = 'added by code'
		);


	//insert LineItem2;
	LineItemList.add(LineItem1);

	//create proposal line items
	List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
	proposalLineItemList[0].Apttus_Proposal__Product__c = productInst[0].id;
	proposalLineItemList[0].Apttus_Proposal__Proposal__c =listProposal[0].id;
	proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'option';
	proposalLineItemList[0].Item_Type__c = 'Service';
	insert proposalLineItemList;

	//GlobalConstants.DIRECT_QUOTE_TYPE = 'Direct CPQ';


	List<CurrencyType> currencyObj = [select IsoCode, ConversionRate from CurrencyType];

	Map<Id, Apttus_Proposal__Proposal__c> proposalNewTriggerMap2=new Map<Id, Apttus_Proposal__Proposal__c>();
	Map<Id, Apttus_Proposal__Proposal__c> proposaloldTriggerMap3=new Map<Id, Apttus_Proposal__Proposal__c>();
	proposalNewTriggerMap2.put(listProposal[0].id,listProposal[0]);
	proposaloldTriggerMap3.put(listProposal[0].id,listProposal[0]);
	ProposalTriggerHelper.updateNCQfieldsOnUpdate(proposalNewTriggerMap2,proposaloldTriggerMap3);
	ProposalTriggerHelper.associateDirectPriceList(listProposal);

	test.stopTest();
}


static testmethod void test_Proposaltrigger11nan1(){

	//List<Account> account_Obj  =  [SELECT Id,Name, Acc_No__c from Account where Acc_No__c ='Test Account' Limit 1];
	//List<Opportunity> opportunity_Obj  =  [SELECT Id from Opportunity];

	File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
	fscs.name= 'Opportunity_SalesPhase_FinalStage';
	fscs.Value__c = 'Completed';
	insert fscs;


	//Create Account
	/* Account account = NF_TestDataFactory.createAccount('Test Account');
	account.L2Name__c = 'TestL2Name';
	List<Account> account_Obj=new List<Account>();
	account_Obj.add(account);
	insert account_Obj;*/
	//  QuoteWarningMessage.getQuoteId(account_Obj[0].Id);
	//Create Opportunity
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);
	update accounts[0];
	acclist.add(accounts[0]);
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	opportunities[0].CurrencyIsoCode = 'USD';
	insert opportunities;
	//QuoteWarningMessage.getQuoteId(accounts[0].Id);

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;

	//create opportunity

	test.startTest();
	Apttus_Config2__PriceList__c pricelist=new Apttus_Config2__PriceList__c();
	pricelist.Name='Global Price List (USD)';
	pricelist.Apttus_Config2__Active__c=true;
	pricelist.PriceList_Type__c = 'FN Direct';
	pricelist.Apttus_Config2__Active__c = TRUE;
	pricelist.CurrencyIsoCode='USD';
	//pricelist.Apttus_Config2__BasedOnPriceListId__c='a5t2100000099P2AAI';
	insert pricelist;
	Apttus_Config2__PriceList__c pricelist1=new Apttus_Config2__PriceList__c();
	pricelist1.Name='Global Price List (USD)';
	pricelist1.Apttus_Config2__Active__c=true;
	pricelist1.PriceList_Type__c = 'FN Direct';
	pricelist1.Apttus_Config2__Active__c = TRUE;
	pricelist1.CurrencyIsoCode='USD';
	pricelist1.Apttus_Config2__BasedOnPriceListId__c=pricelist.id;
	insert pricelist1;

	//Create Proposal
	list<Apttus_Proposal__Proposal__c> listProposal = new list<Apttus_Proposal__Proposal__c>();
	Apttus_Proposal__Proposal__c Quote_Obj = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId(),
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Approved',
		Apttus_Proposal__Account__c = accounts[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c	  = true,
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '1',
		CurrencyISOCode = 'USD',
		//	exchange_rate__c = 2,
		CQ_Value__c =100,
		//NokiaProductAccreditation__c = accreditations[0].Id,
		Apttus_QPConfig__PriceListId__c=pricelist1.id,
		Master_Currency_Code__c='USD',
		isCQ__c=true,
		CQ_Initial_Pricing_Date__c= date.today(),
		CQ_Ready_for_Submission__c=date.today()
		);
	insert Quote_Obj;
	listProposal.add(Quote_Obj);

	//Create Proposal
	list<Apttus_Proposal__Proposal__c> listProposal1 = new list<Apttus_Proposal__Proposal__c>();
	Apttus_Proposal__Proposal__c Quote_Obj1 = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NCQ_ReadOnly_Recordtype').getRecordTypeId(),
		Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Approved',
		Apttus_Proposal__Account__c = accounts[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities[0].Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today()+30,
		NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
		//NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
		//NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
		//NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
		NokiaCPQ_Capture_Cancel_Recall_Action__c='Test',
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c=true,
		NokiaCPQ_SSP_Level__c = 'Unlimited',
		NokiaCPQ_SRS_Level__c = 'Unlimited',
		NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_No_of_Years__c = '2',
		CurrencyISOCode = 'USD',
		CQ_Value__c =100,
		exchange_rate__c = 1.15327,
		//NokiaProductAccreditation__c = accreditations[0].Id,
		Apttus_QPConfig__PriceListId__c=pricelist1.id,
		Master_Currency_Code__c='USD',
		isCQ__c=true

		);
	insert Quote_Obj1;
	//  listProposal.add(Quote_Obj1);



	// create a product configuration
	List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
	prodConfigs[0].Apttus_Config2__PriceListId__c = priceList1.Id;
	prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = pricelist1.Id;
	prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
	prodConfigs[0].Apttus_QPConfig__Proposald__c = listProposal[0].Id;
	prodConfigs[0].Apttus_Config2__Status__c = 'Approved';
	insert prodConfigs;

	//get a IP Routing Product
	List<Product2> productInst = new List<Product2>();

	Product2 prod1 = new product2(
		Name = 'Test1',
		ProductCode = '123',
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'IP Routing',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c = 'Bundle',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Standard SW (STD)',
		NokiaCPQ_License_Usage__c='Commercial Term License',
		NokiaCPQ_Product_Discount_Category__c = 'XYZ'
		);
	productInst.add(prod1);
	insert productInst;



	list<Apttus_Config2__LineItem__c> LineItemList = new List<Apttus_Config2__LineItem__c>();

	Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = pricelist1.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price',
		//Portfolio_from_Quote_Line_Item__c = 'Nokia Software',
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = productInst[0].Id,
		// Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		Apttus_Config2__PricingStatus__c = 'Pending',
		Apttus_Config2__AddedBy__c = 'added by code'
		);


	//insert LineItem2;
	LineItemList.add(LineItem1);

	//create proposal line items
	List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
	proposalLineItemList[0].Apttus_Proposal__Product__c = productInst[0].id;
	proposalLineItemList[0].Apttus_Proposal__Proposal__c =listProposal[0].id;
	proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'option';
	proposalLineItemList[0].Item_Type__c = 'Service';
	insert proposalLineItemList;

	//GlobalConstants.DIRECT_QUOTE_TYPE = 'Direct CPQ';


	List<CurrencyType> currencyObj = [select IsoCode, ConversionRate from CurrencyType];

	Map<Id, Apttus_Proposal__Proposal__c> proposalNewTriggerMap2=new Map<Id, Apttus_Proposal__Proposal__c>();
	Map<Id, Apttus_Proposal__Proposal__c> proposaloldTriggerMap3=new Map<Id, Apttus_Proposal__Proposal__c>();
	proposalNewTriggerMap2.put(Quote_Obj1.id,Quote_Obj1);
	proposaloldTriggerMap3.put(Quote_Obj.id,Quote_Obj);
	ProposalTriggerHelper.updateNCQfieldsOnUpdate(proposalNewTriggerMap2,proposaloldTriggerMap3);
	ProposalTriggerHelper.associateDirectPriceList(listProposal);

	test.stopTest();
}


}