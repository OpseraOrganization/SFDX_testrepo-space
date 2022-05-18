/****************************
   Class Name:NokiaCPQquoteActionsController_test
   Created by: Accenture
   Created Date: 20 september 2018
   Last modified by: Accenture
   Updated by Nokia COE
   Description: Test class for NokiaCPQquoteActionsController
 *******************************/
@istest
public class NokiaCPQquoteActionsController_test{
/***********************
 * Method Name: getProposal_testMethod
 * Description: To cover the method updateMaintenanceTypeValue from class quote_Maintenance_Picklist_handler
 * Parameters: NA
 ************************/
static testmethod void getProposal_testMethod(){
 List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){
	test.startTest();
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

	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	insert proposals;


	NokiaCPQquoteActionsController.getProposal(proposals[0].id);
	NokiaCPQquoteActionsController.getProposal(NULL);
	test.stopTest();
}

}
static testmethod void configureMethod_testMethod(){
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

	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Is_Maintenance_Quote__c = true;
	proposals[0].NokiaCPQ_Contract_Start_Date__c = date.today();
	proposals[0].Warranty_credit__c = 'No';
	insert proposals;

	test.startTest();
	NokiaCPQquoteActionsController.configureMethod(proposals[0].id);
	NokiaCPQquoteActionsController.configureMethod(null);
	NokiaCPQquoteActionsController.configureMethod('');
	test.stopTest();

}
}
static testmethod void configureTurboserver_testMethod(){
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

	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Is_Maintenance_Quote__c = true;
	proposals[0].NokiaCPQ_Contract_Start_Date__c = date.today();
	proposals[0].Warranty_credit__c = 'No';
	proposals[0].Is_Classic_Pricing__c  = false;
	proposals[0].Is_Turbo_Pricing__c = true;
	proposals[0].Apttus_QPConfig__IsTaskPending__c = false;
	insert proposals;

	test.startTest();
	NokiaCPQquoteActionsController.configureTurboserver(proposals[0].id);
	NokiaCPQquoteActionsController.configureTurboserver(null);
	NokiaCPQquoteActionsController.configureTurboserver('');

	NokiaCPQquoteActionsController.UpdateConfigurebutton(proposals[0].id,'Turbo',proposals[0]);
	NokiaCPQquoteActionsController.QueryConfiguration(proposals[0].id);
	NokiaCPQquoteActionsController.QueryQuoteRecord(proposals[0].id);
	test.stopTest();

}}

