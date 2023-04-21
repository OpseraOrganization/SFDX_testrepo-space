@isTest
private class Office365CreateUserPluginTest {

    // Tests
    @isTest static void testCreate() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        generator.nextBody = '{"odata.metadata":"https://graph.windows.net/my-instance.onmicrosoft.com/$metadata#directoryObjects/Microsoft.WindowsAzure.ActiveDirectory.User/@Element","odata.type":"Microsoft.WindowsAzure.ActiveDirectory.User","objectType":"User","objectId":"74380f66-7eee-4afa-831c-e3b164b214ff","accountEnabled":true,"assignedLicenses":[],"assignedPlans":[],"city":null,"country":null,"department":null,"dirSyncEnabled":null,"displayName":"Some User","facsimileTelephoneNumber":null,"givenName":"Some","jobTitle":null,"lastDirSyncTime":null,"mail":null,"mailNickname":"someuser","mobile":null,"otherMails":["daisypop89@gmail.com"],"passwordPolicies":null,"passwordProfile":null,"physicalDeliveryOfficeName":null,"postalCode":null,"preferredLanguage":null,"provisionedPlans":[],"provisioningErrors":[],"proxyAddresses":[],"state":null,"streetAddress":null,"surname":"User","telephoneNumber":null,"usageLocation":null,"userPrincipalName":"someuser@my-instance.onmicrosoft.com"}';
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));
        System.assertEquals('74380f66-7eee-4afa-831c-e3b164b214ff', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERID));
        System.assertEquals('someuser@my-instance.onmicrosoft.com', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERNAME));
        System.assertEquals('someuser@my-instance.onmicrosoft.com', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_EMAIL));
        System.assertEquals('Some', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_FIRSTNAME));
        System.assertEquals('User', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_LASTNAME));  

        // ensure API version was specified
        System.PageReference pageRef = new System.PageReference(generator.firstRequest.getEndpoint());
        Map<String, String> params = pageRef.getParameters();
        String apiVersion = params.get('api-version');
        System.assertEquals(Office365UsersUtility.GRAPH_API_VERSION, apiVersion);                      
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
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Office365', 'Create');
        
        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);

        // Define user account to create - we mock the request & response
        // These are specific to each connector
        if (validInput) {
            inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, '{\n  "displayName" : "Daisy Jensen",\n  "givenName" : "Daisy",\n  "mailNickname" : "daisypop89",\n  "surname" : "Jensen",\n  "userPrincipalName" : "daisypop89@example.org",\n  "accountEnabled" : true,\n  "passwordProfile" : {\n    "password" : "P4ssw0rd!",\n    "forceChangePasswordNextLogin" : true\n  }\n}');
        }

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new Office365CreateUserPlugin(), inputParams);
    }
}