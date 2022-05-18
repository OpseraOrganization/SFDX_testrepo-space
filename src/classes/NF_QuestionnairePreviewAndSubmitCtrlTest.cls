/**
* @name	NF_QuestionnairePreviewAndSubmitCtrlTest
* @author  Sara Elalaoui
* @since   Feb 06, 2017
* @desc	This Class is used to test the Questionnaire Preview And Submit
* @history
**/
@isTest
private class NF_QuestionnairePreviewAndSubmitCtrlTest {
	private static User testUser = NF_TestDataFactory.createAdminUser('Data Loader Profile');
	private static User testUser1 = NF_TestDataFactory.createAdminUser('System Administrator');
	private static Account currentAccount;
	private static Opportunity currentOpportunity;
	private static Offer__c currentOffer;
	private static product2 prod ;
	private static Nokia_Financial_Calendar__c nokiaFinCal ;
	private static List<Order_Intake_Forecast__c> oifs=new List<Order_Intake_Forecast__c>();
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.SWX_UPSELL_PROPOSAL_RECORD_TYPE).getRecordTypeId();
	private static String market= 'Market North America';

	public static void setupBasic(String market, String accountType, String stageName, String phaseStatus, String businessType){

		List<Account> currentAccountList = NF_TestDataFactory.getAccounts(1);
		currentAccount = currentAccountList[0];
		currentAccount.AccountNumber='3017872';
		currentAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(accountType).getRecordTypeId();
		currentAccount.L4Name__c = market;
		insert currentAccount;

		currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, stageName, phaseStatus, Date.today().addDays(10), 7000000);
		currentOpportunity.Lead_BG__c='MN';
		currentOpportunity.Lead_BU__c='MN';
		currentOpportunity.Probability = 50;
		currentOpportunity.RecordTypeId = oppDirectRecordTypeId;
		currentOpportunity.Business_Type__c = businessType;
		insert currentOpportunity;

	}

	public static void setupOIF(Double oifValue){
		Competitor__c compObj = new Competitor__c();
		compObj.Opportunity__c = currentOpportunity.id;
		compObj.Competitor_New__c = 'Adva';
		compObj.Primary_Competitor__c = true;
		insert compObj;

		Nokia_Financial_Calendar__c nokiaFinCalCreation = TestdataFactory.nokiaFinCalCreation(1)[0];
		insert nokiaFinCalCreation;


		Product2 prod = TestDataFactory.productCreation(1)[0];
		prod.Business_Group__c= 'NI';
		prod.Family= null;
		database.insert(prod);

		oifs = TestDataFactory.orderIntakeCreation(1,currentOpportunity,prod,nokiaFinCalCreation);
		oifs[0].Forecast_Category__c = 'Upside';
		oifs[0].OIF_Value_EUR__c= oifValue;
		oifs[0].Rev_RecPlan_Receipt__c = nokiaFinCalCreation.Id;
		insert oifs;

	}

	public static void setupAdditional(String market, String loaLevel){

		currentOffer = TestDataFactory.OfferCreation(1, currentOpportunity)[0];
		currentOffer.LoA_Approval_Level__c = loaLevel;
		insert currentOffer;

		Sales_Role__c salesRoleRec = NF_TestDataFactory.createSalesRole(testUser1,'NSNC_PrMBG',market,'4 - BG Pricing Manager');
		insert salesRoleRec;

		Offer_Team__c offerTeamObj = TestDataFactory.offerTeamCreation(1,currentOffer,testUser1)[0];
		offerTeamObj.Team_Member_Role__c = GlobalConstants.OFFER_OPPTY_TEAM_ROLE_PRICING_MANAGER;
		insert offerTeamObj;
	}

	testMethod static void testSWUpsellOppty(){
		System.runAs(testUser1){
			setupBasic(market, GlobalConstants.CUSTOMER, GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS, GlobalConstants.STANDARDOPPORTUNITY);
			Test.startTest();
			List <SWx_Upsell_Proposal__c> upsellProposalList = TestDataFactory.upsellList(1,currentAccount);
			upsellProposalList[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
			upsellProposalList[0].RecordTypeID=swxRecordTypeId;
			upsellProposalList[0].Sold_To_Party__c = currentAccount.id;
			upsellProposalList[0].Proposal_Recommendation_Type__c = CSWXGlobalConstant.SW_Recommendation;
			upsellProposalList[0].Account_ID__c = currentAccount.id;
			database.insert(upsellProposalList);
			currentOpportunity.SWx_Upsell_Proposal__c = upsellProposalList[0].Id;
			update currentOpportunity;

			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_QuestionnairePreviewAndSubmitCtrl questionnairePreviewAndSubmitCtrl= new NF_QuestionnairePreviewAndSubmitCtrl();
			questionnairePreviewAndSubmitCtrl.init();
			Test.stopTest();

		}
	}

	testMethod static void testInvalidAccount(){
		System.runAs(testUser1){
			setupBasic(market, GlobalConstants.CUSTOMER, GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS, GlobalConstants.STANDARDOPPORTUNITY);
			Test.startTest();
			currentAccount.AccountNumber = '';
			update currentAccount;

			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_QuestionnairePreviewAndSubmitCtrl questionnairePreviewAndSubmitCtrl= new NF_QuestionnairePreviewAndSubmitCtrl();
			questionnairePreviewAndSubmitCtrl.init();
			questionnairePreviewAndSubmitCtrl.cancel();
			Test.stopTest();
		}
	}

	testMethod static void testCloseOutcome(){
		System.runAs(testUser1){
			setupBasic(market, GlobalConstants.CUSTOMER, GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS, GlobalConstants.STANDARDOPPORTUNITY);
			Test.startTest();
			currentOpportunity.StageName=GlobalConstants.CANCELLED_BY_CUSTOMER;
			currentOpportunity.Phase_Status__c=GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON;
			currentOpportunity.Sales_Outcome_Reason__c = GlobalConstants.FREASON;
			currentOpportunity.Second_Reason__c = GlobalConstants.SREASON;
			currentOpportunity.Third_Reason__c =GlobalConstants.TREASON;
			currentOpportunity.Sales_Outcome__c = GlobalConstants.CANCEL_BY_CUSTOMER;
			update currentOpportunity;

			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_QuestionnairePreviewAndSubmitCtrl questionnairePreviewAndSubmitCtrl= new NF_QuestionnairePreviewAndSubmitCtrl();
			questionnairePreviewAndSubmitCtrl.init();
			Test.stopTest();
		}
	}

	testMethod static void testNoOIF(){
		System.runAs(testUser1){
			setupBasic(market, GlobalConstants.CUSTOMER, GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS, GlobalConstants.STANDARDOPPORTUNITY);
			Test.startTest();

			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_QuestionnairePreviewAndSubmitCtrl questionnairePreviewAndSubmitCtrl= new NF_QuestionnairePreviewAndSubmitCtrl();
			questionnairePreviewAndSubmitCtrl.init();
			Test.stopTest();
		}
	}

	testMethod static void testProspectAccount(){
		System.runAs(testUser1){
			setupBasic(market, GlobalConstants.PROSPECT, GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS, GlobalConstants.STANDARDOPPORTUNITY);
			Test.startTest();

			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_QuestionnairePreviewAndSubmitCtrl questionnairePreviewAndSubmitCtrl= new NF_QuestionnairePreviewAndSubmitCtrl();
			questionnairePreviewAndSubmitCtrl.init();
			Test.stopTest();
		}
	}

	testMethod static void testNoLeadBG(){
		System.runAs(testUser1){
			setupBasic(market, GlobalConstants.CUSTOMER, GlobalConstants.IDENTIFY_OPPORTUNITY, GlobalConstants.PLANNED, GlobalConstants.STANDARDOPPORTUNITY);
			Test.startTest();
			currentOpportunity.Lead_BG__c = null;
			update currentOpportunity;

			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_QuestionnairePreviewAndSubmitCtrl questionnairePreviewAndSubmitCtrl= new NF_QuestionnairePreviewAndSubmitCtrl();
			questionnairePreviewAndSubmitCtrl.init();
			Test.stopTest();
		}
	}

	testMethod static void testCommittedUpsell(){
		System.runAs(testUser1){
			setupBasic(market, GlobalConstants.CUSTOMER, GlobalConstants.IDENTIFY_OPPORTUNITY, GlobalConstants.PLANNED, GlobalConstants.COMMITTED_UPSELL);
			Test.startTest();
			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_QuestionnairePreviewAndSubmitCtrl questionnairePreviewAndSubmitCtrl= new NF_QuestionnairePreviewAndSubmitCtrl();
			questionnairePreviewAndSubmitCtrl.init();
			Test.stopTest();
		}
	}

	testMethod static void testWithoutOffer(){
		System.runAs(testUser1){
			setupBasic(market, GlobalConstants.CUSTOMER, GlobalConstants.CREATE_OFFER, GlobalConstants.OFFER_IN_PROGRESS, GlobalConstants.STANDARDOPPORTUNITY);
			setupOIF(5000);
			Test.startTest();
			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_QuestionnairePreviewAndSubmitCtrl questionnairePreviewAndSubmitCtrl= new NF_QuestionnairePreviewAndSubmitCtrl();
			questionnairePreviewAndSubmitCtrl.init();
			Test.stopTest();
		}
	}

	testMethod static void testOfferG4(){
		System.runAs(testUser1){
			setupBasic(market, GlobalConstants.CUSTOMER, GlobalConstants.CREATE_OFFER, GlobalConstants.OFFER_IN_PROGRESS, GlobalConstants.STANDARDOPPORTUNITY);
			setupOIF(5000);
			Test.startTest();
			setupAdditional(market, 'C');
			currentOffer.G4_passed__c = true;
			update currentOffer;
			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_QuestionnairePreviewAndSubmitCtrl questionnairePreviewAndSubmitCtrl= new NF_QuestionnairePreviewAndSubmitCtrl();
			questionnairePreviewAndSubmitCtrl.init();
			Test.stopTest();
		}
	}

	testMethod static void testWinTheCaseOffer(){
		System.runAs(testUser1){
			setupBasic(market, GlobalConstants.CUSTOMER, GlobalConstants.WIN_THE_CASE_NEGOTIATE, GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL, GlobalConstants.STANDARDOPPORTUNITY);
			setupOIF(5000);
			Test.startTest();
			setupAdditional(market, null);
			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_QuestionnairePreviewAndSubmitCtrl questionnairePreviewAndSubmitCtrl= new NF_QuestionnairePreviewAndSubmitCtrl();
			questionnairePreviewAndSubmitCtrl.init();
			Test.stopTest();
		}
	}

	testMethod static void testMarkets(){
		System.runAs(testUser1){
			List<Account_Market__c> markets = new List<Account_Market__c>{new Account_Market__c(Name= 'Market Greater China'),new Account_Market__c(Name= 'Market Europe')} ;
			insert markets;

			setupBasic(market, GlobalConstants.CUSTOMER, GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS, GlobalConstants.STANDARDOPPORTUNITY);
			setupOIF(5000);
			Test.startTest();
			setupAdditional(market, 'C');
			currentOffer.LOA_Bypass__c = GlobalConstants.PICKLIST_VALUE_AUTHORIZED_FOR_PRICING_MANAGER;
			update currentOffer;
			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_QuestionnairePreviewAndSubmitCtrl questionnairePreviewAndSubmitCtrl= new NF_QuestionnairePreviewAndSubmitCtrl();
			questionnairePreviewAndSubmitCtrl.init();
			Test.stopTest();
		}
	}

	testMethod static void testBypassWithOIF(){
		System.runAs(testUser1){
			setupBasic(market, GlobalConstants.CUSTOMER, GlobalConstants.CREATE_OFFER, GlobalConstants.OFFER_IN_PROGRESS, GlobalConstants.STANDARDOPPORTUNITY);
			setupOIF(5000005);
			Test.startTest();
			setupAdditional(market, 'C');
			currentOffer.LOA_Bypass__c = GlobalConstants.PICKLIST_VALUE_AUTHORIZED_FOR_PRICING_MANAGER;
			update currentOffer;
			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_QuestionnairePreviewAndSubmitCtrl questionnairePreviewAndSubmitCtrl= new NF_QuestionnairePreviewAndSubmitCtrl();
			questionnairePreviewAndSubmitCtrl.init();
			Test.stopTest();
		}
	}
}