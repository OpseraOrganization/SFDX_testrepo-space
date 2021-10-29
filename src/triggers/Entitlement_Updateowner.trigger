trigger Entitlement_Updateowner on Entitlement__c (before insert,before update) {
List<Entitlement__c> entitlelist = Trigger.new;
List<Entitlement__c> newelist = new List<Entitlement__c>();
List<id> idlist = new List<ID>();
List<Contract> ctlst = new List<Contract>();
for(integer i=0;i<entitlelist.size();i++)
{
idlist.add(entitlelist[i].Contract_Number__c);
}

if(idlist.size()>0)
{
ctlst = [select name,ownerid from Contract where id in :idlist];
}

for(integer i=0;i<entitlelist.size();i++)
{
for(integer k=0;k<ctlst.size();k++)
{
  if(entitlelist[i].Contract_Number__c == ctlst[k].Id)
    {
    entitlelist[i].ownerid = ctlst[k].ownerid;
    }
}
}
}