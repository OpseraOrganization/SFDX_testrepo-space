/*************************************************************
@Name: APTSCU_ApprovalActionsControllerTest 
@Author:  Pramod Mali
@CreateDate: 23 Feb 2016
@Description: Test class for APTSCU_ApprovalActionsController.
******************************************************************/
@isTest
public class APTSCU_ApprovalActionsControllerTest {
 Public Static Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
 private static User testUser = NF_TestDataFactory.createAdminUser('Data Loader Profile');
	 private static Id approvalProcessId;
	static testMethod void validateApprovalActions(){
		PageReference pageRef = Page.APTSCU_ApprovalAction;		
		Test.setCurrentPage(pageRef);
		
	
		 String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName = orgId + dateString + randomInt;
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		system.runas(testUser){
		Account acc=new Account(
			Name='Test Approval Account',
			BillingCity ='Test',
			BillingCountry ='France',
			BillingStreet ='Test'
		);
		insert acc;
		Opportunity oppId=new Opportunity(
			Name='Test Approval',
			AccountId=acc.Id,
			CloseDate=System.today(),
			StageName='Qualification'			
		);
	insert oppId;
	
		 Profile approverProfile = [select Id, Name from Profile where Name ='System Administrator' limit 1];
		
		User u = new User(LastName = 'TestApproval',
		 FirstName='TestApproval',
		 Alias = 'jliv',
		 Email = 'test@nokia.com',
		 Username = uniqueName + '@test' + orgId + '.org',
		 ProfileId = approverProfile.id,
		 TimeZoneSidKey = 'GMT',
		 LanguageLocaleKey = 'en_US',
		 EmailEncodingKey = 'UTF-8',
		 LocaleSidKey = 'en_US',
		Nokia_ID__c=randomInt +'0'
		 );
		insert u;
		
		 User appr = new User(LastName = 'Testappr',
		 FirstName='Testappr',
		 Alias = 'jliv',
		 Email = 'test2@nokia.com',
		 Username = uniqueName + '@appr' + orgId + '.org',
		 ProfileId = approverProfile.id,
		 TimeZoneSidKey = 'GMT',
		 LanguageLocaleKey = 'en_US',
		 EmailEncodingKey = 'UTF-8',
		 LocaleSidKey = 'en_US',
		Nokia_ID__c=randomInt +'023'
		 );
		insert appr;
		
		 Apttus_Approval__Approval_Process__c mainProcess = new Apttus_Approval__Approval_Process__c();
	mainProcess.Apttus_Approval__Process_Name__c = 'Approval Process for Testing';
	mainProcess.Apttus_Approval__Active__c = true;
	mainProcess.Apttus_Approval__Object_Name__c = 'Opportunity';
	mainProcess.Apttus_Approval__Object_Label__c = 'Opportunity';
	mainProcess.Apttus_Approval__ContextType__c = 'Single';
	insert mainProcess;
		
		approvalProcessId = mainProcess.Id;
	
	Apttus_Approval__Approval_Process__c entryCriteria = new Apttus_Approval__Approval_Process__c();
	entryCriteria.Apttus_Approval__Entry_Criteria__c = mainProcess.Id;
	entryCriteria.Apttus_Approval__Entry_Criteria_Active__c = true;
	entryCriteria.Apttus_Approval__Entry_Criteria_Field__c = 'Amount';
	entryCriteria.Apttus_Approval__Entry_Criteria_Comparison_Type__c = 'greater than';
	entryCriteria.Apttus_Approval__Entry_Criteria_Field_Value__c = '0';
	entryCriteria.Apttus_Approval__Entry_Criteria_BoolOper__c = 'AND';
		entryCriteria.Apttus_Approval__Step_Filter_Field__c='test';
		entryCriteria.Apttus_Approval__Step_Filter_Comparison_Type__c='equal to';
		entryCriteria.Apttus_Approval__Step_Filter_Field_Value__c='test';
		entryCriteria.Apttus_Approval__Step_Filter_BoolOper__c='AND';
	insert entryCriteria;
	
	Apttus_Approval__Approval_Process__c stepGroup = new Apttus_Approval__Approval_Process__c();
	stepGroup.Apttus_Approval__Step_Group__c = mainProcess.Id;
	stepGroup.Apttus_Approval__Step_Group_Active__c = true;
	stepGroup.Apttus_Approval__Step_Group_Name__c = 'Dummy';
	stepGroup.Apttus_Approval__Step_Group_Seq_Number__c = 1;
	insert stepGroup;
	
	Apttus_Approval__Approval_Process__c step = new Apttus_Approval__Approval_Process__c();
	step.Apttus_Approval__Step__c = stepGroup.Id;
	step.Apttus_Approval__StepSequence__c = 1.000;
	step.Apttus_Approval__Step_Name__c = 'First Step';
	step.Apttus_Approval__Step_Assignee_Type__c = 'User';
	step.Apttus_Approval__Step_Assignee__c = 'TestApproval TestApproval';
	step.Apttus_Approval__Step_Assignee_Id__c = String.valueOf(u.Id);
	step.Apttus_Approval__StepDisplayFieldNames__c='';
	step.Apttus_Approval__StepDisplayFieldNameHeader__c = 'Name';
	insert step;
		
		
		Apttus_Approval__Approval_Request__c approvalRequest=new Apttus_Approval__Approval_Request__c(
			Apttus_Approval__Object_Id__c = oppId.id,
			Apttus_Approval__Object_Type__c='Opportunity',
			Apttus_Approval__Approval_Process__c=mainProcess.id,
			Apttus_Approval__Step_Name__c='First Step',
			Apttus_Approval__Initial_Submitter__c=appr.Id,
			Apttus_Approval__Assigned_To_Id__c=appr.Id
		);	
		insert approvalRequest;

		Apttus_Approval__Approval_Request__c approvalRequest1 =new Apttus_Approval__Approval_Request__c(
			Apttus_Approval__Object_Type__c='Opportunity',
			Apttus_Approval__Approval_Process__c=mainProcess.id,
			Apttus_Approval__Step_Name__c='First Step',
			Apttus_Approval__Initial_Submitter__c=appr.Id,
			Apttus_Approval__Assigned_To_Id__c=appr.Id
		);	
		insert approvalRequest1;
	
		ApexPages.currentPage().getParameters().put('approvalRequestId', approvalRequest.id);
		ApexPages.currentPage().getParameters().put('pageMode', 'yyyy');
		ApexPages.currentPage().getParameters().put('Referer', 'Referer');
	
		APTSCU_ApprovalActionsController approvalAction=new APTSCU_ApprovalActionsController();
		 approvalAction.sObjectId = oppId.id;
		 approvalAction.sObjectType = 'Opportunity';
		 //approvalAction.queryApprovalHeaderInformation();
		 //APTSCU_ApprovalActionsController.setUserInformation(appr.Id,appr.Id);
		 /* Line uncommented by HCL Team on 17th July 2019*/
		approvalAction.queryApprovalRequest();
		/* End of comment */
		//queryApprovalHeaderInformation
		APTSCU_ApprovalActionsController.approveRequest(approvalRequest.id,'Hi this is comment');
		APTSCU_ApprovalActionsController.rejectRequest(approvalRequest.id,'Hi this is comment');
		APTSCU_ApprovalActionsController.addCommentsToRequest(approvalRequest.id,'Hi this is comment');
		APTSCU_ApprovalActionsController.reassignRequest(approvalRequest.id,u.Id,'Hi this is comment');
		APTSCU_ApprovalActionsController.approveRequest(approvalRequest1.id,'Hi this is comment');
		APTSCU_ApprovalActionsController.rejectRequest(approvalRequest1.id,'Hi this is comment');
		APTSCU_ApprovalActionsController.addCommentsToRequest(approvalRequest1.id,'Hi this is comment');
		APTSCU_ApprovalActionsController.reassignRequest(approvalRequest1.id,u.Id,'Hi this is comment');
		approvalAction.saveApprovalDisplayInformation(mainProcess.id,approvalRequest.Apttus_Approval__Step_Name__c);
		approvalAction.getOperator('equal to');
		approvalAction.getOperator('not equal to');
		approvalAction.getOperator('less than');
		approvalAction.getOperator('greater than');
		approvalAction.getOperator('less than or equal to');
		approvalAction.getOperator('greater than or equal to');
		approvalAction.getOperator('starts with');
		approvalAction.getOperator('in');
		approvalAction.getOperator('not in');
		}
	}
		
}