/** * File Name: DS_Test_ApexClass_SendApprovalMail
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
Public class DS_Test_ApexClass_SendApprovalMail{
    static testMethod void ApexClass_SendApprovalMail(){
   Date d1 =Date.newInstance(2009,08,12); 
     Profile pf= [select id,name from Profile where name = 'D&S Sales'];
     System.assertEquals('D&S Sales',pf.name);
Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
insert a1;
Contact cnt1 = new Contact(LastName = 'Test contact',firstname='Test',Contact_Is_Employee__c = true,Email='sumithameon@gmail.com',phone_3__c='89652',Employee_Number__c='H123567',Employee_Contact_Role__c='Administrator');
insert cnt1;
Opportunity o1 = new Opportunity(Name='Complexopp',Type ='Complex',Accountid=a1.Id,StageName='Propecting',CloseDate=d1);
insert o1;
Opportunity_Gate__c og =new  Opportunity_Gate__c(Name = 'testopp',Opportunity__c = o1.Id);
insert og;
User u1 = new User(LastName = 'Test User',Username = 'testuser@test.com.honeywell',Email = 'testuser@test.com',Alias = 'tuser' ,CommunityNickname= 'tuser' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US');
insert u1;
   
Opportunity_Gate__c opg;

Contact c1 = new Contact(LastName = 'Test contact',firstname='Test',Accountid = a1.id,Email='sumithameon@gmail.com',phone_3__c='89652' );
insert c1;
Opportunity_Gate_Approval_History__c ch = new Opportunity_Gate_Approval_History__c(Opportunity_Team_Name__c = c1.name,Opportunity_Gate__c = og.Id);
insert ch;
System.currentPageReference().getParameters().put('id',og.id);
    ApexPages.StandardController Controller = new ApexPages.StandardController(og);
    SendApprovalMail st = new SendApprovalMail(Controller);
    Opportunity_Sales_Team__c ost = new Opportunity_Sales_Team__c(User__c = u1.id ,Opportunity__c = o1.id );
insert ost;
Opportunity_Sales_Team__c ost1 = new Opportunity_Sales_Team__c(contact__c = cnt1.id,Opportunity__c = o1.id);
insert ost1; 
ApexPages.StandardController Controller1 = new ApexPages.StandardController(og);
SendApprovalMail s = new SendApprovalMail(Controller1);
s.sendMail();
s.cancel();
s.back();
s.getwrapper();
//s.setwrapper(r);

SendApprovalMail.Oppwrap p = new SendApprovalMail.Oppwrap('dfgd','fdgd','dfgd','dfgd');

    }
    }