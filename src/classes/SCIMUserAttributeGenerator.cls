global class SCIMUserAttributeGenerator {

    public static final String PARAM_FIRSTNAME = 'firstName';
    public static final String PARAM_LASTNAME = 'lastName';
    public static final String PARAM_EMAIL = 'email';
    public static final String PARAM_USERNAME = 'username';
    public static final String PARAM_EXTERNALID = 'externalId';
    public static final String PARAM_ENTITLEMENT = 'entitlement';

    global SCIMUser getMappedAttributes(Process.PluginRequest request){
        String userName = (String)request.inputParameters.get(PARAM_USERNAME);
        String firstName = (String)request.inputParameters.get(PARAM_FIRSTNAME);
        String lastName = (String)request.inputParameters.get(PARAM_LASTNAME);
        String externalid = (String)request.inputParameters.get(PARAM_EXTERNALID);
        String email = (String)request.inputParameters.get(PARAM_EMAIL);
        String entitlement = (String)request.inputParameters.get(PARAM_ENTITLEMENT);
            
        SCIMUser user = new SCIMUser(userName, lastName, firstName, externalid, email, entitlement);

        return user;
    }

    global String getSerializedAttributes(SCIMUser user){
        return System.JSON.serialize(user, true);
    }

}