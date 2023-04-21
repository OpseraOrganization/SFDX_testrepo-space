global class WebExCollectUsersPlugin extends UserProvisioning.UserProvisioningPlugin {

    public static String PARAM_SITE_NAME = 'siteName';

    /*
     * Builds the descibe call for display in Flow Designer
     */
    global override Process.PluginDescribeResult buildDescribeCall() {            
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        // A Group for the Plugins
        describeResult.tag = 'WebEx';
        // The specific operation
        describeResult.Name = 'WebEx: Collect Users';
        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter> {
            new Process.PluginDescribeResult.InputParameter(PARAM_SITE_NAME, Process.PluginDescribeResult.ParameterType.STRING, true)
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
        Boolean isDebug = WebExUsersUtility.isDebug();
        // The ID of the User Provisioning request
        String uprId = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_UPR_ID);
        // The offset for paging through recons
        String reconOffset = (String)request.inputParameters.get(ConnectorUtil.UserProvisioningUtils.PARAM_RECON_OFFSET);
        String siteName = (String)request.inputParameters.get(PARAM_SITE_NAME);

        ConnectorUtil.UserProvisioningUtils userProvUtils = new ConnectorUtil.UserProvisioningUtils(isDebug);
        userProvUtils.debug('Inside WebEx collect users invoke()');
        userProvUtils.debug('Input parameters: reconOffset=[' + reconOffset + ']');

        // Input validation - note individual implementations may vary
        Map<String,String> inputParamValues = new Map<String,String>();
        inputParamValues.put(PARAM_SITE_NAME, siteName);
        if (userProvUtils.areParamsBlank(inputParamValues, result)) {
            return new Process.PluginResult(result);
        }
       
        try {
            userProvUtils.init(uprId);
            WebExUsersUtility.endPoint = userProvUtils.getNamedCredential();
            
            Map<String, Object> callResult = WebExUsersUtility.getAllUsers(siteName, reconOffset);
            userProvUtils.debug('HTTP call result was ' + callResult);

            Boolean isSuccess = (Boolean)callResult.get('isSuccess');
            String responseStr = (String)callResult.get('httpResponseStr');
            
            // Parse response
            if (isSuccess && !String.isBlank(responseStr)) {
                WebExCollectUsersResponse users = WebExCollectUsersResponse.parse(responseStr);

                // Check API result (not returned via HTTP status)
                if (users.result == 'SUCCESS') {
            
                    List<UserProvAccountStaging> upasList = new List<UserProvAccountStaging>();

                    for (WebExCollectUsersResponse.User user: users.users) {
                        UserProvAccountStaging upas = new UserProvAccountStaging();

                        upas.ExternalUserId = user.webExId;
                        upas.ExternalUserName = user.webExId;
                        upas.ExternalFirstName = user.firstName;
                        upas.ExternalLastName = user.lastName;
                        upas.ExternalEmail = user.email;

                        upas.LinkState = 'Orphaned';
                        upas.ConnectedAppId = userProvUtils.getConnectedAppId();
                        
                        upas.Status = user.active.equalsIgnoreCase('ACTIVATED') ? 'Active': 'Deactivated';
                            
                        upasList.add(upas);
                    }                
                    userProvUtils.debug('UPAs to insert: ' + upasList.size() + ', details:' + upasList);
                    
                    // Setup pagination
                    Integer processed_records = users.returned_records + (users.startFrom_records - 1);      
                    if (processed_records < users.total_records) {
                        // More data to fetch
                        reconOffset = String.valueOf(users.startFrom_records + users.returned_records);
                    } else {
                        // No more data to fetch
                        reconOffset = '';
                    }

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
            }

        } catch (Exception e) {
            userProvUtils.handleException(result, 'Exception: ', e);
        } finally {
            userProvUtils.insertLogs();
        }

        return new Process.PluginResult(result);
    }
}