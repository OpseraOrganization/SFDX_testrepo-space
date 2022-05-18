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
		if(System.isFuture() || System.isBatch()){
			CH_EntitlementContactTriggerHandler.skipAuthorizationHistory = true;
		}
		if(newAccountContactList!= null && !newAccountContactList.isEmpty()) {
			Set<Id> contactIds = new Set<Id>();
			Set<Id> accountIds = new Set<Id>();
			Set<Id> nonCompetitorContactIds = new Set<Id>();
			Map<Id, Set<Id>> accountIdContactIdsMap = new Map<Id, Set<Id>>();
			Map<Id, Set<Id>> accountIdSCIdsMap = new Map<Id, Set<Id>>();
			Map<Id, Id> serviceContractIdEntitlementIdMap = new Map<Id, Id>();
			for(AccountContactRelation sObj: newAccountContactList) {
				contactIds.add(sObj.ContactId);
				accountIds.add(sObj.AccountId);
			}
			if(contactIds?.size() > 0){
				for(Contact contactRecord : [SELECT Id FROM Contact WHERE Id IN :contactIds AND NCP_Competitor__c = false]){
					nonCompetitorContactIds.add(contactRecord.Id);
				}
			}
			for(AccountContactRelation sObj: newAccountContactList) {
				if(sObj.NCP_Entitlement_Relationship__c && !sObj.IsDirect && nonCompetitorContactIds.contains(sObj.ContactId)) {
					if(!accountIdContactIdsMap.containsKey(sObj.AccountId)){
						accountIdContactIdsMap.put(sObj.AccountId, new Set<Id>());
					}
					accountIdContactIdsMap.get(sObj.AccountId).add(sObj.ContactId);
				}
			}
			if(!accountIdContactIdsMap.isEmpty() && nonCompetitorContactIds != NULL && !nonCompetitorContactIds.isEmpty()) {
				Set<Id> serviceContractIds = new Set<Id>();
				Map<String, EntitlementContact> entitlementIdContactIdECMap = new Map<String, EntitlementContact>();
				Set<Id> entitlementIds = new Set<Id>();
				//Get the Service Contract Ids
				for(CH_AuthorizedAccount__c authAccount : [SELECT Id, CH_Account__c, CH_Account__r.AccountNumber, CH_ServiceContract__c, CH_ServiceContract__r.CH_Entitlement__c, CH_EntitlementId__c
														   FROM CH_AuthorizedAccount__c
														   WHERE CH_Account__c IN :accountIdContactIdsMap.keySet() AND 
														   CH_Account__r.RecordType.DeveloperName = 'Legal_Entity' AND
														   CH_ServiceContract__r.NCP_External_Status__c = 'Active' AND
														   CH_ServiceContract__r.HWS_Retrofit_Type__c = null ]){
		serviceContractIds.add(authAccount.CH_ServiceContract__c);
					if(!accountIdSCIdsMap.containsKey(authAccount.CH_Account__c)){
						accountIdSCIdsMap.put(authAccount.CH_Account__c, new Set<Id>());
					}
					accountIdSCIdsMap.get(authAccount.CH_Account__c).add(authAccount.CH_ServiceContract__c);
	}
				//Get the Entitlements related to Service Contracts
				if(serviceContractIds != null && !serviceContractIds.isEmpty()){
					for(Entitlement entitlementRecord : [SELECT Id, AccountId, ServiceContractId FROM Entitlement WHERE ServiceContractId IN :serviceContractIds AND CH_EntitlementType__c = 'Authorized Contact']){
						serviceContractIdEntitlementIdMap.put(entitlementRecord.ServiceContractId, entitlementRecord.Id);
						entitlementIds.add(entitlementRecord.Id);
					}
					
					for(Id accountId : accountIdContactIdsMap.keySet()){
						for(Id contactId : accountIdContactIdsMap.get(accountId)){
							for(Id scId : accountIdSCIdsMap.get(accountId)){
								if(serviceContractIdEntitlementIdMap.containsKey(scId)){
									entitlementIdContactIdECMap.put(serviceContractIdEntitlementIdMap.get(scId) + '-' + contactId, new EntitlementContact(EntitlementId = serviceContractIdEntitlementIdMap.get(scId),
																																						  ContactId = contactId));
								}
							}
						}
					}
					for(EntitlementContact ec : [SELECT EntitlementId, ContactId FROM EntitlementContact WHERE EntitlementId IN :entitlementIds AND ContactId IN :nonCompetitorContactIds]){
						if(entitlementIdContactIdECMap.containsKey(ec.EntitlementId + '-' + ec.ContactId)){
							entitlementIdContactIdECMap.remove(ec.EntitlementId + '-' + ec.ContactId);
						}
					}
					if(!entitlementIdContactIdECMap.isEmpty()){
						Database.SaveResult[] srList = Database.insert(entitlementIdContactIdECMap.values(), false);
						if(CH_EntitlementContactTriggerHandler.skipAuthorizationHistory){
							createAH('Add', entitlementIdContactIdECMap.values());
						}
					}
				}
			}
			if(isCreate && contactIds != NULL && !contactIds.isEmpty()){
				updateLegalEntityName(contactIds, accountIds, NULL, newAccountContactList);
			}
		}
	}
	@testVisible
	private static void createAH(String action, List<EntitlementContact> oEntitlementContactList) {
		Set<String> fieldSet = new Set<String>();
		Set<Id> oEntitlementIdSet = new Set<Id>();
		Set<Id> oContactIdSet = new Set<Id>();
		
		for(EntitlementContact oEntitlementContact : oEntitlementContactList) {
			oEntitlementIdSet.add(oEntitlementContact.EntitlementId);
			oContactIdSet.add(oEntitlementContact.ContactId);
		}
		Map<Id, Entitlement> oEntitlementMap = new Map<Id, Entitlement>([SELECT Id, ServiceContractId, ServiceContract.AccountId FROM Entitlement WHERE Id IN :oEntitlementIdSet]);
		Map<Id, Contact> oContactMap = new Map<Id, Contact>([SELECT Id, AccountId FROM Contact WHERE Id IN :oContactIdSet]);
		Map<Id, Id> oContactToLegalEntMap = new Map<Id, Id>();
		for(AccountContactRelation oACRelation: [SELECT Id, AccountId, ContactId FROM AccountContactRelation WHERE NCP_Entitlement_Relationship__c = true AND IsActive = true AND ContactId IN :oContactIdSet]) {
			oContactToLegalEntMap.put(oACRelation.ContactId, oACRelation.AccountId);
		}
		for(EntitlementContact oEntitlementContact : oEntitlementContactList) {
			Contact oContact = oContactMap.get(oEntitlementContact.ContactId);
			String sAccountId = '';
			if('Delete'.equalsIgnoreCase(action)){
				sAccountId = oEntitlementMap.get(oEntitlementContact.EntitlementId).ServiceContract.AccountId != NULL ? oEntitlementMap.get(oEntitlementContact.EntitlementId).ServiceContract.AccountId : oContact.AccountId;
			}
			else{
				sAccountId = oContactToLegalEntMap.containsKey(oEntitlementContact.ContactId) ? oContactToLegalEntMap.get(oEntitlementContact.ContactId) : oContact.AccountId;
			}
			Entitlement oEntitlement = oEntitlementMap.get(oEntitlementContact.EntitlementId);
			fieldSet.add(action + ' Contact,' + oEntitlement.ServiceContractId + ',' + oEntitlementContact.ContactId + ',' + sAccountId);
		}
		insertHistory(fieldSet);
	}
	
	private static void insertHistory(Set<String> fieldSet) {
		List<CH_AuthorizationHistory__c> oAuthorizationHistoryList = new List<CH_AuthorizationHistory__c>();
		for(String fields : fieldSet) {
			List<String> fieldList = fields.split(',');
			if(fieldList.size() == 4) {
				String oServiceContractId = fieldList.get(1).replaceAll( '\\s+', '');
				String oAccountId = fieldList.get(3).replaceAll( '\\s+', '');
				if(oServiceContractId != 'null' && oAccountId  != 'null') {
					CH_AuthorizationHistory__c oAuthorizationHistory = new CH_AuthorizationHistory__c();
					oAuthorizationHistory.Action__c = fieldList.get(0);
					oAuthorizationHistory.ServiceContract__c = (Id) oServiceContractId;
					oAuthorizationHistory.Account__c = (Id) oAccountId;
					if(!fieldList.get(2).equals('null')) { oAuthorizationHistory.Contact__c = (Id) fieldList.get(2); }
					oAuthorizationHistoryList.add(oAuthorizationHistory);
				}
			}
		}
		DML_SObject.doInsert(oAuthorizationHistoryList, false, true);
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
				else if(!acr.NCP_Entitlement_Relationship__c && oldACRMap != NULL && oldACRMap.containsKey(acr.Id) && oldACRMap.get(acr.Id).NCP_Entitlement_Relationship__c && String.isNotBlank(contactRecord.CH_Legal_Entity_Name__c)){//the Entity Relationship has been changed from true to false
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
	* Date(DD/MM/YYYY)  Modified By	 Demand	  Remarks
	09/03/2021		Soham	 DEM0051264  Updated the method to update the Legal Entity Name rather than blindly deleting the Legal Entity Name
	*******************/
	public static void deleteEntitlementContact(List<AccountContactRelation> oldAccountContactList) {
		if(System.isFuture() || System.isBatch()){
			CH_EntitlementContactTriggerHandler.skipAuthorizationHistory = true;
		}
		if(oldAccountContactList != null &&  !oldAccountContactList.isEmpty()) {
			Set<Id> contactIds = new Set<Id>();
			Set<Id> accountIds = new Set<Id>();
			Set<String> contactIdAccountIdSet = new Set<String>();
			Map<Id, Set<Id>> contactIdAccountIdsFromRemainingACRsMap = new Map<Id, Set<Id>>();
			Map<Id, Set<Id>> entitlementIdcontactIdsMap = new Map<Id, Set<Id>>();
			Map<Id, Id> serviceContractIdEntitlementMap = new Map<Id, Id>();
			Map<String, EntitlementContact> entitlementIdContactIdStrECMap = new Map<String, EntitlementContact>();
			Map<Id, AccountContactRelation> oldACRMap = new Map<Id, AccountContactRelation>();
			
			for(AccountContactRelation acr : oldAccountContactList){
				contactIds.add(acr.ContactId);
				accountIds.add(acr.AccountId);
				contactIdAccountIdSet.add(acr.ContactId + '-' + acr.AccountId);
				oldACRMap.put(acr.Id, acr);
			}
			
			//Query ACR with contactIds and accountIds
			for(AccountContactRelation acr : [SELECT ContactId, AccountId FROM AccountContactRelation WHERE ContactId IN :contactIds AND NCP_Entitlement_Relationship__c = true]){
				if(!contactIdAccountIdSet.contains(acr.ContactId + '-' + acr.AccountId)){
					if(!contactIdAccountIdsFromRemainingACRsMap.containsKey(acr.ContactId)){
						contactIdAccountIdsFromRemainingACRsMap.put(acr.ContactId, new Set<Id>());
					}
					contactIdAccountIdsFromRemainingACRsMap.get(acr.ContactId).add(acr.AccountId);
				}
			}
			
			//EC Query
			for(EntitlementContact ec : [SELECT Id, EntitlementId, ContactId, Entitlement.ServiceContractId FROM EntitlementContact WHERE Entitlement.CH_EntitlementType__c = 'Authorized Contact' AND ContactId IN :contactIds]){
				entitlementIdContactIdStrECMap.put(ec.EntitlementId + '-' + ec.ContactId, ec);
				serviceContractIdEntitlementMap.put(ec.Entitlement.ServiceContractId, ec.EntitlementId);
				if(!entitlementIdcontactIdsMap.containsKey(ec.EntitlementId)){
					entitlementIdcontactIdsMap.put(ec.EntitlementId, new Set<Id>());
				}
				entitlementIdcontactIdsMap.get(ec.EntitlementId).add(ec.ContactId);
			}
			
			//AA Query
			for(CH_AuthorizedAccount__c authAccountObj: [SELECT Id, CH_Account__c, CH_ServiceContract__c, CH_ServiceContract__r.Name, CH_Account__r.Name
														 FROM CH_AuthorizedAccount__c
														 WHERE CH_ServiceContract__c != NULL AND 
														 CH_ServiceContract__c IN :serviceContractIdEntitlementMap.keySet() AND 
														 CH_Account__r.RecordType.DeveloperName = 'Legal_Entity']){
															 for(Id contactId : entitlementIdcontactIdsMap.get(serviceContractIdEntitlementMap.get(authAccountObj.CH_ServiceContract__c))){
																 if(contactIdAccountIdsFromRemainingACRsMap.containsKey(contactId) && contactIdAccountIdsFromRemainingACRsMap.get(contactId).contains(authAccountObj.CH_Account__c)){
																	 entitlementIdContactIdStrECMap.remove(serviceContractIdEntitlementMap.get(authAccountObj.CH_ServiceContract__c) + '-' + contactId);
																 }
															 }
														 }
			
			if(!entitlementIdContactIdStrECMap?.isEmpty()) {
				try {
					// Delete entitlement contact list
					Database.DeleteResult[] drList = Database.delete(entitlementIdContactIdStrECMap.values(), false);
					if(CH_EntitlementContactTriggerHandler.skipAuthorizationHistory){
						createAH('Delete', entitlementIdContactIdStrECMap.values());
					}
				} catch(Exception ex) {
					System.debug('#### Exception occurrred at CH_AccountContactRelationTriggerHelper.deleteEntitlementContact ### ' + ex.getMessage());
				}
			}
			updateLegalEntityName(contactIds, accountIds, oldACRMap, NULL);
		}
	}
}