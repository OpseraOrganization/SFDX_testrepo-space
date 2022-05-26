/***************************************
* Class Name : HWS_RetrofitAccountTrigger 
* Created Date: 29 June 2021
* Description : Handler class for HWS_RetrofitAccountTrigger
*****************************************/
public without sharing class HWS_RetrofitAccountHandler {
	/***************************************
	* Method Name : handleBeforeInsert 
	* Description : Handles before Insert Opertions
	*****************************************/
	public static void handleBeforeInsert(Map<Id,HWS_RetrofitAccount__c> oldMap,List<HWS_RetrofitAccount__c> newList) {
		HWS_RetrofitAccountHelper.checkDuplicateAccountServiceContract(oldMap,newList);
		HWS_RetrofitAccountHelper.updateShipToCountry(newList);
	}
	/***************************************
	* Method Name : handleBeforeInsert 
	* Description : Handles before Update Opertions
	*****************************************/
	public static void handleBeforeUpdate(Map<Id,HWS_RetrofitAccount__c> oldMap, List<HWS_RetrofitAccount__c> newList) {
		HWS_RetrofitAccountHelper.checkDuplicateAccountServiceContract(oldMap,newList);
		HWS_RetrofitAccountHelper.updateShipToCountry(newList);
	}
}