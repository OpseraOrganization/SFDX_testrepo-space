global class DropboxUserAttributeGenerator {

    public static final String PARAM_FIRSTNAME = 'firstName';
    public static final String PARAM_LASTNAME = 'lastName';
    public static final String PARAM_EMAIL = 'email';

    global DropboxUser.AddRequest getMappedCreateAttributes(Process.PluginRequest request){
        String firstName = (String)request.inputParameters.get(PARAM_FIRSTNAME);
        String lastName = (String)request.inputParameters.get(PARAM_LASTNAME);
        String email = (String)request.inputParameters.get(PARAM_EMAIL);

        DropboxUser.AddRequest addRequest = new DropboxUser.AddRequest(firstName, lastName, email);

        return addRequest;
    }

    global DropboxUser.SetProfileRequest getMappedUpdateAttributes(Process.PluginRequest request){
        String firstName = (String)request.inputParameters.get(PARAM_FIRSTNAME);
        String lastName = (String)request.inputParameters.get(PARAM_LASTNAME);
        String email = (String)request.inputParameters.get(PARAM_EMAIL);

        DropboxUser.SetProfileRequest setProfileRequest = new DropboxUser.SetProfileRequest(firstName, lastName, email);

        return setProfileRequest;
    }

    global String getSerializedAttributes(DropboxUser.AddRequest addRequest){
        return JSON.serialize(addRequest);
    }

    global String getSerializedAttributes(DropboxUser.SetProfileRequest setProfileRequest){
        return setProfileRequest.serialize();
    }

}