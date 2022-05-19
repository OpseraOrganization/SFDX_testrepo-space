/*****************************************
* Class Name : CH_ServiceContractTriggerHelper 
* Created Date: 08 August 2018
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 09 August 2018
* Description : Contains common business logic
* Test Class: CH_ServiceContractTriggerTest
*****************************************/
public without sharing class CH_ServiceContractTriggerHelper {
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
									
									authAccountSet.add(
										new CH_AuthorizedAccount__c(CH_Account__c = authAccountObj.CH_Account__c, CH_ServiceContract__c = contractObj.Id, CH_IsTriggerRun__c = false)	
									);	
									
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
						Database.insert(new List < CH_AuthorizedAccount__c > (authAccountList) , false);
						
					} catch(Exception ex) {
						//Do Nothing
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
			
			Set < String > previousCDBContractIds = new Set < String > ();
			Set < String > newCDBContractIds = new Set < String > ();
			for(ServiceContract contractObj: newContractList) {
				if(String.isNotBlank(contractObj.CH_CDB_PreviousContractId__c)) {
					
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
						Database.insert(createEntContactList, false);
						
					} catch(Exception ex) {
						//Do Nothing
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
						Database.insert(newEntList, false);
						
					} catch(Exception ex) {
						//Do Nothing
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
						Database.update(contractList, false);
						// Create EntitlementContact Record
						// createEntitlementContact(contractList);
					} catch(Exception ex) {
						//Do Nothing
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
					Database.insert(authAccountList, false);
					
				} catch(Exception ex) {
					//Do Nothing
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
		entObj.RecordTypeId = Schema.SObjectType.Entitlement.getRecordTypeInfosByDeveloperName().get('CH_Entitlement').getRecordTypeId();
		entObj.Name = contractObj.Name + ' - Authorized Contact';
		entObj.ServiceContractId = contractObj.Id;
		entObj.AccountId = contractObj.AccountId;
		entObj.CH_EntitlementType__c = 'Authorized Contact';
		entObj.CH_CDB_EntitlementId__c = '1';
		
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
		List < ServiceContract > entList;
		//Last Modified Modified Date US
		//Prachi Jain 02/16/2022  //NOKIASC-39825 - Updated this for accomadating renewed contracts
		if(newServiceContract[0].CH_CDB_PreviousContractId__c != null && !newServiceContract[0].CH_CDB_PreviousContractId__c.CONTAINS(',') ){
			entList = [SELECT Id, CH_CDB_ContractId__c, CH_CDB_ContractType__c,CH_PortalCaseCreationHWS__c, CH_PortalCaseCreationSWMaintenance__c, CH_SWS_Survey__c, CH_Allow_Competitor_Authorized_Contacts__c FROM ServiceContract WHERE CH_CDB_ContractId__c = :newServiceContract[0].CH_CDB_PreviousContractId__c];
		}
			
			
		List < ServiceContract > contractList = new List < ServiceContract > ();
		if(entList != null && !entList.isEmpty()) {
			for(ServiceContract entObj: entList) {
				ServiceContract contractObj = (newServiceContract[0]).clone(true, true, false, true);
				contractObj.CH_PortalCaseCreationHWS__c = entList[0].CH_PortalCaseCreationHWS__c;
				contractObj.CH_PortalCaseCreationSWMaintenance__c = entList[0].CH_PortalCaseCreationSWMaintenance__c;
				contractObj.CH_SWS_Survey__c = entList[0].CH_SWS_Survey__c;
				contractObj.CH_Allow_Competitor_Authorized_Contacts__c = entList[0].CH_Allow_Competitor_Authorized_Contacts__c;//Added by Soham for SP Changes for Horizontal User
				contractList.add(contractObj);
			}
		   
		}
		ELSE{
			ServiceContract contractObj = (newServiceContract[0]).clone(true, true, false, true);
			//NOKIASC-39825 - R22.3
			contractObj.CH_PortalCaseCreationHWS__c = false;
			contractObj.CH_PortalCaseCreationSWMaintenance__c = true;
			contractObj.CH_SWS_Survey__c = 'Use Legal Entity Setting';  //NOKIASC-22344: Suniti
			//
			contractList.add(contractObj);
		}
		if(!contractList.isEmpty()) {
			try {
				Database.update(contractList, false);
				
			} catch(Exception ex) {
				//Do Nothing
			}
		}
	}
}
	/********************
* Method Name: validateVendorContractOwner
* Parameter: VendorServiceContract
* Description: 
* Reference: NOKIASC-31035
*******************/
	public static void validateVendorContractOwner(Map < Id, ServiceContract > oldContractMap, List < ServiceContract > newContractList) 
	{
		try{
			if(newContractList != null && !newContractList.isEmpty()) 
			{
				
				Map<ServiceContract,Id> contractOwnerMap = new Map<ServiceContract,Id>();
				for(ServiceContract contractObj: newContractList) 
				{
					String recordTypeName = Schema.getGlobalDescribe().get('ServiceContract').getDescribe().getRecordTypeInfosById().get(contractObj.RecordTypeId).getName();
					//Add Vendor Recordtype Check
					if(recordTypeName=='Vendor Contract')
					{
						if(oldContractMap != null && oldContractMap.get(contractObj.Id) != null) 
						{
							ServiceContract oldContractObj = oldContractMap.get(contractObj.Id);
							if(contractObj.OwnerId != oldContractObj.OwnerId) 
							{
								contractOwnerMap.put(contractObj,contractObj.OwnerId);
							}
						}
						else
						{
							contractOwnerMap.put(contractObj,contractObj.OwnerId);
						}
					}
				}
				List<string> permissionSetnName = new List<string>();
				permissionSetnName.add(Label.CH_VendorCCM); 
				permissionSetnName.add(Label.CH_VendorPermissionDVT); 
				permissionSetnName.add(Label.CH_VendorCM);
				String sysadmin = Label.System_Admin_Profile;
				if(!contractOwnerMap.values().isEmpty()) 
				{
					Map<Id,PermissionSetAssignment> permMap= new Map<Id,PermissionSetAssignment>([SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN :contractOwnerMap.values() AND PermissionSet.Label IN :permissionSetnName]);
					Set<Id> permMapIds=new Set<Id>();
					for(PermissionSetAssignment pm:permMap.values())
					{
						permMapIds.add(pm.AssigneeId);
					}
					//Query Permission set and Add error Messgae.
					Map<Id,User> profMap=new Map<Id,User>([SELECT Id FROM User where Profile.Name=:sysadmin AND Id in :contractOwnerMap.values()]);
					Set<Id> userlist= new Set<Id>();
					userlist.addAll(contractOwnerMap.values());
					userlist.removeAll(permMapIds);
					userlist.removeAll(profMap.keySet());
					if(!contractOwnerMap.isEmpty() && !userlist.isEmpty())
					{
						for(ServiceContract sc : contractOwnerMap.keySet())
						{
							if(userlist.contains(sc.OwnerId))
							{
								sc.CH_ServiceContractOwner__c.addError(Label.CH_VendorOwnerErrorMessage); 
							}
						}
					}
				}
			}
		}
		catch(Exception e)
		{
			//Do Nothing
		}
	}
	
	Public Static void updateAuthorizedContact(Map<Id, ServiceContract> oldContractMap, List<ServiceContract> newContractList){
		List<EntitlementContact> lstEntitlementContacts=new List<EntitlementContact>();
		String ipaasUserId = System.Label.CH_IPaas_User_Id;
		Map<Id,Id> oldContractOwnerMap = new Map<Id,Id>();
		Map<Id,ServiceContract> oldContractRecordMap = new Map<Id,ServiceContract>();
		Map<Id,ServiceContract> newContractOwnerMap = new Map<Id,ServiceContract>();
		Map<Id,String> newContractEmailMap = new Map<Id,String>();
		Map<Id,String> getOldUserRecords=new Map<Id,String>();
		Map<Id,String> getOldServiceContactEmails=new Map<Id,String>();
		List<EntitlementContact> delEntRec=new List<EntitlementContact>();
		if(newContractList != null && !newContractList.isEmpty()){
			for(ServiceContract contractObj: newContractList) 
			{
				if(oldContractMap != null && oldContractMap.get(contractObj.Id) != null) 
				{
					ServiceContract oldContractObj = oldContractMap.get(contractObj.Id);
					if(contractObj.OwnerId != oldContractObj.OwnerId) 
					{   //If the old User is Ipass User no need to remove records from the Authorized Contacts
						if(oldContractObj.OwnerId!=ipaasUserId){oldContractOwnerMap.put(oldContractObj.Id,oldContractObj.OwnerId);
																oldContractRecordMap.put(oldContractObj.Id,oldContractObj);
															   }
						//If the new User is Ipass User no need to Add records to the Authorized Contacts
						if(contractObj.OwnerId!=ipaasUserId){newContractOwnerMap.put(contractObj.Id,contractObj); }
					}
				}
			}
			//Insert the Entitlement Contact Records on Change of the Service Contract Owner
			if(!newContractOwnerMap.values().isEmpty()) 
			{
				for(ServiceContract getServiceContactRec:[Select Id , Owner.email from ServiceContract where ID IN : newContractOwnerMap.KeySet()]){
					newContractEmailMap.put(getServiceContactRec.Id,getServiceContactRec.Owner.email);
				}
				if(!newContractEmailMap.values().IsEmpty() && newContractEmailMap.size()>0){
					//key is Email and value is Contact Id 
					Map<String,Id> contactMap=new Map<String,Id>();
					for(contact getContactList:[SELECT Id,Email FROM Contact where Email IN :newContractEmailMap.Values() 
												AND Contact.CH_ContactType__c != 'Secondary Account']){
													contactMap.put(getContactList.Email,getContactList.ID);
												}
					if(contactMap !=null && !contactMap.values().isEmpty()){
						for(String contractId : newContractOwnerMap.keyset()){
							ServiceContract srvConLst = newContractOwnerMap.get(contractId);
							String getConEmail=newContractEmailMap.get(contractId);
							if(contactMap.containskey(getConEmail)){//Pass ownerEmail with new Query
								EntitlementContact entitleCon=new EntitlementContact();
								entitleCon.ContactId=contactMap.get(getConEmail);
								entitleCon.EntitlementId=srvConLst.CH_Entitlement__c;
								lstEntitlementContacts.add(entitleCon); 
							}else{	//Create Contact Record
							}
						}
						
						
					}
				}
			}
			
			//Delete the Entitlement Contact Records on Change of the Service Contract Owner
			system.debug('## Size of the oldContractOwnerMap : '+oldContractOwnerMap.Size());
			if(!oldContractOwnerMap.values().IsEmpty()){
				for(User getUserDet:[Select Id,Email from user where Id in :oldContractOwnerMap.Values()]){
					getOldUserRecords.put(getUserDet.Id,getUserDet.Email);
				}
				if(!getOldUserRecords.values().IsEmpty() ){
					for(ServiceContract getserConDet:oldContractRecordMap.Values()){
						if(getOldUserRecords.containsKey(getserConDet.ownerID)){
							//Map Contains Key as Service Contract Id and Value as Old User Email 
							getOldServiceContactEmails.put(getserConDet.Id,getOldUserRecords.get(getserConDet.ownerID));
						}
					}
					if(!getOldServiceContactEmails.values().IsEmpty() ){
						List<EntitlementContact> getEnConRecords=[Select id , entitlementID, ContactID, Entitlement.ServiceContract.NAme, contact.Email,
																  Entitlement.ServiceContract.owner.Email,Entitlement.ServiceContractId from EntitlementContact
																  where Entitlement.ServiceContractId IN : oldContractOwnerMap.Keyset()];
						
						
						for(EntitlementContact entContact : getEnConRecords){
							string getOldEmail=getOldServiceContactEmails.get(entContact.Entitlement.ServiceContractId);
							if(getOldServiceContactEmails.containskey(entContact.Entitlement.ServiceContractId) && getOldEmail==entContact.contact.Email){
								delEntRec.add(entContact);
							}
						}
					}
				}
			}
			system.debug('## Size of the creating EnConRecords : '+lstEntitlementContacts.Size());
			system.debug('## Size of the deleting Entitlement Contact Records : '+delEntRec.Size());
			if(!lstEntitlementContacts.isEmpty()) {
				try {  // Insert EntitlementContact list
					Database.insert(lstEntitlementContacts, false);
				} catch(Exception ex) { //Do Nothing ]
				}
			}
			if(!delEntRec.isEmpty()) {
				try {
					// Delete the  EntitlementContact list
					Database.Delete(delEntRec, false);
				} catch(Exception ex) {
					//Do Nothing
				}
			}
			
		}
	}
	
	
	Public Static void createAuthorizedContact(Map <Id, ServiceContract > newContractList) {
		String ipaasUserId = System.Label.CH_IPaas_User_Id;
		Map<Id,String> newContractEmailMap=new Map<Id,String>(); 
		Map<String,Id> contactMap=new Map<String,Id>();
		Map<Id,ServiceContract> newContractOwnerMap=new Map<id,ServiceContract>();
		List<EntitlementContact> lstEntitlementContacts=new List<EntitlementContact>();
		if(!newContractList.isEmpty()) {
			for(ServiceContract getServiceContactRec:[Select Id , Owner.Email,OwnerID,CH_Entitlement__c from ServiceContract where ID IN :newContractList.KeySet() ]){
				if(getServiceContactRec.ownerId!=ipaasUserId){newContractEmailMap.put(getServiceContactRec.Id,getServiceContactRec.Owner.Email);
															  newContractOwnerMap.put(getServiceContactRec.id,getServiceContactRec);}
			}
			if(!newContractEmailMap.isEmpty() && !newContractOwnerMap.isEmpty()){
				for(contact getContactList:[SELECT Id,Email FROM Contact where Email IN :newContractEmailMap.Values() 
											AND Contact.CH_ContactType__c != 'Secondary Account']){
												contactMap.put(getContactList.Email,getContactList.ID);
											}
				system.debug('## Size of the contactMap : '+contactMap.Size());
				if(contactMap !=null && !contactMap.values().isEmpty()){
					for(String contractId : newContractOwnerMap.keyset()){
						ServiceContract srvConLst = newContractOwnerMap.get(contractId);
						String getConEmail=newContractEmailMap.get(contractId);
						system.debug('## Size of the srvConLst : '+ srvConLst);
						system.debug('## Size of the Owner : '+ getConEmail);
						if(contactMap.containskey(getConEmail)){//Pass ownerEmail with new Query
							EntitlementContact entitleCon=new EntitlementContact();
							entitleCon.ContactId=contactMap.get(getConEmail);
							entitleCon.EntitlementId=srvConLst.CH_Entitlement__c;
							lstEntitlementContacts.add(entitleCon); 
						}else{	//Create Contact Record
						}
					}
				}
			}
		}
		System.debug('## lstEntitlementContacts : '+lstEntitlementContacts.Size());
		if(!lstEntitlementContacts.isEmpty()) {
			try {  // Insert EntitlementContact list
				Database.insert(lstEntitlementContacts, false);
			} catch(Exception ex) { //Do Nothing ]
			}
		}
	}
	public static void deleteCompetitorAC(Map <Id, ServiceContract> oldSCMap, Map <Id, ServiceContract> newSCMap){
		List<EntitlementContact> ecToBeDeletedList = new List<EntitlementContact>();
		Set<Id> updatedSCIds = new Set<Id>();
		for(ServiceContract sc : oldSCMap.values()){
			if(sc.CH_Allow_Competitor_Authorized_Contacts__c != newSCMap.get(sc.Id).CH_Allow_Competitor_Authorized_Contacts__c && !newSCMap.get(sc.Id).CH_Allow_Competitor_Authorized_Contacts__c){//"Allow Competitor Authorized Contacts" field value has been disabled
				updatedSCIds.add(sc.Id);
			}
		}
		if(!updatedSCIds.isEmpty()){
			for(EntitlementContact ec : [SELECT Id
										 FROM EntitlementContact
										 WHERE Entitlement.ServiceContractId != NULL AND 
											   Entitlement.ServiceContractId IN :updatedSCIds AND 
											   Contact.NCP_Competitor__c = true]){
				ecToBeDeletedList.add(ec);
			}
			if(!ecToBeDeletedList.isEmpty()){
				delete ecToBeDeletedList;
			}
		}
	}
}