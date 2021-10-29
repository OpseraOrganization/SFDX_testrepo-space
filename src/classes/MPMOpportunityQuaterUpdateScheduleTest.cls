/************************************
Name         : MPMOpportunityQuaterUpdateScheduleTest 
Created By   : Chiranjeevi Gogulakonda
Company Name : NTT Data
Project      : M&PM Simulation Phase2
Created Date : 31 May 2017
Test Class   : 
Usages       : This is test class for MPMOpportunityQuaterUpdateBatchSchedule.
*************************************/
@isTest
Public class MPMOpportunityQuaterUpdateScheduleTest {
     Public static testmethod void MPMOpportunityQuaterUpdate(){
     MPMOpportunityQuaterUpdateBatch b = new MPMOpportunityQuaterUpdateBatch(); 
      database.executebatch(b);
      
      MPMOpportunityQuaterUpdateBatchSchedule wfbatch = New MPMOpportunityQuaterUpdateBatchSchedule ();            
           String myDateTime = String.Valueof(datetime.now().addseconds(10));            
           String[] strs =myDateTime.split('-',5);                  
           String[] strs2=strs[2].split(':',5);                  
           String[] strs3=strs2[0].split(' ',3);                 
           String schdul= strs2[2]+' '+strs2[1]+' '+strs3[1]+' '+strs3[0]+' '+strs[1]+' '+'?';                
           System.debug(schdul);                                   
           system.schedule('Job HIPI',schdul,wfbatch);    
     
     }
}