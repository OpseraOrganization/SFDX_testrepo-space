@isTest(seeAllData=False)
public class scheduleEmaiCounterBatchTest{
static testmethod void testScheduleEmaiCounterBatchTest(){
    String CRON_EXP = '0 0 0 15 3 ? 2022';
    Test.StartTest();
     String jobId;
     jobId = System.schedule('ScheduleApexClassTest', CRON_EXP,new scheduleEmaiCounterBatch ());
     Test.StopTest();
}
}