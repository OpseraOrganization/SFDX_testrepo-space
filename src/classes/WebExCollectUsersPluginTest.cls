@isTest
private class WebExCollectUsersPluginTest {

    // Tests
    @isTest static void testSuccess() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        generator.nextBody = '<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:serv="http://www.webex.com/schemas/2002/06/service" xmlns:com="http://www.webex.com/schemas/2002/06/common" xmlns:use="http://www.webex.com/schemas/2002/06/service/user"><serv:header><serv:response><serv:result>SUCCESS</serv:result><serv:gsbStatus>PRIMARY</serv:gsbStatus></serv:response></serv:header><serv:body><serv:bodyContent xsi:type="use:LstsummaryUserResponse" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><use:user><use:webExId>hostid</use:webExId><use:email>email@domain.com</use:email><use:registrationDate>06/23/2004 20:53:08</use:registrationDate><use:active>ACTIVATED</use:active><use:timeZoneID>4</use:timeZoneID></use:user><use:user><use:webExId>bush</use:webExId><use:firstName>bush</use:firstName><use:lastName>bush</use:lastName><use:email>bush@email.com</use:email><use:registrationDate>06/23/2005 21:07:55</use:registrationDate><use:active>ACTIVATED</use:active><use:timeZoneID>4</use:timeZoneID></use:user><use:user><use:webExId>java</use:webExId><use:firstName>java</use:firstName><use:lastName>java</use:lastName><use:email>java@email.com</use:email><use:registrationDate>06/23/2006 21:36:05</use:registrationDate><use:active>ACTIVATED</use:active><use:timeZoneID>4</use:timeZoneID></use:user><use:user><use:webExId>xml</use:webExId><use:firstName>xml</use:firstName><use:lastName>xml</use:lastName><use:email>xml@email.com</use:email><use:registrationDate>06/23/2007 16:56:41</use:registrationDate><use:active>ACTIVATED</use:active><use:timeZoneID>4</use:timeZoneID></use:user><use:matchingRecords><serv:total>4</serv:total><serv:returned>4</serv:returned><serv:startFrom>1</serv:startFrom></use:matchingRecords></serv:bodyContent></serv:body></serv:message>';
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

    @isTest static void testIncompleteInputParams() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);

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
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('WebEx', 'Reconcile', 'Collecting');
        
        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        if (validInput) {
            inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);
            inputParams.put(WebExCollectUsersPlugin.PARAM_SITE_NAME, 'apidemoeu');
        }
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_RECON_OFFSET, '');

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new WebExCollectUsersPlugin(), inputParams);
    }
}