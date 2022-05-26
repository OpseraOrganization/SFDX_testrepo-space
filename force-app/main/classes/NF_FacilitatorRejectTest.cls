/****************************************
* Class Name : NF_FacilitatorRejectTest
* Created Date: 28 June 2017
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date:
* Description : Test class for  NF_FacilitatorReject
*****************************************/
@isTest
Private class NF_FacilitatorRejectTest{

	private static User testUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User CurrentUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User CurrentUser1= NF_TestDataFactory.createAdminUser('Data Loader Profile');

	private static User delegate1User = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User delegate2User = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User delegate3User = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static Account currentAccount;
	private static List<Account> accountList ;
	private static Id upsellDealId = Schema.SObjectType.Deal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.UPSELL_DEAL_RECORD_TYPE).getRecordTypeId();
	private static Deal__c upsellDeal;
	Private Static Competitor__c Comp;
	private static Opportunity currentOpportunity;
	private static Opportunity currentOpportunityC1;
	private static Opportunity currentOpportunityC2;
	private static Opportunity currentOpportunityC3;
	private static Sales_Role__c currentSalesOrg;
	private static Apttus_Approval__Backup_Approver__c BackupApprover;

	public static void setup(){
		ISO_Country_Codes__c isoCountryCode = new ISO_Country_Codes__c();
		isoCountryCode.Name = 'IN';
		isoCountryCode.Country_Name__c = 'India';
		database.insert(isoCountryCode);
		currentAccount=NF_TestDataFactory.createAccount('1234jdjf');
		currentAccount.BillingState='Ontario';
		insert currentAccount;
		upsellDeal = TestDataFactory.createDeal(1)[0];
		upsellDeal.RecordTypeId = upsellDealId;
		insert upsellDeal;
		currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700);
		currentOpportunity.NF_Facilitator_Notified__c=false;
		currentOpportunity.Phase_Status__c='Submitted for G3 Approval';
		currentOpportunity.Business_Type__c='Committed Upsell';
		currentOpportunity.Apttus_Approval__Approval_Status__c='Pending Approval';
		currentOpportunityC1 = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700);
		currentOpportunityC1.NF_Facilitator_Notified__c=false;
		currentOpportunityC1.Phase_Status__c='Submitted for G3 Approval';
		currentOpportunityC1.Business_Type__c='Committed Upsell';
		currentOpportunityC1.Apttus_Approval__Approval_Status__c='Pending Approval';
		currentOpportunityC2 = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700);
		currentOpportunityC2.Phase_Status__c='Submitted for G3 Approval';
		currentOpportunityC2.NF_Facilitator_Notified__c=false;
		currentOpportunityC2.Business_Type__c='Committed Upsell';
		currentOpportunityC2.Apttus_Approval__Approval_Status__c='Pending Approval';
		currentOpportunityC3 = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Identify Opportunity', 'Submitted for G2 Approval', Date.today().addDays(10), 700);
		currentOpportunityC3.NF_Facilitator_Notified__c=false;
		currentOpportunityC3.Phase_Status__c='Submitted for G2 Approval';
		currentOpportunityC3.Business_Type__c='Committed Upsell';
		currentOpportunityC3.Apttus_Approval__Approval_Status__c='Pending Approval';
		list<Opportunity> lstOpp = new list<Opportunity>();
		lstOpp.add(currentOpportunity);
		lstOpp.add(currentOpportunityC1);
		lstOpp.add(currentOpportunityC2);
		lstOpp.add(currentOpportunityC3);
		insert lstOpp;

		insert CurrentUser;
		insert delegate1User;
		insert delegate2User;
		currentSalesOrg = NF_TestDataFactory.createSalesRole(currentUser, 'NSND_OQM', 'LAT GCBT CARSO', '5 - RBC Presales Head AA G3 MU');
		insert currentSalesOrg;

		BackupApprover =new Apttus_Approval__Backup_Approver__c (
			Apttus_Approval__DelegateUserIds__c=testuser.Id+','+delegate1User.Id+','+delegate2User.Id,
			Apttus_Approval__Backup_User__c = testuser.Id,
			Apttus_Approval__IsDelegate__c=true,
			Apttus_Approval__IsActive__c=true,
			Apttus_Approval__InEffect__c=true);

		BackupApprover.Apttus_Approval__Current_User__c=currentUser.Id;
		insert BackupApprover;

		Group g = new Group(Type='Queue', Name='NSW-CAN-NAM');
		Group g1 = new Group(Type='Queue', Name='NSW-TEPS-BIGW-NAM');
		Group g2 = new Group(Type='Queue', Name='NSW-SPR-NAM');
		Group g3 = new Group(Type='Queue', Name='NSW-VER-NAM');
		Group g4 = new Group(Type='Queue', Name='ALU_I_Contracts_Queue');
		Group g5 = new Group(Type='Queue', Name='FN-NAM');
		Group g6 = new Group(Type='Queue', Name='ION-IPR-NAM');
		Group g7 = new Group(Type='Queue', Name='NSW-ATT-NAM');
		Group g8 = new Group(Type='Queue', Name='NSW-TMO-USM-NAM');
		Group g9 = new Group(Type='Queue', Name='LAT_ION_IPR_MarketLatinAmerica');
		Group g10 = new Group(Type='Queue', Name='MNGS-ATT-TMO-CAN-NAM');
		Group g11 = new Group(Type='Queue', Name='MNGS-USM-NAM');
		Group g12 = new Group(Type='Queue', Name='MNGS-VZ-SPR-TEPS-BIGW-NAM');
		Group g13 = new Group(Type='Queue', Name='na-proposals');
		Group g14 = new Group(Type='Queue', Name='ION-OP-NAM');
		Group g15 = new Group(Type='Queue', Name='OND-Proposals');
		Group g16 = new Group(Type='Queue', Name='WT-NAR-Offers');
		List<Group> lstGrp = new List<Group>();
		lstGrp.add(g);
		lstGrp.add(g1);
		lstGrp.add(g2);
		lstGrp.add(g3);
		lstGrp.add(g4);
		lstGrp.add(g5);
		lstGrp.add(g6);
		lstGrp.add(g7);
		lstGrp.add(g8);
		lstGrp.add(g9);
		lstGrp.add(g10);
		lstGrp.add(g11);
		lstGrp.add(g12);
		lstGrp.add(g13);
		lstGrp.add(g14);
		lstGrp.add(g15);
		lstGrp.add(g16);
		insert lstGrp;

		GroupMember member = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g.Id);
		GroupMember member1 = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g1.Id);
		GroupMember member2 = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g2.Id);
		GroupMember member3 = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g3.Id);
		GroupMember member4 = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g4.Id);
		GroupMember member5 = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g5.Id);
		GroupMember member6 = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g6.Id);
		GroupMember member7 = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g7.Id);
		GroupMember member8 = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g8.Id);
		GroupMember member9 = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g9.Id);
		GroupMember member10 = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g10.Id);
		GroupMember member11 = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g11.Id);
		GroupMember member12 = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g12.Id);
		GroupMember member13 = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g13.Id);
		GroupMember member14 = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g14.Id);
		GroupMember member15 = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g15.Id);
		GroupMember member16 = new GroupMember(UserOrGroupId=CurrentUser.Id,GroupId=g16.Id);

		List<GroupMember> lstGrpM = new List<GroupMember>();
		lstGrpM.add(member);
		lstGrpM.add(member1);
		lstGrpM.add(member2);
		lstGrpM.add(member3);
		lstGrpM.add(member4);
		lstGrpM.add(member5);
		lstGrpM.add(member6);
		lstGrpM.add(member7);
		lstGrpM.add(member8);
		lstGrpM.add(member9);
		lstGrpM.add(member10);
		lstGrpM.add(member11);
		lstGrpM.add(member12);
		lstGrpM.add(member13);
		lstGrpM.add(member14);
		lstGrpM.add(member15);
		lstGrpM.add(member16);
		insert lstGrpM;
	}

	static testMethod void RejectTest(){

		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		system.runAs(testUser){
			setup();
			Test.startTest();
			currentOpportunityC3.Is_Automated__c=TRUE;
			Update currentOpportunityC3;

			PageReference validatorPage = Page.NF_FacilitatorNotification;
			Test.setCurrentPage(validatorPage);
			ApexPages.currentPage().getParameters().put('oppId', currentOpportunityC3.Id);

			NF_FacilitatorReject facilrecall = new NF_FacilitatorReject();
			facilrecall .init();
			facilrecall .Reject();

			currentOpportunityC3.Is_Automated__c=TRUE;
			currentOpportunityC3.NF_Facilitator_Notified__c=TRUE;
			Update currentOpportunityC3;
			ApexPages.currentPage().getParameters().put('oppId', currentOpportunityC3.Id);

			NF_FacilitatorReject facilrecall1= new NF_FacilitatorReject();
			facilrecall1.init();
			facilrecall1.Reject();
			facilrecall1.cancel();
			ApexPages.currentPage().getParameters().put('oppId', currentOpportunityC3.Id);

			NF_FacilitatorReject facilrecall2= new NF_FacilitatorReject();
			NF_FacilitatorReject.G3facilitatorId.put(testUser.ID,testUser.ID);
			facilrecall2.init();
			facilrecall2.Reject();
			facilrecall2.cancel();

			ApexPages.currentPage().getParameters().put('oppId', currentOpportunityC3.Id);

			NF_FacilitatorReject facilrecall3= new NF_FacilitatorReject();
			facilrecall3.comments='Testing';
			NF_FacilitatorReject.G3facilitatorId.put(testUser.ID,testUser.ID);
			facilrecall3.init();
			facilrecall3.Reject();
			facilrecall3.cancel();
		}
	}
}