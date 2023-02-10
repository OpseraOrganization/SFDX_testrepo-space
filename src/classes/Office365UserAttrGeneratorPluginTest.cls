@isTest
private class Office365UserAttrGeneratorPluginTest {
    
    // Tests
    @isTest static void testGenerateCreatePayload() {
        // arrange
        String expected = '{\n  "displayName" : "Daisy Jensen",\n  "givenName" : "Daisy",\n  "mailNickname" : "daisypop89",\n  "surname" : "Jensen",\n  "userPrincipalName" : "daisypop89@example.org",\n  "accountEnabled" : true,\n  "passwordProfile" : {\n    "password" : "P4ssw0rd!",\n    "forceChangePasswordNextLogin" : true\n  }\n}';

        // act
        Process.PluginResult response = callPlugin('Create');
        String actual = (String)response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        // assert
        System.assertEquals(expected, actual);
    }

    @isTest static void testGenerateUpdatePayload() {
        // arrange
        String expected = '{\n  "displayName" : "Daisy Jensen",\n  "givenName" : "Daisy",\n  "surname" : "Jensen"\n}';

        // act
        Process.PluginResult response = callPlugin('Update');
        String actual = (String)response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        // assert
        System.assertEquals(expected, actual);
    }

    // Helper methods
    private static Process.PluginResult callPlugin(String uprOperation) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Office365', uprOperation);

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();

        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);
        inputParams.put(Office365UserAttributeGenerator.PARAM_FIRSTNAME, 'Daisy');
        inputParams.put(Office365UserAttributeGenerator.PARAM_LASTNAME, 'Jensen');
        if (uprOperation == 'Create') {
            inputParams.put(Office365UserAttributeGenerator.PARAM_EMAIL, 'daisypop89@gmail.com');
            inputParams.put(Office365UserAttributeGenerator.PARAM_PASSWORD, 'P4ssw0rd!');
        }
        inputParams.put(Office365UserAttributeGenerator.PARAM_DOMAIN, 'example.org');

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new Office365UserAttributeGeneratorPlugin(), inputParams);
    }
}