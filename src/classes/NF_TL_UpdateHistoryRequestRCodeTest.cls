@isTest
private class NF_TL_UpdateHistoryRequestRCodeTest {
	
	private static User testUser = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User testUser2 = NF_TestDataFactory.createAdminUser('System Administrator');
	private static Account currentAccount;
	private static Opportunity currentOpportunity;
	private static Opportunity currentOpportunity1;
	private static Opportunity currentOpportunity2;
	private static Opportunity currentOpportunity3;
	private static Sales_Role__c currentSalesOrg;
	private static Sales_Role__c currentSalesOrg1;
	private static Sales_Role__c currentSalesOrg2;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee1;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee2;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee3;
	
	Private Static List<Apttus_Approval__Approval_Request_History__c > currAppRequest=new  List<Apttus_Approval__Approval_Request_History__c >();
	
	private static Apttus_Approval__Approval_Request_History__c currentApprovalRequest;
	private static Apttus_Approval__Approval_Request_History__c currentApprovalRequest1;
	private static Apttus_Approval__Approval_Request_History__c currentApprovalRequest2;
	private static Apttus_Approval__Approval_Request_History__c currentApprovalRequest3;
	private static List<Opportunity> currOpp = new List<Opportunity>();
	
	public static String l4 = 'Market Europe';
	public static String AssigneeDescription = 'NMSD_BM, Validator';
	
