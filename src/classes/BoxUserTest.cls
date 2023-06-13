@isTest
private class BoxUserTest {
    
    @isTest static void testParse() {
        // arrange
        String json = '{"type":"user","id":"246419014","name":"Daisy Jensen","login":"daisypop89@gmail.com","created_at":"2015-09-01T14:29:10-07:00","modified_at":"2015-09-01T14:29:11-07:00","language":"en","timezone":"America/Los_Angeles","space_amount":5368709120,"space_used":0,"max_upload_size":2147483648,"status":"active","job_title":"","phone":"555-555-5555","address":"555 Box Lane","avatar_url":"https://app.box.com/api/avatar/large/246419014"}';
        
        // act
        BoxUser obj = BoxUser.parse(json);
        
        // assert
        System.assert(obj != null);
        System.assert(obj.user_type == 'user');
        System.assert(obj.id == '246419014');
    }

    @isTest static void testSerializeWithNulls() {
        // arrange
        BoxUser user = new BoxUser();
        
        // act
        String payload = user.serialize();

        // assert
        Map<String, Object> payloadData = (Map<String, Object>)JSON.deserializeUntyped(payload);

        // test properties that exist for BoxUser
        System.assertEquals(false, payloadData.containsKey('job_title'));
        System.assertEquals(false, payloadData.containsKey('phone'));
    }
    
}