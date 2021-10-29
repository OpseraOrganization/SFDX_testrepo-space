/**************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : SendCaseEmail_test
* Description           : Test Class for the trigger SendcaseEmail
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Nov-08-2013      1.0            Anusuy Murugiah       Wrapping the testmethod with Start and Stop
**************************************************************************************************/
@isTest(SeeAllData=true)
public class SendCaseEmail_test
{ 
    static testmethod void SendCaseEmailtest()
    {
        List<Case> lstCases = new List<Case>();
        List<Account> lstAccts = new List<Account>();
        List<Contact> lstContacts = new List<Contact>();
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        lstAccts.add(acc);
        
        Account acc2 = new Account();
        acc2.Name = 'Honeywell Test';
        acc2.Customer_Status__c = 'Active';
        acc2.Strategic_Business_Unit__c = 'ATR';
        acc2.CBT__c = 'Airbus';
        acc2.Region_Name__c = 'Americas';
        acc2.Sub_Region_Name__c = 'Canada';
        acc2.Service_Level__c = 'Standard';
        acc2.Type = 'OEM';
        acc2.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        lstAccts.add(acc2);
        
        insert lstAccts;
        
        Contact con = new Contact();
        con.LastName = 'sampath';
        con.FirstName = 'praveen';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sampathspraveen@gmail.com';
        con.Email='kapil.nowhere@gmail.com';
        lstContacts.add(con);
        
        Contact con2 = new Contact();
        con2.LastName = 'LNAME';
        con2.FirstName = 'FNAME';
        con2.AccountId = acc2.Id;
        con2.Primary_Email_Address__c = 'mythreyee.sureshkumar@nttdata.com';
        con2.Email='mythreyee.sureshkumar@nttdata.com';
        lstContacts.add(con2);
        
        insert lstContacts;
                
        RecordType rt= [select id,name from recordtype where sobjecttype='Case' and name='Quotes'];
        
        Case cs = new Case();
        cs.Origin = 'Phone';
        cs.Status = 'Open';
        cs.ContactId = con.Id;
        cs.Type='MTO';
        cs.Mail_Box_Name__c = 'Email-Quotes';
        cs.RecordtypeId=rt.Id;
        //cs.No_FCR_Reason__c='Unspecified';For Ticket INC000009687923
        cs.HON_Commit_Date__c=system.now();
        cs.Classification__c = 'GTO Field Service';
        cs.HON_Commit_Date__c = System.now() + 1;       
        cs.Agent_Contact_Flag__c =True;
        cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs);
        
        
        Case cs2 = new Case();
        cs2.Origin = 'Web';
        cs2.Status = 'Open';
        cs2.ContactId = con.Id;
        cs2.Type='Quotes/Availability';
        cs2.RecordtypeId=label.QuotesRecordID;
        cs.Mail_Box_Name__c = 'Email-Order Changes';
        //cs2.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
        cs2.HON_Commit_Date__c=system.now();
        cs2.Classification__c = 'GTO Field Service';
        cs2.HON_Commit_Date__c = System.now() + 1;
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs2.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs2);
        
        cs2 = new Case();
        cs2.Emailbox_Origin__c ='Email-Aero GSE Vendor Support';
        cs2.Origin = 'Email';
        cs2.Status = 'Open';
        cs2.ContactId = con.Id;
        cs2.Type='';
        cs2.RecordtypeId=label.GSS_Quotes_Orders;
        //cs2.No_FCR_Reason__c='Not Trained';  For Ticket INC000009687923         
        cs.Agent_Contact_Flag__c =True;
        cs2.HON_Commit_Date__c=system.now();
        cs2.Classification__c = '';
        cs2.HON_Commit_Date__c = System.now() + 1;
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs2.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs2);
        
        cs2 = new Case();
        cs2.Emailbox_Origin__c ='Email-Aero GSE Support';
        cs2.Origin = 'Email';
        cs2.Status = 'Open';
        cs2.ContactId = con.Id;
        cs2.Type='';
        cs2.RecordtypeId=label.GSS_Technical_Support;
        //cs2.No_FCR_Reason__c='Not Trained';    For Ticket INC000009687923       
        cs.Agent_Contact_Flag__c =True;
        cs2.HON_Commit_Date__c=system.now();
        cs2.Classification__c = 'GTO Field Service';
        cs2.HON_Commit_Date__c = System.now();
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs2.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs2);
        
        
        
        
        cs2 = new Case();
        cs2.Mail_Box_Name__c = 'Email-Order Status';
        cs2.Origin = 'Email';
        cs2.Status = 'Open';
        cs2.ContactId = con.Id;
        cs2.Type='Quotes/Availability';
        cs2.RecordtypeId=label.Orders_Rec_ID;
        //cs2.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
        cs2.HON_Commit_Date__c=system.now();
        cs2.Classification__c = 'GTO Field Service';
        cs2.HON_Commit_Date__c = System.now() + 1;
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs2.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs2);
        
        cs2 = new Case();
        cs2.Mail_Box_Name__c = 'Email-Order Status';
        cs2.Origin = 'Web';
        cs2.Status = 'Open';
        cs.Sub_Class__c='Deferred Online Order';
        cs.subject=null;
        cs2.ContactId = con2.Id;
        cs2.Type='Quotes/Availability';
        cs2.RecordtypeId=label.QuotesRecordID;
        //cs2.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
        cs2.HON_Commit_Date__c=system.now();
        cs2.Classification__c = 'GTO Field Service';
        cs2.HON_Commit_Date__c = System.now() + 1;
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs2.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs2);
        
        cs2 = new Case();
        cs2.Mail_Box_Name__c = 'Email-Order Status';
        cs2.Emailbox_Origin__c='Email-Orders';
        cs2.Origin = 'Web';
        cs2.AccountId=acc.id;
        cs2.Status = 'Open';
        cs.Sub_Class__c='Deferred Online Order';
        cs.subject=null;
        cs2.ContactId = con2.Id;
        cs2.Type='Quotes/Availability';
        cs2.RecordtypeId=label.QuotesRecordID;
        //cs2.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
        cs2.HON_Commit_Date__c=system.now();
        cs2.Classification__c = 'GTO Field Service';
        cs2.HON_Commit_Date__c = System.now() + 1;
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs2.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs2);
                
        insert lstCases;
        
        //cs.No_FCR_Reason__c='Credit Issue';For Ticket INC000009687923
        cs.Sub_Class__c='Deferred Online Order';
        cs.Subject='MTO';
        cs.origin='Web';
        cs.Survey_Sent__c =1;
        cs.Survey_Type__c = 'Web_Support';
        update cs;
        cs.Subject='WebOrder; SPEX; Warranty verification';
        update cs;
        Test.stopTest();
       
        
       /* Case cs12 = new Case();
        cs12.Mail_Box_Name__c = 'Email-Order Status';
        cs12.Emailbox_Origin__c='Email-Orders';
        cs12.Origin = 'Web';
        cs12.AccountId=acc.id;
        cs12.Status = 'Open';
        cs12.Sub_Class__c='Deferred Online Order';
        cs12.subject=null;
        cs12.ContactId = con2.Id;
        cs12.Type='Quotes/Availability';
        cs12.RecordtypeId=label.QuotesRecordID;
        cs12.No_FCR_Reason__c='Not Trained';
        cs12.HON_Commit_Date__c=system.now();
        cs12.Classification__c = 'GTO Field Service';
        cs12.HON_Commit_Date__c = System.now() + 1;
        cs12.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs12.Government_Compliance_SM_M_Content__c = 'NO';
        insert cs12;
        cs12.Emailbox_Origin__c='Email-Quotes';
        cs12.Origin='Email';
        update cs12;*/
        
        
    }
}