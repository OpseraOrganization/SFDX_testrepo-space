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
public class CH_LightningController {
	
	@AuraEnabled
	public static DateTime getCurrentDateTime(){
		return System.now();
	}
	
	//Security
	
	@AuraEnabled
	public static Boolean permissionToChangeServiceType() {
		return CH_SecurityUtils.checkUserPermissions(UserInfo.getUserId(), 'CH_Agent', new List<String>{'CH_Key_User'}, false);
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
	
	// Entitlements
	
	@AuraEnabled
	public static List<Entitlement> getContactAuthorizedEntitlements(Boolean withoutSharing, String accountId, String assetId, String contactId, Asset netElemAsset, String serviceType, boolean swMaintenance) {
		return CH_EntitlementUtils.getContactAuthorizedEntitlements(withoutSharing, accountId, assetId, contactId, netElemAsset, serviceType, swMaintenance);
	}
		
	@AuraEnabled
	public static Boolean displayP20fields(Id entitlementId){
		return CH_EntitlementUtils.displayP20fields(entitlementId);
	}
	
	   
	//Products
	
	@AuraEnabled
	public static List<Product2> searchProducts(String searchString) {
		return CH_ProductUtils.searchProducts(searchString);
	}
	
	@AuraEnabled
	public static List<sObject> searchProductRelated(String target, String source, String nokiaProductId) {
		return CH_ProductUtils.searchProductRelated(target, source, nokiaProductId);
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
		return CH_CaseUtils.database(operationType, oCase, withoutSharing);
	}
	
	//Knowledge__kav
	
	@AuraEnabled
	public static List<Knowledge__kav> getArticles(Boolean withoutSharing){
		return DML_SObject.doQuery(
			'SELECT Id, ArticleNumber, UrlName, Title, LastModifiedDate, CH_KB_Products__c, Description__c, CH_PurposeRequired__c, CH_InformationForInternalAudiences__c,'
			+ ' CH_QuestionOrProductDescription__c, CH_AnswerOrResolution__c, CH_ProblemDescriptionRequired__c'
			+ ' FROM Knowledge__kav WHERE PublishStatus = "Online" AND ValidationStatus = "External Approved"'
		, withoutSharing);
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
}