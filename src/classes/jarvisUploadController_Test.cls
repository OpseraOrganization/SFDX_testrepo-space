/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 02-09-2022
 * @last modified by  : Yashdeep Prajapati
 **/
@isTest
private class jarvisUploadController_Test
{   //test
	
private static List<Account> accountList = new List<Account>();
private static List<Opportunity> opportunityList = new List<Opportunity>();
public static String[] csvFileLines;
public static Blob csvFileBody;
static String str = 'Name,AccountNumber,Type,Accountsource,Industry\n Esha Patharabe,10001,Prospect,Test,Banking\n Trupti Nimje,10002,Prospect,Test,Banking';

@TestSetup
static void makeData(){
	List<user> runUSer = TestDataFactory.userCreation(1,'System Administrator');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
		Nokia_CPQ_Constants.isCloneRun = true;
		List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(3);
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[0].Name = 'WithSitePhase';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[1].Name = 'WithoutSitePhase';
		accounts[2].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[2].Partner_Type__c = '';
		accounts[2].Partner_Program__c = '';
		insert accounts;

		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(2,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[2].id;
		opportunities[0].Account_Role__c = 'GPP Distributor Partner';
		opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[1].End_Customer_LE__c = accounts[2].id;
		opportunities[1].Account_Role__c = 'GPP Distributor Partner';
		opportunities[1].Name = 'ForSitePhase';
		INSERT opportunities;

		NokiaCPQ_Site__c site = new NokiaCPQ_Site__c();
		site.name = 'A';
		site.Opportunity__c= opportunities.get(0).Id;
		insert site;

		NokiaCPQ_Phase__c phase = new NokiaCPQ_Phase__c();
		phase.name= '2021';
		phase.Opportunity__c= opportunities.get(0).Id;
		insert phase;

		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(4);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';
		accreditations[2].partner__c = accounts[1].Id;
		accreditations[3].partner__c = accounts[1].Id;
		accreditations[3].Accreditation_Type__c = 'Maintenance';
		accreditations[3].Accreditation_Level__c = 'Premium';
		accreditations[3].Pricing_Level_Override__c = 'Premium';
		insert accreditations;
		product2 prod = new product2();
		prod.name = '3HE15662AB';
		prod.CurrencyIsoCode = 'USD';
		prod.Business_Group__c='MN';
		prod.Family= 'A&A-CEM';
		prod.IsActive=True;
		prod.Partner_Visible__c=True;
		prod.ProductCode='3HE15662AB';
		prod.Apttus_Config2__Version__c=1;
		prod.Portfolio__c='IP Routing';
		prod.Direct_Portfolio__c= 'IP Routing';
		prod.Created_by_PMDI__c = False;
		prod.Pricing_Clusters__c='IPR_N';
		prod.IsActive= True;
		insert prod;

		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List',
			PriceList_Type__c='CPQ',
			Apttus_Config2__Type__c='Standard',
			Apttus_Config2__Active__c = True
			);
		insert priceList;
		Apttus_Config2__PriceListItem__c priceListItem = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__ProductId__c = prod.Id,
			Apttus_Config2__ChargeType__c = 'Standard Price'
			);
		insert priceListItem;

