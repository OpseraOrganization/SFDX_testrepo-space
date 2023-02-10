global class Office365UserAttributeGeneratorPlugin extends UserProvisioning.UserProvisioningPlugin {

    global override Process.PluginDescribeResult buildDescribeCall() { 
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'Office365';
        // The specific operation
        describeResult.Name = 'Office365: Generate User Attributes';
        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            new Process.PluginDescribeResult.InputParameter(Office365UserAttributeGenerator.PARAM_FIRSTNAME, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(Office365UserAttributeGenerator.PARAM_LASTNAME, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(Office365UserAttributeGenerator.PARAM_EMAIL, Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter(Office365UserAttributeGenerator.PARAM_PASSWORD, Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter(Office365UserAttributeGenerator.PARAM_DOMAIN, Process.PluginDescribeResult.ParameterType.STRING, false)
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
        Office365UserAttributeGenerator generator = new Office365UserAttributeGenerator();

        if (uprOperation == 'Create') {
            Office365User user = generator.getMappedCreateAttributes(request);
            String payload = generator.getSerializedAttributes(user);
            result.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, payload);
        } else {
            Office365User user = generator.getMappedUpdateAttributes(request);
            String payload = generator.getSerializedAttributes(user);
            result.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, payload);
        }

        return new Process.PluginResult(result);
    }
}