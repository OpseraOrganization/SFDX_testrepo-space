@isTest 
private class NF_FacilitatorNotificationCtrlTest {

	private static User adminUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User salesUser = NF_TestDataFactory.createAdminUser('Nokia Sales Profile');

	private static Opportunity currentOpportunity;
	private static Offer__c offer;
	private static Account currentAccount;

	private static String l5 = 'EUR GCBT Vodafone';
	private static String l4 = 'Market Europe';
	private static String stageName;
	private static String phaseStatus;
	private static Double totalValue = 1000.0;
 	private static Boolean scopeAligned = false;
	private static Boolean bypassG2 = false;
	private static Boolean bypassG3 = false;
	private static Boolean offerBypass = false;
	private static Boolean blanketApp = false;
	private static Boolean bypassG6 = false;
	private static String teamMemberRole;
	private static User teamMember;

	public static void setup(){
		currentAccount = NF_TestDataFactory.createAccount('301456783');
		currentAccount.L5Name__c = l5;
		currentAccount.L4Name__c = l4;
		insert currentAccount;

		currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, stageName, phaseStatus, Date.today().addDays(10), 100);
		currentOpportunity.Business_Type__c='Standard Opportunity';
		currentOpportunity.Contract_Signing_Entity__c='fALU';
		currentOpportunity.Lead_BG__c = 'CNS';
		currentOpportunity.Lead_BU__c = 'CNS';
		currentOpportunity.Supporting_BGs_BUs__c = 'MN;NI - OPTICS';
		currentOpportunity.Unweighted_Amount_EUR__c = totalValue;
		currentOpportunity.Gate_2_Bypass_no_complex_offer__c = bypassG2;
		currentOpportunity.Gate_3_Bypass_no_offer_support__c = bypassG3;
		currentOpportunity.Gate_6_Bypass_No_Execute_needed__c = bypassG6;
		if(blanketApp){
			currentOpportunity.Blanket_Approval_Condition__c='Blanket Approval for T&C';
		}
		insert currentOpportunity;
	}

	public static void setOffer(){

		offer = TestDataFactory.OfferCreation(1, currentOpportunity)[0];
		if(offerBypass){
			Sales_Role__c currentSalesOrg = NF_TestDataFactory.createSalesRole(teamMember, 'NSND_PrMBG', l5, '5 - BG Pricing Manager');
			insert currentSalesOrg;
			offer.LOA_Bypass__c = GlobalConstants.PICKLIST_VALUE_AUTHORIZED_FOR_PRICING_MANAGER;

			List<OpportunityTeamMember> opptyTeamMembers = TestDataFactory.optyTeamMemberCreation(1, teamMember, currentOpportunity);
			opptyTeamMembers[0].TeamMemberRole = teamMemberRole;
			insert opptyTeamMembers;

		} else {
			offer.LoA_Approval_Level__c ='C';
			offer.LoA_Level_Before_Trigger_Approval__c = 'A';
		}

		insert offer;
	}

	public static void setOpportunityTeam(){
		List<OpportunityTeamMember> opptyTeamMembers = TestDataFactory.optyTeamMemberCreation(1, teamMember, currentOpportunity);
		opptyTeamMembers[0].TeamMemberRole = teamMemberRole;
		insert opptyTeamMembers;
	}

	public static void setApexPage(String submitForApproval, String source, String objectId){
		ApexPages.currentPage().getParameters().put('submitForApproval', submitForApproval);
		ApexPages.currentPage().getParameters().put('from', source);
		ApexPages.currentPage().getParameters().put('oppId', objectId);
	}

	//Test 1 - Submit for bypass G2
	testMethod static void testG2Bypass(){
		insert adminUser;
		System.runAs(adminUser){
			stageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			phaseStatus = GlobalConstants.PLANNED;
			totalValue = 21000000.0;
			bypassG2 = true;
			PageReference redirectPage;
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();

			setup();
			setApexPage('true','PREVIEWSUBMITAPPROVALS',currentOpportunity.Id);
			Test.startTest();
			redirectPage = approvalsPageCtrl.init();
			Test.stopTest();
			System.assert(redirectPage.getUrl().containsIgnoreCase('NF_BypassPreviewAndSubmit'));
		}
	}

	//Test 2 - Submit for approval G2
	testMethod static void testG2Approval(){
		insert adminUser;
		System.runAs(adminUser){
			stageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			phaseStatus = GlobalConstants.PLANNED;
			totalValue = 21000000.0;
			PageReference redirectPage;
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();

			setup();
			setApexPage('true','PREVIEWSUBMITAPPROVALS',currentOpportunity.Id);
			Test.startTest();
			//first part
			approvalsPageCtrl.init();
			//System.assert(ApexPages.getMessages()[0].getDetail().contains(Label.MultiBGOver20PleaseCheckFieldsErrorInfo));
			//second part
			currentOpportunity.Customer_Request__c = 'test';
			currentOpportunity.StrategicContextCompetitiveSituation__c = 'test';
			update currentOpportunity;
			approvalsPageCtrl.init();
			approvalsPageCtrl.cancel();
			approvalsPageCtrl.saveAndReturn();
			redirectPage = approvalsPageCtrl.proceed();
			Test.stopTest();
			System.assert(redirectPage.getUrl().containsIgnoreCase('APTSCU_PreviewApproval'));
		}
	}

	//Test 3 - Submit for bypass G3
	testMethod static void testG3Bypass(){
		insert adminUser;
		System.runAs(adminUser){
			stageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			phaseStatus = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			bypassG3 = true;
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();
			PageReference redirectPage;

			setup();
			setApexPage('true','PREVIEWSUBMITAPPROVALS',currentOpportunity.Id);
			Test.startTest();
			redirectPage = approvalsPageCtrl.init();
			Test.stopTest();
			System.assert(redirectPage.getUrl().containsIgnoreCase('NF_BypassPreviewAndSubmit'));
		}
	}

	//Test 4 - Submit for approval G3
	testMethod static void testG3Approval(){
		insert adminUser;
		System.runAs(adminUser){
			stageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			phaseStatus = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();
			PageReference redirectPage;

			setup();
			setApexPage('true','PREVIEWSUBMITAPPROVALS',currentOpportunity.Id);
			Test.startTest();
			redirectPage = approvalsPageCtrl.init();
			Test.stopTest();
			System.assert(ApexPages.getMessages()[0].getDetail().contains(GlobalConstants.GATE_MANAGEMENT_WTD_ERROR));
		}
	}

	//Test 5 - Submit for bypass G4
	testMethod static void testG4Bypass(){
		insert adminUser;
		System.runAs(adminUser){
			stageName = GlobalConstants.CREATE_OFFER;
			phaseStatus = GlobalConstants.OFFER_IN_PROGRESS;
			offerBypass = true;
			teamMember = adminUser;
			teamMemberRole = GlobalConstants.OFFER_OPPTY_TEAM_ROLE_PRICING_MANAGER;
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();
			PageReference redirectPage;

			setup();
			Test.startTest();
			setOffer();
			setApexPage('true','PREVIEWSUBMITAPPROVALS',currentOpportunity.Id);
			redirectPage = approvalsPageCtrl.init();
			Test.stopTest();
			System.assert(redirectPage.getUrl().containsIgnoreCase('NF_BypassPreviewAndSubmit'));
		}
	}

	//Test 6 - Submit for approval G4
	testMethod static void testG4Approval(){
		insert salesUser;
		System.runAs(salesUser){
			stageName = GlobalConstants.CREATE_OFFER;
			phaseStatus = GlobalConstants.OFFER_IN_PROGRESS;
			PageReference redirectPage;
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();

			setup();
			setApexPage('true','PREVIEWSUBMITAPPROVALS',currentOpportunity.Id);
			Test.startTest();
			redirectPage = approvalsPageCtrl.init();
			Test.stopTest();
			System.assert(ApexPages.getMessages()[0].getDetail().contains(GlobalConstants.GATE_MANAGEMENT_WTD_ERROR));
		}
	}

  	//Test 7 - Submit for bypass G5
	testMethod static void testG5Bypass(){
		insert adminUser;
		System.runAs(adminUser){
			stageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			phaseStatus = GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL;
			blanketApp = true;
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();
			PageReference redirectPage;

			setup();
			Test.startTest();
			setOffer();
			setApexPage('true','PREVIEWSUBMITAPPROVALS',currentOpportunity.Id);
			redirectPage = approvalsPageCtrl.init();
			Test.stopTest();
			System.assert(redirectPage.getUrl().containsIgnoreCase('NF_BypassPreviewAndSubmit'));
		}
	}

	//Test 8 - Submit for approval G5
	testMethod static void testG5Approval(){
		insert salesUser;
		System.runAs(salesUser){
			stageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			phaseStatus = GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL;
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();
			setup();
			setApexPage('true','PREVIEWSUBMITAPPROVALS',currentOpportunity.Id);
			Test.startTest();
			approvalsPageCtrl.init();
			Test.stopTest();
			System.assert(ApexPages.getMessages()[0].getDetail().contains(GlobalConstants.GATE_MANAGEMENT_WTD_ERROR));
		}
	}


	//Test 9 - Submit for approval to Win Declaration
	testMethod static void testWinDeclarationApproval(){
		insert adminUser;
		PageReference redirectPage;
		System.runAs(adminUser){
			stageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			phaseStatus = GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL;
			setup();
			currentOpportunity = [Select id, Gate_2_Bypass_no_complex_offer__c from Opportunity where id=:currentOpportunity.Id];
			currentOpportunity.StageName=GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			currentOpportunity.Phase_Status__c=GlobalConstants.PENDING_WIN_LOSS_DECLARATION;
			currentOpportunity.Apttus_Approval__Approval_Status__c = 'Approved';
			currentOpportunity.Sales_Outcome__c = GlobalConstants.WON_REQUESTED;
			Test.startTest();
			update currentOpportunity;
			setApexPage('true','PREVIEWSUBMITAPPROVALS',currentOpportunity.Id);
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();
			redirectPage = approvalsPageCtrl.init();
			Test.stopTest();
			System.assert(redirectPage.getUrl().containsIgnoreCase('APTSCU_PreviewApproval'));
		}
	}


	//Test 10 - Submit for bypass G6
	testMethod static void testG6Bypass(){
		insert adminUser;
		System.runAs(adminUser){
			stageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			phaseStatus = GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL;
			bypassG6 = true;
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();
			PageReference redirectPage;

			setup();
			Test.startTest();
			currentOpportunity = [Select id, Gate_2_Bypass_no_complex_offer__c from Opportunity where id=:currentOpportunity.Id];
			currentOpportunity.StageName=GlobalConstants.HANDOVER_OPPTY;
			currentOpportunity.Phase_Status__c=GlobalConstants.PTA_HANDOVER;
			currentOpportunity.Apttus_Approval__Approval_Status__c = 'Approved';
			update currentOpportunity;
			setApexPage('true','PREVIEWSUBMITAPPROVALS',currentOpportunity.Id);
			redirectPage = approvalsPageCtrl.init();
			Test.stopTest();
			System.assert(redirectPage.getUrl().containsIgnoreCase('NF_BypassPreviewAndSubmit'));
		}
	}
}