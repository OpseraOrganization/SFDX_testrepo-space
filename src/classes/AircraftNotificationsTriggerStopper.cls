public class AircraftNotificationsTriggerStopper {

    private static boolean isAlreadyExecuted = false;
    private static boolean isAlreadyExecutedPPO = false;
    private static boolean isAlreadyExecutedPFECN = false;
    private static boolean isAlreadyExecutedNavdb = false;
    private static boolean isAlreadyExecutedORdersRT = false;
    private static boolean isAlreadyExecutedDupeOppty = false;
    public static boolean hasalreadyExecuted() {
        return isAlreadyExecuted;
    }
    public static boolean hasalreadyExecutedDupeOppty() {
        return isAlreadyExecutedDupeOppty;
    }
    public static void setalreadyExecutedDupeOppty() {
        isAlreadyExecutedDupeOppty = true;
    }
    public static void setalreadyExecuted() {
        isAlreadyExecuted = true;
    }
    public static boolean hasalreadyExecutedPPO() {
        return isAlreadyExecutedPPO;
    }
   
    public static void setalreadyExecutedPPO() {
        isAlreadyExecutedPPO = true;
    }
    public static boolean hasalreadyExecutedPFECN() {
        return isAlreadyExecutedPFECN;
    }
   
    public static void setalreadyExecutedPFECN() {
        isAlreadyExecutedPFECN = true;
    }
    public static boolean hasalreadyExecutedNavdb() {
        return isAlreadyExecutedNavdb;
    }
   
    public static void setalreadyExecutedNavdb() {
        isAlreadyExecutedNavdb = true;
    }
     public static boolean hasalreadyExecutedORdersRT() {
        return isAlreadyExecutedORdersRT;
    }
   
    public static void setalreadyExecutedORdersRT() {
        isAlreadyExecutedORdersRT = true;
    }
    
    
    //added the below method unsetalreadyExecuted  for test coverage for AircraftNotifications Trigger
    public static void unsetalreadyExecuted() {
        isAlreadyExecuted = false;
    }
}