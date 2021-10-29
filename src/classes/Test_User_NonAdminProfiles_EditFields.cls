@isTest

private class Test_User_NonAdminProfiles_EditFields{
    static testMethod void User_NonAdminProfiles_EditFields_TM(){
        Profile pf = [select id from Profile where name = 'sales admin'];
        User usr = new User(
            LastName = 'Test UserSol',Username = 'tu1cso@test.com',
            Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1sol' ,
            TimeZoneSidKey = 'America/Los_Angeles',Functional_Role__c='tst',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
            EmployeeNumber='H123456',ProfileId = pf.Id,Fax='123',Phone='080',MobilePhone='8878',Title='test',
            UserPermissionsOfflineUser=false,US_Permanent_Resident_Card_Expiry__c=system.today(),US_Permanent_Resident__c=true,
            Citizenship_Status_Descr__c='U.S. Citizen',Citizenship_Cntry__c='Bangalore', LanguageLocaleKey = 'en_US',
            SBU_User__c = 'D&S',KCS_level__c = 'Other',KCS_Coach__c = '005300000041m9d',Support_Level__c = '1',Primary_Manager_Name__c = 'test'
        );
        insert usr;
        system.runas(usr)
        {
            update usr;
        }
    }
    
    static testMethod void User_NonAdminProfiles_EditFields_TM2(){
        Profile pf = [select id from Profile where name ='GTO DS FSE (US)' limit 1];
        User usr = new User(
            LastName = 'Test UserSol',Username = 'tu1cso@test.com',Email = 'testuser@test.com',Alias = 'tu1',
            CommunityNickname= 'tu1sol',TimeZoneSidKey = 'America/Los_Angeles',Functional_Role__c='tst',LocaleSidKey='en_US',
            EmailEncodingKey= 'ISO-8859-1',EmployeeNumber='H123456',ProfileId = pf.Id,Fax='123',Phone='080',
            MobilePhone='8878',Title='test',UserPermissionsOfflineUser=false,US_Permanent_Resident_Card_Expiry__c=system.today(),
            US_Permanent_Resident__c=true,Citizenship_Status_Descr__c='U.S. Citizen',Citizenship_Cntry__c='Bangalore',
            LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S'
        );
        insert usr;
        system.runas(usr)
        {
            update usr;
        }     
    }
}