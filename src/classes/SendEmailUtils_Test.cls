@isTest
public class SendEmailUtils_Test {
    
    public static testMethod void doTest() {

        List<Id> casetoUpdate= new List<Id>();
        List<Case> casetoInsert= new List<Case>();
        List<Case> Updatecase = new List<Case>();
        Profile p1 = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User testUser = (User)SObjectFactory.create(User.sObjectType,new Map<Schema.SObjectField, Object>
            {
                User.FirstName => 'TestFirstName',
                User.LastName => 'TestLastName',
                User.Email => 'abcd@in.ibm.com',
                User.Username => 'abcd.123@in.ibm.com',
                User.Alias => 'TestF',
                User.ProfileId => p1.Id,
                User.TimeZoneSidKey => 'America/Denver',
                User.LocaleSidKey => 'en_US',
                User.EmailEncodingKey => 'UTF-8',
                User.LanguageLocaleKey => 'en_US'
            });
          user currentUser = (User) SObjectFactory.create(
          User.SObjectType,
            new Map<SObjectField, Object>{
            User.Alias => 'wvarg',
            User.Email => 'abcd@example.com',
            User.EmailEncodingKey => 'UTF-8',
            User.LastName => 'Customer Master',
            User.FirstName=>'Salesforce',    
            User.LanguageLocaleKey => 'en_US',
            User.LocalesIdKey => 'en_US',
            User.ProfileId => UserInfo.getProfileId(),
            User.TimezonesIdKey => 'America/Los_Angeles',
            //User.Username => 'wilnellies.vargas@honeywell.com'
            User.Username => 'testtest.123@honeywell.com'
            }
           );     
        
        Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.OwnerId = [Select Id from User where Name = 'API User SFDC Cust Master'].Id;
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airlines';
        acc.CBT_Team__c = 'Americas';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.Optout_P2C_Notification__c = false;
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        try {
        insert acc;
        }catch(Exception ex){}
        
        Contact con = new Contact();
        con.Phone_1__c='231231231';
        con.Honeywell_ID__c='E012345';
        con.Address_Line_1__c='Testtsstts';
        con.Address_Line_2__c='Testtsstts';
        con.Address_Line_3__c='Testtsstts';
        con.City_Name__c='Testtsstts';
        con.State_Code__c='Testtsstts';
        con.Country_Name__c='Testtsstts';
        con.FirstName = 'KapilM';
        con.LastName = 'Singh';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'abcd@gmail.com';
        con.Email='abcd@gmail.com';
        try {
        insert con;
        }catch(Exception ex){}
        
        Platform__c pl = new Platform__c(name='test pt' );
        insert pl;
        
        Test.StartTest();
        case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
        Case.OwnerId => UserInfo.getUserId(),
        Case.Type => 'CPS BGA Process', 
        Case.Subject => 'Test',
        Case.Status=>'Open',
        Case.Sub_Status__c => 'Accts',
        Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Technical Issue','Case').Id,
        Case.SuppliedEmail => 'Test@gulfstream.com',
        Case.Origin => 'Email',
        Case.AccountId=> acc.Id,
        Case.ContactId=> con.Id,
        Case.NSN__c => 'Test;NSN', 
        Case.Part_Number__c => 'Test;Part',
        Case.AOG__c=> False,
        Case.Classification__c=> 'GTO', 
        Case.Sub_Class__c=> 'Electrical',
        Case.SBU_w2c__c =>  'ATR',
        Case.Case_Priority__c => 'Priority 4 – Complex: 1 week to 30 days',
        Case.Customer_Update_Frequency__c => 'Every 7 days',
        Case.Communication_Channel__c => 'Text',
        Case.Aircraft_Type__c => pl.id,
        Case.Comments__c=>'test'
        });
        //Insert Cas1;
        casetoInsert.add(Cas1);
        
       // Cas1.Status = 'propose to Close';
        //Update Cas1;
        //casetoUpdate.add(Cas1.Id);
        //SendEmailUtils.SendEmail(Cas1.Id);
        
        case Cas2 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
            Case.Type => 'CPS BGA Process', 
            Case.Subject => 'Raf',
            Case.Status=>'Open',
            Case.Sub_Status__c => 'Accts',
            Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('AOG','Case').Id,
            Case.Origin => 'Email',
            Case.AccountId=> acc.Id,
            Case.ContactId=> con.Id,
            Case.NSN__c => 'Test;NSN', 
            Case.Part_Number__c => 'Test;Part',
            Case.AOG__c=> False,
            Case.Classification__c=> 'GTO', 
            Case.Sub_Class__c=> 'Electrical',
            Case.SBU_w2c__c =>  'ATR',
            Case.Aircraft_Type__c => pl.id,
            Case.Comments__c=>'test',
            Case.Export_Compliance_Content_ITAR_EAR__c=> 'No', 
            Case.Government_Compliance_SM_M_Content__c=>'No'
        });        
        //insert Cas2;   
        casetoInsert.add(Cas2);
        insert casetoInsert;
        Cas1.Status = 'propose to Close';
        Updatecase.add(Cas1);
        //Update Cas1;
        //casetoUpdate.add(Cas1.Id)
        Cas2.Status = 'propose to Close';
        Updatecase.add(Cas2);
        Test.stopTest();
        Update Updatecase;
        
        casetoUpdate.add(Cas2.Id);
        
        case Cas4 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
            Case.Type => 'Order Status', 
            Case.Type_of_Request__c => 'SPEX Request', 
            Case.Subject => 'Test Subject',
            Case.Status=>'Open',
            Case.Sub_Class__c => 'SPEX/Exchange',
            Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Orders','Case').Id,
            Case.Origin => 'Email',
            Case.AccountId=> acc.Id,
            Case.ContactId=> con.Id,
            Case.Aircraft_Type__c => pl.id,
            Case.Comments__c=>'test',
            Case.Export_Compliance_Content_ITAR_EAR__c=> 'No', 
            Case.Government_Compliance_SM_M_Content__c=>'No'
        });        
        insert Cas4;     
        Cas4.Status = 'propose to Close';
        
        Update Cas4;
        
        casetoUpdate.add(Cas4.Id);
        
        SendEmailUtils.SendEmail(casetoUpdate);
        
    }
    
    public static testMethod void doTest2() {
         List<Id> casetoUpdate= new List<Id>();
        Profile p1 = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User testUser = (User)SObjectFactory.create(User.sObjectType,new Map<Schema.SObjectField, Object>
            {
                User.FirstName => 'TestFirstName',
                User.LastName => 'TestLastName',
                User.Email => 'abcd@in.ibm.com',
                User.Username => 'abcd.123@in.ibm.com',
                User.Alias => 'TestF',
                User.ProfileId => p1.Id,
                User.TimeZoneSidKey => 'America/Denver',
                User.LocaleSidKey => 'en_US',
                User.EmailEncodingKey => 'UTF-8',
                User.LanguageLocaleKey => 'en_US'
            });
          user currentUser = (User) SObjectFactory.create(
          User.SObjectType,
            new Map<SObjectField, Object>{
            User.Alias => 'wvarg',
            User.Email => 'abcd@example.com',
            User.EmailEncodingKey => 'UTF-8',
            User.LastName => 'Customer Master',
            User.FirstName=>'Salesforce',    
            User.LanguageLocaleKey => 'en_US',
            User.LocalesIdKey => 'en_US',
            User.ProfileId => UserInfo.getProfileId(),
            User.TimezonesIdKey => 'America/Los_Angeles',
            //User.Username => 'wilnellies.vargas@honeywell.com'
            User.Username => 'testtest.123@honeywell.com'
            }
           );     
        
        Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.OwnerId = [Select Id from User where Name = 'API User SFDC Cust Master'].Id;
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airlines';
        acc.CBT_Team__c = 'Americas';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.Optout_P2C_Notification__c = false;
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        try {
        insert acc;
        }catch(Exception ex){}
        
        Contact con = new Contact();
        con.Phone_1__c='231231231';
        con.Honeywell_ID__c='E012345';
        con.Address_Line_1__c='Testtsstts';
        con.Address_Line_2__c='Testtsstts';
        con.Address_Line_3__c='Testtsstts';
        con.City_Name__c='Testtsstts';
        con.State_Code__c='Testtsstts';
        con.Country_Name__c='Testtsstts';
        con.FirstName = 'KapilM';
        con.LastName = 'Singh';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'abcd@gmail.com';
        con.Email='abcd@gmail.com';
        try {
        insert con;
        }catch(Exception ex){}
        
        Platform__c pl = new Platform__c(name='test pt' );
        insert pl;
        
        
        
        Test.Starttest();
         case Cas3 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
        Case.OwnerId => UserInfo.getUserId(),
        Case.Type => 'CPS BGA Process', 
        Case.Subject => 'Raf',
        Case.Status=>'Open-Rejected',
        Case.Sub_Status__c => 'Accts',
        Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('AOG','Case').Id,
        Case.Origin => 'Email',
        Case.AccountId=> acc.Id,
        Case.ContactId=> con.Id,
        Case.NSN__c => 'Test;NSN', 
        Case.Part_Number__c => 'Test;Part',
        Case.AOG__c=> False,
        Case.Classification__c=> 'GTO', 
        Case.Sub_Class__c=> 'Electrical',
        Case.SBU_w2c__c =>  'ATR',
        Case.Aircraft_Type__c => pl.id,
        Case.Comments__c=>'test',
        Case.ContactRequested__c => 'Yes, ',
        Case.Export_Compliance_Content_ITAR_EAR__c=> 'No', 
        Case.Government_Compliance_SM_M_Content__c=>'No'
        });        
        insert Cas3;
        
        casetoUpdate.add(Cas3.Id);  
        
        
        SendEmailUtils.SendEmail(casetoUpdate);
        Test.stopTest();
        /*Task newTask = new Task();
        newTask.subject = 'Customer Requested Contact';
        newTask.whatId = Cas3.Id; */
        
        
    
    }
    public static testMethod void doTest3() {
         List<Id> casetoUpdate= new List<Id>();
        Profile p1 = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User testUser = (User)SObjectFactory.create(User.sObjectType,new Map<Schema.SObjectField, Object>
            {
                User.FirstName => 'TestFirstName',
                User.LastName => 'TestLastName',
                User.Email => 'abcd@in.ibm.com',
                User.Username => 'abcd.123@in.ibm.com',
                User.Alias => 'TestF',
                User.ProfileId => p1.Id,
                User.TimeZoneSidKey => 'America/Denver',
                User.LocaleSidKey => 'en_US',
                User.EmailEncodingKey => 'UTF-8',
                User.LanguageLocaleKey => 'en_US'
            });
          user currentUser = (User) SObjectFactory.create(
          User.SObjectType,
            new Map<SObjectField, Object>{
            User.Alias => 'wvarg',
            User.Email => 'abcd@example.com',
            User.EmailEncodingKey => 'UTF-8',
            User.LastName => 'Customer Master',
            User.FirstName=>'Salesforce',    
            User.LanguageLocaleKey => 'en_US',
            User.LocalesIdKey => 'en_US',
            User.ProfileId => UserInfo.getProfileId(),
            User.TimezonesIdKey => 'America/Los_Angeles',
            //User.Username => 'wilnellies.vargas@honeywell.com'
            User.Username => 'testtest.123@honeywell.com'
            }
           );     
        
        Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.OwnerId = [Select Id from User where Name = 'API User SFDC Cust Master'].Id;
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airlines';
        acc.CBT_Team__c = 'Americas';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.Optout_P2C_Notification__c = false;
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        try {
        insert acc;
        }catch(Exception ex){}
        
        Contact con = new Contact();
        con.Phone_1__c='231231231';
        con.Honeywell_ID__c='E012345';
        con.Address_Line_1__c='Testtsstts';
        con.Address_Line_2__c='Testtsstts';
        con.Address_Line_3__c='Testtsstts';
        con.City_Name__c='Testtsstts';
        con.State_Code__c='Testtsstts';
        con.Country_Name__c='Testtsstts';
        con.FirstName = 'KapilM';
        con.LastName = 'Singh';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'abcd@gmail.com';
        con.Email='abcd@gmail.com';
        try {
        insert con;
        }catch(Exception ex){}
        
        Platform__c pl = new Platform__c(name='test pt' );
        insert pl;
        
        
        
        Test.Starttest();
         case Cas3 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
        Case.OwnerId => UserInfo.getUserId(),
        Case.Type => 'CPS BGA Process', 
        Case.Subject => 'Raf',
        Case.Status=>'Propose to Close',
        Case.Sub_Status__c => 'Accts',
        Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
        Case.Origin => 'Email',
        Case.AccountId=> acc.Id,
        Case.ContactId=> con.Id,
        Case.Type => 'Order Status', 
        Case.Part_Number__c => 'Test;Part',
        Case.AOG__c=> False,
        Case.Classification__c=> 'GTO', 
        Case.Sub_Class__c=> 'Electrical',
        Case.SBU_w2c__c =>  'ATR',
        Case.Aircraft_Type__c => pl.id,
        Case.Comments__c=>'test',
        Case.ContactRequested__c => 'Yes, ',
        Case.Export_Compliance_Content_ITAR_EAR__c=> 'No', 
        Case.Government_Compliance_SM_M_Content__c=>'No',
        Case.P2C_sent__c => 1
        });        
        insert Cas3;

        casetoUpdate.add(Cas3.Id);  
        
        
        SendEmailUtils.SendEmail(casetoUpdate);
        
        /*Task newTask = new Task();
        newTask.subject = 'Customer Requested Contact';
        newTask.whatId = Cas3.Id; */
        
        Test.stopTest();
    
    }
   
}