@isTest
public class Batch_DeleteInterfaceLogTest {
	@testSetup
	static void setup() {
	List<Interface_Log__c> ifList=new List<Interface_Log__c>(); 
		for (Integer i=0;i<200;i++) {
			Interface_Log__c ifLog=new Interface_Log__c(Name='123'+i,Interface_Type__c='ALCR ACC SYNC');
			ifList.add(ifLog);
		}
			insert ifList;
		for(Interface_Log__c ifLog:ifList){
			Test.setCreatedDate(ifLog.Id, DateTime.newInstance(2017,8,12));
		}
	}  
	@isTest
	static void testDayBefore() {
		Date_for_Delete_Interface_Log__c ddil = new Date_for_Delete_Interface_Log__c(Name='Test',Active__c=true,  ActiveStartEndDate__c=false, DaysBefore__c=180,  SQL_Limit__c=100,ToEmail__c='hao.han.ext@nokia.com',Count__c=3);
		insert ddil;	   
		Test.startTest();
		Batch_DeleteInterfaceLog dif = new Batch_DeleteInterfaceLog();
		Id batchId = Database.executeBatch(dif,200);
		Test.stopTest();

	}
	@isTest
		static void testSED() {
		Date_for_Delete_Interface_Log__c ddil = new Date_for_Delete_Interface_Log__c(Name='Test',Active__c=true,  ActiveStartEndDate__c=TRUE,Start_Date__c=System.now().addDays(-365),End_Date__c=System.now(),  SQL_Limit__c=10000,ToEmail__c='hao.han.ext@nokia.com',Count__c=3);
		insert ddil;	   
		Test.startTest();
		Batch_DeleteInterfaceLog dif = new Batch_DeleteInterfaceLog();
		Id batchId = Database.executeBatch(dif,200);
		Test.stopTest();

	}
		@isTest
	static void testError() {
		Date_for_Delete_Interface_Log__c ddil = new Date_for_Delete_Interface_Log__c(Name='Test',Active__c=true,  ActiveStartEndDate__c=false, DaysBefore__c=10,  SQL_Limit__c=100,ToEmail__c='hao.han.ext@nokia.com',Count__c=3);
		insert ddil;	   
		Test.startTest();
		Batch_DeleteInterfaceLog dif = new Batch_DeleteInterfaceLog();
		Id batchId = Database.executeBatch(dif,200);
		Test.stopTest();

	}
		@isTest
		static void testERRORSED() {
		Date_for_Delete_Interface_Log__c ddil = new Date_for_Delete_Interface_Log__c(Name='Test',Active__c=true,  ActiveStartEndDate__c=TRUE,Start_Date__c=System.now().addDays(3),End_Date__c=System.now(),  SQL_Limit__c=10000,ToEmail__c='hao.han.ext@nokia.com',Count__c=3);
		insert ddil;	   
		Test.startTest();
		Batch_DeleteInterfaceLog dif = new Batch_DeleteInterfaceLog();
		Id batchId = Database.executeBatch(dif,200);
		Test.stopTest();

	}
}