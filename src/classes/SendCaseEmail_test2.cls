/**************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : SendCaseEmail_test2
* Description           : Test Class for the trigger SendcaseEmail
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Nov-08-2013      1.0            Anusuy Murugiah       Wrapping the testmethod with Start and Stop
**************************************************************************************************/
@isTest(SeeAllData=true)
public class SendCaseEmail_test2
{ 
    static testmethod void SendCaseEmailtest2()
    {
        List<Case> lstCases = new List<Case>();
        List<Account> lstAccts = new List<Account>();
        List<Contact> lstContacts = new List<Contact>();
        
        Account acc = new Account();
        acc.Name = 'Honeywell Test2';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST2';
        lstAccts.add(acc);
        
        Account acc2 = new Account();
        acc2.Name = 'Honeywell Test2';
        acc2.Customer_Status__c = 'Active';
        acc2.Strategic_Business_Unit__c = 'ATR';
        acc2.CBT__c = 'Airbus';
        acc2.Region_Name__c = 'Americas';
        acc2.Sub_Region_Name__c = 'Canada';
        acc2.Service_Level__c = 'Standard';
        acc2.Type = 'OEM';
        acc2.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST2';
        lstAccts.add(acc2);
        
        insert lstAccts;
        
        Contact con = new Contact();
        con.LastName = 'sampaths';
        con.FirstName = 'praveens';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sampathspraveen2@gmail.com';
        con.Email='kapil.nowhere2@gmail.com';
        lstContacts.add(con);
        
        Contact con2 = new Contact();
        con2.LastName = 'LNAME';
        con2.FirstName = 'FNAME';
        con2.AccountId = acc2.Id;
        con2.Primary_Email_Address__c = 'mythreyee.sureshkumars@nttdata.com';
        con2.Email='mythreyee.sureshkumars@nttdata.com';
        lstContacts.add(con2);
        
        insert lstContacts;
                
        
        Case cs = new Case();
        cs.Origin = 'Email';
        cs.Status = 'Open';
        cs.ContactId = con.Id;
        cs.Type='MTO';
        cs.RecordtypeId=label.NavDB_Prod_RecordId;
        //cs.No_FCR_Reason__c='Unspecified';For Ticket INC000009687923
        //cs.HON_Commit_Date__c=system.now();For Ticket INC000009687923
        cs.Classification__c = 'GTO Field Service';
        cs.HON_Commit_Date__c = System.now() + 1;       
        cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs);
        
