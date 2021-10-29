/******************************************************************************************

Name      :    PlannedMeetingRecurrenceController_Test
Purpose   :    Test class for PlannedMeetingRecurrenceController.
History   :
------------------------------------------------------------------------------------------- 
VERSION         AUTHOR                DATE             DETAIL 
1.0             NTT DATA            06/08/2017      Initial Development
*******************************************************************************************/

@isTest
public class PlannedMeetingRecurrenceController_Test
{
    static Planned_Meeting__c plannedMeeting;
    static User adminUser;
    static Id contactPlanRT ;
    static Account accObj;
    
    //Method to insert test data
    public static void insertTestData()
    { 
        contactPlanRT = Schema.SObjectType.Planned_Meeting__c.getRecordTypeInfosByName().get('Contact Plan').getRecordTypeId(); 
        
        List<Profile> profileList = [Select Id From Profile Where Name = 'System Administrator'];
            
        String userNo = '102';
        adminUser = new User();
        adminUser.FirstName = 'test';
        adminUser.LastName = 'user'+userNo;
        adminUser.Email = 'test'+userNo+'@test.domain.com';
        adminUser.Username = 'test'+userNo+'@test.domain.com';
        adminUser.ProfileId = profileList[0].Id;
        adminUser.Alias = 'test'+userNo;
        adminUser.CommunityNickname = 'testusr'+userNo;
        adminUser.TimeZoneSidKey = 'America/Los_Angeles';
        adminUser.LocaleSidKey = 'en_US';
        adminUser.EmailEncodingKey = 'UTF-8';
        adminUser.LanguageLocaleKey = 'en_US'; 
        adminUser.Phone = '+9009899900';
        adminUser.IsActive = true;
        insert adminUser ;
        
        System.runas(adminUser)
        {
            Country__c countryObj = new Country__c();
            countryObj.Name = 'India';
            countryObj.SFDC_Country_Name__c = 'India';
            insert countryObj ;
            
            accObj = new Account();
            accObj.Name = 'Test Account' ;
            accObj.Customer_Status__c = 'Active';
            accObj.Country__c = countryObj.Id;
            accObj.Service_Level__c = 'Superior';
            accObj.Strategic_Business_Unit__c = 'ATR';
            accObj.CBT__c = 'ATR Other';
            accObj.CBT_Team__c = 'HIPI ATR';
            accObj.Sales_Channel__c = 'Americas AM';
            accObj.SC1__c = 'HIPI';
            accObj.Market_Name__c = 'Air Transport';
            accObj.Type = 'Leasing Company';
            accObj.REPORT_ACCOUNT_NAME__c = 'NTT OFFSHORE TEST ACCOUNT1';
            insert accObj;
            
            plannedMeeting = new Planned_Meeting__c();
            plannedMeeting.recordtypeId = contactPlanRT;
            plannedMeeting.Assigned_To__c = adminUser.Id;
            plannedMeeting.Name = 'Test Record';
            plannedMeeting.Meeting_Purpose__c = 'Test';
            plannedMeeting.Account_Name__c = accObj.Id;
            plannedMeeting.Expected_Date__c= System.today()-3;
            plannedMeeting.Completed_Date__c = System.today()-1;
            plannedMeeting.SBU__c = 'C&PS';
            plannedMeeting.CBT_Team__c = 'Advanced Electronics';
            plannedMeeting.Sales_Channel__c = 'Aerospace';
            plannedMeeting.SC1__c = 'ACST';
            plannedMeeting.Location__c = 'Us';    
            insert plannedMeeting;
        }
    }
    
     //Method to check the yearly planned meeting records
    public static testMethod void plannedMeetingYearly_Test()
    {
        insertTestData();
        Test.startTest();  
            PageReference pageRef = page.PlannedMeetingRecurrence;
            pageRef.getParameters().put('id',plannedMeeting.Id);   
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController std = new ApexPages.StandardController(plannedMeeting);
                  
            PlannedMeetingRecurrenceController  planningController1 = new PlannedMeetingRecurrenceController(std);
            planningController1.Noc = 0;
            planningController1.endByDate = system.today().addyears(1);
            planningController1.Recurencetype = 'yearly';
            planningController1.plannedMeetingStartDate = system.today();
            planningController1.saveRecurrence(); 
        Test.stopTest();
    }
    
    public static testMethod void plannedMeetingYearly_Test1()
    {
        insertTestData();
        PageReference pageRef = page.PlannedMeetingRecurrence;
        Test.startTest();  
            pageRef.getParameters().put('id',plannedMeeting.Id);   
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController std = new ApexPages.StandardController(plannedMeeting);
            PlannedMeetingRecurrenceController planningController = new PlannedMeetingRecurrenceController(std);
            planningController.Noc =2;
            planningController.Recurencetype = 'yearly';
            planningController.plannedMeetingStartDate = System.today(); 
            planningController.saveRecurrence();
        Test.stopTest();
    }
   
    //Method to check the weekly planned meeting records
    public static testMethod void plannedMeetingWeekly_Test()
    {
        insertTestData();
        Test.startTest();  
            PageReference pageRef = page.PlannedMeetingRecurrence;
            pageRef.getParameters().put('id',plannedMeeting.Id);   
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController std = new ApexPages.StandardController(plannedMeeting);
            PlannedMeetingRecurrenceController planningController = new PlannedMeetingRecurrenceController(std);
            planningController.Noc =2;
            planningController.Recurencetype = 'weekly';
            planningController.plannedMeetingStartDate = System.today(); 
            planningController.saveRecurrence();
        
            PlannedMeetingRecurrenceController  planningController1 = new PlannedMeetingRecurrenceController(std);
            planningController1.Noc = 0;
            planningController1.endByDate = system.today().addyears(1);
            planningController1.Recurencetype = 'weekly';
            planningController1.plannedMeetingStartDate = system.today();
            planningController1.saveRecurrence(); 
        Test.stopTest();
    }
    
