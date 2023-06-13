@isTest
private class WebExUserAttributeGeneratorPluginTest {
    
    // Tests
    @isTest static void testGenerateCreatePayload() {
        // arrange
        String expected = '<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:serv="http://www.webex.com/schemas/2002/06/service"><header><securityContext><siteName>example-org</siteName><webExID>{!$Credential.Username}</webExID><password>{!$Credential.Password}</password></securityContext></header><body><bodyContent xsi:type="java:com.webex.service.binding.user.CreateUser"><firstName>Daisy</firstName><lastName>Jensen</lastName><webExId>daisypop89@gmail.com</webExId><email>daisypop89@gmail.com</email><password>P4ssw0rd!</password><privilege><host>true</host><isEnablePMR>FALSE</isEnablePMR></privilege><active>ACTIVATED</active></bodyContent></body></serv:message>';

        // act
        Process.PluginResult response = callPlugin('Create');
        String actual = (String)response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        // assert
        System.assertEquals(expected, actual);
    }

    @isTest static void testGenerateUpdatePayload() {
        // arrange
        String expected = '<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:serv="http://www.webex.com/schemas/2002/06/service" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><header><securityContext><siteName>example-org</siteName><webExID>{!$Credential.Username}</webExID><password>{!$Credential.Password}</password></securityContext></header><body><bodyContent xsi:type="java:com.webex.service.binding.user.SetUser"><firstName>Daisy</firstName><lastName>Jensen</lastName><email>daisypop89@gmail.com</email></bodyContent></body></serv:message>';

        // act
        Process.PluginResult response = callPlugin('Update');
        String actual = (String)response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        // assert
        System.assertEquals(expected, actual);
    }

    // Helper methods
    private static Process.PluginResult callPlugin(String uprOperation) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('WebEx', uprOperation);

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();

        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);
        inputParams.put(WebExUserAttributeGenerator.PARAM_FIRSTNAME, 'Daisy');
        inputParams.put(WebExUserAttributeGenerator.PARAM_LASTNAME, 'Jensen');
        inputParams.put(WebExUserAttributeGenerator.PARAM_EMAIL, 'daisypop89@gmail.com');
        if (uprOperation == 'Create') {
            inputParams.put(WebExUserAttributeGenerator.PARAM_PASSWORD, 'P4ssw0rd!');
        }
        inputParams.put(WebExUserAttributeGenerator.PARAM_SITE_NAME, 'example-org');

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new WebExUserAttributeGeneratorPlugin(), inputParams);
    }
}