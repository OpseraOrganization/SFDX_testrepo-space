@isTest
public class MasterData_DelProcessingBatchSchdlrTest {
		static testMethod void testschedule() {
		Test.StartTest();
		MasterData_DeleteProcessingBatchSchedulr testsche = new MasterData_DeleteProcessingBatchSchedulr();
		String sch = '0 0 23 * * ?';
			system.schedule('Test DeleteProcessingBatchShcdlr', sch, testsche );
		Test.stopTest();
	}
}