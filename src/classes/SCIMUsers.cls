public class SCIMUsers {

    // Public fields to serialize / deserialize
    public Integer totalResults;
    public Integer itemsPerPage;
    public List<String> schemas;
    public List<SCIMUser> Resources;

    // Simple JSON deserialization
    public static SCIMUsers parse(String user) {
        return (SCIMUsers)JSON.deserialize(user, SCIMUsers.class);
    }    
}