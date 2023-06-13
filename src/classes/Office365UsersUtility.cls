public class Office365UsersUtility {
        
    public static String endPoint = '';
    public static String GRAPH_API_VERSION = '2013-04-05';
 
    public static Map<String, Object> getAllUsers(String skipToken) {
        String path = ConnectorUtil.HttpCall.buildParam('', GRAPH_API_VERSION, 'api-version');
        if (!String.isBlank(skipToken)) path += ConnectorUtil.HttpCall.buildParam(path, skipToken, '$skiptoken');
        return ConnectorUtil.HttpCall.get(endPoint, path);
    }
    
    public static Map<String, Object> createUser(String userPayload) {
        String path = ConnectorUtil.HttpCall.buildParam('', GRAPH_API_VERSION, 'api-version');
        return ConnectorUtil.HttpCall.post(endPoint, path, userPayload);
    }
    
    public static Map<String, Object> deleteUser(String userId) {
        String path = '/' + userId;
        path  += ConnectorUtil.HttpCall.buildParam(path, GRAPH_API_VERSION, 'api-version');
        return ConnectorUtil.HttpCall.del(endPoint, path);
    }

    public static Map<String, Object> updateUser(String userId, Office365User user) {
        String userPayload = user.serialize();
        return updateUser(userId, userPayload);
    }

    public static Map<String, Object> updateUser(String userId, String userPayload) {
        String path = '/' + userId;
        path  += ConnectorUtil.HttpCall.buildParam(path, GRAPH_API_VERSION, 'api-version');
        return ConnectorUtil.HttpCall.patch(endPoint, path, userPayload);
    }

    public static Boolean isDebug(){
        return Office365_Prov_Connector__c.getOrgDefaults().Enable_Debug_Loging__c;
    }
}