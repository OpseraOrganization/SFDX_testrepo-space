/****************************************
 * Class Name : CH_AuthorizedAccountTriggerHandler 
 * Created Date: 13 September 2018
 * Created By : TCS
 * Last Modified by: TCS
 * Last Modified Date: 13 September 2018
 * Description : Handle the sequence of the CH_AuthorizedAccountTriggerHelper
 * Test Class: CH_AuthorizedAccountTriggerTest
 *****************************************/
public class CH_AuthorizedAccountTriggerHandler {
	/********************
	*Method Name: beforeTriggerOperation
	*Parameter: New CH_AuthorizedAccount__c List
	*Description: Used to handle before insert operation
	*******************/
	public static void beforeTriggerOperation(List < CH_AuthorizedAccount__c > newAuthAccountList) {
		// To filter records which only requires trigger execution
		newAuthAccountList = isolateSkipTriggerRecords(newAuthAccountList);
		
		CH_AuthorizedAccountTriggerHelper.duplicateRecordCheck(newAuthAccountList);
	}
	
	/********************
	*Method Name: afterInsertOperation
	*Parameter: New CH_AuthorizedAccount__c List
	*Description: Used to handle after insert operation
	*******************/
	public static void afterInsertOperation(List < CH_AuthorizedAccount__c > newAuthAccountList) {
		// To filter records which only requires trigger execution
		newAuthAccountList = isolateSkipTriggerRecords(newAuthAccountList);
		if(UserInfo.getUserId() != System.Label.CH_IPaas_User_Id){
			CH_AuthorizationHistory.create('Add', newAuthAccountList);
		}
		CH_AuthorizedAccountTriggerHelper.createEntitlementContact(newAuthAccountList);
	}
	
	/********************
	*Method Name: afterInsertOperation
	*Parameter: Old CH_AuthorizedAccount__c Map, New CH_AuthorizedAccount__c List
	*Description: Used to handle after update operation
	*******************/
	public static void afterUpdateOperation(Map < Id, CH_AuthorizedAccount__c > oldAuthAccountMap, Map < Id, CH_AuthorizedAccount__c > newAuthAccountMap) {
		CH_AuthorizedAccountTriggerHelper.updateEntitlementContact(oldAuthAccountMap, newAuthAccountMap);
	}
	
	/********************
	*Method Name: afterDeleteOperation
	*Parameter: New CH_AuthorizedAccount__c List
	*Description: Used to handle before delete operation
	*******************/
	public static void afterDeleteOperation(List < CH_AuthorizedAccount__c > oldAuthAccountList) {
	 if(UserInfo.getUserId() != System.Label.CH_IPaas_User_Id){
			CH_AuthorizationHistory.create('Delete', oldAuthAccountList);
		}
		CH_AuthorizedAccountTriggerHelper.deleteEntitlementContact(oldAuthAccountList);
	}
	
	/********************
	*Method Name: isolateSkipTriggerRecords
	*Parameter: New ServiceContract List
	*Description: Used to filter records which requires trigger execution
	*******************/
	private static List < CH_AuthorizedAccount__c > isolateSkipTriggerRecords(List < CH_AuthorizedAccount__c > newAuthAccountList) {
		List < CH_AuthorizedAccount__c > authAccountList = new List < CH_AuthorizedAccount__c > ();
		for (CH_AuthorizedAccount__c authAccountObj: newAuthAccountList) {
			// Checks hidden field on CH_AuthorizedAccount__c that is a checkbox field - boolean that returns true if trigger needs to run
			if (authAccountObj.CH_IsTriggerRun__c) {
	authAccountList.add(authAccountObj);
			}
		}
		return authAccountList;
	}
}