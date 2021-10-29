/*
 * @Description: Scheduler class to invoke QA evaluations batch class. 
 * This Class is introduced for CQI Module implementation. 
 * Class will be scheduled to execute on Weekend using cron: 0 50 23 ? * 7
 * 
 * Test Class Name: CQI_BatchScheduleTest
 * 
 * */
public with Sharing class CQI_BatchSchedule implements Schedulable {
    
    /*
     * @Description: execute method. 
     * Calls the Batch Assignments class
     * */
    public void execute(SchedulableContext objSC) {
        CQI_BatchAssignments obj = new CQI_BatchAssignments();
        Database.executeBatch(obj);
    }
}