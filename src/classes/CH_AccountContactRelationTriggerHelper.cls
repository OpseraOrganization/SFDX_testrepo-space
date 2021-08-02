/****************************************
 * Class Name : CH_AccountContactRelationTriggerHelper 
 * Created Date: 14 September 2018
 * Created By : TCS
 * Last Modified by: TCS
 * Last Modified Date: 20 March 2019
 * Description : Contains common business logic
 * Test Class: CH_AccountContactRelationTriggerTest
 *****************************************/
public class CH_AccountContactRelationTriggerHelper {
	/********************
	* Method Name: createEntitlementContact
	* Parameter: CH_AuthorizedAccount__c
	* Description: Used to create EntitlementContact record of type NCP_Entitlement_Relationship__c = true
	* Reference: NOKIASC-4316
	*******************/
	public static void createEntitlementContact(List < AccountContactRelation > newAccountContactList) {
		if(newAccountContactList!= null && !newAccountContactList.isEmpty()) {
			Map < Id, List < AccountContactRelation >> accountContactRelationMap = new Map < Id, List < AccountContactRelation >> ();
			Set < Id > contactIds = new Set < Id > ();
			for(AccountContactRelation sObj: newAccountContactList) {
	if(sObj.NCP_Entitlement_Relationship__c) {
		if(accountContactRelationMap.containsKey(sObj.AccountId)) {
		accountContactRelationMap.get(sObj.AccountId).add(sObj); 
		} else {
		accountContactRelationMap.put(sObj.AccountId, new List < AccountContactRelation > { sObj }); 
		}
		contactIds.add(sObj.ContactId);
	}		
			}
			if(!accountContactRelationMap.isEmpty()) {
	Map<Id, Contact> contactsMap = new Map<Id, Contact>([select id, FirstName, LastName from Contact where id IN : contactIds]);
	Set < Id > entitlementIds = new Set < Id > ();
	List < CH_AuthorizedAccount__c > authAccountList = [SELECT Id, CH_Account__c, CH_ServiceContract__c, CH_EntitlementId__c FROM CH_AuthorizedAccount__c WHERE CH_Account__c IN :accountContactRelationMap.keySet() AND CH_Account__r.RecordType.DeveloperName = 'Legal_Entity'];
	if(authAccountList != null && !authAccountList.isEmpty()) {
		for(CH_AuthorizedAccount__c authAccountObj: authAccountList) {
			entitlementIds.add(authAccountObj.CH_EntitlementId__c);
		}
		if(!entitlementIds.isEmpty()) {
			List < EntitlementContact > entContactList = new List < EntitlementContact > ();
			for(CH_AuthorizedAccount__c authAccountObj: authAccountList) {
				if(String.isNotBlank(authAccountObj.CH_EntitlementId__c)) {
		if(accountContactRelationMap.containsKey(authAccountObj.CH_Account__c)) {
			for(AccountContactRelation sObj: accountContactRelationMap.get(authAccountObj.CH_Account__c)) {
				if(contactsMap.containskey(sObj.ContactId) && 
			 !String.isBlank(contactsMap.get(sObj.ContactId).FirstName) && !contactsMap.get(sObj.ContactId).FirstName.startsWith('DUP') && 
			 !String.isBlank(contactsMap.get(sObj.ContactId).Lastname) && !contactsMap.get(sObj.ContactId).Lastname.startsWith('DUP')){
			 
			  entContactList.add(new EntitlementContact(EntitlementId = authAccountObj.CH_EntitlementId__c, ContactId = sObj.ContactId));
				} 
			}
		}	
				}
			}
			if(!entContactList.isEmpty()) {
				try {
		// Insert EntitlementContact list
		Database.SaveResult[] srList = Database.insert(entContactList, false);
	
		// Iterate through each returned result
		for (Database.SaveResult sr : srList) {
			if (!sr.isSuccess()) {
				// Operation failed, so get all errors	
				for(Database.Error err : sr.getErrors()) {
					System.debug('#### Exception occurred at CH_AccountContactRelationTriggerHelper.createEntitlementContact ### ' + err.getMessage());
				}
			}
		}
				} catch(Exception ex) {
		System.debug('#### Exception occurrred at CH_AccountContactRelationTriggerHelper.createEntitlementContact ### ' + ex.getMessage());
				}
			}   
		}
	}
			}
		}
	}
	
