public class BoxUsersUtility {
        
    public static String endPoint = '';
    
    public static Map<String, Object> getAllUsers(String offset) {
        String path = '';
        if (!String.isBlank(offset)) path += ConnectorUtil.HttpCall.buildParam(path, offset, 'offset');
        return ConnectorUtil.HttpCall.get(endPoint, path);
    }
    
    public static Map<String, Object> createUser(String userPayload) {
        return ConnectorUtil.HttpCall.post(endPoint, userPayload);
    }
    
    public static Map<String, Object> deleteUser(String userId, Boolean forceDelete) {
        String path = '/' + userId;
        if (forceDelete) path += ConnectorUtil.HttpCall.buildParam(path, forceDelete, 'force');
        return ConnectorUtil.HttpCall.del(endPoint, path);
    }
    
    public static Map<String, Object> updateUser(String userId, String userPayload) {
        String path = '/' + userId;
        return ConnectorUtil.HttpCall.put(endPoint, path, userPayload);
    }
    
    public static Boolean isDebug(){
        return Box_Prov_Connector__c.getOrgDefaults().Enable_Debug_Loging__c;
    }
}