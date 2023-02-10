public class ServiceNowUsers {

    // Public fields to serialize / deserialize
    public List<ServiceNowUser> result;

    // Simple JSON deserialization
    public static ServiceNowUsers parse(String users) {
        return (ServiceNowUsers)JSON.deserialize(users, ServiceNowUsers.class);
    }
}