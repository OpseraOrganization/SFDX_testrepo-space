public class Office365Users {
    
    // Public fields to serialize / deserialize 
    public String odata_nextLink;
    public List<Office365User> value;

    // Simple JSON deserialization
    public static Office365Users parse(String users) {
        // Replace reserved words
        // An alternative would be deserializeUntyped()
        String safeJson = users
            .replace('"odata.nextLink":', '"odata_nextLink":');

        return (Office365Users)JSON.deserialize(safeJson, Office365Users.class);
    }   
}