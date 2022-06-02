/****************************************
 * Class Name : NF_ValidatorCommentsCtrlTest 
 * Created Date: 5th June 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : Test class for NF_ValidatorCommentsCtrl Class
 *****************************************/
@isTest
private class NF_ValidatorCommentsCtrlTest {
	
	private static User testUser = TestDataFactory.userCreation(1,'System Administrator')[0];
   
	private static Account currentAccount;
	private static Opportunity currentOpportunity;
	private static Apttus_Approval__Approval_Request__c currentApprovalRequest;
	 
 

	public static void setup(){
	
	
	  
		
		currentAccount = NF_TestDataFactory.createAccount('132456783');
		insert currentAccount;

		currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 7000000);
		insert currentOpportunity;

		currentApprovalRequest = NF_TestDataFactory.createApprovalRequest('Notified', 'User', 'Opportunity', currentOpportunity.Id, true, false, testUser.FirstName+' '+testUser.LastName, testUser.Id,'');
		currentApprovalRequest.Apttus_Approval__DelegateApproverIds__c = testUser.Id;
		currentApprovalRequest.NF_Assignee_Type__c = 'Validator';
		insert currentApprovalRequest;
		
	}

	@isTest static void test_ValidatorCommentsConstructor_DoNotHideValidation() {
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		 insert testUser;
		system.runAs(testUser){
			setup();
			Test.startTest();
			system.debug('###currentApprovalRequest : '+currentApprovalRequest);
			

			PageReference validatorPage = Page.NF_ValidatorComment;
			Test.setCurrentPage(validatorPage);
			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_ValidatorCommentsCtrl valdCommentCtrl = new NF_ValidatorCommentsCtrl();
			valdCommentCtrl.Datacheck=True;

			Test.stopTest();
			 
		}
	}
	
	@isTest static void test_ValidatorCommentsConstructor_DoHideValidation() {
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		setUp();
		system.runAs(testUser){
			
			delete currentApprovalRequest;
			
			Test.startTest();

			PageReference validatorPage = Page.NF_ValidatorComment;
			Test.setCurrentPage(validatorPage);
			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_ValidatorCommentsCtrl valdCommentCtrl = new NF_ValidatorCommentsCtrl();

			Test.stopTest();

			
		}
	}
	
	@isTest static void test_saveValidatorComments() {
	
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		
		system.runAs(testUser){
			setUp();
			Test.startTest();

			PageReference validatorPage = Page.NF_ValidatorComment;
			Test.setCurrentPage(validatorPage);
			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_ValidatorCommentsCtrl valdCommentCtrl = new NF_ValidatorCommentsCtrl();
		   
		   List<NF_ValidatorCommentsCtrl.WrapperClass> CLasswrapper = new List<NF_ValidatorCommentsCtrl.WrapperClass>();
			 CLasswrapper.add(new NF_ValidatorCommentsCtrl.WrapperClass(currentApprovalRequest));
			 for(NF_ValidatorCommentsCtrl.WrapperClass Checklist:CLasswrapper )
			  Checklist.checked=True;
			  
			  valdCommentCtrl.listWrapper =CLasswrapper;
			
			valdCommentCtrl.approverComments = 'Validator Comment';
			valdCommentCtrl.saveValidatorComments();
			valdCommentCtrl.RejectValidatorComments();

			Test.stopTest();

			//System.assertEquals([Select Id, Apttus_Approval__Approver_Comments__c from Apttus_Approval__Approval_Request__c].Apttus_Approval__Approver_Comments__c, 'Validator Comment');

		}
	}
	
	@isTest static void test_saveValidatorComments_Exception() {
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		system.runAs(testUser){
			setUp();
			String url;
			Test.startTest();

			PageReference validatorPage = Page.NF_ValidatorComment;
			Test.setCurrentPage(validatorPage);
			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_ValidatorCommentsCtrl valdCommentCtrl = new NF_ValidatorCommentsCtrl();
			valdCommentCtrl.approverComments = 'Validator Comment';
		   //url = valdCommentCtrl.saveValidatorComments().getUrl();
			 List<NF_ValidatorCommentsCtrl.WrapperClass> CLasswrapper = new List<NF_ValidatorCommentsCtrl.WrapperClass>();
			 CLasswrapper.add(new NF_ValidatorCommentsCtrl.WrapperClass(currentApprovalRequest));
			 for(NF_ValidatorCommentsCtrl.WrapperClass Checklist:CLasswrapper )
			  Checklist.checked=False;
			  
			  valdCommentCtrl.listWrapper =CLasswrapper;
		   
			valdCommentCtrl.approverComments = 'Validator Comment';
			 valdCommentCtrl.RejectValidatorComments();
			valdCommentCtrl.saveValidatorComments();
		   


			Test.stopTest();
			
		}
	}
	
	@isTest static void test_Cancel() {
	
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		system.runAs(testUser){
			setUp();
			String url;
			Test.startTest();

			PageReference validatorPage = Page.NF_ValidatorComment;
			Test.setCurrentPage(validatorPage);
			ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
			NF_ValidatorCommentsCtrl valdCommentCtrl = new NF_ValidatorCommentsCtrl();
			url = valdCommentCtrl.cancel().getUrl();
			 
			 List<NF_ValidatorCommentsCtrl.WrapperClass> CLasswrapper = new List<NF_ValidatorCommentsCtrl.WrapperClass>();
			 CLasswrapper.add(new NF_ValidatorCommentsCtrl.WrapperClass(currentApprovalRequest));
			 for(NF_ValidatorCommentsCtrl.WrapperClass Checklist:CLasswrapper )
			  Checklist.checked=False;
			  
			  valdCommentCtrl.listWrapper =CLasswrapper;
			
			valdCommentCtrl.approverComments = 'Validator Comment';
			 valdCommentCtrl.RejectValidatorComments();
			valdCommentCtrl.saveValidatorComments();

			Test.stopTest();
			
		}
	}
	
}