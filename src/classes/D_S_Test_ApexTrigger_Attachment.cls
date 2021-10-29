/** * File Name: D_S_Test_ApexTrigger_Attachment
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
public class D_S_Test_ApexTrigger_Attachment
{
static testmethod void PlannedMeeting_Attachement()
{
Profile pf = [select name from Profile where name = 'D&S Sales'];
User u1 = new User(LastName = 'Test User',Username = 'testuser552@test.com.honeywell',Email = 'testuser@test.com',Alias = 'tuser' ,CommunityNickname= 'tuser' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c='testsbu',CBT__c='testcbt',CBT_Team__c ='testcbtteam');
insert u1;
Date d1 =Date.newInstance(2009,08,12);
Date d2 =Date.newInstance(2009,08,12);
Planned_Meeting__c p =new Planned_Meeting__c(Name = 'test meeting' , ASSIGNED_TO__C = u1.Id,start__c = d1,end__c = d2);
insert p;
//Trigger covered - Attachment_UpdateName

Attachment att = new Attachment(Name='Test attachment',parentid= p.Id);
att.body = Blob.valueOf( 'this is an attachment test' );
insert att;
att.name='TEst update';
update att;
delete att;
}
}