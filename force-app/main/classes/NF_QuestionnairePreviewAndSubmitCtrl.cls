/**
* @name	NF_QuestionnairePreviewAndSubmitCtrl
* @author
* @since   July 08, 2017
* @desc	Class used to show error messages when user tries to click on submit for approvals

* @history
*/
public without sharing class NF_QuestionnairePreviewAndSubmitCtrl {
	public opportunity opptyObj {get;set;}
	public String currentOppId {get;set;}
	public boolean leadBGNotFilled {get;set;}
	public Opportunity currentOpp {get;set;}

	private static Map<String,Account_Market__c>accMarket = new Map<String,Account_Market__c>();
	Decimal dOIFValue = Decimal.valueOf(System.Label.Unweighted_Value);
	String leadBGBypass = System.Label.LeadBGbypassforallmarket;


	private static Id directRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static Id inDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
	private static Id readOnlyDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_DIRECT_RECORD_TYPE).getRecordTypeId();
	private static Id readOnlyIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_INDIRECT_RECORD_TYPE).getRecordTypeId();

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
					  Lead_BU__c,
					  StageName,
					  Phase_Status__c,
					  Sales_Outcome__c,
					  LOA_Level__c,
					  Account.RecordType.Name,
					  NF_LoA_Bypass__c,
					  Business_Type__c,
					  OIF_Lines__c,
					  Blanket_Approval_Condition__c,
					  Gate_3_Bypass_no_offer_support__c,
					  Gate_6_Bypass_No_Execute_needed__c,
					  PTA_Signed__c,
					  Unweighted_Amount_EUR__c,
					  G3_Planned_Date__c,
					  G5_Planned_Date__c,
					  Contract_Signing_Entity__c,
					  Account.AccountNumber,
					  probability,
					  Org_L4__c,
					  Org_L5__c,
					  RecordTypeId,
					  RecordType.DeveloperName,
					  SWx_Upsell_Proposal__c, AccountId, Account.Market__c,
					  Reference_Opportunity__c,
					  End_Customer_Information__c,
					  End_Customer_LE__c,
					  Type,
					  Enterprise_Main_Solution__c,
					  Partner_Originated__c,
					  (SELECT Id,LoA_Approval_Level__c,G4_passed__c,LOA_Bypass__c FROM Offers__r WHERE ActiveOffer__c = true),
					  (SELECT Id, TeamMemberRole, User.Id, User.Name FROM OpportunityTeamMembers WHERE TeamMemberRole =: CSWXGlobalConstant.SM limit 1),
					  (SELECT id, Opportunity__c,Deal__r.RecordType.Name FROM Opportunity_Groups__r WHERE Deal__r.RecordType.Name =: GlobalConstants.UPSELL_DEAL)
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
		Boolean hasDeals = !currentOpp.Opportunity_Groups__r.isEmpty();
		Offer__c activeOffer = currentOpp.Offers__r.isEmpty() ? null : currentOpp.Offers__r[0];

		List<String> closedOutcome = new List<String>{ GlobalConstants.CANCEL_BY_CUSTOMER, GlobalConstants.OPP_LOST_TO_COMPETITOR, GlobalConstants.OPP_OBSOLETE, GlobalConstants.WITHDRAWN_BY_NOKIA };
		List<String> stagesWithOIF = new List<String> { GlobalConstants.DEVELOP_OPPORTUNITY, GlobalConstants.CREATE_OFFER, GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE, GlobalConstants.HANDOVER_OPPTY, GlobalConstants.EXECUTE_OPPTY, GlobalConstants.COMPLETED_OPPTY };

			//check if the Account is a Prospect
			if(currentOpp.account.RecordType.Name == GlobalConstants.PROSPECT){
				return validationErrorPage(GlobalConstants.CANNOT_SUBMIT_APPROVAL_FROM_PROSPECT_ACC);
			}
		//check if End Customer is Unknown
		if(currentOpp.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE && (activeOffer != null && (activeOffer.LOA_Bypass__c == GlobalConstants.LOA_BYPASS || activeOffer.LOA_Bypass__c == GlobalConstants.NO_LOA) || currentOpp.Phase_Status__c == GlobalConstants.PENDING_WIN_LOSS_DECLARATION)  && currentOpp.RecordType.DeveloperName == GlobalConstants.Indirect_Record_Type
		   && currentOpp.End_Customer_Information__c == GlobalConstants.EC_INFO_UNKNOWN && currentOpp.End_Customer_LE__c == null){
			   return validationErrorPage(GlobalConstants.EC_UNKNOWN_AT_WIN_DECLARATION);
		   }
		//check if the Lead BG is filled
		if(currentOpp.StageName == GlobalConstants.IDENTIFY_OPPORTUNITY &&
		   (currentOpp.Lead_BG__c == null || (currentOpp.Lead_BU__c == null && currentOpp.Lead_BG__c.equals(GlobalConstants.LEAD_BG_NI)) || currentOpp.Unweighted_Amount_EUR__c == null || currentOpp.G3_Planned_Date__c == null ||
			currentOpp.G5_Planned_Date__c == null || currentOpp.Contract_Signing_Entity__c == null || (currentOpp.Type == GlobalConstants.OPPTYSEGMENT_ENTERPRISE && currentOpp.Enterprise_Main_Solution__c == null) ||
			( currentOpp.Partner_Originated__c==null && (currentOpp.RecordTypeId == inDirectRecordTypeId || currentOpp.RecordTypeId == readOnlyIndirectRecordTypeId ) ) ) ){
				List<String> errorMsgAdd = (currentOpp.RecordTypeId == inDirectRecordTypeId || currentOpp.RecordTypeId == readOnlyIndirectRecordTypeId) ? new List<String>{', Partner Originated'} : new List<String>{''};
					if(currentOpp.Type == GlobalConstants.OPPTYSEGMENT_ENTERPRISE ) errorMsgAdd.add(', Enterprise Main Solution'); else  errorMsgAdd.add('');
				return validationErrorPage(String.format(GlobalConstants.MANDATORY_LEAD_BG, errorMsgAdd));
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
		//submission for G4 without G3 Bypass - it must have an offer, with a Approval level defined or G4/G5 Bypass
		if( !currentOpp.Gate_3_Bypass_no_offer_support__c && currentOpp.StageName.equalsIgnoreCase(GlobalConstants.CREATE_OFFER) && (activeOffer == null || ( activeOffer.LoA_Approval_Level__c == null && currentOpp.NF_LoA_Bypass__c == 0))){
			return validationErrorPage(GlobalConstants.MANDATORY_ACTIVE_OFFER);
		}
		//if there was a G3 Bypass then it must occur a G4/G5 Bypass
		if( currentOpp.Gate_3_Bypass_no_offer_support__c && currentOpp.StageName.equalsIgnoreCase(GlobalConstants.CREATE_OFFER) && (activeOffer == null || currentOpp.NF_LoA_Bypass__c == 0)){
			return validationErrorPage(GlobalConstants.MANDATORY_G4BYPASS_OFFER);
		}
		if( currentOpp.StageName.equalsIgnoreCase(GlobalConstants.CREATE_OFFER) && currentOpp.Phase_Status__c.equalsIgnoreCase(GlobalConstants.OFFER_IN_PROGRESS) && activeOffer != null && activeOffer.G4_passed__c){
			return validationErrorPage(GlobalConstants.ACTIVE_OFFER_G4_APPROVED);
		}
		//check if the LOA Level (from Active Offer) is filled
		if(currentOpp.StageName.equalsIgnoreCase(GlobalConstants.WIN_THE_CASE_NEGOTIATE) && currentOpp.NF_LoA_Bypass__c == 0 && currentOpp.Blanket_Approval_Condition__c == null && currentOpp.LOA_Level__c == null ){
			return validationErrorPage(System.Label.NF_Offer_LoA_Level_Validation);
		}
		if( ( currentOpp.StageName.equalsignorecase(GlobalConstants.DEVELOP_OPPORTUNITY) || currentOpp.StageName.equalsignorecase(GlobalConstants.CREATE_OFFER) || currentOpp.StageName.equalsignorecase(GlobalConstants.WIN_THE_CASE_NEGOTIATE ) ) &&
		   (String.isNotBlank(leadBGBypass) && !leadBGBypass.contains(currentOpp.Lead_BG__c)) &&
		   (accMarket != Null && !accMarket.containsKey(currentOpp.Org_L4__c) && !accMarket.containsKey(currentOpp.Org_L5__c)) &&
		   currentOpp.NF_LoA_Bypass__c != Null && activeOffer != null && activeOffer.LOA_Bypass__c != null && GlobalConstants.LOA_BYPASS.equalsIgnoreCase(activeOffer.LOA_Bypass__c))
		{
			return validationErrorPage(System.label.Market_validation_error_msg);
		}
		if( (currentOpp.StageName.equalsIgnoreCase(GlobalConstants.CREATE_OFFER) || currentOpp.StageName.equalsIgnoreCase(GlobalConstants.WIN_THE_CASE_NEGOTIATE)) && activeOffer !=null && (activeOffer.LOA_Bypass__c == GlobalConstants.PICKLIST_VALUE_AUTHORIZED_FOR_PRICING_MANAGER || activeOffer.LOA_Bypass__c == GlobalConstants.LOA_BYPASS) )
		{
			//Changed Business_Group__c to Business_Unit__c in query as a part of AP2021 Change
			AggregateResult[] aggResult = [SELECT Business_Unit__c, Opportunity__c FROM Order_Intake_Forecast__c
										   WHERE Opportunity__c =: currentOppId AND Allocation__c=false AND Forecast_Category__c != : GlobalConstants.CANCEL and Forecast_Category__c != : GlobalConstants.Lost
										   GROUP BY Business_Unit__c,Opportunity__c HAVING SUM(OIF_Value_EUR__c) >: dOIFValue ];

			if(!aggResult.isEmpty())
			{
				return validationErrorPage(Label.Validate_Unweighted_Value);
			}
		}

		if(currentOpp.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE && currentOpp.Phase_Status__c == GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL && activeOffer.LOA_Bypass__c == GlobalConstants.NO_LOA){
			Opportunity refOppty = new Opportunity();
			if(currentOpp.Reference_Opportunity__c != NULL){
				refOppty = [SELECT Id, Sales_Outcome__c FROM opportunity WHERE Id =: currentOpp.Reference_Opportunity__c LIMIT 1];
			}
			if(currentOpp.Reference_Opportunity__c == NULL || (refOppty.Sales_Outcome__c != GlobalConstants.WON && refOppty.Sales_Outcome__c != GlobalConstants.WON_REQUESTED)){
				return validationErrorPage(GlobalConstants.G5_Submision_WO_RefOpp);
			}
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