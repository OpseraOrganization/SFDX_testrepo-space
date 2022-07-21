/****************************************************************
* Class Name : HWS_ServiceFeeTriggerHelperTest 
* Created Date: 22-12-2021
* Created By: TCS
* Description : Test class for HWS_ServiceFeeTriggerHelper and HWS_ServiceFeeTriggerHandler
---------------------------------------------------------
Modified By	 	Modified For US#	Modified Date
AKhil Ramisetty				03/01/2022
******************************************************************/
@isTest
public class HWS_ServiceFeeTriggerHelperTest {
	
	@testSetup
	public static void setupTestData(){		
	 	HWS_DataFactory_TEST.createServiceFeeDetails(); 
		HWS_DataFactory_TEST.createUser();
	}
	
	@isTest
	static void testPreventUsertoDelete() {
		Test.startTest();
		User dataLoderUser = [SELECT Id FROM User WHERE LastName = 'DataLoaderr' LIMIT 1];
		List<HWS_ServiceFeeDetails__c> serFeeRecord = [Select id, HWS_Product__c from HWS_ServiceFeeDetails__c LIMIT 1];
		string errorMsg = System.Label.HWS_ServiceFeeDelete;	  
		string addMsg = errorMsg.replace('**', 'Fee');  
		try{
			System.runAs(dataLoderUser){
			 delete serFeeRecord;
	}		 
		}catch(DMLexception e){
			system.assert(e.getMessage().contains(addMsg));					   
		}
		 Test.stopTest();
	}
}