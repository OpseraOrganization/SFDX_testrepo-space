/**
*   Class used to check the 14 conditions on Pre Sales Opportunity
*/
public with sharing class NF_PRE_ErrorNotificationCtrl{
	Public static integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();
	public Opportunity currentOpp {get;set;}
	public Boolean isAlreadyNotified {get;set;}
	public Boolean hasNoSubmitForApproval {get;set;}
	public String currentOppId {get;set;}
	
	private static String redirectionChoice{get;set;}
	
	public enum ApprovalsRedirection { APPROVALCONTEXTSUBMIT, MYAPPROVALS , PREVIEWSUBMITAPPROVALS }
	
	/* @desc	the method used to initiate the VF NF_FacilitatorNotification 
	* @return   PageReference: 
	*/
	public PageReference init(){
		//Following line used to check wheter the call is from Preview My approvals or Submit&Preview Approvals or Submit from relatedList
		PageReference errorMessage; 
		
		currentOppId = ApexPages.currentPage().getParameters().get('oppId');
		system.debug('CurrentOppId:'+CurrentOppID);
		currentOpp=[select id,name,
		PSR_LoA_Level__c,
		PSR_Description_Justification__c,
		PSR_Date_PO_Expected__c,
		PSR_Total_Cost_in_Local_Currency__c,
		Lead_BG__c, Lead_BU__c,
		org_l4__c, Org_L3__c,Org_L5__c,
		recordTypeId,PSR_GateClass__c,PSR_Reference_Opportunity__c,
		PSR_Total_Sales_Value_in_Local_Currency__c,
		PSR_Total_Cost_In_Euro__c,
		PSR_Trial_Start_Date__c,
		CurrencyIsoCode,
		PSR_Cost_BU_NI_FN__c , PSR_Cost_BU_NI_IPRTG__c , PSR_Cost_BU_NI_OPTICS__c ,PSR_Cost_BG_NI__c, PSR_Cost_BG_MN__c , PSR_Cost_BG_CNS__c,
		PSR_Trial_Duration__c,
		PSR_SW_R_D_Justification_Explanation__c,
		PSR_Trial_Agreement_Status__c,
		PSR_Pre_Sales_Risk_Opportunity_Type__c,
		PSR_Is_Cost_Approved_In_Related_LOA_Opty__c, 
		PSR_Is_Cost_Reflected_In_Latest_Estimate__c,
		PSR_Is_Rv_Reflected_In_Latest_Estimate__c,
		PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c,
		PSR_is_BOM_BOQ_document_attached__c 
		from Opportunity Where id=:currentOppId];
		
		return errorMessage(currentOpp);
		
	}
	
	public PageReference errorMessage(Opportunity currentOpp ) {
		List<String> missingParam = new List<String>();
		system.debug('CurrentOpp:'+currentOpp);
		
		/*Checking Required fields Start*/
		if(String.IsEmpty(currentOpp.PSR_Description_Justification__c)){
			missingParam.add('Description/Justification');
		}
		
		if(String.IsEmpty(currentOpp.Lead_BG__c)){
			missingParam.add('Cost for any BG/BU');
		}
		//Risk order
		if(GlobalConstants.RISK_ORDER.equals(currentOpp.PSR_Pre_Sales_Risk_Opportunity_Type__c)) {   
			if(currentOpp.PSR_Total_Sales_Value_in_Local_Currency__c<=0 ){   
	missingParam.add('Sales Value for any BG/BU');
			}
			if(currentOpp.PSR_Date_PO_Expected__c==NULL){
	missingParam.add('Date PO Expected / Contract Signed');
			}
		}
		
		//Trial
		if(GlobalConstants.TRIAL.equals(currentOpp.PSR_Pre_Sales_Risk_Opportunity_Type__c)) {	
			if(currentOpp.PSR_Trial_Start_Date__c==NULL){
	missingParam.add('Trial/Demo Start Date');
			}
			if(currentOpp.PSR_Trial_Duration__c==NULL){
	missingParam.add('Trial/Demo Duratuion');
			}
			IF(currentOpp.PSR_Date_PO_Expected__c==NULL){
	missingParam.add('Date PO Expected / Contract Signed');
			}
			if(String.IsEmpty(currentOpp.PSR_Trial_Agreement_Status__c)){
	missingParam.add('Trial Agreement Status');
			}
			if(String.IsEmpty(currentOpp.PSR_Is_Cost_Approved_In_Related_LOA_Opty__c)){
	missingParam.add('Is Cost Approved in Sales Opportunity'); // Label Changed - SF Ticket 00956787
			}
		}
		
		//Demo
		if(GlobalConstants.DEMO.equals(currentOpp.PSR_Pre_Sales_Risk_Opportunity_Type__c)) {	 
			if(currentOpp.PSR_Trial_Start_Date__c==NULL){
	 missingParam.add('Trial/Demo Start Date');
			}
			if(currentOpp.PSR_Trial_Duration__c==NULL){
	missingParam.add('Trial/Demo Duratuion');
			}
		}
		
		//FOC
		if(GlobalConstants.FOC.equals(currentOpp.PSR_Pre_Sales_Risk_Opportunity_Type__c) && String.IsEmpty(currentOpp.PSR_Is_Cost_Approved_In_Related_LOA_Opty__c)) {	
			missingParam.add('Is Cost Approved in Sales Opportunity'); // Label Changed - SF Ticket 00956787
		}
		
		if(currentOpp.PSR_is_BOM_BOQ_document_attached__c == false){
			missingParam.add(GlobalConstants.PRESALES_UPLOAD_FILE_ERROR);

		}   
		/*Checking Required fields End*/  
		
		/*Other Validations start*/ 
		if(missingParam.size() == 0 && (GlobalConstants.LOA_Level.equalsIgnoreCase(currentOpp.PSR_LoA_Level__c)&& !UserInfo.getProfileId().equalsIgnoreCase(Label.System_Admin_Profile_ID) && !UserInfo.getProfileId().equalsIgnoreCase(Label.Nokia_Admin_Profile_Id) && !UserInfo.getProfileId().equalsIgnoreCase(Label.Global_Process_Admin_Profile_Id)))
		{   
			Integer optyTeamMembercount = [SELECT count() FROM OpportunityTeamMember WHERE TeamMemberRole=:GlobalConstants.OFFER_CONTROL AND OpportunityId=:currentOpp.Id AND UserId=:Userinfo.getUserId() Limit : limitRows]; 
			if(optyTeamMembercount==0){
	if(currentOpp.PSR_Pre_Sales_Risk_Opportunity_Type__c<>NULL && currentOpp.PSR_Pre_Sales_Risk_Opportunity_Type__c.equals(GlobalConstants.RISK_ORDER))
		missingParam.add(Label.NF_PSRO_OC_RO);
	if(currentOpp.PSR_Pre_Sales_Risk_Opportunity_Type__c<>NULL && (currentOpp.PSR_Pre_Sales_Risk_Opportunity_Type__c.equals(GlobalConstants.TRIAL) || currentOpp.PSR_Pre_Sales_Risk_Opportunity_Type__c.equals(GlobalConstants.DEMO)))
		missingParam.add(Label.NF_PSRO_OC_TD);
			}	
		}
		/*Other Validations End */
		
		if(missingParam.size()>0){
	 String errorMsg ;
			if(missingParam.size() == 1 && (missingParam[0] == Label.NF_PSRO_OC_RO ||  missingParam[0] == Label.NF_PSRO_OC_TD)){
			errorMsg = missingParam[0];
			}
			else{
			errorMsg = Label.NF_PRE_Required_Filed_Mandatory+String.join(missingParam, ', ');
			}
			isAlreadyNotified = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,errorMsg));
			return null;
		}  
		else 
		{
			PageReference myPAge;
			String existing_LoA = currentopp.PSR_LoA_Level__c;
			List<Opportunity> psroLoACalculated = new List<Opportunity>{currentopp};
			OpportunityTriggerHelper_PreSales.calculatePSROApprovalLevel(psroLoACalculated, new Set<Id>{currentopp.PSR_Reference_Opportunity__c}, null);
			
			String New_Loa_level;			
			if(existing_LoA != psroLoACalculated[0].PSR_LoA_Level__c)
			{
	  update psroLoACalculated;
	  New_Loa_level=psroLoACalculated[0].PSR_LoA_Level__c;			
			}
			myPAge= Page.APTSCU_PreviewApproval;
			myPAge.getParameters().put('sObjectId', currentOpp.Id);
			mypage.getparameters().put('PSRLoAlevel',New_Loa_level);	 
			
			System.debug('NF_PRE_Error'+currentOpp.Id); 
			return myPAge;  
		}  
		
	}   

	public PageReference cancel() {
		return new PageReference('/'+currentOppId);
	}

}