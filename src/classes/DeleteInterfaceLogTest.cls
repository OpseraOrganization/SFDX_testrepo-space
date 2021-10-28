@isTest
public class DeleteInterfaceLogTest {
	@testSetup
	static void setup() {
	IFMaintainanceCheck__c IFMC = new IFMaintainanceCheck__c(Name='HasBackup',hasBackup__c=true);
	insert IFMC;
	List<Interface_Log__c> ifList=new List<Interface_Log__c>(); 
		for (Integer i=0;i<100;i++) {
			Interface_Log__c ifLog=new Interface_Log__c(Name='123'+i,Interface_Type__c='ALCR ACC SYNC');
			ifList.add(ifLog);
		}
			insert ifList;
		for(Interface_Log__c ifLog:ifList){
			Test.setCreatedDate(ifLog.Id, DateTime.newInstance(2017,8,12));
		}
	}  
	@isTest
	static void test() {		
		Test.startTest();
		DeleteInterfaceLog dif = new DeleteInterfaceLog();
		Id batchId = Database.executeBatch(dif);
		Test.stopTest();
		IFMaintainanceCheck__c IFMC = [Select hasBackup__c from IFMaintainanceCheck__c WHERE Name='HasBackup' Limit 1];
		String runtime = String.valueOf(Date.today().addMonths(-2))+'T00:00:00.000Z';
		String query='SELECT Id,CreatedDate,Comment__c FROM Interface_Log__c WHERE CreatedDate<'+runtime;
		List<Interface_Log__c> resultList= Database.query(query);
		//System.assertEquals(0,resultList.size());
		//System.assertEquals(false,IFMC.hasBackup__c);
	}

}