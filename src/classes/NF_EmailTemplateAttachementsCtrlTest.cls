/**
*   Test class for EmailTemplate Component
*/
@isTest
private class NF_EmailTemplateAttachementsCtrlTest {

	private static User testUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static Account currentAccount;
	private static Opportunity currentOpportunity;
	private static Apttus_Approval__Approval_Request__c currentApprovalRequest;

	public static void setup()
	{
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		
		currentAccount = NF_TestDataFactory.createAccount('132456783');
		insert currentAccount;
		
		currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS, Date.today().addDays(10), 7000000);
		currentOpportunity.Amount=8000000;
		currentOpportunity.Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
		insert currentOpportunity;
		
		currentApprovalRequest = NF_TestDataFactory.createApprovalRequest(GlobalConstants.NOTIFIED, GlobalConstants.USER, GlobalConstants.OBJECT_OPPORTUNITY, currentOpportunity.Id, true, false, testUser.FirstName+' '+testUser.LastName, testUser.Id, '');
		currentApprovalRequest.Apttus_Approval__DelegateApproverIds__c = testUser.Id;
		insert currentApprovalRequest;
		
	}

	@isTest static void test_EmailAttachments_Reassign_ApproveReject_Comment_Notified()
	{
		system.runAs(testUser)
		{
			setup();
			//Increasing Agreement_ApprovalNotification_Comp coverage 
			Opportunity opp = [Select Id from opportunity Where Business_Type__c = :GlobalConstants.STANDARDOPPORTUNITY Limit 1];	
			List<Offer__c> offersInOpp = TestDataFactory.OfferCreation(1, opp);
			insert offersInOpp;
			
			Test.startTest();
			List<OpportunityTeamMember> membersInOpp =  TestDataFactory.optyTeamMemberCreation(1, testUser, opp);
			membersInOpp[0].TeamMemberRole = GlobalConstants.CT_HEAD_OFFER_TEAM_ROLE;
			insert membersInOpp;
			currentApprovalRequest.Apttus_Approval__Approval_Status__c = GlobalConstants.NOTIFIED;
			update currentApprovalRequest;
			sendEmail();		
			Test.stopTest();
		}
	}

	@isTest static void test_EmailAttachments_Reassign_ApproveReject_Comment_Assigned()
	{
		system.runAs(testUser)
		{
			setup();
			
			Test.startTest();
			currentApprovalRequest.Apttus_Approval__Approval_Status__c = GlobalConstants.ASSIGNED;
			update currentApprovalRequest;
			sendEmail();			
			NF_EmailTemplateAttachementsCtrl ctrl = new NF_EmailTemplateAttachementsCtrl();
			ctrl.reassign='Test';
			ctrl.addComment='Test';
			Test.stopTest();
		}
	}

	@isTest static void test()
	{
		system.runAs(testUser)
		{
			setup();
			Test.startTest();
			currentApprovalRequest.Apttus_Approval__Approval_Status__c = GlobalConstants.ASSIGNED;
			update currentApprovalRequest;
			sendEmail();
			NF_EmailTemplateAttachementsCtrl ctrl = new NF_EmailTemplateAttachementsCtrl();
			ctrl.approvalRequest = currentApprovalRequest;
			string escalate =ctrl.escalate;
			string oppLink = ctrl.oppLink;
			string oppUrl = ctrl.oppUrl;
			List<Apttus_Approval__Approval_Request__c> lstAppReq = ctrl.oppApprovalRequests;
			string reassign =ctrl.reassign;
			string addComment = ctrl.addComment;
			Test.stopTest();
		}
	}
	
	@isTest static void testAgreement_ApprovalNotification_Comp()
	{
		Agreement_ApprovalNotification_Comp component = new Agreement_ApprovalNotification_Comp();
	 	component.getOpp();
	}
	
	private static void sendEmail()
	{
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		EmailTemplate et = [SELECT id FROM EmailTemplate WHERE developerName = 'NF_Opportunity_Approval_Notif_Assignment'];
		mail.setWhatId(currentApprovalRequest.Id);
		mail.setSenderDisplayName('Joe');
		mail.setTargetObjectId(testUser.id); // Specify who the email should be sent to.
		mail.setTemplateId(et.id);
		mail.setSaveAsActivity(false);
		Messaging.SendEmailResult[] results2 = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
	}
}