@isTest
private class BoxCollectUsersPluginTest {

    // Tests
    @isTest static void testSuccess() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        generator.nextBody = '{"total_count":5,"entries":[{"type":"user","id":"246419014","name":"Daisy Jensen","login":"daisypop89@gmail.com","created_at":"2015-09-01T14:29:10-07:00","modified_at":"2015-09-01T14:29:11-07:00","language":"en","timezone":"America/Los_Angeles","space_amount":5368709120,"space_used":0,"max_upload_size":2147483648,"status":"active","job_title":"","phone":"555-555-5555","address":"555 Box Lane","avatar_url":"https://app.box.com/api/avatar/large/246419014"},{"type":"user","id":"246419362","name":"Daisy Jensen","login":"daisypop89+test@gmail.com","created_at":"2015-09-01T14:33:03-07:00","modified_at":"2015-09-01T14:33:03-07:00","language":"en","timezone":"America/Los_Angeles","space_amount":5368709120,"space_used":0,"max_upload_size":2147483648,"status":"active","job_title":"","phone":"555-555-5555","address":"555 Box Lane","avatar_url":"https://app.box.com/api/avatar/large/246419362"},{"type":"user","id":"246397014","name":"Daisy Jensen","login":"daisypop89@gmail.com","created_at":"2015-09-01T12:01:51-07:00","modified_at":"2015-09-03T09:04:54-07:00","language":"gb","timezone":"America/Los_Angeles","space_amount":10737418240,"space_used":0,"max_upload_size":2147483648,"status":"active","job_title":"","phone":"8886870436","address":"","avatar_url":"https://app.box.com/api/avatar/large/246397014"},{"type":"user","id":"246578594","name":"Daisy Jensen","login":"daisypop89+test2@gmail.com","created_at":"2015-09-02T15:29:22-07:00","modified_at":"2015-09-02T15:29:22-07:00","language":"en","timezone":"America/Los_Angeles","space_amount":5368709120,"space_used":0,"max_upload_size":2147483648,"status":"active","job_title":"","phone":"555-555-5555","address":"555 Box Lane","avatar_url":"https://app.box.com/api/avatar/large/246578594"},{"type":"user","id":"246420642","name":"Daisy Jensen","login":"daisypop89+test3@gmail.com","created_at":"2015-09-01T14:44:54-07:00","modified_at":"2015-09-01T14:44:54-07:00","language":"en","timezone":"America/Los_Angeles","space_amount":5368709120,"space_used":0,"max_upload_size":2147483648,"status":"active","job_title":"","phone":"555-555-5555","address":"555 Box Lane","avatar_url":"https://app.box.com/api/avatar/large/246420642"}],"limit":100,"offset":0}';
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS), 'Status Not As Expected');
    }

    @isTest static void test403HttpResponse() {
        // arrange
        ConnectorUtil.UserProvisioningTestUtils.setMock(new ConnectorUtil.HttpResponseGenerator(403));

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Failed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));
    }

    @isTest static void testIncompleteInputParams() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

        // act
        Process.PluginResult response = callPlugin(false);

        // assert
        System.assertEquals('Failed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS), 'Status Not As Expected');
    }

    // Helper methods
    private static Process.PluginResult callPlugin() {
        return callPlugin(true);
    }

    private static Process.PluginResult callPlugin(Boolean validInput) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Box', 'Reconcile', 'Collecting');
        
        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        if (validInput) {
            inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);
        }
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_RECON_OFFSET, '');

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new BoxCollectUsersPlugin(), inputParams);
    }
}