/****************************************
* Class Name : HWS_BulkUploadDelete_Batch
* User Story :NOKIASC-
* Created Date: 01 June 2021
* Created By : TCS
* Last Modified by: 
* Last Modified Date:
* Description : Batch job for deleting staging table data
* Test Class: HWS_PS_RelationsDelete_Batch_Test
*****************************************/
global without sharing class HWS_BulkUploadDelete_Batch implements database.Batchable<sobject>{

list<HWS_BulkUpload__c> llist=new list<HWS_BulkUpload__c>();
	
	global database.querylocator start(database.BatchableContext bc){
	   string query='select Id,ParentCaseId__c,Part_Code_Part_Revision__c from HWS_BulkUpload__c where ParentCaseId__c!=NULL AND Part_Code_Part_Revision__c!=NULL and CreatedDate<LAST_N_DAYS:7';
	   return database.getQueryLocator(query); 
  }
	global void execute(database.BatchableContext bc,list<HWS_BulkUpload__c> le){
	  delete le;			
	  database.emptyRecycleBin(le); 
	}
	global void finish(database.BatchableContext bc){

	}
}