@isTest
private class ServiceNowUserAttrGeneratorPluginTest {
    
    // Tests
    @isTest static void testGenerateCreatePayload() {
        // arrange
        String expected = '{\n  "email" : "daisypop89@gmail.com",\n  "first_name" : "Daisy",\n  "last_name" : "Jensen",\n  "user_name" : "daisypop89@gmail.com",\n  "user_password" : "P4ssw0rd!",\n  "active" : "true",\n  "password_needs_reset" : "true"\n}';

        // act
        Process.PluginResult response = callPlugin('Create');
        String actual = (String)response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        // assert
        System.assertEquals(expected, actual);
    }

    @isTest static void testGenerateUpdatePayload() {
        // arrange
        String expected = '{\n  "email" : "daisypop89@gmail.com",\n  "first_name" : "Daisy",\n  "last_name" : "Jensen"\n}';

        // act
        Process.PluginResult response = callPlugin('Update');
        String actual = (String)response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        // assert
        System.assertEquals(expected, actual);
    }

    // Helper methods
    private static Process.PluginResult callPlugin(String uprOperation) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('ServiceNow', uprOperation);

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();

        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);
        inputParams.put(ServiceNowUserAttributeGenerator.PARAM_FIRSTNAME, 'Daisy');
        inputParams.put(ServiceNowUserAttributeGenerator.PARAM_LASTNAME, 'Jensen');
        inputParams.put(ServiceNowUserAttributeGenerator.PARAM_EMAIL, 'daisypop89@gmail.com');
        if (uprOperation == 'Create') {
            inputParams.put(ServiceNowUserAttributeGenerator.PARAM_PASSWORD, 'P4ssw0rd!');
        }

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new ServiceNowUserAttributeGeneratorPlugin(), inputParams);
    }
}