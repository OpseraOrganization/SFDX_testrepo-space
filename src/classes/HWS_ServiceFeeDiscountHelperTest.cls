/****************************************************************
* Class Name : HWS_ServiceFeeDiscountHelperTest 
* Created Date: 22-12-2021
* Created By: TCS
* Description : Test class for HWS_ServiceFeeDiscountHelper and HWS_ServiceFeeDiscountHandler
---------------------------------------------------------
Modified By	 Modified For US#	Modified Date
Akhil Ramisetty			29-12-2021
******************************************************************/
@isTest
public class HWS_ServiceFeeDiscountHelperTest {

	@testSetup
	public static void setupTestData(){ 
	  HWS_DataFactory_TEST.createServiceFeeDiscount();
	  HWS_DataFactory_TEST.createUser();	  
	}
	@isTest
	static void testPreventUsertoDelete() {
		Test.startTest();
		User dataLoderUser = [SELECT Id FROM User WHERE LastName = 'DataLoaderr' LIMIT 1];
		List<HWS_ServiceFee_Discount__c> serDiscount = [Select id from HWS_ServiceFee_Discount__c LIMIT 1];
		string errorMsg = System.Label.HWS_ServiceFeeDelete;	  
		string addMsg = errorMsg.replace('**', 'Discount');  
		try{
			System.runAs(dataLoderUser){
			delete serDiscount;
			}			
		}catch(DMLexception e){
			system.assert(e.getMessage().contains(addMsg));					   
		}
		Test.stopTest();
	}
}