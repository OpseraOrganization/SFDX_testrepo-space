/*******************************************************************************
Name         : BatchAERUpdate
Created By   : Haritha Lekkala
Company Name : HoneyWell
Project      : 
Created Date : 2/20/2017 
Usages       : This Batch class will be used to update AER_Update__c field on Account_Eligible_RMU_Fleet_Asset__c to true.

Modification History  :
Date            Version No.     Modified by     Brief Description of Modification
*******************************************************************************/
//Batch job to update AER Fleet Asset record's AER_Update__c field.
global class BatchAERUpdate implements Database.Batchable<sObject>
{
    //The first method that gets executed.
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        // Prepare a query string which will give all the records with the satisfied where condition.
        String query = 'SELECT Id,AER_Update__c,RMU_Dealer_Extended_Price__c,'+
                       'RMU_Dealer_Work_Ext__c,RMU_Dealer_Extended_Price_Net__c,RMU_Dealer_Work_Ext_Net__c,'+
                       'RMU_Flyaway_Extended_Price__c,RMU_Flyaway_Work_Ext__c,RMU_Flyaway_Extended_Price_Net__c,'+
                        'RMU_Flyaway_Work_Ext_Net__c,'+ 'RMU_Honeywell_Extended_Price__c,RMU_Honeywell_Work_Ext__c,RMU_Honeywell_Extended_Price_Net__c,'+
                        'RMU_Honeywell_Work_Ext_Net__c'+
                        ' FROM Account_Eligible_RMU_Fleet_Asset__c where AER_Update__c=false';
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC, List<Account_Eligible_RMU_Fleet_Asset__c> scope)
    {
         // Prepare an empty list of Account_Eligible_RMU_Fleet_Asset__c to which all the updatable records will be added.
         list<Account_Eligible_RMU_Fleet_Asset__c> aerFleetRecList = new list<Account_Eligible_RMU_Fleet_Asset__c>();
         for(Account_Eligible_RMU_Fleet_Asset__c a : scope)
         {
            if( (a.RMU_Dealer_Extended_Price__c != a.RMU_Dealer_Work_Ext__c) ||
                 (a.RMU_Dealer_Extended_Price_Net__c != a.RMU_Dealer_Work_Ext_Net__c) ||
                 (a.RMU_Flyaway_Extended_Price__c != a.RMU_Flyaway_Work_Ext__c) ||
                 (a.RMU_Flyaway_Extended_Price_Net__c != a.RMU_Flyaway_Work_Ext_Net__c) ||
                 (a.RMU_Honeywell_Extended_Price__c != a.RMU_Honeywell_Work_Ext__c) ||
                 (a.RMU_Honeywell_Extended_Price_Net__c != a.RMU_Honeywell_Work_Ext_Net__c)
              ){
                 // set AER_Update__c field value to true as per requirement and add it to the list created at line#25.
                 a.AER_Update__c = true;
                 aerFleetRecList.add(a);
             }
         }
            // update the records in areFleetRecList.         
         update aerFleetRecList;
    }  
    global void finish(Database.BatchableContext BC)
    {
    }
}