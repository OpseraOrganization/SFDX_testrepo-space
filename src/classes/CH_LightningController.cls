/** 
* About 
* ----- 
* @Description	  : Case Handling Lightning Controller Method Routing.
* @TestClass		: CH_LightningController_Test.
* @Project		  : Case Handling.
* @Modification Log : 
*  Created  : 2019 11 18 – tiago.almeida@nokia.com
* ----- 
**/
public without sharing class CH_LightningController {
	private static final string NOKIA_ADMINISTRATOR = 'Nokia Admin Profile';
	private static final string SYSTEM_ADMINISTRATOR = 'System Administrator';
	
	
	@AuraEnabled
	public static DateTime getCurrentDateTime(){
		return System.now();
	}
	
	//Accounts
	
	@AuraEnabled
	public static Account getInternalAccount() {
		return CH_AccountUtils.getInternalAccount();
	}
	
	@AuraEnabled
	public static List<Account> getContactAuthorizedLegalEntities(Boolean withoutSharing, String contactId, boolean swMaintenance) {
		return CH_AccountUtils.getContactAuthorizedLegalEntities(withoutSharing, contactId, swMaintenance);
	}
	
	@AuraEnabled
	public static List<Account> searchLegalEntities(String searchString, String contactId, String serviceType) {
		return CH_AccountUtils.searchLegalEntities(searchString, contactId, serviceType);
	}
	
	//Assets
	
	@AuraEnabled
	public static List<Asset> getContactAuthorizedAssets(Boolean withoutSharing, String accountId, String contactId, Asset netElemAsset, String serviceType, boolean swMaintenance) {
		return CH_AssetUtils.getContactAuthorizedAssets(withoutSharing, accountId, contactId, netElemAsset, serviceType, swMaintenance);
	}
	
	@AuraEnabled
	public static List<Asset> getAccountRelatedNetworkElementAssets(Boolean withoutSharing, String accountId, Asset asset, Entitlement entitlement) {
		return CH_AssetUtils.getAccountRelatedNetworkElementAssets(withoutSharing, accountId, asset, entitlement);
	}
	
	@AuraEnabled
	public static Asset getAsset(Id assetId) {
		return CH_AssetUtils.getAsset(assetId);
	}
	
	@AuraEnabled
	public static Id doAsset(String operationType, Asset oAsset, Boolean withoutSharing) {
		return CH_AssetUtils.database(operationType, oAsset, withoutSharing);
	}
	
	//Business Hours
	
	@AuraEnabled
	public static BusinessHours getBusinessHours(String businessHourName) {
		List<BusinessHours> oBusinessHoursList = DML_SObject.doQuery(
			'SELECT Id, Name, IsDefault FROM BusinessHours ' + 
			'WHERE IsActive = true AND Name = "' + businessHourName + '" '
		);
		if(oBusinessHoursList.isEmpty() || oBusinessHoursList.size() != 1) {
			postToBHChatterGroup('Failed to identify a singe Business Hours with the name : \'' + businessHourName + '\'');
			return null;
		}
		return oBusinessHoursList.get(0);
	}
	
	//Case
	
	@AuraEnabled
	public static Id getStandardCaseRecordTypeId() {
		return CH_CaseUtils.getStandardCaseRecordTypeId();
	}
	
	@AuraEnabled
	public static Id getVirtualPortalAttendantId(){
		return CH_CaseUtils.getVirtualPortalAttendantId();
	}
	
	@AuraEnabled
	public static Case getCase(Id caseId) {
		return CH_CaseUtils.getCase(caseId);
	}
	
	@AuraEnabled
	public static Id doCase(String operationType, Case oCase, Boolean withoutSharing) {
		system.debug('doCase --');
		return CH_CaseUtils.database(operationType, oCase, withoutSharing);
	}
	
	//Case Tag
	
	@AuraEnabled
	public static List<String> getCaseTagDetails(String field, String productId, String issueType, String issueDetails) {
		return CH_CaseTagUtils.getTagDetails(field, productId, issueType, issueDetails);
	}
	
	@AuraEnabled
	public static CH_CaseTag__c getTag(String productId, String issueType, String issueDetails, String additionalDetails) {
		return CH_CaseTagUtils.getTag(productId, issueType, issueDetails, additionalDetails);
	}
	
	//Chatter Groups
	
	@AuraEnabled
	public static void postToBHChatterGroup(String post) {
		try {
			List<CollaborationGroup> oCollaborationGroupList = DML_SObject.doQuery('SELECT Id FROM CollaborationGroup WHERE Name = "Error - BH Conversion" LIMIT 1', true);
			DML_SObject.doInsert(new FeedItem(
				ParentId = oCollaborationGroupList.get(0).Id,
				Body = post
			), true, true);
		} catch(Exception e) { 
			System.debug(e.getMessage());
			System.debug('Error while Posting to Chatter Groups'); 
		}
	}
	
	//Contacts
	
	@AuraEnabled
	public static String getContactName(Id contactId) {
		return CH_ContactUtils.getContactName(contactId);
	}
	
	@AuraEnabled
	public static Contact getCurrentUserContactDetails() {
		return CH_ContactUtils.getCurrentUserContactDetails();
	}
	
	@AuraEnabled
	public static Boolean contactIsInternalAuthorized(Id contactId) {
		return CH_ContactUtils.contactIsInternalAuthorized(contactId);
	}
	
	@AuraEnabled
	public static List<SObject> searchContacts(Id oContractId, String contactGlobalSearch, String contactId, String email, String accountName) {
		return CH_ContactUtils.searchContacts(oContractId, contactGlobalSearch, contactId, email, accountName);
	}
	
	//Contract Line Items
	
	@AuraEnabled
	public static List<ContractLineItem> searchContractLineItem(Id oVendorContractId, Id oAccountId, String sServiceAgreement, String sCaresLineItem, String sCDBNumber, String sContractNumber, String sLineItemNumber, String sProductName, String sStatus, String sExternalStatus) {
		return CH_ContractLineItemUtils.searchCLI(oVendorContractId, oAccountId, sServiceAgreement, sCaresLineItem, sCDBNumber, sContractNumber, sLineItemNumber, sProductName, sStatus, sExternalStatus);
	}
	
	//Covered Network Element Asset
	
	@AuraEnabled
	public static List<CH_CoveredNetworkElementAsset__c> getCoveredNetworkElementAssets(Id sObjectId, Boolean active) {
		return CH_CoveredNetworkElementAssetUtils.get(sObjectId, active);
	}
	
	@AuraEnabled
	public static List<CH_CoveredNetworkElementAsset__c> getCoveredNetworkElementAssetsAvailableForLinking(Id sObjectId) {
		return CH_CoveredNetworkElementAssetUtils.getAvailableForLinking(sObjectId);
	}
	
	@AuraEnabled
	public static boolean linkCoveredNetworkElementAssets(List<CH_CoveredNetworkElementAsset__c> oCoveredNetworkElementAssetList) {
		return CH_CoveredNetworkElementAssetUtils.link(oCoveredNetworkElementAssetList);
	}
	
	@AuraEnabled
	public static boolean unlinkCoveredNetworkElementAssets(List<CH_CoveredNetworkElementAsset__c> oCoveredNetworkElementAssetList) {
		return CH_CoveredNetworkElementAssetUtils.unlink(oCoveredNetworkElementAssetList);
	}
	
	//Covered Vendor Contract
	
	@AuraEnabled
	public static List<CH_CoveredVendorContract__c> getCoveredVendorContracts(String sObjectType, Id sObjectId) {
		return CH_CoveredVendorContractUtils.get(sObjectType, sObjectId);
	}
	
	@AuraEnabled
	public static String createCoveredVendorContracts(Id oVendorContractId, List<String> oContractLineItemIdList) {
		return CH_CoveredVendorContractUtils.create(oVendorContractId, oContractLineItemIdList);
	}
	
	@AuraEnabled
	public static Boolean removeCoveredVendorContracts(Id sObjectId) {
		return CH_CoveredVendorContractUtils.remove(sObjectId);
	}
	
	//Entitlement Contact
	
	@AuraEnabled
	public static List<SObject> getAuthorizedContacts(Id recordId) {
		return CH_EntitlementContactUtils.getAuthorizedContacts(recordId);
	}
	
	@AuraEnabled
	public static Id doAuthorizedContacts(String operationType, EntitlementContact oEntitlementContact, Id oServiceContractId, Boolean withoutSharing) {
		try {
			return CH_EntitlementContactUtils.database(operationType, oEntitlementContact, oServiceContractId, withoutSharing);
		} catch (Exception e) { 
			throw new AuraHandledException(e.getMessage());
		}
	}
	
	//Entitlements
	
	@AuraEnabled
	public static List<Entitlement> getContactAuthorizedEntitlements(Boolean withoutSharing, String accountId, String assetId, String contactId, Asset netElemAsset, String serviceType, boolean swMaintenance) {
		return CH_EntitlementUtils.getContactAuthorizedEntitlements(withoutSharing, accountId, assetId, contactId, netElemAsset, serviceType, swMaintenance);
	}
	
	@AuraEnabled
	public static Boolean displayP20fields(Id entitlementId){
		return CH_EntitlementUtils.displayP20fields(entitlementId);
	}
	
	//FIR Questions
	
	@AuraEnabled
	public static List<CH_FIRQuestion__c> getFIRQuestions() {
		return CH_FIRUtils.getFIRQuestions();
	}
	
	@AuraEnabled
	public static void submitFIRAnswers(List<CH_FIRAnswer__c> oFIRAnswers) {
		CH_FIRUtils.submitFIRAnswers(oFIRAnswers);
	}
	
	//Location
	
	@AuraEnabled
	public static Boolean countryIsMultiTimezone(String countryName) {
		return CH_LocationUtils.countryIsMultiTimezone(countryName);
	}
	
	@AuraEnabled
	public static Map<String, Object> getTimeZone(String address, String city, String postalCode, String state, String country) {
		Map<String, Object> result = CH_LocationUtils.getCoordinates(address, city, postalCode, state, country);
		Map<String, Object> coordinates = (Map<String, Object>) ((Map<String, Object>) result.get('geometry')).get('location');
		result.put('lat', coordinates.get('lat'));
		result.put('lng', coordinates.get('lng'));
		result.put('timezone', CH_LocationUtils.getTimeZone(coordinates));
		return result;
	}
	
	//Knowledge__kav
	//NOKIASC-33498-Get Article data using SOSL
	@AuraEnabled
	public static List < List < sObject >>  getArticles(Boolean withoutSharing,String searchText){
		final String publishStatus = 'Online';
		final String validationStatus = 'External Approved';
		CH_Settings__c articleLimitSettings = CH_Settings__c.getValues('CH_ArticleLimit_Portal');
		final Integer articleLimit= Integer.valueOf(articleLimitSettings.SettingValue__c);
	   
		String soslQuery ='FIND \'' + searchText + '\' IN ALL FIELDS returning Knowledge__kav ';
		soslQuery = soslQuery +' (Id, ArticleNumber, UrlName, Title, LastModifiedDate, CH_KB_Products__c, Description__c, CH_PurposeRequired__c,';
		soslQuery = soslQuery +' CH_InformationForInternalAudiences__c,CH_QuestionOrProductDescription__c, CH_AnswerOrResolution__c, CH_ProblemDescriptionRequired__c ';
		soslQuery = soslQuery +' WHERE ValidationStatus =:validationStatus AND PublishStatus = :publishStatus ORDER BY LastModifiedDate DESC ) LIMIT:articleLimit';
		List < List < sObject >> sResults = search.query(soslQuery);
		return sResults;	  
	}
	
	//Products
	
	@AuraEnabled
	public static List<Product2> searchProducts(String searchString) {
		return CH_ProductUtils.searchProducts(searchString);
	}
	
	@AuraEnabled
	public static List<sObject> searchProductRelated(String target, Map<String,String> source) {
		return CH_ProductUtils.searchProductRelated(target, source);
	}
	
	//Security
	
	@AuraEnabled
	public static Boolean permissionToChangeServiceType() {
		return CH_SecurityUtils.checkUserPermissions(UserInfo.getUserId(), new List<String>{'CH_Agent'}, new List<String>{'CH_Key_User'}, false);
	}
	
	@AuraEnabled
	public static Boolean permissionToChangeCaseTag() {
		return CH_SecurityUtils.checkUserPermissions(
			UserInfo.getUserId(),
			new List<String>{'CH_Case Handler',NOKIA_ADMINISTRATOR, SYSTEM_ADMINISTRATOR},
			new List<String>{'CH_CaseHandler', 'CH_3rdParty'}, false
		);
	}
	
	@AuraEnabled
	public static Boolean permissionToAuthorizedContactsAccess(Id recordId) {
		Boolean result = CH_SecurityUtils.checkUserPermissions(
			UserInfo.getUserId(),
			new List<String>{NOKIA_ADMINISTRATOR, SYSTEM_ADMINISTRATOR},
			new List<String>(Label.CH_AuthorizedContactsAccess.replaceAll('\\s','').split(',')), false
		);
		if(!result) {
			List<ServiceContract> oServiceContractList = DML_SObject.doQuery('SELECT Id FROM ServiceContract WHERE Id = "' + recordId + '" AND ownerId = "' + UserInfo.getUserId() + '"  LIMIT 1');
			result = !oServiceContractList.isEmpty() && CH_SecurityUtils.checkUserPermissions(UserInfo.getUserId(), new List<String>{}, new List<String>{'CH_CustomerCareManager'}, false);
		}
		return result;
	}
	
	@AuraEnabled
	public static Boolean permissionToChangeNetworkElmentAssets() {
		return CH_SecurityUtils.checkUserPermissions(
			UserInfo.getUserId(),
			new List<String>{NOKIA_ADMINISTRATOR, SYSTEM_ADMINISTRATOR},
			new List<String>{'CH_NEAssetAdmin'}, false
		);
	}
	
	@AuraEnabled
	public static Boolean permissionToChangeVendorContract(String recordId) {
		Boolean hasAccess = CH_SecurityUtils.checkUserPermissions(
			UserInfo.getUserId(),
			new List<String>{NOKIA_ADMINISTRATOR, SYSTEM_ADMINISTRATOR},
			new List<String>{'CARE_DVT_Admin', 'CH_CustomerCareManager'}, false
		);
		if(!hasAccess){
			List<ServiceContract> oServiceContractList = DML_SObject.doQuery('SELECT Id FROM ServiceContract WHERE Id = "' + recordId + '" AND ownerId = "' + UserInfo.getUserId() + '"  LIMIT 1');
			hasAccess = !oServiceContractList.isEmpty();
		}
		return hasAccess;
	}
	
	//Service Contracts
	
	@AuraEnabled
	public static Id getVendorContractRecordTypeId() {
		return Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_VendorContract').getRecordTypeId();
	}
	
	@AuraEnabled
	public static Id getCareContractRecordTypeId() {
		return Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
	}
	
	@AuraEnabled
	public static ServiceContract getServiceContract(Id serviceContractId) {
		List<ServiceContract> oServiceContractList = DML_SObject.doQuery('SELECT Id, Name, ContractNumber FROM ServiceContract WHERE Id = "' + serviceContractId + '" LIMIT 1');
		return !oServiceContractList.isEmpty()?oServiceContractList.get(0):null;
	}
	
	//Reports
	
	@AuraEnabled
	public static Report getReportFromDevName(String devName) {
		List<Report> oReportList = DML_SObject.doQuery('SELECT Id FROM Report WHERE DeveloperName = "' + devName + '" AND FolderName = "CH_CaseHandlingReports" LIMIT 1');
		return !oReportList.isEmpty()?oReportList.get(0):null;
	}
	
	//Changes added for NOKIASC-32422
	@AuraEnabled
	public static void getPortalRoutingCases(Id caseId) {
		CH_Portal_Case_TriggerHandler.assignOwner(new Set<Id>{caseId});
	}
}