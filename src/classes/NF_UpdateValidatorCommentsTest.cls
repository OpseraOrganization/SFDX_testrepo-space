/****************************************
 * Class Name : NF_UpdateValidatorCommentsTest
 * Created Date: 5th June 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : Test class for NF_UpdateValidatorComments Class
 *****************************************/

 @isTest
Private class NF_UpdateValidatorCommentsTest{
	 /******************************
	*Method Name: GirdMobileTest
	*Description: Test Method to cover OIFGrid class
	********************************/
	
	
	 private static User testUser = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User CurrentUser = NF_TestDataFactory.createAdminUser('System Administrator');
	Private Static List<User> Userlist =new List<User>();
  
	private static Account currentAccount;
	 private static Id upsellDealId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Upsell Deal').getRecordTypeId();
	private static Deal__c upsellDeal;
	private static Opportunity currentOpportunity;
	private static Opportunity currentOpportunityC1;
	Private Static  List<Opportunity> Opplist=new List<Opportunity>();
	Private Static List<Apttus_Approval__Approval_Request__c> Approvalrequest;
	
	static testMethod void EmailTest(){
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
	Userlist.add(testUser);
	insert Userlist;
	
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
		 
		Insert  opplist;
		
		Approvalrequest=NF_TestDataFactory.getApprovalRequests(1,opplist,Userlist);
		
		insert Approvalrequest;
	
	
	
		
		// create a new email and envelope object
	   Messaging.InboundEmail email = new Messaging.InboundEmail() ;
	   Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
	   
			  
	   
	   // setup the data for the email
	  email.subject = 'Approved';
	  email.fromAddress = 'someaddress@email.com';
	  email.plainTextBody = 'Updating the Coments Approval Request ID'+Approvalrequest.get(0).id;
	   
	 
	  NF_UpdateValidatorComments comments =new NF_UpdateValidatorComments();
	  
	  
	  // call the email service class and test it with the data in the testMethod
	   
	  comments.handleInboundEmail(email, env);
	  
	  
	
		
		
			
		
	  }
	}