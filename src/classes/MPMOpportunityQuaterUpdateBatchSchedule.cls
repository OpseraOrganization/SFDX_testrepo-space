/************************************
Name         : MPMOpportunityQuaterUpdateBatchSchedule
Created By   : Chiranjeevi Gogulakonda
Company Name : NTT Data
Project      : M&PM Simulation Phase2
Created Date : 13 April 2017
Test Class   : 
Usages       : This Batch is used for updating Current date in "Current end of fiscal quarter date" field on Quaterly basis.
*************************************/
Global class MPMOpportunityQuaterUpdateBatchSchedule implements Schedulable{
   Global void execute(SchedulableContext sc) {
      MPMOpportunityQuaterUpdateBatch MPMBatch = new MPMOpportunityQuaterUpdateBatch();
       database.executebatch(MPMBatch);
      //string QuaterCron = '0 0 5 1 JAN,APR,JUL,OCT ?';
      //system.schedule('QuaterJob--------',QuaterCron,new MPMOpportunityQuaterUpdateBatchSchedule ());
   }
}