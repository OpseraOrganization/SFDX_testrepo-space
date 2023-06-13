public class ServiceNowWrappedUser {
    // Public fields to serialize / deserialize
  public ServiceNowUser result;

  // Simple JSON deserialization
  public static ServiceNowWrappedUser parse(String user) {
      return (ServiceNowWrappedUser)System.JSON.deserialize(user, ServiceNowWrappedUser.class);
  }
}