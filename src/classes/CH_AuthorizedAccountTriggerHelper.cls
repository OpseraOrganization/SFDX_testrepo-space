/****************************************
 * Class Name : CH_AuthorizedAccountTriggerHelper 
 * Created Date: 13 September 2018
 * Created By : TCS
 * Last Modified by: TCS
 * Last Modified Date: 13 September 2018
 * Description : Contains common business logic
 * Test Class: CH_AuthorizedAccountTriggerTest
 *****************************************/
public without sharing class CH_AuthorizedAccountTriggerHelper {
	/********************
	* Method Name: duplicateRecordCheck
	* Parameter: List < CH_AuthorizedAccount__c >
	* Description: Used to check for duplicate record
	* Reference: NOKIASC-4316
	*******************/
	public static void duplicateRecordCheck(List < CH_AuthorizedAccount__c > newAuthorizedAccountList) {
		if(newAuthorizedAccountList != null && !newAuthorizedAccountList.isEmpty()) {
			Set < Id > accountIds = new Set < Id > ();
			Set < Id > contractIds = new Set < Id > ();
			for(CH_AuthorizedAccount__c authAccountObj: newAuthorizedAccountList) {
	accountIds.add(authAccountObj.CH_Account__c);
	contractIds.add(authAccountObj.CH_ServiceContract__c);
			}
			
			// To check for existing records
			Map < String, CH_AuthorizedAccount__c > authAccountMap = new Map < String, CH_AuthorizedAccount__c > ();
			List < CH_AuthorizedAccount__c > authAccountList = [SELECT Id, CH_Account__c, CH_ServiceContract__c FROM CH_AuthorizedAccount__c WHERE CH_Account__c IN :accountIds AND CH_ServiceContract__c IN :contractIds];
			if(authAccountList != null && !authAccountList.isEmpty()) {
	for(CH_AuthorizedAccount__c authAccountObj: authAccountList) {
		authAccountMap.put(getUniqueKey(authAccountObj), authAccountObj);   
	}	
			}
			
			// Check for existing records with new records
			for(CH_AuthorizedAccount__c authAccountObj: newAuthorizedAccountList) {
	if(authAccountMap.containsKey(getUniqueKey(authAccountObj))) {
		//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
					authAccountObj.addError(System.Label.CH_Selected_Authorized_Account_Duplicate_Entry);
	}
			}
		}
	}
	
	/********************
	* Method Name: getUniqueKey
	* Parameter: CH_AuthorizedAccount__c
	* Description: Used to prepare unique key for checking duplicate record
	* Reference: NOKIASC-4316
	*******************/
	private static String getUniqueKey(CH_AuthorizedAccount__c authAccountObj) {
		if(String.isBlank(authAccountObj.CH_Account__c) || String.isBlank(authAccountObj.CH_ServiceContract__c)) {
			//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
			authAccountObj.addError(System.Label.CH_Account_Service_Contract_Not_Found);
		}
		return (authAccountObj.CH_Account__c + '-' + authAccountObj.CH_ServiceContract__c);
	}
	
	/********************
	* Method Name: createEntitlementContact
	* Parameter: CH_AuthorizedAccount__c
	* Description: Used to create EntitlementContact record of type NCP_Entitlement_Relationship__c = true
	* Reference: NOKIASC-4316
	*******************/
	public static void createEntitlementContact(List < CH_AuthorizedAccount__c > newAuthorizedAccountList) {
		if(newAuthorizedAccountList != null && !newAuthorizedAccountList.isEmpty()) {
			Set < Id > accountIds = new Set < Id > ();
			Set < Id > contractIds = new Set < Id > ();
			Set < Id > entitlementIds = new Set < Id > ();
			for(CH_AuthorizedAccount__c authAccountObj: newAuthorizedAccountList) {
	accountIds.add(authAccountObj.CH_Account__c);
	contractIds.add(authAccountObj.CH_ServiceContract__c);
	entitlementIds.add(authAccountObj.CH_EntitlementId__c);
			}
			if(!accountIds.isEmpty()) {
	// To fetch all contacts related to account of service contract
	Map < Id, List < Id >> accountContactsMap = new Map < Id, List < Id >> (); 
	Set < Id > contactIds = new Set < Id > ();
	List < AccountContactRelation > AccountContactRelationList = [SELECT Id, AccountId, ContactId, Contact.Firstname, Contact.Lastname FROM AccountContactRelation 
					 WHERE Account.RecordType.DeveloperName = 'Legal_Entity' AND AccountId IN :accountIds AND NCP_Entitlement_Relationship__c = true];
	if(AccountContactRelationList != null) {
		for(AccountContactRelation obj: AccountContactRelationList) {
			if(!String.isBlank(obj.Contact.Firstname) && !obj.Contact.Firstname.startsWith('DUP') && !String.isBlank(obj.Contact.Lastname) && !obj.Contact.Lastname.startsWith('DUP')){
				if(accountContactsMap.get(obj.accountId) != null) {
		accountContactsMap.get(obj.accountId).add(obj.ContactId);
				} else {
		accountContactsMap.put(obj.accountId, new List < Id > {obj.ContactId});
				}
				contactIds.add(obj.ContactId);
			}
		}	
	}
	
	if(!accountContactsMap.isEmpty()) {
		// Check for existing EntitlementContact records
		Map < String, EntitlementContact > existingEntContactMap = new Map < String, EntitlementContact > ();
		for(EntitlementContact entContactObj: [SELECT Id, EntitlementId, ContactId FROM EntitlementContact WHERE EntitlementId IN :entitlementIds AND ContactId IN :contactIds]) {
			existingEntContactMap.put(entContactObj.EntitlementId + '-' + entContactObj.ContactId, entContactObj);
		}
		
		List < EntitlementContact > entContactList = new List < EntitlementContact > ();
		for(CH_AuthorizedAccount__c authAccountObj: newAuthorizedAccountList) {
			if(String.isNotBlank(authAccountObj.CH_EntitlementId__c) && accountContactsMap.get(authAccountObj.CH_Account__c) != null) {
				for(Id contactId: accountContactsMap.get(authAccountObj.CH_Account__c)) {
		if(!existingEntContactMap.containsKey(authAccountObj.CH_EntitlementId__c + '-' + contactId)) {
			entContactList.add(new EntitlementContact(EntitlementId = authAccountObj.CH_EntitlementId__c, ContactId = contactId));	
		}
				}
				
			}
		}
		if(!entContactList.isEmpty()) {
			try {
				// Insert EntitlementContact list
				CH_EntitlementContactTriggerHandler.skipAuthorizationHistory = true;
				Database.SaveResult[] srList = Database.insert(entContactList, false);

				// Iterate through each returned result
				for (Database.SaveResult sr : srList) {
		if (!sr.isSuccess()) {
			// Operation failed, so get all errors	
			for(Database.Error err : sr.getErrors()) {
				System.debug('#### Exception occurred at CH_AuthorizedAccountTriggerHelper.createEntitlementContact ### ' + err.getMessage());
			}
		}
				}
			} catch(Exception ex) {
				System.debug('#### Exception occurred at CH_AuthorizedAccountTriggerHelper.createEntitlementContact ### ' + ex.getMessage());
			}
		}
	}
			}
		}
	}
	
	/********************
	* Method Name: updateEntitlementContact
	* Parameter: CH_AuthorizedAccount__c
	* Description: Used to update EntitlementContact record of type NCP_Entitlement_Relationship__c = true
	* Reference: NOKIASC-4316
	*******************/
	public static void updateEntitlementContact(Map < Id, CH_AuthorizedAccount__c > oldAuthorizedAccountMap, Map < Id, CH_AuthorizedAccount__c > newAuthorizedAccountMap) {
		if(newAuthorizedAccountMap != null && !newAuthorizedAccountMap.isEmpty() && oldAuthorizedAccountMap != null && !oldAuthorizedAccountMap.isEmpty()) {
			for(CH_AuthorizedAccount__c newAuthAccountObj: newAuthorizedAccountMap.values()) {
	CH_AuthorizedAccount__c oldAuthAccountObj = oldAuthorizedAccountMap.get(newAuthAccountObj.Id);
	if(oldAuthAccountObj != null && oldAuthAccountObj.CH_Account__c == newAuthAccountObj.CH_Account__c) {
		oldAuthorizedAccountMap.remove(newAuthAccountObj.Id);
		newAuthorizedAccountMap.remove(oldAuthAccountObj.Id);
		
	}
			}
			if(!oldAuthorizedAccountMap.isEmpty()) {
	// Delete all existing 
	deleteEntitlementContact(oldAuthorizedAccountMap.values());
			}
			if(!newAuthorizedAccountMap.isEmpty()) {
	// Create all EntitlementContact
	createEntitlementContact(newAuthorizedAccountMap.values());
			}
		}
	}
	
	/********************
	* Method Name: deleteEntitlementContact
	* Parameter: CH_AuthorizedAccount__c
	* Description: Used to delete EntitlementContact record of type NCP_Entitlement_Relationship__c = true
	* Reference: NOKIASC-4316
	*******************/	
	public static void deleteEntitlementContact(List < CH_AuthorizedAccount__c > oldAuthorizedAccountList) {
		if(oldAuthorizedAccountList != null &&  !oldAuthorizedAccountList.isEmpty()) {
			Set < Id > accountIds = new Set < Id > ();
			Set < Id > contractIds = new Set < Id > ();
			for(CH_AuthorizedAccount__c authAccountObj: oldAuthorizedAccountList) {
	accountIds.add(authAccountObj.CH_Account__c);
	contractIds.add(authAccountObj.CH_ServiceContract__c);
			}
			Set < Id > contactIds = new Set < Id > ();
			for(AccountContactRelation accContactObj: [SELECT ContactId FROM AccountContactRelation WHERE AccountId IN :accountIds AND NCP_Entitlement_Relationship__c = true]) {
	contactIds.add(accContactObj.ContactId);
			}
			List < EntitlementContact > entContactList = [SELECT Id FROM EntitlementContact WHERE Entitlement.ServiceContractId IN :contractIds AND ContactId IN :contactIds];
			if(entContactList != null && !entContactList.isEmpty()) {
	try {
		// Delete entitlement contact list
					CH_EntitlementContactTriggerHandler.skipAuthorizationHistory = true;
		Database.DeleteResult[] drList = Database.delete(entContactList, false);
		
		// Iterate through each returned result
		for(Database.DeleteResult dr : drList) {
			if (!dr.isSuccess()) {
				// Operation failed, so get all errors	
				for(Database.Error err : dr.getErrors()) {	  
		System.debug('#### Exception occurred at CH_AuthorizedAccountTriggerHelper.deleteEntitlementContact ### ' + err.getMessage());
				}
			}
		}
	} catch(Exception ex) {
		System.debug('#### Exception occurred at CH_AuthorizedAccountTriggerHelper.deleteEntitlementContact ### ' + ex.getMessage());
	}
			}
		}
	}
}