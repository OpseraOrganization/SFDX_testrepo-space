/** 
 * About 
 * ----- 
 * @Description	  : CH_CaseTag__c Object Trigger Handler.
 * @TestClass		 : CH_CaseTagTriggerTest.
 * @Project	   : Case Handling.
 * @Modification Log : 
 *  Created  : 2020 06 25 – tiago.almeida@nokia.com
 * ----- 
**/
public with sharing class CH_CaseTagTriggerHandler extends TriggerHandler {
	private List<CH_CaseTag__c> oldList;
	private List<CH_CaseTag__c> newList;
	private Map<Id, CH_CaseTag__c> oldMap;
	private Map<Id, CH_CaseTag__c> newMap;
	private static final String OBJECT_NAME = String.valueOf(CH_CaseTag__c.sObjectType).replace('__c', '');
	private static final Map<String, Schema.RecordTypeInfo> RECORDTYPES = Schema.SObjectType.CH_CaseTag__c.getRecordTypeInfosByDeveloperName();
	private static final Id CH_RECORDTYPE_ID = RECORDTYPES.get('CH_CaseTag').getRecordTypeId();
	
	public CH_CaseTagTriggerHandler() {
		this.oldList = (List<CH_CaseTag__c>) Trigger.Old;
		this.newList = (List<CH_CaseTag__c>) Trigger.New;
		this.oldMap  = (Map<Id, CH_CaseTag__c>) Trigger.OldMap;
		this.newMap  = (Map<Id, CH_CaseTag__c>) Trigger.NewMap;
	}
	
	public override void beforeInsert(){
		if (!PAD.cantRun(OBJECT_NAME)){
			List<CH_CaseTag__c> oCHCaseTagList = isolateCHRecordType(newList);
			//
			CH_CaseTagTriggerHelper.validateProducts(oCHCaseTagList);
			CH_CaseTagTriggerHelper.preventDuplication(oCHCaseTagList);
		}
	}
	
	public override void beforeUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)){
			List<CH_CaseTag__c> oCHCaseTagList = isolateCHRecordType(newList);
			//
			CH_CaseTagTriggerHelper.preventDuplication(oCHCaseTagList);
		}
	}
	
	private static List<CH_CaseTag__c> isolateCHRecordType(List<CH_CaseTag__c> oCaseTagList) {
		List<CH_CaseTag__c> result = new List<CH_CaseTag__c>();
		for(CH_CaseTag__c oCaseTag: oCaseTagList) {
			if(oCaseTag.RecordTypeId == CH_RECORDTYPE_ID) {
				result.add(oCaseTag);
			}
		}
		return result;
	}
}