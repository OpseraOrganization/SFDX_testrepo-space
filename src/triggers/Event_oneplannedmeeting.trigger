/** * File Name: Event_oneplannedmeeting
* Description Trigger to ensure that only one Meeting exists for a Planned Meeting
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger Event_oneplannedmeeting on Event (before insert) {

//Variable Declaration
//List<Event> newlsteve = Trigger.new;

List<Event> newlsteve = new List<Event>();
for(Event nevent : Trigger.new){
        if(nevent.recordtypeid != label.BGA_Event){
            newlsteve.add(nevent);
        }
    }

List<ID> eid = new List<ID>();
List<ID> lstid = new List<ID>();
List<Planned_Meeting__c> lspm = new List<Planned_Meeting__c>();
List<Event> e = new List<Event> ();
//Adding the Planned Meeting Ids associated to the Event to a list
for(integer i=0;i<newlsteve.size();i++)
{
lstid.add(newlsteve[i].whatid);
}
//Qeurying for the Planned Meeting
if(lstid.size()>0)
{
lspm = [select id from  Planned_Meeting__c where id in :lstid];
}
//Qerying for Events associated to the Planned Meeting
if(lspm.size()>0)
{
 e= [select id,whatid from Event where whatid in :lspm];
}
if(e.size()>0)
{
//Throwing error if Meeting already exist for the Planned Meeting
for(integer i=0;i<newlsteve.size();i++)
{
for(integer j=0;j<e.size();j++)
{
if(newlsteve[i].whatid == e[j].whatid)
{
newlsteve[i].adderror('Meeting already exist for this Planned Meeting');
}
}
}
}
}