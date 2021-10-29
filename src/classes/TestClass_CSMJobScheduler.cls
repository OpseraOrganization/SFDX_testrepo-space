@isTest(SeeAllData=true)
public class TestClass_CSMJobScheduler
{
    public static testMethod void testschedule() 
    {
        Test.StartTest();
        CSMJobScheduler csm = new CSMJobScheduler();
        csm.CSMJobScheduler();
        //The below code erros out since in PROD the actual job is already scheduled
        //CSMJobScheduler.start();
        Test.stopTest();
    }
}