@isTest
public class NF_GateparticipantswebServiceTest {

	public static String webServiceURL = '/services/apexrest/Gateparticipants/V1/';
	public static String l4Ex = 'LAT CARSO CT CO';
	public static String oppId = '20.MX.234235';
	public static String roleName = '4 - RBC Presales Head AA G3 MU';
	public static String ruleName = 'Rule A';
	public static String assigneeValue ='Sales_Role__c(Role_Code__c=\'NSN%C_BM\' AND ( O__c =\':Org_L4__c\' OR __c =\':Org_L5__c\' OR O__c =\':Org_L6__c\' OR O__c =\':Org_L7__c\') AND Active__c=true).User__c';
	public static String assigneeDesc = 'NSNC_BM, Validator';

	@isTest static void testGetGateParticipantsDevelopOpp(){

		User testUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
		insert testUser;

		Account currentAccount = NF_TestDataFactory.createAccount('132456783');
		currentAccount.L4Name__c = l4Ex;
		insert currentAccount;

		Opportunity currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS, Date.today().addDays(10), 700);
		currentOpportunity.Business_Type__c=GlobalConstants.STANDARDOPPORTUNITY;
		currentOpportunity.Contract_Signing_Entity__c='fALU';
		currentOpportunity.Lead_BG__c = GlobalConstants.Lead_BG_MN;
		currentOpportunity.Opportunity_ID__c = oppId;
		insert currentOpportunity;


		List<Apttus_Approval__Approval_Request__c> requestsList =new  List<Apttus_Approval__Approval_Request__c>();

		Sales_Role__c currentSalesOrg = NF_TestDataFactory.createSalesRole(testUser, 'NSNC_BM', l4Ex, roleName);
		insert currentSalesOrg;
		Apttus_Approval__ApprovalRule__c appRule = NF_TestDataFactory.createApprovalRule(ruleName, true, 'Opportunity', 'Condition', 1);
		insert appRule;

		Apttus_Approval__ApprovalRuleEntry__c ruleEntry = NF_TestDataFactory.createRuleEntry(appRule.Id, 1);
		insert ruleEntry;


