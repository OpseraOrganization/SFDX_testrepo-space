/****************************************
 * Class Name : DS_GBOMBatch_SchedulerTest
 * Created Date: 15 march 2019
 * Created By : Accenture
 * Last Modified by: Accenture
 * Apex Class: DS_CPOLineItem_Scheduler
 *****************************************/
@isTest
public class DS_GBOMBatch_SchedulerTest{
	
	@isTest static void executeTest(){
	
	
	Test.StartTest();
		DS_GBOMBatch_Scheduler testsche = new DS_GBOMBatch_Scheduler();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
		
	   
		 
	}  
	
}