@isTest(SeeAllData=true)
public class TestClass_AOPJobScheduler
{
    public static testMethod void testschedule() 
    {
        Test.StartTest();
        AOPJobScheduler aop = new AOPJobScheduler();
        aop.AOPJobScheduler();
        //The below code erros out since in PROD the actual job is already scheduled
        //AOPJobScheduler.start(2013);
        Test.stopTest();
    }
}