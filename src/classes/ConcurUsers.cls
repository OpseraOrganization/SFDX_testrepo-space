public class ConcurUsers {

    // Public fields to serialize / deserialize
    public String nextPage;
    public List<ConcurUser> items;

    // Simple JSON deserialization
    public static ConcurUsers parse(String users) {
        return (ConcurUsers)JSON.deserialize(users, ConcurUsers.class);
    }
}