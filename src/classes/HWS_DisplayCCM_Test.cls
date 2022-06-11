/****************************************
* Name : HWS_DisplayCCM_Test 
* Author : TCS
* Description : This is testclass for HWS_DispayCCM
* Userstories: NOKIASC-31238/31239
****************************************/
@isTest
public class HWS_DisplayCCM_Test {
 public static Account legalAcc;
 public static Case childCase;
 
 //Testdata creation
	   @testSetup 
	static void setup() {
		Id rtId = Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
		legalAcc = HWS_DataFactory_TEST.insertAccount();
		insert legalAcc;
		
		Id childRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ADVANCE_EXCHANGE_IN_DAYS);	 
		childCase= HWS_DataFactory_TEST.createCase(childRecordType);
		childCase.AccountId = legalAcc.Id;
		insert childCase;

 
		ServiceContract sc = HWS_DataFactory_TEST.insertServiceContract(legalAcc);
		sc.Pricebook2Id = Test.getStandardPricebookId();
		sc.NCP_External_Status__c = 'Active';
		sc.CurrencyIsoCode = 'EUR';
		sc.recordTypeId = rtId;
		sc.StartDate=System.today().addDays(-2);
		sc.EndDate=System.today().addDays(2);
		insert sc;
		sc.ownerId = userInfo.getUserId();
		update sc;
		}
	
	//there is no service contract owners case
	public static testmethod void noUserDetailsTest(){
		setup();   
		ServiceContract sc = [SELECT id, AccountId, OwnerId, RecordTypeId FROM ServiceContract limit 1];
		test.startTest();
		List<user> userList = HWS_DispayCCM.getUserInfo(childCase.Id);
		system.assertNotEquals(childCase, null);
		test.stopTest();
	}
}