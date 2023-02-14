@isTest
private class SCIMUserAttributeGeneratorPluginTest {
    
    // Tests     
    @isTest static void testGeneratePayload() {
        // arrange
        String expected = '{"schemas":["urn:scim:schemas:core:1.0"],"name":{"givenName":"Daisy","familyName":"Jensen"},"emails":[{"value":"daisypop89@gmail.com"}]}';
        // act
        Process.PluginResult response = callPlugin();
        String actual = (String)response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        // assert
        System.assertEquals(expected, actual);
    }

    // Helper methods
    private static Process.PluginResult callPlugin() {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('SCIM', 'Create');

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();

        inputParams.put(SCIMUserAttributeGenerator.PARAM_FIRSTNAME, 'Daisy');
        inputParams.put(SCIMUserAttributeGenerator.PARAM_LASTNAME, 'Jensen');
        inputParams.put(SCIMUserAttributeGenerator.PARAM_EMAIL, 'daisypop89@gmail.com');

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new SCIMUserAttributeGeneratorPlugin(), inputParams);
    }
}