global class ConcurToggleUserPlugin extends UserProvisioning.UserProvisioningPlugin {

    public static String PARAM_ENABLE_USER = 'enableUser';
    public static String PARAM_USER_ENDPOINT = 'userV1Endpoint';
    public static String PARAM_USER_ENDPOINT_V3 = 'userV3Endpoint';
    public static String PARAM_CONSUMER_KEY = 'partnerAppKey';

    global override Process.PluginDescribeResult buildDescribeCall() { 
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'Concur';
        // The specific operation
        describeResult.Name = 'Concur: Toggle User';
        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            new Process.PluginDescribeResult.InputParameter(PARAM_CONSUMER_KEY, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(PARAM_USER_ENDPOINT, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(PARAM_USER_ENDPOINT_V3, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(PARAM_ENABLE_USER, Process.PluginDescribeResult.ParameterType.BOOLEAN, true)
        };
        return describeResult;
    }
    
    global override Process.PluginResult invoke(Process.PluginRequest request) {
    
        Map<String,Object> result = new Map<String,Object>();
        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Failed'); // set default
        
        // Input parameters
        Boolean isDebug = ConcurUsersUtility.isDebug();
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        // The URLs for the User endpoint in the Concur API
        String userEndpoint = (String)request.inputParameters.get(PARAM_USER_ENDPOINT);
        String userEndpointV3 = (String)request.inputParameters.get(PARAM_USER_ENDPOINT_V3);
        // The key for the Partner Application defined in Concur
        String consumerKey = (String)request.inputParameters.get(PARAM_CONSUMER_KEY);
        Boolean enableUser = (Boolean)request.inputParameters.get(PARAM_ENABLE_USER);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside ConcurToggleUserPlugin invoke()');

        // Input validation - note individual implementations may vary
        Map<String,String> inputParamValues = new Map<String, String>();
        inputParamValues.put(PARAM_USER_ENDPOINT, String.valueOf(userEndpoint));
        inputParamValues.put(PARAM_USER_ENDPOINT_V3, String.valueOf(userEndpointV3));
        inputParamValues.put(PARAM_CONSUMER_KEY, String.valueOf(consumerKey));
        inputParamValues.put(PARAM_ENABLE_USER, String.valueOf(enableUser));
        if (userProvUtils.areParamsBlank(inputParamValues, result)) {
            return new Process.PluginResult(result);
        }

        try {
            userProvUtils.init(uprId);

            // the following is specific to Concur as the Concur API
            // follows a non-standard OAuth 2 implementation.
            ConcurUsersUtility.endPoint = userEndpoint;
            ConcurUsersUtility.accessToken = ConcurNativeAuth.getAccessToken(
                userProvUtils.getNamedCredential(), consumerKey).token;
            // end non-standard connector impl

            UserProvAccount upa = userProvUtils.getLinkedUserProvAccount();
            if (upa != null && !String.isBlank(upa.externalUserId)) {
                // Concur does not supply a way to update a subset of attributes, so we
                // must first fetch Concur User before modifying values known to SFDC.
                // set endPoint to v3 URL passed via input param
                ConcurUsersUtility.endPoint = userEndpointV3;
                ConcurUser user = ConcurUsersUtility.getExistingUser(upa.externalUserId);
                user.active = enableUser;

                ///////////////////////////////////////////////////
                //
                // !!!WARNING!!!
                //
                // There is a potential race condition here. There could be multiple
                // Concur connector plugins executing concurrently in separate
                // threads. In theory we could read the ConcurUser above, and then
                // BEFORE executing the below code, a separate thread could update
                // the remote ConcurUser to be inconsistent with the value read. 
                // Finally, the below code would be executed, setting the active
                // state of the user to the wrong value.
                //
                // !!!WARNING!!!
                //
                ///////////////////////////////////////////////////

                // set endPoint to v1 URL passed via input param
                ConcurUsersUtility.endPoint = userEndpoint;
                Map<String, Object> callResult = ConcurUsersUtility.updateUser(user);
                userProvUtils.debug('HTTP call result was ' + callResult);

                Boolean isSuccess = (Boolean)callResult.get('isSuccess');
                if (isSuccess) {
                    String responseStr = (String)callResult.get('httpResponseStr');
                    ConcurUpdateUserResponse respObj = ConcurUpdateUserResponse.parse(responseStr);

                    // Check API result (not returned via HTTP status)
                    if (respObj.records_succeeded == 1) {
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