global class ConcurUpdateUserPlugin extends UserProvisioning.UserProvisioningPlugin {

    public static String PARAM_FIRSTNAME = 'firstName';
    public static String PARAM_LASTNAME = 'lastName';
    public static String PARAM_EMAIL = 'email';
    public static String PARAM_USER_ENDPOINT = 'userV1Endpoint';
    public static String PARAM_USER_ENDPOINT_V3 = 'userV3Endpoint';
    public static String PARAM_CONSUMER_KEY = 'partnerAppKey';
    
    global override Process.PluginDescribeResult buildDescribeCall() { 
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'Concur';
        // The specific operation
        describeResult.Name = 'Concur: Update User';

        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            new Process.PluginDescribeResult.InputParameter(PARAM_CONSUMER_KEY, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(PARAM_USER_ENDPOINT, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(PARAM_USER_ENDPOINT_V3, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, Process.PluginDescribeResult.ParameterType.STRING, true)
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
        String userPayload = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside ConcurUpdateUserPlugin invoke()');

        // input validation - note individual implementations may vary
        Map<String,String> inputParamValues = new Map<String,String>();
        inputParamValues.put(PARAM_USER_ENDPOINT, String.valueOf(userEndpoint));
        inputParamValues.put(PARAM_USER_ENDPOINT_V3, String.valueOf(userEndpointV3));
        inputParamValues.put(PARAM_CONSUMER_KEY, String.valueOf(consumerKey));
        inputParamValues.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, userPayload);
        if (userProvUtils.areParamsBlank(inputParamValues, result)) {
            return new Process.PluginResult(result);
        }
    
        try {
            userProvUtils.init(uprId);

            // the following is specific to Concur as the Concur API
            // follows a non-standard OAuth 2 implementation.
            ConcurUsersUtility.accessToken = ConcurNativeAuth.getAccessToken(
                userProvUtils.getNamedCredential(), consumerKey).token;
            // end non-standard connector impl

            UserProvAccount upa = userProvUtils.getLinkedUserProvAccount();
            if (upa != null && !String.isBlank(upa.externalUserId)) {

                userPayload = applyOutstandingAttributes(userPayload, upa);

                // set endPoint to v1 URL passed via input param
                ConcurUsersUtility.endPoint = userEndpoint;
                Map<String, Object> callResult = ConcurUsersUtility.updateUser(userPayload);
                Boolean isSuccess = (Boolean)callResult.get('isSuccess');
                userProvUtils.debug('HTTP call result was ' + callResult);

                if (isSuccess) {
                    String responseStr = (String)callResult.get('httpResponseStr');
                    ConcurUpdateUserResponse respObj = ConcurUpdateUserResponse.parse(responseStr);

                    // Check API result (not returned via HTTP status)
                    if (respObj.records_succeeded == 1) {
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
        
        Dom.XmlNode batchNode = doc.getRootElement();
        Dom.XmlNode userProfileNode = batchNode.getChildElement('UserProfile', ConcurUser.NS_XML);

        // *Do not* overwrite existing values the user may have provided
        Dom.XmlNode activeNode = userProfileNode.getChildElement('Active', ConcurUser.NS_XML);
        if (activeNode == null) {
            ConcurUser existingUser = ConcurUsersUtility.getExistingUser(upa.externalUserId);

            ///////////////////////////////////////////////////
            //
            // !!!WARNING!!!
            //
            // There is a potential race condition here. There could be multiple
            // Concur connector plugins executing concurrently in separate
            // threads. In theory we could read the ConcurUser above, and then
            // BEFORE executing our update code, a separate thread could modify
            // the remote ConcurUser to be inconsistent with the value read. 
            // Finally, our update code would be executed, setting the active
            // state of the user to the wrong value.
            //
            // !!!WARNING!!!
            //
            ///////////////////////////////////////////////////

            activeNode = userProfileNode.addChildElement('Active', null, null);
            activeNode.addTextNode(existingUser.active ? 'Y' : 'N');
        }

        return doc.toXmlString();
    }
}