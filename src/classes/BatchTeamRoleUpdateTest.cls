@isTest
public class BatchTeamRoleUpdateTest{ 
/*static testMethod void batchteamroleexecute()
{
 list <AccountTeamMember> scope =new list <AccountTeamMember>();
 
 Profile p = [select id from profile where name='System Administrator' limit 1];
 User usr = new User();
        usr.alias = 'dhivya';
        usr.email = 'dhivya123@test.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='vnv';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.profileid = p.Id;
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='standarduser@testing.com';
        usr.isactive=true;
        insert usr;
          User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
System.runAs ( thisUser ) {       
        Test.StartTest();
Account AccRec = new Account();
AccRec.name='Acc_Text_rec';
AccRec.Type='OEM';
AccRec.Strategic_Business_Unit__c='ATR';
AccRec.CBT__c='Airbus';
AccRec.Customer_Status__c='Active';
AccRec.Region_Name__c='Americas';
AccRec.Sub_Region_Name__c='Canada';
AccRec.Service_Level__c='Standard';

insert AccRec;
AccountTeamMember am = new AccountTeamMember();
        am.UserId = usr.id;
        //am.User.name=usr.name;
        am.TeamMemberRole = 'Customer Service Project Manager (CSPM)';
        am.AccountId = AccRec.id;
        insert am;
        scope.add(am);
        if(am.TeamMemberRole=='Customer Service Project Manager (CSPM)')
        {
        usr.Account_Team_Member_Role__c='Customer Service Project Manager (CSPM)';
        }
        update usr;
        
        batchteamroleupdate testing1= new batchteamroleupdate ();      
        ID batchprocessid = Database.executeBatch(testing1);
        
        batchteamroleupdate rem = new batchteamroleupdate();
        String sch = '0 24 17 19 08 ?';
        System.Schedule('Batchroleupdate-Testing', sch, rem );    
       // usr.Account_Team_Member_Role__c=am.TeamMemberRole ; 
       Test.StopTest(); 
}
}*/
}