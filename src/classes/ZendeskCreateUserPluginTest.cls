@isTest
private class ZendeskCreateUserPluginTest {

    // Tests
    @isTest static void testCreate() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        generator.nextBody = '{"user":{"id":1478729297,"url":"https://my-instance.zendesk.com/api/v2/users/1478729297.json","name":"Daisy Jensen","email":"daisypop89@gmail.com","created_at":"2015-09-14T14:20:18Z","updated_at":"2015-09-18T13:44:27Z","time_zone":"Atlantic Time (Canada)","phone":null,"photo":null,"locale_id":1,"locale":"en-US","organization_id":757031337,"role":"admin","verified":true,"external_id":null,"tags":[],"alias":null,"active":true,"shared":false,"shared_agent":false,"last_login_at":"2015-09-18T13:44:27Z","two_factor_auth_enabled":null,"signature":null,"details":null,"notes":null,"custom_role_id":null,"moderator":true,"ticket_restriction":null,"only_private_comments":false,"restricted_agent":false,"suspended":false,"chat_only":false,"user_fields":{}}}';
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS), 'Status Not As Expected');
        System.assertEquals('1478729297', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERID), 'ExternalUserId Not As Expected');
        System.assertEquals('daisypop89@gmail.com', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERNAME), 'ExternalUserName Not As Expected');
        System.assertEquals('daisypop89@gmail.com', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_EMAIL), 'ExternalEmail Not As Expected');
        System.assertEquals('Daisy', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_FIRSTNAME), 'ExternalFirstName Not As Expected');
        System.assertEquals('Jensen', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_LASTNAME), 'ExternalLastName Not As Expected');                        
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
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Zendesk', 'Create');
        
        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);

        // Define user account to create - we mock the request & response
        if (validInput) {
            inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, '{\n  "user" : {\n    "name" : "Daisy Jensen",\n    "email" : "daisypop89@gmail.com"\n  }\n}');
        }

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new ZendeskCreateUserPlugin(), inputParams);
    }
}