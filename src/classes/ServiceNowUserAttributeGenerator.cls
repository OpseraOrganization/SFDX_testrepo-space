global class ServiceNowUserAttributeGenerator {

    public static final String PARAM_FIRSTNAME = 'firstName';
    public static final String PARAM_LASTNAME = 'lastName';
    public static final String PARAM_EMAIL = 'email';
    public static final String PARAM_PASSWORD = 'password';

    global ServiceNowUser getMappedCreateAttributes(Process.PluginRequest request){
        String firstName = (String)request.inputParameters.get(PARAM_FIRSTNAME);
        String lastName = (String)request.inputParameters.get(PARAM_LASTNAME);
        String email = (String)request.inputParameters.get(PARAM_EMAIL);
        String password = (String)request.inputParameters.get(PARAM_PASSWORD);

        ServiceNowUser user = new ServiceNowUser();
        user.password_needs_reset = 'true';
        user.active = 'true';
        user.first_name = firstName;
        user.last_name= lastName;
        user.email = email;
        user.user_name = email;
        user.user_password = password;

        return user;
    }

    global ServiceNowUser getMappedUpdateAttributes(Process.PluginRequest request){
        String firstName = (String)request.inputParameters.get(PARAM_FIRSTNAME);
        String lastName = (String)request.inputParameters.get(PARAM_LASTNAME);
        String email = (String)request.inputParameters.get(PARAM_EMAIL);
            
        ServiceNowUser user = new ServiceNowUser();
        user.first_name = firstName;
        user.last_name = lastName;
        user.email = email;

        return user;
    }

    global String getSerializedAttributes(ServiceNowUser user){
        return user.serialize();
    }

}