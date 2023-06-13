@isTest
private class GoogleUserAttributeGeneratorPluginTest {
    
    // Tests
    @isTest static void testGenerateCreatePayload() {
        // arrange
        String expected = '{\n  "primaryEmail" : "daisypop89@example.org",\n  "password" : "P4ssw0rd!",\n  "suspended" : false,\n  "changePasswordAtNextLogin" : true,\n  "name" : {\n    "familyName" : "Jensen",\n    "givenName" : "Daisy"\n  }\n}';

        // act
        Process.PluginResult response = callPlugin('Create');
        String actual = (String)response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        // assert
        System.assertEquals(expected, actual);
    }

    @isTest static void testGenerateUpdatePayload() {
        // arrange
        String expected = '{\n  "name" : {\n    "familyName" : "Jensen",\n    "givenName" : "Daisy"\n  }\n}';

        // act
        Process.PluginResult response = callPlugin('Update');
        String actual = (String)response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        // assert
        System.assertEquals(expected, actual);
    }

    // Helper methods
    private static Process.PluginResult callPlugin(String uprOperation) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Google', uprOperation);

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();

        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);
        inputParams.put(GoogleUserAttributeGenerator.PARAM_FIRSTNAME, 'Daisy');
        inputParams.put(GoogleUserAttributeGenerator.PARAM_LASTNAME, 'Jensen');
        if (uprOperation == 'Create') {
            inputParams.put(GoogleUserAttributeGenerator.PARAM_EMAIL, 'daisypop89@gmail.com');
            inputParams.put(GoogleUserAttributeGenerator.PARAM_PASSWORD, 'P4ssw0rd!');
        }
        inputParams.put(GoogleUserAttributeGenerator.PARAM_DOMAIN, 'example.org');

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new GoogleUserAttributeGeneratorPlugin(), inputParams);
    }
}