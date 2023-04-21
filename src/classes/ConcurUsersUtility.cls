public with sharing class ConcurUsersUtility {

    public static String endPoint = '';
    public static String accessToken = '';

    // must target the v3.0 API - v1.0 does not support pagination, JSON 
    // or - in practice - returning more than just the current User record
    public static Map<String, Object> getAllUsers(String offset) {
        String path = '';
        if (!String.isBlank(offset)) path += ConnectorUtil.HttpCall.buildParam(path, offset, 'offset');

        ConnectorUtil.HttpCall call = new ConnectorUtil.HttpCall(endPoint, path, null, ConnectorUtil.HttpCall.HTTP_METHOD_GET);
        call.authHeader = 'OAuth ' + accessToken;
        return call.invoke();
    }

    public static Map<String, Object> getUser(String loginId) {
        String path = ConnectorUtil.HttpCall.buildParam('', loginId, 'user');
        ConnectorUtil.HttpCall call = new ConnectorUtil.HttpCall(endPoint, path, null, ConnectorUtil.HttpCall.HTTP_METHOD_GET);
        call.authHeader = 'OAuth ' + accessToken;
        return call.invoke();
    }

    // must target the v1.0 API - v3.0 does not support modifications
    public static Map<String, Object> createUser(String userPayload) {
        // same API operation creates & updates based on loginId
        return updateUser(userPayload);
    }

    // must target the v1.0 API - v3.0 does not support modifications
    public static Map<String, Object> updateUser(ConcurUser user) {
        String userPayload = user.serializeXML();
        return updateUser(userPayload);
    }

    public static Map<String, Object> updateUser(String userPayload) {
        String path = 'users/';

        ConnectorUtil.HttpCall call = new ConnectorUtil.HttpCall(endPoint, path, userPayload, ConnectorUtil.HttpCall.HTTP_METHOD_POST);
        call.authHeader = 'OAuth ' + accessToken;
        return call.invoke();
    }

    // Retrieve the ConcurUser representing the specified loginId
    // Raises a CalloutException() if the user is not found or an error occurs
    public static ConcurUser getExistingUser(String loginId) {
        ConcurUser result = null;
        Map<String, Object> callResult = ConcurUsersUtility.getUser(loginId);
        Boolean isSuccess = (Boolean)callResult.get('isSuccess');
        if (isSuccess) {
            String responseStr = (String)callResult.get('httpResponseStr');
            ConcurUsers users = ConcurUsers.parse(responseStr);
            if (users.items.size() == 1) {
                result = users.items[0];
            }                    
        } else {
            throw new CalloutException('Invalid HTTP response locating existing Concur user for update: ' + loginId);
        }

        if (result == null) {            
            throw new CalloutException('Unable to locate existing Concur user for update: ' + loginId);
        }

        return result;
    }

    public static Boolean isDebug(){
        return Concur_Prov_Connector__c.getOrgDefaults().Enable_Debug_Loging__c;
    }
}