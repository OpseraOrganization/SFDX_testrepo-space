/*************************************************************
@Name: APTSCU_PreviewApprovalsControllerTest
@Author:  Pramod Mali 
@CreateDate: 23 Feb 2016
@Description: Test class for APTSCU_PreviewApprovalsController.
******************************************************************/
@isTest
public class APTSCU_PreviewApprovalsControllerTest {
	private static Id approvalProcessId;
	public static Id opportunityId;
	private static Apttus_Approval__Approval_Request__c request;
	private static User testUser = NF_TestDataFactory.createAdminUser('Data Loader Profile');
	private static String firstStep = 'First Step';

	static{
		system.runas(testUser){
			User approver = NF_TestDataFactory.createAdminUser('System Administrator');
			insert approver;

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
			step.Apttus_Approval__Step_Name__c = firstStep;
			step.Apttus_Approval__Step_Assignee_Type__c = 'User';
			step.Apttus_Approval__Step_Assignee__c = 'TestApproval TestApproval';
			step.Apttus_Approval__Step_Assignee_Id__c = approver.Id;
			step.Apttus_Approval__StepDisplayFieldNameHeader__c = 'Name';
			step.Apttus_Approval__StepDisplayFieldNames__c = 'Test';
			insert step;

			Account acc = NF_TestDataFactory.createAccount('301456783');
			insert acc;
		
			Opportunity opp = NF_TestDataFactory.createOpportunity(acc.Id, GlobalConstants.IDENTIFY_OPPORTUNITY, GlobalConstants.PLANNED, Date.today().addDays(10), Decimal.valueOf(System.Label.Unweighted_Amount_For_Sales_Outcome));
			opp.Business_Type__c = GLobalConstants.STANDARDOPPORTUNITY;
			insert opp;
			opportunityId = opp.Id;

			Apttus_Approval__Approval_Request__c approvalRequest=new Apttus_Approval__Approval_Request__c(
			Apttus_Approval__Object_Id__c = opp.id,
			Apttus_Approval__Object_Type__c='Opportunity',
			Apttus_Approval__Approval_Process__c=approvalProcessId,
			Apttus_Approval__Step_Name__c=firstStep,
			Apttus_Approval__Initial_Submitter__c=approver.Id,
			Apttus_Approval__Assigned_To_Id__c=approver.Id,
			NF_Assignee_Type__c=GlobalConstants.APPROVER
			);
			insert approvalRequest;

			Apttus_Approval__Approval_Request__c approvalRequest1=new Apttus_Approval__Approval_Request__c(
			Apttus_Approval__Object_Id__c = opp.id,
			Apttus_Approval__Object_Type__c='Opportunity',
			Apttus_Approval__Approval_Process__c=approvalProcessId,
			Apttus_Approval__Step_Name__c=firstStep,
			Apttus_Approval__Initial_Submitter__c=approver.Id,
			Apttus_Approval__Assigned_To_Id__c=approver.Id,
			NF_Assignee_Type__c=GlobalConstants.STAKEHOLDER_INFORMATION
			);
			insert approvalRequest1;

			request = approvalRequest;
		}
	}

	static testMethod void validateApproval(){
		Test.startTest();

		PageReference pageRef = Page.APTSCU_PreviewApproval;
		pageRef.getParameters().put('sObjectId',opportunityId);
		Test.setCurrentPage(pageRef);

		APTSCU_PreviewApprovalsController controller = new APTSCU_PreviewApprovalsController();
		controller.previewApprovals();
		controller.getDisplayFields();
		Opportunity oppty = new Opportunity(Id=opportunityId,Probability=70,Calculating_Probability__c=70);
		APTSCU_PreviewApprovalsController.updateOpportunity(oppty);
		APTSCU_PreviewApprovalsController.submitForApprovals('Opportunity', opportunityId );
		APTSCU_PreviewApprovalsController.addComments('Opportunity', opportunityId, 'Approve');
		APTSCU_PreviewApprovalsController.cancelApprovals('Opportunity', opportunityId, 'Cancel');
		controller.getOperator('equal to');
		controller.getOperator('not equal to');
		controller.getOperator('less than');
		controller.getOperator('greater than');
		controller.getOperator('less than or equal to');
		controller.getOperator('greater than or equal to');
		controller.getOperator('starts with');
		controller.getOperator('in');
		controller.getOperator('not in');
		Test.stopTest();
	}


	static testMethod void validateApprovalWD(){
		system.runas(testUser){
			Test.startTest();
			Opportunity opty = new Opportunity(Id=opportunityId);
			opty.Phase_Status__c=GlobalConstants.PENDING_WIN_LOSS_DECLARATION;
			opty.Apttus_Approval__Approval_Status__c=GlobalConstants.PENDING_APPROVAL;
			opty.StageName=GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			update opty;

			PageReference pageRef = Page.APTSCU_PreviewApproval;
			pageRef.getParameters().put('sObjectId',opportunityId);
			Test.setCurrentPage(pageRef);

			APTSCU_PreviewApprovalsController controller = new APTSCU_PreviewApprovalsController();
			controller.currentApprovalStatus='Pending Approval';
			controller.previewApprovals();
			controller.getDisplayFields();
			controller.currentApprovalStatus='Cancelled';
			controller.previewApprovals();
			controller.currentApprovalStatus='';
			controller.previewApprovals();
			Opportunity oppty = new Opportunity(Id=opportunityId);
			oppty.Sales_Outcome__c = 'Won (Requested)';
			oppty.Gate_6_Bypass_No_Execute_needed__c = true;
			APTSCU_PreviewApprovalsController.updateOpportunity(oppty);
			APTSCU_PreviewApprovalsController.submitForApprovals('Opportunity', opportunityId );
			APTSCU_PreviewApprovalsController.addComments('Opportunity', opportunityId, 'Approve');
			APTSCU_PreviewApprovalsController.updateG6PlannedDate(opportunityId, System.today().format());
			APTSCU_PreviewApprovalsController.cancelApprovals('Opportunity', opportunityId, 'Cancel');
			Test.stopTest();
		}
	}

}