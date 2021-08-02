/****************************************
 * Class Name : CH_ServiceContractTriggerHelper 
 * Created Date: 08 August 2018
 * Created By : TCS
 * Last Modified by: TCS
 * Last Modified Date: 09 August 2018
 * Description : Contains common business logic
 * Test Class: CH_ServiceContractTriggerTest
 *****************************************/
public class CH_ServiceContractTriggerHelper {
	/********************
	* Method Name: copyPreviousContractsAuthorizedAccounts
	* Parameter: List < ServiceContract >
	* Description: Used to copy authorized account from previous service contract
	* Reference: NOKIASC-4229
	*******************/
	public static List < ServiceContract > copyPreviousContractsAuthorizedAccounts(List < ServiceContract > newContractList) {
		List < ServiceContract > defaultProcessContractList = new List < ServiceContract > ();
		if(newContractList != null && !newContractList.isEmpty()) {
			Set < String > extContractIds = new Set < String > ();
			for(ServiceContract contractObj: newContractList) {
	if(String.isNotBlank(contractObj.CH_CDB_PreviousContractId__c)) {
		extContractIds.addAll(splitTextByComma(contractObj.CH_CDB_PreviousContractId__c));
	}
			}
			
			if(!extContractIds.isEmpty()) {
	
	// Get a map of service contracts where key is CH_CDB_ContractId__c field
	Map<string, ServiceContract> prevServContracts = new Map<string, ServiceContract>();
	for(ServiceContract servC : [SELECT AccountId, CH_CDB_ContractId__c FROM ServiceContract WHERE CH_CDB_ContractId__c IN :extContractIds]){
		if(!string.isBlank(servC.CH_CDB_ContractId__c)) prevServContracts.put(servC.CH_CDB_ContractId__c, servC);
	}
	
	Map < String, List < CH_AuthorizedAccount__c >> contractAuthorizedAccountMap = new Map < String, List < CH_AuthorizedAccount__c >> ();
	for(CH_AuthorizedAccount__c authAccountObj: [
		SELECT Id, Name, CH_Account__c, CH_ServiceContract__c, CH_ServiceContract__r.CH_CDB_ContractId__c, CH_ServiceContract__r.AccountId FROM CH_AuthorizedAccount__c WHERE CH_ServiceContract__c IN (
			SELECT Id FROM ServiceContract WHERE CH_CDB_ContractId__c IN :extContractIds	
		)]) {
		// Process Return List 
		if(contractAuthorizedAccountMap.containsKey(authAccountObj.CH_ServiceContract__r.CH_CDB_ContractId__c)) {
			contractAuthorizedAccountMap.get(authAccountObj.CH_ServiceContract__r.CH_CDB_ContractId__c).add(authAccountObj);
		} else {
			contractAuthorizedAccountMap.put(authAccountObj.CH_ServiceContract__r.CH_CDB_ContractId__c, new List < CH_AuthorizedAccount__c > { authAccountObj });		
		}
	}
	
	Set < CH_AuthorizedAccount__c > authAccountSet = new Set < CH_AuthorizedAccount__c > ();
	for(ServiceContract contractObj: newContractList) {
		if(String.isNotBlank(contractObj.CH_CDB_PreviousContractId__c)) {
			Boolean isDefaultProcess = true;
			if(contractAuthorizedAccountMap.isEmpty() && !prevServContracts.isEmpty()){
		isDefaultProcess = false; 
			}
			for(String extContractId: splitTextByComma(contractObj.CH_CDB_PreviousContractId__c)) {
	if(prevServContracts.containsKey(extContractId) && contractObj.AccountId != prevServContracts.get(extContractId).AccountId){
		isDefaultProcess = true;
	}
	// NOKIASC-22290 copy only if service contract accounts match
	if(contractAuthorizedAccountMap.containsKey(extContractId) && prevServContracts.containsKey(extContractId) && contractObj.AccountId == prevServContracts.get(extContractId).AccountId) {
		isDefaultProcess = false; 
		for(CH_AuthorizedAccount__c authAccountObj: contractAuthorizedAccountMap.get(extContractId)) {
			// if(contractObj.AccountId != authAccountObj.CH_Account__c) {
	authAccountSet.add(
		new CH_AuthorizedAccount__c(CH_Account__c = authAccountObj.CH_Account__c, CH_ServiceContract__c = contractObj.Id, CH_IsTriggerRun__c = false)	
	);	
			// }
		}
	}
			}
			if(isDefaultProcess) {
	defaultProcessContractList.add(contractObj);
			}
		}
	}
	
	if(!authAccountSet.isEmpty()) {
		try {
			List < CH_AuthorizedAccount__c > authAccountList = new List < CH_AuthorizedAccount__c > (authAccountSet); 
			// Insert EntitlementContact list
			Database.SaveResult[] srList = Database.insert(new List < CH_AuthorizedAccount__c > (authAccountList) , false);
			
			// Iterate through each returned result
			for (Integer i = 0; i < authAccountList.size(); i++) {
	Database.SaveResult sr = srList[i];
	CH_AuthorizedAccount__c authAccountObj = authAccountList[i];
	if (!sr.isSuccess()) {
		// Operation failed, so get all errors	
		for(Database.Error err : sr.getErrors()) {
			System.debug('### CH_AuthorizedAccount__c Info (' + authAccountObj.CH_Account__c + '==' + authAccountObj.CH_ServiceContract__c + ') ### Error Message ### ' + err.getMessage());
		}
	}
			}
		} catch(Exception ex) {
			System.debug('### ' + ex.getMessage());
		}
	}	  
			}
		}
		return defaultProcessContractList;
	}
	
