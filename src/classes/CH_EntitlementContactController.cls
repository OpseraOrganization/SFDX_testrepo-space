public without sharing class CH_EntitlementContactController {
	@AuraEnabled
	public static Boolean checkUserPermission() {
		Set<String> sAuthorizedContactsAccessSet = new Set<String>(Label.CH_AuthorizedContactsAccess.replaceAll('\\s','').split(','));
		List < PermissionSetAssignment > permSetAssignList = [
			SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId IN 
			(SELECT Id FROM PermissionSet WHERE Name in :sAuthorizedContactsAccessSet) AND AssigneeId = :UserInfo.getUserId()
		];
		return (permSetAssignList != null && !permSetAssignList.isEmpty());
	}
	
	@AuraEnabled
	public static List < EntitlementContact > getContactList(Id recordId) {
		if(String.isBlank(recordId)) {
			return null;			 
		}
		String query = getAuthorizedContactQuery();
		String sObjectName = recordId.getSObjectType().getDescribe().getName();		
		if(sObjectName == 'ServiceContract') {
		 return getAuthorizedContactsByContractId(recordId);	
		} else if(sObjectName == 'Entitlement') {
			query = query + 'WHERE EntitlementId = :recordId ';		
		} else if(sObjectName == 'Contact') {
			query = query + 'WHERE ContactId = :recordId ';	   
		} else {
			return null;
		}
		query = query + 'ORDER BY createdDate ASC';   
		return Database.query(query);
	}
	
	public static String getAuthorizedContactQuery() {
		return 'SELECT Id, Name, EntitlementId, Entitlement.Name, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name, Contact.CH_Legal_Entity_Name__c FROM EntitlementContact ';	
	}
	
	public static List < EntitlementContact > getAuthorizedContactsByContractId(Id contractId) {
		if(String.isBlank(contractId)) {
			return null;			 
		}
		String query = getAuthorizedContactQuery();
		query = query + ' WHERE EntitlementId IN (SELECT Id FROM Entitlement WHERE ServiceContractId = :contractId AND CH_EntitlementType__c = \'Authorized Contact\') '; 
		query = query + ' ORDER BY createdDate ASC';   
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
		return entContactList;
	}
	
	@AuraEnabled
	public static String deleteRecord(Id contractId, Id contactId, Id deleteId) {
		if(String.isBlank(contractId) || String.isBlank(contactId) || String.isBlank(deleteId)) {
			throw new AuraHandledException('Unexpected error has occurred. Kindly contact system administrator.');
		}
		// Prepare list of contacts beloning to authorized accounts
		Set < Id > contactIds = new Set < Id > ();
		List < AccountContactRelation > accContactList = [
			SELECT ContactId FROM AccountContactRelation WHERE AccountId IN (
	SELECT CH_Account__c FROM CH_AuthorizedAccount__c WHERE CH_ServiceContract__c = :contractId
			) AND NCP_Entitlement_Relationship__c = true
		];		
		if(accContactList != null && !accContactList.isEmpty()) {
			for(AccountContactRelation accContactObj: accContactList) {
				contactIds.add(accContactObj.ContactId);
			}
		}
		System.debug('## ' + contactIds + '-' + deleteId);
		// Check contactIds contains deleting record Id or not		
		if(contactIds.contains(contactId)) {
			throw new AuraHandledException('This Contact cannot be deleted as it is part of an authorized account. Please delete the Authorized account first.');
		}
		String message = '';
		try {
			Database.delete(deleteId);
			message = 'Record deleted successfully.';
		} catch(Exception ex) {
			System.debug('### ' + ex.getMessage());			
			message = ex.getMessage();
		}
		return message;
	}
}