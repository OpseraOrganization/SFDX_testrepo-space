/*********************************************************************************************************************
Name         :TestRalateToContract
Created By   :Chiranth Aradhya
company Name :
Project      :Aero sales
created Date :1/30/2013
Usages       :This Test class is used to relate the contact
******************************************************************************************************************/
@isTest
public class TestRalateToContract{
 static testMethod void TestRalateToContract()
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
   u.Username='test5523.5523user@nttdataa.com';
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
    
    /* Case c1= new Case();
     c1.Origin='Email';
     c1.Export_Compliance_Content_ITAR_EAR__c='No';
     c1.Government_Compliance_SM_M_Content__c='Yes';
     c1.Status='Open';  
     c1.Type='AOG';
     c1.HON_Commit_Date__c=date.Today()+5;
     c1.ContactId=c.Id;
     insert c1;*/
      
    Platform__c pltFrm = new Platform__c(name='Test Platform');
        insert pltFrm;
    
    Fleet_Asset_Detail__c Fad = new Fleet_Asset_Detail__c();
    Fad.Platform_Name__c=pltFrm.id;
    Fad.Name='testFleet';
    insert Fad;
      
   
    
    Contract cont= new Contract (name='Test',accountId= a.Id);
    insert cont;
    
    Entitlement__c En = new Entitlement__c();
    En.Contract_Number__c=cont.Id;
    En.Status__c='Active';
    En.Usage_Count__c=2;
    En.Percentage__c=1;
    En.Usage_Cap__c=2;
    En.Entitlement_Start_Date__c=System.Today()+3;
    En.End_Date__c=System.Today()+6;
    insert En;
          
     
     Task tsk = new Task();
     tsk.Priority = 'High';
     tsk.Status = 'Open';
     tsk.Subject = 'Other';
     tsk.Whatid= En .id;
     insert tsk;
     
     tsk.Whatid=cont.Id;
     update tsk;
     
     
    
    }
  }