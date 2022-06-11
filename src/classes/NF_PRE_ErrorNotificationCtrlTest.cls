/**
* @name	NF_PRE_ErrorNotificationCtrlTest
* @author   
* @since   July 08, 2017
* @desc	This class helps create customized test data, used in test classes
* @history 
*/
@isTest
private class NF_PRE_ErrorNotificationCtrlTest{
	 
	private static User testUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User oc = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User testUserSales = NF_TestDataFactory.createAdminUser('Nokia Sales Profile');
	private static Account currentAccount;
	private static Opportunity currentOpportunity;
	private static List<Opportunity> opptyPSRO ;

	public static void setup(){ 		
		currentAccount = NF_TestDataFactory.createAccount('132456783');
		insert currentAccount;
		currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS, Date.today().addDays(10), 700);
		currentOpportunity.Lead_BG__c = GlobalConstants.LEAD_BG_MN;
		currentOpportunity.Lead_BU__c = GlobalConstants.LEAD_BG_MN;
		insert currentOpportunity ;
		opptyPSRO  = TestDataFactory.preSalesOpportunityCreation(3, currentAccount, currentOpportunity);
		//Risk Order
		opptyPSRO[0].PSR_Pre_Sales_Risk_Opportunity_Type__c = GlobalConstants.RISK_ORDER;
		opptyPSRO[0].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c=GlobalConstants.RISK_ORDER_ONLY;
		opptyPSRO[0].PSR_Date_PO_Expected__c= null;
		opptyPSRO[0].CloseDate = System.Today();
		opptyPSRO[0].PSR_Description_Justification__c=null;
		//Trial
		opptyPSRO[1].PSR_Pre_Sales_Risk_Opportunity_Type__c = GlobalConstants.TRIAL;
		opptyPSRO[1].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'R&D Trial';
		opptyPSRO[1].PSR_Trial_Start_Date__c=null;
		opptyPSRO[1].PSR_Trial_Duration__c=null;
		opptyPSRO[1].PSR_Date_PO_Expected__c=null;
		opptyPSRO[1].PSR_Trial_Agreement_Status__c=null;
		opptyPSRO[1].PSR_Is_Cost_Approved_In_Related_LOA_Opty__c=null;
		opptyPSRO[1].CloseDate = System.Today();
		//Demo
		opptyPSRO[2].PSR_Pre_Sales_Risk_Opportunity_Type__c = GlobalConstants.DEMO;
		opptyPSRO[2].PSR_Trial_Start_Date__c=null;
		opptyPSRO[2].PSR_Trial_Duration__c=null;
		opptyPSRO[2].CloseDate = System.Today();
		insert opptyPSRO;
	}

	@isTest static void test_init_Notifier() {
		insert testUser;
		system.runAs(testUser){
			setup();
			
			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_PRE_ErrorNotificationCtrl errorNotifCntrl = new NF_PRE_ErrorNotificationCtrl();
			errorNotifCntrl.init();
			errorNotifCntrl.cancel();
			
			Test.startTest();			
			for(Opportunity psro : opptyPSRO){
	ApexPages.currentPage().getParameters().put('oppId', psro.Id);
	errorNotifCntrl =new NF_PRE_ErrorNotificationCtrl();
	errorNotifCntrl.init();
	errorNotifCntrl.cancel();
			}
			Test.StopTest();
		}
	}
	
	@isTest static void test_init_NotifierMissingOC() {
		insert testUserSales;
		system.runAs(testUserSales){
			setup();
			
			opptyPSRO[0].PSR_Sales_Value_BG_MN__c=1000;
			opptyPSRO[0].PSR_Date_PO_Expected__c=System.today();
			opptyPSRO[0].CloseDate = System.Today();
			opptyPSRO[0].PSR_Description_Justification__c='Test';
			opptyPSRO[0].PSR_is_BOM_BOQ_document_attached__c = true;
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = false;
			Test.startTest();
			update opptyPSRO[0];

			ApexPages.currentPage().getParameters().put('oppId', opptyPSRO[0].Id);
			NF_PRE_ErrorNotificationCtrl errorNotifCntrl =new NF_PRE_ErrorNotificationCtrl();
			errorNotifCntrl.init();
			errorNotifCntrl.cancel();
			
			Test.StopTest();
		}
	}
	
	@isTest static void test_init_Notifier_NoMissingParam() {
		insert testUser;
		system.runAs(testUser){
			setup();
			insert oc;
			OpportunityTeamMember memberOC = TestDataFactory.optyTeamMemberCreation(1, oc, opptyPSRO[0])[0];  
			memberOC.TeamMemberRole = GlobalConstants.OFFER_CONTROL;
			insert memberOC;  
			opptyPSRO[0].PSR_Sales_Value_BG_MN__c=1000;
			opptyPSRO[0].PSR_Date_PO_Expected__c=System.today();
			opptyPSRO[0].CloseDate = System.Today();
			opptyPSRO[0].PSR_Description_Justification__c='Test';
			opptyPSRO[0].PSR_is_BOM_BOQ_document_attached__c = true;
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = false;
			Test.startTest();
			update opptyPSRO[0];

			ApexPages.currentPage().getParameters().put('oppId', opptyPSRO[0].Id);
			NF_PRE_ErrorNotificationCtrl errorNotifCntrl =new NF_PRE_ErrorNotificationCtrl();
			errorNotifCntrl.init();
			errorNotifCntrl.cancel();
			Test.stopTest();
		}
	}
}