//Commented for SRINC000005853824 as it is no longer needed by the User
global class BatchTeamRoleUpdate //implements Database.Batchable<sObject>
{
/*Map<id,list<string>> schedulemap=new Map<id,list<string>>();
set<id>uid=new set<id>();
List<User> ulist= new List<User>();
list<string> temp=new list<string>();
DateTime dt = system.now()-1;      
 
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT UserId,user.name,AccountId,CreatedDate,LastModifiedDate,TeamMemberRole FROM AccountTeamMember WHERE ((TeamMemberRole = \'Customer Service Project Manager (CSPM)\' or TeamMemberRole = \'CSPM\') and (CreatedDate >: dt or LastModifiedDate >: dt)and User.IsActive=True )';
        system.debug('query ::'+query );
        return Database.getQueryLocator(query );
    }
   
    global void execute(Database.BatchableContext BC, List<AccountTeamMember> scope)
    {
    for(AccountTeamMember am:scope){
            uid.add(am.UserId);
        }
         ulist=[SELECT Id,Name,UserName,Account_Team_Member_Role__c FROM User where (IsActive=True and Id in: uid)];
         system.debug(ulist.size());    
        for(AccountTeamMember am:scope)
        {
        if(schedulemap.containsKey(am.id))
        {
        temp=(schedulemap.get(am.id));
        temp.add(am.user.name);
        schedulemap.put(am.id,temp);
        }
         for(User u : ulist)
         {
             if(am.UserId==u.id)
             {
             u.Account_Team_Member_Role__c='Customer Service Project Manager (CSPM)';
             system.debug('PPPPPP'+u.Id);  
             system.debug('WWWWW'+u.Account_Team_Member_Role__c);      
             system.debug(ulist.size()); 
          update u; 
          }      
         }   
             
         }
         }
    global void finish(Database.BatchableContext BC)
    {
      
    }
     global void execute(SchedulableContext sc){
    
      // Below Lines Should be there to call the batchablecontext execute method
       batchteamroleupdate roleupdate = new batchteamroleupdate();
       Database.executeBatch(roleupdate );
      
    }*/
}