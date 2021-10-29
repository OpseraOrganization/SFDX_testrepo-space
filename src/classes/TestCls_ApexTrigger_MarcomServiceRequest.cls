@isTest(SeeAllData=false)
public class TestCls_ApexTrigger_MarcomServiceRequest{
static testMethod void TestCls_ApexTrigger_MarcomServiceRequestTest()
{
  Profile p = [select id from profile where name='System Administrator'];
  system.debug('system dmin'+p.id);
   User u = new User();
   u.alias = 'standt';
   u.email='venkatesh4force@gmail.com';
   u.emailencodingkey='UTF-8';
   u.lastname='Testing';
   u.languagelocalekey='en_US';
   u.localesidkey='en_US';
   u.profileid = p.Id;
   u.timezonesidkey='America/Los_Angeles';
   u.username='standarduser@testorrgg.com';
   insert u;
   
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
     
     Marcom_Service_Request__c msr=new Marcom_Service_Request__c();
     msr.Marcom_Business__c='test';
     msr.Marcom_Audience__c='Internal';
     msr.Marcom_Related_Activity__c='test2';
     msr.Marcom_Market__c='BGA';
     msr.Marcom_Request_Region__c='Americas';
     msr.Marcom_Request_Timeline__c=date.Today()+5;
     insert msr;
     
     Marcom_Request_Ticket_Routing__c mrt=new Marcom_Request_Ticket_Routing__c();
     mrt.Marcom_Audience__c='Internal';
     mrt.Marcom_Market__c='BGA';
     mrt.Marcom_Region__c='Americas';
     mrt.Carbon_Copy__c='vvv@gmail.com';
     mrt.Owner__c=u.Id;
     insert mrt;
     
     msr.Marcom_Audience__c=mrt.Marcom_Audience__c;
     msr.Marcom_Market__c=mrt.Marcom_Market__c;
     msr.Marcom_Request_Region__c=mrt.Marcom_Region__c;
     msr.OwnerId=mrt.Owner__c;
     mrt.Carbon_Copy__c='True';
     update msr;
     
}
}