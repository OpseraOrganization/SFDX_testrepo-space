/**
* @name	NF_FacilitatorNotificationCtrl
* @author
* @since   July 08, 2017
* @desc	Class used to serve as redirection to the submit for approval
* @history
*/
public with sharing class NF_FacilitatorNotificationCtrl extends NF_QueueHandler{
	public Opportunity currentOpp {get;set;}
	public Boolean hasNoSubmitForApproval {get;set;}
	public String currentOppId {get;set;}
	public Boolean showMandatoryInfo {get;set;}
	public Boolean g4ApprValForG5Needed {get;set;}
	public String confirmationMessage {get;set;}

	public Set<String> mandParams = new Set<String>();
	private static Double netSalesVal = Double.valueOf(System.Label.Total_Net_Sales_Value);
	private boolean bypassG2 = false;
	private Id userId = UserInfo.getUserId();
	private String userProfileId = UserInfo.getProfileId();

	@TestVisible static String redirectionChoice{get;set;}
	public enum ApprovalsRedirection { APPROVALCONTEXTSUBMIT, MYAPPROVALS , PREVIEWSUBMITAPPROVALS }

	/*
* @desc	the method used to initiate the VF NF_FacilitatorNotification
* @return  PageReference:
*/
	public PageReference init(){
		//Following line used to check wheter the call is from Preview My approvals or Submit&Preview Approvals or Submit from relatedList
		//Modifying exsisting logic as a part of LoA Req 2356 of Sprint 7.
		PageReference errorMessage;
		redirectionChoice = ApexPages.currentPage().getParameters().get('from');
		currentOppId = ApexPages.currentPage().getParameters().get('oppId');
		String isSubmitApproval = ApexPages.currentPage().getParameters().get('submitForApproval');
		String query = buildQuery();
		if(currentOppId !=null ){
			currentOpp = Database.query(query);
		} else {
			return null;
		}
		g4ApprValForG5Needed = false;
		if(isSubmitApproval != null && isSubmitApproval.equals('true')){
			hasNoSubmitForApproval = false;
			return submitForApproval();
		} else {
			hasNoSubmitForApproval = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.NF_OnlyFacilitator_Offer_Validation));
			errorMessage = null;
			return errorMessage;
		}
	}

	/**
*   @description : Method invoked my confirm button at G5, when LoA leval is D or C < 10M when G5 case is not uploaded.
*   @return : void
*/
	public PageReference confirmG4apprvl()
	{
		g4ApprValForG5Needed = false;
		hasNoSubmitForApproval = false;
		redirectionChoice = ApexPages.currentPage().getParameters().get('from');
		PageReference redirect = null;
		return constructRedirectionPage(redirect);
	}

	/**
*   @description : Method used to redirect whether to the approval process submit or to reject the request if conditions not comply.
*   @return : PageReference
*/
	public PageReference submitForApproval(){
		PageReference myPage;
		set<Id> queueMembers = new set<Id>();
		if(String.isNotBlank(currentOpp.Queue_Id__c)){
			queueMembers = getQueueMembers(new set<String>{currentOpp.Queue_Id__c});
		}
		// Identify Opportunity
		if(GlobalConstants.IDENTIFY_OPPORTUNITY.equalsIgnoreCase(currentOpp.StageName) ){
			if(currentOpp.isMultiBG__c && currentOpp.Unweighted_Amount_EUR__c > GlobalConstants.MINUNWEIGHTEDVALUE_G2APPROVAL){
	if (!currentOpp.MultiBGException_AllowG2Bypass__c && !currentOpp.SolutionScopeAlignedCSO__c) {
		hasNoSubmitForApproval = true;
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.MultiBGOver20PleaseCheckFieldsErrorInfo));
		return null;
	}
	if(currentOpp.MultiBGException_AllowG2Bypass__c){
		bypassG2 = true;
	} else if(!currentOpp.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.PENDING_APPROVAL)) {
		showMandatoryInfo = true;
		hasNoSubmitForApproval = true;
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.MANDATORY_PARAMETERS_G2_APPROVAL_MSG));
		return null;
	}
			} else {
	bypassG2 = true;
			}
		}
		// G3, G4 and G5 approval
		else if(	(GlobalConstants.DEVELOP_OPPORTUNITY.equalsIgnoreCase(currentOpp.StageName) && !currentOpp.Gate_3_Bypass_no_offer_support__c ) ||
					(GlobalConstants.CREATE_OFFER.equalsIgnoreCase(currentOpp.StageName) && currentOpp.NF_LoA_Bypass__c == 0 ) ||
		( GlobalConstants.WIN_THE_CASE_NEGOTIATE.equalsIgnoreCase(currentOpp.StageName) && !GlobalConstants.PENDING_WIN_LOSS_DECLARATION.equalsIgnoreCase(currentOpp.Phase_Status__c) && currentOpp.Blanket_Approval_Condition__c == null && currentOpp.NF_LoA_Bypass__c == 0  )
		){
			hasNoSubmitForApproval = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,GlobalConstants.GATE_MANAGEMENT_WTD_ERROR));
			return null;
		}
		// Win the Case
		else if( GlobalConstants.WIN_THE_CASE_NEGOTIATE.equalsIgnoreCase(currentOpp.StageName) && GlobalConstants.PENDING_WIN_LOSS_DECLARATION.equalsIgnoreCase(currentOpp.Phase_Status__c) && GlobalConstants.WON_REQUESTED.equalsignorecase(currentOpp.Sales_Outcome__c) && currentOpp.Blanket_Approval_Condition__c == null  && currentOpp.NF_LoA_Bypass__c == 0
	&& currentOpp.OwnerID != null && currentOpp.OwnerID != userId && !userProfileId.equalsIgnoreCase(Label.System_Admin_Profile_ID) && !userProfileId.equalsIgnoreCase(Label.Nokia_Admin_Profile_Id) && !userProfileId.equalsIgnoreCase(Label.Global_Process_Admin_Profile_Id) && !userProfileId.equalsIgnoreCase(Label.Sales_Ops_profile_ID)) {
		hasNoSubmitForApproval = true;
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.NF_G4_and_G5_Users_Error_Info2));
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
		if(String.valueOf(ApprovalsRedirection.APPROVALCONTEXTSUBMIT).equalsIgnoreCase(redirectionChoice)){
			myPage = Page.Apttus_Approval__ApprovalContextSubmit;
			myPage.getParameters().put('sObjectType', GlobalConstants.OBJECT_OPPORTUNITY);
			myPage.getParameters().put('sObjectId', currentOppId);
		} else if(String.valueOf(ApprovalsRedirection.MYAPPROVALS).equalsIgnoreCase(redirectionChoice)){
			myPage = Page.Apttus_Approval__MyApprovals;
			myPage.getParameters().put('Id', currentOpp.Id);
		} else if(String.valueOf(ApprovalsRedirection.PREVIEWSUBMITAPPROVALS).equalsIgnoreCase(redirectionChoice)){
			if(GlobalConstants.IDENTIFY_OPPORTUNITY.equalsignorecase(currentOpp.StageName) && !currentOpp.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.PENDING_APPROVAL) && bypassG2) {
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
		for(String mandField : mandParams){
			if(currentOpp.get(mandField) == null){
	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,GlobalConstants.ERROR_MANDATORY_PARAMETERS_G2_APPROVAL_MSG));
	showMandatoryInfo = true;
	hasNoSubmitForApproval = true;
	return null;
			}
		}
		try{
			update currentOpp;
		} catch (Exception e) {
			System.debug('Exception : ' + e.getMessage());
		}
		showMandatoryInfo = false;
		hasNoSubmitForApproval = false;
		redirectionChoice = ApexPages.currentPage().getParameters().get('from');
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
*   @description : Method used to get fields API name in fieldset
*   @return : String
*/
	public static Set<String> getFieldSetFieldsAPI(String fieldSetName, String objectName)
	{
		Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
		Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(objectName);
		Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
		Schema.FieldSet fieldSetObj = describeSObjectResultObj.FieldSets.getMap().get(fieldSetName);

		Set<String> fieldsAPI = new Set<String>();
		for(Schema.FieldSetMember field : fieldSetObj.getFields()){
			fieldsAPI.add(field.getFieldPath());
		}

		return fieldsAPI;
	}

	/**
*   @description : Method used to build query for opportunity object
*   @return : String
*/
	public String buildQuery(){
		mandParams.addAll(getFieldSetFieldsAPI('G2_Mandatory_Parameters', 'Opportunity'));
		List<String> noDuplicatesFieldsAPI = new List<String>(mandParams);

		String query = 'SELECT Id, Account.AccountNumber, NF_Facilitator_Notified__c, NF_Facilitator_User__c, StageName, Facilitator_Delegate_1__c, Facilitator_Delegate_2__c, Facilitator_Delegate_3__c, Facilitator_Backup__c, Org_L2__c, Org_L3__c, Org_L4__c, Org_L5__c, Org_L6__c, Org_L7__c, OwnerID , Lead_BG__c, Lead_BU__c, LOA_Level__c, LoA_Level_before_STA__c, Sales_Outcome__c, Gate_3_Bypass_no_offer_support__c, Blanket_Approval_Condition__c, Supporting_BGs_BUs__c, Phase_Status__c, Queue_Id__c, Queue_Name__c, Opportunity_Gate_Class__c, Type_of_Request__c, Supporting_BU_MN__c, Supporting_BU_ION__c, Business_Type__c, OIF_Lines__c, Probability, NF_LoA_Bypass__c, Unweighted_Amount_EUR__c, MultiBGException_AllowG2Bypass__c, SolutionScopeAlignedCSO__c, isMultiBG__c, Gate_6_Bypass_No_Execute_needed__c, Apttus_Approval__Approval_Status__c, ' +
			String.join(noDuplicatesFieldsAPI,',') +
			' , (SELECT Id,ActiveOffer__c,Name, LoA_Approval_Level_G5__c,Total_Net_Sales_in_LoA_EUR__c,LoA_Approval_Level__c,LoA_Level_Before_Trigger_Approval__c,Solution_Sign_Off_New__c FROM Offers__r where ActiveOffer__c = true limit 1), (SELECT Id, UserId,TeamMemberRole FROM OpportunityTeamMembers WHERE UserId=\'' + userId + '\') FROM Opportunity WHERE Id =\'' + currentOppId + '\'';

		return query;
	}
}