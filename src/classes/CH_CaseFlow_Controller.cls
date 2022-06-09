/****************************************
* Class Name : CH_CaseFlow_Controller
* Created Date: 8 May 2019
* Created By : Tiago Almeida (tiago.almeida@nokia.com)
* Last Modified by: Sónia Reis
* Last Modified Date: 10 October 2019
* Description : Controller for all the Case Flows
* Test Class: 

Name			Modified DATE	Comments
Rajeshwari	  21 June 2019		Added  CH_Reported_By__c as part of US - NOKIASC-16857 
Gourisankar	 29 June 2019		Changed  Method caseEntitlementWrapper getEntitlementTabData
Gourisankar	 25 Sept 2019		Added Entitlement script flag as a part of US-22301(Line 568 and 569)
Rajeshwari		12 March 2020		 //NOKIASC-27305
*****************************************/
public with sharing class CH_CaseFlow_Controller {
	public static final String LEGAL_ENTITY_REC_TYPE = 'Legal_Entity';
	public static final String errorMsg='You are not authorized to change this case';
	public static final String errorMsg2 ='Contact System Administrator, Do not have enough permission to edit';
	public static final String errorMsg3= 'Something went wrong: ';
	@AuraEnabled
	public static DateTime getCaseInitiationDateTime(){
		return System.now();
	}
	
	@AuraEnabled
	public static Id getStandardCaseRecordTypeId() {
		return Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
	}
	
	@AuraEnabled
	public static Object getContactNameAndId(){
		Id contactId = [SELECT Id, ContactId FROM User WHERE id =: UserInfo.getUserId() LIMIT 1].ContactId;
		return [SELECT Id, Name FROM Contact WHERE Id =: contactId LIMIT 1];
	}
	
	@AuraEnabled
	public static Id getCaseOwnerId(){
		return [SELECT Id FROM User WHERE Username LIKE 'virtual_portal_attendant@%' LIMIT 1].Id;
	}
	
	@AuraEnabled
	public static List < Knowledge__kav > getArticles(){
		return CH_CaseFlow_Helper.getArticles();
	}
	
	@AuraEnabled
	public static Boolean isP20OrderEditAllowed(String caseId) {
		if(String.isNotBlank(caseId)) {
			// Do Nothing
		}
		return false;
	}
	
	@AuraEnabled
	public static List < Account > getLegalEntities(Boolean withoutSharing, String contactId, boolean swMaintenance){
		if(withoutSharing)
			return CH_CaseFlow_Helper.getLegalEntities(contactId, swMaintenance);
		Set < Account > legalEntitySet = new Set < Account > ();
		if(String.isNotBlank(contactId)){
			// Get Account legal entity record type dev name
			Id legalEntRecTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get(LEGAL_ENTITY_REC_TYPE).getRecordTypeId();
			if(swMaintenance)
	for(EntitlementContact entCtt : [SELECT Entitlement.AccountId, Entitlement.Account.Name, Entitlement.Account.CH_CareContract__c, Entitlement.Account.OperationalCustomerName__c, Entitlement.Account.Acc_No__c, Entitlement.Account.AccountNumber, Entitlement.Account.CH_ParentAccountName__c , Entitlement.Account.CH_Account_Name_Alias__c
			 FROM EntitlementContact 
			 WHERE ContactId = :contactId 
			 AND Entitlement.ServiceContract.CH_PortalCaseCreationSWMaintenance__c = true
			 AND Entitlement.ServiceContract.NCP_External_Status__c = 'Active'
			 AND Entitlement.Account.RecordTypeId = :legalEntRecTypeId
			 AND Entitlement.Account.Type != 'Vendor']) {
				 if(entCtt.Entitlement != null && entCtt.Entitlement.Account != null) {
					 legalEntitySet.add(entCtt.Entitlement.Account);				 
				 }
			 }
			else
	// Get Legal entities based on EntitlementContact object
	for(EntitlementContact entCtt : [SELECT Entitlement.AccountId, Entitlement.Account.Name, Entitlement.Account.CH_CareContract__c, Entitlement.Account.OperationalCustomerName__c, Entitlement.Account.Acc_No__c, Entitlement.Account.AccountNumber, Entitlement.Account.CH_ParentAccountName__c , Entitlement.Account.CH_Account_Name_Alias__c
			 FROM EntitlementContact 
			 WHERE ContactId = :contactId 
			 AND Entitlement.ServiceContract.NCP_External_Status__c = 'Active'
			 AND Entitlement.Account.RecordTypeId = :legalEntRecTypeId
			 AND Entitlement.Account.Type != 'Vendor']) {
				 if(entCtt.Entitlement != null && entCtt.Entitlement.Account != null) {
					 legalEntitySet.add(entCtt.Entitlement.Account);				 
				 }
			 }
		}
		return new List < Account > (legalEntitySet);
	}
	
	@AuraEnabled
	public static List < Asset > getAssets(Boolean withoutSharing, String accountId, String contactId, String serviceType, boolean swMaintenance) {
		if(withoutSharing) 
			return CH_CaseFlow_Helper.getAssets(accountId, contactId, serviceType, swMaintenance);
		Set < Asset > assetSet = new Set < Asset > ();
		if(String.isNotBlank(contactId) && String.isNotBlank(accountId)) {
			Set < Id > contractIds = new Set < Id > ();
			for(EntitlementContact entContactObj: [SELECT Entitlement.ServiceContractId FROM EntitlementContact WHERE ContactId = :contactId]) {
	contractIds.add(entContactObj.Entitlement.ServiceContractId);	
			} 
			if(swMaintenance)
	for(ContractLineItem cliObj: [SELECT AssetId, Asset.Name, Asset.Product2Id, Asset.Product2.Name, Asset.Product2.Description, Asset.CH_Solution__c, Asset.CH_Solution__r.Name, Asset.CH_ProductVariant__c, Asset.CH_ProductVariant__r.Name, Asset.CH_ProductRelease__c, Asset.CH_ProductRelease__r.Name, Asset.CH_CountryISOName__c	
			 FROM ContractLineItem
			 WHERE ServiceContractId IN :contractIds
			 AND ServiceContract.CH_PortalCaseCreationSWMaintenance__c = true
			 AND Asset.RecordType.DeveloperName = 'CH_CoveredProduct'
			 AND Asset.AccountId = :accountId
			 AND NCP_External_Status__c = 'Active'
			 AND CH_ServiceType__c = :serviceType
			 ORDER BY Asset.Name]) {
			  assetSet.add(cliObj.Asset);
			 }	
			else
	for(ContractLineItem cliObj: [SELECT AssetId, Asset.Name, Asset.Product2Id, Asset.Product2.Name, Asset.Product2.Description, Asset.CH_Solution__c, Asset.CH_Solution__r.Name, Asset.CH_ProductVariant__c, Asset.CH_ProductVariant__r.Name, Asset.CH_ProductRelease__c, Asset.CH_ProductRelease__r.Name, Asset.CH_CountryISOName__c	
			 FROM ContractLineItem
			 WHERE ServiceContractId IN :contractIds
			 AND Asset.AccountId = :accountId
			 AND Asset.RecordType.DeveloperName = 'CH_CoveredProduct'
			 AND NCP_External_Status__c = 'Active'
			 AND CH_ServiceType__c = :serviceType
			 ORDER BY Asset.Name]) {
			  assetSet.add(cliObj.Asset);
			 }
		}
		return new List < Asset > (assetSet);
	}
	
	@AuraEnabled
	public static List < Entitlement > getEntitlements(Boolean withoutSharing, String accountId, String assetId, String contactId, String serviceType, boolean swMaintenance) {
		if(withoutSharing)
			return CH_CaseFlow_Helper.getEntitlements(assetId, contactId, serviceType, swMaintenance);
		List < Entitlement > entitlementList = new List < Entitlement > ();
		if(String.isNotBlank(contactId) && String.isNotBlank(assetId)) {
			Set < Id > contractIds = new Set < Id > ();
			for(EntitlementContact entContactObj: [SELECT Entitlement.ServiceContractId FROM EntitlementContact WHERE ContactId = :contactId]) {
	contractIds.add(entContactObj.Entitlement.ServiceContractId);	
			}
			if(swMaintenance)
	entitlementList = [SELECT Id, Name, StartDate, EndDate, Status, Entitlement_Status__c, Type, 
		   AccountId, Account.Name, AssetId, Asset.Name, 
		   ServiceContractId, ServiceContract.Name, ServiceContract.CH_Project__c, ServiceContract.CH_EntitlementScript__c, ServiceContract.CH_CustomerContractNumber__c, 
		   ContractLineItemId, ContractLineItem.CH_LineItemEntitlementScript__c, ContractLineItem.LineItemNumber, 
		   ContractLineItem.CH_BusinessHour__c, ContractLineItem.CH_BusinessHour__r.Name 
		   FROM Entitlement
		   WHERE ServiceContractId IN :contractIds
		   AND ServiceContract.CH_PortalCaseCreationSWMaintenance__c = true
		   AND CH_RecordTypeCheck__c = true 
		   AND ContractLineItem.CH_ServiceType__c = :serviceType
		   AND ContractLineItem.NCP_External_Status__c = 'Active'
		   AND Name != 'Authorized Contact'		  
		   AND AssetId =: assetId		  
		   AND AccountId =: accountId];
			else
	entitlementList = [SELECT Id, Name, StartDate, EndDate, Status, Entitlement_Status__c, Type, 
		   AccountId, Account.Name, AssetId, Asset.Name, 
		   ServiceContractId, ServiceContract.Name, ServiceContract.CH_Project__c, ServiceContract.CH_EntitlementScript__c, ServiceContract.CH_CustomerContractNumber__c, 
		   ContractLineItemId, ContractLineItem.CH_LineItemEntitlementScript__c, ContractLineItem.LineItemNumber, 
		   ContractLineItem.CH_BusinessHour__c, ContractLineItem.CH_BusinessHour__r.Name, ServiceContract.CH_PortalCaseCreationSWMaintenance__c
		   FROM Entitlement
		   WHERE ServiceContractId IN :contractIds
		   AND CH_RecordTypeCheck__c = true 
		   AND ContractLineItem.CH_ServiceType__c = :serviceType
		   AND ContractLineItem.NCP_External_Status__c = 'Active'
		   AND Name != 'Authorized Contact'		  
		   AND AssetId =: assetId		  
		   AND AccountId =: accountId];
		}
		return entitlementList;
	}
	
	@AuraEnabled
	public static List < Account > getAllLegalEntities(String searchString, string contactId, String serviceType) {
		
		map<Id,Account> eligibleAccounts = serviceType == 'Customer Support'?new map<Id,Account>(getLegalEntities(false, contactId, false)):new map<Id,Account>();
		
		// Get Account legal entity record type dev name
		Id legalEntRecTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get(LEGAL_ENTITY_REC_TYPE).getRecordTypeId();
		
		List < Account > accounts = new List <Account>();
		if(String.isNotBlank(searchString)) {
			String soslString = 'FIND ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '\' ';
			soslString += 'IN All FIELDS RETURNING Account (Id, Name, AccountNumber, CH_ParentAccountName__c, CH_CareContract__c, OperationalCustomerName__c, CH_Account_Name_Alias__c WHERE RecordTypeId = ' + '\'' + legalEntRecTypeId + '\'' + ')'; 
			List < List < sObject >> sResults = search.query(soslString);
			if(sResults != null && !sResults.isEmpty()) { //
	for(sObject sObj : sResults[0]){
		if(!eligibleAccounts.containsKey(((Account) sObj).Id))
			accounts.add((Account) sObj);
	}
			}
		}
		return accounts;
	}
	
	/********************
	* Method Name: accountRelatedIsAuth
	* Parameter: Id contactId
	* Parameter: String accountNumber
	* Description: Check if Account is authorized (If Contact Authorized Contact on at least one contract with Account Id given (Usually the Nokia Internal Account, Nokia OYJ)
	* Reference: NOKIASC-22262
	*******************/
	@AuraEnabled
	public static Boolean accountRelatedIsAuth(Id contactId, String accountId) {
		Set<Id> accountIds = new Set<Id>();
		for(EntitlementContact cur : [SELECT Id, Entitlement.ServiceContract.AccountId FROM EntitlementContact WHERE ContactId= :contactId]) {
			if(cur.Entitlement != null && cur.Entitlement.ServiceContract != null && cur.Entitlement.ServiceContract.AccountId != null) {
	accountIds.add(cur.Entitlement.ServiceContract.AccountId);	
			}
		}
		return accountIds.contains(accountId);
	}
	
	/********************
* Method Name: getInternalAccount
* Description: Get the CH Nokia Internal Account
* Reference: NOKIASC-22262
*******************/
	@AuraEnabled
	public static Account getInternalAccount() {
		Account result = [SELECT Id, Name, AccountNumber, OperationalCustomerName__c, Acc_No__c, CH_ParentAccountName__c, CH_Account_Name_Alias__c FROM Account WHERE AccountNumber = :System.Label.CH_Nokia_Internal_Account LIMIT 1];
		return result != null?result:null;
	}
	
	/********************
	* Method Name: saveCase
	* Parameter: String oCase
	* Description: Used to save a Case and retrieve is Id to redirect to his record page
	* Reference: NOKIASC-15463/NOKIASC-15465
	*******************/
	@AuraEnabled
	public static id  saveCase(String  action, String oCase){
  return CH_CaseFlow_Helper.saveCase(action, oCase);
	}

	
	//Method to save Asset
	@AuraEnabled
	public static Id saveAsset(String action, String asst) {
		try {
	 
			List<Asset> assetList = (List<Asset>) JSON.deserialize(asst, List<Asset>.class);
			
			if(action.equals('insert')) insert assetList;
			else if(action.equals('upsert')) upsert assetList;
			else if(action.equals('update')) update assetList;
			return assetList[0].id;
		}catch (Exception e) {
			
			throw new AuraHandledException('Something went wrong!'+e.getMessage());
		}
	}
	
	@AuraEnabled
	public static String getContactName(string contactId){ 
		String message = '';
		if(contactId != null) {
			Contact contactObj = [SELECT Id, Name FROM Contact WHERE Id =: contactId];
			if(contactObj.Name != null) {
	message = contactObj.Name;
			} else {
	message = 'Contact object not found';
			}	
		}
		return message;
	}
	
	@AuraEnabled
	public static String enableReEntitlement (Id caseRecordId) {
		String message = '';
		if ( caseRecordId != null ) {
			
			//Checking record level access
			message = CH_CreateCaseController.checkRecordLevelAccess(caseRecordId);
			if (String.isNotBlank(message)) {
	return message = errorMsg;  
			}
			//Checking object level access
			message = checkObjectAccess('Case', new String[] {'Edit'});
			if (String.isNotBlank(message)) {
	return message = errorMsg;
			}
			//Checking field level access
			Map < String, String > fieldLevelAccessMap =  CH_CreateCaseController.checkFieldAccess('Case', new Map < String, String > {'AccountId' => 'Edit','AssetId' => 'Edit','ProductId' => 'Edit','EntitlementId' => 'Edit' }); 
			if ( String.isNotBlank(fieldLevelAccessMap.get('AccountId')) || String.isNotBlank(fieldLevelAccessMap.get('AssetId')) || String.isNotBlank(fieldLevelAccessMap.get('ProductId')) || String.isNotBlank(fieldLevelAccessMap.get('EntitlementId')) ) {
	message = errorMsg;
	return message ;
			}
			
			//If the User has all the above access string would be empty
			if ( String.isBlank(message) ) {
	Case caseObj = [SELECT Id, AccountId,CH_DeferralStatus__c,CH_LegacyCaseNumber__c, EntitlementId, ContactId, CH_IsCompleteInitialResponse__c,CH_IsCompleteRestore__c,CH_IsCompleteTemporarySolution__c,CH_IsCompleteSolutionProvided__c,CH_IsCompleteServiceDisruptionReport__c FROM Case WHERE Id =: caseRecordId LIMIT 1];
	if ( caseObj != null ) {
		if ( caseObj.CH_DeferralStatus__c == 'Active' ) {
			message = 'Re-Entitlement cannot be done when the Deferral Status is Active.' +'\n';
		} else if (String.isNotBlank(caseObj.CH_LegacyCaseNumber__c) ) {
			message += 'Entitlement information cannot be modified on a case migrated from legacy system.'+'\n';
		} else if ( caseObj.CH_IsCompleteRestore__c || caseObj.CH_IsCompleteTemporarySolution__c || caseObj.CH_IsCompleteSolutionProvided__c || caseObj.CH_IsCompleteServiceDisruptionReport__c)  {
			message += 'Entitlement related details cannot be modified once Restore, Temporary Solution or Solution Provided events have been completed.' +'\n';
		}  else {
			message = '';
			return message;
		}
	} else {
		message = errorMsg2;
		return message;
	}
			}   
		}
		return message;		
	}
	
	
	@AuraEnabled
	public static string checkPermissionSet(String permissionName) {
		String message = '';
	
		if( String.isNotBlank(permissionName) && String.isNotEmpty(permissionName) ) {
			try {
	PermissionSetAssignment  permissionAssign =  [SELECT Id, PermissionSet.Name, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =: UserInfo.getUserId() AND PermissionSet.Name =: permissionName ];
	if ( permissionAssign != null && permissionAssign.PermissionSet.Name == permissionName  ) {
		
		return message;
	}
			} catch(QueryException e) {
	message = 'Permission is not assgined to the user';
	 
	return message;
			}  
		} else {
			message = 'Null value has been passed';
		}
		return message;
	}
	
	@AuraEnabled
	public static string checkProfile(String profileName) {
		String message = '';
		if ( String.isNotEmpty(profileName) && String.isNotBlank(profileName) ) {
			try{
	User userObj = [SELECT Profile.Name FROM User WHERE Id =: UserInfo.getUserId() AND Profile.Name =: profileName ];
	if ( userObj != null ) {
		return message;
	}
			} catch ( QueryException e ) {
	message = 'The required profile is not assigned to the user';
			}
		} else {
			message = 'The profile name provided is null';
		}
		return message;
	}
	
	@AuraEnabled
	public static User getCurrentUser(){
		return [SELECT Username FROM User WHERE Id = :UserInfo.getUserId()];
	}
	
	@AuraEnabled
	public static boolean hasOnlyReadAccess(string caseId){
		list<UserRecordAccess> ura = new list<UserRecordAccess>([SELECT RecordId, HasEditAccess, HasReadAccess FROM UserRecordAccess WHERE RecordId = :caseId AND UserId =:UserInfo.getUserId()]);
		return ura.isEmpty() ? false : ( (!ura[0].HasEditAccess && ura[0].HasReadAccess) ? true : false) ;
			}
	
 /*******************************************************************************
 * NOKIASC-22547 : Entitlement script trigger window visibility
 * Updated Class caseEntitlementWrapper 
 * Updated caseEntitlementWrapper getEntitlementTabData to check Line item script

 ********************************************************************************/ 
	public class caseEntitlementWrapper {
		@AuraEnabled
		public boolean hasOnlyReadAccess {get; set;}
		@AuraEnabled
		public boolean hasEditAccess {get; set;}
		@AuraEnabled
		public User currentUser {get; set;}
		@AuraEnabled
		public string recordTypeDevName {get; set;}
		@AuraEnabled
		public boolean enableShowScript {get; set;}
	}
   
	@AuraEnabled
	 public static caseEntitlementWrapper getEntitlementTabData(string caseId){		
		list<UserRecordAccess> ura = new list<UserRecordAccess>([SELECT RecordId, HasEditAccess, HasReadAccess FROM UserRecordAccess WHERE RecordId = :caseId AND UserId =:UserInfo.getUserId()]);		
		caseEntitlementWrapper wInstance = new caseEntitlementWrapper();
		//NOKIASC-27305
		wInstance.hasEditAccess = accessCheck(caseId);//ura[0].HasEditAccess;
		wInstance.hasOnlyReadAccess = !ura[0].HasEditAccess && ura[0].HasReadAccess;
		wInstance.currentUser = [SELECT Username FROM User WHERE Id = :UserInfo.getUserId()];
		Case aCase = [SELECT RecordType.DeveloperName, EntitlementId, Entitlement.ContractLineItemId , Entitlement.ContractLineItem.CH_LineItemEntitlementScript__c,Entitlement.ServiceContractid,Entitlement.ServiceContract.CH_EntitlementScript__c FROM Case WHERE Id = :caseId];
		wInstance.recordTypeDevName = aCase.RecordType.DeveloperName;
		
		if((aCase.EntitlementId !=null && aCase.Entitlement.ContractLineItemId !=null &&  aCase.Entitlement.ContractLineItem.CH_LineItemEntitlementScript__c !=null) ||(aCase.Entitlement.ServiceContractid !=null && aCase.Entitlement.ServiceContract.CH_EntitlementScript__c !=null )){
			wInstance.enableShowScript = false;
		}else{
			wInstance.enableShowScript = true; 
		}
	
		return wInstance;
	}
	
	@AuraEnabled
	public static string redirectScreen(String profileName, String permissionName) {
		String message = '';
		if(String.isNotEmpty(profileName) || String.isNotEmpty(permissionName)) {
			String checkPermission = checkPermissionSet(permissionName);
			String checkProfile = checkProfile(profileName);
			
			if(String.isBlank(checkPermission) || String.isBlank(checkProfile)) {
	return message;
			} else {
	message = 'Dont have enough Access';
			}
		} else {
			message = 'Both inputs are empty or null';
		}
		return message;
	}
	
	@AuraEnabled
	public static Case getCaseDetails(Id CaseId) {
		try{
			List<Case> cases = [SELECT  Id, Account.Name, Contact.Name, Contact.CH_ContactType__c, Asset.Name, Entitlement.Name, CH_Problem__c, CH_Problem__r.Subject,
				ProductId, Product.Name, Product.NCP_Nokia_Product_Id__c,
				CH_Product_Release__c, CH_Product_Release__r.Name, CH_Product_Release__r.CH_NSNLegacyCode__c,
				CH_Solution__c, CH_Solution__r.Name, CH_Solution__r.NCP_Nokia_Product_Id__c,
				CH_Product_Module__c, CH_Product_Module__r.Name, CH_Product_Module__r.NCP_Nokia_Product_Id__c,
				CH_ProductVariant__c, CH_ProductVariant__r.Name, CH_ProductVariant__r.NCP_Nokia_Product_Id__c,
				CH_SW_Component__c, CH_SW_Release__c, CH_SW_Module__c, CH_SW_Build__c, CH_HW_Component__c,
				CH_ServiceType__c
		FROM Case WHERE Id =: CaseId
			];
			return cases.isEmpty() ? null : cases[0];
		}catch(Exception e){
			throw new AuraHandledException(CH_CaseFlow_Controller.errorMsg3 + e.getMessage());
		}
	}
	
	//Method to get Asset Details
	@AuraEnabled
	public static Asset getAssetDetails(Id assetId) {
		try{
			List<Asset> asset = [SELECT Id, Account.Name, Contact.Name, Name,
		 Product2Id, Product2.Name, Product2.NCP_Nokia_Product_Id__c,
		 CH_ProductRelease__c, CH_ProductRelease__r.Name, CH_ProductRelease__r.CH_NSNLegacyCode__c,
		 CH_Solution__c, CH_Solution__r.Name, CH_Solution__r.NCP_Nokia_Product_Id__c,
		 CH_ProductVariant__c, CH_ProductVariant__r.Name, CH_ProductVariant__r.NCP_Nokia_Product_Id__c
		 FROM Asset WHERE Id =: assetId];
			return asset.isEmpty() ? null : asset[0];
		}catch(Exception e){
			throw new AuraHandledException(CH_CaseFlow_Controller.errorMsg3  + e.getMessage());
		}
	}
	
	@AuraEnabled
	public static String hasCaseEditAcess(Id caseRecordId, List<String> fields) {
		String message = '';
		if (caseRecordId != null ) {
			//Checking record level access
			message = checkRecordLevelAccess(caseRecordId);
			if (String.isNotBlank(message)) {
	return message = errorMsg;  
			}
			//Checking object level access
			message = checkObjectAccess('Case', new String[] {'Edit'});
			if (String.isNotBlank(message)) {
	return message = errorMsg;
			}
			//Checking field level access
			Map < String, String > fieldLevelPermissionMap = new Map < String, String >();
			for(String field : fields){
	fieldLevelPermissionMap.put(field, 'Edit');
			}
			Map < String, String > fieldLevelAccessMap =  CH_CreateCaseController.checkFieldAccess('Case', fieldLevelPermissionMap);
			for(String field : fields){
	if(String.isNotBlank(fieldLevelAccessMap.get(field))){
		message = errorMsg;
		return message ;
	}
			}
			if(String.isBlank(message)) {
	Case caseObj = [SELECT Id, CH_Stage__c, RecordType.Name, AccountId, EntitlementId, ContactId, CH_IsCompleteInitialResponse__c,CH_IsCompleteRestore__c,CH_IsCompleteTemporarySolution__c,CH_IsCompleteSolutionProvided__c,CH_IsCompleteServiceDisruptionReport__c,status FROM Case WHERE Id =: caseRecordId LIMIT 1];
	if(caseObj != null && caseObj.RecordType.Name.equals('Problem')) {
		//Defect 26533: Status has been added in the below criteria-TCS-Partha Roy-3rd Feb,2020		 
		 
		if(caseObj.CH_Stage__c.equals('Close') && caseObj.Status.equals('Closed')) {
			message = 'Problem Details cannot be modified once Problem is closed.';
		}
	}
	else {
		if(caseObj.CH_IsCompleteRestore__c || caseObj.CH_IsCompleteTemporarySolution__c || caseObj.CH_IsCompleteSolutionProvided__c || caseObj.CH_IsCompleteServiceDisruptionReport__c) {
			message = 'Entitlement related details cannot be modified once Restore, Temporary Solution or Solution Provided events have been completed.';
		}
	}
			}
			return message;
		}	
		return errorMsg2;
	}
		
	@AuraEnabled
	public static String hasAssetEditAcess(Id assetRecordId, List<String> fields) {
		String message = '';
		if (assetRecordId != null ) {
			//Checking record level access
			message = checkRecordLevelAccess(assetRecordId);
			if (String.isNotBlank(message)) {
	return message = errorMsg;  
			}
			//Checking object level access
			message = checkObjectAccess('Asset', new String[] {'Edit'});
			if (String.isNotBlank(message)) {
	return message = errorMsg;
			}
			//Checking field level access
			Map < String, String > fieldLevelPermissionMap = new Map < String, String >();
			for(String field : fields){
	fieldLevelPermissionMap.put(field, 'Edit');
			}
			Map < String, String > fieldLevelAccessMap =  CH_CreateAssetController.checkFieldAccess('Asset', fieldLevelPermissionMap);
			for(String field : fields){
	if(String.isNotBlank(fieldLevelAccessMap.get(field))){
		message = errorMsg;
		return message ;
	}
			}
			return message;
		}	
		return errorMsg2;
	}
	
	
	/*******************
	* Method Name: checkRecordLevelAccess
	* Parameter: Id objectID
	* Description: TO check the record level access
	* Reference: NOKIASC-16337
	*******************/   
	public static String checkRecordLevelAccess(Id objectID){ 
		String message = '';
		if (objectID != null){
			UserRecordAccess recordAccess =  [SELECT RecordId  ,HasEditAccess FROM UserRecordAccess WHERE UserId =:UserInfo.getUserId() AND RecordId =: objectID Limit 1];
			if(recordAccess != null && recordAccess.HasEditAccess){
	message = ''; 
			} else {
	message = 'Does not have edit access over record for this user';
			}	 
		}  
		return message;
	}
	
	/********************
	* Method Name: checkObjectAccess
	* Parameter: String sObjectName, String[] accessLevel
	* Description: Used to check access of given object with provided access level
	* Reference: NOKIASC-15495/15083
	*******************/
	
	public static string checkObjectAccess(String sObjectName, String[] accessLevel) {
		SObjectType sObjectTypeName = Schema.getGlobalDescribe().get(sObjectName);
		for(String access: accessLevel) {
			if(access == 'Read' && !sObjectTypeName.getDescribe().isAccessible()) {
	return 'No Read Access';
			} else if(access == 'Create' && !sObjectTypeName.getDescribe().isCreateable()) {
	return 'No Create Access';
			} else if(access == 'Edit' && !sObjectTypeName.getDescribe().isUpdateable()) {
	return 'No Edit Access';
			} else if(access == 'Delete' && !sObjectTypeName.getDescribe().isDeletable()) {
	return 'No Delete Access';
			} else {
	return '';
			}
		}
		return 'Invalid object access level';	
	}
  
	/** Problem Tab **/
	
	@AuraEnabled
	public static boolean accessCheck(Id caseId){
		
		Boolean flag=CH_Utils.accessCheck(caseId, false);
		return flag;
	}
	
	@AuraEnabled
	public static void disassociateNewProblem(Id caseId){
		try{
			update new Case(Id = caseId, CH_Problem__c = null, ParentId = null);	
		}catch(Exception e){
			throw new AuraHandledException(CH_CaseFlow_Controller.errorMsg3  + e.getMessage());
		}
	}
	
	@AuraEnabled
	public static void newPostToProblem(Id caseId){
		try{
			
			list<Case> incidents = new list<Case>([SELECT CaseNumber, CH_Problem__c, CH_Problem__r.OwnerId FROM Case WHERE Id = :caseId]);
			if(!incidents.isEmpty() && incidents[0].CH_Problem__c != null){
	if(((string)incidents[0].CH_Problem__r.OwnerId).startsWith('00G'))
		throw new NokiaException('You cannot create a chatter post because the problem is currently owned by a Queue');

	ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
	ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
	ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
	ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
	messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
	mentionSegmentInput.id = incidents[0].CH_Problem__r.OwnerId;
	messageBodyInput.messageSegments.add(mentionSegmentInput);
	textSegmentInput.text = '\n More information has been added to the incident: ' + incidents[0].CaseNumber;
	messageBodyInput.messageSegments.add(textSegmentInput);
	feedItemInput.body = messageBodyInput;
	feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
	feedItemInput.subjectId = incidents[0].CH_Problem__c;
	ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput); 
	
	
			}
			
			
			
			
		}catch(Exception e){
			throw new AuraHandledException(CH_CaseFlow_Controller.errorMsg3  + e.getMessage());
		}
	}
	
	@AuraEnabled
	public static boolean displayP20fields(string entitlementId){
		
		try {
			CH_Hierarchical_Setting__c  hierSetting = CH_Hierarchical_Setting__c.getInstance();
			if(string.isBlank(entitlementId)) return false; 
			list<Entitlement> lments = new list<Entitlement>([SELECT ServiceContract.CH_CARES_ServiceAgreement__c, ServiceContract.CH_CDB_ContractNumber__c FROM Entitlement WHERE Id = :entitlementId]);
			return (hierSetting != null && hierSetting.P20OrderDetails__c && !lments.isEmpty() && string.isBlank(lments[0].ServiceContract.CH_CARES_ServiceAgreement__c) && !string.isBlank(lments[0].ServiceContract.CH_CDB_ContractNumber__c)) ? true : false;
		}
		catch(Exception e) {
			
			throw new AuraHandledException(CH_CaseFlow_Controller.errorMsg3  + e.getMessage());
		}
	}
  /*
   * NOKIASC-22547 : On click of Show script button event method
   * */
	@AuraEnabled
	public static void updateEntitlementScript(string recordId){
		
	
		try {
			Case objCaseUpdate = new Case();
			objCaseUpdate.Id = recordId;
			objCaseUpdate.CH_EntitlementScriptFlag__c = false;
			update objCaseUpdate;		  
			
		}
		catch(Exception e) {
			//This is empty line.
		}
			
	  
	}
	
	 //Changes added as a Part of NOKIASC-35322
	@AuraEnabled
	Public Static DateTime checkSolutionTargetDate(Id caseId){
		DateTime getTargetDate;
		// Get the first milestones
		for(CaseMilestone caseMilestones:  [SELECT TargetDate, Startdate,milestonetype.name,Case.id,Case.status,Case.CH_Time_Stamp_Customer_Pending__c,MilestoneTypeId FROM CaseMilestone 
											WHERE milestonetype.name IN ('Solution Provided (deferred)','Solution Provided (defect)') AND Case.Id = : caseId
											Order by TargetDate ASC LIMIT 1])
		{
			getTargetDate = caseMilestones.TargetDate;
			
		}
		return getTargetDate;
	}
	
	 //Changes added as a Part of NOKIASC-35322
	@AuraEnabled
	Public Static DateTime checkpausedSinceDate(Id getCaseId){
		DateTime getpausedSinceDate;
		// Get the pausedSinceDate Values
		DateTime isValid= CH_CaseFlow_Controller.checkSolutionTargetDate(getCaseId);
		if(isValid != null){
			for(CH_PendingTimeSuspension__c getPendingSuspensionTime:  [Select Id,CH_StartTime__c,CH_SupportTicket__r.status from CH_PendingTimeSuspension__c where CH_SupportTicket__c=:getCaseId AND CH_SupportTicket__r.status = 'Pending Customer'  Order by CH_StartTime__c DESC LIMIT 1 ])
			{
				getpausedSinceDate = getPendingSuspensionTime.CH_StartTime__c;
				
			}
		}
		return getpausedSinceDate;
	}
	
	public class NokiaException extends Exception {}
}