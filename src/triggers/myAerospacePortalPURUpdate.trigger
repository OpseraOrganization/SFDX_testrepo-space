trigger myAerospacePortalPURUpdate on Portal_Honeywell_ID__c (after insert) {
Set<String> purHWID=new Set<String>();
Set<String> successCount=new Set<String>();
Map<String,Portal_User_Registration__c> failureMap=new Map<String,Portal_User_Registration__c>();

for(Portal_Honeywell_ID__c localHWID:[select id,Name from Portal_Honeywell_ID__c where CreatedBy.Name='API User MyAerospace Portal' and Primary_Honeywell_ID__c=true and id in :trigger.newmap.keyset()])
{
    purHWID.add(localHWID.Name);
}

List<Portal_User_Registration__c> updatePUR=[select id,Honeywell_ID__c,Contact_Creation_in_SFDC__c,LastModifiedDate from Portal_User_Registration__c where Honeywell_ID__c=:purHWID];

for(Portal_User_Registration__c PURLoopVar:updatePUR)
{
    if(PURLoopVar.Contact_Creation_in_SFDC__c =='Y')
    {
        successCount.add(PURLoopVar.Honeywell_ID__c); 
    }
    if(!failureMap.containsKey(PURLoopVar.Honeywell_ID__c))
    {
        failureMap.put(PURLoopVar.Honeywell_ID__c,PURLoopVar);
    }
    else
    {
        if(failureMap.get(PURLoopVar.Honeywell_ID__c).lastmodifieddate < PURLoopVar.lastmodifieddate)
        {
            failureMap.put(PURLoopVar.Honeywell_ID__c,PURLoopVar);
        }
    }
}
failureMap.keySet().removeAll(successCount);
List<Portal_User_Registration__c> updatePURList=new List<Portal_User_Registration__c>();
for(Portal_User_Registration__c purloc4:failureMap.values())
{
    purloc4.Contact_Creation_in_SFDC__c='Y';
    updatePURList.add(purloc4);
}
if(updatePURList.size()>0)
{
    update updatePURList;
}
}