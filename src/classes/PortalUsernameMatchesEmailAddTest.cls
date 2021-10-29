@isTest
private class PortalUsernameMatchesEmailAddTest {

    /*
    static testMethod void testUserUpdate() {
        String email = 'foo' + Math.random() + '@example.org';
        User u = new User();
        u.Username = email;
        u.Email = email;
        u.CommunityNickname = 'fooNickName';
        // lastName is a required field on user, but if it isn't specified, it gets defaulted to the username somewhere
        String accountId = getSiteSetup().PortalAccount__r.Id;
        String userId = Site.createPortalUser(u, accountId, 'password');
        String username = 'bar' + Math.random() + '@example.org';
        //u = new User();
        //u.Id = userId;
        u.Username = username;
        update u;
    }
    */

    static testMethod void testRegularAppUserUpdate() {
        User u = IdeaTestUtil.makeUser();
        String oldUsername = ([select username from user where id = :u.id]).username;
        String newUsername = 'bar' + Math.random() + '@example.org';
        u.username = newUsername;
        update u;
        String actualNewUsername = ([select username from user where id = :u.id]).username;
        System.assertEquals(newUsername, actualNewUsername);
        System.assert(newUsername != oldUsername);
    }
    static testMethod void updateUser() {
        Profile p = [ select Id from Profile where Name=:'System Administrator'];
        User u = new User(
            Username = 'test1@test.com.dspc',
            Email = 'test@test.com',
            LastName = 'lastName',
            Alias = 'alias',
            ProfileID = p.id,
            PortalRole = 'Manager',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey='UTF-8',
            PS_Manager_EID__c ='H185868'
        );
        insert u; 
        string oldPSManagerId = ([select PS_Manager_EID__c from user where id = :u.id]).PS_Manager_EID__c ;
        string newPSManagerId = 'E881182';
        u.PS_Manager_EID__c = newPSManagerId ;
        update u;       
    }

}