		List<Apttus_Proposal__Proposal__c> propList = new List<Apttus_Proposal__Proposal__c>();
		Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			IsCQ__c = false,
			Apttus_QPConfig__PriceListId__c = priceList.Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='No',
			NokiaCPQ_Needs_Reprice__c = false,
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
			);
		propList.add(proposal);
		Apttus_Proposal__Proposal__c proposal1 = new Apttus_Proposal__Proposal__c(
			Apttus_Proposal__Account__c = accounts[1].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(1).Id,
			IsCQ__c = false,
			Apttus_QPConfig__PriceListId__c = priceList.Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='No',
			NokiaCPQ_Needs_Reprice__c = false,
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
			);
		propList.add(proposal1);
		insert propList;

		List<Apttus_Config2__ProductConfiguration__c> prodConfigList = new List<Apttus_Config2__ProductConfiguration__c>();
		Apttus_Config2__ProductConfiguration__c pconfig = new Apttus_Config2__ProductConfiguration__c();
		pconfig.Apttus_QPConfig__Proposald__c = proposal.Id;
		pconfig.Apttus_Config2__Status__c = 'Saved';
		pconfig.Name = 'APTTUS Test Config';
		pconfig.Apttus_Config2__AccountId__c = accounts[0].Id;
		pconfig.Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigList.add(pconfig);
		Apttus_Config2__ProductConfiguration__c pconfig1 = new Apttus_Config2__ProductConfiguration__c();
		pconfig1.Apttus_QPConfig__Proposald__c = proposal1.Id;
		pconfig1.Apttus_Config2__Status__c = 'Saved';
		pconfig1.Name = 'APTTUS Test Config';
		pconfig1.Apttus_Config2__AccountId__c = accounts[1].Id;
		pconfig1.Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigList.add(pconfig1);
		insert prodConfigList;

		List<Apttus_Config2__LineItem__c> lineList = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c lineItem =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=pconfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = priceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price',
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod.Id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__IsHidden__c=true,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'
			);
		lineList.add(lineItem);
		Apttus_Config2__LineItem__c lineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=pconfig1.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = priceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price',
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod.Id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__IsHidden__c=true,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[1].Id,
			Apttus_Config2__AddedBy__c = 'added by code'
			);
		lineList.add(lineItem1);
		insert lineList;
	}
}

@isTest static void lineitemTest10() {

	//   String csvContent = '/n /n Name,Material,Description\nSite A - Solution 1,3HE15662AB,OS - 7250 IXR R21.x OS LICENSE LARGE\nSite A - Solution 1,1,BC\n301049607,1,C D\n3HE06970AA,1,D E\n3FE31189BA,1,E F\n301049607,1,F G';
	//  String csvContent = '/n /n Name,Material,Description\nSite A - Solution 1,3HE15662AB,OS - 7250 IXR R21.x OS LICENSE LARGE\nSite A - Solution 1,3HE07928AA,QSFP+ - 40G SR4 100m, MPO ROHS6/6 0/70C\nSite B - Solution 2,3HE16249AA,7250 IXR-6 SRLinux - Advanced Lic.19.x\nSite A - Solution 1,3HE11915AA,L2 VPN License,Â  per UNI 100G IXR port\nSite B - Solution 2,3HE16839AA,RTU - 1588 Freq & Phase LICENSE LARGE';
	List<User> sysAdminUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Data Loader Profile');
	System.runAs(sysAdminUser[0]){
		String csvContent = '/n /n "Name","Material","Description"\n"Site A - Solution 1","3HE15662AB","OS - 7250 IXR R21.x OS LICENSE LARGE"\n"Site A - Solution 1","3HE07928AA","QSFP+ - 40G SR4 100m, MPO ROHS6/6 0/70C"\n"Site B - Solution 2","3HE16249AA","7250 IXR-6 SRLinux - Advanced Lic.19.x"\n"Site A - Solution 1","3HE11915AA","L2 VPN License,Â  per UNI 100G IXR port"\n"Site B - Solution 2","3HE16839AA","RTU - 1588 Freq & Phase LICENSE LARGE"';

		test.startTest();
		Apttus_Proposal__Proposal__c testProposal1 = [SELECT ID from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Account__r.Name = 'WithSitePhase' LIMIT 1];
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		jarvisUploadController juc = new  jarvisUploadController(new ApexPages.StandardController(testProposal1));
		juc.csvAsString = 'filename.csv';
		juc.csvFileBody =  Blob.valueof(csvContent);
		juc.setFile();
		juc.validateCSVFile();
		juc.importProdutsfromfile();
		juc.createcart();
		juc.addProductsfromfile();
		juc.Reprice();
		juc.Saveconfig();
		juc.returntoquote();
		juc.goToCart();
		juc.close();
		List<Apttus_Config2__LineItem__c> li = [select Id from Apttus_Config2__LineItem__c Limit 1];
		Apttus_Config2__ProductAttributeValue__c PA1 = new Apttus_Config2__ProductAttributeValue__c();
		test.stopTest();
	}
}
@isTest static void lineitemTest11(){

	//   String csvContent = '/n /n Name,Material,Description\nSite A - Solution 1,3HE15662AB,OS - 7250 IXR R21.x OS LICENSE LARGE\nSite A - Solution 1,1,BC\n301049607,1,C D\n3HE06970AA,1,D E\n3FE31189BA,1,E F\n301049607,1,F G';
	//  String csvContent = '/n /n Name,Material,Description\nSite A - Solution 1,3HE15662AB,OS - 7250 IXR R21.x OS LICENSE LARGE\nSite A - Solution 1,3HE07928AA,QSFP+ - 40G SR4 100m, MPO ROHS6/6 0/70C\nSite B - Solution 2,3HE16249AA,7250 IXR-6 SRLinux - Advanced Lic.19.x\nSite A - Solution 1,3HE11915AA,L2 VPN License,Â  per UNI 100G IXR port\nSite B - Solution 2,3HE16839AA,RTU - 1588 Freq & Phase LICENSE LARGE';
	List<User> sysAdminUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Data Loader Profile');
	System.runAs(sysAdminUser[0]){
		String csvContent = '/n /n "Name","Material","Description","GLP (USD)","NSP license pts","2021","2022","2023","2024","FPC","Total","Targeted Release","GA release","FD release","FA item","jBoQ token"\n"Site A - Solution 1","3HE15662AB","OS - 7250 IXR R21.x OS LICENSE LARGE","10000","0","3","0","0"," "," ","3","","21.2.R1","","N","jBoQ_part"\n"Site A - Solution 1","3HE07928AA","QSFP+ - 40G SR4 100m, MPO ROHS6/6 0/70C","3000","0","6","6","15"," "," ","27","","20.2.R1","","N","jBoQ_part"';

		test.startTest();
		Apttus_Proposal__Proposal__c testProposal1 = [SELECT ID from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Account__r.Name = 'WithSitePhase' LIMIT 1];
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		jarvisUploadController juc = new  jarvisUploadController(new ApexPages.StandardController(testProposal1));
		juc.csvAsString = 'filename.csv';
		juc.csvFileBody =  Blob.valueof(csvContent);
		juc.setFile();
		juc.validateCSVFile();
		juc.importProdutsfromfile();
		juc.createcart();
		juc.addProductsfromfile();
		juc.Reprice();
		juc.Saveconfig();
		juc.returntoquote();
		juc.goToCart();
		juc.close();
		List<Apttus_Config2__LineItem__c> li = [select Id from Apttus_Config2__LineItem__c Limit 1];
		Apttus_Config2__ProductAttributeValue__c PA1 = new Apttus_Config2__ProductAttributeValue__c();
		test.stopTest();
	}
}

