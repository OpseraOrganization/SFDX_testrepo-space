global class GoToMeetingCollectUsersPlugin extends UserProvisioning.UserProvisioningPlugin {

    /*
     * Builds the descibe call for display in Flow Designer
     */
    global override Process.PluginDescribeResult buildDescribeCall() {
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'GoToMeeting';
        // The specific operation
        describeResult.Name = 'GoToMeeting: Collect Users';

        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter> {
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
        Boolean isDebug = GoToMeetingUsersUtility.isDebug();
        // The ID of the User Provisioning request
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside GoToMeeting collect users invoke()');
        
        try {
            userProvUtils.init(uprId);
            GoToMeetingUsersUtility.endPoint = userProvUtils.getNamedCredential();

            // Note: no pagination support in the GoToMeeting API

            Map<String, Object> callResult = GoToMeetingUsersUtility.getAllUsers();
            userProvUtils.debug('HTTP call result was ' + callResult);

            Boolean isSuccess = (Boolean)callResult.get('isSuccess');
            String responseStr = (String)callResult.get('httpResponseStr');

            // Parse response
            if (isSuccess && !String.isBlank(responseStr)) {

                List<UserProvAccountStaging> upasList = new List<UserProvAccountStaging>();

                List<GoToMeetingUser> users = GoToMeetingUser.parseUsers(responseStr);
                for (GoToMeetingUser user: users) {
                    UserProvAccountStaging upas = new UserProvAccountStaging();

                    upas.ExternalUserId = String.valueOf(user.organizerKey);
                    upas.ExternalUserName = user.email;
                    upas.ExternalFirstName = user.firstName;
                    upas.ExternalLastName = user.lastName;
                    upas.ExternalEmail = user.email;

                    upas.LinkState = 'Orphaned';
                    upas.ConnectedAppId = userProvUtils.getConnectedAppId();

                    upas.Status = user.status == 'active' ? 'Active' : 'Deactivated';

                    upasList.add(upas);
                }
                userProvUtils.debug('UPAs to insert: ' + upasList.size() + ', details:' + upasList);

                // perform DML operations after all callouts are done
                if (!upasList.isEmpty()) insert upasList;

                // set result
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Completed');
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_DETAILS, 'All users collected successfully');
            }

        } catch (Exception e) {
            userProvUtils.handleException(result, 'Exception: ', e);
        } finally {
            userProvUtils.insertLogs();
        }

        return new Process.PluginResult(result);
    }
}