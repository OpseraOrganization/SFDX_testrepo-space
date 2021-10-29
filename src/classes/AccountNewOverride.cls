public class AccountNewOverride{
    Id userId;
    String ProfileName;
    //constructor
    public AccountNewOverride(ApexPages.StandardController controller) {
    }
    
    public PageReference AccountOverride(){
        userId = UserInfo.getUserId();
        profileName = [Select Name from Profile where Id in (Select ProfileId from user where Id=:userId)].Name;
        
        if(profileName == 'Master Data Administrator' || profileName == 'System Administrator' || profileName == 'Developer Administrator (Non US)'
         || profileName == 'eBiz Master Data Admin (Non US)' || profileName == 'CSR Contract Admin')
        {
            //PageReference pageRef = new PageReference('https://tapp0.salesforce.com/001/e?retURL=%2F001%2Fo&nooverride=1');
            string serverUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/'+ '001/e?retURL=%2F001%2Fo&nooverride=1';
            PageReference pageRef = new PageReference(serverUrl);
            return pageRef ;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Only Customer Master Data Master Team or System Admin Can Create Account')); 
            return null;
        }
    }
}