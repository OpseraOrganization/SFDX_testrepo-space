@isTest
public class Test_UserCasedescritionupdate{        
    static testMethod void testMethod1() {
        test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        
        insert acc;
        //Id rt= [select id,name from recordtype where sobjecttype='Case' and name='Orders'].id;
        Contact con = new Contact();
        con.LastName = 'Kulkarni';
        con.FirstName = 'Shrivaths';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'shrivaths.kulkarni@nttdata.com';
        con.Email='shrivaths.kulkarni@nttdata.com';
        insert con;
            
        Case cseLow = new Case();
        cseLow.Origin = 'Email-EMS-Norcross';
        //cseLow.Status = 'New';
        cseLow.RecordTypeId = Label.EMS_Orders_RecordType_ID;
       // cseLow.Classification__c = 'MyGDC';
        cseLow.ContactId = con.Id;
        cseLow.Type_of_Change__c = 'New Account';
        cseLow.Type = 'Other';
        cseLow.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow.Government_Compliance_SM_M_Content__c = 'NO';  
        cseLow.OwnerId=label.aero_default_user_id;
        insert cseLow; 
        cseLow.OwnerId=label.aero_default_user_id;
        update cseLow;
        //userstatus
        List<Activitiy_Line_Item__c>  userstatuslist=new List<Activitiy_Line_Item__c>();
        Activitiy_Line_Item__c  userstatus=new Activitiy_Line_Item__c ();
        userstatus.Name__c='GAT0';
        userstatus.status__c = 'open';
        userstatus.Case__c=cseLow.id;
        userstatuslist.add(userstatus);
        Activitiy_Line_Item__c  userstatus1=new Activitiy_Line_Item__c ();
        userstatus1.Name__c='GAT1';
        userstatus1.status__c = 'open';
        userstatus1.Case__c=cseLow.id;      
        userstatuslist.add(userstatus1);
        Activitiy_Line_Item__c  userstatus2=new Activitiy_Line_Item__c ();
        userstatus2.Name__c='HRTS';
        userstatus2.status__c = 'open';
        userstatus2.Case__c=cseLow.id;      
        userstatuslist.add(userstatus2);
        if(userstatuslist.size()>0)
        insert userstatuslist;      
        test.stopTest(); 
    }  
    static testMethod void  testmethod2()
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
        
        insert cslist; 
        
        Id  recId = RecordTypeServices.getRecordTypeByName('Task Activities Record Type','Z_Task__c').Id;   
        
        Z_Task__c Z135task = new Z_Task__c();
        Z135task.Type__c = 'Z146 Cust Follow Up Required - GAT0';
        Z135task.Status__c = 'Open';
        Z135task.Sub_Type__c = 'Other';
        Z135task.Other_Short_Text__c = 'HRTS – Past RAI threshold';
        Z135task.RelatedTo__c = cslist[0].id;
        Z135task.RecordTypeId= recId;
        ZtaskInsert.add(Z135task);

        insert ZtaskInsert;
        
        Activitiy_Line_Item__c u = new Activitiy_Line_Item__c();
        u.Name__c = 'WADV';
        u.Status__c = 'Open';
        u.Case__c = cslist[0].id;
        u.Task_Activities__c=ZtaskInsert[0].Id;
        u.CurrencyIsoCode ='USD';
        ulist.add(u);        
       
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
   }
   
   static testMethod void  testmethod3()
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
        
        
        Case cs = new Case();
        cs.Origin = 'SAP Interface';
        cs.Status = 'Open';                
        cs.ContactId = conlist[0].Id;
        cs.AccountID = acclist[0].id;
        cs.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cs.Customer_Type__c = 'MSP';
        cs.Part_Status__c = 'Outright';
        cs.Customer_PO_RO_WONumber__c = '352312345';
        cs.Sales_Order_Number__c = '21100463';
        cs.Part_Number_Needed__c = 'Test';
        cs.Quote_Number__c = '23648623';
        cs.Proposed_Supplier__c = 'Test1';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs.Part_Number__c = 'Test';
        cs.Repair_Notification_Number__c = '76547654';
        cs.Subject = 'Test Cases';
        cs.Product_Serial_Number__c = 'testsn';
        cs.CaseOwnerChanged__c = 'test@test.com';
        cs.Requestor_Email__c = 'test1@test.com';
        cs.Order_Channel__c = 'M2M ';
        cslist.add(cs);           
        
        insert cslist; 
        
        Id  recId = RecordTypeServices.getRecordTypeByName('Task Activities Record Type','Z_Task__c').Id;   
        
        Z_Task__c Z135task = new Z_Task__c();
        Z135task.Type__c = 'Z136 CUSTOMER FOLLOW UP REQUIRED';
        Z135task.Name= 'Z136 CUSTOMER FOLLOW UP REQUIRED';
        Z135task.Status__c = 'Open';
        Z135task.Sub_Type__c = 'Other';
        Z135task.Other_Short_Text__c = 'Z136 CUSTOMER FOLLOW UP REQUIRED';
        Z135task.RelatedTo__c = cslist[0].id;
        Z135task.RecordTypeId= recId;
        ZtaskInsert.add(Z135task);

        insert ZtaskInsert;
        
        Activitiy_Line_Item__c u = new Activitiy_Line_Item__c();
        u.Name__c = 'WFES';
        u.Status__c = 'Open';
        u.Case__c = cslist[0].id;
        u.Task_Activities__c=ZtaskInsert[0].Id;
        u.CurrencyIsoCode ='USD';
        ulist.add(u);        
       
        try{ 
            upsert ulist;
                     
            }catch(Exception e){
            
            }

}
static testMethod void  testmethod4()
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
        
        
        Case cs = new Case();
        cs.Origin = 'SAP Interface';
        cs.Status = 'Open';                
        cs.ContactId = conlist[0].Id;
        cs.AccountID = acclist[0].id;
        cs.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cs.Customer_Type__c = 'MSP';
        cs.Part_Status__c = 'Outright';
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
        cs.Order_Channel__c = 'M2M ';
        cs.Reason_for_hold__c = 'Quote Approval';
        cs.Sub_Status__c = 'Customer Hold';
        cs.Status = 'On Hold';
        cslist.add(cs);           
        
        insert cslist; 
        
        Id  recId = RecordTypeServices.getRecordTypeByName('Task Activities Record Type','Z_Task__c').Id;   
        
        Z_Task__c Z135task = new Z_Task__c();
        Z135task.Type__c = 'Z129 CUSTOMER FOLLOW UP REQUIRED';
        Z135task.Name= 'Z129 CUSTOMER FOLLOW UP REQUIRED';
        Z135task.Status__c = 'Open';
        Z135task.Sub_Type__c = 'Other';
        Z135task.Other_Short_Text__c = 'Z129 CUSTOMER FOLLOW UP REQUIRED';
        Z135task.RelatedTo__c = cslist[0].id;
        Z135task.RecordTypeId= recId;
        ZtaskInsert.add(Z135task);

        insert ZtaskInsert;
        
        Activitiy_Line_Item__c u = new Activitiy_Line_Item__c();
        u.Name__c = 'ESTA';
        u.Status__c = 'Open';
        u.Case__c = cslist[0].id;
        u.Task_Activities__c=ZtaskInsert[0].Id;
        u.CurrencyIsoCode ='USD';
        ulist.add(u);        
       
       Test.StartTest();    
            upsert ulist;

        Test.StopTest();
        
}
}