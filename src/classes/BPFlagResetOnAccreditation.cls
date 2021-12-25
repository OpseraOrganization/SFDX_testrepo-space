/* Created Date: June 2018
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 
* Description : update Accreditation BP Status on start of Fiscal year
* Test Class: 
 *****************************************/
global class BPFlagResetOnAccreditation implements Database.Batchable<sObject>, Database.Stateful {	
	private List<Accreditation__c> newAccreditation =  new List<Accreditation__c>();   
	 /********************
	*Method Name: start
	*Parameter: Database.BatchableContext
	*Description: Start Method of Batch Class
	*******************/
   global Database.QueryLocator start(Database.BatchableContext BC){
	   //syste.debug('query location ... '+ Database.getQueryLocator('select id, Partner_Business_Plan_Status__c from Accreditation__c where Partner_Business_Plan_Status__c = '\'Approved\''));
	return Database.getQueryLocator(PRMGlobalConstants.BPQuery);
   }
   /********************
	*Method Name: execute
	*Parameter: Database.BatchableContext  BC
	*Description: Execute Method of Batch Class
	*******************/
	global void execute(Database.BatchableContext BC, List<Accreditation__c> accreditationList) {
		list<Accreditation__c> accredToUpdate = new list<Accreditation__c>();
		for(Accreditation__c accred : accreditationList){
		   accred.Partner_Business_Plan_Status__c = PRMGlobalConstants.None;
		   accredToUpdate.add(accred);
		} 
		database.update(accredToUpdate);
	}
	/********************
	*Method Name: finish
	*Parameter: Database.BatchableContext
	*Description: finish Method of Batch Class
	*******************/
	global void finish(Database.BatchableContext BC){	   
	}
}