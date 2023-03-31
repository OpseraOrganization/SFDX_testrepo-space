global class WebExCreateUserPlugin extends UserProvisioning.UserProvisioningPlugin {

    global override Process.PluginDescribeResult buildDescribeCall() { 
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'WebEx';
        // The specific operation
        describeResult.Name = 'WebEx: Create User';
        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{ 
            new Process.PluginDescribeResult.InputParameter(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, Process.PluginDescribeResult.ParameterType.STRING, true)
        }; 
        return describeResult;
    }
    
    global override Process.PluginResult invoke(Process.PluginRequest request) {
    
        Map<String, Object> result = new Map<String, Object>();
        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Failed'); // set default
        
        // Input parameters
        Boolean isDebug = WebExUsersUtility.isDebug();
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        String userPayload = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside WebExCreateUserPlugin invoke()');

        // Input validation - note individual implementations may vary
        Map<String,String> inputParamValues = new Map<String,String>();
        inputParamValues.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, userPayload);
        if (userProvUtils.areParamsBlank(inputParamValues, result)) {
            return new Process.PluginResult(result);
        }
    
        try {
            userProvUtils.init(uprId);
            WebExUsersUtility.endPoint = userProvUtils.getNamedCredential();

            Map<String, Object> callResult = WebExUsersUtility.updateUser(userPayload);
            userProvUtils.debug('HTTP call result was ' + callResult);

            Boolean isSuccess = (Boolean)callResult.get('isSuccess');
            
            if (isSuccess) {
                String responseStr = (String)callResult.get('httpResponseStr');
                WebExCreateUserResponse respObj = WebExCreateUserResponse.parse(responseStr);

                // Check API result (not returned via HTTP status)
                if (respObj.result == 'SUCCESS') {
                    result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Completed');

                    assignDerivedOutputParameters(result, userPayload);

                    result.put(ConnectorUtil.UserProvisioningUtils.PARAM_DETAILS,'User created successfully with ExternalUserId=' + result.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERID) + ', and ExternalUsername=' + result.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERNAME));
                }
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
        Dom.Document doc = new Dom.Document();
        doc.load(userPayload);
        
        Dom.XmlNode messageNode = doc.getRootElement();
        Dom.XmlNode bodyNode = messageNode.getChildElement('body', null);
        Dom.XmlNode bodyContentNode = bodyNode.getChildElement('bodyContent', null);

        String email = getNodeText(bodyContentNode, 'email');
        String firstName = getNodeText(bodyContentNode, 'firstName');
        String lastName = getNodeText(bodyContentNode, 'lastName');

        pluginResult.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERID, email);
        pluginResult.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERNAME, email);
        pluginResult.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_EMAIL, email);
        pluginResult.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_FIRSTNAME, firstName);
        pluginResult.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_LASTNAME, lastName);
    }

    private String getNodeText(Dom.XmlNode parentNode, String nodeName) {
        Dom.XmlNode childNode = parentNode.getChildElement(nodeName, null);
        return childNode.getText();
    }
}