/****************************************
* Name : NF_UpsellNotificationHelperTest
* Author : Accenture Sep-2018
* Description : Test class for NF_UpsellNotificationHelper
*****************************************/
@istest
public class NF_UpsellNotificationHelperTest {
   
	 public static Account currentAccount;
	public static Id upsellDealId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Upsell Deal').getRecordTypeId();
	public static Deal__c upsellDeal;
	public static List<Offer__c> offerList = new List<Offer__c>();
	public static Offer__c optyOffer ;
	public static Opportunity currentOpportunity;
	public static Opportunity currentOpportunityC1;
	 public static Apttus_Approval__Backup_Approver__c BackupApprover;
	private static Apttus_Approval__Approval_Request__c currentApprovalRequest;
	 private static Apttus_Approval__Approval_Request__c currentApprovalRequest1;
	 private static Apttus_Approval__Approval_Request__c currentApprovalRequest2;
	 private static Apttus_Approval__Approval_Request__c currentApprovalRequest3;
	 private static Apttus_Approval__Approval_Request__c currentApprovalRequest4;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee;
	  private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee1;
	   private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee2;
	   private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee3;
	   private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee4;
	Private Static List<Apttus_Approval__Approval_Request__c> CurrentRequest=new  List<Apttus_Approval__Approval_Request__c>();
	  private static User testUser = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User testUser1 = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User testUser2 = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User testUser3 = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User testUser4 = NF_TestDataFactory.createAdminUser('System Administrator');

