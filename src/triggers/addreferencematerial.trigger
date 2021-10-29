trigger addreferencematerial on Related_Customer_Stories__c (after insert) {
set<id> oppid=new set<id>();
for (Related_Customer_Stories__c rt: trigger.new)
{
  oppid.add(rt.Opportunity__c);
}   
//id oppid = rt.Opportunity__c;
list<opportunity> t = [select id, Add_reference_material__c from opportunity where id =: oppid];

for (opportunity opp: t)
{
if (opp.Add_reference_material__c = true)
{
opp.Add_reference_material__c = false;
}
update opp;
}

}