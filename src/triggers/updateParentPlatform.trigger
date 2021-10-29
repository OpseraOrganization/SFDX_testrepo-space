/*******************************************************************************
Name         : UpdateParentPlatform 
Company Name : NTT Data
Project      : SR INC000009288177
Created Date : 28 October 2015

************Added for SR INC000009288177 to update platform name in fleet assest *********************/
trigger updateParentPlatform on Fleet_Asset_Detail__c (before update) {
List<Fleet_Asset_Detail__c > fleetup= new List<Fleet_Asset_Detail__c >();
set<Id> platformset=new set<Id>();
List<Platform__c> platformlist = new List<Platform__c>();
for (Fleet_Asset_Detail__c aircft : Trigger.new)
    {
    system.debug('aircft.Platform_Name__r.id'+aircft.Platform_Name__c);
if(Trigger.isupdate && (Trigger.OldMap.get(aircft.id).Platform_Name__c!= Trigger.NewMap.get(aircft.id).Platform_Name__c)  )
{
platformset.add(aircft.Platform_Name__c);
fleetup.add(aircft);
} 
      
    }
    
if(platformset.size()>0){
platformlist=[select id,Name,Parent_Platform__c from Platform__c where id in:platformset];
if(platformlist.size()>0)
{
for(Platform__c p: platformlist)
{
for(Fleet_Asset_Detail__c flee: fleetup)
{
if(p.Parent_Platform__c != null && flee.Platform_Name__c==p.id)
flee.Platform_Parent_Name__c= p.Parent_Platform__c;

else
flee.Platform_Parent_Name__c=p.id;
}
}
}
    
   /*************Added for SR INC000009288177 to update platform name in fleet asses ends*********************/

}
}