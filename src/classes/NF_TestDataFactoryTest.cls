@isTest
public class NF_TestDataFactoryTest
{
	testMethod static void testClass() 
	{
		User testUser1 = NF_TestDataFactory.createAdminUser('System Administrator');
		List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
		users.add(testUser1);
		insert users;
		
		Account account = NF_TestDataFactory.createAccount('12345676');
		account.BillingState='Ontario';
		List<Account> currentAccountList = NF_TestDataFactory.getAccounts(1);
		currentAccountList.add(account);
		insert currentAccountList;
		
		List<Opportunity> currOpp = new List<Opportunity>();
		Opportunity currentOpportunity = NF_TestDataFactory.createOpportunity(account.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700);
		currentOpportunity.lead_bg__c = 'MN';
		currOpp.add(currentOpportunity);
		
		Opportunity  currentOpportunity1= NF_TestDataFactory.createOpportunity(account.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700);
		currentOpportunity1.lead_bg__c = 'MN';
		currOpp.add(currentOpportunity1);
		
		List<Opportunity> opportunities = NF_TestDataFactory.getOpportunities(1,currentAccountList);
		currOpp.addAll(opportunities);
		insert currOpp;
		
		List<Apttus_Approval__Approval_Request__c> approvalrequests = NF_TestDataFactory.getApprovalRequests(1,currOpp,users);
		insert approvalrequests;

		List<OpportunityTeamMember> opportunityteammembers = NF_TestDataFactory.getOpportunityTeamMember(1,opportunities,users);
		insert opportunityteammembers;
		 
		Apttus_Approval__ApprovalRule__c appRule = NF_TestDataFactory.createApprovalRule('rule class C1', true, 'Opportunity', 'Condition', 1);
		insert appRule;
		Apttus_Approval__ApprovalRuleEntry__c ruleEntry = NF_TestDataFactory.createRuleEntry(appRule.Id, 1);
		insert ruleEntry;
		String assigneeValue = 'Sales_Role__c(Role_Code__c like \'%\\_BM\' AND Organisation__c =\':Org_L4__c\' AND Active__c=true).User__c';
		Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, true, false, assigneeValue);
		insert ruleAssignee;		
		NF_TestDataFactory.createApprovalHistoryRequest('Notified', 'User', 'Opportunity', currentOpportunity1.Id, true, false, testUser1.FirstName+''+testUser1.LastName, testUser1.Id, ruleAssignee.Name);
	}
}