public with sharing class SPoG_ShowBannerInfoHelper {
    @AuraEnabled(cacheable=true)
    public static string getSessionId(){
        return UserInfo.getSessionId();
    }
}