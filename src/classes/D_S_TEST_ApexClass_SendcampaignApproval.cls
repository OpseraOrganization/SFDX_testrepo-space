/** * File Name:  D_S_TEST_ApexClass_SendcampaignApproval
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
public class D_S_TEST_ApexClass_SendcampaignApproval
{
static testmethod void SendcampaignApprovalMail()
{
Profile pf= [select id from Profile where name = 'Sales D&S'];
Contact cnt1 = new Contact(LastName = 'Test contact',firstname='Test',Contact_Is_Employee__c = true,phone_3__c='89652', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567' );
insert cnt1;
User u1 = new User(LastName = 'Test User',Username = 'testuser@test.com.honeywell',Email = 'testuser@test.com',Alias = 'tuser' ,CommunityNickname= 'tuser' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US');
insert u1;
Campaign  cmp = new Campaign(name='test campaign');
insert cmp;
Campaign_Gate__c cg = new Campaign_Gate__c(name = 'test campaign gate ', campaign__c = cmp.ID); 
insert cg ;
Campaign_Team__c ct1 = new Campaign_Team__c(team_user__c = u1.id,campaign__c = cmp.Id);
insert ct1;
Campaign_Team__c ct2 = new Campaign_Team__c(contact__c = cnt1.id,campaign__c = cmp.Id);
insert ct2;
Campaign_Gate_Approval_History__c ch = new Campaign_Gate_Approval_History__c(Campaign_Team_Name__c = ct1.name,Campaign_Phase__c = cg.Id);
insert ch;
System.currentPagereference().getParameters().put('Id', cg.Id);
//SendcampaignApprovalMail s  =new SendcampaignApprovalMail( cg.Id);
system.debug('*************************'+cg);
ApexPages.StandardController Controller = new ApexPages.StandardController(cg);
SendcampaignApprovalMail s = new SendcampaignApprovalMail(Controller);
s.sendMail();
s.cancelmail();
s.back();
System.assertEquals(null,ch.Approval_Status__c);
}
}