	public static void setup(){
		insert testUser2;
		
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
		currentOpportunity2.lead_bu__c = GlobalConstants.BU_NI_OPTICS;
		currOpp.add(currentOpportunity2);
		
		currentOpportunity3 = NF_TestDataFactory.createOpportunity(currentAccount.Id, GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.OPPORTUNITY_IN_PROGRESS, Date.today().addDays(10), 700);
		currentOpportunity3.lead_bg__c = GlobalConstants.BG_NI;
		currentOpportunity3.Lead_BU__c = GlobalConstants.BU_NI_IPRTG;
		currOpp.add(currentOpportunity3);
		
		insert currOpp;
		
		currentSalesOrg1 = NF_TestDataFactory.createSalesRole(testUser2, 'NSNC_BM', l4, '4 - RBC Presales Head AA G3 MU');
		insert currentSalesOrg1;
		currentSalesOrg2 = NF_TestDataFactory.createSalesRole(testUser, 'NSNC_BM', l4, '4 - BG Validator');
		currentSalesOrg2.BG__c=GlobalConstants.LEAD_BG_MN;
		insert currentSalesOrg2;
		currentSalesOrg = NF_TestDataFactory.createSalesRole(testUser, 'NSNC_BM', l4, '4 - BG Approver');
		currentSalesOrg.BG__c=GlobalConstants.BU_NI_IPRTG;
		insert currentSalesOrg;
		
		Apttus_Approval__ApprovalRule__c appRule = NF_TestDataFactory.createApprovalRule('rule class C1', true, 'Opportunity', 'Condition', 1);
		insert appRule;
		
		List<Apttus_Approval__ApprovalRuleEntry__c> ruleEntryList = new List<Apttus_Approval__ApprovalRuleEntry__c>();
		Apttus_Approval__ApprovalRuleEntry__c ruleEntry = NF_TestDataFactory.createRuleEntry(appRule.Id, 1);
		ruleEntry.Apttus_Approval__EntryLabel__c='Rule 1';
		ruleEntryList.add(ruleEntry);
		Apttus_Approval__ApprovalRuleEntry__c ruleEntry2 = NF_TestDataFactory.createRuleEntry(appRule.Id, 2);
		ruleEntry2.Apttus_Approval__EntryLabel__c='Rule 2';
		ruleEntryList.add(ruleEntry2);
		Apttus_Approval__ApprovalRuleEntry__c ruleEntry3 = NF_TestDataFactory.createRuleEntry(appRule.Id, 3);
		ruleEntry3.Apttus_Approval__EntryLabel__c='Rule-SH';
		ruleEntryList.add(ruleEntry3);
		insert ruleEntryList; 
		
		String assigneeValue = 'Sales_Role__c(Role_Code__c=\'%\\_BM\' AND (Organisation__c =\':Org_L2__c\' OR Organisation__c =\':Org_L3__c\')AND Active__c=true)).User__c';
		String assigneeValue1 = 'Sales_Role__c((Role_Code__c=\'%\\_BM\' AND (Organisation__c =\':Org_L4__c\' OR Organisation__c =\':Org_L5__c\' OR Organisation__c =\':Org_L6__c\' OR Organisation__c =\':Org_L7__c\')AND Active__c=true AND BG__c=\'MN\')).User__c';
		String assigneeValue2 = 'Sales_Role__c(Role_Code__c like \'%\\_BM\' AND Organisation__c =\':Org_L4__c\' AND Active__c=true).User__c';
		String assigneeValue3 ='Sales_Role__c((Role_Code__c=\'%\\_BM\' AND (Organisation__c =\':Org_L4__c\' OR Organisation__c =\':Org_L5__c\' OR Organisation__c =\':Org_L6__c\' OR Organisation__c =\':Org_L7__c\')AND Active__c=true AND (BG__c=\':Lead_BG__c\' OR BG__c=\':Lead_BU__c\'))).User__c';
		
		List<Apttus_Approval__ApprovalRuleAssignee__c> assignList = new List<Apttus_Approval__ApprovalRuleAssignee__c>();
		ruleAssignee = NF_TestDataFactory.createArAssignee(ruleEntryList[0].Id, 1, true, false, assigneeValue);
		ruleAssignee.Apttus_Approval__AssigneeDescription__c = 'NSNC_BM, Stakeholder for Information';
		assignList.add(ruleAssignee);
		ruleAssignee1 = NF_TestDataFactory.createArAssignee(ruleEntryList[0].Id, 1, true, false, assigneeValue1);
		ruleAssignee1.Apttus_Approval__AssigneeDescription__c = 'NSNC_BM, Approver';
		assignList.add(ruleAssignee1);
		
		ruleAssignee2 = NF_TestDataFactory.createArAssignee(ruleEntryList[1].Id, 1, true, false, assigneeValue2);
		ruleAssignee2.Apttus_Approval__AssigneeDescription__c = AssigneeDescription;
		assignList.add(ruleAssignee2);
		
		ruleAssignee3 = NF_TestDataFactory.createArAssignee(ruleEntryList[2].Id, 1, true, false, assigneeValue3);
		ruleAssignee3.Apttus_Approval__AssigneeDescription__c = AssigneeDescription;
		assignList.add(ruleAssignee3);
		insert assignList;
		
		ruleAssignee = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :assignList[0].Id];
		ruleAssignee1 = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :assignList[1].Id];
		ruleAssignee2 = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :assignList[2].Id];
		ruleAssignee3 = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :assignList[3].Id];
		
		
		currentApprovalRequest = NF_TestDataFactory.createApprovalHistoryRequest('Notified', 'User', 'Opportunity', currOpp[0].Id, true, true, testUser.FirstName+''+testUser.LastName, testUser.Id, ruleAssignee.Name);
		currentApprovalRequest.Apttus_Approval__Related_Opportunity__c=currOpp[0].ID;
		currentApprovalRequest.Apttus_Approval__DelegateApproverIds__c=testUser.Id+','+testUser.Id;
		currentApprovalRequest.NF_Assignee_Type__c='Validator';
		currAppRequest.add(currentApprovalRequest);
		
		currentApprovalRequest1 = NF_TestDataFactory.createApprovalHistoryRequest('Notified', 'Validator', 'Opportunity', currOpp[1].Id, true, false, testUser.FirstName+''+testUser.LastName, testUser.Id, ruleAssignee1.Name);
		currentApprovalRequest1.Apttus_Approval__Related_Opportunity__c=currOpp[1].ID;
		currentApprovalRequest1.NF_Assignee_Type__c='Approver';
		currentApprovalRequest1.Apttus_Approval__Approval_Status__c='Submitted';
		currentApprovalRequest1.Apttus_Approval__DelegateApproverIds__c=testUser.Id+','+testUser.Id;
		currAppRequest.add(currentApprovalRequest1);
		
		currentApprovalRequest2 = NF_TestDataFactory.createApprovalHistoryRequest('Assigned', 'GlobalConstants.QUEUE', 'Opportunity', currOpp[2].Id, true, false, testUser.FirstName+''+testUser.LastName, testUser.Id, ruleAssignee2.Name);
		currentApprovalRequest2.Apttus_Approval__Related_Opportunity__c=currOpp[2].ID;
		currentApprovalRequest2.NF_Assignee_Type__c='Approver';
		currentApprovalRequest2.Apttus_Approval__Approval_Status__c='Submitted';
		currentApprovalRequest2.Apttus_Approval__DelegateApproverIds__c=testUser.Id+','+testUser.Id;
		currAppRequest.add(currentApprovalRequest2);
		
		currentApprovalRequest3 = NF_TestDataFactory.createApprovalHistoryRequest('Notified', 'User', 'Opportunity', currOpp[3].Id, true, false, testUser.FirstName+''+testUser.LastName, testUser.Id, ruleAssignee3.Name);
		currentApprovalRequest3.Apttus_Approval__Related_Opportunity__c=currOpp[3].ID;
		currentApprovalRequest3.NF_Assignee_Type__c='Approver';
		currentApprovalRequest3.Apttus_Approval__Approval_Status__c='Submitted';
		currentApprovalRequest3.Apttus_Approval__DelegateApproverIds__c=testUser2.Id+','+testUser2.Id;
		currAppRequest.add(currentApprovalRequest3);
		insert currAppRequest;
	}
	
	@isTest static void test_updateRequestRcodeM() {
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		insert testUser;
		system.runAs(testUser){
			Test.startTest();
			setup();
			NF_TL_UpdateHistoryRequestRCode.updateHistoryRequestRcodeM(currAppRequest);
			Test.stopTest();
		}
	}
	
}