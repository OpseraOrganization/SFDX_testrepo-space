global class GoToMeetingCreateUserPlugin extends UserProvisioning.UserProvisioningPlugin {

    public static String PARAM_FIRSTNAME = 'firstName';
    public static String PARAM_LASTNAME = 'lastName';
    public static String PARAM_EMAIL = 'email';

    global override Process.PluginDescribeResult buildDescribeCall() {
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'GoToMeeting';
        // The specific operation
        describeResult.Name = 'GoToMeeting: Create User';

        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
           new Process.PluginDescribeResult.InputParameter(PARAM_FIRSTNAME, Process.PluginDescribeResult.ParameterType.STRING, true),
           new Process.PluginDescribeResult.InputParameter(PARAM_LASTNAME, Process.PluginDescribeResult.ParameterType.STRING, true),
           new Process.PluginDescribeResult.InputParameter(PARAM_EMAIL, Process.PluginDescribeResult.ParameterType.STRING, true)
        };

        return describeResult;
    }

    global override Process.PluginResult invoke(Process.PluginRequest request) {

        Map<String, Object> result = new Map<String, Object>();
        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Failed'); // set default

        // Input parameters
        Boolean isDebug = GoToMeetingUsersUtility.isDebug();
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        String firstName = (String)request.inputParameters.get(PARAM_FIRSTNAME);
        String lastName = (String)request.inputParameters.get(PARAM_LASTNAME);
        String email = (String)request.inputParameters.get(PARAM_EMAIL);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside GoToMeetingCreateUserPlugin invoke()');

        // input validation - note individual implementations may vary
        Map<String,String> inputParamValues = new Map<String,String>();
        inputParamValues.put(PARAM_FIRSTNAME, firstName);
        inputParamValues.put(PARAM_LASTNAME, lastName);
        inputParamValues.put(PARAM_EMAIL, email);
        if (userProvUtils.areParamsBlank(inputParamValues, result)) {
            return new Process.PluginResult(result);
        }

        try {
            userProvUtils.init(uprId);
            GoToMeetingUsersUtility.endPoint = userProvUtils.getNamedCredential();

            GoToMeetingUserRequest user = new GoToMeetingUserRequest();
            user.productType = 'g2m';
            user.firstName = firstName;
            user.lastName = lastName;
            user.organizerEmail = email;

            Map<String, Object> callResult = GoToMeetingUsersUtility.createUser(user);
            userProvUtils.debug('HTTP call result was ' + callResult);

            Boolean isSuccess = (Boolean)callResult.get('isSuccess');
            String responseStr = (String)callResult.get('httpResponseStr');
            if (isSuccess) {
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Completed');

                List<GoToMeetingShortUser> respObjs = GoToMeetingShortUser.parseUsers(responseStr);
                GoToMeetingShortUser respObj = respObjs[0];
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERID, respObj.key);
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_USERNAME, respObj.email);
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_EMAIL, respObj.email);
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_FIRSTNAME, user.firstName);
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_EXTERNAL_LASTNAME, user.lastName);

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