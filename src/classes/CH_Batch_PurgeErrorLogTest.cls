@isTest
public class CH_Batch_PurgeErrorLogTest {
	Public static testmethod void deleteErrorLogTest(){
		List<ErrorLog__c> errorLogList = new List<ErrorLog__c>();
		
		ErrorLog__c newErrorLog = new ErrorLog__c(Application__c='Case Handling');
		errorLogList.add(newErrorLog);
		
		insert errorLogList;
		Test.startTest();
		SchedulableContext SC = null;
		CH_Batch_PurgeErrorLog eLogBatch = new CH_Batch_PurgeErrorLog();
		Database.BatchableContext BC;
		eLogBatch.start(BC);
		eLogBatch.execute(BC,errorLogList);
		eLogBatch.finish(BC);
		elogBatch.execute(SC);
		test.stopTest();
	}
}