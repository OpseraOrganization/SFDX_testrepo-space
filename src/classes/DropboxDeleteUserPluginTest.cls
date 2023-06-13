@isTest
private class DropboxDeleteUserPluginTest {

    // Tests
    @isTest static void testDeleteWithTransfer() {
        testDelete('dest-member-id', 'admin-member-id');
    }

    @isTest static void testDeleteWithoutTransfer() {
        testDelete(null, null);
    }

    static void testDelete(String transferDestMemberId, String transferAdminMemberId) {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);
        String expectedDestId = transferDestMemberId == null ? '' : transferDestMemberId;
        String expectedAdminId = transferDestMemberId == null ? '' : transferAdminMemberId;
        
        // act
        Process.PluginResult response = callPlugin(transferDestMemberId, transferAdminMemberId);

        // assert
        System.assertEquals('Completed', response.outputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS), 'Status Not As Expected');
    
        // ensure transfer parameters are passed to the query string
        DropboxUser.RemoveRequest actualRequest = (DropboxUser.RemoveRequest)System.JSON.deserialize(generator.firstRequest.getBody(), DropboxUser.RemoveRequest.class);
        System.assertEquals(expectedDestId, actualRequest.transfer_dest_member_id);
        System.assertEquals(expectedAdminId, actualRequest.transfer_admin_member_id);
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
        return callPlugin(null, null);
    }

    private static Process.PluginResult callPlugin(String transferDestMemberId, String transferAdminMemberId) {
        // Create a UserProvisioningRequest for testing
        UserProvisioningRequest upr = ConnectorUtil.UserProvisioningTestUtils.createUserProvisioningRequest('Dropbox', 'Deactivate');

        // Build input params
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID, upr.id);
        inputParams.put(DropboxDeleteUserPlugin.PARAM_TRANSFER_DEST_MEMBER_ID, transferDestMemberId);
        inputParams.put(DropboxDeleteUserPlugin.PARAM_TRANSFER_ADMIN_MEMBER_ID, transferAdminMemberId);
                
        return ConnectorUtil.UserProvisioningTestUtils.runPlugin(new DropboxDeleteUserPlugin(), inputParams);
    }    
}