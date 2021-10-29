@isTest
public class MCORERemaindersSchedulerTest{
static testMethod void myUniTest(){
Test.StartTest();
MCORERemaindersScheduler mcore = new MCORERemaindersScheduler(); 
String sch = '0 0 23 * * ?';
System.schedule('Test MCORE Reminder Scheduler Check', sch, mcore);
Test.StopTest(); 
}
}