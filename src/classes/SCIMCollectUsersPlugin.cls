global class SCIMCollectUsersPlugin extends UserProvisioning.UserProvisioningPlugin {
    
    /*
     * Builds the descibe call for display in Flow Designer
     */
    global override Process.PluginDescribeResult buildDescribeCall() {
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'SCIM';
        // The specific operation
        describeResult.Name = 'SCIM: Collect Users';

        describeResult.inputParameters = new List <Process.PluginDescribeResult.InputParameter> {
        };

        return describeResult;
    }

    /*
     * The Plugin Collect Logic 
     */
    global override Process.PluginResult invoke(Process.PluginRequest request) {

        Map<String, Object> result = new Map<String, Object>();
        result.put(ConnectorUtil.UserProvisioningUtils.PARAM_STATUS, 'Failed'); // set default status to failed and override it later

        //The ID of the User Provisioning request
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        //The offset for paging through recons
        String reconOffset = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_RECON_OFFSET);

        //Is Debug
        Boolean isDebug = SCIMUsersUtility.isDebug();
        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside SCIM collect users invoke()');
        userProvUtils.debug('Input parameters: reconOffset=[' + reconOffset + ']');

        try {
            userProvUtils.init(uprId);
            SCIMUsersUtility.endPoint = userProvUtils.getNamedCredential();
            
            Map<String, Object> callResult = SCIMUsersUtility.getAllUsers(reconOffset, userProvUtils.getReconFilter());
            userProvUtils.debug('HTTP call result was ' + callResult);

            Boolean isSuccess = (Boolean)callResult.get('isSuccess');
            String responseStr = (String)callResult.get('httpResponseStr');

            if (isSuccess && !String.isBlank(responseStr)) { // parse response
            
                List<UserProvAccountStaging> upasList = new List<UserProvAccountStaging>();
                
                SCIMUsers users = SCIMUsers.parse(responseStr);
                String lastUserId; //for pagination filter
                for (SCIMUser user : users.Resources) {
                    UserProvAccountStaging upas = new UserProvAccountStaging();
                    upas.ExternalUserId = user.id;
                    lastUserId = upas.ExternalUserId;
                    upas.ExternalUserName = user.userName;
                    upas.ExternalFirstName = user.Name.familyName;
                    upas.ExternalLastName = user.Name.givenName;
                    upas.ExternalEmail = user.emails.get(0).value;
                    upas.LinkState = 'Orphaned';
                    upas.ConnectedAppId = userProvUtils.getConnectedAppId();
                    if (!user.active) upas.Status = 'Deactivated';
                    else upas.Status = 'Active';
                    upasList.add(upas);
                }                
                userProvUtils.debug('UPAs to insert: ' + upasList.size() + ', details:' + upasList);
                
                // Setup pagination
                Integer totalResults = users.totalResults;
                Integer itemsPerPage = users.itemsPerPage; //optionally sent
                if (itemsPerPage != null && totalResults > itemsPerPage) {
                    // need to paginate
                    reconOffset = lastUserId;
                } else reconOffset = '';

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