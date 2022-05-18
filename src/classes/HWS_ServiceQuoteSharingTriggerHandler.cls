/****************************************************************
* Class Name : HWS_ServiceQuoteSharingTriggerHandler 
* Created Date: 05-11-2021
* Created By: TCS
* Description : This Class is used as handler for ServiceQuoteSharingTrigger Trigger
* Modification Log:
---------------------------------------------------------
Modified By	 Modified For US#	Modified Date

******************************************************************/
public class HWS_ServiceQuoteSharingTriggerHandler extends TriggerHandler{ 
	
	private List<HWS_Service_Quote__c> newList;
	private List<HWS_Service_Quote__c> oldList;
	private Map<Id,HWS_Service_Quote__c> newMap;
	private Map<Id,HWS_Service_Quote__c> oldMap;
	
	public HWS_ServiceQuoteSharingTriggerHandler() {
		this.newList = (List<HWS_Service_Quote__c>) Trigger.New;
		this.oldList = (List<HWS_Service_Quote__c>) Trigger.Old;
		this.oldMap = (Map<Id,HWS_Service_Quote__c>) Trigger.oldMap;
		this.newMap = (Map<Id,HWS_Service_Quote__c>) Trigger.newMap;
	}
	
	/*
	* @description : afterInsert handle the HWS_Service_Quote__c afterInsert event on HWS_Service_Quote__c.
	*/
	public override void afterInsert(){}
	
	/*
	* @description : afterUpdate handle the HWS_Service_Quote__c afterUpdate event on HWS_Service_Quote__c.
	*/
	public override void afterUpdate(){
		HWS_ServiceQuoteSharingTriggerHelper.updateSharing(oldMap,newMap);
		HWS_ServiceQuoteSharingTriggerHelper.autoAssignToWorkgroups(oldMap,newMap); 
		HWS_ServiceQuoteSharingTriggerHelper.sendOwnerAssignmentEmail(oldMap,newMap);
		HWS_ServiceQuoteUtility.createOrLinkSuspensionRecord(oldMap,newMap);//Moved code to without sharing
	}
	
	/*
	* @description : beforeUpdate handle the HWS_Service_Quote__c beforeUpdate event on HWS_Service_Quote__c.
	*/
	public override void beforeUpdate(){ }
}