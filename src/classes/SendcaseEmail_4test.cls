/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class SendcaseEmail_4test {

    static testMethod void SendCaseEmailtest() 
    {
      List<Account> lstAccts = new List<Account>();
      List<Contact> lstContacts = new List<Contact>();
      List<Case> lstCases = new List<Case>();
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
        acc2.Strategic_Business_Unit__c = 'BGA';
        acc2.Concierge__c=true;
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
        
       
       
        
        Case cs12 = new Case();
        cs12.Mail_Box_Name__c = 'Email-Order Status';
        cs12.Emailbox_Origin__c='Email-Orders';
        cs12.Origin = 'Web';
        cs12.AccountId=acc.id;
        cs12.Status = 'Open';
        cs12.Sub_Class__c='Deferred Online Order';
        cs12.subject=null;
        cs12.ContactId = con.Id;
        cs12.Type='Quotes/Availability';
        cs12.RecordtypeId=label.QuotesRecordID;
        //cs12.No_FCR_Reason__c='Not Trained'; For Ticket INC000009687923
        cs12.HON_Commit_Date__c=system.now();
        cs12.Classification__c = 'GTO Field Service';
        cs12.HON_Commit_Date__c = System.now() + 1;
        cs12.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs12.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs12);
        
        
        
         cs12 = new Case();
        cs12.Mail_Box_Name__c = 'Email-Order Status';
        cs12.Emailbox_Origin__c='Email-Orders';
        cs12.Origin = 'Web';
        cs12.AccountId=acc.id;
        cs12.Status = 'Open';
        cs12.Sub_Class__c='Deferred Online Order';
        cs12.subject=null;
        cs12.ContactId = con.Id;
        cs12.Type='Owner/Operator';
        cs12.RecordtypeId=label.QuotesRecordID;
        //cs12.No_FCR_Reason__c='Not Trained'; For Ticket INC000009687923
        cs12.HON_Commit_Date__c=system.now();
        cs12.Classification__c = 'GTO Field Service';
        cs12.HON_Commit_Date__c = System.now() + 1;
        cs12.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs12.Government_Compliance_SM_M_Content__c = 'NO';
        lstCases.add(cs12);
        
        
       insert lstCases; 
        cs12.Emailbox_Origin__c='Email-Quotes';
        cs12.Origin='Email';
        update cs12;                
    }
}