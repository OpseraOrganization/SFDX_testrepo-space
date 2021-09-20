@isTest
public class MasterData_DeleteProcessingBatchTest {
	@isTest static void testDeleteProcessing(){
		
		CNP_High_ProcessingTable__c processing = new CNP_High_ProcessingTable__c();
		processing.New_List_Price__c	= '400';
		processing.Old_List_Price__c	= '200';
		processing.Product_Code__c = '35ABCQ123';
		insert processing;
		
		Integer Days = Integer.ValueOf(Label.DeleteProcessingPeriod);
		dateTime tempdateTime =  system.now()-Days;
		Test.setCreatedDate(processing.Id,tempdateTime);
		test.starttest();
		Database.executebatch(new MasterData_DeleteProcessingBatch());
		test.stoptest();
	}
}