@isTest
private class DropboxCreateUserPluginTest {

    // Tests
    @isTest static void testCreate() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        generator.nextBody = '{"profile":{"status":"active","surname":"Jensen","email_verified":true,"given_name":"Daisy","groups":[],"member_id":"dbmid:AAAp4WHvplm7lcooX4Nnz61l1q5mG7M7Cao","external_id":null,"email":"daisypop89@gmail.com"},"permissions":{"is_admin":true}}';
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS), 'Status Not As Expected');
        System.assertEquals('dbmid:AAAp4WHvplm7lcooX4Nnz61l1q5mG7M7Cao', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERID), 'ExternalUserId Not As Expected');
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
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Dropbox', 'Create');
        
        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);

        // Define user account to create - we mock the request & response
        // These are specific to each connector
        if (validInput) {
            inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, '{"send_welcome_email":true,"member_surname":"Jensen","member_given_name":"Daisy","member_email":"daisypop89@gmail.com"}');
        }

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new DropboxCreateUserPlugin(), inputParams);
    }
}