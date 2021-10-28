/**********************************************************************************************************
* Class Name : CH_SWSHistorical_CaseTeamHistUpdate
* Test Class Name : CH_SWSHistoricalCase_Test
* Created By : TCS
* Last Modified by: TCS
* Description : This batch class will update the Case Team Exit date of closed and completed SWS cases.
* User Story : https://jiradc2.ext.net.nokia.com/browse/NOKIASC-33494 
************************************************************************************************************/
global without sharing class CH_SWSHistorical_CaseTeamHistUpdate implements Database.Batchable<sObject> {
	
	global Database.QueryLocator start(Database.BatchableContext BC){	 
		
		return Database.getQueryLocator([select CH_CaseTeamExit__c,Id from CH_CaseTeamHistory__c where Support_Ticket__r.CH_RecordTypeCheck__c = TRUE and (Support_Ticket__r.Status = 'Completed' or Support_Ticket__r.Status = 'Cancelled') and CH_CaseTeamExit__c = null]);
		
	}
	global void execute(Database.BatchableContext BC,List<CH_CaseTeamHistory__c> casehistlist){ 
		List<CH_CaseTeamHistory__c> objCAseTeamHistory = new List<CH_CaseTeamHistory__c>();
		CH_CaseStatus_Validation_Bypass__c cussett = [Select id,CH_Disable_Validation_Rules__c from CH_CaseStatus_Validation_Bypass__c Limit 1];
		cussett.CH_Disable_Validation_Rules__c = true;
		update cussett;
		try{
			if(casehistlist.size()>0){
	for( CH_CaseTeamHistory__c cHist : casehistlist )
	{
		cHist.CH_CaseTeamExit__c = System.now();
		objCAseTeamHistory.add(cHist);
		
	}
	Update objCAseTeamHistory;
			}
		}
		catch(Exception ex)
		{
			System.debug('Exception Caught');
		}
		
		
	}
	global void finish(Database.BatchableContext BC) {
		AsyncApexJob a = [SELECT Id,Status,JobType,NumberOfErrors,JobItemsProcessed,TotalJobItems,CompletedDate,ExtendedStatus,CreatedBy.Email
		FROM AsyncApexJob WHERE Id =:bc.getJobId()];			
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setSubject('Historical SWS Case Team History Exit Date Update-' + a.Status+' In '+UserInfo.getUserName().substringAfterLast('.'));
		mail.setTargetObjectId(a.CreatedBy.id);
		mail.setSaveAsActivity(false);
		mail.setPlainTextBody
			('The batch Apex job completed on  ' + a.CompletedDate + ',\n\n' +'Created By : '+a.CreatedBy.Email+'\n'+
	'Job Status : ' + a.Status + '\n'+
	'Total Job Items processed : ' + a.TotalJobItems + '\n'+
	'Number of Job Items processed : ' + a.JobItemsProcessed + '\n' +
	'Number of Failures : '+ a.NumberOfErrors);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		// Database.executeBatch(new CH_SWSHistorical_DeleteCaseTeam(),20);
		
		
	}
	
	
	
}