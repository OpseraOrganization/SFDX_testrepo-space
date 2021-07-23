/** 
 * About 
 * ----- 
 * @Description	  : Case Handling Contact Object Utility Class.
 * @TestClass		: CH_ContactUtils_Test.
 * @Project		  : Case Handling.
 * @Modification Log : 
 *  Created  : 2019 12 04 – tiago.almeida@nokia.com
 * ----- 
**/
public class CH_ContactUtils {
	public static DML_SObject DM_Contact = new DML_SObject(Contact.sObjectType);

	/**
	 * @description : Get Current User Contact Details - NOKIASC-#####
	 * @return	  : Contact
	**/
	public static Contact getCurrentUserContactDetails() {
		List<User> oUserList = DML_SObject.doQuery('SELECT Id, ContactId FROM User WHERE Id = "'+UserInfo.getUserId()+'" LIMIT 1');
		try {
			List<Contact> oContactList = DM_Contact.doSelect('Id, Name').doWhere('Id = "'+oUserList.get(0).contactId+'"').setOptions('LIMIT 1').doQuery();
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
				List<Contact> oContactList = DM_Contact.doSelect('Id, Name').doWhere('Id = "'+contactId+'"').setOptions('LIMIT 1').doQuery();
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
	 * @param	   : Id contactId
	 * @return	  : Boolean
	**/
	public static Boolean contactIsInternalAuthorized(Id contactId) {
		List<EntitlementContact> oEntitlementContact = DML_SObject.doQuery(
			'SELECT Id FROM EntitlementContact WHERE ContactId = "' + contactId  + '" AND Entitlement.ServiceContract.CH_ServiceContractType__c = "Internal Contract"'
		);
		return !oEntitlementContact.isEmpty();
	}
}