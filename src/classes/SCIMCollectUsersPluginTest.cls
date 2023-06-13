@isTest                        
private class SCIMCollectUsersPluginTest {

    // positive test
    @isTest static void testSuccess() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        generator.nextBody = '{"totalResults":2,"itemsPerPage":2,"schemas":["urn:scim:schemas:core:1.0","urn:scim:schemas:extension:enterprise:1.0"],"Resources":[{"schemas":["urn:scim:schemas:core:1.0","urn:scim:schemas:extension:enterprise:1.0"],"id":"005B0000001OWr2IAG","userName":"dummy@gmail.com","name":{"formatted":"test99","familyName":"test99"},"emails":[{"type":"work","primary":true,"value":"dummy@gmail.com"}],"active":true},{"schemas":["urn:scim:schemas:core:1.0","urn:scim:schemas:extension:enterprise:1.0"],"id":"005B0000001OWrHIAW","userName":"dummy1@gmail.com","name":{"formatted":"testdemo","familyName":"testdemo"},"emails":[{"type":"work","primary":true,"value":"dummy1@gmail.com"}],"active":true}]}';
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

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
    
    // negative test
    @isTest static void testIncompleteInputParams() {
        // arrange
        ConnectorUtil.UserProvisioningTestUtils.setMock(new ConnectorUtil.HttpResponseGenerator());
        
        // act
        Process.PluginResult response = callPlugin(false);
        
        // assert
        System.assertEquals('Failed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));
    }

    // Helper methods
    private static Process.PluginResult callPlugin() {
        return callPlugin(true);
    }

    private static Process.PluginResult callPlugin(Boolean validInput) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('SCIM', 'Reconcile', 'Collecting');

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        if (validInput) {
            inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);
        }

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new SCIMCollectUsersPlugin(), inputParams);
    }
}