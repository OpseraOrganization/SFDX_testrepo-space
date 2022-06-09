@isTest
Private class Batch_Recall_opportunityTest{
/******************************
	*Method Name: Batchtest
	*Description: Test Method to cover Batch_Recall_opportunity class
********************************/

	private static User testUser = NF_TestDataFactory.createAdminUser('Data Loader Profile');
		private static User testUser1 = NF_TestDataFactory.createAdminUser('Data Loader Profile');

	 private static User CurrentUser = NF_TestDataFactory.createAdminUser('System Administrator');
	 Private static List<Apttus_Approval__Approval_Request__c>Approvalrequestinfo = new List<Apttus_Approval__Approval_Request__c>();
	Private Static List<User> Userlist =new List<User>();
  
	private static Account currentAccount;
	private static Opportunity currentOpportunity;
	 private static Opportunity currentOpportunity1;
	
	Private Static  List<Opportunity> Opplist=new List<Opportunity>();

	 
static testMethod void Batchtest(){
NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		
 system.runAs(testUser1){
	
   
   DateTime dT = System.now();
   Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
	 
	 Userlist.add(testUser);
	 Userlist.add(CurrentUser);
	 Database.insert(Userlist);
	 currentAccount = NF_TestDataFactory.createAccount('132456783');
	 currentAccount.BillingState='Ontario';
	 insert currentAccount;
  Test.startTest();
	 currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700);
				  
		//currentOpportunity.Organisation_Level_5__c = 'LAT GCBT CARSO';
		//currentOpportunity.Organisation_Level_4__c = 'Market Latin America';
		currentOpportunity.NF_Facilitator_Notified__c=false;
		currentOpportunity.Business_Type__c='Standard Opportunity';
		currentOpportunity.NF_Facilitator_User__c = testuser.Id;
		opplist.add(currentOpportunity);	   
		
		currentOpportunity1 = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700);
				  
		//currentOpportunity1.Organisation_Level_5__c = 'LAT GCBT CARSO';
		//currentOpportunity1.Organisation_Level_4__c = 'Market Latin America';
		currentOpportunity1.NF_Facilitator_Notified__c=false;
		currentOpportunity1.Business_Type__c='Standard Opportunity';
		currentOpportunity1.NF_Facilitator_User__c = testuser.Id;
		opplist.add(currentOpportunity1);	   
		Insert  opplist;
		
		Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
		database.insert(nokiaFinCal);
		nokiaFinCal.Start_Date__c=system.today()+1;
		nokiaFinCal.End_Date__c = system.today()-1;
		database.update(nokiaFinCal);
		
		product2 prod = TestDataFactory.productCreation(1)[0];
		database.insert (prod);   
		
		 List<Order_Intake_Forecast__c> oif1=new List<Order_Intake_Forecast__c>();
		 oif1=TestDataFactory.orderIntakeCreation(1,oppList[0],prod,nokiaFinCal);
		 insert oif1;
		 
		 List<Order_Intake_Forecast__c> oif2=new List<Order_Intake_Forecast__c>();
		 oif2=TestDataFactory.orderIntakeCreation(1,oppList[1],prod,nokiaFinCal);
		 insert oif2;
		 
		opplist[0].Phase_Status__c='Submitted for G3 Approval';
		opplist[0].Apttus_Approval__Approval_Status__c='Pending Approval';	
		opplist[1].Phase_Status__c='Submitted for G3 Approval';
		opplist[1].Apttus_Approval__Approval_Status__c='Pending Approval';  
		  opplist[1].Is_Automated__c=True;
		   opplist[0].Is_Automated__c=True;
		Update oppList;
					
		Apttus_Approval__Approval_Request__c  Approvalrequest=NF_TestDataFactory.createApprovalRequest('Notify','Validator','Opportunity',currentOpportunity.ID,TRUE,TRUE,CurrentUser.name,CurrentUser.id,'G2 Rule');
		Approvalrequest.Apttus_Approval__Assigned_To_Id__c=CurrentUser.ID;
		Approvalrequest.Apttus_Approval__DelegateApproverIds__c=testUser.ID;
		Approvalrequest.NF_Assignee_Type__c='Approver';
		Approvalrequest.Apttus_Approval__Approval_Status__c='Assigned';
		Approvalrequestinfo.add(Approvalrequest);
		
		Apttus_Approval__Approval_Request__c  Approvalrequest1=NF_TestDataFactory.createApprovalRequest('Notify','Validator','Opportunity',currentOpportunity1.ID,TRUE,TRUE,CurrentUser.name,CurrentUser.id,'G2 Rule');
		Approvalrequest1.Apttus_Approval__Assigned_To_Id__c=CurrentUser.ID;
		Approvalrequest1.Apttus_Approval__DelegateApproverIds__c=testUser.ID;
		Approvalrequest1.NF_Assignee_Type__c='Approver';
		Approvalrequest1.Apttus_Approval__Approval_Status__c='Assigned';
		Approvalrequestinfo.add(Approvalrequest1);
		insert Approvalrequestinfo;
		
			List<NF_Recall_Ongoing_oppty__c> ongoing_oppty = new List<NF_Recall_Ongoing_oppty__c>();
			NF_Recall_Ongoing_oppty__c recall_oppty = new NF_Recall_Ongoing_Oppty__c( Name = opplist[0].Id );
			ongoing_oppty.add(recall_oppty);
			NF_Recall_Ongoing_oppty__c recall_oppty1 = new NF_Recall_Ongoing_Oppty__c( Name = opplist[1].Id );
			ongoing_oppty.add(recall_oppty1);
			insert ongoing_oppty;	 
			
			Exception__c Exp = new Exception__c( Class__c = 'Batch_Recall_Opportunity',Method__c = 'Execute', Message__C = 'Future method cannot be called from a future or batch method');
			insert Exp;
			 Test.StopTest();	
		   
			Batch_Recall_opportunity batch= new Batch_Recall_opportunity();
			batch.msg='Future method cannot be called from a future or batch method';
			Database.BatchableContext BC;
			SchedulableContext SC;  
			
			 batch.start(BC);
			 batch.execute(BC,oppList);
			
			batch.finish(BC);
			
		   
		 }   
		   
	 }
	 
  }