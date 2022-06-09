@isTest
public class ScheduledSearchAndAddEndCustomerTest {
public static testMethod void testschedule() {
			Test.StartTest();
		ScheduledSearchAndAddEndCustomer sh1 = new ScheduledSearchAndAddEndCustomer();
			String sch = '0 0 23 * * ?';
			system.schedule('Test Territory Check', sch, sh1); 
			Test.stopTest(); }
 
	
}