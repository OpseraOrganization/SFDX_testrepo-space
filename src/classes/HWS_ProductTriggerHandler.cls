/****************************************
* Name : HWS_ProductTriggerHandler
* Author : TCS
* Description : This class is to handle before update operation of Product
* ReqNo : 
****************************************/
Public class HWS_ProductTriggerHandler {
	Public static void beforeUpdateOperation(Map<Id, Product2> oldProductMap, List<Product2> newProductList) {
		HWS_ProductTriggerHelper.sourceFieldUpdate(oldProductMap, newProductList);
	}
}