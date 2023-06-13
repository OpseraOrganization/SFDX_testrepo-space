@isTest
private class ServiceNowCollectUsersPluginTest {

    // Tests
    @isTest static void testSuccess() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        generator.nextBody = '{"result":[{"phone":"","manager":"","location":{"link":"https://my-instance.service-now.com/api/now/v1/table/cmn_location/8226baa4ac1d55eb40eb653c02649519","value":"8226baa4ac1d55eb40eb653c02649519"},"street":"","city":"","web_service_access_only":"false","vip":"false","first_name":"Bridget","sys_domain":{"link":"https://my-instance.service-now.com/api/now/v1/table/sys_user_group/global","value":"global"},"locked_out":"false","gender":"","sys_mod_count":"3","employee_number":"","calendar_integration":"1","middle_name":"","sys_updated_on":"2012-02-25 21:17:19","last_login":"","country":"","user_name":"bridget.bottella","time_zone":"","email":"bridget.bottella@example.com","failed_attempts":"","company":{"link":"https://my-instance.service-now.com/api/now/v1/table/core_company/81fbfe03ac1d55eb286d832de58ae1fd","value":"81fbfe03ac1d55eb286d832de58ae1fd"},"roles":"","last_name":"Bottella","user_password":"","active":"true","introduction":"","department":{"link":"https://my-instance.service-now.com/api/now/v1/table/cmn_department/221f79b7c6112284005d646b76ab978c","value":"221f79b7c6112284005d646b76ab978c"},"state":"1","password_needs_reset":"false","sys_created_on":"2012-02-18 03:04:51","ldap_server":"","cost_center":{"link":"https://my-instance.service-now.com/api/now/v1/table/cmn_cost_center/d9d0a971c0a80a641c20b13d99a48576","value":"d9d0a971c0a80a641c20b13d99a48576"},"mobile_phone":"","title":"","sys_updated_by":"admin","name":"Bridget Bottella","date_format":"","notification":"2","zip":"","building":"","last_login_time":"","sys_id":"da826bf03710200044e0bfc8bcbe5dbb","default_perspective":"","photo":"","sys_created_by":"admin","internal_integration_user":"false","schedule":"","source":"","sys_class_name":"sys_user","home_phone":"","time_format":"","preferred_language":""}]}';
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS), 'Status Not As Expected');
    }

    @isTest static void test404Paging() {
        // arrange
        ConnectorUtil.UserProvisioningTestUtils.setMock(new ConnectorUtil.HttpResponseGenerator(404));

        // act
        Process.PluginResult response = callPlugin(true, 100);

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));
    }

    @isTest static void test404NotPaging() {
        // arrange
        ConnectorUtil.UserProvisioningTestUtils.setMock(new ConnectorUtil.HttpResponseGenerator(404));

        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Failed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));
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
        return callPlugin(true, 0);
    }

    private static Process.PluginResult callPlugin(Boolean validInput) {
        return callPlugin(validInput, 0);
    }

    private static Process.PluginResult callPlugin(Boolean validInput, Integer offset) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('ServiceNow', 'Reconcile', 'Collecting');

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        if (validInput) {
            inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);
        }
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_RECON_OFFSET, offset == 0 ? '' : String.valueOf(offset));

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new ServiceNowCollectUsersPlugin(), inputParams);
    }
}