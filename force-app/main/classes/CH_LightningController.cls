/** 
* About 
* ----- 
* @Description	: Case Handling Lightning Controller Method Routing.
* @TestClass	: CH_LightningController_Test.
* @Project	  : Case Handling.
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
	
	@AuraEnabled
	public static Boolean isCommunity(){
		return Site.getSiteId() != null;
	}
	
	@AuraEnabled
	public static List<String> getPicklistValues(SObject sfObject, String field) {
		List<String> result = new List<String>();
		Map<String, Schema.SObjectField> fieldMap = sfObject.getSObjectType().getDescribe().fields.getMap();
		if(fieldMap.containsKey(field)) {
			List<Schema.PicklistEntry> picklistEntries = fieldMap.get(field).getDescribe().getPickListValues();
			for (Schema.PicklistEntry picklistEntry : picklistEntries) {
				result.add(picklistEntry.getValue());
			}
		}
		return result;
	}
	
	//R&D Interaction
	@AuraEnabled
	public static String getRNDInterface(Id rndId) {
		List<CH_Problem_RnD_Reference__c> oRNDList = DML_SObject.doQuery('SELECT Id, Name, CH_RnD_Interface__c FROM CH_Problem_RnD_Reference__c WHERE Id = "' + rndId + '" LIMIT 1');
		return (oRNDList.get(0) != null ? oRNDList.get(0).CH_RnD_Interface__c : 'RnD record not found');
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
	public static List<Asset> getAccountRelatedNetworkElementAssets(Boolean withoutSharing, String accountId, Asset asset, Entitlement entitlement, Product2 product) {
		return CH_AssetUtils.getAccountRelatedNetworkElementAssets(withoutSharing, accountId, asset, entitlement, product);
	}
	
	@AuraEnabled
	public static Asset getAsset(Id assetId) {
		return CH_AssetUtils.getAsset(assetId);
	}
	
	@AuraEnabled
	public static Id doAsset(String operationType, Asset oAsset, Boolean withoutSharing) {
		return CH_AssetUtils.database(operationType, oAsset, withoutSharing);
	}
	
	//Attachments
	
	@AuraEnabled
	public static List<CH_Attachment__c> getAttachments(Id caseId) {
		return CH_AttachmentUtils.getRelated(caseId);
	}
	
	@AuraEnabled
	public static void markAttachmentsForDelete(Id caseId, List<CH_Attachment__c> oAttachmentList) {
		CH_AttachmentUtils.markForDelete(caseId, oAttachmentList);
	}
	
	@AuraEnabled
	public static Boolean updateAttachmentVisibility(List<CH_Attachment__c> oAttachmentList, String visibilityType, Boolean visibilityValue) {
		return CH_AttachmentUtils.updateVisibility(oAttachmentList, visibilityType, visibilityValue);
	}
	
	@AuraEnabled
	public static Map<String, String> initiateAttachmentsUpload(Id caseId, Map<String, Object> file) {
		return CH_AttachmentUtils.initiateUpload(caseId, file);
	}
	
	@AuraEnabled
	public static Map<String, String> parseAttachmentResponse(String response) {
		return CH_AttachmentUtils.parseResponse(response);
	}
	
	@AuraEnabled
	public static String completeAttachmentUpload(Id caseId, Map<String, Object> file, Map<String, String> initialMap, Map<String, String> partToETagMap, String uploadId, String s3KeyNameInUTF8, Boolean isFromEmail) {
		return CH_AttachmentUtils.completeUpload(caseId, file, initialMap, partToETagMap, uploadId, s3KeyNameInUTF8, isFromEmail);
	}
	
	@AuraEnabled
	public static List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper> downloadAttachments(List<CH_Attachment__c> oAttachmentList) {
		return CH_AttachmentUtils.download(oAttachmentList);
	}
	
	@AuraEnabled
	public static Map<String, Object> getUserAttachmentActionsAuthorization(Id caseId, Boolean forUpload) {
		return CH_AttachmentUtils.getUserActionsAuthorization(caseId, forUpload);
	}
	
	@AuraEnabled
	public static String shareAttachmentWithRND(Id caseId, String interfaceName, String subject, String combinedDescription, String comments, List<CH_Attachment__c> oAttachmentList) {
		return CH_AttachmentUtils.shareWithRND(caseId, interfaceName, subject, combinedDescription, comments, oAttachmentList);
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
		if(oCase.AccountId!=null){ //NOKIASC-38892
			Account ac=[Select id,AccountNumber from Account where Id=:oCase.AccountId];
			Boolean IsMegafoneAcc = getInterfaceMappingTableForLegalEntity(ac.AccountNumber);
			//getInterfaceMappingTableForLegalEntity(oCase.A)
			if(IsMegafoneAcc && oCase.Severity__c== 'Critical' && (oCase.Origin == 'Phone' || oCase.Origin == 'Email')){
				oCase.Origin = 'S2S';
				oCase.CH_CaseOriginSystem__c='megafon';
			}
			System.debug('Case data is oCase.CH_CaseOriginSystem__c'+oCase.CH_CaseOriginSystem__c+'oCase.Origin '+oCase.Origin);
		}
		return CH_CaseUtils.database(operationType, oCase, withoutSharing);
	}
	
	@AuraEnabled
	public static Boolean getInterfaceMappingTableForLegalEntity (String accountNumber) {
		List<CH_Case_PA_InterfaceMapping__c> oInterfaceMappingList = DML_SObject.doQuery(
			'SELECT AccountOut__c, CaseOriginSystem__c FROM CH_Case_PA_InterfaceMapping__c ' +
			'WHERE CaseOriginSystem__c = "megafon" AND AccountOut__c = "' + accountNumber + '" '
		);
		if(!oInterfaceMappingList.isEmpty()) {
			return true;
		}
		return false;
	}
	
	@AuraEnabled
	public static Boolean isCaseOwnerOrTeamMember(Id caseId, Id userId) {
		return CH_CaseUtils.isOwnerOrTeamMember(caseId, userId);
	}
	
	/****************************************
* Name : getCaseDeatils
* Description : to get and return case details
* written on 14th Jun 2021
* By Satya Pagadala
* NOKIASC-36145
*****************************************/
	@AuraEnabled
	public static String getCaseInfoString(Id caseId) {
		Map<String, Object> obj = new Map<String, Object>();
		obj.put('baseUrl',system.URL.getSalesforceBaseUrl().toExternalForm());
		obj.put('case',caseId !=null?CH_CaseUtils.getCaseData(caseId):null);
		return JSON.Serialize(obj);
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
	
	//Retrieve service contract with the given Id and return retrofit contract or not
	//NOKIASC - 37083
	@AuraEnabled
	public static boolean getServiceContractRetrofit(Id oContractId) {
		ServiceContract sC = [select Id, HWS_Retrofit_Type__c from ServiceContract where Id =:oContractId];
		if(sC != null && String.isNotBlank(sC.HWS_Retrofit_Type__c)){
			return true;
		}
		return false;
	}
	//Return employee type
	//NOKIASC - 37083  
	@AuraEnabled
	public static List<String> getEmployeeType() {
		List<HWS_GenericSettings__c> genericSetting = [select HWS_Field1__c  from HWS_GenericSettings__c where Name = 'HWS_AllowAuthContactAddition'];
		String empType = genericSetting.get(0).HWS_Field1__c;
		return empType.split(',');
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
	
	//Log Collection
	
	@AuraEnabled
	public static List<CH_ProductLogType__c> getCaseProductLogType(String caseId) {
		Case oCase = CH_CaseUtils.getCase(caseId);
		List<CH_AutomatedLogCollection__c> oAutomatedLogCollectionList = [SELECT Id, CH_AccountName__c, CH_AccountName__r.Id, CH_Product__c, CH_Product__r.Id FROM CH_AutomatedLogCollection__c WHERE CH_Status__c = TRUE AND CH_AccountName__r.Id = :oCase.AccountId AND CH_Product__r.Id = :oCase.ProductId];
		if(!oAutomatedLogCollectionList.isEmpty()){   
			return [SELECT CH_Product__c, CH_ProductFamily__c, CH_LogType__c, CH_AutoLogCollection__c, CH_Status__c, CH_Category__c, CH_CollectorLogType__c,Id
					FROM CH_ProductLogType__c WHERE CH_Product__r.Id = :oCase.ProductId AND CH_Status__c = TRUE AND CH_AutoLogCollection__c = FALSE
				   ];
		}
		else { return null; }
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
	
	//NDA
	
	@AuraEnabled
	public static void sendCaseInfoToNDA(Id caseId, String ndaKey) {
		//Chatter Post
		String link = System.Label.NDAURL;
		link = link.replace(link.split('^https?://[^/]+')[1], '');
		String ndaConversation = link + '/conversation/' + ndaKey;
		DML_SObject.doInsert(new FeedItem(
			ParentId = caseId,
			Type = 'TextPost',
			Body = '<p>Ticket Created with NDA (Nokia Digital Assistant) Support.</p><p> </p>' +
			'<p>You can see the conversation history with the previous investigation by <a href="' + ndaConversation + '" alt="' + ndaConversation + '" target="_blank">clicking here</a>.</p><p> </p>'+
			'<p>Do you know that you can use NDA to help you with your investigation? <a href="' + link + '" alt="' + link + '" target="_blank">Try it</a>!</p>',
			IsRichText = true,
			Visibility = 'AllUsers'
		), true, true);
		//NDA API Call
		User oUser = [SELECT Id, FederationIdentifier, Nokia_ID__c FROM User WHERE Id = :UserInfo.getUserId()];
		CH_NEAMessageDigiMop.sendCaseToNDA(ndaKey, CH_CaseUtils.getCase(caseId), oUser.FederationIdentifier != null ? oUser.FederationIdentifier : oUser.Nokia_ID__c);
	}
	
	@AuraEnabled
	public static String sendlogCollectionRequesttoNDA(Id caseId, SObject selectedNEA, String manualNEA, List<CH_ProductLogType__c> selectedLogs) {
		return CH_NEAMessageDigiMop.sendOneTouchLogInformation(caseId, selectedNEA, manualNEA, selectedLogs);
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
	
	@AuraEnabled
	public static List<Map<String, Object>> getProductRelated(String objectName, String recordId, String type) {
		return CH_ProductUtils.getProductRelated(objectName, recordId, type);
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
			List<ServiceContract> oServiceContractList = DML_SObject.doQuery('SELECT Id, ownerID FROM ServiceContract WHERE Id = "' + recordId + '" AND ownerId = "' + UserInfo.getUserId() + '" LIMIT 1');
			result = !oServiceContractList.isEmpty() && CH_SecurityUtils.checkUserPermissions(UserInfo.getUserId(), new List<String>{}, new List<String>{'CH_CustomerCareManager'}, false);
			for(ServiceContract oServiceContract : oServiceContractList){
				if(oServiceContract.OwnerId == userinfo.getUserId()){
					result = true;
				}
			}
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
	
	//User
	
	@AuraEnabled
	public static Boolean getUserPermission() {
		Boolean hasAccess = false;
		List<User> oUserList = DML_SObject.doQuery('SELECT Id, Username, Email FROM User WHERE UserRole.Name != "GWC" AND Profile.Name != "CH_Agent" AND Id = "' + UserInfo.getUserId() + '"  LIMIT 1');
		hasAccess = !oUserList.isEmpty();
		
		return hasAccess;
	}
	
	/****************************************
* Name : getTimezones
* Description : to get and returns timezone picklist Entry
* written on 9th Jun 2021
* By Satya Pagadala
* NOKIASC-36145
*****************************************/
	@AuraEnabled
	public static String getTimezones() {
		Schema.DescribeFieldResult fieldResult =User.TimeZoneSidKey.getDescribe();
		List<Schema.PicklistEntry> PkListEntry = fieldResult.getPicklistValues();
		return json.serialize(PkListEntry);
	}
	@AuraEnabled
	public static List<CaseMilestone> getMilestoneDetails(String caseId) {
		return CH_CaseUtils.getMilestoneDetails(caseId);
	}
}