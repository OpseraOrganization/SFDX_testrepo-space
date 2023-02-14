@isTest
private class ZendeskUsersTest {
    
    @isTest static void testParse() {
        // arrange
        String json = '{"users":[{"id":1478729297,"url":"https://my-instance.zendesk.com/api/v2/users/1478729297.json","name":"Daisy Jensen","email":"daisypop89@gmail.com","created_at":"2015-09-14T14:20:18Z","updated_at":"2015-09-17T15:56:36Z","time_zone":"Atlantic Time (Canada)","phone":null,"photo":null,"locale_id":1,"locale":"en-US","organization_id":757031337,"role":"admin","verified":true,"external_id":null,"tags":[],"alias":null,"active":true,"shared":false,"shared_agent":false,"last_login_at":"2015-09-17T15:56:36Z","two_factor_auth_enabled":null,"signature":null,"details":null,"notes":null,"custom_role_id":null,"moderator":true,"ticket_restriction":null,"only_private_comments":false,"restricted_agent":false,"suspended":false,"chat_only":false,"user_fields":{}}],"next_page":"https://my-instance.zendesk.com/api/v2/users.json?page=2&per_page=1","previous_page":null,"count":2}';
        
        // act
        ZendeskUsers obj = ZendeskUsers.parse(json);

        // assert
        System.assertNotEquals(null, obj);
        System.assertNotEquals(null, obj.next_page);
        System.assertEquals(1, obj.users.size());
    }
    
}