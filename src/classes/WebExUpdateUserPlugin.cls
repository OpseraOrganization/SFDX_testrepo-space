global class WebExUpdateUserPlugin extends UserProvisioning.UserProvisioningPlugin {

    global override Process.PluginDescribeResult buildDescribeCall() { 
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'WebEx';
        // The specific operation
        describeResult.Name = 'WebEx: Update User';

        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{ 
            new Process.PluginDescribeResult.InputParameter(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, Process.PluginDescribeResult.ParameterType.STRING, true)
        };

        return describeResult;
    }
    
    global override Process.PluginResult invoke(Process.PluginRequest request) {
    
        Map<String,Object> result = new Map<String,Object>();
        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Failed'); // set default
        
        // Input parameters
        Boolean isDebug = WebExUsersUtility.isDebug();
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        String userPayload = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside WebExUpdateUserPlugin invoke()');
    
        // Input validation - note individual implementations may vary
        Map<String,String> inputParamValues = new Map<String, String>();
        inputParamValues.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, userPayload);
        if (userProvUtils.areParamsBlank(inputParamValues, result)) {
            return new Process.PluginResult(result);
        }
    
        try {
            userProvUtils.init(uprId);
            WebExUsersUtility.endPoint = userProvUtils.getNamedCredential();

            UserProvAccount upa = userProvUtils.getLinkedUserProvAccount();
            if (upa != null && !String.isBlank(upa.externalUserId)) {

                userPayload = applyOutstandingAttributes(userPayload, upa);

                Map<String, Object> callResult = WebExUsersUtility.updateUser(userPayload);
                userProvUtils.debug('HTTP call result was ' + callResult);

                Boolean isSuccess = (Boolean)callResult.get('isSuccess');
                if (isSuccess) {

                    String responseStr = (String)callResult.get('httpResponseStr');

                    WebExResponse respObj = WebExResponse.parse(responseStr);

                    // Check API result (not returned via HTTP status)
                    if (respObj.result == 'SUCCESS') {
                        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Completed');
                        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_DETAILS,'User updated with ExternalUserId=' + result.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERID) + ', and ExternalUsername=' + result.get(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERNAME));
                    }

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
        Dom.Document doc = new Dom.Document();
        doc.load(userPayload);
        
        Dom.XmlNode messageNode = doc.getRootElement();
        Dom.XmlNode bodyNode = messageNode.getChildElement('body', null);
        Dom.XmlNode bodyContentNode = bodyNode.getChildElement('bodyContent', null);

        // *Do not* overwrite existing values the user may have provided
        Dom.XmlNode webExIdNode = bodyContentNode.getChildElement('webExId', null);
        if (webExIdNode == null) {
            webExIdNode = bodyContentNode.addChildElement('webExId', null, null);
            webExIdNode.addTextNode(upa.externalUserId);
        }

        return doc.toXmlString();
    }

}