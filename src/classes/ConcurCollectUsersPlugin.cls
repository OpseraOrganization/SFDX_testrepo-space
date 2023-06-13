global class ConcurCollectUsersPlugin extends UserProvisioning.UserProvisioningPlugin {

    public static String PARAM_USER_ENDPOINT = 'userV3Endpoint';
    public static String PARAM_CONSUMER_KEY = 'partnerAppKey';

    /*
     * Builds the descibe call for display in Flow Designer
     */
    global override Process.PluginDescribeResult buildDescribeCall() {
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'Concur';
        // The specific operation
        describeResult.Name = 'Concur: Collect Users';

        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter> {
            new Process.PluginDescribeResult.InputParameter(PARAM_CONSUMER_KEY, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(PARAM_USER_ENDPOINT, Process.PluginDescribeResult.ParameterType.STRING, true)
        };

        return describeResult;
    }

    /*
     * The Plugin Collect Logic
     */
    global override Process.PluginResult invoke(Process.PluginRequest request) {

        Map<String, Object> result = new Map<String, Object>();
        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Failed'); // set default status to failed and override it later

        // Is Debug
        Boolean isDebug = ConcurUsersUtility.isDebug();
        // The ID of the User Provisioning request
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        // The URL for the User endpoint in the Concur API
        String userEndpoint = (String)request.inputParameters.get(PARAM_USER_ENDPOINT);
        // The key for the Partner Application defined in Concur
        String consumerKey = (String)request.inputParameters.get(PARAM_CONSUMER_KEY);
        // The offset for paging through recons
        String reconOffset = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_RECON_OFFSET);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside Concur collect users invoke()');
        userProvUtils.debug('Input parameters: reconOffset=[' + reconOffset + ']');

        // Input validation - note individual implementations may vary
        Map<String,String> inputParamValues = new Map<String, String>();
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
            
            Map<String, Object> callResult = ConcurUsersUtility.getAllUsers(reconOffset);
            userProvUtils.debug('HTTP call result was ' + callResult);

            Boolean isSuccess = (Boolean)callResult.get('isSuccess');
            String responseStr = (String)callResult.get('httpResponseStr');

            // Parse response
            if (isSuccess && !String.isBlank(responseStr)) {

                List<UserProvAccountStaging> upasList = new List<UserProvAccountStaging>();

                ConcurUsers users = ConcurUsers.parse(responseStr);
                for (ConcurUser user: users.items) {
                    UserProvAccountStaging upas = new UserProvAccountStaging();
                    
                    upas.ExternalUserId = user.loginId;
                    upas.ExternalUserName = user.loginId;
                    upas.ExternalFirstName = user.firstName;
                    upas.ExternalLastName = user.lastName;
                    upas.ExternalEmail = user.primaryEmail;
                    upas.LinkState = 'Orphaned';
                    upas.ConnectedAppId = userProvUtils.getConnectedAppId();
                    upas.Status = user.active ? 'Active': 'Deactivated';

                    upasList.add(upas);
                }
                userProvUtils.debug('UPAs to insert: ' + upasList.size() + ', details:' + upasList);
                
                // Setup pagination
                String nextLink = users.nextPage;
                System.PageReference pageRef = new System.PageReference('/' + nextLink);
                Map<String,String> params = pageRef.getParameters();
                reconOffset = params.get('offset');

                // perform DML operations after all callouts are done
                if (!upasList.isEmpty()) insert upasList;

                // set result
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Completed');
                if (!String.isBlank(reconOffset)) {
                    result.put(ConnectorUtil.UserProvisioningUtils.PARAM_NEXT_RECON_OFFSET, reconOffset);
                    result.put(ConnectorUtil.UserProvisioningUtils.PARAM_DETAILS, 'Partial users collected successfully');
                } else {
                    result.put(ConnectorUtil.UserProvisioningUtils.PARAM_DETAILS, 'All users collected successfully');
                }
            }

        } catch (Exception e) {
            userProvUtils.handleException(result, 'Exception: ', e);
        } finally {
            userProvUtils.insertLogs();
        }

        return new Process.PluginResult(result);
    }
}