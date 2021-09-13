public without sharing class HWS_Constants {
	
	public static final String LEGAL_ENTITY = 'Legal_Entity'; 
	//Adding EntitlementStatus 
	public static final String ESIWVM='Entitled (In Warranty Verified Manually)';
	public static final String ESOOWVM='Entitled (Out of Warranty Verified Manually)';
	public static final String ESMOFOC='Management Override - Free of Charge';
	public static final String ESMOB='Management Override - Billable';
	public static final String ESQAPR='Quotation Accepted and PO Received';
	public static final String QR='Quotation Rejected';
	public static final String QD='Quote Declined';
	public static final String QExp='Quote Expired';
	
	 //Added for 34951
	public static final string NA_QuotRequired ='Not Applicable - Quotation Required';
	//Validation Error
	public static final String EntitlementStatusValidationError ='You cannot choose this value for this Contract';
	public static final String caseStatusDraft = 'Draft';
	public static final String caseStatusOnHold = 'On Hold';
	public static final String caseStatusCancel = 'Cancelled';
	
	
	//UseCase Conditions :
	public static final String UC1 ='HWS_W_AND_Q_UC_1';
	public static final String UC2A ='HWS_W_AND_Q_UC_2A';
	public static final String UC67 ='HWS_W_AND_Q_UC_6_7';
	public static final String UC8='HWS_W_AND_Q_UC_8';
	public static final String UC9='HWS_W_AND_Q_UC_9';
	public static final String UC3='HWS_W_AND_Q_UC_3';
	public static final String UC2B='HWS_W_AND_Q_UC_2B';
	public static final String UC4='HWS_W_AND_Q_UC_4';
	public static final String UC5='HWS_W_AND_Q_UC_5';
	
	 //Warranty Status
	public static final String WS_InWarranty ='In Warranty';
	public static final String WS_UKWarranty ='Warranty Unknown';
	public static final String WS_FailDWarranty ='Failed to determine warranty';
	public static final string OUT_OF_WARRANTY ='Out of Warranty';
	
	//Entitlement Status
	public static final string Service_Declined = 'Service Declined';
	public static final string Entitled_AV ='Entitled (Automated Verification)';
	public static final string PendingQuotCreation ='Pending Quotation Creation';
	public static final string PendingCAOQ ='Pending Customer Acceptance of Quote';
	public static final string PendingCAPMR ='Pending CAPM Review';
	public static final string PendingWarrantyVerification ='Pending Warranty Verification';
	public static final string EE_OOWD ='Out of Warranty Dispute';
	
	
	// Entitlement Exception
	public static final string IW_QuotRequired ='In Warranty - Quotation Required';
	public static final string OOW_QuotRequired ='Out of Warranty - Quotation Required';
	
	
	public static final String CUSTOMER = 'Customer';
	public static final String HWS_ADVANCE_EXCHANGE_IN_DAYS = 'HWS_Advance_Exchange_In_Days';
	public static final String HWS_ADVANCE_EXCHANGE_IN_HOURS = 'HWS_Advance_Exchange_In_Hours';
	public static final String HWS_PARENT_CASE = 'HWS_Parent_Case';
	public static final String SALES_PRODUCT = 'NokiaCPQ_Sales_Product';
	public static final String HWS_CHILD_CASE_READ_ONLY = 'HWS_Child_Case_Read_Only';
	public static final String HWS_PARENT_CASE_READ_ONLY = 'HWS_Parent_Case_Ready_Only';
	public static final String HWS_SPS_PART_SALES = 'HWS_Spare_Part_Sales'; 
	public static final String HWS_RETURN_FOR_REPAIR ='HWS_Return_For_Repair';
	public static final String HWS_SPS_PART_SALES_READ_ONLY = 'HWS_Spare_Part_Sales_Read_only';
	public static final String LOGISTIC_ACCOUNT_EXISTING = 'Logistic_Account';
	public static final String HWS_ESCALATION_CASE = 'HWS_Case_Escalation';
	public static final String PUMA1_SOURCE = 'PUMA1';
	public static final String PUMA2_SOURCE = 'PUMA2';
	
	public static final string Entitled ='Entitled (Manually Verified)';
	public static final string Management_Override ='Management Override';
	public static final string Not_Applicable ='Not Applicable';
	
	public static final string Warranty_Status ='Warranty Status Check Failed to Complete';
	public static final string None ='--None--';
	public static final String AED = 'Advanced Exchange in Days';
	public static final String AEH = 'Advanced Exchange in Hours';
	public static final String IR = 'Identical Repair';
	public static final String RFR = 'Return for Repair or Replacement';
	public static final String SPS = 'Spare Part Sales';
	public static final String	REQUESTED_BY_CUSTOMER = 'Requested by customer';
	public static final String	On_Hold = 'On Hold';
	public static final String	USATT = 'US_AT&T';
	public static final String	Test123 = 'Test data123';
	public static final String	Permanent_Address = 'Permanent Address';
	public static final String PARTIALLY_SHIPPED ='Partially Shipped';
	public static final String REQUEST_TO_CANCEL ='Request to Cancel';
	public static final String RETRIED_TO_CANCEL ='Retried To Cancel';
	public static final String	EDP_Login = 'callout:EDP_Login';
	public static final String	content = 'Content-Type';
	public static final String	json = 'application/json'; 
	public static final String CodeNumber = '833-049122_00';
	public static final String PENDING_REFERRAL_INSTRUCTION = 'Pending Referral Instruction';
	public static final string NoTXPOWER='No TX Power';
	public static final string REBOOT_MODULE = 'Reboot Module';
	public static final string false_InWarranty = 'false-In Warranty';
	public static final string false_NotApplicable = 'false-Not Applicable';
	public static final string false_OutofWarranty = 'false-Out of Warranty';
	public static final string false_WarrantyUnknown = 'false-Warranty Unknown';
	public static final string true_OutofWarranty = 'true-Out of Warranty';
	public static final string true_InWarranty = 'true-In Warranty';
	public static final string EDP_Release_Stage = 'EDP Release Stage';
	//34587
	public static final string HWS_WCheck_UnKnowns = 'Warranty Unknown';
	public static final string WCUnknowns ='Warranty Unknown';
	//34829
	public static final string IWPOMissing ='In Warranty PO Missing';
	public static final string OWPOMissing ='Out of Warranty PO Missing';
	public static final string UWStatus ='Warranty Unknown';
	public static final string WStatusCheckFailed ='Warranty Status Check Failed';
	//testmethod for code coverage
	public static void hwsConstantsmethod(){
		
	}
}