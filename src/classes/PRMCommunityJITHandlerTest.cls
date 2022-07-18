@isTest
private class PRMCommunityJITHandlerTest{
	private static testmethod void createusertest(){
		 List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
			ISO_Country_Codes__c iso = new ISO_Country_Codes__c();
			iso.Name = 'IN';
			iso.Market__c = 'Market India';
			iso.Country_Name__c = 'India';
			insert iso;
			Account accountCreation1 = TestDataFactory.createAccount(1)[0];
			accountCreation1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
			accountCreation1.AccountNumber = '1010101010';
			accountCreation1.Name = 'Nokia OYJ ' + Utils.generateRandomInteger(2)+Utils.generateRandomString(2);
			accountCreation1.BillingStreet = '1660 International Dr';
			accountCreation1.BillingCity = 'McLean';
			accountCreation1.BillingState = 'maharashtra';
			accountCreation1.BillingPostalCode = '22102';
			accountCreation1.BillingCountry = 'india';
			accountCreation1.AccountStatusInCRMOM__c = 'Active';
			accountCreation1.Industry='Enterprise';
			accountCreation1.Market__c='Market India';
			accountCreation1.Country__c='India';
			accountCreation1.acc_no__c = '0QC000000000000';	
			accountCreation1.NCP_P20_ID__c = '0QC000000000000';
			insert accountCreation1;
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.acc_no__c = '0BC000000000000';
			accountCreation.NCP_P20_ID__c = '0BC000000000000';
			accountCreation.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			accountCreation.ParentId =accountCreation1.Id;
			insert accountCreation;
			String accId = accountCreation.id;
			accountCreation.AccountNumber = accId.substring(1, accId.length());
			update accountCreation;
			
			final Id samlSsoProviderId = '0LE000000000000';
			final Id communityId = '0DB000000000000';
			final Id portalId = '0DB000000000000';
			final String federationIdentifier = 'federationIdentifier';
			final Map<String, String> attributes = new Map<String, String> {
	  'ApprovalStatus' =>  'Pending',
		'Customer Name' => 'testname',
		'Relationship' => 'Partner',
		'P20' => '0QC000000000000',
		'ALCR' => '0QC000000000000',
		'MyAccountId' =>  accountCreation.id,
		'Lname' => 'testlname',
		'Fname' => 'testfname',
		'email ID' => 'test@email.com',
		'City' => 'Mumbai',
		'Street' => 'teststreet',
		'emailID' => 'test123456@email1.com',
		'Phone' => '1236549870',
		'Country' => 'India',
		'State' => 'Maharashtra',
		'FederationIdentifier' => federationIdentifier,
		'Personal ID' => 'abcd',
		'nsnPrimaryAccountFlag' => 'true',
		'PersonalID' => '5647598625',
		'MobilePhone' => '7896541230',
		'PostalCode' => '000000',
		'CountryCode' => 'IN',
		'HorizontalFlag' => '1',
		'HorizontalCustomerName' => 'TestName',
		'SSOPID' => 'abcd'		
		};
			final String assertion = 'assertion';
			test.startTest();	
			PRMCommunityJITHandler handler = new PRMCommunityJITHandler();
			try{
			handler.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
			test.stopTest();
			}
			catch(Exception e){
	
			}
		}
	}
	
	private static testmethod void createusertest1(){
		 List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
			ISO_Country_Codes__c iso = new ISO_Country_Codes__c();
			iso.Name = 'IN';
			iso.Market__c = 'Market India';
			iso.Country_Name__c = 'India';
			insert iso;
			Account accountCreation1 = TestDataFactory.createAccount(1)[0];
			accountCreation1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
			accountCreation1.AccountNumber = '1010101010';
			accountCreation1.Name = 'Test Account ' + Utils.generateRandomInteger(2)+Utils.generateRandomString(2);
			accountCreation1.BillingStreet = '1660 International Dr';
			accountCreation1.BillingCity = 'McLean';
			accountCreation1.BillingState = 'maharashtra';
			accountCreation1.BillingPostalCode = '22102';
			accountCreation1.BillingCountry = 'india';
			accountCreation1.AccountStatusInCRMOM__c = 'Active';
			accountCreation1.Industry='Enterprise';
			accountCreation1.Market__c='Market India';
			accountCreation1.Country__c='India';
			insert accountCreation1;
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.acc_no__c = '0QC000000000000';
			accountCreation.NCP_P20_ID__c = '0QC000000000000';
			accountCreation.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			accountCreation.ParentId =accountCreation1.Id;
			insert accountCreation;
			String accId = accountCreation.id;
			accountCreation.AccountNumber = accId.substring(1, accId.length());
			update accountCreation;
			final Id samlSsoProviderId = '0LE000000000000';
			final Id communityId = '0DB000000000000';
			final Id portalId = '0DB000000000000';
			final String federationIdentifier = 'federationIdentifier';
			final Map<String, String> attributes = new Map<String, String> {
		'ApprovalStatus' =>  'Pending',
		'Customer Name' => 'testname',
		'Relationship' => 'Partner',
		'P20' => '0QC000000000000',
		'ALCR' => '',
		'MyAccountId' =>  accountCreation.id,
		'Lname' => 'testlname',
		'Fname' => 'testfname',
		'email ID' => 'test@email.com',
		'City' => 'Mumbai',
		'Street' => 'teststreet',
		'emailID' => 'JITSSO123@email1.com',
		'Phone' => '1236549870',
		'Country' => 'India',
		'State' => 'Maharashtra',
		'FederationIdentifier' => 'Afrdct6cf',
		'Personal ID' => 'abcd',
		'nsnPrimaryAccountFlag' => 'true',
		'PersonalID' => '5647598625',
		'MobilePhone' => '7896541230',
		'PostalCode' => '000000',
		'CountryCode' => 'IN',
		'HorizontalFlag' => '1',
		'HorizontalCustomerName' => 'TestName'
		};
			final String assertion = 'assertion';
	  test.startTest();	
			PRMCommunityJITHandler handler = new PRMCommunityJITHandler();
	  handler.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
			test.stopTest();
		}
	}
	private static testmethod void createusertest2(){
		 List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
			Account accountCreation1 = TestDataFactory.createAccount(1)[0];
			accountCreation1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			accountCreation1.AccountNumber = '10101010101010';
			accountCreation1.Name = 'Nokia OYJ ' + Utils.generateRandomInteger(2)+Utils.generateRandomString(2);
			accountCreation1.BillingStreet = '1660 International Dr';
			accountCreation1.BillingCity = 'McLean';
			accountCreation1.BillingState = 'maharashtra';
			accountCreation1.BillingPostalCode = '22102';
			accountCreation1.BillingCountry = 'india';
			accountCreation1.AccountStatusInCRMOM__c = 'Active';
			accountCreation1.Industry='Enterprise';
			accountCreation1.Market__c='Market India';
			accountCreation1.Country__c='India';
			insert accountCreation1;
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.acc_no__c = '0QC000000000000';
			accountCreation.NCP_P20_ID__c = '0QC000000000000';
			accountCreation.Name = 'Nokia OYJ1';
			accountCreation.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			accountCreation.ParentId =accountCreation1.Id;
			insert accountCreation;
			String accId = accountCreation1.id;
			accountCreation.AccountNumber = accId.substring(1, accId.length());
			update accountCreation;
			String accNo = [select id,acc_no__c from Account where id =: accountCreation.id].acc_no__c;
			Contact con = new Contact();
			con.First_Name__c = 'test';
			con.Last_Name__c = 'test';
			con.LastName = 'test';
			con.Email = 'test@email1.com';
			con.AccountId = accountCreation1.Id;
			insert con;
			List<User> user = TestDataFactory.userCreation(1,'Standard User');
			user[0].NCP_Relationship__c= 'Partner';
			user[0].ProfileId = System.Label.PRM_Partner_Profile_Id;
			user[0].contactID = con.id;
			insert user[0]; 
			final Id samlSsoProviderId = '0LE000000000000';
			final Id communityId = '0DB000000000000';
			final Id portalId = '0DB000000000000';
			final String federationIdentifier = 'federationIdentifier';
			Map<String, String> attributes = new Map<String, String> {
	  'ApprovalStatus' =>  'Approved',
		'Customer Name' => 'testname',
		'Relationship' => 'Partner',
		'P20' => '',
		'ALCR' => accNo,
		'MyAccountId' =>  accountCreation.id,
		'Lname' => 'testlname',
		'Fname' => 'testfname',
		'email ID' => 'test@email.com',
		'City' => 'Mumbai',
		'Street' => 'teststreet',
		//'emailID' => 'test123456@email1.com',
		'Phone' => '1236549870',
		'Country' => 'India',
		'State' => 'Maharashtra',
		//'FederationIdentifier' => 'Afrdct6cf',
		'Personal ID' => 'abcd',
		'nsnPrimaryAccountFlag' => 'true',
		'PersonalID' => '5647598625',
		'MobilePhone' => '7896541230',
		'PostalCode' => '000000',
		/*'CountryCode' => 'US',*/
		'HorizontalFlag' => '1',
		'HorizontalCustomerName' => 'TestName'
		};
			final String assertion = 'assertion';
			PRMCommunityJITHandler handler = new PRMCommunityJITHandler();
			handler.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
			
			
		}
	}
	
	
	private static testmethod void createusertest3(){
		 List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
			
			Account accountCreation1 = TestDataFactory.createAccount(1)[0];
			accountCreation1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
			accountCreation1.AccountNumber = '1010101010';
			accountCreation1.Name = 'Test Account ' + Utils.generateRandomInteger(2)+Utils.generateRandomString(2);
			accountCreation1.BillingStreet = '1660 International Dr';
			accountCreation1.BillingCity = 'McLean';
			accountCreation1.BillingState = 'maharashtra';
			accountCreation1.BillingPostalCode = '22102';
			accountCreation1.BillingCountry = 'india';
			accountCreation1.AccountStatusInCRMOM__c = 'Active';
			accountCreation1.Industry='Enterprise';
			accountCreation1.Market__c='Market India';
			accountCreation1.Country__c='India';
			insert accountCreation1;
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.acc_no__c = '0QC000000000000';
			accountCreation.NCP_P20_ID__c = '0QC000000000000';
			accountCreation.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			accountCreation.ParentId =accountCreation1.Id;
			insert accountCreation;
			String accId = accountCreation.id;
			accountCreation.AccountNumber = accId.substring(1, accId.length());
			update accountCreation;
			final Id samlSsoProviderId = '0LE000000000000';
			final Id communityId = '0DB000000000000';
			final Id portalId = '0DB000000000000';
			final String federationIdentifier = 'federationIdentifier';
			Map<String, String> attributes = new Map<String, String> {
	  'ApprovalStatus' =>  'Pending',
		'Customer Name' => 'testname',
		'Relationship' => 'Internal',
		'P20' => '0QC000000000000',
		'ALCR' => '',
		'MyAccountId' =>  accountCreation.id,
		'Lname' => 'testlname',
		'Fname' => 'testfname',
		'email ID' => 'test@email.com',
		'City' => 'Mumbai',
		'Street' => 'teststreet',
		'emailID' => 'JITSSO321@email1.com',
		'Phone' => '1236549870',
		'Country' => 'India',
		'State' => 'Maharashtra',
		'FederationIdentifier' => 'Afrdct6cfww',
		'Personal ID' => 'abcd',
		'nsnPrimaryAccountFlag' => 'true',
		'PersonalID' => '5647598625',
		'MobilePhone' => '7896541230',
		'PostalCode' => '000000',
		/*'CountryCode' => 'US',*/
		'HorizontalFlag' => '0',
		'HorizontalCustomerName' => 'TestName',
		'SSOPID' => 'ssopid'
		};
			final String assertion = 'assertion';
			PRMCommunityJITHandler handler = new PRMCommunityJITHandler();
			handler.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
			
			
		}
	}
	
	private static testmethod void createusertest4(){
		 List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
	
			Account accountCreation1 = TestDataFactory.createAccount(1)[0];
			accountCreation1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
			accountCreation1.AccountNumber = '1010101010';
			accountCreation1.Name = 'Test Account ' + Utils.generateRandomInteger(2)+Utils.generateRandomString(2);
			accountCreation1.BillingStreet = '1660 International Dr';
			accountCreation1.BillingCity = 'McLean';
			accountCreation1.BillingState = 'maharashtra';
			accountCreation1.BillingPostalCode = '22102';
			accountCreation1.BillingCountry = 'india';
			accountCreation1.AccountStatusInCRMOM__c = 'Active';
			accountCreation1.Industry='Enterprise';
			accountCreation1.Market__c='Market India';
			accountCreation1.Country__c='India';
			insert accountCreation1;
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.acc_no__c = '0QC000000000000';
			accountCreation.NCP_P20_ID__c = '0QC000000000000';
			accountCreation.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			accountCreation.ParentId =accountCreation1.Id;
			insert accountCreation;
			String accId = accountCreation.id;
			accountCreation.AccountNumber = accId.substring(1, accId.length());
			update accountCreation;
			
			NCP_CustomerCommunitySetting__c cucom = new NCP_CustomerCommunitySetting__c();
			cucom.Name = 'Default'; 
			cucom.Customer_Account__c = 'Test Account';
			cucom.Customer_Account_Number__c = '1010101010';
			insert cucom;
			final Id samlSsoProviderId = '0LE000000000000';
			final Id communityId = '0DB000000000000';
			final Id portalId = '0DB000000000000';
			final String federationIdentifier = 'federationIdentifier';
			Map<String, String> attributes = new Map<String, String> {
	  'ApprovalStatus' =>  'Pending',
		'Customer Name' => 'testname',
		'Relationship' => 'Internal',
		'P20' => '',
		'ALCR' => '',
		'MyAccountId' =>  accountCreation.id,
		'Lname' => 'testlname',
		'Fname' => 'testfname',
		'email ID' => 'test@email.com',
		'City' => 'Mumbai',
		'Street' => 'teststreet',
		'emailID' => 'JITSSO321@email1.com',
		'Phone' => '1236549870',
		'Country' => 'India',
		'State' => 'Maharashtra',
		'FederationIdentifier' => 'Afrdct6cfww',
		'Personal ID' => 'abcd',
		'nsnPrimaryAccountFlag' => 'true',
		'PersonalID' => '5647598625',
		'MobilePhone' => '7896541230',
		'PostalCode' => '000000',
		/*'CountryCode' => 'US',*/
		'HorizontalFlag' => '0',
		'HorizontalCustomerName' => 'TestName',
		'SSOPID' => 'ssopid'
		};
			final String assertion = 'assertion';
			try{
			PRMCommunityJITHandler handler = new PRMCommunityJITHandler();
			handler.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
			}
			catch(Exception e){}
		}
	}
	
	private static testmethod void updateusertest1(){
		 List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
			Account accountCreation1 = TestDataFactory.createAccount(1)[0];
			accountCreation1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			accountCreation1.AccountNumber = '1010101010';
			accountCreation1.Name = 'Test Account ' + Utils.generateRandomInteger(2)+Utils.generateRandomString(2);
			accountCreation1.BillingStreet = '1660 International Dr';
			accountCreation1.BillingCity = 'McLean';
			accountCreation1.BillingState = 'maharashtra';
			accountCreation1.BillingPostalCode = '22102';
			accountCreation1.BillingCountry = 'india';
			accountCreation1.AccountStatusInCRMOM__c = 'Active';
			accountCreation1.Industry='Enterprise';
			accountCreation1.Market__c='Market India';
			accountCreation1.Country__c='India';
			insert accountCreation1;
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.acc_no__c = '0QC000000000000';
			accountCreation.NCP_P20_ID__c = '0QC000000000000';
			accountCreation.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			accountCreation.ParentId =accountCreation1.Id;
			insert accountCreation;
			String accId = accountCreation.id;
			accountCreation.AccountNumber = accId.substring(1, accId.length());
			update accountCreation;
			Contact con = new Contact();
			con.First_Name__c = 'test';
			con.Last_Name__c = 'test';
			con.LastName = 'test';
			con.Email = 'test@email1.com';
			con.AccountId = accountCreation1.Id;
			insert con;
			List<User> user = TestDataFactory.userCreation(1,'Standard User');
			user[0].NCP_Relationship__c= 'Customer';
			user[0].ProfileId = System.Label.PRM_Partner_Profile_Id;
			user[0].contactID = con.id;
			user[0].isActive = false;	
			insert user[0]; 
			final Id samlSsoProviderId = '0LE000000000000';
			final Id communityId = null;
			final Id portalId = '0AB000000000000';
			final String federationIdentifier = 'federationIdentifier';
			String accNo = [select id,acc_no__c from Account where id =: accountCreation.id].acc_no__c;
			Map<String, String> attributes = new Map<String, String> {
	  'ApprovalStatus' =>  'Approved',
		'Customer Name' => 'testname',
		'Relationship' => 'Partner',
		'P20' => '0QC000000000000',
		'ALCR' => '',
		'MyAccountId' =>  accountCreation.id,
		'Lname' => 'testlname',
		'Fname' => 'testfname',
		'email ID' => 'test@email.com',
		'City' => 'Mumbai',
		'Street' => 'teststreet',
		'emailID' => 'JITSSO421@email1.com',
		'Phone' => '1236549870',
		'Country' => 'India',
		'State' => 'Maharashtra',
		'FederationIdentifier' => 'Afrdct6cfww',
		'Personal ID' => 'abcd',
		'nsnPrimaryAccountFlag' => 'true',
		'PersonalID' => '5647598625',
		'MobilePhone' => '7896541230',
		'PostalCode' => '000000',
		/*'CountryCode' => 'US',*/
		'HorizontalFlag' => '1',
		'HorizontalCustomerName' => 'TestName'
		};
			final String assertion = 'assertion';
			
			PRMCommunityJITHandler handler = new PRMCommunityJITHandler();
			handler.updateUser(user[0].id,samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);	  
		}
	}
	
	private static testmethod void futureupdateusertest1(){
		 List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
			ISO_Country_Codes__c iso = new ISO_Country_Codes__c();
			iso.Name = 'IN';
			iso.Market__c = 'Market India';
			iso.Country_Name__c = 'India';
			insert iso;
			Account accountCreation1 = TestDataFactory.createAccount(1)[0];
			accountCreation1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
			accountCreation1.AccountNumber = '1010101010';
			accountCreation1.Name = 'Test Account ' + Utils.generateRandomInteger(2)+Utils.generateRandomString(2);
			accountCreation1.BillingStreet = '1660 International Dr';
			accountCreation1.BillingCity = 'McLean';
			accountCreation1.BillingState = 'maharashtra';
			accountCreation1.BillingPostalCode = '22102';
			accountCreation1.BillingCountry = 'india';
			accountCreation1.AccountStatusInCRMOM__c = 'Active';
			accountCreation1.Industry='Enterprise';
			accountCreation1.Market__c='Market India';
			accountCreation1.Country__c='India';
			insert accountCreation1;
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.acc_no__c = '0QC000000000000';
			accountCreation.NCP_P20_ID__c = '0QC000000000000';
			accountCreation.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
			accountCreation.ParentId =accountCreation1.Id;
			insert accountCreation;
			String accId = accountCreation.id;
			accountCreation.AccountNumber = accId.substring(1, accId.length());
			update accountCreation;
			Contact con = new Contact();
			con.First_Name__c = 'test';
			con.Last_Name__c = 'test';
			con.LastName = 'test';
			con.Email = 'test@email1.com';
			con.AccountId = accountCreation.Id;
			insert con;
			List<User> user = TestDataFactory.userCreation(1,'Standard User');
			user[0].NCP_Relationship__c= 'Customer';
			user[0].ProfileId = System.Label.PRM_Partner_Profile_Id;
			user[0].contactID = con.id;
			user[0].isActive = false;	
			insert user[0]; 
			final Id samlSsoProviderId = '0LE000000000000';
			final Id communityId = null;
			final Id portalId = '0AB000000000000';
			final String federationIdentifier = 'federationIdentifier';
			Map<String, String> attributes = new Map<String, String> {
	  'ApprovalStatus' =>  'Approved',
		'Customer Name' => 'testname',
		'Relationship' => 'Partner',
		'P20' => '0QC000000000000',
		'ALCR' => '',
		'MyAccountId' =>  accountCreation.id,
		'Lname' => 'testlname',
		'Fname' => 'testfname',
		'email ID' => 'test@email.com',
		'City' => 'Mumbai',
		'Street' => 'teststreet',
		'emailID' => 'JITSSO764@email1.com',
		'Phone' => '1236549870',
		'Country' => 'India',
		'State' => 'Maharashtra',
		'FederationIdentifier' => 'Afrdct6cfww',
		'Personal ID' => 'abcd',
		'nsnPrimaryAccountFlag' => 'true',
		'PersonalID' => '5647598625',
		'MobilePhone' => '7896541230',
		'PostalCode' => '000000',
		'CountryCode' => 'IN',
		'HorizontalFlag' => '1',
		'HorizontalCustomerName' => 'TestName'
		};
			final String assertion = 'assertion';
			Test.startTest();
			//PRMCommunityJITHandler handler = new PRMCommunityJITHandler();
			//handler.updateUser(user[0].id,samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);	  
	PRMCommunityJITHandler.futureUpdateUser(user[0].id,attributes,federationIdentifier,accountCreation1.id,runAsUSer[0].id,'PRM Partner Community User Login');
	Test.stopTest();
		}
	}
	
	private static testmethod void futureupdateusertest2(){
		 List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
			ISO_Country_Codes__c iso = new ISO_Country_Codes__c();
			iso.Name = 'IN';
			iso.Market__c = 'Market India';
			iso.Country_Name__c = 'India';
			insert iso;
			Account accountCreation1 = TestDataFactory.createAccount(1)[0];
			accountCreation1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
			accountCreation1.AccountNumber = '1010101010';
			accountCreation1.Name = 'Test Account ' + Utils.generateRandomInteger(2)+Utils.generateRandomString(2);
			accountCreation1.BillingStreet = '1660 International Dr';
			accountCreation1.BillingCity = 'McLean';
			accountCreation1.BillingState = 'maharashtra';
			accountCreation1.BillingPostalCode = '22102';
			accountCreation1.BillingCountry = 'india';
			accountCreation1.AccountStatusInCRMOM__c = 'Active';
			accountCreation1.Industry='Enterprise';
			accountCreation1.Market__c='Market India';
			accountCreation1.Country__c='India';
			insert accountCreation1;
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.acc_no__c = '0QC000000000000';
			accountCreation.NCP_P20_ID__c = '0QC000000000000';
			accountCreation.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
			accountCreation.ParentId =accountCreation1.Id;
			insert accountCreation;
			String accId = accountCreation.id;
			accountCreation.AccountNumber = accId.substring(1, accId.length());
			update accountCreation;
			Contact con = new Contact();
			con.First_Name__c = 'test';
			con.Last_Name__c = 'test';
			con.LastName = 'test';
			con.Email = 'test@email1.com';
			con.AccountId = accountCreation.Id;
			insert con;
			List<User> user = TestDataFactory.userCreation(1,'Standard User');
			user[0].NCP_Relationship__c= 'Customer';
			user[0].ProfileId = System.Label.PRM_Partner_Profile_Id;
			user[0].contactID = con.id;
			user[0].isActive = false;	
			insert user[0]; 
			final Id samlSsoProviderId = '0LE000000000000';
			final Id communityId = null;
			final Id portalId = '0AB000000000000';
			final String federationIdentifier = 'federationIdentifier';
			Map<String, String> attributes = new Map<String, String> {
	  'ApprovalStatus' =>  'Approved',
		'Customer Name' => 'testname',
		'Relationship' => 'Customer',
		'P20' => '0QC000000000000',
		'ALCR' => '',
		'MyAccountId' =>  accountCreation.id,
		'Lname' => 'testlname',
		'Fname' => 'testfname',
		'email ID' => 'test@email.com',
		'City' => 'Mumbai',
		'Street' => 'teststreet',
		//'emailID' => 'JITSSO764@email1.com',
		'Phone' => '1236549870',
		'Country' => 'India',
		'State' => 'Maharashtra',
		'FederationIdentifier' => 'Afrdct6cfww',
		'Personal ID' => 'abcd',
		'nsnPrimaryAccountFlag' => 'true',
		'PersonalID' => '5647598625',
		'MobilePhone' => '7896541230',
		'PostalCode' => '000000',
		'CountryCode' => 'IN',
		'HorizontalFlag' => '0',
		'HorizontalCustomerName' => 'TestName',
		 'SSOPID' => 'ssopid'
		};
			final String assertion = 'assertion';
			Test.startTest();
			//PRMCommunityJITHandler handler = new PRMCommunityJITHandler();
			//handler.updateUser(user[0].id,samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);	  
	PRMCommunityJITHandler.futureUpdateUser(user[0].id,attributes,federationIdentifier,accountCreation1.id,runAsUSer[0].id, 'PRM Partner Community User Login');
	Test.stopTest();
		}
	}
	  
}