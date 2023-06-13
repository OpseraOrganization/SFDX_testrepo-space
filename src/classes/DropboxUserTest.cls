@isTest
private class DropboxUserTest {
    
    @isTest static void testParse() {
        // arrange
        String json = '{"profile":{"status":"active","surname":"Jensen","email_verified":true,"given_name":"Daisy","groups":[],"member_id":"dbmid:AAAp4WHvplm7lcooX4Nnz61l1q5mG7M7Cao","external_id":null,"email":"daisypop89@gmail.com"},"permissions":{"is_admin":true}}';
        
        // act
        DropboxUser obj = DropboxUser.parse(json);
        
        // assert
        System.assertNotEquals(null, obj);
        System.assertEquals('dbmid:AAAp4WHvplm7lcooX4Nnz61l1q5mG7M7Cao', obj.profile.member_id);
        System.assertEquals('daisypop89@gmail.com', obj.profile.email);
    }
    
    @isTest static void testAddRequestConstructor() {
        // arrange
        String firstName = 'First';
        String lastName = 'Last';
        String emailAddress = 'first.name@example.org';
        Boolean sendEmailDefault = true;

        // act
        DropboxUser.AddRequest addRequest = new DropboxUser.AddRequest(firstName, lastName, emailAddress);
        
        // assert
        System.assertEquals(firstName, addRequest.member_given_name);
        System.assertEquals(lastName, addRequest.member_surname);
        System.assertEquals(emailAddress, addRequest.member_email);
        System.assertEquals(sendEmailDefault, addRequest.send_welcome_email);        
    }

    @isTest static void testSerializeWithNulls() {
        // arrange
        DropboxUser.SetProfileRequest user = new DropboxUser.SetProfileRequest();
        
        // act
        String payload = user.serialize();

        // assert
        Map<String, Object> payloadData = (Map<String, Object>)JSON.deserializeUntyped(payload);

        // test properties that exist for DropboxUser.SetProfileRequest
        System.assert(!payloadData.containsKey('new_email'));
        System.assert(!payloadData.containsKey('new_external_id'));
        System.assert(!payloadData.containsKey('member_id'));
    }
    
}