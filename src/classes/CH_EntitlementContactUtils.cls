/** 
 * About 
 * ----- 
 * @Description	  : Case Handling EntitlementContact Object Utility Class.
 * @TestClass		: CH_EntitlementContactUtils_Test.
 * @Project		  : Case Handling.
 * @Modification Log : 
 *  Created  : 2019 12 04 – tiago.almeida@nokia.com
 * ----- 
**/

public without sharing class CH_EntitlementContactUtils {
	public static final DML_SObject DML = new DML_SObject(EntitlementContact.sObjectType);
	public class NonAuraHandledException extends Exception {}

	/**
	 * @description : 
	 * @param	   : Id recordId
	 * @return	  : List<SObject>
	**/
	public static List<SObject> getAuthorizedContacts(Id recordId) {
		Set<SObject> result = new Set<SObject>();
		String sObjectName = recordId.getSObjectType().getDescribe().getName();
		String sQuery = 'SELECT Id, Contact.Name, Contact.Contact_Status__c, Contact.Phone, Contact.MobilePhone, Contact.Email, Contact.CH_Legal_Entity_Name__c, ';
		sQuery += 'Entitlement.Account.Name, Entitlement.Account.AccountNumber, Entitlement.ServiceContract.Name, Contact.Country__c, ';
		sQuery += 'Contact.CH_ContactTimeZone__c, ContactId, CreatedBy.Name, CreatedDate FROM EntitlementContact WHERE ';
		if(sObjectName == 'Entitlement' || sObjectName == 'Contact') {
			if(sObjectName == 'Contact') sQuery += 'Entitlement.ServiceContract.Status != "Expired" AND ';
			sQuery += sObjectName + 'Id = "' + recordId + '" ORDER BY createdDate ASC';
			result = new Set<SObject>(DML_SObject.doQuery(sQuery));
		}
		else if(sObjectName == 'ServiceContract') {
			sQuery += 'EntitlementId IN (SELECT Id FROM Entitlement WHERE ServiceContractId = "' + recordId + '" ';
			sQuery += 'AND CH_EntitlementType__c = "Authorized Contact") ORDER BY createdDate ASC';
			Map<Id, EntitlementContact> oContactIdToEntContactMap = new Map<Id, EntitlementContact>();
			for(EntitlementContact oEntitlementContact: (List<EntitlementContact>) DML_SObject.doQuery(sQuery)) {
				oContactIdToEntContactMap.put(oEntitlementContact.ContactId, oEntitlementContact);
			}
			if(!oContactIdToEntContactMap.isEmpty()) {
				for(AccountContactRelation oAccountContactRelation: [SELECT Id, ContactId FROM AccountContactRelation WHERE ContactId IN :oContactIdToEntContactMap.keySet() AND NCP_Entitlement_Relationship__c = true]) {
					result.add(oContactIdToEntContactMap.get(oAccountContactRelation.ContactId));
				}	
			}
		}
		return new List<SObject>(result);
	}
	
	/**
	 * @description : Do EntitlementContact DML operations from the Lightning Components - NOKIASC-#####
	 * @param	  	: String operationType
	 * @param	  	: EntitlementContact oEntitlementContact
	 * @param	  	: Id oServiceContractId
	 * @return	  : Id
	**/
	public static Id database(String operationType, EntitlementContact oEntitlementContact, Id oServiceContractId, Boolean withoutSharing) {
		try {
			if(operationType.equals('insert')) {
				CH_AccountName__c oAccountName = CH_AccountName__c.getOrgDefaults();
				Contact oContact = ((List<Contact>) DML_SObject.doQuery('SELECT Id, CH_ContactType__c, AccountId, Account.Name FROM Contact WHERE Id = "' + oEntitlementContact.ContactId + '" LIMIT 1')).get(0);
				if(oAccountName != null && (String.isNotBlank(oContact.AccountId) &&String.isNotBlank(oContact.Account.Name)) && oAccountName.CH_InvalidName__c.containsIgnoreCase(oContact.Account.Name) 
						   && !oAccountName.CH_ValidName__c.equalsIgnoreCase(oContact.Account.Name)) {
							   throw new NonAuraHandledException('The selected contact is not valid for authorization.');
						   }
				if(oContact.CH_ContactType__c != 'Nokia Employee') {
					Boolean isExistingAccount = false;
					for(CH_AuthorizedAccount__c oAuthorizedAccount: (List<CH_AuthorizedAccount__c>) DML_SObject.doQuery('SELECT Id, CH_Account__c FROM CH_AuthorizedAccount__c WHERE CH_ServiceContract__c = "' + oServiceContractId + '"')) {
						if(oAuthorizedAccount.CH_Account__c == oContact.AccountId) {
							isExistingAccount = true;
							break;
						}		 
					} 
					if(isExistingAccount) {
						throw new NonAuraHandledException(
							'If you authorise contacts from an entire account, you cannot then add individual a contacts, before you delete all the contacts from 3rd party / Partner accounts, and vice versa.'
						);
					}
				}				
				ServiceContract oServiceContract = ((List<ServiceContract>) DML_SObject.doQuery('SELECT Id, CH_Entitlement__c FROM ServiceContract WHERE Id = "' + oServiceContractId + '" LIMIT 1')).get(0);
				if(oServiceContract == null || (oServiceContract != null && String.isBlank(oServiceContract.CH_Entitlement__c))) {
					throw new NonAuraHandledException('No Authorized Entitlement found.');
				}
				oEntitlementContact.EntitlementId = oServiceContract.CH_Entitlement__c;
				DML_SObject.doInsert(oEntitlementContact, withoutSharing);
			}
			else if(operationType.equals('delete')) {
				List<AccountContactRelation> oAccountContactRelationList = [
					SELECT Id, ContactId FROM AccountContactRelation WHERE AccountId IN (
						SELECT CH_Account__c FROM CH_AuthorizedAccount__c WHERE CH_ServiceContract__c = :oServiceContractId
					) AND NCP_Entitlement_Relationship__c = true AND ContactId = :oEntitlementContact.ContactId
				];
				if(oAccountContactRelationList.isEmpty()) {
					DML_SObject.doDelete(oEntitlementContact, withoutSharing);
				}
				else throw new NonAuraHandledException(
					'This Contact cannot be deleted as it is part of an authorized account. Please delete the Authorized account first.'
				);
			}
			return operationType.equals('delete')?null:oEntitlementContact.Id;
		} catch (Exception e) {
			system.debug('###Exception:' + e.getMessage());
			throw new NonAuraHandledException('Something went wrong! '+ e.getMessage());
		}
	}
}