@isTest()
public class PursendmailTest{

    static testMethod void firstTest() 
    {
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

insert acc;

Contact con = new Contact();
con.LastName = 'Singh';
con.FirstName = 'Kapil';
con.AccountId = acc.Id;
con.Primary_Email_Address__c = 'kapil.nowhere@gmail.com.qa';
con.Email='kapil.nowhere@gmail.com.qa';
insert con;
    
    Portal_User_Registration__c p=new Portal_User_Registration__c();
     p.Contact_Creation_in_SFDC__c='N';
     p.Honeywell_ID__c='1234';
     p.Contact__c=con.id;
     insert p;  
     
     p.Contact_Creation_in_SFDC__c='Y';
     update p;
     
    
    }
    
  }