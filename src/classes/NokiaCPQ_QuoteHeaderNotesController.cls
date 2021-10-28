/*************************************************************
@Name: NokiaCPQ_QuoteHeaderNotesController 
@Author: Christie JJ
@CreateDate: 1 February 2021
@Description: This class acts as the controller for the VF page : NokiaCPQ_QuoteHeaderNotes, which displays warning messages on the quote record page (rqmt 7357)
@UsedBy: VF page

* Modification Log  :
* Developer	Date		   Description
* -----------------------------------------------------------------------------------------------------------
* Christie JJ   10 March 2021	  Removed "Approval Required" check on the Quote Stage and aggregated similar scenarios

***************************************************************
*/

public without sharing class NokiaCPQ_QuoteHeaderNotesController 
{
	public final Apttus_Proposal__Proposal__c prop {get;set;}
	public String warning {get;set;}
	private Boolean approvalRequired = false;
	private String proposalId,opptyId,opptyStage,loaApprovalLevel,loaBypassOfferCondition,approvalStage;
	
	public NokiaCPQ_QuoteHeaderNotesController(ApexPages.StandardController stdController) 
	{
		warning='';

		String getuserProfileId = userinfo.getProfileId();
		Profile Getprofile = [Select name from Profile where id = :getuserProfileId];
		String partnerProfile = Getprofile.Name;
	   
		this.prop = (Apttus_Proposal__Proposal__c)stdController.getRecord();
		proposalId= this.prop.Id;
		Apttus_Proposal__Proposal__c proposalRecord = [SELECT Id,Apttus_Proposal__Opportunity__c,NokiaCPQ_Approval_Required_Flag__c,Apttus_Proposal__Approval_Stage__c FROM Apttus_Proposal__Proposal__c WHERE Id =:proposalId][0];
		approvalRequired  = proposalRecord.NokiaCPQ_Approval_Required_Flag__c;
		approvalStage = proposalRecord.Apttus_Proposal__Approval_Stage__c;
		opptyId = proposalRecord.Apttus_Proposal__Opportunity__c;
		Opportunity opptyRecord = [SELECT Id,StageName FROM Opportunity WHERE Id =:opptyId][0];
		opptyStage = opptyRecord.StageName;
		Offer__c offerRecord;
		List<Offer__c> offerRecords = [SELECT Id,Opportunity__c,LoA_Approval_Level__c,LOA_Bypass__c,ActiveOffer__c FROM Offer__c WHERE Opportunity__c =:opptyId AND ActiveOffer__c = true];
		
		//Check if valid offer exists
		if(offerRecords!=null && offerRecords.size()>=1){
			offerRecord=offerRecords[0];
			if(offerRecord!=null){
			loaApprovalLevel = offerRecord.LoA_Approval_Level__c;
			loaBypassOfferCondition = offerRecord.LOA_Bypass__c;

			//Check if User is Partner User
			if(partnerProfile.contains(Nokia_CPQ_Constants.profilename_contains)){
				//Scenario NA1
				if(opptyStage == Nokia_CPQ_Constants.CREATEOFFERSTAGE && (String.isBlank(loaApprovalLevel)||loaApprovalLevel==Nokia_CPQ_Constants.LOABYPASS) && String.isBlank(loaBypassOfferCondition) && approvalRequired==Nokia_CPQ_Constants.FalseValue && approvalStage==Nokia_CPQ_Constants.QUOTEDRAFT)
				warning = GlobalConstants.ERRORSS;
				//Scenario NA3
				else if(opptyStage == Nokia_CPQ_Constants.CREATEOFFERSTAGE && loaBypassOfferCondition==GlobalConstants.LOA_BYPASS && approvalRequired==Nokia_CPQ_Constants.FalseValue && approvalStage==Nokia_CPQ_Constants.QUOTEDRAFT)
				warning = Nokia_CPQ_Constants.INFOIVPTNR;
				//Scenario NA4
				else if(opptyStage == Nokia_CPQ_Constants.CREATEOFFERSTAGE && loaBypassOfferCondition==GlobalConstants.PICKLIST_VALUE_AUTHORIZED_FOR_PRICING_MANAGER && approvalRequired==Nokia_CPQ_Constants.FalseValue && approvalStage==Nokia_CPQ_Constants.QUOTEDRAFT)
				warning = Nokia_CPQ_Constants.INFOIVPTNR;
				//Scenario NA6
				else if(opptyStage == Nokia_CPQ_Constants.CREATEOFFERSTAGE && (loaApprovalLevel!=Nokia_CPQ_Constants.LOABYPASS) && loaBypassOfferCondition==GlobalConstants.NO_LOA && approvalRequired==Nokia_CPQ_Constants.FalseValue && approvalStage==Nokia_CPQ_Constants.QUOTEDRAFT)
				warning = GlobalConstants.ERRORSS;
				//Scenario AR6
				else if(opptyStage == Nokia_CPQ_Constants.CREATEOFFERSTAGE && (loaApprovalLevel==Nokia_CPQ_Constants.LOABYPASS) && loaBypassOfferCondition==GlobalConstants.NO_LOA && approvalRequired==Nokia_CPQ_Constants.TrueValue && approvalStage==Nokia_CPQ_Constants.ApprovalRequired)
				warning = GlobalConstants.ERRORSS;
				//Scenario NA8
				else if(opptyStage == Nokia_CPQ_Constants.WINTHECASESTAGE && (!String.isBlank(loaApprovalLevel)&&loaApprovalLevel!=Nokia_CPQ_Constants.LOABYPASS) && String.isBlank(loaBypassOfferCondition) && approvalRequired==Nokia_CPQ_Constants.FalseValue && approvalStage==Nokia_CPQ_Constants.QUOTEDRAFT)
				warning = Nokia_CPQ_Constants.INFOIVPTNR;
				//Scenario NA9
				else if(opptyStage == Nokia_CPQ_Constants.WINTHECASESTAGE && (String.isBlank(loaApprovalLevel)||loaApprovalLevel==Nokia_CPQ_Constants.LOABYPASS) && loaBypassOfferCondition==GlobalConstants.LOA_BYPASS && approvalRequired==Nokia_CPQ_Constants.FalseValue && approvalStage==Nokia_CPQ_Constants.QUOTEDRAFT)
				warning = Nokia_CPQ_Constants.INFOIVPTNR;
				//Scenario NA10
				else if(opptyStage == Nokia_CPQ_Constants.WINTHECASESTAGE && (String.isBlank(loaApprovalLevel)||loaApprovalLevel==Nokia_CPQ_Constants.LOABYPASS) && loaBypassOfferCondition==GlobalConstants.PICKLIST_VALUE_AUTHORIZED_FOR_PRICING_MANAGER && approvalRequired==Nokia_CPQ_Constants.FalseValue && approvalStage==Nokia_CPQ_Constants.QUOTEDRAFT)
				warning = Nokia_CPQ_Constants.INFOIVPTNR;
				//Scenario AR7
				else if(opptyStage == Nokia_CPQ_Constants.WINTHECASESTAGE && (String.isBlank(loaApprovalLevel)||loaApprovalLevel==Nokia_CPQ_Constants.LOABYPASS) && loaBypassOfferCondition==GlobalConstants.NO_LOA && approvalRequired==Nokia_CPQ_Constants.TrueValue && approvalStage==Nokia_CPQ_Constants.QUOTEDRAFT)
				warning = Nokia_CPQ_Constants.INFOIVPTNR;
			}


			//User is PSM user
			else{
				//Scenario NA1
				if(opptyStage == Nokia_CPQ_Constants.CREATEOFFERSTAGE && (String.isBlank(loaApprovalLevel)||loaApprovalLevel==Nokia_CPQ_Constants.LOABYPASS) && String.isBlank(loaBypassOfferCondition) && approvalRequired==Nokia_CPQ_Constants.FalseValue && approvalStage==Nokia_CPQ_Constants.QUOTEDRAFT)
				warning = Nokia_CPQ_Constants.INFOLOA;
				//Scenario NA3
				else if(opptyStage == Nokia_CPQ_Constants.CREATEOFFERSTAGE && loaBypassOfferCondition==GlobalConstants.LOA_BYPASS && approvalRequired==Nokia_CPQ_Constants.FalseValue && approvalStage==Nokia_CPQ_Constants.QUOTEDRAFT)
				warning = Nokia_CPQ_Constants.INFOPSMNA;
				//Scenario NA4
				else if(opptyStage == Nokia_CPQ_Constants.CREATEOFFERSTAGE && loaBypassOfferCondition==GlobalConstants.PICKLIST_VALUE_AUTHORIZED_FOR_PRICING_MANAGER && approvalRequired==Nokia_CPQ_Constants.FalseValue && approvalStage==Nokia_CPQ_Constants.QUOTEDRAFT)
				warning = Nokia_CPQ_Constants.INFOPSMNA;
				//Scenario NA6
				else if(opptyStage == Nokia_CPQ_Constants.CREATEOFFERSTAGE && (loaApprovalLevel!=Nokia_CPQ_Constants.LOABYPASS) && loaBypassOfferCondition==GlobalConstants.NO_LOA && approvalRequired==Nokia_CPQ_Constants.FalseValue && approvalStage==Nokia_CPQ_Constants.QUOTEDRAFT)
				warning = Nokia_CPQ_Constants.INFOLOA;
				//Scenario AR6
				else if(opptyStage == Nokia_CPQ_Constants.CREATEOFFERSTAGE && (loaApprovalLevel==Nokia_CPQ_Constants.LOABYPASS) && loaBypassOfferCondition==GlobalConstants.NO_LOA && approvalRequired==Nokia_CPQ_Constants.TrueValue && approvalStage==Nokia_CPQ_Constants.ApprovalRequired)
				warning = Nokia_CPQ_Constants.INFOLOA;
				//Scenario NA8
				else if(opptyStage == Nokia_CPQ_Constants.WINTHECASESTAGE && (!String.isBlank(loaApprovalLevel)&&loaApprovalLevel!=Nokia_CPQ_Constants.LOABYPASS) && String.isBlank(loaBypassOfferCondition) && approvalRequired==Nokia_CPQ_Constants.FalseValue && approvalStage==Nokia_CPQ_Constants.QUOTEDRAFT)
				warning = Nokia_CPQ_Constants.OPPORTUNITYCANNOTBEVALIDATED;
				//Scenario NA9
				else if(opptyStage == Nokia_CPQ_Constants.WINTHECASESTAGE && (String.isBlank(loaApprovalLevel)||loaApprovalLevel==Nokia_CPQ_Constants.LOABYPASS) && loaBypassOfferCondition==GlobalConstants.LOA_BYPASS && approvalRequired==Nokia_CPQ_Constants.FalseValue && approvalStage==Nokia_CPQ_Constants.QUOTEDRAFT)
				warning = Nokia_CPQ_Constants.INFOPSMNA;
				//Scenario NA10
				else if(opptyStage == Nokia_CPQ_Constants.WINTHECASESTAGE && (String.isBlank(loaApprovalLevel)||loaApprovalLevel==Nokia_CPQ_Constants.LOABYPASS) && loaBypassOfferCondition==GlobalConstants.PICKLIST_VALUE_AUTHORIZED_FOR_PRICING_MANAGER && approvalRequired==Nokia_CPQ_Constants.FalseValue && approvalStage==Nokia_CPQ_Constants.QUOTEDRAFT)
				warning = Nokia_CPQ_Constants.INFOPSMNA;
				//Scenario AR7
				else if(opptyStage == Nokia_CPQ_Constants.WINTHECASESTAGE && (String.isBlank(loaApprovalLevel)||loaApprovalLevel==Nokia_CPQ_Constants.LOABYPASS) && loaBypassOfferCondition==GlobalConstants.NO_LOA && approvalRequired==Nokia_CPQ_Constants.TrueValue && approvalStage==Nokia_CPQ_Constants.QUOTEDRAFT)
				warning = Nokia_CPQ_Constants.OPPORTUNITYCANNOTBEVALIDATED;
		   
			}
			
			if(warning != '')
			warning = Nokia_CPQ_Constants.WARNING + warning;
		}
	}

	//No Valid Offer exists
	else{
		if(partnerProfile.contains(Nokia_CPQ_Constants.profilename_contains)) {
			warning = Nokia_CPQ_Constants.WARNING + GlobalConstants.ERRORSS;
		}
		else {
			warning =  Nokia_CPQ_Constants.WARNING + Nokia_CPQ_Constants.VALIDOFFER;
		}

	}


}
}