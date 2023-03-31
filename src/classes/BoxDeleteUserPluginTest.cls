@isTest
private class BoxDeleteUserPluginTest {

    // Tests
    @isTest static void testForceDelete() {
        testDelete(true);
    }

    @isTest static void testNoForceDelete() {
        testDelete(false);
    }

    private static void testDelete(Boolean forceDelete) {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);
        String expected = forceDelete ? String.valueOf(forceDelete) : null;
        
        // act
        Process.PluginResult response = callPlugin(true, forceDelete);

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS), 'Status Not As Expected');
    
        // ensure forceDeleteUsers is passed to the query string
        System.PageReference pageRef = new System.PageReference(generator.firstRequest.getEndpoint());
        Map<String, String> params = pageRef.getParameters();
        String forceValue = params.get('force');
        System.assertEquals(expected, forceValue);
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
        return callPlugin(validInput, true);
    }

    private static Process.PluginResult callPlugin(Boolean validInput, Boolean forceDelete) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Box', 'Deactivate');

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);

        if (validInput) {
            // Specify whether to delete users with associated data / files
            inputParams.put(BoxDeleteUserPlugin.PARAM_FORCE_DELETE_USERS, forceDelete);
        }
                
        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new BoxDeleteUserPlugin(), inputParams);
    }    
}