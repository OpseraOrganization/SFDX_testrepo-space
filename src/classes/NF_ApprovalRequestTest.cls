/**
* @name	NF_ApprovalRequestTest
* @author
* @since   July 08, 2017
* @desc	This class helps to code coverrage to the NF_ApprovalRequest Class
* @history
*/

@isTest
private class NF_ApprovalRequestTest{

	Private static NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();

	private static User testUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User testUser1 = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User testUser2 = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User testUser3 = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User testUser4 = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);

	private static Account currentAccount;
	private static Opportunity currentOpportunity;
	private static Opportunity currentOpportunity1;
	private static Opportunity currentOpportunity2;
	private static Opportunity currentOpportunity3;
	private static Opportunity currentOpportunity4;
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

	public static void setup(){
		List<User> userList = new List<User>();

		userList.add(testUser1);
		userList.add(testUser2);
		userList.add(testUser3);
		userList.add(testUser4);
		insert userList;

		currentAccount = NF_TestDataFactory.createAccount('132456783');
		currentAccount.L4Name__c = 'LAT CARSO CT CO';
		insert currentAccount;

		List<Opportunity> opportunityList = new List<Opportunity>();
		currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700);
		currentOpportunity.lead_bg__c = 'MN';
		currentOpportunity.Phase_Status__c='Submitted for G3 Approval';
		currentOpportunity.StageName='Develop Opportunity';
		opportunityList.add(currentOpportunity);
		insert opportunityList;

		Apttus_Approval__Backup_Approver__c approvalRec = new Apttus_Approval__Backup_Approver__c();
		approvalRec.Apttus_Approval__Current_User__c = testUser.id;
		approvalRec.Apttus_Approval__Comment__c = 'Test Comments';
		approvalRec.Apttus_Approval__InEffect__c=True;
		approvalRec.Apttus_Approval__IsActive__c=True;
		approvalRec.Apttus_Approval__IsDelegate__c=true;
		approvalRec.Apttus_Approval__DelegateUserIds__c= userList[0].id+','+ userList[1].id;
		approvalRec.Delegate_Approver1__c = userList[0].id;
		insert approvalRec;

		currentSalesOrg = NF_TestDataFactory.createSalesRole(testUser, 'NSNC_BM', 'LAT CARSO CT CO', '4 - RBC Presales Head AA G3 MU');
		insert currentSalesOrg;
		Apttus_Approval__ApprovalRule__c appRule = NF_TestDataFactory.createApprovalRule('rule class C1', true, 'Opportunity', 'Condition', 1);
		insert appRule;

		Apttus_Approval__ApprovalRuleEntry__c ruleEntry = NF_TestDataFactory.createRuleEntry(appRule.Id, 1);
		insert ruleEntry;

		String assigneeValue2 = 'Sales_Role__c (Role_Code__c =\'NMS%D_BM \' AND O__c =\':Org_L4__c\' AND Active__c=true).User__c';

		String assigneeValue1 = 'Sales_Role__c (Role_Code__c =\'NSN%C_BM\' AND O__c =\':Org_L4__c\' AND Active__c=true).User__c';
		String assigneeValue ='Sales_Role__c(Role_Code__c=\'NSN%C_BM\' AND ( O__c =\':Org_L4__c\' OR __c =\':Org_L5__c\' OR O__c =\':Org_L6__c\' OR O__c =\':Org_L7__c\') AND Active__c=true).User__c';
		String assigneeValue3 ='Sales_Role__c(Role_Code__c=\'NSN%C_BM\' AND ( O__c =\':Org_L4__c\' OR __c =\':Org_L5__c\' OR O__c =\':Org_L6__c\' OR O__c =\':Org_L7__c\') AND Active__c=true and BG__c=\'MN\').User__c';

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
		currentApprovalRequest.Apttus_Approval__DelegateApproverIds__c=null;
		currentApprovalRequest.Apttus_Approval__Approval_Status__c='Not Submitted';
		currentApprovalRequest.NF_Assignee_Type__c='Validator';
		currentApprovalRequest.NF_Remaindercount__c=0;
		CurrentRequest.add(currentApprovalRequest);

		currentApprovalRequest1 = NF_TestDataFactory.createApprovalRequest('Notified', 'User', 'Opportunity',currentOpportunity.Id, true, false, testUser.FirstName+''+testUser.LastName, userList[0].Id, AssigneeList[1].Name);
		currentApprovalRequest1.NF_Assignee_Type__c='Approver';
		currentApprovalRequest1.Apttus_Approval__Approval_Status__c='Submitted';
		currentApprovalRequest1.Apttus_Approval__DelegateApproverIds__c=testUser.Id+','+userList[1].Id;
		CurrentRequest.add(currentApprovalRequest1);


		currentApprovalRequest2 = NF_TestDataFactory.createApprovalRequest('Assigned', 'User', 'Opportunity', currentOpportunity.Id, true, false, testUser.FirstName+''+testUser.LastName, userList[1].Id, AssigneeList[2].Name);
		currentApprovalRequest2.NF_Assignee_Type__c='Approver';
		currentApprovalRequest2.Apttus_Approval__Approval_Status__c='Submitted';
		currentApprovalRequest2.Apttus_Approval__DelegateApproverIds__c=testUser.Id+','+userList[2].Id;
		CurrentRequest.add(currentApprovalRequest2);

		currentApprovalRequest3 = NF_TestDataFactory.createApprovalRequest('Notified', 'User', 'Opportunity', currentOpportunity.Id, true, false, testUser.FirstName+''+testUser.LastName, userList[2].Id, AssigneeList[3].Name);
		currentApprovalRequest3.Apttus_Approval__DelegateApproverIds__c=testUser.Id+','+userList[0].Id;
		currentApprovalRequest3.NF_Assignee_Type__c='Validator';
		currentApprovalRequest3.Validator_Status__c='Validated';
		currentApprovalRequest3.NF_Remaindercount__c=0;
		CurrentRequest.add(currentApprovalRequest3);

		currentApprovalRequest4 = NF_TestDataFactory.createApprovalRequest('Assigned', 'User', 'Opportunity', currentOpportunity.Id, true, false, testUser.FirstName+''+testUser.LastName, userList[3].Id, AssigneeList[4].Name);
		currentApprovalRequest4.NF_Assignee_Type__c='Stakeholder for Information';
		currentApprovalRequest4.Apttus_Approval__Approval_Status__c='Notified';
		currentApprovalRequest4.Apttus_Approval__DelegateApproverIds__c=testUser.Id+','+userList[2].Id;
		CurrentRequest.add(currentApprovalRequest4);

		Database.insert(CurrentRequest);

	}

	@isTest static void NF_ApprovlRequestHandlerTest() {
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		system.runAs(testUser){

			setup();
			Test.startTest();

			NF_ApprovalRequest.getDelegateApprovers(CurrentRequest);
			NF_ApprovalRequest.getAssignedId(null);
			NF_ApprovalRequest.Opptysharing(CurrentRequest);
			NF_ApprovalRequest.getNotificationUsersList(CurrentRequest);

			NF_ApprovalRequest.getApproverNotification(null);
			NF_ApprovalRequest.getApproverNotification(CurrentRequest);
			CurrentRequest.get(0).NF_Assignee_Type__c='Approver';
			CurrentRequest.get(0).Apttus_Approval__Approval_Status__c='Submitted';
			CurrentRequest.get(1).NF_Assignee_Type__c='Approver';
			CurrentRequest.get(1).Apttus_Approval__Approval_Status__c='Reassigned';
			update CurrentRequest;
			NF_ApprovalRequest.getApproverNotification(CurrentRequest);

			CurrentRequest.get(0).NF_Assignee_Type__c='Validator';
			CurrentRequest.get(0).Apttus_Approval__Approval_Status__c='Approved';
			CurrentRequest.get(1).NF_Assignee_Type__c='Validator';
			CurrentRequest.get(1).Apttus_Approval__Approval_Status__c='Approved';
			CurrentRequest.get(2).NF_Assignee_Type__c='Approver';
			CurrentRequest.get(2).Apttus_Approval__Approval_Status__c='Submitted';
			CurrentRequest.get(3).NF_Assignee_Type__c='Approver';
			CurrentRequest.get(3).Apttus_Approval__Approval_Status__c='Submitted';

			update CurrentRequest;

			NF_ApprovalRequest.TotalValidator=2;
			NF_ApprovalRequest.ValidatorCompletion=2;
			NF_ApprovalRequest.EmailTemplate=Label.NF_G3_Validation_Completion_Email;

			NF_ApprovalRequest.getNotificationUsersList(CurrentRequest);

			Test.stopTest();
		}

	}

	@isTest static void NF_ApprovlRequestHandlerChatterpost() {
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		system.runAs(testUser){

			Set<ID> Remid=new Set<ID>();

			setup();
			Test.startTest();
			for(Apttus_Approval__Approval_Request__c Appreq:CurrentRequest)	 {
	Remid.add(Appreq.ID);
			}

			NF_ApprovalRequest.Remindupdate(Remid);

			NF_ApprovalRequest.ChatterPostToG5StakeHolders(CurrentRequest);
			//create offer
			NF_ApprovalRequest.Remindupdate(Null);

			NF_ApprovalRequest.ChatterPostToG5StakeHolders(Null);
			Test.stopTest();
		}
	}
}