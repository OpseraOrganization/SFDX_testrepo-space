@isTest
public class SendeMailToADVNCustomersBatch_Test {
    
     static testMethod void  testmethod1()
      {  
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        List<Case> csList = new List<Case>();
        List<Account> acclist = new List<Account>();
        List<Contact> conlist = new List<Contact>();
        List<Z_Task__c> ZtaskInsert = new List<Z_Task__c>();        
        List<Activitiy_Line_Item__c> ulist = new List<Activitiy_Line_Item__c>();
       
        Account acc = new Account();
        acc.Name = 'Testweb';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.RAI_Excluded__c = TRUE;
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        acclist.add(acc);
        insert acclist;
        
        Contact objContact = new Contact();
        objContact.LastName = 'hariiii';
        objContact.FirstName = 'testweb';
        objContact.AccountId = acclist[0].Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
        objContact.Employee_Number__c = 'H287751';      
        conlist.add(objContact);
        insert conlist;
        
        Product2 p = new Product2();
        p.Name = 'Test';
        p.ProductCode = 'Test123';
        p.IsActive = true;
        p.Product_Number__c = 'Test2345';
        insert p;
        
        Product2 p1 = new Product2();
        p1.Name = 'Test';
        p1.ProductCode = 'Test123';
        p1.IsActive = true;
        p1.Product_Number__c = null;
        insert p1;
        
        
        Case cs = new Case();
        cs.Origin = 'SAP Interface';
        cs.Status = 'Open';                
        cs.ContactId = conlist[0].Id;
        cs.AccountID = acclist[0].id;
        cs.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cs.Customer_Type__c = 'MSP';
        cs.Part_Status__c = 'Outright';
        cs.Product_Number__c = p.id;
        cs.Customer_PO_RO_WONumber__c = '352312345';
        cs.Sales_Order_Number__c = '21100463';
        cs.Part_Number_Needed__c = 'Test';
        cs.Quote_Number__c = '23648623';
        cs.Proposed_Supplier__c = 'Test1';
        cs.Price__c = '123';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs.Part_Number__c = 'Test';
        cs.Repair_Notification_Number__c = '76547654';
        cs.Subject = 'Test Cases';
        cs.Product_Serial_Number__c = 'testsn';
        cs.CaseOwnerChanged__c = 'test@test.com';
        cs.Requestor_Email__c = 'test1@test.com';
        cslist.add(cs);   
        
        Case cs1 = new Case();
        cs1.Origin = 'SAP Interface';
        cs1.Status = 'Open';                
        cs1.ContactId = conlist[0].Id;
        cs1.AccountID = acclist[0].id;
        cs1.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cs1.Customer_Type__c = 'MSP';
        cs1.Part_Status__c = 'Outright';
        cs1.Product_Number__c = p1.id;
        cs1.Sales_Order_Number__c = '21100463';
        cs1.Part_Number_Needed__c = 'Test';
        cs1.Quote_Number__c = '23648623';
        cs1.Proposed_Supplier__c = 'Test1';
        cs1.Price__c = '123';
        cs1.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs1.SuppliedEmail = 'harikishore.vutukuri@honeywell.com';         
        cs1.Repair_Notification_Number__c = '76547654';
        cs1.Subject = 'Test Cases';        
        cs1.CaseOwnerChanged__c = 'test@test.com;test@test.com';
        cs1.Requestor_Email__c = '';
        cslist.add(cs1); 
        
        Case cs2 = new Case();
        cs2.Origin = 'SAP Interface';
        cs2.Status = 'Open';                
        cs2.ContactId = conlist[0].Id;
        cs2.AccountID = acclist[0].id;
        cs2.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cs2.Customer_Type__c = 'MSP';
        cs2.Part_Status__c = 'Outright';
        cs2.Product_Number__c = p.id;
        cs2.Sales_Order_Number__c = '21100463';
        cs2.Part_Number_Needed__c = 'Test';
        cs2.Quote_Number__c = '23648623';
        cs2.Proposed_Supplier__c = 'Test1';
        cs2.Price__c = '123';
        cs2.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs2.SuppliedEmail = 'harikishore.vutukuri@honeywell.com';         
        cs2.Repair_Notification_Number__c = '76547654';
        cs2.Subject = 'Test Cases';        
        cs2.CaseOwnerChanged__c = '';
        cs2.Requestor_Email__c = 'test@test.com';
        cslist.add(cs2); 
                
        insert cslist; 
        
        cs2.Requestor_Email__c = '';
        
        update cs2;
        
        Id  recId = RecordTypeServices.getRecordTypeByName('Task Activities Record Type','Z_Task__c').Id;   
        
        Z_Task__c Z135task = new Z_Task__c();
        Z135task.Type__c = 'Z146 Cust Follow Up Required - GAT0';
        Z135task.Status__c = 'Open';
        Z135task.Sub_Type__c = 'Other';
        Z135task.Other_Short_Text__c = 'HRTS – Past RAI threshold';
        Z135task.RelatedTo__c = cslist[0].id;
        Z135task.RecordTypeId= recId;
        ZtaskInsert.add(Z135task);
        
        Z_Task__c Z151task = new Z_Task__c();
        Z151task.Type__c = 'Z146 Cust Follow Up Required - GAT0';
        Z151task.Status__c = 'Open';
        Z151task.Sub_Type__c = 'Pre payment order';
        Z151task.RelatedTo__c = cslist[1].id;
        Z151task.RecordTypeId = recId;
        ZtaskInsert.add(Z151task);
        
        Z_Task__c Z151task1 = new Z_Task__c();
        Z151task1.Type__c = 'Z146 Cust Follow Up Required - GAT0';
        Z151task1.Status__c = 'Open';
        Z151task1.Sub_Type__c = 'Pre payment order';
        Z151task1.RelatedTo__c = cslist[2].id;
        Z151task1.RecordTypeId = recId;
        ZtaskInsert.add(Z151task1);
        
        insert ZtaskInsert;
        
        Activitiy_Line_Item__c u = new Activitiy_Line_Item__c();
        u.Name__c = 'WADV';
        u.Status__c = 'Open';
        u.Case__c = cslist[0].id;
        u.Task_Activities__c=ZtaskInsert[0].Id;
        u.CurrencyIsoCode ='USD';
        ulist.add(u);
        
        Activitiy_Line_Item__c u1 = new Activitiy_Line_Item__c();
        u1.Name__c = 'WADV';
        u1.Status__c = 'Open';
        u1.Task_Activities__c=ZtaskInsert[1].Id;
        u1.Case__c = cslist[1].id;
        u1.CurrencyIsoCode ='USD'; 
        ulist.add(u1);
        
        Activitiy_Line_Item__c u2 = new Activitiy_Line_Item__c();
        u2.Name__c = 'WADV';
        u2.Status__c = 'Open';
        u2.Task_Activities__c=ZtaskInsert[2].Id;
        u2.Case__c = cslist[2].id;
        u2.CurrencyIsoCode ='USD'; 
        ulist.add(u2);
         
        //insert ulist; 
         try{ 
            upsert ulist;
                     
            }catch(Exception e){
            
         }
          //EmailTemplate et=[Select id,subject,body from EmailTemplate where name = 'Repair_Overhaul_ADVN_Notification' limit 1];
         String[] toAddresses = new String[] {'user@acme.com'};
         
          for(Activitiy_Line_Item__c ca: ulist)
          {
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
               mail.setToAddresses(toAddresses);
              // mail.settemplateId(et.id);
               mail.setsubject('test-subject');
               mail.setHTMLbody('<html> test body</html>');
               Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
           }
        Test.StartTest();
        SendeMailToADVNCustomersBatch obj= new  SendeMailToADVNCustomersBatch();
        Id jobId= Database.executebatch(obj);
        Test.stopTest();       
   }
}