/*
 * @Description: Test Class for Scheduler Interface class
 * */
@isTest(seeAllData = false)
public with Sharing class CQI_BatchScheduleTest {
    
    /*
     * @Description: unit test method to schedule the cqi batch job &
     * verify if job id is generated. 
     * */
    testmethod static void testSchedule() {
        
        Test.startTest() ; 
        CQI_BatchSchedule cqiSchedule = new CQI_BatchSchedule(); 
        String cronExp = '0 50 23 ? * 7'; 
        String jobId = System.Schedule('Weekly Quality Assessment Evaluations Test Class',cronExp,cqiSchedule);
        /*
         * verify if job is submitted with this cron string
         * */
        System.assertNotEquals(jobId, null); 
        
        Test.stopTest(); 
    }

}