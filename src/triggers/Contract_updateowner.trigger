trigger Contract_updateowner on Contract (after update) {

List<contract> cntlst = Trigger.new;
List<Entitlement__c> newent = new List<Entitlement__c>();
List<Entitlement__c> ent = new List<Entitlement__c>();
List<id> idlst = new List<ID>();


for(integer i=0;i<cntlst.size();i++)
{
if(Trigger.old[i].ownerid != cntlst[i].ownerid)
{
idlst.add(cntlst[i].Id);
}
}
if(idlst.size()>0)
{
ent = [select name,ownerid,Contract_Number__c from Entitlement__c where Contract_Number__c in :idlst];
}

for(integer i=0;i<cntlst.size();i++)
{
for(integer k=0;k<ent.size();k++)
{

if(ent[k].Contract_Number__c == cntlst[i].Id)
    {
    ent[k].ownerid = cntlst[i].ownerid;
    newent.add(ent[k]);
    }
}
}
if(newent.size()>0)
update newent;
}