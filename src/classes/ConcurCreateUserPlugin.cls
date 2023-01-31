global class ConcurCreateUserPlugin extends UserProvisioning.UserProvisioningPlugin {

    public static String PARAM_FIRSTNAME = 'firstName';
    public static String PARAM_LASTNAME = 'lastName';
    public static String PARAM_EMAIL = 'email';
    public static String PARAM_USER_ENDPOINT = 'userV1Endpoint';
    public static String PARAM_CONSUMER_KEY = 'partnerAppKey';
    public static String PARAM_PASSWORD = 'password';

    global override Process.PluginDescribeResult buildDescribeCall() { 
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'Concur';
        // The specific operation
        describeResult.Name = 'Concur: Create User';

        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{ 
            new Process.PluginDescribeResult.InputParameter(PARAM_CONSUMER_KEY, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(PARAM_USER_ENDPOINT, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, Process.PluginDescribeResult.ParameterType.STRING, true)
        };

        return describeResult;
    }
    
    global override Process.PluginResult invoke(Process.PluginRequest request) {
    
        Map<String, Object> result = new Map<String, Object>();
        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Failed'); // set default
        
        // Input parameters
        Boolean isDebug = ConcurUsersUtility.isDebug();
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        String userPayload = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD);
        // The URL for the User endpoint in the Concur API
        String userEndpoint = (String)request.inputParameters.get(PARAM_USER_ENDPOINT);
        // The key for the Partner Application defined in Concur
        String consumerKey = (String)request.inputParameters.get(PARAM_CONSUMER_KEY);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside ConcurCreateUserPlugin invoke()');

        // Input validation - note individual implementations may vary
        Map<String,String> inputParamValues = new Map<String,String>();
        inputParamValues.put(ConnectorUtil.UserProvisioningUtils.PARAM_USERPAYLOAD, userPayload);
        inputParamValues.put(PARAM_USER_ENDPOINT, String.valueOf(userEndpoint));
        inputParamValues.put(PARAM_CONSUMER_KEY, String.valueOf(consumerKey));
        if (userProvUtils.areParamsBlank(inputParamValues, result)) {
            return new Process.PluginResult(result);
        }
    
        try {
            userProvUtils.init(uprId);

            // the following is specific to Concur as the Concur API
            // follows a non-standard OAuth 2 implementation.
            ConcurUsersUtility.endPoint = userEndpoint;
            ConcurUsersUtility.accessToken = ConcurNativeAuth.getAccessToken(
                userProvUtils.getNamedCredential(), consumerKey).token;
            // end non-standard connector impl
            
            Map<String, Object> callResult = ConcurUsersUtility.createUser(userPayload);
            userProvUtils.debug('HTTP call result was ' + callResult);

            Boolean isSuccess = (Boolean)callResult.get('isSuccess');
            
            if (isSuccess) {
                String responseStr = (String)callResult.get('httpResponseStr');
                ConcurUpdateUserResponse respObj = ConcurUpdateUserResponse.parse(responseStr);

                // Check API result (not returned via HTTP status)
                if (respObj.records_succeeded == 1) {
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
        
        Dom.XmlNode batchNode = doc.getRootElement();
        Dom.XmlNode userProfileNode = batchNode.getChildElement('UserProfile', ConcurUser.NS_XML);

        String userID = getNodeText(userProfileNode, 'LoginId');
        String email = getNodeText(userProfileNode, 'EmailAddress');
        String firstName = getNodeText(userProfileNode, 'FirstName');
        String lastName = getNodeText(userProfileNode, 'LastName');

        pluginResult.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERID, userID);
        pluginResult.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERNAME, userID);
        pluginResult.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_EMAIL, email);
        pluginResult.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_FIRSTNAME, firstName);
        pluginResult.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_LASTNAME, lastName);
    }

    private String getNodeText(Dom.XmlNode parentNode, String nodeName) {
        Dom.XmlNode childNode = parentNode.getChildElement(nodeName, ConcurUser.NS_XML);
        return childNode.getText();
    }

}