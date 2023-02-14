global class GoogleDeleteUserPlugin extends UserProvisioning.UserProvisioningPlugin {

    private static String PARAM_EMAIL = 'email';

    global override Process.PluginDescribeResult buildDescribeCall() {
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'Google';
        // The specific operation
        describeResult.Name = 'Google: Delete User';

        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
        };

        return describeResult;
    }

    global override Process.PluginResult invoke(Process.PluginRequest request) {

        Map<String,Object> result = new Map<String,Object>();
        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Failed'); // set default

        // Input parameters
        Boolean isDebug = GoogleUsersUtility.isDebug();
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside GoogleDeleteUserPlugin invoke()');

        try {
            userProvUtils.init(uprId);
            GoogleUsersUtility.endPoint = userProvUtils.getNamedCredential();

            UserProvAccount upa = userProvUtils.getLinkedUserProvAccount();
            if (upa != null && !String.isBlank(upa.externalUserId)) {
                Map<String, Object> callResult = GoogleUsersUtility.deleteUser(upa.externalUserId);
                Boolean isSuccess = (Boolean)callResult.get('isSuccess');
                userProvUtils.debug('HTTP call result was ' + callResult);

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