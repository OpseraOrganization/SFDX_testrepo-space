global class ZendeskUserAttributeGenerator {

    public static final String PARAM_FIRSTNAME = 'firstName';
    public static final String PARAM_LASTNAME = 'lastName';
    public static final String PARAM_EMAIL = 'email';

    global ZendeskWrappedUser getMappedAttributes(Process.PluginRequest request){
        String firstName = (String)request.inputParameters.get(PARAM_FIRSTNAME);
        String lastName = (String)request.inputParameters.get(PARAM_LASTNAME);
        String email = (String)request.inputParameters.get(PARAM_EMAIL);

        ZendeskWrappedUser user = new ZendeskWrappedUser();
        user.user.name = firstName + ' ' + lastName;
        user.user.email = email;

        return user;
    }

    global String getSerializedAttributes(ZendeskWrappedUser user){
        return user.serialize();
    }

}