@isTest
public class SendCaseSurveyInlinePage_cntrl_Test {
    /*public static testMethod void doTest() {
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
        Test.StartTest();
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
        
        
        /*case Cas2 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
            Case.Type => 'MyAerospace Survey', 
            Case.Subject => 'Test Case',
            Case.Status=>'Done',
            Case.Sub_Status__c => 'Accts',
            Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('General','Case').Id,
            Case.Origin => 'Email',
            Case.AccountId=> acc.Id,
            Case.ContactId=> con.Id,
            Case.NSN__c => 'Test;NSN', 
            Case.Part_Number__c => 'Test;Part',
            Case.AOG__c=> False,
            Case.Classification__c=> 'GTO', 
            Case.Sub_Class__c=> 'Electrical',
            Case.SBU_w2c__c =>  'ATR',
            //Case.Aircraft_Type__c => pl.id,
            Case.Comments__c=>'test',
            Case.Survey_Type__c => 'Manual_General',
            //Case.Survey_Sent__c => 1,
            Case.NSS_Survey_Link__c => 'http://survey.clicktools.com/app/survey/go.jsp?i=3tg6qzgkl8rqw&ii=8b3wx8t58j5ydu0kr&iii=anonymous',
            Case.Export_Compliance_Content_ITAR_EAR__c=> 'No', 
            Case.Government_Compliance_SM_M_Content__c=>'No'
        });        
        insert Cas2;     
        
        casetoUpdate.add(Cas2.Id);
        
        PageReference pageRef = Page.SendCaseSurveyInlinePage;
        Test.setCurrentPage(pageRef);
        
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', Cas2.id);
        
        ApexPages.StandardController cont = new ApexPages.StandardController(new Case ());
        
        SendCaseSurveyInlinePage_cntrl controller2  = new SendCaseSurveyInlinePage_cntrl(cont);
        controller2.givesurvey();*/
         
         /*case Cas3 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
            Case.Type => 'MyAerospace Survey', 
            Case.Subject => 'Test Case',
            Case.Status=>'Done',
            Case.Sub_Status__c => 'Accts',
            Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('General','Case').Id,
            Case.Origin => 'Email',
            Case.AccountId=> acc.Id,
            Case.ContactId=> con.Id,
            Case.NSN__c => 'Test;NSN', 
            Case.Part_Number__c => 'Test;Part',
            Case.AOG__c=> False,
            Case.Classification__c=> 'CSO Spares', 
            Case.Sub_Class__c=> 'Electrical',
            Case.SBU_w2c__c =>  'ATR',
            Case.Aircraft_Type__c => pl.id,
            Case.Survey_Type__c => 'RGQO',
            Case.Comments__c=>'test',
            Case.Survey_Type__c => 'Manual_General',
            //Case.Survey_Sent__c => 1,
            Case.NSS_Survey_Link__c => '',
            Case.Export_Compliance_Content_ITAR_EAR__c=> 'No', 
            Case.Government_Compliance_SM_M_Content__c=>'No'
        });        
        insert Cas3;     
        
        casetoUpdate.add(Cas3.Id);
        
        PageReference pageRef = Page.SendCaseSurveyInlinePage;
        Test.setCurrentPage(pageRef);
        
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', Cas3.id);
        
        ApexPages.StandardController cont3 = new ApexPages.StandardController(new Case ());
        
        SendCaseSurveyInlinePage_cntrl controller3  = new SendCaseSurveyInlinePage_cntrl(cont3);
        controller3.givesurvey();
         
        
        Test.stopTest();
    }*/
    
    public static testMethod void doTest1() {
             List<Id> casetoUpdate= new List<Id>();

     Test.StartTest();
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
        case ca = new case();
        ca.AccountId= acc.Id;
        ca.ContactId= con.Id;
        ca.RecordtypeId = RecordTypeServices.getrecordtypebyName('General','Case').Id;
        ca.Type ='MyAerospace Survey';
        ca.NSS_Survey_Link__c= '';
        ca.Status='Done';
        ca.Survey_Type__c = 'Manual_General';
        insert ca;
        casetoUpdate.add(ca.Id);        
        PageReference pageRef = Page.SendCaseSurveyInlinePage;
        Test.setCurrentPage(pageRef);       
        ApexPages.currentPage().getParameters().put('id', Ca.id);
        ApexPages.StandardController cont3 = new ApexPages.StandardController(new Case ());
        SendCaseSurveyInlinePage_cntrl controller4  = new SendCaseSurveyInlinePage_cntrl(cont3);
        controller4.givesurvey();  
        Test.stopTest();
    }
    
