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
	   
		if(allowSubmitForApprovals() && isSubmitApproval != null && isSubmitApproval.equals('true')){
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
	*   @description : Method used to redirect whether to the approval process submit or to reject the request if conditions not comply.
	*   @return : PageReference
	*/
	public PageReference submitForApproval(){
		
		PageReference myPage;
		set<Id> queueMembers = new set<Id>();
		if(String.isNotBlank(currentOpp.Queue_Id__c)){
			queueMembers = getQueueMembers(new set<String>{currentOpp.Queue_Id__c});
		}
		Offer__c offerInfo = currentOpp.Offers__r.isEmpty() ? null : currentOpp.Offers__r[0];
		
		// Identify Opportunity
		if(GlobalConstants.IDENTIFY_OPPORTUNITY.equalsIgnoreCase(currentOpp.StageName) ){
			if((currentOpp.lead_BG__c != null && currentOpp.isMultiBG__c) && currentOpp.Unweighted_Amount_EUR__c > GlobalConstants.MINUNWEIGHTEDVALUE_G2APPROVAL){
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
		// Develop Opportunity
		else if ( GlobalConstants.DEVELOP_OPPORTUNITY.equalsIgnoreCase(currentOpp.StageName) && currentOpp.No_Offer_Support__c != 1 && currentOpp.No_Offer_Support__c != 3 && !isFacilitatorSubmitting(queueMembers) ){
			// DO not submit for approval show message that only Facilitator can submit for G3
			hasNoSubmitForApproval = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.NF_OnlyFacilitatorCanSubmit));
			return null;
		} 
		// Create Offer
		else if(GlobalConstants.CREATE_OFFER.equalsIgnoreCase(currentOpp.StageName) && currentOpp.NF_LoA_Bypass__c == 0 ) {
			if(offerInfo != Null){
				if( (GlobalConstants.LOA_Level_C.equalsignorecase(offerInfo.LoA_Approval_Level__c) || GlobalConstants.LOA_Level.equalsignorecase(offerInfo.LoA_Approval_Level__c) || GlobalConstants.LOA_Level_A_Plus.equalsignorecase(offerInfo.LoA_Approval_Level__c) || GlobalConstants.LOA_Level_D.equalsignorecase(offerInfo.LoA_Approval_Level__c) ) && !userProfileId.equalsIgnoreCase(Label.System_Admin_Profile_ID) && !userProfileId.equalsIgnoreCase(Label.Nokia_Admin_Profile_Id) && !userProfileId.equalsIgnoreCase(Label.Global_Process_Admin_Profile_Id) && !OpptyofferUserlist() )   {
					hasNoSubmitForApproval = true;
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.NF_G4_and_G5_Users_Error_Info));
					return null;
				} 
			} else {
				hasNoSubmitForApproval = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,GlobalConstants.ACTIVE_OFFER_FOR_APPROVAL));
				return null;
			}
		} 
		// Win the Case
		else if( GlobalConstants.WIN_THE_CASE_NEGOTIATE.equalsIgnoreCase(currentOpp.StageName) && !GlobalConstants.PENDING_WIN_LOSS_DECLARATION.equalsIgnoreCase(currentOpp.Phase_Status__c) && currentOpp.No_Offer_Support__c != 2 && currentOpp.No_Offer_Support__c != 3 && currentOpp.NF_LoA_Bypass__c==0  ) {
			if(offerInfo != null){
				if( (GlobalConstants.LOA_Level.equalsignorecase(offerInfo.LoA_Level_Before_Trigger_Approval__c) || GlobalConstants.LOA_Level_A_Plus.equalsignorecase(offerInfo.LoA_Level_Before_Trigger_Approval__c) || (GlobalConstants.LOA_Level_C.equalsignorecase(offerInfo.LoA_Level_Before_Trigger_Approval__c) && offerInfo.Total_Net_Sales_in_LoA_EUR__c != Null &&  offerInfo.Total_Net_Sales_in_LoA_EUR__c>=netSalesVal )) && !userProfileId.equalsIgnoreCase(Label.System_Admin_Profile_ID) && !userProfileId.equalsIgnoreCase(Label.Nokia_Admin_Profile_Id) && !userProfileId.equalsIgnoreCase(Label.Global_Process_Admin_Profile_Id)  && !OpptyofferUserlist()) {
					hasNoSubmitForApproval = true;
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.NF_G4_and_G5_Users_Error_Info));
					return null;
				} 
			} else {
				hasNoSubmitForApproval = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, GlobalConstants.ACTIVE_OFFER_FOR_APPROVAL));
				return null;
			}
		} 
		else if( GlobalConstants.WIN_THE_CASE_NEGOTIATE.equalsIgnoreCase(currentOpp.StageName) && GlobalConstants.PENDING_WIN_LOSS_DECLARATION.equalsIgnoreCase(currentOpp.Phase_Status__c) && GlobalConstants.WON_REQUESTED.equalsignorecase(currentOpp.Sales_Outcome__c) && currentOpp.No_Offer_Support__c != 2 && currentOpp.No_Offer_Support__c != 3 && currentOpp.NF_LoA_Bypass__c == 0 
		&& currentOpp.OwnerID != null && currentOpp.OwnerID != userId && !userProfileId.equalsIgnoreCase(Label.System_Admin_Profile_ID) && !userProfileId.equalsIgnoreCase(Label.Nokia_Admin_Profile_Id) && !userProfileId.equalsIgnoreCase(Label.Global_Process_Admin_Profile_Id) && !userProfileId.equalsIgnoreCase(Label.Sales_Ops_profile_ID)) {
			hasNoSubmitForApproval = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.NF_G4_and_G5_Users_Error_Info));
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
			} else if(GlobalConstants.DEVELOP_OPPORTUNITY.equalsignorecase(currentOpp.StageName) && !currentOpp.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.PENDING_APPROVAL) && (currentOpp.No_Offer_Support__c==1 || currentOpp.No_Offer_Support__c==3 )) {
				myPage = redirectPage(Page.NF_BypassPreviewAndSubmit, GlobalConstants.GATE_G3);
			} else if(GlobalConstants.CREATE_OFFER.equalsignorecase(currentOpp.StageName) && !currentOpp.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.PENDING_APPROVAL) && currentOpp.NF_LoA_Bypass__c>0 ) {
				myPage = redirectPage(Page.NF_BypassPreviewAndSubmit, GlobalConstants.GATE_G4);
			} else if(GlobalConstants.WIN_THE_CASE_NEGOTIATE.equalsignorecase(currentOpp.StageName) &&  currentOpp.No_Offer_Support__c>1 ) {
				myPage = redirectPage(Page.NF_BypassPreviewAndSubmit, GlobalConstants.GATE_G5);
			} else if(GlobalConstants.HANDOVER_OPPTY.equalsignorecase(currentOpp.StageName) &&  !currentOpp.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.PENDING_APPROVAL) && (currentOpp.Product_Only_Offer_RS__c>0 || currentOpp.No_Offer_Support__c>1 )) {
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
	*   @description : Method to test Opportunity and Offer Team Member
	*   @return : Boolean
	*/
	public Boolean OpptyofferUserlist() {
		try{
			Offer__c offerInfo = currentOpp.Offers__r.isEmpty() ? null : currentOpp.Offers__r[0];
			for(OpportunityTeamMember OpptyTeam : currentOpp.OpportunityTeamMembers) {
				if(GlobalConstants.OFFER_CONTROL.equalsignorecase(OpptyTeam.TeamMemberRole))
					return true;
			}
			//Collecting the Offer Team Members
			for(Offer_Team__c OfferTeam : [SELECT id,Name__c,Team_Member_Role__c FROM Offer_Team__c WHERE Offer__c=:offerInfo.Id and Name__c=:userId]) {
				if( GlobalConstants.OFFER_CONTROL.equalsignorecase(OfferTeam.Team_Member_Role__c))
					return true;
			}
		} catch(Exception e) {
			System.debug('In Exception--->'+ e);
		}
		return false;
	}


	/**
	*   @description : Method used to make LoA Gate 5 Template upload - mandatory for LoA A Opptys Req.#2356, Req#4537, Req#4855
	*   @return : Boolean
	*/
	public Boolean allowSubmitForApprovals() {
		Offer__c offerRec = currentOpp.Offers__r.isEmpty() ? null : currentOpp.Offers__r[0];
		try{
			if(GlobalConstants.WIN_THE_CASE_NEGOTIATE.equalsIgnoreCase(currentOpp.StageName) && 
			   GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL.equalsIgnoreCase(currentOpp.Phase_Status__c) &&
			   currentOpp.No_Offer_Support__c != 2 && currentOpp.No_Offer_Support__c != 3 && 
			   ( GlobalConstants.LOA_Level.equalsIgnoreCase(currentOpp.LOA_Level__c) || GlobalConstants.LOA_Level_A_Plus.equalsIgnoreCase(currentOpp.LOA_Level__c) || GlobalConstants.LOA_Level_C.equalsIgnoreCase(currentOpp.LOA_Level__c)))
			{
				if(offerRec != null && 
				   (String.isNotBlank(offerRec.LoA_Approval_Level_G5__c) || 
				   ((offerRec.Total_Net_Sales_in_LoA_EUR__c == null || offerRec.Total_Net_Sales_in_LoA_EUR__c < netSalesVal) && currentOpp.LOA_Level__c.equalsIgnoreCase(GlobalConstants.LOA_Level_C)) ) )
				{
					return true;
				} 
				return false;
			} 
		}  catch(Exception e) {
			System.debug('In Exception--->'+ e);
		}
		return true;
	}
	
	/**
	*   @description : Method used to verify if it's the facilitator to submit for approval
	*   @return : Boolean
	*/
	public Boolean isFacilitatorSubmitting(Set<Id> queueMembers) {
		Boolean noFacilitator = queueMembers.isEmpty() && String.isBlank(currentOpp.NF_Facilitator_User__c) && String.isBlank(currentOpp.Facilitator_Backup__c) && String.isBlank(currentOpp.Facilitator_Delegate_1__c) && String.isBlank(currentOpp.Facilitator_Delegate_2__c) && String.isBlank(currentOpp.Facilitator_Delegate_3__c);
		Boolean isQueueMember = !queueMembers.isEmpty() && queueMembers.contains(userId);
		Boolean isFacilitator = queueMembers.isEmpty() && (userId.equals(currentOpp.NF_Facilitator_User__c) || userId.equals(currentOpp.Facilitator_Backup__c) || userId.equals(currentOpp.Facilitator_Delegate_1__c) || userId.equals(currentOpp.Facilitator_Delegate_2__c) || userId.equals(currentOpp.Facilitator_Delegate_3__c));
		return  currentOpp.NF_Facilitator_Notified__c && !noFacilitator && ( isQueueMember || isFacilitator );
	}
	
	/**
	*   @description : Method used to get fields API name in fieldset
	*   @return : String 
	*/
	public static Set<String> getFieldSetFieldsAPI(String fieldSetName, String ObjectName)
	{
		Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
		Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
		Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
		Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);

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
		Set<String> extraFieldsForQuery = new Set<String>();
		mandParams.addAll(getFieldSetFieldsAPI('G2_Mandatory_Parameters', 'Opportunity'));
		List<String> noDuplicatesFieldsAPI = new List<String>(mandParams);
		
		String query = 'SELECT Id, Account.AccountNumber, NF_Facilitator_Notified__c, NF_Facilitator_User__c, StageName, Facilitator_Delegate_1__c, Facilitator_Delegate_2__c, Facilitator_Delegate_3__c, Facilitator_Backup__c, Org_L2__c, Org_L3__c, Org_L4__c, Org_L5__c, Org_L6__c, Org_L7__c, OwnerID , Lead_BG__c, Lead_BU__c, LOA_Level__c, Sales_Outcome__c, No_Offer_Support__c, Supporting_BG_AA__c, Supporting_BG_FN__c, Supporting_BG_ION__c, Supporting_BG_MN__c, Supporting_BG_GS__c, Supporting_BG_NEN__c, Supporting_BG__c, Phase_Status__c, Queue_Id__c, Queue_Name__c, Opportunity_Gate_Class__c, Type_of_Request__c, Supporting_BU_MN__c, Supporting_BU_ION__c, Business_Type__c, OIF_Lines__c, Probability, NF_LoA_Bypass__c, Unweighted_Amount_EUR__c, MultiBGException_AllowG2Bypass__c, SolutionScopeAlignedCSO__c, isMultiBG__c, Product_Only_Offer_RS__c, Apttus_Approval__Approval_Status__c, ' +
			String.join(noDuplicatesFieldsAPI,',') + 
			 ' , (SELECT Id,ActiveOffer__c,Name, LoA_Approval_Level_G5__c,Total_Net_Sales_in_LoA_EUR__c,LoA_Approval_Level__c,LoA_Level_Before_Trigger_Approval__c,Solution_Sign_Off_New__c FROM Offers__r where ActiveOffer__c = true limit 1), (SELECT Id, UserId,TeamMemberRole FROM OpportunityTeamMembers WHERE UserId=\'' + userId + '\') FROM Opportunity WHERE Id =\'' + currentOppId + '\'';

		return query;
	}
}