/** * File Name: PlannedMeeting_UpdateAttendee
* Description Trigger to update the Planned Meeting Attendee fields when a Planned Meeting is edited. This is used internally to get the fields in the email template
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger PlannedMeeting_UpdateAttendee on Planned_Meeting__c (after update) {

//Declaring variables
List<Planned_Meeting__c> lstpm = Trigger.new;
List<Planned_Meeting_Attendee__c> pmattlist = new List<Planned_Meeting_Attendee__c>();
List<ID> idlist = new List<ID>();
List<Planned_Meeting__c> lstpm1 = new List<Planned_Meeting__c>();
List<Event__c> lsteve = new List<EVent__C>();
List<Id> lsteveid = new List<Id>();
MAP<ID,String> m1 = new MAP<ID,String>();

for(integer i=0;i<lstpm.size();i++)
{
//Condition check so that code runs only when the merge fields are updated
if(lstpm[i].Event__c != Trigger.old[i].Event__c ||lstpm[i].Meeting_Purpose__c != Trigger.old[i].Meeting_Purpose__c || lstpm[i].Location__c != Trigger.old[i].Location__c || lstpm[i].Start__c != Trigger.old[i].Start__c || lstpm[i].End__c != Trigger.old[i].End__c || lstpm[i].Send_Email_Notification__c != Trigger.old[i].Send_Email_Notification__c)
{
idlist.add(lstpm[i].id);
lstpm1.add(lstpm[i]);
}
}
//Event is a lookup.Hence direct copying of field gives SFDC Id. Hence query to fetch the name
for(integer i=0;i<lstpm1.size();i++)
{
lsteveid.add(lstpm1[i].Event__c);
}
if(lsteveid.size()>0)
lsteve= [select name from Event__c where id in :lsteveid];
for(integer i=0;i<lstpm1.size();i++)
{
for(integer k=0;k<lsteve.size();k++)
{
    if(lstpm1[i].Event__c == lsteve[k].Id)
      m1.put(lstpm1[i].Event__c,lsteve[k].name);
}
}
if(idlist.size()>0)
{
pmattlist = [select name,Meeting_Purpose__c,Location__c,Start__c,End__c,Planned_Meeting__c,Event_del__c,Send_Email_Notification__c from Planned_Meeting_Attendee__c where Planned_Meeting__c in :idlist];
}
//Updating Planned Meeting fields
for(integer i=0;i<lstpm1.size();i++)
{
for(integer j=0;j<pmattlist.size();j++)
   {
    if(pmattlist[j].Planned_Meeting__c == lstpm1[i].id)
    {
        pmattlist[j].Event_Del__c = m1.get(lstpm1[i].Event__c);
        pmattlist[j].Meeting_Purpose__c = lstpm1[i].Meeting_Purpose__c;
        pmattlist[j].Location__c = lstpm1[i].Location__c;
        pmattlist[j].Start__c = lstpm1[i].Start__c;
        pmattlist[j].End__c = lstpm1[i].End__c;
        pmattlist[j].Send_Email_Notification__c = lstpm1[i].Send_Email_Notification__c;
        if(lstpm1[i].Send_Email_Notification__c == true)
        {
        pmattlist[j].email_flag__c = true;
        }
        if(lstpm1[i].Send_Email_Notification__c == false)
        {
        pmattlist[j].email_flag__c = false;
        }
      
    }
   
   }

}
if(pmattlist.size()>0){
try{
update pmattlist;
}
catch(Exception e){
System.Debug('Error!');
}
}


}