    public static testMethod void doTest2() {
        Test.StartTest();
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
        case ca = new case();
        ca.AccountId= acc.Id;
        ca.ContactId= con.Id;
        ca.RecordtypeId = RecordTypeServices.getrecordtypebyName('General','Case').Id;
        ca.Type ='MyAerospace Survey';
        ca.NSS_Survey_Link__c= 'http://survey.clicktools.com/app/survey/go.jsp?i=1vx78nfwfslvr&ii=y682ipkgeujwm79ta&iii=anonymous';
        ca.Status='Done';
        ca.Survey_Type__c = '';
        insert ca;              
        PageReference pageRef = Page.SendCaseSurveyInlinePage;
        Test.setCurrentPage(pageRef);     
        ApexPages.currentPage().getParameters().put('id', ca.id);        
        ApexPages.StandardController cont3 = new ApexPages.StandardController(new Case ());        
        SendCaseSurveyInlinePage_cntrl controller4  = new SendCaseSurveyInlinePage_cntrl(cont3);
        controller4.givesurvey();       
    }    
    public static testMethod void doTest3() {
                Test.startTest();
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
        case ca = new case();
        ca.AccountId= acc.Id;
        ca.ContactId= con.Id;
        ca.RecordtypeId = RecordTypeServices.getrecordtypebyName('WEB Support','Case').Id;
        ca.Type ='MyAerospace Survey';
        ca.NSS_Survey_Link__c= 'http://survey.clicktools.com/app/survey/go.jsp?i=1vx78nfwfslvr&ii=y682ipkgeujwm79ta&iii=anonymous';
        ca.Status='Done';
        ca.Survey_Type__c = '';
        insert ca;              
        PageReference pageRef = Page.SendCaseSurveyInlinePage;
        Test.setCurrentPage(pageRef);     
        ApexPages.currentPage().getParameters().put('id', ca.id);        
        ApexPages.StandardController cont3 = new ApexPages.StandardController(new Case ());        
        SendCaseSurveyInlinePage_cntrl controller4  = new SendCaseSurveyInlinePage_cntrl(cont3);
        controller4.givesurvey();  
        Test.stopTest();
    }
    public static testMethod void dotest8(){
        Test.startTest();
        case ca1 = new case();
        //ca1.AccountId= acc.Id;
        //ca1.ContactId= con.Id;
        ca1.RecordtypeId = RecordTypeServices.getrecordtypebyName('CP Events Record Type','Case').Id;
        //ca1.Type ='MyAerospace Survey';
        ca1.NSS_Survey_Link__c= '';
        ca1.Status='Done';
        ca1.Survey_Type__c = 'Manual_CpFeedback';
        ca1.Requestor_Email_Address__c = 'abcde@gmail.com';
        insert ca1;              
        PageReference pageRef1 = Page.SendCaseSurveyInlinePage;
        Test.setCurrentPage(pageRef1);     
        ApexPages.currentPage().getParameters().put('id', ca1.id);        
        ApexPages.StandardController cont4 = new ApexPages.StandardController(new Case ());        
        SendCaseSurveyInlinePage_cntrl controller5  = new SendCaseSurveyInlinePage_cntrl(cont4);
        controller5.givesurvey(); 
        test.stopTest();
    }
    public static testMethod void doTest4() {
                Test.startTest();
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
     case ca2 = new case();
        ca2.AccountId= acc.Id;
        ca2.ContactId= con.Id;
        ca2.RecordtypeId = RecordTypeServices.getrecordtypebyName('CP Events Record Type','Case').Id;
        ca2.NSS_Survey_Link__c= '';
        ca2.Status='Done';
        ca2.Survey_Type__c = 'Manual_CpFeedback';
        insert ca2;
        PageReference pageRef2 = Page.SendCaseSurveyInlinePage;
        Test.setCurrentPage(pageRef2);       
        ApexPages.currentPage().getParameters().put('id', ca2.id);
        ApexPages.StandardController cont2 = new ApexPages.StandardController(new Case ());
        SendCaseSurveyInlinePage_cntrl controller2  = new SendCaseSurveyInlinePage_cntrl(cont2);
        controller2.givesurvey();
        Test.stopTest();
    }
     public static testMethod void doTest5() {
                Test.startTest();
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
     case ca2 = new case();
        ca2.AccountId= acc.Id;
        ca2.ContactId= con.Id;
        ca2.RecordtypeId = RecordTypeServices.getrecordtypebyName('General','Case').Id;
        ca2.Type ='MyAerospace Survey';
        ca2.NSS_Survey_Link__c= 'http://survey.clicktools.com/app/survey/go.jsp?i=1vx78nfwfslvr&ii=y682ipkgeujwm79ta&iii=anonymous';
        ca2.Status='Done';
        ca2.Survey_Type__c = 'Manual_CpFeedback';
        insert ca2;
        PageReference pageRef2 = Page.SendCaseSurveyInlinePage;
        Test.setCurrentPage(pageRef2);       
        ApexPages.currentPage().getParameters().put('id', ca2.id);
        ApexPages.StandardController cont2 = new ApexPages.StandardController(new Case ());
        SendCaseSurveyInlinePage_cntrl controller2  = new SendCaseSurveyInlinePage_cntrl(cont2);
        controller2.givesurvey();
        Test.stopTest();
    }
    public static testMethod void doTest6() {
        Test.startTest();
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
        case ca2 = new case();
        ca2.AccountId= acc.Id;
        ca2.ContactId= con.Id;
        ca2.RecordtypeId = RecordTypeServices.getrecordtypebyName('General','Case').Id;
        ca2.Type ='MyAerospace Survey';
        ca2.NSS_Survey_Link__c= 'http://survey.clicktools.com/app/survey/go.jsp?i=1vx78nfwfslvr&ii=y682ipkgeujwm79ta&iii=anonymous';
        ca2.Status='Done';
        ca2.Survey_Type__c = 'Manual_General';
        try{
        insert ca2;
        }catch(Exception ex){}
        Test.stopTest();
        PageReference pageRef2 = Page.SendCaseSurveyInlinePage;
        Test.setCurrentPage(pageRef2);       
        ApexPages.currentPage().getParameters().put('id', ca2.id);
        ApexPages.StandardController cont2 = new ApexPages.StandardController(new Case ());
        SendCaseSurveyInlinePage_cntrl controller2  = new SendCaseSurveyInlinePage_cntrl(cont2);
        controller2.givesurvey();
    }
    public static testMethod void doTest7() {
        Test.startTest();
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
        case ca2 = new case();
        ca2.AccountId= acc.Id;
        ca2.ContactId= con.Id;
        ca2.RecordtypeId = RecordTypeServices.getrecordtypebyName('CP Events Record Type','Case').Id;
        //ca2.Type ='MyAerospace Survey';
        ca2.NSS_Survey_Link__c= 'http://survey.clicktools.com/app/survey/go.jsp?i=1vx78nfwfslvr&ii=y682ipkgeujwm79ta&iii=anonymous';
        ca2.Status='Done';
        ca2.Survey_Type__c = 'Manual_WebSupport';
        try{
        insert ca2;
        }catch(Exception ex){}
        Test.stopTest();
        PageReference pageRef2 = Page.SendCaseSurveyInlinePage;
        Test.setCurrentPage(pageRef2);       
        ApexPages.currentPage().getParameters().put('id', ca2.id);
        ApexPages.StandardController cont2 = new ApexPages.StandardController(new Case ());
        SendCaseSurveyInlinePage_cntrl controller2  = new SendCaseSurveyInlinePage_cntrl(cont2);
        controller2.givesurvey();
    }
}