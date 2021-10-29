/*********************************************
 * @Description : Unit test class for the My Team view handler. 
 * *******************************************/
@isTest(seeAllData = false)  
public with Sharing class SG_MyTeamHandler_Test { 

    private static User newUser = null ; 
    
    /*********************************************
    * @Description : Method to create test data
    * *******************************************/
    static void createTestData() {
        //create a user with role
        newUser = new User(); 
        newUser.Firstname = 'test'; 
        newUser.lastName  = 'test'; 
        newUser.Username = 'test@test.com'+Math.random() ; 
        newUser.Email = 'test@test.com'; 
        newUser.ProfileId = [SELECT id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id; 
        newUser.UserRoleId = [SELECT id FROM UserRole where ParentRoleId = null LIMIT 1].Id ; 
        newUser.CurrencyIsoCode = 'USD' ; // locale currency ;
        newUser.Alias = String.valueOf(Math.random()).left(8);  
        newUser.TimeZoneSidKey = 'America/Los_Angeles'; 
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LanguageLocaleKey  = 'en_US';
        newUser.LocaleSidKey  = 'en_US';
        database.insert(newUser); 
       
        System.runAs(newUser) {
            //insert account
            Account objAccount = new Account(Name = 'Test Account'); 
            
            objAccount.BillingStreet='Test';
            objAccount.BillingCity='test';
            objAccount.BillingCountry='United States';
            objAccount.Phone='123214231453';
            objAccount.BillingLatitude=10;
            objAccount.BillingLongitude=10;
            
            database.insert(objAccount); 
            //insert opp
            Opportunity objOpp = new Opportunity(); 
            objOpp.Name = 'Test Opp';
            objOpp.RecordTypeId = [SELECT id FROM RecordType WHERE sObjectType = 'Opportunity' LIMIT 1].Id;
            objOpp.AccountId = objAccount.Id ; 
            objOpp.CloseDate = System.today(); 
           // objOpp.ForecastCategoryName = 'Committed' ; 
            objOpp.CurrencyIsoCode = 'USD';//use different currency for conversion testing
            objOpp.Amount = 20000; 
            objOpp.StageName = 'Closed Won';
            database.insert(objOpp) ;
        }
        
    }
    
    /*********************************************
    * @Description : Method to test my team view to retrieve opps amount. 
    * *******************************************/
    testmethod static void testMyTeamView() {
        createTestData(); //create test data
        System.runAs(newUser){ //run as test user.
            SG_MyTeamHandler.getCommittedOrders(true);   
        }        
    }
    
}