@isTest
public class CH_ErrorLogUtils_Test {
	@isTest
	Static void createLogRecord(){
		List<ErrorLog__c> errorLogList = New List<ErrorLog__c>();
		ErrorLog__c newErrorLog = New ErrorLog__c();
		String asyncType = 'QUEUEABLE';
		String triggerEvent='INSERT';
		test.startTest();
		newErrorLog = CH_ErrorLogUtils.createErrorLog('Test Error','TestClass-TestMethod',triggerEvent+'-'+asyncType,'Test Process',null);
		errorLogList.add(newErrorLog);
		CH_ErrorLogUtils.insertErrorLog(errorLogList);
		test.stopTest();
	} 
}