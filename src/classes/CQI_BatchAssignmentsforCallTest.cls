/*
 * @Description: Test Class for unit test code coverage for the batch assignments of calls for evaluation. 
 * */
@isTest(seeAllData = false)
public with Sharing class CQI_BatchAssignmentsforCallTest {
    
    /*
     * @Description: Test Setup method to create test data. 
     * Test Data includes: 2 user insertion for case owners, 2 case insertion
     */ 
    @testSetup
    public static void testDataSetup() {
        Profile objProfile = [SELECT Id FROM Profile WHERE Name = 'CSO (US)' LIMIT 1] ; 
        UserRole objRole = [SELECT Id FROM UserRole WHERE Name = 'CSO' LIMIT 1] ; 
        User user1 = insertUser('user1',objProfile.Id, objRole.Id , true ); 
        User user2 = insertUser('user2',objProfile.Id, objRole.Id , false );
        Account objAccount = new Account(); 
        Contact objContact = new Contact(); 
        Case objCase = new Case(); 
        List<Case> lstCase = new List<Case>(); 
        List<Task> lstTask = new List<Task>(); 
        /*
         *change context to avoid mixed DML operation
         */ 
        System.runAs(new User(Id = UserInfo.getUserId())) {
            objAccount = createAccount(); 
            objContact = createContact(objAccount.Id); 
            
            objCase = initCaseInstance(objAccount.Id, objContact.Id); 
            objCase.OwnerId = user1.Id ;
            lstCase.add(objCase); 
            
            objCase = initCaseInstance(objAccount.Id, objContact.Id); 
            objCase.OwnerId = user2.id ; 
            lstCase.add(objCase); 
            
            Database.insert(lstCase) ; 
            Test.startTest();
            Task newTask = initCallTask(lstCase[0].Id,'00000') ; 
            newTask.OwnerId = user1.id ; 
            lstTask.add(newTask); 
            
            newTask = initCallTask(lstCase[1].Id,'123456'); 
            newTask.OwnerId = user2.Id; 
            lstTask.add(newTask); 
            
            Database.insert(lstTask) ; 
            Test.stopTest() ; 
        }
    }
    
    /*
     * @Description: test method
     */ 
    testmethod static void testCaseAssignments() {
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1] ; 
        UserRole adminRole = [SELECT Id FROM UserRole WHERE Name = 'System Admin' LIMIT 1] ;
        User user1 = insertUser('adminUs1',adminProfile.Id, adminRole.Id , false ); 
        System.runAs(user1) {
            Test.startTest(); 
            CQI_BatchAssignmentsforCall obj = new CQI_BatchAssignmentsforCall();
            Database.executeBatch(obj);
            Test.stopTest();
            List<CQA_Summary__c> lstEvalSuggestions = [SELECT ID FROM CQA_Summary__c
                                                      WHERE RecordType.DeveloperName IN ('QA_Eval_Parent_Summary')]; 
            //after the batch execution, there must be Evaluation Suggestion record created.  
            System.assertNotEquals(0, lstEvalSuggestions.size()); 
        }
    }
    
    /*
     * @Description:  method to create account record
     */ 
    private static Account createAccount() {
        
        
        Account objAccount = new Account(); 
        objAccount.Name = 'Test Account';
        objAccount.Customer_Status__c = 'Active';
        objAccount.Strategic_Business_Unit__c = 'ATR';
        objAccount.CBT__c = 'Airbus';
        objAccount.Region_Name__c = 'Americas';
        objAccount.Sub_Region_Name__c = 'Canada';
        objAccount.Service_Level__c = 'Standard';
        objAccount.Type = 'OEM';
        objAccount.REPORT_ACCOUNT_NAME__c = 'Test Account';
        objAccount.Market_Name__c = 'Marine';
        objAccount.BillingStreet='Test';
        objAccount.BillingCity='test';
        objAccount.BillingState = 'Test'; 
        objAccount.BillingCountry='United States';
        objAccount.Site = 'Antwerp' ;  
        objAccount.BillingPostalCode = '54321'; 
        objAccount.Phone='123214231';
        
              
        insert objAccount;
        
        return objAccount ; 
    }
    
    /**
     * @Description: method to create a test contact
     */ 
    private static Contact createContact(Id accountId ) {
        Contact objContact = new Contact(); 
        objContact.LastName = 'Kulkarni';
        objContact.FirstName = 'Shrivaths';
        objContact.AccountId = accountId;
        objContact.Primary_Email_Address__c = 'shrivaths.kulkarni@nttdata.com';
        objContact.Email='shrivaths.kulkarni@nttdata.com';
        insert objContact;
        
        return objContact ;  
    }
    
    /*
     * Utility method to init a case instance
     */ 
    
    private static Case initCaseInstance(Id accountId, Id contactId) {
       Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('OEM Quotes Orders').getRecordTypeId();
        
        Case objCase = new Case(); 
        objCase.Subject = 'New Test Case';
        objCase.Status = 'closed';
        objCase.RecordTypeId =  RecordTypeIdCase ;
        objCase.Reason = 'Billing Inquire';
        objCase.Origin = 'Email'; 
        objCase.ContactId = contactId;
        objCase.Type_of_Change__c = 'New Account';
        objCase.Type = 'Other';
        objCase.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        objCase.Government_Compliance_SM_M_Content__c = 'NO';         
               
        
        return objCase ; 
    }
    
    
    /*
     * @Description: Utility method to insert users. 
     * Method has parameters for user name, profile id, role id
     * 
     */ 
    private static User insertUser(String userName, Id profileId, Id roleId, Boolean isAssignQAUser ) {
        
        User newUser = new User(); 
        
        newUser.FirstName = userName;
        newUser.lastName = userName;
        newUser.Alias = userName ; 
        newUser.Email = userName+'@test.com'; 
        newUser.Username = userName+Math.random()+'@test.com.test'; 
        newUser.Title = 'Cust Exp Specialist'; 
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.LocaleSidKey = 'en_US';
        newUser.UserRoleId = roleId ; 
        newUser.ProfileId = profileId ; 
        if(isAssignQAUser) {
            newUser.CQI_Coach_User__c = UserInfo.getUserId(); //assign current user as the coach.     
        }
        newUser.ManagerId = UserInfo.getUserId(); //assign current user as the Manager. 
        database.insert(newUser) ; 
        
        return newUser ; 
    }
    
    /*
     * Method to initialize a call task
     */ 
    private static Task initCallTask(Id caseId, String inContactId) {
        Task newTask = new Task() ; 
        
        newTask.Type = 'Call'; 
        newTask.Subject = 'Call Task'; 
        newTask.WhatId = caseId ; 
        newTask.Status = 'Completed'; 
        newTask.inContact_ContactId__c = inContactId;
        newTask.inContact_Call_Duration_in_Sec__c = '200'; 
        
        return newTask ; 
            
    }
}