@isTest                       
private class SCIMDeleteUserPluginTest {
      
    // Tests
    @isTest static void testDelete() {
        // arrange
        ConnectorUtil.UserProvisioningTestUtils.setMock(new ConnectorUtil.HttpResponseGenerator());
        
        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));
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
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('SCIM', 'Deactivate');
        
        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new SCIMDeleteUserPlugin(), inputParams);
    }
}