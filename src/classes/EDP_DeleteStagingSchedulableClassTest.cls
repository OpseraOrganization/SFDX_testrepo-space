/****************************************
	 * Name : EDP_DeleteStagingSchedulableClassTest
	 * Author : Accenture
	 * Description : This is a test class for edp delete scheduling class
	 * ReqNo : 
	****************************************/
@isTest
private  class EDP_DeleteStagingSchedulableClassTest {
	
	/****************************************
		 * Name : testExecuteMethod
		 * Description : test class for schedule method
		 * Parameters: 
	 *****************************************/
	static testmethod void testExecuteMethod() 
	{
		Test.startTest();
		
		// Schedule the test job
		//Datetime dt = Datetime.now().addMinutes(1);
		//String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
		//String jobId = System.schedule('EDP Delete Staging Data Schedule Job',CRON_EXP,new EDP_DeleteStagingSchedulableClass());
		
		
		Batch_EDPDeleteStagingTable edpsc = new Batch_EDPDeleteStagingTable('Product_Sales_Item__c');
		Database.BatchableContext BC;
		
		List<Product_Sales_Item__c> salesItems = new List<Product_Sales_Item__c>();
		Product_Sales_Item__c psi=new Product_Sales_Item__c();
		psi.NSNCode__c='106742596';
		psi.Description__c = 'PSI';
		psi.Is_Processed__c = true;	
		salesItems.add(psi);
		insert salesItems;
		
		edpsc.execute(BC,salesItems);
		edpsc.execute(BC,salesItems);
		edpsc.execute(BC,salesItems);
		
		 EDP_DeleteStagingSchedulableClass edpsc1 = new EDP_DeleteStagingSchedulableClass();
		 SchedulableContext SC;
		 edpsc1.execute(SC);

		Test.stopTest();
	}
	
	/****************************************
		 * Name : testScheduled
		 * Description : test class for unschedule method
		 * Parameters: 
	 *****************************************/
	/*static testMethod void testScheduled()
	{
		Test.startTest();
		EDP_DeleteStagingSchedulableClass edpsc = new EDP_DeleteStagingSchedulableClass();
		edpsc.schedule();
		Test.stopTest();
	}*/
	
	
	 /****************************************
		 * Name : testUnscheduled
		 * Description : test class for unschedule method
		 * Parameters: 
	 *****************************************/
	static testMethod void testUnscheduled()
	{
		Test.startTest();
		EDP_DeleteStagingSchedulableClass edpsc = new EDP_DeleteStagingSchedulableClass();
		
		edpsc.unschedule();
		edpsc.schedule();
		edpsc.unschedule();
		Test.stopTest();
	}
	
		
	/****************************************
		 * Name : testBatchExecute
		 * Description : test class for execute method
		 * Parameters: 
	 *****************************************/
	static testMethod void testBatchExecute()
	{
		Test.startTest();
		List<Product_Sales_Item__c> salesItems = new List<Product_Sales_Item__c>();
		Product_Sales_Item__c psi=new Product_Sales_Item__c();
		psi.NSNCode__c='106742596';
		psi.Description__c = 'PSI';
		psi.Is_Processed__c = true;	
		salesItems.add(psi);
		insert salesItems;
		
		Batch_EDPDeleteStagingTable edpsc = new Batch_EDPDeleteStagingTable('Product_Sales_Item__c');
		Database.BatchableContext BC;
		edpsc.execute(BC,salesItems);
	  
		Test.stopTest();
		
	}	

}