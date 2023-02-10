public class ZendeskUsers {
    // Public fields to serialize / deserialize
    public Integer count;
    public String next_page;
    public String previous_page;
    public List<ZendeskUser> users;

    // Simple JSON deserialization
    public static ZendeskUsers parse(String users) {
        return (ZendeskUsers)JSON.deserialize(users, ZendeskUsers.class);
    }
}