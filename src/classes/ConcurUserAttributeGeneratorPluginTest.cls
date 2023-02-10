@isTest
private class ConcurUserAttributeGeneratorPluginTest {
    
    // Tests
    @isTest static void testGenerateCreatePayload() {
        // arrange
        String expected = '<batch xmlns="http://www.concursolutions.com/api/user/2011/02"><UserProfile><FeedRecordNumber>1</FeedRecordNumber><LocaleName>en_US</LocaleName><CrnKey>USD</CrnKey><Custom21>US</Custom21><CtryCode>US</CtryCode><LedgerCode>Default</LedgerCode><EmpId>daisypop89@gmail.com</EmpId><LoginId>daisypop89@gmail.com</LoginId><EmailAddress>daisypop89@gmail.com</EmailAddress><Active>Y</Active><Password>P4ssw0rd!</Password><FirstName>Daisy</FirstName><LastName>Jensen</LastName></UserProfile></batch>';

        // act
        Process.PluginResult response = callPlugin('Create');
        String actual = (String)response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        // assert
        System.assertEquals(expected, actual);
    }

    @isTest static void testGenerateUpdatePayload() {
        // arrange
        String expected = '<batch xmlns="http://www.concursolutions.com/api/user/2011/02"><UserProfile><FeedRecordNumber>1</FeedRecordNumber><LocaleName>en_US</LocaleName><CrnKey>USD</CrnKey><Custom21>US</Custom21><CtryCode>US</CtryCode><LedgerCode>Default</LedgerCode><EmpId>daisypop89@gmail.com</EmpId><LoginId>daisypop89@gmail.com</LoginId><EmailAddress>daisypop89@gmail.com</EmailAddress><Active>Y</Active><Password> </Password><FirstName>Daisy</FirstName><LastName>Jensen</LastName></UserProfile></batch>';

        // act
        Process.PluginResult response = callPlugin('Update');
        String actual = (String)response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        // assert
        System.assertEquals(expected, actual);
    }

    // Helper methods
    private static Process.PluginResult callPlugin(String uprOperation) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Concur', uprOperation);

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();

        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);
        inputParams.put(ConcurUserAttributeGenerator.PARAM_FIRSTNAME, 'Daisy');
        inputParams.put(ConcurUserAttributeGenerator.PARAM_LASTNAME, 'Jensen');
        inputParams.put(ConcurUserAttributeGenerator.PARAM_EMAIL, 'daisypop89@gmail.com');
        if (uprOperation == 'Create') {
            inputParams.put(ConcurUserAttributeGenerator.PARAM_PASSWORD, 'P4ssw0rd!');
        }

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new ConcurUserAttributeGeneratorPlugin(), inputParams);
    }
}