static testmethod void configureMethodDirect_testMethod(){
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

	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	insert proposals;

	test.startTest();
	NokiaCPQquoteActionsController.configureMethodDirect(proposals[0].id);
	NokiaCPQquoteActionsController.configureMethodDirect(null);
	NokiaCPQquoteActionsController.configureCollaboration(null);
	NokiaCPQquoteActionsController.makePrimaryMethod(null);
	NokiaCPQquoteActionsController.bomExportMethod(null);
	NokiaCPQquoteActionsController.quoteExportMethod(null);
	NokiaCPQquoteActionsController.acceptMethod(null);
	//  NokiaCPQquoteActionsController.cspExportMethod(null);
	NokiaCPQquoteActionsController.cspExportMethod('','');
	NokiaCPQquoteActionsController.viewProductsMethod(null);
	NokiaCPQquoteActionsController.viewProductsDirectMethod(null);
	test.stopTest();
}}
/***************************
* Description : The method returns Collaboration URL.
* Parameter passed : recordIdVar
* return : String
***************************/
static testmethod void configureCollaboration_testMethod(){
 List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){

	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
	insert accounts;

	//create a Account
	List<Account> accounts1 = NOKIA_CPQ_TestDataFactory.getAccounts(1);
	accounts1[0].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts1[0].Acc_No__c = 'Testing99';
	accounts1[0].Partner_Type__c = '';
	accounts1[0].Partner_Program__c = '';
	insert accounts1;

	List<Account> acclist = new List<Account>();
	acclist.add(accounts[0]);

	//create opportunity
	/* GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		 List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		 opportunities[0].End_Customer_LE__c = accounts[1].id;
		 opportunities[0].Account_Role__c = 'GPP Distributor Partner';
		 insert opportunities;  */
	//Create Opportunity
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts1[0].Id;
	insert opportunities;

	//create Accreditation
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = accounts[0].Id;
	accreditations[1].partner__c = accounts[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;

	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].Quote_Status__c='Order';
	insert proposals;

	//Create PriceList

	Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List',
		Apttus_Config2__Active__c = True
		);
	insert ApttusTestPriceList;

	Apttus_Config2__ProductConfiguration__c ProdConfigs = new Apttus_Config2__ProductConfiguration__c(
		Name = 'APTTUS Test Config',
		Apttus_Config2__AccountId__c = accounts[0].Id,
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__Proposald__c = proposals[0].Id,
		Apttus_Config2__Status__c = 'New',
		Apttus_Config2__VersionNumber__c = 1,
		Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id),
		Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
	test.startTest();

	//create a quote Line Item
	List<Apttus_Proposal__Proposal_Line_Item__c > proposalLineItemList = NOKIA_CPQ_TestDataFactory.createProposalLineItem(5);
	proposalLineItemList[0].Apttus_Proposal__Proposal__c = proposals[0].id;
	proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'Option';
	proposalLineItemList[0].Apttus_QPConfig__IsPrimaryLine__c = true;
	//insert proposalsLineItem;


	proposalLineItemList[1].Apttus_Proposal__Proposal__c = proposals[0].id;
	proposalLineItemList[1].Apttus_QPConfig__LineType__c = 'Option';
	proposalLineItemList[1].Item_Type_From_CAT__c = 'Offer';
	proposalLineItemList[1].Sequence_Site_Id__c= '';
	proposalLineItemList[1].Apttus_QPConfig__IsPrimaryLine__c = true;
	proposalLineItemList[0].NokiaCPQ_Spare__c = false;
	//   proposalLineItemList[0].Apttus_Proposal__Product__c = pList[0].Id;
	//   proposalLineItemList[0].Apttus_QPConfig__OptionId__c = pList[0].Id;
	proposalLineItemList[2].Apttus_Proposal__Proposal__c = proposals[0].Id;
	proposalLineItemList[2].Apttus_QPConfig__ParentBundleNumber__c = Null;
	proposalLineItemList[2].NokiaCPQ_Configuration_Type__c = 'Standalone';
	proposalLineItemList[2].Apttus_QPConfig__LineType__c = 'Product Service';
	proposalLineItemList[2].Custom_Product_Code__c = 'AirScaleWiFi';
	proposalLineItemList[2].is_Custom_Product__c = false;
	proposalLineItemList[2].Apttus_QPConfig__ChargeType__c = 'Standard price';
	proposalLineItemList[2].Apttus_QPConfig__LineNumber__c = 1;
	proposalLineItemList[2].Apttus_QPConfig__PrimaryLineNumber__c = 1;
	proposalLineItemList[2].Apttus_Proposal__Description__c = 'Installation Services';
	proposalLineItemList[2].Apttus_QPConfig__ConfigurationId__c = prodConfigs.id;
	proposalLineItemList[3].NokiaCPQ_Spare__c = false;
	//  proposalLineItemList[1].Apttus_Proposal__Product__c = pList[1].Id;
	//  proposalLineItemList[1].Apttus_QPConfig__OptionId__c = pList[1].Id;

	proposalLineItemList[3].Apttus_Proposal__Proposal__c = proposals[0].Id;
	proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 1;
	proposalLineItemList[3].NokiaCPQ_Configuration_Type__c = 'Standalone';
	proposalLineItemList[3].Custom_Product_Code__c = 'AirScaleWiFi';
	proposalLineItemList[3].is_Custom_Product__c = false;
	proposalLineItemList[3].Apttus_QPConfig__LineType__c = 'Product Service';
	proposalLineItemList[3].Apttus_QPConfig__ChargeType__c = 'Standard price';
	proposalLineItemList[3].Apttus_QPConfig__LineNumber__c = 1;
	proposalLineItemList[3].Apttus_QPConfig__PrimaryLineNumber__c = 2;
	proposalLineItemList[3].Apttus_Proposal__Description__c = 'Installation Services';

	proposalLineItemList[4].NokiaCPQ_Spare__c = false;
	//  proposalLineItemList[2].Apttus_Proposal__Product__c = pList[2].Id;
	//  proposalLineItemList[2].Apttus_QPConfig__OptionId__c = pList[2].Id;
	proposalLineItemList[4].Apttus_Proposal__Proposal__c = proposals[0].Id;
	proposalLineItemList[4].Apttus_QPConfig__ParentBundleNumber__c = 1;
	proposalLineItemList[4].NokiaCPQ_Configuration_Type__c = 'Standalone';
	proposalLineItemList[4].Custom_Product_Code__c = 'AirScaleWiFi';
	proposalLineItemList[4].is_Custom_Product__c = false;
	proposalLineItemList[4].Apttus_QPConfig__LineType__c = 'Option';
	proposalLineItemList[4].Apttus_QPConfig__ChargeType__c = 'Standard price';
	proposalLineItemList[4].Apttus_QPConfig__LineNumber__c = 1;
	proposalLineItemList[4].Apttus_QPConfig__PrimaryLineNumber__c = 2;
	proposalLineItemList[4].Apttus_Proposal__Description__c = 'Installation Services';

	insert proposalLineItemList;



	//create a quote
	/*  List<Apttus_Proposal__Proposal__c > proposals1 = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals1[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals1[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals1[0].Quote_Status__c='Closed';
	insert proposals1;*/


	NokiaCPQquoteActionsController.configureCollaboration(proposals[0].id);
	NokiaCPQquoteActionsController.makePrimaryMethod(proposals[0].id);
	NokiaCPQquoteActionsController.bomExportMethod(proposals[0].id);
	NokiaCPQquoteActionsController.quoteExportMethod(proposals[0].id);
	NokiaCPQquoteActionsController.acceptMethod(proposals[0].id);
	NokiaCPQquoteActionsController.cspExportMethod('','');
	NokiaCPQquoteActionsController.viewProductsMethod(proposals[0].id);
	NokiaCPQquoteActionsController.viewProductsDirectMethod(proposals[0].id);
	NokiaCPQquoteActionsController.returnProfileName();
	NokiaCPQquoteActionsController.boqExportreturn(proposals[0].id);
	NokiaCPQquoteActionsController.boqClpExportReturn(proposals[0].id);
	NokiaCPQquoteActionsController.prmExportFunction(proposals[0].id);
	NokiaCPQquoteActionsController.returnAccessLoaFile();
	NokiaCPQquoteActionsController.loaFileExportFunction(proposals[0].id);
	NokiaCPQquoteActionsController.initiateOrderExportForAlliance(proposals[0].id,'Alliance');
	NokiaCPQquoteActionsController.initiateOrderExportForQTC(proposals[0].id,proposals[0].NokiaCPQ_Proposal_Id__c);
	NokiaCPQquoteActionsController.initiateOrderExportForQTCSite(proposals[0].id,'123');
	NokiaCPQquoteActionsController.isPricingManager();
	NokiaCPQquoteActionsController.CQOrderDocExportMethod('', '');
	NokiaCPQquoteActionsController.sendAddQuoteMessageToEAI(proposals[0].id, proposals[0].NokiaCPQ_Proposal_Id__c);
	NokiaCPQquoteActionsController.submitForApprovalMethod(proposals[0].id);
	NokiaCPQquoteActionsController.basicquoteExportMethod(proposals[0].id);
	NokiaCPQquoteActionsController.configureMethodDirect(proposals[0].id);
	NokiaCPQquoteActionsController.configureMethod(proposals[0].id);
	//NokiaCPQquoteActionsController.generateSiteIdOnQDSI(proposals[0].id);
	NokiaCPQquoteActionsController.generateSiteId(proposals[0].id);
	//NokiaCPQquoteActionsController.updatePLIandQDSI(null);
	NokiaCPQquoteActionsController.updatePLIandQDSI(proposals[0].id);
	test.stopTest();
}}

