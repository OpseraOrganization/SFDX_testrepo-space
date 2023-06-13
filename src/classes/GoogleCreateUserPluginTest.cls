@isTest
private class GoogleCreateUserPluginTest {

    // Tests
    @isTest static void testCreate() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        generator.nextBody = '{"kind":"admin#directory#user","id":"111654564594313286254","etag":"\\"wp-nv9JMeB-zUDJ9G-GPqjRzodU/UqJnasF2vGI7xmKmPTPUhstT7LQ\\"","primaryEmail":"daisypop89@gmail.com","name":{"givenName":"Daisy","familyName":"Jensen","fullName":"Daisy Jensen"},"isAdmin":false,"isDelegatedAdmin":false,"lastLoginTime":"1970-01-01T00:00:00.000Z","creationTime":"2015-05-12T22:48:44.000Z","agreedToTerms":false,"suspended":true,"suspensionReason":"ADMIN","changePasswordAtNextLogin":false,"ipWhitelisted":false,"emails":[{"address":"daisypop89@gmail.com","primary":true}],"nonEditableAliases":["idf-test-user@example.org","idf-test-user@example.net"],"customerId":"C04gock8x","orgUnitPath":"/","isMailboxSetup":true,"includeInGlobalAddressList":true}';
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));
        System.assertEquals('111654564594313286254', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERID));
        System.assertEquals('daisypop89@gmail.com', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERNAME));
        System.assertEquals('daisypop89@gmail.com', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_EMAIL));
        System.assertEquals('Daisy', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_FIRSTNAME));
        System.assertEquals('Jensen', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_LASTNAME));
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
        ConnectorUtil.UserProvisioningTestUtils.setMock(new ConnectorUtil.HttpResponseGenerator(403));

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
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Google', 'Create');

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);

        // Define user account to create - we mock the request & response
        if (validInput) {
            inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, '{\n  "primaryEmail" : "daisypop89@example.org",\n  "password" : "P4ssw0rd!",\n  "suspended" : false,\n  "changePasswordAtNextLogin" : true,\n  "name" : {\n    "familyName" : "Jensen",\n    "givenName" : "Daisy"\n  }\n}');
        }

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new GoogleCreateUserPlugin(), inputParams);
    }
}