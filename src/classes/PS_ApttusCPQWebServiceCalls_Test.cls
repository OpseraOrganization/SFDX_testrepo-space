@isTest
private class PS_ApttusCPQWebServiceCalls_Test {

	private static List<Account> accountList = new List<Account>();
	private static List<Opportunity> opportunityList = new List<Opportunity>();
	public static String[] csvFileLines;
	public static Blob csvFileBody;
	static String str = 'Name,AccountNumber,Type,Accountsource,Industry\n Esha Patharabe,10001,Prospect,Test,Banking\n Trupti Nimje,10002,Prospect,Test,Banking';

	@isTest static void lineitemTest10(){
	String csvContent = '/n /n ProductCode,Quantity,SiteName\n3EC17929UA,1,A B\n3FE31189BA,1,BC\n301049607,1,C D\n3HE06970AA,1,D E\n3FE31189BA,1,E F\n301049607,1,F G';
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
	opportunities1[0].G3_Planned_Date__c =  Date.Today();
	opportunities1[0].G4_Planned_Date__c =  Date.Today();
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
	prod.QuantityUnitOfMeasure= 'Each';
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

	//create a quote with non-euro currency
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = account3[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
	proposals[0].CurrencyIsoCode = 'USD'; 
	proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = true;
	proposals[0].Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id;
	proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(); //direct quote
	insert proposals;	

	PS_ApttusCPQWebServiceCalls puc = new  PS_ApttusCPQWebServiceCalls();
	Apttus_Config2__ProductConfiguration__c pconfig = new Apttus_Config2__ProductConfiguration__c();
	pconfig.Id = puc.CreateApttusCart(proposals[0].Id);
	puc.addMultiProductsfromfile(new map<Id,Decimal>{prod.Id => 2}, pconfig.Id);

	Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c();
	LineItem1 = [SELECT Id,Name FROM Apttus_Config2__LineItem__c LIMIT 1];
	
	puc.updateMaintenanceLineItem(pconfig.Id);
	puc.RepriceProposal(pconfig.Id);
	puc.saveCart(pconfig.Id);
	puc.Finalizeproposal(pconfig.Id);

	test.stopTest();
	}
}