trigger updatecase_on_opportunitychange on Opportunity_Proposal__c (before update) {
  set<id> oppropids = new set<id>();
  set<id> oppids = new set<id>();
  set<id> oppids1 = new set<id>();
  set<id> ssplst = new set<id>();
  set<id> cliplst = new set<id>();
  map<id,id> mapids = new map<id,id>();
  list<Opportunity_Proposal__c> oppprop = new list<Opportunity_Proposal__c>();
  list<Opportunity_Ship_Set__c> lstoss = new list<Opportunity_Ship_Set__c>();
  list<Opportunity_Ship_Set__c> lstoss1 = new list<Opportunity_Ship_Set__c>();
  list<Opportunity_Ship_Set__c> delosslst = new list<Opportunity_Ship_Set__c>();
  list<Opportunity_Ship_Set__c> osslst = new list<Opportunity_Ship_Set__c>();
  list<case> caselst = new list<case>();
  list<case> caselst1 = new list<case>();
  list<case> caselst2 = new list<case>();
  list<Opportunity_Proposal__c> oppprop1 = new list<Opportunity_Proposal__c>();

  for(integer i=0;i<trigger.new.size();i++){
    if(trigger.new[i].Opportunity__c!=trigger.old[i].Opportunity__c){
       oppropids.add(trigger.new[i].id);
       oppprop.add(trigger.new[i]);
       if(trigger.new[i].Opportunity__c!=null)
       oppids.add(trigger.new[i].Opportunity__c);
       if(trigger.old[i].Opportunity__c!=null)
       oppids1.add(trigger.old[i].Opportunity__c);
      mapids.put(trigger.old[i].Opportunity__c,trigger.new[i].Opportunity__c);
    }
  }

  if(oppids1.size()>0)
   lstoss = [select id,Opportunity__c,Ship_Set_Product__c,Name from Opportunity_Ship_Set__c where Opportunity__c in:oppids1 and Ship_Set_Source__c = 'Case'];
 
  if(oppids1.size()>0)
   osslst = [select id,Ship_Set_Product__c,Opportunity__c from Opportunity_Ship_Set__c where Opportunity__c in:oppids];
   
    for(Opportunity_Ship_Set__c oss: osslst)
        {
          ssplst.add(oss.Ship_Set_Product__c);
        }
  if(lstoss.size()>0){
    for(Opportunity_Ship_Set__c os: lstoss){
      if(mapids.get(os.Opportunity__c)!=null && (!ssplst.contains(os.Ship_Set_Product__c))){
      Opportunity_Ship_Set__c oss = new Opportunity_Ship_Set__c();
      oss.Opportunity__c = mapids.get(os.Opportunity__c);
      oss.Ship_Set_Product__c =  os.Ship_Set_Product__c;
      oss.Ship_Set_Source__c = 'Case';
      lstoss1.add(oss);
      } 
    }
  }
  
  if(oppropids.size()>0){
    caselst = [select id,Opportunity__c,Opportunity_Proposal__c from case where Opportunity_Proposal__c in:oppropids]; 
    oppprop1 = [select id,Opportunity__r.ownerid,Opportunity__r.Opportunity_Number__c from Opportunity_Proposal__c where id in:oppropids];       
  }
   for(case c : caselst){
      for(Opportunity_Proposal__c oppro:oppprop1){
         if(c.Opportunity_Proposal__c==oppro.id){
               c.Opportunity__c = oppro.Opportunity__c;
               c.Opportunity_Owner__c = oppro.Opportunity__r.ownerid;
               c.Opportunity_Number__c = oppro.Opportunity__r.Opportunity_Number__c;               
               caselst1.add(c);
            }  
        }
    }
  if(caselst1.size()>0)
   update caselst1;

  if(oppids1.size()>0) {  
    caselst2=[select id,Opportunity__c,(select id,Product_Number__c,Case_Number__c from Case_Line_Items__r) from case where Opportunity__c in:oppids1];
  }

  if(caselst2.size()>0){     
     for(case c:caselst2){
       for(Case_Line_Item__c cli: c.Case_Line_Items__r)
        {
           cliplst.add(cli.Product_Number__c);
        } 
    }
   }
    for(Opportunity_Ship_Set__c os: lstoss){
              if(!cliplst.contains(os.Ship_Set_Product__c)) 
              delosslst.add(os);
    }

  if(lstoss1.size()>0)
   insert lstoss1;
  if(delosslst.size()>0)
   delete delosslst;

}