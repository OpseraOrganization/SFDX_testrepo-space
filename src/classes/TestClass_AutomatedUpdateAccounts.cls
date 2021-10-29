@isTest
public class TestClass_AutomatedUpdateAccounts{
    static testMethod void testschedule() {
        Test.StartTest();
        AutomatedUpdateAccounts sh1 = new AutomatedUpdateAccounts();
        String sch = '0 0 7 * * ?';
        system.schedule('Test Territory Check', sch, sh1);
        Test.stopTest();  
    }
}