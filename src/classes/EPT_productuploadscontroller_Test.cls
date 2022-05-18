@isTest
private class EPT_productuploadscontroller_Test
{  
  
  private static List<Account> accountList = new List<Account>();
  private static List<Opportunity> opportunityList = new List<Opportunity>();
  public static String[] csvFileLines;
  public static Blob csvFileBody;
  /****/
  /*
  @isTest static void lineitemTest1(){

	List<user> runUSer = TestDataFactory.userCreation(1,'System Administrator');
  runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
  runUSer[0].NSA_Compliant__c = true;
  //database.insert(runUSer);
  system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;

	  String csvContent = 'Acronym,Orderable Item,APN,Price,TOTALS,Pune,Mumbai,Delhi\nCOSKIT,"Main Shelf Kit (incl. COSHF, USRPNL, FAN, TIBNKx2)",3HE10869BA,(-),10,1,1,1\n COEKIT,"Extension Shelf Kit (incl COSHF, UPBNK, FAN, TIBNKx2)",3HE10477AA,(-),18,3,1,1\n  COEKIT2,"Extension Shelf Kit2 (incl COSHF2, UPBNK2, FAN2, TIBNKx22)",3HE10869AAAA,(-),18,3,1,1\n COEKIT3,"Extension Shelf Kit2 (incl COSHF3, UPBNK3, FAN3, TIBNKx33)",3HE10869XX,(-),18,3,1,1';
	  
	  
	  
	  List <Account> account2 = NOKIA_CPQ_TestDataFactory.getAccounts(3);
	  account2[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  account2[1].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  account2[2].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  account2[2].Partner_Type__c = '';
	  account2[2].Partner_Program__c = '';
	  insert account2;
	  
	  product2 prod = new product2();
	  prod.name = 'A';
	  prod.CurrencyIsoCode = 'USD';
	  prod.Business_Group__c='MN';
	  prod.Family= 'A&A-CEM';
	  prod.IsActive=True;
	  prod.Partner_Visible__c=True;
	  prod.ProductCode='3HE10869BA';
	  prod.Apttus_Config2__Version__c= 1;
	  prod.Portfolio__c= 'Optics';
	  prod.Pricing_Clusters__c='NAM';
	  prod.IsActive= True;
	  insert prod;
	  
	  product2 prod1 = new product2();
	  prod1.name = 'A2';
	  prod1.CurrencyIsoCode = 'USD';
	  prod1.Business_Group__c='MN';
	  prod1.Family= 'A&A-CEM';
	  prod1.IsActive=True;
	  prod1.Partner_Visible__c=True;
	  prod1.ProductCode='3HE10869AAAA';
	  prod1.Apttus_Config2__Version__c= 1;
	  prod1.Portfolio__c= 'Optics';
	  prod1.Pricing_Clusters__c='NAM';
	  prod1.IsActive= True;
	  insert prod1;
	  
	  product2 prod3 = new product2();
	  prod3.name = 'A3';
	  prod3.CurrencyIsoCode = 'USD';
	  prod3.Business_Group__c='MN';
	  prod3.Family= 'A&A-CEM';
	  prod3.IsActive=True;
	  prod3.Partner_Visible__c=True;
	  prod3.ProductCode='3HE10869XX';
	  prod3.Apttus_Config2__Version__c= 1;
	  prod3.Portfolio__c= 'Optics';
	  prod3.Pricing_Clusters__c='NAM';
	  prod3.IsActive= True;
	  insert prod3;
	  
	  Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
		   Accreditation_Date__c = date.today(),
		   Accreditation_Level__c='Authorized',
		   Partner__c=account2[0].Id,
		   Portfolio__c='Optics',
		   Pricing_Cluster__c='NAM' 
		  );
	  Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
		   Accreditation_Date__c = date.today(),
		   Accreditation_Level__c='Authorized',
		   Partner__c=account2[0].Id,
		   Portfolio__c='Optics',
		   Pricing_Cluster__c='NAM' 
		  );
	  
	  insert accreditation1;
	  insert accreditation2;
	  
	  GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	  
	Test.StartTest();  
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(2,account2);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = account2[2].id;
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[1].End_Customer_LE__c = account2[2].id;
	opportunities[1].Account_Role__c = 'GPP Distributor Partner';
	opportunities[1].Name = 'ForSitePhase';
	INSERT opportunities;
	  
	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
	  insert ApttusTestPriceList;
	  
	  
	  Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
		Apttus_Proposal__Account__c = account2[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='',
		NokiaCPQ_Needs_Reprice__c = false,
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		NokiaCPQ_Portfolio__c = 'Optics',
		NokiaCPQ_Maintenance_Type__c =''		
	  );
	  system.debug('[+] proposal type = '+testProposal.Quote_Type__c);
	  system.debug('[+] proposals oppty type = '+testProposal.Apttus_Proposal__Opportunity__c);
	  insert testProposal;
	  
	  Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c();
	  ProdConfig.Name = 'APTTUS Test Config'; 
	  ProdConfig.Apttus_QPConfig__Proposald__c = testProposal.id;
	  ProdConfig.Apttus_Config2__Status__c = 'Finalized';
	  ProdConfig.Apttus_Config2__VersionNumber__c = 1;
	  ProdConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
	  
	  insert ProdConfig;  
	  
	  NokiaCPQ_Site__c site = new NokiaCPQ_Site__c();
	  site.Opportunity__c = opportunities.get(0).Id;
	  site.name = 'test  test';
	  insert site;
	  
	  
	  ApexPages.currentPage().getParameters().put('id',testProposal.id);
	  EPT_productuploadscontroller puc = new  EPT_productuploadscontroller(new ApexPages.StandardController(testProposal));
	  puc.cartId = ProdConfig.Id;
	  puc.selectedSource = 'Wavelite';
	  puc.csvAsString = 'filename.csv';
	  puc.csvFileBody =  Blob.valueof(csvContent);
	  puc.getsourceType();
	  puc.setCSVFile();
	  puc.readFromFile();
	  puc.createcart();
	  puc.addProductsfromfile();
	  
	  puc.Reprice();
	  puc.getisCSV();
	  puc.Finalize();
	  puc.Saveconfig();
	  puc.addProducttoLineItem(ProdConfig.Id);
	  puc.addProductsToCart();
	  
	  puc.returntoquote();
	  puc.returntocart();
	  Test.StopTest();
	  
	}
  }*/
  /*
  @isTest static void lineitemTest2(){
	List<user> runUSer = TestDataFactory.userCreation(1,'System Administrator');
  runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
  runUSer[0].NSA_Compliant__c = true;
  //database.insert(runUSer);
  system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
	  String csvContent = 'Acronym;Orderable Item;APN,Price,TOTALS,Pune,Mumbai,Delhi\n ,"Main Shelf Kit (incl. COSHF, USRPNL, FAN, TIBNKx2)",3HE10869BA,(-),10,1,1,1\n "Extension Shelf Kit (incl COSHF, UPBNK, FAN, TIBNKx2)",3HE10477AA,(-),18,3,1,1\n,"Extension Shelf Kit2 (incl COSHF2, UPBNK2, FAN2, TIBNKx22)",3HE10869AAAA,(-),18,3,1,1\n,"Extension Shelf Kit2 (incl COSHF3, UPBNK3, FAN3, TIBNKx33)",3HE10869XX,(-);18;3;1;1';
	  
	  
	  
	  List <Account> account2 = NOKIA_CPQ_TestDataFactory.getAccounts(3);
	  account2[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  account2[1].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  account2[2].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  account2[2].Partner_Type__c = '';
	  account2[2].Partner_Program__c = '';
	  insert account2;
	  
	  product2 prod = new product2();
	  prod.name = 'A';
	  prod.CurrencyIsoCode = 'USD';
	  prod.Business_Group__c='MN';
	  prod.Family= 'A&A-CEM';
	  prod.IsActive=True;
	  prod.Partner_Visible__c=True;
	  prod.ProductCode='3HE10869BA';
	  prod.Apttus_Config2__Version__c= 1;
	  prod.Portfolio__c= 'Optics';
	  prod.Pricing_Clusters__c='NAM';
	  prod.IsActive= True;
	  insert prod;
	  
	  product2 prod1 = new product2();
	  prod1.name = 'A2';
	  prod1.CurrencyIsoCode = 'USD';
	  prod1.Business_Group__c='MN';
	  prod1.Family= 'A&A-CEM';
	  prod1.IsActive=True;
	  prod1.Partner_Visible__c=True;
	  prod1.ProductCode='3HE10869AAAA';
	  prod1.Apttus_Config2__Version__c= 1;
	  prod1.Portfolio__c= 'Optics';
	  prod1.Pricing_Clusters__c='NAM';
	  prod1.IsActive= True;
	  insert prod1;
	  
	  product2 prod3 = new product2();
	  prod3.name = 'A3';
	  prod3.CurrencyIsoCode = 'USD';
	  prod3.Business_Group__c='MN';
	  prod3.Family= 'A&A-CEM';
	  prod3.IsActive=True;
	  prod3.Partner_Visible__c=True;
	  prod3.ProductCode='3HE10869XX';
	  prod3.Apttus_Config2__Version__c= 1;
	  prod3.Portfolio__c= 'Optics';
	  prod3.Pricing_Clusters__c='NAM';
	  prod3.IsActive= True;
	  insert prod3;
	  
	  Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
		   Accreditation_Date__c = date.today(),
		   Accreditation_Level__c='Authorized',
		   Partner__c=account2[0].Id,
		   Portfolio__c='Optics',
		   Pricing_Cluster__c='NAM' 
		  );
	  Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
		   Accreditation_Date__c = date.today(),
		   Accreditation_Level__c='Authorized',
		   Partner__c=account2[0].Id,
		   Portfolio__c='Optics',
		   Pricing_Cluster__c='NAM' 
		  );
	  
	  insert accreditation1;
	  insert accreditation2;
	  
	  GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	  Test.StartTest();
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(2,account2);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = account2[2].id;
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[1].End_Customer_LE__c = account2[2].id;
	opportunities[1].Account_Role__c = 'GPP Distributor Partner';
	opportunities[1].Name = 'ForSitePhase';
	INSERT opportunities;
	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
	  insert ApttusTestPriceList;
	  
		 
	  Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
		Apttus_Proposal__Account__c = account2[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='',
		NokiaCPQ_Needs_Reprice__c = false,
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		NokiaCPQ_Portfolio__c = 'Optics',
		NokiaCPQ_Maintenance_Type__c =''
		
	  );
	  insert testProposal;
	  
	  Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c();
	  ProdConfig.Name = 'APTTUS Test Config'; 
	  ProdConfig.Apttus_QPConfig__Proposald__c = testProposal.id;
	  ProdConfig.Apttus_Config2__Status__c = 'Finalized';
	  ProdConfig.Apttus_Config2__VersionNumber__c = 1;
	  ProdConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
	  
	  insert ProdConfig;  
	  
	  NokiaCPQ_Site__c site = new NokiaCPQ_Site__c();
	  site.Opportunity__c = opportunities.get(0).Id;
	  site.name = 'test  test';
	  insert site;
	  
	  
	  ApexPages.currentPage().getParameters().put('id',testProposal.id);
	  EPT_productuploadscontroller puc = new  EPT_productuploadscontroller(new ApexPages.StandardController(testProposal));
	  puc.cartId = ProdConfig.Id;
	  puc.selectedSource = 'Wavelite';
	  puc.csvAsString = 'filename.csv';
	  puc.csvFileBody =  Blob.valueof(csvContent);
	  puc.getsourceType();
	  puc.setCSVFile();
	  puc.readFromFile();
	  puc.createcart();
	  puc.addProductsfromfile();
	  
	  puc.Reprice();
	  puc.getisCSV();
	  puc.Finalize();
	  puc.Saveconfig();
	  puc.addProducttoLineItem(ProdConfig.Id);
	  puc.addProductsToCart();
	  //Test.StopTest();
	  puc.returntoquote();
	  puc.returntocart();
	  Test.StopTest();
	  
	}
  } */ 
  /*
  @isTest static void lineitemTest3(){
	List<user> runUSer = TestDataFactory.userCreation(1,'System Administrator');
  runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
  runUSer[0].NSA_Compliant__c = true;
  //database.insert(runUSer);
  system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
	  String csvContent = '"Acronym","Orderable Item","APN","Price","TOTALS","Pune","Mumbai","Delhi"\n"Main Shelf Kit (incl. COSHF, USRPNL, FAN, TIBNKx2)","3HE10869BA","(-)","10","1","1","1"\n"Extension Shelf Kit (incl COSHF, UPBNK, FAN, TIBNKx2)","3HE10477AA","(-)","18","3","1","1"\n"Extension Shelf Kit2 (incl COSHF2, UPBNK2, FAN2, TIBNKx22)","3HE10869AAAA","(-)","18","3","1","1"\n"Extension Shelf Kit2 (incl COSHF3, UPBNK3, FAN3, TIBNKx33)","3HE10869XX","(-)","18","3","1","1"';
	  
	  
	  
	  List <Account> account2 = NOKIA_CPQ_TestDataFactory.getAccounts(3);
	  account2[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  account2[1].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  account2[2].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  account2[2].Partner_Type__c = '';
	  account2[2].Partner_Program__c = '';
	  insert account2;
	  
	  product2 prod = new product2();
	  prod.name = 'A';
	  prod.CurrencyIsoCode = 'USD';
	  prod.Business_Group__c='MN';
	  prod.Family= 'A&A-CEM';
	  prod.IsActive=True;
	  prod.Partner_Visible__c=True;
	  prod.ProductCode='3HE10869BA';
	  prod.Apttus_Config2__Version__c= 1;
	  prod.Portfolio__c= 'Optics';
	  prod.Pricing_Clusters__c='NAM';
	  prod.IsActive= True;
	  insert prod;
	  
	  product2 prod1 = new product2();
	  prod1.name = 'A2';
	  prod1.CurrencyIsoCode = 'USD';
	  prod1.Business_Group__c='MN';
	  prod1.Family= 'A&A-CEM';
	  prod1.IsActive=True;
	  prod1.Partner_Visible__c=True;
	  prod1.ProductCode='3HE10869AAAA';
	  prod1.Apttus_Config2__Version__c= 1;
	  prod1.Portfolio__c= 'Optics';
	  prod1.Pricing_Clusters__c='NAM';
	  prod1.IsActive= True;
	  insert prod1;
	  
	  product2 prod3 = new product2();
	  prod3.name = 'A3';
	  prod3.CurrencyIsoCode = 'USD';
	  prod3.Business_Group__c='MN';
	  prod3.Family= 'A&A-CEM';
	  prod3.IsActive=True;
	  prod3.Partner_Visible__c=True;
	  prod3.ProductCode='3HE10869XX';
	  prod3.Apttus_Config2__Version__c= 1;
	  prod3.Portfolio__c= 'Optics';
	  prod3.Pricing_Clusters__c='NAM';
	  prod3.IsActive= True;
	  insert prod3;
	  
	  Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
		   Accreditation_Date__c = date.today(),
		   Accreditation_Level__c='Authorized',
		   Partner__c=account2[0].Id,
		   Portfolio__c='Optics',
		   Pricing_Cluster__c='NAM' 
		  );
	  Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
		   Accreditation_Date__c = date.today(),
		   Accreditation_Level__c='Authorized',
		   Partner__c=account2[0].Id,
		   Portfolio__c='Optics',
		   Pricing_Cluster__c='NAM' 
		  );
	  
	  insert accreditation1;
	  insert accreditation2;
	  
	  GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	  Test.StartTest();
	  List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(2,account2);
	  opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities[0].End_Customer_LE__c = account2[2].id;
	  opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	  opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities[1].End_Customer_LE__c = account2[2].id;
	  opportunities[1].Account_Role__c = 'GPP Distributor Partner';
	  opportunities[1].Name = 'ForSitePhase';
	  INSERT opportunities;
	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
	  insert ApttusTestPriceList;
	  
	  
	  Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
		Apttus_Proposal__Account__c = account2[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='',
		NokiaCPQ_Needs_Reprice__c = false,
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		NokiaCPQ_Portfolio__c = 'Optics',
		NokiaCPQ_Maintenance_Type__c =''
		
	  );
	  insert testProposal;
	  
	  Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c();
	  ProdConfig.Name = 'APTTUS Test Config'; 
	  ProdConfig.Apttus_QPConfig__Proposald__c = testProposal.id;
	  ProdConfig.Apttus_Config2__Status__c = 'Finalized';
	  ProdConfig.Apttus_Config2__VersionNumber__c = 1;
	  ProdConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
	  
	  insert ProdConfig;  
	  
	  NokiaCPQ_Site__c site = new NokiaCPQ_Site__c();
	  site.Opportunity__c = opportunities.get(0).Id;
	  site.name = 'test  test';
	  insert site;
	  
	  ApexPages.currentPage().getParameters().put('id',testProposal.id);
	  EPT_productuploadscontroller puc = new  EPT_productuploadscontroller(new ApexPages.StandardController(testProposal));
	  puc.cartId = ProdConfig.Id;
	  puc.selectedSource = 'Wavelite';
	  puc.csvAsString = 'filename.csv';
	  puc.csvFileBody =  Blob.valueof(csvContent);
	  puc.getsourceType();
	  puc.setCSVFile();
	  puc.readFromFile();
	  puc.createcart();
	  puc.addProductsfromfile();
	  
	  puc.Reprice();
	  puc.getisCSV();
	  puc.Finalize();
	  puc.Saveconfig();
	  puc.addProducttoLineItem(ProdConfig.Id);
	  puc.addProductsToCart();
	  //Test.StopTest();
	  puc.returntoquote();
	  puc.returntocart();
	  Test.StopTest();
	  
	}
  }*/
  /*
  @isTest static void lineitemTest4(){
	List<user> runUSer = TestDataFactory.userCreation(1,'System Administrator');
  runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
  runUSer[0].NSA_Compliant__c = true;
  database.insert(runUSer);
  system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
	  String csvContent = 'Acronym,Orderable Item,APN,Price,TOTALS,Pune,Mumbai,Delhi\n,Main Shelf Kit (incl. COSHF, USRPNL, FAN, TIBNKx2),3HE10869BA,(-),10,1,1,1\n Extension Shelf Kit (incl COSHF, UPBNK, FAN, TIBNKx2),3HE10477AA,(-),18,3,1,1\n,Extension Shelf Kit2 (incl COSHF2, UPBNK2, FAN2, TIBNKx22),3HE10869AAAA,(-),18,3,1,1\n,Extension Shelf Kit2 (incl COSHF3, UPBNK3, FAN3, TIBNKx33),3HE10869XX,(-),18,3,1,1\n,Extension Shelf Kit2 (incl COSHF2, UPBNK2, FAN2, TIBNKx22),3HE10869AAAA,(-),18,3,1,1\n,Extension Shelf Kit2 (incl COSHF3, UPBNK3, FAN3, TIBNKx33),3HE10869XX,(-),18,3,1,1';
	  String csvContent2 = 'Acronym,Orderable Item,APN,Price,TOTALS,Pune,Mumbai,Delhi\n,Main Shelf Kit (incl. COSHF, USRPNL, FAN, TIBNKx2),3HE10869BA,(-),10,1,1,1\n Extension Shelf Kit (incl COSHF, UPBNK, FAN, TIBNKx2),3HE10477AA,(-),18,3,1,1\n,Extension Shelf Kit2 (incl COSHF2, UPBNK2, FAN2, TIBNKx22),3HE10869AAAA,(-),18,3,1,1\n,Extension Shelf Kit2 (incl COSHF3, UPBNK3, FAN3, TIBNKx33),3HE10869XX,(-),18,3,1,1\n,Extension Shelf Kit2 (incl COSHF2, UPBNK2, FAN2, TIBNKx22),3HE10869AAAA,(-),18,3,1,1\n,Extension Shelf Kit2 (incl COSHF3, UPBNK3, FAN3, TIBNKx33),3HE10869XX,(-),18,3,1,1';
	  
	  
	  
	  List <Account> account2 = NOKIA_CPQ_TestDataFactory.getAccounts(3);
	  account2[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  account2[1].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  account2[2].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  account2[2].Partner_Type__c = '';
	  account2[2].Partner_Program__c = '';
	  insert account2;
	  
	  product2 prod = new product2();
	  prod.name = 'A';
	  prod.CurrencyIsoCode = 'USD';
	  prod.Business_Group__c='MN';
	  prod.Family= 'A&A-CEM';
	  prod.IsActive=True;
	  prod.Partner_Visible__c=True;
	  prod.ProductCode='3HE10869BA';
	  prod.Apttus_Config2__Version__c= 1;
	  prod.Portfolio__c= 'Optics';
	  prod.Pricing_Clusters__c='NAM';
	  prod.IsActive= True;
	  insert prod;
	  
	  product2 prod1 = new product2();
	  prod1.name = 'A2';
	  prod1.CurrencyIsoCode = 'USD';
	  prod1.Business_Group__c='MN';
	  prod1.Family= 'A&A-CEM';
	  prod1.IsActive=True;
	  prod1.Partner_Visible__c=True;
	  prod1.ProductCode='3HE10869AAAA';
	  prod1.Apttus_Config2__Version__c= 1;
	  prod1.Portfolio__c= 'Optics';
	  prod1.Pricing_Clusters__c='NAM';
	  prod1.IsActive= True;
	  insert prod1;
	  
	  product2 prod3 = new product2();
	  prod3.name = 'A3';
	  prod3.CurrencyIsoCode = 'USD';
	  prod3.Business_Group__c='MN';
	  prod3.Family= 'A&A-CEM';
	  prod3.IsActive=True;
	  prod3.Partner_Visible__c=True;
	  prod3.ProductCode='3HE10869XX';
	  prod3.Apttus_Config2__Version__c= 1;
	  prod3.Portfolio__c= 'Optics';
	  prod3.Pricing_Clusters__c='NAM';
	  prod3.IsActive= True;
	  insert prod3;
	  
	  Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
		   Accreditation_Date__c = date.today(),
		   Accreditation_Level__c='Authorized',
		   Partner__c=account2[0].Id,
		   Portfolio__c='Optics',
		   Pricing_Cluster__c='NAM' 
		  );
	  Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
		   Accreditation_Date__c = date.today(),
		   Accreditation_Level__c='Authorized',
		   Partner__c=account2[0].Id,
		   Portfolio__c='Optics',
		   Pricing_Cluster__c='NAM' 
		  );
	  
	  insert accreditation1;
	  insert accreditation2;
	  
	  GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	  Test.StartTest();
	  List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(2,account2);
	  opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities[0].End_Customer_LE__c = account2[2].id;
	  opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	  opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities[1].End_Customer_LE__c = account2[2].id;
	  opportunities[1].Account_Role__c = 'GPP Distributor Partner';
	  opportunities[1].Name = 'ForSitePhase';
	  INSERT opportunities;
	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
	  insert ApttusTestPriceList;
	  
	   
	  Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
		Apttus_Proposal__Account__c = account2[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='',
		NokiaCPQ_Needs_Reprice__c = false,
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		NokiaCPQ_Portfolio__c = 'Optics',
		NokiaCPQ_Maintenance_Type__c =''
		
	  );
	  insert testProposal;
	  
	  Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c();
	  ProdConfig.Name = 'APTTUS Test Config'; 
	  ProdConfig.Apttus_QPConfig__Proposald__c = testProposal.id;
	  ProdConfig.Apttus_Config2__Status__c = 'Finalized';
	  ProdConfig.Apttus_Config2__VersionNumber__c = 1;
	  ProdConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
	  
	  insert ProdConfig;  
	  
	  NokiaCPQ_Site__c site = new NokiaCPQ_Site__c();
	  site.Opportunity__c = opportunities.get(0).Id;
	  site.name = 'test  test';
	  insert site;
	  String site1='1,1,1,1,1';
	  String site2='2,2,2,2,2';
	  ApexPages.currentPage().getParameters().put('id',testProposal.id);
	  EPT_productuploadscontroller puc = new  EPT_productuploadscontroller(new ApexPages.StandardController(testProposal));
	  puc.cartId = ProdConfig.Id;
	  puc.selectedSource = 'Wavelite';
	  puc.csvAsString = 'filename.csv';
	  puc.csvFileBody =  Blob.valueof(csvContent);
	  puc.getsourceType();
	  puc.setCSVFile();
	  puc.readFromFile();
	  puc.createcart();
	  puc.addProductsfromfile();
	  
	  puc.Reprice();
	  puc.getisCSV();
	  puc.Finalize();
	  puc.Saveconfig();
	  puc.addProducttoLineItem(ProdConfig.Id);
	  puc.addProductsToCart();
	  puc.selectedSource = 'Wavelite';
	  puc.csvAsString = 'filename2.csv';
	  puc.csvFileBody =  Blob.valueof(csvContent2);
	  puc.getsourceType();
	  puc.addSites(site1,site2);
	  puc.setCSVFile();
	  puc.readFromFile();
	  puc.aggregateDuplicates(puc.selectedProdDOList);
	  puc.selectedSource = 'Wavelite';
	  puc.csvAsString = 'filename.csv';
	  puc.csvFileBody =  Blob.valueof(csvContent2);
	  puc.getsourceType();
	  puc.setCSVFile();
	  puc.readFromFile();
	  puc.aggregateDuplicates(puc.selectedProdDOList);
	  
	  //Test.StopTest();
	  puc.returntoquote();
	  puc.returntocart();
	  Test.StopTest();
	  
	}
  }*/
  /*
  @isTest static void lineitemTest5(){
	List<user> runUSer = TestDataFactory.userCreation(1,'System Administrator');
  runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
  runUSer[0].NSA_Compliant__c = true;
  //database.insert(runUSer);
  system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
	  String csvContent = '"Acronym","Orderable Item","APN","Price","TOTALS","Pune","Mumbai","Delhi"\n ,"Main Shelf Kit (incl. COSHF, USRPNL, FAN, TIBNKx2)","3HE10869BA","(-)","10","1","1","1"\n "Extension Shelf Kit (incl COSHF, UPBNK, FAN, TIBNKx2)","3HE10477AA","(-)","18","3","1","1"\n,"Extension Shelf Kit2 (incl COSHF2, UPBNK2, FAN2, TIBNKx22)","3HE10869AAAA","(-)","18","3","1","1"\n,"Extension Shelf Kit2 (incl COSHF3, UPBNK3, FAN3, TIBNKx33)","3HE10869XX","(-)","18","3","1","1"';
	  
	  List <Account> account2 = NOKIA_CPQ_TestDataFactory.getAccounts(3);
	  account2[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  account2[1].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  account2[2].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  account2[2].Partner_Type__c = '';
	  account2[2].Partner_Program__c = '';
	  insert account2;
	  
	  product2 prod = new product2();
	  prod.name = 'A';
	  prod.CurrencyIsoCode = 'USD';
	  prod.Business_Group__c='MN';
	  prod.Family= 'A&A-CEM';
	  prod.IsActive=True;
	  prod.Partner_Visible__c=True;
	  prod.ProductCode='3HE10869BA';
	  prod.Apttus_Config2__Version__c= 1;
	  prod.Portfolio__c= 'Optics';
	  prod.Pricing_Clusters__c='NAM';
	  prod.IsActive= True;
	  insert prod;
	  
	  product2 prod1 = new product2();
	  prod1.name = 'A2';
	  prod1.CurrencyIsoCode = 'USD';
	  prod1.Business_Group__c='MN';
	  prod1.Family= 'A&A-CEM';
	  prod1.IsActive=True;
	  prod1.Partner_Visible__c=True;
	  prod1.ProductCode='3HE10869AAAA';
	  prod1.Apttus_Config2__Version__c= 1;
	  prod1.Portfolio__c= 'Optics';
	  prod1.Pricing_Clusters__c='NAM';
	  prod1.IsActive= True;
	  insert prod1;
	  
	  product2 prod3 = new product2();
	  prod3.name = 'A3';
	  prod3.CurrencyIsoCode = 'USD';
	  prod3.Business_Group__c='MN';
	  prod3.Family= 'A&A-CEM';
	  prod3.IsActive=True;
	  prod3.Partner_Visible__c=True;
	  prod3.ProductCode='3HE10869XX';
	  prod3.Apttus_Config2__Version__c= 1;
	  prod3.Portfolio__c= 'Optics';
	  prod3.Pricing_Clusters__c='NAM';
	  prod3.IsActive= True;
	  insert prod3;
	  
	  Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
		   Accreditation_Date__c = date.today(),
		   Accreditation_Level__c='Authorized',
		   Partner__c=account2[0].Id,
		   Portfolio__c='Optics',
		   Pricing_Cluster__c='NAM' 
		  );
	  Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
		   Accreditation_Date__c = date.today(),
		   Accreditation_Level__c='Authorized',
		   Partner__c=account2[0].Id,
		   Portfolio__c='Optics',
		   Pricing_Cluster__c='NAM' 
		  );
	  
	  insert accreditation1;
	  insert accreditation2;
	  
	  GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	  Test.StartTest();
	  List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(2,account2);
	  opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities[0].End_Customer_LE__c = account2[2].id;
	  opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	  opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities[1].End_Customer_LE__c = account2[2].id;
	  opportunities[1].Account_Role__c = 'GPP Distributor Partner';
	  opportunities[1].Name = 'ForSitePhase';
	  INSERT opportunities;
	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
	  insert ApttusTestPriceList;
	  
	  
	  Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
		Apttus_Proposal__Account__c = account2[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='',
		NokiaCPQ_Needs_Reprice__c = false,
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		NokiaCPQ_Portfolio__c = 'Optics',
		NokiaCPQ_Maintenance_Type__c =''
		
	  );
	  insert testProposal;
	  
	  Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c();
	  ProdConfig.Name = 'APTTUS Test Config'; 
	  ProdConfig.Apttus_QPConfig__Proposald__c = testProposal.id;
	  ProdConfig.Apttus_Config2__Status__c = 'Finalized';
	  ProdConfig.Apttus_Config2__VersionNumber__c = 1;
	  ProdConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
	  
	  insert ProdConfig;
		//surinder change 1***
	Apttus_Config2__LineItem__c li1 = new Apttus_Config2__LineItem__c(
	Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
	EPT_Sites__c='Pune,Mumbai,Dehi',
	EPT_Site_Quantity__c='1,2,3',
	Apttus_Config2__ItemSequence__c = 1,
	Apttus_Config2__LineNumber__c = 1,
	Apttus_Config2__PrimaryLineNumber__c = 1,
	Apttus_Config2__IsPrimaryLine__c = true,
	
	//product fields
	Apttus_Config2__ProductId__c = prod3.Id,
	Apttus_Config2__LineType__c = 'Product/Service',
	// Apttus_Config2__LineType__c = 'Option'
	Apttus_Config2__HasOptions__c = false,
	Apttus_Config2__Quantity__c = 1,	  

	//other fields
	Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
	Apttus_Config2__SellingTerm__c = 1,
	Apttus_Config2__LineStatus__c='New',
	Apttus_Config2__PriceMethod__c = 'Per Unit',
	Apttus_Config2__Frequency__c = 'One Time',
	Apttus_Config2__PricingStatus__c = 'Pending'	
	  );
		insert li1; 
		//surinder change 1 end
	  
	  NokiaCPQ_Site__c site = new NokiaCPQ_Site__c();
	  site.Opportunity__c = opportunities.get(0).Id;
	  site.name = 'test  test';
	  insert site;
	  
	  ApexPages.currentPage().getParameters().put('id',testProposal.id);
		//surinder change 2*****/
		/*
		list<Decimal> lineNumbers=new list<Decimal>();
		lineNumbers.add(1);	 
	  EPT_productuploadscontroller.createSitePhaseQty(ProdConfig.id,lineNumbers,opportunities.get(0).Id);
		//surinder cange 2 end
	  EPT_productuploadscontroller puc = new  EPT_productuploadscontroller(new ApexPages.StandardController(testProposal));
	  puc.cartId = ProdConfig.Id;
	  puc.selectedSource = 'Wavelite';
	  puc.csvAsString = 'filename.csv';
	  puc.csvFileBody =  Blob.valueof(csvContent);
	  puc.getsourceType();
	  puc.setCSVFile();
	  puc.readFromFile();
	  puc.createcart();
	  puc.addProductsfromfile();
	  
	  puc.Reprice();
	  puc.getisCSV();
	  puc.Finalize();
	  puc.Saveconfig();
	  puc.addProducttoLineItem(ProdConfig.Id);
	  puc.addProductsToCart();
	  //Test.StopTest();
	  puc.returntoquote();
	  puc.returntocart();
	  puc.notfoundprdct('test1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCode');
	  Test.StopTest();
	}
  } */
  /*
  @isTest static void lineitemTest6(){
	List<user> runUSer = TestDataFactory.userCreation(1,'System Administrator');
  runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
  runUSer[0].NSA_Compliant__c = true;
  //database.insert(runUSer);
  system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
	  String csvContent = '"Acronym","Orderable Item","APN","Price","TOTALS","Pune","Mumbai","Delhi"\n ,"Main Shelf Kit (incl. COSHF, USRPNL, FAN, TIBNKx2)","3HE10869BA","(-)","10","1","1","1"\n "Extension Shelf Kit (incl COSHF, UPBNK, FAN, TIBNKx2)","3HE10477LLLL","(-)","18","3","1","1"\n,"Extension Shelf Kit2 (incl COSHF2, UPBNK2, FAN2, TIBNKx22)","3HE10869LLLL","(-)","18","3","1","1"\n,"Extension Shelf Kit2 (incl COSHF3, UPBNK3, FAN3, TIBNKx33)","3HE10869LLLL","(-)","18","3","1","1"';
	  //String csvContent = '';
	  List <Account> account2 = NOKIA_CPQ_TestDataFactory.getAccounts(3);
	  account2[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  account2[1].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  account2[2].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  account2[2].Partner_Type__c = '';
	  account2[2].Partner_Program__c = '';
	  insert account2;
	  
	  product2 prod = new product2();
	  prod.name = 'A';
	  prod.CurrencyIsoCode = 'USD';
	  prod.Business_Group__c='MN';
	  prod.Family= 'A&A-CEM';
	  prod.IsActive=True;
	  prod.Partner_Visible__c=True;
	  prod.ProductCode='3HE10869BALL';
	  prod.Apttus_Config2__Version__c= 1;
	  prod.Portfolio__c= 'Optics';
	  prod.Pricing_Clusters__c='NAM';
	  prod.IsActive= True;
	  insert prod;
	  
	  product2 prod1 = new product2();
	  prod1.name = 'A2';
	  prod1.CurrencyIsoCode = 'USD';
	  prod1.Business_Group__c='MN';
	  prod1.Family= 'A&A-CEM';
	  prod1.IsActive=True;
	  prod1.Partner_Visible__c=True;
	  prod1.ProductCode='3HE10869LLLL';
	  prod1.Apttus_Config2__Version__c= 1;
	  prod1.Portfolio__c= 'Optics';
	  prod1.Pricing_Clusters__c='NAM';
	  prod1.IsActive= True;
	  insert prod1;
	  
	  product2 prod3 = new product2();
	  prod3.name = 'A3';
	  prod3.CurrencyIsoCode = 'USD';
	  prod3.Business_Group__c='MN';
	  prod3.Family= 'A&A-CEM';
	  prod3.IsActive=True;
	  prod3.Partner_Visible__c=True;
	  prod3.ProductCode='3HE10869LLLL';
	  prod3.Apttus_Config2__Version__c= 1;
	  prod3.Portfolio__c= 'Optics';
	  prod3.Pricing_Clusters__c='NAM';
	  prod3.IsActive= True;
	  insert prod3;
	  
	  Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
		   Accreditation_Date__c = date.today(),
		   Accreditation_Level__c='Authorized',
		   Partner__c=account2[0].Id,
		   Portfolio__c='Optics',
		   Pricing_Cluster__c='NAM' 
		  );
	  Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
		   Accreditation_Date__c = date.today(),
		   Accreditation_Level__c='Authorized',
		   Partner__c=account2[0].Id,
		   Portfolio__c='Optics',
		   Pricing_Cluster__c='NAM' 
		  );
	  
	  insert accreditation1;
	  insert accreditation2;
	  
	  GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	  Test.StartTest();
	  List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(2,account2);
	  opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities[0].End_Customer_LE__c = account2[2].id;
	  opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	  opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities[1].End_Customer_LE__c = account2[2].id;
	  opportunities[1].Account_Role__c = 'GPP Distributor Partner';
	  opportunities[1].Name = 'ForSitePhase';
	  INSERT opportunities;
	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
	  insert ApttusTestPriceList;
	  
	  
	  Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
		Apttus_Proposal__Account__c = account2[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='',
		NokiaCPQ_Needs_Reprice__c = false,
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		NokiaCPQ_Portfolio__c = 'Optics',
		NokiaCPQ_Maintenance_Type__c =''
		
	  );
	  insert testProposal;
	  
	  Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c();
	  ProdConfig.Name = 'APTTUS Test Config'; 
	  ProdConfig.Apttus_QPConfig__Proposald__c = testProposal.id;
	  ProdConfig.Apttus_Config2__Status__c = 'Finalized';
	  ProdConfig.Apttus_Config2__VersionNumber__c = 1;
	  ProdConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
	  
	  insert ProdConfig;
		//surinder change 1***
	Apttus_Config2__LineItem__c li1 = new Apttus_Config2__LineItem__c(
	Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
	EPT_Sites__c='Pune,Mumbai,Dehi',
	EPT_Site_Quantity__c='1,2,3',
	Apttus_Config2__ItemSequence__c = 1,
	Apttus_Config2__LineNumber__c = 1,
	Apttus_Config2__PrimaryLineNumber__c = 1,
	Apttus_Config2__IsPrimaryLine__c = true,
	
	//product fields
	Apttus_Config2__ProductId__c = prod3.Id,
	Apttus_Config2__LineType__c = 'Product/Service',
	// Apttus_Config2__LineType__c = 'Option'
	Apttus_Config2__HasOptions__c = false,
	Apttus_Config2__Quantity__c = 1,	  

	//other fields
	Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
	Apttus_Config2__SellingTerm__c = 1,
	Apttus_Config2__LineStatus__c='New',
	Apttus_Config2__PriceMethod__c = 'Per Unit',
	Apttus_Config2__Frequency__c = 'One Time',
	Apttus_Config2__PricingStatus__c = 'Pending'	
	  );
		insert li1; 
		//surinder change 1 end
	  
	  NokiaCPQ_Site__c site = new NokiaCPQ_Site__c();
	  site.Opportunity__c = opportunities.get(0).Id;
	  site.name = 'test  test';
	  insert site;
	  
	  ApexPages.currentPage().getParameters().put('id',testProposal.id);
		//surinder change 2*****/
		/*
		list<Decimal> lineNumbers=new list<Decimal>();
		lineNumbers.add(1);	 
	  EPT_productuploadscontroller.createSitePhaseQty(ProdConfig.id,lineNumbers,opportunities.get(0).Id);
		//surinder cange 2 end
	  EPT_productuploadscontroller puc = new  EPT_productuploadscontroller(new ApexPages.StandardController(testProposal));
	  puc.cartId = ProdConfig.Id;
	  puc.selectedSource = 'Wavelit';
	  puc.csvAsString = 'filename.cs';
	  puc.csvFileBody =  Blob.valueof(csvContent);
	  puc.getsourceType();
	  puc.setCSVFile();
	  puc.readFromFile();
	  puc.createcart();
	  puc.addProductsfromfile();
	  
	  puc.Reprice();
	  puc.getisCSV();
	  puc.Finalize();
	  puc.Saveconfig();
	  puc.addProducttoLineItem(ProdConfig.Id);
	  puc.addProductsToCart();
	  //Test.StopTest();
	  puc.returntoquote();
	  puc.returntocart();
	  puc.notfoundprdct('test1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCode');
	  
	  puc.csvAsString = null;
	  puc.readFromFile();
	  
	  puc.csvAsString = 'test123';
	  puc.readFromFile();
	  puc.addSites('test,test1','test1,test2,test3');
	  Test.StopTest();
	  
	}
  } */
  /*
   @isTest static void lineitemTest7(){
	List<user> runUSer = TestDataFactory.userCreation(1,'System Administrator');
  runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
  runUSer[0].NSA_Compliant__c = true;
  //database.insert(runUSer);
  system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
	  String csvContent = '"Acronym","Orderable Item","APN","Price","TOTALS","Pune","Mumbai","Delhi"\n ,"Main Shelf Kit (incl. COSHF, USRPNL, FAN, TIBNKx2)","3HE10869BA","(-)","10","1","1","1"\n "Extension Shelf Kit (incl COSHF, UPBNK, FAN, TIBNKx2)","3HE10477AA","(-)","18","3","1","1"\n,"Extension Shelf Kit2 (incl COSHF2, UPBNK2, FAN2, TIBNKx22)","3HE10869AAAA","(-)","18","3","1","1"\n,"Extension Shelf Kit2 (incl COSHF3, UPBNK3, FAN3, TIBNKx33)","3HE10869XX","(-)","18","3","1","1"';
	  
	  List <Account> account2 = NOKIA_CPQ_TestDataFactory.getAccounts(3);
	  account2[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  account2[1].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  account2[2].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  account2[2].Partner_Type__c = '';
	  account2[2].Partner_Program__c = '';
	  insert account2;
	  
	  product2 prod = new product2();
	  prod.name = 'A';
	  prod.CurrencyIsoCode = 'USD';
	  prod.Business_Group__c='MN';
	  prod.Family= 'A&A-CEM';
	  prod.IsActive=True;
	  prod.Partner_Visible__c=True;
	  prod.ProductCode='3HE10869BALL';
	  prod.Apttus_Config2__Version__c= 1;
	  prod.Portfolio__c= 'Optics';
	  prod.Pricing_Clusters__c='NAM';
	  prod.IsActive= True;
	  insert prod;
	  
	  product2 prod1 = new product2();
	  prod1.name = 'A2';
	  prod1.CurrencyIsoCode = 'USD';
	  prod1.Business_Group__c='MN';
	  prod1.Family= 'A&A-CEM';
	  prod1.IsActive=True;
	  prod1.Partner_Visible__c=True;
	  prod1.ProductCode='3HE10869LLLL';
	  prod1.Apttus_Config2__Version__c= 1;
	  prod1.Portfolio__c= 'Optics';
	  prod1.Pricing_Clusters__c='NAM';
	  prod1.IsActive= True;
	  insert prod1;
	  
	  product2 prod3 = new product2();
	  prod3.name = 'A3';
	  prod3.CurrencyIsoCode = 'USD';
	  prod3.Business_Group__c='MN';
	  prod3.Family= 'A&A-CEM';
	  prod3.IsActive=True;
	  prod3.Partner_Visible__c=True;
	  prod3.ProductCode='3HE10869LLLL';
	  prod3.Apttus_Config2__Version__c= 1;
	  prod3.Portfolio__c= 'Optics';
	  prod3.Pricing_Clusters__c='NAM';
	  prod3.IsActive= True;
	  insert prod3;
	  
	  Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
		   Accreditation_Date__c = date.today(),
		   Accreditation_Level__c='Authorized',
		   Partner__c=account2[0].Id,
		   Portfolio__c='Optics',
		   Pricing_Cluster__c='NAM' 
		  );
	  Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
		   Accreditation_Date__c = date.today(),
		   Accreditation_Level__c='Authorized',
		   Partner__c=account2[0].Id,
		   Portfolio__c='Optics',
		   Pricing_Cluster__c='NAM' 
		  );
	  
	  insert accreditation1;
	  insert accreditation2;
	  
	  GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	  Test.StartTest();
	  List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(2,account2);
	  opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities[0].End_Customer_LE__c = account2[2].id;
	  opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	  opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities[1].End_Customer_LE__c = account2[2].id;
	  opportunities[1].Account_Role__c = 'GPP Distributor Partner';
	  opportunities[1].Name = 'ForSitePhase';
	  INSERT opportunities;
	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
	  insert ApttusTestPriceList;
	  
	  
	  Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
		Apttus_Proposal__Account__c = account2[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='',
		NokiaCPQ_Needs_Reprice__c = false,
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		NokiaCPQ_Portfolio__c = 'Optics',
		NokiaCPQ_Maintenance_Type__c =''
		
	  );
	  insert testProposal;
	  
	  Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c();
	  ProdConfig.Name = 'APTTUS Test Config'; 
	  ProdConfig.Apttus_QPConfig__Proposald__c = testProposal.id;
	  ProdConfig.Apttus_Config2__Status__c = 'Finalized';
	  ProdConfig.Apttus_Config2__VersionNumber__c = 1;
	  ProdConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
	  
	  insert ProdConfig;
		//surinder change 1***
	Apttus_Config2__LineItem__c li1 = new Apttus_Config2__LineItem__c(
	Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
	EPT_Sites__c='Pune,Mumbai,Dehi',
	EPT_Site_Quantity__c='1,2,3',
	Apttus_Config2__ItemSequence__c = 1,
	Apttus_Config2__LineNumber__c = 1,
	Apttus_Config2__PrimaryLineNumber__c = 1,
	Apttus_Config2__IsPrimaryLine__c = true,
	
	//product fields
	Apttus_Config2__ProductId__c = prod3.Id,
	Apttus_Config2__LineType__c = 'Product/Service',
	// Apttus_Config2__LineType__c = 'Option'
	Apttus_Config2__HasOptions__c = false,
	Apttus_Config2__Quantity__c = 1,	  

	//other fields
	Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
	Apttus_Config2__SellingTerm__c = 1,
	Apttus_Config2__LineStatus__c='New',
	Apttus_Config2__PriceMethod__c = 'Per Unit',
	Apttus_Config2__Frequency__c = 'One Time',
	Apttus_Config2__PricingStatus__c = 'Pending'	
	  );
		insert li1; 
		//surinder change 1 end
	  
	  NokiaCPQ_Site__c site = new NokiaCPQ_Site__c();
	  site.Opportunity__c = opportunities.get(0).Id;
	  site.name = 'test  test';
	  insert site;
	  
	  ApexPages.currentPage().getParameters().put('id',testProposal.id);
		//surinder change 2*****/
		/*
		list<Decimal> lineNumbers=new list<Decimal>();
		lineNumbers.add(1);	 
	  EPT_productuploadscontroller.createSitePhaseQty(ProdConfig.id,lineNumbers,opportunities.get(0).Id);
		//surinder cange 2 end
	  EPT_productuploadscontroller puc = new  EPT_productuploadscontroller(new ApexPages.StandardController(testProposal));
	  puc.cartId = ProdConfig.Id;
	  puc.selectedSource = 'Wavelite';
	  puc.csvAsString = 'filename.csv';
	  puc.csvFileBody =  Blob.valueof(csvContent);
	  puc.getsourceType();
	  puc.setCSVFile();
	  puc.readFromFile();
	  puc.createcart();
	  puc.addProductsfromfile();
	  
	  puc.Reprice();
	  puc.getisCSV();
	  puc.Finalize();
	  puc.Saveconfig();
	  puc.addProducttoLineItem(ProdConfig.Id);
	  puc.addProductsToCart();
	  //Test.StopTest();
	  puc.returntoquote();
	  puc.returntocart();
	  puc.notfoundprdct('test1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCode');
	  Test.StopTest();
	  
	}
  }*/
  @isTest static void lineitemTest8(){
	List<user> runUSer = TestDataFactory.userCreation(1,'System Administrator');
  runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
  runUSer[0].NSA_Compliant__c = true;
  database.insert(runUSer);
  system.runAs(runUSer[0]){
	Nokia_CPQ_Constants.isCloneRun = true;
	 // String csvContent = ''Acronym','Orderable Item','APN','Price','TOTALS','Pune','Mumbai','Delhi'\n ,'Main Shelf Kit (incl. COSHF, USRPNL, FAN, TIBNKx2)','3HE10869BA','(-)','10','1'\n 'Extension Shelf Kit (incl COSHF, UPBNK, FAN, TIBNKx2)','3HE10477AA','(-)','18','3','1','1'\n,'Extension Shelf Kit2 (incl COSHF2, UPBNK2, FAN2, TIBNKx22)','3HE10869AAAA','(-)','18','3','1','1'\n,'Extension Shelf Kit2 (incl COSHF3, UPBNK3, FAN3, TIBNKx33)','1'';
	   String csvContent = '"Acronym","csv","Orderable Item","APN","Price","TOTALS","Pune","Mumbai","Delhi"\n ,"Main Shelf Kit (incl. COSHF. USRPNL. FAN, TIBNKx2)","3HE10869BA","(-)","10","1","1","1"\n ,"Extension Shelf Kit (incl COSHF- UPBNK- FAN- TIBNKx2)","3HE10477AA","(-)","18","3","1","1"\n,"Extension Shelf Kit2 (incl COSHF2, UPBNK2, FAN2, TIBNKx22)","3HE10869AAAA","(-)","18","3","1","1"\n,"Extension Shelf Kit2 (incl COSHF3, UPBNK3, FAN3, TIBNKx33)","3HE10869XX","(-)","18","3","1","1"';
	   String csvContent2 = '"Acronym","csv","Orderable Item","APN","Price","TOTALS","Pune","Mumbai","Delhi"\n"Main Shelf Kit (incl. COSHF. USRPNL. FAN. TIBNKx2)","3HE10869BA","1","10","1","1","1"\n"Extension Shelf Kit (incl COSHF, UPBNK, FAN, TIBNKx2)","3HE10477AA","1","18","3","1","1"\n"Extension Shelf Kit2 (incl COSHF2, UPBNK2, FAN2, TIBNKx22)","3HE10869AAAA","1","18","3","1","1"\n"Extension Shelf Kit2 (incl COSHF3, UPBNK3, FAN3, TIBNKx33)","3HE10869XX","1","18","3","1","1"';
	   String csvContent3 = 'Acronym;Orderable Item;APN,Price,TOTALS,Pune,Mumbai,Delhi\n ,Main Shelf Kit (incl. COSHF. USRPNL. FAN. TIBNKx2),3HE10869B7,(-),10,1,1,1\n ,Extension Shelf Kit (incl COSHF. UPBNK. FAN. TIBNKx2),3HE10477AA,(-),18,3,1,1\n,Extension Shelf Kit2 (incl COSHF2, UPBNK2, FAN2, TIBNKx22),3HE10869AAAA,(-),18,3,1,1\n,Extension Shelf Kit2 (incl COSHF3, UPBNK3, FAN3, TIBNKx33),3HE10869XX,(-);18;3;1;1';
	   String csvContent4 = '"Acronym","csv","Orderable Item","APN","Price","TOTALS","Pune","Mumbai","Delhi"\n ,"Main Shelf Kit (incl. COSHF. USRPNL. FAN, TIBNKx2)","3HE10869BA","(-)","10","1","1","1"\n ,"Extension Shelf Kit (incl COSHF- UPBNK- FAN- TIBNKx2)","3HE10477AA","(-)","18","3","1","1"\n,"Extension Shelf Kit2 (incl COSHF2, UPBNK2, FAN2, TIBNKx22)","3HE10869AAAA","(-)","18","3","1","1"\n,"Extension Shelf Kit2 (incl COSHF3, UPBNK3, FAN3, TIBNKx33)","3HE10869XX","(-)","18","3","1","1"';

	   //String csvContent = '"Acronym",3HE10869BA,(-),10,1,1,1\n COEKIT,3HE10477AA,(-),18,3,1,1\n  COEKIT2,3HE10869AAAA,(-),18,3,1,1\n COEKIT3,3HE10869XX,(-),18,3,1,1';
	  List <Account> account2 = NOKIA_CPQ_TestDataFactory.getAccounts(3);
	  account2[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  account2[1].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	  account2[2].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  account2[2].Partner_Type__c = '';
	  account2[2].Partner_Program__c = '';
	  insert account2;
	  
	  product2 prod = new product2();
	  prod.name = 'A';
	  prod.CurrencyIsoCode = 'USD';
	  prod.Business_Group__c='MN';
	  prod.Family= 'A&A-CEM';
	  prod.IsActive=True;
	  prod.Partner_Visible__c=True;
	  prod.ProductCode='3HE10869BA';
	  prod.Apttus_Config2__Version__c= 1;
	  prod.Portfolio__c= 'Optics';
	  prod.Pricing_Clusters__c='NAM';
	  prod.IsActive= True;
	  insert prod;
	  
	  product2 prod1 = new product2();
	  prod1.name = 'A2';
	  prod1.CurrencyIsoCode = 'USD';
	  prod1.Business_Group__c='MN';
	  prod1.Family= 'A&A-CEM';
	  prod1.IsActive=True;
	  prod1.Partner_Visible__c=True;
	  prod1.ProductCode='3HE10869AAAA';
	  prod1.Apttus_Config2__Version__c= 1;
	  prod1.Portfolio__c= 'Optics';
	  prod1.Pricing_Clusters__c='NAM';
	  prod1.IsActive= True;
	  insert prod1;
	  
	  product2 prod3 = new product2();
	  prod3.name = 'A3';
	  prod3.CurrencyIsoCode = 'USD';
	  prod3.Business_Group__c='MN';
	  prod3.Family= 'A&A-CEM';
	  prod3.IsActive=True;
	  prod3.Partner_Visible__c=True;
	  prod3.ProductCode='3HE10869XX';
	  prod3.Apttus_Config2__Version__c= 1;
	  prod3.Portfolio__c= 'Optics';
	  prod3.Pricing_Clusters__c='NAM';
	  prod3.IsActive= True;
	  insert prod3;
	  product2 prod4 = new product2();
	  prod4.name = 'A4';
	  prod4.CurrencyIsoCode = 'USD';
	  prod4.Business_Group__c='MN';
	  prod4.Family= 'A&A-CEM';
	  prod4.IsActive=True;
	  prod4.Partner_Visible__c=True;
	  prod4.ProductCode='3HE10477AAAA';
	  prod4.Apttus_Config2__Version__c= 1;
	  prod4.Portfolio__c= 'Optics';
	  prod4.Pricing_Clusters__c='NAM';
	  prod4.IsActive= True;
	  insert prod4;
	  
	  Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
		   Accreditation_Date__c = date.today(),
		   Accreditation_Level__c='Authorized',
		   Partner__c=account2[0].Id,
		   Portfolio__c='Optics',
		   Pricing_Cluster__c='NAM' 
		  );
	  Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
		   Accreditation_Date__c = date.today(),
		   Accreditation_Level__c='Authorized',
		   Partner__c=account2[0].Id,
		   Portfolio__c='Optics',
		   Pricing_Cluster__c='NAM' 
		  );
	  
	  insert accreditation1;
	  insert accreditation2;
	  
	  GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	  Test.StartTest();
	  List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(2,account2);
	  opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities[0].End_Customer_LE__c = account2[2].id;
	  opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	  opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities[1].End_Customer_LE__c = account2[2].id;
	  opportunities[1].Account_Role__c = 'GPP Distributor Partner';
	  opportunities[1].Name = 'ForSitePhase';
	  INSERT opportunities;
	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
	  insert ApttusTestPriceList;
	  
	  
	  Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
		Apttus_Proposal__Account__c = account2[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='',
		NokiaCPQ_Needs_Reprice__c = false,
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		NokiaCPQ_Portfolio__c = 'Optics',
		
		NokiaCPQ_Maintenance_Type__c =''
		
	  );
	  insert testProposal;
	  
	  Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c();
	  ProdConfig.Name = 'APTTUS Test Config'; 
	  ProdConfig.Apttus_QPConfig__Proposald__c = testProposal.id;
	  ProdConfig.Apttus_Config2__Status__c = 'Finalized';
	  ProdConfig.Apttus_Config2__VersionNumber__c = 1;
	  ProdConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
	  
	  insert ProdConfig;
		//surinder change 1***
	Apttus_Config2__LineItem__c li1 = new Apttus_Config2__LineItem__c(
	Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
	EPT_Sites__c='Pune,Mumbai,Dehi',
	EPT_Site_Quantity__c='1,2,3',
	Apttus_Config2__ItemSequence__c = 1,
	Apttus_Config2__LineNumber__c = 1,
	Apttus_Config2__PrimaryLineNumber__c = 1,
	Apttus_Config2__IsPrimaryLine__c = true,
	
	//product fields
	Apttus_Config2__ProductId__c = prod3.Id,
	Apttus_Config2__LineType__c = 'Product/Service',
	// Apttus_Config2__LineType__c = 'Option'
	Apttus_Config2__HasOptions__c = false,
	Apttus_Config2__Quantity__c = 1,	  

	//other fields
	Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
	Apttus_Config2__SellingTerm__c = 1,
	Apttus_Config2__LineStatus__c='New',
	Apttus_Config2__PriceMethod__c = 'Per Unit',
	Apttus_Config2__Frequency__c = 'One Time',
	Apttus_Config2__PricingStatus__c = 'Pending'	
	  );
		insert li1; 
		//surinder change 1 end
	  
		Apttus_Config2__LineItem__c li2 = new Apttus_Config2__LineItem__c(
		  Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		  EPT_Sites__c='Pune,Mumbai,Dehi',
		  EPT_Site_Quantity__c='1,2,3',
		  Apttus_Config2__ItemSequence__c = 1,
		  Apttus_Config2__LineNumber__c = 1,
		  Apttus_Config2__PrimaryLineNumber__c = 1,
		  Apttus_Config2__IsPrimaryLine__c = true,
		  
		  //product fields
		  Apttus_Config2__ProductId__c = prod3.Id,
		  Apttus_Config2__LineType__c = 'Product/Service',
		  // Apttus_Config2__LineType__c = 'Option'
		  Apttus_Config2__HasOptions__c = false,
		  Apttus_Config2__Quantity__c = 1,	  
	  
		  //other fields
		  Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		  Apttus_Config2__SellingTerm__c = 1,
		  Apttus_Config2__LineStatus__c='New',
		  Apttus_Config2__PriceMethod__c = 'Per Unit',
		  Apttus_Config2__Frequency__c = 'One Time',
		  Apttus_Config2__PricingStatus__c = 'Pending'  ,
		  Source__c='Wavelite'  
			);
			  insert li2; 
	  NokiaCPQ_Site__c site = new NokiaCPQ_Site__c();
	  site.Opportunity__c = opportunities.get(0).Id;
	  site.name = 'APN';
	  insert site;
	  
	  ApexPages.currentPage().getParameters().put('id',testProposal.id);
		//surinder change 2*****/
		list<Decimal> lineNumbers=new list<Decimal>();
		lineNumbers.add(1);	 
	  EPT_productuploadscontroller.createSitePhaseQty(ProdConfig.id,lineNumbers,opportunities.get(0).Id);
		//surinder cange 2 end
	  EPT_productuploadscontroller puc = new  EPT_productuploadscontroller(new ApexPages.StandardController(testProposal));
	  puc.cartId = ProdConfig.Id;
	  puc.selectedSource = 'Wavelite';
	  puc.csvAsString = 'filename.csv';
	  puc.csvFileBody =  Blob.valueof(csvContent);
	  puc.getsourceType();
	  puc.readFromFile();
	  puc.readCSVFile();
	  
	  
	  
	  
	  puc.createcart();
	  puc.addProductsfromfile();
	  puc.aggregateDuplicates(puc.selectedProdDOList);
	  puc.Reprice();
	  puc.getisCSV();
	  puc.Finalize();
	  puc.Saveconfig();
	  puc.addProducttoLineItem(ProdConfig.Id);
	  puc.addProductsToCart();
	  puc.addSites('test,test1','test1,test2,test3');
	  puc.returntoquote();
	  puc.returntocart();
	  puc.notfoundprdct('test1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCodetest1ProductCode');
	  puc.removedelimier(',','csvFileLines,csv');
	  puc.setCSVFile();
	  //puc.readCSVFile();
	  puc.cartId = ProdConfig.Id;
	  puc.selectedSource = 'Wavelite';
	  puc.csvAsString = 'filename.csv';
	  puc.csvFileBody =  Blob.valueof(csvContent2);
	  puc.addSites('1test,1test1','2test1,2test2');
	  puc.readFromFile();
	  puc.readCSVFile();
	  puc.cartId = ProdConfig.Id;
	  puc.selectedSource = 'Wavelite';
	  puc.csvAsString = 'filename.csv';
	  puc.csvFileBody =  Blob.valueof(csvContent3);
	  puc.readFromFile();
	  puc.readCSVFile();
	  puc.csvAsString = null;
	  puc.readFromFile();
	  
	  puc.csvAsString = 'test123';
	  puc.readFromFile();
	 
	  Test.StopTest();
	}
  }  
  
  
}