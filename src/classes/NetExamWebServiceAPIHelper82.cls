global class NetExamWebServiceAPIHelper82
{

    public class MissingAccountInformationException extends Exception{}
    public class NetExamWebserviceException extends Exception{}
    public with sharing class TestException extends Exception {}
    
      
    private static string ne_apiKey = System.Label.NetExam_API_Key;
    private static string ne_apiUser = System.Label.NetExam_API_Username; 
    private static string ne_apiPass = System.Label.NetExam_API_Password; 
    
    public static string contactSalesforceErrorMsg = 'Salesforce is unable to send the Contact details to NetExam. ';
    private static List<String> exceptionsContacts = new List<String>();
   
    @Future(callout=true)
   Public static void SendContactListToNetExam(Set<Id> contactIDList) 
   {
        try
        {
            webservicesNetexamComUserservice82.ArrayOfUserExtended Users = GetNetExamUsers(contactIDList);            
            
            if(Users != null)
            {
                BulkUpsertUsersWithUserGroups(Users);
            }            
            
        }
        catch(Exception e)
        {
            System.debug('SendContactListToNetExam Exception: ' + e);
        }
   } 
    
   public static webservicesNetexamComUserservice82.ArrayOfUserExtended GetNetExamUsers(Set<Id> contactIDList)
   {
      
         webservicesNetexamComUserservice82.ArrayOfUserExtended Users = new webservicesNetexamComUserservice82.ArrayOfUserExtended();
         Users.UserExtended =  new webservicesNetexamComUserservice82.UserExtended[]{}; 
         
         webservicesNetexamComUserservice82.UserExtended neUser = null;         
         
         try
         {
              for(String contactId: contactIDList)
              {
                  try
                  {           
                      neUser = CreateNetExamUser(contactId); 
                      
                      System.debug('FOUND CONTACT ID: ' + neUser.ExternalID);                                       
                       
                      if(neUser.ExternalID != '')
                      {
                          Users.UserExtended.Add(neUser);
                      }
                  }
                  catch(Exception innerEx)
                  {
                      //LOG AND MOVE ON TO NEXT CONTACT
                  }
        
               }
          }
          catch(Exception ex)
          {
              System.debug('GetNetExamUsers: ' + ex);
              throw ex;
          }
    
          return Users; 

    }

    public static webservicesNetexamComUserservice82.UserExtended CreateNetExamUser(string contactID)
    {
        string transactionResult = 'Contact Not sent: Invalid Contact ID';
        System.debug('called CreateNetExamUser');
        webservicesNetexamComUserservice82.UserExtended neUser = new webservicesNetexamComUserservice82.UserExtended();
        try
        {
            List<Contact>objContact =new List<Contact> ();
           
            if(String.isNotBlank(contactID))
            {
            
               objContact = [Select 
                                       ID,
                                       FirstName,
                                       LastName,
                                       Email,
                                       Phone,
                                       MailingStreet,
                                       MailingCity,
                                       MailingCountry,
                                       MailingState,
                                       MailingPostalCode,                                      
                                       Contact.Account.ID,
                                       Contact.Account.BillingStreet,
                                       Contact.Account.BillingCountry,
                                       Contact.Account.BillingCity,
                                       Contact.Account.BillingState,
                                       Contact.Account.BillingPostalCode,
                                       Contact.Account.Name      
                                       FROM Contact WHERE Id = :(contactID) LIMIT 1]; 
                                       
                if(objContact==null || objContact.size()==0)
                {
                     transactionResult = contactID + ': Contact Not sent. Invalid Contact ID';
                    exceptionsContacts.add(transactionResult);
                    return neUser;
                }
                
                  System.debug('objContact.size()='+objContact.size());  
                    
                if((String.isBlank(objContact[0].ID)) ||
                   (String.isBlank(objContact[0].Account.ID)) ||
                   (String.isBlank(objContact[0].FirstName)) ||
                   (String.isBlank(objContact[0].LastName)) ||
                   (String.isBlank(objContact[0].Email))
                ){
                    transactionResult = contactID + ': Contact Not Sent.Invalid Contact field values. Check Account, First Name, Last Name and Email';
                    exceptionsContacts.add(transactionResult);
                    return neUser;
                 }
                
               
            
                string sfdcContactID = objContact[0].ID;
                string firstName = objContact[0].FirstName;
                string lastName = objContact[0].LastName;
                string email = objContact[0].Email;                
                string accountID = objContact[0].Account.ID;
                string accountCountry = 'USA';
                string accountName = objContact[0].Account.Name;    
                //string accountStatus = objContact.Account.Account_Status__c; 
                            
                string language = 'English';
                string userType = 'Default';
                string userRole = 'Student'; 
                string managerSFDCContactID = '';
                string UsersCountry = 'USA';
                string UsersStatus = '';        
                string userName = '';  
                string businessPhone = '';  
                string UsersUserType = userType; 
                string userActive = '1';
                string errorMsg = '';          
                
                
                //Optional variables: Default to empty strings if not used
                string jobTitle = '';
                string ContactsTimeZone = '';
                string personalEmail = '';
                string address1 = '';
                string address2 = '';
                string city = '';
                string postalCode = '';
                string state = '';
                string jobCategory = '';
                DateTime UsersStartDate = NULL;
                string UsersUserRole = '';
                string SalesforceUserID = '';
                String sfdcUserId = '';
                String hireDate = '';
                string formattedStartDate = '';
                string userGroupMgrUserId = '';
                string userGroupMgrContactId = '';
                string userGroupMgrExternalId = '';
                string secondaryUserGroup = 'Invalid';
                string groupName = '';
                Boolean bSendToNetExam = true;
                Boolean bUserTypeDefined = false;
                
                
                //transactionResult = 'ACCOUNT STATUS: ' + accountStatus;
                //exceptionsContacts.add(transactionResult);
                //return neUser;
              
                
                if(!bSendToNetExam)
                {
                    transactionResult = contactID + ': Contact Not Sent. Please make sure the NetExam Access checkbox is checked';
                    exceptionsContacts.add(transactionResult);
                    return neUser;
                }
                            
                                    
                if(String.isNotBlank(userName))
                {
                  userName = email;
                }
            
                    
                //Check to make sure the required fields for the account object have the required information
                errorMsg = ValidateAccountData(accountName, accountID, accountCountry);        
                if(errorMsg != 'Success'){
                    transactionResult = contactID + ': Missing Account Information. Contact was not sent. ' + errorMsg;
                    exceptionsContacts.add(transactionResult);
                    return neUser;
                }
                        
                //Check to make sure the required fields for the account object have the required information
                errorMsg = ValidateContactData(sfdcContactID, firstName, lastName, email, language, userType, userRole, managerSFDCContactID);
                if(errorMsg != 'Success'){
                        
                    transactionResult = contactID + ': Missing Contact Data. Contact was not sent. ' + errorMsg;
                    exceptionsContacts.add(transactionResult);
                    return neUser;
                }                           
                
                //Get Business Phone
                try { businessPhone = ((String.isNotBlank(objContact[0].Phone)) ? objContact[0].Phone : '');} catch(Exception e){ businessPhone = '';}
                
                 //Get Street Address
                try { address1 = ((String.isNotBlank(objContact[0].MailingStreet)) ? objContact[0].MailingStreet : (String.isNotBlank(objContact[0].Account.BillingStreet)? objContact[0].Account.BillingStreet: ''));} catch(Exception e){ address1 = '';}
                        
                //Get City
                try { city = ((String.isNotBlank(objContact[0].MailingCity)) ? objContact[0].MailingCity : (String.isNotBlank(objContact[0].Account.BillingCity) ? objContact[0].Account.BillingCity : ''));} catch(Exception e){ city = '';}

                //Get the Country //check on null for account
                try { UsersCountry = ((String.isNotBlank(objContact[0].MailingCountry)) ? objContact[0].MailingCountry:(String.isNotBlank(objContact[0].Account.BillingCountry) ? objContact[0].Account.BillingCountry : 'USA')); } catch(Exception e){ UsersCountry = 'USA'; }
                
                //Get State 
                try { state = ((String.isNotBlank(objContact[0].MailingState)) ? objContact[0].MailingState : (String.isNotBlank(objContact[0].Account.BillingState) ? objContact[0].Account.BillingState : '')); } catch(Exception e){ state = ''; }

                //Get Postal Code
                try { postalCode = ((String.isNotBlank(objContact[0].MailingPostalCode)) ? objContact[0].MailingPostalCode : (String.isNotBlank(objContact[0].Account.BillingPostalCode) ? objContact[0].Account.BillingPostalCode : '')); } catch(Exception e){ postalCode = ''; }

                //Get the User Id for the user who is the Account owner
                try { userGroupMgrUserId = ((String.isNotBlank(objContact[0].Account.OwnerId)) ? objContact[0].Account.OwnerId : ''); } catch(Exception e){ userGroupMgrUserId = ''; }


                webservicesNetexamComUserservice82.AddressData address = new webservicesNetexamComUserservice82.AddressData();
                address.StreetAddress1 = address1;
                address.StreetAddress2 = '';
                address.City = city;
                address.State = state;
                address.PostalCode = postalCode;
                address.Country = UsersCountry; 

                                  
                      
               //Try to get the Contact Id if there is a Contact record associated with the User
               //NetExam prefares to use Contact Id as the External Id
               if(String.isNotBlank(userGroupMgrUserId))
               {
                   if(userGroupMgrUserId.length() > 0){ 
                      List<User> objUsrMgr = [Select ContactId FROM User WHERE Id = : userGroupMgrUserId LIMIT 1];        
                      try { userGroupMgrContactId = ((String.isEmpty(objUsrMgr[0].ContactId)) ? '': objUsrMgr[0].ContactId); } catch(Exception e){userGroupMgrContactId = '';}      
                   }
               } 
           
               //If Contact Id was found, use it otherwise just send the User Id.
               if(String.isNotBlank(userGroupMgrContactId))
               {
                   if(userGroupMgrContactId.length() > 0)
                       userGroupMgrExternalId = userGroupMgrContactId;
                   else
                       userGroupMgrExternalId = userGroupMgrUserId; 
               }     
              
            
                // Ensure that we have a valid country by setting a default
               if(String.isBlank(accountCountry))
               {
                  accountCountry = 'USA';
               }       
               
               if(String.isBlank(UsersCountry)) 
               {
                  UsersCountry = 'USA';
               }       

               // Ensure that we have a valid language by setting a default
               if(String.isBlank(language))
               {
                  language = 'English';
               } 
                        
            
               Boolean emailOptIn = true;
               Boolean preserveUserGroup = false;

                
               //Try and pull the User Id from the User record if it exists
               List<User> objUser = [Select Id FROM User WHERE ContactId = :sfdcContactID LIMIT 1]; 
               if(objUser != null)
               {       
                  try{
                        sfdcUserId = objUser[0].Id;
                     }
                     catch(Exception e){
                       //Do Nothing with this exception
                       System.debug('Error Finding User: ' + e);             
                     }
               }     

               webservicesNetexamComUserservice82.ArrayOfCustomField CustomFields = new webservicesNetexamComUserservice82.ArrayOfCustomField();
               CustomFields.CustomField=  new webservicesNetexamComUserservice82.CustomField[]{};
               
               
               // Create the array of user groups to send to NetExam. Only the PrimaryGroup is required.
               webservicesNetexamComUserservice82.ArrayOfUserUserGroup Groups = new webservicesNetexamComUserservice82.ArrayOfUserUserGroup();
               Groups.UserUserGroup =  new webservicesNetexamComUserservice82.UserUserGroup[]{};              
                
                
               // ADD ACCOUNT AS PRIMARY USER GROUP
               webservicesNetexamComUserservice82.UserUserGroup PrimaryGroup = new webservicesNetexamComUserservice82.UserUserGroup();
               PrimaryGroup.Name = accountName;
               PrimaryGroup.ExternalID = accountID;
               PrimaryGroup.IsPrimaryUserGroup = 1;
               PrimaryGroup.Country = accountCountry;
               PrimaryGroup.AccountManagerExternalID = userGroupMgrExternalId;   
                
               Groups.UserUserGroup.add(PrimaryGroup);           
               
                //NetExam User
                neUser.FirstName = firstName;
                neUser.LastName = lastName;
                neUser.UserName = userName;
                neUser.Email = email;
                neUser.BusinessPhone = businessPhone;
                neUser.PersonalEmail = personalEmail;
                neUser.address = address;
                neUser.TimeZone = ContactsTimeZone; 
                neUser.Language = language;
                neUser.UserGroups = Groups; 
                neUser.JobCategory = jobCategory; 
                neUser.JobTitle = jobTitle; 
                neUser.UserTypeName = userType; 
                neUser.ExternalID = sfdcContactID; 
                neUser.ExternalUserID = sfdcUserId;
                neUser.Status = userActive; 
                neUser.ManagerExternalID = managerSFDCContactID; 
                neUser.PreserveUserGroup = preserveUserGroup; 
                neUser.customFields = CustomFields;     
                neUser.UserRole = userRole;
                neUser.AlternateEmail = '';
                neUser.version = 0;   
                neUser.EmailOptIn= emailOptIn;      
                neUser.HireDate = DateTime.Now().format();
                neUser.RegistrationEmailType = 1;
                neUser.EmailCommunication = true;
                neUser.MessageWidgetCommunication = false;
            }
        }
        catch(Exception ex)
        {
           System.debug('CreateNetExamUser: ' + ex);              
           throw ex;
        } 
                       
        return neUser;

    }
   
 @Auraenabled
   Webservice static string SendContactToNetExam(string contactID)
    {
        string transactionResult = 'Contact Sent Successfully';
        
        
        System.debug('Send Contact TO NetExam 8.2.1 ...');
        
        
        webservicesNetexamComUserservice82.UserExtended neUser = CreateNetExamUser(contactId);
        
        if(String.isBlank(neUser.ExternalID))
        {
            if(exceptionsContacts.size() > 0)
            {
                transactionResult = exceptionsContacts.get(0);
                exceptionsContacts.clear();
            }
        
        }
        else
        {
                          
             // Send the Contact to NetExam
             Boolean bStatus = ((neUser.Status=='1')?true:false);                                                                                                                                                                                                                                                                                                                                                         
             string errorMsg = UpsertUserWithUserGroupsExtended(ne_apiKey, 
                                                               ne_apiUser, 
                                                               ne_apiPass,
                                                               neUser.FirstName, 
                                                               neUser.LastName, 
                                                               neUser.UserName,
                                                               neUser.UserRole, 
                                                               neUser.Email, 
                                                               neUser.BusinessPhone, 
                                                               neUser.PersonalEmail, 
                                                               neUser.address,                                                                
                                                               neUser.TimeZone,                                                               
                                                               neUser.Language,
                                                               neUser.UserGroups, 
                                                               neUser.JobCategory, 
                                                               neUser.JobTitle, 
                                                               neUser.UserTypeName, 
                                                               neUser.ExternalID, 
                                                               neUser.ExternalUserID,
                                                               bStatus, 
                                                               neUser.ManagerExternalID, 
                                                               neUser.PreserveUserGroup,
                                                             //  neUser.PreserveCustomFields, 
                                                               neUser.customFields, 
                                                               neUser.EmailOptIn,      
                                                               neUser.HireDate,
                                                               neUser.RegistrationEmailType,
                                                               neUser.EmailCommunication,
                                                               neUser.MessageWidgetCommunication);
               
                if(errorMsg != 'Success')
                {
                    transactionResult = 'Error Sending Data to NE web service. Contact was not sent. ' + errorMsg;
                }
                    
            }  
                    
                        
            return transactionResult;
    
    }

    public static void BulkUpsertUsersWithUserGroups(webservicesNetexamComUserservice82.ArrayOfUserExtended Users)
    {
       string ne_result = ''; 

       try{
           webservicesNetexamComUserservice82.UserServiceSoap ne_Webservice = new webservicesNetexamComUserservice82.UserServiceSoap();
           webservicesNetexamComUserservice82.ApiResult apiResult = ne_Webservice.BulkUpsertUsersWithUserGroups(ne_apiKey, ne_apiUser, ne_apiPass, Users);
           System.debug('Result: ' + apiResult.Code + ':' + apiResult.Description);
           ne_result = 'Success';

       }
       catch(System.CalloutException e){
            System.debug('Error: ' + e);            
            ne_result = e.getMessage().replace('Web service callout failed: WebService returned a SOAP Fault: ','').replace('faultcode=soap:Client faultactor=','');          
       }
    }
    
      
    //This method will create a user in NetExam OR if the user already exists(checked by sfdcContactID) the user's information will be updated.
    Public static string UpsertUserWithUserGroupsExtended(string apiKey, string apiUser, string apiPass, string firstName,string lastName, string userName, string userRole, string email, string businessPhone, string personalEmail, webservicesNetexamComUserservice82.AddressData address, string ContactsTimeZone, string language, webservicesNetexamComUserservice82.ArrayOfUserUserGroup Groups,string jobCategory, string jobTitle, string userType, string sfdcContactID, string sfdcUserId, Boolean status, string managerSFDCContactID, Boolean preserveUserGroup, webservicesNetexamComUserservice82.ArrayOfCustomField CustomFields, Boolean emailOptIn,string startDate,Integer RegistrationEmailType, Boolean EmailCommunication,Boolean MessageWidgetCommunication)
    {
        string ne_result = '';
       //INVOKE WEBSERVICE CALL TO ADD/UPDATE USER        
       
       try{
           webservicesNetexamComUserservice82.UserServiceSoap ne_Webservice = new webservicesNetexamComUserservice82.UserServiceSoap();
           webservicesNetexamComUserservice82.ApiResult Result = ne_Webservice.UpsertUserWithUserGroupsExtended(apiKey, apiUser, apiPass, firstName,lastName, userName, userRole, email, businessPhone, personalEmail, address, ContactsTimeZone, language, Groups, jobCategory, jobTitle, userType, sfdcContactID, sfdcUserId, status, managerSFDCContactID, preserveUserGroup, CustomFields, emailOptIn,startDate,RegistrationEmailType,EmailCommunication,MessageWidgetCommunication);
           System.debug('Result: ' + Result.Code + ':' + Result.Description);
           ne_result = 'Success';
        }
        catch(System.CalloutException e){
            System.debug('Error: ' + e);            
            ne_result = e.getMessage().replace('Web service callout failed: WebService returned a SOAP Fault: ','').replace('faultcode=soap:Client faultactor=','');          
        }
        
        return ne_result;  
        
    }  
   
    
    //This method simply checks to make sure that there is enough information to create the user group. 
    // If these values are missing, the webservice would return an error.
    // NOTE: Not all params are required, so not all params are checked.
    public static string ValidateAccountData(string accountName, string accountID, string accountCountry)
    {
        string errorMsg = '';
       
        if(String.isNotBlank(accountID))
        {
            if(accountID.length() == 0){
                errorMsg = errorMsg + '<br>Account ID';
            }
        }
        else{
            errorMsg = errorMsg + '<br>Account ID';
        }        
        
        if(String.isNotBlank(accountName))
        {     
            if(accountName.length() == 0){
                errorMsg  = errorMsg + '<br>Account Name';
            }
        }
        else{
            errorMsg  = errorMsg + '<br>Account Name';
        }
        
        if(errorMsg.length() > 0){
            errorMsg = 'Missing required information: ' + errorMsg;
        }
        else{
            errorMsg = 'Success';
        }

        return errorMsg;
    }
    
    //This method simply checks to make sure that there is enough information to create the user group. 
    // If these values are missing, the webservice would return an error.
    // NOTE: Not all params are required, so not all params are checked.
    public static string ValidateContactData(string sfdcContactID, string firstName, string lastName, string email, string language, string userType, string userRole, string managerSFDCContactID)
    {
        string errorMsg = '';       
        
        //check null for all variables 
        if(String.isNotBlank(firstName))
        {
            if(firstName.length() == 0){
                errorMsg  = errorMsg + '<br>First Name';
            }
        }
        else{
            errorMsg  = errorMsg + '<br>First Name';
        }
        
        if(String.isNotBlank(lastName))
        {
            if(lastName.length() == 0){
                errorMsg = errorMsg + '<br>Last Name';
            }
        }
        else{
            errorMsg = errorMsg + '<br>Last Name';
        }
        
        if(String.isNotBlank(lastName))
        {
            if(email.length() == 0){
                errorMsg = errorMsg + '<br>Email';
            }
        }
        else{
            errorMsg = errorMsg + '<br>Email';
        }
        
        if(errorMsg.length() > 0){
            errorMsg = 'Missing required information: ' + errorMsg;
        }
        else{
            errorMsg = 'Success';
        }

        return errorMsg;
    
    }
    Webservice static string SendAccountToNetExam(string accountID)
   {
        string transactionResult = 'Account Sent Successfully';
       System.debug('called CreateNetExamUserGroups');
        webservicesNetexamComUserservice82.UserUserGroup neUserGroup = CreateNetExamUserGroups(accountID);
       system.debug('neUserGroup');
       system.debug(neUserGroup);
       // Send the Account to NetExam
                                                                                                                                                                                                                                                                                                                                                                   
             string errorMsg = AddEditUserGroup(ne_apiKey, ne_apiUser,ne_apiPass,neUserGroup.Name,neUserGroup.ExternalID,neUserGroup.Country);
               
       if(errorMsg != 'Success'){transactionResult = 'Error Sending Data to NE web service. Contact was not sent. ' + errorMsg;  }
               
       
       
        return transactionResult;
    }
    public static webservicesNetexamComUserservice82.UserUserGroup CreateNetExamUserGroups(string accountID)
    {
        string transactionResult = 'Account Not sent: Invalid Account ID';
        System.debug('called CreateNetExamUserGroup');
        webservicesNetexamComUserservice82.UserUserGroup neUserGroup = new webservicesNetexamComUserservice82.UserUserGroup();
        try
        {
            List<Account>objAccount =new List<Account> ();
           
            if(String.isNotBlank(accountID))
            {
            
               objAccount = [Select 
                                       ID,
                                       Name,
                                       BillingCountry,
                                       ShippingCountry      
                                       FROM Account WHERE Id = :(accountID) LIMIT 1]; 
                                       
                if(objAccount==null || objAccount.size()==0)
                {
                    transactionResult = accountID + ': Contact Not sent. Invalid Contact ID';
                    exceptionsContacts.add(transactionResult);
                    return neUserGroup;
                }
                
                  System.debug('objAccount.size()='+objAccount.size());  
                    
                if((String.isBlank(objAccount[0].ID)))
                {
                    transactionResult = accountID + ': Contact Not Sent.Invalid Account field values. Check Account, Name';
                    exceptionsContacts.add(transactionResult);
                    return neUserGroup;
                }
            
                string sfdcAccountID = objAccount[0].ID;
                string accountName = objAccount[0].Name;
                string accountCountry = 'USA';
                
                Boolean bSendToNetExam = true;
                
               /* if(!bSendToNetExam)
                {
                    transactionResult = accountID + ': Account Not Sent. Please make sure the NetExam Access checkbox is checked';
                    exceptionsContacts.add(transactionResult);
                    return neUser;
                }*/

                //NetExam User group
                neUserGroup.Name = accountName;
                neUserGroup.ExternalID = sfdcAccountID;
                neUserGroup.Country = accountCountry;
                
                
                system.debug('--------------------------------------');
                system.debug(neUserGroup);
                
               
            }
        }
        catch(Exception ex)
        {
           System.debug('CreateNetExamUserGroup : ' + ex);              
           throw ex;
        } 
                       
        return neUserGroup;
    }
    
     //This method will create a user in NetExam OR if the user already exists(checked by sfdcContactID) the user's information will be updated.
    Public static string AddEditUserGroup(string apiKey, string apiUser, string apiPass, string name,string externalId, string country)
    {
        string ne_result = '';
       //INVOKE WEBSERVICE CALL TO ADD/UPDATE USER        
       system.debug(apiKey);
        system.debug(apiUser);
        system.debug(apiPass);
        system.debug(name);
        system.debug(externalId);
        system.debug(country);
       try{
           webservicesNetexamComUserservice82.UserServiceSoap ne_Webservice = new webservicesNetexamComUserservice82.UserServiceSoap();
          // webservicesNetexamComUserservice80.ApiResult
              string Result = ne_Webservice.AddEditUserGroup(apiKey, apiUser, apiPass,name,externalId,country);
//System.debug('Result: ' + Result.Code + ':' + Result.Description);
           ne_result = 'Success';
        }
        catch(System.CalloutException e){
            System.debug('Error: ' + e);            
            ne_result = e.getMessage().replace('Web service callout failed: WebService returned a SOAP Fault: ','').replace('faultcode=soap:Client faultactor=','');          
        }
        
        return ne_result;  
        
    } 
   

}