@isTest static void lineitemTest111(){

	//   String csvContent = '/n /n Name,Material,Description\nSite A - Solution 1,3HE15662AB,OS - 7250 IXR R21.x OS LICENSE LARGE\nSite A - Solution 1,1,BC\n301049607,1,C D\n3HE06970AA,1,D E\n3FE31189BA,1,E F\n301049607,1,F G';
	//  String csvContent = '/n /n Name,Material,Description\nSite A - Solution 1,3HE15662AB,OS - 7250 IXR R21.x OS LICENSE LARGE\nSite A - Solution 1,3HE07928AA,QSFP+ - 40G SR4 100m, MPO ROHS6/6 0/70C\nSite B - Solution 2,3HE16249AA,7250 IXR-6 SRLinux - Advanced Lic.19.x\nSite A - Solution 1,3HE11915AA,L2 VPN License,Â  per UNI 100G IXR port\nSite B - Solution 2,3HE16839AA,RTU - 1588 Freq & Phase LICENSE LARGE';
	List<User> sysAdminUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Data Loader Profile');
	System.runAs(sysAdminUser[0]){
		String csvContent = '/n /n "Name","Material","Description","GLP (USD)","NSP license pts","2021","2022","2023","2024","FPC","Total","Targeted Release","GA release","FD release","FA item","jBoQ token"\n"Site A - Solution 1","3HE15662AB","OS - 7250 IXR R21.x OS LICENSE LARGE","10000","0","0","0","0"," "," ","0","","21.2.R1","","N","jBoQ_part"\n"Site A - Solution 1","3HE07928AA","QSFP+ - 40G SR4 100m, MPO ROHS6/6 0/70C","3000","0","6","6","15"," "," ","27","","20.2.R1","","N","jBoQ_part"';

		test.startTest();
		Apttus_Proposal__Proposal__c testProposal1 = [SELECT ID from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Account__r.Name = 'WithoutSitePhase' LIMIT 1];
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		jarvisUploadController juc = new  jarvisUploadController(new ApexPages.StandardController(testProposal1));
		juc.csvAsString = 'filename.csv';
		juc.csvFileBody =  Blob.valueof(csvContent);
		juc.setFile();
		juc.validateCSVFile();
		juc.importProdutsfromfile();
		juc.createcart();
		juc.addProductsfromfile();
		juc.Reprice();
		juc.Saveconfig();
		juc.returntoquote();
		juc.goToCart();
		juc.close();
		List<Apttus_Config2__LineItem__c> li = [select Id from Apttus_Config2__LineItem__c Limit 1];
		Apttus_Config2__ProductAttributeValue__c PA1 = new Apttus_Config2__ProductAttributeValue__c();
		test.stopTest();
	}
}
@isTest static void lineitemTest1111(){

	//   String csvContent = '/n /n Name,Material,Description\nSite A - Solution 1,3HE15662AB,OS - 7250 IXR R21.x OS LICENSE LARGE\nSite A - Solution 1,1,BC\n301049607,1,C D\n3HE06970AA,1,D E\n3FE31189BA,1,E F\n301049607,1,F G';
	//  String csvContent = '/n /n Name,Material,Description\nSite A - Solution 1,3HE15662AB,OS - 7250 IXR R21.x OS LICENSE LARGE\nSite A - Solution 1,3HE07928AA,QSFP+ - 40G SR4 100m, MPO ROHS6/6 0/70C\nSite B - Solution 2,3HE16249AA,7250 IXR-6 SRLinux - Advanced Lic.19.x\nSite A - Solution 1,3HE11915AA,L2 VPN License,Â  per UNI 100G IXR port\nSite B - Solution 2,3HE16839AA,RTU - 1588 Freq & Phase LICENSE LARGE';
	//String csvContent = '/n /n "x";"3HE14159AA";"2021","2022","2023","2024","FPC","Targeted Release", "x","3HE14159AA","GA release","FD release","FA item","jBoQ token"\n"Site A - Solution 1","3HE15662AB","OS - 7250 IXR R21.x OS LICENSE LARGE","10000","0","0","0","0"," "," ","0","","21.2.R1","","N","jBoQ_part"\n"Site A - Solution 1","3HE07928AA","QSFP+ - 40G SR4 100m, MPO ROHS6/6 0/70C","3000","0","6","6","15"," "," ","27","","20.2.R1","","N","jBoQ_part"';
	List<User> sysAdminUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Data Loader Profile');
	System.runAs(sysAdminUser[0]){
		String csvContent = '/n /n   "x";"3HE14159AA";"Name","Material","Description","GLP (USD)","NSP license pts","Total","Targeted Release","GA release","FD release","FA item","jBoQ token"\n"Site A - Solution 1","3HE15662AB","OS - 7250 IXR R21.x OS LICENSE LARGE","10000","0","0","0","0"," "," ","0","","21.2.R1","","N","jBoQ_part"\n"Site A - Solution 1","3HE07928AA","QSFP+ - 40G SR4 100m, MPO ROHS6/6 0/70C","3000","0","6","6","15"," "," ","27","","20.2.R1","","N","jBoQ_part"';

		test.startTest();
		Apttus_Proposal__Proposal__c testProposal1 = [SELECT ID from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Account__r.Name = 'WithoutSitePhase' LIMIT 1];
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		jarvisUploadController juc = new  jarvisUploadController(new ApexPages.StandardController(testProposal1));
		juc.csvAsString = 'filename.csv';
		juc.csvFileBody =  Blob.valueof(csvContent);
		juc.setFile();
		juc.validateCSVFile();
		juc.importProdutsfromfile();
		juc.createcart();
		juc.addProductsfromfile();
		juc.Reprice();
		juc.Saveconfig();
		juc.returntoquote();
		juc.goToCart();
		juc.close();
		List<Apttus_Config2__LineItem__c> li = [select Id from Apttus_Config2__LineItem__c Limit 1];
		Apttus_Config2__ProductAttributeValue__c PA1 = new Apttus_Config2__ProductAttributeValue__c();

		test.stopTest();
	}
}


}