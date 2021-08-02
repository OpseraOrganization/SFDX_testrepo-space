/** 
* About 
* ----- 
* @Description	  : Case Handling Lightning Controller Test Class.
* @Project		  : Case Handling.
* @Modification Log : 
*  Created  : 2020 02 06 – tiago.almeida@nokia.com
* ----- 
**/
@isTest
private class CH_LightningController_Test {
	public static testMethod void test() {
		test.startTest();
		//SystemTime
		CH_LightningController.getCurrentDateTime();
		//Security
		CH_LightningController.permissionToChangeServiceType();
		//Contacts
		try {
			CH_LightningController.getContactName(null);
			CH_LightningController.getCurrentUserContactDetails();
		} catch(Exception e) { }
		try {
			CH_LightningController.contactIsInternalAuthorized(null);
		} catch(Exception e) { }
		//Accounts
		CH_LightningController.getContactAuthorizedLegalEntities(false, null, false);
		CH_LightningController.searchLegalEntities(null, null, null);
		try {
			CH_LightningController.getInternalAccount();
		} catch(Exception e) { } 
		//Assets
		CH_LightningController.getContactAuthorizedAssets(false, null, null, null, null, false);
		CH_LightningController.getAccountRelatedNetworkElementAssets(false, null, null, null);
		try {
			CH_LightningController.doAsset(null, null, false);
		} catch(Exception e) { } 
		try {
			CH_LightningController.getAsset(null);
		} catch(Exception e) { } 
		// Entitlements
		CH_LightningController.getContactAuthorizedEntitlements(false, null, null, null, null, null, false);
		CH_LightningController.displayP20fields(null);
		//Products
		CH_LightningController.searchProducts(null);
		try {
			CH_LightningController.searchProductRelated(null, null, null);
		} catch(Exception e) { }
		//Case
		CH_LightningController.getStandardCaseRecordTypeId();
		CH_LightningController.getVirtualPortalAttendantId();
		try {
			CH_LightningController.doCase(null, null, false);
		} catch(Exception e) { } 
		try {
			CH_LightningController.getCase(null);
		} catch(Exception e) { } 
		//Knowledge__kav
		CH_LightningController.getArticles(false);
		//Location	
		try {
			CH_LightningController.getTimeZone(null, null, null, null, null); 
		} catch(Exception e) { }		
		try {
			CH_LightningController.countryIsMultiTimezone(null);
		} catch(Exception e) { }	 
		//Business Hours
		try {
			CH_LightningController.getBusinessHours(null);
		} catch(Exception e) { }
		try {
			CH_LightningController.postToBHChatterGroup('Test Script');  
		} catch(Exception e) { }	
		test.stopTest();
	}
}