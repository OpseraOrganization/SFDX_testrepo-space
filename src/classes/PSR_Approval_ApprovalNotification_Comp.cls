/**
* @name	PSR_Approval_ApprovalNotification_Comp
* @author   
* @since   July 08, 2017
* @desc	This class helps in Approval emails data
* @history 
*/
public with sharing class PSR_Approval_ApprovalNotification_Comp{
	@TestVisible private Opportunity Opp {get; set;}
	@TestVisible private Offer__c Off {get; set;}
	
	public String OppId {get; set;}
	
	public PSR_Approval_ApprovalNotification_Comp(){}
	
	public Opportunity  getOpp() {
		List<Opportunity> opptyList = [Select Id, Name, Account.Name, L7_Name__c, Country__c, Opportunity_ID__c,
			PSR_Pre_Sales_Risk_Opportunity_Type__c, PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c,  PSR_Description_Justification__c,
			PSR_Reference_Opportunity__r.L7_Name__c,  PSR_Reference_Opportunity__r.Country__c, PSR_Reference_Opportunity__r.Account.Name,
			PSR_Reference_Opportunity__r.StageName,  PSR_Reference_Opportunity__r.Phase_Status__c,  PSR_Reference_Opportunity__r.Amount,
			PSR_Reference_Opportunity__r.Contract_Signing_Entity__c, End_Customer__c, End_Customer__r.Name, Lead_BG__c,
			PSR_Total_Cost_In_Euro__c,  PSR_Total_Sales_Value_In_Euro__c,  PSR_Total_Sales_Value_in_Local_Currency__c,
			PSR_Total_Cost_in_Local_Currency__c,  PSR_Date_PO_Expected__c, PSR_Reference_Opportunity__c,
			PSR_Reference_Opportunity__r.Opportunity_ID__c, PSR_Reference_Opportunity__r.Name,
			PSR_Pre_C5_NPI__c, PSR_Is_Cost_Approved_In_Related_LOA_Opty__c, PSR_Is_Cost_Reflected_In_Latest_Estimate__c,
			Org_L7__c, CurrencyIsoCode From Opportunity  Where Id =: OppId ];
		
		if( opptyList.isEmpty()){
			return null ;
		}else{
			return opptyList[0];
		}	 
	}
	
	public Offer__c getOff() {
		
		List<Opportunity> oppList = [Select Id, PSR_Reference_Opportunity__c From Opportunity  Where Id =: OppId];
		if(oppList.isEmpty())
			return null;
		
		List<Offer__c >	offerList = [Select Id, Offer_ID__c, Offer_Number__c, Name, Offer_Description__c, Price__c, CurrencyIsoCode,
	LoA_Approval_Level__c, LoA_Level_Before_Trigger_Approval__c, Total_Price_At_Approval_Net_Sale__c,
	LoA_Approval_Level_G4__c, Top_5_trigger_1_Name__c, Top_5_trigger_1_Level__c, Top_5_trigger_1_Category__c,
	Top_5_trigger_2_Category__c,  Top_5_trigger_2_Level__c, Top_5_trigger_2_Name__c, Top_5_trigger_3_Category__c,
	Top_5_trigger_3_Level__c, Top_5_trigger_3_Name__c, Top_5_trigger_4_Category__c, Top_5_trigger_4_Level__c,
	Top_5_trigger_4_Name__c, Top_5_trigger_5_Category__c, Top_5_trigger_5_Level__c, Top_5_trigger_5_Name__c,		
	Approval_Scope__c,  Customer_and_Competitive_Situation__c,
	Customer_Offer_Due_Date__c,  LoA_Currency__c, Net_Sales_LoA_Base_Case__c	 
	From Offer__c	Where Opportunity__c =: oppList[0].PSR_Reference_Opportunity__c  And ActiveOffer__c = true ];
		
		if( offerList.isEmpty()){
			return null ;
		}else{
			return offerList[0];
		} 
	}
	
	public List<Apttus_Approval__Approval_Request__c> oppApprovalRequests {
		get{
			if(String.isNotBlank(oppId)){
	oppApprovalRequests =[ SELECT Apttus_Approval__Step_Name__c, Apttus_Approval__Approval_Status__c, Validator_Status__c,
	Apttus_Approval__Date__c, Apttus_Approval__Assigned_To_Name__c, NF_Assignee_Type__c,
	Apttus_Approval__Actual_Approver__c, Apttus_Approval__Approver_Comments__c, NF_Role_Name__c,
	NF_Organization_Level__c, Apttus_Approval__ActualApproverName__c, Apttus_Approval__DelegateApprover__c, NF_BG_Attribute__c
	FROM Apttus_Approval__Approval_Request__c 
			WHERE Apttus_Approval__Related_Opportunity__c = :oppId AND Apttus_Approval__Approval_Status__c != 'Not Submitted' ];		 
			}
			return oppApprovalRequests;
		}
		set;
	}   
	
}