/****************************************
* Class Name : HWS_ServiceFeeTriggerHelper
* Created Date: 11 November 2021
* Created By : TCS
* Last Modified by: Akhil Ramisetty
* Last Modified Date: 11 November 2021
* Description : Contains common business logic
* Test Class: HWS_ServiceFeeTriggerHelperTest
*****************************************/
public class HWS_ServiceFeeTriggerHelper {
	
	public static void preventUsertoDelete(List < HWS_ServiceFeeDetails__c > oldServiceFeesList){   
	   string warningMsg = System.Label.HWS_ServiceFeeDelete;	  
	   string addMsg =warningMsg.replace('**', 'Fee');		
		for (HWS_ServiceFeeDetails__c ser: oldServiceFeesList) {			
			if (Trigger.isBefore) {		 
					ser.adderror(addMsg);
			}
		}		
	}
}