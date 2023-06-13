@isTest
private class BoxUserAttributeGeneratorPluginTest {
    
    // Tests     
    @isTest static void testGeneratePayload() {
        // arrange
        String expected = '{\n  "name" : "Daisy Jensen",\n  "login" : "daisypop89@gmail.com"\n}';

        // act
        Process.PluginResult response = callPlugin();
        String actual = (String)response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        // assert
        System.assertEquals(expected, actual);
    }

    // Helper methods
    private static Process.PluginResult callPlugin() {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Box', 'Create');

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();

        inputParams.put(BoxUserAttributeGenerator.PARAM_FIRSTNAME, 'Daisy');
        inputParams.put(BoxUserAttributeGenerator.PARAM_LASTNAME, 'Jensen');
        inputParams.put(BoxUserAttributeGenerator.PARAM_EMAIL, 'daisypop89@gmail.com');

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new BoxUserAttributeGeneratorPlugin(), inputParams);
    }
}