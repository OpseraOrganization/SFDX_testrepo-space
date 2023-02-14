public class GoToMeetingShortUser {
    // Public fields to serialize / deserialize
    public String key;
    public String email;

    // Simple JSON deserialization
    public static List<GoToMeetingShortUser> parseUsers(String users) {
        return (List<GoToMeetingShortUser>)System.JSON.deserialize(users, List<GoToMeetingShortUser>.class);
    }
}