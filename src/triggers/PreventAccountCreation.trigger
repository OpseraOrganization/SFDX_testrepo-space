trigger PreventAccountCreation on Account (before insert){
    String profid=(UserInfo.getProfileId().substring(0,15));
    
    if(profid!=label.DeniedpartyAPIuserprofile){
        
        List<AccountTeamMember> act = new List<AccountTeamMember>();
        List<User> users = new List<User>();
        String prof = Userinfo.getProfileId();
        
        String profname = [Select name from Profile where Id=:prof].name;
        profname = profname.tolowercase();
        
        if(profname != 'master data administrator' && profname != 'accountwebform profile' &&
            profname != 'system administrator' && profname != 'honeywell system administrator' &&
            profName != 'eBiz Master Data Admin (non us)' && profName != 'honeywell system administrator (non us)' &&
            profName != 'Services Interfaces API Profile'
        )
        {
            for(Account accounts:Trigger.new){
                accounts.addError('To create a new account please contact the Aero DataMaster Team');                       
            }  
        }
    }
}