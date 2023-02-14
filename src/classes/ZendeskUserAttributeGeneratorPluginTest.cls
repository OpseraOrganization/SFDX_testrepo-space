@isTest
private class ZendeskUserAttributeGeneratorPluginTest {
    
    // Tests     
    @isTest static void testGeneratePayload() {
        // arrange
        String expected = '{\n  "user" : {\n    "name" : "Daisy Jensen",\n    "email" : "daisypop89@gmail.com"\n  }\n}';

        // act
        Process.PluginResult response = callPlugin();
        String actual = (String)response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        // assert
        System.assertEquals(expected, actual);
    }

    // Helper methods
    private static Process.PluginResult callPlugin() {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Zendesk', 'Create');

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();

        inputParams.put(ZendeskUserAttributeGenerator.PARAM_FIRSTNAME, 'Daisy');
        inputParams.put(ZendeskUserAttributeGenerator.PARAM_LASTNAME, 'Jensen');
        inputParams.put(ZendeskUserAttributeGenerator.PARAM_EMAIL, 'daisypop89@gmail.com');

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new ZendeskUserAttributeGeneratorPlugin(), inputParams);
    }
}