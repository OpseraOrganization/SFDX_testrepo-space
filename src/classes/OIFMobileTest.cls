/****************************************
 * Class Name : OIFMobileTest
 * Created Date: 9th May 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : Test class for OIFMobile Class
 *****************************************/

 @isTest
Private class OIFMobileTest{
	 /******************************
	*Method Name: GirdMobileTest
	*Description: Test Method to cover OIFGrid class
	********************************/
	Private Static Opportunity Opp2=Null;
	static testMethod void GridMoileTest(){
	
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		 user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.RunAs(userCreation){
		//List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		//fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		//database.insert(fileSharingCustomSettingList); 
		Account acc = TestDataFactory.createAccount(1)[0];
		database.insert(acc);
		
		Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc)[0];
		  opp2 = TestDataFactory.OpportunityCreation(1,acc)[0];
		  
		 
		Test.StartTest();
		database.insert(opp1);
		ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(opp1);
		
		OIFMobile OIF=new OIFMobile( sc);
	  OIFMobile.OptyLock();
	  OIFMobile.OptyLock();
		
	   
	   
	   ApexPages.Standardcontroller sc1 = new ApexPages.Standardcontroller(opp2);
		
		OIFMobile OIF1=new OIFMobile( sc1);
		OIFMobile.posId=Null;
	  OIFMobile.OptyLock();
	  OIFMobile.OptyLock();
	   test.StopTest();
	  
	  
		
	  }
	}
	
 }