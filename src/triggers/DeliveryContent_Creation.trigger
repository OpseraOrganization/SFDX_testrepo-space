trigger DeliveryContent_Creation on Opportunity_Platform__c (after insert, after update) 
{
    
    set<id>oppid= new set<id>();
    map<id,string>oppmap= new map<id,string>();
    list<Opportunity> opplist = new list<Opportunity>();
    list<Opportunity> updateopplist = new list<Opportunity>();
    for(Opportunity_Platform__c  oppplatform :trigger.new)
    {
     if(oppplatform.Opportunity_Type__c=='ATR' && ((trigger.isupdate && oppplatform.Platform_Name__c!= trigger.oldmap.get(oppplatform.id).Platform_Name__c)|| trigger.isinsert))
     {
              oppid.add(oppplatform.Opportunity__c);
              string temp='';
              if(oppmap.containskey(oppplatform.Opportunity__c))
                temp=oppmap.get(oppplatform.Opportunity__c);
              if(temp!='')
                  temp=temp+','+oppplatform.Platform_Name__c;
              else
                 temp=oppplatform.Platform_Name__c;
              oppmap.put(oppplatform.Opportunity__c,temp);
     }   
    }
    if(oppmap.size()>0)
    {
       opplist= [select id,Platform_Name__c,Content_Platform_Name__c from opportunity where id IN: oppmap.keyset()];
    }
    for(opportunity opp: opplist)
    {
      if(oppmap.get(opp.id)!=null){
        system.debug('test***********'+opp.Platform_Name__c);
        system.debug('test11111111111'+oppmap.get(opp.id));
        if(opp.Content_Platform_Name__c!='' && opp.Content_Platform_Name__c!=Null)
           opp.Content_Platform_Name__c=opp.Content_Platform_Name__c+','+oppmap.get(opp.id);
         else
            opp.Content_Platform_Name__c=oppmap.get(opp.id);
          updateopplist.add(opp);
          }
       }
   if(updateopplist.size()>0)
   update updateopplist;
    

}