	/********************
	* Method Name: copyPreviousContractsAuthorizedContacts
	* Parameter: List < ServiceContract >
	* Description: Used to copy authorized contracts from previous service contract
	* Reference: NOKIASC-4229
	*******************/
	public static void copyPreviousContractsAuthorizedContacts(List < ServiceContract > newContractList) {
		if(newContractList != null && !newContractList.isEmpty()) {
			Set < String > extContractIds = new Set < String > ();
			Set < String > previousCDBContractIds = new Set < String > ();
			Set < String > newCDBContractIds = new Set < String > ();
			for(ServiceContract contractObj: newContractList) {
	if(String.isNotBlank(contractObj.CH_CDB_PreviousContractId__c)) {
		// extContractIds.addAll(splitTextByComma(contractObj.CH_CDB_PreviousContractId__c));
		newCDBContractIds.add(contractObj.CH_CDB_ContractId__c);
		previousCDBContractIds.addAll(splitTextByComma(contractObj.CH_CDB_PreviousContractId__c));
	}
			}
			
			if(!previousCDBContractIds.isEmpty()) {
	
	// Get a map of service contracts where key is CH_CDB_ContractId__c field
	Map<string, ServiceContract> prevServContracts = new Map<string, ServiceContract>();
	for(ServiceContract servC : [SELECT AccountId, CH_CDB_ContractId__c FROM ServiceContract WHERE CH_CDB_ContractId__c IN :previousCDBContractIds]){
		if(!string.isBlank(servC.CH_CDB_ContractId__c)) prevServContracts.put(servC.CH_CDB_ContractId__c, servC);
	}
	
	Map < String, Id > contractAuthorizedEntitlementMap = new Map < String, Id > ();
	for(Entitlement entObj: [SELECT Id, ServiceContract.CH_CDB_ContractId__c FROM Entitlement WHERE ServiceContract.CH_CDB_ContractId__c IN :newCDBContractIds AND CH_EntitlementType__c = 'Authorized Contact']) {
		contractAuthorizedEntitlementMap.put(entObj.ServiceContract.CH_CDB_ContractId__c, entObj.Id);
	}
	 
	String query = 'SELECT Id, ContactId, EntitlementId, Entitlement.ServiceContract.CH_CDB_ContractId__c FROM EntitlementContact WHERE EntitlementId IN (SELECT Id FROM Entitlement WHERE ServiceContract.CH_CDB_ContractId__c IN :previousCDBContractIds AND CH_EntitlementType__c = \'Authorized Contact\') ORDER BY createdDate ASC';
	Map < Id, EntitlementContact > contactIdVsEntContactMap = new Map < Id, EntitlementContact > ();
	for(EntitlementContact entContactObj: Database.query(query)) {
		contactIdVsEntContactMap.put(entContactObj.ContactId, entContactObj);
	}
	List < EntitlementContact > entContactList = new List < EntitlementContact > ();
	if(!contactIdVsEntContactMap.isEmpty()) {
		for(AccountContactRelation accContactObj: [SELECT Id, ContactId FROM AccountContactRelation WHERE ContactId IN :contactIdVsEntContactMap.keySet() AND NCP_Entitlement_Relationship__c = true]) {
			entContactList.add(contactIdVsEntContactMap.get(accContactObj.ContactId));
		}	
	}
	
	Map < String, List < EntitlementContact >> previousContractAuthorizedContactsMap = new Map < String, List < EntitlementContact >> ();
	if(!entContactList.isEmpty()) {
		for(EntitlementContact entContactObj: entContactList) {
			if(previousContractAuthorizedContactsMap.containsKey(entContactObj.Entitlement.ServiceContract.CH_CDB_ContractId__c)) {
	previousContractAuthorizedContactsMap.get(entContactObj.Entitlement.ServiceContract.CH_CDB_ContractId__c).add(entContactObj);
			} else {
	previousContractAuthorizedContactsMap.put(entContactObj.Entitlement.ServiceContract.CH_CDB_ContractId__c, new List < EntitlementContact > { entContactObj });
			}
		}
	} 
	
	Set < EntitlementContact > createEntContactSet = new Set < EntitlementContact > (); 
	for(ServiceContract contractObj: newContractList) {
		if(String.isNotBlank(contractObj.CH_CDB_PreviousContractId__c)) {
			for(String cdbContractId: splitTextByComma(contractObj.CH_CDB_PreviousContractId__c)) {
	// NOKIASC-22290 copy only if service contract accounts match
	if(previousContractAuthorizedContactsMap.containsKey(cdbContractId) && prevServContracts.containsKey(cdbContractId) && contractObj.AccountId == prevServContracts.get(cdbContractId).AccountId ) {
		for(EntitlementContact entContactObj: previousContractAuthorizedContactsMap.get(cdbContractId)) {
			if(contractAuthorizedEntitlementMap.containsKey(contractObj.CH_CDB_ContractId__c)) {
	createEntContactSet.add(new EntitlementContact(ContactId = entContactObj.ContactId, EntitlementId = contractAuthorizedEntitlementMap.get(contractObj.CH_CDB_ContractId__c)));
			}
		}
	}
			}
		}
	}
	if(!createEntContactSet.isEmpty()) {
		try {
			List < EntitlementContact > createEntContactList = new List < EntitlementContact > (createEntContactSet); 
			// Insert EntitlementContact list
			Database.SaveResult[] srList = Database.insert(createEntContactList, false);
			
			// Iterate through each returned result
			for (Integer i = 0; i < createEntContactList.size(); i++) {
	Database.SaveResult sr = srList[i];
	EntitlementContact entContactObj = createEntContactList[i];
	if (!sr.isSuccess()) {
		// Operation failed, so get all errors	
		for(Database.Error err : sr.getErrors()) {
			System.debug('### EntitlementContact Info (' + entContactObj.ContactId + '==' + entContactObj.EntitlementId + ') ### Error Message ### ' + err.getMessage());
		}
	}
			}
		} catch(Exception ex) {
			System.debug('### Exception has occurred as :: ' + ex.getMessage());
		}
	}
			}
		}
		
	}
	
