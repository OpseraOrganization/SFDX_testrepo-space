/***************************************
* Handler Class : CH_ProductLogTypeTrigger_Handler
* Description - Handler class for trigger 'CH_ProductLogTypeTrigger' and related helper 'CH_ProductLogTypeTrigger_Helper'
* Created Details - 
* Developer - TCS 
* Date - 16 June 2021
* User Story - NOKIASC-36516
*****************************************/

public without sharing class CH_ProductLogTypeTrigger_Handler extends TriggerHandler {
	private List<CH_ProductLogType__c> newProductLogTypeList;
	public CH_ProductLogTypeTrigger_Handler() {
		
		this.newProductLogTypeList = (List<CH_ProductLogType__c>) Trigger.New;
	
	  }
	
	public override void beforeInsert() { 
	CH_ProductLogTypeTrigger_Helper.validateDuplication(newProductLogTypeList);
	 }
	
	public override void beforeUpdate() {
	 CH_ProductLogTypeTrigger_Helper.validateDuplication(newProductLogTypeList);
	 }
	
}