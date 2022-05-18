/****************************************
 * Class Name : CH_ServiceContractTriggerHandler
 * Created Date: 31 August 2018
 * Created By : TCS
 * Last Modified by: TCS
 * Last Modified Date: 31 August 2018
 * Description : Handle the sequence of the ServiceContractTriggerHelper
 * Test Class: CH_ServiceContractTriggerHelperTest
 *****************************************/
public class CH_ServiceContractTriggerHandler extends TriggerHandler {
	private List<ServiceContract> oldList;
	private List<ServiceContract> newList;
	private Map<Id, ServiceContract> oldMap;
	private Map<Id, ServiceContract> newMap;
	 
	public CH_ServiceContractTriggerHandler() {
		this.oldList = (List<ServiceContract>) Trigger.Old;
		this.newList = (List<ServiceContract>) Trigger.New;
		this.oldMap  = (Map<Id, ServiceContract>) Trigger.OldMap;
		this.newMap  = (Map<Id, ServiceContract>) Trigger.NewMap;
	}
	
	/*
	* @description : beforeInsert handle the ServiceContract beforeInsert event on ServiceContract.
	*/
	public override void beforeInsert(){
		System.debug('Service contract Handler beforeInsertOperation'+newList);
		//NOKIASC-31035 To prevent being vendor service contract owner without Admin or specific permissionsets
		//Map <Id, ServiceContract> oldContractMap=new Map <Id, ServiceContract>();
		CH_ServiceContractTriggerHelper.validateVendorContractOwner(oldMap, newList);
		// Isolate CH_ServiceContract Record Type
		// Populate lookup Id reference
		CH_ServiceContractTriggerHelper.populateLookupIds(isolateCaseHandlingRecordType(newList));
	}
	
	/*
	* @description : afterInsert handle the ServiceContract afterInsert event on ServiceContract.
	*/
	public override void afterInsert(){
		if(CH_AvoidRecursion.runOnce()) {
			// Isolate CH_ServiceContract Record Type
			List <ServiceContract> newContractList = isolateCaseHandlingRecordType(newList);
			
			// Create authorized entitlement for service contract
			CH_ServiceContractTriggerHelper.createAuthorizedEntitlement(new Map <Id, ServiceContract> (newContractList));
			// Update authorized entitlement reference at service contract level for an easy access
			CH_ServiceContractTriggerHelper.updateAuthorizedEntitlementOnContract(new Map <Id, ServiceContract> (newContractList));
			
			// Declare List of ServiceContract which stores ServiceContract object whose previous contract id does not return any value
			List <ServiceContract> defaultProcessContractList = new List <ServiceContract> ();
			
			// Process batch class logic to copy all authorized contacts of previous serivce contract only if previous contract ids are populated
			List <ServiceContract> contractWithPreviousContractIds = isolateContractWithHavingPreviousContractIds(newContractList);
			if(contractWithPreviousContractIds != null && !contractWithPreviousContractIds.isEmpty()) {
	// Process batch to copy all authorized accounts of previous contract ids 
	defaultProcessContractList = CH_ServiceContractTriggerHelper.copyPreviousContractsAuthorizedAccounts(contractWithPreviousContractIds);
	// Process batch to copy all authorized contacts of previous contract ids 
	CH_ServiceContractTriggerHelper.copyPreviousContractsAuthorizedContacts(contractWithPreviousContractIds);
			}
			
			// Procss trigger logic if service contract does not have previous contract id set
			List <ServiceContract> contractWithoutPreviousContractIds = isolateContractWithoutHavingPreviousContractIds(newContractList);
			
			if(!defaultProcessContractList.isEmpty()) {
	contractWithoutPreviousContractIds.addAll(defaultProcessContractList);
			}
			
			if(contractWithoutPreviousContractIds != null && !contractWithoutPreviousContractIds.isEmpty()) {
	CH_ServiceContractTriggerHelper.createAuthorizedAccount(new Map <Id, ServiceContract> (contractWithoutPreviousContractIds));
			}
			//update HWS portal
			CH_ServiceContractTriggerHelper.updateHWSPortal(newContractList);
			CH_SecurityUtils.createNewSecurityRules(newContractList); //NOKIASC-25016
			CH_ServiceContractTriggerHelper.ServiceContractSharing(oldMap, newMap);
			CH_ServiceContractTriggerHelper.createAuthorizedContact(new Map <Id, ServiceContract> (newContractList));//NOKIASC-35113
		}
	}
	
	/*
	* @description : beforeUpdate handle the ServiceContract beforeUpdate event on ServiceContract.
	*/
	public override void beforeUpdate(){
	//NOKIASC-31035 To prevent being vendor service contract owner without Admin or specific permissionsets
		CH_ServiceContractTriggerHelper.validateVendorContractOwner(oldMap,newList);
		// Update lookup Id reference based on change in lookup reference name value
		CH_ServiceContractTriggerHelper.updateLookupIds(oldMap, isolateCaseHandlingRecordType(newList));
	}
	
	/*
	* @description : afterUpdate handle the ServiceContract afterUpdate event on ServiceContract.
	*/
	public override void afterUpdate(){
		CH_ServiceContractTriggerHelper.deleteCompetitorAC(oldMap, newMap);
		if(CH_AvoidRecursion.runOnce()){
			CH_ServiceContractTriggerHelper.ServiceContractSharing(oldMap, newMap);
			//Changes added for NOKIASC-35113
			List <ServiceContract> newContrctList = isolateCaseHandlingRecordType(newList);
			CH_ServiceContractTriggerHelper.updateAuthorizedContact(oldMap, newContrctList);
		}
	}
	
	/*
	* @description : beforeDelete handle the ServiceContract beforeDelete event on ServiceContract.
	*/
	public override void beforeDelete(){
		
	}
	
	/*
	* @description : afterDelete handle the ServiceContract afterDelete event on ServiceContract.
	*/
	public override void afterDelete(){
		
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
			Boolean retrofitCheck = (contractObj.HWS_Retrofit_Type__c == null);
			if (String.isBlank(contractObj.CH_CDB_PreviousContractId__c) && retrofitCheck) {
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
			Boolean retrofitCheck = (contractObj.HWS_Retrofit_Type__c == null);
			if (String.isNotBlank(contractObj.CH_CDB_PreviousContractId__c) && retrofitCheck) {
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
			if (contractObj.CH_RecordTypeCheck__c ) {
	chContractList.add(contractObj);
			}
		}
		return chContractList;
	}
}