global class DropboxUser {

    // Nested classes
    public class Profile {
        public String status;
        public String surname;
        public String given_name;
        public String member_id;
        public String email;
    }

    public class Permissions {
        public Boolean is_admin;
    }
    
    // Public fields to serialize / deserialize
    public Profile profile;
    public Permissions permissions;

    public DropboxUser() {
        this.profile = new Profile();
        this.permissions = new Permissions();
    }

    // Simple JSON deserialization
    public static DropboxUser parse(String user) {            
        return (DropboxUser)System.JSON.deserialize(user, DropboxUser.class);
    }

    // API request / response classes
    global class AddRequest {
        public String member_email;
        public String member_given_name;
        public String member_surname;
        public Boolean send_welcome_email = true; // Dropbox API won't allow nulls - could be a Custom Setting

        public AddRequest(String firstName, String lastName, String emailAddress) {
            member_given_name = firstName;
            member_surname = lastName;
            member_email = emailAddress;
        }
    }

    public class RemoveRequest {
        public String member_id;
        public String transfer_dest_member_id;
        public String transfer_admin_member_id;

        public RemoveRequest(String memberId, String transferDestMemberId, String transferAdminMemberId) {
            member_id = memberId;
            transfer_dest_member_id = transferDestMemberId;
            transfer_admin_member_id = transferAdminMemberId;

            // the Dropbox API expects values, not nulls
            if (transfer_dest_member_id == null) transfer_dest_member_id = '';
            if (transfer_admin_member_id == null) transfer_admin_member_id = '';
        }
    }

    global class SetProfileRequest {
        public String member_id;
        public String external_id;
        public String new_email;
        public String new_external_id;
        public String new_given_name;
        public String new_surname;

        public SetProfileRequest() {
        }

        public SetProfileRequest(String newFirstName, String newLastName, String newEmailAddress) {
            this();
            new_given_name = newFirstName;
            new_surname = newLastName;
            new_email = newEmailAddress;
        }

        // Simple JSON deserialization
        public String serialize() {

            // The following can be used once the SFDC platform supports the concept of serializing
            // JSON payloads without including properties with null values.
            //return JSON.serialize(user);

            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            
            // String fields
            if (this.member_id != null) gen.writeStringField('member_id', this.member_id);
            if (this.external_id != null) gen.writeStringField('external_id', this.external_id);
            if (this.new_email != null) gen.writeStringField('new_email', this.new_email);
            if (this.new_external_id != null) gen.writeStringField('new_external_id', this.new_external_id);
            if (this.new_given_name != null) gen.writeStringField('new_given_name', this.new_given_name);
            if (this.new_surname != null) gen.writeStringField('new_surname', this.new_surname);
                
            gen.writeEndObject();
            return gen.getAsString();
        }
    }

}