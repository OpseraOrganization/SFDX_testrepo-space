/**
 This trigger will bypass some portion of code from triggers based upon the users/Profiles
 Defined in Data_Load_Users custom label.
* 
*/
public class AvoidTriggerExecution 
{    
    public static Boolean whitelistedUsers() 
    {
       Boolean isRunningUser = true;  
        system.debug('before delete trigger');
        String userId = UserInfo.getUserId();
        String profileId = UserInfo.getProfileId();
        System.debug('Current User id'+Userid);
        System.debug('Current User Profile id'+profileId);
        set<string> strkey = new set<string>(Label.Data_Load_Users.split(','));
        System.debug('strkey'+strkey); 
        
        if(strkey.contains(userId) || strkey.contains(profileId))
        {
          isRunningUser = false;
          System.debug('Inside of condition');
        }        
      return isRunningUser;  
    } 
}