trigger Class_reschedule on Class__c (after update) {

List <Class__c> schlist = Trigger.new ;
List<Id> idlist = new List<ID>();
List<Reservation__c> studlist = new List <Reservation__c>();
for(integer i=0;i<schlist.size();i++)
{
if(schlist[i].Start_Date__c != Trigger.old[i].Start_Date__c || schlist[i].End_Date__c != Trigger.old[i].End_Date__c || schlist[i].End_Time__c != Trigger.old[i].End_Time__c || schlist[i].Start_Time__c != Trigger.old[i].start_Time__c ||schlist[i].Location__c != Trigger.old[i].Location__c ||schlist[i].Course_Name__c != Trigger.old[i].Course_Name__c)
{
system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&');
idlist.add(schlist[i].Id);
}
}
if(idlist.size()>0)
{
studlist = [ select name,Class__c from Reservation__c where Class_name__c in :idlist ];
system.debug('studlist *************'+studlist);
}
if(studlist.size()>0)
{
for(integer i=0;i<studlist.size();i++)
{
system.debug('^^^^^^^^^^^^^^');
studlist[i].Rescheduled__c = True;
}
try
{
update studlist;
}
catch(Exception e)
{
system.debug('Exception^^^^^^^^^^^^^^'+e);
}
}

}