        Case cs2 = new Case();
        cs2.Origin = 'Web';
        cs2.Status = 'Open';
        cs2.ContactId = con.Id;
        cs2.Type='Quotes/Availability';
        cs2.Emailbox_Origin__c = 'Email-Orders';
        //cs2.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
        cs2.HON_Commit_Date__c=system.now();
        cs2.Recordtypeid = label.Orders_Rec_ID;
        cs2.Classification__c = 'GTO Field Service';
        cs2.HON_Commit_Date__c = System.now() + 1;
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs2.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs2);
        
        cs2 = new Case();
        cs2.Origin = 'Email';
        cs2.Status = 'Open';
        cs2.ContactId = con.Id;
        cs2.Type='Quotes/Availability';
        cs2.Emailbox_Origin__c = 'Email-Order Status';
        //cs2.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
        cs2.HON_Commit_Date__c=system.now();
        cs2.Recordtypeid = label.Orders_Rec_ID;
        cs2.Classification__c = 'GTO Field Service';
        cs2.HON_Commit_Date__c = System.now() + 1;
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs2.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs2);
        
        cs2 = new Case();
        cs2.Emailbox_Origin__c ='Email-EngineRentals';
        cs2.Origin = 'Email';
        cs2.Status = 'Open';
        cs2.ContactId = con.Id;
        cs2.Type='';
        cs2.RecordtypeId = label.Engine_Rentals_RT_ID;
        //cs2.No_FCR_Reason__c='Not Trained';    For Ticket INC000009687923       
        cs.Agent_Contact_Flag__c =True;
        cs2.HON_Commit_Date__c=system.now();
        cs2.Classification__c = 'GTO Field Service';
        cs2.HON_Commit_Date__c = System.now();
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs2.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs2);
        
        cs2 = new Case();
        cs2.Origin = 'Email';
        cs2.Status = 'Open';
        cs2.ContactId = con.Id;
        cs2.Type='Quotes/Availability';
        cs2.Emailbox_Origin__c = 'Email-Order Status';
        //cs2.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
        cs2.HON_Commit_Date__c=system.now();
        cs2.Recordtypeid = label.Repair_Overhaul_RT_ID;
        cs2.Classification__c = 'CSO Spares';
        cs2.HON_Commit_Date__c = System.now() + 1;
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'Yes';
        cs2.Government_Compliance_SM_M_Content__c = 'Yes';
        lstCases.add(cs2);
        
        cs2 = new Case();
        cs2.Origin = 'Email';
        cs2.Status = 'Open';
        cs2.ContactId = con.Id;
        cs2.Type='Quotes/Availability';
        cs2.Emailbox_Origin__c = 'Email-Order Status';
        //cs2.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
        cs2.HON_Commit_Date__c=system.now();
        cs2.Recordtypeid = label.Repair_Overhaul_RT_ID;
        cs2.Classification__c = 'GTO Field Service';
        cs2.HON_Commit_Date__c = System.now() + 1;
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'Yes';
        cs2.Government_Compliance_SM_M_Content__c = 'Yes';
        lstCases.add(cs2);
        
        cs2 = new Case();
        cs2.Origin = 'Email';
        cs2.Status = 'Open';
        cs2.ContactId = con.Id;
        cs2.Type='Quotes/Availability';
        cs2.Emailbox_Origin__c = 'Email-Order Status';
        //cs2.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
        cs2.HON_Commit_Date__c=system.now();
        cs2.Recordtypeid = label.Case_Technical_Issue_RecordType;
        cs2.Classification__c = 'GTO D&S Technical Issue';
        cs2.HON_Commit_Date__c = System.now() + 1;
        cs2.Secure_Notes__c = 'test case for explort and government compliance case';
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'Yes';
        cs2.Government_Compliance_SM_M_Content__c = 'Yes';
        lstCases.add(cs2);
        Test.startTest();        
        insert lstCases;
        Test.stopTest();
    }
    static testmethod void SendCaseEmailtest3()
    {
       List<Case> lstCases = new List<Case>();
       List<caseShare> lstInsA350 = new List<caseShare>();
       List<Contact> lstContacts = new List<Contact>();
       List<Account> lstAccts = new List<Account>();
       Account acc2=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1]; 
       
       
        Account acc3 = new Account();
        acc3.Name = 'Honeywell Test1';
        acc3.Customer_Status__c = 'Active';
        acc3.Strategic_Business_Unit__c = 'BGA';
        acc3.Concierge__c =True;
        acc3.CBT__c = 'Airbus';
        acc3.Region_Name__c = 'Americas';
        acc3.Sub_Region_Name__c = 'Canada';
        acc3.Service_Level__c = 'Standard';
        acc3.Type = 'OEM';
        acc3.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        //insert acc3;
        lstAccts.add(acc3);
           Account acc4 = new Account();
        acc4.Name = 'Honeywell Test2';
        acc4.Customer_Status__c = 'Active';
        acc4.Strategic_Business_Unit__c = 'BGA';
        acc4.CBT__c = 'Airbus';
        acc4.Region_Name__c = 'Americas';
        acc4.Sub_Region_Name__c = 'Canada';
        acc4.Service_Level__c = 'Standard';
        acc4.Type = 'Owner/Operator';
        acc4.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        //insert acc4;
        lstAccts.add(acc4);
       insert lstAccts;
       
        Contact con2 = new Contact();
        con2.LastName = 'LNAME';
        con2.FirstName = 'FNAME';
        con2.AccountId = acc2.Id;
        con2.Primary_Email_Address__c = 'mythreyee.sureshkumars@nttdata.com';
        con2.Email='mythreyee.sureshkumars@nttdata.com';
        //lstContacts.add(con2);
        insert con2;
        
        
        case cs2 = new Case();
        cs2.Origin = 'Email';
        cs2.Status = 'Open';
        cs2.ContactId = con2.Id;
        cs2.Type='Quotes/Availability';
        cs2.Emailbox_Origin__c = 'Email-Order Status';
        //cs2.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
        cs2.HON_Commit_Date__c=system.now();
        cs2.Recordtypeid = label.A350_FT_EIS_Tech_Issue_Rec_ID;
        cs2.Classification__c = 'GTO D&S Technical Issue';
        cs2.HON_Commit_Date__c = System.now() + 1;
        cs2.Secure_Notes__c = 'test case for explort and government compliance case';
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'Yes';
        cs2.Government_Compliance_SM_M_Content__c = 'Yes';
        
        insert cs2;
        
        CaseShare objA350CaseShare = new CaseShare();
        objA350CaseShare.CaseAccessLevel = 'Edit';
        objA350CaseShare.UserorGroupid = label.A350_FT_EIS_Tech_Issue_Group_ID;
        objA350CaseShare.caseid = cs2.id;
        lstInsA350.add(objA350CaseShare);
        insert lstInsA350;
        
        case cs3 = new Case();
        cs3.Origin = 'Phone';
        cs3.Status = 'Open';
        cs3.subject = 'Service Request Web Application';
        cs3.ContactId = con2.Id;
        cs3.Type='Quotes/Availability';
        cs3.Emailbox_Origin__c = 'Email-Order Status';
        //cs3.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
        cs3.HON_Commit_Date__c=system.now();
        cs3.Recordtypeid = label.Case_Technical_Issue_RecordType;
        cs3.Classification__c = 'CSO Spares';
        cs3.HON_Commit_Date__c = System.now() + 1;
        cs3.Secure_Notes__c = 'test case for explort and government compliance case';
        cs3.Export_Compliance_Content_ITAR_EAR__c = 'Yes';
        cs3.Government_Compliance_SM_M_Content__c = 'Yes';
        
        insert cs3;
        
        
        cs3.Emailbox_Origin__c ='Email-Quotes';
        cs3.Accountid = acc3.id;
        cs3.Origin = 'Email';
        update cs3;
         Test.startTest(); 
        
        case cs4 = new Case();
        cs4.Origin = 'Email';
        cs4.Status = 'Open';
        cs4.ContactId = con2.Id;
        cs4.Type='Quotes/Availability';
        cs4.Emailbox_Origin__c = 'Email-Order Status';
        //cs4.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
        cs4.HON_Commit_Date__c=system.now();
        cs4.Recordtypeid = label.Case_Technical_Issue_RecordType;
        cs4.Classification__c = 'CSO Spares';
        cs4.HON_Commit_Date__c = System.now() + 1;
        cs4.Secure_Notes__c = 'test case for explort and government compliance case';
        cs4.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs4.Government_Compliance_SM_M_Content__c = 'NO';
          insert cs4;
          
             case cs5 = new Case();
        cs5.Origin = 'Phone';
        cs5.Status = 'Open';
        cs5.ContactId = con2.Id;
        cs5.Type='Quotes/Availability';
        cs5.Emailbox_Origin__c = 'Email-Order Status';
        //cs5.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
        cs5.HON_Commit_Date__c=system.now();
        cs5.Recordtypeid = label.Case_Technical_Issue_RecordType;
        cs5.Classification__c = 'CSO Spares';
        cs5.HON_Commit_Date__c = System.now() + 1;
        cs5.Secure_Notes__c = 'test case for explort and government compliance case';
        cs5.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs5.Government_Compliance_SM_M_Content__c = 'NO';
          insert cs5;
          
        cs5.Accountid = acc4.id;
        cs5.Origin = 'Email';
        cs5.Emailbox_Origin__c ='Email-Quotes';
        update cs5;
      
        
        Test.stopTest();
   
      } 
}