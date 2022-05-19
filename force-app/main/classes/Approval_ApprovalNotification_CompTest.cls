/****************************************
* Class Name : Approval_ApprovalNotification_CompTest
* Created Date: 5th June 2017
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date:
* Description : Test class for Approval_ApprovalNotification_Comp Class
*****************************************/
@isTest
Private class Approval_ApprovalNotification_CompTest{
	private static User testUser = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User CurrentUser = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User sysAdminUser = NF_TestDataFactory.createAdminUser('System Administrator');
	Private Static List<User> Userlist =new List<User>();
	private static List<OpportunityTeamMember> opptyTeamMemberList = new List<OpportunityTeamMember>();
	Private static List<Apttus_Approval__Approval_Request__c>Approvalrequestinfo = new List<Apttus_Approval__Approval_Request__c>();
	Private static List<Apttus_Approval__Approval_Request__c>Approvalrequestinfo1 = new List<Apttus_Approval__Approval_Request__c>();

	private static Account currentAccount;
	private static Opportunity currentOpportunity;
	private static Opportunity currentOpportunityC1;
	Private Static  List<Opportunity> Opplist=new List<Opportunity>();

	Private Static List<Offer__c> offerList = new List<Offer__c>();
	Private Static List<Offer__c> offerListEmp = new List<Offer__c>();
	Private Static  List<Opportunity> OpplistEmp=new List<Opportunity>();

	static testMethod void notification(){
		Userlist.add(testUser);
		Userlist.add(sysAdminUser);
		Database.insert(Userlist);
		System.runAs(sysAdminUser){

			NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
			cs.Name = 'Default';
			cs.Customer_Account__c = 'Customer - test';
			cs.Customer_Account_Number__c = '12345';
			cs.Customer_User_Profile__c = 'Customers';
			insert cs;

			DateTime dT = System.now();
			Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());

			currentAccount = NF_TestDataFactory.createAccount('132456783');
			currentAccount.BillingState='Ontario';

			insert currentAccount;

			currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700);
			currentOpportunity.NF_Facilitator_Notified__c=false;
			currentOpportunity.Business_Type__c='Standard Opportunity';
			currentOpportunity.Apttus_Approval__Approval_Status__c='Pending Approval';
			opplist.add(currentOpportunity);

			Insert  opplist;

			opptyTeamMemberList = TestDataFactory.optyTeamMemberCreation(1,Userlist[0],opplist[0]);
			database.insert(opptyTeamMemberList);

			Apttus_Approval__Approval_Request__c  Approvalrequest=NF_TestDataFactory.createApprovalRequest('Notify','Validator','Opportunity',currentOpportunity.ID,TRUE,TRUE,CurrentUser.name,CurrentUser.id,'G2 Rule');
			Approvalrequest.Apttus_Approval__Assigned_To_Id__c=CurrentUser.ID;
			Approvalrequest.Apttus_Approval__DelegateApproverIds__c=testUser.ID;
			Approvalrequest.NF_Assignee_Type__c='Approver';
			Approvalrequest.Apttus_Approval__Approval_Status__c='Assigned';
			Approvalrequestinfo.add(Approvalrequest);
			Test.startTest();
			insert Approvalrequestinfo;

			//Creating Offer
			Offer__c offerCreation = TestDataFactory.OfferCreation(1,currentOpportunity)[0];
			offerCreation.ActiveOffer__c = True;
			offerCreation.Customer_Offer_Due_Date__c =myDate ;
			offerList.add(offerCreation);
			insert offerList;

			Approval_ApprovalNotification_Comp  notification1 = new Approval_ApprovalNotification_Comp();

			notification1.OppId=Null;
			notification1.Opp=Null;
			notification1.Off=Null;
			notification1.CTname='Test';
			notification1.doc=Null;
			notification1.getOpp();
			notification1.getOff();
			notification1.getCTname();
			notification1.getDoc();
			notification1.getOppName();
			notification1.oppApprovalRequests=Null;

			Approval_ApprovalNotification_Comp  notification = new Approval_ApprovalNotification_Comp();

			notification.OppId=currentOpportunity.id;
			notification.Opp=currentOpportunity;
			notification.Off=offerCreation;
			notification.CTname='Test';
			notification.getOpp();
			notification.getOff();
			notification.getCTname();
			notification.getDoc();
			notification.getOppName();
			Approvalrequestinfo1 =notification.oppApprovalRequests;

			Test.stoptest();
		}
	}

}