    //Method to check the monthly planned meeting records
    public static testMethod void plannedMeetingMonthly_Test()
    {
        insertTestData();
        Test.startTest();  
            PageReference pageRef = page.PlannedMeetingRecurrence;
                 
            pageRef.getParameters().put('id',plannedMeeting.Id);   
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController std = new ApexPages.StandardController(plannedMeeting);
            
            PlannedMeetingRecurrenceController planningController = new PlannedMeetingRecurrenceController(std);
            planningController.Noc =2;
            planningController.Recurencetype = 'Monthly';
            planningController.plannedMeetingStartDate = system.today(); 
            planningController.saveRecurrence();
            
            PlannedMeetingRecurrenceController planningController1 = new PlannedMeetingRecurrenceController (std);
            planningController1.Recurencetype = 'Monthly';
            planningController1.Noc = 0;
            planningController1.plannedMeetingStartDate = system.today();
            planningController1.endByDate = system.today().addmonths(1);
            planningController1.saveRecurrence();
        Test.stopTest();
    }
    
    //Method to check the quarterly planned meeting records
    public static testMethod void plannedMeetingQuarterly_Test()
    {
        insertTestData();
        Test.startTest();  
            PageReference pageRef = page.PlannedMeetingRecurrence;
                 
            pageRef.getParameters().put('id',plannedMeeting.Id);   
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController std = new ApexPages.StandardController(plannedMeeting);
            
            PlannedMeetingRecurrenceController planningController = new PlannedMeetingRecurrenceController(std);
            planningController.Noc =2;
            planningController.Recurencetype = 'Quarterly';
            planningController.plannedMeetingStartDate = system.today(); 
            planningController.saveRecurrence();
            
            PlannedMeetingRecurrenceController planningController1 = new PlannedMeetingRecurrenceController (std);
            planningController1.Noc = 0;
            planningController1.endByDate = system.today().addmonths(4);
            planningController1.Recurencetype = 'Quarterly';
            planningController1.plannedMeetingStartDate = system.today(); 
            planningController1.saveRecurrence();
            planningController1.cancel();   
        Test.stopTest();     
    }
    
    //Method to check the quarterly planned meeting records
    public static testMethod void plannedMeetingQuarterly_Test1()
    {
        insertTestData();
        Test.startTest();  
            Planned_Meeting__c plannedMeeting1 = new Planned_Meeting__c();
            plannedMeeting1.recordtypeId = contactPlanRT;
            plannedMeeting1.Assigned_To__c = adminUser.Id;
            plannedMeeting1.Name = 'Test Record 11';
            plannedMeeting.Meeting_Purpose__c = 'Test';
            plannedMeeting.Account_Name__c = accObj.Id;
            plannedMeeting1.Expected_Date__c= System.today().addMonths(1).toStartOfMonth().addDays(30);
            plannedMeeting1.Completed_Date__c = System.today().addMonths(1).toStartOfMonth().addDays(30);
            plannedMeeting1.SBU__c = 'C&PS';
            plannedMeeting1.CBT_Team__c = 'Advanced Electronics';
            plannedMeeting1.Sales_Channel__c = 'Aerospace';
            plannedMeeting1.SC1__c = 'ACST';
            plannedMeeting1.Location__c = 'Us';    
            insert plannedMeeting1;
                
            PageReference pageRef = page.PlannedMeetingRecurrence;           
            pageRef.getParameters().put('id',plannedMeeting1.Id);   
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController std = new ApexPages.StandardController(plannedMeeting1);     
             
            PlannedMeetingRecurrenceController planningController2 = new PlannedMeetingRecurrenceController (std);
            planningController2.Noc = 0;
            planningController2.endByDate = system.today().addmonths(4);
            planningController2.Recurencetype = 'Monthly';
            planningController2.plannedMeetingStartDate = system.today(); 
            planningController2.saveRecurrence();
            
            PlannedMeetingRecurrenceController planningController = new PlannedMeetingRecurrenceController (std);
            planningController.Noc = 0;
            planningController.endByDate = system.today().addmonths(4);
            planningController.Recurencetype = 'Quarterly';
            planningController.plannedMeetingStartDate = system.today();
            planningController.saveRecurrence();
            
            PlannedMeetingRecurrenceController planningControllerNew = new PlannedMeetingRecurrenceController (std);
            planningControllerNew.saveRecurrence();
            
            PlannedMeetingRecurrenceController planningControllerNew1 = new PlannedMeetingRecurrenceController (std);
            planningControllerNew1.plannedMeetingStartDate = system.today();
            planningControllerNew1.saveRecurrence();
            
            
            PlannedMeetingRecurrenceController planningControllerNew2 = new PlannedMeetingRecurrenceController (std);
            planningControllerNew2.plannedMeetingStartDate = system.today();
            planningControllerNew2.Noc = 0;
            planningControllerNew2.endByDate = system.today().addmonths(-4);
            planningControllerNew2.saveRecurrence();
        Test.stopTest();
    }
}