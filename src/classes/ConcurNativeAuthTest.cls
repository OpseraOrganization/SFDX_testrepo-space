@isTest
private class ConcurNativeAuthTest {

    @isTest static void testGetAccessToken() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        generator.nextBody = '{"Access_Token":{"Instance_Url":"https://example.org/","Token":"some-token","Expiration_date":"9/23/2016 2:57:31 PM","Refresh_Token":"some-refresh-token"}}';
	System.Test.setMock(HttpCalloutMock.class, generator);

        // no real values needed below - calls are mocked
        String namedCredential = 'callout:https://example.org';
        String consumerKey = 'some-partner-app-key';

        // act
        ConcurNativeAuth.AccessToken obj = ConcurNativeAuth.getAccessToken(namedCredential, consumerKey);

        // assert
        System.assertNotEquals(null, obj);
        System.assertEquals('some-token', obj.token);
        System.assertEquals('some-refresh-token', obj.refresh_Token);
        System.assertEquals('https://example.org/', obj.instance_Url);
    }
     
    @isTest static void test403HttpResponse() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator(403);
        System.Test.setMock(HttpCalloutMock.class, generator);

        // no real values needed below - calls are mocked
        String namedCredential = 'callout:https://example.org';
        String consumerKey = 'some-partner-app-key';

        // act
        try {
            ConcurNativeAuth.AccessToken obj = ConcurNativeAuth.getAccessToken(namedCredential, consumerKey);
        } catch (CalloutException e) {
            // Exit the test if the expected CalloutException is thrown.
            return;
        }

        // assert
        // Fail the test if the expected CalloutException is not thrown.
        System.assert(false, 'A CalloutException was expected, but was not thrown.');   
    }

}