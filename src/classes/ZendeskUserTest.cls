@isTest
private class ZendeskUserTest {
    
    @isTest static void testParse() {
        // arrange
        String json = '{"id":1478729297,"url":"https://my-instance.zendesk.com/api/v2/users/1478729297.json","name":"Daisy Jensen","email":"daisypop89@gmail.com","created_at":"2015-09-14T14:20:18Z","updated_at":"2015-09-18T13:44:27Z","time_zone":"Atlantic Time (Canada)","phone":null,"photo":null,"locale_id":1,"locale":"en-US","organization_id":757031337,"role":"admin","verified":true,"external_id":null,"tags":[],"alias":null,"active":true,"shared":false,"shared_agent":false,"last_login_at":"2015-09-18T13:44:27Z","two_factor_auth_enabled":null,"signature":null,"details":null,"notes":null,"custom_role_id":null,"moderator":true,"ticket_restriction":null,"only_private_comments":false,"restricted_agent":false,"suspended":false,"chat_only":false,"user_fields":{}}';
        
        // act
        ZendeskUser obj = ZendeskUser.parse(json);
        
        // assert
        System.assertNotEquals(null, obj);
        System.assertEquals(1478729297, obj.id);
        System.assertEquals('daisypop89@gmail.com', obj.email);
    }
    
    @isTest static void testParseLongId() {
        // arrange
        // test a Long specifically
        Long id = 4495674377L;
        String json = '{"id":' + String.valueOf(id) + ',"url":"https://my-instance.zendesk.com/api/v2/users/1478729297.json","name":"Daisy Jensen","email":"daisypop89@gmail.com","created_at":"2015-09-14T14:20:18Z","updated_at":"2015-09-18T13:44:27Z","time_zone":"Atlantic Time (Canada)","phone":null,"photo":null,"locale_id":1,"locale":"en-US","organization_id":757031337,"role":"admin","verified":true,"external_id":null,"tags":[],"alias":null,"active":true,"shared":false,"shared_agent":false,"last_login_at":"2015-09-18T13:44:27Z","two_factor_auth_enabled":null,"signature":null,"details":null,"notes":null,"custom_role_id":null,"moderator":true,"ticket_restriction":null,"only_private_comments":false,"restricted_agent":false,"suspended":false,"chat_only":false,"user_fields":{}}';
        
        // act
        ZendeskUser obj = ZendeskUser.parse(json);
        
        // assert
        System.assertNotEquals(null, obj);
        System.assertEquals(id, obj.id);
        System.assertEquals('daisypop89@gmail.com', obj.email);
    }
    
}