@isTest

private class User_NonAdminProfiles_EditFields_TC{

static testMethod void User_NonAdminProfiles_EditFields_TM()
    {
        Profile pf = [select id from Profile where name = 'Sales Admin'];
        User usr = new User(LastName = 'Test UserSol',Username = 'tu1cso@test.com',
        Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1sol' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
        ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr;
        system.debug('aaaaaaa'+usr.ProfileId);
        system.runas(usr)
        {
             usr.CommunityNickname = 'Test Community';
             try{
                 Update usr;
             }
             catch(System.DMLException e){
                 System.assert(
                 e.getMessage().contains(
                 'You are not authorized to change this information'),
                 e.getMessage());
             }
        }
        
        Profile pf2 = [select id from Profile where name = 'GTO DS FSE (US)'];
        User usr2 = new User(LastName = 'Test UserSol2',Username = 'tu2cso@test.com',
        Email = 'testuser@test2.com',Alias = 'tu2' ,CommunityNickname= 't2sol' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
        ProfileId = pf2.Id, Country = 'India', LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',
        AboutMe = 'Test about me'
        );
        insert usr2;
        system.debug('hhhhhhh'+usr2.ProfileId );
        system.runas(usr2)
        {
             usr2.Country = 'Brazil';
             Update usr2;
        }
    }
}