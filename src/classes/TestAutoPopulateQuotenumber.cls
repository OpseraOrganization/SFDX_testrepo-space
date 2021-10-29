@isTest
public class TestAutoPopulateQuotenumber{
 static testMethod void TestAutoPopulateQuotenumber()
 {
  TriggerInactive.testTrigger = false;
   Profile p = [select id from profile where name='System Administrator' limit 1];
   User u = new User();
   u.alias = 'standt';
   u.email='harikishore.vutukuri@nttdata.com';
   u.emailencodingkey='UTF-8';
   u.lastname='Testing';
   u.languagelocalekey='en_US';
   u.localesidkey='en_US';
   u.profileid = p.Id;
   u.timezonesidkey='America/Los_Angeles';
   u.CommunityNickname='tcs';
   u.Username='test2355.2355user@nttdataaaa.com';
  
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
     
     Contact c= new Contact();
     c.AccountId=a.Id;
     c.LastName='Hari';
     c.SBU_Contact__c='ACS Labs';
     c.CBT__c='ACS Sensors Lab';
     c.CBT_Team__c='ACS Advanced Sensors';
     c.Primary_Email_Address__c='test@test.com';
     c.Phone_1__c= '12345678';
     insert c;
    
     Case c1= new Case();
     c1.Origin='Email';
     c1.Export_Compliance_Content_ITAR_EAR__c='No';
     c1.Government_Compliance_SM_M_Content__c='Yes';
     c1.Status='Open';  
     c1.Type='AOG';
     c1.HON_Commit_Date__c=date.Today()+5;
     c1.ContactId=c.Id;
     
     
     insert c1;
     
     Task tsk = new Task();
     tsk.recordtypeid=label.Quote_Defects_RT_Id;
     tsk.Priority = 'High';
     tsk.Status = 'Open';
     tsk.Subject = 'Other';
     tsk.Whatid= c1.id;
     insert tsk;
     c1.Status='cancelled';
     c1.Reason_for_Cancellation__c= 'Duplicate CASE';
     c1.resolution__c = 'abc test test';
     update c1;
     
    
    }
  }