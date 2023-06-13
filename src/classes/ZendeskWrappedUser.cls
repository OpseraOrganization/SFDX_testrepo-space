global class ZendeskWrappedUser {
    // Public fields to serialize / deserialize
    public ZendeskUser user;

    public ZendeskWrappedUser() {
        user = new ZendeskUser();
    }

    public ZendeskWrappedUser(String name, String email) {
        this();
        user.name = name;
        user.email = email;
    }

    // Simple JSON deserialization
    public static ZendeskWrappedUser parse(String user) {
        return (ZendeskWrappedUser)System.JSON.deserialize(user, ZendeskWrappedUser.class);
    }

    public String serialize() {

        // The following can be used once the SFDC platform supports the concept of serializing
        // JSON payloads without including properties with null values.
        //return JSON.serialize(user);

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();

        // Complex fields
        if (this.user != null) {
            gen.writeFieldName('user');
            gen.writeStartObject();

            // String fields
            if (this.user.name != null)  gen.writeStringField('name', this.user.name);
            if (this.user.email != null) gen.writeStringField('email', this.user.email);

            // Boolean fields
            if (this.user.active != null) gen.writeBooleanField('active', this.user.active);
            if (this.user.suspended != null) gen.writeBooleanField('suspended', this.user.suspended);
            
            gen.writeEndObject();
        }
            
        gen.writeEndObject();
        return gen.getAsString();
    }
}