	/********************
	* Method Name: splitTextByComma
	* Parameter: String
	* Description: Used to return list of values splitted by comma
	* Reference: NOKIASC-4229
	*******************/
	public static List < String > splitTextByComma(String str) {
		List < String > strList = new List < String > ();
		if(String.isNotBlank(str)) {
			for(String s: str.split(',')) {
	if(String.isNotBlank(s)) {
		strList.add(s.trim());
	}
			}
		}
		return strList;
	}
	
	/********************
	* Method Name: createAuthorizedEntitlement
	* Parameter: ServiceContract
	* Description: Used to create entitlement record of type "Authorized Contact" (Entitlement) 
	* Reference: NOKIASC-4316
	*******************/
	public static void createAuthorizedEntitlement(Map < Id, ServiceContract > newContractMap) {
		if(newContractMap != null && !newContractMap.isEmpty()) {
			// Check for existing Authorized Entitlement
			for(Entitlement entObj: [SELECT Id, ServiceContractId, AccountId FROM Entitlement WHERE ServiceContractId IN :newContractMap.keySet() AND CH_EntitlementType__c = 'Authorized Contact']) {
	if(newContractMap.get(entObj.ServiceContractId) != null) {
		newContractMap.remove(entObj.ServiceContractId);
	}
			}
			if(!newContractMap.isEmpty()) {
	// To get SLA Procss Id
	List < SLAProcess > slaProcessList = [SELECT Id, Name FROM SlaProcess WHERE SobjectType = 'Case' AND IsActive = true];
	// Check process exist or not
	if(slaProcessList != null && !slaProcessList.isEmpty()) {
		List < Entitlement > newEntList = new List < Entitlement > ();
		for(Id contractId: newContractMap.keySet()) {
			newEntList.add(createDummyEntitlement(newContractMap.get(contractId), slaProcessList.get(0)));	
		}
		try { // Insert new entitlement list
			// Insert EntitlementContact list
			Database.SaveResult[] srList = Database.insert(newEntList, false);

			// Iterate through each returned result
			for (Database.SaveResult sr : srList) {
	if (!sr.isSuccess()) {
		// Operation failed, so get all errors	
		for(Database.Error err : sr.getErrors()) {
			System.debug('#### Exception occurred at CH_ServiceContractTriggerHelper.createAuthorizedEntitlement ### ' + err.getMessage());
		}
	}
			}
		} catch(Exception ex) {
			System.debug('#### ' + ex.getMessage());
		}
	}
			}
		} 
	}
	
