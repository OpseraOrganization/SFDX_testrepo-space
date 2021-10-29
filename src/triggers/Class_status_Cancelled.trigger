trigger Class_status_Cancelled on Class__c (after update) {
List <Class__c> schlist = Trigger.new ;
List<Id> idlist = new List<ID>();

List<Reservation__c> studlist = new List <Reservation__c>();
for(integer i=0;i<schlist.size();i++)
{
if(schlist[i].Status__c=='Cancelled')
{
idlist.add(schlist[i].Id);
}
}

if(idlist.size()>0)
{
studlist = [ select name,Class__c,Reservation_Status__c,class_cancelled_by_admin__c from Reservation__c where Class_name__c in :idlist and Reservation_Status__c!='Cancel'];

}

if(studlist.size()>0)
{
for(integer i=0;i<studlist.size();i++)
{
studlist[i].Reservation_Status__c= 'Cancel';
studlist[i].class_cancelled_by_admin__c = True;
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