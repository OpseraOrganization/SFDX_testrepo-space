public class ServiceNowUsersUtility {

    public static String endPoint = '';

    public static Map<String, Object> getAllUsers(Integer pageSize, Integer offset) {
        String path = '';
        if (pageSize != null) path += ConnectorUtil.HttpCall.buildParam(path, pageSize, 'sysparm_limit');
        if (offset != null) path += ConnectorUtil.HttpCall.buildParam(path, offset, 'sysparm_offset');
        return ConnectorUtil.HttpCall.get(endPoint, path);
    }

    public static Map<String, Object> createUser(String userPayload) {
        String path = ConnectorUtil.HttpCall.buildParam('', true, 'sysparm_input_display_value');

        return ConnectorUtil.HttpCall.post(endPoint, path, userPayload);
    }

    public static Map<String, Object> deleteUser(String userId) {
        String path = '/' + userId;
        return ConnectorUtil.HttpCall.del(endPoint, path);
    }

    public static Map<String, Object> updateUser(String userId, ServiceNowUser user) {
        String userPayload = user.serialize();
        return updateUser(userId, userPayload);
    }

    public static Map<String, Object> updateUser(String userId, String userPayload) {
        String path = '/' + userId;
        path += ConnectorUtil.HttpCall.buildParam(path, true, 'sysparm_input_display_value');

        return ConnectorUtil.HttpCall.put(endPoint, path, userPayload);
    }

    public static Boolean isDebug(){
        return ServiceNow_Prov_Connector__c.getOrgDefaults().Enable_Debug_Loging__c;
    }
}