	/********************
	* Method Name: updateAuthorizedEntitlementOnContract
	* Parameter: Map < Id, ServiceContract >
	* Description: Used to update CH_Entitlement__c field on ServiceContract with "Authorized Contact" (Entitlement) 
	* Reference: NOKIASC-4316
	*******************/
	public static void updateAuthorizedEntitlementOnContract(Map < Id, ServiceContract > newContractMap) {
		if(newContractMap != null && !newContractMap.isEmpty()) {
			List < Entitlement > entList = [SELECT Id, ServiceContractId FROM Entitlement WHERE ServiceContractId IN :newContractMap.keySet() AND CH_EntitlementType__c = 'Authorized Contact'];
			if(entList != null && !entList.isEmpty()) {
	List < ServiceContract > contractList = new List < ServiceContract > ();
	for(Entitlement entObj: entList) {
		if(newContractMap.get(entObj.ServiceContractId) != null) {
			ServiceContract contractObj = (newContractMap.get(entObj.ServiceContractId)).clone(true, true, false, true);
			contractObj.CH_Entitlement__c = entObj.Id;
			contractList.add(contractObj);
		}
	}
	if(!contractList.isEmpty()) {
		try {
			// Insert EntitlementContact list
			Database.SaveResult[] srList = Database.update(contractList, false);

			// Iterate through each returned result
			for (Database.SaveResult sr : srList) {
	if (!sr.isSuccess()) {
		// Operation failed, so get all errors	
		for(Database.Error err : sr.getErrors()) {
			System.debug('#### Exception occurred at CH_ServiceContractTriggerHelper.updateAuthorizedEntitlementOnContract ### ' + err.getMessage());
		}
	}
			}
			// Create EntitlementContact Record
			// createEntitlementContact(contractList);
		} catch(Exception ex) {
			System.debug('#### ' + ex.getMessage());
		}
	}
			}
		}
	}
	
