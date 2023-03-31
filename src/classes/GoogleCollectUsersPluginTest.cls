@isTest
private class GoogleCollectUsersPluginTest {

    // Tests
    @isTest static void testSuccess() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        generator.nextBody = '{"kind":"admin#directory#users","etag":"\\"wp-nv9JMeB-zUDJ9G-GPqjRzodU/0IlFXoYh0hNH9JkAnXaw1SC9RwM\\"","users":[{"kind":"admin#directory#user","id":"116553285709261971170","etag":"\\"wp-nv9JMeB-zUDJ9G-GPqjRzodU/EfgqJ5qdejB7nrXZrLsegc2Mnoc\\"","primaryEmail":"jane.doe@example.com","name":{"givenName":"Jane","familyName":"Doe","fullName":"Jane Doe"},"isAdmin":true,"isDelegatedAdmin":false,"lastLoginTime":"2015-09-29T15:57:01.000Z","creationTime":"2012-10-11T00:20:11.000Z","agreedToTerms":true,"suspended":false,"changePasswordAtNextLogin":false,"ipWhitelisted":false,"emails":[{"address":"jane.andersen@example.com"},{"address":"jane.andersen@example.org"},{"address":"janedoe@example.com"},{"address":"jane@example.org"},{"address":"jane@example.com"},{"address":"janedoe@example.org"},{"address":"janedoe@example.net"},{"address":"jane@example.net"},{"address":"jane.andersen@example.net"},{"address":"jane.doe@example.com","primary":true},{"address":"jane.doe@example.org"},{"address":"jane.doe@example.net"}],"externalIds":[{"value":"12345","type":"custom","customType":""}],"addresses":[{"type":"custom","customType":""}],"aliases":["jane@example.com","janedoe@example.com","jane.andersen@example.com"],"nonEditableAliases":["jane.doe@example.org","jane@example.org","janedoe@example.org","jane.andersen@example.org","jane@example.net","jane.andersen@example.net","jane.doe@example.net","janedoe@example.net"],"customerId":"C04gock8x","orgUnitPath":"/MY-DOMAIN","isMailboxSetup":true,"includeInGlobalAddressList":true,"thumbnailPhotoUrl":"https://plus.google.com/_/focus/photos/public/AIbEiAIAAABECOK98LDktMXc5QEiC3ZjYXJkX3Bob3RvKig3YmM1MzM3ZjBjNTIzNzg0OTA2MzU0NDE4NTdjNzZmOTY2OGI5MmYzMAF37vkiTIUxUXfY4S22ODE7TaJtGQ","thumbnailPhotoEtag":"\\"wp-nv9JMeB-zUDJ9G-GPqjRzodU/3JWXjFZbprQU-a3MMIpu5zRmEwA\\""}],"nextPageToken":"0a35f806b49dffffffff9e9e8d9091d19e919b9a8d8c9091bf969b9288908d948cd19c9092ff00fefffeccc9cbcecbc8c7c7cecbc9fffe100121c57a3bfc50ff152c3900000000624bf900480150005a0b09e646653cc65527b01001"}';
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
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Google', 'Reconcile', 'Collecting');

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        if (validInput) {
            inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);
            inputParams.put(GoogleCollectUsersPlugin.PARAM_DOMAIN, 'example.org');
        }
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_RECON_OFFSET, '');

        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new GoogleCollectUsersPlugin(), inputParams);
    }
}