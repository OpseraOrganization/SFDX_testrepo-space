global class updateAccounts implements Database.Batchable<Sobject>  
{  
    global Database.QueryLocator start(Database.BatchableContext BC)  
    {  
        DateTime dt = system.now()-1;
        return Database.getQueryLocator([SELECT UserId,user.name,AccountId,CreatedDate,LastModifiedDate,TeamMemberRole FROM AccountTeamMember WHERE (TeamMemberRole = 'Customer Service Manager' and (CreatedDate >: dt or LastModifiedDate >: dt)) ]);  
    }     
    global void execute(Database.BatchableContext BC, List<AccountTeamMember> scope)
    {  
        set<id> accid = new set<id>();
        List<Account> lstAccount = new list<Account>();  
        for(AccountTeamMember am:scope){
            accid.add(am.AccountId);
        }
        if(accid.size()>0){
            List<Account> acclist = [select id, Name, Team_Member__c from Account where id IN:accid];
            Update acclist;  
        }
    }     
    global void finish(Database.BatchableContext BC){}  
}