	/********************
	* Method Name: createAuthorizedAccount
	* Parameter: ServiceContract
	* Description: Used to create Junction record (CH_AuthorizedAccount__c)
	* Reference: NOKIASC-4316
	*******************/
	public static void createAuthorizedAccount(Map < Id, ServiceContract > newContractMap) {
		if(newContractMap != null && !newContractMap.isEmpty()) {
			List < CH_AuthorizedAccount__c > authAccountList = new List < CH_AuthorizedAccount__c > ();
			for(ServiceContract contractObj: newContractMap.values()) {
	authAccountList.add(new CH_AuthorizedAccount__c(CH_Account__c = contractObj.AccountId, CH_ServiceContract__c = contractObj.Id));
			}
			if(!authAccountList.isEmpty()) {
	try {
		// Insert EntitlementContact list
		Database.SaveResult[] srList = Database.insert(authAccountList, false);

		// Iterate through each returned result
		for (Database.SaveResult sr : srList) {
			if (!sr.isSuccess()) {
	// Operation failed, so get all errors	
	for(Database.Error err : sr.getErrors()) {
		System.debug('#### Exception occurred at CH_ServiceContractTriggerHelper.createAuthorizedAccount ### ' + err.getMessage());
	}
			}
		}
	} catch(Exception ex) {
		System.debug('### ' + ex.getMessage());
	}
			}
		}
	}
	
	/********************
	* Method Name: createDummyEntitlement
	* Parameter: ServiceContract
	* Description: Used to prepare data for Entitlement object.
	* Reference: NOKIASC-4316
	*******************/
	public static Entitlement createDummyEntitlement(ServiceContract contractObj, SlaProcess slaProcessObj) {
		Entitlement entObj = new Entitlement();
		entObj.RecordTypeId = Schema.SObjectType.Entitlement.getRecordTypeInfosByName().get('CH Entitlement').getRecordTypeId();
		entObj.Name = contractObj.Name + ' - Authorized Contact';
		entObj.ServiceContractId = contractObj.Id;
		entObj.AccountId = contractObj.AccountId;
		entObj.CH_EntitlementType__c = 'Authorized Contact';
		entObj.CH_CDB_EntitlementId__c = '1';
		// entObj.CH_ServiceMappingId__c = slaProcessObj.Name;
		entObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical 24x7';
		entObj.SlaProcessId = slaProcessObj.Id;
		entObj.StartDate = contractObj.StartDate;
		entObj.EndDate = contractObj.EndDate;
		return entObj;
	}	
	
	/********************
	* Method Name: populateLookupIds
	* Parameter: ServiceContract
	* Description: Used to set lookup fields Id coming from Interface/CDB/CARES
	* Reference: NOKIASC-10907
	*******************/
	public static void populateLookupIds(List<ServiceContract> newContractList) {
		if(newContractList != null && !newContractList.isEmpty()) {
			List<User> iPAASUser = [SELECT Id FROM User Where Name = 'iPAAS User' LIMIT 1];
			Set<String> ownerEmailIds = new Set<String>();
			Set<String> pricebookNames = New Set<String>();
			for(ServiceContract contractObj: newContractList) {
	ownerEmailIds.add(contractObj.CH_CAPM_EmailAddress__c);
	pricebookNames.add(contractObj.CH_PriceBook__c);
			}
			// Get all useers by email ids
			Map<String, Id> emailOwnerIdMap = new Map<String, Id>(); 
			if(!ownerEmailIds.isEmpty()) {
	Set<Id> userIdSet = new Set<Id>();
	for(PermissionSetAssignment oPermissionSetAssignment : [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name IN ('CH_BasicCaseHandling','CH_CaseHandler')]) {
		userIdSet.add(oPermissionSetAssignment.AssigneeId);
	}
	for(User userObj: [SELECT Id, Email FROM User WHERE (Profile.Name IN ('CH_Agent','CH_Case Handler','CH_Basic Case Handling') OR Id IN :userIdSet) AND Contact.CH_ContactType__c != 'Secondary Account' AND IsActive = true AND Email IN :ownerEmailIds]) {
		emailOwnerIdMap.put(userObj.Email, userObj.Id);
	}	
			}
			// Get all pricebook by its name
			Map<String, Id> pricebookMap = new Map<String, Id>();
			if(!priceBookNames.isEmpty()) {
	for(Pricebook2 pricebookObj: [SELECT Id, Name FROM Pricebook2 WHERE Name IN :pricebookNames]) {
		pricebookMap.put(pricebookObj.Name, pricebookObj.Id);
	}	
			}
			// Iterate newContractList againt to set lookup fields Id
			for(ServiceContract contractObj: newContractList) {
	if(emailOwnerIdMap.containsKey(contractObj.CH_CAPM_EmailAddress__c)) {
		contractObj.OwnerId = emailOwnerIdMap.get(contractObj.CH_CAPM_EmailAddress__c);
	}
	else {
		if(!iPAASUser.isEmpty()){
			contractObj.OwnerId = iPAASUser.get(0).Id;
		}
		else throw new AuraHandledException('No iPAAS User found on the system.');
	}
	if(pricebookMap.get(contractObj.CH_PriceBook__c) != null) {
		contractObj.Pricebook2Id = pricebookMap.get(contractObj.CH_PriceBook__c);
	}
			}
		}
	}
	