static testmethod void getPLIbundleOptionMapping_testMethod6(){
 List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){
	//Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSIFinalMap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
	//Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> PLIandAttributeMap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
	Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c> > finalPLImap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c> >();
	Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> finalAttributePLImap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
	Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c> > mappingPLIMap = new Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c> >();
	Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c> > > cspOderAndPliMap = new Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c> > >();
	//create Mapping
	NokiaCPQ_CSP_Map_Control__c mapControl = new NokiaCPQ_CSP_Map_Control__c();

	mapControl.Portfolio__c = 'Airscale Wifi';
	mapControl.Product_Code__c = 'AirScaleWiFi';
	mapControl.Source__c = 'Table';
	mapControl.Map_Mode__c = 'Split';
	insert mapControl;

	//create a Account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
	insert accounts;

	//create opportunity
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	insert opportunities;

	//create a quote
	Apttus_Proposal__Proposal__c proposals = new Apttus_Proposal__Proposal__c();
	proposals.Apttus_Proposal__Account__c = accounts[0].Id;
	proposals.Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals.NokiaCPQ_Needs_Reprice__c = false;
	proposals.Reprice_In_Progress__c = false;
	proposals.RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();
	proposals.NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)';
	proposals.NokiaCPQ_No_of_Years__c = '1';
	proposals.NokiaCPQ_Portfolio__c = 'IP Routing';
	proposals.NokiaCPQ_SSP_Level__c = '';
	proposals.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = true;
	proposals.NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
	insert proposals;
	system.debug('>>>Quote Record Type::>>'+proposals.recordtypeID);

	//get a Product Apttus_Config2__ConfigurationType__c
	List <Product2> pList = NOKIA_CPQ_TestDataFactory.productCreationDirect(6);
	pList[0].NokiaCPQ_Category__c = '1000Base-SX';
	pList[0].NokiaCPQ_Product_Discount_Category__c = '';
	//pList[0].Pricing_Clusters_Search_Filter__c =',';
	pList[0].Pricing_Clusters__c = '';
	pList[0].NokiaCPQ_State__c = 'Ramp Up';
	pList[0].NokiaCPQ_Item_Type__c = 'Service';
	pList[0].Business_Group__c='MN';
	pList[0].Portfolio__c = 'Airscale Wifi';
	pList[0].ProductCode = 'AirScaleWiFi';
	pList[0].Apttus_Config2__ConfigurationType__c = 'Bundle';

	//get a Product
	pList[1].NokiaCPQ_Category__c = '1000Base-SX';
	pList[1].NokiaCPQ_Product_Discount_Category__c = '';
	//pList[0].Pricing_Clusters_Search_Filter__c =',';
	pList[1].Pricing_Clusters__c = '';
	pList[1].NokiaCPQ_State__c = 'Ramp Up';
	pList[1].NokiaCPQ_Item_Type__c = 'Service';
	pList[1].Business_Group__c='MN';
	pList[1].Portfolio__c = 'Airscale Wifi';
	pList[1].ProductCode = 'AirScaleWiFi';
	pList[1].Apttus_Config2__ConfigurationType__c = 'Standalone';

	//get a Product
	pList[2].NokiaCPQ_Category__c = '1000Base-SX';
	pList[2].NokiaCPQ_Product_Discount_Category__c = '';
	//pList[0].Pricing_Clusters_Search_Filter__c =',';
	pList[2].Pricing_Clusters__c = '';
	pList[2].NokiaCPQ_State__c = 'Ramp Up';
	pList[2].NokiaCPQ_Item_Type__c = 'Service';
	pList[2].ProductCode = 'FC21001';
	pList[2].Business_Group__c='MN';
	pList[2].Portfolio__c = 'Airscale Wifi';
	pList[2].ProductCode = 'AirScaleWiFi';
	pList[2].Apttus_Config2__ConfigurationType__c = 'Bundle';

	pList[3].NokiaCPQ_Category__c = '1000Base-SX';
	pList[3].NokiaCPQ_Product_Discount_Category__c = '';
	//pList[0].Pricing_Clusters_Search_Filter__c =',';
	pList[3].Pricing_Clusters__c = '';
	pList[3].NokiaCPQ_State__c = 'Ramp Up';
	pList[3].NokiaCPQ_Item_Type__c = 'Service';
	pList[3].ProductCode = 'FC21001';
	pList[3].Business_Group__c='MN';
	pList[3].Portfolio__c = 'Airscale Wifi';
	pList[3].ProductCode = 'AirScaleWiFi';
	pList[3].Apttus_Config2__ConfigurationType__c = 'Bundle';

	pList[4].NokiaCPQ_Category__c = '1000Base-SX';
	pList[4].NokiaCPQ_Product_Discount_Category__c = '';
	//pList[0].Pricing_Clusters_Search_Filter__c =',';
	pList[4].Pricing_Clusters__c = '';
	pList[4].NokiaCPQ_State__c = 'Ramp Up';
	pList[4].NokiaCPQ_Item_Type__c = 'Service';
	pList[4].ProductCode = 'FC21001';
	pList[4].Business_Group__c='MN';
	pList[4].Portfolio__c = 'Airscale Wifi';
	pList[4].ProductCode = 'AirScaleWiFi';
	pList[4].Apttus_Config2__ConfigurationType__c = 'Bundle';
	pList[4].Is_Dummy_Bundle_CPQ__c = 'Yes';

	pList[5].NokiaCPQ_Category__c = '1000Base-SX';
	pList[5].NokiaCPQ_Product_Discount_Category__c = '';
	//pList[0].Pricing_Clusters_Search_Filter__c =',';
	pList[5].Pricing_Clusters__c = '';
	pList[5].NokiaCPQ_State__c = 'Ramp Up';
	pList[5].NokiaCPQ_Item_Type__c = 'Service';
	pList[5].ProductCode = 'FC21001';
	pList[5].Business_Group__c='MN';
	pList[5].Portfolio__c = 'Airscale Wifi';
	pList[5].ProductCode = 'AirScaleWiFi';
	pList[5].Apttus_Config2__ConfigurationType__c = 'Option';

	insert pList;

	//get a Price List
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (EUR)';
	priceList.CurrencyIsoCode='EUR';
	priceList.Apttus_Config2__Active__c=true;
	priceList.PriceList_Type__c='CPQ';
	priceList.Apttus_Config2__Type__c='Standard';
	insert priceList;

	List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceList.Id,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__ProductId__c = pList[0].Id,
		Apttus_Config2__ChargeType__c = 'Standard Price'
		);
	plistItems.add(pLI1);
	Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceList.Id,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__ProductId__c = pList[1].Id,
		Apttus_Config2__ChargeType__c = 'Standard Price'
		);
	plistItems.add(pLI2);
	Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceList.Id,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__ProductId__c = pList[2].Id,
		Apttus_Config2__ChargeType__c = 'Standard Price'
		);
	plistItems.add(pLI3);
	Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceList.Id,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__ProductId__c = pList[3].Id,
		Apttus_Config2__ChargeType__c = 'Standard Price'
		);
	plistItems.add(pLI4);
	Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceList.Id,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__ProductId__c = pList[4].Id,
		Apttus_Config2__ChargeType__c = 'Standard Price'
		);
	plistItems.add(pLI5);
	Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceList.Id,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__ProductId__c = pList[5].Id,
		Apttus_Config2__ChargeType__c = 'Standard Price'
		);
	plistItems.add(pLI6);
	insert plistItems;

	List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
	prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
	prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
	prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
	prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals.Id;
	prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
	insert prodConfigs;

	List<Apttus_Config2__LineItem__c> prodConfigsLineItems = NOKIA_CPQ_TestDataFactory.createLineItem(6);
	prodConfigsLineItems[0].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
	prodConfigsLineItems[0].Apttus_Config2__LineSequence__c = 1;
	prodConfigsLineItems[0].Apttus_Config2__LineStatus__c='New';
	prodConfigsLineItems[0].Apttus_Config2__PriceListId__c = priceList.id;
	prodConfigsLineItems[0].Apttus_Config2__ChargeType__c = 'Standard Price';
	prodConfigsLineItems[0].Apttus_Config2__LineType__c = 'Product/Service';
	prodConfigsLineItems[0].Apttus_Config2__ProductId__c = pList[0].Id;
	prodConfigsLineItems[0].Apttus_Config2__PriceListItemId__c = pLI1.id;
	prodConfigsLineItems[0].Apttus_Config2__PriceMethod__c = 'Per Unit';
	prodConfigsLineItems[0].Apttus_Config2__Frequency__c = 'One Time';
	prodConfigsLineItems[0].Apttus_Config2__AdjustmentAmount__c = 100.00;
	prodConfigsLineItems[0].Apttus_Config2__ListPrice__c = 200;
	prodConfigsLineItems[0].Apttus_Config2__PrimaryLineNumber__c = 1;
	//prodConfigsLineItems[0].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
	prodConfigsLineItems[0].Apttus_Config2__AddedBy__c = 'added by code';

	prodConfigsLineItems[1].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
	prodConfigsLineItems[1].Apttus_Config2__LineSequence__c = 1;
	prodConfigsLineItems[1].Apttus_Config2__LineStatus__c='New';
	prodConfigsLineItems[1].Apttus_Config2__PriceListId__c = priceList.id;
	prodConfigsLineItems[1].Apttus_Config2__ChargeType__c = 'Standard Price';
	prodConfigsLineItems[1].Apttus_Config2__LineType__c = 'Product/Service';
	prodConfigsLineItems[1].Apttus_Config2__ProductId__c = pList[1].Id;
	prodConfigsLineItems[1].Apttus_Config2__PriceListItemId__c = pLI2.id;
	prodConfigsLineItems[1].Apttus_Config2__PriceMethod__c = 'Per Unit';
	prodConfigsLineItems[1].Apttus_Config2__Frequency__c = 'One Time';
	prodConfigsLineItems[1].Apttus_Config2__AdjustmentAmount__c = 100.00;
	prodConfigsLineItems[1].Apttus_Config2__ListPrice__c = 200;
	prodConfigsLineItems[1].Apttus_Config2__PrimaryLineNumber__c = 1;
	//prodConfigsLineItems[1].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
	prodConfigsLineItems[1].Apttus_Config2__AddedBy__c = 'added by code';

	prodConfigsLineItems[2].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
	prodConfigsLineItems[2].Apttus_Config2__LineSequence__c = 1;
	prodConfigsLineItems[2].Apttus_Config2__LineStatus__c='New';
	prodConfigsLineItems[2].Apttus_Config2__PriceListId__c = priceList.id;
	prodConfigsLineItems[2].Apttus_Config2__ChargeType__c = 'Standard Price';
	prodConfigsLineItems[2].Apttus_Config2__LineType__c = 'Product/Service';
	prodConfigsLineItems[2].Apttus_Config2__ProductId__c = pList[2].Id;
	prodConfigsLineItems[2].Apttus_Config2__PriceListItemId__c = pLI3.id;
	prodConfigsLineItems[2].Apttus_Config2__PriceMethod__c = 'Per Unit';
	prodConfigsLineItems[2].Apttus_Config2__Frequency__c = 'One Time';
	prodConfigsLineItems[2].Apttus_Config2__AdjustmentAmount__c = 100.00;
	prodConfigsLineItems[2].Apttus_Config2__ListPrice__c = 200;
	prodConfigsLineItems[2].Apttus_Config2__PrimaryLineNumber__c = 1;
	//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
	prodConfigsLineItems[2].Apttus_Config2__AddedBy__c = 'added by code';

	prodConfigsLineItems[3].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
	prodConfigsLineItems[3].Apttus_Config2__LineSequence__c = 1;
	prodConfigsLineItems[3].Apttus_Config2__LineStatus__c='New';
	prodConfigsLineItems[3].Apttus_Config2__PriceListId__c = priceList.id;
	prodConfigsLineItems[3].Apttus_Config2__ChargeType__c = 'Standard Price';
	prodConfigsLineItems[3].Apttus_Config2__LineType__c = 'Product/Service';
	prodConfigsLineItems[3].Apttus_Config2__ProductId__c = pList[3].Id;
	prodConfigsLineItems[3].Apttus_Config2__PriceListItemId__c = pLI4.id;
	prodConfigsLineItems[3].Apttus_Config2__PriceMethod__c = 'Per Unit';
	prodConfigsLineItems[3].Apttus_Config2__Frequency__c = 'One Time';
	prodConfigsLineItems[3].Apttus_Config2__AdjustmentAmount__c = 100.00;
	prodConfigsLineItems[3].Apttus_Config2__ListPrice__c = 200;
	prodConfigsLineItems[3].Apttus_Config2__PrimaryLineNumber__c = 1;
	//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
	prodConfigsLineItems[3].Apttus_Config2__AddedBy__c = 'added by code';

	prodConfigsLineItems[4].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
	prodConfigsLineItems[4].Apttus_Config2__LineSequence__c = 1;
	prodConfigsLineItems[4].Apttus_Config2__LineStatus__c='New';
	prodConfigsLineItems[4].Apttus_Config2__PriceListId__c = priceList.id;
	prodConfigsLineItems[4].Apttus_Config2__ChargeType__c = 'Standard Price';
	prodConfigsLineItems[4].Apttus_Config2__LineType__c = 'Product/Service';
	prodConfigsLineItems[4].Apttus_Config2__ProductId__c = pList[4].Id;
	prodConfigsLineItems[4].Apttus_Config2__PriceListItemId__c = pLI5.id;
	prodConfigsLineItems[4].Apttus_Config2__PriceMethod__c = 'Per Unit';
	prodConfigsLineItems[4].Apttus_Config2__Frequency__c = 'One Time';
	prodConfigsLineItems[4].Apttus_Config2__AdjustmentAmount__c = 100.00;
	prodConfigsLineItems[4].Apttus_Config2__ListPrice__c = 200;
	prodConfigsLineItems[4].Apttus_Config2__PrimaryLineNumber__c = 1;
	//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
	prodConfigsLineItems[4].Apttus_Config2__AddedBy__c = 'added by code';

	prodConfigsLineItems[5].Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id;
	prodConfigsLineItems[5].Apttus_Config2__LineSequence__c = 1;
	prodConfigsLineItems[5].Apttus_Config2__LineStatus__c='New';
	prodConfigsLineItems[5].Apttus_Config2__PriceListId__c = priceList.id;
	prodConfigsLineItems[5].Apttus_Config2__ChargeType__c = 'Standard Price';
	prodConfigsLineItems[5].Apttus_Config2__LineType__c = 'Product/Service';
	prodConfigsLineItems[5].Apttus_Config2__ProductId__c = pList[5].Id;
	prodConfigsLineItems[5].Apttus_Config2__PriceListItemId__c = pLI6.id;
	prodConfigsLineItems[5].Apttus_Config2__PriceMethod__c = 'Per Unit';
	prodConfigsLineItems[5].Apttus_Config2__Frequency__c = 'One Time';
	prodConfigsLineItems[5].Apttus_Config2__AdjustmentAmount__c = 100.00;
	prodConfigsLineItems[5].Apttus_Config2__ListPrice__c = 200;
	prodConfigsLineItems[5].Apttus_Config2__PrimaryLineNumber__c = 1;
	//prodConfigsLineItems[2].Apttus_Config2__ShipToAccountId__c = accounts[0].Id;
	prodConfigsLineItems[5].Apttus_Config2__AddedBy__c = 'added by code';
	insert prodConfigsLineItems;

	List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(6);
	proposalLineItemList[0].NokiaCPQ_Spare__c = false;
	proposalLineItemList[0].Apttus_Proposal__Product__c  = pList[0].Id;
	proposalLineItemList[0].Apttus_QPConfig__OptionId__c = pList[0].Id;
	proposalLineItemList[0].Apttus_Proposal__Proposal__c = proposals.Id;
	proposalLineItemList[0].Apttus_QPConfig__ParentBundleNumber__c = Null;
	proposalLineItemList[0].NokiaCPQ_Configuration_Type__c = 'Bundle';
	proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'Product Service';
	proposalLineItemList[0].Custom_Product_Code__c = 'AirScaleWiFi';
	proposalLineItemList[0].is_Custom_Product__c = false;
	proposalLineItemList[0].Apttus_QPConfig__ChargeType__c = 'Standard price';
	proposalLineItemList[0].Apttus_QPConfig__LineNumber__c = 1;
	proposalLineItemList[0].Apttus_QPConfig__PrimaryLineNumber__c = 1;
	proposalLineItemList[0].Apttus_Proposal__Description__c = 'Installation Services';
	proposalLineItemList[0].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[0].id;
	proposalLineItemList[0].Apttus_QPConfig__IsPrimaryLine__c = true;


	proposalLineItemList[1].NokiaCPQ_Spare__c = false;
	proposalLineItemList[1].Apttus_Proposal__Product__c  = pList[1].Id;
	proposalLineItemList[1].Apttus_QPConfig__OptionId__c = pList[1].Id;
	proposalLineItemList[1].Apttus_Proposal__Proposal__c = proposals.Id;
	proposalLineItemList[1].Apttus_QPConfig__ParentBundleNumber__c = 1;
	proposalLineItemList[1].NokiaCPQ_Configuration_Type__c = 'Standalone';
	proposalLineItemList[1].Custom_Product_Code__c = 'AirScaleWiFi';
	proposalLineItemList[1].is_Custom_Product__c = false;
	proposalLineItemList[1].Apttus_QPConfig__LineType__c = 'Product Service';
	proposalLineItemList[1].Apttus_QPConfig__ChargeType__c = 'Standard price';
	proposalLineItemList[1].Apttus_QPConfig__LineNumber__c = 1;
	proposalLineItemList[1].Apttus_QPConfig__PrimaryLineNumber__c = 2;
	proposalLineItemList[1].Apttus_Proposal__Description__c = 'Installation Services';
	proposalLineItemList[1].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[1].id;
	proposalLineItemList[1].Apttus_QPConfig__IsPrimaryLine__c = true;

	proposalLineItemList[2].NokiaCPQ_Spare__c = false;
	proposalLineItemList[2].Apttus_Proposal__Product__c  = pList[2].Id;
	proposalLineItemList[2].Apttus_QPConfig__OptionId__c = pList[2].Id;
	proposalLineItemList[2].Apttus_Proposal__Proposal__c = proposals.Id;
	proposalLineItemList[2].Apttus_QPConfig__ParentBundleNumber__c = 1;
	proposalLineItemList[2].NokiaCPQ_Configuration_Type__c = 'Bundle';
	proposalLineItemList[2].Custom_Product_Code__c = 'AirScaleWiFi';
	proposalLineItemList[2].is_Custom_Product__c = false;
	proposalLineItemList[2].Apttus_QPConfig__LineType__c = 'Option';
	proposalLineItemList[2].Apttus_QPConfig__ChargeType__c = 'Standard price';
	proposalLineItemList[2].Apttus_QPConfig__LineNumber__c = 1;
	proposalLineItemList[2].Apttus_QPConfig__PrimaryLineNumber__c = 3;
	proposalLineItemList[2].Apttus_Proposal__Description__c = 'Installation Services';
	proposalLineItemList[2].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[2].id;
	proposalLineItemList[2].Apttus_QPConfig__IsPrimaryLine__c = true;
	proposalLineItemList[2].NokiaCPQ_IsArcadiaBundle__c = true;

	proposalLineItemList[3].NokiaCPQ_Spare__c = false;
	proposalLineItemList[3].Apttus_Proposal__Product__c  = pList[3].Id;
	proposalLineItemList[3].Apttus_QPConfig__OptionId__c = pList[3].Id;
	proposalLineItemList[3].Apttus_Proposal__Proposal__c = proposals.Id;
	proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 3;
	proposalLineItemList[3].NokiaCPQ_Configuration_Type__c = 'Standalone';
	proposalLineItemList[3].Custom_Product_Code__c = 'AirScaleWiFi';
	proposalLineItemList[3].is_Custom_Product__c = false;
	proposalLineItemList[3].Apttus_QPConfig__LineType__c = 'Option';
	proposalLineItemList[3].Apttus_QPConfig__ChargeType__c = 'Standard price';
	proposalLineItemList[3].Apttus_QPConfig__LineNumber__c = 1;
	proposalLineItemList[3].Apttus_QPConfig__PrimaryLineNumber__c = 4;
	proposalLineItemList[3].Apttus_Proposal__Description__c = 'Installation Services';
	proposalLineItemList[3].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[3].id;
	proposalLineItemList[3].Apttus_QPConfig__IsPrimaryLine__c = true;

	proposalLineItemList[4].NokiaCPQ_Spare__c = false;
	proposalLineItemList[4].Apttus_Proposal__Product__c  = pList[4].Id;
	proposalLineItemList[4].Apttus_QPConfig__OptionId__c = pList[4].Id;
	proposalLineItemList[4].Apttus_Proposal__Proposal__c = proposals.Id;
	proposalLineItemList[4].Apttus_QPConfig__ParentBundleNumber__c = 3;
	proposalLineItemList[4].NokiaCPQ_Configuration_Type__c = 'Standalone';
	proposalLineItemList[4].Custom_Product_Code__c = 'AirScaleWiFi';
	proposalLineItemList[4].is_Custom_Product__c = false;
	proposalLineItemList[4].Apttus_QPConfig__LineType__c = 'Option';
	proposalLineItemList[4].Apttus_QPConfig__ChargeType__c = 'Standard price';
	proposalLineItemList[4].Apttus_QPConfig__LineNumber__c = 1;
	proposalLineItemList[4].Apttus_QPConfig__PrimaryLineNumber__c = 5;
	proposalLineItemList[4].Apttus_Proposal__Description__c = 'Installation Services';
	proposalLineItemList[4].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[3].id;
	proposalLineItemList[4].Apttus_QPConfig__IsPrimaryLine__c = true;

	proposalLineItemList[5].NokiaCPQ_Spare__c = false;
	proposalLineItemList[5].Apttus_Proposal__Product__c  = pList[5].Id;
	proposalLineItemList[5].Apttus_QPConfig__OptionId__c = pList[5].Id;
	proposalLineItemList[5].Apttus_Proposal__Proposal__c = proposals.Id;
	proposalLineItemList[5].Apttus_QPConfig__ParentBundleNumber__c = 5;
	proposalLineItemList[5].NokiaCPQ_Configuration_Type__c = 'Standalone';
	proposalLineItemList[5].Custom_Product_Code__c = 'AirScaleWiFi';
	proposalLineItemList[5].is_Custom_Product__c = false;
	proposalLineItemList[5].Apttus_QPConfig__LineType__c = 'Option';
	proposalLineItemList[5].Apttus_QPConfig__ChargeType__c = 'Standard price';
	proposalLineItemList[5].Apttus_QPConfig__LineNumber__c = 1;
	proposalLineItemList[5].Apttus_QPConfig__PrimaryLineNumber__c = 6;
	proposalLineItemList[5].Apttus_Proposal__Description__c = 'Installation Services';
	proposalLineItemList[5].Apttus_QPConfig__DerivedFromId__c = prodConfigsLineItems[3].id;
	proposalLineItemList[5].Apttus_QPConfig__IsPrimaryLine__c = true;


	insert proposalLineItemList;
	System.debug('proposalLineItemList[0] : '+proposalLineItemList[0]);
	System.debug('proposalLineItemList[1] : '+proposalLineItemList[1]);
	System.debug('proposalLineItemList[2] : '+proposalLineItemList[2]);

	Quote_Delivery_Sales_Item__c salesitem= new Quote_Delivery_Sales_Item__c();
	salesitem.Arcadia_Product_Code__c='ARC00010AA';
	salesitem.Product_Code__c='3HZ16085AAAA';
	salesitem.Quantity__c=200;
	salesitem.Item_Type__c='Order';
	salesitem.PCI_Code__c='SPS-ALU-PR-SW-PCI';
	salesitem.Proposal__c= proposals.Id;
	salesitem.Parent_Line_Item__c=prodConfigsLineItems[2].Id;
	salesitem.Name='2-ARC00010AA-1';
	insert salesitem;

	List<Apttus_QPConfig__ProposalProductAttributeValue__c> pavList = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
	Apttus_QPConfig__ProposalProductAttributeValue__c pav1 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
	pav1.How_is_the_software_to_be_delivered__c = 'Physically';
	pav1.Apttus_QPConfig__LineItemId__c = proposalLineItemList[0].Id;
	pavList.add(pav1);

	Apttus_QPConfig__ProposalProductAttributeValue__c pav2 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
	pav2.How_is_the_software_to_be_delivered__c = 'Physically';
	pav2.Apttus_QPConfig__LineItemId__c = proposalLineItemList[1].Id;
	pavList.add(pav2);

	Apttus_QPConfig__ProposalProductAttributeValue__c pav3 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
	pav3.How_is_the_software_to_be_delivered__c = 'Physically';
	pav3.Apttus_QPConfig__LineItemId__c = proposalLineItemList[2].Id;
	pavList.add(pav3);

	insert pavList;

	NokiaCPQ_CSP_ordering_export_mapping__c cspMap = new NokiaCPQ_CSP_ordering_export_mapping__c();
	cspMap.Parent_Product__c = 'AirScale WiFi';
	cspMap.PCI_Type__c = 'Equipment PCI';
	cspMap.PCI_Code__c = 'FC20002';
	cspMap.PCI_Description__c = 'WI-FI Controller SW Physical Delivery';
	cspMap.PName1__c = 'How_is_the_software_to_be_delivered__c';
	cspMap.Pvalue1__c = 'Physically';
	cspMap.Rule__c = 'FC21001,FC21002,FC21006,FC21007,FC21019,FC21020,FC21008,FC21009,FC21011,FC21012.T,FC21010,FC21013.T,FC21014,FC21015,FC21013,FC21016,FC21017,FC21015.T,FC21022,FC21021,FC21018,FC21017.T,FC21025,FC21024,FC21023,FC21028,FC21029,FC21027,FC21026,FC21030,FC22003.T,FC22005.T,FC22013.T,FC22015.T,FC22004.T,FC22017.T,FC23005.T,FC23004.T,FC23003.T,FC23013.T,FC23015.T,FC23012.T,FC23017.T,FC22021.T,FC22023.T,FC22027.T,FC22029.T,FC22025.T,FC23021.T,FC23025.T,FC23023.T,FC23029.T,FC23027.T,FC21031,FC21033,FC21032,FC21034,FC21035,FC21036,FC21037,FC21038,FC21039,FC21040,FC21041,FC21042,FC21043,FC21044,FC21003,FC21005,OEMVMSW001,OEMVMSW002,OEMVMSW003';
	cspMap.Rule_Type__c = 'Attribute';
	insert cspMap;

	mappingPLIMap.put(cspMap, proposalLineItemList);

	for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItemObj : proposalLineItemList) {
		cspOderAndPliMap.put(proposalLineItemObj, mappingPLIMap);
	}
	//finalAttributePLImap.put(pav.Apttus_QPConfig__LineItemId__c,pav);
	Test.startTest();
	NokiaCPQquoteActionsController.generateReconciliationExport(null);
	NokiaCPQquoteActionsController.generateReconciliationExport(proposals.id);
	Test.stopTest();
}
}
static testmethod void configureMethodNCQ_testMethod(){
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

	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Is_Maintenance_Quote__c = true;
	proposals[0].NokiaCPQ_Contract_Start_Date__c = date.today();
	proposals[0].Warranty_credit__c = 'No';
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId();
	insert proposals;

	test.startTest();
	NokiaCPQquoteActionsController.configureMethodNCQ(proposals[0].id);
	test.stopTest();

}
}

