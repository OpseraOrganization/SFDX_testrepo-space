global class DropboxDeleteUserPlugin extends UserProvisioning.UserProvisioningPlugin {

    public static String PARAM_TRANSFER_DEST_MEMBER_ID = 'transferDestMemberId';
    public static String PARAM_TRANSFER_ADMIN_MEMBER_ID = 'transferAdminMemberId';

    global override Process.PluginDescribeResult buildDescribeCall() { 
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'Dropbox';
        // The specific operation
        describeResult.Name = 'Dropbox: Delete User';
        describeResult.inputParameters = new 
            List<Process.PluginDescribeResult.InputParameter>{ 
               new Process.PluginDescribeResult.InputParameter(PARAM_TRANSFER_DEST_MEMBER_ID, Process.PluginDescribeResult.ParameterType.STRING, false),
               new Process.PluginDescribeResult.InputParameter(PARAM_TRANSFER_ADMIN_MEMBER_ID, Process.PluginDescribeResult.ParameterType.STRING, false)
            }; 
        return describeResult;
    }
    
    global override Process.PluginResult invoke(Process.PluginRequest request) {
    
        Map<String,Object> result = new Map<String,Object>();
        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Failed'); // set default
        
        // Input parameters
        Boolean isDebug = DropboxUsersUtility.isDebug();
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        String transferDestMemberId = (String)request.inputParameters.get(PARAM_TRANSFER_DEST_MEMBER_ID);
        String transferAdminMemberId = (String)request.inputParameters.get(PARAM_TRANSFER_ADMIN_MEMBER_ID);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside DropboxDeleteUserPlugin invoke()');

        try {
            userProvUtils.init(uprId);
            DropboxUsersUtility.endPoint = userProvUtils.getNamedCredential();

            UserProvAccount upa = userProvUtils.getLinkedUserProvAccount();
            if (upa != null && !String.isBlank(upa.externalUserId)) {
                DropboxUser.RemoveRequest removeRequest = new DropboxUser.RemoveRequest(
                    upa.externalUserId, transferDestMemberId, transferAdminMemberId);

                Map<String, Object> callResult = DropboxUsersUtility.deleteUser(removeRequest);
                userProvUtils.debug('HTTP call result was ' + callResult);

                Boolean isSuccess = (Boolean)callResult.get('isSuccess');

                if (isSuccess) {
                    result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Completed');
                    result.put(ConnectorUtil.UserProvisioningUtils.PARAM_UPASTATUS, 'Deleted');
                    result.put(ConnectorUtil.UserProvisioningUtils.PARAM_DETAILS, 'User deactivated successfully with ' + upa);
                    userProvUtils.debug('User deactivated successfully with ' + upa);

                }
            } else {
                userProvUtils.debug('Could not find user to delete from UserProvAccount where linkState = Linked and salesforceUserId = ' + userProvUtils.getSalesforceUserId());
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Failed');
            }
        } catch(Exception e) {
            userProvUtils.handleException(result, 'Exception found when calling service: ', e);
        } finally {
            userProvUtils.insertLogs();
        }

        return new Process.PluginResult(result);
    }
}