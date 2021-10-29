/************************************
Name         : ServiceRecoveryRecdsCreateBatch
Created By   : NTT DATA
Project      : CSO Bundle Project- Service Recovery Report
Created Date : 21 July 2017
Test Class   : ServiceRecoveryRecdsCreateBatchTest
Usage       : This Batch is used for creating Service recovery report records and adding attachments from Case- Service recovery report record type.
*************************************/ 
global class ServiceRecoveryRecdsCreateBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string query = 'Select id,CaseNumber,Report_Type__c,Customer_Request_Date__c,HON_Commit_Date__c,GTO_Eng_Supp__c,Log_book_Rplcmnt_APU__c,Diagnostics_Fee__c,DERB__c,Service_Days__c,GTO_Eng_Support_Non_Auth__c,Log_book_Rplcmnt_Engine__c,Dispatch_Fee__c,Event_Type_Total__c,Travel_by_Auto__c,Recordtype.name from case where Recordtype.name= \'Service Recovery Report\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Case> caseRecds){
        List<Service_Recovery_Report__c> ServiceRecoveryList = new List<Service_Recovery_Report__c>();
        List<Attachment> AttachmentList = [SELECT Id,Name,ParentId,Body from Attachment where ParentId =: caseRecds];
        List<Attachment> TotalAttachmentList = new List<Attachment>();
        Map<Id,Id> mapCaseToServiceRecvry = new Map<id,id>();
        for(Case CaseList: caseRecds){
            Service_Recovery_Report__c ServiceRcd = new Service_Recovery_Report__c();
            ServiceRcd.Report_Type__c = CaseList.Report_Type__c;
            ServiceRcd.Case_Number__c = CaseList.id;
            ServiceRcd.Customer_Request_Date__c=CaseList.Customer_Request_Date__c;
            ServiceRcd.HON_Commit_Date__c=Date.Valueof(CaseList.HON_Commit_Date__c);
            ServiceRcd.GTO_Eng_Supp__c=CaseList.GTO_Eng_Supp__c;
            ServiceRcd.Log_book_Rplcmnt_APU__c=CaseList.Log_book_Rplcmnt_APU__c;
            ServiceRcd.Diagnostics_Fee__c=CaseList.Log_book_Rplcmnt_APU__c;
            ServiceRcd.DERB__c=CaseList.DERB__c;
            ServiceRcd.Service_Days__c=CaseList.Service_Days__c;
            ServiceRcd.GTO_Eng_Support_Non_Auth__c=CaseList.GTO_Eng_Support_Non_Auth__c;
            ServiceRcd.Log_book_Rplcmnt_Engine__c=CaseList.Log_book_Rplcmnt_Engine__c;
            ServiceRcd.Dispatch_Fee__c=CaseList.Dispatch_Fee__c;
            ServiceRcd.Travel_by_Auto__c=CaseList.Travel_by_Auto__c;
            //ServiceRcd.Air_Travel_Local__c=CaseList.Air_Travel_Local__c;
            //ServiceRcd.Air_Travel_Region__c=CaseList.Air_Travel_Region__c;
            //ServiceRcd.Air_Travel_Btw_Regions__c=CaseList.Air_Travel_Btw_Regions__c;
            //ServiceRcd.Travel_Days__c=CaseList.Travel_Days__c;
            //ServiceRcd.Additional_Expenses_Amount__c=CaseList.Additional_Expenses_Amount__c;
            //ServiceRcd.Additional_Expenses_Misc_Amount__c=CaseList.Additional_Expenses_Misc_Amount__c;  
            ServiceRecoveryList.add(ServiceRcd);            
        }
        Insert ServiceRecoveryList;
        for(Service_Recovery_Report__c sr : ServiceRecoveryList)
        {
            mapCaseToServiceRecvry.put(sr.Case_Number__c,sr.Id);
        
        }
        for(Attachment att: AttachmentList)
        {
            if(mapCaseToServiceRecvry.containsKey(att.parentid)) {
                Attachment cloneAtt = new Attachment(name = att.name, body = att.body, parentid = mapCaseToServiceRecvry.get(att.parentid));
                TotalAttachmentList.add(cloneAtt);
            }
        }
        if(TotalAttachmentList.size()>0)
            insert TotalAttachmentList;
        }
    global void finish(Database.BatchableContext Bc)
    {
    }
}