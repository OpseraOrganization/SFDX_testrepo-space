global class ServiceNowUserAttributeGeneratorPlugin extends UserProvisioning.UserProvisioningPlugin {

    global override Process.PluginDescribeResult buildDescribeCall() { 
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'ServiceNow';
        // The specific operation
        describeResult.Name = 'ServiceNow: Generate User Attributes';
        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            new Process.PluginDescribeResult.InputParameter(ServiceNowUserAttributeGenerator.PARAM_FIRSTNAME, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(ServiceNowUserAttributeGenerator.PARAM_LASTNAME, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(ServiceNowUserAttributeGenerator.PARAM_EMAIL, Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter(ServiceNowUserAttributeGenerator.PARAM_PASSWORD, Process.PluginDescribeResult.ParameterType.STRING, false)
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
        ServiceNowUserAttributeGenerator generator = new ServiceNowUserAttributeGenerator();

        if (uprOperation == 'Create') {
            ServiceNowUser user = generator.getMappedCreateAttributes(request);
            String payload = generator.getSerializedAttributes(user);
            result.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, payload);
        } else {
            ServiceNowUser user = generator.getMappedUpdateAttributes(request);
            String payload = generator.getSerializedAttributes(user);
            result.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, payload);
        }

        return new Process.PluginResult(result);
    }
}