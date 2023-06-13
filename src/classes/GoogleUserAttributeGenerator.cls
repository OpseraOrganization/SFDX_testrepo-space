global class GoogleUserAttributeGenerator {

    public static final String PARAM_FIRSTNAME = 'firstName';
    public static final String PARAM_LASTNAME = 'lastName';
    public static final String PARAM_EMAIL = 'email';
    public static final String PARAM_PASSWORD = 'password';
    public static final String PARAM_DOMAIN = 'domain';

    global GoogleUser getMappedCreateAttributes(Process.PluginRequest request){
        String firstName = (String)request.inputParameters.get(PARAM_FIRSTNAME);
        String lastName = (String)request.inputParameters.get(PARAM_LASTNAME);
        String email = (String)request.inputParameters.get(PARAM_EMAIL);
        String password = (String)request.inputParameters.get(PARAM_PASSWORD);
        String domain = (String)request.inputParameters.get(PARAM_DOMAIN);

        GoogleUser user = new GoogleUser();
        user.suspended = false;
        user.changePasswordAtNextLogin = true;
        user.name = new GoogleUser.Username();
        user.name.givenName = firstName;
        user.name.familyName = lastName;
        
        List<String> parts = email.split('@', 2);
        user.primaryEmail = parts[0] + '@' + domain;

        user.password = password;

        return user;
    }

    global GoogleUser getMappedUpdateAttributes(Process.PluginRequest request){
        String firstName = (String)request.inputParameters.get(PARAM_FIRSTNAME);
        String lastName = (String)request.inputParameters.get(PARAM_LASTNAME);

        GoogleUser user = new GoogleUser();
        user.name = new GoogleUser.Username();
        user.name.givenName = firstName;
        user.name.familyName = lastName;

        return user;
    }

    global String getSerializedAttributes(GoogleUser user){
        return user.serialize();
    }

}