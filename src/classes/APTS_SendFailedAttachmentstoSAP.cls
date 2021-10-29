global class APTS_SendFailedAttachmentstoSAP implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {    
         String Type = 'Error';
         return Database.getQueryLocator('select id,APTS_Credit_Memo__c,APTS_Integration_Requested__c,APTS_Integration_Result__c,APTS_Attachment_Id__c,APTS_Delete_Draft_Attachments__c,APTS_Status__c from APTS_PDF_Attachment_Status__c where '+'APTS_Status__c=:Type');
    }
    
    global void execute(Database.BatchableContext BC, List<APTS_PDF_Attachment_Status__c>scope)
    {
         list<APTS_PDF_Attachment_Status__c> lstUpdate = new list<APTS_PDF_Attachment_Status__c>();
         for(APTS_PDF_Attachment_Status__c objPAS:scope)
         {
             objPAS.APTS_Status__c='To be Processed';
             objPAS.APTS_Integration_Result__c='';
             objPAS.APTS_Integration_Requested__c=system.now();
             lstUpdate.add(objPAS);
         }     
         
         update lstUpdate;
    }
    
    global void finish(Database.BatchableContext BC)
    {
            // Logic to be Executed at finish
    }
}