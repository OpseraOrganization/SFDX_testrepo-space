global class WebExUserAttributeGenerator {

    public static final String PARAM_FIRSTNAME = 'firstName';
    public static final String PARAM_LASTNAME = 'lastName';
    public static final String PARAM_EMAIL = 'email';
    public static final String PARAM_PASSWORD = 'password';
    public static final String PARAM_SITE_NAME = 'siteName';

    global WebExCreateUserRequest getMappedCreateAttributes(Process.PluginRequest request){
        String firstName = (String)request.inputParameters.get(PARAM_FIRSTNAME);
        String lastName = (String)request.inputParameters.get(PARAM_LASTNAME);
        String email = (String)request.inputParameters.get(PARAM_EMAIL);
        String password = (String)request.inputParameters.get(PARAM_PASSWORD);

        WebExCreateUserRequest createRequest = new WebExCreateUserRequest(firstName, lastName, email, password);

        return createRequest;
    }

    global WebExUpdateUserRequest getMappedUpdateAttributes(Process.PluginRequest request){
        String firstName = (String)request.inputParameters.get(PARAM_FIRSTNAME);
        String lastName = (String)request.inputParameters.get(PARAM_LASTNAME);
        String email = (String)request.inputParameters.get(PARAM_EMAIL);
            
        WebExUpdateUserRequest updateRequest = new WebExUpdateUserRequest();
        updateRequest.firstName = firstName;
        updateRequest.lastName = lastName;
        updateRequest.email = email;

        return updateRequest;
    }

    global String getSerializedAttributes(WebExCreateUserRequest createRequest, String siteName) {
        WebExSecurityContext context = createSecurityContext(siteName);
        return createRequest.serialize(context);
    }

    global String getSerializedAttributes(WebExUpdateUserRequest updateRequest, String siteName) {
        WebExSecurityContext context = createSecurityContext(siteName);
        return updateRequest.serialize(context);
    }

    private static WebExSecurityContext createSecurityContext(String siteName) {
        // Merge Fields in the HTTP Body using Named Credentials in Winter '16 release
        return new WebExSecurityContext(siteName, 
            '{!$Credential.Username}', 
            '{!$Credential.Password}');
    }

}