		List<Apttus_Approval__ApprovalRuleAssignee__c> AssigneeList = new List<Apttus_Approval__ApprovalRuleAssignee__c>();
		Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, true, false, assigneeValue);
		ruleAssignee.Apttus_Approval__AssigneeDescription__c = assigneeDesc;
		AssigneeList.add(ruleAssignee);
		insert AssigneeList;

		Apttus_Approval__Approval_Request__c currentApprovalRequest = NF_TestDataFactory.createApprovalRequest('Notified', 'User', 'Opportunity', currentOpportunity.Id, true, false, testUser.FirstName+''+testUser.LastName, testUser.Id, AssigneeList[0].Name);
		currentApprovalRequest.NF_Assignee_Type__c='Validator';
		currentApprovalRequest.Apttus_Approval__Object_Type__c = 'Opportunity';
		currentApprovalRequest.NF_Remaindercount__c=0;

		requestsList.add(currentApprovalRequest);

		Database.insert(requestsList);

		List<Apttus_Approval__Approval_Request__c> approvalRequestListval=new List<Apttus_Approval__Approval_Request__c>();
			String soqlQuery ='SELECT Apttus_Approval__Object_Id__c, Apttus_Approval__Object_Type__c,  Id,NF_Role_Name__c,NF_Assignee_Type__c,NF_BG_Attribute__c,NF_Organization_Level__c,Apttus_Approval__Assigned_To_Id__c,Apttus_Approval__DelegateApproverIds__c FROM Apttus_Approval__Approval_Request__c ';
			approvalRequestListval = Database.query(soqlQuery);

		System.debug(approvalRequestListval);

		// Set up a test request
		RestRequest request = new RestRequest();
		request.requestUri =URL.getSalesforceBaseUrl().toExternalForm() + webServiceURL
			+ currentOpportunity.Opportunity_ID__c;
		request.httpMethod = 'GET';
		RestContext.request = request;

		// Call the method to test
		NF_GateparticipantswebService.Onlyquery = true;
		NF_GateparticipantswebService.GAteParticipantsPageseparation participants = NF_GateparticipantswebService.myoppApprovalrelatedlist();
		// Verify results
		System.assert(participants != null);
	}

	 @isTest static void testGetGateParticipantsCreateOfferBypass(){

		User testUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
		insert testUser;

		Account currentAccount = NF_TestDataFactory.createAccount('132456783');
		currentAccount.L4Name__c = l4Ex;
		insert currentAccount;

		Opportunity currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, GlobalConstants.CREATE_OFFER, GlobalConstants.OFFER_IN_PROGRESS, Date.today().addDays(10), 700);
		currentOpportunity.Business_Type__c=GlobalConstants.STANDARDOPPORTUNITY;
		currentOpportunity.Contract_Signing_Entity__c='fALU';
		currentOpportunity.Lead_BG__c = GlobalConstants.Lead_BG_MN;
		currentOpportunity.Opportunity_ID__c = oppId;
		currentOpportunity.Blanket_Approval_Condition__c='Blanket Approval for T&C';
		insert currentOpportunity;

		 Offer__c offer = TestDataFactory.OfferCreation(1, currentOpportunity)[0];
			offer.No_LoA__c = true;
			insert offer;

		List<Apttus_Approval__Approval_Request__c> requestsList =new  List<Apttus_Approval__Approval_Request__c>();

		Sales_Role__c currentSalesOrg = NF_TestDataFactory.createSalesRole(testUser, 'NSNC_BM', l4Ex, roleName);
		insert currentSalesOrg;
		Apttus_Approval__ApprovalRule__c appRule = NF_TestDataFactory.createApprovalRule(ruleName, true, 'Opportunity', 'Condition', 1);
		insert appRule;

		Apttus_Approval__ApprovalRuleEntry__c ruleEntry = NF_TestDataFactory.createRuleEntry(appRule.Id, 1);
		insert ruleEntry;

		List<Apttus_Approval__ApprovalRuleAssignee__c> AssigneeList = new List<Apttus_Approval__ApprovalRuleAssignee__c>();
		Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, true, false, assigneeValue);
		ruleAssignee.Apttus_Approval__AssigneeDescription__c = assigneeDesc;
		AssigneeList.add(ruleAssignee);
		insert AssigneeList;
		Test.startTest();
		Apttus_Approval__Approval_Request__c currentApprovalRequest = NF_TestDataFactory.createApprovalRequest('Notified', 'User', 'Opportunity', currentOpportunity.Id, true, false, testUser.FirstName+''+testUser.LastName, testUser.Id, AssigneeList[0].Name);
		currentApprovalRequest.NF_Assignee_Type__c='Validator';
		currentApprovalRequest.Apttus_Approval__Object_Type__c = 'Opportunity';
		currentApprovalRequest.NF_Remaindercount__c=0;

		requestsList.add(currentApprovalRequest);

		Database.insert(requestsList);

		// Set up a test request
		RestRequest request = new RestRequest();
		request.requestUri =URL.getSalesforceBaseUrl().toExternalForm() + webServiceURL
			+ currentOpportunity.Opportunity_ID__c;
		request.httpMethod = 'GET';
		RestContext.request = request;

		// Call the method to test
		NF_GateparticipantswebService.Onlyquery = true;
		NF_GateparticipantswebService.GAteParticipantsPageseparation participants = NF_GateparticipantswebService.myoppApprovalrelatedlist();
		 Test.stopTest();
		// Verify results
		System.assert(participants != null);
	}

	 @isTest static void testGetGateParticipantsNoOffer(){

		User testUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
		insert testUser;

		Account currentAccount = NF_TestDataFactory.createAccount('132456783');
		currentAccount.L4Name__c = l4Ex;
		insert currentAccount;

		Opportunity currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, GlobalConstants.CREATE_OFFER, GlobalConstants.OFFER_IN_PROGRESS, Date.today().addDays(10), 700);
		currentOpportunity.Business_Type__c=GlobalConstants.STANDARDOPPORTUNITY;
		currentOpportunity.Contract_Signing_Entity__c='fALU';
		currentOpportunity.Lead_BG__c = GlobalConstants.Lead_BG_MN;
		currentOpportunity.Opportunity_ID__c = oppId;
		insert currentOpportunity;

		List<Apttus_Approval__Approval_Request__c> requestsList =new  List<Apttus_Approval__Approval_Request__c>();

		Sales_Role__c currentSalesOrg = NF_TestDataFactory.createSalesRole(testUser, 'NSNC_BM', l4Ex, roleName);
		insert currentSalesOrg;
		Apttus_Approval__ApprovalRule__c appRule = NF_TestDataFactory.createApprovalRule(ruleName, true, 'Opportunity', 'Condition', 1);
		insert appRule;

		Apttus_Approval__ApprovalRuleEntry__c ruleEntry = NF_TestDataFactory.createRuleEntry(appRule.Id, 1);
		insert ruleEntry;

		List<Apttus_Approval__ApprovalRuleAssignee__c> AssigneeList = new List<Apttus_Approval__ApprovalRuleAssignee__c>();
		Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, true, false, assigneeValue);
		ruleAssignee.Apttus_Approval__AssigneeDescription__c = assigneeDesc;
		AssigneeList.add(ruleAssignee);
		insert AssigneeList;
		Test.startTest();
		Apttus_Approval__Approval_Request__c currentApprovalRequest = NF_TestDataFactory.createApprovalRequest('Notified', 'User', 'Opportunity', currentOpportunity.Id, true, false, testUser.FirstName+''+testUser.LastName, testUser.Id, AssigneeList[0].Name);
		currentApprovalRequest.NF_Assignee_Type__c='Validator';
		currentApprovalRequest.Apttus_Approval__Object_Type__c = 'Opportunity';
		currentApprovalRequest.NF_Remaindercount__c=0;

		requestsList.add(currentApprovalRequest);

		Database.insert(requestsList);

		// Set up a test request
		RestRequest request = new RestRequest();
		request.requestUri =URL.getSalesforceBaseUrl().toExternalForm() + webServiceURL
			+ currentOpportunity.Opportunity_ID__c;
		request.httpMethod = 'GET';
		RestContext.request = request;

		// Call the method to test
		NF_GateparticipantswebService.Onlyquery = true;
		NF_GateparticipantswebService.GAteParticipantsPageseparation participants = NF_GateparticipantswebService.myoppApprovalrelatedlist();
		 Test.stopTest();
		// Verify results
		System.assert(participants != null);
	}

	 @isTest static void testGetGateParticipantsPreSales(){

		User testUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
		insert testUser;

		Account currentAccount = NF_TestDataFactory.createAccount('132456783');
		currentAccount.L4Name__c = l4Ex;
		insert currentAccount;

		Opportunity currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, GlobalConstants.CREATE_OFFER, GlobalConstants.OFFER_IN_PROGRESS, Date.today().addDays(10), 700);
		currentOpportunity.Business_Type__c=GlobalConstants.STANDARDOPPORTUNITY;
		currentOpportunity.Contract_Signing_Entity__c='fALU';
		currentOpportunity.Lead_BG__c = GlobalConstants.Lead_BG_MN;
		currentOpportunity.Opportunity_ID__c = oppId;
		insert currentOpportunity;

		 Opportunity preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, currentAccount, currentOpportunity)[0];
		 preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Type__c = GlobalConstants.RISK_ORDER;
		 preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = GlobalConstants.RISK_ORDER_ONLY;
		 preSalesTest.CurrencyIsoCode = 'USD';
		 preSalesTest.Opportunity_ID__c = '20.MX.234235.R001';
		 database.insert(preSalesTest);
		 presalesTest.NF_PRE_Tech_Field__c = 'Gate Submitted';
		 preSalesTest.StageName = GlobalConstants.IN_EXECUTION;
		 preSalesTest.Apttus_Approval__Approval_Status__c = 'Approved';
		 system.debug('preSalesTest>>>>>>>>>>'+preSalesTest);
		 database.update(preSalesTest);

		List<Apttus_Approval__Approval_Request__c> requestsList =new  List<Apttus_Approval__Approval_Request__c>();

		Sales_Role__c currentSalesOrg = NF_TestDataFactory.createSalesRole(testUser, 'NSNC_BM', l4Ex, roleName);
		insert currentSalesOrg;
		Apttus_Approval__ApprovalRule__c appRule = NF_TestDataFactory.createApprovalRule(ruleName, true, 'Opportunity', 'Condition', 1);
		insert appRule;

		Apttus_Approval__ApprovalRuleEntry__c ruleEntry = NF_TestDataFactory.createRuleEntry(appRule.Id, 1);
		insert ruleEntry;

		List<Apttus_Approval__ApprovalRuleAssignee__c> AssigneeList = new List<Apttus_Approval__ApprovalRuleAssignee__c>();
		Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, true, false, assigneeValue);
		ruleAssignee.Apttus_Approval__AssigneeDescription__c = assigneeDesc;
		AssigneeList.add(ruleAssignee);
		insert AssigneeList;
		Test.startTest();
		Apttus_Approval__Approval_Request__c currentApprovalRequest = NF_TestDataFactory.createApprovalRequest('Notified', 'User', 'Opportunity', preSalesTest.Id, true, false, testUser.FirstName+''+testUser.LastName, testUser.Id, AssigneeList[0].Name);
		currentApprovalRequest.NF_Assignee_Type__c='Validator';
		currentApprovalRequest.Apttus_Approval__Object_Type__c = 'Opportunity';
		currentApprovalRequest.NF_Remaindercount__c=0;

		requestsList.add(currentApprovalRequest);

		Database.insert(requestsList);


		 String recordId = [Select Opportunity_ID__c from Opportunity where Id = : preSalesTest.Id][0].Opportunity_ID__c;

		// Set up a test request
		RestRequest request = new RestRequest();
		request.requestUri =URL.getSalesforceBaseUrl().toExternalForm() + webServiceURL
			+ recordId;
		request.httpMethod = 'GET';
		RestContext.request = request;


		// Call the method to test
		NF_GateparticipantswebService.Onlyquery = true;
		NF_GateparticipantswebService.GAteParticipantsPageseparation participants = NF_GateparticipantswebService.myoppApprovalrelatedlist();
		 Test.stopTest();
		// Verify results
		System.assert(participants != null);
	}

	@isTest static void testGetGateParticipantsWinTheCaseBypass(){

		User testUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
		insert testUser;

		Account currentAccount = NF_TestDataFactory.createAccount('132456783');
		currentAccount.L4Name__c = l4Ex;
		insert currentAccount;

		Opportunity currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, GlobalConstants.WIN_THE_CASE_NEGOTIATE, GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL, Date.today().addDays(10), 700);
		currentOpportunity.Business_Type__c=GlobalConstants.STANDARDOPPORTUNITY;
		currentOpportunity.Contract_Signing_Entity__c='fALU';
		currentOpportunity.Lead_BG__c = GlobalConstants.Lead_BG_MN;
		currentOpportunity.Opportunity_ID__c = oppId;
		currentOpportunity.Blanket_Approval_Condition__c='Blanket Approval for T&C';
		insert currentOpportunity;

		 Offer__c offer = TestDataFactory.OfferCreation(1, currentOpportunity)[0];
			offer.No_LoA__c = true;
			insert offer;

		List<Apttus_Approval__Approval_Request__c> requestsList =new  List<Apttus_Approval__Approval_Request__c>();

		Sales_Role__c currentSalesOrg = NF_TestDataFactory.createSalesRole(testUser, 'NSNC_BM', l4Ex, roleName);
		insert currentSalesOrg;
		Apttus_Approval__ApprovalRule__c appRule = NF_TestDataFactory.createApprovalRule(ruleName, true, 'Opportunity', 'Condition', 1);
		insert appRule;

		Apttus_Approval__ApprovalRuleEntry__c ruleEntry = NF_TestDataFactory.createRuleEntry(appRule.Id, 1);
		insert ruleEntry;

		List<Apttus_Approval__ApprovalRuleAssignee__c> AssigneeList = new List<Apttus_Approval__ApprovalRuleAssignee__c>();
		Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, true, false, assigneeValue);
		ruleAssignee.Apttus_Approval__AssigneeDescription__c = assigneeDesc;
		AssigneeList.add(ruleAssignee);
		insert AssigneeList;
		Test.startTest();
		Apttus_Approval__Approval_Request__c currentApprovalRequest = NF_TestDataFactory.createApprovalRequest('Notified', 'User', 'Opportunity', currentOpportunity.Id, true, false, testUser.FirstName+''+testUser.LastName, testUser.Id, AssigneeList[0].Name);
		currentApprovalRequest.NF_Assignee_Type__c='Validator';
		currentApprovalRequest.Apttus_Approval__Object_Type__c = 'Opportunity';
		currentApprovalRequest.NF_Remaindercount__c=0;

		requestsList.add(currentApprovalRequest);

		Database.insert(requestsList);

		// Set up a test request
		RestRequest request = new RestRequest();
		request.requestUri =URL.getSalesforceBaseUrl().toExternalForm() + webServiceURL
			+ currentOpportunity.Opportunity_ID__c;
		request.httpMethod = 'GET';
		RestContext.request = request;

		// Call the method to test
		NF_GateparticipantswebService.Onlyquery = true;
		NF_GateparticipantswebService.GAteParticipantsPageseparation participants = NF_GateparticipantswebService.myoppApprovalrelatedlist();
		 Test.stopTest();
		// Verify results
		System.assert(participants != null);
	}

	@isTest static void testGetGateParticipantsBypasses(){

		User testUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
		insert testUser;

		Account currentAccount = NF_TestDataFactory.createAccount('132456783');
		currentAccount.L4Name__c = l4Ex;
		insert currentAccount;

		List<Opportunity> oppties = new List<Opportunity>();
		Opportunity currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, GlobalConstants.IDENTIFY_OPPORTUNITY, GlobalConstants.PLANNED, Date.today().addDays(10), 700);
		currentOpportunity.Opportunity_ID__c = oppId;
		oppties.add(currentOpportunity);

		Opportunity currentOpportunity1 = NF_TestDataFactory.createOpportunity(currentAccount.Id, GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS, Date.today().addDays(10), 700);
		currentOpportunity1.Gate_3_Bypass_no_offer_support__c = true;
		currentOpportunity1.Opportunity_ID__c = oppId.substring(0, oppId.length()-2)+'3';
		oppties.add(currentOpportunity1);

		Opportunity currentOpportunity2 = NF_TestDataFactory.createOpportunity(currentAccount.Id, GlobalConstants.HANDOVER_OPPTY, GlobalConstants.PTA_HANDOVER, Date.today().addDays(10), 700);
		currentOpportunity2.Gate_6_Bypass_No_Execute_needed__c = true;
		currentOpportunity2.Opportunity_ID__c = oppId.substring(0, oppId.length()-2)+'2';
		oppties.add(currentOpportunity2);

		Opportunity currentOpportunity3 = NF_TestDataFactory.createOpportunity(currentAccount.Id,'Completed', 'Closed', Date.today().addDays(10), 700);
		currentOpportunity3.Opportunity_ID__c = oppId.substring(0, oppId.length()-2)+'7';
		oppties.add(currentOpportunity3);

		insert oppties;
		// Set up a test request
		Test.startTest();
		for(Opportunity oppty : oppties){
			RestRequest request = new RestRequest();
			request.requestUri =URL.getSalesforceBaseUrl().toExternalForm() + webServiceURL
	+ oppty.Opportunity_ID__c;
			request.httpMethod = 'GET';
			RestContext.request = request;
			// Call the method to test
			NF_GateparticipantswebService.Onlyquery = true;
			NF_GateparticipantswebService.myoppApprovalrelatedlist();
		}
		 Test.stopTest();
	}

}