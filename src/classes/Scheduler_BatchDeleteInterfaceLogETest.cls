@isTest
public class Scheduler_BatchDeleteInterfaceLogETest {
	public static String CRON_EXP = '0 0 0 15 3 ? 2022';
		static testmethod void testScheduledJob() {
			Delete_Interface_Log_Extend__c ddil = new Delete_Interface_Log_Extend__c(Name='Test',Active__c=true,  ActiveStartEndDate__c=false, DaysBefore__c=180,  SQL_Limit__c=100,ToEmail__c='hao.han.ext@nokia.com',Count__c=3);
			insert ddil;
			Test.startTest();
			String jobId = System.schedule('ScheduledApexExtendTest',CRON_EXP,new Scheduler_BatchDeleteInterfaceLogExtend());
			Test.stopTest();
	}
}