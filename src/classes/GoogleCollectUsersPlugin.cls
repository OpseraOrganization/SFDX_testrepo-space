global class GoogleCollectUsersPlugin extends UserProvisioning.UserProvisioningPlugin {

    public static String PARAM_DOMAIN = 'domain';

    /*
     * Builds the descibe call for display in Flow Designer
     */
    global override Process.PluginDescribeResult buildDescribeCall() {
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'Google';
        // The specific operation
        describeResult.Name = 'Google: Collect Users';

        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter> {
            new Process.PluginDescribeResult.InputParameter(PARAM_DOMAIN, Process.PluginDescribeResult.ParameterType.STRING, true)
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
        Boolean isDebug = GoogleUsersUtility.isDebug();
        // The ID of the User Provisioning request
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        // The offset for paging through recons
        String reconOffset = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_RECON_OFFSET);
        String companyDomain = (String)request.inputParameters.get(PARAM_DOMAIN);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside Google collect users invoke()');
        userProvUtils.debug('Input parameters: reconOffset=[' + reconOffset + ']');

        // Input validation - note individual implementations may vary
        Map<String,String> inputParamValues = new Map<String,String>();
        inputParamValues.put(PARAM_DOMAIN, companyDomain);
        if (userProvUtils.areParamsBlank(inputParamValues, result)) {
            return new Process.PluginResult(result);
        }

        try {
            userProvUtils.init(uprId);
            GoogleUsersUtility.endPoint = userProvUtils.getNamedCredential();
            
            Map<String, Object> callResult = GoogleUsersUtility.getAllUsers(companyDomain, reconOffset);
            userProvUtils.debug('HTTP call result was ' + callResult);

            Boolean isSuccess = (Boolean)callResult.get('isSuccess');
            String responseStr = (String)callResult.get('httpResponseStr');

            // Parse response
            if (isSuccess && !String.isBlank(responseStr)) {
            
                List<UserProvAccountStaging> upasList = new List<UserProvAccountStaging>();

                GoogleUsers users = GoogleUsers.parse(responseStr);
                for (GoogleUser user: users.users) {
                    UserProvAccountStaging upas = new UserProvAccountStaging();

                    upas.ExternalUserId = user.id;
                    upas.ExternalUserName = user.primaryEmail;
                    upas.ExternalFirstName = user.name.givenName;
                    upas.ExternalLastName = user.name.familyName;
                    upas.ExternalEmail = user.primaryEmail;

                    upas.LinkState = 'Orphaned';
                    upas.ConnectedAppId = userProvUtils.getConnectedAppId();

                    upas.Status = user.suspended ? 'Deactivated' : 'Active';

                    upasList.add(upas);
                }
                userProvUtils.debug('UPAs to insert: ' + upasList.size() + ', details:' + upasList);

                // Setup pagination
                reconOffset = users.nextPageToken;

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