/**
* @name	NF_TL_UpdateRequestRCodeTest 
* @author   
* @since   July 08, 2017
* @desc	This class helps to code coverrage to the NF_TL_UpdateRequestRCode Class
* @history 
*/

@isTest
private class NF_TL_UpdateRequestRCodeTest {
	
	private static User testUser = NF_TestDataFactory.createAdminUser(GlobalConstants.DATA_LOADER_PROFILE);
	private static User testUser1 = NF_TestDataFactory.createAdminUser(GlobalConstants.DATA_LOADER_PROFILE);
	private static User testUser3 = NF_TestDataFactory.createAdminUser(GlobalConstants.DATA_LOADER_PROFILE);
	private static User testUser2 = NF_TestDataFactory.createAdminUser(GlobalConstants.DATA_LOADER_PROFILE);

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
	private static Apttus_Approval__Approval_Request__c currentApprovalRequest5;
	private static Sales_Role__c currentSalesOrg1,currentSalesOrg2,currentSalesOrg3,currentSalesOrg4;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee1;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee2;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee3;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee4;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee5;
	
	
	private static  Apttus_Approval__ApprovalRuleEntry__c ruleEntry; 
	private static  Apttus_Approval__ApprovalRuleEntry__c ruleEntry2;
	private static  Apttus_Approval__ApprovalRuleEntry__c ruleEntry3;
	
	private static List<Opportunity> currOpp = new List<Opportunity>();
	private static List<Apttus_Approval__Approval_Request__c> currAppRequest = new List<Apttus_Approval__Approval_Request__c>();
	private static List<Sales_Role__c> salesOrg = new List<Sales_Role__c>();
	private static  List<Apttus_Approval__ApprovalRuleAssignee__c> assignList = new List<Apttus_Approval__ApprovalRuleAssignee__c>();
	private static List<Apttus_Approval__ApprovalRuleEntry__c> ruleEntryList = new List<Apttus_Approval__ApprovalRuleEntry__c>();
	
	public static String l4 = 'Market Europe';
	public static String AssigneeDescription = 'NMSD_BM, Validator';
	
	public static void setup(){
		List<User> users = new List<User>{testUser1,testUser2,testUser3};
		insert users;
		users[1].NSA_Compliant__c=true;
		users[0].NSA_Compliant__c=true;
		update users;
		
		currentAccount =  TestDataFactory.createAccount(1)[0];
		currentAccount.L4Name__c = l4;
		currentAccount.Customer_Compliance__c='US_Govern';
		insert currentAccount;
		
		currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS, Date.today().addDays(10), 700);
		currentOpportunity.lead_bg__c = GlobalConstants.LEAD_BG_MN;
		currentOpportunity.lead_bu__c = GlobalConstants.LEAD_BG_MN;
		currOpp.add(currentOpportunity);
		
		currentOpportunity1= NF_TestDataFactory.createOpportunity(currentAccount.Id, GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS, Date.today().addDays(10), 700);
		currentOpportunity1.lead_bg__c = GlobalConstants.BG_CNS;
		currentOpportunity1.lead_bu__c = 'CNS';
		currOpp.add(currentOpportunity1);
		
		currentOpportunity2 = NF_TestDataFactory.createOpportunity(currentAccount.Id, GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS, Date.today().addDays(10), 700);
		currentOpportunity2.lead_bg__c = GlobalConstants.BG_NI;
		currentOpportunity2.lead_bu__c = GlobalConstants.BU_NI_FN;
		currOpp.add(currentOpportunity2);
		
		currentOpportunity3 = NF_TestDataFactory.createOpportunity(currentAccount.Id, GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS, Date.today().addDays(10), 700);
		currentOpportunity3.lead_bg__c = GlobalConstants.BG_NI;
		currentOpportunity3.Lead_BU__c = GlobalConstants.BU_NI_IPRTG;
		currOpp.add(currentOpportunity3);
		
		currentOpportunity4 = NF_TestDataFactory.createOpportunity(currentAccount.Id, GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS, Date.today().addDays(10), 700);
		currentOpportunity4.lead_bg__c = GlobalConstants.BG_NI;
		currentOpportunity4.Lead_BU__c = GlobalConstants.BU_NI_OPTICS;
		currOpp.add(currentOpportunity4);
		
