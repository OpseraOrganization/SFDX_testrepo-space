/** 
About
-----
Description: This Class is used as handler for CH_ProductRelationTrigger

Created for: Nokia Portugal COE
Created: 17 04 2019

Update History
--------------
Created: 17 04 2019 – flavio.toscano@nokia.com
-------------
**/
public with sharing class CH_ProductRelationHandler_TH extends TriggerHandler {
	private List<CH_ProductRelation__c> oldList;
	private List<CH_ProductRelation__c> newList;
	private Map<Id, CH_ProductRelation__c> oldMap;
	private Map<Id, CH_ProductRelation__c> newMap;

	public CH_ProductRelationHandler_TH() {
		this.oldList = (List<CH_ProductRelation__c>) Trigger.Old;
		this.newList = (List<CH_ProductRelation__c>) Trigger.New;
		this.oldMap  = (Map<Id, CH_ProductRelation__c>) Trigger.OldMap;
		this.newMap  = (Map<Id, CH_ProductRelation__c>) Trigger.NewMap;
	}

	/*
	* @description : afterInsert handle the CH_Workgroup afterInsert event on CH_ProductRelation__c.	
	*/
	public override void afterInsert(){
	 if(UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) || Test.isRunningTest()){
			System.enqueuejob(new CH_UpdateKBProductsQueueable(newList));
		}
	}
}