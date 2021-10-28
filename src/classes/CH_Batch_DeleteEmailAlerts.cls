/*************************************************************************************************
* Class Name : Batch_DeleteEmailAlerts
* Created Date: 2nd Feb 2021
* Created By : TCS
* Description: Batch class for Delete Email Alerts
* Last Modified by: 
* Last Modified Date: 
* Description : 
*************************************************************************************************/

global with sharing class CH_Batch_DeleteEmailAlerts implements Database.Batchable<sObject>{

global Database.queryLocator Start(Database.BatchableContext BC){

string emailAlerts = 'SELECT Id,CreatedDate from CH_EmailAlert__c where CreatedDate = LAST_N_DAYS:30';
return Database.getQueryLocator(emailAlerts);

}
global void execute(Database.BatchableContext BC,List<CH_EmailAlert__c> emailAlertsList){
 delete emailAlertsList;
}
global void Finish(Database.BatchableContext BC){

}
}