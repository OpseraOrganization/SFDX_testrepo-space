@isTest
private class Office365CollectUsersPluginTest {

    // Tests
    @isTest static void testSuccess() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        generator.nextBody = '{"odata.metadata":"https://graph.windows.net/my-instance.onmicrosoft.com/$metadata#directoryObjects/Microsoft.WindowsAzure.ActiveDirectory.User","value":[{"odata.type":"Microsoft.WindowsAzure.ActiveDirectory.User","objectType":"User","objectId":"35a545ad-4799-4e3f-99c5-8f1de07312dd","accountEnabled":true,"assignedLicenses":[],"assignedPlans":[],"city":null,"country":null,"department":null,"dirSyncEnabled":null,"displayName":"Daisy Jensen","facsimileTelephoneNumber":null,"givenName":"Daisy","jobTitle":null,"lastDirSyncTime":null,"mail":null,"mailNickname":"daisypop89_gmail.com#EXT#","mobile":null,"otherMails":["daisypop89@gmail.com"],"passwordPolicies":null,"passwordProfile":null,"physicalDeliveryOfficeName":null,"postalCode":null,"preferredLanguage":null,"provisionedPlans":[],"provisioningErrors":[],"proxyAddresses":[],"state":null,"streetAddress":null,"surname":"Jensen","telephoneNumber":null,"usageLocation":null,"userPrincipalName":"daisypop89_gmail.com#EXT#@my-instance.onmicrosoft.com"},{"odata.type":"Microsoft.WindowsAzure.ActiveDirectory.User","objectType":"User","objectId":"74380f66-7eee-4afa-831c-e3b164b214ff","accountEnabled":true,"assignedLicenses":[],"assignedPlans":[],"city":null,"country":null,"department":null,"dirSyncEnabled":null,"displayName":"Some User","facsimileTelephoneNumber":null,"givenName":null,"jobTitle":null,"lastDirSyncTime":null,"mail":null,"mailNickname":"someuser","mobile":null,"otherMails":["daisypop89@gmail.com"],"passwordPolicies":null,"passwordProfile":null,"physicalDeliveryOfficeName":null,"postalCode":null,"preferredLanguage":null,"provisionedPlans":[],"provisioningErrors":[],"proxyAddresses":[],"state":null,"streetAddress":null,"surname":null,"telephoneNumber":null,"usageLocation":null,"userPrincipalName":"someuser@my-instance.onmicrosoft.com"}]}';
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS), 'Status Not As Expected');

        // ensure API version was specified
        System.PageReference pageRef = new System.PageReference(generator.firstRequest.getEndpoint());
        Map<String, String> params = pageRef.getParameters();
        String apiVersion = params.get('api-version');
        System.assertEquals(Office365UsersUtility.GRAPH_API_VERSION, apiVersion);
    }

    @isTest static void test403HttpResponse() {
        // arrange
        ConnectorUtil.UserProvisioningTestUtils.setMock(new ConnectorUtil.HttpResponseGenerator(403));

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Failed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));
    }

    @isTest static void testException() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

        // act
        Process.PluginResult response = callPlugin(false);

        // assert
        System.assertEquals('Failed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS), 'Status Not As Expected');
    }

    // Helper methods
    private static Process.PluginResult callPlugin() {
        return callPlugin(true);
    }

    private static Process.PluginResult callPlugin(Boolean validInput) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Office365', 'Reconcile', 'Collecting');
        
        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        if (validInput) {
            inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);
        }
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_RECON_OFFSET, '');

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new Office365CollectUsersPlugin(), inputParams);
    }
}