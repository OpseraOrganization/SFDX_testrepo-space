@isTest
private class ConcurCreateUserPluginTest {

    // These entries must exist and be named exactly as below - see README.Concur
    private static String CONNECTED_APP_NAME = 'Concur';

    private static String ENDPOINT_USER_V1 = 'https://www.concursolutions.com/api/user/v1.0/';
    private static String ENDPOINT_USERS_V1 = 'https://www.concursolutions.com/api/user/v1.0/users/';
    private static String PARTNER_APP_KEY = 'some-partner-app-key';
    private static String USER_FIRSTNAME = 'John';
    private static String USER_LASTNAME = 'Doe';
    private static String USER_EMAIL = 'jdoe@example.org';

    // Tests
    @isTest static void testCreate() {
        // arrange
        ConnectorUtil.HttpResponseGenerator authGen = new ConnectorUtil.HttpResponseGenerator();
        authGen.nextBody = '{"Access_Token":{"Instance_Url":"https://example.org/","Token":"some-token","Expiration_date":"9/23/3000 2:57:31 PM","Refresh_Token":"some-refresh-token"}}';

        ConnectorUtil.HttpResponseGenerator apiGen = new ConnectorUtil.HttpResponseGenerator();
        apiGen.nextBody = '{"records-succeeded":1,"records-failed":0,"errors":null,"UsersDetails":[]}';

        ConnectorUtil.HttpMultiResponseGenerator generator = new ConnectorUtil.HttpMultiResponseGenerator();
        generator.addGenerator('callout:' + ConnectorUtil.UserProvisioningUtils.TESTING_NAMED_CREDENTIAL, authGen);
        generator.addGenerator(ENDPOINT_USERS_V1, apiGen);

        System.Test.setMock(HttpCalloutMock.class, authGen);
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));
        System.assertEquals('daisypop89@gmail.com', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERID));
        System.assertEquals('daisypop89@gmail.com', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERNAME));
        System.assertEquals('daisypop89@gmail.com', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_EMAIL));
        System.assertEquals('Daisy', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_FIRSTNAME));
        System.assertEquals('Jensen', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_LASTNAME));                        
    }

    @isTest static void testFailedCreate() {
        // arrange        
        ConnectorUtil.HttpResponseGenerator authGen = new ConnectorUtil.HttpResponseGenerator();
        authGen.nextBody = '{"Access_Token":{"Instance_Url":"https://example.org/","Token":"some-token","Expiration_date":"9/23/3000 2:57:31 PM","Refresh_Token":"some-refresh-token"}}';

        ConnectorUtil.HttpResponseGenerator apiGen = new ConnectorUtil.HttpResponseGenerator();
        apiGen.nextBody = '{"records-succeeded":2,"records-failed":1,"errors":null,"UsersDetails":[]}';

        ConnectorUtil.HttpMultiResponseGenerator generator = new ConnectorUtil.HttpMultiResponseGenerator();
        generator.addGenerator('callout:' + ConnectorUtil.UserProvisioningUtils.TESTING_NAMED_CREDENTIAL, authGen);
        generator.addGenerator(ENDPOINT_USERS_V1, apiGen);

        System.Test.setMock(HttpCalloutMock.class, authGen);
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Failed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));                      
    }

    @isTest static void testIncompleteInputParams() {
        // arrange
        ConnectorUtil.UserProvisioningTestUtils.setMock(new ConnectorUtil.HttpResponseGenerator());

        // act
        Process.PluginResult response = callPlugin(false);

        // assert
        System.assertEquals('Failed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS), 'Status Not As Expected');
    }

    @isTest static void test403HttpResponse() {
        // arrange
        ConnectorUtil.HttpResponseGenerator authGen = new ConnectorUtil.HttpResponseGenerator();
        authGen.nextBody = '{"Access_Token":{"Instance_Url":"https://example.org/","Token":"some-token","Expiration_date":"9/23/3000 2:57:31 PM","Refresh_Token":"some-refresh-token"}}';

        ConnectorUtil.HttpMultiResponseGenerator generator = new ConnectorUtil.HttpMultiResponseGenerator();
        generator.addGenerator('callout:' + ConnectorUtil.UserProvisioningUtils.TESTING_NAMED_CREDENTIAL, authGen);
        generator.addGenerator(ENDPOINT_USERS_V1, new ConnectorUtil.HttpResponseGenerator(403));

        System.Test.setMock(HttpCalloutMock.class, authGen);
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);
        
        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Failed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS), 'Status Not As Expected');      
    }

    // Helper methods
    private static Process.PluginResult callPlugin() {
        return callPlugin(true);
    }

    private static Process.PluginResult callPlugin(Boolean validInput) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest(CONNECTED_APP_NAME, 'Create');
        
        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);

        // Define user account to create - we mock the request & response
        // These are specific to each connector
        if (validInput) {
            inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, '<batch xmlns="http://www.concursolutions.com/api/user/2011/02"><UserProfile><FeedRecordNumber>1</FeedRecordNumber><LocaleName>en_US</LocaleName><CrnKey>USD</CrnKey><Custom21>US</Custom21><CtryCode>US</CtryCode><LedgerCode>Default</LedgerCode><EmpId>daisypop89@gmail.com</EmpId><LoginId>daisypop89@gmail.com</LoginId><EmailAddress>daisypop89@gmail.com</EmailAddress><Active>Y</Active><Password>P4ssw0rd!</Password><FirstName>Daisy</FirstName><LastName>Jensen</LastName></UserProfile></batch>');
            inputParams.put(ConcurCreateUserPlugin.PARAM_CONSUMER_KEY, PARTNER_APP_KEY);
            inputParams.put(ConcurCreateUserPlugin.PARAM_USER_ENDPOINT, ENDPOINT_USER_V1);
        }

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new ConcurCreateUserPlugin(), inputParams);
    }
}