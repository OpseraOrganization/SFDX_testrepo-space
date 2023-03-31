@isTest
private class ConcurToggleUserPluginTest {

    private static String ENDPOINT_USER_V1 = 'https://www.concursolutions.com/api/user/v1.0/';
    private static String ENDPOINT_USERS_V1 = 'https://www.concursolutions.com/api/user/v1.0/users/';
    private static String ENDPOINT_USER_V3 = 'https://www.concursolutions.com/api/v3.0/common/users';
    private static String PARTNER_APP_KEY = 'some-partner-app-key';
    
    // Tests
    @isTest static void testToggle() {
        // arrange
        ConnectorUtil.HttpResponseGenerator authGen = new ConnectorUtil.HttpResponseGenerator();
        authGen.nextBody = '{"Access_Token":{"Instance_Url":"https://example.org/","Token":"some-token","Expiration_date":"9/23/3000 2:57:31 PM","Refresh_Token":"some-refresh-token"}}';

        ConnectorUtil.HttpResponseGenerator existingUserGen = new ConnectorUtil.HttpResponseGenerator();
        existingUserGen.nextBody = '{"Items":[{"LoginID":"ConcurAdmin@d0005524pnbx","EmployeeID":"Concur Administrator","FirstName":"Concur","LastName":"Administrator","MiddleName":"","PrimaryEmail":"ConcurAdmin@d0005524pnbx","Active":true,"CellPhoneNumber":"","OrganizationUnit":null,"ID":null,"URI":null}],"NextPage":null}';

        ConnectorUtil.HttpResponseGenerator updateUserGen = new ConnectorUtil.HttpResponseGenerator();
        updateUserGen.nextBody = '{"records-succeeded":1,"records-failed":0,"errors":null,"UsersDetails":[]}';

        ConnectorUtil.HttpMultiResponseGenerator generator = new ConnectorUtil.HttpMultiResponseGenerator();
        generator.addGenerator('callout:' + ConnectorUtil.UserProvisioningUtils.TESTING_NAMED_CREDENTIAL, authGen);
        generator.addGenerator(ENDPOINT_USER_V3 + '?user=' + ConnectorUtil.UserProvisioningTestUtils.EXTERNAL_USER_ID, existingUserGen);
        generator.addGenerator(ENDPOINT_USERS_V1, updateUserGen);

        System.Test.setMock(HttpCalloutMock.class, authGen);
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);
        
        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));
    }

    @isTest static void testIncompleteInputParams() {
        // arrange
        ConnectorUtil.UserProvisioningTestUtils.setMock(new ConnectorUtil.HttpResponseGenerator());

        // act
        Process.PluginResult response = callPlugin(false);

        // assert
        System.assertEquals('Failed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));
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
        System.assertEquals('Failed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));      
    }

    // Helper methods
    private static Process.PluginResult callPlugin() {
        return callPlugin(true);
    }

    private static Process.PluginResult callPlugin(Boolean validInput) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Concur', 'Deactivate');

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);

        // Specify additional required plugin input parameters
        // These are specific to each connector
        if (validInput) {
            inputParams.put(ConcurToggleUserPlugin.PARAM_ENABLE_USER, true);
            inputParams.put(ConcurToggleUserPlugin.PARAM_CONSUMER_KEY, PARTNER_APP_KEY);
            inputParams.put(ConcurToggleUserPlugin.PARAM_USER_ENDPOINT, ENDPOINT_USER_V1);
            inputParams.put(ConcurUpdateUserPlugin.PARAM_USER_ENDPOINT_V3, ENDPOINT_USER_V3);
        }

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new ConcurToggleUserPlugin(), inputParams);
    }    
}