@isTest
private class ConcurCollectUsersPluginTest {

    // These entries must exist and be named exactly as below - see README.Concur
    private static String CONNECTED_APP_NAME = 'Concur';

    private static String ENDPOINT_USER_V3 = 'https://www.concursolutions.com/api/v3.0/common/users';

    // Tests
    @isTest static void testSuccess() {
        // arrange
        ConnectorUtil.HttpResponseGenerator authGen = new ConnectorUtil.HttpResponseGenerator();
        authGen.nextBody = '{"Access_Token":{"Instance_Url":"https://example.org/","Token":"some-token","Expiration_date":"9/23/3000 2:57:31 PM","Refresh_Token":"some-refresh-token"}}';

        ConnectorUtil.HttpResponseGenerator apiGen = new ConnectorUtil.HttpResponseGenerator();
        apiGen.nextBody = '{"Items":[{"LoginID":"ConcurAdmin@d0005524pnbx","EmployeeID":"Concur Administrator","FirstName":"Concur","LastName":"Administrator","MiddleName":"","PrimaryEmail":"ConcurAdmin@d0005524pnbx","Active":true,"CellPhoneNumber":"","OrganizationUnit":null,"ID":null,"URI":null}],"NextPage":null}';

        ConnectorUtil.HttpMultiResponseGenerator generator = new ConnectorUtil.HttpMultiResponseGenerator();
        generator.addGenerator('callout:' + ConnectorUtil.UserProvisioningUtils.TESTING_NAMED_CREDENTIAL, authGen);
        generator.addGenerator(ENDPOINT_USER_V3, apiGen);

        System.Test.setMock(HttpCalloutMock.class, authGen);
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));
    }

    // Tests
    @isTest static void test403HttpResponse() {
        // arrange
        ConnectorUtil.HttpResponseGenerator authGen = new ConnectorUtil.HttpResponseGenerator();
        authGen.nextBody = '{"Access_Token":{"Instance_Url":"https://example.org/","Token":"some-token","Expiration_date":"9/23/3000 2:57:31 PM","Refresh_Token":"some-refresh-token"}}';

        ConnectorUtil.HttpResponseGenerator apiGen = new ConnectorUtil.HttpResponseGenerator(403);
        
        ConnectorUtil.HttpMultiResponseGenerator generator = new ConnectorUtil.HttpMultiResponseGenerator();
        generator.addGenerator('callout:' + ConnectorUtil.UserProvisioningUtils.TESTING_NAMED_CREDENTIAL, authGen);
        generator.addGenerator(ENDPOINT_USER_V3, apiGen);

        System.Test.setMock(HttpCalloutMock.class, authGen);
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Failed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));
    }

    @isTest static void testIncompleteInputParams() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

        // act
        Process.PluginResult response = callPlugin(false);

        // assert
        System.assertEquals('Failed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));
    }

    // Helper methods
    private static Process.PluginResult callPlugin() {
        return callPlugin(true);
    }

    private static Process.PluginResult callPlugin(Boolean validInput) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest(CONNECTED_APP_NAME, 'Reconcile', 'Collecting');
        
        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        if (validInput) {
            inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);
            inputParams.put(ConcurCollectUsersPlugin.PARAM_CONSUMER_KEY, 'some-partner-app-key');
            inputParams.put(ConcurCollectUsersPlugin.PARAM_USER_ENDPOINT, ENDPOINT_USER_V3);
        }
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_RECON_OFFSET, '');

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new ConcurCollectUsersPlugin(), inputParams);
    }
}