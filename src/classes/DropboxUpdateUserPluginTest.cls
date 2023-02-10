@isTest
private class DropboxUpdateUserPluginTest {
    
    // Tests     
    @isTest static void testUpdate() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));

        // ensure DropboxUpdateUserPlugin inserted the ExternalUserID into the payload
        String requestBody = generator.firstRequest.getBody();
        Map<String, Object> payloadData = (Map<String, Object>)JSON.deserializeUntyped(requestBody);
        System.assert(payloadData.containsKey('member_id'));
        System.assertEquals(ConnectorUtil.UserProvisioningTestUtils.EXTERNAL_USER_ID, payloadData.get('member_id'));
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
        System.assertEquals('Failed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));       
    }

    // Helper methods
    private static Process.PluginResult callPlugin() {
        return callPlugin(true);
    }

    private static Process.PluginResult callPlugin(Boolean validInput) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Dropbox', 'Update');

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);

        // Define user account to create - we mock the request & response
        // These are specific to each connector
        if (validInput) {
            inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, '{ "new_email" : "daisypop89@gmail.com", "new_given_name" : "Daisy", "new_surname" : "Jensen" }');
        }

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new DropboxUpdateUserPlugin(), inputParams);
    }
}