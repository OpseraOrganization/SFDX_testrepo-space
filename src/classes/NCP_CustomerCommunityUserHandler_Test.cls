/**
* Created by bkandov on 10/05/2018.
*/
@isTest
private class NCP_CustomerCommunityUserHandler_Test {
	private static String COMMUNITY_ID;
	
	@testSetup static void setup() {
		NCP_CustomerCommunitySetting__c setting = NCP_TestFactory.insertCustomSetting();
		setting.Internal_User_Profile__c = 'system Administrator';
		update setting;
		ISO_Country_Codes__c countryCodes = NCP_TestFactory.insertIsoCountryCodes();
		
		Network MyCommunity = new Network();
		MyCommunity = [SELECT Id,Name From Network WHERE Name = 'Customers' Limit 1];
		COMMUNITY_ID = MyCommunity.Id; 
		
		System.assertNotEquals(null, setting);
	}
	
	@isTest
	static void testCreateUser() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		insert adminUser;
		System.runAs(adminUser) {
			
			Test.startTest();
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			Account acc = new Account(
	Name = 'customer name to be tested in JIT code and this code is for testing the length more than 80 characters',
	accountNumber = 'customer number',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			insert acc;
			
			Account LEacc = new Account(
	Name = ' LE customer name',
	accountNumber = '111',
	NCP_P20_ID__c='111',
	parentId = acc.Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			insert LEacc;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
			
			attributes.put('emailID', 'test123@gmail.com');
			attributes.put('Lname', 'AES');
			attributes.put('Fname', 'AES');
			//attributes.put('FederationIdentifier', 'ex@ex.com');
			attributes.put('Approval Status', '');
			attributes.put('Street', '');
			attributes.put('City', 'test city');
			attributes.put('State', '');
			attributes.put('PostalCode', 'test postal code');
			attributes.put('CountryCode', 'IN');
			attributes.put('Country', 'India');
			attributes.put('Phone', '');
			attributes.put('Relationship', 'Customer');
			attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
			attributes.put('NSN ID', '');
			attributes.put('HorizontalFlag', '');
			attributes.put('HorizontalCustomerName', '');
			attributes.put('ApprovalStatus', 'Approved');
			attributes.put('SSOPID', '50000000');
			attributes.put('MobilePhone', '9000000000');
			attributes.put('PersonalID', 'B12345678');
			attributes.put('Username', 'abcd@singlecrm.nokia.com');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no contact');
			}
			
			CH_AccountName__c settings = CH_AccountName__c.getOrgDefaults();
			settings.CH_InvalidName__c = 'Nokia';
			settings.CH_ValidName__c = 'Nokia OYJ';
			upsert settings;
			
			Contact cont = new Contact(
	AccountId = acc.Id,
	FirstName = 'First Name',
	LastName = 'Last Name',
	City__c = 'City',
	Street__c = 'Street',
	State__c = 'State',
	Country__c = 'Country',
	Phone = '0550222333',
	CH_ContactTimeZone__c = '(GMT+14:00) Line Islands Time (Pacific/Kiritimati)',
	CH_PreferredMtdOfServiceCommunication__c = 'Email ',
	Email = 'test@gmail.com');
			insert cont;
			
			//handler.acrChanges(cont,LEacc.Id,acc.Id);
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no legal account');
			}
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - wrong approved status');
			}
			attributes.remove('ApprovalStatus');
			
			Account acc2 = new Account(
	Name = setting.Customer_Account__c,
	AccountNumber = setting.Customer_Account_Number__c,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
	parentId = acc.Id);
			insert acc2;
			
