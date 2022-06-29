/****************************************
* Class Name : HWS_ServiHWS_ServiceFeeDiscountHandlerceFeeDiscount
* Created Date: 12 December 2021
* Created By : TCS
* Last Modified by: 
* Last Modified Date: 12 December 2021
* Description : Contains common business logic
* Test Class: HWS_ServiceFeeDiscountHelperTest
*****************************************/
public class HWS_ServiceFeeDiscountHandler {
	public static void beforeDeleteOperation(List<HWS_ServiceFee_Discount__c> oldServiceDiscountList) {	
		HWS_ServiceFeeDiscountHelper.preventUsertoDelete(oldServiceDiscountList); 
	}	
}