		insert currOpp;
		
		currentSalesOrg1 = NF_TestDataFactory.createSalesRole(testUser2, 'NSNC_BM', l4, '4 - RBC Presales Head AA G3 MU');
		insert currentSalesOrg1;
		currentSalesOrg2 = NF_TestDataFactory.createSalesRole(testUser1, 'NSNC_BM', l4, '4 - BG Validator');
		currentSalesOrg2.BG__c=GlobalConstants.LEAD_BG_MN;
		insert currentSalesOrg2;
		currentSalesOrg3 = NF_TestDataFactory.createSalesRole(testUser3, 'NSNC_BM', l4, '4 - BG Approver');
		currentSalesOrg3.BG__c=GlobalConstants.BU_NI_IPRTG;
		insert currentSalesOrg3;
		currentSalesOrg4 = NF_TestDataFactory.createSalesRole(testUser2, 'NSNC_BM', l4, '4 - BG Approver');
		currentSalesOrg4.BG__c=GlobalConstants.BU_NI_OPTICS;
		insert currentSalesOrg4;
		
		Apttus_Approval__ApprovalRule__c appRule = NF_TestDataFactory.createApprovalRule('rule class C1', true, 'Opportunity', 'Condition', 1);
		insert appRule;
		
		ruleEntry = NF_TestDataFactory.createRuleEntry(appRule.Id, 1);
		ruleEntry.Apttus_Approval__EntryLabel__c='Rule 1';
		ruleEntryList.add(ruleEntry);
		ruleEntry2 = NF_TestDataFactory.createRuleEntry(appRule.Id, 2);
		ruleEntry2.Apttus_Approval__EntryLabel__c='Rule 2';
		ruleEntryList.add(ruleEntry2);
		ruleEntry3 = NF_TestDataFactory.createRuleEntry(appRule.Id, 3);
		ruleEntry3.Apttus_Approval__EntryLabel__c='Rule-SH';
		ruleEntryList.add(ruleEntry3);
		insert ruleEntryList; 
		
		String assigneeValue = 'Sales_Role__c(Role_Code__c=\'%\\_BM\' AND (Organisation__c =\':Org_L2__c\' OR Organisation__c =\':Org_L3__c\')AND Active__c=true)).User__c';
		String assigneeValue1 = 'Sales_Role__c(Role_Code__c=\'%\\_BM\' AND (Organisation__c =\':Org_L4__c\' OR Organisation__c =\':Org_L5__c\' OR Organisation__c =\':Org_L6__c\' OR Organisation__c =\':Org_L7__c\')AND Active__c=true).User__c';
		String assigneeValue2 = 'Sales_Role__c(Role_Code__c like \'%\\_BM\' AND Organisation__c =\':Org_L4__c\' AND Active__c=true).User__c';
		String assigneeValue3 ='Sales_Role__c((Role_Code__c=\'%\\_BM\' AND (Organisation__c =\':Org_L4__c\' OR Organisation__c =\':Org_L5__c\' OR Organisation__c =\':Org_L6__c\' OR Organisation__c =\':Org_L7__c\')AND Active__c=true AND (BG__c=\':Lead_BG__c\' OR BG__c=\':Lead_BU__c\'))).User__c';
		String assigneeValue4 ='Sales_Role__c((Role_Code__c=\'%\\_BM\' AND (Organisation__c =\':Org_L4__c\' OR Organisation__c =\':Org_L5__c\' OR Organisation__c =\':Org_L6__c\' OR Organisation__c =\':Org_L7__c\')AND Active__c=true AND BG__c=\'MN\')).User__c';
		String assigneeValue5 = 'Sales_Role__c(Role_Code__c=\'%\\_BM\' AND (Organisation__c =\':Org_L4__c\' OR Organisation__c =\':Org_L5__c\' OR Organisation__c =\':Org_L6__c\' OR Organisation__c =\':Org_L7__c\')AND Active__c=true).User__c';
		
		
		ruleAssignee = NF_TestDataFactory.createArAssignee(ruleEntryList[0].Id, 1, true, false, assigneeValue);
		ruleAssignee.Apttus_Approval__AssigneeDescription__c = 'NSNC_BM, Stakeholder for Information';
		assignList.add(ruleAssignee);
		ruleAssignee1 = NF_TestDataFactory.createArAssignee(ruleEntryList[0].Id, 1, true, false, assigneeValue1);
		ruleAssignee1.Apttus_Approval__AssigneeDescription__c = 'NSNC_BM, Approver';
		assignList.add(ruleAssignee1);
		ruleAssignee4 = NF_TestDataFactory.createArAssignee(ruleEntryList[0].Id, 1, true, false, assigneeValue4);
		ruleAssignee4.Apttus_Approval__AssigneeDescription__c = AssigneeDescription;
		assignList.add(ruleAssignee4);
		
