trigger Update_PrimaryandSecondary_Solution on Supported_Products__c (after Update)
{
set<id> supportid= new set <id>();
list<solution> solutionlist= new list<solution>();
list<Supported_Products__c> splist = new list<Supported_Products__c >();
list<solution> updatelist= new list<solution>();
map<id,string> primarymap= new map<id,string>();
map<id,string> secondarymap= new map<id,string>();
for(Supported_Products__c s: trigger.new)
{
 if(s.Primary__c!= trigger.oldmap.get(s.id).Primary__c ||s.Secondary__c!= trigger.oldmap.get(s.id).Secondary__c)
 {
    supportid.add(s.id);
   
  }
}
if(supportid.size()>0)
{
splist=[select id,Primary__r.name,Secondary__r.name from Supported_Products__c where Id IN:supportid];
for(Supported_Products__c s: splist)
{
 primarymap.put(s.id,s.Primary__r.name);
 secondarymap.put(s.id,s.Secondary__r.name);
}
}
if(splist.size()>0)
solutionlist=[select id,Supported_Products__c from solution where Supported_Products__c IN:supportid];
for(solution  s:solutionlist)
{
  s.Primary__c=primarymap.get(s.Supported_Products__c);
  s.Secondary__c=secondarymap.get(s.Supported_Products__c);
  updatelist.add(s);
}
update updatelist;
}