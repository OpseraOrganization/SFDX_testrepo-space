/*
** @author : Apttus
** @date : 06/03/2017
** @description : Test class for the APTS_ApprovalBackupApproverTrigger trigger.
*/


@isTest
Public class APTS_ApprovalBackupApproverTriggerTest{

 Public Static Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
	public static testMethod void CreateBackupApprove(){
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];

		User u = new User(
		  Alias = 'testu',
		  Email = 'test@nokia.com',
		  EmailEncodingKey = 'UTF-8',
		  LastName = 'Test',
		  LanguageLocaleKey = 'en_US',
		  LocaleSidKey = 'en_US',
		  TimeZoneSidKey='America/Los_Angeles',
		  ProfileId = p.Id,
		  UserName='test@nokia.com',
		  Nokia_ID__c=randomInt +'0',
		  NSA_Compliant__c=True
		);
	
		INSERT u;
	
		User u1 = new User(
		  Alias = 'testu',
		  Email = 'test1@nokia.com',
		  EmailEncodingKey = 'UTF-8',
		  LastName = 'Test',
		  LanguageLocaleKey = 'en_US',
		  LocaleSidKey = 'en_US',
		  TimeZoneSidKey='America/Los_Angeles',
		  ProfileId = p.Id,
		  UserName='test1@nokia.com',
		   Nokia_ID__c=randomInt +'01',
		   NSA_Compliant__c=True
		);
	
		INSERT u1;
		System.debug(u1.id + '@@@@@@@' + u.id);
	 
		
		Apttus_Approval__Backup_Approver__c objBA = new Apttus_Approval__Backup_Approver__c();

		objBA.Apttus_Approval__Current_User__c =UserInfo.getUserId();
		//objBA.Delegate_Approver1__c = u.Id;
		//objBA.Apttus_Approval__Backup_User__c = u1.Id;		
		//objBA.Delegate_Approver2__c = u1.Id;
		objBA.Apttus_Approval__IsActive__c = true;
		objBA.Apttus_Approval__InEffect__c = true;
		objBA.Apttus_Approval__IsDelegate__c = true;
		objBA.Apttus_Approval__DelegateUserIds__c = u.Id + ',' + u1.ID;
		
		
		insert objBA;
	}
	
	  

}