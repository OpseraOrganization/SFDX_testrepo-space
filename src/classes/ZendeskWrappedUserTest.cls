@isTest
private class ZendeskWrappedUserTest {
    
    @isTest static void testParse() {
        // arrange
        String json = '{"user":{"id":1478729297,"url":"https://my-instance.zendesk.com/api/v2/users/1478729297.json","name":"Daisy Jensen","email":"daisypop89@gmail.com","created_at":"2015-09-14T14:20:18Z","updated_at":"2015-09-18T13:44:27Z","time_zone":"Atlantic Time (Canada)","phone":null,"photo":null,"locale_id":1,"locale":"en-US","organization_id":757031337,"role":"admin","verified":true,"external_id":null,"tags":[],"alias":null,"active":true,"shared":false,"shared_agent":false,"last_login_at":"2015-09-18T13:44:27Z","two_factor_auth_enabled":null,"signature":null,"details":null,"notes":null,"custom_role_id":null,"moderator":true,"ticket_restriction":null,"only_private_comments":false,"restricted_agent":false,"suspended":false,"chat_only":false,"user_fields":{}}}';
        
        // act
        ZendeskWrappedUser obj = ZendeskWrappedUser.parse(json);
        
        // assert
        System.assertNotEquals(null, obj);
        System.assertNotEquals(null, obj.user);
        System.assertEquals(1478729297, obj.user.id);
        System.assertEquals('daisypop89@gmail.com', obj.user.email);
    }

    @isTest static void testSerializeWithNulls() {
        // arrange
        ZendeskWrappedUser user = new ZendeskWrappedUser();
        
        // act
        String payload = user.serialize();

        // assert
        Map<String, Object> wrappedData = (Map<String, Object>)JSON.deserializeUntyped(payload);
        Map<String, Object> payloadData = (Map<String, Object>)wrappedData.get('user');        

        // test properties that exist for ZendeskWrappedUser
        System.assert(!payloadData.containsKey('name'));
        System.assert(!payloadData.containsKey('email'));
    }
    
}