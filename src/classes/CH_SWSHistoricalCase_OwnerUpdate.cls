/*************************************************************************************************
* Class Name : CH_SWSHistoricalCase_OwnerUpdate
* Test Class Name : CH_SWSHistoricalCase_Test
* Created By : TCS
* Last Modified by: TCS
* Description : This batch class will update owner of completed and cancelled SWS cases.
* User Story : https://jiradc2.ext.net.nokia.com/browse/NOKIASC-33494 
****************************************************************************************************/
global without sharing class CH_SWSHistoricalCase_OwnerUpdate implements Database.Batchable<sObject> {
	
	global Database.QueryLocator start(Database.BatchableContext BC){	 
		
		return Database.getQueryLocator([SELECT id,Ownerid FROM Case where status in ('Completed','Cancelled') AND CH_RecordTypeCheck__c = TRUE]);
		
	}
	global void execute(Database.BatchableContext BC,List<Case> swsCase){ 
		String archiveOwnerid = [Select id from User where name='Archived Case No Owner'].id;
		CH_CaseStatus_Validation_Bypass__c cussett = [Select id,CH_Disable_Validation_Rules__c from CH_CaseStatus_Validation_Bypass__c Limit 1];
		cussett.CH_Disable_Validation_Rules__c = true;
		update cussett;
		try{
			if(swsCase.size()>0){
	for( Case ocase : swsCase )
	{
		ocase.Ownerid=archiveOwnerid;
		
	}
	Update swsCase;
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
		mail.setSubject('Historical SWS Owner Update - ' + a.Status+' In '+UserInfo.getUserName().substringAfterLast('.'));
		mail.setTargetObjectId(a.CreatedBy.id);
		mail.setSaveAsActivity(false);
		mail.setPlainTextBody
			('The batch Apex job completed on  ' + a.CompletedDate + ',\n\n' +'Created By : '+a.CreatedBy.Email+'\n'+
	'Job Status : ' + a.Status + '\n'+
	'Total Job Items processed : ' + a.TotalJobItems + '\n'+
	'Number of Job Items processed : ' + a.JobItemsProcessed + '\n' +
	'Number of Failures : '+ a.NumberOfErrors);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		//Database.executeBatch(new CH_HWSHistoricalCase_OwnerUpdate(),20);
		
		
	}
	
	
}