/**
* @name	NF_FacilitatorNotificationCtrl
* @author
* @since   July 08, 2017
* @desc	Class used to serve as redirection to the submit for approval
* @history
*/
public with sharing class NF_FacilitatorNotificationCtrl {
	public Opportunity currentOpp {get;set;}
	public Boolean hasNoSubmitForApproval {get;set;}
	public String currentOppId {get;set;}
	public Boolean showMandatoryInfo {get;set;}

	public List<String> mandParamsG2 {get;set;}
	public List<String> paramsG2 {get;set;}
	private Id userId = UserInfo.getUserId();
	private String userProfileId = UserInfo.getProfileId();

	//@TestVisible static String redirectionChoice{get;set;}
	//public enum ApprovalsRedirection { APPROVALCONTEXTSUBMIT, MYAPPROVALS , PREVIEWSUBMITAPPROVALS }

	/*
* @desc	the method used to initiate the VF NF_FacilitatorNotification
* @return  PageReference:
*/
	public PageReference init(){
		//redirectionChoice = ApexPages.currentPage().getParameters().get('from');
		currentOppId = ApexPages.currentPage().getParameters().get('oppId');
		String isSubmitApproval = ApexPages.currentPage().getParameters().get('submitForApproval');
		mandParamsG2 = new List<String>{'Customer_Request__c','StrategicContextCompetitiveSituation__c'};
		paramsG2 = new List<String>{'Customer_Request__c', 'StrategicContextCompetitiveSituation__c','Customer_pain_points_challenges__c','Pursue_Strategy__c','Comments_Cust_Req_Nokia_Prop__c'};

		if(currentOppId !=null ){
			currentOpp = [SELECT Id, StageName, OwnerID , Sales_Outcome__c, Gate_3_Bypass_no_offer_support__c, Gate_2_Bypass_no_complex_offer__c,
						  Blanket_Approval_Condition__c,  Phase_Status__c, NF_LoA_Bypass__c, Unweighted_Amount_EUR__c, MultiBGException_AllowG2Bypass__c, SolutionScopeAlignedCSO__c, isMultiBG__c, Gate_6_Bypass_No_Execute_needed__c,Apttus_Approval__Approval_Status__c,
						  /*mand + info params -> */ Customer_Request__c, StrategicContextCompetitiveSituation__c,  Customer_pain_points_challenges__c, Pursue_Strategy__c, Comments_Cust_Req_Nokia_Prop__c
						  FROM Opportunity WHERE Id = :currentOppId   ];
			if(isSubmitApproval != null && isSubmitApproval.equals('true')){
				hasNoSubmitForApproval = false;
				return submitForApproval();
			}
		}
		 /*else {
			hasNoSubmitForApproval = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.NF_OnlyFacilitator_Offer_Validation));
			errorMessage = null;
			return errorMessage;
		}*/
		return null;
	}

	/**
*   @description : Method used to redirect whether to the approval process submit or to reject the request if conditions not comply.
*   @return : PageReference
*/
	public PageReference submitForApproval(){
		PageReference myPage;
		// Identify Opportunity
		if(GlobalConstants.IDENTIFY_OPPORTUNITY.equalsIgnoreCase(currentOpp.StageName) && !currentOpp.Gate_2_Bypass_no_complex_offer__c &&!currentOpp.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.PENDING_APPROVAL)) {
			showMandatoryInfo = true;
			hasNoSubmitForApproval = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.MANDATORY_PARAMETERS_G2_APPROVAL_MSG + GlobalConstants.SPACE + getFieldsLabel()));
			return null;
		}
		// G3, G4, G5 and G6 approval
		else if((GlobalConstants.DEVELOP_OPPORTUNITY.equalsIgnoreCase(currentOpp.StageName) && !currentOpp.Gate_3_Bypass_no_offer_support__c ) ||
				(GlobalConstants.CREATE_OFFER.equalsIgnoreCase(currentOpp.StageName) && currentOpp.NF_LoA_Bypass__c == 0 ) ||
				( GlobalConstants.WIN_THE_CASE_NEGOTIATE.equalsIgnoreCase(currentOpp.StageName) && !GlobalConstants.PENDING_WIN_LOSS_DECLARATION.equalsIgnoreCase(currentOpp.Phase_Status__c) && currentOpp.Blanket_Approval_Condition__c == null && currentOpp.NF_LoA_Bypass__c == 0  ) ||
				(GlobalConstants.HANDOVER_OPPTY.equalsIgnoreCase(currentOpp.StageName) && !(currentOpp.Gate_6_Bypass_No_Execute_needed__c || currentOpp.Blanket_Approval_Condition__c != null) )
			   ){
				   hasNoSubmitForApproval = true;
				   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,GlobalConstants.SPACE +GlobalConstants.GATE_MANAGEMENT_WTD_ERROR));
				   return null;
			   }
		// Win Declaration
		else if( GlobalConstants.WIN_THE_CASE_NEGOTIATE.equalsIgnoreCase(currentOpp.StageName) && GlobalConstants.PENDING_WIN_LOSS_DECLARATION.equalsIgnoreCase(currentOpp.Phase_Status__c) && GlobalConstants.WON_REQUESTED.equalsignorecase(currentOpp.Sales_Outcome__c) && currentOpp.Blanket_Approval_Condition__c == null  && currentOpp.NF_LoA_Bypass__c == 0
				&& currentOpp.OwnerID != null && currentOpp.OwnerID != userId && !userProfileId.equalsIgnoreCase(Label.System_Admin_Profile_ID) && !userProfileId.equalsIgnoreCase(Label.Nokia_Admin_Profile_Id) && !userProfileId.equalsIgnoreCase(Label.Global_Process_Admin_Profile_Id) && !userProfileId.equalsIgnoreCase(Label.Sales_Ops_profile_ID)) {
					hasNoSubmitForApproval = true;
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,GlobalConstants.SPACE + Label.NF_G4_and_G5_Users_Error_Info2));
					return null;
				}
		return constructRedirectionPage(myPage);
	}

	/**
*   @description : Method used to redirect back to the opportunity
*   @return : PageReference
*/
	public PageReference cancel() {
		return new PageReference('/'+currentOppId);
	}

	/**
*   @description : Method used to redirect back to the opportunity based on different conditions
*   @return : PageReference
*/
	@TestVisible private PageReference constructRedirectionPage(PageReference myPage){
		//Redirect to submit for approval.
		/*if(String.valueOf(ApprovalsRedirection.APPROVALCONTEXTSUBMIT).equalsIgnoreCase(redirectionChoice)){
			myPage = Page.Apttus_Approval__ApprovalContextSubmit;
			myPage.getParameters().put('sObjectType', GlobalConstants.OBJECT_OPPORTUNITY);
			myPage.getParameters().put('sObjectId', currentOppId);
		} else if(String.valueOf(ApprovalsRedirection.MYAPPROVALS).equalsIgnoreCase(redirectionChoice)){
			myPage = Page.Apttus_Approval__MyApprovals;
			myPage.getParameters().put('Id', currentOpp.Id);
		} else if(String.valueOf(ApprovalsRedirection.PREVIEWSUBMITAPPROVALS).equalsIgnoreCase(redirectionChoice)){*/
		if(GlobalConstants.IDENTIFY_OPPORTUNITY.equalsignorecase(currentOpp.StageName) && !currentOpp.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.PENDING_APPROVAL) && currentOpp.Gate_2_Bypass_no_complex_offer__c) {
			myPage = redirectPage(Page.NF_BypassPreviewAndSubmit, GlobalConstants.GATE_G2);
		} else if(GlobalConstants.DEVELOP_OPPORTUNITY.equalsignorecase(currentOpp.StageName) && !currentOpp.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.PENDING_APPROVAL) && currentOpp.Gate_3_Bypass_no_offer_support__c== true) {
			myPage = redirectPage(Page.NF_BypassPreviewAndSubmit, GlobalConstants.GATE_G3);
		} else if(GlobalConstants.CREATE_OFFER.equalsignorecase(currentOpp.StageName) && !currentOpp.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.PENDING_APPROVAL) && currentOpp.NF_LoA_Bypass__c>0 ) {
			myPage = redirectPage(Page.NF_BypassPreviewAndSubmit, GlobalConstants.GATE_G4);
		} else if(GlobalConstants.WIN_THE_CASE_NEGOTIATE.equalsignorecase(currentOpp.StageName) &&  currentOpp.Blanket_Approval_Condition__c != null ) {
			myPage = redirectPage(Page.NF_BypassPreviewAndSubmit, GlobalConstants.GATE_G5);
		} else if(GlobalConstants.HANDOVER_OPPTY.equalsignorecase(currentOpp.StageName) &&  !currentOpp.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.PENDING_APPROVAL) && (currentOpp.Gate_6_Bypass_No_Execute_needed__c == true || currentOpp.Blanket_Approval_Condition__c != null )) {
			myPage = redirectPage(Page.NF_BypassPreviewAndSubmit, GlobalConstants.GATE_G6);
		} else {
			myPage = Page.APTSCU_PreviewApproval;
			myPage.getParameters().put('sObjectId', currentOpp.Id);
		}
	return myPage;
	}

	/**
*   @description : Method to set the page redirect
*   @return : PageReference
*/
	private PageReference redirectPage(PageReference redirectPage, String gateClass){
		PageReference newPage = redirectPage;
		newPage.getParameters().put('oppId', currentOpp.Id);
		newPage.getParameters().put('GateClass', gateClass);
		return newPage;
	}

	/**
*   @description : method to check if can proceed for approval
*   @return : PageReference
*/
	public PageReference proceed(){
		for(String mandField : mandParamsG2){
			if(currentOpp.get(mandField) == null){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,GlobalConstants.SPACE + GlobalConstants.MANDATORY_PARAMETERS_G2_APPROVAL_MSG + GlobalConstants.SPACE + getFieldsLabel()));
				showMandatoryInfo = true;
				hasNoSubmitForApproval = true;
				return null;
			}
		}
		if(!validComments()){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,' Please fill "Comments on Cust Req & Nokia Prop"'));
			showMandatoryInfo = true;
			hasNoSubmitForApproval = true;
			return null;
		}
		try{
			update currentOpp;
		} catch (Exception e) {
			System.debug('Exception : ' + e.getMessage());
		}
		showMandatoryInfo = false;
		hasNoSubmitForApproval = false;
		//redirectionChoice = ApexPages.currentPage().getParameters().get('from');
		PageReference redirect = null;
		return constructRedirectionPage(redirect);
	}

	/**
*   @description : method to check if can proceed for approval
*   @return : PageReference
*/
	public PageReference saveAndReturn(){
		try{
			update currentOpp;
		} catch (Exception e) {
			System.debug('Exception : ' + e.getMessage());
		}
		return cancel();
	}
/**
*   @description : get fields label from Schema
*/
	private String getFieldsLabel(){
		List<String> fieldsLabels = new List<String>();
		Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap();
		for(String mandParam : mandParamsG2) {
			for (String fieldName: fieldMap.keySet()) {
				if(fieldName == mandParam) fieldsLabels.add(fieldMap.get(fieldName).getDescribe().getLabel());
			}
		}
		return String.join(fieldsLabels,', ');
	}
/**
*   @description : method to valid Comments fields (JIRA ITBACRM-285)
*/
	private boolean validComments(){
		String customerPPC = currentOpp.Customer_pain_points_challenges__c;
		String comments = currentOpp.Comments_Cust_Req_Nokia_Prop__c;
		if(customerPPC != null && customerPPC.contains('Other + Comment*') && (comments == '' || comments == null)) return false;
		return true;
	}
}