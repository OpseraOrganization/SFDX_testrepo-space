public with sharing class DropboxUsersUtility {
    
    public static String endPoint = '';
 
    public static Map<String, Object> getAllUsers(String skipToken) {
        // We use a map as cursor must not be present if blank
        Map<String, Object> request = new Map<String, Object>();
        if (!String.isBlank(skipToken)) request.put('cursor', skiptoken);
        String body = JSON.serialize(request);

        return ConnectorUtil.HttpCall.post(endPoint, '/list', body);
    }
    
    public static Map<String, Object> createUser(String requestPayload) {
        return ConnectorUtil.HttpCall.post(endPoint, '/add', requestPayload);
    }
    
    public static Map<String, Object> deleteUser(DropboxUser.RemoveRequest removeRequest) {
        String body = JSON.serialize(removeRequest);

        return ConnectorUtil.HttpCall.post(endPoint, '/remove', body);
    }
    
    public static Map<String, Object> updateUser(String requestPayload) {
        return ConnectorUtil.HttpCall.post(endPoint, '/set_profile', requestPayload);
    }

    public static Boolean isDebug(){
        return Dropbox_Prov_Connector__c.getOrgDefaults().Enable_Debug_Loging__c;
    }
}