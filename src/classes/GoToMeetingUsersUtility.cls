public class GoToMeetingUsersUtility {

    public static String endPoint = '';

    public static Map<String, Object> getAllUsers() {
        return ConnectorUtil.HttpCall.get(endPoint);
    }

    public static Map<String, Object> createUser(GoToMeetingUserRequest user) {
        String body = JSON.serialize(user);
        return ConnectorUtil.HttpCall.post(endPoint, body);
    }

    public static Map<String, Object> deleteUser(String userId) {
        String path = '/' + userId;
        return ConnectorUtil.HttpCall.del(endPoint, path);
    }

    public static Map<String, Object> updateUser(String userId, GoToMeetingUser user) {
        String path = '/' + userId;
        String body = user.serialize();
        return ConnectorUtil.HttpCall.put(endPoint, path, body);
    }
    public static Boolean isDebug(){
        return GoToMeeting_Prov_Connector__c.getOrgDefaults().Enable_Debug_Loging__c;
    }
}