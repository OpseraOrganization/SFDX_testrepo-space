/****************************************
 * Class Name : CH_EntitlementTriggerHandler 
 * Created Date: 25 September 2018
 * Created By : TCS
 * Last Modified by: TCS
 * Last Modified Date: 25 September 2018
 * Description : Handle the sequence of the CH_EntitlementTriggerHelper
 * Test Class: CH_EntitlementTriggerHelperTest 
 *****************************************/
public class CH_EntitlementTriggerHandler extends TriggerHandler {
	private List<Entitlement> oldList;
	private List<Entitlement> newList;
	private Map<Id, Entitlement> oldMap;
	private Map<Id, Entitlement> newMap;
		
	public CH_EntitlementTriggerHandler() {
		this.oldList = (List<Entitlement>) Trigger.Old;
		this.newList = (List<Entitlement>) Trigger.New;
		this.oldMap  = (Map<Id, Entitlement>) Trigger.OldMap;
		this.newMap  = (Map<Id, Entitlement>) Trigger.NewMap;
	}
	
	/*
	* @description : beforeInsert handle the Entitlement beforeInsert event on Entitlement.
	*/
	public override void beforeInsert(){
		CH_EntitlementTriggerHelper.populateSLAProcessIds(isolateCaseHandlingRecordType(newList));
	}
	
	/*
	* @description : afterInsert handle the Entitlement afterInsert event on Entitlement.
	*/
	public override void afterInsert(){
		CH_EntitlementTriggerHelper.updateContractLineItemRecordsOnInsert(isolateCaseHandlingRecordType(newList));
	}
	
	/*
	* @description : beforeUpdate handle the Entitlement beforeUpdate event on Entitlement.
	  @description : Added the newmap for 34017	
	*/
	public override void beforeUpdate(){
		CH_EntitlementTriggerHelper.updateSLAProcessIds(oldMap,newMap,isolateCaseHandlingRecordType(newList));
	}
	
		/*
	* @description : afterUpdate handle the Entitlement afterUpdate event on Entitlement.
	*/
	public override void afterUpdate(){
		CH_EntitlementTriggerHelper.updateContractLineItemRecordsOnUpdate(oldMap, isolateCaseHandlingRecordType(newList));
		CH_EntitlementTriggerHelper.updateCustomerSpecificTargetSLA(oldMap, isolateCaseHandlingRecordType(newList));
	}
	
	/*
	* @description : beforeDelete handle the Entitlement beforeDelete event on Entitlement.
	*/
	public override void beforeDelete(){
		
	}
	
		/*
	* @description : afterDelete handle the Entitlement afterDelete event on Entitlement.
	*/
	public override void afterDelete(){
		
	}
	
	/********************
	*Method Name: isolateCaseHandlingRecordType
	*Parameter: New Entitlement List
	*Description: Used to filter Case Handling Record Type Records
	*******************/
	private static List < Entitlement > isolateCaseHandlingRecordType(List < Entitlement > newEntitlementList) {
		List < Entitlement > entList = new List < Entitlement > ();
		for (Entitlement entObj: newEntitlementList) {
			//Checks hidden field on Entitlement that is a formula field - boolean that returns true for the CH_Entitlement Record Types
			if (entObj.CH_RecordTypeCheck__c) {
				entList.add(entObj);
			}
		}
		return entList;
	}
}