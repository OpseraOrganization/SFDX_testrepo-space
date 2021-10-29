public class StopRecursivecall
 {
                 private static boolean Update_OnBehalfendUserStatus = false;
                 private static boolean StopREcursiveStatus = false;
      public static boolean hasUpdate_OnBehalfendUserStatus() 
                  {
        return Update_OnBehalfendUserStatus;
     }
     
      public static boolean getRecursiveStatus() 
                  {
        return StopREcursiveStatus;
     }
     
                 public static void setUpdate_OnBehalfendUserStatus() {
        Update_OnBehalfendUserStatus = true;
    }
    
      public static void updateRecursiveStatus() {
        StopREcursiveStatus= true;
    }
 }