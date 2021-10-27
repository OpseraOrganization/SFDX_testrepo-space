/**
 * @description	   : 
 * @author			: Yashdeep Prajapati
 * @group			 : 
 * @last modified on  : 06-08-2021
 * @last modified by  : Yashdeep Prajapati
 * Modifications Log 
 * Ver   Date		 Author			   Modification
 * 1.0   06-08-2021   Yashdeep Prajapati   Initial Version
**/
@istest 
public with sharing class NokiaCPQ_InactiveProductsSchedulerTest {
	/**
	* @description Creates the test data
	* @author Yashdeep Prajapati | 06-08-2021 
	**/
	@TestSetup
	static void makeData(){
		List<Product2> prods = TestDataFactory.productCreation(4);
		insert prods;

		List<Apttus_Config2__ProductOptionComponent__c> pocList = new List<Apttus_Config2__ProductOptionComponent__c>();
		Apttus_Config2__ProductOptionComponent__c productOptionComponentObj1 = TestDataFactory.CreateproductOptionComponent(prods[0].id,1)[0];
		productOptionComponentObj1.Apttus_Config2__ParentProductId__c = prods[2].id;
		productOptionComponentObj1.Apttus_Config2__Sequence__c = 46511;
		pocList.add(productOptionComponentObj1);

		Apttus_Config2__ProductOptionComponent__c productOptionComponentObj2 = TestDataFactory.CreateproductOptionComponent(prods[1].id,1)[0];
		productOptionComponentObj2.Apttus_Config2__ParentProductId__c = prods[3].id;
		productOptionComponentObj2.Apttus_Config2__Sequence__c = 46511;
		pocList.add(productOptionComponentObj2);
		insert pocList;

		List<NokiaCPQ_Deactivated_Products__c> daps = new List<NokiaCPQ_Deactivated_Products__c>();
		NokiaCPQ_Deactivated_Products__c dap1 = new NokiaCPQ_Deactivated_Products__c();
		dap1.NCPQ_Product__c = prods[0].id;
		daps.add(dap1);
		NokiaCPQ_Deactivated_Products__c dap2 = new NokiaCPQ_Deactivated_Products__c();
		dap2.NCPQ_Product__c = prods[1].id;
		daps.add(dap2);
		insert daps;
	}

	/**
	* @description test method
	* @author Yashdeep Prajapati | 06-08-2021 
	**/
	@IsTest
	static void testExecute(){
		
		String CRON_EXP = '0 0 5 ? * 2,3,4,5,6';
		Test.startTest();
		String jobId = System.schedule('testing scheduler1', CRON_EXP, new NokiaCPQ_InactiveProductsScheduler('daily'));
		
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		
		System.assertEquals(CRON_EXP, ct.CronExpression);
		System.assertEquals(0, ct.TimesTriggered);

		CRON_EXP = '0 0 7 ? * 6';
		jobId = System.schedule('testing scheduler2', CRON_EXP, new NokiaCPQ_InactiveProductsScheduler('weekly'));
		
		ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		
		System.assertEquals(CRON_EXP, ct.CronExpression);
		System.assertEquals(0, ct.TimesTriggered);
		Test.stopTest();
	}
}