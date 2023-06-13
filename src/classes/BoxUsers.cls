public class BoxUsers {
    
    // Public fields to serialize / deserialize 
    public Integer total_count;
    public Integer page_limit;
    public Integer offset;
    public List<String> schemas;
    public List<BoxUser> entries;

    // Simple JSON deserialization
    public static BoxUsers parse(String users) {
        // Replace reserved words
        // An alternative would be deserializeUntyped()
        String safeJson = users
            .replace('"limit":', '"page_limit":')
            .replace('"type":', '"user_type":');

        return (BoxUsers)JSON.deserialize(safeJson, BoxUsers.class);
    }   
}