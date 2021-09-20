/****************************************
* Class Name : CH_AccountContactRelationTriggerHelper 
* Created Date: 14 September 2018
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 20 March 2019
* Description : Contains common business logic
* Test Class: CH_AccountContactRelationTriggerTest
*****************************************/
public without sharing class CH_AccountContactRelationTriggerHelper {

	/********************
	* Method Name: createEntitlementContact
	* Parameter: CH_AuthorizedAccount__c
	* Description: Used to create EntitlementContact record of type NCP_Entitlement_Relationship__c = true
	* Reference: NOKIASC-4316
	* Date(DD/MM/YYYY)  Modified By	 Demand	  Remarks
	09/03/2021		Soham	 DEM0051264  Updated the method by putting the logic inside the createECRecords() and calling the same method
	*******************/
	public static void createEntitlementContact(List<AccountContactRelation> newAccountContactList) {
		createECRecords(true, newAccountContactList);
	}
	
	/********************
	* Method Name: createECRecords
	* Parameter: Boolean, List<AccountContactRelation>
	* Description: Used to create EntitlementContact record of type NCP_Entitlement_Relationship__c = true
	* Reference: DEM0051264
	* Date(DD/MM/YYYY)  Modified By	 Demand	  Remarks
	09/03/2021		Soham	 DEM0051264  Created the method by putting the logic from the createEntitlementContact() and introduce the isCreate parameter to be used by the updateEntitlementContact()
	*******************/
	private static void createECRecords(Boolean isCreate, List<AccountContactRelation> newAccountContactList) {
		if(newAccountContactList!= null && !newAccountContactList.isEmpty()) {
			Map<Id, List<AccountContactRelation>> accountContactRelationMap = new Map<Id, List<AccountContactRelation>>();
			Set<Id> contactIds = new Set<Id>();
			for(AccountContactRelation sObj: newAccountContactList) {
	if(sObj.NCP_Entitlement_Relationship__c && !sObj.IsDirect) {
		if(accountContactRelationMap.containsKey(sObj.AccountId)) {
			accountContactRelationMap.get(sObj.AccountId).add(sObj); 
		} else {
			accountContactRelationMap.put(sObj.AccountId, new List<AccountContactRelation>{ sObj }); 
		}
		contactIds.add(sObj.ContactId);
	}		
			}
			
			if(!accountContactRelationMap.isEmpty() && contactIds != NULL && !contactIds.isEmpty()) {
	Map<Id, Contact> contactsMap = new Map<Id, Contact>([select id, FirstName, LastName from Contact where id IN : contactIds]);
	Set<Id> contactEntitementIds = new Set<Id>();
	Set<Id> serviceContractIds = new Set<Id>();
	Map<Id, Id> entitlementIdAccountId = new Map<Id, Id>();
	//Get the Service Contract Ids
	for(CH_AuthorizedAccount__c authAccount : [SELECT Id, CH_Account__c, CH_Account__r.AccountNumber, CH_ServiceContract__c, CH_ServiceContract__r.CH_Entitlement__c, CH_EntitlementId__c
				 FROM CH_AuthorizedAccount__c
				 WHERE CH_Account__c IN :accountContactRelationMap.keySet() AND 
				 CH_Account__r.RecordType.DeveloperName = 'Legal_Entity' AND
				 CH_ServiceContract__r.NCP_External_Status__c = 'Active']){
		serviceContractIds.add(authAccount.CH_ServiceContract__c);
	}
	//Get the Entitlements related to Service Contracts
	if(serviceContractIds != null && !serviceContractIds.isEmpty()){
		for(Entitlement entitlementRecord : [SELECT Id, AccountId FROM Entitlement WHERE ServiceContractId IN :serviceContractIds AND CH_EntitlementType__c = 'Authorized Contact']){
			entitlementIdAccountId.put(entitlementRecord.Id, entitlementRecord.AccountId);
		}
		
		
		Set<String> entitlementIdContactIdSet = new Set<String>();
		for(EntitlementContact ec : [SELECT EntitlementId, ContactId FROM EntitlementContact WHERE EntitlementId IN :entitlementIdAccountId.keySet() AND ContactId IN :contactIds]){
			entitlementIdContactIdSet.add(ec.EntitlementId + '-' + ec.ContactId);
		}
		
		if(!entitlementIdAccountId.isEmpty()) {
			List<EntitlementContact> entContactList = new List<EntitlementContact>();
			Set<String> ecStringSet = new Set<String>();
			for(Id entitlementId: entitlementIdAccountId.keySet()) {
				if(accountContactRelationMap.containsKey(entitlementIdAccountId.get(entitlementId))){
		for(AccountContactRelation sObj: accountContactRelationMap.get(entitlementIdAccountId.get(entitlementId))) {
			if(!String.isBlank(contactsMap.get(sObj.ContactId).FirstName)){
				if(contactsMap.containskey(sObj.ContactId) && !contactsMap.get(sObj.ContactId).FirstName.startsWith('DUP') && !String.isBlank(contactsMap.get(sObj.ContactId).Lastname) && !contactsMap.get(sObj.ContactId).Lastname.startsWith('DUP') && !ecStringSet.contains(entitlementId + '-' + sObj.ContactId) && (entitlementIdContactIdSet.isEmpty() || (!entitlementIdContactIdSet.isEmpty() && !entitlementIdContactIdSet.contains(entitlementId + '-' + sObj.ContactId)))){
					entContactList.add(new EntitlementContact(EntitlementId = entitlementId, ContactId = sObj.ContactId));
					ecStringSet.add(entitlementId + '-' + sObj.ContactId);
				} 
			}
			else {
				if(contactsMap.containskey(sObj.ContactId) && !String.isBlank(contactsMap.get(sObj.ContactId).Lastname) && !contactsMap.get(sObj.ContactId).Lastname.startsWith('DUP') && !ecStringSet.contains(entitlementId + '-' + sObj.ContactId) && (entitlementIdContactIdSet.isEmpty() || (!entitlementIdContactIdSet.isEmpty() && !entitlementIdContactIdSet.contains(entitlementId + '-' + sObj.ContactId)))){
					entContactList.add(new EntitlementContact(EntitlementId = entitlementId, ContactId = sObj.ContactId));
					ecStringSet.add(entitlementId + '-' + sObj.ContactId);
				}		
			}
		}
				}
			}
			
			if(!entContactList?.isEmpty()) {
				try {
		// Insert EntitlementContact list
		Database.SaveResult[] srList = Database.insert(entContactList, false);
		// Iterate through each returned result
		Integer count = 0;
		for (Database.SaveResult sr : srList) {
			if (!sr.isSuccess()) {
				// Operation failed, so get all errors	
				for(Database.Error err : sr.getErrors()) {
					System.debug('#### Exception occurred at CH_AccountContactRelationTriggerHelper.createEntitlementContact ### ' + entContactList[count] + err.getMessage());
				}
			}
			count++;
		} 
				} catch(Exception ex) {
		System.debug('#### Exception occurrred at CH_AccountContactRelationTriggerHelper.createEntitlementContact ### ' + ex.getMessage());
				}
			}
		}
	}
			}
			if(isCreate && contactIds != NULL && !contactIds.isEmpty()){
	updateLegalEntityName(contactIds, accountContactRelationMap.keySet(), NULL, newAccountContactList);
			}
		}
	}
	
	/********************
	* Method Name: updateLegalEntityName
	* Parameter: Set<Id>, Set<Id>, Map<Id, AccountContactRelation>, List<AccountContactRelation>
	* Description: To update CH_Legal_Entity_Name__c when account contact relation record is deleted/updated
	* Reference: DEM0051264
	*******************/
	private static void updateLegalEntityName(Set<Id> contactIdSet, Set<Id> accountIdSet, Map<Id, AccountContactRelation> oldACRMap, List<AccountContactRelation> newACRList) {
		//ISNEW(), ISCHANGED(ACR.NCP_Entitlement_Relationship__c), ACR.NCP_Entitlement_Relationship__c == true
		Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id, CH_Legal_Entity_Name__c
						FROM Contact
						WHERE Id IN :contactIdSet]);
		Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name
						FROM Account
						WHERE Id IN :accountIdSet]);
		Map<Id, Contact> contactMapToBeUpdated = new Map<Id, Contact>();
		if(newACRList != NULL && !newACRList.isEmpty()){//Insert or Update
			for(AccountContactRelation acr : newACRList){
	Contact contactRecord = new Contact();
	contactRecord = contactMap.get(acr.ContactId);
	String accName = (truncatedLegalEntityName((accountMap.get(acr.AccountId)).Name)).removeEnd(';');
	if(acr.NCP_Entitlement_Relationship__c && (oldACRMap == NULL || !(oldACRMap.get(acr.Id).NCP_Entitlement_Relationship__c))){//Insert operation or on an Update operation, the Entity Relationship has been changed from false to true
		if(contactRecord != NULL && String.isNotBlank(contactRecord.CH_Legal_Entity_Name__c) && 
		accountMap.containsKey(acr.AccountId) && !((accountMap.get(acr.AccountId)).Name).equalsIgnoreCase((contactMap.get(acr.ContactId)).CH_Legal_Entity_Name__c)){   
		 contactRecord.CH_Legal_Entity_Name__c += ';' + accName;//Append the new Account name to existing Account Name
		}
		else{
			contactRecord.CH_Legal_Entity_Name__c = accName;//Add the new Account Name to the Legal Entity Name
		}
	}
	else if(!acr.NCP_Entitlement_Relationship__c && oldACRMap.get(acr.Id).NCP_Entitlement_Relationship__c && String.isNotBlank(contactRecord.CH_Legal_Entity_Name__c)){//the Entity Relationship has been changed from true to false
		contactRecord.CH_Legal_Entity_Name__c = contactRecord.CH_Legal_Entity_Name__c.remove(accName);//Remove the new Account Name from the Legal Entity Name
	}
	contactRecord.CH_Legal_Entity_Name__c = (contactRecord.CH_Legal_Entity_Name__c)?.removeEnd(';');
	contactMapToBeUpdated.put(contactRecord.Id, contactRecord);
			}
		}
		else{//Delete
			for(AccountContactRelation acr : oldACRMap.values()){
	Contact contactRecord = new Contact();
	contactRecord = contactMap.get(acr.ContactId);
	String accName = (truncatedLegalEntityName((accountMap.get(acr.AccountId)).Name)).removeEnd(';');
	if(contactRecord.CH_Legal_Entity_Name__c != NULL && contactRecord.CH_Legal_Entity_Name__c.contains(accName)){
		contactRecord.CH_Legal_Entity_Name__c = (contactRecord.CH_Legal_Entity_Name__c).remove(accName);//Remove the new Account Name from the Legal Entity Name
		contactRecord.CH_Legal_Entity_Name__c = (contactRecord.CH_Legal_Entity_Name__c.removeEnd(';')).removeStart(';');
		contactMapToBeUpdated.put(contactRecord.Id, contactRecord);
	}	
			}
		}
		if(!contactMapToBeUpdated?.isEmpty()){
			update contactMapToBeUpdated.values();
		}
	}
	
	/********************
	* Method Name: truncatedLegalEntityName
	* Parameter: String
	* Description: To truncate the Legal Entity Name to 125 characters if length is more than 125.
	* Reference: DEM0051264
	*******************/
	private static String truncatedLegalEntityName(String accountNameStr) {
		return accountNameStr?.length()>120 ? accountNameStr.substring(0,120) + Label.NCP_ThreeDot + Label.NCP_Separator : accountNameStr + Label.NCP_Separator;//Label.NCP_Separator = ;, Label.NCP_ThreeDot = ...
	}
	
	/********************
	* Method Name: updateEntitlementContact
	* Parameter: CH_AuthorizedAccount__c
	* Description: Used to add/remove EntitlementContact record depending on NCP_Entitlement_Relationship__c flag
	* Reference: NOKIASC-4316
	* Date(DD/MM/YYYY)  Modified By	 Demand	  Remarks
	09/03/2021		Soham	 DEM0051264  Updated the method by calling the createEntitlementContact() and updateLegalEntityName()
	*******************/
	public static void updateEntitlementContact(Map<Id, AccountContactRelation> oldAccountContactMap, Map<Id, AccountContactRelation> newAccountContactMap) {
		if(newAccountContactMap != null && !newAccountContactMap.isEmpty() && oldAccountContactMap != null && !oldAccountContactMap.isEmpty()) {
			List<AccountContactRelation> deleteList = new List<AccountContactRelation>();
			List<AccountContactRelation> createList = new List<AccountContactRelation>();
			Set<Id> accountIdSet = new Set<Id>();
			Set<Id> contactIdSet = new Set<Id>();
			for(AccountContactRelation newAccountContactObj: newAccountContactMap.values()) {
	AccountContactRelation oldAccountContactObj = oldAccountContactMap.get(newAccountContactObj.Id);
	if(oldAccountContactObj != null) {
		if(oldAccountContactObj.NCP_Entitlement_Relationship__c != newAccountContactObj.NCP_Entitlement_Relationship__c) {
			if(newAccountContactObj.NCP_Entitlement_Relationship__c) {
				createList.add(newAccountContactObj);
			} else if(!newAccountContactObj.NCP_Entitlement_Relationship__c) {
				// NOKIASC-14643 - To update CH_Legal_Entity_Name__c when account contact relation flag is updated
				deleteList.add(newAccountContactObj);
			} else {
				deleteList.add(newAccountContactObj);
			}
		}
	}
	accountIdSet.add(newAccountContactObj.AccountId);
	contactIdSet.add(newAccountContactObj.ContactId);
			}
			if(!deleteList.isEmpty()) {
	// Delete all existing 
	deleteEntitlementContact(deleteList);
			}
			if(!createList.isEmpty()) {
	// Create all EntitlementContact
	//createEntitlementContact(createList);
	createECRecords(false, createList);
			}
			if(!contactIdSet.isEmpty() && !accountIdSet.isEmpty()) {
	updateLegalEntityName(contactIdSet, accountIdSet, oldAccountContactMap, newAccountContactMap.values());
			}
		}
	}
	
	/********************
	* Method Name: deleteEntitlementContact
	* Parameter: CH_AuthorizedAccount__c
	* Description: Used to delete EntitlementContact record of type NCP_Entitlement_Relationship__c = true
	* Reference: NOKIASC-4316
	* Date(DD/MM/YYYY)  Modified By	 	Demand	Remarks
	  09/03/2021		Soham	DEM0051264  Updated the method to update the Legal Entity Name rather than blindly deleting the Legal Entity Name
	*******************/
	public static void deleteEntitlementContact(List<AccountContactRelation> oldAccountContactList) {
		if(oldAccountContactList != null &&  !oldAccountContactList.isEmpty()) {
			Set<Id> accountIds = new Set<Id>();
			Set<Id> accIdSet = new Set<Id>();
			Set<Id> contactIds = new Set<Id>();
			Map<Id, AccountContactRelation> oldACRMap = new Map<Id, AccountContactRelation>();
			Set<String> accountIdContactIdSet = new Set<String>();
			Set<Id> entitlementIds = new Set<Id>();
			Map<Id, Id> entitlementIdAccountIdMap = new Map<Id, Id>();
			Set<Id> serviceContractIds = new Set<Id>();
			Map<Id, Id> entitlementIdServiceContractIdMap = new Map<Id, Id>();
			Map<Id, Set<Id>> serviceContractIdAccountIdsMap = new Map<Id, Set<Id>>();
			
			for(AccountContactRelation sObj : oldAccountContactList) {
	accountIds.add(sObj.AccountId);
	contactIds.add(sObj.ContactId);
	oldACRMap.put(sObj.Id, sObj);
	accountIdContactIdSet.add(sObj.AccountId + '-' + sObj.ContactId);
			}
			for(AccountContactRelation acrRecord : [SELECT Id, AccountId, ContactId
				FROM AccountContactRelation
				WHERE ContactId IN :contactIds AND
														  NCP_Entitlement_Relationship__c = TRUE]){
	accIdSet.add(acrRecord.AccountId);
			}
			
			for(CH_AuthorizedAccount__c authAccountObj: [SELECT Id, CH_EntitlementId__c, CH_Account__c, CH_ServiceContract__c
					 FROM CH_AuthorizedAccount__c
					 WHERE CH_Account__c IN :accountIds AND 
														 CH_Account__r.RecordType.DeveloperName = 'Legal_Entity' AND
														 CH_ServiceContract__r.NCP_External_Status__c = 'Active']){
				 if(String.isNotBlank(authAccountObj.CH_ServiceContract__c)) {
	 	serviceContractIds.add(authAccountObj.CH_ServiceContract__c);
				 }
			}
			accIdSet.addAll(accountIds);
			for(CH_AuthorizedAccount__c authAccountObj: [SELECT Id, CH_EntitlementId__c, CH_Account__c, CH_ServiceContract__c, CH_ServiceContract__r.CH_Entitlement__c
					 FROM CH_AuthorizedAccount__c
					 WHERE CH_Account__c IN :accIdSet AND 
					 CH_Account__r.RecordType.DeveloperName = 'Legal_Entity' AND 
														 CH_ServiceContract__c IN :serviceContractIds AND
														 CH_ServiceContract__r.NCP_External_Status__c = 'Active']){
	if(String.isNotBlank(authAccountObj.CH_ServiceContract__c)) {		
		if(serviceContractIdAccountIdsMap.containsKey(authAccountObj.CH_ServiceContract__c)){
			Set<Id> accIds = serviceContractIdAccountIdsMap.get(authAccountObj.CH_ServiceContract__c);
			accIds.add(authAccountObj.CH_Account__c);
			serviceContractIdAccountIdsMap.put(authAccountObj.CH_ServiceContract__c, accIds);
		}
		else{
			serviceContractIdAccountIdsMap.put(authAccountObj.CH_ServiceContract__c, new Set<Id>{authAccountObj.CH_Account__c});
		}
	}
			}
			if(serviceContractIds?.size() > 0){
	for(Entitlement entitlementRecord : [SELECT Id, AccountId, ServiceContractId FROM Entitlement WHERE ServiceContractId IN :serviceContractIds AND CH_EntitlementType__c = 'Authorized Contact']){
		entitlementIds.add(entitlementRecord.Id);
		entitlementIdServiceContractIdMap.put(entitlementRecord.Id, entitlementRecord.ServiceContractId);
	}
					
	Map<Id, EntitlementContact> ecMap = new Map<Id, EntitlementContact>([SELECT Id, EntitlementId, ContactId FROM EntitlementContact WHERE EntitlementId IN :entitlementIds AND ContactId IN :contactIds]);
				
	for(EntitlementContact ec : [SELECT Id, EntitlementId, ContactId FROM EntitlementContact WHERE EntitlementId IN :entitlementIds AND ContactId IN :contactIds]){
		for(String accountId : serviceContractIdAccountIdsMap.get(entitlementIdServiceContractIdMap.get(ec.EntitlementId))){
						if(!accountIdContactIdSet.contains(accountId + '-' + ec.ContactId)){
				ecMap.remove(ec.Id);
			}			
		}
	}
	
	if(!ecMap?.isEmpty()) {
		try {
			// Delete entitlement contact list
			Database.DeleteResult[] drList = Database.delete(ecMap.values(), false);
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
	updateLegalEntityName(contactIds, accountIds, oldACRMap, NULL);
			}			
		}
	}
}