/****************************************
 * Class Name : CH_ServiceContractTriggerHandler
 * Created Date: 31 August 2018
 * Created By : TCS
 * Last Modified by: TCS
 * Last Modified Date: 31 August 2018
 * Description : Handle the sequence of the ServiceContractTriggerHelper
 * Test Class: CH_ServiceContractTriggerHelperTest
 *****************************************/
public class CH_ServiceContractTriggerHandler {
	/********************
	*Method Name: beforeInsertOperation
	*Parameter: New ServiceContract List
	*Description: Used to handle before insert operation
	*******************/
	public static void beforeInsertOperation(List < ServiceContract > newContractList) {
		// Isolate CH_ServiceContract Record Type
		newContractList = isolateCaseHandlingRecordType(newContractList);
		// Populate lookup Id reference
	CH_ServiceContractTriggerHelper.populateLookupIds(newContractList);
	}
	
	/********************
	*Method Name: beforeUpdateOperation
	*Parameter: Old ServiceContract Map, New ServiceContract List
	*Description: Used to handle before update operation
	*******************/
	public static void beforeUpdateOperation(Map < Id, ServiceContract > oldContractMap, List < ServiceContract > newContractList) {
	// Isolate CH_ServiceContract Record Type
		newContractList = isolateCaseHandlingRecordType(newContractList);
		// Update lookup Id reference based on change in lookup reference name value
		CH_ServiceContractTriggerHelper.updateLookupIds(oldContractMap, newContractList);
	}
	
	/********************
	*Method Name: SharingServiceContractsRecords
	*Parameter: New ServiceContract List
	*Description: Used to handle before update operation
	*******************/
	public static void SharingServiceContractsRecords(Map<Id, ServiceContract> oldContractMap, Map<Id, ServiceContract> newContractMap) {
		CH_ServiceContractTriggerHelper.ServiceContractSharing(oldContractMap, newContractMap);
	}
	
	/********************
	*Method Name: afterInsertOperation
	*Parameter: New ServiceContract Map
	*Description: Used to handle after insert operation
	*******************/
	public static void afterInsertOperation(List < ServiceContract > newContractList) {
		// Isolate CH_ServiceContract Record Type
		newContractList = isolateCaseHandlingRecordType(newContractList);
		
		// Create authorized entitlement for service contract
		CH_ServiceContractTriggerHelper.createAuthorizedEntitlement(new Map < Id, ServiceContract > (newContractList));
		// Update authorized entitlement reference at service contract level for an easy access
		CH_ServiceContractTriggerHelper.updateAuthorizedEntitlementOnContract(new Map < Id, ServiceContract > (newContractList));
		
		// Declare List of ServiceContract which stores ServiceContract object whose previous contract id does not return any value
		List < ServiceContract > defaultProcessContractList = new List < ServiceContract > ();
		
		// Process batch class logic to copy all authorized contacts of previous serivce contract only if previous contract ids are populated
		List < ServiceContract > contractWithPreviousContractIds = isolateContractWithHavingPreviousContractIds(newContractList);
		if(contractWithPreviousContractIds != null && !contractWithPreviousContractIds.isEmpty()) {
			// Process batch to copy all authorized accounts of previous contract ids 
			defaultProcessContractList = CH_ServiceContractTriggerHelper.copyPreviousContractsAuthorizedAccounts(contractWithPreviousContractIds);
			// Process batch to copy all authorized contacts of previous contract ids 
			CH_ServiceContractTriggerHelper.copyPreviousContractsAuthorizedContacts(contractWithPreviousContractIds);
		}
		
		// Procss trigger logic if service contract does not have previous contract id set
		List < ServiceContract > contractWithoutPreviousContractIds = isolateContractWithoutHavingPreviousContractIds(newContractList);
		
		if(!defaultProcessContractList.isEmpty()) {
			contractWithoutPreviousContractIds.addAll(defaultProcessContractList);
		}
		
		if(contractWithoutPreviousContractIds != null && !contractWithoutPreviousContractIds.isEmpty()) {
			CH_ServiceContractTriggerHelper.createAuthorizedAccount(new Map < Id, ServiceContract > (contractWithoutPreviousContractIds));
		}
		//update HWS portal
		CH_ServiceContractTriggerHelper.updateHWSPortal(newContractList);
		CH_SecurityUtils.createNewSecurityRules(newContractList); //NOKIASC-25016
	}
	
	/********************
	*Method Name: isolateContractNotHavingPreviousContractIds
	*Parameter: New ServiceContract List
	*Description: Used to filter service contract that do not have previous contract id populated
	*******************/
	private static List < ServiceContract > isolateContractWithoutHavingPreviousContractIds(List < ServiceContract > newContractList) {
		List < ServiceContract > contractWithoutPreviousContractIds = new List < ServiceContract > ();
		for (ServiceContract contractObj: newContractList) {
			// Checks previous contract id field to add into contractWithoutPreviousContractIds
			if (String.isBlank(contractObj.CH_CDB_PreviousContractId__c)) {
	contractWithoutPreviousContractIds.add(contractObj);
			}
		}
		return contractWithoutPreviousContractIds;
	}
	
	/********************
	*Method Name: isolateContractHavingPreviousContractIds
	*Parameter: New ServiceContract List
	*Description: Used to filter hasPreviousContractId service contract
	*******************/
	private static List < ServiceContract > isolateContractWithHavingPreviousContractIds(List < ServiceContract > newContractList) {
		List < ServiceContract > contractWithPreviousContractIds = new List < ServiceContract > ();
		for (ServiceContract contractObj: newContractList) {
			// Checks previous contract id field to add into contractWithPreviousContractIds
			if (String.isNotBlank(contractObj.CH_CDB_PreviousContractId__c)) {
	contractWithPreviousContractIds.add(contractObj);
			}
		}
		return contractWithPreviousContractIds;
	}
	
	/********************
	*Method Name: isolateCaseHandlingRecordType
	*Parameter: New ServiceContract List
	*Description: Used to filter Case Handling Record Type Records
	*******************/
	private static List < ServiceContract > isolateCaseHandlingRecordType(List < ServiceContract > newContractList) {
		List < ServiceContract > chContractList = new List < ServiceContract > ();
		for (ServiceContract contractObj: newContractList) {
			// Checks hidden field on ServiceContract that is a formula field - boolean that returns true for the CH_ServiceContract Record Types
			if (contractObj.CH_RecordTypeCheck__c) {
	chContractList.add(contractObj);
			}
		}
		return chContractList;
	}
	
}