global class SCIMCreateUserPlugin extends UserProvisioning.UserProvisioningPlugin {
   
    global override Process.PluginDescribeResult buildDescribeCall() { 
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'SCIM';
        // The specific operation
        describeResult.Name = 'SCIM: Create User';

        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{ 
            new Process.PluginDescribeResult.InputParameter(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, Process.PluginDescribeResult.ParameterType.STRING, true)
        };

        return describeResult;
    }
    
    global override Process.PluginResult invoke(Process.PluginRequest request) {
    
        Map<String,Object> result = new Map<String,Object>();
        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Failed'); // set default
        
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        String userPayload = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        //Is Debug
        Boolean isDebug = SCIMUsersUtility.isDebug();
        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside SCIMCreateUserPlugin invoke()');
            
        // input validation - note SCIM is different than Salesforce
        Map<String,String> inputParamValues = new Map<String,String>();
        inputParamValues.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, userPayload);
        if (userProvUtils.areParamsBlank(inputParamValues, result)) {
            return new Process.PluginResult(result);
        }
    
        try {
            userProvUtils.init(uprId);
            SCIMUsersUtility.endPoint = userProvUtils.getNamedCredential();
            
            Map<String, Object> callResult = SCIMUsersUtility.createUser(userPayload);
            userProvUtils.debug('HTTP call result was ' + callResult);

            Boolean isSuccess = (Boolean)callResult.get('isSuccess');
            String responseStr = (String)callResult.get('httpResponseStr');
            if (isSuccess) {
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Completed');

                SCIMCreateUserResponse respObj = SCIMCreateUserResponse.parse(responseStr);
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERID, respObj.id);
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERNAME, respObj.userName);

                assignDerivedOutputParameters(result, userPayload);

                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_DETAILS,'User created successfully with ExternalUserId=' + result.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERID) + ', and ExternalUsername=' + result.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERNAME));
            }
        } catch(Exception e) {
            userProvUtils.handleException(result, 'Exception found when calling service: ', e);
        } finally {
            userProvUtils.insertLogs();
        }

        return new Process.PluginResult(result);
    }

    // Read values that were not returned by the target API from the input payload
    private void assignDerivedOutputParameters(Map<String, Object> pluginResult, String userPayload) {
        SCIMUser user = SCIMUser.parse(userPayload);

        pluginResult.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_EMAIL, user.emails.get(0).value);
        pluginResult.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_FIRSTNAME, user.name.givenName);
        pluginResult.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_LASTNAME, user.name.familyName);
    }
}