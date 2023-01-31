global class BoxUserAttributeGenerator {

    public static final String PARAM_FIRSTNAME = 'firstName';
    public static final String PARAM_LASTNAME = 'lastName';
    public static final String PARAM_EMAIL = 'email';

    global BoxUser getMappedAttributes(Process.PluginRequest request){
        String firstName = (String)request.inputParameters.get(PARAM_FIRSTNAME);
        String lastName = (String)request.inputParameters.get(PARAM_LASTNAME);
        String email = (String)request.inputParameters.get(PARAM_EMAIL);

        BoxUser user = new BoxUser();
        user.login = email;
        user.name = firstName + ' ' + lastName;

        return user;
    }

    global String getSerializedAttributes(BoxUser user){
        return user.serialize();
    }

}