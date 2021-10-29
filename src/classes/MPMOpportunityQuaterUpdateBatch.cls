/************************************
Name         : MPMOpportunityQuaterUpdateBatch
Created By   : Chiranjeevi Gogulakonda
Company Name : NTT Data
Project      : M&PM Simulation Phase2
Created Date : 13 April 2017
Test Class   : 
Usages       : This Batch is used for updating Current date in "Current end of fiscal quarter date" field on Quaterly basis.
*************************************/ 
global class MPMOpportunityQuaterUpdateBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
    string query = 'Select id,name,stagename,Record_Type_Name__c,Current_end_of_fiscal_quarter_date1__c  from Opportunity where Record_Type_Name__c = \'M&PM SIM Licensing\' AND StageName != \'Closed Won\' AND StageName != \'Closed Lost\'';
    //string query = 'Select id,name,stagename,Record_Type_Name__c,Current_end_of_fiscal_quarter_date1__c  from Opportunity where id=\'0061300001KIGnA\'';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Opportunity> oppRecds) {
    Date closeDate = [Select EndDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER].EndDate;
         for(Opportunity Opp: oppRecds)
         {
         system.debug('****Current Date***#########'+Opp.Current_end_of_fiscal_quarter_date1__c);
            if(Opp.Current_end_of_fiscal_quarter_date1__c != closeDate ){
             Opp.Current_end_of_fiscal_quarter_date1__c = closeDate; 
             system.debug('****Current Date***'+Opp.Current_end_of_fiscal_quarter_date1__c);
             }          
         }
         update oppRecds;
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}