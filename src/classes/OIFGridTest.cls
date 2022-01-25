/****************************************
* Class Name : OIFGridTest
* Created Date: 28 November 2016
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 
* Description : Test class for OIFGrid Class
*****************************************/

@isTest
Private class OIFGridTest{
	/******************************
*Method Name: GirdTest
*Description: Test Method to cover OIFGrid class
********************************/
	
	static testMethod void GridTest()
	{
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		//List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		//fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		//database.insert(fileSharingCustomSettingList); 
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.RunAs(userCreation)
		{
			Account acc = TestDataFactory.createAccount(1)[0];
			database.insert(acc);
			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc)[0];
			Test.StartTest();
			database.insert(opp1);
			OIFGrid.getOIFByOpportunityId(opp1.Id);
			OIFGrid.getUrlInfo();
			OIFGrid.getopplock(opp1.Id);
			test.StopTest();
		}
	}
}