public class DropboxUsers {
    
    // Public fields to serialize / deserialize
    public Boolean has_more;
    public String cursor;
    public List<DropboxUser> members;

    // Simple JSON deserialization
    public static DropboxUsers parse(String users) {            
        return (DropboxUsers)JSON.deserialize(users, DropboxUsers.class);
    }   
}