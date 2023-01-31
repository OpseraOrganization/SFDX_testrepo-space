global class WebExToggleUserPlugin extends UserProvisioning.UserProvisioningPlugin {

    public static String PARAM_SITE_NAME = 'siteName';
    public static String PARAM_ENABLE_USER = 'enableUser';

    global override Process.PluginDescribeResult buildDescribeCall() { 
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'WebEx';
        // The specific operation
        describeResult.Name = 'WebEx: Toggle User';
        describeResult.inputParameters = new 
            List<Process.PluginDescribeResult.InputParameter>{
               new Process.PluginDescribeResult.InputParameter(PARAM_SITE_NAME, Process.PluginDescribeResult.ParameterType.STRING, true),
               new Process.PluginDescribeResult.InputParameter(PARAM_ENABLE_USER, Process.PluginDescribeResult.ParameterType.BOOLEAN, true)
            }; 
        return describeResult;
    }
    
    global override Process.PluginResult invoke(Process.PluginRequest request) {
    
        Map<String,Object> result = new Map<String,Object>();
        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Failed'); // set default
        
        // Input parameters
        Boolean isDebug = WebExUsersUtility.isDebug();
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        String siteName = (String)request.inputParameters.get(PARAM_SITE_NAME);
        Boolean enableUser = (Boolean)request.inputParameters.get(PARAM_ENABLE_USER);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside WebExToggleUserPlugin invoke()');

        // Input validation - note individual implementations may vary
        Map<String,String> inputParamValues = new Map<String, String>();
        inputParamValues.put(PARAM_SITE_NAME, siteName);
        inputParamValues.put(PARAM_ENABLE_USER, String.valueOf(enableUser));
        if (userProvUtils.areParamsBlank(inputParamValues, result)) {
            return new Process.PluginResult(result);
        }

        try {
            userProvUtils.init(uprId);
            WebExUsersUtility.endPoint = userProvUtils.getNamedCredential();

            UserProvAccount upa = userProvUtils.getLinkedUserProvAccount();
            if (upa != null && !String.isBlank(upa.externalUserId)) {

                WebExUpdateUserRequest updateUserRequest = new WebExUpdateUserRequest(upa.externalUserId);
                updateUserRequest.active = enableUser ? 'ACTIVATED' : 'DEACTIVATED';

                Map<String, Object> callResult = WebExUsersUtility.updateUser(siteName, updateUserRequest);
                userProvUtils.debug('HTTP call result was ' + callResult);

                Boolean isSuccess = (Boolean)callResult.get('isSuccess');
                if (isSuccess) {

                    String responseStr = (String)callResult.get('httpResponseStr');

                    WebExResponse respObj = WebExResponse.parse(responseStr);

                    // Check API result (not returned via HTTP status)
                    if (respObj.result == 'SUCCESS') {
                    
                        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Completed');
                        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_DETAILS, 'User toggled successfully with ' + upa);
                        userProvUtils.debug('User toggled successfully with ' + upa);

                        // Lastly flag the User Provisioning Account active / deactivated
                        upa.status = enableUser ? 'Active' : 'Deactivated';
                        
                        update upa;
                    }
                    
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