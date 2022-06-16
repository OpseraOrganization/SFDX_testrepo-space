/***********************************************************************************************************
* Apex Class Name   : PS_productuploadscontroller_Test
* Version   : 1.0 
* Created Date  : 24 Jan 2018
* Function  : test class for PS_productuploadscontroller_Test 
* Modification Log  :
* Developer Date	Description
* -----------------------------------------------------------------------------------------------------------
*Sneha Padhi	  20/01/2018	 Created Test Class for PS_productuploadscontroller_Test
*
************************************************************************************************************/
@isTest(seeAllData=false)
private class PS_productuploadscontroller_Test
{

	
	private static List<Account> accountList = new List<Account>();
	private static List<Opportunity> opportunityList = new List<Opportunity>();
	public static String[] csvFileLines;
	public static Blob csvFileBody;
	static String str = 'Name,AccountNumber,Type,Accountsource,Industry\n Esha Patharabe,10001,Prospect,Test,Banking\n Trupti Nimje,10002,Prospect,Test,Banking';

	@isTest static void lineitemTest10() {
	List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){		
	
		//String csvContent = '/n /nProductCode,Quantity,SiteName\nFC11011;1;AB';
	String csvContent = '/n /n ProductCode,Quantity,SiteName\n3EC17929UA,1,A B\n3FE31189BA,1,BC\n301049607,1,C D\n3HE06970AA,1,D E\n3FE31189BA,1,E F\nFC11011,1,F G';
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
		prod.Portfolio__c='Fixed Networks';
		prod.Created_by_PMDI__c = False;
		prod.Pricing_Clusters__c='FBA_N;POL_N';
		prod.IsActive= True;
		insert prod;
	
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
	 // RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Draft Quote').getRecordTypeId(),
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
		 );
		insert testProposal1;
		 
		
		
		Apttus_Config2__ProductConfiguration__c pconfig = new Apttus_Config2__ProductConfiguration__c();
		pconfig.Apttus_QPConfig__Proposald__c = testProposal1.Id;
		pconfig.Apttus_Config2__Status__c = 'Saved';
		pconfig.Name = 'APTTUS Test Config';
		pconfig.Apttus_Config2__AccountId__c = account3[0].Id;
		pconfig.Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id;
		insert pconfig;
	 
	Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=pconfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod.Id,
		//  Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__IsHidden__c=true,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = account3[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		insert  LineItem1;
		
		Direct_Portfolio_General_Setting__mdt setting = new Direct_Portfolio_General_Setting__mdt();
		setting.Portfolio__c = testProposal1.NokiaCPQ_Portfolio__c;
		setting.GSS_Flow__c = 'GSS List Price';
		setting.Non_GSS_Flow__c = 'ION Direct Pricing Quote';
		setting.MNDirectFlow__c = 'GridViewCartMNDirect';
		setting.Direct_CPQ__c = true;
		
	
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		PS_productuploadscontroller puc = new  PS_productuploadscontroller(new ApexPages.StandardController(testProposal1));
		
		
		
		puc.csvAsString = 'filename.csv';
		puc.csvFileBody =  Blob.valueof(csvContent);
		puc.setFile();
		puc.readFromFile();
		puc.createcart();
		puc.addProductsfromfile();
		//puc.Reprice();
		puc.Finalize();
		puc.Saveconfig();
		puc.Finalize();
		puc.returntocart();
		puc.returntoquote();
		puc.returntoProp();
		
		
		List<Apttus_Config2__LineItem__c> li = [select Id from Apttus_Config2__LineItem__c Limit 1];
		Apttus_Config2__ProductAttributeValue__c PA1 = new Apttus_Config2__ProductAttributeValue__c();
		
