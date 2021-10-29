/*****************************************
 * @Description : Unit test Class for the Sales Coach handler. 
 * ***************************************/ 
@isTest(seeAllData = false) 
public with Sharing class SalesCoachController_Test {
    
    /*****************************************
    * @Description : testmethod for getting org fical end end date. 
    * ***************************************/
    static testMethod void test_getFiscalEndDate(){
        
        SalesCoachController.getFiscalEndDate(); 
        SalesCoachController.getFiscalSummary(FALSE);
        SalesCoachController.getUserAccess(); 
    }
    
    /*****************************************
    * @Description : testmethod for configured list of field information. 
    * NOTE : List Metadatatype are deployable and hence they are not created in test class & 
    * and an existing metadata type is referenced. 
    * ***************************************/
    static testMethod void test_getConfiguredFields(){    
        SalesCoachController.getConfiguredFields('GROUP1_1_Health');    
    }
    static testMethod void test_getConfiguredFields1(){    
        SalesCoachController.getConfiguredFields('GROUP1_2_QUALITY');    
    }
    /***********************************************************
     * @Description : Test method to test configured pipeline review 
     * ********************************************************/
    static testMethod void test_getPipelineReviews(){    
        SalesCoachController.getPipelineReviews(FALSE); 
        SalesCoachController.getAdjustOpps(TRUE); 
        User salesUser = createSalesUser(); 
        if(salesUser.Id != null) {
            system.runAs(salesUser) {
                SalesCoachController.getPipelineReviews(FALSE); 
            }
        }
    }
    
    /***********************************************************
     * @Description : Test method to test configured pipeline review 
     * ********************************************************/
    static testMethod void test_getTableData(){ 
        SalesCoachController.getTableData('GROUP1_1_Health');     
    }
    static testMethod void test_getTableData1(){ 
        SalesCoachController.getTableData('GROUP1_2_QUALITY');     
    }
    static testMethod void test_getTableData2(){ 
        SalesCoachController.getTableData('GROUP1_3_WINS');     
    }
    static testMethod void test_getTableData3(){ 
        SalesCoachController.getTableData('GROUP1_4_LOADS');     
    }
    static testMethod void test_getTableData4(){ 
        SalesCoachController.getTableData('GROUP2_1_F2F_MEETINGS');     
    }
    static testMethod void test_getTableData5(){ 
        SalesCoachController.getTableData('GROUP2_2_VIRTUAL_MEETINGS');     
    }
    static testMethod void test_getTableData6(){ 
        SalesCoachController.getTableData('GROUP3_1_EXPIRED_CLOSE_DATE');     
    }
    /***********************************************************
     * @Description : Test method to test configured pipeline review 
     * ********************************************************/
    static testMethod void test_parseColumnFields(){ 
        Pipeline_Review__mdt db= new Pipeline_Review__mdt();
        db.Object_API_Name__c='Opportunity_Sales_Team__c';//Name, AccountNumber
        db.Fields_API_Name__c='Opportunity__r.Opportunity_Number__c,Opportunity__r.Name,Opportunity__r.Pipeline_Amount__c,Opportunity__r.TeamMemberLastName__c,Opportunity__r.CloseDate,Opportunity__r.StageName';
        SalesCoachController.parseColumnFields(db);     
    }
    /***********************************************************
     * @Description : Test method to test configured pipeline review 
     * ********************************************************/
    static testMethod void test_getCountValue(){ 
        SalesCoachController.getCountValue('GROUP1_1_Health');     
    }
    static testMethod void test_getCountValue1(){ 
        SalesCoachController.getCountValue('GROUP1_2_QUALITY');     
    }
    static testMethod void test_getCountValue2(){ 
        SalesCoachController.getCountValue('GROUP1_3_WINS');     
    }
    static testMethod void test_getCountValue3(){ 
        SalesCoachController.getCountValue('GROUP1_4_LOADS');     
    }
    static testMethod void test_getCountValue4(){ 
        SalesCoachController.getCountValue('GROUP2_1_F2F_MEETINGS');     
    }
    static testMethod void test_getCountValue5(){ 
        SalesCoachController.getCountValue('GROUP2_2_VIRTUAL_MEETINGS');     
    }
    static testMethod void test_getCountValue6(){ 
        SalesCoachController.getCountValue('GROUP3_1_EXPIRED_CLOSE_DATE');     
    }
    /***********************************************************
     * @Description : Test method to test configured pipeline review 
     * ********************************************************/
    static testMethod void test_updateSObjects(){ 
        List<Account> accList= new List<Account>();
        Account a = new Account();
        a.Name = 'test'+math.random();
        a.BillingStreet ='test';
        a.BillingCity='Hyderabad';
        a.BillingCountry='India';
        accList.add(a);
        Account b = new Account();
        b.Name = 'test'+math.random();
        b.BillingStreet ='test';
        b.BillingCity='Hyderabad';
        b.BillingCountry='India';
        accList.add(b); 
        insert accList;
        SalesCoachController.updateSObjects(accList);
    }
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
            newUser.Alias = 'salesA';
            newUser.TimeZoneSidKey = 'America/Los_Angeles';
            newUser.EmailEncodingKey = 'UTF-8';
            newUser.LanguageLocaleKey = 'en_US';
            newUser.LocaleSidKey = 'en_US';
            
            insert newUser;    
        }
        
        return newUser ; 
    } 
}