public class GoogleUsers {

    // Public fields to serialize / deserialize
    public String nextPageToken;
    public List<GoogleUser> users;

    // Simple JSON deserialization
    public static GoogleUsers parse(String users) {
        return (GoogleUsers)JSON.deserialize(users, GoogleUsers.class);
    }
}