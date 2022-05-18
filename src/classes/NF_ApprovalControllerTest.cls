@isTest 
public class NF_ApprovalControllerTest {

	private static User testUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User testUser1 = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User testUser2 = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);

	private static final Id directRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id PSR_ReadOnlyRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_PSR_RECORD_TYPE).getRecordTypeId();

	private static Account currentAccount;
	private static Opportunity currentOpportunity;

	private static Apttus_Approval__Approval_Request__c currentApprovalRequest;
	private static Apttus_Approval__Approval_Request__c currentApprovalRequest1;
	private static Apttus_Approval__Approval_Request__c currentApprovalRequest2;
	private static Apttus_Approval__Approval_Request__c currentApprovalRequest3;
	private static Apttus_Approval__Approval_Request__c currentApprovalRequest4;
	private static Sales_Role__c currentSalesOrg;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee1;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee2;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee3;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee4;

	Private Static List<Apttus_Approval__Approval_Request__c> CurrentRequest=new  List<Apttus_Approval__Approval_Request__c>();

	Private Static List<Opportunity> opportunityList = new List<Opportunity>();

	public static void setup(String stageName, String phaseStatus){

		currentAccount = NF_TestDataFactory.createAccount('132456783');
		currentAccount.L4Name__c = 'LAT CARSO CT CO';
		insert currentAccount;

		currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, stageName, phaseStatus, Date.today().addDays(10), 700);
		currentOpportunity.Business_Type__c=GlobalConstants.STANDARDOPPORTUNITY;
		currentOpportunity.Contract_Signing_Entity__c='fALU';
		currentOpportunity.Lead_BG__c = 'MN';
		insert currentOpportunity;

		currentSalesOrg = NF_TestDataFactory.createSalesRole(testUser, 'NSNC_BM', 'LAT CARSO CT CO', '4 - RBC Presales Head AA G3 MU');
		insert currentSalesOrg;
		Apttus_Approval__ApprovalRule__c appRule = NF_TestDataFactory.createApprovalRule('Rule A', true, 'Opportunity', 'Condition', 1);
		insert appRule;

		Apttus_Approval__ApprovalRuleEntry__c ruleEntry = NF_TestDataFactory.createRuleEntry(appRule.Id, 1);
		insert ruleEntry;

		String assigneeValue ='Sales_Role__c(Role_Code__c=\'NSN%C_BM\' AND ( O__c =\':Org_L4__c\' OR __c =\':Org_L5__c\' OR O__c =\':Org_L6__c\' OR O__c =\':Org_L7__c\') AND Active__c=true).User__c';
		String assigneeValue1 = 'Sales_Role__c (Role_Code__c =\'NSN%C_BM\' AND O__c =\':Org_L4__c\' AND Active__c=true).User__c';
		String assigneeValue2 = 'Sales_Role__c (Role_Code__c =\'NMS%D_BM \' AND O__c =\':Org_L4__c\' AND Active__c=true).User__c';
		String assigneeValue3 ='Sales_Role__c(Role_Code__c=\'NSN%C_BM\' AND ( O__c =\':Org_L4__c\' OR __c =\':Org_L5__c\' OR O__c =\':Org_L6__c\' OR O__c =\':Org_L7__c\') AND Active__c=true and BG__c=\'NSW\').User__c';

		List<Apttus_Approval__ApprovalRuleAssignee__c> AssigneeList = new List<Apttus_Approval__ApprovalRuleAssignee__c>();
		ruleAssignee = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, true, false, assigneeValue);
		ruleAssignee.Apttus_Approval__AssigneeDescription__c = 'NSNC_BM, Validator';
		AssigneeList.add(ruleAssignee);

		ruleAssignee1 = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, true, false, assigneeValue1);
		ruleAssignee1.Apttus_Approval__AssigneeDescription__c = 'NSNC_BM, Validator';
		AssigneeList.add(ruleAssignee1);

		ruleAssignee2 = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, true, false, assigneeValue2);
		ruleAssignee2.Apttus_Approval__AssigneeDescription__c = 'NMSD_BM, Validator';
		AssigneeList.add(ruleAssignee2);

		ruleAssignee3 = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, true, false, assigneeValue2);
		ruleAssignee3.Apttus_Approval__AssigneeDescription__c = 'NMSE_BM, Approver';
		AssigneeList.add(ruleAssignee3);

		ruleAssignee4 = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, true, false, assigneeValue3);
		ruleAssignee4.Apttus_Approval__AssigneeDescription__c = 'NMSG_BM, Validator';
		AssigneeList.add(ruleAssignee4);
		insert AssigneeList;

		currentApprovalRequest = NF_TestDataFactory.createApprovalRequest('Notified', 'User', 'Opportunity', currentOpportunity.Id, true, false, testUser.FirstName+''+testUser.LastName, testUser.Id, AssigneeList[0].Name);
		currentApprovalRequest.Apttus_Approval__DelegateApproverIds__c=testUser.Id+','+testUser1.Id;
		currentApprovalRequest.NF_Assignee_Type__c='Validator';
		currentApprovalRequest.NF_Remaindercount__c=0;
		CurrentRequest.add(currentApprovalRequest);

		currentApprovalRequest1 = NF_TestDataFactory.createApprovalRequest('Notified', 'User', 'Opportunity', currentOpportunity.Id, true, false, testUser.FirstName+''+testUser.LastName, testUser.Id, AssigneeList[1].Name);
		currentApprovalRequest1 .NF_Assignee_Type__c='Approver';
		currentApprovalRequest1 .Apttus_Approval__Approval_Status__c='Submitted';
		currentApprovalRequest1.Apttus_Approval__DelegateApproverIds__c=testUser1.Id+','+testUser2.Id;
		CurrentRequest.add(currentApprovalRequest1);


		currentApprovalRequest2 = NF_TestDataFactory.createApprovalRequest('Assigned', 'User', 'Opportunity', currentOpportunity.Id, true, false, testUser.FirstName+''+testUser.LastName, testUser.Id, AssigneeList[2].Name);
		currentApprovalRequest2.NF_Assignee_Type__c='Approver';
		currentApprovalRequest2.Apttus_Approval__Approval_Status__c='Submitted';
		currentApprovalRequest2.Apttus_Approval__DelegateApproverIds__c=testUser1.Id+','+testUser2.Id;
		CurrentRequest.add(currentApprovalRequest2);

		currentApprovalRequest3 = NF_TestDataFactory.createApprovalRequest('Notified', 'User', 'Opportunity', currentOpportunity.Id, true, false, testUser.FirstName+''+testUser.LastName, testUser.Id, AssigneeList[3].Name);
		currentApprovalRequest3.Apttus_Approval__DelegateApproverIds__c=testUser1.Id+','+testUser2.Id;
		currentApprovalRequest3.NF_Assignee_Type__c='Validator';
		currentApprovalRequest3.Validator_Status__c='Approved';
		currentApprovalRequest3.NF_Remaindercount__c=0;
		CurrentRequest.add(currentApprovalRequest3);

		currentApprovalRequest4 = NF_TestDataFactory.createApprovalRequest('Assigned', 'User', 'Opportunity', currentOpportunity.Id, true, false, testUser.FirstName+''+testUser.LastName, testUser.Id, AssigneeList[4].Name);
		currentApprovalRequest4.NF_Assignee_Type__c='Stakeholder for Information';
		currentApprovalRequest4.Apttus_Approval__Approval_Status__c='Notified';
		currentApprovalRequest4.Apttus_Approval__DelegateApproverIds__c=testUser1.Id+','+testUser2.Id;
		CurrentRequest.add(currentApprovalRequest4);
		Database.insert(CurrentRequest);
	}

	@isTest static void NF_ApprovlcontrollerTest() {

		insert testUser;
		insert testUser1;
		insert testUser2;
		system.runAs(testUser){
			setup(GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS);
			Test.startTest();
			NF_ApprovalController.Onlyquery=true;
			NF_ApprovalController.gate_bypass=false;
			DateTime myDateTime = DateTime.newInstance(2006, 3, 16, 23, 0, 0);

			NF_ApprovalController.myoppApproval_relatedlist(currentOpportunity.Id,'Opportunity',false);
			NF_ApprovalController.getAllFieldsSOQL('Apttus_Approval__Approval_Request__c','Apttus_Approval__Object_Id__c = :currentRecordId And Apttus_Approval__Object_Type__c = :Objecttype AND Apttus_Approval__Assigned_To_Id__c!= null order by Name');
			NF_ApprovalController.sendInvite('salesforce@example.com','Hi','Test class',myDateTime,myDateTime,'chennai','salesforce@example.com',null,true);

			Test.stopTest();
		}
	}

	@isTest static void NF_ApprovlcontrollerPresalesTest() {
		insert testUser;
		insert testUser1;
		insert testUser2;
		system.runAs(testUser){
			setup(GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS);
			Test.startTest();
			List<Opportunity> psroOpportunity  = TestDataFactory.preSalesOpportunityCreation(1, currentAccount, currentOpportunity);
			psroOpportunity[0].PSR_Pre_Sales_Risk_Opportunity_Type__c = GlobalConstants.RISK_ORDER;
			psroOpportunity[0].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c=GlobalConstants.RISK_ORDER_ONLY;
			psroOpportunity[0].PSR_Date_PO_Expected__c=null;
			psroOpportunity[0].CloseDate = System.Today();
			psroOpportunity[0].PSR_Description_Justification__c=null;
			insert psroOpportunity;

			NF_ApprovalController.Onlyquery=true;
			NF_ApprovalController.gate_bypass=false;
			NF_ApprovalController.myoppApproval_relatedlist( psroOpportunity[0].Id,'Opportunity',false);
		}
		test.stopTest();
	}


	@isTest static void NF_ApprovlcontrollerG2bypassTest() {

		insert testUser;
		insert testUser1;
		insert testUser2;
		system.runAs(testUser){
			setup(GlobalConstants.IDENTIFY_OPPORTUNITY, GlobalConstants.PLANNED);
			Test.startTest();
			NF_ApprovalController.myoppApproval_relatedlist(currentOpportunity.Id,'Opportunity',false);
			Test.stopTest();
		}

	}

	@isTest static void NF_ApprovlcontrollerG2Test() {

		insert testUser;
		insert testUser1;
		insert testUser2;
		system.runAs(testUser){
			setup(GlobalConstants.IDENTIFY_OPPORTUNITY, GlobalConstants.PLANNED);
			currentOpportunity.Unweighted_Amount_EUR__c = 21000000;
			currentOpportunity.Gate_2_Bypass_no_complex_offer__c = true;
			currentOpportunity.Supporting_BGs_BUs__c = 'CNS';
			update currentOpportunity;
			Test.startTest();
			NF_ApprovalController.Onlyquery=true;
			NF_ApprovalController.gate_bypass=false;
			NF_ApprovalController.myoppApproval_relatedlist(currentOpportunity.Id,'Opportunity',false);
			Test.stopTest();
		}

	}

	@isTest static void NF_ApprovlcontrollerG4bypassTest() {

		insert testUser;
		insert testUser1;
		insert testUser2;
		system.runAs(testUser){
			setup(GlobalConstants.CREATE_OFFER, GlobalConstants.OFFER_IN_PROGRESS);
			Test.startTest();
			NF_ApprovalController.myoppApproval_relatedlist(currentOpportunity.Id,'Opportunity',false);
			Test.stopTest();
		}
	}

	@isTest static void NF_ApprovlcontrollerG4bypassTest_1() {

		insert testUser;
		insert testUser1;
		insert testUser2;
		system.runAs(testUser){
			setup(GlobalConstants.CREATE_OFFER, GlobalConstants.OFFER_IN_PROGRESS);
			Test.startTest();
			Offer__c offer = TestDataFactory.OfferCreation(1, currentOpportunity)[0];
			offer.LoA_Approval_Level__c = null;
			insert offer;
			NF_ApprovalController.myoppApproval_relatedlist(currentOpportunity.Id,'Opportunity',false);
			Test.stopTest();
		}
	}

	@isTest static void NF_ApprovlcontrollerG4bypassTest_2() {

		insert testUser;
		insert testUser1;
		insert testUser2;
		system.runAs(testUser){
			setup(GlobalConstants.CREATE_OFFER, GlobalConstants.OFFER_IN_PROGRESS);
			currentOpportunity.Blanket_Approval_Condition__c='Blanket Approval for T&C';
			update currentOpportunity;
			Test.startTest();
			Offer__c offer = TestDataFactory.OfferCreation(1, currentOpportunity)[0];
			offer.No_LoA__c = true;
			insert offer;
			NF_ApprovalController.myoppApproval_relatedlist(currentOpportunity.Id,'Opportunity',false);
			Test.stopTest();
		}

	}

	 @isTest static void NF_ApprovlcontrollerG4Test() {

		insert testUser;
		insert testUser1;
		insert testUser2;
		system.runAs(testUser){
			setup(GlobalConstants.CREATE_OFFER, GlobalConstants.OFFER_IN_PROGRESS);
			Test.startTest();
			Offer__c offer = TestDataFactory.OfferCreation(1, currentOpportunity)[0];
			offer.LoA_Approval_Level__c = 'A';
			insert offer;
			NF_ApprovalController.Onlyquery=true;
			NF_ApprovalController.gate_bypass=false;
			NF_ApprovalController.myoppApproval_relatedlist(currentOpportunity.Id,'Opportunity',false);
			Test.stopTest();
		}
	}


	@isTest static void NF_ApprovlcontrollerClosedTest() {

		insert testUser;
		insert testUser1;
		insert testUser2;
		system.runAs(testUser){
			setup(GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS);
			Test.startTest();
			currentOpportunity.StageName = GlobalConstants.CANCELLED_BY_CUSTOMER;
			currentOpportunity.Phase_Status__c = GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON;
			update currentOpportunity;
			NF_ApprovalController.myoppApproval_relatedlist(currentOpportunity.Id,'Opportunity',false);
			Test.stopTest();
			
		}
	}
}