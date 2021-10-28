public class CH_AuthorizedContactController {
	@AuraEnabled
	public static List < Contact > getSearchContactList(String contractId, String fName, String lName, String contactId, String email, String accountName) {
	 if(String.isNotBlank(fName) || String.isNotBlank(lName)) {
		 Set < Id > accountIds = new Set < Id > ();
			if(String.isNotBlank(contractId)) {
				for(CH_AuthorizedAccount__c sObj: [SELECT Id, CH_Account__c FROM CH_AuthorizedAccount__c WHERE CH_ServiceContract__c = :contractId]) {
			accountIds.add(sObj.CH_Account__c);		   
				} 
			}		
		 // Get Contract Object Details
		 List < Contact > contactList = new List < Contact > ();
		 String searchTerms = '';
		 if(String.isNotBlank(fName)) {
			 searchTerms += '("' + String.escapeSingleQuotes(fName.trim()) + '*")';
		 }
		 if(String.isNotBlank(lName)) {
				if(String.isNotBlank(searchTerms)){
					searchTerms += ' AND ';
				}
				searchTerms += '("' + String.escapeSingleQuotes(lName.trim()) + '*")';
			}
			String contactQuery = 'Contact(Id, Name, Email, AccountId, Account.Name, CH_Legal_Entity_Name__c, CH_ContactType__c, CH_ContactID__c WHERE AccountId NOT IN :accountIds ';
			contactQuery += ' AND CH_Legal_Entity_Name__c != null ';
			if(String.isNotBlank(accountName)) {			
				contactQuery += ' AND CH_Legal_Entity_Name__c like \'' + String.escapeSingleQuotes(accountName.trim()) + '%\'';
			}
			if(String.isNotBlank(email)) {
				contactQuery += ' AND Email like \'' + String.escapeSingleQuotes(email.trim()) + '%\'';
			}
			if(String.isNotBlank(contactId)) {			
				contactQuery += ' AND CH_ContactId__c like \'' + String.escapeSingleQuotes(contactId.trim()) + '%\'';
			}  
			contactQuery += ')';
			String searchQuery = 'FIND :searchTerms IN ALL FIELDS RETURNING ' + contactQuery + ' LIMIT 20';
			System.debug('### SOSL Query - ' + searchQuery);
		 return (List < Contact >) search.query(searchQuery)[0]; 
	 }
	 // Dynamic Query logic to bypass SOSL query if first name / last name is blank.
		String contactQuery = 'SELECT Id, Name, Email, AccountId, Account.Name, CH_Legal_Entity_Name__c, CH_ContactType__c, CH_ContactID__c FROM Contact WHERE CH_Legal_Entity_Name__c != null ';
		if(String.isNotBlank(accountName)) {			
			contactQuery += ' AND CH_Legal_Entity_Name__c like \'' + String.escapeSingleQuotes(accountName.trim()) + '%\'';
		}
		if(String.isNotBlank(email)) {
			contactQuery += ' AND Email like \'' + String.escapeSingleQuotes(email.trim()) + '%\'';
		}
		if(String.isNotBlank(contactId)) {			
			contactQuery += ' AND CH_ContactId__c like \'' + String.escapeSingleQuotes(contactId.trim()) + '%\'';
		}
		contactQuery += ' LIMIT 20';
		return (List < Contact >) Database.query(contactQuery);
	} 
	
	@AuraEnabled
	public static String addEntitlementContact(Id contractId, Contact contactObj) {
	 if(contactObj == null) {
		 throw new AuraHandledException('No selected contact found.');
	 } 
		// Validate valid and invalid names
		CH_AccountName__c accountNameObj = CH_AccountName__c.getOrgDefaults();
		if(accountNameObj != null) {
			if(String.isNotBlank(contactObj.AccountId) && String.isNotBlank(contactObj.Account.Name)) {
				String validNames = accountNameObj.CH_ValidName__c;
				String invalidNames = accountNameObj.CH_InvalidName__c;
				if(invalidNames.containsIgnoreCase(contactObj.Account.Name) 
				   && !validNames.equalsIgnoreCase(contactObj.Account.Name)) {
					   throw new AuraHandledException('The selected contact is not valid for authorization.');
				   }
			}
		}
		
	 // Check for existing EntitlementContact record
	 List < EntitlementContact > entContactList = [SELECT Id FROM EntitlementContact WHERE Entitlement.ServiceContractId = :contractId AND ContactId = :contactObj.Id];
	 if(entContactList != null && !entContactList.isEmpty()) {
		 throw new AuraHandledException('Contact is already present in Entitlement.');
	 }
		// If Not Nokia Employee then Check for Authorization type
	 if(contactObj.CH_ContactType__c != 'Nokia Employee') {
		 Boolean isExistingAccount = false;
		 for(CH_AuthorizedAccount__c authAccountObj: [SELECT Id, CH_Account__c, CH_ServiceContract__c FROM CH_AuthorizedAccount__c WHERE CH_ServiceContract__c = :contractId]) {
			 if(authAccountObj.CH_Account__c == contactObj.AccountId) {
				 isExistingAccount = true;
				 break;
			 }		 
		 } 
		 if(isExistingAccount) {
			 throw new AuraHandledException('If you authorise contacts from an entire account, you cannot then add individual a contacts, before you delete all the contacts from 3rd party / Partner accounts, and vice versa.');
		 }
	 }	  
	 ServiceContract contractObj = [SELECT Id, CH_Entitlement__c FROM ServiceContract WHERE Id = :contractId];
	 if(contractObj == null || (contractObj != null && String.isBlank(contractObj.CH_Entitlement__c))) {
		 throw new AuraHandledException('No Authorized Entitlement found.');
	 }	 
	 String message = '';
	 EntitlementContact entContactObj = new EntitlementContact();
	 entContactObj.EntitlementId = contractObj.CH_Entitlement__c;
	 entContactObj.ContactId = contactObj.Id;
	 try {
		 insert entContactObj;
		 message = 'Contact added successfully';
	 } catch(Exception ex) {
		 System.debug('### ' + ex.getMessage());
		 throw new AuraHandledException('Unexpected error has occurred. Kindly contact System administrator.');
	 }
	 return message;
	}
}