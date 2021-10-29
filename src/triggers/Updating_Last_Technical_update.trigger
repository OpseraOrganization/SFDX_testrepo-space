trigger Updating_Last_Technical_update on SR_Status__c (after update,after insert) {
list <Service_Request__c> updatelist=New list<Service_Request__c>();
 List<SR_Status__c> srstatus = new List<SR_Status__c>();
set<Id> serviceid= New set<Id>();
 List<id> srprogressid = new List<id>();
map<id,string> srstatusmap=new map<id,string>();
for(SR_Status__c sr:Trigger.new){

if(Trigger.isInsert){
serviceid.add(sr.Service_Request__c);
}
if(Trigger.isUpdate){
if((System.Trigger.OldMap.get(sr.id).SR_Status__c != System.Trigger.NewMap.get(sr.id).SR_Status__c)||(System.Trigger.OldMap.get(sr.id).Service_Request__c != System.Trigger.NewMap.get(sr.id).Service_Request__c))
serviceid.add(sr.Service_Request__c);
}
if((trigger.IsUpdate && Trigger.newMap.get(sr.id).SR_Status__c!=Trigger.oldMap.get(sr.id).SR_Status__c) || (trigger.isinsert && sr.SR_Status__c!=Null))
     { 
         srprogressid.add(sr.Service_Request__c);
     }
}
if(srprogressid.size()>0)
    srstatus=[select id,SR_Status__c, Service_Request__c  from SR_Status__c where Service_Request__c=:srprogressid];
      
    for(SR_Status__c srst : srstatus) {       
    string temp='';
         if(srstatusmap.containskey(srst.Service_Request__c))
              temp=srstatusmap.get(srst.Service_Request__c);
              system.debug ('##### Temp1'+ temp);
         if(temp!='')
              temp=temp+','+srst.SR_Status__c;
         else
             temp=srst.SR_Status__c;
        system.debug ('##### Temp2'+ temp);  
         srstatusmap.put(srst.Service_Request__c,temp);
       }

list <Service_Request__c> servicerreq=New list<Service_Request__c>([select id,Last_Technical_Update__c,Summary_of_SR_Progress__c from Service_Request__c where id in:serviceid ]);

for(Service_Request__c srreq:servicerreq){
srreq.Last_Technical_Update__c=system.today();
srreq.Summary_of_SR_Progress__c=srstatusmap.get(srreq.id);
updatelist.add(srreq);
}
update updatelist;
}