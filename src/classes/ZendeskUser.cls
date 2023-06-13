public class ZendeskUser {
    // Public fields to serialize / deserialize
    public Long id;
    public String name;
    public String email;
    // indicates if the user has been "deleted"
    public Boolean active;
    // indicates if the user is "suspended"
    public Boolean suspended;

    // Simple JSON deserialization
    public static ZendeskUser parse(String user) {
        return (ZendeskUser)System.JSON.deserialize(user, ZendeskUser.class);
    }
}