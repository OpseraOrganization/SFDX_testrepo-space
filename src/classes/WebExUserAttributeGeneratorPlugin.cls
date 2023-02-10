global class WebExUserAttributeGeneratorPlugin extends UserProvisioning.UserProvisioningPlugin {

    global override Process.PluginDescribeResult buildDescribeCall() { 
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'WebEx';
        // The specific operation
        describeResult.Name = 'WebEx: Generate User Attributes';
        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            new Process.PluginDescribeResult.InputParameter(WebExUserAttributeGenerator.PARAM_FIRSTNAME, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(WebExUserAttributeGenerator.PARAM_LASTNAME, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(WebExUserAttributeGenerator.PARAM_EMAIL, Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter(WebExUserAttributeGenerator.PARAM_PASSWORD, Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter(WebExUserAttributeGenerator.PARAM_SITE_NAME, Process.PluginDescribeResult.ParameterType.STRING, true)
        };

        describeResult.outputParameters = new List<Process.PluginDescribeResult.OutputParameter>{
           new Process.PluginDescribeResult.OutputParameter(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, Process.PluginDescribeResult.ParameterType.STRING)
        };

        return describeResult;
    }
    
    global override Process.PluginResult invoke(Process.PluginRequest request) {
        // Determine the operation
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        UserProvisioningRequest upr = [SELECT Operation FROM UserProvisioningRequest WHERE Id = :uprId LIMIT 1];
        String uprOperation = upr.Operation;

        // Attribute generation & serialization
        Map<String, Object> result = new Map<String, Object>();
        WebExUserAttributeGenerator generator = new WebExUserAttributeGenerator();

        // Input parameters
        String siteName = (String)request.inputParameters.get(WebExUserAttributeGenerator.PARAM_SITE_NAME);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(false);
        
        // Input validation - note individual implementations may vary
        Map<String,String> inputParamValues = new Map<String,String>();
        inputParamValues.put(WebExUserAttributeGenerator.PARAM_SITE_NAME, siteName);
        if (userProvUtils.areParamsBlank(inputParamValues, result)) {
            return new Process.PluginResult(result);
        }

        if (uprOperation == 'Create') {

            userProvUtils.init(uprId);
            UserProvAccount upa = userProvUtils.getLinkedUserProvAccount();
            
            if ((upa != null) && (upa.status == 'Deactivated')) {
                // Re-activate user, WebEx CreateUser API does not handle this
                WebExUpdateUserRequest updateRequest = generator.getMappedUpdateAttributes(request);
                updateRequest.active = 'ACTIVATED';
                updateRequest.webExId = upa.externalUserId;
                String payload = generator.getSerializedAttributes(updateRequest, siteName);
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, payload);
            } else {
                WebExCreateUserRequest createRequest = generator.getMappedCreateAttributes(request);
                String payload = generator.getSerializedAttributes(createRequest, siteName);
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, payload);
            }

        } else {
            WebExUpdateUserRequest updateRequest = generator.getMappedUpdateAttributes(request);
            String payload = generator.getSerializedAttributes(updateRequest, siteName);
            result.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, payload);
        }

        return new Process.PluginResult(result);
    }
}