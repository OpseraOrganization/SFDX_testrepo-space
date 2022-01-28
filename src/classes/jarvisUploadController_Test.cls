@isTest  
private class jarvisUploadController_Test
{   
	private static List<Account> accountList = new List<Account>();
	private static List<Opportunity> opportunityList = new List<Opportunity>();
	public static String[] csvFileLines; 
	public static Blob csvFileBody;
	static String str = 'Name,AccountNumber,Type,Accountsource,Industry\n Esha Patharabe,10001,Prospect,Test,Banking\n Trupti Nimje,10002,Prospect,Test,Banking';

	@isTest static void lineitemTest10(){
	   
	//   String csvContent = '/n /n Name,Material,Description\nSite A - Solution 1,3HE15662AB,OS - 7250 IXR R21.x OS LICENSE LARGE\nSite A - Solution 1,1,BC\n301049607,1,C D\n3HE06970AA,1,D E\n3FE31189BA,1,E F\n301049607,1,F G';
	//	String csvContent = '/n /n Name,Material,Description\nSite A - Solution 1,3HE15662AB,OS - 7250 IXR R21.x OS LICENSE LARGE\nSite A - Solution 1,3HE07928AA,QSFP+ - 40G SR4 100m, MPO ROHS6/6 0/70C\nSite B - Solution 2,3HE16249AA,7250 IXR-6 SRLinux - Advanced Lic.19.x\nSite A - Solution 1,3HE11915AA,L2 VPN License,Â  per UNI 100G IXR port\nSite B - Solution 2,3HE16839AA,RTU - 1588 Freq & Phase LICENSE LARGE';
	   String csvContent = '/n /n "Name","Material","Description"\n"Site A - Solution 1","3HE15662AB","OS - 7250 IXR R21.x OS LICENSE LARGE"\n"Site A - Solution 1","3HE07928AA","QSFP+ - 40G SR4 100m, MPO ROHS6/6 0/70C"\n"Site B - Solution 2","3HE16249AA","7250 IXR-6 SRLinux - Advanced Lic.19.x"\n"Site A - Solution 1","3HE11915AA","L2 VPN License,Â  per UNI 100G IXR port"\n"Site B - Solution 2","3HE16839AA","RTU - 1588 Freq & Phase LICENSE LARGE"';
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
	opportunities1[0].Account_Role__c = 'Alliance Partner';
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
	NokiaCPQ_Site__c site = new NokiaCPQ_Site__c();
	site.name = 'A';
	site.Opportunity__c= opportunities1.get(0).Id;
	
	insert site;
	
	NokiaCPQ_Phase__c phase = new NokiaCPQ_Phase__c();
	phase.name= '2021';
	phase.Opportunity__c= opportunities1.get(0).Id;
	insert phase;
	
	 List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = account3[0].Id;
	accreditations[1].partner__c = account3[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';   
	insert accreditations;
	   /*create product*/
	   product2 prod = new product2();
		prod.name = '3HE15662AB';
		prod.CurrencyIsoCode = 'USD';
		prod.Business_Group__c='MN';
		prod.Family= 'A&A-CEM';
		prod.IsActive=True;
		prod.Partner_Visible__c=True;
		prod.ProductCode='3HE15662AB';
		prod.Apttus_Config2__Version__c=1;
		prod.Portfolio__c='Airscale Wifi';
		prod.Direct_Portfolio__c= 'IP Routing';
		prod.Created_by_PMDI__c = False;
		prod.Pricing_Clusters__c='NAM';
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
		  //  Apttus_Config2__ProductCode__c='3HE15662AB'
			
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
	 @isTest static void lineitemTest11(){
	   
	//   String csvContent = '/n /n Name,Material,Description\nSite A - Solution 1,3HE15662AB,OS - 7250 IXR R21.x OS LICENSE LARGE\nSite A - Solution 1,1,BC\n301049607,1,C D\n3HE06970AA,1,D E\n3FE31189BA,1,E F\n301049607,1,F G';
	//	String csvContent = '/n /n Name,Material,Description\nSite A - Solution 1,3HE15662AB,OS - 7250 IXR R21.x OS LICENSE LARGE\nSite A - Solution 1,3HE07928AA,QSFP+ - 40G SR4 100m, MPO ROHS6/6 0/70C\nSite B - Solution 2,3HE16249AA,7250 IXR-6 SRLinux - Advanced Lic.19.x\nSite A - Solution 1,3HE11915AA,L2 VPN License,Â  per UNI 100G IXR port\nSite B - Solution 2,3HE16839AA,RTU - 1588 Freq & Phase LICENSE LARGE';
String csvContent = '/n /n "Name","Material","Description","GLP (USD)","NSP license pts","2021","2022","2023","2024","FPC","Total","Targeted Release","GA release","FD release","FA item","jBoQ token"\n"Site A - Solution 1","3HE15662AB","OS - 7250 IXR R21.x OS LICENSE LARGE","10000","0","3","0","0"," "," ","3","","21.2.R1","","N","jBoQ_part"\n"Site A - Solution 1","3HE07928AA","QSFP+ - 40G SR4 100m, MPO ROHS6/6 0/70C","3000","0","6","6","15"," "," ","27","","20.2.R1","","N","jBoQ_part"';
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
	opportunities1[0].Account_Role__c = 'Alliance Partner';
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
	NokiaCPQ_Site__c site = new NokiaCPQ_Site__c();
	site.name = 'A';
	site.Opportunity__c= opportunities1.get(0).Id;
	
	insert site;
	
	NokiaCPQ_Phase__c phase = new NokiaCPQ_Phase__c();
	phase.name= '2021';
	phase.Opportunity__c= opportunities1.get(0).Id;
	insert phase;
	
	 List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = account3[0].Id;
	accreditations[1].partner__c = account3[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';   
	insert accreditations;
	test.startTest();
	   /*create product*/
	   product2 prod = new product2();
		prod.name = '3HE15662AB';
		prod.CurrencyIsoCode = 'USD';
		prod.Business_Group__c='MN';
		prod.Family= 'A&A-CEM';
		prod.IsActive=True;
		prod.Partner_Visible__c=True;
		prod.ProductCode='3HE15662AB';
		prod.Apttus_Config2__Version__c=1;
		prod.Portfolio__c='Airscale Wifi';
		prod.Direct_Portfolio__c= 'IP Routing';
		prod.Created_by_PMDI__c = False;
		prod.Pricing_Clusters__c='NAM';
		prod.IsActive= True;
		
		insert prod;
 
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
		  //  Apttus_Config2__ProductCode__c='3HE15662AB'
			
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
	 
	 @isTest static void lineitemTest111(){
	   
	//   String csvContent = '/n /n Name,Material,Description\nSite A - Solution 1,3HE15662AB,OS - 7250 IXR R21.x OS LICENSE LARGE\nSite A - Solution 1,1,BC\n301049607,1,C D\n3HE06970AA,1,D E\n3FE31189BA,1,E F\n301049607,1,F G';
	//	String csvContent = '/n /n Name,Material,Description\nSite A - Solution 1,3HE15662AB,OS - 7250 IXR R21.x OS LICENSE LARGE\nSite A - Solution 1,3HE07928AA,QSFP+ - 40G SR4 100m, MPO ROHS6/6 0/70C\nSite B - Solution 2,3HE16249AA,7250 IXR-6 SRLinux - Advanced Lic.19.x\nSite A - Solution 1,3HE11915AA,L2 VPN License,Â  per UNI 100G IXR port\nSite B - Solution 2,3HE16839AA,RTU - 1588 Freq & Phase LICENSE LARGE';
String csvContent = '/n /n "Name","Material","Description","GLP (USD)","NSP license pts","2021","2022","2023","2024","FPC","Total","Targeted Release","GA release","FD release","FA item","jBoQ token"\n"Site A - Solution 1","3HE15662AB","OS - 7250 IXR R21.x OS LICENSE LARGE","10000","0","0","0","0"," "," ","0","","21.2.R1","","N","jBoQ_part"\n"Site A - Solution 1","3HE07928AA","QSFP+ - 40G SR4 100m, MPO ROHS6/6 0/70C","3000","0","6","6","15"," "," ","27","","20.2.R1","","N","jBoQ_part"';
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
	opportunities1[0].Account_Role__c = 'Alliance Partner';
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
	List<Opportunity> opportunities11 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
		opportunities11[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities11[0].StageName = 'Create Offer (Bid)';
		opportunities11[0].Phase_Status__c = 'Offer in Progress';
	   opportunities11[0].End_Customer_LE__c = account3[1].id;
	   opportunities11[0].StageName='Create Offer (Bid)';
	opportunities11[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities11[0].LOA_Level__c = '';
	opportunities11[0].No_Loa__c = false;
	opportunities11[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities11[0].Account_Role__c = 'Alliance Partner';
	   insert opportunities11;
	 
	 opportunities11[0].StageName = 'Create Offer (Bid)';
		opportunities11[0].Phase_Status__c = 'Offer in Progress';
	   opportunities11[0].End_Customer_LE__c = account3[1].id;
	   opportunities11[0].StageName='Create Offer (Bid)';
	opportunities11[0].Phase_Status__c='Submitted for G4 Approval';
	opportunities11[0].LOA_Level__c = '';
	opportunities11[0].No_Loa__c = false;
	opportunities11[0].Apttus_Approval__Approval_Status__c = 'Approved';
	opportunities11[0].G2_Approval_Date__c = Date.Today();
	//opportunities1[0].G3_Approval_Date__c =  Date.Today();
	opportunities11[0].G3_Planned_Date__c =  Date.Today();
	//opportunities11[0].G4_Approval_Date__c =  Date.Today();
	opportunities11[0].G4_Planned_Date__c =  Date.Today();
	//opportunities1[0].G5_Submission_Date__c =  Date.Today();
	//opportunities1[0].G4_Planned_Date__c =  Date.Today();
	
	update opportunities11[0];
	NokiaCPQ_Site__c site = new NokiaCPQ_Site__c();
	site.name = 'A';
	site.Opportunity__c= opportunities11.get(0).Id;
	
	insert site;
	
	NokiaCPQ_Phase__c phase = new NokiaCPQ_Phase__c();
	phase.name= '2021';
   phase.Opportunity__c= opportunities11.get(0).Id;
	insert phase;
	
	 List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
	accreditations[0].partner__c = account3[0].Id;
	accreditations[1].partner__c = account3[0].Id;
	accreditations[1].Accreditation_Type__c = 'Maintenance';
	accreditations[1].Accreditation_Level__c = 'Premium';
	accreditations[1].Pricing_Level_Override__c = 'Premium';   
	insert accreditations;
	test.startTest();
	   /*create product*/
	   product2 prod = new product2();
		prod.name = '3HE15662AB';
		prod.CurrencyIsoCode = 'USD';
		prod.Business_Group__c='MN';
		prod.Family= 'A&A-CEM';
		prod.IsActive=True;
		prod.Partner_Visible__c=True;
		prod.ProductCode='3HE15662AB';
		prod.Apttus_Config2__Version__c=1;
		prod.Portfolio__c='Airscale Wifi';
		prod.Direct_Portfolio__c= 'IP Routing';
		prod.Created_by_PMDI__c = False;
		prod.Pricing_Clusters__c='NAM';
		prod.IsActive= True;
		
		insert prod;
  
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
		  //  Apttus_Config2__ProductCode__c='3HE15662AB'
			
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