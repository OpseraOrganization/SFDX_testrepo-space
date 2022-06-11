/***************************************
* Name : CRM_CPVDataControllerTest
* Author : CRM Dev
* Description : Test class for CRM_CPVDataController
*****************************************/
@istest
public class CRM_CPVDataControllerTest
{
	@testSetup
	static void datasetup()
	{
		Account acc = TestDataFactory.createAccount(1)[0];
		acc.AccountNumber = '1234';
		insert acc;
		
	}

	static testmethod void test1()
	{
		Test.startTest();
		List<Account> accList = [SELECT Id FROM Account WHERE AccountNumber = '1234'];
		CRM_CPVDataController.getAccountCPVApex(accList[0].Id);
		
		CRM_Customer_Perceived_Value__c cpv1 = new  CRM_Customer_Perceived_Value__c();
		cpv1.Account__c = accList[0].Id;
		insert cpv1;
		CRM_CPVDataController.getAccountCPVApex(accList[0].Id);
	
		CRM_Customer_Perceived_Value__c cpv2 = new  CRM_Customer_Perceived_Value__c();
		cpv2.Account__c = accList[0].Id;
		insert cpv2;
		CRM_CPVDataController.getAccountCPVApex(accList[0].Id);
		
		Test.stopTest();
	}
}