		ruleAssignee2 = NF_TestDataFactory.createArAssignee(ruleEntryList[1].Id, 1, true, false, assigneeValue2);
		ruleAssignee2.Apttus_Approval__AssigneeDescription__c = AssigneeDescription;
		assignList.add(ruleAssignee2);
		
		ruleAssignee3 = NF_TestDataFactory.createArAssignee(ruleEntryList[2].Id, 1, true, false, assigneeValue3);
		ruleAssignee3.Apttus_Approval__AssigneeDescription__c = AssigneeDescription;
		assignList.add(ruleAssignee3);
		ruleAssignee5 = NF_TestDataFactory.createArAssignee(ruleEntryList[2].Id, 1, true, false, assigneeValue5);
		ruleAssignee5.Apttus_Approval__AssigneeDescription__c = AssigneeDescription;
		assignList.add(ruleAssignee5);
		insert assignList;
		
		ruleAssignee = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :assignList[0].Id];
		ruleAssignee1 = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :assignList[1].Id];
		ruleAssignee2 = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :assignList[2].Id];
		ruleAssignee3 = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :assignList[3].Id];
		ruleAssignee4 = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :assignList[4].Id];
		ruleAssignee5 = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :assignList[5].Id];
		
		
		
		currentApprovalRequest = NF_TestDataFactory.createApprovalRequest('Notified', 'User', 'Opportunity', currOpp[0].Id, true, true, testUser.FirstName+''+testUser.LastName, testUser.Id, ruleAssignee.Name);
		currentApprovalRequest.Apttus_Approval__Related_Opportunity__c=currOpp[0].ID;
		currAppRequest.add(currentApprovalRequest);
		currentApprovalRequest1 = NF_TestDataFactory.createApprovalRequest('Notified', 'Validator', 'Opportunity', currOpp[1].Id, true, false, testUser.FirstName+''+testUser.LastName, testUser2.Id, ruleAssignee1.Name);
		currentApprovalRequest1.Apttus_Approval__Related_Opportunity__c=currOpp[1].ID;
		currentApprovalRequest1.Validator_Request_Status__c=true;
		currAppRequest.add(currentApprovalRequest1);
		currentApprovalRequest2 = NF_TestDataFactory.createApprovalRequest('Assigned', 'GlobalConstants.QUEUE', 'Opportunity', currOpp[2].Id, true, false, testUser.FirstName+''+testUser.LastName, testUser1.Id, ruleAssignee2.Name);
		currentApprovalRequest2.Apttus_Approval__Related_Opportunity__c=currOpp[2].ID;
		currAppRequest.add(currentApprovalRequest2);
		currentApprovalRequest3 = NF_TestDataFactory.createApprovalRequest('Notified', 'User', 'Opportunity', currOpp[3].Id, true, false, testUser.FirstName+''+testUser.LastName, testUser1.Id, ruleAssignee3.Name);
		currentApprovalRequest3.Apttus_Approval__Related_Opportunity__c=currOpp[3].ID;
		currAppRequest.add(currentApprovalRequest3);
		currentApprovalRequest4 = NF_TestDataFactory.createApprovalRequest('Notified', 'User', 'Opportunity', currOpp[4].Id, true, false, testUser.FirstName+''+testUser.LastName, testUser3.Id, ruleAssignee4.Name);
		currentApprovalRequest4.Apttus_Approval__Related_Opportunity__c=currOpp[4].ID;
		currAppRequest.add(currentApprovalRequest4);
		
		insert currAppRequest;
		
	}
	
	
	@isTest static void test_updateRequestRcodeM() {
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		system.runAs(testUser){
			Test.startTest();
			setup();
			
			currAppRequest[0].Apttus_Approval__Approval_Status__c='Approved';
			currAppRequest[0].Apttus_Approval__Assigned_To_Name__c=null;
			currAppRequest[0].Apttus_Approval__Related_Opportunity__c =currOpp[0].Id;
			update currAppRequest;
			List<Apttus_Approval__Approval_Request__c> appRequests = new List<Apttus_Approval__Approval_Request__c>{currAppRequest[0]};
			NF_TL_UpdateRequestRCode.updateRequestRcodeM(appRequests);
			
			currAppRequest[2].Apttus_Approval__Approval_Status__c='Approved';
			currAppRequest[2].Apttus_Approval__Assigned_To_Name__c=null;
			currAppRequest[2].Apttus_Approval__Related_Opportunity__c =currOpp[2].Id;
			update currAppRequest[2];
			List<Apttus_Approval__Approval_Request__c> appRequests2 = new List<Apttus_Approval__Approval_Request__c>{currAppRequest[2]};
			NF_TL_UpdateRequestRCode.updateRequestRcodeM(appRequests2);
			
			currAppRequest[3].Apttus_Approval__Approval_Status__c='Approved';
			currAppRequest[3].Apttus_Approval__Assigned_To_Name__c=null;
			currAppRequest[3].Apttus_Approval__Related_Opportunity__c =currOpp[3].Id;
			update currAppRequest[3];
			List<Apttus_Approval__Approval_Request__c> appRequests3 = new List<Apttus_Approval__Approval_Request__c>{currAppRequest[3]};
			NF_TL_UpdateRequestRCode.updateRequestRcodeM(appRequests3);
			
			currAppRequest[4].Apttus_Approval__Approval_Status__c='Approved';
			currAppRequest[4].Apttus_Approval__Assigned_To_Name__c=null;
			currAppRequest[4].Apttus_Approval__Related_Opportunity__c =currOpp[4].Id;
			update currAppRequest[4];
			List<Apttus_Approval__Approval_Request__c> appRequests4 = new List<Apttus_Approval__Approval_Request__c>{currAppRequest[4]};
			NF_TL_UpdateRequestRCode.updateRequestRcodeM(appRequests4);
			
			List<Apttus_Approval__Approval_Request__c> appRequestsTot = new List<Apttus_Approval__Approval_Request__c>{currentApprovalRequest,currAppRequest[2],currAppRequest[3],currAppRequest[4]};
			NF_TL_UpdateRequestRCode.updateRequestRcodeM(appRequestsTot);
			Test.stopTest();
		}
	}
	
	@isTest static void test_UpdateValidatorStatus() {
		
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		system.runAs(testUser){
			Test.startTest();
			setup();
			
			currAppRequest[3].NF_Assignee_Type__c='Validator';
			currAppRequest[3].Validator_Status__c='Validated';
			currAppRequest[3].Validator_Request_Status__c=True;
			currAppRequest[3].Apttus_Approval__ParentRequestId__c=currAppRequest[4].ID;
			currAppRequest[3].Apttus_Approval__Related_Opportunity__c =currOpp[3].Id;
			update currAppRequest[3];
			
			currAppRequest[4].NF_Assignee_Type__c='Validator';
			currAppRequest[4].Validator_Status__c='Validated';
			currAppRequest[4].Apttus_Approval__Related_Opportunity__c =currOpp[4].Id;
			update currAppRequest[4];
			
			List<Apttus_Approval__Approval_Request__c> appRequests = new List<Apttus_Approval__Approval_Request__c>{currAppRequest[3],currAppRequest[4]};
			NF_TL_UpdateRequestRCode.count=1;
			NF_TL_UpdateRequestRCode.Total_count=1;
			
			NF_TL_UpdateRequestRCode.ParentReqUpdate.add(Null);
			GlobalConstants.UPDATE_VALIDATOR_REQUEST_STATUS = false;
			NF_TL_UpdateRequestRCode.UpdateValidatorStatus(appRequests);
			
			//to test method updateValidatorAndStakeholderStatus
			currAppRequest[1].Apttus_Approval__Approval_Status__c='Rejected';
			currAppRequest[1].Apttus_Approval__Related_Opportunity__c =currOpp[3].Id;
			update currAppRequest[1];

			Test.StopTest();
			
		}
	}
	
}