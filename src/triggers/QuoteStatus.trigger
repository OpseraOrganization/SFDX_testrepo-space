trigger QuoteStatus on Quote__c (before insert) {
     set<id> oppid=new set<id>();
     List<quote__c> obj=trigger.new;
     for(quote__c obj1:trigger.new)
     {
          system.debug('obj1.Opportunity__c********'+obj1.Opportunity__c);
         // if(obj1.Opportunity__c != null && obj1.opportunity__c != '')
         
          oppid.add(obj1.Opportunity__c);
         obj1.Name=obj1.quote_number__c+' - '+obj1.Revision_Number__c ; 
     }
     system.debug('oppid********'+oppid);
     List<quote__c> objlist=new list<quote__c>();
     List<quote__c> objlst=new list<quote__c>();
     if(oppid.size()>0)
     objlist=[select id,name,status__c from quote__c where opportunity__c=:oppid and status__c='Active'];
     if(objlist.size()>0)
     {
        for(quote__c obj2:trigger.new)
        {
         obj2.status__c='In Active';
        // objlst.add(obj2);
         }
     }
     
     //if(objlst.size()>0)
     //update objlst;
}