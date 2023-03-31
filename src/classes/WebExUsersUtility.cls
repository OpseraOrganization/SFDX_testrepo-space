public with sharing class WebExUsersUtility {
    
    public static String endPoint = '';
 
    public static Map<String, Object> getAllUsers(String siteName, String startFrom) {
    	WebExCollectUsersRequest request = new WebExCollectUsersRequest();
    	if (!String.isEmpty(startFrom)) {
    		request.startFrom = Integer.valueOf(startFrom);
    	}

    	WebExSecurityContext context = createSecurityContext(siteName);
        String body = request.serialize(context);
        return ConnectorUtil.HttpCall.post(endPoint, body);
    }
    
    public static Map<String, Object> createUser(String siteName, String requestPayload) {
        return updateUser(requestPayload);
    }

    public static Map<String, Object> deleteUser(String siteName, String webExId) {
        WebExSecurityContext context = createSecurityContext(siteName);
        WebExDeleteUserRequest request = new WebExDeleteUserRequest(webExId);
        String requestPayload = request.serialize(context);
        return updateUser(requestPayload);
    }
    
    public static Map<String, Object> updateUser(String siteName, WebExUpdateUserRequest request) {
        WebExSecurityContext context = createSecurityContext(siteName);
        String requestPayload = request.serialize(context);
        return updateUser(requestPayload);
    }
    
    public static Map<String, Object> updateUser(String requestPayload) {
        return ConnectorUtil.HttpCall.post(endPoint, requestPayload);
    }

    private static WebExSecurityContext createSecurityContext(String siteName) {
    	// Merge Fields in the HTTP Body using Named Credentials in Winter '16 release
    	return new WebExSecurityContext(siteName, 
            '{!$Credential.Username}', 
            '{!$Credential.Password}');
    }

    public static Boolean isDebug(){
        return WebEx_Prov_Connector__c.getOrgDefaults().Enable_Debug_Loging__c;
    }
}