static testmethod void test_configureMethodMNDirect(){
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

	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Is_Maintenance_Quote__c = true;
	proposals[0].NokiaCPQ_Contract_Start_Date__c = date.today();
	proposals[0].Warranty_credit__c = 'No';
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId();
	insert proposals;

	test.startTest();
	NokiaCPQquoteActionsController.configureMethodMNDirect(proposals[0].id);
	test.stopTest();

}}

static testmethod void test_viewProductsMNDirectMethod(){
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

	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Is_Maintenance_Quote__c = true;
	proposals[0].NokiaCPQ_Contract_Start_Date__c = date.today();
	proposals[0].Warranty_credit__c = 'No';
	proposals[0].Apttus_QPConfig__IsTaskPending__c=true;
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId();
	insert proposals;

	test.startTest();
	NokiaCPQquoteActionsController.viewProductsMNDirectMethod(proposals[0].id);
	test.stopTest();

}
}

static testmethod void test_generateReconciliationExport(){
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

	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Is_Maintenance_Quote__c = true;
	proposals[0].NokiaCPQ_Contract_Start_Date__c = date.today();
	proposals[0].Warranty_credit__c = 'No';
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId();
	insert proposals;

	test.startTest();
	String result = NokiaCPQquoteActionsController.generateReconciliationExport(proposals[0].id);
	test.stopTest();

}}

