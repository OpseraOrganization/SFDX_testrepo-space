/**
 * Created by bkandov on 23/05/2018.
 */

@isTest
private class NCP_NAM_UserDetails_WS_Test {

	private static final String UPDATE_LAST_NAME = 'UPDATE LAST NAME';

	@testSetup static void createTestData() {
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.SandboxNameForUserName__c = '.sandbox';
		insert cs;
	}

	@isTest static void testUpdateUserDetails() {

		User customerUser;
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {

			Account acc = NCP_TestFactory.createAccount();
			Contact cont = NCP_TestFactory.createContact(acc);
			cont.FirstName = 'First Name';
			cont.Email = 'test@testEmail.com';
			cont.Email_Change_Source__c ='Customer/Account request (e.g Name or Domain change)'; 
			cont.MobilePhone = '1234567890';
			cont.City__c = 'City';
			cont.Street__c = 'Street';
			cont.State__c = 'State';
			cont.Country__c = 'Country';
			update cont;

			Contact cont2 = NCP_TestFactory.createContact(acc);
			customerUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			customerUser.FirstName = 'First Name';
			customerUser.FederationIdentifier = '1234';
			customerUser.NCP_Relationship__c = 'Customer';
			customerUser.NCP_HR_ID__c = 'HR_ID';
			customerUser.Phone = '123456';
			customerUser.MobilePhone = '1234567890';
			customerUser.NCP_SSOPID__c = 'SSOPID';
			customerUser.Country__c = 'India';
			customerUser.NCP_Approval_Status__c = 'Approved';
			customerUser.NCP_NSN_ID__c = 'NCP_NSN_ID';
			customerUser.NCP_Horizontal_Company_Name__c = 'Horizontal_Company_Name';

			insert customerUser;

			Test.startTest();

			NCP_NAM_UserDetails_WS.NCP_NAM_UserDetails userDetails = new NCP_NAM_UserDetails_WS.NCP_NAM_UserDetails();
			NCP_NAM_UserDetails_WS.ResponseParams responseParams = NCP_NAM_UserDetails_WS.updateUserDetails(userDetails);
			System.assertEquals(responseParams.Status, 400);

			userDetails.FederationIdentifier = 'aaa';
			responseParams = NCP_NAM_UserDetails_WS.updateUserDetails(userDetails);
			System.assertEquals(responseParams.Status, 400);

			userDetails.Username = customerUser.Username;
			userDetails.FederationIdentifier = customerUser.FederationIdentifier;
			userDetails.IsActive = customerUser.IsActive;
			userDetails.NokiaID = customerUser.Nokia_ID__c;
			userDetails.Email = customerUser.Email;
			userDetails.MobilePhone = customerUser.MobilePhone;
			userDetails.LastName = UPDATE_LAST_NAME; // CHANGE USER'S LAST NAME
			userDetails.FirstName = customerUser.FirstName;
			userDetails.NCPRelationship = customerUser.NCP_Relationship__c;
			userDetails.NCPHRID = customerUser.NCP_HR_ID__c;
			userDetails.Phone = customerUser.Phone;
			userDetails.NCPSSOPID = customerUser.NCP_SSOPID__c;
			userDetails.Country = 'IN';
			userDetails.NCPApprovalStatus = customerUser.NCP_Approval_Status__c;
			userDetails.NCPNSNID = customerUser.NCP_NSN_ID__c;
			userDetails.NCPIsHorizontal = customerUser.NCP_IsHorizontal__c;
			userDetails.NCPHorizontalCompanyName = customerUser.NCP_Horizontal_Company_Name__c;

			userDetails.UserContact = new NCP_NAM_UserDetails_WS.NCP_NAM_ContactDetails();
			userDetails.UserContact.FirstName = cont.FirstName;
			userDetails.UserContact.LastName = cont.LastName;
			userDetails.UserContact.Email = cont.Email;
			userDetails.UserContact.City = cont.City__c;
			userDetails.UserContact.Street = cont.Street__c;
			userDetails.UserContact.State = cont.State__c;
			userDetails.UserContact.Country = cont.Country__c;

			// START - test SUCCESS
			responseParams = NCP_NAM_UserDetails_WS.updateUserDetails(userDetails);
			System.debug('error >>');
			System.debug(responseParams);
			//System.assertEquals(responseParams.Status, 201);

			User updatedUser = [SELECT Id,LastName FROM User where Id = :customerUser.Id];
			//System.assertEquals(updatedUser.LastName, UPDATE_LAST_NAME);

//			usersDetails = new List<NCP_NAM_UserDetails_WS.NCP_NAM_UserDetails>();
//			usersDetails.add(userDetails);
//			responseParams = NCP_NAM_UserDetails_WS.updateUsersDetails(usersDetails);
//			System.debug('error >>');
//			System.debug(responseParams);
//			System.debug('usersDetails >>');
//			System.debug(usersDetails[0]);
//			System.assertEquals(responseParams.Status, 201);
//
//			// END - test SUCCESS
//
//			// ANOTHER ERROR - contact not related to user
//			responseParams = NCP_NAM_UserDetails_WS.updateUserDetails(userDetails);
//			System.debug('error >>');
//			System.debug(responseParams);
//			System.assertEquals(responseParams.Status, 400);
//			// END

			Test.stopTest();
		}


	}

}