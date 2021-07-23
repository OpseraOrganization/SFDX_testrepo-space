@isTest
private class NF_FacilitatorNotificationCtrlTest {

	private static User adminUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User salesUser = NF_TestDataFactory.createAdminUser('Nokia Sales Profile');
	
	private static Id upsellDealId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Upsell Deal').getRecordTypeId();
	private static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	
	private static Opportunity currentOpportunity;
	private static Offer__c offer;
	private static Account currentAccount;
	
	private static String l5 = 'EUR GCBT Vodafone';
	private static String l4 = 'Market Europe';
	private static String stageName;
	private static String phaseStatus;
	private static Double totalValue = 1000.0;
	private static Boolean allowBypassG2 = false;
 	private static Boolean scopeAligned = false;
	
	private static Boolean offerBypass = false;
	private static Boolean withPrM = false;
	private static String teamMemberRole;
	private static User teamMember;
	
	public static void setup(){
		//insert account
		currentAccount = NF_TestDataFactory.createAccount('301456783');
		currentAccount.L5Name__c = l5;
		currentAccount.L4Name__c = l4;
		insert currentAccount;
		//insert opp
		currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, stageName, phaseStatus, Date.today().addDays(10), 100);
		currentOpportunity.Business_Type__c='Standard Opportunity';
		currentOpportunity.Contract_Signing_Entity__c='fALU';
		currentOpportunity.Lead_BG__c = 'FN';
		currentOpportunity.Supporting_BG_MN__c = 'MN';
		
		currentOpportunity.Unweighted_Amount_EUR__c = totalValue;
		currentOpportunity.MultiBGException_AllowG2Bypass__c = allowBypassG2;
		currentOpportunity.SolutionScopeAlignedCSO__c = scopeAligned;

