public class TSS_PreChat_controller {
    @RemoteAction
    Public static Contact GetUserAccount() {
        user u = [select id,contactid,LastLoginDate,User.Profile.Name from user where id =:userinfo.getUserId() limit 1];
        if(!u.Profile.Name.contains('System Administrator')) {
            contact con = [select id,accountid,Account.Name,Email from contact where id =:u.contactid Limit 1];
            return con; //.Account.Name;
        }
        else {
            return null;
        }
    }
}