//Added by Christie jj for ITCCPQ-1125
static testmethod void test_aggregation(){
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

	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Is_Maintenance_Quote__c = true;
	proposals[0].NokiaCPQ_Contract_Start_Date__c = date.today();
	proposals[0].Warranty_credit__c = 'No';
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId();
	insert proposals;

	Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List',
		Apttus_Config2__Active__c = True
		);
	insert ApttusTestPriceList;

	Apttus_Config2__ProductConfiguration__c ProdConfigs = new Apttus_Config2__ProductConfiguration__c(
		Name = 'APTTUS Test Config',
		Apttus_Config2__AccountId__c = accounts[0].Id,
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__Proposald__c = proposals[0].Id,
		Apttus_Config2__Status__c = 'New',
		Apttus_Config2__VersionNumber__c = 1,
		Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id),
		Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
	insert ProdConfigs;
	test.startTest();
	NokiaCPQquoteActionsController.getAggregation(proposals[0].id);
	String result2 = NokiaCPQquoteActionsController.getXAEParameters(ProdConfigs.Id);
	String result3 = NokiaCPQquoteActionsController.getCustomSetting();
	//surinder
	NokiaCPQquoteActionsController.updateTurboFlag(proposals[0],true);
	test.stopTest();
}
}
static testmethod void configureTurboserver_testMethod12(){
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

	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Is_Maintenance_Quote__c = true;
	proposals[0].NokiaCPQ_Contract_Start_Date__c = date.today();
	proposals[0].Warranty_credit__c = 'No';
	proposals[0].Is_Classic_Pricing__c  = false;
	proposals[0].Is_Turbo_Pricing__c = true;
	proposals[0].Apttus_QPConfig__IsTaskPending__c = false;
	insert proposals;

	test.startTest();
	NokiaCPQquoteActionsController.callSendBomToNPT(proposals[0].id);
	NokiaCPQquoteActionsController.callSendBomToNPT(null);
	NokiaCPQquoteActionsController.callSendBomToNPT('');

	NokiaCPQquoteActionsController.UpdateConfigurebutton(proposals[0].id,'Turbo',proposals[0]);
	NokiaCPQquoteActionsController.QueryConfiguration(proposals[0].id);
	NokiaCPQquoteActionsController.QueryQuoteRecord(proposals[0].id);
	test.stopTest();

}}


}