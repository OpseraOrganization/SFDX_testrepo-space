/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest(SeeAllData=true)
private class NetExamWebServiceAPIHelper82TestClass{

    public class MissingAccountInformationException extends Exception{}
    public class NetExamWebserviceException extends Exception{}
    
    //NetExam API Credentials    
    private static string ne_apiKey = 'APIKey';
    private static string ne_apiUser = 'APIUsername';
    private static string ne_apiPass = 'APIPassword';
    
    public static List<Account> lstAccs = new list<Account>();
    public static List<Contact> lstContacs = new list<Contact>();
    
    private static void createTestAccounts()
    {
        //0 Positive Test
        /* Account testAccount = new Account();
         testAccount.Name = 'NE PositiveTest';*/
          Account acct = new Account(name='Test Company Name1',
                                     BillingCountry = 'GB',
                                     BillingPostalCode = 'DM12',
                                     Industry = 'Others');
         lstAccs.add(acct);  
         Insert lstAccs;     
    }
    
       
    private static void createTestContacts() {
        
        //0 Positive Test
        Contact testContact = new Contact();
        testContact.FirstName = 'TestUser';
        testContact.LastName  = 'NEtester0';
        testContact.Email = 'tester@yourmail.com';
        testContact.AccountId  = lstAccs[0].ID;
        testContact.MailingStreet  = '0 Main Street';
        testContact.MailingCity = 'Beverly Hills';
        testContact.MailingState = 'CA';
        testContact.MailingPostalCode  = '90210';
        testContact.MailingCountry = 'US';       
                
        lstContacs.add(testContact); 
        Insert lstContacs;             
        
    }
    
   static testMethod void validateSendContactToNetExamExtended()
    {
        
        String result = '';
        string expectedResult = '';
        String testAccountID = '';
        String accountName = '';
        Account objAccount = null;  
        Contact objContact = null;      
    
               
        //Create the test Accounts    
        createTestAccounts();
        
      /*  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; //Standard User
        string label = 'MyTestUserAlias';
        string rand = String.valueOf(Math.rint(Math.random() * 10000));
        
        User u = new User(FirstName='testUser', Alias='testUser', Email='test@example.com',EmailEncodingKey='UTF-8', 
                          LastName=label, LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='unitTest' + rand + '@example.com');
         
                          
        System.runAs(u) {*/
            createTestContacts();
       // } 
         
                      
        //Positive Test 0
        //****************************************************************************************** 
        String contactID = lstContacs[0].ID;
        result = NetExamWebServiceAPIHelper82.SendContactToNetExam(contactID);
      //  System.assertEquals(result, NEConstants.CONTACT_SENT);
        //******************************************************************************************
       
        //Test Send Contact from Trigger method5
        //******************************************************************************************
        contactID = lstContacs[0].ID;
        Set<Id> contactIds = new Set<Id>();
        contactIds.add(contactID);           
        
        NetExamWebServiceAPIHelper82.SendContactListToNetExam(contactIds);
        System.assertEquals(contactID,lstContacs[0].ID);      
        //******************************************************************************************
        
    }
    
    static testmethod void validateSendAccountToNetExam()
    {
         createTestAccounts();
       string result = NetExamWebServiceAPIHelper82.SendAccountToNetExam(lstAccs[0].ID);       
       System.assertEquals(result,'Account Sent Successfully'); 
    }


    
    
 }