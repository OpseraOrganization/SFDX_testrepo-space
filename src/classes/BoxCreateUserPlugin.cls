global class BoxCreateUserPlugin extends UserProvisioning.UserProvisioningPlugin {

    global override Process.PluginDescribeResult buildDescribeCall() { 
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'Box';
        // The specific operation
        describeResult.Name = 'Box: Create User';

        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{ 
            new Process.PluginDescribeResult.InputParameter(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, Process.PluginDescribeResult.ParameterType.STRING, true)
        }; 
        
        return describeResult;
    }
    
    global override Process.PluginResult invoke(Process.PluginRequest request) {
    
        Map<String, Object> result = new Map<String, Object>();
        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Failed'); // set default
        
        // Input parameters
        Boolean isDebug = BoxUsersUtility.isDebug();
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        String userPayload = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);
    
        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside BoxCreateUserPlugin invoke()');

        // input validation
        Map<String,String> inputParamValues = new Map<String,String>();
        inputParamValues.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, userPayload);
        if (userProvUtils.areParamsBlank(inputParamValues, result)) {
            return new Process.PluginResult(result);
        }

        try {
            userProvUtils.init(uprId);
            BoxUsersUtility.endPoint = userProvUtils.getNamedCredential();
            
            Map<String, Object> callResult = BoxUsersUtility.createUser(userPayload);
            userProvUtils.debug('HTTP call result was ' + callResult);

            Boolean isSuccess = (Boolean)callResult.get('isSuccess');
            String responseStr = (String)callResult.get('httpResponseStr');
            if (isSuccess) {
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Completed');
                BoxUser respObj = BoxUser.parse(responseStr);
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERID, respObj.id);
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERNAME, respObj.login);
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_EMAIL, respObj.login);

                ConnectorUtil.PersonName personName = new ConnectorUtil.PersonName(respObj.name);
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_FIRSTNAME, personName.firstName);
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_LASTNAME, personName.lastName);

                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_DETAILS,'User created successfully with ExternalUserId=' + result.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERID) + ', and ExternalUsername=' + result.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERNAME));
            }
        } catch(Exception e) {
            userProvUtils.handleException(result, 'Exception found when calling service: ', e);
        } finally {
            userProvUtils.insertLogs();
        }

        return new Process.PluginResult(result);
    }
}