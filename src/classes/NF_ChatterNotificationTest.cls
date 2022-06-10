/**
	* @name	NF_ChatterNotificationTest
	* @author Abdallah Dahjou 
	* @since   Dec 29, 2016
	* @desc	This Class is used to Test the chatter notification in case of opportunity approved o rejected				
	* @history 
**/
@isTest(SeeAllData=true)// we use seeAllData equals to true because of chatter api can't work
private class NF_ChatterNotificationTest {
	private static User testUser= NF_TestDataFactory.createAdminUser('System Administrator');
 
	
	/*
	 * @desc This method is used to test send chatter notification
	 */
	
	static testMethod void testchatterNotification() {
 
  
NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		//insert cs;

		
	system.runAs(testUser){
		// The test data
		Account account = NF_TestDataFactory.createAccount('12345676');
		account.BillingState='Ontario';
		List<Account> accounts=new List<Account>();
		accounts.add(account);
		insert accounts;
		
		List<Opportunity> opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		insert opportunities;
		
		List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
		insert users;
		
		List<Apttus_Approval__Approval_Request__c> approvalrequests = NF_TestDataFactory.getApprovalRequests(1,opportunities,users);
		insert approvalrequests;
		
		 List<OpportunityTeamMember> opportunityteammembers = NF_TestDataFactory.getOpportunityTeamMember(1,opportunities,users);
		 insert opportunityteammembers;
		
		// approve opportunities
		for (Opportunity opportunity : opportunities){
			opportunity.Apttus_Approval__Approval_Status__c = 'G2 Approved';
		}
		
				   
		//Testing	
		Test.startTest();
		 update opportunities; 
		Test.stopTest();
		}
		// Verification	

	}
}