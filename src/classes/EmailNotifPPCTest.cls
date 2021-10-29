@istest
public class EmailNotifPPCTest {
  /*   testMethod static void discretionaryTest(){
         
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
        
       // Test.startTest(); 
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
         try{
         insert sr;
         }catch(Exception e){
             
         }
         system.debug('sr is @'+sr);
         
        Discretionary__C disc2= new Discretionary__C();
        disc2.Type__c='Bid & Proposal';
        disc2.SBU__c='ATR';
        disc2.Estimated_Completion_Date__c = System.today();
        
        disc2.Service_Request__c =sr.Id;
        
        disc2.OwnerId = userValue2.id;
        disc2.Owner__c = userValue2.id;
        
        disc2.Approval_Status__c = 'Open';
        try{ 
        insert disc2;
        }catch(Exception e){
             
        }
         
        
     
        
        
        Discretionary_Line_item__c DLI2=new Discretionary_Line_item__c();
        DLI2.Funding_Amount__c=40;
        dli2.Requested_Amount__c=50;
        DLI2.Discretionary_Request__c = disc2.id;
        
        DLI2.Approval_Status__c ='Open';
        try{ 
        insert DLI2;
         }catch(Exception e){
             
         }
         system.debug('dli rec is'+DLI2.Id);
         system.debug('dli dis is'+DLI2.Discretionary_Request__c);
         
        Test.startTest(); 
        
        disc2.Approval_Status__c = 'Closed';
        try{
        update disc2;
        }catch(Exception e){
            
        }
        
       
        Test.stopTest();
        
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
        
        Test.startTest();
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
         try{
         insert sr;
         }catch(exception e){
             
         } 
         system.debug('sr is @'+sr);
         
        Discretionary__C disc2= new Discretionary__C();
        disc2.Type__c='Bid & Proposal';
        disc2.SBU__c='ATR';
        disc2.Estimated_Completion_Date__c = System.today();
        
        disc2.Service_Request__c =sr.Id;
        
        disc2.OwnerId = userValue2.id;
        disc2.Owner__c = userValue2.id;
        
        disc2.Approval_Status__c = 'Open';
         try{
        insert disc2;
         }catch(exception e){
             
         } 
         
     
        
        
        Discretionary_Line_item__c DLI2=new Discretionary_Line_item__c();
        DLI2.Funding_Amount__c=40;
        dli2.Requested_Amount__c=50;
        DLI2.Discretionary_Request__c = disc2.id;
        
        DLI2.Approval_Status__c ='Open';
         try{
         insert DLI2;
         }catch(exception e){
             
         }      
         system.debug('dli rec is'+DLI2.Id);
         system.debug('dli dis is'+DLI2.Discretionary_Request__c);
         

          
          
         
           sr.Status__c = 'Closed';
           try{
           update sr;
           }catch(exception e){
               
           }
           Test.stopTest();
          
      }  */
      
      testMethod static void discretionaryTest2(){
          
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
        
        Test.startTest();
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
         try{
         insert sr;
         }catch(exception e){
             
         } 
         system.debug('sr is @'+sr);
         
        Discretionary__C disc2= new Discretionary__C();
        disc2.Type__c='Bid & Proposal';
        disc2.SBU__c='ATR';
        disc2.Estimated_Completion_Date__c = System.today();
        
        disc2.Service_Request__c =sr.Id;
        
        disc2.OwnerId = userValue2.id;
        disc2.Owner__c = userValue2.id;
        
        disc2.Approval_Status__c = 'Open';
         try{
        insert disc2;
         }catch(exception e){
             
         } 
         
     
        
        
        Discretionary_Line_item__c DLI2=new Discretionary_Line_item__c();
        DLI2.Funding_Amount__c=40;
        dli2.Requested_Amount__c=50;
        DLI2.Discretionary_Request__c = disc2.id;
        
        DLI2.Approval_Status__c ='Open';
         try{
         insert DLI2;
         }catch(exception e){
             
         }      
         system.debug('dli rec is'+DLI2.Id);
         system.debug('dli dis is'+DLI2.Discretionary_Request__c);
         

          
          
         
           DLI2.Approval_Status__c = 'Close';
           //DLI2.PPC_Notify__c = true;
           try{
           update DLI2;
           DLI2.PPC_Notify__c = true;
           }catch(exception e){
               
           }
           Test.stopTest();
          
      }  

}