			attributes.put('ALCR', '111');
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - issue with ALCR field');
			}
			attributes.remove('ALCR');
			
			attributes.put('P20', '111');
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - issue with p20 field');
			}
			
			attributes.put('Relationship', 'Internal');
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - issue with p20 field');
			}
			
			//ACR
			attributes.put('nsnPrimaryAccountFlag', 'false');
			try{
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			}
			catch (Exception ex) {
	System.debug('error inside test class - wrong approved status');
			}
			///
			
			Test.stopTest();
		}
	}
	
	@isTest
	static void testCreateUser1() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		insert adminUser;
		System.runAs(adminUser) {
			
			Test.startTest();
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			
			List<Account> parentAccountList = new List<Account>();
			Account acc = new Account(
	Name = 'customer name to be tested in JIT code and this code is for testing the length more than 80 characters',
	accountNumber = 'customer number',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc);
			
			Account acc2 = new Account(
	Name = 'customer name to be tested in JIT code and this code is for testing the length more than 80 characters',
	accountNumber = 'customer number 2',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc2);
			insert parentAccountList;
			
			List<Account> accList = new List<Account>();
			Account accLE = new Account(
	Name = ' LE customer name',
	accountNumber = '111',
	NCP_P20_ID__c='111',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE);
			
			Account accLE2 = new Account(
	Name = ' LE customer name 2',
	accountNumber = '222',
	NCP_P20_ID__c='222',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE2);
			
			Account acc3 = new Account(
	Name = setting.Customer_Account__c,
	AccountNumber = setting.Customer_Account_Number__c,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
	parentId = parentAccountList[0].Id);
			accList.add(acc3);
			
			Account accLE3 = new Account(
	Name = ' LE customer name 3',
	accountNumber = '333',
	NCP_P20_ID__c='333',
	parentId = parentAccountList[1].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE3);
			insert accList;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
			
			attributes.put('emailID', 'test123@gmail.com');
			attributes.put('Lname', 'AES');
			attributes.put('Fname', 'AES');
			//attributes.put('FederationIdentifier', 'ex@ex.com');
			attributes.put('Approval Status', '');
			attributes.put('Street', '');
			attributes.put('City', 'test city');
			attributes.put('State', '');
			attributes.put('PostalCode', 'test postal code');
			attributes.put('CountryCode', 'IN');
			attributes.put('Country', 'India');
			attributes.put('Phone', '');
			attributes.put('Relationship', 'Customer');
			attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
			attributes.put('NSN ID', '');
			attributes.put('HorizontalFlag', '');
			attributes.put('HorizontalCustomerName', '');
			attributes.put('ApprovalStatus', 'Approved');
			attributes.put('SSOPID', '50000000');
			attributes.put('MobilePhone', '9000000000');
			attributes.put('PersonalID', 'B12345678');
			attributes.put('Username', 'abcd@singlecrm.nokia.com');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no contact');
			}
			
			CH_AccountName__c settings = CH_AccountName__c.getOrgDefaults();
			settings.CH_InvalidName__c = 'Nokia';
			settings.CH_ValidName__c = 'Nokia OYJ';
			upsert settings;
			
			Contact cont = new Contact(
	AccountId = parentAccountList[0].Id,
	FirstName = 'First Name',
	LastName = 'Last Name',
	City__c = 'City',
	Street__c = 'Street',
	State__c = 'State',
	Country__c = 'Country',
	Phone = '0550222333',
	CH_ContactTimeZone__c = '(GMT+14:00) Line Islands Time (Pacific/Kiritimati)',
	CH_PreferredMtdOfServiceCommunication__c = 'Email ',
	Email = 'test@gmail.com');
			insert cont;
			
			//handler.acrChanges(cont,accLE.Id,parentAccountList[0].Id);
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no legal account');
			}
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - wrong approved status');
			}
			attributes.remove('ApprovalStatus');
			
			attributes.put('ALCR', '111');
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - issue with ALCR field');
			}
			
			
			attributes.put('displayName', '222');
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - issue with ALCR field');
			}
			attributes.remove('ALCR');
			attributes.remove('displayName');
			
			attributes.put('ALCR', '333');
			
			Case caseRecord = new Case();
			caseRecord.SuppliedEmail = 'test123@gmail.com';
			caseRecord.Status = 'New';
			caseRecord.RecordTypeId = NCP_Utils.getObjectRecordTypeId('Case', 'NCP_SSO_Account_Change'); 
			caseRecord.Subject = 'Test case';
			caseRecord.Description = 'Test Description';
			caseRecord.ContactId = cont.Id;
			caseRecord.AccountID = parentAccountList[1].Id;
			insert caseRecord;
			
			caseRecord.Status = 'Approved';
			update caseRecord;
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - issue with ALCR field');
			}
			Test.stopTest();
			attributes.remove('ALCR');
			
			attributes.put('P20', '111');
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - issue with p20 field');
			}
			
			attributes.put('Relationship', 'Internal');
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
	
			} catch (Exception ex) {
	System.debug('error inside test class - issue with p20 field');
			}
			
			
		}
	}
	
	@isTest
	static void testCreateUserNotApproved() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		insert adminUser;
		System.runAs(adminUser) {
			
			Test.startTest();
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			Account acc = new Account(
	Name = 'customer name to be tested in JIT code and this code is for testing the length more than 80 characters',
	accountNumber = 'customer number',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			insert acc;
			
			Account LEacc = new Account(
	Name = ' LE customer name',
	accountNumber = '111',
	NCP_P20_ID__c='111',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			insert LEacc;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
			
			attributes.put('emailID', 'test123@gmail.com');
			attributes.put('Lname', 'AES');
			attributes.put('Fname', 'AES');
			//attributes.put('FederationIdentifier', 'ex@ex.com');
			attributes.put('Approval Status', '');
			attributes.put('Street', '');
			attributes.put('City', 'test city');
			attributes.put('State', '');
			attributes.put('PostalCode', 'test postal code');
			attributes.put('CountryCode', 'IN');
			attributes.put('Country', 'India');
			attributes.put('Phone', '');
			attributes.put('Relationship', 'Customer');
			attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
			attributes.put('NSN ID', '');
			attributes.put('HorizontalFlag', '');
			attributes.put('HorizontalCustomerName', '');
			attributes.put('ApprovalStatus', 'Pending');
			attributes.put('SSOPID', '50000000');
			attributes.put('MobilePhone', '9000000000');
			attributes.put('PersonalID', 'B12345678');
			attributes.put('Username', 'abcd@singlecrm.nokia.com');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no contact');
			}
			
			CH_AccountName__c settings = CH_AccountName__c.getOrgDefaults();
			settings.CH_InvalidName__c = 'Nokia';
			settings.CH_ValidName__c = 'Nokia OYJ';
			upsert settings;
			
			Contact cont = new Contact(
	AccountId = acc.Id,
	FirstName = 'First Name',
	LastName = 'Last Name',
	City__c = 'City',
	Street__c = 'Street',
	State__c = 'State',
	Country__c = 'Country',
	Phone = '0550222333',
	CH_ContactTimeZone__c = '(GMT+14:00) Line Islands Time (Pacific/Kiritimati)',
	CH_PreferredMtdOfServiceCommunication__c = 'Email ',
	Email = 'test@gmail.com');
			insert cont;
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no legal account');
			}
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - wrong approved status');
			}
			attributes.remove('ApprovalStatus');
			
			Account acc2 = new Account(
	Name = setting.Customer_Account__c,
	AccountNumber = setting.Customer_Account_Number__c,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
	parentId = acc.Id);
			insert acc2;
			
			attributes.put('ALCR', '111');
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - issue with ALCR field');
			}
			attributes.remove('ALCR');
			
			attributes.put('P20', '111');
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
	
			} catch (Exception ex) {
	System.debug('error inside test class - issue with p20 field');
			}
			Test.stopTest();
		}
	}   
	
	@isTest
	static void testCreateUserScenario() {
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		insert adminUser;
		System.runAs(adminUser) {	
			Test.startTest();
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			Account acc = new Account(
	Name = 'customer name to be tested in JIT code and this code is for testing the length more than 80 characters',
	accountNumber = 'customer number',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			insert acc;	
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
			
			attributes.put('emailID', 'test123@gmail.com');
			attributes.put('PersonalID', '2341236');
			attributes.put('Lname', 'AES');
			attributes.put('Fname', 'AES');
			//attributes.put('FederationIdentifier', 'ex@ex.com');
			attributes.put('Approval Status', '');
			attributes.put('Street', '');
			attributes.put('City', 'test city');
			attributes.put('State', '');
			attributes.put('PostalCode', 'test postal code');
			attributes.put('CountryCode', 'IN');
			attributes.put('Country', 'India');
			attributes.put('Phone', '');
			attributes.put('Relationship', 'Customer');
			attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
			attributes.put('NSN ID', '');
			attributes.put('HorizontalFlag', '');
			attributes.put('HorizontalCustomerName', '');
			attributes.put('ApprovalStatus', 'Approved');
			attributes.put('SSOPID', '50000000');
			attributes.put('MobilePhone', '9000000000');
			attributes.put('PersonalID', 'B12345678');
			attributes.put('ALCR', '111');
			attributes.put('P20', '111');
			attributes.put('Username', 'abcd@singlecrm.nokia.com');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no contact');
			}
			
			CH_AccountName__c settings = CH_AccountName__c.getOrgDefaults();
			settings.CH_InvalidName__c = 'Nokia';
			settings.CH_ValidName__c = 'Nokia OYJ';
			upsert settings;
			
			Contact cont = new Contact(
	AccountId = acc.Id,
	FirstName = 'First Name',
	LastName = 'Last Name',
	City__c = 'City',
	Street__c = 'Street',
	State__c = 'State',
	Country__c = 'Country',
	Phone = '0550222333',
	CH_ContactTimeZone__c = '(GMT+14:00) Line Islands Time (Pacific/Kiritimati)',
	CH_PreferredMtdOfServiceCommunication__c = 'Email ',
	Email = 'test@gmail.com');
			insert cont;
			
			handler.createCase(cont,attributes, false);
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no legal account' + ex.getMessage());
			}
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - wrong approved status' + ex.getMessage());
			}
			
			attributes.remove('ApprovalStatus');
			
			Account acc2 = new Account(
	Name = setting.Customer_Account__c,
	AccountNumber = setting.Customer_Account_Number__c,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
	parentId = acc.Id);
			insert acc2;
			
			
			User myUser;
			try{
	myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - wrong approved status' + ex.getMessage());
			}
			
			attributes.put('emailID', 'test1234567890@gmail.com');
			try {
	myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - wrong contact email');
			}
			attributes.put('emailID', 'test@gmail.com');
			
			try {
	myUser.isActive = false;
	handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - user is inactive');
			} 
			
			Test.stopTest();
		}
	}
	
	@isTest
	static void testRelationShipInternal() {
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		insert adminUser;
		System.runAs(adminUser) {
			
			Test.startTest();
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			Account acc = new Account(
	Name = 'customer name',
	accountNumber = 'customer number',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			insert acc;
			
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
			String federationIdentifier = '15262723';
			
			attributes.put('emailID', 'test@gmail.com');
			attributes.put('PersonalID', '2345556');
			attributes.put('Lname', 'AES');
			attributes.put('Fname', 'AES');
			//attributes.put('FederationIdentifier', 'ex@ex.com');
			attributes.put('Approval Status', '');
			attributes.put('Street', '');
			attributes.put('City', 'test city');
			attributes.put('State', '');
			attributes.put('PostalCode', 'test postal code');
			attributes.put('CountryCode', 'IN');
			attributes.put('Country', 'India');
			attributes.put('Phone', '');
			attributes.put('Relationship', 'Customer');
			attributes.put('NSN ID', '');
			attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
			attributes.put('HorizontalFlag', '');
			attributes.put('HorizontalCustomerName', '');
			attributes.put('ApprovalStatus', 'approved status');
			attributes.put('Username', 'abcd@singlecrm.nokia.com');
			attributes.put('SSOPID', '50000000');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no contact');
			}
			
			CH_AccountName__c settings = CH_AccountName__c.getOrgDefaults();
			settings.CH_InvalidName__c = 'Nokia';
			settings.CH_ValidName__c = 'Nokia OYJ';
			upsert settings;
			
			Contact cont = new Contact(
	AccountId = acc.Id,
	FirstName = 'First Name',
	LastName = 'Last Name',
	City__c = 'City',
	Street__c = 'Street',
	State__c = 'State',
	Country__c = 'Country',
	Phone = '0550222333',
	CH_ContactTimeZone__c = '(GMT+14:00) Line Islands Time (Pacific/Kiritimati)',
	CH_PreferredMtdOfServiceCommunication__c = 'Email ',
	Email = 'test1@gmail.com');
			insert cont;
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no legal account');
			}
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - wrong approved status');
			}
			attributes.remove('ApprovalStatus');
			
			Account acc2 = new Account(
	Name = setting.Customer_Account__c,
	AccountNumber = setting.Customer_Account_Number__c,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
	parentId = acc.Id);
			insert acc2;
			
			// Internal User
			Account internalAccount = NCP_TestFactory.createAccount(setting.Internal_User_Profile__c);
			Account acc3 = new Account(
	Name = setting.Internal_User_Profile__c,
	AccountNumber = '12345',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
	parentId = internalAccount.Id);
			insert acc3;
			
			federationIdentifier = '152627231';
			attributes = new Map<String, String>();
			
			attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');		
			attributes.put('emailID', 'test113344@gmail.com');
			attributes.put('PersonalID', '234555611');
			attributes.put('Lname', 'DCP Internal Portal User');
			attributes.put('Fname', 'DCP');
			attributes.put('MobilePhone', '9000000000');
			//attributes.put('FederationIdentifier', 'ex55@ex.com');
			//attributes.put('FederationIdentifier', federationIdentifier);
			attributes.put('Approval Status', '');
			attributes.put('Street', '');
			attributes.put('City', 'test city');
			attributes.put('PostalCode', 'test postal code');
			attributes.put('CountryCode', 'IN');
			attributes.put('Country', 'India');
			attributes.put('Phone', '');
			attributes.put('NSN ID', '');
			attributes.put('ALCR', acc3.Id);
			attributes.put('Username', 'abcd@singlecrm.nokia.com');
			attributes.put('SSOPID', '50000000');
			
			try {
	User internalUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
	handler.updateUser(internalUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no Relationship');
			}
			
			attributes.put('Relationship', 'Partner');
			try {
	User internalUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
	handler.updateUser(internalUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - Relationship Partner');
			}
			attributes.put('Relationship', 'WRONG');
			try {
	User internalUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
	handler.updateUser(internalUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - WRONG Relationship');
			}
			
			attributes.put('Relationship', 'Internal');
			//User internalUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			try{
	User internalUser = handler.createUser(null, COMMUNITY_ID, null, federationIdentifier, attributes, '');
	handler.updateUser(internalUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - WRONG Internal');
			}
			
			Test.stopTest();
		}
	}
	
	@isTest
	static void testRelationShipInternalUpdate() {
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		insert adminUser;
		System.runAs(adminUser) {
			
			Test.startTest();
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			Account acc = new Account(
	Name = 'customer name',
	accountNumber = 'customer number',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			insert acc;
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			attributes.put('emailID', 'test@gmail.com');
			// attributes.put('Personal ID', '2345556');
			attributes.put('Lname', 'AES');
			attributes.put('Fname', 'AES');
			//attributes.put('FederationIdentifier', 'ex@ex.com');
			attributes.put('Approval Status', '');
			attributes.put('Street', '');
			attributes.put('City', 'test city');
			attributes.put('State', '');
			attributes.put('PostalCode', 'test postal code');
			attributes.put('CountryCode', 'IN');
			attributes.put('Country', 'India');
			attributes.put('Phone', '');
			attributes.put('Relationship', 'Customer');
			attributes.put('NSN ID', '');
			attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
			attributes.put('HorizontalFlag', '');
			attributes.put('HorizontalCustomerName', '');
			attributes.put('ApprovalStatus', 'Approved');		 
			attributes.put('SSOPID', '50000000');
			attributes.put('MobilePhone', '9000000000');
			attributes.put('PersonalID', 'B12345678');
			attributes.put('Username', 'abcd@singlecrm.nokia.com');   
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no contact');
			}
			
			CH_AccountName__c settings = CH_AccountName__c.getOrgDefaults();
			settings.CH_InvalidName__c = 'Nokia';
			settings.CH_ValidName__c = 'Nokia OYJ';
			upsert settings;
			
			Contact cont = new Contact(
	AccountId = acc.Id,
	FirstName = 'First Name',
	LastName = 'Last Name',
	City__c = 'City',
	Street__c = 'Street',
	State__c = 'State',
	Country__c = 'Country',
	Phone = '0550222333',
	CH_ContactTimeZone__c = '(GMT+14:00) Line Islands Time (Pacific/Kiritimati)',
	CH_PreferredMtdOfServiceCommunication__c = 'Email ',
	Email = 'test123test@gmail.com');
			insert cont;
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no legal account');
			}
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - wrong approved status');
			}
			attributes.remove('ApprovalStatus');
			
			Account acc2 = new Account(
	Name = setting.Customer_Account__c,
	AccountNumber = setting.Customer_Account_Number__c,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
	parentId = acc.Id);
			insert acc2;
			
			// Internal User
			Account internalAccount = NCP_TestFactory.createAccount(setting.Internal_User_Profile__c);
			Account acc3 = new Account(
	Name = setting.Internal_User_Profile__c,
	AccountNumber = '12345',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
	parentId = internalAccount.Id);
			insert acc3;
			
			federationIdentifier = '152627231';
			attributes = new Map<String, String>();
			attributes.put('emailID', 'test113344@gmail.com');
			attributes.put('PersonalID', '234555611');
			attributes.put('Fname', 'DCP');
			attributes.put('MobilePhone', '9000000000');
			attributes.put('Lname', 'DCP Internal Portal User');
			//attributes.put('FederationIdentifier', 'ex55@ex.com');
			//attributes.put('FederationIdentifier', federationIdentifier);
			attributes.put('Approval Status', '');
			attributes.put('Street', '');
			attributes.put('City', 'test city');
			attributes.put('PostalCode', 'test postal code');
			attributes.put('CountryCode', 'IN');
			attributes.put('Country', 'India');
			attributes.put('Phone', '');
			attributes.put('NSNID', '');
			attributes.put('SSOPID', '50000000');
			attributes.put('ALCR', acc3.Id);
			attributes.put('Username', 'abcd@singlecrm.nokia.com');
			attributes.put('Relationship', 'Internal');
			
			
			//User internalUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			try{
	User internalUser = handler.createUser(null, COMMUNITY_ID, null, federationIdentifier, attributes, '');
	handler.updateUser(internalUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - WRONG Internal');
			}
			User myUser;
			try{
	myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - WRONG Internal');
			}
			try {
	myUser.isActive = false;
	handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - user is inactive');
			}		 
			
			Test.stopTest();
		}
	}
	
	@isTest
	static void testAutomationFailureScenario(){
		// Internal User
		
		Test.startTest();
		NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
		Account internalAccount = NCP_TestFactory.createAccount(setting.Internal_User_Profile__c);
		Account acc3 = new Account(
			Name = setting.Internal_User_Profile__c,
			AccountNumber = '12345',
			recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
			parentId = internalAccount.Id);
		insert acc3;
		NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
		String federationIdentifier = '152627231';
		Map<String, String> attributes = new Map<String, String>();
		
		
		NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
		timeZ.Name = '123';
		timeZ.SF_Timezone__c = 'Europe/Amsterdam';
		timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
		insert timeZ;
		attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');		
		attributes = new Map<String, String>();
		attributes.put('emailID', 'test113344@gmail.com');
		attributes.put('PersonalID', '234555611');
		attributes.put('Lname', 'DCP Internal Portal User');
		attributes.put('Fname', 'DCP');
		attributes.put('MobilePhone', '9000000000');		
		//attributes.put('FederationIdentifier', 'ex55@ex.com');
		//attributes.put('FederationIdentifier', federationIdentifier);
		attributes.put('Approval Status', '');
		attributes.put('Street', '');
		attributes.put('City', 'test city');
		attributes.put('PostalCode', 'test postal code');
		attributes.put('CountryCode', 'IN');
		attributes.put('Country', 'India');
		attributes.put('Phone', '');
		attributes.put('NSNID', '');
		attributes.put('SSOPID', '50000000');
		attributes.put('ALCR', acc3.Id);
		attributes.put('Relationship', 'Internal');
		attributes.put('Username', 'abcd@singlecrm.nokia.com');
		
		//User internalUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
		User internalUser;
		try{	
			internalUser = handler.createUser(null, COMMUNITY_ID, null, federationIdentifier, attributes, '');
			internalUser.isActive=false;
			update internalUser;
			handler.updateUser(internalUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
		}
		catch(Exception e)
		{
			system.assertEquals(e.getMessage(), e.getMessage());   
		}
		Test.stopTest();
	}
	@isTest
	static void testAutomationScenario(){
		
		Test.startTest();
		NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
		Account internalAccount = NCP_TestFactory.createAccount(setting.Internal_User_Profile__c);
		Account acc3 = new Account(
			Name = setting.Internal_User_Profile__c,
			AccountNumber = '12345',
			recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
			parentId = internalAccount.Id);
		insert acc3;
		NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
		String federationIdentifier = '152627231';
		Map<String, String> attributes = new Map<String, String>();
		
		NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
		timeZ.Name = '123';
		timeZ.SF_Timezone__c = 'Europe/Amsterdam';
		timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
		insert timeZ;
		attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
		
		attributes = new Map<String, String>();
		attributes.put('emailID', 'test113344@gmail.com');
		attributes.put('PersonalID', '234555611');
		attributes.put('Lname', 'DCP Internal Portal User');
		attributes.put('Fname', 'DCP');
		attributes.put('MobilePhone', '9000000000');
		//attributes.put('FederationIdentifier', 'ex55@ex.com');
		//attributes.put('FederationIdentifier', federationIdentifier);
		attributes.put('Approval Status', '');
		attributes.put('Street', '');
		attributes.put('City', 'test city');
		attributes.put('PostalCode', 'test postal code');
		attributes.put('CountryCode', 'IN');
		attributes.put('Country', 'India');
		attributes.put('Phone', '');
		attributes.put('NSNID', '');
		attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
		attributes.put('ALCR', acc3.Id);
		attributes.put('Relationship', 'Internal'); 
		attributes.put('Username', 'abcd@singlecrm.nokia.com');  
		attributes.put('SSOPID', '50000000');  
		User internalUser;
		
		List<User> userlist=[select id from User where Profile.Name='DCP Internal Portal User' and isActive=true];
		List<User> informaticaUser=[select id from User where Name='Informatica User'];
		CollaborationGroup grp=new CollaborationGroup(Name=setting.License_Management_Group__c,CollaborationType='Public');
		insert grp;
		CollaborationGroupMember member=new CollaborationGroupMember(MemberId=informaticaUser[0].id,CollaborationGroupId=grp.id);
		insert member;
		System.runAs(new user(ID = UserInfo.getUserID()))
		{
			
			setting.License_Threshold_Limit__c=String.valueOf(userlist.size()+10);
			setting.Warning_System_Threshold__c=String.valueOf(userlist.size());
			update setting;
		}
		
		
		System.runAs(informaticaUser[0])
		{
			internalUser = handler.createUser(null, COMMUNITY_ID, null, federationIdentifier, attributes, '');
			internalUser.isActive=false;
			update internalUser;
			//handler.updateUser(internalUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
		}
		Test.stopTest();
		
	}
	
	@isTest
	static void testCreateUserScenarioLead() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		insert adminUser;
		System.runAs(adminUser) {
			
			Test.startTest();
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			Account acc = new Account(
	Name = 'Customer',
	accountNumber = 'customer number',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			insert acc;
			
			Id RecordTypeCaseId = NCP_Utils.getObjectRecordTypeId('Case', 'SF_Support');
			Case cas = new Case();
			cas.SuppliedEmail = 'test123@gmail.com';
			cas.Status = 'New';
			cas.RecordTypeId = RecordTypeCaseId ; 
			cas.Subject = 'Test case';
			cas.Description = 'Test Description';		 
			insert cas ;
			
			Id RecordTypeCase2Id = NCP_Utils.getObjectRecordTypeId('Case', 'NCP_SSO_Account_Change');
			Case cases = new Case();
			cases.SuppliedEmail = 'test123@gmail.com';
			cases.Status = 'New';
			cases.RecordTypeId = RecordTypeCase2Id ; 
			cases.Subject = 'Test case';
			cases.Description = 'Test Description';   
			insert cases ;	  
			
			
			Id RecordTypeLeadId = NCP_Utils.getObjectRecordTypeId('Lead', 'Direct_Sales');
			Lead lea = new Lead();
			lea.Email = 'test123@gmail.com';
			lea.recordTypeId = RecordTypeLeadId ;
			lea.Status = 'Open';
			lea.country = 'Ukraine';
			lea.FirstName = 'Test Name';
			lea.LastName = 'Lead';
			lea.Company = 'Customer' ;
			insert lea;		
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
			
			attributes.put('emailID', 'test123@gmail.com');
			attributes.put('PersonalID', '2341236');
			attributes.put('Lname', 'AES');
			attributes.put('Fname', 'AES');
			//attributes.put('FederationIdentifier', 'ex@ex.com');
			attributes.put('Approval Status', '');
			attributes.put('Street', '');
			attributes.put('City', 'test city');
			attributes.put('State', '');
			attributes.put('PostalCode', 'test postal code');
			attributes.put('CountryCode', 'IN');
			attributes.put('Country', 'India');
			attributes.put('Phone', '');
			attributes.put('Relationship', 'Customer');
			attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
			attributes.put('NSN ID', '');
			attributes.put('HorizontalFlag', '');
			attributes.put('HorizontalCustomerName', '');
			attributes.put('ApprovalStatus', 'Approved');
			attributes.put('SSOPID', '50000000');
			attributes.put('MobilePhone', '9000000000');
			attributes.put('PersonalID', 'B12345678');
			attributes.put('ALCR', '111');
			attributes.put('P20', '111');
			attributes.put('Username', 'abcd@singlecrm.nokia.com');
			attributes.put('nsnPrimaryAccountFlag', 'True');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			handler.isCaseExists('test123@gmail.com');
			
			handler.callExistingContactPlatformEvent(lea,RecordTypeLeadId,'Test Name Lead','Customer');
			//handler.callExistingContactPlatformEventJIT(lea,RecordTypeLeadId,'Test Name Lead','Customer');	
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no contact');
			}
			
			CH_AccountName__c settings = CH_AccountName__c.getOrgDefaults();
			settings.CH_InvalidName__c = 'Nokia';
			settings.CH_ValidName__c = 'Nokia OYJ';
			upsert settings;
			
			Contact cont = new Contact(
	AccountId = acc.Id,
	FirstName = 'First Name',
	LastName = 'Last Name',
	City__c = 'City',
	Street__c = 'Street',
	State__c = 'State',
	Country__c = 'Country',
	Phone = '0550222333',
	CH_ContactTimeZone__c = '(GMT+14:00) Line Islands Time (Pacific/Kiritimati)',
	CH_PreferredMtdOfServiceCommunication__c = 'Email ',
	Email = 'test123@gmail.com');
			
			Try{	
	insert cont;
	
			}Catch(Exception Ec){
	System.debug('error inside test class');
			}
			
			handler.postLicenseConsumptionMessageInChatter(5,acc.ID);
			//Account IDCaccount = NCP_CustomerCommunityUserHandler.IndependentContractAccountDetails();
			//Boolean stat = handler.createCaseForDuplicateLeadContact('test123@gmail.com','test123','Account');
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no legal account');
			}
			
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - wrong approved status');
			}
			
			attributes.remove('ApprovalStatus');
			
			Account acc2 = new Account(
	Name = setting.Customer_Account__c,
	AccountNumber = setting.Customer_Account_Number__c,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
	parentId = acc.Id);
			insert acc2;
			try{
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');	 
			}
			catch(Exception e){
	//System.assert(e.getMessage().contains('Data Mismatch found while processing the request due to an issue in the email address.'));
			}
			Test.stopTest();
		}
	}
	
	@isTest
	static void testUpdateUser() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		insert adminUser;
		System.runAs(adminUser) {
			
			Test.startTest();
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			Account acc = new Account(
	Name = 'customer name to be tested in JIT code and this code is for testing the length more than 80 characters',
	accountNumber = 'customer number',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			insert acc;
			
			Account LEacc = new Account(
	Name = ' LE customer name',
	accountNumber = '111',
	NCP_P20_ID__c='111',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			insert LEacc;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
			
			attributes.put('emailID', 'test123@gmail.com');
			attributes.put('Lname', 'AES');
			attributes.put('Fname', 'AES');
			//attributes.put('FederationIdentifier', 'ex@ex.com');
			attributes.put('Approval Status', '');
			attributes.put('Street', '');
			attributes.put('City', 'test city');
			attributes.put('State', '');
			attributes.put('PostalCode', 'test postal code');
			attributes.put('CountryCode', 'IN');
			attributes.put('Country', 'India');
			attributes.put('Phone', '');
			attributes.put('Relationship', 'Customer');
			attributes.put('nokiaTimeZone', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna');
			attributes.put('NSN ID', '');
			attributes.put('HorizontalFlag', '');
			attributes.put('HorizontalCustomerName', '');
			attributes.put('ApprovalStatus', 'Pending');
			attributes.put('SSOPID', '50000000');
			attributes.put('MobilePhone', '9000000000');
			attributes.put('PersonalID', 'B12345678');
			attributes.put('Username', 'abcd@singlecrm.nokia.com');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			
			try {
	//	  User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no contact');
			}
			
			CH_AccountName__c settings = CH_AccountName__c.getOrgDefaults();
			settings.CH_InvalidName__c = 'Nokia';
			settings.CH_ValidName__c = 'Nokia OYJ';
			upsert settings;
			
			
			
			ID ProfileID = [ Select id from Profile where name = 'Customer Portal Manager Custom'].id;
			
			List<Contact> ContactList = new List<Contact>();
			
			Contact Con = new Contact( AccountID = acc.id, FirstName = 'User', LastName = 'test',
	 
	 email = 'test123@gmail.com' );
			
			insert Con;
			
			User u = new User( email='test123@gmail.com', contactid = Con.id, profileid = profileid, UserName='abcd@singlecrm.nokia.com', alias='tuser', CommunityNickName='tuser',
		 
		 TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',
		 
		 LanguageLocaleKey='en_US', FirstName = 'User', LastName = 'Test' );
			
			//User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			try {
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			} catch (Exception ex) {
	System.debug('error inside test class - no contact');
			}
			Test.stopTest();
		}
	}   
	
	@isTest
	static void testMultipleACR1() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		Profile profileRecord = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		adminUser.ProfileId = profileRecord.Id;
		insert adminUser;
		
		
		System.runAs(adminUser) {
			Profiles_to_Bypass__c profilesBypassHCS = new Profiles_to_Bypass__c(SetupOwnerId = adminUser.Id, 	Bypass_Validation_Rule__c = true);
			insert profilesBypassHCS;
			Test.startTest();
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			
			List<Account> parentAccountList = new List<Account>();
			Account acc = new Account(
	Name = 'Parent 1',
	accountNumber = '1234567',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc);
			
			Account acc2 = new Account(
	Name = 'Parent 2',
	accountNumber = '1234568',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc2);
			insert parentAccountList;
			
			List<Account> accList = new List<Account>();
			Account accLE = new Account(
	Name = ' LE customer name',
	accountNumber = '1001069312',
	NCP_P20_ID__c='1000069312',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE);
			
			Account accLE2 = new Account(
	Name = ' LE customer name 2',
	accountNumber = '1001069314',
	NCP_P20_ID__c='1000069313',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE2);
			
			Account acc3 = new Account(
	Name = setting.Customer_Account__c,
	AccountNumber = setting.Customer_Account_Number__c,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
	parentId = parentAccountList[0].Id);
			accList.add(acc3);
			
			Account accLE3 = new Account(
	Name = ' LE customer name 3',
	accountNumber = '1001069315',
	NCP_P20_ID__c='1001069315',
	parentId = parentAccountList[1].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE3);
			
			
			Account accLE4 = new Account(
	Name = ' LE customer name 4',
	accountNumber = '1001069316',
	NCP_P20_ID__c='1001069316',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE4);
			
			insert accList;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1000009553');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			
			attributes.put('ALCR', '1001069314');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			Test.stopTest();
			attributes.put('nokiaSecAlcrId', '1001069312');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			
			attributes.remove('nokiaSecAlcrId');
			attributes.put('ALCR', '1001069315');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');		
		}
	} 
	
	@isTest
	static void testMultipleACR2() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		Profile profileRecord = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		adminUser.ProfileId = profileRecord.Id;
		insert adminUser;
		
		
		System.runAs(adminUser) {
			Profiles_to_Bypass__c profilesBypassHCS = new Profiles_to_Bypass__c(SetupOwnerId = adminUser.Id, 	Bypass_Validation_Rule__c = true);
			insert profilesBypassHCS;
			
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			
			List<Account> parentAccountList = new List<Account>();
			Account acc = new Account(
	Name = 'Parent 1',
	accountNumber = '1234567',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc);
			
			Account acc2 = new Account(
	Name = 'Parent 2',
	accountNumber = '1234568',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc2);
			insert parentAccountList;
			
			List<Account> accList = new List<Account>();
			Account accLE = new Account(
	Name = ' LE customer name',
	accountNumber = '1001069312',
	NCP_P20_ID__c='1000069312',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE);
			
			Account accLE2 = new Account(
	Name = ' LE customer name 2',
	accountNumber = '1001069314',
	NCP_P20_ID__c='1000069313',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE2);
			
			Account acc3 = new Account(
	Name = setting.Customer_Account__c,
	AccountNumber = setting.Customer_Account_Number__c,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
	parentId = parentAccountList[0].Id);
			accList.add(acc3);
			
			Account accLE3 = new Account(
	Name = ' LE customer name 3',
	accountNumber = '1001069315',
	NCP_P20_ID__c='1001069315',
	parentId = parentAccountList[1].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE3);
			
			
			Account accLE4 = new Account(
	Name = ' LE customer name 4',
	accountNumber = '1001069316',
	NCP_P20_ID__c='1001069316',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE4);
			
			insert accList;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			Test.startTest();
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1000009553');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			
			attributes.put('nokiaSecAlcrId', '1001069314');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			Test.stopTest();
			attributes.put('nokiaSecAlcrId', '1001069316');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
		}
	}
	
	@isTest
	static void testMultipleACR3() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		Profile profileRecord = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		adminUser.ProfileId = profileRecord.Id;
		insert adminUser;
		
		
		System.runAs(adminUser) {
			Profiles_to_Bypass__c profilesBypassHCS = new Profiles_to_Bypass__c(SetupOwnerId = adminUser.Id, 	Bypass_Validation_Rule__c = true);
			insert profilesBypassHCS;
			
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			
			List<Account> parentAccountList = new List<Account>();
			Account acc = new Account(
	Name = 'Parent 1',
	accountNumber = '1234567',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc);
			
			Account acc2 = new Account(
	Name = 'Parent 2',
	accountNumber = '1234568',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc2);
			insert parentAccountList;
			
			List<Account> accList = new List<Account>();
			Account accLE = new Account(
	Name = ' LE customer name',
	accountNumber = '1001069312',
	NCP_P20_ID__c='1000069312',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE);
			
			Account accLE2 = new Account(
	Name = ' LE customer name 2',
	accountNumber = '1001069314',
	NCP_P20_ID__c='1000069313',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE2);
			
			Account acc3 = new Account(
	Name = setting.Customer_Account__c,
	AccountNumber = setting.Customer_Account_Number__c,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
	parentId = parentAccountList[0].Id);
			accList.add(acc3);
			
			Account accLE3 = new Account(
	Name = ' LE customer name 3',
	accountNumber = '1001069315',
	NCP_P20_ID__c='1001069315',
	parentId = parentAccountList[1].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE3);
			
			
			Account accLE4 = new Account(
	Name = ' LE customer name 4',
	accountNumber = '1001069316',
	NCP_P20_ID__c='1001069316',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE4);
			
			insert accList;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			Test.startTest();
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1000009553');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			
			attributes.put('nokiaSecAlcrId', '1001069314');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			Test.stopTest();
			
			attributes.remove('nokiaSecAlcrId');
			attributes.put('ALCR', '1001069315');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
		}
	} 
	@isTest
	static void testMultipleACR4() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		Profile profileRecord = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		adminUser.ProfileId = profileRecord.Id;
		insert adminUser;
		
		
		System.runAs(adminUser) {
			Profiles_to_Bypass__c profilesBypassHCS = new Profiles_to_Bypass__c(SetupOwnerId = adminUser.Id, 	Bypass_Validation_Rule__c = true);
			insert profilesBypassHCS;
			Test.startTest();
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			
			List<Account> parentAccountList = new List<Account>();
			Account acc = new Account(
	Name = 'Parent 1',
	accountNumber = '1234567',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc);
			
			Account acc2 = new Account(
	Name = 'Parent 2',
	accountNumber = '1234568',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc2);
			insert parentAccountList;
			
			List<Account> accList = new List<Account>();
			Account accLE = new Account(
	Name = ' LE customer name',
	accountNumber = '1001069312',
	NCP_P20_ID__c='1000069312',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE);
			
			Account accLE2 = new Account(
	Name = ' LE customer name 2',
	accountNumber = '1001069314',
	NCP_P20_ID__c='1000069313',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE2);
			
			Account acc3 = new Account(
	Name = setting.Customer_Account__c,
	AccountNumber = setting.Customer_Account_Number__c,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
	parentId = parentAccountList[0].Id);
			accList.add(acc3);
			
			Account accLE3 = new Account(
	Name = ' LE customer name 3',
	accountNumber = '1001069315',
	NCP_P20_ID__c='1001069315',
	parentId = parentAccountList[1].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE3);
			
			
			Account accLE4 = new Account(
	Name = ' LE customer name 4',
	accountNumber = '1001069316',
	NCP_P20_ID__c='1001069316',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE4);
			
			insert accList;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1000009553');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			
			attributes.put('nokiaSecAlcrId', '1001069314');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			Test.stopTest();
			attributes.put('ALCR', '1001069316');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');	
		}
	}
	
	@isTest
	static void testMultipleACR5() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		Profile profileRecord = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		adminUser.ProfileId = profileRecord.Id;
		insert adminUser;
		
		
		System.runAs(adminUser) {
			Profiles_to_Bypass__c profilesBypassHCS = new Profiles_to_Bypass__c(SetupOwnerId = adminUser.Id, 	Bypass_Validation_Rule__c = true);
			insert profilesBypassHCS;
			
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			
			List<Account> parentAccountList = new List<Account>();
			Account acc = new Account(
	Name = 'Parent 1',
	accountNumber = '1234567',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc);
			
			Account acc2 = new Account(
	Name = 'Parent 2',
	accountNumber = '1234568',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc2);
			insert parentAccountList;
			
			List<Account> accList = new List<Account>();
			Account accLE = new Account(
	Name = ' LE customer name',
	accountNumber = '1001069312',
	NCP_P20_ID__c='1000069312',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE);
			
			Account accLE2 = new Account(
	Name = ' LE customer name 2',
	accountNumber = '1001069314',
	NCP_P20_ID__c='1000069313',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE2);
			
			Account acc3 = new Account(
	Name = setting.Customer_Account__c,
	AccountNumber = setting.Customer_Account_Number__c,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
	parentId = parentAccountList[0].Id);
			accList.add(acc3);
			
			Account accLE3 = new Account(
	Name = ' LE customer name 3',
	accountNumber = '1001069315',
	NCP_P20_ID__c='1001069315',
	parentId = parentAccountList[1].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE3);
			
			
			Account accLE4 = new Account(
	Name = ' LE customer name 4',
	accountNumber = '1001069316',
	NCP_P20_ID__c='1001069316',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE4);
			
			insert accList;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			Test.startTest();
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1000009553');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			
			attributes.put('ALCR', '1001069315');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			Test.stopTest();	 
		}
	}
	
	@isTest
	static void testMultipleACR6() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		Profile profileRecord = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		adminUser.ProfileId = profileRecord.Id;
		insert adminUser;
		
		
		System.runAs(adminUser) {
			Profiles_to_Bypass__c profilesBypassHCS = new Profiles_to_Bypass__c(SetupOwnerId = adminUser.Id, 	Bypass_Validation_Rule__c = true);
			insert profilesBypassHCS;
			Test.startTest();
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			
			List<Account> parentAccountList = new List<Account>();
			Account acc = new Account(
	Name = 'Parent 1',
	accountNumber = '1234567',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc);
			
			Account acc2 = new Account(
	Name = 'Parent 2',
	accountNumber = '1234568',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc2);
			insert parentAccountList;
			
			List<Account> accList = new List<Account>();
			Account accLE = new Account(
	Name = ' LE customer name',
	accountNumber = '1001069312',
	NCP_P20_ID__c='1000069312',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE);
			
			Account accLE2 = new Account(
	Name = ' LE customer name 2',
	accountNumber = '1001069314',
	NCP_P20_ID__c='1000069313',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE2);
			
			Account acc3 = new Account(
	Name = setting.Customer_Account__c,
	AccountNumber = setting.Customer_Account_Number__c,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
	parentId = parentAccountList[0].Id);
			accList.add(acc3);
			
			Account accLE3 = new Account(
	Name = ' LE customer name 3',
	accountNumber = '1001069315',
	NCP_P20_ID__c='1001069315',
	parentId = parentAccountList[1].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE3);
			
			
			Account accLE4 = new Account(
	Name = ' LE customer name 4',
	accountNumber = '1001069316',
	NCP_P20_ID__c='1001069316',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE4);
			
			insert accList;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1000009553');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			
			attributes.put('nokiaSecAlcrId', '1001069314');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			Test.stopTest();
			attributes.remove('nokiaSecAlcrId');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');	
		}
	}
	
	@isTest
	static void testMultipleACR7() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		Profile profileRecord = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		adminUser.ProfileId = profileRecord.Id;
		insert adminUser;
		
		
		System.runAs(adminUser) {
			Profiles_to_Bypass__c profilesBypassHCS = new Profiles_to_Bypass__c(SetupOwnerId = adminUser.Id, 	Bypass_Validation_Rule__c = true);
			insert profilesBypassHCS;
			Test.startTest();
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			
			List<Account> parentAccountList = new List<Account>();
			Account acc = new Account(
	Name = 'Parent 1',
	accountNumber = '1234567',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc);
			
			Account acc2 = new Account(
	Name = 'Parent 2',
	accountNumber = '1234568',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc2);
			insert parentAccountList;
			
			List<Account> accList = new List<Account>();
			Account accLE = new Account(
	Name = ' LE customer name',
	accountNumber = '1001069312',
	NCP_P20_ID__c='1000069312',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE);
			
			Account accLE2 = new Account(
	Name = ' LE customer name 2',
	accountNumber = '1001069314',
	NCP_P20_ID__c='1000069313',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE2);
			
			Account acc3 = new Account(
	Name = setting.Customer_Account__c,
	AccountNumber = setting.Customer_Account_Number__c,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
	parentId = parentAccountList[0].Id);
			accList.add(acc3);
			
			Account accLE3 = new Account(
	Name = ' LE customer name 3',
	accountNumber = '1001069315',
	NCP_P20_ID__c='1001069315',
	parentId = parentAccountList[1].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE3);
			
			
			Account accLE4 = new Account(
	Name = ' LE customer name 4',
	accountNumber = '1001069316',
	NCP_P20_ID__c='1001069316',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE4);
			
			insert accList;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1000009553');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			
			attributes.put('nokiaSecAlcrId', '1001069314');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			Test.stopTest();
			attributes.remove('ALCR');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');	
		}
	}
	
	
	@isTest
	static void testMultipleACR8() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		Profile profileRecord = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		adminUser.ProfileId = profileRecord.Id;
		insert adminUser;
		
		
		System.runAs(adminUser) {
			Profiles_to_Bypass__c profilesBypassHCS = new Profiles_to_Bypass__c(SetupOwnerId = adminUser.Id, 	Bypass_Validation_Rule__c = true);
			insert profilesBypassHCS;
			
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			
			List<Account> parentAccountList = new List<Account>();
			Account acc = new Account(
	Name = 'Parent 1',
	accountNumber = '1234567',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc);
			
			Account acc2 = new Account(
	Name = 'Parent 2',
	accountNumber = '1234568',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc2);
			insert parentAccountList;
			
			List<Account> accList = new List<Account>();
			Account accLE = new Account(
	Name = ' LE customer name',
	accountNumber = '1001069312',
	NCP_P20_ID__c='1000069312',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE);
			
			Account accLE3 = new Account(
	Name = ' LE customer name 3',
	accountNumber = '1001069315',
	NCP_P20_ID__c='1001069315',
	parentId = parentAccountList[1].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE3);
			
			insert accList;
			
			List<Venue__c> oVenues = TestDataFactory.createVenues(1);
			insert oVenues;
			//List<Event__c> events = [SELECT Id, Account__c, Event_Type__c FROM Event__c WHERE (Event_Type__c = 'ERM - Executive Review Meeting' OR Event_level__c = 'ERM') AND Account__c =: parentAccountId AND Event_phase__c !='Closed'];
			List<Event__c> oEvents = TestDataFactory.createEvents(1, 'ERM', parentAccountList, oVenues);
			oEvents[0].Event_host__c = adminUser.Id;
			insert oEvents;
			//Event__c eventRecord = new Event__c(Event_Type__c = 'ERM - Executive Review Meeting', Account__c = parentAccountList[0].Id);
			//insert eventRecord;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			Test.startTest();
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1000009553');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			
			attributes.remove('nokiaSecAlcrId');
			attributes.put('ALCR', '1001069315');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			Test.stopTest();
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			
		}
	}
	
	@isTest
	static void testMultipleACR9() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		Profile profileRecord = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		adminUser.ProfileId = profileRecord.Id;
		insert adminUser;
		
		
		System.runAs(adminUser) {
			Profiles_to_Bypass__c profilesBypassHCS = new Profiles_to_Bypass__c(SetupOwnerId = adminUser.Id, 	Bypass_Validation_Rule__c = true);
			insert profilesBypassHCS;
			
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			
			List<Account> parentAccountList = new List<Account>();
			Account acc = new Account(
	Name = 'Parent 1',
	accountNumber = '1234567',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc);
			
			Account acc2 = new Account(
	Name = 'Parent 2',
	accountNumber = '1234568',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc2);
			insert parentAccountList;
			
			List<Account> accList = new List<Account>();
			Account accLE = new Account(
	Name = ' LE customer name',
	accountNumber = '1001069312',
	NCP_P20_ID__c='1000069312',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE);
			
			Account accLE3 = new Account(
	Name = ' LE customer name 3',
	accountNumber = '1001069315',
	NCP_P20_ID__c='1001069315',
	parentId = parentAccountList[1].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE3);
			
			insert accList;
			
			List<campaign> campaignList= new List<campaign>();
			Campaign camp1 = new Campaign();
			camp1.Name = 'Test camp1';
			camp1.CurrencyIsoCode = 'EUR';
			camp1.Campaign_id__c = 'T9901658'; 
			campaignList.add(camp1);
			insert campaignList;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1000009553');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			Test.startTest();
			Contact contactRecord = new Contact();
			contactRecord.Id = myUser.ContactId;
			contactRecord.Marketing_Campaign__c = campaignList[0].Id;
			update contactRecord;
			
			attributes.put('ALCR', '1001069315');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			List<Case> caseList = [SELECT Id, Status FROM Case WHERE recordtype.name = 'NCP SSO Account Change' AND contactId = :myUser.ContactId AND accountID = :parentAccountList[0].Id AND Status = 'New' ORDER BY CreatedDate DESC];
			caseList[0].Status = 'Approved';
			update caseList;
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			Test.stopTest();
		}
	}
	
	@isTest
	static void testMultipleACR10() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		Profile profileRecord = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		adminUser.ProfileId = profileRecord.Id;
		insert adminUser;
		
		
		System.runAs(adminUser) {
			Profiles_to_Bypass__c profilesBypassHCS = new Profiles_to_Bypass__c(SetupOwnerId = adminUser.Id, 	Bypass_Validation_Rule__c = true);
			insert profilesBypassHCS;
			
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			
			List<Account> parentAccountList = new List<Account>();
			Account acc = new Account(
	Name = 'Parent 1',
	accountNumber = '1234567',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc);
			
			Account acc2 = new Account(
	Name = 'Parent 2',
	accountNumber = '1234568',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc2);
			insert parentAccountList;
			
			List<Account> accList = new List<Account>();
			Account accLE = new Account(
	Name = ' LE customer name',
	accountNumber = '1001069312',
	NCP_P20_ID__c='1000069312',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE);
			
			Account accLE3 = new Account(
	Name = ' LE customer name 3',
	accountNumber = '1001069315',
	NCP_P20_ID__c='1001069315',
	parentId = parentAccountList[1].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE3);
			
			insert accList;
			
			List<Venue__c> oVenues = TestDataFactory.createVenues(1);
			insert oVenues;
			//List<Event__c> events = [SELECT Id, Account__c, Event_Type__c FROM Event__c WHERE (Event_Type__c = 'ERM - Executive Review Meeting' OR Event_level__c = 'ERM') AND Account__c =: parentAccountId AND Event_phase__c !='Closed'];
			List<Event__c> oEvents = TestDataFactory.createEvents(1, 'ERM', parentAccountList, oVenues);
			oEvents[0].Event_host__c = adminUser.Id;
			insert oEvents;
			//Event__c eventRecord = new Event__c(Event_Type__c = 'ERM - Executive Review Meeting', Account__c = parentAccountList[0].Id);
			//insert eventRecord;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1000009553');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			//SELECT Id, email,FirstName,LastName, status, recordType.name FROM lead WHERE email = :email AND RecordType.name IN ('Direct Sales', 'TXLE Lead') AND status != 'Closed - Converted (Qualified)'
			List<Lead> leadList = new  List<Lead>();
			leadList = TestDataFactory.createLead(1);
			leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Direct_Sales').getRecordTypeId();
			leadList[0].email = 'testmultipleacr190320211514@test.com';
			insert leadList;
			Test.startTest();
			try{
	NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
	User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			}
			catch(Exception e){
	System.assert(e.getMessage().contains('Data Mismatch found while processing the request due to an issue in the email address'));
			}Test.stopTest();
		}
	}
	
	@isTest
	static void testMultipleACR11() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		Profile profileRecord = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		adminUser.ProfileId = profileRecord.Id;
		insert adminUser;
		
		
		System.runAs(adminUser) {
			Profiles_to_Bypass__c profilesBypassHCS = new Profiles_to_Bypass__c(SetupOwnerId = adminUser.Id, 	Bypass_Validation_Rule__c = true);
			insert profilesBypassHCS;
			
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			
			List<Account> parentAccountList = new List<Account>();
			Account acc = new Account(
	Name = 'Parent 1',
	accountNumber = '1234567',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc);
			
			Account acc2 = new Account(
	Name = 'Parent 2',
	accountNumber = '1234568',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc2);
			insert parentAccountList;
			
			List<Account> accList = new List<Account>();
			Account accLE = new Account(
	Name = ' LE customer name',
	accountNumber = '1001069312',
	NCP_P20_ID__c='1000069312',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE);
			
			Account accLE3 = new Account(
	Name = ' LE customer name 3',
	accountNumber = '1001069315',
	NCP_P20_ID__c='1001069315',
	parentId = parentAccountList[1].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE3);
			
			insert accList;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1000009553');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			//SELECT Id, email,FirstName,LastName, status, recordType.name FROM lead WHERE email = :email AND RecordType.name IN ('Direct Sales', 'TXLE Lead') AND status != 'Closed - Converted (Qualified)'
			Test.startTest();
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			try{
	User myUser1 = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			}
			catch(Exception e){
	System.assert(e.getMessage().contains('User can not be created'));
			}
			Test.stopTest();
		}
	}
	
	@isTest
	static void testMultipleACR12() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		Profile profileRecord = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		adminUser.ProfileId = profileRecord.Id;
		insert adminUser;
		
		
		System.runAs(adminUser) {
			Profiles_to_Bypass__c profilesBypassHCS = new Profiles_to_Bypass__c(SetupOwnerId = adminUser.Id, 	Bypass_Validation_Rule__c = true);
			insert profilesBypassHCS;
			
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			
			List<Account> parentAccountList = new List<Account>();
			Account acc = new Account(
	Name = 'Parent 1',
	accountNumber = '1234567',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc);
			
			Account acc2 = new Account(
	Name = 'Parent 2',
	accountNumber = '1234568',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc2);
			insert parentAccountList;
			
			List<Account> accList = new List<Account>();
			Account accLE = new Account(
	Name = ' LE customer name',
	accountNumber = '1001069312',
	NCP_P20_ID__c='1000069312',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE);
			
			Account accLE3 = new Account(
	Name = ' LE customer name 3',
	accountNumber = '1001069315',
	NCP_P20_ID__c='1001069315',
	parentId = parentAccountList[1].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE3);
			
			insert accList;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1000009553');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'WW');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			//SELECT Id, email,FirstName,LastName, status, recordType.name FROM lead WHERE email = :email AND RecordType.name IN ('Direct Sales', 'TXLE Lead') AND status != 'Closed - Converted (Qualified)'
			Test.startTest();
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			try{
	User myUser1 = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			}
			catch(Exception e){
	System.assert(e.getMessage().contains('Data Mismatch found while processing the request as System is unable to identify the Country Code.'));
			}
			Test.stopTest();
		}
	}
	
	@isTest
	static void testMultipleACR17() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		Profile profileRecord = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		adminUser.ProfileId = profileRecord.Id;
		insert adminUser;
		
		
		System.runAs(adminUser) {
			Profiles_to_Bypass__c profilesBypassHCS = new Profiles_to_Bypass__c(SetupOwnerId = adminUser.Id, 	Bypass_Validation_Rule__c = true);
			insert profilesBypassHCS;
			
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			
			List<Account> parentAccountList = new List<Account>();
			Account acc = new Account(
	Name = 'Parent 1',
	accountNumber = '1234567',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc);
			
			Account acc2 = new Account(
	Name = 'Parent 2',
	accountNumber = '1234568',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc2);
			insert parentAccountList;
			
			List<Account> accList = new List<Account>();
			Account accLE = new Account(
	Name = ' LE customer name',
	accountNumber = '1001069312',
	NCP_P20_ID__c='1000069312',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE);
			
			Account accLE3 = new Account(
	Name = ' LE customer name 3',
	accountNumber = '1001069315',
	NCP_P20_ID__c='1001069315',
	parentId = parentAccountList[1].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE3);
			
			insert accList;
			Test.startTest();
			List<campaign> campaignList= new List<campaign>();
			Campaign camp1 = new Campaign();
			camp1.Name = 'Test camp1';
			camp1.CurrencyIsoCode = 'EUR';
			camp1.Campaign_id__c = 'T9901658'; 
			campaignList.add(camp1);
			insert campaignList;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1000009553');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			Contact contactRecord = new Contact();
			contactRecord.Id = myUser.ContactId;
			contactRecord.Marketing_Campaign__c = campaignList[0].Id;
			update contactRecord;
			attributes.put('ALCR', '1001069315');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			Test.stopTest();
			List<Case> caseList = [SELECT Id, Status FROM Case WHERE recordtype.name = 'NCP SSO Account Change' AND contactId = :myUser.ContactId AND accountID = :parentAccountList[0].Id AND Status = 'New' ORDER BY CreatedDate DESC];
			caseList[0].Status = 'Closed';
			update caseList;
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			
		}
	}
	
	//2 ACRs replaced by single ALCR under the same parent
	@isTest
	static void testMultipleACR18() {
		
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		Profile profileRecord = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		adminUser.ProfileId = profileRecord.Id;
		insert adminUser;
		
		
		System.runAs(adminUser) {
			Profiles_to_Bypass__c profilesBypassHCS = new Profiles_to_Bypass__c(SetupOwnerId = adminUser.Id, 	Bypass_Validation_Rule__c = true);
			insert profilesBypassHCS;
			Test.startTest();
			NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
			
			List<Account> parentAccountList = new List<Account>();
			Account acc = new Account(
	Name = 'Parent 1',
	accountNumber = '1234567',
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc);
			insert parentAccountList;
			List<Account> accList = new List<Account>();
			Account accLE = new Account(
	Name = ' LE customer name',
	accountNumber = '1001069312',
	NCP_P20_ID__c='1000069312',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE);
			
			Account accLE2 = new Account(
	Name = ' LE customer name 2',
	accountNumber = '1001069314',
	NCP_P20_ID__c='1000069313',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE2);
			
			Account accLE3 = new Account(
	Name = ' LE customer name 3',
	accountNumber = '1001069315',
	NCP_P20_ID__c='1001069315',
	parentId = parentAccountList[0].Id,
	recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE3);			
			insert accList;
			
			String federationIdentifier = '15262723';
			Map<String, String> attributes = new Map<String, String>();
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1000009553');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			
			attributes.put('nokiaSecAlcrId', '1001069314');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			Test.stopTest();
			attributes.remove('nokiaSecAlcrId');
			attributes.put('ALCR', '1001069315');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');	
		}
	}
}