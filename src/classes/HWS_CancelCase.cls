/*****************************************************************
@description:	Apex controller for HWS_CancelCase lightning component
**************************************************/
public without sharing class HWS_CancelCase {
	
	/****************************************
* Name : cancelChildCases
* @description : method to cancel Child Cases
* @param: String casId,String cancelReason,String reasonForCancel
* @return : List of String
*****************************************/
	@auraEnabled
	public static List<String> cancelChildCases(String casId,String cancelReason,String reasonForCancel){
		String platform='console';
		//NOKIASC-32416:Calling HWS_Utilty class generic method for cancel child case.
		return HWS_Utilty.cancelChildCases(casId, cancelReason,reasonForCancel,platform);
	}
}