@isTest
private class ServiceNowWrappedUserTest {

    @isTest static void testParse() {
        // arrange
        String json = '{"result":{"phone":"","manager":"","location":{"link":"https://my-instance.service-now.com/api/now/v1/table/cmn_location/8226baa4ac1d55eb40eb653c02649519","value":"8226baa4ac1d55eb40eb653c02649519"},"street":"","city":"","web_service_access_only":"false","vip":"false","first_name":"Bridget","sys_domain":{"link":"https://my-instance.service-now.com/api/now/v1/table/sys_user_group/global","value":"global"},"locked_out":"false","gender":"","sys_mod_count":"3","employee_number":"","calendar_integration":"1","middle_name":"","sys_updated_on":"2012-02-25 21:17:19","last_login":"","country":"","user_name":"bridget.bottella","time_zone":"","email":"bridget.bottella@example.com","failed_attempts":"","company":{"link":"https://my-instance.service-now.com/api/now/v1/table/core_company/81fbfe03ac1d55eb286d832de58ae1fd","value":"81fbfe03ac1d55eb286d832de58ae1fd"},"roles":"","last_name":"Bottella","user_password":"","active":"true","introduction":"","department":{"link":"https://my-instance.service-now.com/api/now/v1/table/cmn_department/221f79b7c6112284005d646b76ab978c","value":"221f79b7c6112284005d646b76ab978c"},"state":"1","password_needs_reset":"false","sys_created_on":"2012-02-18 03:04:51","ldap_server":"","cost_center":{"link":"https://my-instance.service-now.com/api/now/v1/table/cmn_cost_center/d9d0a971c0a80a641c20b13d99a48576","value":"d9d0a971c0a80a641c20b13d99a48576"},"mobile_phone":"","title":"","sys_updated_by":"admin","name":"Bridget Bottella","date_format":"","notification":"2","zip":"","building":"","last_login_time":"","sys_id":"da826bf03710200044e0bfc8bcbe5dbb","default_perspective":"","photo":"","sys_created_by":"admin","internal_integration_user":"false","schedule":"","source":"","sys_class_name":"sys_user","home_phone":"","time_format":"","preferred_language":""}}';

        // act
        ServiceNowWrappedUser obj = ServiceNowWrappedUser.parse(json);

        // assert
        System.assertNotEquals(null, obj);
        System.assertEquals('da826bf03710200044e0bfc8bcbe5dbb', obj.result.sys_id);
        System.assertEquals('bridget.bottella@example.com', obj.result.email);
    }

}