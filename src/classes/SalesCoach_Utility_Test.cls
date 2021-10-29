/****************************************
* @Description : Test Class coverage for Sales Coach Utility Methods
* ***************************************/
@isTest(seeAllData = false)
public with Sharing class SalesCoach_Utility_Test {
    
    
    /*************************************************************
* @Description : 
* 
* ***********************************************************/
    static testMethod void getConfiguredRecords_test() {
        Test.StartTest();
        User objResult = new User(); 
        
        objResult.ProfileId = [SELECT Id FROM Profile WHERE Name = 'CRM Admin'].Id;
        
        objResult.LastName = 'last';
        objResult.Email = 'test@test.com';
        objResult.Username = 'test@test.com'+System.Math.random() ;
        objResult.CompanyName = 'TEST';
        objResult.Title = 'title';
        objResult.Alias = 'alias';
        objResult.TimeZoneSidKey = 'America/Los_Angeles';
        objResult.EmailEncodingKey = 'UTF-8';
        objResult.LanguageLocaleKey = 'en_US';
        objResult.LocaleSidKey = 'en_US';
        objResult.Region__c='test';
        
        // insert objResult;
        Test.StopTest();
    }
    static testMethod Boolean verifyConfig_test(){
        SalesCoach_Utility s= new SalesCoach_Utility();
        boolean res=s.verifyConfig('a', 'userValue');
        boolean res1=s.verifyConfig('', 'userValue');
        SalesCoachController.getPipelineReviews(FALSE); 
        User salesUser = createSalesUser(); 
        if(salesUser.Id != null) {
            system.runAs(salesUser) {
                SalesCoachController.getPipelineReviews(FALSE); 
            }
        }
        return res;
    }
    static testMethod void getAllRecords_test(){
        SalesCoach_Utility s= new SalesCoach_Utility();
        List<Pipeline_Review__mdt> res=s.getAllRecords(true);
        List<Pipeline_Review__mdt> rest=s.getConfiguredRecords(true);
    }
    static testMethod void isUserCanManageMetadata_test(){
        SalesCoach_Utility s= new SalesCoach_Utility();
        s.isUserCanManageMetadata();
    }
    static testMethod void getMyTeamUsers_test(){
        SalesCoach_Utility s= new SalesCoach_Utility();
        s.getMyTeamUsers();
    }
    
    /************************************************************************
* @Description : Method to create a Sales test user with Valid GBE Combination
* 
* *********************************************************************/
    private static User createSalesUser() {
        User newUser = new User(); 
        
        List<Profile> salesProfile =  [SELECT Id FROM Profile WHERE Name = 'Sales BGA' LIMIT 1]; 
        
        if(!salesProfile.isEmpty()) {
            newUser.ProfileId = salesProfile[0].Id;
            
            newUser.LastName = 'last';
            newUser.Email = 'test@test.com';
            newUser.Username = 'test@test.com'+System.Math.random() ;
            newUser.CompanyName = 'TEST';
            newUser.Title = 'title';
            newUser.Alias = 'salesB';
            newUser.TimeZoneSidKey = 'America/Los_Angeles';
            newUser.EmailEncodingKey = 'UTF-8';
            newUser.LanguageLocaleKey = 'en_US';
            newUser.LocaleSidKey = 'en_US';
            
            insert newUser;    
        }
        
        return newUser ; 
    }
    
    
}