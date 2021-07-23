global class NCP_CustomerCommunityUserHandler implements Auth.SamlJitHandler {
  
  static final String NOT_AVAILABLE = 'Not Available';
  
  private class JitException extends Exception {
  }
  
  String gAccountId = '';
  
  String partner1 = Label.NCP_SSO_partner_1;
  String ssoContactEmail = Label.NCP_SSO_contact_email;
  String ssoContactStem = Label.NCP_SSO_contact_stem;
  String ssoProfile1 = Label.NCP_SSO_profile1;
  String ssoUserUpdate1 = Label.NCP_SSO_UserUpdate1;
  String ssoCaseSubject = Label.NCP_SSO_Acc_Case_Subject;
  String ssoCaseDescription = Label.NCP_SSO_Acc_Case_Description;
  
  private void handleUser(Boolean create, User u, String contactId, Map<String, String> attributes,
        String federationIdentifier, Boolean isStandard, String PrimaryAccount, String assertion) {
        
        String profileNameCustomer = NCP_CustomerCommunitySetting__c.getValues('Default').Customer_User_Profile__c;
        String profileNameCustomerLogin = NCP_CustomerCommunitySetting__c.getValues('Default').NCP_Customer_Login_Profile__c;
        String emailAddress;
        if (create) {
          Profile pCustomer;
          try {
          pCustomer = [SELECT Id FROM Profile WHERE name = :profileNameCustomer];
          } catch (Exception e) {
          String errMsg = ssoProfile1 + ' profileNameCustomer=' + profileNameCustomer + ', e=' + e;
          errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
          throw new JitException(errMsg);
          }
          u.ProfileId = pCustomer.Id;
        
          if (attributes.containsKey('emailID')) {
          emailAddress = attributes.get('emailID');
          String userName = NCP_Utils.getUsername(emailAddress);
          u.Email = emailAddress;
          if (PrimaryAccount == 'true') {
            u.Username = userName;
            u.NCP_CDB_Contact_ID__c = emailAddress;
          } else if (PrimaryAccount == 'false') {
            u.Username = userName + '.' + federationIdentifier;
            //u.NCP_CDB_Contact_ID__c = emailAddress + '.' + federationIdentifier;
          }
          }       
        
        
        }
        
        
        if (attributes.containsKey('FederationIdentifier')) {
          u.FederationIdentifier = attributes.get('FederationIdentifier');
        } else {
          u.FederationIdentifier = federationIdentifier;
        }
        
        if (PrimaryAccount == 'true' && attributes.containsKey('emailID')) {          
          u.NCP_CDB_Contact_ID__c = attributes.get('emailID');
        }          
       
        if (attributes.containsKey('PersonalID')) {
          u.NokiaUID__c = attributes.get('PersonalID');
        }
        if (attributes.containsKey('Lname')) {
          u.LastName = attributes.get('Lname');
        }
        if (attributes.containsKey('Fname')) {
          u.FirstName = attributes.get('Fname');
        }
        if (attributes.containsKey('MobilePhone')) {
          u.MobilePhone = attributes.get('MobilePhone');
        }
        if (create && !String.isBlank(contactId)) {
          u.ContactId = contactId;
        }
        if (attributes.containsKey('Relationship')) {
          u.NCP_Relationship__c = attributes.get('Relationship');
        }
        if (attributes.containsKey('Phone')) {
          u.Phone = attributes.get('Phone');
        }
        if (attributes.containsKey('SSOPID')) {
          u.NCP_SSOPID__c = attributes.get('SSOPID');
        }
        if (attributes.containsKey('Street')) {
          u.Street = attributes.get('Street');
        }
        if (attributes.containsKey('City')) {
          u.City = attributes.get('City');
        }
        if (attributes.containsKey('State')) {
          u.State = attributes.get('State');
          if (u.State == NOT_AVAILABLE){
          u.State = '';
          }
        }
        if (attributes.containsKey('PostalCode')) {
          u.PostalCode = attributes.get('PostalCode');
        }
        if (attributes.containsKey('CountryCode')) {
          u.CountryCode = attributes.get('CountryCode');
          try{
          u.Market__c = ISO_Country_Codes__c.getvalues(u.CountryCode).Market__c;
          u.Country__c = ISO_Country_Codes__c.getvalues(u.CountryCode).Country_Name__c;
          }catch(Exception e){
          String errMsg = 'User CountryCode is not correct! countryCode=' + u.CountryCode +' e=' + e;
          errMsg = getErrorMessage(errMsg, attributes, attributes.get('CountryCode'));
          throw new JitException(errMsg);
          }
          
        }
        if (attributes.containsKey('ApprovalStatus')) {
          u.NCP_Approval_Status__c = attributes.get('ApprovalStatus');
        }
        if (attributes.containsKey('NSNID') && PrimaryAccount == 'true') {
          u.NCP_NSN_ID__c = attributes.get('NSNID');
        }
        if (attributes.containsKey('HorizontalFlag')) {
          u.NCP_IsHorizontal__c = attributes.get('HorizontalFlag') == '1';
        }
        if (attributes.containsKey('HorizontalCustomerName')) {
          u.NCP_Horizontal_Company_Name__c = attributes.get('HorizontalCustomerName');
        }
        u.UserPermissionsSFContentUser = u.NCP_Relationship__c == 'Partner';
        
        List<Account> accounts = [Select name from account where id = :gAccountId LIMIT 1];
        
        Account companyAccount;
        if (accounts.isEmpty() == false) {
          companyAccount = accounts[0];
          String companyAccountName = companyAccount.Name;
          if(companyAccountName.length() > 80 ){
          u.CompanyName = companyAccountName.substring(0, 80);
          }else{
          u.CompanyName = companyAccountName;
          }
          
          //String companyNameAbbr = companyAccount.name.abbreviate(80);
          //u.CompanyName = companyNameAbbr;
        }
        
        // Added for Timezone attribute
        
          if (attributes.containsKey('nokiaTimeZone')) {
            String CSTimezoneValue;
            
            For(NCP_Timezone_Mapping__c namTZ: NCP_Timezone_Mapping__c.getAll().Values()){
              if(namTZ.NAM_Timezone__c == attributes.get('nokiaTimeZone'))
                CSTimezoneValue = namTZ.SF_TimeZone__c ;
            }
            //  string CSTimezoneValue = NCP_Timezone_Mapping__c.getvalues(attributes.get('nokiaTimeZone')).SF_Timezone__c;
            system.debug('CSTimezoneValue :'+CSTimezoneValue );
            system.debug('CSTimezoneValue get value:'+attributes.get('nokiaTimeZone'));
            if(CSTimezoneValue != NULL){
              u.TimeZoneSidKey =  CSTimezoneValue ;   
            }else{
              u.TimeZoneSidKey = 'GMT';
            }
          }  
        
        if (create) {
          u.Alias = u.LastName.left(4) + '1';
        //  u.TimeZoneSidKey = 'Europe/Amsterdam';
          u.LanguageLocaleKey = 'en_US';
          u.EmailEncodingKey = 'UTF-8';
          u.LocaleSidKey = 'en_GB';
        }
        
        if (!create) {
          system.debug('inside in this block');
          if (!Schema.sObjectType.Contact.isUpdateable()) {
          System.debug(LoggingLevel.Error, 'you don\'t have access to update User');
          } else {
          try {
            system.debug('inside in this block2');
            if (attributes.containsKey('FederationIdentifier')) {
              u.FederationIdentifier = attributes.get('FederationIdentifier');
            } 
            system.debug('inside in this block3:'+u);
            
            update(u);
          } catch (Exception e) {
            String errMsg = ssoUserUpdate1 + ' Email=' + u.Email + ',Username=' + u.Username + ',NokiaUID__c='
            + u.NokiaUID__c + ',FederationIdentifier=' + u.FederationIdentifier + ',Nokia_ID__c=' + u.Nokia_ID__c
            + ',NCP_SSOPID__c=' + u.NCP_SSOPID__c + ',u.NCP_IsHorizontal__c=' + u.NCP_IsHorizontal__c + ',NCP_Horizontal_Company_Name__c='
            + u.NCP_Horizontal_Company_Name__c + ', e=' + e;
            
            errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
            throw new JitException(errMsg);
          }
          }
        } else {
          if (!Schema.sObjectType.Contact.isCreateable()) {
          System.debug(LoggingLevel.Error, 'you don\'t have access to create User');
          } else {
          try {
            insert(u);
          } catch (Exception e) {
            if (e.getMessage().contains('LICENSE_LIMIT_EXCEEDED')) {
            Profile pCustomerLogin;
            try {
              pCustomerLogin = [SELECT Id FROM Profile WHERE name = :profileNameCustomerLogin];
            } catch (Exception e1) {
              String errMsg = 'User profile not identified! profileNameCustomerLogin=' + profileNameCustomerLogin + ', e=' + e1;
              errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
              throw new JitException(errMsg);
            }
            u.ProfileId = pCustomerLogin.Id;
            try {
              insert(u);
            } catch (Exception e2) {
              String errMsg = 'User can not be created! Email=' + u.Email + ',Username=' + u.Username + ',NokiaUID__c='
              + u.NokiaUID__c + ',FederationIdentifier=' + u.FederationIdentifier + ',Nokia_ID__c='
              + u.Nokia_ID__c + ',NCP_SSOPID__c=' + u.NCP_SSOPID__c + ',u.NCP_IsHorizontal__c=' + u.NCP_IsHorizontal__c
              + ',NCP_Horizontal_Company_Name__c=' + u.NCP_Horizontal_Company_Name__c + ', e=' + e2;
              
              errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
              throw new JitException(errMsg);
            }
            } else {
            String errMsg = 'User can not be created! Email=' + u.Email + ',Username=' + u.Username + ',NokiaUID__c='
              + u.NokiaUID__c + ',FederationIdentifier=' + u.FederationIdentifier + ',Nokia_ID__c=' + u.Nokia_ID__c
              + ',NCP_SSOPID__c=' + u.NCP_SSOPID__c + ',u.NCP_IsHorizontal__c=' + u.NCP_IsHorizontal__c
              + ',NCP_Horizontal_Company_Name__c=' + u.NCP_Horizontal_Company_Name__c + ', e=' + e;
            
            errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
            throw new JitException(errMsg);
            }
          }
          }
        }
        }
  
  private void handleInternalUser(Boolean create, User u, Map<String, String> attributes,
          String federationIdentifier, Boolean isStandard, String PrimaryAccount) {
          
          String profileNameInternalUser = NCP_CustomerCommunitySetting__c.getValues('Default').Internal_User_Profile__c;
          String thresholdLicense=NCP_CustomerCommunitySetting__c.getValues('Default').License_Threshold_Limit__c;
          String warningThreshold=NCP_CustomerCommunitySetting__c.getValues('Default').Warning_System_Threshold__c;
          List<User> SpInternalUserList=new List<User>();
          SpInternalUserList=[select id from User where Profile.Name=:profileNameInternalUser and isActive=true];
          List<Profile> profiles = [SELECT Id FROM Profile WHERE name = :profileNameInternalUser];
          String licensingGroupName=NCP_CustomerCommunitySetting__c.getValues('Default').License_Management_Group__c; 
          List<CollaborationGroup> licensingGroup =[select id from CollaborationGroup where Name=:licensingGroupName Limit 1];
          //Only while updating an inactive user or during creation of new user the below block will be executed
          if ((!create&&!u.isActive)||create){
            //If an inactive user does not belongs to below profile throw the error message
            if(!create&&u.Profile.Name !=profileNameInternalUser)
            {
            String errMsg = 'Error:  Your Salesforce account is currently deactivated and not eligible for auto-activation for Support portal access. Please contact IT Service Desk for assistance';
            errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
            throw new JitException(errMsg);
            }
            
            //if there is no user exists under this profile
            if(profiles.isEmpty())
            {
            return;  
            }
            Integer availableLicenseCount=Integer.ValueOf(thresholdLicense)- SpInternalUserList.Size();
            //if InternalUser count is greater or equal to threshold throw error message while creation or activation
            if(SpInternalUserList.Size()>=Integer.ValueOf(thresholdLicense))
            {  
            
            String errMsg = 'Error:  License Threshold has been exceeded.  Please open an IT ticket';
            errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
            throw new JitException(errMsg);
            
            }
            else if(SpInternalUserList.Size()<Integer.ValueOf(thresholdLicense)&& SpInternalUserList.Size()+1>=Integer.ValueOf(warningThreshold))
            {
            
            /*Boolean isReplyPerUser=NCP_CustomerCommunitySetting__c.getValues('Default').Licensing_Reply_Per_User__c;
Integer remainderForLicense=Math.mod(availableLicenseCount,50);
if((!isReplyPerUser && remainderForLicense==0) ||isReplyPerUser)
{
}*/
            
            postLicenseConsumptionMessageInChatter(availableLicenseCount-1,licensingGroup[0].id);
            
            
            }
            
            
            
          }   
          
          
          if(!create)
          {
            //If user exists and user profile is not DCP and the user is active then only update the internal flag
            
            if ( u.Profile.Name != profileNameInternalUser && u.isActive) {
            
            if (u.NCP_Is_Internal__c != True) {
              u.NCP_Is_Internal__c = True;
              update (u);
            }
            return;
            }
            if(!u.isActive)
            u.isActive=true;
          }
          
          if (create) {
            if (profiles.isEmpty()) {
            return;
            }
            
            u.ProfileId = profiles[0].Id;
            if (attributes.containsKey('FederationIdentifier')) {
            u.FederationIdentifier = attributes.get('FederationIdentifier');
            } else {
            u.FederationIdentifier = federationIdentifier;
            }
            System.debug(' in Create: u.FederationIdentifier: '+u.FederationIdentifier);
            u.Nokia_ID__c = u.FederationIdentifier;
            u.NCP_Is_Internal__c = True;
          }
          
          if (attributes.containsKey('emailID')) {
            String emailAddress = attributes.get('emailID');
            String userName = NCP_Utils.getUsername(emailAddress);
            U.Email = emailAddress;
            if (PrimaryAccount == 'true') {
            u.Username = userName;
            u.NCP_CDB_Contact_ID__c = emailAddress;
            } else if (PrimaryAccount == 'false') {
            u.Username = userName + '.' + federationIdentifier;
            //u.NCP_CDB_Contact_ID__c = emailAddress + '.' + federationIdentifier;
            }
          }
          
          if (attributes.containsKey('PersonalID')) {
            u.NokiaUID__c = attributes.get('PersonalID');
          }
          if (attributes.containsKey('Lname')) {
            u.LastName = attributes.get('Lname');
          }
          if (attributes.containsKey('Fname')) {
            u.FirstName = attributes.get('Fname');
          }
          if (attributes.containsKey('MobilePhone')) {
            u.MobilePhone = attributes.get('MobilePhone');
          }
          if (attributes.containsKey('Relationship')) {
            u.NCP_Relationship__c = attributes.get('Relationship');
          }
          System.debug(' Not in Create: u.FederationIdentifier: '+u.FederationIdentifier);
          u.Nokia_ID__c = u.FederationIdentifier;
          u.NCP_Is_Internal__c = true;
          
          if (attributes.containsKey('Phone')) {
            u.Phone = attributes.get('Phone');
          }
          if (attributes.containsKey('SSOPID')) {
            u.NCP_SSOPID__c = attributes.get('SSOPID');
          }
          if (attributes.containsKey('Street')) {
            u.Street = attributes.get('Street');
          }
          if (attributes.containsKey('City')) {
            u.City = attributes.get('City');
          }
          if (attributes.containsKey('State')) {
            u.State = attributes.get('State');
            if (u.State == NOT_AVAILABLE){
            u.State = '';
            }
          }
          if (attributes.containsKey('PostalCode')) {
            u.PostalCode = attributes.get('PostalCode');
          }
          if (attributes.containsKey('CountryCode')) {
            u.CountryCode = attributes.get('CountryCode');
            try{
            u.Market__c = ISO_Country_Codes__c.getvalues(u.CountryCode).Market__c;
            u.Country__c = ISO_Country_Codes__c.getvalues(u.CountryCode).Country_Name__c; 
            }catch(Exception e){
            String errMsg = 'User CountryCode is not correct! countryCode=' + u.CountryCode +' e=' + e;
            errMsg = getErrorMessage(errMsg, attributes, attributes.get('CountryCode'));
            throw new JitException(errMsg);
            }
            
          }
          if (attributes.containsKey('ApprovalStatus')) {
            u.NCP_Approval_Status__c = attributes.get('ApprovalStatus');
          }
          if (attributes.containsKey('NSNID') && PrimaryAccount == 'true') {
            u.NCP_NSN_ID__c = attributes.get('NSNID');
          }
          
          u.CompanyName = 'Nokia';
          
        // Added for Timezone attribute
        
        // Added for Timezone attribute
        
          if (attributes.containsKey('nokiaTimeZone')) {
            String CSTimezoneValue;
            
            For(NCP_Timezone_Mapping__c namTZ: NCP_Timezone_Mapping__c.getAll().Values()){
              if(namTZ.NAM_Timezone__c == attributes.get('nokiaTimeZone'))
                CSTimezoneValue = namTZ.SF_TimeZone__c ;
            }
            //  string CSTimezoneValue = NCP_Timezone_Mapping__c.getvalues(attributes.get('nokiaTimeZone')).SF_Timezone__c;
            system.debug('CSTimezoneValue :'+CSTimezoneValue );
            system.debug('CSTimezoneValue get value:'+attributes.get('nokiaTimeZone'));
            if(CSTimezoneValue != NULL){
              u.TimeZoneSidKey =  CSTimezoneValue ;   
            }else{
              u.TimeZoneSidKey = 'GMT';
            }
          }              
          
                    
          if (create) {
            u.Alias = u.LastName.left(4) + '1';
          //  u.TimeZoneSidKey = 'Europe/Amsterdam';
            u.LanguageLocaleKey = 'en_US';
            u.EmailEncodingKey = 'UTF-8';
            u.LocaleSidKey = 'en_GB';
          }
          
          if (!create) {
            if (!Schema.sObjectType.Contact.isUpdateable()) {
            System.debug(LoggingLevel.Error, 'you don\'t have access to update User');
            } else {
            update(u);
            }
          } else {
            if (!Schema.sObjectType.Contact.isCreateable()) {
            System.debug(LoggingLevel.Error, 'you don\'t have access to create User');
            } else {
            insert(u);
            }
          }
          
          }
  
  private void handleJit(Boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId,
         String federationIdentifier, Map<String, String> attributes, String assertion) {
          
          User user = u;
          Boolean c = create;
          
    /*        if (attributes.containsKey('username') && attributes.containsKey('EmailID')) {
            string uName =  attributes.containsKey('username');
            String emailAdd = attributes.containsKey('emailID');
            List<User> userList = [select ID,username,contactId, isActive, Profile.Name,ManagerId, NCP_Is_Internal__c, Street, City, State, PostalCode, CountryCode, FederationIdentifier from User where Username=:uName and emailId =:emailAdd];
            if(!userList.isEmpty()){
            c=false;
            user = userList[0];
            }           
          } */
          
         String relationship = attributes.get('Relationship');
         
         if (relationship == '' || relationship == null) {
           String errMsg = 'Relationship not identified! Relationship=' + relationship;
           errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
           throw new JitException(errMsg);
         }
         String PrimaryAccount = 'true';
         if (attributes.containsKey('nsnPrimaryAccountFlag')) {
           PrimaryAccount = attributes.get('nsnPrimaryAccountFlag');
         }
         
         if (relationship == 'Customer' || relationship == 'Supplier' || relationship == 'Sub Contractor' || relationship == 'Guest') {
           String contactId = '';
           String accountId = handleAccount(c, user, attributes, assertion, PrimaryAccount, federationIdentifier);
           Account acct;
           String parentAccountId;
           try {
           List<Account> accounts = [SELECT Id, parentId FROM Account WHERE id = :accountId];
           if (accounts.isEmpty() == false) {
             acct = accounts[0];
             parentAccountId = acct.parentId;
           }
           } catch (Exception e) {
           String errMsg = 'ParentAccount Id or Account Id not identified! accountId=' + accountId + ' parentAccountId=' + parentAccountId + ' relationship=' + relationship;
           
           errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
           throw new JitException(errMsg);
           }
           
           contactId = handleContact(c, accountId, parentAccountId, user, attributes, PrimaryAccount, federationIdentifier, assertion);
           if (contactId == '' || contactId == null) {
           String errMsg = 'Contact can not be identified! contactId=' + contactId + ',create=' + create + ',accountId='
             + accountId + ',parentAccountId' + parentAccountId + ',PrimaryAccount=' + PrimaryAccount
             + ',federationIdentifier=' + federationIdentifier;
           
           errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
           throw new JitException(errMsg);
           }
           system.debug('Inside Handle JIT block');
       /*    if (attributes.containsKey('username') && attributes.containsKey('EmailID')) {
            string uName =  attributes.containsKey('username');
            String emailAdd = attributes.containsKey('emailID');
            User userD = [select ID,username from User where Username=:uName and emailId =:emailAdd];
            handleUser(false, userD.ID, contactId, attributes, federationIdentifier, false, PrimaryAccount, assertion);
           }else{ 
            handleUser(create, u, contactId, attributes, federationIdentifier, false, PrimaryAccount, assertion);
           } */
           handleUser(create, u, contactId, attributes, federationIdentifier, false, PrimaryAccount, assertion);
         } else if (relationship == 'Internal') {
           handleInternalUser(create, u, attributes, federationIdentifier, false, PrimaryAccount);
         } else if (relationship == 'Partner') {
           //just login. No JIT at all
           if (create) {
           String errMsg = partner1 + ' ...Relationship=' + relationship + ',create=' + create;
           errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
           throw new JitException(errMsg);
           }
         } else {
           String errMsg = 'Relationship value not correct! Relationship=' + relationship;
           errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
           throw new JitException(errMsg);
         }
         }
  
  private String handleContact(Boolean create, String accountId, String parentAccountId, User u, Map<String, String> attributes,
         String PrimaryAccount, String federationIdentifier, String assertion) {
           
           List<Contact> contacts;
           String secondaryFirstName = '';
           String secondaryLastName = '';
           String secondaryPrefix = 'DUP';
           String email = '';
           Boolean createSSOAccountChangeCase = false;
           Boolean existSSOAccountChangeCase = false;
           if (attributes.containsKey('Fname')) {
           secondaryFirstName = attributes.get('Fname');
           }
           if (attributes.containsKey('Lname')) {
           secondaryLastName = attributes.get('Lname');
           }
           if (attributes.containsKey('emailID')) {
           email = attributes.get('emailID');
           if (PrimaryAccount == 'false') {
             email = secondaryFirstName + secondaryLastName + '@' + federationIdentifier + '.com';
           }
           contacts = [SELECT Id, lastName, firstName, Email, AccountId FROM Contact WHERE id = :u.ContactId OR email = :email LIMIT 1];
           } else {
           contacts = [SELECT Id, lastName, firstName, Email, AccountId FROM Contact WHERE id = :u.ContactId LIMIT 1];
           }
           Contact c;
           if (contacts.isEmpty()) {
           
           Integer maxSize = 80;
           String fullName = secondaryFirstName + ' ' + secondaryLastName;
           if (fullName.length() > maxSize) {
             fullName = fullName.substring(0, maxSize);
           }
           String p20Id;
           String alcrId;
           String AccountDetails;
           if (attributes.containsKey('P20')) {
             p20Id = attributes.get('P20');
           }
           if (attributes.containsKey('ALCR')) {
             alcrId = attributes.get('ALCR');
           }
           AccountDetails = 'Contact will be assigned to the parent Account of Legal Entity with numbers: P20 Id: '+p20Id+', ALCRID: '+alcrId;
           Boolean isDuplicateEmail = createCaseForDuplicateLeadContact(email,fullName, AccountDetails);
           if(isDuplicateEmail) {
             //throw an exception
             String errMsg = Label.NCP_DuplicateMailException;
             errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
             throw new JitException(errMsg);
           }else{
             c = new Contact();
           }
           
           } else {
           c = contacts[0];
           }
           
           if (create) {
           if (attributes.containsKey('emailID')) {
             if (PrimaryAccount == 'true') {
             c.email = attributes.get('emailID');
             } else if (PrimaryAccount == 'false') {
             c.email = secondaryFirstName + secondaryLastName + '@' + federationIdentifier + '.com';
             }
           }
           }
           /*
if (String.isNotBlank(accountId) && String.isNotBlank(parentAccountId)) {
if (c.accountId != parentAccountId) {
c.AccountId = parentAccountId;
}
}
*/
           if (attributes.containsKey('Fname')) {
           if (PrimaryAccount == 'false'){
             c.FirstName = secondaryPrefix + attributes.get('Fname');
           }else{
             c.FirstName = attributes.get('Fname'); 
           }
           //c.FirstName = attributes.get('Fname');
           
           }
           if (attributes.containsKey('Lname')) {
           if (PrimaryAccount == 'false'){
             c.LastName = secondaryPrefix + attributes.get('Lname');
           }else{
             c.LastName = attributes.get('Lname'); 
           }
           //c.LastName = attributes.get('Lname');
           }
           if (attributes.containsKey('MobilePhone')) {
           c.MobilePhone = attributes.get('MobilePhone');
           }
           if (attributes.containsKey('Street')) {
           c.MailingStreet = attributes.get('Street');
           }
           if (attributes.containsKey('City')) {
           c.MailingCity = attributes.get('City');
           }
           if (attributes.containsKey('State')) {
           c.MailingState = attributes.get('State');
           if (c.MailingState == NOT_AVAILABLE){
             c.MailingState = '';
           }
           }
           if (attributes.containsKey('PostalCode')) {
           c.MailingPostalCode = attributes.get('PostalCode');
           }
           if (attributes.containsKey('CountryCode')) {
           c.MailingCountryCode = attributes.get('CountryCode');
           try {
             c.Market__c = ISO_Country_Codes__c.getvalues(c.mailingCountryCode).Market__c;
           }
           catch(Exception e){
             String errMsg = 'Contact CountryCode is not correct! countryCode=' + c.MailingCountryCode +' e=' + e;
             errMsg = getErrorMessage(errMsg, attributes, attributes.get('CountryCode'));
             throw new JitException(errMsg);
           }
           
           }
           if (attributes.containsKey('Phone')) {
           c.Phone = attributes.get('Phone');
           }
           if (attributes.containsKey('SSOPID')) {
           c.NCP_External_Contact_Id__c = attributes.get('SSOPID');
           }
           
           String userRelationship = '';
           if (attributes.containsKey('Relationship')) {
           userRelationship = attributes.get('Relationship');
           }
           if (PrimaryAccount == 'false'){
           c.CH_ContactType__c = 'Secondary Account';
           c.NCP_Secondary_Account__c = true; 
           c.Sync_To_Marketo__c = false;  
           }
           else if (userRelationship == 'Supplier'){
           c.CH_ContactType__c = 'Supplier';
           } else if (userRelationship == 'Customer'){
           c.CH_ContactType__c = 'Customer';
           }
           
           
           if (contacts.isEmpty()) {
           System.debug('accountId= '+accountId+', parentAccountId= '+parentAccountId);
           if (String.isNotBlank(accountId) && String.isNotBlank(parentAccountId)) {
             c.AccountId = parentAccountId;
           }
           System.debug('c.AccountId: '+c.AccountId);
           if (!Schema.sObjectType.Contact.isCreateable()) {
             System.debug(LoggingLevel.Error, 'you don\'t have access to create Contact');
           } else {
             try {
             insert c;
             } catch (Exception e) {
             String errMsg = 'Contact can not be created! contactType=' + c.CH_ContactType__c + ' FirstName='
               + c.FirstName + ' LastName=' + c.LastName + ' MailingCountryCode=' + c.MailingCountryCode
               + ' ExternalContactId=' + c.NCP_External_Contact_Id__c + ' AccountId=' + c.AccountId + ' e=' + e;
             
             errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
             throw new JitException(errMsg);
             }
           }
           } else {
          //   if (String.isNotBlank(accountId) && String.isNotBlank(parentAccountId)) {
          //   c.AccountId = parentAccountId;
          //   }           
           if (!Schema.sObjectType.Contact.isUpdateable()) {
             System.debug(LoggingLevel.Error, 'you don\'t have access to update Contact ');
           } else {
             try {
             update c;
             } catch (Exception e) {
             String errMsg = 'Contact can not be updated! contactType=' + c.CH_ContactType__c + ' Id=' + c.id + ' FirstName=' + c.FirstName
               + ' LastName=' + c.LastName + ' MailingCountryCode=' + c.MailingCountryCode + ' ExternalContactId='
               + c.NCP_External_Contact_Id__c + ' AccountId=' + c.AccountId + ' e=' + e;
             
             errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
             throw new JitException(errMsg);
             }
           }
           }// 
           system.debug('contacts.isEmpty()= '+contacts.isEmpty());
           if (contacts.isEmpty()) { //only if it is new Contact record
           //create Account Contact Relationship record for legal entity
           if (String.isNotBlank(accountId)) {
             //delete not correct Account Contact Relation records(not proper accountid)
             List <AccountContactRelation> delACRList = [SELECT Id, contactId, accountId, NCP_Entitlement_Relationship__c from AccountContactRelation where contactId = :c.Id AND accountId != :accountId AND IsDirect != TRUE];
             if (delACRList.isEmpty() == false) {
             delete delACRList;
             }
             
             String userApprovalStatus = '';
             if (attributes.containsKey('ApprovalStatus')) {
             userApprovalStatus = attributes.get('ApprovalStatus');
             }
             //get correct accoutContactRelation record. If not exist , create new
             List<AccountContactRelation> correctEntitlementRelationshipACRList = [SELECT Id, contactId, accountId, NCP_Entitlement_Relationship__c from AccountContactRelation where contactId = :c.Id AND accountId = :accountId AND IsDirect != True];
             
             if (correctEntitlementRelationshipACRList.isEmpty()) {
             AccountContactRelation acr = new AccountContactRelation();
             acr.AccountId = accountId;
             acr.ContactId = c.Id;
             acr.NCP_Entitlement_Relationship__c = userApprovalStatus == 'Approved';
             
             insert acr;
             } else if (correctEntitlementRelationshipACRList.size() == 1) {
             
             correctEntitlementRelationshipACRList[0].NCP_Entitlement_Relationship__c = userApprovalStatus == 'Approved';
             update (correctEntitlementRelationshipACRList[0]);
             }
             
             gAccountId = accountId;
           }
           }else { // only if it is existing contact
           system.debug('contacts[0].AccountId: '+contacts[0].AccountId+', parentAccountId= '+parentAccountId);
           if(contacts[0].AccountId != parentAccountId){
             createSSOAccountChangeCase = true; //case should be created
           }
           //Get the list of LE ACRs
           List<AccountContactRelation> existingLEACRs = [SELECT Id, contactId, accountId, NCP_Entitlement_Relationship__c from AccountContactRelation where contactId = :contacts[0].Id AND NCP_Entitlement_Relationship__c = True];
           system.debug('existingLEACRs: '+existingLEACRs);
           if (existingLEACRs.isEmpty()) { //only if LE ACR does not exist
             String userApprovalStatus = '';
             if (attributes.containsKey('ApprovalStatus')) {
             userApprovalStatus = attributes.get('ApprovalStatus');
             }
             system.debug('userApprovalStatus: '+userApprovalStatus);
             if (userApprovalStatus == 'Approved'){
             AccountContactRelation acr = new AccountContactRelation();
             acr.AccountId = accountId;
             acr.ContactId = c.Id;
             acr.NCP_Entitlement_Relationship__c = True;
             
             insert acr;
             }
           } 
           for (AccountContactRelation existingLEACR : existingLEACRs){
             system.debug('existingLEACR.accountId: '+existingLEACR.accountId+', accountId= '+accountId);
             if (String.isNotBlank(existingLEACR.accountId) && String.isNotBlank(accountId)) {
             if(existingLEACR.accountId != accountId){
               createSSOAccountChangeCase = true; //case should be created
             }
             }else{
             createSSOAccountChangeCase = true; //case should be created
             }
           }
           existSSOAccountChangeCase = isCaseSSOAccountChangeExists(contacts[0].Id);
           system.debug('createSSOAccountChangeCase: '+createSSOAccountChangeCase+',existSSOAccountChangeCase: '+existSSOAccountChangeCase);
           if (createSSOAccountChangeCase && !existSSOAccountChangeCase){
             //get p20ID and ALCRId
             String p20Id;
             String alcrId;
             String AccountDetails;
             if (attributes.containsKey('P20')) {
             p20Id = attributes.get('P20');
             }
             if (attributes.containsKey('ALCR')) {
             alcrId = attributes.get('ALCR');
             }
             
             Case newCase = new Case();
             Id caseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('NCP SSO Account Change').getRecordTypeId();
             newCase.RecordTypeId =  caseRecTypeId;
             newCase.contactid = contacts[0].id;
             newCase.accountId = contacts[0].accountId;
             newCase.subject = 'Contact '+contacts[0].email+ssoCaseSubject;
             newCase.description = 'Contact '+contacts[0].email+ssoCaseDescription+' NAM P20ID= ('+p20Id+'). NAM ALCRID= ('+alcrId+').';
             newCase.Priority = 'Critical';
             newCase.Origin = 'Web';
             
             Database.DMLOptions dmo = new Database.DMLOptions();
             dmo.assignmentRuleHeader.useDefaultRule= true;
             dmo.EmailHeader.triggerAutoResponseEmail = true;
             dmo.EmailHeader.triggerUserEmail = true;
             dmo.EmailHeader.triggerOtherEmail = true;
             //dmo.assignmentRuleHeader.assignmentRuleId= '01Q41000000fp0CEAQ';
             newCase.setOptions(dmo);
             insert newCase;
             system.debug('Case SSOAccountChange created');
           }
           }
           
           gAccountId = accountId;
           return c.id;
         }
  
  private String handleAccount(Boolean create, User u, Map<String, String> attributes, String assertion, String PrimaryAccount, String federationIdentifier) {
  String accountId = '';
  String parentAccountId = '';
  String accountName = '';
  String accountNumber = '';
  String userApprovalStatus = '';
  String p20Id = '';
  String alcrId = '';
  
  if (attributes.containsKey('ApprovalStatus')) {
    userApprovalStatus = attributes.get('ApprovalStatus');
  }
  if (attributes.containsKey('CustomerName')) {
    accountName = attributes.get('CustomerName');
  }
  if (attributes.containsKey('P20')) {
    p20Id = attributes.get('P20');
  }
  if (attributes.containsKey('ALCR')) {
    alcrId = attributes.get('ALCR');
  }
  
  //check if Contact record exists 
  String email;
  List<Contact> contacts; 
  String secondaryFirstName = '';
  String secondaryLastName = '';   
  if (attributes.containsKey('Fname')) {
    secondaryFirstName = attributes.get('Fname');
  }
  if (attributes.containsKey('Lname')) {
    secondaryLastName = attributes.get('Lname');
  }  
  if (attributes.containsKey('emailID')) {
    email = attributes.get('emailID');
    if (PrimaryAccount == 'false') {
    email = secondaryFirstName + secondaryLastName + '@' + federationIdentifier + '.com';
    }
    contacts = [SELECT Id, lastName, firstName, Email, AccountId FROM Contact WHERE id = :u.ContactId OR email = :email LIMIT 1];
  } else {
    contacts = [SELECT Id, lastName, firstName, Email, AccountId FROM Contact WHERE id = :u.ContactId LIMIT 1];
  }
  
  
  
  Account acct;
  String errMsg = '';
  if (String.isNotBlank(alcrId)) {
    try {
    acct = [SELECT Id, parentId FROM Account where acc_no__c = :alcrId LIMIT 1];
    } catch (Exception e) {
    if(contacts.isEmpty()){
      errMsg = 'ParentAccount Id or Account Id not identified for user using AlcrID! userApprovalStatus=' + userApprovalStatus + ' alcrId=' + alcrId + ' attributes:' + attributes + ' e=' + e;
      errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
      throw new JitException(errMsg);
    }
    }
  } else if (String.isNotBlank(p20Id)) {
    try {
    acct = [SELECT Id, parentId FROM Account where NCP_P20_ID__c = :p20Id LIMIT 1];
    } catch (Exception e) {
    if(contacts.isEmpty()){
      errMsg = 'ParentAccount Id or Account Id not identified for user using P20ID ! userApprovalStatus=' + userApprovalStatus + ' p20Id=' + p20Id + ' attributes:' + attributes + ' e=' + e;
      errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
      throw new JitException(errMsg);
    }
    }
  } else if (userApprovalStatus != 'Approved') {
    accountName = NCP_CustomerCommunitySetting__c.getValues('Default').Customer_Account__c;
    accountNumber = NCP_CustomerCommunitySetting__c.getValues('Default').Customer_Account_Number__c;
    try {
    //get accountId and parentAccountId
    acct = [SELECT Id, parentId FROM Account WHERE accountNumber = :accountNumber AND name = :accountName LIMIT 1];
    system.debug('acct: '+acct);
    } catch (Exception e) {
    if(contacts.isEmpty()){
      errMsg = 'ParentAccount Id or Account Id not identified for non Approved User! userApprovalStatus=' + userApprovalStatus + ' accountName=' + accountName + ' accountNumber=' + accountNumber + ' attributes:' + attributes + ' e=' + e;
      errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
      throw new JitException(errMsg);
    }
    }
  }
  /*else if(userApprovalStatus == 'Approved'){
      try {
      //get accountId and parentAccountId
      acct = [SELECT Id, parentId FROM Account WHERE accountNumber = :alcrId AND NCP_P20_ID__c = :p20Id LIMIT 1];
      system.debug('acct: '+acct);
      } catch (Exception e) {
      if(contacts.isEmpty()){
        errMsg = 'ParentAccount Id or Account Id not identified for non Approved User! userApprovalStatus=' + userApprovalStatus + ' accountName=' + accountName + ' accountNumber=' + accountNumber + ' attributes:' + attributes + ' e=' + e;
        errMsg = getErrorMessage(errMsg, attributes, attributes.get('emailID'));
        throw new JitException(errMsg);
      }
      } 
  }*/
  if(acct != null){
    accountId = acct.Id;
    parentAccountId = acct.parentId;   
  }
  system.debug('accountId: '+accountId);
  return accountId;
  }
  
  @testVisible
  global User createUser(Id samlSsoProviderId, Id communityId, Id portalId,
         String federationIdentifier, Map<String, String> attributes, String assertion) {        

        String emailAdd = '';
        String uName1 = '';
        String userRelationship = '';
        User u = new User();
        
      try{      
                
        if (attributes.containsKey('Relationship')) {
         userRelationship = attributes.get('Relationship');
        }       
      
        if (attributes.containsKey('emailID')) {
          emailAdd = attributes.get('emailID');
        }
        
        if (attributes.containsKey('Username')) {
          uName1 = attributes.get('Username');
        }          
                  
        List<User> user = [SELECT Id, Email,Username, contactId, isActive, 
                  Profile.Name,ManagerId, NCP_Is_Internal__c, Street, City,State, postalCode, 
                  CountryCode, FederationIdentifier FROM User WHERE Email =: emailAdd and Username =: uName1 limit 1];                  
        if(user.size()>0)
        {
          
          Contact con = [select ID,Email from Contact where Id =: user[0].contactID];
          if((con.ID != NULL && con.Email == user[0].Email) || userRelationship=='Internal'){
            System.debug('Existing user record----'+user);
            System.debug('Existing Contact record----:'+con);   
            System.debug('inside123:');             
            u = user[0];
            String decodedAssertion = EncodingUtil.base64Decode(assertion).toString();
            handleJit(false, u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, decodedAssertion);              
          }
          //  return u;
        }else{
          
          system.debug('New user----');
          u = new User(); 
          String decodedAssertion = EncodingUtil.base64Decode(assertion).toString();
          handleJit(true, u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, decodedAssertion);
          //  return u;           
        }
        return u;
      }Catch(Exception E){                    
         
         system.debug('Catch exception E:'+E);
         return u; 
      }      
}
  
  global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
         String federationIdentifier, Map<String, String> attributes, String assertion) {
         
         List<User> users = [SELECT Id, contactId, isActive, Profile.Name,ManagerId, NCP_Is_Internal__c, Street, City, State, PostalCode, CountryCode, FederationIdentifier FROM User WHERE Id = :userId];
         if (users.isEmpty()) {
           return;
         }
         System.debug('inside update:');  
         User u = users[0];
         String decodedAssertion = EncodingUtil.base64Decode(assertion).toString();
         handleJit(false, u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, decodedAssertion);
         
         }
  
  private String getErrorMessage(String errorMessage, Map<String, String> attributes, String userName) {
  
  Map<String, Object> err = new Map<String, Object>{
    'UserName' => userName,
    'Attributes' => attributes,
    //'Assertion' => assertion,
    'ErrorMessage' => errorMessage
    };
      return JSON.serialize(err);
  }
  
  private Boolean createCaseForDuplicateLeadContact(String email,String fullName, String accountDetails){
  Boolean leadEmailExists = false;
  List<Lead> leadsList = [SELECT id, email,FirstName,LastName, status, recordType.name FROM lead WHERE email = :email AND RecordType.name IN ('Direct Sales', 'TXLE Lead') AND status != 'Closed - Converted (Qualified)'];
  
  if (leadsList.size()>0) {
    String leadEmail = leadsList[0].Email;
    //Add check if case exists
    if (!isCaseExists(leadEmail)) {
    Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SF Support').getRecordTypeId();
    callExistingContactPlatformEvent(leadsList[0],String.valueOf(recTypeId),fullName,accountDetails);
    }
    leadEmailExists = true;
  }
  return leadEmailExists;
  }
  
  static public Boolean isCaseExists(String leadEmail){
  Boolean caseExists = false;
  List<Case> caseList = [SELECT Id FROM Case WHERE
         RecordType.Name ='SF Support' AND Status='New' AND SuppliedEmail =:leadEmail];
  if(caseList.size()>0){
    caseExists = true;
  }
  return caseExists;
  }
  
  static public Boolean isCaseSSOAccountChangeExists(String contactId){
  Boolean caseExists = false;
  List<Case> caseList = [SELECT id FROM case WHERE recordtype.name = 'NCP SSO Account Change' AND contactId = :contactId AND status = 'New'];
  if(caseList.size()>0){
    caseExists = true;
  }
  return caseExists;
  }
  
  public void callExistingContactPlatformEvent(Lead singleLead,String recordTypeId,String fullName,String accountDetails){
  List<NCP_ExistingContact__e> existingContactEvent = new List<NCP_ExistingContact__e>();
  existingContactEvent.add(new NCP_ExistingContact__e(
    Lead_ID__c = singleLead.Id,
    Reported_User_ID__c = UserInfo.getUserId(),
    Lead_Email__c = singleLead.Email,
    Record_Type_ID__c = recordTypeId,
    Full_Name__c = fullName,
    Account_Details__c = accountDetails));
  List<Database.SaveResult> results = EventBus.publish(existingContactEvent);
  }
  
  
  public void callExistingContactPlatformEventJIT(Lead singleLead,String recordTypeId,String fullName,String accountDetails){
      
    List<NCP_ExistingContact__e> existingContactEvent = new List<NCP_ExistingContact__e>();
    existingContactEvent.add(new NCP_ExistingContact__e(
    Lead_ID__c = singleLead.Id,
    Reported_User_ID__c = UserInfo.getUserId(),
    Lead_Email__c = singleLead.Email,
    Record_Type_ID__c = recordTypeId,
    Full_Name__c = fullName,
    Account_Details__c = accountDetails));

    Boolean leadEmailExists = false;
    Boolean leadEmailExistsContact = false;
    Boolean leadEmailExistsAccount = false;
    Boolean leadEmailExistsUser = false;
    Boolean leadEmailExistsLead = false;
    Boolean leadEmailExistsLeads = false;
    
    List<Lead> leadsList = [SELECT id, email,FirstName,LastName, status, recordType.name FROM lead WHERE email = :singleLead.Email AND RecordType.name IN ('Direct Sales', 'TXLE Lead') AND status != 'Closed - Converted (Qualified)'];
    
    createCaseForDuplicateLeadContactJIT(singleLead.email,singleLead,recordTypeId,fullName,accountDetails);
  }  
  
  public void createCaseForDuplicateLeadContactJIT(String email,Lead singleLead,String recordTypeId,String fullName,String accountDetails){
      
    
    List<Lead> leadsList = [SELECT id, email,FirstName,LastName, status, recordType.name FROM lead WHERE email = :email AND RecordType.name IN ('Direct Sales', 'TXLE Lead') AND status != 'Closed - Converted (Qualified)'];
    
    Boolean leadEmailExistsLead = false;
    Boolean leadEmailExists = false;
    Boolean leadEmailExistsContact = false;
    Boolean leadEmailExistsAccount = false;
    Boolean leadEmailExistsUser = false;

    List<NCP_ExistingContact__e> existingContactEvent = new List<NCP_ExistingContact__e>();
    existingContactEvent.add(new NCP_ExistingContact__e(
    Lead_ID__c = singleLead.Id,
    Reported_User_ID__c = UserInfo.getUserId(),
    Lead_Email__c = singleLead.Email,
    Record_Type_ID__c = recordTypeId,
    Full_Name__c = fullName,
    Account_Details__c = accountDetails));

    createSupportTicketForDuplicateLeadContactJIT(singleLead.email,singleLead,recordTypeId,fullName,accountDetails);

  }  
  
  
  public void createSupportTicketForDuplicateLeadContactJIT(String email,Lead singleLead,String recordTypeId,String fullName,String accountDetails){
      
    
    List<Lead> leadsList = [SELECT id, email,FirstName,LastName, status, recordType.name FROM lead WHERE email = :email AND RecordType.name IN ('Direct Sales', 'TXLE Lead') AND status != 'Closed - Converted (Qualified)'];
    
    Boolean leadEmailExistsLead = false;
    Boolean leadEmailExists = false;
    Boolean leadEmailExistsContact = false;
    Boolean leadEmailExistsAccount = false;
    Boolean leadEmailExistsUser = false;

    List<NCP_ExistingContact__e> existingContactEvent = new List<NCP_ExistingContact__e>();
    existingContactEvent.add(new NCP_ExistingContact__e(
    Lead_ID__c = singleLead.Id,
    Reported_User_ID__c = UserInfo.getUserId(),
    Lead_Email__c = singleLead.Email,
    Record_Type_ID__c = recordTypeId,
    Full_Name__c = fullName,
    Account_Details__c = accountDetails));

    String partner1lbl = Label.NCP_SSO_partner_1;
    String ssoContactEmaillbl = Label.NCP_SSO_contact_email;
    String ssoContactStemlbl = Label.NCP_SSO_contact_stem;
    String ssoProfile1lbl = Label.NCP_SSO_profile1;
    String ssoUserUpdate1lbl = Label.NCP_SSO_UserUpdate1;
    String ssoCaseSubjectlbl = Label.NCP_SSO_Acc_Case_Subject;
    String ssoCaseDescriptionlbl = Label.NCP_SSO_Acc_Case_Description;

    createSupportTicketDuplicateLeadContactJIT(singleLead.email,singleLead,recordTypeId,fullName,accountDetails);

  }   
  
  
  public void createSupportTicketDuplicateLeadContactJIT(String email,Lead singleLead,String recordTypeId,String fullName,String accountDetails){
      
    
    List<Lead> leadsList = [SELECT id, email,FirstName,LastName, status, recordType.name FROM lead WHERE email = :email AND RecordType.name IN ('Direct Sales', 'TXLE Lead') AND status != 'Closed - Converted (Qualified)'];
    
    Boolean leadEmailExistsLead = false;
    Boolean leadEmailExists = false;
    Boolean leadEmailExistsContact = false;
    Boolean leadEmailExistsAccount = false;
    Boolean leadEmailExistsUser = false;

    List<NCP_ExistingContact__e> existingContactEvent = new List<NCP_ExistingContact__e>();
    existingContactEvent.add(new NCP_ExistingContact__e(
    Lead_ID__c = singleLead.Id,
    Reported_User_ID__c = UserInfo.getUserId(),
    Lead_Email__c = singleLead.Email,
    Record_Type_ID__c = recordTypeId,
    Full_Name__c = fullName,
    Account_Details__c = accountDetails));

    String partner1lbl = Label.NCP_SSO_partner_1;
    String ssoContactEmaillbl = Label.NCP_SSO_contact_email;
    String ssoContactStemlbl = Label.NCP_SSO_contact_stem;
    String ssoProfile1lbl = Label.NCP_SSO_profile1;
    String ssoUserUpdate1lbl = Label.NCP_SSO_UserUpdate1;
    String ssoCaseSubjectlbl = Label.NCP_SSO_Acc_Case_Subject;
    String ssoCaseDescriptionlbl = Label.NCP_SSO_Acc_Case_Description;

    SupportTicketDuplicateLeadContactJIT(singleLead.email,singleLead,recordTypeId,fullName,accountDetails);

  }   
  
  public void SupportTicketDuplicateLeadContactJIT(String email,Lead singleLead,String recordTypeId,String fullName,String accountDetails){
      
    
    List<Lead> leadsList = [SELECT id, email,FirstName,LastName, status, recordType.name FROM lead WHERE email = :email AND RecordType.name IN ('Direct Sales', 'TXLE Lead') AND status != 'Closed - Converted (Qualified)'];
    
    Boolean leadEmailExistsLead = false;
    Boolean leadEmailExists = false;
    Boolean leadEmailExistsContact = false;
    Boolean leadEmailExistsAccount = false;
    Boolean leadEmailExistsUser = false;

    List<NCP_ExistingContact__e> existingContactEvent = new List<NCP_ExistingContact__e>();
    existingContactEvent.add(new NCP_ExistingContact__e(
    Lead_ID__c = singleLead.Id,
    Reported_User_ID__c = UserInfo.getUserId(),
    Lead_Email__c = singleLead.Email,
    Record_Type_ID__c = recordTypeId,
    Full_Name__c = fullName,
    Account_Details__c = accountDetails));

    String partner1lbl = Label.NCP_SSO_partner_1;
    String ssoContactEmaillbl = Label.NCP_SSO_contact_email;
    String ssoContactStemlbl = Label.NCP_SSO_contact_stem;
    String ssoProfile1lbl = Label.NCP_SSO_profile1;
    String ssoUserUpdate1lbl = Label.NCP_SSO_UserUpdate1;
    String ssoCaseSubjectlbl = Label.NCP_SSO_Acc_Case_Subject;
    String ssoCaseDescriptionlbl = Label.NCP_SSO_Acc_Case_Description;

  }   
  
  
  public static void postLicenseConsumptionMessageInChatter(integer availableLicense,Id chattergroupId)
  {  
  if(chattergroupId!=null)
  {
    
    FeedItem feed = new FeedItem();
    feed.ParentId = chattergroupId;
    feed.Body ='Hi Members! ,Only '+availableLicense+' Reserved SP Licenses Are Remaining To Activate User';
    try{
    insert feed;
    }
    catch(Exception e)
    {
    
    }
  } 
  }
}