@isTest
private class DropboxUsersTest {
    
    @isTest static void testParse() {
        // arrange
        String json = '{"has_more":false,"cursor":"AACIOrKLQ2yrSCibTRDytuUZLadI60HLQebkz58wlUuoaoJEmRlJ8oKPT8WTqiYM8R877kZxZAFeHJ7g9PsUwU32","members":[{"profile":{"status":"active","surname":"Jensen","email_verified":true,"given_name":"Daisy","groups":[],"member_id":"dbmid:AAAp4WHvplm7lcooX4Nnz61l1q5mG7M7Cao","external_id":null,"email":"daisypop89@gmail.com"},"permissions":{"is_admin":true}}]}';
        
        // act
        DropboxUsers obj = DropboxUsers.parse(json);

        // assert
        System.assertNotEquals(null, obj);
        System.assertNotEquals(null, obj.cursor);
        System.assertEquals(1, obj.members.size());
    }
    
}