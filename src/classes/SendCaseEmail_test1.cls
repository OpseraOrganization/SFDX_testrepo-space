/**************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : SendCaseEmail_test1
* Description           : Test Class for the trigger SendcaseEmail
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Nov-08-2013      1.0            Anusuy Murugiah       Wrapping the testmethod with Start and Stop
**************************************************************************************************/
@isTest(SeeAllData=true)
public class SendCaseEmail_test1
{ 
    static testmethod void SendCaseEmailtest1()
    {
        List<Case> lstCases = new List<Case>();
        List<Account> lstAccts = new List<Account>();
        List<Contact> lstContacts = new List<Contact>();
        
        Account acc = new Account();
        acc.Name = 'Honeywell Test1';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST1';
        lstAccts.add(acc);
        
        Account acc2 = new Account();
        acc2.Name = 'Honeywell Test11';
        acc2.Customer_Status__c = 'Active';
        acc2.Strategic_Business_Unit__c = 'ATR';
        acc2.CBT__c = 'Airbus';
        acc2.Region_Name__c = 'Americas';
        acc2.Sub_Region_Name__c = 'Canada';
        acc2.Service_Level__c = 'Standard';
        acc2.Type = 'OEM';
        acc2.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST11';
        lstAccts.add(acc2);
        
        insert lstAccts;
        
        Contact con = new Contact();
        con.LastName = 'sampath1';
        con.FirstName = 'praveen1';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sampathspraveen1@gmail.com';
        con.Email='kapil.nowhere1@gmail.com';
        lstContacts.add(con);
        
        Contact con2 = new Contact();
        con2.LastName = 'LNAME1';
        con2.FirstName = 'FNAME1';
        con2.AccountId = acc2.Id;
        con2.Primary_Email_Address__c = 'mythreyee1.sureshkumar@nttdata.com';
        con2.Email='mythreyee.sureshkumar1@nttdata.com';
        lstContacts.add(con2);
        
        insert lstContacts;
                
        RecordType rt= [select id,name from recordtype where sobjecttype='Case' and name='Quotes'];
        Test.startTest();                    
        Case cs2 = new Case();
        cs2.Emailbox_Origin__c ='Email-Aero GSE Vendor Support';
        cs2.Origin = 'Email';
        cs2.Status = 'Open';
        cs2.ContactId = con.Id;
        cs2.Type='';
        cs2.RecordtypeId=label.GSS_Quotes_Orders;
        //cs2.No_FCR_Reason__c='Not Trained'; For Ticket INC000009687923          
        cs2.Agent_Contact_Flag__c =True;
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
        //cs2.No_FCR_Reason__c='Not Trained';  For Ticket INC000009687923         
        cs2.Agent_Contact_Flag__c =True;
        cs2.HON_Commit_Date__c=system.now();
        cs2.Classification__c = 'GTO Field Service';
        cs2.HON_Commit_Date__c = System.now();
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs2.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs2);
        
        cs2 = new Case();
        cs2.Emailbox_Origin__c ='Email-Aero GSE Quotes';
        cs2.Origin = 'Email';
        cs2.Status = 'Open';
        cs2.ContactId = con.Id;
        cs2.Type='';
        cs2.RecordtypeId=label.GSS_Quotes_Orders;
        //cs2.No_FCR_Reason__c='Not Trained';    For Ticket INC000009687923       
        cs2.Agent_Contact_Flag__c =True;
        cs2.HON_Commit_Date__c=system.now();
        cs2.Classification__c = '';
        cs2.HON_Commit_Date__c = System.now();
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs2.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs2);
        
        cs2 = new Case();
        cs2.Emailbox_Origin__c ='Email-Aero GSE Orders';
        cs2.Origin = 'Email';
        cs2.Status = 'Open';
        cs2.ContactId = con.Id;
        cs2.Type='';
        cs2.RecordtypeId=label.GSS_Quotes_Orders;
        //cs2.No_FCR_Reason__c='Not Trained';   For Ticket INC000009687923        
        cs2.Agent_Contact_Flag__c =True;
        cs2.HON_Commit_Date__c=system.now();
        cs2.Classification__c = '';
        cs2.HON_Commit_Date__c = System.now();
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs2.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs2);
        
        cs2 = new Case();
        cs2.Emailbox_Origin__c ='Email-Aero GSE Quotes';
        cs2.Origin = 'Email';
        cs2.Status = 'Open';
        cs2.ContactId = con.Id;
        cs2.Type='';
        cs2.RecordtypeId=label.GSS_Quotes_Orders;
        //cs2.No_FCR_Reason__c='Not Trained';     For Ticket INC000009687923      
        cs2.Agent_Contact_Flag__c =false;
        cs2.HON_Commit_Date__c=system.now();
        cs2.Classification__c = '';
        cs2.HON_Commit_Date__c = System.now();
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs2.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs2);
        
        cs2 = new Case();
        cs2.Emailbox_Origin__c ='Email-Aero GSE Orders';
        cs2.Origin = 'Email';
        cs2.Status = 'Open';
        cs2.ContactId = con.Id;
        cs2.Type='';
        cs2.RecordtypeId=label.GSS_Quotes_Orders;
        //cs2.No_FCR_Reason__c='Not Trained';   For Ticket INC000009687923        
        cs2.Agent_Contact_Flag__c =false;
        cs2.HON_Commit_Date__c=system.now();
        cs2.Classification__c = '';
        cs2.HON_Commit_Date__c = System.now();
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs2.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs2);
             
        insert lstCases;
        Test.stopTest();
                
        
    }
}