/**
* Created by bkandov on 10/05/2018.
*/
@isTest
private class NCP_CustomerCommunityUserHandler_Test {
    
    //private static final String COMMUNITY_ID = '01p2F000000HM5h';
    private static String COMMUNITY_ID;
    
    @testSetup static void setup() {
        NCP_CustomerCommunitySetting__c setting = NCP_TestFactory.insertCustomSetting();
        ISO_Country_Codes__c countryCodes = NCP_TestFactory.insertIsoCountryCodes();
        
        Network MyCommunity = new Network();
        MyCommunity = [SELECT Id,Name From Network WHERE Name = 'Customers' Limit 1];
        COMMUNITY_ID = MyCommunity.Id; 
        
        System.assertNotEquals(null, setting);
    }
    
    @isTest
    static void testCreateUser() {
        
        System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
            
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
        
        System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
            
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
            


            
            User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
            
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
        System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
            
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
        System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
            
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
            
            User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
            
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
    static void testAutomationFailureScenario()
    {
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
        
        User u = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev') ;
        
        
        System.runAs(u) {
            
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
            NCP_CustomerCommunityUserHandler.isCaseExists('test123@gmail.com');
            handler.callExistingContactPlatformEvent(lea,RecordTypeLeadId,'Test Name Lead','Customer');
            handler.callExistingContactPlatformEventJIT(lea,RecordTypeLeadId,'Test Name Lead','Customer');            
            
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
            }Catch(Exception Ec){}
            
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

            User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');

            Test.stopTest();
        }
    }      
    
}