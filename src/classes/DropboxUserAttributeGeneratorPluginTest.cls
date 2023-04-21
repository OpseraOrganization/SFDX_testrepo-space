@isTest
private class DropboxUserAttributeGeneratorPluginTest {
    
    // Tests
    @isTest static void testGenerateCreatePayload() {
        // arrange
        String expected = '{"send_welcome_email":true,"member_surname":"Jensen","member_given_name":"Daisy","member_email":"daisypop89@gmail.com"}';

        // act
        Process.PluginResult response = callPlugin('Create');
        String actual = (String)response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        // assert
        System.assertEquals(expected, actual);
    }

    @isTest static void testGenerateUpdatePayload() {
        // arrange
        String expected = '{\n  "new_email" : "daisypop89@gmail.com",\n  "new_given_name" : "Daisy",\n  "new_surname" : "Jensen"\n}';

        // act
        Process.PluginResult response = callPlugin('Update');
        String actual = (String)response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        // assert
        System.assertEquals(expected, actual);
    }

    // Helper methods
    private static Process.PluginResult callPlugin(String uprOperation) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Dropbox', uprOperation);

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();

        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);
        inputParams.put(DropboxUserAttributeGenerator.PARAM_FIRSTNAME, 'Daisy');
        inputParams.put(DropboxUserAttributeGenerator.PARAM_LASTNAME, 'Jensen');
        inputParams.put(DropboxUserAttributeGenerator.PARAM_EMAIL, 'daisypop89@gmail.com');

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new DropboxUserAttributeGeneratorPlugin(), inputParams);
    }
}