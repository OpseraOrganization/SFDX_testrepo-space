global class GoogleUser {

    public class UserName {
        public String givenName;
        public String familyName;
        public String fullName;
    }

    // Public fields to serialize / deserialize
    public String id;
    public String primaryEmail;
    public UserName name;
    public String password;
    public Boolean suspended;
    public Boolean changePasswordAtNextLogin;

    // Simple JSON deserialization
    public static GoogleUser parse(String user) {
        // Replace reserved words
        // An alternative would be deserializeUntyped()
        String safeJson = user
            .replace('"id":', '"userId":');

        return (GoogleUser)System.JSON.deserialize(user, GoogleUser.class);
    }

    public String serialize() {

        // The following can be used once the SFDC platform supports the concept of serializing
        // JSON payloads without including properties with null values.
        //return JSON.serialize(user);

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        
        // String fields
        if (this.id != null) gen.writeStringField('id', this.id);
        if (this.primaryEmail != null) gen.writeStringField('primaryEmail', this.primaryEmail);
        if (this.password != null) gen.writeStringField('password', this.password);

        // Boolean fields
        if (this.suspended != null) gen.writeBooleanField('suspended', this.suspended);
        if (this.changePasswordAtNextLogin != null) gen.writeBooleanField('changePasswordAtNextLogin', this.changePasswordAtNextLogin);

        // Complex fields
        if (this.name != null) {
            gen.writeFieldName('name');
            gen.writeStartObject();
            if (this.name.fullName != null)  gen.writeStringField('fullName', this.name.fullName);
            if (this.name.familyName != null) gen.writeStringField('familyName', this.name.familyName);
            if (this.name.givenName != null) gen.writeStringField('givenName', this.name.givenName);
            gen.writeEndObject();
        }
            
        gen.writeEndObject();
        return gen.getAsString();
    }
}