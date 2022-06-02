/* Created Date: June 2018
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 
* Description : Accreditation level evalustion batch
* Test Class: 
*****************************************/
global class BatchAccreditationLevelEvalution implements Database.Batchable<sObject>, Database.Stateful {
	
	private List<Accreditation__c> newAccreditation =  new List<Accreditation__c>();
		/********************
	*Method Name: start
	*Parameter: Database.BatchableContext
	*Description: Start Method of Batch Class
	*******************/
	global Database.QueryLocator start(Database.BatchableContext BC){
		string query = PRMGlobalConstants.accrdeitationQuery_Part1 + system.label.Accredittaion_Automation_certification_Job_Function;
		query = query + PRMGlobalConstants.accrdeitationQuery_Part2;
		return Database.getQueryLocator(query);		
	}
		/********************
	*Method Name: execute
	*Parameter: Database.BatchableContext  BC
	*Description: Execute Method of Batch Class
	*******************/
	global void execute(Database.BatchableContext BC, List<Accreditation__c> accreditationList) {
		AccreditationLevelChange.evaluteAccreditationForLevelChange(accreditationList);
	}
		/********************
	*Method Name: finish
	*Parameter: Database.BatchableContext
	*Description: finish Method of Batch Class
	*******************/
	global void finish(Database.BatchableContext BC){
		
	}
}