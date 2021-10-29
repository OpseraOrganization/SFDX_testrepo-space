@isTest
public class TestAutopopulateEmailUpdate{
 static testMethod void TestAutopopulateEmailUpdate()
 {
   Profile p = [select id from profile where name='Honeywell System Administrator'];
   User u = new User();
   u.alias = 'standt';
   u.email='reply2manjuys@gmail.com';
   u.emailencodingkey='UTF-8';
   u.lastname='Testing';
   u.languagelocalekey='en_US';
   u.localesidkey='en_US';
   u.profileid = p.Id;
   u.timezonesidkey='America/Los_Angeles';
   u.username='manjuys@nttdata.com';
   insert u;
  
   System.runAs(u)
    {
     Account a= new Account();
     a.Name='Tesst Account';
     a.Customer_Status__c='Active';
     a.Region_Name__c='Americas';
     a.Sub_Region_Name__c='Africa';
     a.Service_Level__c='Comprehensive';
     a.Strategic_Business_Unit__c='ATR';
     a.CBT__c='Airbus';
     a.CBT_Team__c='Airbus';
     a.Market_Name__c='Air Transport';
     a.Business_Owner__c='Ryan, Justin';
     a.Type='Air Cargo Transporter';
     a.REPORT_ACCOUNT_NAME__c='Test Report';
     insert a;
     
    Account_Address__c aa= new Account_Address__c();
    aa.Account_Name__c=a.Id;
    aa.Address_Type__c='Account';
    aa.Report_Address_Line_1__c='Test';
    aa.Report_City_Name__c='Bagalore';
    aa.Report_Country_Name__c='Afghanistan';
    insert aa;
     
 }
 
 }
}