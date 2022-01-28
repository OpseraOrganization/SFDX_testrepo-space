/****************************************
* Class Name : CH_LegalEntitiesController
* Created Date: 20 Feb 2019
* Created By : Tiago Almeida (tiago.almeida@nokia.com)
* Last Modified by: Tiago Almeida
* Last Modified Date: 26 Feb 2019
* Description : Controller for the CH_LegalEntitiesRelatedList Component
* Test Class: 
*****************************************/
public class CH_LegalEntitiesController {
	/********************
	* Method Name: getContactList
	* Parameter: Id contactId
	* Description: Used to retrieve all the Entitlement Contacts of the parameter contact id
	* Reference: NOKIASC-15477
	*******************/
	@AuraEnabled
	public static List<EntitlementContact> getContactList(Id contactId) {
		if(String.isBlank(contactId)) {
			return null;			 
		}
		return [SELECT Id, EntitlementId, Entitlement.Account.Name, Entitlement.Account.AccountNumber, Entitlement.ServiceContract.Name FROM EntitlementContact WHERE ContactId= :contactId];
	}

}