global class Office365UserAttributeGenerator {

    public static final String PARAM_FIRSTNAME = 'firstName';
    public static final String PARAM_LASTNAME = 'lastName';
    public static final String PARAM_EMAIL = 'email';
    public static final String PARAM_PASSWORD = 'password';
    public static final String PARAM_DOMAIN = 'domain';

    global Office365User getMappedCreateAttributes(Process.PluginRequest request){
        String firstName = (String)request.inputParameters.get(PARAM_FIRSTNAME);
        String lastName = (String)request.inputParameters.get(PARAM_LASTNAME);
        String email = (String)request.inputParameters.get(PARAM_EMAIL);
        String password = (String)request.inputParameters.get(PARAM_PASSWORD);
        String domain = (String)request.inputParameters.get(PARAM_DOMAIN);

        Office365User user = new Office365User();
        user.accountEnabled = true;
        user.displayName = firstName + ' ' + lastName;
        user.givenName = firstName;
        List<String> parts = email.split('@', 2);
        user.mailNickname = parts[0];
        user.passwordProfile = new Office365User.PasswordProfile();
        user.passwordProfile.password = password;
        user.passwordProfile.forceChangePasswordNextLogin = true;
        user.surname = lastName;
        user.userPrincipalName = user.mailNickname + '@' + domain;

        return user;
    }

    global Office365User getMappedUpdateAttributes(Process.PluginRequest request){
        String firstName = (String)request.inputParameters.get(PARAM_FIRSTNAME);
        String lastName = (String)request.inputParameters.get(PARAM_LASTNAME);

        Office365User user = new Office365User();
        user.displayName = firstName + ' ' + lastName;
        user.givenName = firstName;
    	user.surname = lastName;

        return user;
    }

    global String getSerializedAttributes(Office365User user){
        return user.serialize();
    }

}