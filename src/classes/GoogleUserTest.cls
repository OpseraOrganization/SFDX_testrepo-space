@isTest
private class GoogleUserTest {

    @isTest static void testParse() {
        // arrange
        String json = '{"kind":"admin#directory#user","id":"111654564594313286254","etag":"\\"wp-nv9JMeB-zUDJ9G-GPqjRzodU/UqJnasF2vGI7xmKmPTPUhstT7LQ\\"","primaryEmail":"daisypop89@gmail.com","name":{"givenName":"Test","familyName":"User","fullName":"Test User"},"isAdmin":false,"isDelegatedAdmin":false,"lastLoginTime":"1970-01-01T00:00:00.000Z","creationTime":"2015-05-12T22:48:44.000Z","agreedToTerms":false,"suspended":true,"suspensionReason":"ADMIN","changePasswordAtNextLogin":false,"ipWhitelisted":false,"emails":[{"address":"daisypop89@gmail.com","primary":true}],"nonEditableAliases":["idf-test-user@example.org","idf-test-user@example.net"],"customerId":"C04gock8x","orgUnitPath":"/","isMailboxSetup":true,"includeInGlobalAddressList":true}';

        // act
        GoogleUser obj = GoogleUser.parse(json);

        // assert
        System.assertNotEquals(null, obj);
        System.assertEquals('111654564594313286254', obj.id);
        System.assertEquals('daisypop89@gmail.com', obj.primaryEmail);
    }

    @isTest static void testSerializeWithNulls() {
        // arrange
        GoogleUser user = new GoogleUser();
        
        // act
        String payload = user.serialize();

        // assert
        Map<String, Object> payloadData = (Map<String, Object>)JSON.deserializeUntyped(payload);

        // test properties that exist for GoogleUser
        System.assert(!payloadData.containsKey('suspended'));
        System.assert(!payloadData.containsKey('password'));
    }

}