	/********************
	* Method Name: updateLookupIds
	* Parameter: ServiceContract
	* Description: Used to update lookup fields Id coming from Interface/CDB/CARES
	* Reference: NOKIASC-10907
	*******************/
	public static void updateLookupIds(Map < Id, ServiceContract > oldContractMap, List < ServiceContract > newContractList) {
		if(newContractList != null && !newContractList.isEmpty()) {
			List < ServiceContract > contractList = new List < ServiceContract > ();
			for(ServiceContract contractObj: newContractList) {
	if(oldContractMap != null && oldContractMap.get(contractObj.Id) != null) {
		ServiceContract oldContractObj = oldContractMap.get(contractObj.Id);
		if(oldContractObj.CH_CAPM_EmailAddress__c != contractObj.CH_CAPM_EmailAddress__c || oldContractObj.CH_PriceBook__c != contractObj.CH_PriceBook__c) {
			contractList.add(contractObj);
		}
	}
			}
			// Check if contractList has any records or not to process
			if(!contractList.isEmpty()) {
	populateLookupIds(contractList);
			}
		}
	}
	
	/********************
	* Method Name: ServiceContractSharing
	* Parameter: ServiceContract
	* Description: Used to share Service Contract records with Public Groups
	* Reference: NOKIASC-4372, NOKIASC-22868
	*******************/
	public static void ServiceContractSharing(Map<Id, ServiceContract> oldContractMap, Map<Id, ServiceContract> newContractMap) {
		Set<Id> accountId = new Set<Id>();
		Set<Id> contractsId = new Set<Id>();
		Map<Id, Id> contractAccountToRemove = new Map<Id, Id>();
		Map<Id, Id> contractAccountToAdd = new Map<Id, Id>();
		// Add all Contract Ids to one list
		if(oldContractMap != null && !oldContractMap.isEmpty()) contractsId.addAll(oldContractMap.keySet());
		if(newContractMap != null && !newContractMap.isEmpty()) contractsId.addAll(newContractMap.keySet());
		// Sort Contracts and respective Accounts to the maps
		for(Id contractId: contractsId) {
			ServiceContract oldContract = oldContractMap != null && oldContractMap.containsKey(contractId)?oldContractMap.get(contractId):null;
			ServiceContract newContract = newContractMap != null && newContractMap.containsKey(contractId)?newContractMap.get(contractId):null;
			if(oldContract != null && oldContract.AccountId != null){
	if(newContract == null || (newContract != null && (!oldContract.AccountId.equals(newContract.AccountId) || !oldContract.OwnerId.equals(newContract.OwnerId)))) {
		accountId.add(oldContract.AccountId);
		contractAccountToRemove.put(contractId, oldContract.AccountId);
		if(newContract != null && newContract.AccountId != null) {
			accountId.add(newContract.AccountId);
			contractAccountToAdd.put(contractId, newContract.AccountId);
		} 
	}	
			} else {
	if(newContract != null && newContract.AccountId != null){
		accountId.add(newContract.AccountId);
		contractAccountToAdd.put(contractId, newContract.AccountId);
	}
			}
		}
		if(!accountId.isEmpty()) {
			// Get Account Customer_Compliance__c field to check Public Group access
			Map<Id, Account> accountMap = new Map <Id, Account>([SELECT Id, Customer_Compliance__c FROM Account WHERE Id IN :accountId]);
			//
			Map<String, CH_SecurityGroups__c> securityGroupMap = CH_SecurityGroups__c.getAll();
			if(!securityGroupMap.isEmpty()) {
	Map<String, Set<Id>> customerComplianceToIds = new Map<String, Set<Id>>();
	Map<String, String> groupNameToCustomerCompliance = new Map<String, String>();
	// Build the customerComplianceToIds & groupNameToCustomerCompliance Maps
	for(String name: securityGroupMap.keySet()) {
		CH_SecurityGroups__c curSecurityGroups = securityGroupMap.get(name);
		if(curSecurityGroups.CH_CustomerCompliance__c != null && !curSecurityGroups.CH_CustomerCompliance__c.equals('')) {
			groupNameToCustomerCompliance.put(curSecurityGroups.GroupName__c, curSecurityGroups.CH_CustomerCompliance__c);
			customerComplianceToIds.put(curSecurityGroups.CH_CustomerCompliance__c, new Set<Id>());
		}
	}
	// Add the Security Group Ids to the correspondent Customer Compliance
	for(Group oGroup: [SELECT Id, DeveloperName FROM Group WHERE DeveloperName IN :groupNameToCustomerCompliance.keySet()]) {
		String customerCompliance = groupNameToCustomerCompliance.get(oGroup.DeveloperName);
		if(customerCompliance.equals('ALL')) {
			for(String name: groupNameToCustomerCompliance.keySet()) {
	String customerComplianceToAddAll = groupNameToCustomerCompliance.get(name);
	if(!customerComplianceToAddAll.equals('ALL')) {
		Set<Id> securityGroupsId = customerComplianceToIds.get(customerComplianceToAddAll);
		securityGroupsId.add(oGroup.Id);
		customerComplianceToIds.put(customerComplianceToAddAll, securityGroupsId);
		
	}
			}
		}
		else {
			Set<Id> securityGroupsId = customerComplianceToIds.get(customerCompliance);
			securityGroupsId.add(oGroup.Id);
			customerComplianceToIds.put(customerCompliance, securityGroupsId);
		}
	}
	// Adding sharing from the Security Groups to the Service Contract to a list
	List<ServiceContractShare> contractsToShareList = new List<ServiceContractShare>();
	List<ServiceContractShare> contractsToRemoveShareList = new List<ServiceContractShare>();
	for(Id contractId : contractsId) {
		if(contractAccountToRemove.containsKey(contractId)) {
			String customerCompliance = accountMap.get(contractAccountToRemove.get(contractId)).Customer_Compliance__c;
			if(customerCompliance != null && !customerCompliance.equals('')) {
	for(Id groupId: customerComplianceToIds.containsKey(customerCompliance)?customerComplianceToIds.get(customerCompliance):customerComplianceToIds.get('OTHER')) {
		ServiceContractShare oContractShare = new ServiceContractShare();	
		oContractShare.AccessLevel = 'Read';	
		oContractShare.ParentId = contractId;
		oContractShare.UserOrGroupId = groupId;
		contractsToRemoveShareList.add(oContractShare);	
	}
			}
		}
		if(contractAccountToAdd.containsKey(contractId)) {
			String customerCompliance = accountMap.get(contractAccountToAdd.get(contractId)).Customer_Compliance__c;
			if(customerCompliance != null && !customerCompliance.equals('')) {
	for(Id groupId: customerComplianceToIds.containsKey(customerCompliance)?customerComplianceToIds.get(customerCompliance):customerComplianceToIds.get('OTHER')) {
		ServiceContractShare oContractShare = new ServiceContractShare();	
		oContractShare.AccessLevel = 'Read';	
		oContractShare.ParentId = contractId;
		oContractShare.UserOrGroupId = groupId;
		contractsToShareList.add(oContractShare);	
	}
			}
		}
	}
	// Delete the Sharing List
	if(contractsToRemoveShareList != null && !contractsToRemoveShareList.isEmpty()) {
		upsert contractsToRemoveShareList;
		delete contractsToRemoveShareList;
	}
	// Insert the Sharing list
	if(contractsToShareList != null && !contractsToShareList.isEmpty()) {
		insert contractsToShareList;		
	}
			}
		}
	}
	
