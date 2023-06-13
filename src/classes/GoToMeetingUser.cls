public class GoToMeetingUser {

    // Public fields to serialize / deserialize
    public String lastName;
    public String status;
    public String email;
    public Long organizerKey;
    public String firstName;

    // Simple JSON deserialization
    public static List<GoToMeetingUser> parseUsers(String users) {
        return (List<GoToMeetingUser>)System.JSON.deserialize(users, List<GoToMeetingUser>.class);
    }

    public String serialize() {

        // The following can be used once the SFDC platform supports the concept of serializing
        // JSON payloads without including properties with null values.
        //return JSON.serialize(user);

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        
        // String fields
        if (this.lastName != null) gen.writeStringField('lastName', this.lastName);
        if (this.status != null) gen.writeStringField('status', this.status);
        if (this.email != null) gen.writeStringField('email', this.email);
        if (this.firstName != null) gen.writeStringField('firstName', this.firstName);

        // Number fields
        if (this.organizerKey != null) gen.writeNumberField('organizerKey', this.organizerKey);
            
        gen.writeEndObject();
        return gen.getAsString();
    }
}