global class ServiceNowUser {

    // Public fields to serialize / deserialize
    public String sys_id;
    public String email;
    public String first_name;
    public String last_name;
    public String user_name;
    public String user_password;
    public String password_needs_reset;
    // Setting active = false in SN automatically sets locked_out = true
    // However, setting active = true does not set locked_out = false in SN
    public String active;
    public String locked_out;

    // Simple JSON deserialization
    public static ServiceNowUser parse(String user) {
        return (ServiceNowUser)System.JSON.deserialize(user, ServiceNowUser.class);
    }

    public String serialize() {

        // The following can be used once the SFDC platform supports the concept of serializing
        // JSON payloads without including properties with null values.
        //return JSON.serialize(user);

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        
        // String fields
        if (this.sys_id != null) gen.writeStringField('sys_id', this.sys_id);
        if (this.email != null) gen.writeStringField('email', this.email);
        if (this.first_name != null) gen.writeStringField('first_name', this.first_name);
        if (this.last_name != null) gen.writeStringField('last_name', this.last_name);
        if (this.user_name != null) gen.writeStringField('user_name', this.user_name);
        if (this.user_password != null) gen.writeStringField('user_password', this.user_password);
        if (this.active != null) gen.writeStringField('active', this.active);
        if (this.password_needs_reset != null) gen.writeStringField('password_needs_reset', this.password_needs_reset);
        if (this.locked_out != null) gen.writeStringField('locked_out', this.locked_out);

        gen.writeEndObject();
        return gen.getAsString();
    }
}