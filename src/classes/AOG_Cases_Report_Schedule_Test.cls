/*******************************************************************************
Name            :   AOG_Cases_Report_Schedule_Test
Created By      :   NTT DATA
Company Name    :   NTT DATA
Project         :   <CSO Bundle Project - Req No 16 - D&S AOG MYCAPS identification> 
Created Date    :   27-June-2017
Usages          :   Test class for AOG_Cases_Report.
Modified By     :   NTT DATA
*******************************************************************************/
@isTest
private class AOG_Cases_Report_Schedule_Test {
    
    static testMethod void aog_Cases_Report_Schedule_Method() {       
            Test.startTest();
            AOG_Cases_Report_Schedule tstCaseSchd = new AOG_Cases_Report_Schedule();
            String Shdlr='0 0 23 * * ?';  
            System.schedule('AOG_Cases_Report_ScheduleOne',Shdlr,tstCaseSchd);
            Test.stoptest();
            
    }
}