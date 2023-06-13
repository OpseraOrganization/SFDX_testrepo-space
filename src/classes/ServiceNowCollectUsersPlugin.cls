global class ServiceNowCollectUsersPlugin extends UserProvisioning.UserProvisioningPlugin {

    public static String PARAM_RECON_OFFSET = 'reconOffset';
    public static String PARAM_NEXT_RECON_OFFSET = 'nextReconOffset';
    private static Integer PAGE_SIZE = 100;

    /*
     * Builds the descibe call for display in Flow Designer
     */
    global override Process.PluginDescribeResult buildDescribeCall() {
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'ServiceNow';
        // The specific operation
        describeResult.Name = 'ServiceNow: Collect Users';

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
        Boolean isDebug = ServiceNowUsersUtility.isDebug();
        // The ID of the User Provisioning request
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        // The offset for paging through recons
        String reconOffset = (String)request.inputParameters.get(PARAM_RECON_OFFSET);
        Integer offset = String.isBlank(reconOffset) ? 0 : Integer.valueOf(reconOffset);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside ServiceNow collect users invoke()');
        userProvUtils.debug('Input parameters: reconOffset=[' + reconOffset + ']');

        try {
            userProvUtils.init(uprId);
            ServiceNowUsersUtility.endPoint = userProvUtils.getNamedCredential();
            
            Map<String, Object> callResult = ServiceNowUsersUtility.getAllUsers(PAGE_SIZE, offset);
            userProvUtils.debug('HTTP call result was ' + callResult);

            Boolean isSuccess = (Boolean)callResult.get('isSuccess');
            String responseStr = (String)callResult.get('httpResponseStr');

            // Parse response
            if (isSuccess && !String.isBlank(responseStr)) {
            
                List<UserProvAccountStaging> upasList = new List<UserProvAccountStaging>();

                ServiceNowUsers users = ServiceNowUsers.parse(responseStr);
                for (ServiceNowUser user: users.result) {
                    UserProvAccountStaging upas = new UserProvAccountStaging();

                    upas.ExternalUserId = user.sys_id;
                    upas.ExternalUserName = user.user_name;
                    upas.ExternalFirstName = user.first_name;
                    upas.ExternalLastName = user.last_name;
                    upas.ExternalEmail = user.email;

                    upas.LinkState = 'Orphaned';
                    upas.ConnectedAppId = userProvUtils.getConnectedAppId();

                    upas.Status = user.active == 'true' ? 'Active' : 'Deactivated';

                    upasList.add(upas);
                }
                userProvUtils.debug('UPAs to insert: ' + upasList.size() + ', details:' + upasList);

                // Setup pagination
                offset += PAGE_SIZE;
                reconOffset = String.valueOf(offset);

                // perform DML operations after all callouts are done
                if (!upasList.isEmpty()) insert upasList;

                // set result
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Completed');
                if (!String.isBlank(reconOffset)) {
                    result.put(PARAM_NEXT_RECON_OFFSET, reconOffset);
                    result.put(ConnectorUtil.UserProvisioningUtils.PARAM_DETAILS, 'Partial users collected successfully');
                } else {
                    result.put(ConnectorUtil.UserProvisioningUtils.PARAM_DETAILS, 'All users collected successfully');
                }
            }

            Integer httpStatusCode = (Integer)callResult.get('httpStatusCode');
            if ((offset > 0) && (httpStatusCode == 404)) {
                // 404 is to be expected for the last fetched page
                result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Completed');
            }

        } catch (Exception e) {
            userProvUtils.handleException(result, 'Exception: ', e);
        } finally {
            userProvUtils.insertLogs();
        }

        return new Process.PluginResult(result);
    }
}