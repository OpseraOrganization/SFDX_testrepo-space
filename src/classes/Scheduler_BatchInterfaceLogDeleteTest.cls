@isTest
public class Scheduler_BatchInterfaceLogDeleteTest {
	public static String CRON_EXP = '0 0 0 15 3 ? 2022';
	static testmethod void testScheduledJob() {
		IFMaintainanceCheck__c IFMC = new IFMaintainanceCheck__c(Name='HasBackup',hasBackup__c=false);
		insert IFMC;
		IFMaintainanceCheck__c IFMC1 = [Select hasBackup__c from IFMaintainanceCheck__c WHERE Name='HasBackup' Limit 1];
		System.debug('--->'+IFMC1.hasBackup__c);
		Test.startTest();
		String jobId = System.schedule('ScheduledApexTest',
			CRON_EXP, 
			new Scheduler_BatchInterfaceLogDelete());
		Test.stopTest();
		Integer months=0-Integer.valueof(Label.DeleteIFMonths);	
		String runtime = String.valueOf(Date.today().addMonths(months))+'T00:00:00.000Z';
		String query='SELECT Id,CreatedDate,Comment__c FROM Interface_Log__c WHERE CreatedDate<'+runtime;
		List<Interface_Log__c> resultList= Database.query(query);
		System.assertEquals(0,resultList.size());  
		
		
	 

	}
	
}