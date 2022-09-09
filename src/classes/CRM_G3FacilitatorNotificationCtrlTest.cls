@isTest
public class CRM_G3FacilitatorNotificationCtrlTest {
	private static User testUser = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User dataloaderUser = NF_TestDataFactory.createAdminUser('Data Loader Profile');
	private static Id upsellDealId = Schema.SObjectType.Deal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.UPSELL_DEAL_RECORD_TYPE).getRecordTypeId();
	private static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.SWX_UPSELL_PROPOSAL_RECORD_TYPE).getRecordTypeId();

	private static Opportunity currentOpportunity;
	private static Account currentAccount;

	private static String stageName;
	private static String phaseStatus;
	private static String l4;
	private static String l5;
	private static String l7;
	private static String bg;
	private static String bu;
	private static Boolean noG4PlannedDate = false;
	private static String teamMemberRole;
	private static Boolean withOIF;
	private static String roleCode;
	private static Double totalValue = 1000.0;
	private static String marketEx = 'Market Europe';
	private static String l5Ex = 'EUR GCBT Vodafone';

	public static void setup(){
		//insert account
		currentAccount = NF_TestDataFactory.createAccount('132456783');
		currentAccount.L7Name__c = l7;
		currentAccount.L5Name__c = l5;
		currentAccount.L4Name__c = l4;
		insert currentAccount;
		//insert opp
		currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, stageName, phaseStatus, Date.today().addDays(10), 100);
		currentOpportunity.Business_Type__c=GlobalConstants.STANDARDOPPORTUNITY;
		currentOpportunity.Contract_Signing_Entity__c='fALU';
		currentOpportunity.Lead_BG__c = bg;
		currentOpportunity.Lead_BU__c = bu;
		currentOpportunity.Unweighted_Amount_EUR__c = totalValue;
		currentOpportunity.Type_of_Request__c = GlobalConstants.TYPE_REQUEST_RFP_RFI;
		currentOpportunity.G3_Prepared__c = true;
		if(noG4PlannedDate) currentOpportunity.G4_Planned_Date__c = null;
		insert currentOpportunity;

	}

	public static void addTeamMember(){
		List<OpportunityTeamMember> opptyTeamMembers = TestDataFactory.optyTeamMemberCreation(1, testUser, currentOpportunity);
		opptyTeamMembers[0].TeamMemberRole = teamMemberRole;
		insert opptyTeamMembers;
	}

	public static void addOIF(){
		Product2 prod = TestDataFactory.productCreation(1)[0];
		prod.Business_Group__c='CNS';
		prod.Family= 'CNSCORE';
		database.insert(prod);
		Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
		database.insert(nokiaFinCal);
		nokiaFinCal.Start_Date__c=system.today()+1;
		nokiaFinCal.End_Date__c = system.today()+2;
		database.update(nokiaFinCal);
		List<Order_Intake_Forecast__c> oif1=new List<Order_Intake_Forecast__c>();
		oif1=TestDataFactory.orderIntakeCreation(1,currentOpportunity,prod,nokiaFinCal);
		oif1[0].Rev_RecPlan_Receipt__c = nokiaFinCal.Id;
		insert oif1;
	}

	public static void addSalesRole(){
		User delegate1User = NF_TestDataFactory.createAdminUser('System Administrator');
		insert delegate1User;
		String orgLevel = l7 != null ? l7 : l5;
		Sales_Role__c currentSalesOrg = NF_TestDataFactory.createSalesRole(dataloaderUser, roleCode, orgLevel, '5 - G3 Facilitator');
		insert currentSalesOrg;
		Apttus_Approval__Backup_Approver__c backupApprover =new Apttus_Approval__Backup_Approver__c (
			Apttus_Approval__Backup_User__c= null,
			Apttus_Approval__Cancellation_Date__c= null,
			Apttus_Approval__Comment__c= null,
			Apttus_Approval__Current_User__c= dataloaderUser.Id,
			Apttus_Approval__DelegateUserIds__c= delegate1User.Id,
			Apttus_Approval__Effective_Date__c= null,
			Apttus_Approval__Expiration_Date__c= null,
			Apttus_Approval__InEffect__c= true,
			Apttus_Approval__IsActive__c= true,
			Apttus_Approval__IsDelegate__c= true,
			Apttus_Approval__SuppressDelegateNotification__c= false,
			Apttus_Approval__Transfer_in_flight__c= true,
			Delegate_Approver1__c= delegate1User.Id
		);
		insert backupApprover;
	}


	@isTest
	public static void testFacilitatorNotif_IdentifyOppty(){
		insert testUser;
		stageName = 'Identify Opportunity';
		phaseStatus = 'Planned';
		l4 = marketEx;
		l5 = l5Ex;
		bg = 'MN';
		bu = 'MN';
		system.runAs(testUser){
			setup();
			Test.startTest();
			CRM_G3FacilitatorNotificationCtrl.FacilitatorWrapper info = CRM_G3FacilitatorNotificationCtrl.initAction(currentOpportunity.Id);
			Test.stopTest();
			System.assert(info.errorMessage.contains( String.format(Label.NF_OnlyFacilitatorCanBeNotified,new String[] {GlobalConstants.DEVELOP_OPPORTUNITY})));
		}
	}

	@isTest
	public static void testFacilitatorNotif_G3Bypass(){
		insert testUser;
		stageName = GlobalConstants.DEVELOP_OPPORTUNITY;
		phaseStatus = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
		l4 = marketEx;
		l5 = l5Ex;
		bg = 'MN';
		bu = 'MN';
		system.runAs(testUser){
			setup();
			Test.startTest();
			currentOpportunity.Gate_3_Bypass_no_offer_support__c = true;
			update currentOpportunity;
			CRM_G3FacilitatorNotificationCtrl.FacilitatorWrapper info = CRM_G3FacilitatorNotificationCtrl.initAction(currentOpportunity.Id);
			Test.stopTest();
			System.assert(info.errorMessage.contains(GlobalConstants.G3_FACILITATOR_BYPASS));
		}
	}

	@isTest
	public static void testFacilitatorNotif_G4PlannedDate(){
		insert testUser;
		stageName = GlobalConstants.DEVELOP_OPPORTUNITY;
		phaseStatus = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
		l4 = marketEx;
		l5 = l5Ex;
		bg = 'MN';
		bu = 'MN';
		noG4PlannedDate = true;
		system.runAs(testUser){
			setup();
			Test.startTest();
			CRM_G3FacilitatorNotificationCtrl.FacilitatorWrapper info = CRM_G3FacilitatorNotificationCtrl.initAction(currentOpportunity.Id);
			Test.stopTest();
			System.assert(info.errorMessage.contains(Label.NF_G4_PlannedDate_Error));
		}
	}

	@isTest
	public static void testFacilitatorNotif_WithoutOIF(){
		insert testUser;
		stageName = GlobalConstants.DEVELOP_OPPORTUNITY;
		phaseStatus = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
		l4 = marketEx;
		l5 = l5Ex;
		bg = 'MN';
		bu = 'MN';
		system.runAs(testUser){
			setup();
			Test.startTest();
			CRM_G3FacilitatorNotificationCtrl.FacilitatorWrapper info = CRM_G3FacilitatorNotificationCtrl.initAction(currentOpportunity.Id);
			Test.stopTest();
			System.assert(info.errorMessage.contains(GlobalConstants.MANDATORY_OIF_FOR_APPROVAL));
		}
	}

	@isTest
	public static void testFacilitatorNotif_AlreadyNotified(){
		insert testUser;
		stageName = GlobalConstants.DEVELOP_OPPORTUNITY;
		phaseStatus = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
		l4 = marketEx;
		l5 = l5Ex;
		bg = 'MN';
		bu = 'MN';
		system.runAs(testUser){
			setup();
			addOIF();
			Test.startTest();
			currentOpportunity.NF_Facilitator_Notified__c = true;
			update currentOpportunity;
			CRM_G3FacilitatorNotificationCtrl.FacilitatorWrapper info = CRM_G3FacilitatorNotificationCtrl.initAction(currentOpportunity.Id);
			Test.stopTest();
			System.assert(info.errorMessage.contains(Label.NF_Facilitator_already_notified));
		}
	}

	@isTest
	public static void testFacilitatorNotif_UpsellOpptyWithTeam(){
		insert testUser;
		stageName = GlobalConstants.DEVELOP_OPPORTUNITY;
		phaseStatus = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
		l4 = marketEx;
		l5 = l5Ex;
		bg = 'MN';
		bu = 'MN';
		teamMemberRole = CSWXGlobalConstant.AM;
		system.runAs(testUser){
			setup();
			Test.startTest();
			addOIF();
			addTeamMember();
			SWx_Upsell_Proposal__c upsellProposal_SWX=TestDataFactory.upsellList(1,currentAccount)[0];
			upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
			upsellProposal_SWX.Analytics_Source__c='CXM';
			upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
			upsellProposal_SWX.P20_Id__c=215616;
			upsellProposal_SWX.CurrencyIsoCode='EUR';
			upsellProposal_SWX.Unweighted_Value__c=429052;
			upsellProposal_SWX.Account_ID__c=currentAccount.Id;
			upsellProposal_SWX.Sold_To_Party__c = currentAccount.Id;
			upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
			insert upsellProposal_SWX;
			Test.stopTest();
			currentOpportunity.SWx_Upsell_Proposal__c = upsellProposal_SWX.Id;
			update currentOpportunity;
			CRM_G3FacilitatorNotificationCtrl.FacilitatorWrapper info = CRM_G3FacilitatorNotificationCtrl.initAction(currentOpportunity.Id);

			System.assert(info.facilitator != null);
		}
	}


	@isTest
	public static void testFacilitatorNotif_MarketLATQueue(){
		insert testUser;

		stageName = GlobalConstants.DEVELOP_OPPORTUNITY;
		phaseStatus = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
		l4 = 'Market Latin America';
		bg = 'NI';
		bu = 'NI - OPTICS';
		roleCode = 'NSND_OQM';

		system.runAs(testUser){
			setup();
			addOIF();
			Test.startTest();
			insert new NF_G3FacilitatorQueueMatrix__c(Name='LAT ION Optics Market Latin America', Queue_Developer_Name__c='LAT ION Optics Market Latin America', Lead_BG__c= bg, Lead_BU__c=bu, Organisation_Level_4__c= l4);
			CRM_G3FacilitatorNotificationCtrl.FacilitatorWrapper info = CRM_G3FacilitatorNotificationCtrl.initAction(currentOpportunity.Id);
			System.assert(info.queueName != null && info.queueID != null && info.facilitator == null);
			CRM_G3FacilitatorNotificationCtrl.updateOppty(currentOpportunity.Id, '{"Probability":50,"NF_Facilitator_Notified__c":true}');
			Test.stopTest();

		}
	}

	@isTest
	public static void testFacilitatorNotif_MarketNFSQueue(){
		insert testUser;

		stageName = GlobalConstants.DEVELOP_OPPORTUNITY;
		phaseStatus = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
		l4 = 'Market NFS';
		bg = 'MN';
		bu = 'MN';
		system.runAs(testUser){

			setup();
			addOIF();
			Test.startTest();
			insert new NF_G3FacilitatorQueueMatrix__c(Name='na-proposals-NFS', Queue_Developer_Name__c='na-proposals-NFS', Lead_BG__c= bg, Lead_BU__c= null,  Organisation_Level_4__c= l4,Organisation_Level_5__c=null, Type_of_Request__c= GlobalConstants.TYPE_REQUEST_RFP_RFI, Unweighted_Value__c=GlobalConstants.BELOW5M);
			CRM_G3FacilitatorNotificationCtrl.FacilitatorWrapper info = CRM_G3FacilitatorNotificationCtrl.initAction(currentOpportunity.Id);
			Test.stopTest();
			System.assert(info.queueName != null && info.queueID != null && info.facilitator == null);
		}

	}

	@isTest
	public static void testFacilitatorNotif_MarketEurope(){
		insert testUser;
		insert dataloaderUser;
		stageName = GlobalConstants.DEVELOP_OPPORTUNITY;
		phaseStatus = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
		l4 = marketEx;
		l5 = l5Ex;
		bg = 'NI';
		bu = 'NI - OPTICS';
		roleCode = 'NSND_OQM';
		system.runAs(dataloaderUser){
			setup();
			addOIF();
			Test.startTest();
			addSalesRole();
			CRM_G3FacilitatorNotificationCtrl.FacilitatorWrapper info = CRM_G3FacilitatorNotificationCtrl.initAction(currentOpportunity.Id);
			Test.stopTest();
			System.assert(info.queueName == null && info.queueID == null && info.facilitator != null);
		}
	}

	@isTest
	public static void testFacilitatorNotif_MarketNAM(){
		insert testUser;
		stageName = GlobalConstants.DEVELOP_OPPORTUNITY;
		phaseStatus = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
		l4 = 'Market North America';
		l5 = 'NE AME NAM';
		bg = 'CNS';
		bu = 'CNS';
		system.runAs(testUser){
			setup();
			addOIF();
			Test.startTest();
			insert new NF_G3FacilitatorQueueMatrix__c(Name='na-proposals-NE NE AME NSW E',Queue_Developer_Name__c= 'na-proposals-NE', Lead_BG__c= bg, Lead_BU__c= null, Organisation_Level_4__c= l4, Organisation_Level_5__c= l5, Type_of_Request__c= 'RFP/RFI', Unweighted_Value__c=GlobalConstants.BELOW5M );
			CRM_G3FacilitatorNotificationCtrl.FacilitatorWrapper info = CRM_G3FacilitatorNotificationCtrl.initAction(currentOpportunity.Id);
			System.assert(info.queueName != null && info.queueID != null && info.facilitator == null);
			Opportunity changedOppty = new Opportunity(Id=currentOpportunity.Id, Type_of_Request__c='');
			info = CRM_G3FacilitatorNotificationCtrl.recalculateFacilitator(changedOppty, new List<String>{'Type_Of_Request__c'});
			System.assert(info.queueName != null && info.queueID != null && info.facilitator == null);
			CRM_G3FacilitatorNotificationCtrl.updateOppty(currentOpportunity.Id, '{"Probability":50,"NF_Facilitator_Notified__c":true,"Queue_Id__c":\"'+info.queueID+'\"}');
			Test.stopTest();
		}
	}
}