@isTest
private class ZendeskCollectUsersPluginTest {

    // Tests
    @isTest static void testSuccess() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        generator.nextBody = '{"users":[{"id":1478729297,"url":"https://my-instance.zendesk.com/api/v2/users/1478729297.json","name":"Daisy Jensen","email":"daisypop89@gmail.com","created_at":"2015-09-14T14:20:18Z","updated_at":"2015-09-17T15:56:36Z","time_zone":"Atlantic Time (Canada)","phone":null,"photo":null,"locale_id":1,"locale":"en-US","organization_id":757031337,"role":"admin","verified":true,"external_id":null,"tags":[],"alias":null,"active":true,"shared":false,"shared_agent":false,"last_login_at":"2015-09-17T15:56:36Z","two_factor_auth_enabled":null,"signature":null,"details":null,"notes":null,"custom_role_id":null,"moderator":true,"ticket_restriction":null,"only_private_comments":false,"restricted_agent":false,"suspended":false,"chat_only":false,"user_fields":{}}],"next_page":"https://my-instance.zendesk.com/api/v2/users.json?page=2&per_page=1","previous_page":null,"count":2}';
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS), 'Status Not As Expected');
    }

    // Tests
    @isTest static void test403HttpResponse() {
        // arrange
        ConnectorUtil.UserProvisioningTestUtils.setMock(new ConnectorUtil.HttpResponseGenerator(403));

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Failed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));
    }

    @isTest static void testException() {
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
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Zendesk', 'Reconcile', 'Collecting');
        
        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        if (validInput) {
            inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);
        }
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_RECON_OFFSET, '');

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new ZendeskCollectUsersPlugin(), inputParams);
    }
}