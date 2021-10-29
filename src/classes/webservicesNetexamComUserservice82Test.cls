/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class webservicesNetexamComUserservice82Test{
    
    static webservicesNetexamComUserservice82 userService = new webservicesNetexamComUserservice82();
    
    //Instantiate the NetExam web service proxy
    static webservicesNetexamComUserservice82.UserServiceSoap ws = userService.GetUserServiceSoap();
    
    //Instantiate the Account API credentials. These will be supplied by NetExam
    static String APIKey= 'ApiKey';
    static String APIUsername='APIUsername';
    static String APIPassword='APIPassword';  
  
  static testMethod void TestAPIMethods(){
      
      UpsertUserWithUserGroupsExtendedTest();
      BulkUpsertUserWithUserGroupsTest();
      AddEditUserGroupTest();
  }
    
  private  static void UpsertUserWithUserGroupsExtendedTest(){
    
        //Create a test account    
       Account acct = new Account(name='Test Company Name1',BillingCountry = 'GB',BillingPostalCode = 'DM12',Industry = 'Others');
        insert acct;
        
        //Create a test contact
        Contact ct = new Contact(AccountId=acct.Id,lastname='Testing',firstname='Apex',email='testuser@myapexemail.com');
        insert ct; 
        
        String ExternalUserID=ct.Id;
        String FirstName=ct.firstname;
        String LastName=ct.lastname;
        String Email=ct.email;
        String Language='English';
        String UserType='Default';
        String UserRole='Student';
        String ManagersExternalID='';
        Boolean UserActive = True;
        String Country = 'USA'; 
        Boolean EmailOptIn = True;
        String SFDCUserID = '005367348382kdl';
        Boolean PreserveUserGroup = True;
    Boolean PreserveCustomFields = False;
        String TimeZone = '';
        String UserName = '';
        String BusinessPhone = '';
        String PersonalEmail='';
        String Address1 = '';
        String Address2 = '';
        String City = '';
        String State = '';
        String PostalCode = '';
        String JobCategory = '';
        String JobTitle = '';
        String StartDate = '';
    Integer RegistrationEmailType = 1;
    Boolean EmailCommunication = True;
    Boolean MessageWidgetCommunication = False;


     webservicesNetexamComUserservice82.AddressData address = new webservicesNetexamComUserservice82.AddressData();
         address.StreetAddress1 = Address1;
         address.StreetAddress2 = Address2;
         address.City = City;
         address.State = State;
         address.PostalCode = PostalCode;
         address.Country = Country;
    
        
        
        // Add account as primary user group
        webservicesNetexamComUserservice82.UserUserGroup PrimaryGroup = new webservicesNetexamComUserservice82.UserUserGroup();
        PrimaryGroup.Name = acct.name;
        PrimaryGroup.ExternalID = acct.Id;
        PrimaryGroup.IsPrimaryUserGroup = 1; 
        PrimaryGroup.Country = 'USA'; 
        PrimaryGroup.AccountManagerExternalID = '';       

        // Create the array of user groups to send to NetExam. Only the PrimaryGroup is required.
        webservicesNetexamComUserservice82.ArrayOfUserUserGroup Groups = new webservicesNetexamComUserservice82.ArrayOfUserUserGroup();         
        Groups.UserUserGroup =  new webservicesNetexamComUserservice82.UserUserGroup[]{PrimaryGroup};
        
        webservicesNetexamComUserservice82.ArrayOfCustomField CustomFields = new webservicesNetexamComUserservice82.ArrayOfCustomField();
        CustomFields.CustomField=  new webservicesNetexamComUserservice82.CustomField[]{};
         
        webservicesNetexamComUserservice82.ApiResult result; 

        result = ws.UpsertUserWithUserGroupsExtended(APIKey,APIUsername,APIPassword,FirstName,LastName,UserName,UserRole,Email,BusinessPhone,PersonalEmail,address,TimeZone,Language,Groups,JobCategory,JobTitle,UserType,ExternalUserID,SFDCUserId,UserActive,ManagersExternalID,PreserveUserGroup,customFields,EmailOptIn,StartDate, RegistrationEmailType, EmailCommunication, MessageWidgetCommunication);
        
        System.assert(result.Description == 'SUCCESS');
        delete ct;
        //delete acct;
        
    }
  
    private static void BulkUpsertUserWithUserGroupsTest() {    
    
         //Create test account 1   
         Account acct = new Account(name='Test Company Name2',BillingCountry = 'GB',BillingPostalCode = 'DM12',Industry = 'Others');
         insert acct;

         //Create test account 2
        Account acct2 = new Account(name='Test Company Name3',BillingCountry = 'GB',BillingPostalCode = 'DM12',Industry = 'Others');
         insert acct2;

         webservicesNetexamComUserservice82.ArrayOfUserUserGroup Groups = new webservicesNetexamComUserservice82.ArrayOfUserUserGroup();         
             
    
         //NE UserGroup 1 Instance
         webservicesNetexamComUserservice82.UserUserGroup Account1 = new webservicesNetexamComUserservice82.UserUserGroup();
         Account1.ExternalID = acct.Id;
         Account1.Name = acct.Name;
         Account1.Country = 'USA';
         Account1.IsPrimaryUserGroup = 1;

        //NE UserGroup 2 Instance
         webservicesNetexamComUserservice82.UserUserGroup Account2 = new webservicesNetexamComUserservice82.UserUserGroup();
         Account2.ExternalID = acct2.Id;
         Account2.Name = acct2.Name;
         Account2.Country = 'USA';
         Account2.IsPrimaryUserGroup = 0;
         
         Groups.UserUserGroup =  new webservicesNetexamComUserservice82.UserUserGroup[]{Account1,Account2};
         
         webservicesNetexamComUserservice82.CustomField region = new webservicesNetexamComUserservice82.CustomField();
         region.Name = 'Region';
         region.Value = 'North America';
         
         
         webservicesNetexamComUserservice82.ArrayOfCustomField customFields = new webservicesNetexamComUserservice82.ArrayOfCustomField();         
         customFields.CustomField=  new webservicesNetexamComUserservice82.CustomField[]{region};
         
        
          
         //Create a test contact
         Contact ct = new Contact(AccountId=acct.Id,lastname='Testing',firstname='Apex',email='testuser@myapexemail.com');
         insert ct;


          Integer version = 0;
          String Address1 = 'Stree Add 1';
          String Address2 = 'Street Add 2';
          String City = 'Brooklyn';
          String State = 'NY';
          String PostalCode = '11249';
          String Country = 'USA';
          String ExternalUserID = '';
          Boolean PreserveUserGroup = true;
          Boolean PreserveCustomFields = true;
          Boolean EmailOptIn = false;
          String HireDate = '05/31/2015';
          Integer RegistrationEmailType = 1;
          Boolean EmailCommunication =  true;
          Boolean MessageWidgetCommunication = false;

         webservicesNetexamComUserservice82.AddressData address = new webservicesNetexamComUserservice82.AddressData();
         address.StreetAddress1 = Address1;
         address.StreetAddress2 = Address2;
         address.City = City;
         address.State = State;
         address.PostalCode = PostalCode;
         address.Country = Country;


    
        //User 1
        webservicesNetexamComUserservice82.UserExtended user1 = new webservicesNetexamComUserservice82.UserExtended();
        user1.FirstName = ct.firstname;
        user1.LastName = ct.lastname;
        user1.UserName = ct.email;
        user1.Email = ct.email;
        user1.AlternateEmail = '';
        user1.Address = address;
        user1.Language = 'English';
        user1.BusinessPhone = '';
        user1.PersonalPhone = '';
        user1.PersonalEmail = '';
        user1.JobCategory = '';
        user1.JobTitle = '';
        user1.TimeZone = '9';
        user1.ExternalID =ct.Id;
        user1.UserRole = 'Student';
        user1.UserTypeName = 'Default';
        user1.ManagerExternalID = '';
        user1.Status = '1';
        user1.UserGroups = Groups;
        user1.version = version;
        user1.ExternalUserID = ExternalUserID;
        user1.PreserveUserGroup = PreserveUserGroup;       
        user1.customFields = customFields;
        user1.EmailOptIn = EmailOptIn;
        user1.HireDate = HireDate;
        user1.RegistrationEmailType = RegistrationEmailType;
        user1.EmailCommunication = EmailCommunication;
        user1.MessageWidgetCommunication = MessageWidgetCommunication;
    

  
    
        //Create a test contact
        Contact ct2 = new Contact(AccountId=acct.Id,lastname='Testing2',firstname='Apex2',email='testuser2@myapexemail.com');
        insert ct2;
    
        //User 2
        webservicesNetexamComUserservice82.UserExtended user2 = new webservicesNetexamComUserservice82.UserExtended();
        user2.FirstName = ct2.firstname;
        user2.LastName = ct2.lastname;
        user2.UserName = ct2.email;
        user2.Email = ct2.email;
        user2.AlternateEmail = '';
        user2.Address = address;
        user2.Language = 'French';
        user2.BusinessPhone = '';
        user2.PersonalPhone = '';
        user2.PersonalEmail = '';
        user2.JobCategory = '';
        user2.JobTitle = '';
        user2.TimeZone = '9';
        user2.ExternalID =ct2.Id;
        user2.UserRole = 'Student';
        user2.UserTypeName = 'Default';
        user2.ManagerExternalID = '';
        user2.Status = '1';
        user2.UserGroups = Groups;  
        user2.version = version;        
        user2.ExternalUserID = ExternalUserID;
        user2.PreserveUserGroup = PreserveUserGroup;        
        user2.customFields = customFields;
        user2.EmailOptIn = EmailOptIn;
        user2.HireDate = HireDate;
        user2.RegistrationEmailType = RegistrationEmailType;
        user2.EmailCommunication = EmailCommunication;
        user2.MessageWidgetCommunication = MessageWidgetCommunication;  
        
        // Create the array of User to send to NetExam.
        webservicesNetexamComUserservice82.ArrayOfUserExtended Users = new webservicesNetexamComUserservice82.ArrayOfUserExtended();         
        Users.UserExtended =  new webservicesNetexamComUserservice82.UserExtended[]{user1,user2};     
    
        webservicesNetexamComUserservice82.ApiResult apiResult = ws.BulkUpsertUsersWithUserGroups(APIKey,APIUsername,APIPassword,Users);
        
        System.assert(apiResult.Description == 'SUCCESS');
        
        delete ct;
        delete ct2;
       // delete acct;
       // delete acct2;
    
    
    }  
   
    private static void AddEditUserGroupTest()
    {
        String UserGroupName = 'test user group';
        String UserGroupExternalID = '1234568595';
        String Country = 'USA';
         string result = ws.AddEditUserGroup(APIKey,APIUsername,APIPassword,UserGroupName,UserGroupExternalID,Country);
         System.assert(result == 'SUCCESS');
    }
}