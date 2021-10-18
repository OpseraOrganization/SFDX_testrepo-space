/****************************************
* Name : CommunityClientLogoTest
* Author : Accenture
* Description : Test class for CommunityClientLogo
*****************************************/
@istest
private with sharing class CommunityClientLogoTest{
	/******************************
	*Method Name: getAccountAttachmentTest
	*Description: Test Method to cover getAccountAttachment,getCurrentUserData method
	********************************/
	static testMethod void getAccountAttachmentTest(){
		Account accountCreation = TestDataFactory.createAccount(1)[0]; 
		accountCreation.AccountNumber  = '301545';
		database.insert(accountCreation);
		
		//Contact con = new Contact(LastName ='testCon',AccountId = accountCreation.Id);
		List<Contact> con = TestDataFactory.createContact(1,accountCreation);
		con[0].LastName = 'testCon';
		insert con;  
		
		user userCreation = TestDataFactory.userCreation(1,'PRM Partner Community User Login')[0];
		userCreation.contactId = con[0].id;
		userCreation.FirstName = 'Test';
		userCreation.LastName  = 'test';
		

			
			CommunityClientLogo.getCurrentUserData();
			//CommunityClientLogo.getAccountAttachment();
	}
}