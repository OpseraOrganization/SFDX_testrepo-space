/* --------------------------------------------------------------------------------------------------------------------------------------------------------
				Name:	BulkUploadCustomProducts_Controller_Test
				Description:	 Test Class for Controller Class of the Bulk Upload functionality for Custom Products in Cart .
				Date	Version  Author	 Summary of Changes
				-----------   ----------   -----------------	 ---------------------------------------------------------------------------------------
				30 Apr 2021   1.0   Christie JJ	  ITCCPQ-925 - Pre-Aplha version.
				---------------------------------------------------------------------------------------------------------------------------------------------------------- */

@isTest
public class BulkUploadCustomProducts_Controller_Test{


@isTest static void   test_init_WithMaintenance()  {
	List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){

	String csvContent = 'Product Name,Product Code,Quantity,List Price,Maintenance Year 1 Rate %,Maintenance Year 2 Rate %,Product Discount Rate %,SSP/SRS Rate %,Is NSP?\ntest1,3324DDFA,1,5.5,3.5,2,1,5.5,no\ntest4,3324DDFD,4,8.5,6.5,5,4,5.5,yes';

	List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	account3[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	account3[1].Partner_Type__c = '';
	account3[1].Partner_Program__c = '';
	insert account3;

	List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
	opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities1[0].StageName = 'Create Offer (Bid)';
	opportunities1[0].Phase_Status__c = 'Offer in Progress';
	opportunities1[0].End_Customer_LE__c = account3[1].id;
	opportunities1[0].StageName='Create Offer (Bid)';
	opportunities1[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities1[0].LOA_Level__c = '';
	opportunities1[0].No_Loa__c = false;
	opportunities1[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
	insert opportunities1;

	opportunities1[0].StageName = 'Create Offer (Bid)';
	opportunities1[0].Phase_Status__c = 'Offer in Progress';
	opportunities1[0].End_Customer_LE__c = account3[1].id;
	opportunities1[0].StageName='Create Offer (Bid)';
	opportunities1[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities1[0].LOA_Level__c = '';
	opportunities1[0].No_Loa__c = false;
	opportunities1[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities1[0].G2_Approval_Date__c = Date.Today();
	//opportunities1[0].G3_Approval_Date__c =  Date.Today();
	opportunities1[0].G3_Planned_Date__c =  Date.Today();
	//opportunities1[0].G4_Approval_Date__c =  Date.Today();
	opportunities1[0].G4_Planned_Date__c =  Date.Today();
	//opportunities1[0].G5_Submission_Date__c =  Date.Today();
	//opportunities1[0].G4_Planned_Date__c =  Date.Today();

	update opportunities1[0];
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = account3[0].Id;
	accreditations[1].partner__c = account3[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	/*create product*/
	product2 prod = new product2();
	prod.name = '5G';
	prod.CurrencyIsoCode = 'USD';
	prod.Business_Group__c='MN';
	prod.Family= 'A&A-CEM';
	prod.IsActive=True;
	prod.Partner_Visible__c=True;
	prod.ProductCode='FC11011';
	prod.Apttus_Config2__Version__c=1;
	prod.Portfolio__c='Airscale Wifi';
	prod.Created_by_PMDI__c = False;
	prod.Pricing_Clusters__c='NAM';
	prod.IsActive= True;
	insert prod;


	// Insert Custom Product record
	Product2 objProd = new Product2();
	objProd.ProductCode = 'CUSTPROD001';
	objProd.Name = 'Custom Product';
	insert objProd;


	test.startTest();
	/*create pricelist*/
	Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List',
		PriceList_Type__c='CPQ',
		Apttus_Config2__Type__c='Standard',
		Apttus_Config2__Active__c = True
		);
	insert ApttusTestPriceList;
	/*create pricelist Item*/
	Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__ProductId__c = prod.Id,
		Apttus_Config2__ChargeType__c = 'Standard Price'

		);
	insert pLI5;

	Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
		Apttus_Proposal__Account__c = account3[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities1.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='No',
		NokiaCPQ_Needs_Reprice__c = false,
		//NokiaCPQ_Environment_Access_Type__c = 'PRM',
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '1',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)',
		NokiaCPQ_Is_Maintenance_Quote__c=true,
		NokiaCPQ_Contract_Start_Date__c=date.today(),
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = true,
		NokiaCPQPricing_Cluster__c = 'NAM',
		Warranty_credit__c='Yes'
					  //NokiaProductAccreditation__c=accreditations[0].id

		);
	insert testProposal1;



	Apttus_Config2__ProductConfiguration__c pconfig = new Apttus_Config2__ProductConfiguration__c();
	pconfig.Apttus_QPConfig__Proposald__c = testProposal1.Id;
	pconfig.Apttus_Config2__Status__c = 'Saved';
	pconfig.Name = 'APTTUS Test Config';
	pconfig.Apttus_Config2__AccountId__c = account3[0].Id;
	pconfig.Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id;
	insert pconfig;

	//Insert csv template document
	Document document = new Document();
	document.Body = Blob.valueOf('sep=,\nProduct Name,Product Code,Quantity,List Price,Product Discount Rate %,Maintenance Under Warranty Rate %,Maintenance Beyond Warranty Rate %,SSP Rate %,Is NSP? (Yes/No)');
	document.ContentType = 'text/csv';
	document.DeveloperName = 'Custom_Product_Upload_CSV_TemplateTest';
	document.IsPublic = true;
	document.Name = 'Custom Product Upload CSV TemplateTest';
	document.FolderId = [select id,DeveloperName from folder where DeveloperName = 'ApttusConfigDocuments'][0].id;
	insert document;

	//Insert Price Ruleset record
	List<Apttus_Config2__PriceRuleset__c> priceRulesetList = new List<Apttus_Config2__PriceRuleset__c>();
	Apttus_Config2__PriceRuleset__c priceRuleset0 = new Apttus_Config2__PriceRuleset__c(Apttus_Config2__Sequence__c=2,NokiaCPQ_Cluster_Tiers__c = 'LEO',NokiaCPQ_Partner_Program__c = '',name = 'NokiaCPQ LEO Discount IPR NUA OPT ');
	Apttus_Config2__PriceRuleset__c priceRuleset1 = new Apttus_Config2__PriceRuleset__c(Apttus_Config2__Sequence__c=1,NokiaCPQ_Partner_Program__c = 'GPP 3.0',name = 'NokiaCPQ Accreditation Level Discount GPP 3.0');
	priceRulesetList.add(priceRuleset0);
	priceRulesetList.add(priceRuleset1);
	insert priceRulesetList;

	//Insert Price Rule Id
	Apttus_Config2__PriceRule__c priceRuleRecord = new Apttus_Config2__PriceRule__c(Apttus_Config2__Sequence__c=1,Apttus_Config2__RulesetId__c = priceRulesetList[1].Id);
	insert priceRuleRecord;
	//Insert Price Rule Entry record
	Apttus_Config2__PriceRuleEntry__c priceEntryRecord = new Apttus_Config2__PriceRuleEntry__c(Apttus_Config2__Sequence__c=1,Apttus_Config2__Dimension1Value__c = 'Advanced',Apttus_Config2__PriceRuleId__c = priceRuleRecord.Id,Apttus_Config2__AdjustmentAmount__c=0.0);
	insert priceEntryRecord;

	NCPQ_Settings__c cpqSetting = new NCPQ_Settings__c();
	cpqSetting.NCPQ_MaintenanceProdCodes__c = 'test';
	cpqSetting.NCPQ_SPS_SRS_ProdCodes__c = 'test';
	cpqSetting.Name = 'test';
	insert cpqSetting;

	BulkUploadCustomProducts_Controller.init (pconfig.Id,'BulkUpload.csv',EncodingUtil.base64Encode(Blob.valueOf(csvContent)));


	test.stopTest();
	}

}

@isTest static void test_init_WithoutMaintenance(){
	String csvContent = 'Product Name,Product Code,Quantity,List Price,Maintenance Year 1 Rate %,Maintenance Year 2 Rate %,Product Discount Rate %,SSP/SRS Rate %,Is NSP?\ntest1,3324DDFA,1,5.5,3.5,2,1,5.5,no\ntest4,3324DDFD,4,8.5,6.5,5,4,5.5,yes';
	List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){

	List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	account3[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();

	account3[1].Partner_Type__c = '';
	account3[1].Partner_Program__c = '';
	insert account3;

	List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
	opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities1[0].StageName = 'Create Offer (Bid)';
	opportunities1[0].Phase_Status__c = 'Offer in Progress';
	opportunities1[0].End_Customer_LE__c = account3[1].id;
	opportunities1[0].StageName='Create Offer (Bid)';
	opportunities1[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities1[0].LOA_Level__c = '';
	opportunities1[0].No_Loa__c = false;
	opportunities1[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
	insert opportunities1;

	opportunities1[0].StageName = 'Create Offer (Bid)';
	opportunities1[0].Phase_Status__c = 'Offer in Progress';
	opportunities1[0].End_Customer_LE__c = account3[1].id;
	opportunities1[0].StageName='Create Offer (Bid)';
	opportunities1[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities1[0].LOA_Level__c = '';
	opportunities1[0].No_Loa__c = false;
	opportunities1[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities1[0].G2_Approval_Date__c = Date.Today();
	//opportunities1[0].G3_Approval_Date__c =  Date.Today();
	opportunities1[0].G3_Planned_Date__c =  Date.Today();
	//opportunities1[0].G4_Approval_Date__c =  Date.Today();
	opportunities1[0].G4_Planned_Date__c =  Date.Today();
	//opportunities1[0].G5_Submission_Date__c =  Date.Today();
	//opportunities1[0].G4_Planned_Date__c =  Date.Today();

	update opportunities1[0];
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = account3[0].Id;
	accreditations[1].partner__c = account3[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	/*create product*/
	product2 prod = new product2();
	prod.name = '5G';
	prod.CurrencyIsoCode = 'USD';
	prod.Business_Group__c='MN';
	prod.Family= 'A&A-CEM';
	prod.IsActive=True;
	prod.Partner_Visible__c=True;
	prod.ProductCode='FC11011';
	prod.Apttus_Config2__Version__c=1;
	prod.Portfolio__c='Airscale Wifi';
	prod.Created_by_PMDI__c = False;
	prod.Pricing_Clusters__c='NAM';
	prod.IsActive= True;
	insert prod;

	// Insert Custom Product record
	Product2 objProd = new Product2();
	objProd.ProductCode = 'CUSTPROD001';
	objProd.Name = 'Custom Product';
	insert objProd;

	test.startTest();
	/*create pricelist*/
	Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List',
		PriceList_Type__c='CPQ',
		Apttus_Config2__Type__c='Standard',
		Apttus_Config2__Active__c = True
		);
	insert ApttusTestPriceList;
	/*create pricelist Item*/
	Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__ProductId__c = prod.Id,
		Apttus_Config2__ChargeType__c = 'Standard Price'

		);
	insert pLI5;

	Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
		Apttus_Proposal__Account__c = account3[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities1.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='No',
		NokiaCPQ_Needs_Reprice__c = false,
		//NokiaCPQ_Environment_Access_Type__c = 'PRM',
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '1',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)',
		NokiaCPQ_Is_Maintenance_Quote__c=false,
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = false,
		NokiaCPQPricing_Cluster__c = 'NAM'
							   //NokiaProductAccreditation__c=accreditations[0].id
		);
	insert testProposal1;



	Apttus_Config2__ProductConfiguration__c pconfig = new Apttus_Config2__ProductConfiguration__c();
	pconfig.Apttus_QPConfig__Proposald__c = testProposal1.Id;
	pconfig.Apttus_Config2__Status__c = 'Saved';
	pconfig.Name = 'APTTUS Test Config';
	pconfig.Apttus_Config2__AccountId__c = account3[0].Id;
	pconfig.Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id;
	insert pconfig;

	//Insert csv template document
	Document document = new Document();
	document.Body = Blob.valueOf('sep=,\nProduct Name,Product Code,Quantity,List Price,Product Discount Rate %,Maintenance Under Warranty Rate %,Maintenance Beyond Warranty Rate %,SSP Rate %,Is NSP? (Yes/No)');
	document.ContentType = 'text/csv';
	document.DeveloperName = 'Custom_Product_Upload_CSV_TemplateTest';
	document.IsPublic = true;
	document.Name = 'Custom Product Upload CSV TemplateTest';
	document.FolderId = [select id,DeveloperName from folder where DeveloperName = 'ApttusConfigDocuments'][0].id;
	insert document;



	//Insert Price Ruleset record
	List<Apttus_Config2__PriceRuleset__c> priceRulesetList = new List<Apttus_Config2__PriceRuleset__c>();
	Apttus_Config2__PriceRuleset__c priceRuleset0 = new Apttus_Config2__PriceRuleset__c(Apttus_Config2__Sequence__c=2,NokiaCPQ_Cluster_Tiers__c = 'LEO',NokiaCPQ_Partner_Program__c = '',name = 'NokiaCPQ LEO Discount IPR NUA OPT ');
	Apttus_Config2__PriceRuleset__c priceRuleset1 = new Apttus_Config2__PriceRuleset__c(Apttus_Config2__Sequence__c=1,NokiaCPQ_Partner_Program__c = 'GPP 3.0',name = 'NokiaCPQ Accreditation Level Discount GPP 3.0');
	priceRulesetList.add(priceRuleset0);
	priceRulesetList.add(priceRuleset1);
	insert priceRulesetList;

	//Insert Price Rule Id
	Apttus_Config2__PriceRule__c priceRuleRecord = new Apttus_Config2__PriceRule__c(Apttus_Config2__Sequence__c=1,Apttus_Config2__RulesetId__c = priceRulesetList[1].Id);
	insert priceRuleRecord;
	//Insert Price Rule Entry record
	Apttus_Config2__PriceRuleEntry__c priceEntryRecord = new Apttus_Config2__PriceRuleEntry__c(Apttus_Config2__Sequence__c=1,Apttus_Config2__Dimension1Value__c = 'Advanced',Apttus_Config2__PriceRuleId__c = priceRuleRecord.Id,Apttus_Config2__AdjustmentAmount__c=0.0);
	insert priceEntryRecord;
	BulkUploadCustomProducts_Controller.init (pconfig.Id,'BulkUpload.csv',EncodingUtil.base64Encode(Blob.valueOf(csvContent)));
	BulkUploadCustomProducts_Controller.getDocumentId(testProposal1.Id);//FN-Modified
	BulkUploadCustomProducts_Controller.getSubPortfolio(testProposal1.Id);//FN-Added

	test.stopTest();
	}

}


@isTest static void test_init_withLeoQuote(){
	List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){	
	String csvContent = 'Product Name,Product Code,Quantity,List Price,Maintenance Year 1 Rate %,Maintenance Year 2 Rate %,Product Discount Rate %,SSP/SRS Rate %,Is NSP?\ntest1,3324DDFA,1,5.5,3.5,2,1,5.5,no\ntest4,3324DDFD,4,8.5,6.5,5,4,5.5,yes';

	List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	account3[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();

	account3[1].Partner_Type__c = '';
	account3[1].Partner_Program__c = '';
	insert account3;

	List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
	opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities1[0].StageName = 'Create Offer (Bid)';
	opportunities1[0].Phase_Status__c = 'Offer in Progress';
	opportunities1[0].End_Customer_LE__c = account3[1].id;
	opportunities1[0].StageName='Create Offer (Bid)';
	opportunities1[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities1[0].LOA_Level__c = '';
	opportunities1[0].No_Loa__c = false;
	opportunities1[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
	insert opportunities1;

	opportunities1[0].StageName = 'Create Offer (Bid)';
	opportunities1[0].Phase_Status__c = 'Offer in Progress';
	opportunities1[0].End_Customer_LE__c = account3[1].id;
	opportunities1[0].StageName='Create Offer (Bid)';
	opportunities1[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities1[0].LOA_Level__c = '';
	opportunities1[0].No_Loa__c = false;
	opportunities1[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities1[0].G2_Approval_Date__c = Date.Today();
//opportunities1[0].G3_Approval_Date__c =  Date.Today();
	opportunities1[0].G3_Planned_Date__c =  Date.Today();
//opportunities1[0].G4_Approval_Date__c =  Date.Today();
	opportunities1[0].G4_Planned_Date__c =  Date.Today();
//opportunities1[0].G5_Submission_Date__c =  Date.Today();
//opportunities1[0].G4_Planned_Date__c =  Date.Today();

	update opportunities1[0];
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = account3[0].Id;
	accreditations[1].partner__c = account3[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
	/*create product*/
	product2 prod = new product2();
	prod.name = '5G';
	prod.CurrencyIsoCode = 'USD';
	prod.Business_Group__c='MN';
	prod.Family= 'A&A-CEM';
	prod.IsActive=True;
	prod.Partner_Visible__c=True;
	prod.ProductCode='FC11011';
	prod.Apttus_Config2__Version__c=1;
	prod.Portfolio__c='Airscale Wifi';
	prod.Created_by_PMDI__c = False;
	prod.Pricing_Clusters__c='NAM';
	prod.IsActive= True;
	insert prod;

	// Insert Custom Product record
	Product2 objProd = new Product2();
	objProd.ProductCode = 'CUSTPROD001';
	objProd.Name = 'Custom Product';
	insert objProd;

	test.startTest();
	/*create pricelist*/
	Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List',
		PriceList_Type__c='CPQ',
		Apttus_Config2__Type__c='Standard',
		Apttus_Config2__Active__c = True
		);
	insert ApttusTestPriceList;
	/*create pricelist Item*/
	Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__ProductId__c = prod.Id,
		Apttus_Config2__ChargeType__c = 'Standard Price'

		);
	insert pLI5;

	Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
		Apttus_Proposal__Account__c = account3[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities1.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='No',
		NokiaCPQ_Needs_Reprice__c = false,
		//NokiaCPQ_Environment_Access_Type__c = 'PRM',
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '1',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)',
		NokiaCPQ_Is_Maintenance_Quote__c=false,
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = false,
		NokiaCPQPricing_Cluster__c = 'NAM',
		//NokiaProductAccreditation__c=accreditations[0].id,
		NokiaCPQ_LEO_Discount__c=true
		);
	insert testProposal1;



	Apttus_Config2__ProductConfiguration__c pconfig = new Apttus_Config2__ProductConfiguration__c();
	pconfig.Apttus_QPConfig__Proposald__c = testProposal1.Id;
	pconfig.Apttus_Config2__Status__c = 'Saved';
	pconfig.Name = 'APTTUS Test Config';
	pconfig.Apttus_Config2__AccountId__c = account3[0].Id;
	pconfig.Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id;
	insert pconfig;

	//Insert csv template document
	Document document = new Document();
	document.Body = Blob.valueOf('sep=,\nProduct Name,Product Code,Quantity,List Price,Product Discount Rate %,Maintenance Under Warranty Rate %,Maintenance Beyond Warranty Rate %,SSP Rate %,Is NSP? (Yes/No)');
	document.ContentType = 'text/csv';
	document.DeveloperName = 'Custom_Product_Upload_CSV_TemplateTest';
	document.IsPublic = true;
	document.Name = 'Custom Product Upload CSV TemplateTest';
	document.FolderId = [select id,DeveloperName from folder where DeveloperName = 'ApttusConfigDocuments'][0].id;
	insert document;



	//Insert Price Ruleset record
	List<Apttus_Config2__PriceRuleset__c> priceRulesetList = new List<Apttus_Config2__PriceRuleset__c>();
	Apttus_Config2__PriceRuleset__c priceRuleset0 = new Apttus_Config2__PriceRuleset__c(Apttus_Config2__Sequence__c=2,NokiaCPQ_Cluster_Tiers__c = 'LEO',NokiaCPQ_Partner_Program__c = '',name = 'NokiaCPQ LEO Discount IPR NUA OPT ');
	Apttus_Config2__PriceRuleset__c priceRuleset1 = new Apttus_Config2__PriceRuleset__c(Apttus_Config2__Sequence__c=1,NokiaCPQ_Partner_Program__c = 'GPP 3.0',name = 'NokiaCPQ LEO Discount IPR NUA OPT GPP 3.0');
	priceRulesetList.add(priceRuleset0);
	priceRulesetList.add(priceRuleset1);
	insert priceRulesetList;

	//Insert Price Rule Id
	Apttus_Config2__PriceRule__c priceRuleRecord = new Apttus_Config2__PriceRule__c(Apttus_Config2__Sequence__c=1,Apttus_Config2__RulesetId__c = priceRulesetList[1].Id);
	insert priceRuleRecord;
	//Insert Price Rule Entry record
	Apttus_Config2__PriceRuleEntry__c priceEntryRecord = new Apttus_Config2__PriceRuleEntry__c(Apttus_Config2__Sequence__c=1,Apttus_Config2__Dimension1Value__c = 'Advanced',Apttus_Config2__PriceRuleId__c = priceRuleRecord.Id,Apttus_Config2__AdjustmentAmount__c=0.0);
	insert priceEntryRecord;
	Apttus_Config2__PriceRuleEntry__c priceEntryRecord2 = new Apttus_Config2__PriceRuleEntry__c(Apttus_Config2__Sequence__c=1,Apttus_Config2__Dimension1Value__c = 'IP Routing',Apttus_Config2__PriceRuleId__c = priceRuleRecord.Id,Apttus_Config2__AdjustmentAmount__c=0.0);
	insert priceEntryRecord2;
	BulkUploadCustomProducts_Controller.init (pconfig.Id,'BulkUpload.csv',EncodingUtil.base64Encode(Blob.valueOf(csvContent)));
	BulkUploadCustomProducts_Controller.getDocumentId(testProposal1.Id);//FN-Modified

	test.stopTest();
	}

}


@isTest static void test_init_withDirectQuote(){
	String csvContent = 'Product Name,Product Code,Quantity,List Price,Maintenance Year 1 Rate %,Maintenance Year 2 Rate %,Product Discount Rate %,SSP/SRS Rate %,Is NSP?\ntest1,3324DDFA,1,5.5,3.5,2,1,5.5,no\ntest4,3324DDFD,4,8.5,6.5,5,4,5.5,yes';
	List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
	List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	account3[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();

	account3[1].Partner_Type__c = '';
	account3[1].Partner_Program__c = '';
	insert account3;

	List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
	opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities1[0].StageName = 'Create Offer (Bid)';
	opportunities1[0].Phase_Status__c = 'Offer in Progress';
	opportunities1[0].End_Customer_LE__c = account3[1].id;
	opportunities1[0].StageName='Create Offer (Bid)';
	opportunities1[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities1[0].LOA_Level__c = '';
	opportunities1[0].No_Loa__c = false;
	opportunities1[0].Apttus_Approval__Approval_Status__c = 'Approved';
	//opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
	insert opportunities1;

	opportunities1[0].StageName = 'Create Offer (Bid)';
	opportunities1[0].Phase_Status__c = 'Offer in Progress';
	opportunities1[0].End_Customer_LE__c = account3[1].id;
	opportunities1[0].StageName='Create Offer (Bid)';
	opportunities1[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities1[0].LOA_Level__c = '';
	opportunities1[0].No_Loa__c = false;
	opportunities1[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities1[0].G2_Approval_Date__c = Date.Today();
//opportunities1[0].G3_Approval_Date__c =  Date.Today();
	opportunities1[0].G3_Planned_Date__c =  Date.Today();
//opportunities1[0].G4_Approval_Date__c =  Date.Today();
	opportunities1[0].G4_Planned_Date__c =  Date.Today();
//opportunities1[0].G5_Submission_Date__c =  Date.Today();
//opportunities1[0].G4_Planned_Date__c =  Date.Today();

	update opportunities1[0];
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = account3[0].Id;
	accreditations[1].partner__c = account3[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';
	insert accreditations;
/*create product*/
	product2 prod = new product2();
	prod.name = '5G';
	prod.CurrencyIsoCode = 'USD';
	prod.Business_Group__c='MN';
	prod.Family= 'A&A-CEM';
	prod.IsActive=True;
	prod.Partner_Visible__c=True;
	prod.ProductCode='FC11011';
	prod.Apttus_Config2__Version__c=1;
	prod.Portfolio__c='Airscale Wifi';
	prod.Created_by_PMDI__c = False;
	prod.Pricing_Clusters__c='NAM';
	prod.IsActive= True;
	insert prod;

	// Insert Custom Product record
	Product2 objProd = new Product2();
	objProd.ProductCode = 'CUSTPROD001';
	objProd.Name = 'Custom Product';
	insert objProd;
	

	test.startTest();
/*create pricelist*/
	Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List',
		PriceList_Type__c='CPQ',
		Apttus_Config2__Type__c='Standard',
		Apttus_Config2__Active__c = True
		);
	insert ApttusTestPriceList;
	/*create pricelist Item*/
	Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__ProductId__c = prod.Id,
		Apttus_Config2__ChargeType__c = 'Standard Price'

		);
	insert pLI5;

	Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
		Apttus_Proposal__Account__c = account3[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities1.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='No',
		NokiaCPQ_Needs_Reprice__c = false,
		//NokiaCPQ_Environment_Access_Type__c = 'PRM',
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '1',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)',
		NokiaCPQ_Is_Maintenance_Quote__c=false,
		NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = false,
		NokiaCPQPricing_Cluster__c = 'NAM',
		//NokiaProductAccreditation__c=accreditations[0].id,
		NokiaCPQ_LEO_Discount__c=true
		);
	insert testProposal1;



	Apttus_Config2__ProductConfiguration__c pconfig = new Apttus_Config2__ProductConfiguration__c();
	pconfig.Apttus_QPConfig__Proposald__c = testProposal1.Id;
	pconfig.Apttus_Config2__Status__c = 'Saved';
	pconfig.Name = 'APTTUS Test Config';
	pconfig.Apttus_Config2__AccountId__c = account3[0].Id;
	pconfig.Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id;
	insert pconfig;

	//Insert csv template document
	Document document = new Document();
	document.Body = Blob.valueOf('sep=,\nProduct Name,Product Code,Quantity,List Price,Product Discount Rate %,Maintenance Under Warranty Rate %,Maintenance Beyond Warranty Rate %,SSP Rate %,Is NSP? (Yes/No)');
	document.ContentType = 'text/csv';
	document.DeveloperName = 'Custom_Product_Upload_CSV_TemplateTest';
	document.IsPublic = true;
	document.Name = 'Custom Product Upload CSV TemplateTest';
	document.FolderId = [select id,DeveloperName from folder where DeveloperName = 'ApttusConfigDocuments'][0].id;
	insert document;



//Insert Price Ruleset record
	List<Apttus_Config2__PriceRuleset__c> priceRulesetList = new List<Apttus_Config2__PriceRuleset__c>();
	Apttus_Config2__PriceRuleset__c priceRuleset0 = new Apttus_Config2__PriceRuleset__c(Apttus_Config2__Sequence__c=2,NokiaCPQ_Cluster_Tiers__c = 'LEO',NokiaCPQ_Partner_Program__c = '',name = 'NokiaCPQ LEO Discount IPR NUA OPT ');
	Apttus_Config2__PriceRuleset__c priceRuleset1 = new Apttus_Config2__PriceRuleset__c(Apttus_Config2__Sequence__c=1,NokiaCPQ_Partner_Program__c = 'GPP 3.0',name = 'NokiaCPQ Accreditation Level Discount GPP 3.0');
	priceRulesetList.add(priceRuleset0);
	priceRulesetList.add(priceRuleset1);
	insert priceRulesetList;

//Insert Price Rule Id
	Apttus_Config2__PriceRule__c priceRuleRecord = new Apttus_Config2__PriceRule__c(Apttus_Config2__Sequence__c=1,Apttus_Config2__RulesetId__c = priceRulesetList[1].Id);
	insert priceRuleRecord;
//Insert Price Rule Entry record
	Apttus_Config2__PriceRuleEntry__c priceEntryRecord = new Apttus_Config2__PriceRuleEntry__c(Apttus_Config2__Sequence__c=1,Apttus_Config2__Dimension1Value__c = 'Advanced',Apttus_Config2__PriceRuleId__c = priceRuleRecord.Id,Apttus_Config2__AdjustmentAmount__c=0.0);
	insert priceEntryRecord;
	BulkUploadCustomProducts_Controller.init (pconfig.Id,'BulkUpload.csv',EncodingUtil.base64Encode(Blob.valueOf(csvContent)));
	//BulkUploadCustomProducts_Controller.getDocumentId();

	test.stopTest();
	}

}
/*
@isTest static void   test_init_ProdCheck(){
	String csvContent = 'Product Name,Product Code,Quantity,List Price,Maintenance Year 1 Rate %,Maintenance Year 2 Rate %,Product Discount Rate %,SSP/SRS Rate %,Is NSP?\ntest1,3324DDFA,1,5.5,3.5,2,1,5.5,no\ntest12,PRECUSTPROD001,1,5.5,3.5,2,1,5.5,no';
	Apttus_Config2__ProductConfiguration__c objProductConfiguration;
	//List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	//runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	//runUSer[0].NSA_Compliant__c = true;
	//database.insert(runUSer);
	//system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
	// Create a test account
	List<Account> accounts=new List<Account>();
	Account testAcct = TestDataFactory.createAccount(1)[0];
	testAcct.AccountNumber='3011546567YP';
	testAcct.Acc_No__c = '3011546567';
	testAcct.CountryCode__c='IN';
	testAcct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	accounts.add(testAcct);
	//insert accounts;
	// Creates first opportunity
	//List<Opportunity> opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
	//opportunities.get(0).Lead_BG__c = 'MN';
	//opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	//opportunities.get(0).Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
	//insert opportunities.get(0);

	List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	account3[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();

	account3[1].Partner_Type__c = '';
	account3[1].Partner_Program__c = '';
	insert account3;

	List<Opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[0].StageName = 'Create Offer (Bid)';
	opportunities[0].Phase_Status__c = 'Offer in Progress';
	opportunities[0].End_Customer_LE__c = account3[1].id;
	opportunities[0].StageName='Create Offer (Bid)';
	opportunities[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities[0].LOA_Level__c = '';
	opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	//opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
	insert opportunities;
	List<product2> lstProduct = TestDataSetup.createCPQTestproduct(2);
	lstProduct[0].ProductCode = '3324DDFA';
	lstProduct[0].Direct_Portfolio__c = 'IP Routing';
	lstProduct[1].ProductCode = 'CUSTPROD001';
	lstProduct[1].Direct_Portfolio__c = 'IP Routing';
	insert lstProduct;
	Apttus_Config2__PriceList__c objPriceList = TestDataSetup.createpriceListSO();
	insert objPriceList;
	List<Apttus_Config2__PriceListItem__c> plis = new List<Apttus_Config2__PriceListItem__c>();
	Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = objPriceList.Id,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__ProductId__c = lstProduct[0].Id,
		Apttus_Config2__ChargeType__c = 'Standard Price'
		);
	plis.add(pLI1);
	Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = objPriceList.Id,
		Apttus_Config2__ListPrice__c = 0,
		Apttus_Config2__ProductId__c = lstProduct[1].Id,
		Apttus_Config2__ChargeType__c = 'Standard Price'
		);
	plis.add(pLI2);
	insert plis;
	Apttus_Proposal__Proposal__c objProposal = TestDataSetup.creatProposal(opportunities[0], testAcct, objPriceList);
	objProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
	objProposal.NokiaCPQ_No_of_Years__c = null;
	insert objProposal;
	objProductConfiguration = TestDataSetup.creatProductConfiguration(testAcct, objPriceList, objProposal);
	insert objProductConfiguration;

	List<Pre_Approved_Custom_Products__c> preApprovedProducts = new List<Pre_Approved_Custom_Products__c>();
	Pre_Approved_Custom_Products__c preApprovedProductsRecord1 = new Pre_Approved_Custom_Products__c();
	preApprovedProductsRecord1.Account__c=testAcct.Id;
	preApprovedProductsRecord1.Expiration_Date__c=System.Today().addDays(100);
	preApprovedProductsRecord1.Is_NSP__c=true;
	preApprovedProductsRecord1.List_Price__c=5.0;
	preApprovedProductsRecord1.Maintenance_Beyond_Warranty_Rate__c=1.0;
	preApprovedProductsRecord1.Maintenance_Type__c='Gold (Return for Exchange)';
	preApprovedProductsRecord1.Maintenance_Under_Warranty_Rate__c=2.0;
	preApprovedProductsRecord1.Portfolio__c='IP Routing';
	preApprovedProductsRecord1.Product_Code__c= '3324DDFA';
	preApprovedProductsRecord1.Product_Discount_Rate__c=3.0;
	preApprovedProductsRecord1.SSP_Rate__c=4.0;
	Pre_Approved_Custom_Products__c preApprovedProductsRecord2 = new Pre_Approved_Custom_Products__c();
	preApprovedProductsRecord2.Account__c=testAcct.Id;
	preApprovedProductsRecord2.Expiration_Date__c=Date.today().addDays(100);
	preApprovedProductsRecord2.Is_NSP__c=true;
	preApprovedProductsRecord2.List_Price__c=5.0;
	preApprovedProductsRecord2.Maintenance_Beyond_Warranty_Rate__c=1.0;
	preApprovedProductsRecord2.Maintenance_Type__c='Gold (Return for Exchange)';
	preApprovedProductsRecord2.Maintenance_Under_Warranty_Rate__c=2.0;
	preApprovedProductsRecord2.Portfolio__c='IP Routing';
	preApprovedProductsRecord2.Product_Code__c='PRECUSTPROD001';
	preApprovedProductsRecord2.Product_Discount_Rate__c=3.0;
	preApprovedProductsRecord2.SSP_Rate__c=4.0;

	preApprovedProducts.add(preApprovedProductsRecord1);
	preApprovedProducts.add(preApprovedProductsRecord2);
	insert preApprovedProducts;
//}

	test.startTest();
	BulkUploadCustomProducts_Controller.init (objProductConfiguration.Id,'BulkUpload.csv',EncodingUtil.base64Encode(Blob.valueOf(csvContent)));
	test.stopTest();

}*/

}