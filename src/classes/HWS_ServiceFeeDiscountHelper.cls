/****************************************
* Class Name : HWS_ServiceFeeDiscountHelper
* Created Date: 13 December 2021
* Created By : TCS
* Last Modified by: 
* Last Modified Date: 
* Description : Contains common business logic
* Test Class: HWS_ServiceFeeDiscountHelperTest
*****************************************/

public class HWS_ServiceFeeDiscountHelper {	
	public static void preventUsertoDelete(List < HWS_ServiceFee_Discount__c > oldServiceDiscountList){ 
	   string errorMsg = System.Label.HWS_ServiceFeeDelete;	  
	   string addMsg = errorMsg.replace('**', 'Discount');  
		for (HWS_ServiceFee_Discount__c ser: oldServiceDiscountList) {			
			if (Trigger.isBefore) {							  
					ser.adderror(addMsg);				
			}
		}		
	} 
}