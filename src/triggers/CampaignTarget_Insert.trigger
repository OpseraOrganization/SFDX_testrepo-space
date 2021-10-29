/** * File Name: CampaignTarget_Insert
* Description Trigger to insert or update Cmapaign Targets whenever Platform is changed on Campaign
* * @author : NTTDATA
* Modification Log =============================================================== **/
trigger CampaignTarget_Insert on Campaign (after Insert, after Update)
{
   set<id>palformid= new set<id>();
   set<id>campaignid = new set<id>();
   set<id>accid= new set<id>();
  // set<id>ctid=new set<id>();
     list<Campaign_Target__c> deletelist= new list<Campaign_Target__c>();
   list<Campaign_Target__c> updatelist= new list<Campaign_Target__c>();
   map<Id,set<Id>> pladformmap= new map<id,set<id>>();
   map<id,set<id>> contactmap = new map<id,set<id>>();
   //map<id,set<id>> existingtarget= new map<id,set<id>>();
   map<id,boolean> contactemailmap= new map<id,boolean>();
   for(Campaign c: Trigger.new)
   {
     if(c.Platform__c!=null && (trigger.isinsert || (trigger.isUpdate && trigger.oldmap.get(c.id).Platform__c !=c.Platform__c)))
     {
       palformid.add(c.Platform__c);
       campaignid.add(c.id);
     }
   }
  if(campaignid.size()>0)
   for(Campaign_Target__c c: [select Target_Contact__c,Campaign__c from Campaign_Target__c where Campaign__c IN:campaignid])
   { 
    deletelist.add(c);
     /** ctid.add(c.id);
      set<id>tempid= new set<id>();
      if(existingtarget.containskey(c.Campaign__c))
         tempid=existingtarget.get(c.Campaign__c);
      tempid.add(c.Target_Contact__c);
      existingtarget.put(c.Campaign__c,tempid);**/
   }
   if(deletelist.size()>0)
    delete deletelist;
 if(palformid.size()>0)
  for(Fleet_Asset_Detail__c  fad: [select id, Platform_Name__c,Account__c  from Fleet_Asset_Detail__c where Platform_Name__c IN: palformid])
  {
    set<id>tempid = new set<id>();
    if(fad.Account__c!= Null)
    {
        if(pladformmap.containskey(fad.Platform_Name__c))
          tempid=pladformmap.get(fad.Platform_Name__c);
         tempid.add(fad.Account__c);
         pladformmap.put(fad.Platform_Name__c,tempid);
         accid.add(fad.Account__c);
    }
  }
 system.debug('accid*****************'+accid.size()+'aaaaaaaaaaaaaaaaa'+accid);
 if(accid.size()>0)
  for(Contact c: [select id, name,AccountId,HasOptedOutOfEmail from contact where AccountId IN: accid ])
  {
     for(Id plid : pladformmap.keyset())
     {
         set<id> tempid = new set<id>();
         if(contactmap.containskey(plid))
             tempid=contactmap.get(plid);
            tempid.add(c.id);
            contactmap.put(plid,tempid);
            contactemailmap.put(c.id,c.HasOptedOutOfEmail);
        
     }
  }
  system.debug('contactmap**************************************'+contactmap);
  system.debug('contactemailmap**************************************'+contactemailmap);
  for(Campaign c: Trigger.new)
  {
 system.debug('Platform************'+c.Platform__c);
  if(contactmap.get(c.Platform__c)!=null){
    for(id conid: contactmap.get(c.Platform__c))
    {
        system.debug('conid************'+conid);
       //if((existingtarget.get(c.id)!= Null && (!existingtarget.get(c.id).contains(conid))) || (ctid.size()==0))
       {
           system.debug('inside if************');
            Campaign_Target__c ct = new Campaign_Target__c();
            ct.Campaign__c=c.id;
            ct.Target_Contact__c=conid;
            ct.Send_to_Target__c=(!contactemailmap.get(conid));
            updatelist.add(ct);
        }
    }
    }
  //  else
   //  c.adderror('Fleet Asset Aircraft is not present');
  }
    system.debug('updatelist**************************************'+updatelist);
  if(updatelist.size()>0)
     insert updatelist;
}