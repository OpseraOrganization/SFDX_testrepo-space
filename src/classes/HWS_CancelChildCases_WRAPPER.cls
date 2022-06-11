/*****************************************************************
Description: Wrapper class to store Child Case attributes that are being sent to SOO while Cancel from SRM
																													   
DATE			AUTHOR		  CHANGE
12/04/2019	  Vinod T		 Created
*****************************************************************/
Public Class HWS_CancelChildCases_WRAPPER{
	Public String SRMServiceItemID;
	Public String RMA;
	Public String Status;
	
	Public HWS_CancelChildCases_WRAPPER(Case childcase) {
		this.SRMServiceItemID=childcase.id;
		if(childcase.HWS_Contract_Line_Item__r.CH_ServiceType__c=='Spare Part Sales'){
			this.RMA = childcase.HWS_SPS_Order_No__c;   
		}else{
			this.RMA = childcase.HWS_RMA_Number__c;
		}
		this.Status=childcase.Status;
	}
}