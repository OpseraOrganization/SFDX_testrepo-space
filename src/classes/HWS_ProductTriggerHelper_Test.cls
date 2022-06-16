/****************************************
* Name : HWS_ProductTriggerHelper_Test
* Author : TCS
* Description : Test class for HWS_ProductTriggerHelper
****************************************/
@isTest
public class HWS_ProductTriggerHelper_Test {
	public static testmethod void sourceFieldUpdateTest(){ 
		Account acc = HWS_DataFactory_TEST.insertAccount();		 
		insert acc;		
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();
		Test.startTest();
		prod.HWS_Source__c ='PuMA2';
		insert prod;
		prod.HWS_Source__c ='PUMA1';
		update prod;
		prod.HWS_Source__c ='PuMA2';
		update prod;
		system.assertEquals(prod.HWS_Source__c,'PuMA2');
		Test.stopTest();
	}
}