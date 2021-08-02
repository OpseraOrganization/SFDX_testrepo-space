/**
* @name	NF_QuestionnairePreviewAndSubmitCtrl
* @author
* @since   July 08, 2017
* @desc	Class used to show error messages when user tries to click on submit for approvals

* @history
*/
public with sharing class NF_QuestionnairePreviewAndSubmitCtrl {
	public opportunity opptyObj {get;set;}
	public String currentOppId {get;set;}
	public boolean leadBGNotFilled {get;set;}
	public Opportunity currentOpp {get;set;}

	private static Map<String,Account_Market__c>accMarket = new Map<String,Account_Market__c>();
	Decimal dOIFValue = Decimal.valueOf(System.Label.Unweighted_Value);
	String leadBGBypass = System.Label.LeadBGbypassforallmarket;
	

	private static Id directRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.DIRECT_OPPTY).getRecordTypeId();
	private static Id inDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.INDIRECT_OPPTY).getRecordTypeId();
	private static Id readOnlyDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.READONLYDIRECT).getRecordTypeId();
	private static Id readOnlyIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.READONLYINDIRECT).getRecordTypeId();

	/*****
	* @desc	constructor used to initiate and query variable
	* @return  query result
	***/
	public NF_QuestionnairePreviewAndSubmitCtrl() {
		system.debug('in NF_QuestionnairePreviewAndSubmitCtrl constructor*********************');
		currentOppId = ApexPages.currentPage().getParameters().get('oppId');
		leadBGNotFilled = false;

		currentOpp = [SELECT
		Lead_BG__c,
		StageName,
		Phase_Status__c,
		Sales_Outcome__c,
		LOA_Level__c,
		Account.RecordType.Name,
		NF_LoA_Bypass__c,
		Business_Type__c,
		OIF_Lines__c,
		No_Offer_Support__c,
		Product_Only_Offer_RS__c,
		PTA_Signed__c,
		Account.AccountNumber,
		probability,
		Org_L4__c,
		Org_L5__c,
		RecordTypeId,
		Expected_LoA_Approval_Level__c,
		SWx_Upsell_Proposal__c, AccountId, Account.Market__c,
		(SELECT Id,LoA_Approval_Level__c,G4_passed__c,LOA_Bypass__c FROM Offers__r WHERE ActiveOffer__c = true),
		(SELECT Id, TeamMemberRole, User.Id, User.Name FROM OpportunityTeamMembers WHERE TeamMemberRole =: CSWXGlobalConstant.SM limit 1),
		(SELECT id, Opportunity__c,Deal__r.RecordType.Name FROM Opportunity_Groups__r WHERE Deal__r.RecordType.Name =: GlobalConstants.UPSELL_DEAL),
		(SELECT Id, OIF_Value_EUR__c FROM Order_Intake_Forecast_del__r WHERE Allocation__c=false AND Forecast_Category__c != : GlobalConstants.CANCEL and Forecast_Category__c != : GlobalConstants.Lost )
		FROM Opportunity
		WHERE Id =: currentOppId];

	}

	/**
	*   @desc : this method is used to redirect to the approvalPreview&Submit directly in the opportunity is already in Pending Approvals.
	*   @return :	PageReference
	*/
	public PageReference init(){
		PageReference myPage = null;
		accMarket = Account_Market__c.getAll();
		OpportunityTeamMember oppTeamMember = currentOpp.OpportunityTeamMembers.isEmpty() ? null : currentOpp.OpportunityTeamMembers[0];
		Boolean hasDeals = currentOpp.Opportunity_Groups__r.isEmpty() ? false : true;
		Offer__c activeOffer = currentOpp.Offers__r.isEmpty() ? null : currentOpp.Offers__r[0];
		List<Order_Intake_Forecast__c> opptyOIFs = currentOpp.Order_Intake_Forecast_del__r.isEmpty() ? new List<Order_Intake_Forecast__c>() : currentOpp.Order_Intake_Forecast_del__r;
		Double totalValueOIF = 0.0;
		for(Order_Intake_Forecast__c oif : opptyOIFs){
			totalValueOIF += oif.OIF_Value_EUR__c == null ? 0.0 : oif.OIF_Value_EUR__c;
		}

		List<String> closedOutcome = new List<String>{ GlobalConstants.CANCEL_BY_CUSTOMER, GlobalConstants.OPP_LOST_TO_COMPETITOR, GlobalConstants.OPP_OBSOLETE, GlobalConstants.WITHDRAWN_BY_NOKIA };
		List<String> stagesWithOIF = new List<String> { GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.CREATE_OFFER, GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE, GlobalConstants.HANDOVER_OPPTY, GlobalConstants.EXECUTE_OPPTY, GlobalConstants.COMPLETED_OPPTY };

		//check if the Account is a Prospect
		if(currentOpp.account.RecordType.Name == GlobalConstants.PROSPECT){
			return validationErrorPage(GlobalConstants.CANNOT_SUBMIT_APPROVAL_FROM_PROSPECT_ACC);
		}
		//check if the Lead BG is filled
		if(currentOpp.StageName == GlobalConstants.IDENTIFY_OPPORTUNITY && currentOpp.Lead_BG__c == null ){
			return validationErrorPage(GlobalConstants.MANDATORY_LEAD_BG);
		}
		if( (oppTeamMember == null || String.isBlank(oppTeamMember.TeamMemberRole) ) && currentOpp.StageName == GlobalConstants.DEVELOP_OPPORTUNITY && currentOpp.SWx_Upsell_Proposal__c != null){
			return validationErrorPage(System.label.Error_msg_on_opportunity);
		}
		if( (String.isEmpty(currentOpp.Account.AccountNumber) || !currentOpp.Account.AccountNumber.contains('301') ) &&
		(currentOpp.StageName.equalsignorecase(GlobalConstants.DEVELOP_OPPORTUNITY ) || currentOpp.StageName.equalsignorecase(GlobalConstants.IDENTIFY_OPPORTUNITY ) ))
		{
			return validationErrorPage(GlobalConstants.ACCOUNT_NOT_VALID);
		}
		//check if Sales_Outcome__c = Cancelled by Customer'or  'Lost to Competitor' or 'Obsolete' or  'Withdrawn by Nokia'
		if( closedOutcome.contains(currentOpp.Sales_Outcome__c) ){
			return validationErrorPage(GlobalConstants.SALES_OUTCOME_CLOSED);
		}
		/*changes for Committed Upsell Block to create upsell deal*/
		if ((currentOpp.RecordTypeId == directRecordTypeId || currentOpp.RecordTypeId == inDirectRecordTypeId || currentOpp.RecordTypeId == readOnlyDirectRecordTypeId || currentOpp.RecordTypeId == readOnlyIndirectRecordTypeId ) && currentOpp.Business_Type__c == GlobalConstants.COMMITTED_UPSELL && currentOpp.StageName == GlobalConstants.IDENTIFY_OPPORTUNITY && !hasDeals )
		{
			return validationErrorPage(System.label.NF_Upsell_Bypass_ErrorMsg);
		}
		//check if at least 1 record of OIF object should be created before opening G3
		if(currentOpp.OIF_Lines__c==0 && stagesWithOIF.contains(currentOpp.StageName) ){
			return validationErrorPage(GlobalConstants.MANDATORY_OIF_FOR_APPROVAL);
		}
		if(currentOpp.StageName.equalsIgnoreCase(GlobalConstants.DEVELOP_OPPORTUNITY) && currentOpp.Expected_LoA_Approval_Level__c == null){
			return validationErrorPage(GlobalConstants.MANDATORY_EXP_LOA_LEVEL_G3);
		}
		if( currentOpp.StageName.equalsIgnoreCase(GlobalConstants.CREATE_OFFER) && (activeOffer == null || ( activeOffer.LoA_Approval_Level__c == null && currentOpp.NF_LoA_Bypass__c == 0))){
			return validationErrorPage(GlobalConstants.MANDATORY_ACTIVE_OFFER);
		}
		if( currentOpp.StageName.equalsIgnoreCase(GlobalConstants.CREATE_OFFER) && currentOpp.Phase_Status__c.equalsIgnoreCase(GlobalConstants.OFFER_IN_PROGRESS) && activeOffer != null && activeOffer.G4_passed__c){
			return validationErrorPage(GlobalConstants.ACTIVE_OFFER_G4_APPROVED);
		}
		//check if the LOA Level (from Active Offer) is filled
		if(currentOpp.StageName.equalsIgnoreCase(GlobalConstants.WIN_THE_CASE_NEGOTIATE) && currentOpp.NF_LoA_Bypass__c == 0 && currentOpp.No_Offer_Support__c<2 && currentOpp.LOA_Level__c == null ){
			return validationErrorPage(System.Label.NF_Offer_LoA_Level_Validation);
		}
		if( ( currentOpp.StageName.equalsignorecase(GlobalConstants.DEVELOP_OPPORTUNITY) || currentOpp.StageName.equalsignorecase(GlobalConstants.CREATE_OFFER) || currentOpp.StageName.equalsignorecase(GlobalConstants.WIN_THE_CASE_NEGOTIATE ) ) &&
		(String.isNotBlank(leadBGBypass) && !leadBGBypass.contains(currentOpp.Lead_BG__c)) &&
		(accMarket != Null && !accMarket.containsKey(currentOpp.Org_L4__c) && !accMarket.containsKey(currentOpp.Org_L5__c)) &&
		currentOpp.NF_LoA_Bypass__c != Null && activeOffer != null && activeOffer.LOA_Bypass__c != null && GlobalConstants.LOA_BYPASS.equalsIgnoreCase(activeOffer.LOA_Bypass__c))
		{
			return validationErrorPage(System.label.Market_validation_error_msg);
		}
		if( (currentOpp.StageName.equalsIgnoreCase(GlobalConstants.CREATE_OFFER) || currentOpp.StageName.equalsIgnoreCase(GlobalConstants.WIN_THE_CASE_NEGOTIATE)) && activeOffer !=null && (activeOffer.LOA_Bypass__c == GlobalConstants.PICKLIST_VALUE_AUTHORIZED_FOR_PRICING_MANAGER || activeOffer.LOA_Bypass__c == GlobalConstants.LOA_BYPASS) && totalValueOIF > dOIFValue )
		{
			return validationErrorPage(Label.Validate_Unweighted_Value);
		}
		if(currentOpp.StageName == GlobalConstants.HANDOVER_OPPTY && currentOpp.Product_Only_Offer_RS__c == 0 && !currentOpp.PTA_Signed__c){
			return validationErrorPage(GlobalConstants.MANDATORY_PTA_SIGNED_G6);
		}

		return constructRedirectionPage(myPage);

	}


	private PageReference validationErrorPage(String errorMsg){
		leadBGNotFilled = true;
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorMsg));
		return null;
	}

	/**
	*   @desc : Method used to construct PageReference redirection to the submit preview approvals
	*   @param : PageReference
	*   @return PageReference
	*/
	@TestVisible private PageReference constructRedirectionPage(PageReference myPage){
		myPage = Page.NF_FacilitatorNotification;
		myPage.getParameters().put('submitForApproval', 'true');
		myPage.getParameters().put('oppId', currentOppId);
		myPage.getParameters().put('from', 'PreviewSubmitApprovals');
		return myPage;
	}
	/**
	*   @description : Method used to redirect back to the opportunity
	*   @return : PageReference
	*/
	public PageReference cancel() {
		return new PageReference('/'+currentOppId);
	}
}