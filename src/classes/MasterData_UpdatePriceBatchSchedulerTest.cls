@isTest
public class MasterData_UpdatePriceBatchSchedulerTest {
	
		static testMethod void testschedule() {
		Test.StartTest();
		MasterData_UpdatePriceBatchScheduler testsche = new MasterData_UpdatePriceBatchScheduler();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}