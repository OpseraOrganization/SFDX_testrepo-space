/****************************************
 * Class Name : NF_ValidatorApproveorRejectTest
 * Created Date: 09 July 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : Test class for NF_ValidatorApproveorRejectController
 *****************************************/

 @isTest
Private class NF_ValidatorApproveorRejectTest{
	 
	private static User testUser = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User CurrentUser = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User CurrentUser1= NF_TestDataFactory.createAdminUser('Data Loader Profile');

	private static User delegate1User = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User delegate2User = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User delegate3User = NF_TestDataFactory.createAdminUser('System Administrator');
	private static Account currentAccount;
		private static List<Account> accountList;	 
  
Private Static Competitor__c Comp;
 private static Id upsellDealId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Upsell Deal').getRecordTypeId();
	private static Deal__c upsellDeal;
	private static Opportunity currentOpportunity;
	private static Opportunity currentOpportunityC1;
	private static Opportunity currentOpportunityC2;
	private static Opportunity currentOpportunityC3;
	 private static Sales_Role__c currentSalesOrg;
	 Private Static Apttus_Approval__Approval_Request__c ApprovalReq;
	 Private Static Apttus_Approval__Approval_Request__c ApprovalReq1;
	  private static Apttus_Approval__Backup_Approver__c BackupApprover;
 


public static void setup(){ 

 


currentAccount=NF_TestDataFactory.createAccount('1234jdjf');
	  currentAccount.BillingState='Ontario';

		 insert currentAccount;
upsellDeal = TestDataFactory.createDeal(1)[0];
 upsellDeal.RecordTypeId = upsellDealId;
		insert upsellDeal;
  insert testUser;
		
		
		
		currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 7000000);
			
		//currentOpportunity.Organisation_Level_5__c = 'LAT GCBT CARSO';
		//currentOpportunity.Organisation_Level_4__c = 'Market Latin America';
		currentOpportunity.NF_Facilitator_Notified__c=false;
		currentOpportunity.Phase_Status__c='Submitted for G3 Approval';
		 
		currentOpportunity.Business_Type__c='Committed Upsell';
		currentOpportunity.Apttus_Approval__Approval_Status__c='Pending Approval';  
		//currentOpportunity.Deal__c = upsellDeal.Id;
		
		currentOpportunityC1 = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700000);
		//currentOpportunityC1.Organisation_Level_5__c = 'LAT GCBT CARSO';
		currentOpportunityC1.NF_Facilitator_Notified__c=false;
		currentOpportunityC1.Business_Type__c='Committed Upsell';
		currentOpportunityC1.Apttus_Approval__Approval_Status__c='Pending Approval';
		//currentOpportunityC1.Organisation_Level_4__c = 'Market Asia Pacific & Japan';
		//currentOpportunityC1.Deal__c = upsellDeal.Id;
		
		
		currentOpportunityC2 = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 7000000);
		//currentOpportunityC2.Organisation_Level_5__c = 'LAT GCBT CARSO';
		currentOpportunityC2.NF_Facilitator_Notified__c=false;
		currentOpportunityC2.Business_Type__c='Committed Upsell';
		currentOpportunityC2.Apttus_Approval__Approval_Status__c='Pending Approval';
		//currentOpportunityC2.Organisation_Level_4__c = 'Market Asia Pacific & Japan';
		//currentOpportunityC2.Deal__c = upsellDeal.Id;
		
		currentOpportunityC3 = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 70000000);
		//currentOpportunityC3.Organisation_Level_5__c = 'LAT GCBT CARSO';
		currentOpportunityC3.NF_Facilitator_Notified__c=false;
		currentOpportunityC3.Business_Type__c='Committed Upsell';
		currentOpportunityC3.Apttus_Approval__Approval_Status__c='Pending Approval';
		//currentOpportunityC3.Organisation_Level_4__c = 'Market Asia Pacific & Japan';
		//currentOpportunityC3.Deal__c = upsellDeal.Id;
		
		List<Opportunity> lstOpp = new List<Opportunity>();	
		 lstOpp.add(currentOpportunityC1);
		 lstOpp.add(currentOpportunityC2);
		 lstOpp.add(currentOpportunityC3);
		 

	 insert currentOpportunity;
	
	 insert lstOpp;
   
 
		
		 
	
	ApprovalReq=NF_TestDataFactory.createApprovalRequest('Notify','Validator','Opportunity',currentOpportunity.ID,TRUE,TRUE,testUser.name,testUser.id,'G2 Rule');
	ApprovalReq.Apttus_Approval__DelegateApproverIds__c=testUser.id+',';

	insert ApprovalReq;
		

	
	 ApprovalReq1=NF_TestDataFactory.createApprovalRequest('Notify','Validator','Opportunity',currentOpportunity.ID,TRUE,TRUE,testUser.name,null,'G2 Rule');
 
	insert ApprovalReq1;
	
	
}



 @isTest static void Validatortest () {
 
 
 NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		system.runAs(CurrentUser1){
			setup();
			Test.startTest();
			
			
			
	 ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ApprovalReq);
	 NF_ValidatorApproveorRejectController Validatorpage=new NF_ValidatorApproveorRejectController(sc);
	 Validatorpage.cancel();
	 Validatorpage.Reject();
	 Validatorpage.Approve();
	 
	
	 ApprovalReq.Apttus_Approval__Assigned_To_Id__c=CurrentUser1.id;
	 update ApprovalReq; 
			ApexPages.Standardcontroller sc1 = new ApexPages.Standardcontroller(ApprovalReq);
	NF_ValidatorApproveorRejectController Validatorpage1=new NF_ValidatorApproveorRejectController(sc1);
	Validatorpage1.isQueueAssigned=TRUE;
	Validatorpage1.hasPermissionToredirect=TRUE;
		  Validatorpage1.comments='Updating';
	
	 Validatorpage1.Reject();
	 Validatorpage1.Approve();
	 
	 ApprovalReq.Validator_Status__c='Validated';
	 update ApprovalReq;
	 
	 ApexPages.Standardcontroller sc2 = new ApexPages.Standardcontroller(ApprovalReq);
	NF_ValidatorApproveorRejectController Validatorpage2=new NF_ValidatorApproveorRejectController(sc2);
	Validatorpage2.Reject();
	 Validatorpage2.Approve();
	 
	 
	  ApexPages.Standardcontroller sc3 = new ApexPages.Standardcontroller(ApprovalReq);
	NF_ValidatorApproveorRejectController Validatorpage3=new NF_ValidatorApproveorRejectController(sc3);
	Validatorpage3.comments='Test';
	 Validatorpage3.notifyInfo();
	Validatorpage3.Reject();
	 Validatorpage3.Approve();
		 
			ApprovalReq.Validator_Status__c=null;	
			ApprovalReq.Tech_Approval_Date__c   = system.today()-8 ;
			update ApprovalReq;
	ApexPages.Standardcontroller sc4 = new ApexPages.Standardcontroller(ApprovalReq);
	NF_ValidatorApproveorRejectController Validatorpage4=new NF_ValidatorApproveorRejectController(sc4);
	 Validatorpage4.notifyInfo();
	
	Test.stopTest();
	  
	}


 }




}