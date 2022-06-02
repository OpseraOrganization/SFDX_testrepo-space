/** 
* About 
* ----- 
* @Description	: Case Handling Lightning Controller Test Class.
* @Project	  : Case Handling. 
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
		CH_LightningController.isCommunity();
		CH_LightningController.getPicklistValues(new Case(), 'Type');
		//Accounts
		CH_LightningController.getContactAuthorizedLegalEntities(false, null, false);
		CH_LightningController.searchLegalEntities(null, null, null);
		try {
			CH_LightningController.getInternalAccount();
		} catch(Exception e) { /* Do Nothing */ } 
		//Assets
		CH_LightningController.getContactAuthorizedAssets(false, null, null, null, null, false);
		CH_LightningController.getAccountRelatedNetworkElementAssets(false, null, null, null, null);
		try {
			CH_LightningController.doAsset(null, null, false);
		} catch(Exception e) { /* Do Nothing */ } 
		try {
			CH_LightningController.getAsset(null);
		} catch(Exception e) { /* Do Nothing */ } 
		//Attachments
		try{
			CH_LightningController.getAttachments(null);
		}catch(Exception e) { /* Do Nothing */ }
		try{
			CH_LightningController.markAttachmentsForDelete(null, null);
		}catch(Exception e) { /* Do Nothing */ }
		CH_LightningController.downloadAttachments(null);
		CH_LightningController.updateAttachmentVisibility(null, null, null);
		try {
			CH_LightningController.getUserAttachmentActionsAuthorization(null, false);
		} catch(Exception e) { /* Do Nothing */ } 
		try {
			CH_LightningController.initiateAttachmentsUpload(null, null);
		} catch(Exception e) { /* Do Nothing */ } 
		try {
			CH_LightningController.parseAttachmentResponse(null);
		} catch(Exception e) { /* Do Nothing */ } 
		try {
			CH_LightningController.completeAttachmentUpload(null, null, null, null, null, null, null);
		} catch(Exception e) { /* Do Nothing */ } 
		try {
			CH_LightningController.shareAttachmentWithRND(null, null, null, null, null, null);
		} catch(Exception e) { /* Do Nothing */ } 
		//Business Hours
		try {
			CH_LightningController.getBusinessHours(null);
		} catch(Exception e) { /* Do Nothing */ }
		try {
			CH_LightningController.postToBHChatterGroup('Test Script');  
		} catch(Exception e) { /* Do Nothing */} 
		//Case
		CH_LightningController.getStandardCaseRecordTypeId();
		CH_LightningController.getVirtualPortalAttendantId();
		try {
			CH_LightningController.doCase(null, null, false);
		} catch(Exception e) { /* Do Nothing */ } 
		try {
			CH_LightningController.getCase(null);
		} catch(Exception e) { /* Do Nothing */ } 
		try {
			CH_LightningController.getPortalRoutingCases(null);
		} catch(Exception e) { /* Do Nothing */ } 
		//Case Tag
		try {
			CH_LightningController.getCaseTagDetails(null, null, null, null);  
		} catch(Exception e) { /* Do Nothing */ }   
		try {
			CH_LightningController.getTag(null, null, null, null);  
		} catch(Exception e) { /* Do Nothing */ }
		//Contacts
		try {
			CH_LightningController.getContactName(null);
			CH_LightningController.getCurrentUserContactDetails();
		} catch(Exception e) { /* Do Nothing */ }
		try {
			CH_LightningController.contactIsInternalAuthorized(null);
		} catch(Exception e) { /* Do Nothing */ }
		try {
			CH_LightningController.searchContacts(null, '', '', '', '');
		} catch(Exception e) { /* Do Nothing */ }
		//Contract Line Items
		try {
			CH_LightningController.searchContractLineItem(null, null, '', '', '', '', '', '', '', '');
		} catch(Exception e) { /* Do Nothing */ }
		//Covered Network Element Asset
		try {
			CH_LightningController.getCoveredNetworkElementAssets(null, false);
		} catch(Exception e) { /* Do Nothing */ }
		try {
			CH_LightningController.getCoveredNetworkElementAssetsAvailableForLinking(null);
		} catch(Exception e) { /* Do Nothing */ }
		try {
			CH_LightningController.linkCoveredNetworkElementAssets(null);
		} catch(Exception e) { /* Do Nothing */ }
		try {
			CH_LightningController.unlinkCoveredNetworkElementAssets(null);
		} catch(Exception e) { /* Do Nothing */ }
		//Covered Vendor Contract
		try {
			CH_LightningController.getCoveredVendorContracts('', null);
		} catch(Exception e) { /* Do Nothing */ }
		try {
			CH_LightningController.createCoveredVendorContracts(null, null);
		} catch(Exception e) { /* Do Nothing */ }
		try {
			CH_LightningController.removeCoveredVendorContracts(null);
		} catch(Exception e) { /* Do Nothing */ }
		//Entitlement Contact
		try {
			CH_LightningController.getAuthorizedContacts(null);
		} catch(Exception e) { /* Do Nothing */ }
		try {
			CH_LightningController.doAuthorizedContacts(null, null, null, false);
		} catch(Exception e) { /* Do Nothing */ }
		// Entitlements
		CH_LightningController.getContactAuthorizedEntitlements(false, null, null, null, null, null, false);
		CH_LightningController.displayP20fields(null);
		//FIR Questions
		CH_LightningController.getFIRQuestions();
		try {
			CH_LightningController.submitFIRAnswers(null);
		} catch(Exception e) { /* Do Nothing */ }
		//Location  
		try {
			CH_LightningController.getTimeZone(null, null, null, null, null); 
		} catch(Exception e) { /* Do Nothing */ }	
		try {
			CH_LightningController.countryIsMultiTimezone(null);
		} catch(Exception e) { /* Do Nothing */ }
		//Log Request
		try {
			CH_LightningController.getCaseProductLogType(null); 
		} catch(Exception e) { /* Do Nothing */ }
		//Knowledge__kav
		CH_Settings__c setting = new CH_Settings__c();
		setting.Description__c = 'CH_ArticleLimit_Portal';
		setting.SettingValue__c = '2000';
		setting.Name = 'CH_ArticleLimit_Portal';
		insert setting;
		CH_LightningController.getArticles(false,'te');
		//NDA
		try {
			CH_LightningController.sendCaseInfoToNDA(null, null);
		} catch(Exception e) { /* Do Nothing */ }
		//Products
		CH_LightningController.searchProducts(null);
		try {
			CH_LightningController.searchProductRelated(null, null);
		} catch(Exception e) { /* Do Nothing */ }
		try {
			CH_LightningController.getProductRelated(null, null, null);
		} catch(Exception e) { /* Do Nothing */ }
		//Security
		CH_LightningController.permissionToChangeServiceType();
		CH_LightningController.permissionToChangeCaseTag();
		CH_LightningController.permissionToChangeNetworkElmentAssets();
		try {
			CH_LightningController.permissionToAuthorizedContactsAccess(null);
		} catch(Exception e) { /* Do Nothing */ }
		try {
			CH_LightningController.permissionToChangeVendorContract(null);
		} catch(Exception e) { /* Do Nothing */ }
		//Service Contract
		CH_LightningController.getVendorContractRecordTypeId();
		CH_LightningController.getCareContractRecordTypeId();
		try {
			CH_LightningController.getServiceContract(null);
		} catch(Exception e) { /* Do Nothing */ }
		//Report
		try {
			CH_LightningController.getReportFromDevName('Test');
		} catch(Exception e) { /* Do Nothing */ }
		CH_LightningController.getTimezones();
		CH_LightningController.getCaseInfoString(null);
		//Callout  
		try {
			CH_LightningController.sendlogCollectionRequesttoNDA(null, null,null,null); 
		} catch(Exception e) { /* Do Nothing */ } 
		//Retrieve EmployeeType
		try {
			CH_LightningController.getEmployeeType(); 
		} catch(Exception e) { /* Do Nothing */ }
		//Search for retrofitcontract
		try {
			CH_LightningController.getServiceContractRetrofit(null); 
		} catch(Exception e) { /* Do Nothing */ }
		test.stopTest();
	}
}