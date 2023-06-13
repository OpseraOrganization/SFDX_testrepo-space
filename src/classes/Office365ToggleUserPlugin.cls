global class Office365ToggleUserPlugin extends UserProvisioning.UserProvisioningPlugin {

    public static String PARAM_ENABLE_USER = 'enableUser';

    global override Process.PluginDescribeResult buildDescribeCall() { 
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'Office365';
        // The specific operation
        describeResult.Name = 'Office365: Toggle User';
        describeResult.inputParameters = new 
            List<Process.PluginDescribeResult.InputParameter>{
               new Process.PluginDescribeResult.InputParameter(PARAM_ENABLE_USER, Process.PluginDescribeResult.ParameterType.BOOLEAN, true)
            }; 
        return describeResult;
    }
    
    global override Process.PluginResult invoke(Process.PluginRequest request) {
    
        Map<String,Object> result = new Map<String,Object>();
        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Failed'); // set default
        
        // Input parameters
        Boolean isDebug = Office365UsersUtility.isDebug();
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        Boolean enableUser = (Boolean)request.inputParameters.get(PARAM_ENABLE_USER);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside Office365ToggleUserPlugin invoke()');

        // Input validation - note individual implementations may vary
        Map<String,String> inputParamValues = new Map<String, String>();
        inputParamValues.put(PARAM_ENABLE_USER, String.valueOf(enableUser));
        if (userProvUtils.areParamsBlank(inputParamValues, result)) {
            return new Process.PluginResult(result);
        }

        try {
            userProvUtils.init(uprId);
            Office365UsersUtility.endPoint = userProvUtils.getNamedCredential();

            UserProvAccount upa = userProvUtils.getLinkedUserProvAccount();
            if (upa != null && !String.isBlank(upa.externalUserId)) {

                Office365User user = new Office365User();
                user.accountEnabled = enableUser;

                Map<String, Object> callResult = Office365UsersUtility.updateUser(upa.externalUserId, user);
                userProvUtils.debug('HTTP call result was ' + callResult);

                Boolean isSuccess = (Boolean)callResult.get('isSuccess');
                if (isSuccess) {
                    result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Completed');
                    result.put(ConnectorUtil.UserProvisioningUtils.PARAM_DETAILS, 'User toggled successfully with ' + upa);
                    userProvUtils.debug('User toggled successfully with ' + upa);

                    // Lastly flag the User Provisioning Account active / deactivated
                    upa.status = user.accountEnabled ? 'Active' : 'Deactivated';

                    update upa;
                }
            } else {
                userProvUtils.debug('Could not find user to toggle for UserProvAccount where linkState = Linked and salesforceUserId = ' + userProvUtils.getSalesforceUserId());
            }
        } catch(Exception e) {
            userProvUtils.handleException(result, 'Exception found when calling service: ', e);
        } finally {
            userProvUtils.insertLogs();
        }

        return new Process.PluginResult(result);
    }
}