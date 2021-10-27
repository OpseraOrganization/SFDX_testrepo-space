@isTest
public class Scheduler_BatchDeleteInterfaceLogTest {
	public static String CRON_EXP = '0 0 0 15 3 ? 2022';
	static testmethod void testScheduledJob() {
		Date_for_Delete_Interface_Log__c ddil = new Date_for_Delete_Interface_Log__c(Name='Test',Active__c=true,  ActiveStartEndDate__c=false, DaysBefore__c=180,  SQL_Limit__c=100,ToEmail__c='hao.han.ext@nokia.com',Count__c=3);
		insert ddil;
		Test.startTest();
		String jobId = System.schedule('ScheduledApexTest',
			CRON_EXP, 
			new Scheduler_BatchDeleteInterfaceLog());
		Test.stopTest();
	}
}