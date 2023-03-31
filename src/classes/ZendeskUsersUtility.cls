public with sharing class ZendeskUsersUtility {
    
    public static String endPoint = '';
 
    public static Map<String, Object> getAllUsers(Integer page) {
        String path = '/users.json';
        if (page != null) path += ConnectorUtil.HttpCall.buildParam(path, page, 'page');

        return ConnectorUtil.HttpCall.get(endPoint, path);
    }
    
    public static Map<String, Object> createUser(String userPayload) {
        String path = '/users.json';

        return ConnectorUtil.HttpCall.post(endPoint, path, userPayload);
    }
    
    public static Map<String, Object> deleteUser(String userId) {
        String path = '/users/' + userId + '.json';

        return ConnectorUtil.HttpCall.del(endPoint, path);
    }
    
    public static Map<String, Object> updateUser(String userId, ZendeskWrappedUser zendeskUser) {
        String userPayload = zendeskUser.serialize();

        return updateUser(userId, userPayload);
    }
    
    public static Map<String, Object> updateUser(String userId, String userPayload) {
        String path = '/users/' + userId + '.json';

        return ConnectorUtil.HttpCall.put(endPoint, path, userPayload);
    }

    public static Boolean isDebug(){
        return Zendesk_Prov_Connector__c.getOrgDefaults().Enable_Debug_Loging__c;
    }
}