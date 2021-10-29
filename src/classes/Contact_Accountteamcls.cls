public class Contact_Accountteamcls {
  Contact con = new Contact();
  id conid;
  string accid;
  public list<AccountTeamMember>accountdetail{get;set;}
    public Contact_Accountteamcls(ApexPages.StandardController controller) 
    {
         this.con= (Contact)controller.getRecord();
         conid=con.id;
         system.debug('Contactid*****************'+conid);
        accountdetail= new list<AccountTeamMember>();
        accid=[select email from contact where id =:conid limit 1].email;
        if (accid!=null){
        system.debug('Accountid*****************'+accid);
        accountdetail=[SELECT  account.name, TeamMemberRole FROM AccountTeamMember where  user.email =:accid];
        } 
    }
}