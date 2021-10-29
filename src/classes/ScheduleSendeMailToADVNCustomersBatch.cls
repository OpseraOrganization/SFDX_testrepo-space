/*******************************************************************************
Name         : ScheduleSendeMailToADVNCustomersBatch 
Created By   : Ravi Bodepalli
Company Name : NTT Data
Created Date : 2 Feb 2019
Usages       : This Class is used for scheduling SendeMailToADVNCustomersBatch class.
*******************************************************************************/
global class ScheduleSendeMailToADVNCustomersBatch implements Schedulable{
    global void execute(SchedulableContext sc) 
    {
        SendeMailToADVNCustomersBatch advnBatch = new SendeMailToADVNCustomersBatch();
        ID batchprocessid = Database.executeBatch(advnBatch,25);           
    }
}