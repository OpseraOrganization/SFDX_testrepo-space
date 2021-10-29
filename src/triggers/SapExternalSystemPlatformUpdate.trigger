trigger SapExternalSystemPlatformUpdate on Platform_cross_ref__c (before insert, before Update) 
{
   set<Id> platformset=new set<Id>();
   set<Id> platformset1=new set<Id>();
   set<Id> platformset2=new set<Id>();
   list<Platform__c> platformlist=new list<Platform__c>();
   list<Platform__c> platformlist1=new list<Platform__c>();
   list<Platform__c> platformlist2=new list<Platform__c>();
   list<Platform__c> platformupdatelist = new list<Platform__c>();
   list<Platform__c> platformupdatelist1 = new list<Platform__c>();
   list<Platform__c> platformupdatelist2 = new list<Platform__c>();
   set<id> pcrids = new set<id>();
  
   for(Platform_cross_ref__c pcr: trigger.new)
   {
   pcrids.add(pcr.id);
   if(trigger.isinsert)
   {
       if(pcr.External_System_Name__c=='SAP')
       {
           platformset.add(pcr.Platform_Parent__c);
       }
   }
   
   if(trigger.isupdate )
   {
     id oldpp = trigger.oldmap.get(pcr.id).Platform_Parent__c;
      if(pcr.External_System_Name__c=='SAP' && pcr.Platform_Parent__c==oldpp)
       {
           platformset.add(pcr.Platform_Parent__c);
       }
     
      if(pcr.Platform_Parent__c!=oldpp && pcr.External_System_Name__c=='SAP' )
      {
          platformset.add(pcr.Platform_Parent__c);
          platformset2.add(oldpp) ;
      }
       
       if((pcr.External_System_Name__c!='SAP' || pcr.External_System_Name__c==null) && pcr.Platform_Parent__c==oldpp)
       {
           platformset1.add(pcr.Platform_Parent__c);
       }
       if((pcr.External_System_Name__c!='SAP' || pcr.External_System_Name__c==null) && pcr.Platform_Parent__c!=oldpp)
       {
              platformset1.add(pcr.Platform_Parent__c);
              platformset2.add(oldpp) ;
       }
    }
   }
    
  if(platformset.size()>0){
   platformlist=[select id,SAP_External_System__c from Platform__c where id in:platformset];
   if(platformlist.size()>0)
   {
       for(Platform__c p: platformlist)
       {
          p.SAP_External_System__c=true;
          platformupdatelist.add(p);
       }
   }
   }
   if(platformset1.size()>0){
     
     platformlist1=[select id,SAP_External_System__c,(select id,External_System_Name__c,Platform_Parent__r.SAP_External_System__c from Platform_cross_ref__r) from Platform__c where id in:platformset1];
              system.debug('111' +platformlist1);
     if(platformlist1.size()>0) {     
        for(Platform__c p: platformlist1)
        {
         Boolean bol=true;
         system.debug('222' +p.Platform_cross_ref__r);   
           for(Platform_cross_ref__c pcr1:p.Platform_cross_ref__r){
               if(pcr1.External_System_Name__c=='SAP'){
                   p.SAP_External_System__c=true;
                   platformupdatelist1.add(p);
                   bol = false;
                   break;
                   //update pcr1;
                }
            
            }
            if(bol){
            p.SAP_External_System__c=false;
             platformupdatelist1.add(p);
            }
       }
     }
   }
   
   if(platformset2.size()>0){
   platformlist2=[select id,SAP_External_System__c,(select id,External_System_Name__c,Platform_Parent__r.SAP_External_System__c from Platform_cross_ref__r) from Platform__c where id in:platformset2];
   
    if(platformlist2.size()>0)
   {
        for(Platform__c p: platformlist2)
       {
         Boolean bol1=true;
         system.debug('222' +p.Platform_cross_ref__r);   
           for(Platform_cross_ref__c pcr1:p.Platform_cross_ref__r){
               if(pcr1.External_System_Name__c=='SAP' && !pcrids.contains(pcr1.id)){
                   p.SAP_External_System__c=true;
                   platformupdatelist2.add(p);
                   bol1 = false;
                   break;
                }
            }
        if(bol1){
           p.SAP_External_System__c=false;
           platformupdatelist2.add(p);
        }
       } 
   }
  }
  if(platformupdatelist.size()>0)
  update platformupdatelist;
   
   if(platformupdatelist1.size()>0)
  update platformupdatelist1;
   
   if(platformupdatelist2.size()>0)
  update platformupdatelist2;
   
   
}