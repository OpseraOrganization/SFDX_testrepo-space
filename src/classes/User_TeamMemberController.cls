public class User_TeamMemberController {
  user usr = new user();
  id usrid;
  public list<user>teammember{get;set;}
    public User_TeamMemberController(ApexPages.StandardController controller) 
    {
         this.usr= (User)controller.getRecord();
          usrid=usr.id;
          system.debug('userid*****************'+usrid);
          teammember= new list<user>();
          teammember=[select name,ManagerId from user where ManagerId=:usrid];
         
    }
    
   

}