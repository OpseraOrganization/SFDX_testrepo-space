/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 03-01-2022
 * @last modified by  : Yashdeep Prajapati
 **/
@isTest
public class NokiaCPQ_Validate_Quote_CtrlrTest {
	
static List<Pre_Approved_Custom_Products__c> preApprovedProducts;
static List<Account> accountsList;
static Apttus_Config2__PriceList__c priceList;
static list<product2> productsList;
static list<Apttus_Config2__PriceListItem__c> pli = new list<Apttus_Config2__PriceListItem__c>();
static List<opportunity> opportunities = new list<opportunity>();
static List<Apttus_Proposal__Proposal__c > proposals = new List<Apttus_Proposal__Proposal__c >();
static List<Apttus_Config2__ProductConfiguration__c> pConfigList = new List<Apttus_Config2__ProductConfiguration__c>();

@testSetup static void dataSetup() {
	id profileId = [SELECT Id FROM profile WHERE name = 'PRM Partner Community User Login'].Id;
	String uniqueName = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') + Integer.valueOf(math.rint(math.random()*1000000));
	List<user> runAsUSer = new List<user>();
	runAsUSer = TestDataFactory.userCreation(2,'Data Loader Profile');
	runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runAsUSer[0].NSA_Compliant__c = true;
	runAsUSer[0].Nokia_ID__c= '6777777666';
	database.insert(runAsUSer);
	User userSO = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
	system.runAs(runAsUSer[0]){
		Nokia_CPQ_Constants.isCloneRun = true;
		accountsList = NOKIA_CPQ_TestDataFactory.getAccounts(3);
		accountsList[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accountsList[1].AccountNumber='';
		accountsList[0].CurrencyIsoCode = 'EUR';
		accountsList[1].Partner_Type__c = '';
		accountsList[1].Partner_Program__c = '';
		accountsList[2].CurrencyIsoCode = 'EUR';
		database.insert(accountsList);
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountsList[0].id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		createPortalUser();

		preApprovedProducts = new List<Pre_Approved_Custom_Products__c>();
		Pre_Approved_Custom_Products__c preApprovedProductsRecord1 = new Pre_Approved_Custom_Products__c(Account__c=accountsList[2].Id,Expiration_Date__c=System.Today(),Is_NSP__c=true,List_Price__c=5.0,Maintenance_Beyond_Warranty_Rate__c=1.0,Maintenance_Type__c='Gold (Return for Exchange)',Maintenance_Under_Warranty_Rate__c=2.0,Portfolio__c='Microwave',Product_Code__c='PROD1',Product_Discount_Rate__c=3.0,SSP_Rate__c=4.0);
		preApprovedProducts.add(preApprovedProductsRecord1);

		insert preApprovedProducts;
		
		

		priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='EUR';
		priceList.Apttus_Config2__Active__c=true;
		priceList.Apttus_Config2__BasedOnPriceListId__c = null;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		priceList.PriceList_Type__c = 'CPQ';
		insert priceList;

		productsList = NOKIA_CPQ_TestDataFactory.productCreation(3);
		productsList[2].IsActive=false;
		insert productsList;

		Apttus_Config2__PriceListItem__c pli1 = new Apttus_Config2__PriceListItem__c();
		pli1.Apttus_Config2__PriceListId__c = priceList.Id;
		pli1.Apttus_Config2__ProductId__c = productsList[0].Id;
		pli1.Apttus_Config2__Active__c = true;
		pli.add(pli1);
		Apttus_Config2__PriceListItem__c pli2 = new Apttus_Config2__PriceListItem__c();
		pli2.Apttus_Config2__PriceListId__c = priceList.Id;
		pli2.Apttus_Config2__ProductId__c = productsList[1].Id;
		pli2.Apttus_Config2__Active__c = true;
		pli.add(pli2);
		insert pli;

		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(4);
		accreditations[2].Portfolio__c = 'Microwave';
		accreditations[3].Portfolio__c = 'Microwave';
		accreditations[0].partner__c = accountsList[0].Id;
		accreditations[1].partner__c = accountsList[0].Id;
		accreditations[2].partner__c = accountsList[0].Id;
		accreditations[3].partner__c = accountsList[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';
		accreditations[3].Accreditation_Type__c = 'Maintenance';
		accreditations[3].Accreditation_Level__c = 'Premium';
		accreditations[3].Pricing_Level_Override__c = 'Premium';

		insert accreditations;

		List<Opportunity> opptyRecord = createOpportunities();
		Offer__c offerIndirect = TestDataFactory.OfferCreation(1, opptyRecord[0])[0];
		insert offerIndirect;
		Offer__c offerDirect = TestDataFactory.OfferCreation(1, opptyRecord[1])[0];
		insert offerDirect;
		Offer__c offerIndirect_Authorized = TestDataFactory.OfferCreation(1, opptyRecord[3])[0];
		offerIndirect_Authorized.Authorized_for_Pricing_Manager__c= true;
		offerIndirect_Authorized.ActiveOffer__c=true;
		//offerIndirect_Authorized.Expected_LoA_G4_Approval_Level__c = 'A';
		//offerIndirect_Authorized.No_LoA__c=true;
		insert offerIndirect_Authorized;
		test.startTest();
		createProposals();
		createConfigurationsAndLineitems();
		test.stopTest();
	}

}
static user createPortalUser() {
	User userSO = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
	userSO.UserRoleId  = system.Label.Global_Role_ID;
	userSO.NSA_Compliant__c = true;
	user portalUser;
	system.runAs(userSO) {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		Id profileId = [SELECT Id FROM profile WHERE name ='PRM Partner Community User Login' limit 1].Id;
		Id roleId = [SELECT Id,PortalType FROM userrole WHERE PortalType='Partner' AND PortalRole = 'Manager' LIMIT 1].Id;
		portalUser = new User( email='test.fdsfves4@gmail.com',
						 profileid = profileId,
						 UserName='Test.partnerfsds@gmail.com',
						 Alias = 'GDS',
						 TimeZoneSidKey='America/New_York',
						 EmailEncodingKey='ISO-8859-1',
						 LocaleSidKey='en_US',
						 LanguageLocaleKey='en_US',
						 ContactId = [SELECT Id FROM Contact WHERE accountId =: acc.Id LIMIT 1].Id,
						 PortalRole = 'Manager',
						 FirstName = 'Test',
						 LastName = 'partner2323');
		insert portalUser;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Nokia_CPQ_Partner_User'];
		insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
	}
	return portalUser;
}

static testMethod void indirectQuoteMethod1() {
	test.startTest();
	user partnerUser = [SELECT Id,Name FROM User where username = 'Test.partnerfsds@gmail.com' LIMIT 1];
	Apttus_Proposal__Proposal__c proposalSO = new Apttus_Proposal__Proposal__c();
	User userSO = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
	userSO.UserRoleId  = system.Label.Global_Role_ID;
	userSO.NSA_Compliant__c = true;

	system.runAs(userSO) {
		proposalSO = [SELECT Id,Name,Apttus_Proposal__Account__c FROM Apttus_Proposal__Proposal__c WHERE Quote_Type__c = 'Indirect CPQ' LIMIT 1];
		system.debug('@---- '+proposalSO);
		ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();
		system.runAs(partnerUser) {
			objControllerClass.init();
		}
		Account acc = [SELECT Id FROM Account WHERE Id =: proposalSO.Apttus_Proposal__Account__c LIMIT 1];

		objControllerClass.opportunity.StageName = 'Create Offer (Bid)';
		objControllerClass.quote.NokiaCPQ_LEO_Discount__c = true;
		objControllerClass.quote.NokiaCPQ_has_Partner_Certified__c = false;
		objControllerClass.init();
		objControllerClass.quote.NokiaCPQ_Needs_Reprice__c = false;
		objControllerClass.productConfig.Apttus_Config2__Status__c = 'Saved';
		objControllerClass.init();
		objControllerClass.productConfig.Apttus_Config2__Status__c = GlobalConstants.FINALIZED;

		objControllerClass.flag = 2;
		objControllerClass.init();

		objControllerClass.quote.NokiaCPQ_LEO_Discount__c = false;
		objControllerClass.flag = 1;
		objControllerClass.init();

	}
	system.runAs(partnerUser) {
		ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.init();
	}
	test.stopTest();

}

static testMethod void indirectQuoteMethod10() {
	test.startTest();
	user partnerUser = [SELECT Id,Name FROM User where username = 'Test.partnerfsds@gmail.com' LIMIT 1];
	Apttus_Proposal__Proposal__c proposalSO = new Apttus_Proposal__Proposal__c();
	User userSO = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
	userSO.UserRoleId  = system.Label.Global_Role_ID;
	userSO.NSA_Compliant__c = true;

	system.runAs(userSO) {
		opportunity opty = [SELECT id,Name,stageName,Contract_Price_List__c,CurrencyIsoCode FROM Opportunity LIMIT 1];
		Apttus_Config2__PriceList__c priceList1 = new Apttus_Config2__PriceList__c();
		priceList1.Name='Global1';
		priceList1.CurrencyIsoCode=opty.CurrencyIsoCode;
		priceList1.Apttus_Config2__Active__c=true;
		priceList1.Apttus_Config2__BasedOnPriceListId__c = null;
		priceList1.Apttus_Config2__Type__c='Standard';
		priceList1.PriceList_Type__c = 'Partner';
		insert priceList1;

		proposalSO = [SELECT Id,Name,Apttus_Proposal__Account__c FROM Apttus_Proposal__Proposal__c WHERE Quote_Type__c = 'Indirect CPQ' LIMIT 1];
		system.debug('@---- '+proposalSO);
		Apttus_Config2__PriceList__c priceList2 = [SELECT Id,Project_Price_List_Number__c FROM Apttus_Config2__PriceList__c WHERE Name='Global1' LIMIT 1];
		proposalSO.Project_Price_List_Number__c = priceList2.Project_Price_List_Number__c;
		update proposalSO;
		ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.quote.NokiaCPQ_LEO_Discount__c = false;
		objControllerClass.quote.NokiaCPQ_Needs_Reprice__c = false;
		objControllerClass.flag = 5;
		objControllerClass.opportunity.StageName = 'Create Offer (Bid)';
		objControllerClass.opportunity.Phase_Status__c= null;
		objControllerClass.init();

		proposalSO.Project_Price_List_Number__c = '123';
		update proposalSO;

		opty.Contract_Price_List__c = priceList1.Id;
		update opty;

		ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass1 = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass1.quote.NokiaCPQ_LEO_Discount__c = false;
		objControllerClass1.quote.NokiaCPQ_Needs_Reprice__c = false;
		objControllerClass1.flag = 5;
		objControllerClass1.opportunity.StageName = 'Create Offer (Bid)';
		objControllerClass1.opportunity.Phase_Status__c= null;
		objControllerClass1.init();
	}
	test.stopTest();

}


static testMethod void indirectQuoteMethod2() {
	Apttus_Proposal__Proposal__c proposalSO = new Apttus_Proposal__Proposal__c();
	proposalSO = [SELECT Id,Name,NokiaCPQ_Maintenance_Type__c,NokiaCPQ_Portfolio__c FROM Apttus_Proposal__Proposal__c WHERE Quote_Type__c = 'Indirect CPQ' LIMIT 1];
	system.debug('@---- '+proposalSO);
	test.startTest();
	Apttus_Config2__ProductConfiguration__c pConfig = new Apttus_Config2__ProductConfiguration__c();
	pConfig = [SELECT Id,name FROM Apttus_Config2__ProductConfiguration__c WHERE Apttus_QPConfig__Proposald__c =: proposalSO.Id];
	pConfig.Apttus_Config2__Status__c = 'Saved';
	update pConfig;
	list<Pre_Approved_Custom_Products__c> preApprovedSOList = getPreapprovedProducts(2, [SELECT id FROM Account LIMIT 1][0].id);
	preApprovedSOList[1].Expiration_Date__c = System.today().addDays(2);
	preApprovedSOList[1].Maintenance_Type__c = proposalSO.NokiaCPQ_Maintenance_Type__c;
	insert preApprovedSOList;
	list<Apttus_Config2__LineItem__c> linesList = new list<Apttus_Config2__LineItem__c>();
	linesList = [SELECT Id,Name,Pre_Approved_Custom_Product__c FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c =: pConfig.Id];
	linesList[0].Pre_Approved_Custom_Product__c = preApprovedSOList[1].id;
	linesList[1].Pre_Approved_Custom_Product__c = preApprovedSOList[0].id;
	preApprovedSOList[1].Expiration_Date__c = System.today().addDays(2);
	preApprovedSOList[0].Expiration_Date__c = System.today().addDays(2);
	preApprovedSOList[1].Maintenance_Type__c = proposalSO.NokiaCPQ_Maintenance_Type__c;
	preApprovedSOList[0].Maintenance_Type__c = proposalSO.NokiaCPQ_Maintenance_Type__c;
	preApprovedSOList[0].Portfolio__c = proposalSO.NokiaCPQ_Portfolio__c;
	preApprovedSOList[1].Portfolio__c = proposalSO.NokiaCPQ_Portfolio__c;
	update linesList;
	ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	//objControllerClass.preApprovedProductsList = preApprovedSOList;
	//objControllerClass.flagPreApproved = true;
	//objControllerClass.init();
	test.stopTest();
}

static testMethod void indirectQuoteMethod3() {

	Apttus_Proposal__Proposal__c proposalSO = new Apttus_Proposal__Proposal__c();
	proposalSO = [SELECT Id,Name FROM Apttus_Proposal__Proposal__c WHERE Quote_Type__c = 'Indirect CPQ' LIMIT 1];
	test.startTest();
	list<Apttus_Proposal__Proposal_Line_Item__c> linesList = new list<Apttus_Proposal__Proposal_Line_Item__c>();
	linesList = [SELECT Id,Name,Apttus_QPConfig__LineType__c FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c =: proposalSO.Id];
	linesList[0].Apttus_QPConfig__LineType__c = 'Product/Service';
	linesList[1].Apttus_QPConfig__LineType__c = 'Option';
	linesList[1].Invalid_Maintenance_type__c = true;
	update linesList;
	list <product2> productList = new list<product2>();
	for(product2 productSO : [SELECT Id,name,isActive,Last_Modified_Version__c FROM product2]) {
		productSO.isActive = false;
		productList.add(productSO);
	}
	update productList;
	ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.opportunity.StageName = 'Create Offer (Bid)';
	objControllerClass.init();
	for(product2 productSO : productList) {
		productSO.isActive = true;
		productSO.Last_Modified_Version__c = system.now().addDays(10);
	}
	update productList;
	objControllerClass.flag = 2; //check this later
	objControllerClass.init();
	for(product2 productSO : productList) {
		productSO.isActive = true;
		productSO.Last_Modified_Version__c = system.now();
	}
	update productList;
	objControllerClass.quote.NokiaCPQ_Needs_Reprice__c = true;
	objControllerClass.flag = 0;
	objControllerClass.init();
	//objControllerClass.checkIndirectInvaliCPQ();
	test.stopTest();
}

static testMethod void indirectQuoteMethod4() {
	user partnerUser = [SELECT Id,Name FROM User where username = 'Test.partnerfsds@gmail.com' LIMIT 1];
	Apttus_Proposal__Proposal__c proposalSO = new Apttus_Proposal__Proposal__c();
	proposalSO = [SELECT Id,Name FROM Apttus_Proposal__Proposal__c WHERE Quote_Type__c = 'Indirect CPQ' LIMIT 1];
	test.startTest();
	ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.opportunity.StageName = 'Create Offer (Bid)';
	objControllerClass.opportunity.LOA_Level__c  = null;
	objControllerClass.quote.NokiaCPQ_Needs_Reprice__c = false;
	objControllerClass.init();
	system.runAs(partnerUser) {
		objControllerClass.init();
	}
	objControllerClass.quote.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO;
	objControllerClass.isCustomFlag = true;
	objControllerClass.init();

	objControllerClass.quote.NokiaCPQ_Portfolio__c = 'IP Routing';
	objControllerClass.isCustomFlag = false;
	objControllerClass.opportunity.StageName = 'Develop Opportunity';
	objControllerClass.init();

	objControllerClass.quote.NokiaCPQ_Portfolio__c = 'IP Routing';
	objControllerClass.isCustomFlag = false;
	objControllerClass.opportunity.StageName = 'Create Offer (Bid)';
	objControllerClass.opportunity.No_Loa__c = true;
	objControllerClass.opportunity.Phase_Status__c = GlobalConstants.SUBMITTED_FOR_G4_APPROVAL;
	objControllerClass.init();

	objControllerClass.quote.NokiaCPQ_Portfolio__c = 'IP Routing';
	objControllerClass.isCustomFlag = false;
	objControllerClass.opportunity.Phase_Status__c = '';
	objControllerClass.init();

	delete [SELECT Id FROM Apttus_QPConfig__ProposalSummaryGroup__c];
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass1 = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass1.quote.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO;
	objControllerClass1.isCustomFlag = true;
	objControllerClass1.quote.NokiaCPQ_Needs_Reprice__c = false;
	objControllerClass1.opportunity.No_Loa__c = true;
	objControllerClass1.init();
	test.stopTest();
}

static testMethod void indirectQuoteMethod5() {

	

	Apttus_Proposal__Proposal__c proposalSO = new Apttus_Proposal__Proposal__c();
	user partnerUser = [SELECT Id,Name FROM User where username = 'Test.partnerfsds@gmail.com' LIMIT 1];
	proposalSO = [SELECT Id,Name FROM Apttus_Proposal__Proposal__c WHERE Quote_Type__c = 'Indirect CPQ' AND NokiaCPQ_Portfolio__c = 'Microwave' LIMIT 1];
	test.startTest();
	ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.opportunity.StageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
	objControllerClass.opportunity.Phase_Status__c = '';
	objControllerClass.opportunity.LOA_Level__c  = null;
	objControllerClass.opportunity.No_Loa__c  = true;
	objControllerClass.quote.NokiaCPQ_Needs_Reprice__c = false;
	objControllerClass.init();
	system.runAs(partnerUser) {
		objControllerClass.init();
	}
	opportunity opty = [SELECT id,Name,stageName FROM Opportunity LIMIT 1];
	opty.G5_Approval_Date__c = DateTime.now().addDays(2);
	opty.stageName = 'Win the Case (Negotiate)';
	opty.Phase_Status__c = 'Offer Submitted to Customer (Manual)';
	opty.Apttus_Approval__Approval_Status__c = 'Approved';
	update opty;
	
	/*Offer__c offer = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = true,
		Pre_approved_Price_List_for_Acc_Managers__c = false,
		LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
		Opportunity__c = opty.Id,
		Expected_LoA_G4_Approval_Level__c='A'
		);*/
		Offer__c offer = [SELECT Id FROM Offer__c WHERE Opportunity__c=:opty.Id LIMIT 1];
		//insert offer;
		//change add expected loa
		
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass1 = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass1.opportunity.Phase_Status__c = '';
	objControllerClass1.opportunity.StageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
	objControllerClass1.quote.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO;
	objControllerClass1.init();

	system.runAs(partnerUser) {
		objControllerClass1.init();
	}

	offer.Authorized_for_Pricing_Manager__c = false;
	offer.Pre_approved_Price_List_for_Acc_Managers__c = true;
	update offer;

	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass3 = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass3.isCustomFlag  = false;
	objControllerClass3.opportunity.StageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
	objControllerClass3.opportunity.No_Loa__c  = false;
	objControllerClass3.opportunity.LOA_Level__c = GlobalConstants.LOA_BYPASS_LEVEL;
	objControllerClass3.quote.NokiaCPQ_Portfolio__c = 'IP Routing';
	objControllerClass3.init();

	system.runAs(partnerUser) {
		objControllerClass3.init();
	}
	offer.Authorized_for_Pricing_Manager__c = true;
	offer.Pre_approved_Price_List_for_Acc_Managers__c = false;
	update offer;
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass4 = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass4.isCustomFlag  = false;
	objControllerClass4.opportunity.StageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
	objControllerClass4.opportunity.No_Loa__c  = false;
	objControllerClass4.opportunity.LOA_Level__c = 'E';
	objControllerClass4.quote.NokiaCPQ_Portfolio__c = 'IP Routing';
	objControllerClass4.init();

	system.runAs(partnerUser) {
		objControllerClass4.init();
	}
	test.stopTest();

}

static testMethod void indirectQuoteMethod6A() {
	test.startTest();
	Apttus_Proposal__Proposal__c proposalSO = new Apttus_Proposal__Proposal__c();
	user partnerUser = [SELECT Id,Name FROM User where username = 'Test.partnerfsds@gmail.com' LIMIT 1];
	proposalSO = [SELECT Id,Name FROM Apttus_Proposal__Proposal__c WHERE Quote_Type__c = 'Indirect CPQ' AND NokiaCPQ_Portfolio__c = 'Microwave' LIMIT 1];
	ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass2 = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass2.opportunity.StageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
	objControllerClass2.opportunity.No_Loa__c  = true;
	objControllerClass2.opportunity.LOA_Level__c = 'E';
	objControllerClass2.opportunity.Phase_Status__c = '';
	objControllerClass2.quote.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO;
	objControllerClass2.init();

	objControllerClass2.opportunity.StageName = GlobalConstants.CREATE_OFFER;
	objControllerClass2.opportunity.No_Loa__c  = true;
	objControllerClass2.opportunity.LOA_Level__c = GlobalConstants.LOA_BYPASS_LEVEL;
	objControllerClass2.opportunity.Phase_Status__c = '';
	objControllerClass2.quote.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO;
	objControllerClass2.init();

	test.stopTest();
}


static testMethod void indirectQuoteMethod6B() {
	
	test.startTest();
	user partnerUser = [SELECT Id,Name FROM User where username = 'Test.partnerfsds@gmail.com' LIMIT 1];
	
	opportunity opty = [SELECT id,Name,stageName FROM Opportunity LIMIT 1];
	
	opty.stageName = 'Win the Case (Negotiate)';
	opty.G5_Approval_Date__c = DateTime.now().addDays(2);
	opty.Phase_Status__c = 'Offer Submitted to Customer (Manual)';
	opty.Apttus_Approval__Approval_Status__c = 'Approved';
	update opty;
	

	/*Offer__c offer = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = false,
		Pre_approved_Price_List_for_Acc_Managers__c = true,
		LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
		Opportunity__c = opty.Id,
		Expected_LoA_G4_Approval_Level__c='A'
		);*/
		Offer__c offer = [SELECT Id FROM Offer__c  WHERE Opportunity__c=:opty.Id LIMIT 1];
		//insert offer;
		//change add expected loa
	

	NokiaCPQ_Discount_Threshold__c dt = new NokiaCPQ_Discount_Threshold__c();
	dt.Name = 'Quote Discount Threshold (Profile)';
	dt.NokiaCPQ_Approved_Amount_Threshold__c = 10;
	insert dt;



	offer.Authorized_for_Pricing_Manager__c = true;
	offer.Pre_approved_Price_List_for_Acc_Managers__c = false;
	update offer;

	Apttus_Proposal__Proposal__c proposal1 = [SELECT Id,Name FROM Apttus_Proposal__Proposal__c WHERE Quote_Type__c = 'Indirect CPQ' AND NokiaCPQ_Portfolio__c = 'IP Routing' LIMIT 1];
	ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposal1.Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass4 = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass4.opportunity.StageName = GlobalConstants.CREATE_OFFER;
	objControllerClass4.opportunity.No_Loa__c  = false;
	objControllerClass4.quote.NokiaCPQ_Needs_Reprice__c = false;
	objControllerClass4.opportunity.LOA_Level__c = 'E';
	objControllerClass4.opportunity.Phase_Status__c = '';
	objControllerClass4.init();
	system.runAs(partnerUser) {
		objControllerClass4.init();
	}

	Apttus_QPConfig__ProposalSummaryGroup__c psg = new Apttus_QPConfig__ProposalSummaryGroup__c();
	psg.Name = 'Total (One Time)';
	psg.Apttus_QPConfig__NetPrice__c = 1000;
	psg.Apttus_QPConfig__ChargeType__c = 'Standard Price';
	psg.Apttus_QPConfig__ProposalId__c = proposal1.Id;
	psg.Apttus_QPConfig__ItemSequence__c = 1;
	psg.Apttus_QPConfig__LineNumber__c = 1;
	psg.Apttus_QPConfig__AdjustmentAmount__c = 1;
	insert psg;

	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass3 = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass3.opportunity.StageName = GlobalConstants.CREATE_OFFER;
	objControllerClass3.opportunity.No_Loa__c  = false;
	objControllerClass3.quote.NokiaCPQ_Needs_Reprice__c = false;
	objControllerClass3.opportunity.LOA_Level__c = 'E';
	objControllerClass3.opportunity.Phase_Status__c = '';
	objControllerClass3.quote.Maintenance_Y1__c = 10;
	objControllerClass3.init();

	system.runAs(partnerUser) {
		objControllerClass3.init();
	}

	test.stopTest();
}


static testMethod void indirectQuoteMethod7() {

	Apttus_Proposal__Proposal__c proposalSO = new Apttus_Proposal__Proposal__c();
	user partnerUser = [SELECT Id,Name FROM User where username = 'Test.partnerfsds@gmail.com' LIMIT 1];
	proposalSO = [SELECT Id,Name FROM Apttus_Proposal__Proposal__c WHERE Quote_Type__c = 'Indirect CPQ' AND NokiaCPQ_Portfolio__c = 'Microwave' LIMIT 1];
	test.startTest();
	Apttus_QPConfig__ProposalSummaryGroup__c psg = new Apttus_QPConfig__ProposalSummaryGroup__c();
	psg.Name = 'Total (One Time)';
	psg.Apttus_QPConfig__NetPrice__c = 1000;
	psg.Apttus_QPConfig__ChargeType__c = 'Standard Price';
	psg.Apttus_QPConfig__ProposalId__c = proposalSO.Id;
	psg.Apttus_QPConfig__ItemSequence__c = 1;
	psg.Apttus_QPConfig__LineNumber__c = 1;
	psg.Apttus_QPConfig__AdjustmentAmount__c = 10;
	insert psg;
	ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass2 = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass2.opportunity.StageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
	objControllerClass2.opportunity.No_Loa__c  = true;
	objControllerClass2.opportunity.LOA_Level__c = null;
	objControllerClass2.opportunity.Phase_Status__c = '';
	objControllerClass2.quote.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO;
	objControllerClass2.init();

	system.runAs(partnerUser) {
		objControllerClass2.init();
	}

	test.stopTest();
}

static testMethod void indirectQuoteMethod9() {
	test.startTest();
	user partnerUser = [SELECT Id,Name FROM User where username = 'Test.partnerfsds@gmail.com' LIMIT 1];

	Apttus_Proposal__Proposal__c proposalSO1 = [SELECT Id,Name FROM Apttus_Proposal__Proposal__c WHERE Quote_Type__c = 'Indirect CPQ' AND NokiaCPQ_Portfolio__c = 'IP Routing' LIMIT 1];
	Apttus_QPConfig__ProposalSummaryGroup__c psg1 = new Apttus_QPConfig__ProposalSummaryGroup__c();

	psg1.Name = 'Total (One Time)';
	psg1.Apttus_QPConfig__NetPrice__c = 1000;
	psg1.Apttus_QPConfig__ChargeType__c = 'Standard Price';
	psg1.Apttus_QPConfig__ProposalId__c = proposalSO1.Id;
	psg1.Apttus_QPConfig__ItemSequence__c = 1;
	psg1.Apttus_QPConfig__LineNumber__c = 1;
	psg1.Apttus_QPConfig__AdjustmentAmount__c = 10;
	insert psg1;

	ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO1.Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass1 = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass1.opportunity.StageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
	objControllerClass1.opportunity.No_Loa__c  = true;
	objControllerClass1.opportunity.LOA_Level__c = null;
	objControllerClass1.opportunity.Phase_Status__c = '';
	objControllerClass1.quote.NokiaCPQ_Needs_Reprice__c = false;
	objControllerClass1.quote.NokiaCPQ_LEO_Discount__c  = true;
	objControllerClass1.isCustomFlag  = true;
	objControllerClass1.quote.NokiaCPQ_has_Partner_Certified__c = true;
	objControllerClass1.quote.Maintenance_Y1__c = 10;
	objControllerClass1.init();
	system.runAs(partnerUser) {
		objControllerClass1.init();
	}

	objControllerClass1.quote.NokiaCPQ_LEO_Discount__c  = false;
	objControllerClass1.init();
	system.runAs(partnerUser) {
		objControllerClass1.init();
	}

	objControllerClass1.quote.NokiaCPQ_LEO_Discount__c  = true;
	objControllerClass1.isCustomFlag  = false;
	objControllerClass1.init();
	system.runAs(partnerUser) {
		objControllerClass1.init();
	}
	objControllerClass1.quote.NokiaCPQ_LEO_Discount__c  = false;
	objControllerClass1.isCustomFlag  = false;
	objControllerClass1.init();
	system.runAs(partnerUser) {
		objControllerClass1.init();
	}

	objControllerClass1.quote.Maintenance_Y1__c  = 0;
	objControllerClass1.quote.NokiaCPQ_LEO_Discount__c  = true;
	objControllerClass1.isCustomFlag  = true;
	objControllerClass1.init();
	system.runAs(partnerUser) {
		objControllerClass1.init();
	}

	objControllerClass1.quote.NokiaCPQ_LEO_Discount__c  = false;
	objControllerClass1.isCustomFlag  = true;
	objControllerClass1.init();
	system.runAs(partnerUser) {
		objControllerClass1.init();
	}




	test.stopTest();
}

static testMethod void indirectQuoteMethod8() {
	test.startTest();
	user partnerUser = [SELECT Id,Name FROM User where username = 'Test.partnerfsds@gmail.com' LIMIT 1];

	Apttus_Proposal__Proposal__c proposalSO1 = [SELECT Id,Name FROM Apttus_Proposal__Proposal__c WHERE Quote_Type__c = 'Indirect CPQ' AND NokiaCPQ_Portfolio__c = 'IP Routing' LIMIT 1];
	Apttus_QPConfig__ProposalSummaryGroup__c psg1 = new Apttus_QPConfig__ProposalSummaryGroup__c();

	psg1.Name = 'Total (One Time)';
	psg1.Apttus_QPConfig__NetPrice__c = 1000;
	psg1.Apttus_QPConfig__ChargeType__c = 'Standard Price';
	psg1.Apttus_QPConfig__ProposalId__c = proposalSO1.Id;
	psg1.Apttus_QPConfig__ItemSequence__c = 1;
	psg1.Apttus_QPConfig__LineNumber__c = 1;
	psg1.Apttus_QPConfig__AdjustmentAmount__c = 10;
	insert psg1;

	ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO1.Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass1 = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass1.opportunity.StageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
	objControllerClass1.opportunity.No_Loa__c  = true;
	objControllerClass1.opportunity.LOA_Level__c = null;
	objControllerClass1.opportunity.Phase_Status__c = '';
	objControllerClass1.quote.NokiaCPQ_Needs_Reprice__c = false;
	objControllerClass1.quote.NokiaCPQ_LEO_Discount__c  = false;
	objControllerClass1.isCustomFlag  = false;
	objControllerClass1.quote.NokiaCPQ_has_Partner_Certified__c = true;
	objControllerClass1.init();
	system.runAs(partnerUser) {
		objControllerClass1.init();
	}
	objControllerClass1.quote.Maintenance_Y1__c  = 0;
	objControllerClass1.quote.NokiaCPQ_LEO_Discount__c  = true;
	objControllerClass1.isCustomFlag  = false;
	objControllerClass1.isCustomFlag  = true;
	objControllerClass1.init();
	system.runAs(partnerUser) {
		objControllerClass1.init();
	}

	objControllerClass1.quote.NokiaCPQ_LEO_Discount__c  = false;
	objControllerClass1.init();
	system.runAs(partnerUser) {
		objControllerClass1.init();
	}

	psg1.Apttus_QPConfig__AdjustmentAmount__c = 0;
	update psg1;

	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.opportunity.StageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
	objControllerClass.opportunity.No_Loa__c  = true;
	objControllerClass.opportunity.LOA_Level__c = null;
	objControllerClass.opportunity.Phase_Status__c = '';
	objControllerClass.quote.NokiaCPQ_Needs_Reprice__c = false;
	objControllerClass.quote.Maintenance_Y1__c  = 10;
	objControllerClass.isCustomFlag  = false;
	objControllerClass.quote.NokiaCPQ_has_Partner_Certified__c = true;
	objControllerClass.quote.NokiaCPQ_LEO_Discount__c = false;
	objControllerClass.init();
	system.runAs(partnerUser) {
		objControllerClass.init();
	}
	objControllerClass.isCustomFlag = true;
	objControllerClass.quote.Maintenance_Y1__c  = 0;
	system.runAs(partnerUser) {
		objControllerClass.init();
	}

	objControllerClass.isCustomFlag = false;
	objControllerClass.quote.NokiaCPQ_LEO_Discount__c  = true;
	system.runAs(partnerUser) {
		objControllerClass.init();
	}


	test.stopTest();
}

static testMethod void directQuoteMethod1() {
	Apttus_Proposal__Proposal__c proposalSO = new Apttus_Proposal__Proposal__c();
	proposalSO = [SELECT Id,Name FROM Apttus_Proposal__Proposal__c WHERE Quote_Type__c = 'Direct CPQ' LIMIT 1];
	test.startTest();
	ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.init();
	objControllerClass.quote.NokiaCPQ_Needs_Reprice__c = false;
	objControllerClass.opportunity.StageName = '';
	objControllerClass.init();
	objControllerClass.opportunity.StageName = GlobalConstants.CREATE_OFFER;
	objControllerClass.opportunity.LOA_Level__c  = null;
	objControllerClass.opportunity.No_Loa__c = false;
	objControllerClass.init();

	objControllerClass.opportunity.No_Loa__c  = true;
	objControllerClass.opportunity.StageName = GlobalConstants.CREATE_OFFER;
	objControllerClass.opportunity.Phase_Status__c = GlobalConstants.SUBMITTED_FOR_G4_APPROVAL;
	objControllerClass.init();

	objControllerClass.opportunity.StageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
	objControllerClass.opportunity.Phase_Status__c = '';
	objControllerClass.opportunity.No_Loa__c = true;
	objControllerClass.opportunity.LOA_Level__c = 'E';
	objControllerClass.init();

	objControllerClass.opportunity.StageName = GlobalConstants.CREATE_OFFER;
	objControllerClass.quote.Is_List_Price_Only__c = true;
	objControllerClass.init();

	objControllerClass.quote.Is_List_Price_Only__c = false;
	objControllerClass.quote.CurrencyIsoCode = 'USD';
	objControllerClass.quote.Exchange_Rate__c = 10;
	objControllerClass.opportunity.LOA_Level__c = GlobalConstants.LOA_BYPASS_LEVEL;
	objControllerClass.trafficLight = Nokia_CPQ_Constants.RED;
	objControllerClass.quote.Apttus_Proposal__Approval_Stage__c = Nokia_CPQ_Constants.ApprovalRequired;
	objControllerClass.init();

	objControllerClass.quote.Apttus_Proposal__Approval_Stage__c = '';
	objControllerClass.init();

	objControllerClass.trafficLight = Nokia_CPQ_Constants.GREEN;
	objControllerClass.init();

	objControllerClass.trafficLight = '';
	objControllerClass.init();
	test.stopTest();

}

static testMethod void directQuoteMethod2() {
	Apttus_Proposal__Proposal__c proposalSO = new Apttus_Proposal__Proposal__c();
	proposalSO = [SELECT Id,Name FROM Apttus_Proposal__Proposal__c WHERE Quote_Type__c = 'Direct CPQ' LIMIT 1];
	test.startTest();
	opportunity opty = [SELECT id,Name,stageName FROM Opportunity WHERE recordtype.developername='Direct_Record_Type' LIMIT 1];
	//opty.stageName = 'Win the Case (Negotiate)';
	opty.Phase_Status__c = 'Offer in Progress   ';
	update opty;

	/*Offer__c offer = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = false,
		Pre_approved_Price_List_for_Acc_Managers__c = true,
		LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
		Opportunity__c = opty.Id,
		Expected_LoA_G4_Approval_Level__c='A'
		);*/
		Offer__c offer = [SELECT Id FROM Offer__c WHERE Opportunity__c=:opty.Id LIMIT 1];
		//insert offer;
		//change add expected loa
	

	ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.quote.NokiaCPQ_Needs_Reprice__c = false;
	objControllerClass.opportunity.StageName = GlobalConstants.CREATE_OFFER;
	objControllerClass.quote.Is_List_Price_Only__c = false;
	objControllerClass.quote.CurrencyIsoCode = 'USD';
	objControllerClass.quote.Exchange_Rate__c = 10;
	objControllerClass.opportunity.Phase_Status__c = '';
	objControllerClass.opportunity.No_Loa__c = false;
	objControllerClass.opportunity.LOA_Level__c = GlobalConstants.LOA_BYPASS_LEVEL;
	objControllerClass.trafficLight = Nokia_CPQ_Constants.GREEN;
	objControllerClass.init();

	objControllerClass.trafficLight = '';
	objControllerClass.init();

	objControllerClass.trafficLight = Nokia_CPQ_Constants.RED;
	objControllerClass.quote.Apttus_Proposal__Approval_Stage__c = Nokia_CPQ_Constants.ApprovalRequired;
	objControllerClass.init();
	objControllerClass.trafficLight = Nokia_CPQ_Constants.RED;
	objControllerClass.init();

	offer.Authorized_for_Pricing_Manager__c = true;
	offer.Pre_approved_Price_List_for_Acc_Managers__c = false;
	update offer;
	ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass1 = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass1.quote.NokiaCPQ_Needs_Reprice__c = false;
	objControllerClass1.opportunity.StageName = GlobalConstants.CREATE_OFFER;
	objControllerClass1.quote.Is_List_Price_Only__c = false;
	objControllerClass1.quote.CurrencyIsoCode = 'USD';
	objControllerClass1.quote.Exchange_Rate__c = 10;
	objControllerClass1.opportunity.Phase_Status__c = '';
	objControllerClass1.opportunity.No_Loa__c = false;
	objControllerClass1.opportunity.LOA_Level__c = GlobalConstants.LOA_BYPASS_LEVEL;
	objControllerClass1.trafficLight = Nokia_CPQ_Constants.GREEN;
	objControllerClass1.init();

	objControllerClass1.trafficLight = '';
	objControllerClass1.init();

	objControllerClass1.opportunity.LOA_Level__c = 'E';
	objControllerClass1.trafficLight = Nokia_CPQ_Constants.GREEN;
	objControllerClass1.init();

	objControllerClass1.opportunity.LOA_Level__c = 'E';
	objControllerClass1.quote.NokiaCPQ_Portfolio__c = 'QTC';
	objControllerClass1.init();
	objControllerClass1.loaBypass = false;
	objControllerClass1.currentBatchStatus();
	objControllerClass1.loaBypass = true;
	objControllerClass1.currentBatchStatus();
	objControllerClass1.cancel();
	//NokiaCPQ_Validate_Quote_Ctrlr.submitforApproval(opty.Id);

}

static list<Pre_Approved_Custom_Products__c> getPreapprovedProducts(Integer size, Id accountId) {
	list<Pre_Approved_Custom_Products__c> preApprovedList = new list<Pre_Approved_Custom_Products__c>();
	for(Integer i=0; i<size; i++) {
		Pre_Approved_Custom_Products__c pacp = new Pre_Approved_Custom_Products__c();
		pacp.Name = 'Product '+i;
		pacp.Account__c = accountId;
		pacp.Expiration_Date__c = System.today().addDays(2);
		pacp.Portfolio__c = 'IP Routing';
		pacp.Product_Code__c = '3HE14910AA';
		pacp.List_Price__c = 100;
		pacp.Maintenance_Type__c = 'Gold (Return for Exchange)';
		pacp.Maintenance_Under_Warranty_Rate__c = 2;
		pacp.Maintenance_Beyond_Warranty_Rate__c = 2;
		preApprovedList.add(pacp);
	}
	return preApprovedList;
}

static List<Opportunity> createOpportunities() {

	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accountsList);
	opportunities[0].StageName = 'Create Offer (Bid)';
	opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accountsList[1].id;
	opportunities[0].CurrencyIsoCode = 'EUR';

	opportunities.addAll(NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accountsList));
	opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	opportunities[1].Account_Role__c = 'GPP Distributor Partner';
	insert opportunities;
	opportunities[0].StageName = GlobalConstants.HANDOVER_OPPTY;
	opportunities[0].LOA_Level__c = '';
	opportunities[0].No_Loa__c = false;
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	//opportunities[0].Apttus_Approval__Approval_Status__c = 'Not Submitted';
	opportunities[0].G2_Approval_Date__c = Date.Today();
	opportunities[0].G3_Planned_Date__c =  Date.Today();
	opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	opportunities[1].G4_Planned_Date__c =  Date.Today();
	opportunities[1].Apttus_Approval__Approval_Status__c = 'Approved';
	//opportunities[1].Apttus_Approval__Approval_Status__c = 'Not Submitted';
	opportunities[1].stageName = 'Create Offer (bid)';
	opportunities[1].Phase_Status__c = 'Submitted for G4 Approval';
	opportunities[1].No_Loa__c = true;
	opportunities[1].LOA_Level__c = 'A';
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	update opportunities;
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	opportunities.addAll(NOKIA_CPQ_TestDataFactory.getOpportunities(1,accountsList));
	opportunities[2].StageName = 'Create Offer (Bid)';
	opportunities[2].Phase_Status__c = 'Submitted for G4 Approval';
	opportunities[2].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[2].End_Customer_LE__c = accountsList[1].id;
	opportunities[2].CurrencyIsoCode = 'EUR';
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	upsert opportunities;

	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	opportunities.addAll(NOKIA_CPQ_TestDataFactory.getOpportunities(1,accountsList));
	opportunities[3].StageName = 'Create Offer (Bid)';
	opportunities[3].Phase_Status__c = 'Submitted for G4 Approval';
	opportunities[3].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[3].End_Customer_LE__c = accountsList[2].id;
	opportunities[3].CurrencyIsoCode = 'EUR';
	opportunities[3].LOA_Level__c='A';
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	upsert opportunities;
	system.debug('[+] Optty Id = '+opportunities[3].Id);
	system.debug('[+] Optty LOA_Level__c = '+opportunities[3].LOA_Level__c);
	OpportunityShare os = new OpportunityShare();
	os.OpportunityAccessLevel = 'Edit';
	os.UserOrGroupId = [SELECT Id,Name FROM User where username = 'Test.partnerfsds@gmail.com' LIMIT 1].Id;
	os.OpportunityId = opportunities[0].Id;
	insert os;
	return opportunities;
}

static void createProposals() {

	proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	proposals[0].Apttus_Proposal__Account__c = accountsList[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = true;
	proposals[0].CurrencyIsoCode = 'EUR';
	proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing';
	proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[0].NokiaCPQ_No_of_Years__c = '3';
	proposals[0].Apttus_QPConfig__PriceListId__c = priceList.Id;
	//proposals[0].Project_Price_List_Number__c = '1234';
	proposals[0].RecordTypeId=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();

	proposals.addAll(NOKIA_CPQ_TestDataFactory.createProposalDirect(1));
	proposals[1].Apttus_Proposal__Account__c = accountsList[0].Id;
	proposals[1].Apttus_Proposal__Opportunity__c = opportunities[1].Id;
	proposals[1].NokiaCPQ_Needs_Reprice__c = true;
	proposals[1].NokiaCPQ_Portfolio__c = 'IP Routing';
	proposals[1].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();
	proposals[1].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c =true;
	proposals[1].NokiaCPQ_Maintenance_Type__c ='Gold (Return for Exchange)';
	proposals[1].NokiaCPQ_Existing_IONMaint_Contract__c = 'NO';
	proposals[1].NokiaCPQ_No_of_Years__c = '1';

	proposals.addAll(NOKIA_CPQ_TestDataFactory.createProposal(1));
	proposals[2].Apttus_Proposal__Account__c = accountsList[0].Id;
	proposals[2].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[2].NokiaCPQ_Portfolio__c = 'Microwave';
	proposals[2].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	proposals[2].NokiaCPQ_Maintenance_Type__c ='Basic Support';
	proposals[2].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[2].NokiaCPQ_No_of_Years__c = '3';
	proposals[2].NokiaCPQ_SSP_Level__c = '';
	proposals[2].NokiaCPQ_SRS_Level__c = '';
	//proposals[0].Project_Price_List_Number__c = '12345';
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;

	proposals.addAll(NOKIA_CPQ_TestDataFactory.createProposal(1));
	proposals[3].Apttus_Proposal__Account__c = accountsList[0].Id;
	proposals[3].Apttus_Proposal__Opportunity__c = opportunities[2].Id;
	proposals[3].NokiaCPQ_Portfolio__c = 'Microwave';
	proposals[3].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	proposals[3].NokiaCPQ_Maintenance_Type__c ='Basic Support';
	proposals[3].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[3].NokiaCPQ_No_of_Years__c = '3';
	proposals[3].NokiaCPQ_SSP_Level__c = '';
	proposals[3].NokiaCPQ_SRS_Level__c = '';
	proposals[3].Project_Price_List_Number__c = '12345678';
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;

	proposals.addAll(NOKIA_CPQ_TestDataFactory.createProposal(1));
	proposals[4].Apttus_Proposal__Account__c = accountsList[2].Id;
	proposals[4].Apttus_Proposal__Opportunity__c = opportunities[3].Id;
	proposals[4].NokiaCPQ_Portfolio__c = 'Microwave';
	proposals[4].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	proposals[4].NokiaCPQ_Maintenance_Type__c ='Basic Support';
	proposals[4].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[4].NokiaCPQ_No_of_Years__c = '3';
	proposals[4].NokiaCPQ_SSP_Level__c = '';
	proposals[4].NokiaCPQ_SRS_Level__c = '';
	proposals[4].Project_Price_List_Number__c = '123456789';
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;

	proposals.addAll(NOKIA_CPQ_TestDataFactory.createProposal(1));
	proposals[5].Apttus_Proposal__Account__c = accountsList[0].Id;
	proposals[5].Apttus_Proposal__Opportunity__c = opportunities[2].Id;
	proposals[5].NokiaCPQ_Portfolio__c = 'Microwave';
	proposals[5].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	proposals[5].NokiaCPQ_Maintenance_Type__c ='Basic Support';
	proposals[5].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
	proposals[5].NokiaCPQ_No_of_Years__c = '3';
	proposals[5].NokiaCPQ_SSP_Level__c = '';
	proposals[5].NokiaCPQ_SRS_Level__c = '';
	proposals[5].Project_Price_List_Number__c = '1234567890';
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;


	insert proposals;

	Apttus_Proposal__Proposal__Share ps = new Apttus_Proposal__Proposal__Share();
	ps.AccessLevel  = 'Edit';
	ps.UserOrGroupId = [SELECT Id,Name FROM User where username = 'Test.partnerfsds@gmail.com' LIMIT 1].Id;
	ps.ParentId = proposals[0].Id;
	insert ps;

	Apttus_QPConfig__ProposalSummaryGroup__c psg = new Apttus_QPConfig__ProposalSummaryGroup__c();
	psg.Name = 'Total (One Time)';
	psg.Apttus_QPConfig__NetPrice__c = 1000;
	psg.Apttus_QPConfig__ChargeType__c = 'Standard Price';
	psg.Apttus_QPConfig__ProposalId__c = proposals[2].Id;
	psg.Apttus_QPConfig__ItemSequence__c = 1;
	psg.Apttus_QPConfig__LineNumber__c = 1;
	insert psg;

	Apttus_QPConfig__ProposalSummaryGroup__c psg1 = new Apttus_QPConfig__ProposalSummaryGroup__c();
	psg1.Name = 'Total (One Time)';
	psg1.Apttus_QPConfig__NetPrice__c = 1000;
	psg1.Apttus_QPConfig__ChargeType__c = 'Standard Price';
	psg1.Apttus_QPConfig__ProposalId__c = proposals[0].Id;
	psg1.Apttus_QPConfig__ItemSequence__c = 1;
	psg1.Apttus_QPConfig__LineNumber__c = 1;
	insert psg1;

}

static void createConfigurationsAndLineitems() {

	pConfigList = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
	pConfigList[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
	pConfigList[0].Apttus_Config2__AccountId__c = accountsList[0].Id;
	pConfigList[0].Apttus_Config2__Status__c = 'Finalized';

	pConfigList.addAll(NOKIA_CPQ_TestDataFactory.createProdConfig(1));
	pConfigList[1].Apttus_QPConfig__Proposald__c = proposals[1].Id;

	pConfigList.addAll(NOKIA_CPQ_TestDataFactory.createProdConfig(1));
	pConfigList[2].Apttus_QPConfig__Proposald__c = proposals[3].Id;

	pConfigList.addAll(NOKIA_CPQ_TestDataFactory.createProdConfig(1));
	pConfigList[3].Apttus_QPConfig__Proposald__c = proposals[4].Id;

	pConfigList.addAll(NOKIA_CPQ_TestDataFactory.createProdConfig(1));
	pConfigList[4].Apttus_QPConfig__Proposald__c = proposals[5].Id;

	insert pConfigList;

	list<Apttus_Config2__LineItem__c> lineItemList = new list<Apttus_Config2__LineItem__c>();
	Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c();
	lineItem.Apttus_Config2__ConfigurationId__c = pConfigList[0].Id;
	lineItem.Apttus_Config2__ItemSequence__c = 1;
	lineItem.Apttus_Config2__LineNumber__c = 1;
	lineItem.Apttus_Config2__LineStatus__c='New';
	lineItem.Apttus_Config2__PriceListId__c = priceList.id;
	lineItem.Apttus_Config2__ChargeType__c = 'Standard Price';
	lineItem.Apttus_Config2__LineType__c = 'Product/Service';
	lineItem.Apttus_Config2__ProductId__c = productsList[0].Id;
	lineItem.Apttus_Config2__PriceMethod__c = 'Per Unit';
	lineItem.Apttus_Config2__Frequency__c = 'One Time';
	lineItem.Apttus_Config2__AdjustmentAmount__c = 10;
	lineItem.Apttus_Config2__ListPrice__c = 100;
	lineItem.Apttus_Config2__Quantity__c = 1;
	lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
	lineItem.Apttus_Config2__ShipToAccountId__c = accountsList[0].Id;
	lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
	lineItem.Apttus_Config2__PriceListItemId__c = pli[0].Id;

	Apttus_Config2__LineItem__c lineItem1 = new Apttus_Config2__LineItem__c();
	lineItem1.Apttus_Config2__ConfigurationId__c = pConfigList[0].Id;
	lineItem1.Apttus_Config2__ItemSequence__c = 2;
	lineItem1.Apttus_Config2__LineNumber__c = 2;
	lineItem1.Apttus_Config2__LineStatus__c='New';
	lineItem1.Apttus_Config2__PriceListId__c = priceList.id;
	lineItem1.Apttus_Config2__ChargeType__c = 'Standard Price';
	lineItem1.Apttus_Config2__LineType__c = 'Product/Service';
	lineItem1.Apttus_Config2__ProductId__c = productsList[0].Id;
	lineItem1.Apttus_Config2__PriceMethod__c = 'Per Unit';
	lineItem1.Apttus_Config2__Frequency__c = 'One Time';
	lineItem1.Apttus_Config2__AdjustmentAmount__c = 10;
	lineItem1.Apttus_Config2__ListPrice__c = 100;
	lineItem1.Apttus_Config2__Quantity__c = 1;
	lineItem1.Apttus_Config2__PrimaryLineNumber__c = 1;
	lineItem1.Apttus_Config2__ShipToAccountId__c = accountsList[0].Id;
	lineItem1.Apttus_Config2__PricingStatus__c = 'Pending';
	lineItem1.Apttus_Config2__PriceListItemId__c = pli[1].Id;

	Apttus_Config2__LineItem__c lineItem2 = new Apttus_Config2__LineItem__c();
	lineItem2.Apttus_Config2__ConfigurationId__c = pConfigList[1].Id;
	lineItem2.Apttus_Config2__ItemSequence__c = 1;
	lineItem2.Apttus_Config2__LineNumber__c = 1;
	lineItem2.Apttus_Config2__LineStatus__c='New';
	lineItem2.Apttus_Config2__PriceListId__c = priceList.id;
	lineItem2.Apttus_Config2__ChargeType__c = 'Standard Price';
	lineItem2.Apttus_Config2__LineType__c = 'Product/Service';
	lineItem2.Apttus_Config2__ProductId__c = productsList[0].Id;
	lineItem2.Apttus_Config2__PriceMethod__c = 'Per Unit';
	lineItem2.Apttus_Config2__Frequency__c = 'One Time';
	lineItem2.Apttus_Config2__AdjustmentAmount__c = 10;
	lineItem2.Apttus_Config2__ListPrice__c = 100;
	lineItem2.Apttus_Config2__Quantity__c = 1;
	lineItem2.Apttus_Config2__PrimaryLineNumber__c = 1;
	lineItem2.Apttus_Config2__ShipToAccountId__c = accountsList[0].Id;
	lineItem2.Apttus_Config2__PricingStatus__c = 'Pending';
	lineItem2.Apttus_Config2__PriceListItemId__c = pli[0].Id;

	Apttus_Config2__LineItem__c lineItem3 = new Apttus_Config2__LineItem__c();
	lineItem3.Apttus_Config2__ConfigurationId__c = pConfigList[2].Id;
	lineItem3.Apttus_Config2__ItemSequence__c = 1;
	lineItem3.Apttus_Config2__LineNumber__c = 1;
	lineItem3.Apttus_Config2__LineStatus__c='New';
	//lineItem3.Apttus_Config2__PriceListId__c = priceList.id;
	lineItem3.Apttus_Config2__ChargeType__c = 'Standard Price';
	lineItem3.Apttus_Config2__LineType__c = 'Product/Service';
	lineItem3.Apttus_Config2__ProductId__c = productsList[0].Id;
	lineItem3.Apttus_Config2__PriceMethod__c = 'Per Unit';
	lineItem3.Apttus_Config2__Frequency__c = 'One Time';
	lineItem3.Apttus_Config2__AdjustmentAmount__c = 10;
	lineItem3.Apttus_Config2__ListPrice__c = 100;
	lineItem3.Apttus_Config2__Quantity__c = 1;
	lineItem3.Apttus_Config2__PrimaryLineNumber__c = 1;
	lineItem3.Apttus_Config2__ShipToAccountId__c = accountsList[0].Id;
	lineItem3.Apttus_Config2__PricingStatus__c = 'Pending';
	//lineItem3.Apttus_Config2__PriceListItemId__c = pli[0].Id;

	Apttus_Config2__LineItem__c lineItem4 = new Apttus_Config2__LineItem__c();
	lineItem4.Apttus_Config2__ConfigurationId__c = pConfigList[3].Id;
	lineItem4.Apttus_Config2__ItemSequence__c = 1;
	lineItem4.Apttus_Config2__LineNumber__c = 1;
	lineItem4.Apttus_Config2__LineStatus__c='New';
	lineItem4.Apttus_Config2__PriceListId__c = priceList.id;
	lineItem4.Apttus_Config2__ChargeType__c = 'Standard Price';
	lineItem4.Apttus_Config2__LineType__c = 'Product/Service';
	lineItem4.Apttus_Config2__ProductId__c = productsList[1].Id;
	lineItem4.Apttus_Config2__PriceMethod__c = 'Per Unit';
	lineItem4.Apttus_Config2__Frequency__c = 'One Time';
	lineItem4.Apttus_Config2__AdjustmentAmount__c = 10;
	lineItem4.Apttus_Config2__ListPrice__c = 100;
	lineItem4.Apttus_Config2__Quantity__c = 1;
	lineItem4.Apttus_Config2__PrimaryLineNumber__c = 1;
	lineItem4.Apttus_Config2__ShipToAccountId__c = accountsList[2].Id;
	lineItem4.Apttus_Config2__PricingStatus__c = 'Pending';
	lineItem4.Apttus_Config2__PriceListItemId__c = pli[0].Id;
	lineItem4.Pre_Approved_Custom_Product__c = preApprovedProducts[0].Id;

	Apttus_Config2__LineItem__c lineItem5 = new Apttus_Config2__LineItem__c();
	lineItem5.Apttus_Config2__ConfigurationId__c = pConfigList[4].Id;
	lineItem5.Apttus_Config2__ItemSequence__c = 1;
	lineItem5.Apttus_Config2__LineNumber__c = 1;
	lineItem5.Apttus_Config2__LineStatus__c='New';
	lineItem5.Apttus_Config2__PriceListId__c = priceList.id;
	lineItem5.Apttus_Config2__ChargeType__c = 'Standard Price';
	lineItem5.Apttus_Config2__LineType__c = 'Product/Service';
	lineItem5.Apttus_Config2__ProductId__c = productsList[1].Id;
	lineItem5.Apttus_Config2__PriceMethod__c = 'Per Unit';
	lineItem5.Apttus_Config2__Frequency__c = 'One Time';
	lineItem5.Apttus_Config2__AdjustmentAmount__c = 10;
	lineItem5.Apttus_Config2__ListPrice__c = 100;
	lineItem5.Apttus_Config2__Quantity__c = 1;
	lineItem5.Apttus_Config2__PrimaryLineNumber__c = 1;
	lineItem5.Apttus_Config2__ShipToAccountId__c = accountsList[0].Id;
	lineItem5.Apttus_Config2__PricingStatus__c = 'Pending';
	lineItem5.Apttus_Config2__PriceListItemId__c = pli[0].Id;


	lineItemList.add(lineItem2);
	lineItemList.add(lineItem);
	lineItemList.add(lineItem1);
	lineItemList.add(lineItem3);
	lineItemList.add(lineItem4);
	lineItemList.add(lineItem5);
	insert lineItemList;

	Apttus_Config2__SummaryGroup__c SummaryGrp1 = new Apttus_Config2__SummaryGroup__c(
		Apttus_Config2__AdjustmentAmount__c = 10,
		CurrencyIsoCode = 'USD',
		name = 'Subtotal - Standard Price (One Time)',
		Apttus_Config2__ConfigurationId__c=pConfigList[1].Id,
		Apttus_Config2__ItemSequence__c =1,
		Apttus_Config2__LineNumber__c=1
		);
	insert SummaryGrp1;

	List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList = NOKIA_CPQ_TestDataFactory.createProposalLineItem(2);
	proposalLineItemList[0].Apttus_Proposal__Product__c = productsList[0].id;
	proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
	proposalLineItemList[0].Apttus_QPConfig__PriceListItemId__c = pli[0].Id;
	proposalLineItemList[1].Apttus_Proposal__Product__c = productsList[1].id;
	proposalLineItemList[1].Apttus_Proposal__Proposal__c =proposals[0].id;
	proposalLineItemList[1].Apttus_QPConfig__PriceListItemId__c = pli[1].Id;

	proposalLineItemList.addAll(NOKIA_CPQ_TestDataFactory.createProposalLineItem(2));
	proposalLineItemList[2].Apttus_Proposal__Product__c = productsList[0].id;
	proposalLineItemList[2].Apttus_Proposal__Proposal__c =proposals[1].id;
	proposalLineItemList[2].Apttus_QPConfig__PriceListItemId__c = pli[0].Id;
	proposalLineItemList[3].Apttus_Proposal__Product__c = productsList[1].id;
	proposalLineItemList[3].Apttus_Proposal__Proposal__c =proposals[1].id;
	proposalLineItemList[3].Apttus_QPConfig__PriceListItemId__c = pli[1].Id;

	//1956
	proposalLineItemList.addAll(NOKIA_CPQ_TestDataFactory.createProposalLineItem(1));
	proposalLineItemList[4].Apttus_Proposal__Product__c = productsList[1].id;
	proposalLineItemList[4].Apttus_Proposal__Proposal__c =proposals[1].id;
	proposalLineItemList[4].Apttus_QPConfig__PriceListItemId__c = pli[0].Id;

	//For Reprice()
	proposalLineItemList.addAll(NOKIA_CPQ_TestDataFactory.createProposalLineItem(1));
	proposalLineItemList[5].Apttus_Proposal__Product__c = productsList[1].id;
	proposalLineItemList[5].Apttus_Proposal__Proposal__c =proposals[3].id;
	//proposalLineItemList[5].Apttus_QPConfig__PriceListItemId__c = pli[0].Id;
	proposalLineItemList[5].Apttus_QPConfig__DerivedFromId__c = lineItemList[3].Id;

	//For Init()
	proposalLineItemList.addAll(NOKIA_CPQ_TestDataFactory.createProposalLineItem(1));
	proposalLineItemList[6].Apttus_Proposal__Product__c = productsList[1].id;
	proposalLineItemList[6].Apttus_Proposal__Proposal__c =proposals[4].id;
	proposalLineItemList[6].Apttus_QPConfig__PriceListItemId__c = pli[0].Id;
	proposalLineItemList[6].Apttus_QPConfig__DerivedFromId__c = lineItemList[4].Id;

	//For PreApproved
	proposalLineItemList.addAll(NOKIA_CPQ_TestDataFactory.createProposalLineItem(1));
	proposalLineItemList[7].Apttus_Proposal__Product__c = productsList[1].id;
	proposalLineItemList[7].Apttus_Proposal__Proposal__c =proposals[5].id;
	proposalLineItemList[7].Apttus_QPConfig__PriceListItemId__c = pli[0].Id;
	proposalLineItemList[7].Apttus_QPConfig__DerivedFromId__c = lineItemList[5].Id;

	insert proposalLineItemList;

}

@isTest static void indirectQuoteMethod13() {

	user partnerUser = [SELECT Id,Name FROM User where username = 'Test.partnerfsds@gmail.com' LIMIT 1];
	Apttus_Proposal__Proposal__c proposalSO = new Apttus_Proposal__Proposal__c();
	// User userSO = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
	// userSO.UserRoleId  = system.Label.Global_Role_ID;
	// userSO.NSA_Compliant__c = true;
	system.runAs(partnerUser) {
		test.startTest();
		opportunity opty = [SELECT id,Name,stageName,Contract_Price_List__c,CurrencyIsoCode FROM Opportunity LIMIT 1];
		proposalSO = [SELECT Id,Name,Apttus_Proposal__Account__c FROM Apttus_Proposal__Proposal__c WHERE Quote_Type__c = 'Indirect CPQ' LIMIT 1];
		List<Apttus_Proposal__Proposal_Line_Item__c> lineItemList =[SELECT Id FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c =:proposalSO.Id];
		for(Apttus_Proposal__Proposal_Line_Item__c lineItem : lineItemList) {
			lineItem.Apttus_QPConfig__PriceListItemId__c = null;
		}
		update lineItemList;
		ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
		NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
		objControllerClass.quote.NokiaCPQ_LEO_Discount__c = false;
		objControllerClass.quote.NokiaCPQ_Needs_Reprice__c = false;
		objControllerClass.quote.Project_Price_List_Number__c= null;
		objControllerClass.flag = 3;
		objControllerClass.opportunity.StageName = 'Create Offer (Bid)';
		objControllerClass.opportunity.Phase_Status__c= null;
		objControllerClass.init();
		test.stopTest();
	}
}

@isTest static void directQuoteMethodPLIValidationTest() {
	test.startTest();
	Apttus_Proposal__Proposal__c proposalSO = [SELECT Id,Name,Apttus_Proposal__Account__c FROM Apttus_Proposal__Proposal__c WHERE Quote_Type__c = 'Direct CPQ' LIMIT 1];
	List<Apttus_Proposal__Proposal_Line_Item__c> lineItemList =[SELECT Id FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c =:proposalSO.Id];
	for(Apttus_Proposal__Proposal_Line_Item__c lineItem : lineItemList) {
		lineItem.Apttus_QPConfig__PriceListItemId__c = null;
	}
	update lineItemList;
	ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.quote.NokiaCPQ_LEO_Discount__c = false;
	objControllerClass.quote.NokiaCPQ_Needs_Reprice__c = false;
	objControllerClass.quote.Project_Price_List_Number__c= null;
	objControllerClass.flag = 3;
	objControllerClass.opportunity.StageName = 'Create Offer (Bid)';
	objControllerClass.opportunity.Phase_Status__c= null;
	objControllerClass.init();
	test.stopTest();
}

@istest static void inActiveProductTest(){
	Apttus_Proposal__Proposal__c proposalSO = new Apttus_Proposal__Proposal__c();
	proposalSO = [SELECT Id,Name,NokiaCPQ_Needs_Reprice__c FROM Apttus_Proposal__Proposal__c WHERE Quote_Type__c = 'Direct CPQ' LIMIT 1];
	test.startTest();
	proposalSO.NokiaCPQ_Needs_Reprice__c = false;
	Nokia_CPQ_Constants.BYPASS_PROPOSAL_TRIGGER = true;
	update proposalSO;
	Nokia_CPQ_Constants.BYPASS_PROPOSAL_TRIGGER = false;
	list <product2> productList = new list<product2>();
	list<Apttus_Proposal__Proposal_Line_Item__c> pliList= new list<Apttus_Proposal__Proposal_Line_Item__c>();
	Set<Id> prodIds = new Set<Id>();
	for(Apttus_Proposal__Proposal_Line_Item__c pli : [SELECT Id,Apttus_Proposal__Product__c,Apttus_Proposal__Product__r.ProductCode,Apttus_Proposal__Product__r.IsActive,Apttus_QPConfig__LineType__c FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c =:proposalSO.Id]) {
		pli.Apttus_QPConfig__LineType__c = 'Product/Service';
		pliList.add(pli);
		if(!prodIds.contains(pli.Apttus_Proposal__Product__c)) {
			prodIds.add(pli.Apttus_Proposal__Product__c);
			product2 productSO = new product2(Id = pli.Apttus_Proposal__Product__c);
			productSO.IsActive = false;
			productSO.ProductCode = pli.Apttus_Proposal__Product__c;
			productList.add(productSO);
		}
	}
	update pliList;
	System.debug('inActiveProductTest -->' + productList);
	update productList;
	ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.opportunity.StageName = 'Create Offer (Bid)';
	Apttus_Config2__ProductConfiguration__c pConfig = [SELECT Id,name FROM Apttus_Config2__ProductConfiguration__c WHERE Apttus_QPConfig__Proposald__c =: proposalSO.Id];
	pConfig.Apttus_Config2__Status__c = GlobalConstants.FINALIZED;
	update pConfig;
	objControllerClass.init();
}

@isTest static void testReprice() {
	test.startTest();
	Apttus_Proposal__Proposal__c proposalSO = [SELECT Id,Name,Apttus_Proposal__Account__c FROM Apttus_Proposal__Proposal__c WHERE NokiaCPQ_Portfolio__c = 'Microwave' AND Project_Price_List_Number__c = '12345678' LIMIT 1];
	system.debug('[+] In Testcoverage');
	system.debug(proposalSO);
	ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.reprice();
	test.stopTest();
}

@isTest static void testInitCoverage() {
	test.startTest();
	Apttus_Proposal__Proposal__c proposalSO = [SELECT Id,Name,Apttus_Proposal__Account__c FROM Apttus_Proposal__Proposal__c WHERE NokiaCPQ_Portfolio__c = 'Microwave' AND Project_Price_List_Number__c = '123456789' LIMIT 1];
	system.debug('[+] In Testcoverage');
	system.debug(proposalSO);
	ApexPages.currentPage().getParameters().put(GlobalConstants.QUOTEID,proposalSO.Id);
	NokiaCPQ_Validate_Quote_Ctrlr objControllerClass = new NokiaCPQ_Validate_Quote_Ctrlr();
	objControllerClass.opportunity.LOA_Level__c = 'A';
	objControllerClass.opportunity.No_LoA__c = true;
	//objControllerClass.opportunity.Authorized_for_Pricing_manager__c = true;
	objControllerClass.init();
	test.stopTest();
}



}