	/********************
	* Method Name: updateEntitlementContact
	* Parameter: CH_AuthorizedAccount__c
	* Description: Used to add/remove EntitlementContact record depending on NCP_Entitlement_Relationship__c flag
	* Reference: NOKIASC-4316
	*******************/
	public static void updateEntitlementContact(Map < Id, AccountContactRelation > oldAccountContactMap, Map < Id, AccountContactRelation > newAccountContactMap) {
		if(newAccountContactMap != null && !newAccountContactMap.isEmpty() && oldAccountContactMap != null && !oldAccountContactMap.isEmpty()) {
			List < AccountContactRelation > deleteList = new List < AccountContactRelation > ();
			List < AccountContactRelation > createList = new List < AccountContactRelation > ();
			Set < Id > contactIds = new Set < Id > ();
			for(AccountContactRelation newAccountContactObj: newAccountContactMap.values()) {
	AccountContactRelation oldAccountContactObj = oldAccountContactMap.get(newAccountContactObj.Id);
	if(oldAccountContactObj != null) {
		if(oldAccountContactObj.NCP_Entitlement_Relationship__c != newAccountContactObj.NCP_Entitlement_Relationship__c) {
			if(newAccountContactObj.NCP_Entitlement_Relationship__c) {
				createList.add(newAccountContactObj);
			} else if(!newAccountContactObj.NCP_Entitlement_Relationship__c) {
				// NOKIASC-14643 - To update CH_Legal_Entity_Name__c when account contact relation flag is updated
				contactIds.add(newAccountContactObj.ContactId);
							deleteList.add(newAccountContactObj);
			} else {
				deleteList.add(newAccountContactObj);
			}
		} 
	}
			}
			if(!deleteList.isEmpty()) {
	// Delete all existing 
	deleteEntitlementContact(deleteList);
			}
			if(!createList.isEmpty()) {
	// Create all EntitlementContact
	createEntitlementContact(createList);
			}
			// NOKIASC-14643 - To update CH_Legal_Entity_Name__c when account contact relation record is deleted
			if(!contactIds.isEmpty()) {
	setLegalEntityBlank(contactIds);
			}
		}
	}
	
	/********************
	* Method Name: deleteEntitlementContact
	* Parameter: CH_AuthorizedAccount__c
	* Description: Used to delete EntitlementContact record of type NCP_Entitlement_Relationship__c = true
	* Reference: NOKIASC-4316
	*******************/
	public static void deleteEntitlementContact(List < AccountContactRelation > oldAccountContactList) {
		if(oldAccountContactList != null &&  !oldAccountContactList.isEmpty()) {
			Set < Id > accountIds = new Set < Id > ();
			Set < Id > contactIds = new Set < Id > ();
			for(AccountContactRelation sObj: oldAccountContactList) {
	accountIds.add(sObj.AccountId);
	contactIds.add(sObj.ContactId);
			}
			Set < Id > entitlementIds = new Set < Id > ();
			for(CH_AuthorizedAccount__c authAccountObj: [SELECT Id, CH_EntitlementId__c FROM CH_AuthorizedAccount__c WHERE CH_Account__c IN :accountIds AND CH_Account__r.RecordType.DeveloperName = 'Legal_Entity']) {
	if(String.isNotBlank(authAccountObj.CH_EntitlementId__c)) {
		entitlementIds.add(authAccountObj.CH_EntitlementId__c);
	}
			}	
			List < EntitlementContact > entContactList = [SELECT Id FROM EntitlementContact WHERE EntitlementId IN :entitlementIds AND ContactId IN :contactIds];
			if(entContactList != null && !entContactList.isEmpty()) {
	try {
		// Delete entitlement contact list
		Database.DeleteResult[] drList = Database.delete(entContactList, false);
		
		// Iterate through each returned result
		for(Database.DeleteResult dr : drList) {
			if (!dr.isSuccess()) {
				// Operation failed, so get all errors	
				for(Database.Error err : dr.getErrors()) {	  
		System.debug('#### Exception occurred at CH_AccountContactRelationTriggerHelper.deleteEntitlementContact ### ' + err.getMessage());
				}
			}
		}
	} catch(Exception ex) {
		System.debug('#### Exception occurrred at CH_AccountContactRelationTriggerHelper.deleteEntitlementContact ### ' + ex.getMessage());
	}
			}
			
			// NOKIASC-14643 - To update CH_Legal_Entity_Name__c when account contact relation record is deleted
			if(!contactIds.isEmpty()) {
	setLegalEntityBlank(contactIds);
			}
		}
	}
	
	/********************
	* Method Name: setLegalEntityBlank
	* Parameter: Set < Id >  
	* Description: To update CH_Legal_Entity_Name__c when account contact relation record is deleted/updated
	* Reference: NOKIASC-14643
	*******************/
	public static void setLegalEntityBlank(Set < Id > contactIds) {
		if(contactIds != null && !contactIds.isEmpty()) {
			List < Contact > contactList = new List < Contact > ();
			for (Contact contactObj : [SELECT Id, CH_Legal_Entity_Name__c FROM Contact WHERE Id =: contactIds] ) {
	if (contactObj != null && String.isNotBlank(contactObj.CH_Legal_Entity_Name__c)) {
		contactObj.CH_Legal_Entity_Name__c = '';
		contactList.add(contactObj);
	}			
			}
			
			if (!contactList.isEmpty()) {
	update contactList;
			}
		}
	}
}