  /********************
	* Method Name: updateHWSPortal
	* Parameter: Map < Id, ServiceContract >
	* Description: Used to update HWS Portal field on ServiceContract with Previous service contract ID
	* Reference: NOKIASC-4316
	*******************/
	public static void updateHWSPortal(List < ServiceContract > newServiceContract) {
		if(newServiceContract != null && !newServiceContract.isEmpty()) {
			if(newServiceContract[0].CH_CDB_PreviousContractId__c != null && !newServiceContract[0].CH_CDB_PreviousContractId__c.CONTAINS(',') ){
			List < ServiceContract > entList = [SELECT Id, CH_CDB_ContractId__c, CH_PortalCaseCreationHWS__c, CH_PortalCaseCreationSWMaintenance__c, CH_SWS_Survey__c  FROM ServiceContract WHERE CH_CDB_ContractId__c = :newServiceContract[0].CH_CDB_PreviousContractId__c];
			
			//System.debug('####Step1 ' + entList[0].CH_CDB_ContractId__c);
			
			if(entList != null && !entList.isEmpty()) {
	List < ServiceContract > contractList = new List < ServiceContract > ();
	for(ServiceContract entObj: entList) {
			ServiceContract contractObj = (newServiceContract[0]).clone(true, true, false, true);
			contractObj.CH_PortalCaseCreationHWS__c = entList[0].CH_PortalCaseCreationHWS__c;
			contractObj.CH_PortalCaseCreationSWMaintenance__c = entList[0].CH_PortalCaseCreationSWMaintenance__c;
			contractObj.CH_SWS_Survey__c = entList[0].CH_SWS_Survey__c;
			//
			//System.debug('####CH_PortalCaseCreationHWS__c ' + contractObj.CH_PortalCaseCreationHWS__c);
			//System.debug('####CH_PortalCaseCreationSWMaintenance__c ' + contractObj.CH_PortalCaseCreationSWMaintenance__c);
			//System.debug('####CH_SWS_Survey__c ' + contractObj.CH_SWS_Survey__c);
			//
			contractList.add(contractObj);
	}
	if(!contractList.isEmpty()) {
		try {

			Database.SaveResult[] srList = Database.update(contractList, false);

			// Iterate through each returned result
			for (Database.SaveResult sr : srList) {
	if (!sr.isSuccess()) {
		// Operation failed, so get all errors	
		for(Database.Error err : sr.getErrors()) {
			System.debug('#### Exception occurred at CH_ServiceContractTriggerHelper.updateAuthorizedEntitlementOnContract ### ' + err.getMessage());
		}
	}
			}

		} catch(Exception ex) {
			System.debug('#### ' + ex.getMessage());
		}
	}
			}
		}
			ELSE{
	List < ServiceContract > contractList = new List < ServiceContract > ();
	ServiceContract contractObj = (newServiceContract[0]).clone(true, true, false, true);
	contractObj.CH_PortalCaseCreationHWS__c = false;
	contractObj.CH_PortalCaseCreationSWMaintenance__c = false;
	contractObj.CH_SWS_Survey__c = 'Use Legal Entity Setting';  //NOKIASC-22344: Suniti
	//
	contractList.add(contractObj);
	//
	  if(!contractList.isEmpty()) {
		try {

			Database.SaveResult[] srList = Database.update(contractList, false);

			// Iterate through each returned result
			for (Database.SaveResult sr : srList) {
	if (!sr.isSuccess()) {
		// Operation failed, so get all errors	
		for(Database.Error err : sr.getErrors()) {
			System.debug('#### Exception occurred at CH_ServiceContractTriggerHelper.updateAuthorizedEntitlementOnContract ### ' + err.getMessage());
		}
	}
			}

		} catch(Exception ex) {
			System.debug('#### ' + ex.getMessage());
		}
	}
			}
		}
	}
}