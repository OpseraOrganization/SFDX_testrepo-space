@isTest(SeeAllData=true)
private class Testcls_Apextrgr_emailNotificationSR{
    static testMethod void Testcls_Apextrgr_emailNotificationSRTest(){
        Profile p = [select id from profile where name='System Administrator'];
        
        Account acc = new Account();
        acc.Name='Account';
        acc.Customer_Status__c='Active';
        acc.Region_Name__c='Americas';
        acc.Sub_Region_Name__c='Africa';
        acc.Service_Level__c='Comprehensive';
        acc.Strategic_Business_Unit__c='ATR';
        acc.CBT__c='Airbus';
        acc.CBT_Team__c='Airbus';
        acc.Market_Name__c='Air Transport';
        acc.Business_Owner__c='Ryan, Justin';
        acc.Type='Air Cargo Transporter';
        acc.REPORT_ACCOUNT_NAME__c='Test Report';
        insert acc;
        
        Contact con= new Contact();
        con.AccountId=acc.Id;
        con.LastName='Hari';
        con.SBU_Contact__c='ACS Labs';
        con.CBT__c='ACS Sensors Lab';
        con.CBT_Team__c='ACS Advanced Sensors';
        con.Primary_Email_Address__c='testing@testing.com';
        con.Phone_1__c= '12345678';
        insert con;
        
        Case cas= new Case();
        cas.Origin='Email';
        cas.Export_Compliance_Content_ITAR_EAR__c='No';
        cas.Government_Compliance_SM_M_Content__c='Yes';
        cas.Status='Open';  
        cas.Type='AOG';
        cas.HON_Commit_Date__c=date.Today()+5;
        cas.ContactId=con.Id;
        cas.Classification__c = 'GTO Product Support';
        try{
        insert cas;
        }catch(DMLException e){}
        
        User usr = new User();
        usr.alias = 'hari';
        usr.email = 'hari23@test.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='vnv';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.profileid = p.Id;
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='standarduser@testing.com';
        try{
        insert usr;
        }catch(DMLException ie){}
        
        List<Service_Request__c> srlist = new List<Service_Request__c>();
        Service_Request__c sr = new Service_Request__c();
        sr.Subject__c = 'test';
        sr.SR_Type__c = 'GDC';
        //sr.HON_Commit_Date__c = null;
        sr.Customer_Due_Date__c = null;
        sr.Priority__c = 'High';
        sr.Status__c = 'Monitor';
        sr.Case_Number__c = cas.id;
        sr.Problem_Description__c = 'test';
        sr.Deliverable__c = 'test';
        sr.Contact_Name__c = con.Id;
        sr.Account_Name__c = acc.id;
        sr.Customer_Due_Date__c = System.today();
        //sr.HON_Commit_Date__c = system.today()+1;
        sr.Atr__c = 'Value';
        sr.Attribute_Sub__c = 'Contracts';
        sr.Attribute_Details__c = 'Late';
        sr.Complexity_Level__c='1-Part Price/Availability';
        sr.ATR_checkbox__c = true;
        sr.SR_Phase__c= 'Investigation';
        sr.Key_code__c= NULL;
        sr.CSB_Gate__c='Gate 3';
        sr.EPS_Start_Time__c = system.today();
        sr.EPS_End_Time__c = system.today();
        sr.Gate_1_Completion_Date__c=null;
        sr.Gate_2_Completed__c=null;
        srlist.add(sr);
        
        Service_Request__c sr1 = new Service_Request__c();
        sr1.Subject__c = 'test';
        sr1.SR_Type__c = 'GDC';
        sr1.Priority__c = 'High';
        sr1.Status__c = 'Open';
        sr1.Case_Number__c = cas.id;
        sr1.Problem_Description__c = 'test';
        sr1.Deliverable__c = 'test';
        sr1.Contact_Name__c = con.Id;
        sr1.Account_Name__c = acc.id;
        sr1.Ownerid = Label.EPS_D_S_Queue; 
        sr1.EPS_End_Time__c = system.today();
        sr1.Customer_Due_Date__c = System.today();
        //sr1.HON_Commit_Date__c = null;
        sr1.Atr__c = 'Value';
        sr1.Attribute_Sub__c = 'Contracts';
        sr1.Attribute_Details__c = 'Late';
        sr1.Complexity_Level__c='1-Part Price/Availability';
        sr1.ATR_checkbox__c = true;  
        sr1.Key_code__c= '1234';
        sr1.CSB_Gate__c='Gate 4';
        sr1.Gate_1_Completion_Date__c=system.Today();
        sr1.Gate_2_Completed__c=system.today();
        //insert sr1;
        srlist.add(sr1);
       
       Service_Request__c sr2 = new Service_Request__c();
        sr2.Subject__c = 'test';
        sr2.SR_Type__c = 'GDC';
        sr2.Priority__c = 'High';
        sr2.Status__c = 'Open';
        sr2.Case_Number__c = cas.id;
        //sr2.Problem_Description__c = 'test';
        sr2.Deliverable__c = 'test';
        sr2.Contact_Name__c = con.Id;
        sr2.Account_Name__c = acc.id;
        //sr.Ownerid = Label.EPS_D_S_Queue; 
        //sr.EPS_End_Time__c = system.today();
        sr2.Customer_Due_Date__c = System.today();
        //sr2.HON_Commit_Date__c = null;
        sr2.Atr__c = 'Value';
        sr2.Attribute_Sub__c = 'Contracts';
        sr2.Attribute_Details__c = 'Late';
        sr2.Complexity_Level__c='1-Part Price/Availability';
        sr2.ATR_checkbox__c = true;  
        sr2.Key_code__c= '1234';
        sr2.CSB_Gate__c='Gate 4';
        sr2.Gate_1_Completion_Date__c=NULL;
        sr2.Gate_2_Completed__c=NULL;
        //insert sr2;
        srlist.add(sr2);
        
        Service_Request__c sr3 = new Service_Request__c();
        sr3.Subject__c = 'test';
        sr3.SR_Type__c = 'GDC';
        sr3.Priority__c = 'High';
        sr3.Status__c = 'Open';
        sr3.Case_Number__c = cas.id;
        sr3.Problem_Description__c = 'test';
        sr3.Deliverable__c = 'test';
        sr3.Contact_Name__c = con.Id;
        sr3.Account_Name__c = acc.id;
        sr3.Customer_Due_Date__c = System.today();
        //sr3.HON_Commit_Date__c = system.today()+1;
        sr3.Atr__c = 'Value';
        sr3.Attribute_Sub__c = 'Contracts';
        sr3.Attribute_Details__c = 'Late';
        sr3.Complexity_Level__c='1-Part Price/Availability';
        sr3.ATR_checkbox__c = true;
        sr3.SR_Phase__c= 'Investigation';
        sr3.SR_Phase__c = 'EPS Queue';
        sr3.Key_code__c= '1234';
        sr3.CSB_Gate__c='Gate 4';
        sr3.Gate_1_Completion_Date__c=system.Today();
        sr3.Gate_2_Completed__c=null;
        //insert sr3;
        srlist.add(sr3);
        
        Service_Request__c sr4 = new Service_Request__c();
        sr4.Subject__c = 'test';
        sr4.SR_Type__c = 'GDC';
        sr4.Priority__c = 'High';
        sr4.Status__c = 'closed';
        sr4.Case_Number__c = cas.id;
        sr4.Problem_Description__c = 'test';
        sr4.Deliverable__c = 'test';
        sr4.Contact_Name__c = con.Id;
        sr4.Account_Name__c = acc.id;
        sr4.CSB_Gate__c='Gate 3';
        sr4.Key_code__c= null;
        sr4.Customer_Due_Date__c = System.today();
        //sr4.HON_Commit_Date__c = system.today()+2;
        sr4.Atr__c = 'Value';
        sr4.createdDate = system.today();
        sr4.Date_Closed__c = system.today();
        sr4.Attribute_Sub__c = 'Contracts';
        sr4.Attribute_Details__c = 'Late';
        sr4.Complexity_Level__c='1-Part Price/Availability';
        sr4.ATR_checkbox__c = true;
        sr4.Gate_1_Completion_Date__c=system.Today();
        sr4.Gate_2_Completed__c=system.today();
        //insert sr4;
        srlist.add(sr4);
        
        Service_Request__c sr5 = new Service_Request__c();
        sr5.Subject__c = 'test';
        sr5.SR_Type__c = 'GDC';
        sr5.Priority__c = 'High';
        sr5.Status__c = 'closed';
        sr5.Case_Number__c = cas.id;
        sr5.Problem_Description__c = 'test';
        sr5.Deliverable__c = 'test';
        sr5.Contact_Name__c = con.Id;
        sr5.Account_Name__c = acc.id;
        sr5.Customer_Due_Date__c = System.today();
        //sr5.HON_Commit_Date__c = system.today()+3;
        sr5.Atr__c = 'Value';
        sr5.createdDate = system.today();
        sr5.Date_Closed__c = system.today()+1;
        sr5.Attribute_Sub__c = 'Contracts';
        sr5.Attribute_Details__c = 'Late';
        sr5.Complexity_Level__c='1-Part Price/Availability';
        sr5.ATR_checkbox__c = true;
        sr5.SR_Phase__c= 'Investigation';
        sr5.SR_Phase__c = 'EPS Queue';
        sr5.Key_code__c= '1234';
        sr5.CSB_Gate__c='Gate 4';
        sr5.Gate_1_Completion_Date__c = system.Today();
        sr5.Gate_2_Completed__c = NULL;
        //insert sr5;
        srlist.add(sr5);
        
        Service_Request__c sr6 = new Service_Request__c();
        sr6.Subject__c = 'test';
        sr6.SR_Type__c = 'GDC';
        sr6.Priority__c = 'High';
        sr6.Status__c = 'monitor';
        sr6.Case_Number__c = cas.id;
        sr6.Problem_Description__c = 'test';
        sr6.Deliverable__c = 'test';
        sr6.Contact_Name__c = con.Id;
        sr6.Account_Name__c = acc.id;
        sr6.Customer_Due_Date__c = System.today();
        //sr6.HON_Commit_Date__c = system.today()+1;
        sr6.Atr__c = 'Value';
        sr6.Attribute_Sub__c = 'Contracts';
        sr6.Attribute_Details__c = 'Late';
        sr6.Complexity_Level__c='1-Part Price/Availability';
        sr6.ATR_checkbox__c = true;
        sr6.Key_code__c= null;
        sr4.CSB_Gate__c='Gate 3';
        sr6.Gate_1_Completion_Date__c=system.Today();
        sr6.Gate_2_Completed__c = SYSTEM.TODAY();
        //insert sr6;
        srlist.add(sr6);
        
        try{
        insert srlist;
        }Catch(DMLException ee){}
    }
     testMethod static void discretionaryTest3(){
          
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         
         User us3 = new User(Alias = 'standt@3', Email='standarduser3@testforceorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing@3', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser3@forceorg.com');
         insert us3;
         system.debug('user 11@@'+us3); 
         
        User us1 = new User(Alias = 'standt@1', Email='standarduser1@testforceorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing@1', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@forceorg.com',Discretionary_Workflow_Approver__c = us3.id);
         insert us1;
         system.debug('user 11@@'+us1);
         system.debug('user 11@@ app'+us1.Discretionary_Workflow_Approver__c);
        
      
          User userValue2 = new User(Alias = 'standt@2', Email='standarduser2@testforceorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing@2', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2@forceorg.com',Managers_Name__c = us1.id,Managerid = us1.id);
         insert userValue2;
          system.debug('user 22@@'+userValue2);
         system.debug('user 22@@'+userValue2.ManagerId);
        
         
       //  list<Service_Request__c> sr= [select id,status__c,OwnerId__c,SR_Owner__c from Service_Request__c where status__c = 'Open' and OwnerId__c =:userValue.id limit 1];
        
         Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Unauthorized Dist/Brkr';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        insert acc;
        
         Contact con = new Contact();

        con.LastName = 'Testcon';
        con.FirstName = 'test';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'test.test1@nttdata.com';
        con.Email='test.test1@nttdata.com';
        insert con; 
         
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'BGA Service Request';
        email.fromAddress = 'Fanita.Nathireddy@honeywell.com';
        email.plaintextbody='Service Request Deliverable';
        
       
        Service_Request__c sr=new Service_Request__c();
        sr.Subject__c=email.subject;
        sr.Status__c = 'Open';
        sr.Customer_Due_Date_BGA_S__c=system.now();
        sr.HON_Commit_Date_BGA__c=system.now();
        sr.OwnerId = userValue2.id;
        sr.OwnerId__c = userValue2.id;
        sr.Contact_Name__c = con.id;

         sr.IsAttachment__c=true;
         //sr.recordtypeid='012e00000000aln';
         //sr.Contact_Name__c='003e000000OQfZg';
         
         insert sr;
        
         system.debug('sr is @'+sr);
         
        Discretionary__C disc2= new Discretionary__C();
        disc2.Type__c='Bid & Proposal';
        disc2.SBU__c='ATR';
        disc2.Estimated_Completion_Date__c = System.today();
        
        disc2.Service_Request__c =sr.Id;
        
        disc2.OwnerId = userValue2.id;
        disc2.Owner__c = userValue2.id;
        
        disc2.Approval_Status__c = 'Open';
        
        insert disc2;
        
        
        Discretionary_Line_item__c DLI2=new Discretionary_Line_item__c();
        DLI2.Funding_Amount__c=40;
        dli2.Requested_Amount__c=50;
        DLI2.Discretionary_Request__c = disc2.id;
        
       // DLI2.Approval_Status__c ='Open';
        
         insert DLI2;
            
         system.debug('dli rec is'+DLI2.Id);
         system.debug('dli dis is'+DLI2.Discretionary_Request__c);
         
         Test.startTest();
         
           sr.Status__c = 'Closed';
           update sr;
           update disc2;
         
           Test.stopTest();
          
      }
    testMethod static void discretionaryTest(){
         
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         
         User us3 = new User(Alias = 'standt@3', Email='standarduser3@testforceorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing@3', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser3@forceorg.com');
         insert us3;
         system.debug('user 11@@'+us3); 
         
        User us1 = new User(Alias = 'standt@1', Email='standarduser1@testforceorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing@1', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@forceorg.com',Discretionary_Workflow_Approver__c = us3.id);
         insert us1;
         system.debug('user 11@@'+us1);
         system.debug('user 11@@ app'+us1.Discretionary_Workflow_Approver__c);
        
      
          User userValue2 = new User(Alias = 'standt@2', Email='standarduser2@testforceorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing@2', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2@forceorg.com',Managers_Name__c = us1.id,Managerid = us1.id);
         insert userValue2;
          system.debug('user 22@@'+userValue2);
         system.debug('user 22@@'+userValue2.ManagerId);
        
         
       //  list<Service_Request__c> sr= [select id,status__c,OwnerId__c,SR_Owner__c from Service_Request__c where status__c = 'Open' and OwnerId__c =:userValue.id limit 1];
        
         Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Unauthorized Dist/Brkr';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        insert acc;
        
         Contact con = new Contact();

        con.LastName = 'Testcon';
        con.FirstName = 'test';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'test.test1@nttdata.com';
        con.Email='test.test1@nttdata.com';
        insert con; 
         
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'BGA Service Request';
        email.fromAddress = 'Fanita.Nathireddy@honeywell.com';
        email.plaintextbody='Service Request Deliverable';
        
       
        Service_Request__c sr=new Service_Request__c();
        sr.Subject__c=email.subject;
        sr.Status__c = 'Open';
        sr.Customer_Due_Date_BGA_S__c=system.now();
        sr.HON_Commit_Date_BGA__c=system.now();
        sr.OwnerId = userValue2.id;
        sr.OwnerId__c = userValue2.id;
        sr.Contact_Name__c = con.id;

         sr.IsAttachment__c=true;
         //sr.recordtypeid='012e00000000aln';
         //sr.Contact_Name__c='003e000000OQfZg';
        
         insert sr;
        
         system.debug('sr is @'+sr);
         
        Discretionary__C disc2= new Discretionary__C();
        disc2.Type__c='Bid & Proposal';
        disc2.SBU__c='ATR';
        disc2.Estimated_Completion_Date__c = System.today();
        
        disc2.Service_Request__c =sr.Id;
        
        disc2.OwnerId = userValue2.id;
        disc2.Owner__c = userValue2.id;
        
        disc2.Approval_Status__c = 'Open';
       
        insert disc2;
       
        
    
        
        
        Discretionary_Line_item__c DLI2=new Discretionary_Line_item__c();
        DLI2.Funding_Amount__c=40;
        dli2.Requested_Amount__c=50;
        DLI2.Discretionary_Request__c = disc2.id;
        DLI2.Discretionary_Account__c = '1';
        
       // DLI2.Approval_Status__c ='Open';
       
        insert DLI2;
  
  Contact c=[select id,Email from Contact where id ='0033000000h1LiV'];
       
         DLI_Site_CC_List__c cc = new DLI_Site_CC_List__c();
     cc.Discretionary_Line_Item__c= DLI2.id;
     cc.Contact__c=c.id;
     insert cc;
     
        DLI2.Approval_Status__c ='Open';
        update DLI2;
        
        Discretionary_Line_item__c DLI3=new Discretionary_Line_item__c();
        DLI3.Funding_Amount__c=40;
        DLI3.Requested_Amount__c=50;
        DLI3.Discretionary_Request__c = disc2.id;
        DLI3.Discretionary_Account__c = '2';
        
       // DLI2.Approval_Status__c ='Open';
       
        insert DLI3;
        
        DLI_Site_CC_List__c cc1 = new DLI_Site_CC_List__c();
     cc1.Discretionary_Line_Item__c= DLI3.id;
     cc1.Contact__c=c.id;
     insert cc1;
        
        DLI3.Approval_Status__c ='Close';
        update DLI3;
        
        system.debug('dli rec is'+DLI2.Id);
        system.debug('dli dis is'+DLI2.Discretionary_Request__c);
         
        Test.startTest();
        
        disc2.Approval_Status__c = 'Closed';
        update disc2;
       
        Test.stopTest();
        
    }  
}