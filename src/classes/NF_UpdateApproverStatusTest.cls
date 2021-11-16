/****************************************
 * Class Name : NF_UpdateApproverStatus
 * Created Date: 5th June 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : Test class for NF_ApprovalEmailCheck Class
 *****************************************/

 @isTest
Private class NF_UpdateApproverStatusTest{
	 /******************************
	*Method Name: EmailTest
	*Description: Test Method to cover  NF_UpdateApproverStatus Class
	********************************/
	
	private static User testUser = TestDataFactory.userCreation(1,'System Administrator')[0];
	private static User CurrentUser = TestDataFactory.userCreation(1,'System Administrator')[0];
	Private Static List<User> Userlist =new List<User>();
  
	private static Account currentAccount;
	 private static Id upsellDealId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Upsell Deal').getRecordTypeId();
	private static Deal__c upsellDeal;
	private static Opportunity currentOpportunity;
	private static Opportunity currentOpportunityC1;
	Private Static  List<Opportunity> Opplist=new List<Opportunity>();
	Private Static List<Apttus_Approval__Approval_Request__c> Approvalrequest;
	//private static List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();

	
	static testMethod void EmailTest(){
	
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
	
	 insert testUser ;
	 insert  CurrentUser ;
	
	 system.runAs(CurrentUser){
	 
	 //fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
	 //database.insert(fileSharingCustomSettingList);
	 currentAccount = NF_TestDataFactory.createAccount('132456783');
	 currentAccount.BillingState='Ontario';
	 insert currentAccount;
	 upsellDeal = TestDataFactory.createDeal(1)[0];
	  upsellDeal.RecordTypeId = upsellDealId;
	insert upsellDeal;
	 currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 7000000);
	 //currentOpportunity.Organisation_Level_5__c = 'LAT GCBT CARSO';
	 //currentOpportunity.Organisation_Level_4__c = 'Market Latin America';
	 currentOpportunity.NF_Facilitator_Notified__c=false;
	 currentOpportunity.Business_Type__c='Committed Upsell';
	 currentOpportunity.Apttus_Approval__Approval_Status__c='Pending Approval';   
	//currentOpportunity.Deal__c = upsellDeal.Id;  
	 opplist.add(currentOpportunity);
	 Test.StartTest();
	 Insert  opplist;
	 Apttus_Approval__Approval_Request__c  ApprovalReq=NF_TestDataFactory.createApprovalRequest('Notify','Validator','Opportunity',currentOpportunity.ID,TRUE,TRUE,CurrentUser.name,CurrentUser.id,'G2 Rule');
	 ApprovalReq.Apttus_Approval__Assigned_To_Id__c=CurrentUser.ID;
	 ApprovalReq.Apttus_Approval__DelegateApproverIds__c=testUser.ID;
	 ApprovalReq.NF_Assignee_Type__c='Approver';
	 ApprovalReq.Apttus_Approval__Approval_Status__c='Assigned';
	  ApprovalReq.Validation_Completion_Date__c=System.now();
		  ApprovalReq.Tech_Status__c='Approved';
		 ApprovalReq.Tech_Approval_Date__c=System.now()-90;
	 insert ApprovalReq;
		 
		  Apttus_Approval__Approval_Request__c  ApprovalReq2=NF_TestDataFactory.createApprovalRequest('Notify','Validator','Opportunity',currentOpportunity.ID,TRUE,TRUE,CurrentUser.name,CurrentUser.id,'G2 Rule');
	 ApprovalReq2.Apttus_Approval__Assigned_To_Id__c=CurrentUser.ID;
	 ApprovalReq2.Apttus_Approval__DelegateApproverIds__c=testUser.ID;
	 ApprovalReq2.NF_Assignee_Type__c='Validator';
	 ApprovalReq2.Apttus_Approval__Approval_Status__c='Notify';
	  ApprovalReq2.Validation_Completion_Date__c=System.now();
		  ApprovalReq2.Tech_Status__c='Approved';
		 ApprovalReq2.Tech_Approval_Date__c=System.now()-90;
		 ApprovalReq2.Apttus_Approval__Approver_Comments__c='Test';
	 insert ApprovalReq2;
		 
		 
		  Apttus_Approval__Approval_Request__c  ApprovalReq1=NF_TestDataFactory.createApprovalRequest('Notify','Validator','Opportunity',currentOpportunity.ID,TRUE,TRUE,CurrentUser.name,CurrentUser.id,'G2 Rule');
	 ApprovalReq1.Apttus_Approval__Assigned_To_Id__c=CurrentUser.ID;
	 ApprovalReq1.Apttus_Approval__DelegateApproverIds__c=testUser.ID;
	 ApprovalReq1.NF_Assignee_Type__c='Approver';
		  ApprovalReq1.Validator_Status__c='Rejected';
	 ApprovalReq1.Apttus_Approval__Approval_Status__c='Assigned';
	  ApprovalReq1.Validation_Completion_Date__c=System.now();
		  
		 ApprovalReq1.Tech_Approval_Date__c=System.now()-10;
	 insert ApprovalReq1;
		 
	 // create a new email and envelope object
	 Messaging.InboundEmail email = new Messaging.InboundEmail() ;
	 Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		 
	 //Code coverage for Reject
	 Messaging.InboundEmail email1 = new Messaging.InboundEmail() ;
	 Messaging.InboundEnvelope env1 = new Messaging.InboundEnvelope();
	   
	 Messaging.InboundEmail email2 = new Messaging.InboundEmail() ;
	 Messaging.InboundEnvelope env2 = new Messaging.InboundEnvelope();
	 Messaging.InboundEmail email3 = new Messaging.InboundEmail() ;
	 Messaging.InboundEnvelope env3 = new Messaging.InboundEnvelope();
		 
		  Messaging.InboundEmail email4 = new Messaging.InboundEmail() ;
	 Messaging.InboundEnvelope env4 = new Messaging.InboundEnvelope();
   
	  // setup the data for the email
	  email.subject = 'Approved ApprovalRequestID:'+ApprovalReq.id;
	  email.fromAddress = CurrentUser.email;
	  email.plainTextBody = 'Updating the Coments   ApprovalRequestID:'+ApprovalReq.id;
	   
	  // setup the data for the email
	  email1.subject = 'Rejected ApprovalRequestID: '+ApprovalReq.id;
	  email1.fromAddress = 'someaddress@email.com';
	  email1.plainTextBody = 'Updating the Coments   ApprovalRequestID:'+ApprovalReq.id;
	  
			 
		
  
		 
	  email2.subject='Approved'+ApprovalReq2.id+'-SubmityourDecision';
	  email2.fromAddress =  CurrentUser.email;
	  email2.plainTextBody = 'End of Comments'+'test989';
	  
		 
	 
		 
		  email3.subject='Rejected  '+ApprovalReq.id+'- Submit your Decision';
	  email3.fromAddress = 'test@nokia.com';
	  email3.plainTextBody = 'End of Comments'+'test345';
		 
		 
	   
		
		  
		  email4.subject='Approved  '+ApprovalReq1.id+'- Submit your Decision';
	  email4.fromAddress =  CurrentUser.email;
	  email4.plainTextBody = 'End of Comments'+'test343';
	 
	  
	  NF_ApprovalEmailCheck  approvalstatus =new NF_ApprovalEmailCheck();	  
	  NF_UpdateApproverStatus   Validatorstatus =new NF_UpdateApproverStatus();
	  
	  // call the email service class and test it with the data in the testMethod
	   
	  approvalstatus.handleInboundEmail(email, env);
	  approvalstatus.handleInboundEmail(email1, env1);
	  Validatorstatus.handleInboundEmail(email2, env2);
	   Validatorstatus.handleInboundEmail(email3, env3);
		 Validatorstatus.handleInboundEmail(email4, env4);
  
	 
	  Validatorstatus.sendEmail('Test','Test','Test');   
	  Validatorstatus.sendEmail(null,null,null);   
	  Test.StopTest();   
	  }  
		
	  }
	}