	/******************************
*Method Name: notifyupsellApprovers
*Description: Test Method to cover NF_UpsellNotificationHelper class
********************************/
  public static testMethod void notifyupsellApprovers(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
	  list<user> userCreationval = TestDataFactory.userCreation(4,'System Administrator');
		insert userCreation;
	  insert userCreationval;
   List<User> userList = new List<User>();
		 
		userList.add(testUser1);
		userList.add(testUser2);
		userList.add(testUser3);
		userList.add(testUser4);
		userList.add(testUser);
		insert userList;
		system.runAs(userCreation){
	
		 
		upsellDeal = TestDataFactory.createDeal(1)[0];
		 upsellDeal.RecordTypeId = upsellDealId;
		insert upsellDeal;
			Sales_Role__c currentSalesOrg;
			Sales_Role__c currentSalesOrg1;
			//Apttus_Approval__Backup_Approver__c Apttus_BAckup;
			 CurrentSalesOrg = NF_TestDataFactory.createSalesRole(userCreationval[0],'NSNB_BGCM','Customer Operations','3 - BG Trial Demo Validator');
		   CurrentSalesOrg1 = NF_TestDataFactory.createSalesRole(userCreationval[0],'NSNC_BGCMH','Market Latin America','4 - BG Trial Demo Validator');
			CurrentSalesOrg.BG__c='MN';
			CurrentSalesOrg1.BG__c='MN';
			insert CurrentSalesOrg;
			insert CurrentSalesOrg1;
			
			 BackupApprover =new Apttus_Approval__Backup_Approver__c (
								 Apttus_Approval__DelegateUserIds__c=userCreationval[1].id+','+userCreationval[2].id+','+userCreationval[3].id,
								 Apttus_Approval__Backup_User__c = userCreation.id, 
								 Apttus_Approval__IsDelegate__c=true,
								 Apttus_Approval__IsActive__c=true,
								 Apttus_Approval__InEffect__c=true);
		
		BackupApprover.Apttus_Approval__Current_User__c=userCreationval[0].id;
		insert BackupApprover;
			 currentAccount = NF_TestDataFactory.createAccount('132456783');
		currentAccount.L5Name__c = 'LAT GCBT CARSO';
		currentAccount.L4Name__c = 'Market Latin America';
		insert currentAccount;
	  currentOpportunityC1 = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Win the Case (Negotiate)', 'Pending Win/Loss Declaration', Date.today().addDays(10), 700);
		currentOpportunityC1.NF_Facilitator_Notified__c=false;
		currentOpportunityC1.Business_Type__c='Standard Opportunity';
		currentOpportunityC1.Unweighted_Amount_EUR__c=10000000;
		currentOpportunityC1.Lead_BG__c='MN';
	   insert currentOpportunityC1;
	   Test.startTest();  
		 currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700);
		currentOpportunity.NF_Facilitator_Notified__c=false;
		currentOpportunity.Business_Type__c='Committed Upsell';
		currentOpportunity.Apttus_Approval__Approval_Status__c='Not Submitted';
		currentOpportunity.Unweighted_Amount_EUR__c=10000000;
		  currentOpportunity.Committed_Unweighted_Value_in_EUR__c= 10000000; 
		currentOpportunity.Lead_BG__c='MN';
	   insert currentOpportunity;
	 
			 Opportunity_Group__c oppsubordinateGRP=new Opportunity_Group__c(Deal__c=upsellDeal.id,Opportunity__c=currentOpportunity.id,Opportunity_Relation__c='subordinate');  
		 insert oppsubordinateGRP;
			
	   Opportunity_Group__c oppMAsterGRP=new Opportunity_Group__c(Deal__c=upsellDeal.id,Opportunity__c=currentOpportunityC1.id,Opportunity_Relation__c='Master');  
	   insert oppMAsterGRP;
			
		 Apttus_Approval__ApprovalRule__c appRule = NF_TestDataFactory.createApprovalRule('rule class C1', true, 'Opportunity', 'Condition', 1);
		insert appRule;

		Apttus_Approval__ApprovalRuleEntry__c ruleEntry = NF_TestDataFactory.createRuleEntry(appRule.Id, 1);
		insert ruleEntry;
		   
		String assigneeValue2 = 'Sales_Role__c (Role_Code__c =\'NMS%D_BM \' AND O__c =\':Org_L4__c\' AND Active__c=true).User__c';

		String assigneeValue1 = 'Sales_Role__c (Role_Code__c =\'NSN%C_BM\' AND O__c =\':Org_L4__c\' AND Active__c=true).User__c';
		String assigneeValue ='Sales_Role__c(Role_Code__c=\'NSN%C_BM\' AND ( O__c =\':Org_L4__c\' OR __c =\':Org_L5__c\' OR O__c =\':Org_L6__c\' OR O__c =\':Org_L7__c\') AND Active__c=true).User__c';
		String assigneeValue3 ='Sales_Role__c(Role_Code__c=\'NSN%C_BM\' AND ( O__c =\':Org_L4__c\' OR __c =\':Org_L5__c\' OR O__c =\':Org_L6__c\' OR O__c =\':Org_L7__c\') AND Active__c=true and BG__c=\'NSW\').User__c';
		
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
		
		ruleAssignee = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :ruleAssignee.Id];
		ruleAssignee1 = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :ruleAssignee1.Id];
		ruleAssignee2 = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :ruleAssignee2.Id];
		ruleAssignee3 = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :ruleAssignee3.Id];
		ruleAssignee4 = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :ruleAssignee4.Id];

		
		currentApprovalRequest1 = NF_TestDataFactory.createApprovalRequest('Notified', 'User', 'Opportunity', currentOpportunityC1.Id, true, false, testUser.FirstName+''+testUser.LastName, userList[0].Id, AssigneeList[1].Name);
		currentApprovalRequest1 .NF_Assignee_Type__c='Approver';
		currentApprovalRequest1 .Apttus_Approval__Approval_Status__c='Approved';
		currentApprovalRequest1.Apttus_Approval__DelegateApproverIds__c=testUser.Id+','+userList[1].Id;
		CurrentRequest.add(currentApprovalRequest1);
	  
		 
		currentApprovalRequest2 = NF_TestDataFactory.createApprovalRequest('Assigned', 'User', 'Opportunity', currentOpportunityC1.Id, true, false, testUser.FirstName+''+testUser.LastName, userList[1].Id, AssigneeList[2].Name);
		currentApprovalRequest2.NF_Assignee_Type__c='Approver';
		currentApprovalRequest2.Apttus_Approval__Approval_Status__c='Approved';
		currentApprovalRequest2.Apttus_Approval__DelegateApproverIds__c=testUser.Id+','+userList[2].Id;
		CurrentRequest.add(currentApprovalRequest2);
	 
		  Database.insert(CurrentRequest);
		
			currentOpportunity.Unweighted_Amount_EUR__c=8000000;
			currentOpportunity.Upsell_Change_Explanation__c='the purpose of checking' ;
			database.update(currentOpportunity);
			 Map<Id, Id> userOppMap = new Map<Id,Id>();
			set<String> userOppset = new set<String>();
			 userOppMap.put(userCreationval[0].id,currentOpportunity.Id);
			userOppset.add(userCreationval[0].id+','+currentOpportunity.Id);
			 userOppset.add(userCreationval[2].id+','+currentOpportunity.Id);
			NF_UpsellNotificationHelper.sendEmailtoUpsellApprovers(userOppset,null);
			NF_UpsellNotificationHelper.sendEmailtoUpsellApprovers(null,null);
		  Test.stopTest();   
		}
	}
	
   
}