	/* if(li != null && !li.isEmpty() && li[0] != null){
			PA1.Apttus_Config2__LineItemId__c = li[0].id;
			PA1.Q_SWSuite__c = 'Premium';
		}
	 insert PA1;
*/   
		test.stopTest();
		}
	}
	
	

	 static testmethod void directInitTest1(){
	String csvContent = '/n /n ProductCode,Quantity,SiteName\n3EC17929UA ,1,A B\n3FE31189BA ,1,B C\n3HE06153AC ,1,C D\n3HE06970AA,1,D E\n3HE06970BA,1,E F\nFC11011,1,F G';
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		 insert accounts;
	  
		
		
		//create opportunity with non-euro currency
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities[0].CurrencyIsoCode = 'USD'; 
		insert opportunities;  
	  
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
		prod.Portfolio__c='Fixed Networks';
		prod.Created_by_PMDI__c = False;
		prod.Pricing_Clusters__c='FBA_N;POL_N';
		prod.IsActive= True;
		prod.Direct_Portfolio__c = 'IP Routing';
		insert prod;
	Test.startTest();
		 
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
		 
		//create a quote with non-euro currency
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].CurrencyIsoCode = 'USD'; 
		proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing';
		proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = true;
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
		insert proposals;   
	
		Direct_Portfolio_General_Setting__mdt setting = new Direct_Portfolio_General_Setting__mdt();
		setting.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
		setting.GSS_Flow__c = 'GSS List Price';
		setting.Non_GSS_Flow__c = 'ION Direct Pricing Quote';
		setting.MNDirectFlow__c = 'GridViewCartMNDirect';
		setting.Direct_CPQ__c = true;
		 
		ApexPages.currentPage().getParameters().put('id',proposals[0].id);
		PS_productuploadscontroller puc = new  PS_productuploadscontroller(new ApexPages.StandardController(proposals[0]));
		
		
		
		puc.csvAsString = 'filename.csv';
		puc.csvFileBody =  Blob.valueof(csvContent);
		puc.setFile();
		puc.readFromFile();
		//puc.createcart();
		//puc.addProductsfromfile();
		//puc.Reprice();
	  //  puc.Finalize();
		puc.Saveconfig();
		puc.Finalize();
		puc.returntocart();
		puc.returntoquote();
		
		
	  /*  List<Apttus_Config2__LineItem__c> li = [select Id from Apttus_Config2__LineItem__c Limit 1];
		Apttus_Config2__ProductAttributeValue__c PA1 = new Apttus_Config2__ProductAttributeValue__c();
		
		if(li != null && !li.isEmpty() && li[0] != null){
			PA1.Apttus_Config2__LineItemId__c = li[0].id;
			PA1.Q_SWSuite__c = 'Premium';
		}
	 insert PA1; 
	*/
	

		Test.stopTest();	
		
			
}
	
	@isTest static void lineitemTest04(){
	
		String csvContent = '/n /n ProductCode,Quantity,SiteName\nFC11011,1,A B\n  3FE31189BA ,1,B C\n  3HE06153AC ,1,C D\n  3HE06970AA,1,D E\n  3HE06970BA,1,E F\n  3HE06972AB,1,F G';
		List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	// account2[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	 //   account2[1].Partner_Type__c = '';
	  //  account2[1].Partner_Program__c = '';
		insert account3;
		
		List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	 //   opportunities[0].End_Customer_LE__c = account2[1].id;
		insert opportunities1;
	 
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
		prod.Portfolio__c='IP Routing';
		prod.Created_by_PMDI__c = False;
		prod.Pricing_Clusters__c='IPR_N';
		prod.IsActive= True;
		insert prod;

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
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),
			Apttus_Proposal__Account__c = account3[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities1.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = true,
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			
			NokiaCPQ_Needs_Reprice__c = false,
			//NokiaCPQ_Environment_Access_Type__c = 'PRM',
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_IONMaint_Contract__c='No',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'IP Routing',
			//NokiaCPQ_Maintenance_Type__c ='MN GS TSS Basic',
			Is_List_Price_Only__c = true,
			NokiaCPQPricing_Cluster__c = 'NAM'
		 );
		insert testProposal1;
	 
	 
		Direct_Portfolio_General_Setting__mdt setting = new Direct_Portfolio_General_Setting__mdt();
		setting.Portfolio__c = testProposal1.NokiaCPQ_Portfolio__c;
		setting.GSS_Flow__c = 'GSS List Price';
		setting.Non_GSS_Flow__c = 'ION Direct Pricing Quote';
		setting.MNDirectFlow__c = 'GridViewCartMNDirect';
		setting.Direct_CPQ__c = true;
		
	
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		PS_productuploadscontroller puc = new  PS_productuploadscontroller(new ApexPages.StandardController(testProposal1));
		
		
		
		//puc.csvAsString = 'filename.csv';
		puc.csvFileBody =  Blob.valueof(csvContent);
		puc.setFile();
		puc.readFromFile();
		//puc.createcart();
		//puc.addProductsfromfile();
		//puc.Reprice();
		puc.Finalize();
		puc.Saveconfig();
		puc.Finalize();
		puc.returntocart();
		puc.returntoquote();
		
		/*
		List<Apttus_Config2__LineItem__c> li = [select Id from Apttus_Config2__LineItem__c Limit 1];
		Apttus_Config2__ProductAttributeValue__c PA1 = new Apttus_Config2__ProductAttributeValue__c();
		
		if(li != null && !li.isEmpty() && li[0] != null){
			PA1.Apttus_Config2__LineItemId__c = li[0].id;
			PA1.Q_SWSuite__c = 'Premium';
		}
	 insert PA1; */
		test.stopTest();
	 }
	@isTest static void lineitemTest045(){
		String csvContent = '/n /n ProductCode,Quantity,SiteName\n  3EC17929UA ,1,A B\n  3FE31189BA ,1,B C\n  3HE06153AC ,1,C D\n  3HE06970AA,1,D E\n  3HE06970BA,1,E F\n  3HE06972AB,1,F G';
		test.starttest();
		Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Draft_Quote_Cannot_Validate').getRecordTypeId(),
			//Apttus_Proposal__Account__c = account3[0].Id,
			//Apttus_Proposal__Opportunity__c = opportunities1.get(0).Id,
			//Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = true,
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			
			NokiaCPQ_Needs_Reprice__c = false,
			//NokiaCPQ_Environment_Access_Type__c = 'PRM',
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_IONMaint_Contract__c='No',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'IP Routing',
			//NokiaCPQ_Maintenance_Type__c ='MN GS TSS Basic',
			Is_List_Price_Only__c = true,
			NokiaCPQPricing_Cluster__c = 'NAM'
		 );
		insert testProposal1;
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		PS_productuploadscontroller puc = new  PS_productuploadscontroller(new ApexPages.StandardController(testProposal1));
		puc.csvAsString = 'filename.csv';
		puc.csvFileBody =  Blob.valueof(csvContent);
		puc.readFromFile();
			test.stoptest();
	}
	 @isTest static void lineitemTest101(){
		List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
		runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runUSer[0].NSA_Compliant__c = true;
		database.insert(runUSer);
		system.runAs(runUSer[0]){ 
	
		//String csvContent = '/n /nProductCode,Quantity,SiteName\nFC11011;1;AB';
	String csvContent = '/n /n ProductCode,Quantity,SiteName\nFC11011,1,A B\n3FE31189BA,1,BC\n301049607,1,C D\n3HE06970AA,1,D E\n3FE31189BA,1,E F\n301049607,1,F G';
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
		prod.Portfolio__c='IP Routing';
		prod.Created_by_PMDI__c = False;
		prod.Pricing_Clusters__c='IPR_N';
		prod.IsActive= True;
		prod.isInvalidProductCatalog__c = Nokia_CPQ_Constants.TrueValue;
		prod.NokiaCPQ_Valid_for__c = 'Indirect';
		insert prod;

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
	 // RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Draft Quote').getRecordTypeId(),
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
		 );
		insert testProposal1;
		 
		
		
		Apttus_Config2__ProductConfiguration__c pconfig = new Apttus_Config2__ProductConfiguration__c();
		pconfig.Apttus_QPConfig__Proposald__c = testProposal1.Id;
		pconfig.Apttus_Config2__Status__c = 'Saved';
		pconfig.Name = 'APTTUS Test Config';
		pconfig.Apttus_Config2__AccountId__c = account3[0].Id;
		pconfig.Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id;
		insert pconfig;
	 
	Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=pconfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod.Id,
		//  Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__IsHidden__c=true,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = account3[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		insert  LineItem1;
		
		Direct_Portfolio_General_Setting__mdt setting = new Direct_Portfolio_General_Setting__mdt();
		setting.Portfolio__c = testProposal1.NokiaCPQ_Portfolio__c;
		setting.GSS_Flow__c = 'GSS List Price';
		setting.Non_GSS_Flow__c = 'ION Direct Pricing Quote';
		setting.MNDirectFlow__c = 'GridViewCartMNDirect';
		setting.Direct_CPQ__c = true;
		
	
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		PS_productuploadscontroller puc = new  PS_productuploadscontroller(new ApexPages.StandardController(testProposal1));
		
		puc.csvAsString = 'filename.csv';
		puc.csvFileBody =  Blob.valueof(csvContent);
		puc.setFile();
		puc.readFromFile();
		puc.createcart();
		puc.addProductsfromfile();
		//puc.Reprice();
		//puc.Finalize();
		puc.Saveconfig();
		//puc.Finalize();
		puc.returntocart();
		puc.returntoquote();
		
		List<Apttus_Config2__LineItem__c> li = [select Id from Apttus_Config2__LineItem__c Limit 1];
		Apttus_Config2__ProductAttributeValue__c PA1 = new Apttus_Config2__ProductAttributeValue__c();
		
		/*if(li != null && !li.isEmpty() && li[0] != null){
					PA1.Apttus_Config2__LineItemId__c = li[0].id;
					PA1.Q_SWSuite__c = 'Premium';
				}
			insert PA1;
		*/   
		test.stopTest();
		}
	 }
	 static testmethod void directInitTest1_1(){
		List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
		runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runUSer[0].NSA_Compliant__c = true;
		database.insert(runUSer);
		system.runAs(runUSer[0]){		 
	//String csvContent = '/n /n ProductCode,Quantity,SiteName\n3EC17929UA ,1,A B\n3FE31189BA ,1,B C\n3HE06153AC ,1,C D\n3HE06970AA,1,D E\n3HE06970BA,1,E F\n  3HE06972AB,1,F G';
	String csvContent = '/n /n ProductCode,Quantity,SiteName\n3EC17929UA ,1,A B\n3FE31189BA ,1,B C\n3HE06153AC ,1,C D\n3HE06970AA,1,D E\n3HE06970BA,1,E F\nFC11011,1,F G';
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		 insert accounts;

		//create opportunity with non-euro currency
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities[0].CurrencyIsoCode = 'GBP'; 
		insert opportunities;  
		//added to avoid soql 101 by skipping productTrigger
		Global_Control__c gc = new Global_Control__c();
		gc.ObjectTriggerByPass__c = 'PROD2';
		insert gc; 
		 /*create product*/
	product2 prod = new product2();
		prod.name = '3HE06972AB';
		prod.CurrencyIsoCode = 'GBP';
		prod.Business_Group__c='MN';
		prod.Family= 'A&A-CEM';
		prod.IsActive=True;
		prod.Partner_Visible__c=True;
		//prod.ProductCode='  3HE06972AB';
		prod.ProductCode='FC11011';
		prod.Apttus_Config2__Version__c=1;
		prod.Portfolio__c='IP Routing';
		prod.Created_by_PMDI__c = False;
		prod.Pricing_Clusters__c='IPR_N';
	 //   prod.IsActive= True;
		prod.Created_by_PMDI__c= false;
		insert prod;
System.debug('----prod--'+ prod);
	
		 
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
		 
		//create a quote with non-euro currency
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].CurrencyIsoCode = 'USD'; 
		proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = true;
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
		//proposals[0].Quote_Type__c = 'Direct CPQ';
		insert proposals;   
	
		Direct_Portfolio_General_Setting__mdt setting = new Direct_Portfolio_General_Setting__mdt();
		setting.Portfolio__c = proposals[0].NokiaCPQ_Portfolio__c;
		setting.GSS_Flow__c = 'GSS List Price';
		setting.Non_GSS_Flow__c = 'ION Direct Pricing Quote';
		setting.MNDirectFlow__c = 'GridViewCartMNDirect';
		setting.Direct_CPQ__c = true;
		 
		ApexPages.currentPage().getParameters().put('id',proposals[0].id);
		PS_productuploadscontroller puc = new  PS_productuploadscontroller(new ApexPages.StandardController(proposals[0]));
		
		Test.startTest();
		
		puc.csvAsString = 'filename.csv';
		puc.csvFileBody =  Blob.valueof(csvContent);
		puc.setFile();
		puc.readFromFile();
		//puc.createcart();
		//puc.addProductsfromfile();
		//puc.Reprice();
	  //  puc.Finalize();
		puc.Saveconfig();
		puc.Finalize();
		puc.returntocart();
		puc.returntoquote();
	//  puc.abandonCart();
		
		
	  

		Test.stopTest();	
		}	
		
			
}
   
}