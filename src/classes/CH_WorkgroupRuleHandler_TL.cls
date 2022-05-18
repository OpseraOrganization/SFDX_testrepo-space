/**
About
-----
Description: This Class is used as Helper for CH_WorkgroupRuleTrigger.

Created for: Nokia Portugal COE (ERM)
Created: 19 02 2019

Update History
--------------
Created: 19 02 2019 – flavio.toscano@nokia.com
-------------
**/
public with sharing class CH_WorkgroupRuleHandler_TL {

	/*
	* @description : CH_ProductId__c based on Product__c in order to run the Duplicate Rules
	* @param : List<CH_Workgroup_Rule__c>
	* @return : void
	*/
	public static void updateProductId(List<CH_Workgroup_Rule__c> oCH_WorkgroupRule) {
		final Id workgroupRuleRT = Utils.MapRecordType('CH_Workgroup_Rule__c').get('CH_KB_WorkgroupRule');

		for(CH_Workgroup_Rule__c oWorkgroupRule: oCH_WorkgroupRule){
			if(oWorkgroupRule.RecordTypeId == workgroupRuleRT) {
	oWorkgroupRule.CH_ProductId__c = oWorkgroupRule.CH_Product__c;
	oWorkgroupRule.CH_WorkgroupId__c = oWorkgroupRule.CH_Workgroup__c;
			}
		}
	}
	
	public static void isValidUser(List<CH_Workgroup_Rule__c> oCH_WorkgroupRule) {
		final Id workgroupRuleRT = Utils.MapRecordType('CH_Workgroup_Rule__c').get('CH_CA_WorkgroupRule');
		for(CH_Workgroup_Rule__c oWorkgroupRule: oCH_WorkgroupRule){
			if(oWorkgroupRule.RecordTypeId == workgroupRuleRT) {
				Boolean value=CH_Workgroup_Controller.getValidUser();
				if(!value){
					//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
					oWorkgroupRule.addError(System.Label.CH_Not_Authorized_To_Delete_CA_WG_Rule);
				}
			}
		}
	}
}