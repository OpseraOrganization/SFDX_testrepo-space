/****************************************
* Class Name : CH_ProcessClosedLegacyCasesBatch
* Created Date: 28th Feb 2020
* Created By : TCS
* Last Modified by: Prateek Sarangi
*****************************************/
global without sharing class CH_ProcessClosedLegacyCasesBatch implements Database.Batchable<sObject>, Schedulable, Database.Stateful{
	global List<Interface_Log__c> logsClosedLegacy = new List<Interface_Log__c>();
	global Set<Id> caseIds = new Set<Id> ();
	global Database.QueryLocator start(Database.BatchableContext BC){
		//Using Custom Metadata CH_LegacyCasesBatchQuery to make this query configurable
		CH_LegacyCasesBatchQuery__mdt closedLegacyCasesBatchQuery = [Select CH_LegacyCasesBatchQuery__c from CH_LegacyCasesBatchQuery__mdt where Label= 'Closed'];
		return Database.getQueryLocator(closedLegacyCasesBatchQuery.CH_LegacyCasesBatchQuery__c);
	}
	global void execute(Database.BatchableContext BC, List<Case> newCaseList){
		CH_CaseTriggerHelper.fetchCaseFields(newCaseList, null);	   
		CH_SecurityUtils.setCaseSecurityGroups(newCaseList, null);
		CH_AuthorizedContactSharing.handleSharing(new Map<Id, Case>(newCaseList), new Map<Id, Case>(), true, false);		
		 /*To update CH_BlockCases__c field as true -- For 32408*/
		CH_CaseTriggerHelper.CH_BlacklistCaseReportTrigger(newCaseList);
		 /*To update CH_BlockCases__c field as true -- For 32408*/
		for(Case updateCase: newCaseList ){
			updateCase.HWS_DeliveryNote__c='processed';
			caseIds.add(updateCase.Id);			
			CH_LegacyCasesBatchUtility.caseValuesSet(updateCase);//Added to avoid duplicate Code NOKIASC-31968 
		   
		}
		
		List<Case> closedLegacyCases=CH_LegacyCasesBatchUtility.newCaseListSet(newCaseList);//Added to avoid duplicate Code NOKIASC-31968
		Database.SaveResult[] caseListNew = Database.update(closedLegacyCases,false);   
		Integer i=0;
		for(Database.SaveResult results : caseListNew){
			if(!results.isSuccess()){
				for(Database.Error err : results.getErrors()) {
					logsClosedLegacy.add(new Interface_Log__c(
						Comment__c = 'Error with the Case with Id: ' +newCaseList.get(i).Id + '--> ' + err.getMessage(),
						Interface_Type__c = 'Closed Legacy Case Error'
					));
				}
			}
			i++; 
		}
		Database.insert(logsClosedLegacy,false);
	}
	global void finish(Database.BatchableContext BC){
		//
	}
	global void execute(SchedulableContext SC){
		CH_ProcessClosedLegacyCasesBatch  batch = new CH_ProcessClosedLegacyCasesBatch();
		Database.executebatch(batch,50);	 
	}
}