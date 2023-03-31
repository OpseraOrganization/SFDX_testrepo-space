global class Office365User {

    public class PasswordProfile {
        public String password;
        public Boolean forceChangePasswordNextLogin;
    }
    
    // Public fields to serialize / deserialize
    public String objectId;
    public Boolean accountEnabled;
    public String displayName;
    public String givenName;
    public String mailNickname;
    public PasswordProfile passwordProfile;
    public String surname;
    public String userPrincipalName;

    // Simple JSON deserialization
    public static Office365User parse(String user) {            
        return (Office365User)System.JSON.deserialize(user, Office365User.class);
    }

    public String serialize() {

        // The following can be used once the SFDC platform supports the concept of serializing
        // JSON payloads without including properties with null values.
        //return JSON.serialize(user);

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        
        // String fields
        if (this.objectId != null) gen.writeStringField('objectId', this.objectId);
        if (this.displayName != null) gen.writeStringField('displayName', this.displayName);
        if (this.givenName != null) gen.writeStringField('givenName', this.givenName);
        if (this.mailNickname != null) gen.writeStringField('mailNickname', this.mailNickname);
        if (this.surname != null) gen.writeStringField('surname', this.surname);
        if (this.userPrincipalName != null) gen.writeStringField('userPrincipalName', this.userPrincipalName);

        // Boolean fields
        if (this.accountEnabled != null) gen.writeBooleanField('accountEnabled', this.accountEnabled);

        // Complex fields
        if (this.passwordProfile != null) {
            gen.writeFieldName('passwordProfile');
            gen.writeStartObject();
            if (this.passwordProfile.password != null)  gen.writeStringField('password', this.passwordProfile.password);
            if (this.passwordProfile.forceChangePasswordNextLogin != null) gen.writeBooleanField('forceChangePasswordNextLogin', 
                this.passwordProfile.forceChangePasswordNextLogin);
            gen.writeEndObject();
        }
            
        gen.writeEndObject();
        return gen.getAsString();
    }
}