trigger PlannedMeeting_Opportunity_Event_Relation on Planned_Meeting_and_Opportunity__c (after insert,after update,before delete) {
List<Event_and_Opportunity__c> EventOppListinsert=New List<Event_and_Opportunity__c>();
List<Event_and_Opportunity__c> EventOppListupdate=New List<Event_and_Opportunity__c>();
List<Event_and_Opportunity__c> EventOppListdelete=New List<Event_and_Opportunity__c>();
List<Event_and_Opportunity__c> EventOppListupdate1=New List<Event_and_Opportunity__c>();
List<Event_and_Opportunity__c> EventOppListupdate2=New List<Event_and_Opportunity__c>();
List<Event_and_Opportunity__c> EventOppListdel=New List<Event_and_Opportunity__c>();
Event_and_Opportunity__c EventOppList=New Event_and_Opportunity__c();
Map<Id,Id> maptoupdate = New Map<Id,Id>();
set<Id> toupdate =New set<Id>();
set<Id> pmid =New set<Id>();
set<Id> delId=New set<Id>();
set<Id> formap=New set<Id>();
if(Trigger.Isinsert){
   for(Planned_Meeting_and_Opportunity__c opp:Trigger.New){
   if(opp.Planned_Meeting__c != null)
   pmid.add(opp.Planned_Meeting__c);
   }
  Map<Id,Planned_Meeting__c> pmmap=New Map<Id,Planned_Meeting__c>([select Event__c from Planned_Meeting__c where id in: pmid]);
     for(Planned_Meeting_and_Opportunity__c opp:Trigger.New){
      if(opp.Planned_Meeting__c!=null){
       EventOppList=New Event_and_Opportunity__c();
       EventOppList.Opportunity__c=opp.Opportunity__c;
       EventOppList.Event__c=(pmmap.get(opp.Planned_Meeting__c)).Event__c;
       EventOppListinsert.add(EventOppList);    
       }  
     }
    if(EventOppListinsert.size()!=0 ||EventOppListinsert.size()>0)
       insert EventOppListinsert; 
  }
if(Trigger.Isupdate){
  for(Planned_Meeting_and_Opportunity__c opp:Trigger.New){
    if(System.Trigger.OldMap.get(opp.id).Planned_Meeting__c != System.Trigger.NewMap.get(opp.id).Planned_Meeting__c){
        toupdate.add(opp.Opportunity__c);
        formap.add(opp.Planned_Meeting__c);
        maptoupdate.put(opp.Opportunity__c,opp.Planned_Meeting__c);
        }
     } 
     Map<Id,Planned_Meeting__c> pmmap=New Map<Id,Planned_Meeting__c>([select Event__c from Planned_Meeting__c where id in: formap]);
     system.debug('%%%%%%%%%%'+toupdate);
     system.debug('%%%%%%%%%%'+maptoupdate);
 EventOppListupdate=[select Id,Opportunity__c,Opportunity__r.Planned_Meeting__r.Event__c from Event_and_Opportunity__c where   Opportunity__c   in: toupdate]; 
 
   for(Event_and_Opportunity__c eve:EventOppListupdate){
     if(maptoupdate.get(eve.Opportunity__c)!=null){
     system.debug('@@@@@@@@'+maptoupdate.get(eve.Opportunity__c));
            eve.Event__c = (pmmap.get(maptoupdate.get(eve.Opportunity__c))).Event__c;
        EventOppListupdate1.add(eve);
       }
        else if(maptoupdate.get(eve.Opportunity__c) == null){
        system.debug('********'+maptoupdate.get(eve.Opportunity__c));
        EventOppListdelete.add(eve);
        }
      } 
 if(EventOppListdelete.size()!=0 ||EventOppListdelete.size()>0)
   delete EventOppListdelete;
 if(EventOppListupdate1.size()!=0 ||EventOppListupdate1.size()>0)
   update EventOppListupdate1;       
}
if(Trigger.Isdelete){
for(Planned_Meeting_and_Opportunity__c del:Trigger.old){
delId.add(del.Opportunity__c);
}
EventOppListdel=[select Id,Opportunity__c,Opportunity__r.Planned_Meeting__r.Event__c from Event_and_Opportunity__c where   Opportunity__c   in: delId];
if(EventOppListdel.size()>0 || EventOppListdel.size()!=0) 
delete EventOppListdel;
}
}