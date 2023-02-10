global class DropboxUpdateUserPlugin extends UserProvisioning.UserProvisioningPlugin {
    
    global override Process.PluginDescribeResult buildDescribeCall() { 
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'Dropbox';
        // The specific operation
        describeResult.Name = 'Dropbox: Update User';

        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            new Process.PluginDescribeResult.InputParameter(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, Process.PluginDescribeResult.ParameterType.STRING, true)
        };

        return describeResult;
    }
    
    global override Process.PluginResult invoke(Process.PluginRequest request) {
    
        Map<String,Object> result = new Map<String,Object>();
        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Failed'); // set default
        
        // Input parameters
        Boolean isDebug = DropboxUsersUtility.isDebug();
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        String userPayload = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside DropboxUpdateUserPlugin invoke()');

        // input validation
        Map<String,String> inputParamValues = new Map<String,String>();
        inputParamValues.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, userPayload);
        if (userProvUtils.areParamsBlank(inputParamValues, result)) {
            return new Process.PluginResult(result);
        }
    
        try {
            userProvUtils.init(uprId);
            DropboxUsersUtility.endPoint = userProvUtils.getNamedCredential();

            UserProvAccount upa = userProvUtils.getLinkedUserProvAccount();
            if (upa != null && !String.isBlank(upa.externalUserId)) {
            
                userPayload = applyOutstandingAttributes(userPayload, upa);

                Map<String, Object> callResult = DropboxUsersUtility.updateUser(userPayload);
                userProvUtils.debug('HTTP call result was ' + callResult);

                Boolean isSuccess = (Boolean)callResult.get('isSuccess');
                if (isSuccess) {
                    result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Completed');
                    result.put(ConnectorUtil.UserProvisioningUtils.PARAM_DETAILS,'User updated with ExternalUserId=' + result.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERID) + ', and ExternalUsername=' + result.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERNAME));
                }
            } else {
                userProvUtils.debug('Could not find user to update for UserProvAccount where linkState = Linked and salesforceUserId = ' + userProvUtils.getSalesforceUserId());
            }
        } catch(Exception e) {
            userProvUtils.handleException(result, 'Exception found when calling service: ', e);
        } finally {
            userProvUtils.insertLogs();
        }

        return new Process.PluginResult(result);
    }  

    // Assign properties not available in the UserAttributeGenerator class
    // Deserialize *untyped* to preserve any attributes a customer may have added
    private String applyOutstandingAttributes(String userPayload, UserProvAccount upa) {
        Map<String, Object> userData = (Map<String, Object>)JSON.deserializeUntyped(userPayload);

        // *Do not* overwrite existing values the user may have provided
        String keyName = 'member_id';
        if (!userData.containsKey(keyName)) {
            userData.put(keyName, upa.externalUserId);
        }

        return JSON.serialize(userData);
    }
}