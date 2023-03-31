global class BoxDeleteUserPlugin extends UserProvisioning.UserProvisioningPlugin {

    public static String PARAM_FORCE_DELETE_USERS = 'forceDeleteUsers';

    global override Process.PluginDescribeResult buildDescribeCall() { 
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'Box';
        // The specific operation
        describeResult.Name = 'Box: Delete User';
        describeResult.inputParameters = new 
            List<Process.PluginDescribeResult.InputParameter>{ 
               new Process.PluginDescribeResult.InputParameter(PARAM_FORCE_DELETE_USERS, Process.PluginDescribeResult.ParameterType.BOOLEAN, true)
            }; 
        return describeResult;
    }
    
    global override Process.PluginResult invoke(Process.PluginRequest request) {
    
        Map<String,Object> result = new Map<String,Object>();
        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Failed'); // set default
        
        // Input parameters
        Boolean isDebug = BoxUsersUtility.isDebug();
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        Boolean forceDeleteUsers = (Boolean)request.inputParameters.get(PARAM_FORCE_DELETE_USERS);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside BoxDeleteUserPlugin invoke()');

        // Input validation - note individual implementations may vary
        Map<String,String> inputParamValues = new Map<String, String>();
        inputParamValues.put(PARAM_FORCE_DELETE_USERS, String.valueOf(forceDeleteUsers));
        if (userProvUtils.areParamsBlank(inputParamValues, result)) {
            return new Process.PluginResult(result);
        }

        try {
            userProvUtils.init(uprId);
            BoxUsersUtility.endPoint = userProvUtils.getNamedCredential();

            UserProvAccount upa = userProvUtils.getLinkedUserProvAccount();
            if (upa != null && !String.isBlank(upa.externalUserId)) {
                Map<String, Object> callResult = BoxUsersUtility.deleteUser(upa.externalUserId, forceDeleteUsers);
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