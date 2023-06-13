global class ConcurUserAttributeGenerator {

    public static final String PARAM_FIRSTNAME = 'firstName';
    public static final String PARAM_LASTNAME = 'lastName';
    public static final String PARAM_EMAIL = 'email';
    public static final String PARAM_PASSWORD = 'password';

    global ConcurUser getMappedCreateAttributes(Process.PluginRequest request){
        String firstName = (String)request.inputParameters.get(PARAM_FIRSTNAME);
        String lastName = (String)request.inputParameters.get(PARAM_LASTNAME);
        String email = (String)request.inputParameters.get(PARAM_EMAIL);
        String password = (String)request.inputParameters.get(PARAM_PASSWORD);

        ConcurUser user = new ConcurUser(firstName, lastName, email, password);

        return user;
    }

    global ConcurUser getMappedUpdateAttributes(Process.PluginRequest request){
        String firstName = (String)request.inputParameters.get(PARAM_FIRSTNAME);
        String lastName = (String)request.inputParameters.get(PARAM_LASTNAME);
        String email = (String)request.inputParameters.get(PARAM_EMAIL);

        ConcurUser user = new ConcurUser(firstName, lastName, email);

        return user;
    }

    global String getSerializedAttributes(ConcurUser user){
        return user.serializeXML();
    }

}