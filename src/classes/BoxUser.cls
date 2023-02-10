global class BoxUser {
    
    // Public fields to serialize / deserialize
    public String user_type;
    public String id;
    public String name;
    public String login;
    public String created_at; // won't serialize as Date
    public String modified_at; // won't serialize as Date
    public String language;
    public String timezone;
    public Long space_amount;
    public Long space_used;
    public Long max_upload_size;
    public String status;
    public String job_title;
    public String phone;
    public String address;
    public String avatar_url;   

    // Simple JSON deserialization
    public static BoxUser parse(String user) {
        // Replace reserved words
        // An alternative would be deserializeUntyped()
        String safeJson = user
            .replace('"type":', '"user_type":');
            
        return (BoxUser)System.JSON.deserialize(safeJson, BoxUser.class);
    }

    public String serialize() {

        // The following can be used once the SFDC platform supports the concept of serializing
        // JSON payloads without including properties with null values.
        //return JSON.serialize(user);

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        
        // String fields
        if (this.user_type != null) gen.writeStringField('type', this.user_type);
        if (this.id != null) gen.writeStringField('id', this.id);
        if (this.name != null) gen.writeStringField('name', this.name);
        if (this.login != null) gen.writeStringField('login', this.login);
        if (this.created_at != null) gen.writeStringField('created_at', this.created_at);
        if (this.modified_at != null) gen.writeStringField('modified_at', this.modified_at);
        if (this.language != null) gen.writeStringField('language', this.language);
        if (this.timezone != null) gen.writeStringField('timezone', this.timezone);
        if (this.status != null) gen.writeStringField('status', this.status);
        if (this.job_title != null) gen.writeStringField('job_title', this.job_title);
        if (this.phone != null) gen.writeStringField('phone', this.phone);
        if (this.address != null) gen.writeStringField('address', this.address);
        if (this.avatar_url != null) gen.writeStringField('avatar_url', this.avatar_url);

        // Number fields
        if (this.space_amount != null) gen.writeNumberField('space_amount', this.space_amount);
        if (this.space_used != null) gen.writeNumberField('space_used', this.space_used);
        if (this.max_upload_size != null) gen.writeNumberField('max_upload_size', this.max_upload_size);
            
        gen.writeEndObject();
        return gen.getAsString();
    }
}