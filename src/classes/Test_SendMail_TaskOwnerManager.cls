/** * File Name: Test_SendMail_TaskOwner
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
Version   Date         Author         Modification 
1.1       20/05/2016   NTTDATA        INC000009966209 - Added NSS Detractor Follow Up notification to include link to Case, Activity and Feedback Records test coverage method **/ 

@isTest
public class Test_SendMail_TaskOwnerManager
{
static testmethod void testSendMailTaskOwnerManager()
{
    //variable declaration
Profile pf= [select id from Profile where name = 'System Administrator'];
User usr = new User(LastName = 'Test UserMger',Username = 'TestMger@test.com',Email = 'saritha.babu@wipro.com',Alias = 'tum9gr' ,CommunityNickname= 'tu19mgr' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr;
User usr1 = new User(LastName = 'Test1 UserManger',Managerid=usr.id,Username = 'Test1Manager@test.com',Email = 'raji.mathew@wipro.com',Alias = 'tumgr1' ,CommunityNickname= 'tu1mgr1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr1;

 //creating account;
 Account acc= new Account(name='Test Task Account',Strategic_Business_Unit__c = 'ATR',CBT__c = 'CBMS',CBT_Team__c = 'AMFS');
 insert acc;
 
 //creating contact;
/* Contact cont=new Contact(firstname='Test',LastName='Manager',AccountId=acc.Id,Phone_3__c='9986502445',
  Contact_Is_Employee__c=true,Phone_1__c ='9874563210', Primary_Email_Address__c ='mariakitheri.tinulin@nttdata.com', Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E156767');
 insert cont;*/
Test.StartTest();
 //creating case
 Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',
 //ContactId=cont.Id,
 Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',RecordTypeid=Label.QuotesRecordID,Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',Sales_Order_Number__c='123Test',ClosedDate =system.today(),of_Emails_Sent__c =2,of_Emails_Received__c=3,Resolution__c ='123',Notes__c='test',Description = 'Test');
 insert cases;
 Test.StopTest();
 
 //creating Feedback
  Feedback__c fb =new feedback__c(Account__c=acc.id,Case__c=cases.id,CES_Score__c =2,NPS_Recommend__c=2,NPS_Classification__c='detractor',Inquiry_closed__c ='yes',Ease_of_Contact_Availability__c =2,Knowledge_Technical_Expertise__c=2,Timeliness_of_response__c=2,Quality_and_Accuracy__c=2,Courtesy_and_Professionalism__c=2,Overall_satisfaction__c=2,Contact_requested__c ='yes',Comments__c='test',Comments_Topic__c ='Ease of contact',No_of_Contacts_to_Resolve__c ='2',FCR__c = 2);
  insert fb;  
//creating task
     
  Task tasks= new Task (whatId=cases.Id, ownerid=usr1.Id, subject='NSS Survey - Follow Up', PRIORITY='Normal' );    
  insert tasks;
  String Subjected;
  String parent='';
        if(tasks.recordtypeid!= label.General_Task ){
            Subjected = tasks.Subject;
            if(Subjected != ''& Subjected!= Null){
                 if(Subjected.contains('NSS Survey - Follow Up')){
                    tasks.Ownerid = usr1.Id;    
                    tasks.whatid =  cases.Id;
                  }
                parent=tasks.whatId;
               if(parent!=null)//Added for null pointer fix
                    parent=parent.substring(0,3);
                
                //if(Subjected.contains('NSS Detractor Follow Up') && tasks.recordtypeid==label.Service_Task_RT_ID && parent=='500' ){ 
                if(Subjected.contains('NSS Detractor Follow Up') && tasks.recordtypeid==label.Task_Survey_FP_RecordTypeId && parent=='500' ){   
                    tasks.whatid = cases.Id;
                    tasks.Ownerid = usr1.Id;
                }      
            }
        }    
    
  
/*  Event event= new Event (whatId=cases.Id, whoId=cont.Id, ownerid=usr1.Id, subject='NSS Survey - Follow Up', DurationInMinutes = 10, ActivityDateTime = system.now());    
  insert event; */

}// end of method
   /* static testmethod void testSendMailTaskOwnerManager1()
{
    //variable declaration

Profile pf= [select id from Profile where name = 'System Administrator'];
User usr = new User(LastName = 'Test UserMger',Username = 'TestMger@test.com',Email = 'saritha.babu@wipro.com',Alias = 'tum9gr' ,CommunityNickname= 'tu19mgr' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr;
User usr1 = new User(LastName = 'Test1 UserManger',Managerid=usr.id,Username = 'Test1Manager@test.com',Email = 'raji.mathew@wipro.com',Alias = 'tumgr1' ,CommunityNickname= 'tu1mgr1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr1;

 //creating account;
 Account acc= new Account(name='Test Task Account',Strategic_Business_Unit__c = 'ATR',CBT__c = 'CBMS',CBT_Team__c = 'AMFS');
 insert acc;
 
 //creating contact;*/
 /*Contact cont=new Contact(firstname='Test',LastName='Manager',AccountId=acc.Id,Phone_3__c='9986502445',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Phone_1__c ='9874563210', Primary_Email_Address__c ='mariakitheri.tinulin@nttdata.com',Employee_Number__c='E156767');
 insert cont;*/
  /*Test.startTest(); 
 //creating case
 Case cases=new Case(AccountId=acc.Id,Description = 'Test',subject='Fax:{9986502495} test data',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 Type='Order',Supported_Product__c='ADIRS',RecordTypeid=Label.FSS_Accounts_RecordType_ID ,Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',Sales_Order_Number__c='123Test',ClosedDate =system.today(),of_Emails_Sent__c =2,of_Emails_Received__c=3,Resolution__c ='123',Notes__c='test');
 insert cases;
 
 //creating feedback
 Feedback__c fb =new feedback__c(Account__c=acc.id,Case__c=cases.id,CES_Score__c =2,NPS_Recommend__c=2,NPS_Classification__c='detractor',Inquiry_closed__c ='yes',Ease_of_Contact_Availability__c =2,Knowledge_Technical_Expertise__c=2,Timeliness_of_response__c=2,Quality_and_Accuracy__c=2,Courtesy_and_Professionalism__c=2,Overall_satisfaction__c=2,Contact_requested__c ='yes',Comments__c='test',Comments_Topic__c ='Ease of contact',No_of_Contacts_to_Resolve__c ='2',FCR__c = 2);
 insert fb;
 //creating task
 
 
  Task tasks= new Task (whatId=cases.Id, ownerid=usr1.Id, subject='NSS Detractor Follow Up', PRIORITY='Normal' ,recordtypeid=label.Service_Task_RT_ID);    
  insert tasks;
  
  Test.stoptest();  


}*/ 
// end of method
}// end of class