public class SCIMUsersUtility{

    public static String endPoint = '';
        
    public static Map<String, Object> getAllUsers(String offset, String reconFilter) {
        String path = '?attributes=active,userName,emails,name,name.familyName,name.givenName&count=200';

        String filter = buildFilter(offset, reconFilter);
        if (!String.isBlank(filter)) path += ConnectorUtil.HttpCall.buildParam(path, filter, 'filter');

        return ConnectorUtil.HttpCall.get(endPoint, path);
    }
    
    public static Map<String, Object> createUser(String userPayload) {
        return ConnectorUtil.HttpCall.post(endPoint, userPayload);
    }
    
    public static Map<String, Object> updateUser(String userId, SCIMUser user) {
        String userPayload = System.JSON.serialize(user, true);
        return updateUser(userId, userPayload);
    }
    
    public static Map<String, Object> updateUser(String userId, String userPayload) {
        String path = '/' + userId;
        path += ConnectorUtil.HttpCall.buildParam(path, 'PATCH', '_HttpMethod');

        return ConnectorUtil.HttpCall.patch(endPoint, path, userPayload);
    }
    
    public static Boolean isDebug(){
    	return SCIM_Prov_Connector__c.getOrgDefaults().Enable_Debug_Loging__c;
    }
    
    public static Map<String, Object> deleteUser(String userId) {
        String path = '/' + userId;
        return ConnectorUtil.HttpCall.del(endPoint, path);
    }

    private static String buildFilter(String offset, String reconFilter) {
        String filter = '';

        // Are we filtering?
        if (!String.isBlank(offset) || !String.isBlank(reconFilter)) {

            if (!String.isBlank(offset) && !String.isBlank(reconFilter))
                // Filtering on both offset and reconFilter
                filter += EncodingUtil.URLEncode('id gt "' + offset + '" and ' + reconFilter, 'UTF-8');
            else if (!String.isBlank(offset))
                // Only filtering on offset
                filter += EncodingUtil.URLEncode('id gt "' + offset + '"', 'UTF-8');
            else filter += 
                // Only filtering on reconFilter
                EncodingUtil.URLEncode(reconFilter, 'UTF-8');
        }

        return filter;
    }
}