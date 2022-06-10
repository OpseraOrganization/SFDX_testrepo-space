/*******************************
Class Name: DS_PortalDashboard
Created by: Accenture
Last modified by: Accenture
Description: This class used for Lightning component
*******************************/
public with sharing class DS_PortalDashboard {
	/******************************
*Method Name: getCurrentUserData
*Description: This Method will get the required data for the logged in user
********************************/
	@AuraEnabled
	public static User getCurrentUserData()
	{   
		try{
			
			return [SELECT Accountid,Contactid,FirstName,Name, LastName from User where id=:UserInfo.getUserId() limit 1] ;
		}catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_PortalDashboard, CSWXGlobalConstant.getCurrentUserData);
							 return NULL;  
							}
	}
	
	/******************************
*Method Name: getDPDashboard
*Description: This Method will get Number of DP based on Upsell Stage andProposal Status
*Parameter:String technology, String useCase
********************************/
	//Analytics_Source__c !=: CSWXGlobalConstant.SourceID_RMP and removed analytic source reference
	@AuraEnabled
	public static Map<String,String> getDPDashboard() {
		
		Integer readyForReviewCount=0;
		Integer ValidatedCount=0;
		Integer RejectedCount=0;
		
		try{
			Map<String,String>  DPDashboardMap = new Map<String,String>();
			for(SWx_Upsell_Proposal__c dpRec : [select id,Upsell_Status__c,Name,Analytics_File_Refer_ID__c,Creation_Date__c,Proposal_Status__c,Proposal_Recommendation_Type__c,Analytics_Source__c from SWx_Upsell_Proposal__c where Account_ID__c =:getCurrentUserData().accountId  and DS_Show_In_Portal__c=true LIMIT : Limits.getLimitQueryRows()- Limits.getQueryRows()]){
				System.debug('dpRec.Proposal_Status__c----->'+dpRec.Proposal_Status__c);
				if(dpRec.Upsell_Status__c == CSWXGlobalConstant.readyForReview ){
					
					readyForReviewCount++;
				}
				if(dpRec.Proposal_Status__c == CSWXGlobalConstant.VALIDATED  || dpRec.Proposal_Status__c == CSWXGlobalConstant.proposalCloseValidate){
					
					ValidatedCount++;
					System.debug('Validated--->'+ValidatedCount);
				}
				if(dpRec.Proposal_Status__c == CSWXGlobalConstant.Approval_stage_Reject || dpRec.Proposal_Status__c == CSWXGlobalConstant.CLOSE_REJECT ){
					
					RejectedCount++;
					System.debug('RejectedCount--->'+RejectedCount);
				}
			} 
			
			
			DPDashboardMap.put(CSWXGlobalConstant.Review,string.valueof(readyForReviewCount));
			DPDashboardMap.put(CSWXGlobalConstant.VALIDATED,string.valueof(ValidatedCount));
			DPDashboardMap.put(CSWXGlobalConstant.Approval_stage_rejected,string.valueof(RejectedCount));
			System.debug('DPDashboardMap--->'+DPDashboardMap);
			return DPDashboardMap;
		}catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_PortalDashboard, CSWXGlobalConstant.getDPDashboard);
							 return NULL;  
							}	
	}
	
	
	
	/******************************
*Method Name: getQuoteDashboard
*Description: This Method will get Number of Quote based on Approval Stage
*Parameter:
********************************/
	@AuraEnabled
	public static Map<String,String> getQuoteDashboard() {
		
		Map<String,String>  QuoteDashboardMap = new Map<String,String>();   
		Integer acceptedCount = 0;
		Integer revisionCount = 0;
		Integer approvedCount = 0;
		Integer rejectedCount = 0;
		
		String AnalyticsSource_CXM = CSWXGlobalConstant.AnalyticsSource;
		String accountID = getCurrentUserData().accountId;
		
		Set<String> Approval_Stage= new Set<String>();
		Approval_stage.add( CSWXGlobalConstant.Approval_stage_accepted); 
		Approval_stage.add( CSWXGlobalConstant.Approval_stage_withdrawn);
		Approval_stage.add( CSWXGlobalConstant.Approval_stage_approved);
		Approval_stage.add( CSWXGlobalConstant.Approval_stage_rejected);
		
		String Revision = CSWXGlobalConstant.revision_status;
		
		//removed Analytics_Source__c = :AnalyticsSource_CXM AND this condition DSI-1252
		try{
			for(Apttus_Proposal__Proposal__c quoteRec : [SELECT Id,Apttus_Proposal__Approval_Stage__c,Apttus_Proposal__Proposal_Name__c,Quote_Stage__c From Apttus_Proposal__Proposal__c where ((Apttus_Proposal__Approval_Stage__c =:Approval_Stage  OR  Quote_Stage__c=:Revision) AND Apttus_Proposal__Account__c =:accountID) LIMIT : Limits.getLimitQueryRows()- Limits.getQueryRows()]){
				
				if(quoteRec.Apttus_Proposal__Approval_Stage__c == CSWXGlobalConstant.Approval_stage_accepted){
					
					acceptedCount++;
				}
				if(quoteRec.Quote_Stage__c ==  CSWXGlobalConstant.revision_status){
					
					revisionCount++;
					
				}
				if(quoteRec.Apttus_Proposal__Approval_Stage__c == CSWXGlobalConstant.Approval_stage_rejected || quoteRec.Apttus_Proposal__Approval_Stage__c== CSWXGlobalConstant.Approval_stage_withdrawn){
					
					RejectedCount++;
					
				}
				if(quoteRec.Apttus_Proposal__Approval_Stage__c == CSWXGlobalConstant.Approval_stage_approved){
					
					approvedCount++;
					
				}
			} 
			
			QuoteDashboardMap.put(CSWXGlobalConstant.Approval_stage_accepted,string.valueof(acceptedCount));
			QuoteDashboardMap.put(CSWXGlobalConstant.revision_status,string.valueof(revisionCount));
			QuoteDashboardMap.put(CSWXGlobalConstant.Approval_stage_approved,string.valueof(approvedCount));
			QuoteDashboardMap.put(CSWXGlobalConstant.Approval_stage_rejected,string.valueof(rejectedCount));
			
			return QuoteDashboardMap;
		}catch(Exception ex){
			ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_PortalDashboard, CSWXGlobalConstant.getQuoteDashboard);
			return NULL;  
		}  
	}
	
	
}