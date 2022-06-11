/*******************************************************************************************
* Class Name : CH_HWSHistoricalCase_OwnerUpdate
* Test Class Name : CH_HWSHistoricalCase_OwnerUpdate_Test
* Created By : TCS
* Last Modified by: TCS
* Description : This batch class will update the owner of closed and cancelled HWS cases.
* User Story : https://jiradc2.ext.net.nokia.com/browse/NOKIASC-33494 
********************************************************************************************/
global without sharing class CH_HWSHistoricalCase_OwnerUpdate implements Database.Batchable<sObject> {
	
	global Database.QueryLocator start(Database.BatchableContext BC){	 
		
		return Database.getQueryLocator([SELECT id,Ownerid FROM Case where status in ('Closed','Cancelled') AND HWS_RecordTypeCheck__c = TRUE]);
		
	}
	global void execute(Database.BatchableContext BC,List<Case> hwsCase){ 
		String archiveOwnerid = [Select id from User where name='Archived Case No Owner'].id;
		
		try{
			if(hwsCase.size()>0){
	for( Case ocase : hwsCase )
	{
		ocase.Ownerid=archiveOwnerid;
		
	}
	Update hwsCase;
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
		mail.setSubject('Historical HWS Owner Update - ' + a.Status+' In '+UserInfo.getUserName().substringAfterLast('.'));
		mail.setTargetObjectId(a.CreatedBy.id);
		mail.setSaveAsActivity(false);
		mail.setPlainTextBody
			('The batch Apex job completed on  ' + a.CompletedDate + ',\n\n' +'Created By : '+a.CreatedBy.Email+'\n'+
	'Job Status : ' + a.Status + '\n'+
	'Total Job Items processed : ' + a.TotalJobItems + '\n'+
	'Number of Job Items processed : ' + a.JobItemsProcessed + '\n' +
	'Number of Failures : '+ a.NumberOfErrors);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		//Database.executeBatch(new CH_SWSHistorical_CaseTeamHistUpdate(),20);
		
		
	}
	
	
}