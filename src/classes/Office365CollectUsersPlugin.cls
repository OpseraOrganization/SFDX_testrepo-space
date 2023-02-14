global class Office365CollectUsersPlugin extends UserProvisioning.UserProvisioningPlugin {

    /*
     * Builds the descibe call for display in Flow Designer
     */
    global override Process.PluginDescribeResult buildDescribeCall() {            
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'Office365';
        // The specific operation
        describeResult.Name = 'Office365: Collect Users';

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
        Boolean isDebug = Office365UsersUtility.isDebug();
        // The ID of the User Provisioning request
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        // The offset for paging through recons
        String reconOffset = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_RECON_OFFSET);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside Office365 collect users invoke()');
        userProvUtils.debug('Input parameters: reconOffset=[' + reconOffset + ']');
       
        try {
            userProvUtils.init(uprId);
            Office365UsersUtility.endPoint = userProvUtils.getNamedCredential();
            
            Map<String, Object> callResult = Office365UsersUtility.getAllUsers(reconOffset);
            userProvUtils.debug('HTTP call result was ' + callResult);

            Boolean isSuccess = (Boolean)callResult.get('isSuccess');
            String responseStr = (String)callResult.get('httpResponseStr');
            
            // Parse response
            if (isSuccess && !String.isBlank(responseStr)) {
            
                List<UserProvAccountStaging> upasList = new List<UserProvAccountStaging>();

                Office365Users users = Office365Users.parse(responseStr);
                for (Office365User user: users.value) {
                    UserProvAccountStaging upas = new UserProvAccountStaging();

                    upas.ExternalUserId = user.objectId;
                    upas.ExternalUserName = user.userPrincipalName;
                    upas.ExternalFirstName = user.givenName;
                    upas.ExternalLastName = user.surname;                        
                    upas.ExternalEmail = user.userPrincipalName;

                    upas.LinkState = 'Orphaned';
                    upas.ConnectedAppId = userProvUtils.getConnectedAppId();
                    
                    if (user.accountEnabled)
                        upas.Status = 'Active';
                    else 
                        upas.Status = 'Deactivated';
                        
                    upasList.add(upas);
                }
                userProvUtils.debug('UPAs to insert: ' + upasList.size() + ', details:' + upasList);

                // Setup pagination
                String nextLink = users.odata_nextLink;
                System.PageReference pageRef = new System.PageReference('/' + nextLink);
                Map<String,String> params = pageRef.getParameters();
                reconOffset = params.get('$skiptoken');

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