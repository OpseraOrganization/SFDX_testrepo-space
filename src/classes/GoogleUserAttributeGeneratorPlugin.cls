global class GoogleUserAttributeGeneratorPlugin extends UserProvisioning.UserProvisioningPlugin {

    global override Process.PluginDescribeResult buildDescribeCall() { 
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'Google';
        // The specific operation
        describeResult.Name = 'Google: Generate User Attributes';
        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            new Process.PluginDescribeResult.InputParameter(GoogleUserAttributeGenerator.PARAM_FIRSTNAME, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(GoogleUserAttributeGenerator.PARAM_LASTNAME, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(GoogleUserAttributeGenerator.PARAM_EMAIL, Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter(GoogleUserAttributeGenerator.PARAM_PASSWORD, Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter(GoogleUserAttributeGenerator.PARAM_DOMAIN, Process.PluginDescribeResult.ParameterType.STRING, false)
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
        GoogleUserAttributeGenerator generator = new GoogleUserAttributeGenerator();

        if (uprOperation == 'Create') {
            GoogleUser user = generator.getMappedCreateAttributes(request);
            String payload = generator.getSerializedAttributes(user);
            result.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, payload);
        } else {
            GoogleUser user = generator.getMappedUpdateAttributes(request);
            String payload = generator.getSerializedAttributes(user);
            result.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, payload);
        }

        return new Process.PluginResult(result);
    }
}