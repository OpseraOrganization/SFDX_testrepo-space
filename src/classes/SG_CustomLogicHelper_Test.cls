/**************************************************************
 * @Description : Test Class for unit test coverage. 
 * ***************************************************************/
@isTest(seeAllData = false)
public with Sharing class SG_CustomLogicHelper_Test {
     
    private static User newUser = null ; 
    
    /**************************************************************
    * @Description : Method to create test data
    * ***************************************************************/
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
            objAccount.BillingStreet ='test';
            objAccount.BillingCity='Hyderabad';
            objAccount.BillingCountry='India';
            database.insert(objAccount); 
            //insert account team member
            AccountTeamMember objTeamMember = new AccountTeamMember(); 
            objTeammember.UserId = newUser.Id ;
            objTeamMember.AccountId = objAccount.Id;
            objTeamMember.AccountAccessLevel = 'Read';
            objTeamMember.CaseAccessLevel = 'Read';
            objTeamMember.OpportunityAccessLevel = 'Read';
            objTeamMember.ContactAccessLevel = 'Read';
            objTeamMember.TeamMemberRole = 'Manager';
            
            database.insert(objTeamMember); 
            
            //insert opp
            Opportunity objOpp = new Opportunity(); 
            objOpp.Name = 'Test Opp';
            objOpp.RecordTypeId = [SELECT id FROM RecordType WHERE sObjectType = 'Opportunity'  LIMIT 1].Id;
            objOpp.AccountId = objAccount.Id ; 
            objOpp.CloseDate = System.today(); 
            //objOpp.ForecastCategoryName = 'Best Case' ; 
            objOpp.CurrencyIsoCode = 'USD';//use different currency for conversion testing
            objOpp.Amount = 20000; 
            objOpp.StageName = 'Cultivate';
            database.insert(objOpp) ; 
            
            
        }
        
    }
    
    /**************************************************************
    * @Description : testmetod for testing a sample review 
    * ***************************************************************/
    testmethod static void testAccountsWithOutContact(){
        createTestData(); 
        Pipeline_Review__mdt objMetadata = new Pipeline_Review__mdt(); 
        objMetadata.Apex_Unique_Identifier__c = 'ACCOUNT_WITHOUT_CONTACTS';
        objMetadata.Fields_API_Name__c = 'Name , AccountNumber';
        objMetadata.Limit__c = 2000 ; 
         
        System.runAs(newUser) {
            SG_CustomLogicHelper objhelper = new SG_CustomLogicHelper();
            System.debug('Account teams '+[SELECT id ,UserId , AccountId FROM AccountTeamMember WHERE UserId =:UserINfo.getUserId()]); 
            objhelper.executeRequest(objMetadata);     
        }
        objMetadata.Apex_Unique_Identifier__c = 'OPPS_WITHOUT_ROLES';
        objMetadata.Fields_API_Name__c = 'Name,StageName';
        System.runAs(newUser) {
            SG_CustomLogicHelper objhelper = new SG_CustomLogicHelper();
            objhelper.executeRequest(objMetadata);     
        }
    }
}