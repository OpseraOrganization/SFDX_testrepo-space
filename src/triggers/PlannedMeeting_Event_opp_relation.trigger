trigger PlannedMeeting_Event_opp_relation on Planned_Meeting__c (after update) {
set<Id> plannedID =New set<Id>();
set<Id> eventnewId=New set<Id>();
set<Id> plopID=New set<Id>();
List<Planned_Meeting_and_Opportunity__c> opportunitylist=New List<Planned_Meeting_and_Opportunity__c>();
Event_and_Opportunity__c EventOppList=New Event_and_Opportunity__c();
List<Event_and_Opportunity__c> EventOppListinsert=New List<Event_and_Opportunity__c>();
List<Event_and_Opportunity__c> EventOppListdelete=New List<Event_and_Opportunity__c>();
for(Planned_Meeting__c trg:trigger.new){
 if(System.Trigger.OldMap.get(trg.id).Event__c != System.Trigger.NewMap.get(trg.id).Event__c ){
      eventnewId.add(System.Trigger.NewMap.get(trg.id).Event__c);
      plannedID.add(trg.id);
   }
 }
 if(plannedid.size()!=0||plannedid.size()>0){
  opportunitylist=[select ID,Planned_Meeting__r.Event__c,Opportunity__c from Planned_Meeting_and_Opportunity__c where Planned_Meeting__c in: plannedID];
  }
 for(Planned_Meeting_and_Opportunity__c plopp:opportunitylist){
 if(plopp.Opportunity__c!=null)
 plopID.add(plopp.Opportunity__c);
 }
  if(plopID.size()!=0||plopID.size()>0)
  EventOppListdelete=[select ID from Event_and_Opportunity__c where   Opportunity__c   in: plopID or Event__c in:eventnewId];

 for(Planned_Meeting_and_Opportunity__c opp:opportunitylist){
   if(opp.Planned_Meeting__r.Event__c!=null){
      EventOppList=New Event_and_Opportunity__c();
      EventOppList.Opportunity__c=opp.Opportunity__c;
      EventOppList.Event__c=opp.Planned_Meeting__r.Event__c;
      EventOppListinsert.add(EventOppList);
   }
 }
 if(EventOppListdelete.size()!=0 ||EventOppListdelete.size()>0)
   delete EventOppListdelete;
 if(EventOppListinsert.size()!=0 ||EventOppListinsert.size()>0)
   insert EventOppListinsert; 
}