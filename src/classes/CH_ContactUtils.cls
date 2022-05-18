/** 
 * About 
 * ----- 
 * @Description	  : Case Handling Contact Object Utility Class.
 * @TestClass		: CH_ContactUtils_Test.
 * @Project	: Case Handling.
 * @Modification Log : 
 *  Created  : 2019 12 04 – tiago.almeida@nokia.com
 * ----- 
**/
public without sharing class CH_ContactUtils {
	public static final DML_SObject DML = new DML_SObject(Contact.sObjectType);
	/**
	 * @description : Get Current User Contact Details - NOKIASC-#####
	 * @return	  : Contact
	**/
	public static Contact getCurrentUserContactDetails() {
		List<User> oUserList = DML_SObject.doQuery('SELECT Id, ContactId FROM User WHERE Id = "'+UserInfo.getUserId()+'" LIMIT 1');
		try {
			List<Contact> oContactList = DML.doSelect('Id, Name').doWhere('Id = "'+oUserList.get(0).contactId+'"').setOptions('LIMIT 1').doQuery();
			return oContactList.get(0);
		} catch (Exception e) {
			System.debug('CH_ContactUtils Error: No User or Contact found!');
			throw new AuraHandledException('No Country found!');
		}
	}
	
	/**
	 * @description : Get Contact Name - NOKIASC-#####
	 * @param 		: Id contactId
	 * @return	  : String
	**/
	public static String getContactName(Id contactId){
		String result = '';
		if(contactId != null) {
			try {
	List<Contact> oContactList = DML.doSelect('Id, Name').doWhere('Id = "'+contactId+'"').setOptions('LIMIT 1').doQuery();
	result = (oContactList.get(0) != null ? oContactList.get(0).Name : 'Contact object not found');
			} catch (Exception e) {
	System.debug('CH_ContactUtils Error: No User or Contact found!');
	throw new AuraHandledException('No Country found!');
			}
		}
		return result;
	}
	
	/**
	 * @description : Check if Contact is authorized to Internal Support Happy Path - NOKIASC-27047
	 * @param	: Id contactId
	 * @return	  : Boolean
	**/
	public static Boolean contactIsInternalAuthorized(Id contactId) {
		List<EntitlementContact> oEntitlementContact = DML_SObject.doQuery(
			'SELECT Id FROM EntitlementContact WHERE ContactId = "' + contactId  + '" AND Entitlement.ServiceContract.CH_ServiceContractType__c = "Internal Contract"'
		);
		return !oEntitlementContact.isEmpty();
	}	
	
	/**
	 * @description : 
	 * @param	: Id recordId
	 * @return	  : List<SObject>
	**/
	public static List<SObject> searchContacts(Id oContractId, String contactGlobalSearch, String contactId, String email, String accountName) {
		List<SObject> result = new List<SObject>();
		if(String.isNotBlank(oContractId)) {
			Set<String> oAccountIdSet = new Map<String, CH_AuthorizedAccount__c>([SELECT Id, CH_Account__c FROM CH_AuthorizedAccount__c WHERE CH_ServiceContract__c = :oContractId]).keySet();
			String sWhere = 'AccountId NOT IN ' + DML_SObject.setToString(oAccountIdSet) + ' AND CH_Legal_Entity_Name__c != null ';
			if(String.isNotBlank(contactId)) sWhere += 'AND CH_ContactId__c  LIKE "%' + String.escapeSingleQuotes(contactId.trim()) + '%" ';
			if(String.isNotBlank(contactGlobalSearch)) {
	List<List<SObject>> oContactList = DML_SObject.doSearch('FIND {*' + String.escapeSingleQuotes(contactGlobalSearch.trim()) + '*} IN All FIELDS RETURNING Contact(Id)');
	if(!oContactList.isEmpty()) {
		Set<String> oSearchContactIdSet = new Map<String, SObject>(oContactList.get(0)).keySet();
		if(!oSearchContactIdSet.isEmpty()) sWhere += 'AND Id IN ' + DML_SObject.setToString(oSearchContactIdSet) + ' ';
	}
			}
			if(String.isNotBlank(email)) sWhere += 'AND Email LIKE "%' + String.escapeSingleQuotes(email.trim()) + '%" ';
			if(String.isNotBlank(accountName)) sWhere += 'AND CH_Legal_Entity_Name__c LIKE "%' + String.escapeSingleQuotes(accountName.trim()) + '%" ';
			result = DML.doSelect('Id, Name, IsActive__c, Phone, MobilePhone, Email, CH_Legal_Entity_Name__c, CH_ContactTimeZone__c, Country__c, CH_ContactType__c').doWhere(sWhere).doQuery();	  
		}
		return result;
	}
}