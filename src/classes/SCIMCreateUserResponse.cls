public class SCIMCreateUserResponse {

    // Public fields to serialize / deserialize
    public String id;
    public String userName;

    // Simple JSON deserialization
    public static SCIMCreateUserResponse parse(String json) {
        return (SCIMCreateUserResponse)System.JSON.deserialize(json, SCIMCreateUserResponse.class);
    }    
}