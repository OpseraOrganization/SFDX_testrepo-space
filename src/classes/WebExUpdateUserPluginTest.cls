@isTest
private class WebExUpdateUserPluginTest {

    // Tests
    @isTest static void testUpdate() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        generator.nextBody = '<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:serv="http://www.webex.com/schemas/2002/06/service" xmlns:com="http://www.webex.com/schemas/2002/06/common" xmlns:use="http://www.webex.com/schemas/2002/06/service/user"><serv:header><serv:response><serv:result>SUCCESS</serv:result><serv:gsbStatus>PRIMARY</serv:gsbStatus></serv:response></serv:header><serv:body><serv:bodyContent xsi:type="use:delUserResponse" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" /></serv:body></serv:message>';
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);
        
        // act
        Process.PluginResult response = callPlugin();

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS));

        // ensure ExactTargetUpdateUserPlugin inserted the ExternalUserID into the payload
        String requestBody = generator.firstRequest.getBody();
        System.assert(requestBody.contains('<webExId>' + ConnectorUtil.UserProvisioningTestUtils.EXTERNAL_USER_ID + '</webExId>'));
    }

    @isTest static void testIncompleteInputParams() {
        // arrange
        ConnectorUtil.UserProvisioningTestUtils.setMock(new ConnectorUtil.HttpResponseGenerator());

        // act
        Process.PluginResult response = callPlugin(false);

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

    // Helper methods
    private static Process.PluginResult callPlugin() {
        return callPlugin(true);
    }

    private static Process.PluginResult callPlugin(Boolean validInput) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('WebEx', 'Deactivate');

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);

        // Define user account to create - we mock the request & response
        if (validInput) {
            inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, '<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:serv="http://www.webex.com/schemas/2002/06/service" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><header><securityContext><siteName>example-org</siteName><webExID>{!$Credential.Username}</webExID><password>{!$Credential.Password}</password></securityContext></header><body><bodyContent xsi:type="java:com.webex.service.binding.user.SetUser"><firstName>Daisy</firstName><lastName>Jensen</lastName><email>daisypop89@gmail.com</email></bodyContent></body></serv:message>');
        }
                
        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new WebExUpdateUserPlugin(), inputParams);
    }    
}