		insert currentOpportunity;  
	}

	public static void setOffer(){
		
		offer = TestDataFactory.OfferCreation(1, currentOpportunity)[0];
		
		if(offerBypass){
			offer.No_LoA__c = true;
			offer.Expected_LoA_G4_Approval_Level__c = 'LoA Bypass';
			offer.No_Support_Offer_Condition__c = 'Yes';
			offer.Blanket_Approval_Condition__c='Blanket Approval for T&C';
		} else {
			offer.No_Support_Offer_Condition__c = 'No';
			offer.LoA_Approval_Level__c ='C';
			offer.LoA_Level_Before_Trigger_Approval__c = 'A';
		}
		
		if(withPrM){
			Sales_Role__c currentSalesOrg = NF_TestDataFactory.createSalesRole(teamMember, 'NSND_PrMBG', l5, '5 - BG Pricing Manager');
			insert currentSalesOrg;
			offer.LOA_Bypass__c = GlobalConstants.PICKLIST_VALUE_AUTHORIZED_FOR_PRICING_MANAGER;

			List<OpportunityTeamMember> opptyTeamMembers = TestDataFactory.optyTeamMemberCreation(1, teamMember, currentOpportunity);
			opptyTeamMembers[0].TeamMemberRole = teamMemberRole;
			insert opptyTeamMembers;
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
			allowBypassG2 = true;
			PageReference redirectPage;
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();
			
			setup();
			setApexPage('false','PREVIEWSUBMITAPPROVALS',currentOpportunity.Id);
			Test.startTest();
			approvalsPageCtrl.init();
			ApexPages.currentPage().getParameters().put('submitForApproval', 'true');
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
			System.assert(ApexPages.getMessages()[0].getDetail().contains(Label.MultiBGOver20PleaseCheckFieldsErrorInfo));
			//second part
			currentOpportunity.SolutionScopeAlignedCSO__c = true;
			currentOpportunity.Expected_LoA_Approval_Level__c = 'D';
			currentOpportunity.Customer_Request__c = 'test';
			currentOpportunity.StrategicContextCompetitiveSituation__c = 'test';
			update currentOpportunity;
			approvalsPageCtrl.init();
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
			offerBypass = true;
			teamMember = adminUser;
			teamMemberRole = GlobalConstants.OFFER_OPPTY_TEAM_ROLE_PRICING_MANAGER;
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();
			PageReference redirectPage;
			
			setup();  
			setOffer();		  
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
			setOffer();		   
			setApexPage('true','PREVIEWSUBMITAPPROVALS',currentOpportunity.Id);
			Test.startTest();
			//first part - user is not facilitator
			approvalsPageCtrl.init();
			System.assert(ApexPages.getMessages()[0].getDetail().contains(Label.NF_OnlyFacilitatorCanSubmit));
			//second part - user is facilitator
			currentOpportunity.NF_Facilitator_Notified__c = true;
			currentOpportunity.NF_Facilitator_User__c = adminUser.Id;
			update currentOpportunity;
			redirectPage = approvalsPageCtrl.init();
			Test.stopTest();
			System.assert(redirectPage.getUrl().containsIgnoreCase('APTSCU_PreviewApproval'));
		}		  
	}
	
	//Test 5 - Submit for bypass G4
	testMethod static void testG4Bypass(){
		insert adminUser;
		System.runAs(adminUser){
			stageName = GlobalConstants.CREATE_OFFER;
			phaseStatus = GlobalConstants.OFFER_IN_PROGRESS;
			offerBypass = true;
			withPrM = true;
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
			teamMember = salesUser;
			teamMemberRole = GlobalConstants.OFFER_CONTROL;
			PageReference redirectPage;
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();

			setup();			
			setApexPage('true','PREVIEWSUBMITAPPROVALS',currentOpportunity.Id);
			Test.startTest();
			//first part - no offer
			approvalsPageCtrl.init();
			System.assert(ApexPages.getMessages()[0].getDetail().contains(GlobalConstants.ACTIVE_OFFER_FOR_APPROVAL));
			//second part - user is not OC
			setOffer();
			approvalsPageCtrl.init();
			System.assert(ApexPages.getMessages()[1].getDetail().contains(Label.NF_G4_and_G5_Users_Error_Info));
			//third part - user is OC
			setOpportunityTeam();
			redirectPage = approvalsPageCtrl.init();
			Test.stopTest();
			System.assert(redirectPage.getUrl().containsIgnoreCase('APTSCU_PreviewApproval'));
		}
	}

  	//Test 7 - Submit for bypass G5
	testMethod static void testG5Bypass(){
		insert adminUser;
		System.runAs(adminUser){
			stageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			phaseStatus = GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL;
			offerBypass = true;
			withPrM = true;
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
  
	//Test 8 - Submit for approval G5 
	testMethod static void testG5Approval(){
		insert salesUser;
		System.runAs(salesUser){
			stageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			phaseStatus = GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL;
			teamMember = salesUser;
			teamMemberRole = GlobalConstants.OFFER_CONTROL;
			PageReference redirectPage;
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();

			setup();			
			setApexPage('true','PREVIEWSUBMITAPPROVALS',currentOpportunity.Id);
			Test.startTest();
			//first part - no offer
			approvalsPageCtrl.init();
			System.assert(ApexPages.getMessages()[0].getDetail().contains(GlobalConstants.ACTIVE_OFFER_FOR_APPROVAL));
			//second part - user is not OC
			setOffer();
			approvalsPageCtrl.init();
			System.assert(ApexPages.getMessages()[1].getDetail().contains(Label.NF_G4_and_G5_Users_Error_Info));
			//third part - user is OC
			setOpportunityTeam();
			redirectPage = approvalsPageCtrl.init();
			Test.stopTest();
			System.assert(redirectPage.getUrl().containsIgnoreCase('APTSCU_PreviewApproval'));
		}
	}


	//Test 9 - Submit for approval to Win Declaration
	testMethod static void testWinDeclarationApproval(){
		insert adminUser;
		insert salesUser;
		PageReference redirectPage;
		System.runAs(adminUser){
			stageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			phaseStatus = GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL;
			teamMember = salesUser;
			teamMemberRole = GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE;
			setup();  
			Test.startTest();
			setOffer();
			currentOpportunity.StageName=GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			currentOpportunity.Phase_Status__c=GlobalConstants.PENDING_WIN_LOSS_DECLARATION;
			currentOpportunity.Apttus_Approval__Approval_Status__c = 'Approved';
			currentOpportunity.Sales_Outcome__c = GlobalConstants.WON_REQUESTED;
			update currentOpportunity;
			setApexPage('true','PREVIEWSUBMITAPPROVALS',currentOpportunity.Id);
			setOpportunityTeam();
		}
		System.runAs(salesUser){
			
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();
			//first part - user is not OC nor owner
			approvalsPageCtrl.init();
			System.assert(ApexPages.getMessages()[0].getDetail().contains(Label.NF_G4_and_G5_Users_Error_Info));
		}
		System.runAs(adminUser){
			//second part - user is owner
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
			offerBypass = true;
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();
			PageReference redirectPage;
			
			setup();  
			Test.startTest();
			setOffer();	 
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
	
	testMethod static void testOtherApprovals(){
		insert adminUser;
		System.runAs(adminUser){
			stageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			phaseStatus = GlobalConstants.PLANNED;
			PageReference redirectPage;
			NF_FacilitatorNotificationCtrl approvalsPageCtrl = new NF_FacilitatorNotificationCtrl();
		   
			setup();
			Test.startTest();
			setApexPage('true','APPROVALCONTEXTSUBMIT',currentOpportunity.Id);
			redirectPage = approvalsPageCtrl.init();
			System.assert(redirectPage.getUrl().containsIgnoreCase('Apttus_Approval__ApprovalContextSubmit'));
			setApexPage('true','MYAPPROVALS',currentOpportunity.Id);
			redirectPage = approvalsPageCtrl.init();
			System.assert(redirectPage.getUrl().containsIgnoreCase('Apttus_Approval__MyApprovals'));
			approvalsPageCtrl.cancel();
			Test.stopTest();
		}
	}

}