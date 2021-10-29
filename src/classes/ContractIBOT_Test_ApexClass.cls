/** * File Name: ContractIBOT_Test_ApexClass
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class ContractIBOT_Test_ApexClass {
static testmethod void testContractIBOT(){
Profile pf= [select id from Profile where name = 'System Administrator'];
User usr = new User(LastName = 'Test UserCSO',Username = 'tu1cso@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr;

Account act=new Account(name='Test');
insert act;
// creating team member
AccountTeamMember actMmbr= new AccountTeamMember(TeamMemberRole='Contract Manager',accountId=act.Id,
userId=usr.Id);
insert actMmbr;
update act;


Contract cont= new Contract (name='Test',accountId= act.Id);
insert cont;
cont.Contract_3_months_Expiry__C=true;
cont.Contract_6_months_Expiry__C=true;

update cont;
}

}// end of class